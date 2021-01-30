# frozen_string_literal: true

module Persistence
  module Repositories
    class PastPairs < ROM::Repository[:past_pairs] # :nodoc:
      commands :create

      def last_draws(limit: 3)
        root.order { created_at.desc }.limit(limit).select(:complete_draw).to_a
      end
    end
  end
end
