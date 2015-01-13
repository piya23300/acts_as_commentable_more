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
        def define_role_based_inflection(role, join_options)
          send("define_role_based_inflection_#{Rails.version.first}", role, join_options)
        end

        def define_role_based_inflection_3(role, options)
          has_many "#{role.to_s}_comments".to_sym,
                   has_many_options(role, join_options).merge(:conditions => { role: role.to_s })
        end

        def define_role_based_inflection_4(role, join_options)
          has_many "#{role.to_s}_comments".to_sym,
                   -> { where(role: role.to_s) },
                   has_many_options(role, join_options)
        end

        def has_many_options(role, join_options)
          { :before_add => Proc.new { |x, c| c.role = role.to_s } }.merge(join_options)
        end
      end

      module ClassMethods
        include HelperMethods

        def acts_as_commentable(types: [], options: {})
          default_options = {as: :commentable, dependent: :destroy, class_name: 'Comment'}
          default_roles = [:comment]

          association_options = default_options.merge(options.compact)
          self.comment_roles = (default_roles + types.flatten.compact.map(&:to_sym)).uniq

          if comment_roles == [:comment]
            has_many :comments, has_many_options(:comment, association_options)
          else
            comment_roles.each do |role|
              define_role_based_inflection(role, association_options)
            end
            class_eval %{
              def all_comments
                #{default_options[:class_name].classify.constantize}.where(#{default_options[:as].to_s + '_id'}: self.id).order(created_at: :desc)
              end
            }
          end
        end
        
      end

    end
  end
end

ActiveRecord::Base.send(:include, Happio::Acts::Commentable)