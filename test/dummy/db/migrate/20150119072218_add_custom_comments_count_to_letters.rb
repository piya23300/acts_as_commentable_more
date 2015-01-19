class AddCustomCommentsCountToLetters < ActiveRecord::Migration
  def change
    add_column :letters, :custom_comments_count, :integer, default: 0
  end
end
