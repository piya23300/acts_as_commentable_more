
class Comment < ActiveRecord::Base
  ###################################################################
  ### To implement commentable add the following line to your model
  ### acts_as_commentable types: [:hide, :show], options: { class_name: 'Comment', as: :commentable }
  
  ### types is an array of possible comment type
  ### for example if you have public and private comment
  ### your types would be [:public, :private]

  include ActsAsCommentableMore::Finders

  belongs_to :commentable, :polymorphic => true
  belongs_to :user, polymorphic: true

  ###################################################################
end