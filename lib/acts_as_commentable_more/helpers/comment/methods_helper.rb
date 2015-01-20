module ActsAsCommentableMore
  module Helpers
    module Comment
      module MethodsHelper

        private

        def define_can_change_role_of(commentable_name)
          comment_model.redefine_method("can_change_role?") do |role|
            commentable_class = send(commentable_name).class
            limit_role = commentable_class.comment_roles
            limit_role.include?(role.to_sym)
          end
          comment_model.send(:private, "can_change_role?".to_sym)
        end

        def define_is_role?(role)
          comment_model.redefine_method("is_#{role}?") do
            raise(NoMethodError, "undefined method 'is_" + role.to_s + "?'") unless can_change_role?(role.to_s)
            self.role == role.to_s
          end
        end

        def define_to_role(role)
          comment_model.redefine_method("to_#{role}") do
            raise(NoMethodError, "undefined method 'is_" + role.to_s + "?'") unless can_change_role?(role.to_s)
            self.role = role.to_s
            self
          end
        end

        def define_to_role!(role)
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