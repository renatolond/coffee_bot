# frozen_string_literal: true

module Persistence
  module Repositories
    class Groups < ROM::Repository[:groups] # :nodoc:
      def all_groups_and_members
        groups = root.to_a
        groups.map! do |g|
          u = users.where(group_id: g.id, present: true).to_a
          g = g.to_h
          g[:users] = u
          next nil if g[:users].empty?

          g
        end
        groups.compact
      end
    end
  end
end
