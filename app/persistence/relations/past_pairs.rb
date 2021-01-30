# frozen_string_literal: true

module Persistence
  module Relations
    class PastPairs < ROM::Relation[:sql]
      schema(:past_pairs, infer: true)
    end
  end
end
