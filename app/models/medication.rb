class Medication
    include ActiveModel::Validations
    include ActiveModel::Serializers::JSON
    include ActiveModel::Model

    attr_accessor :medicine_name, :dosage_amount_value, :dosage_amount_unit, :dosage_frequency_value, :dosage_frequency_unit, :frequency, :still_active, :date_modified
    
    # validators for each attributes
    validates_presence_of :medicine_name, :dosage_amount_value, :dosage_amount_unit, :dosage_frequency_value, :dosage_frequency_unit, :frequency, :still_active, :date_modified
    validates_inclusion_of :active, in: [true, false]

    before_validation :set_date_modified, on: [:create, :update]
    
    def set_date_modified
        self.date_modified = Date.current
    end

    def attributes
        instance_values
    end
end