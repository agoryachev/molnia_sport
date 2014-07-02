module MatchesHelper
  def vote_for_link(match, team_sym)
    team = match.send(team_sym)
    data = {team_id: team.id, match_id: match.id}
    class_name = current_user && current_user.voted?(team, match.id) ? 'active' : ''
    class_name << ' vote_button'
    haml_tag :a, href: '#share-modal', data: data, class: class_name do
      haml_concat 'я болею'
      haml_tag :span, match.count_votes_for(team_sym)
    end
  end
end