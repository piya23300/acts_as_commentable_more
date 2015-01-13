class Topic < ActiveRecord::Base
  acts_as_commentable options: { class_name: 'CustomComment', as: :customable }
end
