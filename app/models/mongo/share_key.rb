class ShareKey
	include Mongoid::Document
	include Mongoid::Timestamps::Created

	belongs_to :record
	belongs_to :user

	field :share_key, type: String

	validates_presence_of :share_key
end
