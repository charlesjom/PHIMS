class PersonalDemographics
    include ActiveModel::Validations
    include ActiveModel::Serializers::JSON
    include ActiveModel::Model
    
    ATTRIBUTES = [:sex, :birthdate, :civil_status, :street_address, :barangay, :city, :state_or_province, :country, :weight_in_kg, :height_in_cm, :abo_blood_type, :rh_blood_type]
    attr_accessor(*ATTRIBUTES)

    SEX_CHOICES = %w( Male Female Intersex ).freeze
    CIVIL_STATUS_CHOICES = %w( Single Married Separated Widowed ).freeze
    ABO_BLOOD_TYPES = %w( A B AB O ).freeze
    RH_BLOOD_TYPES = %w( + - ).freeze

    validates_presence_of(*ATTRIBUTES)
    validates_inclusion_of :sex, in: SEX_CHOICES
    validates_inclusion_of :civil_status, in: CIVIL_STATUS_CHOICES
    validates_numericality_of :weight_in_kg, greater_than: 0, less_than: 200
    validates_numericality_of :height_in_cm, greater_than: 0, less_than: 400
    validates_inclusion_of :abo_blood_type, in: ABO_BLOOD_TYPES
    validates_inclusion_of :rh_blood_type, in: RH_BLOOD_TYPES
    validates_date :birthdate, :on_or_before => :today

    def attributes
        instance_values
    end
end