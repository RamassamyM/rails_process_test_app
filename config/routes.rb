Rails.application.routes.draw do
  resources :daemon_processes
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'daemon_processes/start', to: 'daemon_processes#start', as: 'start_daemon_process'
end
