class CreateComments < ActiveRecord::Migration
  def change
    enable_extension 'hstore'

    create_table :comments do |t|
      # t.string :title, :limit => 50, :default => "" 
      t.text :message
      t.references :commentable, polymorphic: true
      t.references :user, polymorphic: true, index: true
      t.string :role, default: nil
      t.hstore :related_attributes
      t.timestamps
    end

    add_index :comments, [:commentable_type, :commentable_id],
     name: :index_comments_on_commentable_type_and_commentable_id
  end
end