require 'redmine_linways/version'

module RedmineLinways
  # Hook listeners can be registered here
  # class Hooks < Redmine::Hook::ViewListener
  # end

  # API debugging module
  module ApiDebug
    def self.log_request_details(controller)
      return unless defined?(Rails.logger)
      
      issue = controller.instance_variable_get(:@issue)
      user = User.current
      
      Rails.logger.info "----- LinwaysAPI Debug -----"
      Rails.logger.info "Time: #{Time.now}"
      Rails.logger.info "User: #{user.login} (ID: #{user.id}), Admin: #{user.admin?}"
      
      if issue
        Rails.logger.info "Issue: ##{issue.id}, Project: #{issue.project.identifier}"
        Rails.logger.info "Issue Status: #{issue.status.name}"
        Rails.logger.info "Issue Author: #{issue.author.login}" if issue.author
        Rails.logger.info "Issue Assignee: #{issue.assigned_to.login}" if issue.assigned_to
        Rails.logger.info "Issue Private?: #{issue.is_private?}"
        Rails.logger.info "Project Public?: #{issue.project.is_public?}"
        Rails.logger.info "User Member of Project?: #{issue.project.is_member?(user)}"
        Rails.logger.info "User Roles: #{user.roles_for_project(issue.project).map(&:name).join(', ')}"
        
        # Test different visibility scenarios
        Rails.logger.info "Issue visible? (Normal): #{issue.visible?(user)}"
        
        # Check each permission manually
        visibility_message = if !user.active?
          "User is not active"
        elsif user.admin?
          "User is admin (should have access)"
        elsif issue.is_private? && !user.allowed_to?(:view_private_issues, issue.project)
          "Issue is private and user can't view private issues"
        elsif !issue.project.is_public? && !user.member_of?(issue.project) 
          "Project is private and user is not a member"
        else
          "Should be visible (check other permissions)"
        end
        
        Rails.logger.info "Visibility check result: #{visibility_message}"
      end
      
      Rails.logger.info "---------------------------"
    end
  end

  # Require other dependencies
  require 'redmine_linways/version'
end

# Load controllers, patches, etc.
Dir.glob(File.join(File.dirname(__FILE__), 'redmine_linways/**/*.rb')).each do |file|
  # Skip version.rb as it's already required above
  next if file.end_with?('version.rb')
  require_dependency file
end

# Patch controllers with debug functionality
Rails.configuration.to_prepare do
  # Only include in development/production environments, not in test
  unless Rails.env.test?
    if defined?(RedmineLinways::Api::V1::IssuesController)
      RedmineLinways::Api::V1::IssuesController.class_eval do
        before_action -> { RedmineLinways::ApiDebug.log_request_details(self) }, only: [:allowed_statuses]
      end
    end
  end
end