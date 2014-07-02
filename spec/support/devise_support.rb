# Module for authenticating users for request specs.
module ValidUserRequestHelper
  def sign_in_as_valid_user_driver
    @employee ||= FactoryGirl.create :employee
    @employee.group = employee_group
    @employee.save!
    page.driver.post employee_session_path, employee: {nickname: @employee.nickname, password: @employee.password}
  end

  def employee_group
    employee_abilities
    abilities = Ability.pluck(:id)
    Group.create!(title: 'admin_group', description: 'Описание группы', ability_ids: abilities)
    Group.last
  end

  def employee_abilities
    abilities = []

    abilities << { context: 'controllers.publication_flags.update',         ability_type: 'controllers' }

    abilities << { context: 'partials.menu.content',           ability_type: 'partials' }
    abilities << { context: 'partials.menu.users',             ability_type: 'partials' }
    abilities << { context: 'partials.menu.settings',          ability_type: 'partials' }
    abilities << { context: 'partials.menu.sport',             ability_type: 'partials' }

    abilities << { context: 'controllers.dashboard.index',     ability_type: 'controllers' }

    abilities << { context: 'controllers.users.index',         ability_type: 'controllers' }
    abilities << { context: 'controllers.users.edit',          ability_type: 'controllers' }
    abilities << { context: 'controllers.users.show',          ability_type: 'controllers' }
    abilities << { context: 'controllers.users.update',        ability_type: 'controllers' }
    abilities << { context: 'controllers.users.destroy',       ability_type: 'controllers' }

    abilities << { context: 'controllers.pages.index',         ability_type: 'controllers' }
    abilities << { context: 'controllers.pages.new',           ability_type: 'controllers' }
    abilities << { context: 'controllers.pages.edit',          ability_type: 'controllers' }
    abilities << { context: 'controllers.pages.update',        ability_type: 'controllers' }
    abilities << { context: 'controllers.pages.destroy',       ability_type: 'controllers' }

    abilities << { context: 'controllers.videos.index',         ability_type: 'controllers' }
    abilities << { context: 'controllers.videos.new',           ability_type: 'controllers' }
    abilities << { context: 'controllers.videos.create',        ability_type: 'controllers' }
    abilities << { context: 'controllers.videos.edit',          ability_type: 'controllers' }
    abilities << { context: 'controllers.videos.update',        ability_type: 'controllers' }
    abilities << { context: 'controllers.videos.destroy',       ability_type: 'controllers' }

    abilities << { context: 'controllers.teams.index',         ability_type: 'controllers' }
    abilities << { context: 'controllers.teams.create',        ability_type: 'controllers' }
    abilities << { context: 'controllers.teams.new',           ability_type: 'controllers' }
    abilities << { context: 'controllers.teams.edit',          ability_type: 'controllers' }
    abilities << { context: 'controllers.teams.update',        ability_type: 'controllers' }
    abilities << { context: 'controllers.teams.destroy',       ability_type: 'controllers' }

    abilities << { context: 'controllers.matches.index',         ability_type: 'controllers' }
    abilities << { context: 'controllers.matches.create',        ability_type: 'controllers' }
    abilities << { context: 'controllers.matches.new',           ability_type: 'controllers' }
    abilities << { context: 'controllers.matches.edit',          ability_type: 'controllers' }
    abilities << { context: 'controllers.matches.update',        ability_type: 'controllers' }
    abilities << { context: 'controllers.matches.destroy',       ability_type: 'controllers' }

    abilities << { context: 'controllers.persons.index',       ability_type: 'controllers' }
    abilities << { context: 'controllers.persons.create',      ability_type: 'controllers' }
    abilities << { context: 'controllers.persons.new',         ability_type: 'controllers' }
    abilities << { context: 'controllers.persons.edit',        ability_type: 'controllers' }
    abilities << { context: 'controllers.persons.update',      ability_type: 'controllers' }
    abilities << { context: 'controllers.persons.destroy',     ability_type: 'controllers' }

    abilities << { context: 'controllers.leagues.index',       ability_type: 'controllers' }
    abilities << { context: 'controllers.leagues.new',         ability_type: 'controllers' }
    abilities << { context: 'controllers.leagues.show',        ability_type: 'controllers' }
    abilities << { context: 'controllers.leagues.edit',        ability_type: 'controllers' }
    abilities << { context: 'controllers.leagues.update',      ability_type: 'controllers' }
    abilities << { context: 'controllers.leagues.destroy',     ability_type: 'controllers' }

    abilities << { context: 'controllers.leagues_groups.index',   ability_type: 'controllers' }
    abilities << { context: 'controllers.leagues_groups.new',     ability_type: 'controllers' }
    abilities << { context: 'controllers.leagues_groups.create',  ability_type: 'controllers' }
    abilities << { context: 'controllers.leagues_groups.edit',    ability_type: 'controllers' }
    abilities << { context: 'controllers.leagues_groups.update',  ability_type: 'controllers' }
    abilities << { context: 'controllers.leagues_groups.destroy', ability_type: 'controllers' }


    abilities << { context: 'controllers.groups.index',        ability_type: 'controllers' }
    abilities << { context: 'controllers.groups.new',          ability_type: 'controllers' }
    abilities << { context: 'controllers.groups.edit',         ability_type: 'controllers' }
    abilities << { context: 'controllers.groups.create',       ability_type: 'controllers' }
    abilities << { context: 'controllers.groups.update',       ability_type: 'controllers' }
    abilities << { context: 'controllers.groups.destroy',      ability_type: 'controllers' }

    abilities << { context: 'controllers.countries.index',        ability_type: 'controllers' }
    abilities << { context: 'controllers.countries.new',          ability_type: 'controllers' }
    abilities << { context: 'controllers.countries.edit',         ability_type: 'controllers' }
    abilities << { context: 'controllers.countries.create',       ability_type: 'controllers' }
    abilities << { context: 'controllers.countries.update',       ability_type: 'controllers' }
    abilities << { context: 'controllers.countries.destroy',      ability_type: 'controllers' }

    abilities << { context: 'controllers.employees.index',     ability_type: 'controllers' }
    abilities << { context: 'controllers.employees.show',      ability_type: 'controllers' }
    abilities << { context: 'controllers.employees.new',       ability_type: 'controllers' }
    abilities << { context: 'controllers.employees.edit',      ability_type: 'controllers' }
    abilities << { context: 'controllers.employees.create',    ability_type: 'controllers' }
    abilities << { context: 'controllers.employees.update',    ability_type: 'controllers' }
    abilities << { context: 'controllers.employees.destroy',   ability_type: 'controllers' }

    abilities << { context: 'controllers.comments.index',      ability_type: 'controllers' }
    abilities << { context: 'controllers.comments.edit',       ability_type: 'controllers' }
    abilities << { context: 'controllers.comments.update',     ability_type: 'controllers' }
    abilities << { context: 'controllers.comments.destroy',    ability_type: 'controllers' }

    abilities << { context: 'controllers.authors.index',       ability_type: 'controllers' }
    abilities << { context: 'controllers.authors.new',         ability_type: 'controllers' }
    abilities << { context: 'controllers.authors.edit',        ability_type: 'controllers' }
    abilities << { context: 'controllers.authors.create',      ability_type: 'controllers' }
    abilities << { context: 'controllers.authors.update',      ability_type: 'controllers' }
    abilities << { context: 'controllers.authors.destroy',     ability_type: 'controllers' }

    abilities << { context: 'controllers.posts.index',         ability_type: 'controllers' }
    abilities << { context: 'controllers.posts.new',           ability_type: 'controllers' }
    abilities << { context: 'controllers.posts.edit',          ability_type: 'controllers' }
    abilities << { context: 'controllers.posts.create',        ability_type: 'controllers' }
    abilities << { context: 'controllers.posts.update',        ability_type: 'controllers' }
    abilities << { context: 'controllers.posts.destroy',       ability_type: 'controllers' }

    abilities << { context: 'controllers.galleries.index',         ability_type: 'controllers' }
    abilities << { context: 'controllers.galleries.new',           ability_type: 'controllers' }
    abilities << { context: 'controllers.galleries.edit',          ability_type: 'controllers' }
    abilities << { context: 'controllers.galleries.create',        ability_type: 'controllers' }
    abilities << { context: 'controllers.galleries.update',        ability_type: 'controllers' }
    abilities << { context: 'controllers.galleries.destroy',       ability_type: 'controllers' }

    abilities << { context: 'controllers.categories.index',    ability_type: 'controllers' }
    abilities << { context: 'controllers.categories.new',      ability_type: 'controllers' }
    abilities << { context: 'controllers.categories.edit',     ability_type: 'controllers' }
    abilities << { context: 'controllers.categories.create',   ability_type: 'controllers' }
    abilities << { context: 'controllers.categories.update',   ability_type: 'controllers' }
    abilities << { context: 'controllers.categories.destroy',  ability_type: 'controllers' }

    abilities << { context: 'controllers.videos.index',         ability_type: 'controllers' }
    abilities << { context: 'controllers.videos.new',           ability_type: 'controllers' }
    abilities << { context: 'controllers.videos.edit',          ability_type: 'controllers' }
    abilities << { context: 'controllers.videos.create',        ability_type: 'controllers' }
    abilities << { context: 'controllers.videos.update',        ability_type: 'controllers' }
    abilities << { context: 'controllers.videos.destroy',       ability_type: 'controllers' }

    abilities << { context: 'controllers.years.new',           ability_type: 'controllers' }
    abilities << { context: 'controllers.years.create',           ability_type: 'controllers' }
    abilities << { context: 'controllers.years.edit',          ability_type: 'controllers' }
    abilities << { context: 'controllers.years.update',        ability_type: 'controllers' }
    abilities << { context: 'controllers.years.destroy',       ability_type: 'controllers' }

    abilities << { context: 'controllers.categories.sort',  ability_type: 'controllers' }

    abilities << { context: 'controllers.transfers.index',         ability_type: 'controllers' }
    abilities << { context: 'controllers.transfers.create',        ability_type: 'controllers' }
    abilities << { context: 'controllers.transfers.new',           ability_type: 'controllers' }
    abilities << { context: 'controllers.transfers.edit',          ability_type: 'controllers' }
    abilities << { context: 'controllers.transfers.update',        ability_type: 'controllers' }
    abilities << { context: 'controllers.transfers.destroy',       ability_type: 'controllers' }

    abilities << { context: 'controllers.characters.index',        ability_type: 'controllers' }
    abilities << { context: 'controllers.characters.new',          ability_type: 'controllers' }
    abilities << { context: 'controllers.characters.edit',         ability_type: 'controllers' }
    abilities << { context: 'controllers.characters.create',       ability_type: 'controllers' }
    abilities << { context: 'controllers.characters.update',       ability_type: 'controllers' }
    abilities << { context: 'controllers.characters.destroy',      ability_type: 'controllers' }

    abilities << { context: 'controllers.persons.get_persons_for_select',      ability_type: 'controllers' }
    abilities << { context: 'controllers.teams.get_teams_for_select',      ability_type: 'controllers' }

    abilities << { context: 'controllers.leagues.update_years',      ability_type: 'controllers' }
    abilities << { context: 'controllers.countries.get_countries_for_ajax',      ability_type: 'controllers' }
    abilities << { context: 'controllers.years.update_year_from_modal',      ability_type: 'controllers' }
    abilities << { context: 'controllers.years.update_groups',      ability_type: 'controllers' }
    Ability.create abilities
  end
end