class CreatePostNotCounterFields < ActiveRecord::Migration
  def change
    create_table :post_not_counter_fields do |t|
      t.string :title

      t.timestamps
    end
  end
end
