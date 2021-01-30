# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :past_pairs do
      primary_key :id
      column :complete_draw, :jsonb, null: false
      column :created_at, :timestamp, null: false
    end
  end
end
