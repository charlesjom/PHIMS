class MedicalHistory
    include ActiveModel::Serializers::JSON
    include ActiveModel::Validations
    include ActiveModel::Model
    extend ActiveModel::Naming

    include HasManageableFile

    attr_accessor :allergies, :health_conditions, :medications, :vaccinations, :owner_id

    ## Associations with other models
    ## TODO: need to fix association with user
    # belongs_to :user, foreign_key: "owner"

    def initialize(attributes = {})
        attributes.each do |name, value|
            send("#{name}=", value)
        end
    end

    def save
        # TODO: validation goes here
        # validate
        run_callbacks :save
    end

    def allergies_attributes=(attributes)
        @allergies ||= []
        attributes.each do |i, allergy_params|
            allergy = Allergy.new(allergy_params)
            if allergy.invalid?
                errors.merge!(allergy.errors)
            else
                @allergies.push(allergy)
            end
        end
    end

    def health_conditions_attributes=(attributes)
        @health_conditions ||= []
        attributes.each do |i, health_condition_params|
            health_condition = HealthCondition.new(health_condition_params)
            if health_condition.invalid?
                errors.merge!(health_condition.errors)
            else
                @health_conditions.push(health_condition)
            end
        end
    end

    def medications_attributes=(attributes)
        @medications ||= []
        attributes.each do |i, medical_condition_params|
            medication = Medication.new(medical_condition_params)
            if medication.invalid?
                errors.merge!(medication.errors)
            else
                @medications.push(medication)
            end
        end
    end

    def vaccinations_attributes=(attributes)
        @vaccinations ||= []
        attributes.each do |i, vaccination_params|
            vaccination = Vaccination.new(vaccination_params)
            if vaccination.invalid?
              errors.merge!(vaccination.errors)  
            else
                @vaccinations.push(vaccination)
            end
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