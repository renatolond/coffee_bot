# frozen_string_literal: true

# This class draws coffee pairs and if successful sends them over slack
class DrawCoffeePairsService
  def draw
    groups_and_members = Persistence.repository(:groups).all_groups_and_members
    pairs = get_pairs(groups_and_members)
    message = "This week's random coffees are:\n"
    idx = 1
    pairs.each do |p|
      members = p.map { |u| "<@#{u.slack_id}>" }.join(" and ")
      pair_message = "#{idx}. #{members}"
      message = "#{message}#{pair_message}\n"
      idx += 1
    end

    web_client.chat_postMessage(text: message, channel: slack_channel, link_names: true, as_user: true)
  end

  private

    # This uses a rudimentary algorithm to try and figure out the pairs for coffee.
    # Here's the idea: Get the groups with more members, take a member out, shuffle until we get another group (if there's another), take a member of that group, pair them
    # Repeat until there's no more groups with users left. If there's only one user left in all groups, it gets added to the last pair
    def get_pairs(groups_and_members)
      pairs = []

      loop do
        break if members_left(groups_and_members).zero?

        if members_left(groups_and_members) == 1
          pairs[-1] << groups_and_members[0][:users][0]
          puts "Actually, pair! #{pairs[-1][0].name}, #{pairs[-1][1].name}, #{pairs[-1][2].name}"
          break
        end

        group = groups_and_members.max_by { |g| g[:users].size }
        first_member = group[:users].sample
        group[:users].delete(first_member)

        group2 = loop do
          g = groups_and_members.sample
          break g if g != group || groups_and_members.size == 1
        end

        second_member = group2[:users].sample
        group2[:users].delete(second_member)
        pairs << [first_member, second_member]

        groups_and_members.delete(group) if group[:users].empty?
        groups_and_members.delete(group2) if group2[:users].empty?
      end

      pairs
    end

    def members_left(groups_and_members)
      groups_and_members.map { |g| g[:users] }.map(&:size).sum
    end

    def slack_channel
      @slack_channel ||= ENV.fetch("SLACK_CHANNEL")
    end

    def web_client
      @web_client ||= Slack::Web::Client.new(token: ENV["SLACK_API_TOKEN"])
    end
end
