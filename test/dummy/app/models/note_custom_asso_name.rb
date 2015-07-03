class NoteCustomAssoName < ActiveRecord::Base
  acts_as_commentable :custom_comments, types: [:private, :public]
end
