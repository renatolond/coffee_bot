# frozen_string_literal: true

module Persistence
  module Relations
    class Users < ROM::Relation[:sql]
      schema(:users, infer: true) do
        associations do
          belongs_to :group
        end
      end
    end
  end
end
