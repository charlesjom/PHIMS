class PersonalData
    include ActiveModel::Serializers::JSON
    include ActiveModel::Validations
    include ActiveModel::Model
    extend ActiveModel::Naming
    extend ActiveModel::Callbacks

    include HasManageableFile

    attr_accessor :personal_demographics, :emergency_contacts, :insurances, :owner_id

    ## Associations with other models
    ## TODO: need to fix association with user
    # belongs_to :user, foreign_key: "owner"

    def initialize(attributes = {})
        attributes.each do |name, value|
            send("#{name}=", value)
        end
    end

    def save
        return if errors.present?
        run_callbacks :save
    end
    

    def personal_demographics_attributes=(attributes)
        patient_demographic_params = attributes.values.first
        @personal_demographics = PersonalDemographics.new(patient_demographic_params)
    end

    def emergency_contacts_attributes=(attributes)
        @emergency_contacts ||= []
        attributes.each do |emergency_contact_params|
            emergency_contact = EmergencyContact.new(emergency_contact_params)
            if emergency_contact.invalid?
                errors.merge!(emergency_contact.errors)
            else
                @emergency_contacts.push()
            end
        end
    end

    def insurances_attributes=(attributes)
        @insurances ||= []
        attributes.each do |insurance_params|
            insurance = Insurance.new(insurance_params)
            if insurance.invalid?
                errors.merge!(insurance.errors)
            else
                @insurances.push(insurance)
            end
        end
    end

    def attributes=(hash)
        hash.each do |key, value|
            next if key == 'errors'
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