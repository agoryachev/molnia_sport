module LeaguesGroupHelper

  # Выводит на главной странице названия групп над слайдером
  #
  # @return [HTML] список названий групп
  #
  def leagues_groups_title_for_slider
    leagues_groups = League.leagues_groups_for_slider
    if leagues_groups
      haml_tag :div, class: 'leagues-groups-for-slider' do
        haml_tag :h6, 'Группы'
        leagues_groups.in_groups_of(4).each do |group_of|
          haml_tag :a, href: '#', class: 'leagues-groups-title-group-of' do
            group_of.each do |group|
              haml_tag :span, group.try(:title)
            end
          end
        end
        haml_tag :div, class: 'selected-line'
      end
    end
  end
end