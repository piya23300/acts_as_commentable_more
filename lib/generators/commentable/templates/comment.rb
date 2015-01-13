class <%= class_name %> < ActiveRecord::Base

  belongs_to :<%= class_name.demodulize.underscore + "able" %>, :polymorphic => true

  default_scope -> { order('created_at ASC') }

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_votable

  # NOTE: Comments belong to a user
  belongs_to :user
end