class AddCommentsCountToNoteCustomAssoNames < ActiveRecord::Migration
  def change
    add_column :note_custom_asso_names, :comments_count, :integer, default: 0
  end
end
