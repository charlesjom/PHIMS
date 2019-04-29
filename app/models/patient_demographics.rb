class PatientDemographics
    include ActiveModel::Validations
    include ActiveModel::Serializers::JSON
    include ActiveModel::Model
    
    attr_accessor :sex, :birthdate, :civil_status, :street_address, :barangay, :city, :state_or_province, :country, :weight_in_kg, :height_in_cm, :abo_blood_type, :rh_blood_type

    SEX_CHOICES = %w( Male Female Intersex ).freeze
    CIVIL_STATUS_CHOICES = %w( Single Married Separated Widowed ).freeze
    ABO_BLOOD_TYPES = %w( A B AB O ).freeze
    RH_BLOOD_TYPES = %w( + - ).freeze

    with_options allow_blank: true do |v|
        v.validates_inclusion_of :sex, in: SEX_CHOICES
        v.validates_inclusion_of :civil_status, in: CIVIL_STATUS_CHOICES
        v.validates_numericality_of :weight_in_kg, :height_in_cm
        v.validates_inclusion_of :abo_blood_type, in: ABO_BLOOD_TYPES
        v.validates_inclusion_of :rh_blood_type, in: RH_BLOOD_TYPES
        v.validates_date :birthdate, :on_or_before => :today
    end
    validates_presence_of :abo_blood_type, :if => lambda { self.rh_blood_type.present? }

    def attributes
        instance_values
    end
end