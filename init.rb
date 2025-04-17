require 'redmine'

# Add lib directory to load path
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'redmine_linways/version'

Redmine::Plugin.register :redmine_linways do
  name 'Redmine Linways API'
  author 'Sibin C'
  description 'Custom API extensions for Redmine by Linways'
  version RedmineLinways::Version::STRING
  url 'https://github.com/sibinc/redmine_linways'
  author_url 'https://github.com/sibinc'
  
  # Add API permissions
  project_module :issue_tracking do
    permission :view_allowed_statuses, { "redmine_linways/api/v1/issues": [:allowed_statuses] }
  end
end

# Patches to the Redmine core
require_relative 'lib/redmine_linways'