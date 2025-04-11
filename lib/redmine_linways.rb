module RedmineLinways
  # Hook listeners can be registered here
  # class Hooks < Redmine::Hook::ViewListener
  # end

  # Require other dependencies
  require 'redmine_linways/version'
end

# Load controllers, patches, etc.
Dir.glob(File.join(File.dirname(__FILE__), 'redmine_linways/**/*.rb')).each do |file|
  require_dependency file
end