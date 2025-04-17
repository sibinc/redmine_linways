module RedmineLinways
  module Api
    module V1
      class IssuesController < BaseController
        before_action :find_issue
        before_action :check_visibility
        
        def allowed_statuses
          statuses = @issue.new_statuses_allowed_to(User.current)
          
          render json: {
            issue_id: @issue.id,
            current_status: {
              id: @issue.status.id,
              name: @issue.status.name
            },
            allowed_next_statuses: statuses.map { |s| { id: s.id, name: s.name } }
          }
        end
        
        private
        
        def find_issue
          @issue = Issue.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'Issue not found' }, status: :not_found
        end
        
        def check_visibility
          Rails.logger.info "API Access attempt: User #{User.current.login} (#{User.current.id}) trying to access issue ##{@issue.id} in project #{@issue.project.identifier}"
          Rails.logger.info "User roles: #{User.current.roles_for_project(@issue.project).map(&:name).join(', ')}"
          Rails.logger.info "Issue visible? #{@issue.visible?(User.current)}"
          
          # DEBUG SETTING: Set this to true temporarily to bypass visibility check
          bypass_visibility_check = false
          
          if bypass_visibility_check
            Rails.logger.warn "WARNING: Bypassing visibility check for debugging purposes"
            return
          end
          
          unless @issue.visible?(User.current)
            Rails.logger.warn "API Access denied: User #{User.current.login} (#{User.current.id}) does not have access to issue ##{@issue.id}"
            render json: { 
              error: 'Access denied',
              details: {
                user: User.current.login,
                issue_id: @issue.id,
                project: @issue.project.identifier,
                reason: 'Issue is not visible to this user'
              }
            }, status: :forbidden
          end
        end
      end
    end
  end
end