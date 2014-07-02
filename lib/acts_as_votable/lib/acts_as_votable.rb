require "acts_as_votable/version"

require 'active_record'
require 'active_support/inflector'

module ActsAsVotable
  if defined?(ActiveRecord::Base)
    require "acts_as_votable/votable"
    ActiveRecord::Base.extend ActsAsVotable::Votable
  end
end