# ActsAsCommentable
module Happio
  module Acts #:nodoc:
    module Commentable #:nodoc:
      extend ActiveSupport::Concern

      included do
        mattr_accessor :comment_roles
      end

      module HelperMethods
        private
        def define_role_based_inflection(role, association_base_name, join_options)
          association_name = "#{role.to_s}_#{association_base_name.to_s}"
          send("define_role_based_inflection_#{Rails.version.first}", role, association_name,join_options)
        end

        def define_role_based_inflection_3(role, association_name, join_options)
          has_many "#{association_name.to_s}".to_sym,
                   has_many_options(role, join_options).merge(:conditions => { role: role.to_s })
        end

        def define_role_based_inflection_4(role, association_name, join_options)
          has_many "#{association_name.to_s}".to_sym,
                   -> { where(role: role.to_s) },
                   has_many_options(role, join_options)
          define_add_role(association_name)
        end

        def has_many_options(role, join_options)
          { :before_add => Proc.new { |x, c| c.role = role.to_s } }.merge(join_options)
        end

        def define_add_role(association_name)
          class_eval %{
            def add_#{association_name.to_s.singularize}(attributes = nil)
              #{association_name.to_s}.create(attributes)
            end
          }
        end

      end

      module ClassMethods
        include HelperMethods

        def acts_as_commentable(types: [], options: {}, as: nil)
          default_options = {as: :commentable, dependent: :destroy, class_name: 'Comment'}
          default_as = :comments
          default_roles = [default_as.to_s.singularize.to_sym]

          types = types.flatten.compact.map(&:to_sym)

          association_options = default_options.merge(options.compact)
          self.comment_roles = types.present? ? types : default_roles
          association_base_name = (as || default_as).to_s.pluralize

          if comment_roles == [default_as.to_s.singularize.to_sym]
            has_many association_base_name.to_sym, has_many_options(association_base_name.singularize, association_options)
            define_add_role(association_base_name)
          else
            comment_roles.each do |role|
              define_role_based_inflection(role, association_base_name, association_options)
            end
            class_eval %{
              def all_#{association_base_name.to_s}
                #{association_options[:class_name].classify.constantize}
                .where(
                  #{association_options[:as].to_s + '_id'}: self.id,
                  #{association_options[:as].to_s + '_type'}: self.class.base_class.name
                ).order(created_at: :desc)
              end
            }
          end
          
        end
        
      end

    end
  end
end

ActiveRecord::Base.send(:include, Happio::Acts::Commentable)