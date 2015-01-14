class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :message
      t.references :commentable, polymorphic: true, index: true
      t.references :user, polymorphic: true, index: true
      t.string :role
      t.timestamps
    end
  end
end
