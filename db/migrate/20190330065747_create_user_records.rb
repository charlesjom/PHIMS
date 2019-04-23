class CreateUserRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :user_records do |t|
      t.string  :public_file_key
      t.string  :encrypted_cipher_key
      t.string  :encrypted_cipher_iv
      t.references :user, index: true

      t.datetime :created_at, null: false
    end
  end
end
