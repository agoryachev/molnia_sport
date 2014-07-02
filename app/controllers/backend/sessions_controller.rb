# -*- coding: utf-8 -*-
class Backend::SessionsController < Devise::SessionsController
  skip_before_filter :get_main_news
end