class RenamePublicFileKeyToEncryptedFileKeyInUserRecord < ActiveRecord::Migration[5.2]
  def change
    rename_column :user_records, :public_file_key, :encrypted_file_key
  end
end
