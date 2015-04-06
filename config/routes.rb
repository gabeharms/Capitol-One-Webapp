Rails.application.routes.draw do
  
  post 'update' => 'tickets#api_create'

  
  post '/rate' => 'rater#create', :as => 'rate'
  get 'employee_sessions/new'

  get 'user_sessions/new'

  #get 'customers/new'

 # get 'password_resets/new'

  #get 'password_resets/edit'

  
  #get 'sessions/new'

  #get 'users/new'

  root 'customer_sessions#new'
  
  get 'help'    => 'static_pages#help'
  get 'about'   => 'static_pages#about'
  get 'contact' => 'static_pages#contact'

  get 'create_ticket' => 'employees#create_ticket'
  get 'customer_info' => 'customers#show_info'
  
  get 'customer_signup'  => 'customers#new'
  get 'employee_signup'  => 'employees#new'
  get 'employee_tickets' => 'employees#display_tickets'
  post 'update_status' => 'tickets#update_status'
  post 'update_employee_on_ticket' => 'tickets#update_employee_on_ticket'
  
  get    'customer_login'   => 'customer_sessions#new'
  post   'customer_login'   => 'customer_sessions#create'
  delete 'customer_logout'  => 'customer_sessions#destroy'
  
  get    'employee_login'   => 'employee_sessions#new'
  post   'employee_login'   => 'employee_sessions#create'
  delete 'employee_logout'  => 'employee_sessions#destroy'

  delete 'destroy_comment'   => 'comments#destroy'

  get 'statistics' => 'employees#display_statistics'
#  get 'signup'  => 'users#new'
  
  post 'customer_show'   => 'customers#show'
  
  get    'customer_show_info'   => 'customers#show_info'
  
  get    'customer_edit_info'     => 'customers#edit_info'
  get    'customer_edit_password' => 'customers#edit_password'

  get    'employee_edit_info'     => 'employees#edit_info'
  get    'employee_edit_password' => 'employees#edit_password'

  
#  get    'login'   => 'sessions#new'
#  post   'login'   => 'sessions#create'
#  delete 'logout'  => 'sessions#destroy'
  
  
   resources :customers #do                                   # Automatically ensures that our Rails application responds to the RESTful URLs
   resources :employees
#    member do
#      get :following, :followers
#    end
#  end
  
#  resources :account_activations, only: [:edit] 
#  resources :password_resets,     only: [:new, :create, :edit, :update]
   resources :tickets,          only: [:create, :destroy, :show, :update]
   resources :comments,          only: [:create, :destroy]
#  resources :relationships,       only: [:create, :destroy]
  
  

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
