Gtsapp::Application.routes.draw do

  devise_for :users, class_name: 'Users::User'

  root :to => 'dashboard#index'

end
