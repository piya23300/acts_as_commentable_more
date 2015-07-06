module ActsAsCommentableMore
  module Helpers
    module Post
      module ScopesHelper

        def post_define_all_scope
          redefine_method("all_#{aacm_commentable_options[:association_comment_name]}") do
            aacm_commentable_options[:comment_model]
            .includes(aacm_association_options[:as].to_sym, :user)
            .where(aacm_association_options[:as].to_sym => self)
            .order(aacm_association_options[:order_by])
          end
        end


      end
    end
  end
end