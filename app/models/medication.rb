class Medication
    include ActiveModel::Model
    include ActiveModel::Validations
    include ActiveModel::Serializers::JSON

    attr_accessor :medicine_name, :dosage, :frequency, :still_active, :date_modified
    
    # validators for each attributes
    validates_presence_of :medicine_name, :dosage, :frequency, :still_active, :date_modified
    validates_inclusion_of :active, in: [true, false]

    before_validation(on: :create, :update) do
		self.date_modified = Date.current
	end
end