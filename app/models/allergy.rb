class Allergy
    include ActiveModel::Validations
    include ActiveModel::Serializers::JSON
    include ActiveModel::Model

    attr_accessor :allergen, :symptoms, :medications

    # validators for each attributes
    validates_presence_of :allergen, :symptoms, :medications

    def attributes
       instance_values 
    end
end