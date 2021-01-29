# frozen_string_literal: true

require "rubygems"
require "dotenv/load"
require "bundler"
Bundler.require(:default)

require_relative "app/objects/coffee_bot"
CoffeeBot.logger = Logger.new($stdout)

require_relative "config/initializers/rom"

class CoffeeBotCommands < Thor # :nodoc:
  desc "start", "foo"
  def start
    CoffeeBot::Bot.run
  end
end

CoffeeBotCommands.start(ARGV)
