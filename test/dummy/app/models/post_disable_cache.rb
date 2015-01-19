class PostDisableCache < ActiveRecord::Base
  acts_as_commentable options: { class_name: 'DisableCacheComment', as: :disable_cache_commentable }
end
