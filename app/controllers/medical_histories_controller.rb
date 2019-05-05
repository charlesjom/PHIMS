class MedicalHistoriesController < ApplicationController

    def index
        # TODO: get all medical histories with share keys for certain user
    end
    
    def new
        @medical_history = MedicalHistory.new(allergies: [Allergy.new], health_conditions: [HealthCondition.new], medications: [Medication.new], vaccinations: [Vaccination.new])
    end
    
    def create
        params[:medical_history].merge!({owner_id: current_user.id})
        @medical_history = MedicalHistory.new(medical_history_params)
        if @medical_history.save
            redirect_to medical_histories_path
        else
            redirect_back fallback_location: new_medical_history_path(current_user)
            # return error
        end
    end

    def edit
        # TODO: Steps in editing
        # Retrieve record
        # Decrypt record
        # Create new @medical_history, and fill with details from retrieved record
        # @medical_history = current_user.medical_history
    end

    def update
        # TODO: Steps in updating
        # Create new file with updated values
        # Delete previous record or keep it (?)
        # @medical_history = current_user.medical_history
        # @medical_history.update(medical_history_params)
    end

    private
    def medical_history_params
        params.require(:medical_history).permit(:owner_id,
            allergies_attributes: [:allergen, :symptoms, :medications],
            vaccinations_attributes: [:target_disease, :date_administered],
            health_conditions_attributes: [:name_of_condition, :date_of_diagnosis, :date_of_last_checkup],
            medications_attributes: [:medicine_name, :dosage_amount_value, :dosage_amount_unit, :dosage_frequency_value, :dosage_frequency_unit, :still_active]
        )
    end
end
