# frozen_string_literal: true

ROM::SQL.migration do
  up do
    create_table :groups do
      primary_key :id
      column :name, :varchar, null: false
    end

    run "INSERT INTO groups (id, name) VALUES (0, 'unknown')"

    create_table :users do
      primary_key :id
      foreign_key :group_id, :groups, null: false, default: 0
      column :slack_id, :varchar, null: false
      column :name, :varchar, null: false
      column :present, :boolean, null: false
      unique :slack_id
      column :created_at, :timestamp, null: false
      column :updated_at, :timestamp, null: false
    end
  end
  down do
    drop_table :users

    drop_table :groups
  end
end
