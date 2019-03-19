class PersonalData
    include ActiveModel::Model
    include ActiveModel::Serializers::JSON
    include ActiveModel::Validations
    extend ActiveModel::Naming

    # def initialize
    #     @errors = ActiveModel::Errors.new(self)
    # end

    attr_accessor :patient_demographics, :emergency_contacts, :insurances
    attr_reader :errors

    def initialize(attributes = {})
        # @errors = ActiveModel::Errors.new(self)
        attributes.each do |name, value|
            send("#{name}=", value)
        end
    end

    ## Associations with other models
    ## TODO: need to fix association with user
    # belongs_to :user, foreign_key: "owner"
    

    def patient_demographics_attributes=(attributes)
        @patient_demographics = PatientDemographics.new(patient_demographics_params)
    end

    def emergency_contacts_attributes=(attributes)
        @emergency_contacts ||= []
        attributes.each do |i, emergency_contact_params|
            @emergency_contacts.push(EmergencyContact.new(emergency_contact_params))
        end
    end

    def insurances_attributes=(attributes)
        @insurances ||= []
        attributes.each do |i, insurances|
            @insurances.push(Insurance.new(insurance_params))
        end
    end

    def attributes=(hash)
        hash.each do |key, value|
            send("#{key}=", value)
        end
    end
    
    def attributes
        instance_values
    end

    # Method for handling error messages
    def read_attribute_for_validation(attr)
        send(attr)
    end

    def self.human_attribute_name(attr, options = {})
        attr
    end

    def self.lookup_ancestors
        [self]
    end
end