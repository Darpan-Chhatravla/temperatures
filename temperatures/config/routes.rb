Rails.application.routes.draw do
  scope module: :api do
    namespace :v1 do
      resources :cities, only: [:index, :create] do
        collection do
          patch  '/update',                  to: 'cities#update'
          delete '/delete',                  to: 'cities#destroy'
          get    '/historical_temperatures', to: 'cities#historical_temperatures'    
        end
      end
    end
  end
end
