AndromoneyServer::Application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :delete_datas, only: [] do
        collection do
          post 'delete_all'
        end
      end
      resources :update_datas, only: [] do
        collection do
          post 'update_all'
        end
      end
      resources :users, only: [:create] do
        collection do
          get 'is_user_register'
        end
      end
      resources :add_datas, only: [:create]
      resources :get_device_add_datas, only: [:index]
      resources :get_device_update_datas, only: [:index]
      resources :get_device_delete_datas, only: [:index]
    end
  end
end
