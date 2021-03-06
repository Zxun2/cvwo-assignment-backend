Rails.application.routes.draw do
  # In our route definition, we’re creating todo resource with a nested items resource. This enforces the 1:m (one to many) associations at the routing level.
  resources :todos do
    resources :items
  end

  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'

  post 'auth/auto_login', to: 'authentication#auto_login'

  get 'allitems', to: 'todos#all_items'

end