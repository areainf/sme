Rails.application.routes.draw do

  get 'helps' => 'helps#index'

  resources :authorities do
    collection do
      get 'documents'
    end
  end

  resources :temporary_notes

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :events

  resources :dependencies

  resources :master_units

  resources :people

  resources :employments
  resources :entities do
    member do
      put 'update_active'
    end
  end

  resources :notes do
    collection do
      get 'enter'
    end
  end
  resources :folders do
    collection do
      post 'move'
      # post 'move_document'
    end
  end
  
  resources :documents do
    collection do
      post 'move'
      get 'in_folder'
    end
  end
  


#+m
  root 'landing#index'


  devise_for :users, path: "sessions", path_names: { sign_in: 'login', sign_out: 'logout' }

 ##resources :users
  resource :users, only: [:edit] do
    collection do
      patch 'update_password'
    end 
  end
  # devise_scope :user do
  #   root to: 'devise/sessions#new'
  # end

  # devise_for :users

  # get '/landing_page', to: 'landing#index'




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
