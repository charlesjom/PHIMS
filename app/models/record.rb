class Record
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  belongs_to :user

  field :encrypted_file_key, type: String
  # field for type of record
  field :user_with_access, type: Array, default: []
  field :storage_url, type: String

  validates_presence_of :encrypted_file_key, :date_created, :user_with_access, :storage_url
end
