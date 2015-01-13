# ActsAsCommentable
module Happio
  module Acts #:nodoc:
    module Commentable #:nodoc:
      extend ActiveSupport::Concern

      included do
        mattr_accessor :comment_types
      end

      module HelperMethods
        private
        def define_type_based_inflection(type, join_options)
          send("define_type_based_inflection_#{Rails.version.first}", type, join_options)
        end

        def define_type_based_inflection_3(type, options)
          has_many "#{type.to_s}_comments".to_sym,
                   has_many_options(type, join_options).merge(:conditions => { type: type.to_s })
        end

        def define_type_based_inflection_4(type, join_options)
          has_many "#{type.to_s}_comments".to_sym,
                   -> { where(type: type.to_s) },
                   has_many_options(type, join_options)
        end

        def has_many_options(type, join_options)
          { :before_add => Proc.new { |x, c| c.type = type.to_s } }.merge(join_options)
        end
      end

      module ClassMethods
        include HelperMethods

        def acts_as_commentable(types: [], options: {})
          default_options = {as: :commentable, dependent: :destroy, class_name: 'Comment'}
          default_types = [:comments]

          association_options = default_options.merge(options.compact)
          self.comment_types = (default_types + types.flatten.compact.map(&:to_sym)).uniq

          if comment_types == [:comments]
            has_many :comments, association_options
          else
            comment_types.each do |type|
              define_type_based_inflection(type, association_options)
            end
            has_many :all_comments, association_options
          end
        end
        
      end

    end
  end
end

ActiveRecord::Base.send(:include, Happio::Acts::Commentable)