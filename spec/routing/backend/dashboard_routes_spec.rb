# encoding: utf-8
require 'spec_helper'

describe Backend::DashboardController do

  describe 'маршруты' do
    # Допустимые маршруты
    it ':index' do
      { get: '/backend' }.should route_to(
        controller: 'backend/dashboard',
        action:     'index'
      )
    end

  end

end