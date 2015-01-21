Dir[File.dirname(__FILE__) + "/helpers/**/*.rb"].each {|file| require file }

module ActsAsCommentableMore
  extend ActiveSupport::Concern

  module ClassMethods
    include Helpers::Post::AssociationsHelper
    include Helpers::Post::MethodsHelper
    include Helpers::Post::ScopesHelper
    include Helpers::Comment::CallbacksHelper
    include Helpers::Comment::MethodsHelper

    def acts_as_commentable(types: [], options: {}, as: nil, counter_cache: true)
      mattr_accessor :comment_model
      mattr_accessor :comment_roles

      default_options = {as: :commentable, dependent: :destroy, class_name: 'Comment'}

      types = types.flatten.compact.map(&:to_sym)

      association_options = default_options.merge(options.compact)
      association_comment_name = (as || association_options[:class_name].demodulize.underscore.to_sym).to_s.pluralize
      self.comment_roles = types.present? ? types : [association_comment_name.singularize.to_sym]
      self.comment_model = association_options[:class_name].classify.constantize
      enable_counter_cache = counter_cache

      if comment_roles.size == 1
        ###########################
        ###    basic comment    ###
        ###########################
        define_role_based_inflection(comment_roles.first, association_comment_name, association_options)
        define_create_role_comments(association_comment_name)
      else
        ###########################
        ### many roles comment  ###
        ###########################
        # scope method for post model
        define_all_comments_scope(association_comment_name, association_options[:as])
        
        comment_roles.each do |role|
          # association for post model
          association_name = "#{role.to_s}_#{association_comment_name.to_s}"
          define_role_based_inflection(role, association_name, association_options)
          # support method for comment model
          define_create_role_comments(association_name)
          define_is_role?(role)
          define_to_role(role)
          define_to_role!(role)
        end
        # helpper method for comment model
        define_can_change_role_of(association_options[:as])
      end

       # counter cache for comment model
      define_counter_cache_role_comment_callback(association_comment_name, association_options[:as]) if enable_counter_cache

    end

  end

end

