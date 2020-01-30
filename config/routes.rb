Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace 'api' do
    namespace 'v1' do
        get 'check', to: 'users#check'
        post 'callback', to: 'users#callback'
        patch 'name_update', to: 'users#name_update'
        resources :users do
          resources :household
          resources :expense
          get 'list_period', to: 'household#list_period'
          patch 'attend_group', to: 'users#attend_group'
        end

        resources :group
    end
  end
end
