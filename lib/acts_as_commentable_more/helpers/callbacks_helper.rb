module ActsAsCommentableMore
  module Helpers
    module CallbacksHelper

      private

      def define_counter_cache_role_comment_callback model, commentable_name
        commentable_reflect = model.reflect_on_all_associations(:belongs_to).select { |belongs_to| belongs_to.name == commentable_name.to_sym }.first
        enable_counter_cache = commentable_reflect.options[:counter_cache]

        never_has_counter_cache = !model._create_callbacks.select {|cb| cb.kind == :after }.collect(&:filter).include?(:commentable_increment!)

        if enable_counter_cache and never_has_counter_cache
          model.class_eval do
            after_create :commentable_increment!
            before_destroy :commentable_decrement!
          end
          model.class_eval %{
            private
            
            def commentable_increment!
              comment_table_name = self.class.table_name
              counter_field = \"\#{self.role.to_s}_\#{comment_table_name}_count\"
              post_model = self.send("#{commentable_name}_type").classify.constantize

              attributes_post = post_model.column_names
              if attributes_post.include?(counter_field)
                post_id = self.send("#{commentable_name}_id")
                post_model.increment_counter(counter_field.to_sym, post_id)
              end
            end

            def commentable_decrement!
              comment_table_name = self.class.table_name
              counter_field = \"\#{self.role.to_s}_\#{comment_table_name}_count\"
              post_model = self.send("#{commentable_name}_type").classify.constantize

              attributes_post = post_model.column_names
              if attributes_post.include?(counter_field)
                post_id = self.send("#{commentable_name}_id")
                post_model.decrement_counter(counter_field.to_sym, post_id)
              end
            end
          }
        end
      end


    end
  end
end