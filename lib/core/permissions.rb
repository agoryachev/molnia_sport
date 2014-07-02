# -*- coding: utf-8 -*-
class Core::Permissions

  # Переустановка прав доступа проекта
  #
  # @return [Boolean] true в случае успешной переустановки прав доступа
  #
  def self.rebuild

    ActiveRecord::Base.connection.execute('TRUNCATE TABLE abilities')

    abilities = []

    abilities << { context: 'controllers.publication_flags.update',         ability_type: 'controllers' }

    abilities << { context: 'partials.menu.content',           ability_type: 'partials' }
    abilities << { context: 'partials.menu.users',             ability_type: 'partials' }
    abilities << { context: 'partials.menu.settings',          ability_type: 'partials' }
    abilities << { context: 'partials.menu.sport',             ability_type: 'partials' }

    abilities << { context: 'controllers.dashboard.index',     ability_type: 'controllers' }

    abilities << { context: 'controllers.users.index',         ability_type: 'controllers' }
    abilities << { context: 'controllers.users.new',           ability_type: 'controllers' }
    abilities << { context: 'controllers.users.edit',          ability_type: 'controllers' }
    abilities << { context: 'controllers.users.create',        ability_type: 'controllers' }
    abilities << { context: 'controllers.users.show',          ability_type: 'controllers' }
    abilities << { context: 'controllers.users.update',        ability_type: 'controllers' }
    abilities << { context: 'controllers.users.destroy',       ability_type: 'controllers' }

    abilities << { context: 'controllers.pages.index',         ability_type: 'controllers' }
    abilities << { context: 'controllers.pages.new',           ability_type: 'controllers' }
    abilities << { context: 'controllers.pages.create',        ability_type: 'controllers' }
    abilities << { context: 'controllers.pages.edit',          ability_type: 'controllers' }
    abilities << { context: 'controllers.pages.update',        ability_type: 'controllers' }
    abilities << { context: 'controllers.pages.destroy',       ability_type: 'controllers' }

    abilities << { context: 'controllers.insides.index',         ability_type: 'controllers' }
    abilities << { context: 'controllers.insides.new',           ability_type: 'controllers' }
    abilities << { context: 'controllers.insides.create',        ability_type: 'controllers' }
    abilities << { context: 'controllers.insides.edit',          ability_type: 'controllers' }
    abilities << { context: 'controllers.insides.update',        ability_type: 'controllers' }
    abilities << { context: 'controllers.insides.destroy',       ability_type: 'controllers' }

    abilities << { context: 'controllers.videos.index',        ability_type: 'controllers' }
    abilities << { context: 'controllers.videos.new',          ability_type: 'controllers' }
    abilities << { context: 'controllers.videos.create',       ability_type: 'controllers' }
    abilities << { context: 'controllers.videos.edit',         ability_type: 'controllers' }
    abilities << { context: 'controllers.videos.update',       ability_type: 'controllers' }
    abilities << { context: 'controllers.videos.destroy',      ability_type: 'controllers' }

    abilities << { context: 'controllers.teams.index',         ability_type: 'controllers' }
    abilities << { context: 'controllers.teams.create',        ability_type: 'controllers' }
    abilities << { context: 'controllers.teams.new',           ability_type: 'controllers' }
    abilities << { context: 'controllers.teams.edit',          ability_type: 'controllers' }
    abilities << { context: 'controllers.teams.update',        ability_type: 'controllers' }
    abilities << { context: 'controllers.teams.destroy',       ability_type: 'controllers' }

    abilities << { context: 'controllers.matches.index',       ability_type: 'controllers' }
    abilities << { context: 'controllers.matches.create',      ability_type: 'controllers' }
    abilities << { context: 'controllers.matches.new',         ability_type: 'controllers' }
    abilities << { context: 'controllers.matches.show',        ability_type: 'controllers' }
    abilities << { context: 'controllers.matches.edit',        ability_type: 'controllers' }
    abilities << { context: 'controllers.matches.update',      ability_type: 'controllers' }
    abilities << { context: 'controllers.matches.destroy',     ability_type: 'controllers' }

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


    abilities << { context: 'controllers.groups.index',           ability_type: 'controllers' }
    abilities << { context: 'controllers.groups.new',             ability_type: 'controllers' }
    abilities << { context: 'controllers.groups.edit',            ability_type: 'controllers' }
    abilities << { context: 'controllers.groups.create',          ability_type: 'controllers' }
    abilities << { context: 'controllers.groups.update',          ability_type: 'controllers' }
    abilities << { context: 'controllers.groups.destroy',         ability_type: 'controllers' }

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

    abilities << { context: 'controllers.years.new',               ability_type: 'controllers' }
    abilities << { context: 'controllers.years.create',            ability_type: 'controllers' }
    abilities << { context: 'controllers.years.edit',              ability_type: 'controllers' }
    abilities << { context: 'controllers.years.update',            ability_type: 'controllers' }
    abilities << { context: 'controllers.years.destroy',           ability_type: 'controllers' }

    abilities << { context: 'controllers.categories.sort',         ability_type: 'controllers' }

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

    abilities << { context: 'controllers.persons.get_persons_for_select',    ability_type: 'controllers' }
    abilities << { context: 'controllers.persons.get_referees_for_select',   ability_type: 'controllers' }
    abilities << { context: 'controllers.teams.get_teams_for_select',        ability_type: 'controllers' }

    abilities << { context: 'controllers.leagues.update_years',              ability_type: 'controllers' }
    abilities << { context: 'controllers.countries.get_countries_for_ajax',  ability_type: 'controllers' }
    abilities << { context: 'controllers.years.update_year_from_modal',      ability_type: 'controllers' }
    abilities << { context: 'controllers.years.update_groups',               ability_type: 'controllers' }

    abilities << { context: 'controllers.columnists.index',                  ability_type: 'controllers' }
    abilities << { context: 'controllers.columnists.new',                    ability_type: 'controllers' }
    abilities << { context: 'controllers.columnists.edit',                   ability_type: 'controllers' }
    abilities << { context: 'controllers.columnists.update',                 ability_type: 'controllers' }
    abilities << { context: 'controllers.columnists.destroy',                ability_type: 'controllers' }

    abilities << { context: 'controllers.columnist_posts.index',             ability_type: 'controllers' }
    abilities << { context: 'controllers.columnist_posts.new',               ability_type: 'controllers' }
    abilities << { context: 'controllers.columnist_posts.edit',              ability_type: 'controllers' }
    abilities << { context: 'controllers.columnist_posts.update',            ability_type: 'controllers' }
    abilities << { context: 'controllers.columnist_posts.destroy',           ability_type: 'controllers' }

    abilities << { context: 'controllers.settings.index',                    ability_type: 'controllers' }
    abilities << { context: 'controllers.settings.edit',                     ability_type: 'controllers' }
    abilities << { context: 'controllers.settings.update',                   ability_type: 'controllers' }

    abilities << { context: 'controllers.tweets.index',                      ability_type: 'controllers' }
    abilities << { context: 'controllers.tweets.new',                        ability_type: 'controllers' }
    abilities << { context: 'controllers.tweets.edit',                       ability_type: 'controllers' }
    abilities << { context: 'controllers.tweets.update',                     ability_type: 'controllers' }
    abilities << { context: 'controllers.tweets.destroy',                    ability_type: 'controllers' }

    abilities << { context: 'controllers.instagram_records.index',           ability_type: 'controllers' }
    abilities << { context: 'controllers.instagram_records.new',             ability_type: 'controllers' }
    abilities << { context: 'controllers.instagram_records.edit',            ability_type: 'controllers' }
    abilities << { context: 'controllers.instagram_records.update',          ability_type: 'controllers' }
    abilities << { context: 'controllers.instagram_records.destroy',         ability_type: 'controllers' }

    abilities << { context: 'controllers.tactical_schemes.index',           ability_type: 'controllers' }
    abilities << { context: 'controllers.tactical_schemes.new',             ability_type: 'controllers' }
    abilities << { context: 'controllers.tactical_schemes.edit',            ability_type: 'controllers' }
    abilities << { context: 'controllers.tactical_schemes.update',          ability_type: 'controllers' }
    abilities << { context: 'controllers.tactical_schemes.destroy',         ability_type: 'controllers' }

    abilities << { context: 'controllers.twitter_persons.index',            ability_type: 'controllers' }
    abilities << { context: 'controllers.twitter_persons.new',              ability_type: 'controllers' }
    abilities << { context: 'controllers.twitter_persons.edit',             ability_type: 'controllers' }
    abilities << { context: 'controllers.twitter_persons.update',           ability_type: 'controllers' }
    abilities << { context: 'controllers.twitter_persons.destroy',          ability_type: 'controllers' }
    abilities << { context: 'controllers.twitter_persons.create',           ability_type: 'controllers' }

    abilities << { context: 'controllers.instagram_persons.index',          ability_type: 'controllers' }
    abilities << { context: 'controllers.instagram_persons.new',            ability_type: 'controllers' }
    abilities << { context: 'controllers.instagram_persons.edit',           ability_type: 'controllers' }
    abilities << { context: 'controllers.instagram_persons.update',         ability_type: 'controllers' }
    abilities << { context: 'controllers.instagram_persons.destroy',        ability_type: 'controllers' }
    abilities << { context: 'controllers.instagram_persons.create',         ability_type: 'controllers' }

    Ability.create abilities

  end

end
