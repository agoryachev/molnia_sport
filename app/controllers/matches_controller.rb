class MatchesController < ContentController
  before_filter :set_last_posts, on: :show

  def show
    @match = Match.find(params[:id])
    @events_count = Event.where(type: 'Event::Goal').size
    @broadcast_messages = @match.broadcast_messages.includes(event: [:team, :match])
    # return render json: @match.broadcast_messages.includes(event: [:team, :match]) if request.xhr?
  end

  def vote_for_team
    return render json: {error: 'Вы неавторизированы'}, layout: false unless current_user

    match = Match.find(params[:id])
    team = Team.find(params[:team_id])

    if !current_user.voted?(team, match.id)
      Vote.where(voter_id: current_user.id, vote_scope: match.id).destroy_all
    end
    current_user.like(team, match.id)
    return render json: {success: 'Вы проголосовали', home_votes: match.count_votes_for(:team_home), guest_votes: match.count_votes_for(:team_guest)}, layout: false
  end

private
  # Берет 5 последних новостей для вывода на старнице
  # 
  # @return last_five_posts [Object]
  #
  def set_last_posts
    @last_five_posts = Post.includes(:seo, :main_image, category:[:seo]).not_deleted.is_published.order("created_at DESC").limit(5)
  end
end