AndromoneyServer::Application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :delete_datas, only: [:destroy]
      resources :update_datas, only: [:update]
      resources :add_datas, only: [:create]
      resources :get_device_add_datas, only: [:index]
    end
  end
end
