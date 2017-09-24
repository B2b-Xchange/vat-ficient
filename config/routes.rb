Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :orders do
    member do
      post 'deploy_cant_pay_email'
    end
    
    resources :payments do

    end
  end

  get 'payment/execute', to: 'payments#execute'
  get 'payment/cancel', to: 'payments#cancel'
  
  root 'orders#new'
end
