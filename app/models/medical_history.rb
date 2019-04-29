class MedicalHistory
    include ActiveModel::Serializers::JSON
    include ActiveModel::Validations
    include ActiveModel::Model
    extend ActiveModel::Naming

    include HasManageableFile

    attr_accessor :allergies, :health_conditions, :medications, :vaccinations, :owner_id
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

    def allergies_attributes=(attributes)
        @allergies ||= []
        attributes.each do |i, allergy_params|
            @allergies.push(Allergy.new(allergy_params))
        end
    end

    def health_conditions_attributes=(attributes)
        @health_conditions ||= []
        attributes.each do |i, health_condition_params|
            @health_conditions.push(HealthCondition.new(health_condition_params))
        end
    end

    def medications_attributes=(attributes)
        @medications ||= []
        attributes.each do |i, medical_condition_params|
            @medications.push(Medication.new(medical_condition_params))
        end
    end

    def vaccinations_attributes=(attributes)
        @vaccinations ||= []
        attributes.each do |i, vaccination_params|
            @vaccinations.push(Vaccination.new(vaccination_params))
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