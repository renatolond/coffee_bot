# frozen_string_literal: true

require "dotenv/load"
require "rom/sql/rake_task"
require_relative "app/persistence/setup"

task :default do
  system 'rake -T'
end

namespace :db do
  task :setup do
    ROM::SQL::RakeSupport.env = ROM.container(Persistence.config)
  end
end
