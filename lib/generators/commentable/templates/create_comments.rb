class <%= migration_class_name %> < ActiveRecord::Migration
  def change
    enable_extension 'hstore'

    create_table :<%= table_name %> do |t|
      # t.string :title, :limit => 50, :default => "" 
      t.text :message
      t.references :<%= class_name.demodulize.underscore + "able" %>, polymorphic: true
      t.references :user, polymorphic: true, index: true
      t.string :role, default: nil
      t.hstore :related_attributes, default: ''
      t.timestamps
    end

    add_index :<%= table_name %>, [:<%= class_name.demodulize.underscore + "able" %>_type, :<%= class_name.demodulize.underscore + "able" %>_id],
     name: :index_<%= table_name %>_on_<%= class_name.demodulize.underscore %>able_type_and_<%= class_name.demodulize.underscore %>able_id
  end
end