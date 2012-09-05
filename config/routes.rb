Gtsapp::Application.routes.draw do

  resources :product_types
  resources :rubrics
  resources :streets
  resources :post_indices
  resources :districts
  resources :cities
  resources :form_types
  resources :project_codes

  get 'companies/autocomplete_rubric_name'
  match 'products/autocomplete_rubric_name/:contract_id' => 'products#autocomplete_rubric_name', :as => :products_autocomplete_rubric_name
  resources :companies, :shallow => true do
    resources :people
    resources :contracts do
      resources :products, only: [:new, :create, :edit, :show, :destroy, :update]
    end
    resources :branches do
      resources :addresses
      resources :phones
    end
  end

  match 'branches/:id/make_main' => 'branches#make_main', :as => :branch_make_main

  match 'branches/:id/add_website' => 'branches#add_website', :as => :branch_add_website
  match 'branches/:id/delete_website/:website_id' => 'branches#delete_website', :as => :branch_delete_website

  match 'branches/:id/add_email' => 'branches#add_email', :as => :branch_add_email
  match 'branches/:id/delete_email/:email_id' => 'branches#delete_email', :as => :branch_delete_email

  match 'companies/:id/activate' =>'companies#activate', :as => :activate_company
  match 'companies/:id/request_delete' =>'companies#request_delete_reason', :as => :company_request_delete
  match 'companies/:id/request_attention_reason' =>'companies#request_attention_reason', :as => :company_request_attention_reason
  match 'companies/:id/request_attention' =>'companies#request_attention', :as => :company_request_attention
  match 'companies/:id/request_improvement_reason' =>'companies#request_improvement_reason', :as => :company_request_improvement_reason
  match 'companies/:id/request_improvement' =>'companies#request_improvement', :as => :company_request_improvement
  match 'companies/:id/improve' =>'companies#improve', :as => :company_improve
  match 'companies/:id/queue_for_delete' =>'companies#queue_for_delete', :as => :company_queue_for_delete
  match 'companies/:id/unqueue_for_delete' =>'companies#unqueue_for_delete', :as => :company_unqueue_for_delete

  match 'companies/:id/add_rubric/:rub_id' => 'companies#add_rubric', :as => :company_add_rubric
  match 'companies/:id/delete_rubric/:rub_id' => 'companies#delete_rubric', :as => :company_delete_rubric
  match 'companies/validate_title' => 'companies#validate_title', :as => :company_validate_title

  match 'contracts/:id/activate' =>'contracts#activate', :as => :activate_contract

  resources :users
  resources :user_sessions

  match 'dashboard' => 'dashboard#index', :as => :dashboard
  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout

  match 'search' => 'search#index', :as => :search
  match 'search/company/do' => 'search#search_company', :as => :search_company

  root :to => 'user_sessions#new'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'product_types/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'product_types/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => producttype.id)



  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :product_types

  # Sample resource route with options:
  #   resources :product_types do
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
  #   resources :product_types do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :product_types do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/product_types/* to Admin::ProductTypesController
  #     # (app/controllers/admin/product_types_controller.rb)
  #     resources :product_types
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
