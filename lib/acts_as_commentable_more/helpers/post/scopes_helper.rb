module ActsAsCommentableMore
  module Helpers
    module Post
      module ScopesHelper

        def post_define_all_scope
          redefine_method("all_#{aacm_commentable_options[:association_comment_name]}") do
            aacm_commentable_options[:comment_model]
            .includes(aacm_association_options[:as].to_sym, :user)
            .where(aacm_association_options[:as].to_sym => self)
            .order(created_at: :desc)
          end
        end


      end
    end
  end
end