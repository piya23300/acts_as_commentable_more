require 'acts_as_commentable_more/helpers/associations_helper'
require 'acts_as_commentable_more/helpers/methods_helper'

module ActsAsCommentableMore
  extend ActiveSupport::Concern

  module ClassMethods
    include Helpers::AssociationsHelper
    include Helpers::MethodsHelper

    def acts_as_commentable(types: [], options: {}, as: nil)
      mattr_accessor :comment_roles

      default_options = {as: :commentable, dependent: :destroy, class_name: 'Comment'}
      default_as = :comments
      default_roles = [default_as.to_s.singularize.to_sym]

      types = types.flatten.compact.map(&:to_sym)

      association_options = default_options.merge(options.compact)
      association_base_name = (as || default_as).to_s.pluralize
      self.comment_roles = types.present? ? types : [association_base_name.to_s.singularize.to_sym]

      if comment_roles.size == 1
        define_role_based_inflection(comment_roles.first, association_base_name, association_options)
        define_create_role_comments(association_base_name)
      else
        comment_roles.each do |role|
          association_name = "#{role.to_s}_#{association_base_name.to_s}"
          define_role_based_inflection(role, association_name, association_options)
          define_create_role_comments(association_name)
        end

        association_class = association_options[:class_name].classify.constantize

        class_eval %{
          def all_#{association_base_name.to_s}
            #{association_class}
            .includes("#{association_options[:as].to_sym}",:user)
            .where(
              #{association_options[:as].to_s + '_id'}: self.id,
              #{association_options[:as].to_s + '_type'}: self.class.base_class.name
            ).order(created_at: :desc)
          end
        }

        association_class.class_eval %{
          private

          def can_change_role?(role)
            commentable_class = #{association_options[:as]}.class
            limit_role = commentable_class.comment_roles
            limit_role.include?(role.to_sym)
          end

        }

        comment_roles.each do |role|
          association_class.class_eval %{
            def is_#{role}?
              raise(NoMethodError, "undefined method 'is_" + role.to_s + "?'") unless can_change_role?("#{role.to_s}")
              role == "#{role.to_s}"
            end

            def to_#{role}
              raise(NoMethodError, "undefined method 'to_" + role.to_s + "'") unless can_change_role?("#{role.to_s}")
              self.role = "#{role.to_s}"
            end

            def to_#{role}!
              raise(NoMethodError, "undefined method 'to_" + role.to_s + "!'") unless can_change_role?("#{role.to_s}")
              self.role = "#{role.to_s}"
              self.save
            end

          }
        end
      end
    end

  end

end

