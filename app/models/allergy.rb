class Allergy
    include ActiveModel::Validations
    include ActiveModel::Serializers::JSON
    include ActiveModel::Model

    ATTRIBUTES = [:allergen, :symptoms, :medications]

    attr_accessor(*ATTRIBUTES)

    # validators for each attributes
    validates_presence_of :allergen, :symptoms, :medications

    def attributes
       instance_values 
    end
end