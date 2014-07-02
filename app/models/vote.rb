# encoding: utf-8
# == Schema Information
#
# Table name: votes
#
#  id           :integer          not null, primary key
#  votable_id   :integer
#  votable_type :string(255)
#  voter_id     :integer
#  voter_type   :string(255)
#  vote_flag    :boolean
#  vote_scope   :string(255)
#  vote_weight  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

# Голоса за материал
class Vote < ActiveRecord::Base

  attr_accessible :votable_id, :votable_type, :voter_id, :vote_weight
  belongs_to :user
  belongs_to :votable, polymorphic: true

end
