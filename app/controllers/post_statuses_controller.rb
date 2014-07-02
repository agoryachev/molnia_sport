class PostStatusesController < ContentController
  skip_before_filter :get_main_news, only: :top

  # GET /tag/:tag(.:format)
  def index
    params[:cyrillic_post_status] = get_cyrillic_post_status(params[:post_status])
    status = PostStatus.select(:id).find_by_title(params[:cyrillic_post_status])
    @posts = init_default_posts.where(post_status_id: status.id)
    @posts = paginate(@posts)
    @last_five_posts = last_five_posts(init_default_posts)

    if request.xhr?
      return render 'home/posts_status', layout: false
    else
      render 'home/posts_status'
    end
  end
end
