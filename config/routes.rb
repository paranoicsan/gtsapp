Gtsapp::Application.routes.draw do

  resources :product_types
  resources :rubrics
  resources :streets
  resources :post_indices
  resources :districts
  resources :cities
  resources :form_types
  resources :project_codes

  get 'company/:id/autocomplete_rubric_name/', to: 'companies#autocomplete_rubric_name',
      as: :companies_autocomplete_rubric_name
  get 'addresses/autocomplete_city_name'
  get 'addresses/autocomplete_street_name/:city_id', to: 'addresses#autocomplete_street_name',
      as: :addresses_autocomplete_street_name
  get 'products/autocomplete_rubric_name/:contract_id', to: 'products#autocomplete_rubric_name',
      as: :products_autocomplete_rubric_name

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

  get 'branches/:id/make_main', to: 'branches#make_main', as: :branch_make_main

  get 'branches/:id/add_website', to: 'branches#add_website', as: :branch_add_website
  get 'branches/:id/delete_website/:website_id', to: 'branches#delete_website', as: :branch_delete_website

  get 'branches/:id/add_email', to: 'branches#add_email', as: :branch_add_email
  get 'branches/:id/delete_email/:email_id', to: 'branches#delete_email', as: :branch_delete_email

  get 'companies/:id/activate', to: 'companies#activate', as: :activate_company
  get 'companies/:id/archive', to: 'companies#archive', as: :archive_company
  get 'companies/:id/request_delete', to: 'companies#request_delete_reason',
      as: :company_request_delete
  get 'companies/:id/request_attention_reason', to: 'companies#request_attention_reason',
      as: :company_request_attention_reason
  get 'companies/:id/request_attention', to: 'companies#request_attention',
      as: :company_request_attention
  get 'companies/:id/request_improvement_reason', to: 'companies#request_improvement_reason',
      as: :company_request_improvement_reason
  get 'companies/:id/request_improvement', to: 'companies#request_improvement',
      as: :company_request_improvement
  get 'companies/:id/improve', to: 'companies#improve', as: :company_improve
  get 'companies/:id/queue_for_delete', to: 'companies#queue_for_delete', as: :company_queue_for_delete
  get 'companies/:id/unqueue_for_delete', to: 'companies#unqueue_for_delete',
      as: :company_unqueue_for_delete

  get 'companies/:id/add_rubric/:rub_id', to: 'companies#add_rubric', as: :company_add_rubric
  get 'companies/:id/delete_rubric/:rub_id', to: 'companies#delete_rubric',
      as: :company_delete_rubric
  get 'companies/validate_title', to: 'companies#validate_title', as: :company_validate_title

  get 'contracts/:id/activate', to: 'contracts#activate', as: :activate_contract

  resources :users
  resources :user_sessions

  get 'dashboard', to: 'dashboard#index', as: :dashboard
  get 'login', to: 'user_sessions#new', as: :login
  get 'logout', to: 'user_sessions#destroy', as: :logout

  get 'search', to: 'search#index', as: :search
  get 'search/company/do', to: 'search#search_company', as: :search_company

  get 'reports', to: 'report#index', as: :reports

  get 'reports/by_agent', to: 'report#by_agent', as: :report_by_agent
  get 'reports/prepare_by_agent', to: 'report#prepare_by_agent', as: :report_prepare_by_agent,
      :via => :post

  get 'reports/company_by_rubric', to: 'report#company_by_rubric', as: :report_company_by_rubric
  get 'reports/company_by_rubric/export/:format', to: 'report#company_by_rubric_export',
      as: :report_company_by_rubric_export, :via => :get
  get 'reports/prepare_company_by_rubric', to: 'report#prepare_company_by_rubric',
      as: :report_prepare_company_by_rubric, :via => :post

  get 'reports/company_by_street', to: 'report#company_by_street', as: :report_company_by_street
  get 'reports/company_by_street/export/:format', to: 'report#company_by_street_export',
      as: :report_company_by_street_export, :via => :get
  get 'reports/prepare_company_by_street', to: 'report#prepare_company_by_street',
      as: :report_prepare_company_by_street, :via => :post

  get 'streets_by_city', to: 'streets#streets_by_city', as: :streets_by_city
  get 'streets/export/:format', to: 'streets#streets_by_city_export',
      as: :streets_by_city_export, :via => :get

  root :to => 'user_sessions#new'

end
