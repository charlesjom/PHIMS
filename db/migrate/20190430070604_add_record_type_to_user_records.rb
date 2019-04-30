class AddRecordTypeToUserRecords < ActiveRecord::Migration[5.2]
  def up
    add_column :user_records, :phr_type, :string
  end

  def down
    remove_column :user_records, :phr_type, :string
  end
end
