class CommentableGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  include Rails::Generators::Migration

  def self.source_root
    @_acts_as_commentable_source_root ||= File.expand_path("../templates", __FILE__)
  end

  def self.next_migration_number(path)
    Time.now.utc.strftime("%Y%m%d%H%M%S")
  end

  def create_model_file
    template "comment.rb", "app/models/#{file_path}.rb"
    migration_template "create_comments.rb", "db/migrate/create_#{plural_table_name}.rb"
  end

end
