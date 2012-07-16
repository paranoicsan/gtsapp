Gtsapp::Application.routes.draw do

  resources :products
  resources :rubrics
  resources :streets
  resources :post_indices
  resources :districts
  resources :cities
  resources :form_types

  resources :companies, :shallow => true do
    resources :contracts
    resources :branches do
      resources :addresses
      resources :phones
    end
  end

  match 'branches/:id/make_main' => 'branches#make_main', :as => :branch_make_main
  match 'branches/:id/add_website' => 'branches#add_website', :as => :branch_add_website, :method => :post
  match 'branches/:id/delete_website/:website_id' => 'branches#delete_website', :as => :branch_delete_website
  match 'companies/:id/activate' =>'companies#activate', :as => :activate_company
  match 'companies/:id/add_rubric/:rub_id' => 'companies#add_rubric', :as => :company_add_rubric
  match 'companies/:id/delete_rubric/:rub_id' => 'companies#delete_rubric', :as => :company_delete_rubric
  match 'contracts/:id/activate' =>'contracts#activate', :as => :activate_contract

  resources :users
  resources :user_sessions

  match 'dashboard' => 'dashboard#index', :as => :dashboard
  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout

  root :to => 'user_sessions#new'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)



  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
