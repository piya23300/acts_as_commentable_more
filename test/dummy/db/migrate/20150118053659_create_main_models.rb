class CreateMainModels < ActiveRecord::Migration
  def change
    create_table :main_models do |t|
      t.string :title
      t.string :type

      t.timestamps
    end
  end
end
