# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'board_game_prototyper/dsl'
require 'rspec/its'
require 'pry'
require 'fakefs/spec_helpers'
require 'handlebars-engine'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# FakeFS do
#   fixtures = File.expand_path('spec/fixtures')
#   # handlebars = File.expand_path('/home/elim/.rvm/gems/ruby-3.1.3@board_game_prototyper-new/gems/handlebars-source-4.7.7/handlebars.js')

#   FakeFS::FileSystem.clone(fixtures)
#   # FakeFS::FileSystem.clone(handlebars)
# end
