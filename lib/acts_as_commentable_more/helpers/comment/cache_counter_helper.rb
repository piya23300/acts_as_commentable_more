module ActsAsCommentableMore
  module Helpers
    module Comment
      module CacheCounterHelper

        private

        def comment_define_counter_cache_role(comment_model, association_comment_name, commentable_name)
          never_has_counter_cache = !comment_model._create_callbacks.select {|cb| cb.kind == :after }.collect(&:filter).include?(:acts_as_commentable_more_increment!)

          if never_has_counter_cache
            comment_model.class_eval do
              after_create :acts_as_commentable_more_increment!
              before_destroy :acts_as_commentable_more_decrement!
              after_update :acts_as_commentable_more_adjust_counter!, if: :role_changed?
            end

            comment_model.redefine_method("acts_as_commentable_more_increment!") do
              all_counter_field = "#{association_comment_name}_count"
              role_counter_field = "#{self.role}_#{all_counter_field}"
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
              all_counter_field = "#{association_comment_name}_count"
              role_counter_field = "#{self.role}_#{all_counter_field}"
              post_model = self.send("#{commentable_name}_type").classify.constantize
              attributes_post = post_model.column_names

              counter_fields = {}
              counter_fields.merge!(all_counter_field.to_sym => -1) if attributes_post.include?(all_counter_field)
              counter_fields.merge!(role_counter_field.to_sym => -1) if attributes_post.include?(role_counter_field)

              post_id = self.send("#{commentable_name}_id")
              post_model.update_counters(post_id, counter_fields) if counter_fields.present?
            end
            comment_model.send(:private, "acts_as_commentable_more_decrement!".to_sym)

            comment_model.redefine_method("acts_as_commentable_more_adjust_counter!") do
              all_counter_field = "#{association_comment_name}_count"
              old_role_counter_filed = "#{self.changes[:role][0]}_#{all_counter_field}"
              new_role_counter_filed = "#{self.changes[:role][1]}_#{all_counter_field}"
              post_model = self.send("#{commentable_name}_type").classify.constantize
              attributes_post = post_model.column_names

              counter_fields = {}
              counter_fields.merge!(old_role_counter_filed.to_sym => -1) if attributes_post.include?(old_role_counter_filed)
              counter_fields.merge!(new_role_counter_filed.to_sym => 1) if attributes_post.include?(new_role_counter_filed)

              post_id = self.send("#{commentable_name}_id")
              post_model.update_counters(post_id, counter_fields) if counter_fields.present?
            end
            comment_model.send(:private, "acts_as_commentable_more_adjust_counter!".to_sym) 
          end

          # setting attributes for read only
          post_model = self
          counter_fields = ["#{association_comment_name}_count"]
          if post_model.aacm_commentable_options[:comment_roles].size > 1
            post_model.aacm_commentable_options[:comment_roles].each do |role|
              counter_fields << "#{role}_#{association_comment_name}_count"
            end
          end
          post_model.attr_readonly(*counter_fields)
        end

      end
    end
  end
end