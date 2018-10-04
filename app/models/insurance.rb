class Insurance
    include ActiveModel::Model
    include ActiveModel::Validations
    include ActiveModel::Serializers::JSON

    attr_accessor :provider_name, :id_number, :valid_until, :name_of_insured, :birthdate_of_insured, :relationship_to_insured, :telephone_number

    # validators for each attributes
    validates_presence_of :provider_name, :id_number, :valid_until, :name_of_insured, :birthdate_of_insured, :relationship_to_insured
    validates_numericality_of :id_number
    validates_format_of :telephone_number, with: \A\+?(\d{1,3})?-?(\d{3})?-?(\d{3}-?\d{4})\z, :if => :telephone_number_given?
    # TODO validation for valid_until, birthdate_of_insured
    # :valid_until should be after today
    # :birthday_of_insured should be before today
end