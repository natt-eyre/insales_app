InsalesApp::Application.routes.draw do
  root to: 'main#index'

  resource  :session do
    collection do
      get :autologin
    end
  end
  

  get '/install',   to: 'insales_app#install',   as: :install
  get '/uninstall', to: 'insales_app#uninstall', as: :uninstall
  get '/login',     to: 'sessions#new',          as: :login
  get '/main',      to: 'main#index',            as: :main
  get '/products',  to: 'products#index',        as: :products
  get '/update_products_list', to: 'products#create', as: :update_products_list

  get ':controller/:action/:id'
  get ':controller/:action/:id.:format'
end
