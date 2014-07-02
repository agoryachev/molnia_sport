# encoding: utf-8
class Backend::BackendController < ActionController::Base
  before_filter :authenticate_employee!
  skip_before_filter :get_main_news
  include CheckAbilities
  include Redirects

  layout "backend"

  respond_to :html, :json

  private
  # Вызывает ошибку для контроллера если обьект не найден
  #
  # @return RoutingError [Error]
  #
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

end