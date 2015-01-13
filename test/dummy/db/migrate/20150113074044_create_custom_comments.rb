class CreateCustomComments < ActiveRecord::Migration
  def change
    create_table :custom_comments do |t|
      t.string :message
      t.references :customable, polymorphic: true, index: true
      t.references :user, polymorphic: true, index: true
      t.string :type
      t.timestamps
    end
  end
end
