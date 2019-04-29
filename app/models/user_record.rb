class UserRecord < ApplicationRecord
    has_one_attached :file, dependent: :destroy
    has_many :share_keys

    validates_presence_of :encrypted_file_key, :encrypted_cipher_key, :encrypted_cipher_iv
end