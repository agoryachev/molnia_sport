class Api::PostsApiController < ActionController::Metal

  def index 
    page = (request.params[:page] || 1).to_i
    per_page = (request.params[:per_page] || 20).to_i
    offset = per_page * page - per_page
    posts = Post
              .is_published
              .select([:id, :title, :comments_count, :content, :is_breaknews, :is_comments_enabled, :published_at, :subtitle])
              .includes(:category, :main_image)
              .limit(per_page)
              .offset(offset)
              .map{|post| to_hash(post) }
    self.content_type = "application/json"
    self.response_body = {page: page, per_page: per_page, posts: posts}.to_json
  end

  def show
    post = Post.find(request.params[:id])
    self.content_type = "application/json"
    self.response_body = {post: to_hash(post)}.to_json
  end

private
  def to_hash(post)
    {id: post.id, title: post.title, comments_count: post.comments_count, content: post.content.html_safe, is_breaknews: post.is_breaknews, is_comments_enabled: post.is_comments_enabled, published_at: post.published_at, subtitle: post.subtitle, image: (post.main_image.present? ? post.main_image.url : nil)}
  end
end