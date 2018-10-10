class PatientDemographics
    include ActiveModel::Model
    include ActiveModel::Validations
    include ActiveModel::Serializers::JSON
    
    attr_accessor :sex, :birthdate, :civil_status, :street_address, :barangay, :city, :state_or_province, :country, :weight_in_kg, :height_in_cm, :abo_blood_type, :rh_blood_type

    SEX_CHOICES =  %w( M F )
    SEX_CHOICES.freeze
    CIVIL_STATUS_CHOICES = %w( Single Married Separated Widowed )
    CIVIL_STATUS_CHOICES.freeze
    ABO_BLOOD_TYPES = %w( A B AB O Unknown )
    ABO_BLOOD_TYPES.freeze
    RH_BLOOD_TYPES = %w( + - Unknown )
    RH_BLOOD_TYPES.freeze

    # validators for each attributes
    validates_presence_of :sex, :civil_status, :birthdate, :street_address, :barangay, :city, :state_or_province, :country, :mass_in_kg, :height_in_cm, :abo_blood_type, :rh_blood_type
    validates_inclusion_of :sex, in: SEX_CHOICES
    validates_inclusion_of :civil_status, in: CIVIL_STATUS_CHOICES
    validates_numericality_of :weight_in_kg, :height_in_cm
    validates_inclusion_of :abo_blood_type, in: ABO_BLOOD_TYPES
    validates_inclusion_of :rh_blood_type, in: RH_BLOOD_TYPES
    validates_date :birthdate, :on_or_before => :today
end