class CreateDisableCacheComments < ActiveRecord::Migration
  def change
    enable_extension 'hstore'

    create_table :disable_cache_comments do |t|
      # t.string :title, :limit => 50, :default => "" 
      t.text :message
      t.references :disable_cache_commentable, polymorphic: true
      t.references :user, polymorphic: true, index: true
      t.string :role, default: nil
      t.hstore :related_attributes
      t.timestamps
    end

    add_index :disable_cache_comments, [:disable_cache_commentable_type, :disable_cache_commentable_id],
     name: :index_disable_cache_on_commentable_type_and_commentable_id
  end
end