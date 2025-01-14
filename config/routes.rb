Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :follow do
        post :unfollow, on: :collection
      end

      resources :clock_in do
        get :following_record, on: :collection
      end
    end
  end
end
