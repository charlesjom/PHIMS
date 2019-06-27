class Vaccination
    include ActiveModel::Validations
    include ActiveModel::Serializers::JSON
    include ActiveModel::Model

    ATTRIBUTES = [:target_disease, :date_administered]
    attr_accessor(*ATTRIBUTES)

    validates_presence_of(*ATTRIBUTES)
    validates_date :date_administered, :on_or_before => :today

    def attributes
        instance_values 
    end
end