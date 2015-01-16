class NoteCustomAssoName < ActiveRecord::Base
  acts_as_commentable types: [:private, :public], as: :custom_comments
end
