module ActsAsVotable
  module Votable

    def acts_as_voter
      require 'acts_as_votable/votes'
      include ActsAsVotable::Votes
      has_many :votes, foreign_key: :voter_id
    end

    def acts_as_votable
      has_many :votes, as: :votable
      define_method :count_votes do
        votes.sum(:vote_weight)
      end
    end

    def acts_as_votable_for_match
      define_method :count_votes_for do |team|
        t = self.send(team)
        Vote.where(vote_scope: self.id, votable_type: t.class.name, votable_id: t.id).sum(:vote_weight)
      end
    end
  end
end