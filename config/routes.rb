Sport::Application.routes.draw do

  get "users/show"

  root to: 'home#index'

  namespace :api do
    scope "/v1" do
      get "/posts", to: "posts_api#index"
      get "/posts/:id", to: "posts_api#show"
    end
  end

  # Аутентификация
  # Отлавливаем исключение, так как в противном
  # случае невозможно выполнить миграции на машине,
  # где не развернуты таблицы пользователей
  begin
    devise_for(:employees, controllers: { sessions: 'backend/sessions' })
    devise_for(:users, controllers: {
      registrations: "registrations",
      sessions: "sessions",
      passwords: "passwords",
      unlocks: "unlocks",
      omniauth_callbacks: 'omniauth_callbacks',
      confirmations: "confirmations"
    })
  rescue Exception => e
    puts "Devise error: #{e.class}: #{e}"
  end

  get 'login', to: 'home#index'
  get 'registration', to: 'home#index'

  get '/users/set_user',   to: 'users#set_user'
  resources :insides, only: :index

  get 'templates/:folder/:template',    to: 'home#get_template'

  #  Публичная часть
  #=========================================================================
  get '/get_stars_in_socials', to: 'home#get_stars_in_socials',  as: :get_stars_in_socials

  get 'users/show',       to: 'users#show',       as: :show_user
  put 'users/update',     to: 'users#update',     as: :user
  get 'pages/:id',        to: 'pages#show',       as: :page
  get 'persons/:id',      to: 'persons#show',     as: :person
  get 'teams/:id',        to: 'teams#show',       as: :team
  get 'columnists/:id',   to: 'columnists#show',  as: :columnists

  get 'rss',                to: 'rss#index',                as: :rss
  get 'yandex_news',        to: 'rss#yandex_news',          as: :yandex_news
  get '/get_breaking_news', to: 'posts#get_breaking_news',  as: :get_breaking_news

  get '/national_teams/(:id)',to: 'teams#get_national_teams',  as: :national_teams

  resources :calendars, only: :index do
  end
  get '/calendars/get_play_off_results',      to: 'calendars#get_play_off_results'

  resources :matches, only: :show do
    member {get :vote_for_team}
  end

  scope 'calendars' do
    get '/:league_id/:season_id',       to: 'calendars#index'
    get '/ajax_leagues_statistics',     to: 'calendars#ajax_leagues_statistics'
    get '/ajax_last_tour',              to: 'calendars#ajax_last_tour'
    get '/ajax_tours',                  to: 'calendars#ajax_tours'
    post '/seasons',                    to: 'calendars#seasons'
  end

  scope '/transfers' do
    get 'ajax_countries',               to: 'transfers#ajax_countries'
  end

  resources :transfers, only: %w(index show) do
    collection { post 'filter_clubs' }
  end

  get 'transfers/categories/:category', to: 'transfers#index', as: :transfers_category
  post 'countries/json_countries', to: 'countries#json_countries'

  resources :categories, only: :show do
    collection do
      post 'get_category_colors'
    end
    # resources :leagues, only: %i(index show) #  TO DO
    resources :posts, only: :show
    resources :videos, only: :show
    resources :galleries, only: :show
    resources :countries, only: :show
    resources :columnist_posts, only: :show
  end

  resources :tweets, only: :create
  get 'twitter_records', to: 'tweets#index', as: :twitter_records
  get 'instagram_records', to: 'instagram_records#index', as: :instagram_records
  resources :instagram_records, only: :create
  # Комментарии
  mount Comments::Engine => "/comments"

  # scope "/comments" do
  #   post "/",                           to: "comments#create",       as: :comment
  #   get '/:id/update_vote/:type',       to: 'comments#update_vote'
  # end

  #*************************************

  get 'tag/:tag',                       to: 'posts#index', as: :tag
  get 'post_status/:post_status',       to: 'post_statuses#index', as: :post_status
  get 'photo_video',                    to: 'photo_video#index', as: :photo_video
  get 'photo_video/get_photos_videos_for_slider', to: 'photo_video#get_photos_videos_for_slider'
  get 'photo_video/(category/:category_id)/(filter/:filter)', to: 'photo_video#index', as: :photo_video
  get 'photo_video/(filter/:filter)/(category/:category_id)', to: 'photo_video#index', as: :photo_video
  get 'photo_video/(type/:type)/(filter/:filter)/(category/:category_id)', to: 'photo_video#index', as: :photo_video
  get 'photo_video/(type/:type)/(category/:category_id)/(filter/:filter)', to: 'photo_video#index', as: :photo_video
  get 'posts/top/:type',                to: 'posts#top', as: :posts_top

  # Поиск
  scope "/search" do
    get "/:query",                      to: "search#search",    as: :search
    get "/:query/more/:page",           to: "search#search",    as: :search_ajax
  end

  # Система администрирования
  #=========================================================================
  namespace :backend do
    namespace :popup do
      resources :leagues_groups, except: %w(index show)
    end

    root to: 'dashboard#index'

    put ':name/:id/:field',             to: 'publication_flags#update', as: :update_flag

    resources :posts, :galleries, :instagram_records, :tweets, except: %w(show create)
    resources :insides, :authors, :users, :employees, :pages, :characters, :groups, :leagues_groups, :transfers, :videos, :tactical_schemes, :twitter_persons, :instagram_persons, except: %w(show)

    resources :settings, except: %w(show create new destroy)

    resources :columnists, except: %w(show) do
      resources :columnist_posts, except: %w(show)
    end
    resources :matches do
      resources :broadcast_messages, only: [:create, :destroy]
    end
    resources :years, except: %w(index show)
    scope 'years' do
      post ':id/:league/update_groups', to: 'years#update_groups'
    end

    resources :countries, except: %w(show) do
      collection { post 'get_countries_for_ajax' }
    end

    resources :leagues, except: %w(create)
    scope 'leagues' do
      post ':id/:year/update_years',    to: 'leagues#update_years'
    end

    resources :teams, except: %w(show create) do
      collection { get 'get_teams_for_select' }
    end
    resources :persons, except: %w(show create) do
      collection { get 'get_persons_for_select' }
      collection { get 'get_referees_for_select' }
    end

    resources :categories, except: %w(show) do
      collection { post 'sort' }
    end

    resources :comments, except: %w(show new create)

    scope '/datatable' do
      get '/authors/:id/:type',         to: 'content#get_authors', as: :datatable_authors
    end

    # Медиа-библиотека
    namespace :media do
      root                              to: "uploads#index"
      match "/uploader_tinymce",        to: "uploads#uploader_tinymce", as: :uploader_tinymce
      get "/uploader",                  to: "uploads#uploader", as: :uploader
      match "/:type(/:act)",            to: "uploads#action", as: :action
    end

  end

end