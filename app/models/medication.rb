class Medication
    include ActiveModel::Validations
    include ActiveModel::Validations::Callbacks
    include ActiveModel::Serializers::JSON
    include ActiveModel::Model

    ATTRIBUTES = [:medicine_name, :dosage_dose_amount, :dosage_dose_unit, :dosage_frequency_value, :dosage_frequency_unit, :dosage_duration_value, :dosage_duration_unit, :still_active]
    attr_accessor(*ATTRIBUTES)
    
    # validators for each attributes
    validates_presence_of(*ATTRIBUTES)
    validates_inclusion_of :active, in: [true, false]

    before_validation :set_date_modified, on: [:create, :update]
    
    def set_date_modified
        self.date_modified = Date.current
    end

    def attributes
        instance_values
    end
end