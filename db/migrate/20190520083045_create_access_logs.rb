class CreateAccessLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :access_logs, id: :uuid do |t|
      t.references :user, index: true
      t.references :user_record, index: true
      t.references :share_key, index: true
      t.text :message

      t.timestamps null: false
    end
  end
end
