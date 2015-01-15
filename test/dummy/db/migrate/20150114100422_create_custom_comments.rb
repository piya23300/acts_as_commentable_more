class CreateCustomComments < ActiveRecord::Migration
  def change
    enable_extension 'hstore'

    create_table :custom_comments do |t|
      # t.string :title, :limit => 50, :default => "" 
      t.text :message
      t.references :custom_commentable, polymorphic: true
      t.references :user, polymorphic: true, index: true
      t.string :role, default: nil
      t.hstore :related_attributes
      t.timestamps
    end

    add_index :custom_comments, [:custom_commentable_type, :custom_commentable_id],
     name: :index_custom_comments_on_commentable_type_and_commentable_id
  end
end