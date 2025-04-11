module RedmineLinways
  module Api
    class BaseController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authenticate_with_api_key
      
      respond_to :json
      
      protected
      
      def authenticate_with_api_key
        api_key = request.headers['X-Redmine-API-Key'] || params[:key]
        user = User.find_by_api_key(api_key)
        
        if user
          User.current = user
        else
          render json: { error: 'Unauthorized' }, status: :unauthorized
        end
      end
    end
  end
end