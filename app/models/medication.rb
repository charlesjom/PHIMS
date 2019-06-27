class Medication
    include ActiveModel::Validations
    include ActiveModel::Validations::Callbacks
    include ActiveModel::Serializers::JSON
    include ActiveModel::Model

    ATTRIBUTES = [:medicine_name, :dosage_dose_amount, :dosage_dose_unit, :dosage_frequency_value, :dosage_frequency_unit, :dosage_duration_value, :dosage_duration_unit, :still_active]
    attr_accessor(*ATTRIBUTES)

    DOSE_UNITS = %w(milligram(s) teaspoon(s) tablespoon(s))
    FREQUENCY_UNITS = ["per day", "per week", "per month"]
    DURATION_UNITS = %w(day(s) week(s) month(s))
    
    # validators for each attributes
    validates_presence_of(*ATTRIBUTES)
    validates_inclusion_of :still_active, in: ["true", "false"]
    validates_numericality_of :dosage_dose_amount, :dosage_frequency_value, :dosage_duration_value
    validates_inclusion_of :dosage_dose_unit, in: DOSE_UNITS
    validates_inclusion_of :dosage_frequency_unit, in: FREQUENCY_UNITS
    validates_inclusion_of :dosage_duration_unit, in: DURATION_UNITS

    def attributes
        instance_values
    end
end