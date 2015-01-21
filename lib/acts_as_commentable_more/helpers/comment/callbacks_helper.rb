module ActsAsCommentableMore
  module Helpers
    module Comment
      module CallbacksHelper

        private

        def define_counter_cache_role_comment_callback commentable_name
          never_has_counter_cache = !comment_model._create_callbacks.select {|cb| cb.kind == :after }.collect(&:filter).include?(:acts_as_commentable_more_increment!)

          if never_has_counter_cache
            comment_model.class_eval do
              after_create :acts_as_commentable_more_increment!
              before_destroy :acts_as_commentable_more_decrement!
            end

            comment_model.redefine_method("acts_as_commentable_more_increment!") do
              comment_table_name = self.class.table_name
              all_counter_field = "#{comment_table_name}_count"
              role_counter_field = "#{self.role.to_s}_#{all_counter_field}"
              post_model = self.send("#{commentable_name}_type").classify.constantize
              attributes_post = post_model.column_names

              counter_fields = {}
              counter_fields.merge!(all_counter_field.to_sym => 1) if attributes_post.include?(all_counter_field)
              counter_fields.merge!(role_counter_field.to_sym => 1) if attributes_post.include?(role_counter_field)

              post_id = self.send("#{commentable_name}_id")
              post_model.update_counters(post_id, counter_fields) if counter_fields.present?
            end
            comment_model.send(:private, "acts_as_commentable_more_increment!".to_sym)

            comment_model.redefine_method("acts_as_commentable_more_decrement!") do
              comment_table_name = self.class.table_name
              all_counter_field = "#{comment_table_name}_count"
              role_counter_field = "#{self.role.to_s}_#{all_counter_field}"
              post_model = self.send("#{commentable_name}_type").classify.constantize
              attributes_post = post_model.column_names

              counter_fields = {}
              counter_fields.merge!(all_counter_field.to_sym => -1) if attributes_post.include?(all_counter_field)
              counter_fields.merge!(role_counter_field.to_sym => -1) if attributes_post.include?(role_counter_field)

              post_id = self.send("#{commentable_name}_id")
              post_model.update_counters(post_id, counter_fields) if counter_fields.present?
            end
            comment_model.send(:private, "acts_as_commentable_more_decrement!".to_sym) 
          end

          # setting attributes for read only
          post_model = self
          counter_fields = post_model.column_names.select { |column| column =~ /.*(_count)$/ }
          post_model.attr_readonly(*counter_fields)
        end

      end
    end
  end
end