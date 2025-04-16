module RedmineLinways
  module Api
    class BaseController < ApplicationController
      before_action :authenticate_with_api_key
      before_action :set_cors_headers
      
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

      # Add CORS headers to allow cross-origin requests
      def set_cors_headers
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, PATCH, DELETE, OPTIONS'
        headers['Access-Control-Allow-Headers'] = 'Content-Type, X-Redmine-API-Key'
      end
    end
  end
end