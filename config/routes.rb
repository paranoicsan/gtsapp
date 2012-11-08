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
  get 'addresses/autocomplete_city_name'
  match 'addresses/autocomplete_street_name/:city_id' => 'addresses#autocomplete_street_name', :as => :addresses_autocomplete_street_name
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
  match 'companies/:id/archive' =>'companies#archive', :as => :archive_company
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

  match 'reports' => 'report#index', :as => :reports

  match 'reports/by_agent' =>  'report#by_agent', :as => :report_by_agent
  match 'reports/prepare_by_agent' =>  'report#prepare_by_agent', :as => :report_prepare_by_agent, :via => :post

  match 'reports/by_rubric' => 'report#by_rubric', :as => :report_by_rubric

  match 'reports/company_by_street' =>  'report#company_by_street', :as => :report_company_by_street
  match 'reports/company_by_street/export/:format' =>  'report#company_by_street_export', :as => :report_company_by_street_export, :via => :get
  match 'reports/prepare_company_by_street' =>  'report#prepare_company_by_street', :as => :report_prepare_company_by_street, :via => :post

  match 'streets_by_city' => 'streets#streets_by_city', :as => :streets_by_city
  match 'streets/export/:format' => 'streets#streets_by_city_export', :as => :streets_by_city_export, :via => :get


  root :to => 'user_sessions#new'

end
