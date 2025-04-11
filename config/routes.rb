# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  # API v1 routes
  namespace :redmine_linways do
    namespace :api do
      namespace :v1 do
        resources :issues, only: [] do
          member do
            get :allowed_statuses
          end
        end

        # Additional resources can be added here
        # resources :projects, only: [:index, :show] do
        #   # Project specific routes
        # end
      end
      
      # Future API versions can be added here
      # namespace :v2 do
      #   # V2 API resources
      # end
    end
  end
  
  # Legacy route to support existing implementations
  # This will be deprecated in a future release
  get 'lin_custom_api/allowed_statuses/:id', to: 'redmine_linways/api/v1/issues#allowed_statuses', defaults: { format: 'json' }
  options 'lin_custom_api/allowed_statuses/:id', to: proc { [204, {
    'Access-Control-Allow-Origin' => '*',
    'Access-Control-Allow-Methods' => 'GET, OPTIONS',
    'Access-Control-Allow-Headers' => 'Content-Type, X-Redmine-API-Key'
  }, []] }
  
  # Define CORS headers for the new API
  match 'redmine_linways/api/v1/*path', to: proc {
    [204, {
      'Access-Control-Allow-Origin' => '*',
      'Access-Control-Allow-Methods' => 'GET, POST, PUT, PATCH, DELETE, OPTIONS',
      'Access-Control-Allow-Headers' => 'Content-Type, X-Redmine-API-Key'
    }, []]
  }, via: :options
end