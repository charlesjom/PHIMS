class AccessLog < ApplicationRecord
    belongs_to :user
    belongs_to :user_record

    default_scope { order(created_at: :desc) }
end
