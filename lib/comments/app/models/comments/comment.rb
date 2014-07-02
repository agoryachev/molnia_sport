module Comments
  class Comment < ActiveRecord::Base
    self.table_name = 'comments'
    acts_as_votable
    acts_as_nested_set scope: [:commentable_id, :commentable_type]
    attr_accessible :title,
                    :content,
                    :is_published,
                    :id_deleted,
                    :created_at,
                    :updated_at,
                    :user_id,
                    :parent_id

    # Relations
    # ================================================================
    belongs_to :user
    belongs_to :commentable, polymorphic: true, dependent: :destroy, counter_cache: true

    validates_format_of :content, without: /\.(at|b(y|e|iz)|c(a|c|h|om|n)|d(e|k)|e(du|e|s|u)|i(l|n|o|s|t)|hu|fr|md|n(ame|et|l|o)|org|pl|([-\d\*$&\%_\s]{0,3}r[-\d\*$&\%_\s]{1,3}u|[-\d\*$&\%_\s]{1,3}ru|ru)|s(e|k|t|u)|t(k|o|v)|ws|u(a|k|s))/i, message: "Не допускается размещение ссылок"
    
    def self.build_from(obj, user_id, comment)
      new do |c|
        c.commentable  = obj
        c.content      = comment
        c.user_id      = user_id
        c.is_published = (Setting.moderate_comment == 0)
      end
    end

    def move_to_parent(parent_id)
      move_to_child_of(Comment.find(parent_id))
    end

    def self.get_comments(params)
      if params['filter'].present?
        includes(user: [:main_image, :votes])
        .where(
          commentable_id: params[:id], 
          commentable_type: params[:type]
        )
        .order('cached_weighted_score desc')
      else
        includes(user: [:main_image, :votes])
        .where(
          commentable_id: params[:id], 
          commentable_type: params[:type]
        )
        .order('lft')
      end
    end

    def self.order_by(type)
      order("comments.cached_weighted_score")
    end
  end
end
