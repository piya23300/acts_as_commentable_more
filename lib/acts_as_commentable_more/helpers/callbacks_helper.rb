module ActsAsCommentableMore
  module Helpers
    module CallbacksHelper

      private

      def define_counter_cache_callback model, commentable_name
        commentable_reflect = model.reflect_on_all_associations(:belongs_to).select { |belongs_to| belongs_to.name == commentable_name.to_sym }.first
        enable_counter_cache = commentable_reflect.options[:counter_cache]

        never_has_counter_cache = !model._create_callbacks.select {|cb| cb.kind == :after }.collect(&:filter).include?(:commentable_increment!)

        if enable_counter_cache and never_has_counter_cache
          model.class_eval do
            after_create :commentable_increment!
            after_destroy :commentable_decrement!
          end
          model.class_eval %{
            private
            
            def commentable_increment!
              comment_table_name = self.class.table_name
              counter_field = \"\#{self.role.to_s}_\#{comment_table_name}_count\"

              attributes_post = self.send("#{commentable_name}_type").classify.constantize.column_names
              if attributes_post.include?(counter_field)
                post = self.send("#{commentable_name}")
                post.increment!(counter_field)
              end
            end

            def commentable_decrement!
              comment_table_name = self.class.table_name
              counter_field = \"\#{self.role.to_s}_\#{comment_table_name}_count\"

              attributes_post = self.send("#{commentable_name}_type").classify.constantize.column_names
              if attributes_post.include?(counter_field)
                post = self.send("#{commentable_name}")
                post.decrement!(counter_field)
              end
            end
          }
        end
      end


    end
  end
end