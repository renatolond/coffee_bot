# frozen_string_literal: true

require "rubygems"
require "dotenv/load"
require "bundler"
Bundler.require(:default)

require_relative "app/objects/coffee_bot"
CoffeeBot.logger = Logger.new($stdout)

require_relative "config/initializers/rom"
require_relative "app/services/draw_coffee_pairs_service"

class CoffeeBotCommands < Thor # :nodoc:
  desc "start", "foo"
  def start
    CoffeeBot::Bot.run
  end

  desc "draw", "foo"
  def draw
    DrawCoffeePairsService.new.draw
  end
end

CoffeeBotCommands.start(ARGV)
