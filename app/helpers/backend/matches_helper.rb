module Backend::MatchesHelper

  def select_option_with_optgroup(team)
    haml_tag :optgroup, label: team.title do
      team.persons.each do |person|
        haml_tag :option, person.full_name, value: person.id
      end
    end
  end
end