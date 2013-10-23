AndromoneyServer::Application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :delete_datas, only: [:destroy]
      resources :update_datas, only: [:update]
    end
  end
end
