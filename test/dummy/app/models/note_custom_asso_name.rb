class NoteCustomAssoName < ActiveRecord::Base
  acts_as_commentable types: [:private, :publish], as: :custom_notes
end
