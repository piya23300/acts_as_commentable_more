class CreatePostDisableCaches < ActiveRecord::Migration
  def change
    create_table :post_disable_caches do |t|
      t.string :title

      t.integer :disable_cache_commentable_count, default: 0

      t.timestamps
    end
  end
end
