module ActsAsCommentableMore::Finders
  extend ActiveSupport::Concern
  
  module ClassMethods
    # Helper class method to lookup all comments assigned
    # to all commentable roles for a given user.
    def find_comments_by_user(user, role = nil)

      if comment_roles == [:comment]
        p "0"*20
        where(user: user, role: 'comment').order("created_at DESC")
      else
        if comment_roles.include?(role.to_sym)
          where(user: user, role: role.to_s).order("created_at DESC")
        else
          where(user: user).order("created_at DESC")
        end
      end
    end

    # Helper class method to look up all comments for 
    # commentable class name and commentable id.
    # def find_comments_for_commentable(commentable_str, commentable_id, role = "comments")
    #   where(["commentable_role = ? and commentable_id = ? and role = ?", commentable_str, commentable_id, role]).order("created_at DESC")
    # end

    # Helper class method to look up a commentable object
    # given the commentable class name and id 
    # def find_commentable(commentable_str, commentable_id)
    #   model = commentable_str.constantize
    #   model.respond_to?(:find_comments_for) ? model.find(commentable_id) : nil
    # end
  end
end 