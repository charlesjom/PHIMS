class EmergencyContact
    include ActiveModel::Validations
    include ActiveModel::Serializers::JSON
    include ActiveModel::Model
    
    attr_accessor :first_name, :middle_name, :last_name, :telephone_number, :cellphone_number, :address, :relationship

    # validators for each attributes
    validates_presence_of :first_name, :middle_name, :last_name, :relationship
    validates_length_of :first_name, maximum: 30
    validates_length_of :middle_name, maximum: 30
    validates_length_of :last_name, maximum: 30
    with_options allow_blank: true do |v|
        v.validates_format_of :telephone_number, with: /\A\+?(\d{1,3})?-?(\d{3})?-?(\d{3}-?\d{4})\Z/i
        v.validates_format_of :cellphone_number, with: /\A\+?(\d{1,3})?-?(\d{3})?-?(\d{3}-?\d{4})\Z/i
    end
end