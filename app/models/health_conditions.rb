class HealthCondition
    include ActiveModel::Model
    include ActiveModel::Validation
    include ActiveModel::Serializers::JSON

    attr_accessor :name_of_condition, :date_of_diagnosis, :date_of_last_checkup

    # validators for each attributes
    validates_presence_of :name_of_condition, :date_of_diagnosis, :date_of_last_checkup
    validates_date :date_of_diagnosis, :on_or_before => :today
    validates_date :date_of_last_checkup, :on_or_before => :today
end