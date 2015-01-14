class <%= class_name %> < ActiveRecord::Base
  include ActsAsCommentableMore::Finders

  belongs_to :<%= class_name.demodulize.underscore + "able" %>, :polymorphic => true
  belongs_to :user, polymorphic: true

end