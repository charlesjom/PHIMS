class MedicalHistoriesController < ApplicationController

    def index
        # TODO: get all medical histories with share keys for certain user
    end
    
    def new
        @medical_history = MedicalHistory.new(allergies: [Allergy.new], health_conditions: [HealthCondition.new], medications: [Medication.new], vaccinations: [Vaccination.new])
    end
    
    def create
        @medical_history = current_user.medical_history.new(medical_history_params)
        if @medical_history.create_file
            redirect_to user_path(current_user)
        else
            redirect_back fallback_location: new_user_medical_history_path(current_user)
            # return error
        end
    end

    def edit
        # TODO: Steps in editing
        # Retrieve record
        # Decrypt record
        # Create new @medical_history, and fill with details from retrieved record
        @medical_history = current_user.medical_history
    end

    def update
        # TODO: Steps in updating
        # Create new file with updated values
        # Delete previous record or keep it (?)
        @medical_history = current_user.medical_history
        @medical_history.update(medical_history_params)
    end

    def destroy
        @medical_history = current_user.medical_history
        @medical_history.destroy
    end

    private
    def medical_history_params
    end
end
