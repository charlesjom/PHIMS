class ShareKey < ApplicationRecord
    belongs_to :user
    belongs_to :user_record
    
    validates_presence_of :share_key
end