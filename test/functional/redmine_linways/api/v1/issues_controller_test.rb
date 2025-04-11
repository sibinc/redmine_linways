require File.expand_path('../../../../../test_helper', __FILE__)

class RedmineLinways::Api::V1::IssuesControllerTest < ActionController::TestCase
  fixtures :users, :issues, :projects, :roles, :members, :member_roles, :issue_statuses
  
  def setup
    @controller = RedmineLinways::Api::V1::IssuesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @user = User.find(2) # Usually a regular user with permissions
    @admin = User.find(1) # Admin user
    @issue = Issue.find(1) # An existing issue
    @api_key = @user.api_key || 'test_api_key'
  end
  
  def test_allowed_statuses_with_valid_api_key
    @request.headers['X-Redmine-API-Key'] = @api_key
    get :allowed_statuses, params: { id: @issue.id }
    assert_response :success
    json = ActiveSupport::JSON.decode(@response.body)
    assert_equal @issue.id, json['issue_id']
    assert_not_nil json['current_status']
    assert_not_nil json['allowed_next_statuses']
  end
  
  def test_allowed_statuses_with_invalid_api_key
    @request.headers['X-Redmine-API-Key'] = 'invalid_key'
    get :allowed_statuses, params: { id: @issue.id }
    assert_response :unauthorized
  end
  
  def test_allowed_statuses_with_nonexistent_issue
    @request.headers['X-Redmine-API-Key'] = @api_key
    get :allowed_statuses, params: { id: 99999 }
    assert_response :not_found
  end
end