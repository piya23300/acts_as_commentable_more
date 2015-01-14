class Letter < ActiveRecord::Base
  acts_as_commentable types: [:hide, :show], options: { class_name: 'CustomComment', as: :customable }
end
