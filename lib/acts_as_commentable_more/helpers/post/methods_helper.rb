module ActsAsCommentableMore
  module Helpers
    module Post
      module MethodsHelper

        private

        def define_create_role_comments(association_comment_name)
          redefine_method("creates_#{association_comment_name.to_s.pluralize}") do |attributes = nil|
            send(association_comment_name).create(attributes)
          end
        end


      end
    end
  end
end