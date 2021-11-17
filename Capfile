
# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

require 'capistrano/bundler'
require 'capistrano/rails'
# require 'capistrano/passenger'

require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# If you are using rvm add these lines:
require 'capistrano/rvm'

set :rvm_type, :user
set :rvm_ruby_version, '2.7.2'

# require 'capistrano/rbenv'

# set :rbenv_type, :user # or :system, depends on your rbenv setup
# set :rbenv_ruby, '2.7.2'

# Includes tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#
# require 'capistrano/rvm'
# require 'capistrano/rbenv'
# require 'capistrano/chruby'
# require 'capistrano/bundler'
# require 'capistrano/rails/assets'
# require 'capistrano/rails/migrations'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
