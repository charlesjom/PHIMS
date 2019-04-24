class Vaccination
    include ActiveModel::Validations
    include ActiveModel::Serializers::JSON
    include ActiveModel::Model

    attr_accessor :target_disease, :date_administered
    
    validates_presence_of :target_disease, :date_administered
    validates_date :date_administered, :on_or_before => :today

    def attributes
        instance_values 
    end
end