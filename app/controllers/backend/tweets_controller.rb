# encoding: utf-8
class Backend::TweetsController < Backend::ContentController
  before_filter :set_tweet, only: [:edit, :update, :destroy]

  # GET /backend/tweets(.:format)
  def index
    @tweets = Tweet.paginate(page: params[:page], limit: Setting.records_per_page, order: "published_at DESC").not_deleted
    @tweets = @tweets.where(is_published: params[:is_published]) if params[:is_published]
  end

  # GET /backend/tweets/new(.:format)
  def new
    @tweet = find_or_create_obj(:tweet)
  end

  # GET /backend/tweets/:id/edit(.:format)
  def edit
  end

  # PUT /backend/tweets/:id(.:format)
  def update
    @tweet.link = params[:tweet][:link]
    if @tweet.valid? && @tweet.save
      clear_session(:tweet)
      create_successful
    else
      create_failed
    end
  end

  # DELETE /backend/tweets/:id(.:format)
  def destroy
    @tweet.toggle!(:is_deleted)
    @tweet.update_attribute(:is_published, false)
    clear_session_by_id(@tweet)
    destroy_successful
  end

  private

  def set_tweet
    @tweet = Tweet.find(params[:id])
  end
end