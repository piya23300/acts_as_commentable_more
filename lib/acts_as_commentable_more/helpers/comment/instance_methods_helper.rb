module ActsAsCommentableMore
  module Helpers
    module Comment
      module InstanceMethodsHelper

        private

        def comment_define_instance_method

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

        def comment_define_class_method
          
          comment_model.class_eval do

            class << self

              def find_comments_by_user(user, role = nil)
                attr_finder = { user: user }
                attr_finder.merge!(role: role.to_s) if role.present?
                where(attr_finder).order(created_at: :desc)
              end

            end
          end

        end

        def comment_define_can_change_role_of(commentable_name)
          comment_model.redefine_method("can_change_role?") do |role|
            commentable_class = send(commentable_name).class
            limit_role = commentable_class.comment_roles
            limit_role.include?(role.to_sym)
          end
          comment_model.send(:private, "can_change_role?".to_sym)
        end

        def comment_define_is_role?(role)
          comment_model.redefine_method("is_#{role}?") do
            raise(NoMethodError, "undefined method 'is_" + role.to_s + "?'") unless can_change_role?(role.to_s)
            self.role == role.to_s
          end
        end

        def comment_define_to_role(role)
          comment_model.redefine_method("to_#{role}") do
            raise(NoMethodError, "undefined method 'is_" + role.to_s + "?'") unless can_change_role?(role.to_s)
            self.role = role.to_s
            self
          end
        end

        def comment_define_to_role!(role)
          comment_model.redefine_method("to_#{role}!") do
            raise(NoMethodError, "undefined method 'is_" + role.to_s + "?'") unless can_change_role?(role.to_s)
            self.update(role: role.to_s)
            self
          end
        end


      end
    end
  end
end