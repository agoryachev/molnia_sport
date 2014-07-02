# -*- coding: utf-8 -*-
class Backend::MatchesController < Backend::ContentController
  before_filter :set_match, only: %w(edit update destroy)

  # GET backend/matches
  def index
    @matches = Match.not_deleted.paginate(page: params[:page], limit: Setting.records_per_page, order: 'created_at DESC')
  end

  def show
    @match = Match.find params[:id]
    @tactical_schemes = TacticalScheme.is_published.collect {|p| [ p.description, p.id ] }
    @message = BroadcastMessage.new
  end

  # GET backend/matches/new
  def new
    @match = Match.new
    build_seo
  end

  # POST backend/matches
  def create
    @match = Match.new(params[:match])
    if @match.save
      create_successful
    else
      create_failed
    end
  end

  # GET backend/matches/:id
  def edit
    build_seo
  end

  # PUT /backend/matches/:id
  def update
    update_published_column(@match) && return if request.xhr?
    if @match.update_attributes(params[:match])
      set_team_formations(@match, @match.team_home, params[:team_home])
      set_team_formations(@match, @match.team_guest, params[:team_guest])
      update_successful
    else
      update_failed
    end
  end

  # DELETE /backend/matches/:id
  def destroy
    @match.toggle!(:is_deleted)
    @match.update_attribute(:is_published, false)
    destroy_successful
  end

  private

  # Обновление составов команд при обновлении информации о матче
  def set_team_formations(match, team, data)
    team_formation = TeamFormation.where(match_id: match.id, team_id: team.id)
    # если в БД ничего нет, то создаем новый состав
    if team_formation.size.zero?
      unless data.nil?
        data.each do |key, val|
          val.each do |id|
            TeamFormation.create(match_id: match.id, team_id: team.id, person_id: id, person_type: TeamFormation::TEAM_FORMATION_KEYS[key.to_sym])
          end
        end
      end
    # в БД уже есть какой то состав на матч
    else
      # пришли не пустые данные о составе
      unless data.nil?
        # перебираем все доступные ключи
        TeamFormation::TEAM_FORMATION_KEYS.each do |key, val|
          formation_by_key = team_formation.where(person_type: val)
          new_formation_ids_by_key = data[key].nil? ? nil : data[key].map { |id| id.to_i }
          # если данный ключ (напр. 'forward') в пришедших данных отсуствует то удаляем текущие записи в БД составе, но только по данному ключу
          if new_formation_ids_by_key.nil?
            formation_by_key.destroy_all
          # если данный ключ (напр. 'forward') в пришедших данных присутствует то обновляем текущие записи в БД составе, но только по данному ключу
          else
            formation_ids_by_key = formation_by_key.pluck(:person_id)
            # создаем новые записи о составе, которые еще не были добавлены в БД (они пришли во входных данных из админки)
            new_formation_ids_by_key.each do |id|
              TeamFormation.create(match_id: match.id, team_id: team.id, person_id: id, person_type: val) unless formation_ids_by_key.index id
            end
            # удаляем старые записи о составе, которые уже были добавлены в БД (они НЕ пришли во входных данных из админки)
            formation_by_key.each do |formation|
              TeamFormation.where(id: formation.id).destroy_all unless new_formation_ids_by_key.index formation.person_id
            end
          end
        end
      # пришли пустые данные о составе - значит удаляем весь состав из базы
      else
        team_formation.destroy_all
      end
    end
  end

  def set_match
    @match = Match.find(params[:id])
  end

  def build_seo
    @seo = @match.build_seo unless @match.seo.present?
  end
end