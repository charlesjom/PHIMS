class InsuranceProvider
    include ActiveModel::Model
    include ActiveModel::Validations
    include ActiveModel::Serializers::JSON

    attr_accessor :target_disease, :date_administered
    
    validates_presence_of :target_disease, :date_administered

    # TODO validator for date administered
    # should be before today
end