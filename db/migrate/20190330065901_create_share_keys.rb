class CreateShareKeys < ActiveRecord::Migration[5.2]
  def change
    create_table :share_keys do |t|
      t.string  :share_key
      t.references :user, index: true
      t.references :user_record, index: true

      t.datetime :created_at, null: false
    end
  end
end
