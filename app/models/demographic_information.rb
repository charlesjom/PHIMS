class DemographicInformation
    include ActiveModel::Model
    include ActiveModel::Validations
    
    attr_accessor :sex, :birthdate, :civil_status, :street_address, :barangay, :city, :state_or_province, :country, :mass_in_kg, :height_in_cm, :abo_blood_type, :rh_type

    # validators for each attributes
    validates_presence_of :sex, :civil_status, :birthdate, :street_address, :barangay, :city, :state_or_province, :country, :mass_in_kg, :height_in_cm, :abo_blood_type, :rh_type
    validates_inclusion_of :sex, in: %w( M F )
    validates_inclusion_of :civil_status, in: %w( Single Married Separated Widowed )
    validates_numericality_of :mass_in_kg, :height_in_cm
    validates_inclusion_of :abo_blood_type, in: %w( A B AB O )
    validates_inclusion_of :rh_type, in: %w( + - )
end