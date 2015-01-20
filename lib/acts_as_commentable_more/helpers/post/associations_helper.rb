module ActsAsCommentableMore
  module Helpers
    module Post
      module AssociationsHelper

        private

        def define_role_based_inflection(role, association_name, join_options)
          send("define_role_based_inflection_#{Rails.version.first}", role, association_name,join_options)
        end

        def define_role_based_inflection_3(role, association_name, join_options)
          has_many "#{association_name.to_s}".to_sym,
                   has_many_options(role, join_options).merge(:conditions => { role: role.to_s })
        end

        def define_role_based_inflection_4(role, association_name, join_options)
          has_many "#{association_name.to_s}".to_sym,
                   -> { includes(join_options[:as].to_sym, :user).where(role: role.to_s) },
                   has_many_options(role, join_options)
        end

        def has_many_options(role, join_options)
          { before_add: Proc.new { |post, comment| comment.role = role.to_s } }.merge(join_options)
        end

      end
    end
  end
end