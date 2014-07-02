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

FactoryGirl.define do
  factory :vote do

    votable_id          1
    votable_type        "Comment"
    voter_id            1
    voter_type          "User"
    vote_flag           1
    vote_weight         0

  end
end