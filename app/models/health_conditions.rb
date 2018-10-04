class HealthCondition
    include ActiveModel::Model
    include ActiveModel::Validation
    include ActiveModel::Serializers::JSON

    attr_accessor :name_of_condition, :date_of_diagnosis, :date_of_last_checkup

    # validators for each attributes
    validates_presence_of :name_of_condition, :date_of_diagnosis, :date_of_last_checkup

    # TODO validation for date_of_diagnosis, date_of_last_checkup
    # :date_of_diagnosis, :date_of_last_checkup should be on or before today
end