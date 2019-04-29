class PersonalData
    include ActiveModel::Serializers::JSON
    include ActiveModel::Validations
    include ActiveModel::Model
    extend ActiveModel::Naming
    extend ActiveModel::Callbacks

    include HasManageableFile

    attr_accessor :patient_demographics, :emergency_contacts, :insurances
    attr_reader :errors

    ## Associations with other models
    ## TODO: need to fix association with user
    # belongs_to :user, foreign_key: "owner"

    def initialize(attributes = {})
        super
        attributes.each do |name, value|
            send("#{name}=", value)
        end
    end

    def save
        # TODO: validation goes here
        run_callbacks :save
    end
    

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