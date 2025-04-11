# Load the Redmine helper
require File.expand_path('../../../test/test_helper', __FILE__)

# Ensure plugin test fixtures are loaded
ActiveSupport::TestCase.fixture_path = File.dirname(__FILE__) + '/fixtures'

# Load fixtures from redmine fixtures directory
fixtures = [:users, :issues, :issue_statuses, :projects, :roles, :members, :member_roles]

# Setup test fixtures
class ActiveSupport::TestCase
  self.use_transactional_tests = true
  fixtures fixtures
end