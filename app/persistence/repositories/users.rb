# frozen_string_literal: true

module Persistence
  module Repositories
    class Users < ROM::Repository[:users] # :nodoc:
      def upsert(slack_id:, name:, present: true)
        now = Time.now
        values = {
          slack_id: slack_id,
          name: name,
          present: present,
          created_at: now,
          updated_at: now
        }
        config = {
          target: :slack_id,
          update: {
            name: Sequel.qualify(:excluded, :name),
            present: Sequel.qualify(:excluded, :present),
            updated_at: Sequel.qualify(:excluded, :updated_at)
          }
        }
        root.upsert(values, config)
      end

      def restart_users_in_channel(users)
        root.transaction do
          root.update(present: false)

          users.each do |u|
            upsert(**u)
          end
        end
      end
    end
  end
end
