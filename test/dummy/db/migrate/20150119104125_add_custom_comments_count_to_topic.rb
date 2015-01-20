class AddCustomCommentsCountToTopic < ActiveRecord::Migration
  def change
    add_column :topics, :custom_comments_count, :integer, default: 0
  end
end
