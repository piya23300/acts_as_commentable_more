class AddCommentsCountToPostCustomAssoNames < ActiveRecord::Migration
  def change
    add_column :post_custom_asso_names, :comments_count, :integer, default: 0
  end
end
