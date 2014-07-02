module Comments
  class Engine < ::Rails::Engine
    isolate_namespace Comments
    require 'awesome_nested_set'
    require 'hogan_assets'
  end
end
