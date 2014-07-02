module ActsAsVotable

  module Votes

    extend ActiveSupport::Concern

    def like(comment, score = nil)
      _voted = voted_for(comment, score)
      unless _voted
        create_vote(comment, :increment, score)
        return true
      end
      if _voted.vote_weight > 0
        comment.decrement!(:cached_weighted_score, 1)
        _voted.destroy
      end
      return true
    end

    def dislike(comment, score= nil)
      _voted = voted_for(comment, score)
      unless _voted
        create_vote(comment, :decrement, score)
        return true
      end
      if _voted.vote_weight.zero? || _voted.vote_weight == -1
        comment.increment!(:cached_weighted_score, 1)
        _voted.destroy
      end
      return true
    end

    def voted?(comment, score = nil)
      self.votes.includes(:votable).where(votable_id: comment.id, votable_type: comment.class.name, vote_scope: score).any?
    end

    def voted_for(comment, score)
      self.votes.where(votable_id: comment.id, votable_type: comment.class.name, vote_scope: score).first
    end

    def likes_id(comments)
      comment = if comments.is_a?(ActiveRecord::Relation) then comments.first else comments end
      self.votes.where(votable_id: comment).pluck(:votable_id)
    end

    private

    def create_vote(comment, type, score)
      cached_weighted_score = (type == :increment) ? 1 : -1
      vote = votes.new(votable_id: comment.id, votable_type: comment.class.name.classify)
      vote.vote_weight = cached_weighted_score
      vote.vote_scope = score
      vote.save
      if type == :increment
        comment.increment!(:cached_weighted_score, 1)
      elsif type == :decrement
        comment.decrement!(:cached_weighted_score, 1)
      end
    end

    def vote_weight_zero?(comment)
      comment_votes(comment).first.vote_weight.zero?
    end

    def vote_weight_minus_one?(comment)
      comment_votes(comment).first.vote_weight == -1
    end

    def vote_weight_one?(comment)
      comment_votes(comment).first.vote_weight == 1
    end

    def comment_votes(comment)
      votes.includes(:votable).where(votable_id: comment, votable_type: comment.class.name)
    end

  end

end
