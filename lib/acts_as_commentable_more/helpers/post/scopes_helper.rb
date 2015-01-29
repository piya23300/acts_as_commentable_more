module ActsAsCommentableMore
  module Helpers
    module Post
      module ScopesHelper

        def post_define_all_scope comment_name, commentable
          redefine_method("all_#{comment_name.to_s}") do
            comment_model
            .includes(commentable.to_sym, :user)
            .where(commentable.to_sym => self)
            .order(created_at: :desc)
          end
        end


      end
    end
  end
end