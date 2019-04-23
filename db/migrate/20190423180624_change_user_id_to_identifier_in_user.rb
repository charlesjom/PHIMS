class ChangeUserIdToIdentifierInUser < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :user_id, :identifier
  end
end
