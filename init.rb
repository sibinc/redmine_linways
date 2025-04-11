require 'redmine'
require_dependency 'redmine_linways/version'

Redmine::Plugin.register :redmine_linways do
  name 'Redmine Linways API'
  author 'Sibin C'
  description 'Custom API extensions for Redmine by Linways'
  version RedmineLinways::VERSION
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
  
  # Add permissions if needed
  # permission :example_permission, { controller: actions }, read: true
end

# Patches to the Redmine core
require_relative 'lib/redmine_linways'