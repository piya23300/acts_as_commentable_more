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
      mattr_accessor :comment_model
      mattr_accessor :comment_roles

      default_commentable_options = { types: [], options: {}, as: nil, counter_cache: true }
      default_association_options = { as: :commentable, dependent: :destroy, class_name: 'Comment' }

      commentable_options = default_commentable_options.merge(args.extract_options!)

      commentable_options[:types] = commentable_options[:types].flatten.compact.map(&:to_sym)

      association_options = default_association_options.merge(commentable_options[:options].compact)
      association_comment_name = association_comment_name.to_s
      
      self.comment_roles = commentable_options[:types].present? ? commentable_options[:types] : [association_comment_name.singularize.to_sym]
      self.comment_model = association_options[:class_name].classify.constantize

      if comment_roles.size == 1
        ###########################
        ###    basic comment    ###
        ###########################
        post_define_role_based_inflection(comment_roles.first, association_comment_name, association_options)
        post_define_create_role(association_comment_name)
      else
        ###########################
        ### many roles comment  ###
        ###########################
        # scope method for post model
        post_define_all_scope(association_comment_name, association_options[:as])
        
        comment_roles.each do |role|
          # association for post model
          association_name = "#{role.to_s}_#{association_comment_name.to_s}"
          post_define_role_based_inflection(role, association_name, association_options)
          # support method for comment model
          post_define_create_role(association_name)
          comment_define_is_role?(role)
          comment_define_to_role(role)
          comment_define_to_role!(role)
        end
        # helpper method for comment model
        comment_define_can_change_role_of(association_options[:as])
      end

      # counter cache for comment model
      enable_counter_cache = commentable_options[:counter_cache]
      comment_define_counter_cache_role(association_comment_name, association_options[:as]) if enable_counter_cache

      # instance method for comment
      comment_define_instance_method
      comment_define_class_method
    end

  end

end

