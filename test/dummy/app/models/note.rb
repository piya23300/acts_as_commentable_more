class Note < ActiveRecord::Base
  acts_as_commentable types: [:private, :publish]
end