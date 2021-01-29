# frozen_string_literal: true

module CoffeeBot
  # Class containing bot commands
  class Bot < SlackRubyBot::Bot
  end

  # Class containing hooks for events
  class Server < SlackRubyBot::Server
    on "hello" do |client, _data|
      channel = client.store.channels.find { |_id, c| c["name"] == ENV["SLACK_CHANNEL"] }
      users_in_channel = []
      channel.second.members&.each do |member_id|
        user = client.store.users[member_id]
        next if user.is_bot

        users_in_channel << { slack_id: member_id, name: user.profile.real_name }
      end

      Persistence.repository(:users).restart_users_in_channel(users_in_channel)
    end

    on "member_left_channel" do |client, data|
      next if client.channels[data.channel].name != ENV["SLACK_CHANNEL"]

      user = client.store.users[data.user]
      next if user.is_bot

      Persistence.repository(:users).upsert(slack_id: data.user, name: user.profile.real_name, present: false)
    end

    on "member_joined_channel" do |client, data|
      next if client.channels[data.channel].name != ENV["SLACK_CHANNEL"]

      user = client.store.users[data.user]
      next if user.is_bot

      Persistence.repository(:users).upsert(slack_id: data.user, name: user.profile.real_name, present: true)
    end
  end

  class << self
    attr_accessor :logger
  end
end
