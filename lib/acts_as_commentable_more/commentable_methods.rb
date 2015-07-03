Dir[File.dirname(__FILE__) + "/helpers/**/*.rb"].each {|file| require_relative file }

module ActsAsCommentableMore
  extend ActiveSupport::Concern

  module ClassMethods
    include Helpers::Post::AssociationsHelper
    include Helpers::Post::MethodsHelper
    include Helpers::Post::ScopesHelper
    include Helpers::Comment::CacheCounterHelper
    include Helpers::Comment::InstanceMethodsHelper

    def acts_as_commentable(association_comment_name, *args)#types: [], options: {}, as: nil, counter_cache: true)
      mattr_accessor :aacm_commentable_options
      mattr_accessor :aacm_association_options

      default_commentable_options = { types: [], options: {}, as: nil, counter_cache: true }
      default_association_options = { as: :commentable, dependent: :destroy, class_name: 'Comment' }

      self.aacm_commentable_options = default_commentable_options.merge(args.extract_options!)
      self.aacm_association_options = default_association_options.merge(aacm_commentable_options[:options].compact)

      self.aacm_commentable_options[:association_comment_name] = association_comment_name.to_s
      self.aacm_commentable_options[:types] = aacm_commentable_options[:types].flatten.compact
      self.aacm_commentable_options[:comment_model] = aacm_association_options[:class_name].classify.constantize
      self.aacm_commentable_options[:comment_roles] = if aacm_commentable_options[:types].present?
                                                        aacm_commentable_options[:types]
                                                      else
                                                        [aacm_commentable_options[:association_comment_name].singularize]
                                                      end.map(&:to_s)

      if aacm_commentable_options[:comment_roles].size == 1
        ###########################
        ###    basic comment    ###
        ###########################
        post_define_role_based_inflection(aacm_commentable_options[:comment_roles].first, aacm_commentable_options[:association_comment_name])
        post_define_create_role(aacm_commentable_options[:association_comment_name])
      else
        ###########################
        ### many roles comment  ###
        ###########################
        # scope method for post model
        post_define_all_scope
        
        aacm_commentable_options[:comment_roles].each do |role|
          # association for post model
          association_name = "#{role}_#{aacm_commentable_options[:association_comment_name]}"
          post_define_role_based_inflection(role, association_name)
          # support method for comment model
          post_define_create_role(association_name)
          comment_define_is_role?(aacm_commentable_options[:comment_model], role)
          comment_define_to_role(aacm_commentable_options[:comment_model], role)
          comment_define_to_role!(aacm_commentable_options[:comment_model], role)
        end
        # helpper method for comment model
        comment_define_can_change_role_of(aacm_commentable_options[:comment_model], aacm_association_options[:as])
      end

      # counter cache for comment model
      if aacm_commentable_options[:counter_cache]
        comment_define_counter_cache_role(aacm_commentable_options[:comment_model], aacm_commentable_options[:association_comment_name], aacm_association_options[:as])
      end
      # instance method for comment
      comment_define_instance_method(aacm_commentable_options[:comment_model])
      comment_define_class_method(aacm_commentable_options[:comment_model])
    end

  end

end

