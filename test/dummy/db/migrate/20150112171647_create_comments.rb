class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :massage
      t.references :commentable, polymorphic: true, index: true
      t.references :user, polymorphic: true, index: true
      t.timestamps
    end
  end
end
