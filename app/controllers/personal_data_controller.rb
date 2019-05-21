class PersonalDataController < ApplicationController
    
    def index
        owned_personal_data = current_user.user_records.where(phr_type: 'personal_data').to_a 
        personal_data_with_access = current_user.records_with_access.where(phr_type: 'personal_data').to_a
        @personal_data = owned_personal_data + personal_data_with_access
    end

    def new
        @personal_data = PersonalData.new(personal_demographics: PersonalDemographics.new)
    end
    
    def create
        params[:personal_data].merge!({owner_id: current_user.id})
        @personal_data = PersonalData.new(personal_data_params)
        if @personal_data.save
            redirect_to personal_data_index_path
        else
            flash[:error] = "Please check the data you provided."
            render :new
        end
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

    def personal_data_params
        params.require(:personal_data).permit(:owner_id,
            personal_demographics_attributes: PersonalDemographics::ATTRIBUTES,
            emergency_contacts_attributes: EmergencyContact::ATTRIBUTES,
            insurances_attributes: Insurance::ATTRIBUTES
        )
    end
end
