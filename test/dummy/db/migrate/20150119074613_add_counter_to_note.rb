class AddCounterToNote < ActiveRecord::Migration
  def change
    add_column :notes, :comments_count, :integer, default: 0
    add_column :notes, :private_comments_count, :integer, default: 0
    add_column :notes, :public_comments_count, :integer, default: 0
  end
end
