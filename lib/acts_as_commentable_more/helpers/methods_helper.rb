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
     
    end
  end
end