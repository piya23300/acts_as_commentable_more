class PostDisableCache < ActiveRecord::Base
  acts_as_commentable :disable_cache_comments, options: { class_name: 'DisableCacheComment', as: :disable_cache_commentable }, counter_cache: false
end
