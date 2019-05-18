class MedicalHistoriesController < ApplicationController

    def index
        owned_medical_histories = current_user.user_records.where(phr_type: 'medical_history').to_a
        medical_histories_with_access = current_user.records_with_access.where(phr_type: 'medical_history').to_a
        @medical_histories = owned_medical_histories + medical_histories_with_access
    end
    
    def new
        @medical_history = MedicalHistory.new
    end
    
    def create
        params[:medical_history].merge!({owner_id: current_user.id})
        @medical_history = MedicalHistory.new(medical_history_params)
        if @medical_history.save
            redirect_to medical_histories_path
        else
            render :new
        end
    end

    def update
        # TODO: Steps in updating
        # Create new file with updated values
        # Delete previous record or keep it (?)
        # @medical_history.new(medical_history_params)
    end

    def add_attribute
        @attribute = params[:attribute]
        @collection = params[:collection]
        @model = @attribute.underscore.classify.constantize.new

        respond_to do |format|
            format.js
        end
    end

    private
    def medical_history_params
        params.require(:medical_history).permit(:owner_id,
            allergies_attributes: Allergy::ATTRIBUTES,
            vaccinations_attributes: Vaccination::ATTRIBUTES,
            health_conditions_attributes: HealthCondition::ATTRIBUTES,
            medications_attributes: Medication::ATTRIBUTES
        )
    end
end
