# -*- coding: utf-8 -*-
class StatisticsMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request      = Rack::Request.new(env)
    request_path = request.env["REQUEST_PATH"]
    unless request_path.nil?
      path_components = request_path.scan(/^\/?categories\/[^\/]+\/(posts|galleries|videos)\/(\d{1,})[-_a-z0-9]*(?:\.json|\.html)?$/i)
      path_components = request_path.scan(/^\/?(matches)\/(\d{1,})[-_a-z0-9]*(?:\.json|\.html)?$/i) if path_components.empty?
      if path_components.present?
        Statistics::Put.new(request, path_components)
      end
    end
    @app.call(env)
  end
end