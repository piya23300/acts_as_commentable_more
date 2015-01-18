module ActsAsCommentableMore
  module Helpers
    module MethodsHelper

      private

      def define_create_role_comments(association_name)
        class_eval %{
          def creates_#{association_name.to_s.pluralize}(attributes = nil)
            #{association_name.to_s}.create(attributes)
          end
        }
      end

      def define_is_role?(role)
        %{
          def is_#{role}?
            raise(NoMethodError, "undefined method 'is_" + role.to_s + "?'") unless can_change_role?("#{role.to_s}")
            role == "#{role.to_s}"
          end
        }
      end

      def define_to_role(role)
        %{
          def to_#{role}
            raise(NoMethodError, "undefined method 'to_" + role.to_s + "'") unless can_change_role?("#{role.to_s}")
            self.role = "#{role.to_s}"
            self
          end
        }
      end

      def define_to_role!(role)
        %{
          def to_#{role}!
            raise(NoMethodError, "undefined method 'to_" + role.to_s + "!'") unless can_change_role?("#{role.to_s}")
            self.update(role: "#{role.to_s}")
            self
          end
        }
      end

    end
  end
end