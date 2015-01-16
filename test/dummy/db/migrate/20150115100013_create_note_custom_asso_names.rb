class CreateNoteCustomAssoNames < ActiveRecord::Migration
  def change
    create_table :note_custom_asso_names do |t|
      t.string :title

      t.timestamps
    end
  end
end
