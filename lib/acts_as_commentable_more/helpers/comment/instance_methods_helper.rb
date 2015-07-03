module ActsAsCommentableMore
  module Helpers
    module Comment
      module InstanceMethodsHelper

        private

        def comment_define_instance_method(comment_model)

          comment_model.class_eval do
          
            redefine_method :related_attributes= do |value|
              previous_data = @related_attributes || {} 
              @related_attributes = previous_data.merge(value)
              write_attribute(:related_attributes, @related_attributes)
            end
          
            redefine_method :related_attributes do
              read_attribute(:related_attributes).symbolize_keys
            end
          
          end

        end

        def comment_define_class_method(comment_model)
          
          comment_model.class_eval do

            class << self

              def find_comments_by_user(user, role = nil)
                attr_finder = { user: user }
                attr_finder.merge!(role: role) if role.present?
                where(attr_finder).order(created_at: :desc)
              end

            end
          end

        end

        def comment_define_can_change_role_of(comment_model, commentable_name)
          comment_model.redefine_method("can_change_role?") do |role|
            commentable_class = send(commentable_name).class
            limit_role = commentable_class.aacm_commentable_options[:comment_roles]
            limit_role.include?(role)
          end
          comment_model.send(:private, "can_change_role?".to_sym)
        end

        def comment_define_is_role?(comment_model, role)
          comment_model.redefine_method("is_#{role}?") do
            raise(NoMethodError, "undefined method 'is_" + role + "?'") unless can_change_role?(role)
            self.role == role
          end
        end

        def comment_define_to_role(comment_model, role)
          comment_model.redefine_method("to_#{role}") do
            raise(NoMethodError, "undefined method 'is_" + role + "?'") unless can_change_role?(role)
            self.role = role
            self
          end
        end

        def comment_define_to_role!(comment_model, role)
          comment_model.redefine_method("to_#{role}!") do
            raise(NoMethodError, "undefined method 'is_" + role + "?'") unless can_change_role?(role)
            self.update(role: role)
            self
          end
        end


      end
    end
  end
end