class Allergy
    include ActiveModel::Model
    include ActiveModel::Validations
    include ActiveModel::Serializers::JSON

    attr_accessor :medicine_name, :dosage, :frequency, :active, :date_modified
    
    # validators for each attributes
    validates_presence_of :medicine_name, :dosage, :frequency, :active, :date_modified
    validates_inclusion_of :active, in: [true, false]
    
    # TODO validation for date_modified
    # should be before today
end