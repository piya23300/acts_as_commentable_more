module ActsAsCommentableMore::Finders
  extend ActiveSupport::Concern

  def related_attributes
    read_attribute(:related_attributes).symbolize_keys
  end
  
  module ClassMethods

    def find_comments_by_user(user, role = nil)
      attr_finder = { user: user }
      attr_finder.merge!(role: role.to_s) if role.present?
      where(attr_finder).order("created_at DESC")
    end
    
  end

end
