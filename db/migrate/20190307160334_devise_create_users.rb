# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false
      t.string :encrypted_password, null: false

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      # User Details
      t.string   :user_id,          null: false
      t.string   :username,         null: false
      t.string   :first_name,       default: nil
      t.string   :middle_name,      default: nil
      t.string   :last_name,        default: nil

      # User unique keys
      t.text     :public_key,               null: false
      t.text     :encrypted_private_key,   null: false

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
    add_index :users, :user_id,              unique: true
    add_index :users, :username,             unique: true
  end
end
