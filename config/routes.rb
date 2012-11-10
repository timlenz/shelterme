ShelterMe::Application.routes.draw do

  get "pet_videos/new"

  get "pet_photos/new"

  get "shelter_admins/new"

  get "pet_media/new"

  get "favorites/new"

  get "bonds/new"

  get "addresses/new"

  get "password_resets/new"

  resources :users do
    member do
      get :following, :followers
      get :watching
      get :boosting
      get :managing
    end
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :password_resets
  resources :pet_photos
  resources :pet_videos
  resources :shelters
  resources :pets do
    get :autocomplete_shelter_name, :on => :collection
  end
  resources :bonds, only: [:create, :destroy]
  resources :favorites, only: [:create, :destroy]
  resources :shelter_admins
  resources :breeds
  resources :searches

  root to: 'static_pages#home'
  
  match '/addphoto',    to: 'pet_photos#new'
  match '/crop',        to: 'pet_photos#crop'
  
  match '/addvideo',    to: 'pet_videos#new'
  
  match '/s',           to: 'shelters#index'
  match '/shelters',    to: 'shelters#index'
  match '/s/new',       to: 'shelters#new'
  match '/s/:id',       to: 'shelters#show'
  match '/findshelter', to: 'shelters#find'
  match '/listshelters', to: 'shelters#list'
  
  match '/p',           to: 'pets#index'
  match '/addpet',      to: 'pets#addpet'
  match '/newpet',      to: 'pets#new'
  match '/p/:id',       to: 'pets#show'
  match '/findpet',     to: 'searches#new'
  match '/searches/:id', to: 'searches#new'
  match '/potd',        to: 'pets#potd'
  
  match '/signup',      to: 'users#new'
  match '/signin',      to: 'sessions#new'
  match '/matchme',     to: 'users#matchme'
  match '/signout',     to: 'sessions#destroy', via: :delete
  
  match '/u',           to: 'users#index'
  match '/users',       to: 'users#index'
  match '/u/:id',       to: 'users#show'
  match '/sponsored',   to: 'users#sponsored'
  match '/followed',    to: 'users#followed'
  match '/activity',    to: 'users#activity'
  
  match '/sa',          to: 'shelter_admins#index'
  
  match '/help',        to: 'static_pages#help'
  match '/about',       to: 'static_pages#about'
  match '/contact',     to: 'static_pages#contact'
  match '/faq',         to: 'static_pages#faq'
  match '/terms',       to: 'static_pages#terms'
  match '/privacy',     to: 'static_pages#privacy'
  match '/statistics',  to: 'static_pages#statistics'

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
  # match ':controller(/:action(/:id))(.:format)'
end
