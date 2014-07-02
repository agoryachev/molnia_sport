Comments::Engine.routes.draw do
  get '/',                            to: 'comments#index'
  post "/",                           to: "comments#create"
  get '/:id/update_vote/:type',       to: 'comments#update_vote'
end
