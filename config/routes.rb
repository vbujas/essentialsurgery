Rails.application.routes.draw do
  resources :bugs

  resources :stories

  get 'home/index'

  devise_for :users, :controllers => {   :sessions => "sessions" }

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  # You can have the root of your site routed with "root"
  # root 'doctors#edit'

  root 'home#drdensity'
  get '/docheckpassword' => 'home#docheckpassword'
  get '/check_pwd' => 'home#check_pwd'
  get  '/drdensity'  => 'home#drdensity'
  get  '/drspecialty'  => 'home#drspecialty'
  get  '/drgender'  => 'home#drgender'
  get  '/about'  => 'home#about'
  get  '/contact'  => 'home#contact'
  get  '/privacy'  => 'home#privacy'
  get  '/citiesw'  => 'reports#csvdrdensity'
  get  '/countriesw'  => 'reports#csvdrbycountry'
  get  '/bygender'  => 'reports#geojsondrbygender'
  get  '/genderbydistrict'  => 'reports#genderbydistrict'
  get  '/geojson'  => 'reports#geojson'
  get  '/geojsonprovinces'  => 'reports#geojsonprovinces'
  get  '/geojsoncities'  => 'reports#geojsoncities'
  get  '/byspecialty'  => 'reports#csvdrbyspecialty'
  get  '/euaus'  => 'reports#euaus'
  get  '/docsbycity'  => 'reports#docsbycity'
  get  '/hospitalsbycountry'  => 'reports#hospitalsbycountry'
  get  '/docsbydistrict'  => 'reports#docsbydistrict' 
  get  '/alldocsforcluster'  => 'reports#alldocsforcluster' 
  get  '/searchorgs'  => 'reports#searchorgs' 
  get  '/alldocsforclustergeojson'  => 'reports#alldocsforclustergeojson' 
  get  '/mapcities'  => 'reports#mapcities'
  get  '/specialtybydistrict' => 'reports#specialtybydistrict'
  get  '/docsbyorganisations' => 'reports#docsbyorganisations'
  get  '/docsbyorganisationsgeojson' => 'reports#docsbyorganisationsgeojson'
  get  '/refreshdistricts'  => 'reports#refreshdistricts'
  get  '/refreshcountries'  => 'reports#refreshcountries'
  get  '/ngospercountry'  => 'ngos#ngospercountry'
  get  '/statspercountry'  => 'stats#statspercountry'
  get  '/statsforoverlay'  => 'stats#statsforoverlay'
  get  '/correctcoordinates'  => 'reports#correctcoordinates'
  get  '/getngosforcountry' => 'ngos#getngosforcountry'
  get  'doctors/:id/update_cities' => 'doctors#update_cities', as: 'update_cities'
  post '/bugs/create' => 'bugs#create'
  get 'populaterawtable' => 'ngos#populaterawtable'
  get 'findcountrycode' => 'ngos#findcountrycode'
  get 'getngodetails' =>  'ngos#getngodetails'
  ###########################################################################
  # ETL functions
  ###########################################################################
 get '/extractdistrictsnames'  => 'etl#extractdistrictsnames'
 get '/addethiopia' => 'etl#addethiopia'
 get '/deleteukfraaus'  => 'etl#deleteukfraaus'

 ###########################################################################
  # IMPORT functions
  ###########################################################################
  post '/import'  => 'drive#import'
  # Example of regular route:
  # get 'products/:id' => 'catalog#view'
  # Example of named route that can be invoked with purchase_url(id: product.id)
  # get 'products/:id/purchase' => 'catalog#purchase', as: :purchase
  # Example resource route (maps HTTP verbs to controller actions automatically):
  # resources :products
  # Example resource route with options:
  # resources :products do
  # member do
  # get 'short'
  # post 'toggle'
  # end
  #
  # collection do
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
  #   Example resource route within a namespace:
  #   namespace :admin do
  #   # Directs /admin/products/* to Admin::ProductsController
  #   # (app/controllers/admin/products_controller.rb)
  #   resources :products
  #   end
  resources :drive
  resources :doctors
  resources :updates
  resources :specialties
  resources :cities
  resources :countries
  resources :districts
  resources :ngos
  resources :organisations
  resources :users
end