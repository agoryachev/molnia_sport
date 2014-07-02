$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "comments/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "comments"
  s.version     = Comments::VERSION
  s.authors     = ["Sergey Mild"]
  s.email       = ["sergeymild@yandex.ru"]
  s.summary     = "Summary of Comments."
  s.description = "Comments gem"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.18"
  s.add_dependency "mysql2"
  s.add_dependency "awesome_nested_set"
  s.add_dependency "hogan_assets"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec"
end
