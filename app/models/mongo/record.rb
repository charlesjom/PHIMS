class Record
	include Mongoid::Document
	include Mongoid::Timestamps::Created
	
	## Associations with other models
	has_many :share_keys
	
	field :file_key, type: String
	field :object_key, type: String

	validates_presence_of :file_key, :object_key, :date_created

	# TODO: method for sharing records to other users
	def generate_share_key(user_id, user_pub_key)
		# TODO: algorithm for generating share_key
	end
end
