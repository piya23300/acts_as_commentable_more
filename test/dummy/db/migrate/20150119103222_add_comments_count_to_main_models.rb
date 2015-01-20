class AddCommentsCountToMainModels < ActiveRecord::Migration
  def change
    add_column :main_models, :comments_count, :integer, default: 0
  end
end
