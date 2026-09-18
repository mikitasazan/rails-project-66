Rails.application.routes.draw do
  scope module: :web do
    root "home#index"

    post "auth/:provider", to: "auth#request", as: :auth_request
    get "auth/:provider/callback", to: "auth#callback", as: :callback_auth

    delete "auth/logout"

    resources :repositories, only: %i[index show new create update] do
      scope module: :repositories do
        resources :checks, only: %i[create show]
      end
    end
  end

  if Rails.env.test?
    namespace :test do
      resource :session, only: [ :create ]
    end
  end

  namespace :api do
    resources :checks, only: %i[create]
  end
end
