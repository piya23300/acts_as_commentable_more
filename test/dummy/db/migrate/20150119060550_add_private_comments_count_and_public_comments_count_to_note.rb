class AddPrivateCommentsCountAndPublicCommentsCountToNote < ActiveRecord::Migration
  def change
    add_column :notes, :comments_count, :integer, default: 0
  end
end
