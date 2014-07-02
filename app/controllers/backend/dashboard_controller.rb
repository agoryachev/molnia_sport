# encoding: utf-8
class Backend::DashboardController < Backend::BackendController
 
  # GET /backend/
  def index
    @posts = Post.includes(:seo)
                 .where(is_deleted: false)
                 .limit(Setting.records_per_page)
                 .order("published_at DESC")
  end
   
end