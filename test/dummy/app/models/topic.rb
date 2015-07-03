class Topic < ActiveRecord::Base
  acts_as_commentable :custom_comments, options: { class_name: 'CustomComment', as: :custom_commentable }, counter_cache: true
end
