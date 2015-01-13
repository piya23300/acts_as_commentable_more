class CustomComment < ActiveRecord::Base
  belongs_to :customable, polymorphic: true
  belongs_to :user, polymorphic: true

  belongs_to :post
end
