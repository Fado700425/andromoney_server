require 'sidekiq/web'
AndromoneyServer::Application.routes.draw do
  mount Sidekiq::Web, at: '/sidekiq'
  
  # get 'home', controller: 'welcome', action: 'index'
  # get 'download', controller: 'welcome', action: 'download'
  # get 'about', controller: "welcome", action: 'about'
  # get 'pricing', controller: "welcome", action: 'pricing'
  # root to: 'welcome#front'

  # resources :records
  # resources :budgets
  # resources :reports

  get 'share_confirm', controller: 'api/v1/sync', action: 'confirm_share'

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

      resources :sync, only: []  do
        collection do
          post 'start'
          post 'end'
          post 'owner_share_user_payment'
          post 'delete_share'
          get  'confirm_share'
        end
      end

      resources :add_datas, only: [:create]
      resources :get_device_add_datas, only: [:index]
      resources :get_device_update_datas, only: [:index]
      resources :get_device_delete_datas, only: [:index]
      resources :get_share_payment_datas, only: [:index] do
        collection do
          get  'users_who_shared_by_owner'
          get  'payments_shared_by_others'
        end
      end
    end
  end
end
