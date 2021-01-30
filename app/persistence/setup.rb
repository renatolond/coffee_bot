# frozen_string_literal: true

require "rom"
require "rom-sql"

require_relative "repositories/groups"
require_relative "repositories/past_pairs"
require_relative "repositories/users"

# This module contains all db-related logic
module Persistence
  def self.config
    @config ||= ROM::Configuration.new(:sql, ENV.fetch("DATABASE_URL"))
  end

  def self.db
    @db ||= config.gateways[:default]
  end

  def self.rom
    raise "not finalized" unless instance_variable_defined?(:@rom)

    @rom
  end

  def self.finalize
    @rom ||= begin
      config.auto_registration __dir__
      container = ROM.container(config)
      container.gateways[:default].use_logger(::CoffeeBot.logger)
      container.gateways[:default].connection.sql_log_level = :debug
      container
    end

    true
  end

  class UnknownRepositoryError < StandardError; end

  REPOSITORIES = {
    groups: Repositories::Groups,
    past_pairs: Repositories::PastPairs,
    users: Repositories::Users
  }.freeze

  def self.repository(name)
    raise UnknownRepositoryError, "Unknown repository name=#{name}" unless REPOSITORIES.key? name

    Thread.current[:repositories] ||= {}
    Thread.current[:repositories][name] ||= REPOSITORIES[name].new(rom)
  end
end
