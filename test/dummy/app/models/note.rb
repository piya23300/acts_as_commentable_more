class Note < ActiveRecord::Base
  acts_as_commentable :comments, types: [:private, :public], options: { order_by: {message: :asc} }
end
