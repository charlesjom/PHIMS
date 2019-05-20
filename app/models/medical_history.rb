class MedicalHistory
    include ActiveModel::Serializers::JSON
    include ActiveModel::Validations
    include ActiveModel::Model
    extend ActiveModel::Naming

    include HasManageableFile

    attr_accessor :allergies, :health_conditions, :medications, :vaccinations, :owner_id
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

    def allergies_attributes=(attributes)
        @allergies ||= []
        attributes.each do |allergy_params|
            allergy = Allergy.new(allergy_params)
            if allergy.invalid?
                errors.merge!(allergy.errors)
            end
            @allergies.push(allergy)
        end
    end

    def health_conditions_attributes=(attributes)
        @health_conditions ||= []
        attributes.each do |health_condition_params|
            health_condition = HealthCondition.new(health_condition_params)
            if health_condition.invalid?
                errors.merge!(health_condition.errors)
            end
            @health_conditions.push(health_condition)
        end
    end

    def medications_attributes=(attributes)
        @medications ||= []
        attributes.each do |medical_condition_params|
            medication = Medication.new(medical_condition_params)
            if medication.invalid?
                errors.merge!(medication.errors)
            end
            @medications.push(medication)
        end
    end

    def vaccinations_attributes=(attributes)
        @vaccinations ||= []
        attributes.each do |vaccination_params|
            vaccination = Vaccination.new(vaccination_params)
            if vaccination.invalid?
              errors.merge!(vaccination.errors)  
            end
            @vaccinations.push(vaccination)
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