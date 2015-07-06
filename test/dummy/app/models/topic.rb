class Topic < ActiveRecord::Base
  acts_as_commentable :custom_comments, counter_cache: true,
    options: { 
      class_name: 'CustomComment', 
      as: :custom_commentable,
      order_by: {message: :asc}
    }
end
