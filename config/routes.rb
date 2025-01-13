Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :follow do
        post :unfollow, on: :collection
      end

      resources :clock_in do
        member do
          get 'following_record', to: 'clock_in#following_record'
        end
      end
    end
  end
end
