class PersonalData
    include ActiveModel::Serializers::JSON
    include ActiveModel::Validations
    include ActiveModel::Model
    extend ActiveModel::Naming
    extend ActiveModel::Callbacks

    include HasManageableFile

    attr_accessor :personal_demographics, :emergency_contacts, :insurances, :owner_id
    attr_reader :record_id

    ## Associations with other models
    ## TODO: need to fix association with user
    # belongs_to :user, foreign_key: "owner"

    def initialize(attributes = {})
        attributes.each do |name, value|
            send("#{name}=", value)
        end
        @record_id = nil
    end

    def save
        return if errors.present?
        run_callbacks :save
    end

    def update(record = nil)
        return if errors.present?
        return unless record.present?
        @record_id = record.id
        run_callbacks :save
    end

    def personal_demographics_attributes=(patient_demographic_params)
        @personal_demographics = PersonalDemographics.new(patient_demographic_params)
        if @personal_demographics.invalid?
            errors.merge!(@personal_demographics.errors)
        end
    end

    def emergency_contacts_attributes=(attributes)
        @emergency_contacts ||= []
        attributes.each do |emergency_contact_params|
            emergency_contact = EmergencyContact.new(emergency_contact_params)
            if emergency_contact.invalid?
                errors.merge!(emergency_contact.errors)
            end
            @emergency_contacts.push(emergency_contact)
        end
    end

    def insurances_attributes=(attributes)
        @insurances ||= []
        attributes.each do |insurance_params|
            insurance = Insurance.new(insurance_params)
            if insurance.invalid?
                errors.merge!(insurance.errors)
            end
            @insurances.push(insurance)
        end
    end

    def attributes=(hash)
        hash.each do |key, value|
            next if key == 'errors' || key == 'record_id'
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