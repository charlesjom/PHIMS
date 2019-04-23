class Insurance
    include ActiveModel::Validations
    include ActiveModel::Serializers::JSON
    include ActiveModel::Model

    attr_accessor :provider_name, :id_number, :valid_until, :name_of_insured, :birthdate_of_insured, :relationship_of_beneficiary_to_insured, :telephone_number

    # validators for each attributes
    validates_presence_of :provider_name, :id_number, :valid_until, :name_of_insured, :birthdate_of_insured, :relationship_of_beneficiary_to_insured
    with_options allow_blank: true do |v|
        validates_format_of :telephone_number, with: /\A\+?(\d{1,3})?-?(\d{3})?-?(\d{3}-?\d{4})\Z/i
        validates_date :birthdate_of_insured, :on_or_before => :today
    end
end