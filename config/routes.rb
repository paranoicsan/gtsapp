Gtsapp::Application.routes.draw do

  devise_for :users, class_name: 'Users::User'

  root :to => 'dashboard#index'

  resources :product_types
  resources :rubrics
  resources :streets
  resources :post_indices

  resources :form_types
  resources :project_codes

  scope module: :address do
    resources :districts
    resources :cities
  end

  match 'company/:id/autocomplete_rubric_name/', to: 'companies#autocomplete_rubric_name',
      as: :companies_autocomplete_rubric_name
  match 'address/autocomplete_city_name'
  match 'address/autocomplete_street_name/:city_id', to: 'address#autocomplete_street_name',
      as: :addresses_autocomplete_street_name
  match 'products/autocomplete_rubric_name/:contract_id', to: 'products#autocomplete_rubric_name',
      as: :products_autocomplete_rubric_name

  resources :companies, :shallow => true do
    resources :people
    resources :contracts do
      resources :products, only: [:new, :create, :edit, :show, :destroy, :update]
    end
    resources :branches do
      resources :addresses, module: :address
      resources :phones
    end
  end

  match 'branches/:id/make_main', to: 'branches#make_main', as: :branch_make_main

  match 'branches/:id/add_website', to: 'branches#add_website', as: :branch_add_website
  match 'branches/:id/delete_website/:website_id', to: 'branches#delete_website', as: :branch_delete_website

  match 'branches/:id/add_email', to: 'branches#add_email', as: :branch_add_email
  match 'branches/:id/delete_email/:email_id', to: 'branches#delete_email', as: :branch_delete_email

  match 'companies/:id/activate', to: 'companies#activate', as: :activate_company
  match 'companies/:id/archive', to: 'companies#archive', as: :archive_company
  match 'companies/:id/request_delete', to: 'companies#request_delete_reason',
      as: :company_request_delete
  match 'companies/:id/request_attention_reason', to: 'companies#request_attention_reason',
      as: :company_request_attention_reason
  match 'companies/:id/request_attention', to: 'companies#request_attention',
      as: :company_request_attention
  match 'companies/:id/request_improvement_reason', to: 'companies#request_improvement_reason',
      as: :company_request_improvement_reason
  match 'companies/:id/request_improvement', to: 'companies#request_improvement',
      as: :company_request_improvement
  match 'companies/:id/improve', to: 'companies#improve', as: :company_improve
  match 'companies/:id/queue_for_delete', to: 'companies#queue_for_delete', as: :company_queue_for_delete
  match 'companies/:id/unqueue_for_delete', to: 'companies#unqueue_for_delete',
      as: :company_unqueue_for_delete

  match 'companies/:id/add_rubric/:rub_id', to: 'companies#add_rubric', as: :company_add_rubric
  match 'companies/:id/delete_rubric/:rub_id', to: 'companies#delete_rubric',
      as: :company_delete_rubric
  match 'companies/validate_title', to: 'companies#validate_title', as: :company_validate_title

  match 'contracts/:id/activate', to: 'contracts#activate', as: :activate_contract

  # resources :users
  # resources :user_sessions

  match 'dashboard', to: 'dashboard#index', as: :dashboard
  match 'login', to: 'user_sessions#new', as: :login
  match 'logout', to: 'user_sessions#destroy', as: :logout

  match 'search', to: 'search#index', as: :search
  match 'search/company/do', to: 'search#search_company', as: :search_company

  match 'reports', to: 'report#index', as: :reports

  match 'reports/by_agent', to: 'report#by_agent', as: :report_by_agent
  match 'reports/prepare_by_agent', to: 'report#prepare_by_agent', as: :report_prepare_by_agent,
      :via => :post

  match 'reports/company_by_rubric', to: 'report#company_by_rubric', as: :report_company_by_rubric
  match 'reports/company_by_rubric/export/:format', to: 'report#company_by_rubric_export',
      as: :report_company_by_rubric_export, :via => :get
  match 'reports/prepare_company_by_rubric', to: 'report#prepare_company_by_rubric',
      as: :report_prepare_company_by_rubric, :via => :post

  match 'reports/company_by_street', to: 'report#company_by_street', as: :report_company_by_street
  match 'reports/company_by_street/export/:format', to: 'report#company_by_street_export',
      as: :report_company_by_street_export, :via => :get
  match 'reports/prepare_company_by_street', to: 'report#prepare_company_by_street',
      as: :report_prepare_company_by_street, :via => :post

  match 'streets_by_city', to: 'streets#streets_by_city', as: :streets_by_city
  match 'streets/export/:format', to: 'streets#streets_by_city_export',
      as: :streets_by_city_export, :via => :get



end
