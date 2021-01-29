# frozen_string_literal: true

module Persistence
  module Relations
    class Groups < ROM::Relation[:sql]
      schema(:groups, infer: true) do
        associations do
          has_many :users
        end
      end
    end
  end
end
