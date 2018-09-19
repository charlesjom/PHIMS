class EmergencyContact
    include ActiveModel::Model
    include ActiveModel::Validations
    
    attr_accessor :first_name, :middle_name, :last_name, :telephone_number, :cellphone_number, :address, :relationship

    # validators for each attributes
    validates_presence_of :first_name, :middle_name, :last_name, :relationship
    validates_length_of :first_name, maximum: 30
    validates_length_of :middle_name, maximum: 30
    validates_length_of :last_name, maximum: 30
    validates_numericality_of :telephone_number, :if => :telephone_number_given?
    validates_format_of :telephone_number, with: \A\+?(\d{1,3})?-?(\d{3})?-?(\d{3}-?\d{4})\z, :if => :telephone_number_given?
    validates_numericality_of :cellphone_number, :if => :cellphone_number_given?
    validates_format_of :cellphone_number, with: \A\+?(\d{1,3})?-?(\d{3})?-?(\d{3}-?\d{4})\z, :if => :cellphone_number_given?
end