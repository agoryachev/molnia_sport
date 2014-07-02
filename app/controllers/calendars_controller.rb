class CalendarsController < ContentController
  before_filter :get_last_five_posts, only: [:index]
  skip_before_filter :get_main_news

  # GET calendars (для групповых)
  # def index
  #   # @leagues = League.is_published.order("title")
  #   # @years = League.is_published.first.years.order("league_year")

  #   @league = League.includes(:leagues_groups).where('title = ? AND is_published = ? AND is_deleted = ?', "Чемпионат мира", true, false).first
  #   @leagues_groups = @league.leagues_groups.where(round_type: 0)
  #   leagues_group_ids = @league.leagues_groups.pluck(:id)
  #   @played_matches = Match.played_matches(leagues_group_ids)
  #   render 'current_calendar'
  # end

  # GET calendars
  def index
    @league = League.includes(:leagues_groups).where('title = ? AND is_published = ? AND is_deleted = ?', "Чемпионат мира", true, false).first
    @play_off_group = @league.leagues_groups.where(round_type: 1).first
    @leagues_groups = @league.leagues_groups.where(round_type: 0)

    leagues_group_ids = @league.leagues_groups.pluck(:id)
    @played_matches = Match.played_matches(leagues_group_ids)
    render 'playoff_calendar'
  end

  def get_play_off_results
    matches_timetable = {
      stage_1: {
        round_8: [
          {date: 'Сб 28 июня', time: '20:00'},
          {date: 'Вс 29 июня', time: '00:00'},
          {date: 'Пн 30 июня', time: '20:00'},
          {date: 'Вт 1 июля',  time: '00:00'}
        ],
        round_4: [
          {date: 'Сб 5 июля', time: '00:00'},
          {date: 'Чт 4 июля', time: '20:00'}
        ],
        round_2: [
          {date: 'Ср 9 июля',time: '00:00'}
        ],
        round_1: [
          {date: 'Вс 13 июля',time: '00:00'}
        ],
        round_0: [
          {date: 'Вс 13 июля',time: '23:00'}
        ]
      },
      stage_2: {
        round_8: [
          {date: 'Вс 29 июня', time: '20:00'},
          {date: 'Пн 30 июня', time: '00:00'},
          {date: 'Вт 1 июля',  time: '20:00'},
          {date: 'Ср 2 июля',  time: '00:00'}
        ],
        round_4: [
          {date: 'Вс 6 июля', time: '00:00'},
          {date: 'Сб 5 июля', time: '20:00'}
        ],
        round_2: [
          {date: 'Чт 10 июля',time: '00:00'}
        ]
      }
    }

    leagues_group = LeaguesGroup.find(params['leagues_groups_id'])
    matches = leagues_group.matches
    result= []
    (1..2).each do |side|
      st = leagues_group.start_stage
      while st > 1
        matches_stage = matches.where(side: side, stage: st).order('position_in_stage')
        (1..st/2).each do |s|
          match = matches_stage.where(position_in_stage: s).first
          result.push(render_to_string partial: 'shared/calendars/card_match', locals: {match: match, side: side, stage: st, pos: s,
            match_time: matches_timetable["stage_#{side}".to_sym]["round_#{st}".to_sym][s-1]})
        end
        st = st/2
      end
    end
    LeaguesGroup::SPEC_STAGE_KEYS.each do |ind, val|
      match = matches.where(stage: val).order('position_in_stage').first
      result.push(render_to_string partial: 'shared/calendars/card_match', locals: {match: match, side: 1, stage: val, pos: 1, 
        match_time: matches_timetable[:stage_1]["round_#{val}".to_sym][0]})
    end
    return render json: {cards: result}
  end
  # URL POST calendars/seasons
  # При выборе лиги в фильтре,
  # обращаемся на этот url для годов выбранной лиги
  #
  # @param id [Integer] params
  # @return [JSON] найденные года
  #
  # def seasons
  #   seasons = Year.select([:id, :title, :league_year]).where(league_id: params[:id]).order("id DESC")
  #   seasons_json = seasons.collect{ |season| { id: season.id, title: season.season_title, league_year: season.league_year } }
  #   return render json: seasons_json, root: false
  # end

  # URL GET calendars/ajax_leagues_statistics
  # Получение статистики по выбранной лиги
  #
  # @param league_id     [Integer] id лиги
  # @param year_id       [Integer] id года
  # @return statistics   [JSON] найденная статистика
  # @return league_title [JSON] название лиги
  #
  def ajax_leagues_statistics
    league_title = League.select(:title).find(params[:league_id])
    statistics = LeaguesStatistic.get_statistics_for_league(params[:league_id], params[:year_id])
    return render json: {statistics: statistics, league_title: league_title.title}
  end


  # URL GET calendars/ajax_last_tour
  # Вывод последнего тура по выбранной лиги на странице календаря
  #
  # @param league_id           [Integer] id лиги
  # @param year_id             [Integer] id года
  #
  # @return last_leagues_group [JSON] найденный тур
  # @return matches            [JSON] матчи тура
  # @return error              [JSON] тескт с ошибкой
  #
  def ajax_last_tour
    # Находим лигу по фильтру
    league = League
              .includes(:leagues_groups, :years)
              .where("
                  leagues.id = ?
                  AND
                  years.id = ?",
                params[:league_id],
                params[:year_id]
              ).first
    render_error && return if league.nil?

    # получение последнего тура по лиге
    # если тур найден
    if last_leagues_group = league.get_leagues_groups.pop
      # находим матчи для найденного тура
      matches = last_leagues_group.get_matches
      # Если матчей не найдено то нечего не выводим
      render_error && return unless matches.present?
      # парсим в json обьект
      matches_json = Match.parse_to_json(matches)
      # отдаем на страницу
      render json: {last_leagues_group: last_leagues_group, matches: matches_json}
    else
      # иначе пишем не найдено
      render_error
    end
  end

  # URL GET calendars/ajax_tours
  # Получение всех туров, кроме последнего по выбранной лиги
  #
  # @param league_id  [Integer] id лиги
  # @param year_id    [Integer] id года
  # @return league    [JSON] лига, со всеми турами и матчами для туров
  #
  def ajax_tours
    # Поиск лиги по id и соединение с таблицей leagues_groups
    # так же leagues_groups соединятеся с matches
    league = League
              .joins("
                JOIN leagues_groups
                  ON leagues_groups.league_id = leagues.id")
              .joins("
                JOIN matches
                  ON leagues_groups.id = matches.leagues_group_id")
              .joins("
                JOIN teams team_home
                  ON matches.team_home_id = team_home.id")
              .joins("
                JOIN teams team_guest
                  ON matches.team_guest_id = team_guest.id")
              .where("leagues.id = ?", params[:league_id])
              .select([
                "leagues.title as league_title",
                "leagues_groups.id as leagues_group_id",
                "leagues_groups.title as leagues_group_title",
                "team_home.title team_home_title",
                "team_guest.title as team_guest_title",
                "DATE_FORMAT(matches.start_at, '%d.%m') as match_start_at_day",
                "DATE_FORMAT(matches.start_at, '%H:%m') as match_start_at_hours",
                "matches.count_home as match_count_home",
                "matches.count_guest as match_count_guest"
              ])
    # дополнительная фильтрация по year_id если такой параметр пришел
    league = league
              .where("
                leagues_groups.year_id = ?",
                params[:year_id]) if params[:year_id].present?
    # группировка всего по leagues_group_id
    # Если созданная группа не содержит игр, сюда она не попадает
    league = league
              .group("leagues_groups.id, matches.id")
              .group_by(&:leagues_group_id)

    # удаление последнего тура, он отобрадается наверху
    league.delete(params[:last_tour_id].to_i)
    # рендер лиги туров лиги и матчей туров
    render json: league, root: false
  end

  private

  # Получение последних 5 новостей для шапки
  #
  # @return [Array] последние новости
  #
  def get_last_five_posts
    @last_five_posts = last_five_posts(init_default_posts)
  end

  def render_error
    render json: {error: {msg: 'Не найдено'}}
  end
end
