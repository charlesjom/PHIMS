class Insurance
    include ActiveModel::Validations
    include ActiveModel::Serializers::JSON
    include ActiveModel::Model

    ATTRIBUTES = [:provider_name, :id_number, :valid_until, :name_of_insured, :birthdate_of_insured, :relationship_of_beneficiary_to_insured, :telephone_number]
    attr_accessor(*ATTRIBUTES)

    # validators for each attributes
    validates_presence_of :provider_name, :id_number, :valid_until, :name_of_insured, :birthdate_of_insured, :relationship_of_beneficiary_to_insured
    validates_format_of :telephone_number, with: /\A\+?(\d{1,3})?-?(\d{3})?-?(\d{3}-?\d{4})\Z/i, allow_blank: true
    validates_date :birthdate_of_insured, :on_or_before => :today

    def attributes
        instance_values
    end
end