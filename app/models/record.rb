class Record
	include Mongoid::Document
	include Mongoid::Timestamps::Created
	
	## Associations with other models
	has_many :share_keys

	field :encrypted_file_key, type: String
	field :storage_url, type: String

	validates_presence_of :encrypted_file_key, :date_created, :storage_url

	# TODOS
	# method for sharing records to other users
	def generate_share_key(user_id, user_pub_key)
		# algorithm for generating share_key
	end
end
