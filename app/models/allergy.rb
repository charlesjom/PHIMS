class Allergy
    include ActiveModel::Model
    include ActiveModel::Validations
    include ActiveModel::Serializers::JSON

    attr_accessor :allergen, :symptoms, :medications

    # validators for each attributes
    validates_presence_of :allergen, :symptoms, :medications
end