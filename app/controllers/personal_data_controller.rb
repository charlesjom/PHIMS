class PersonalDataController < ApplicationController
    
    def index
        # TODO: get all personal data with share keys for certain user
    end

    def new
        @personal_data = PersonalData.new(patient_demographics: [PatientDemographics.new], emergency_contacts: [EmergencyContact.new], insurances: [Insurance.new])
    end
    
    def create
        params[:personal_data].merge!({owner_id: current_user.id})
        @personal_data = PersonalData.new(personal_data_params)
        if @personal_data.save
            redirect_to personal_data_path
        else
            redirect_back fallback_location: new_user_personal_data_path(current_user)
            # return error
        end
    end

    def edit
        @personal_data = current_user.personal_data
    end

    def update
        @personal_data = current_user.personal_data
        @personal_data.update(personal_data_params)
    end

    def destroy
        @personal_data = current_user.personal_data
        @personal_data.destroy
    end

    private

    def personal_data_params
        params.require(:personal_data).permit(:owner_id,
            patient_demographics_attributes: [:birthdate, :sex, :civil_status, :weight_in_kg, :height_in_cm, :abo_blood_type, :rh_blood_type],
            emergency_contacts_attributes: [:first_name, :middle_name, :last_name, :cellphone_number, :address, :relationship],
            insurances_attributes: [:provider_name, :id_number, :valid_until, :name_of_insured, :birthdate_of_insured, :relationship_of_beneficiary_to_insured, :telephone_number]
        )
    end
end
