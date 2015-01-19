class AddCounterToLetter < ActiveRecord::Migration
  def change
    add_column :letters, :custom_comments_count, :integer, default: 0
    add_column :letters, :hide_custom_comments_count, :integer, default: 0
    add_column :letters, :show_custom_comments_count, :integer, default: 0
  end
end
