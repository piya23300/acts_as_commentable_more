
class <%= class_name %> < ActiveRecord::Base
  ###################################################################
  ### To implement commentable add the following line to your model
  ### acts_as_commentable types: [:hide, :show], options: { class_name: '<%= class_name %>', as: :<%= class_name.demodulize.underscore + "able" %> }
  
  ### types is an array of possible comment type
  ### for example if you have public and private comment
  ### your types would be [:public, :private]

  include ActsAsCommentableMore::Finders

  belongs_to :<%= class_name.demodulize.underscore + "able" %>, :polymorphic => true
  belongs_to :user, polymorphic: true

  ###################################################################
end