class UserRecordsController < ApplicationController
    before_action :set_user_record, only: [:show, :view, :destroy, :edit, :share, :share_form, :edit_data]

    def index
        owned_user_records = current_user.user_records.to_a || []
        @user_records = owned_user_records + current_user.records_with_access.to_a
    end

    def show
        if @user_record.is_owner?(current_user)
            @share_keys = @user_record.share_keys
            @access_logs = @user_record.access_logs.includes(:user)
        end
    end

    def view
        if request.post?
            output = @user_record.read_file(current_user, user_record_params)
            if @user_record.errors.empty?
                send_data(output.force_encoding('BINARY'), type: 'application/pdf', disposition: 'inline')
            else
                redirect_to user_record_path(@user_record), error: @user_record.errors.full_messages
            end
        else
            redirect_to user_record_path(@user_record), information: "Please enter your password"
        end
    end

    def destroy
        @user_record.destroy
        redirect_to root_path
    end

    def share_form
    end

    def share
        if request.post?
            share_recipient = share_user_record_params[:share_recipient]
            status = @user_record.share_file(current_user, share_user_record_params)
            if status
                redirect_to share_form_user_record_path(@user_record), success: "Successfully shared record to #{share_recipient}"
            else
                flash[:error] = @user_record.errors.full_messages
                render :share_form
            end
        else
            redirect_to share_form_user_record_path(@user_record)
        end
    end

    def edit
    end

    def edit_data
        if request.post?
            @output = @user_record.edit_file(current_user, user_record_params)
            if @user_record.errors.any?
                redirect_to edit_user_record_path(@user_record), error: @user_record.errors.full_messages
            end
        else
            redirect_to edit_user_record_path(@user_record), information: "Please enter your password"
        end
    end

    def update
        @user_record = UserRecord.find(params[:id])
        if params.has_key?(:medical_history)
            params[:medical_history].merge!({owner_id: current_user.id})
            @output = MedicalHistory.new(medical_history_params)
            status = @output.update(@user_record)
        elsif params.has_key?(:personal_data)
            params[:personal_data].merge!({owner_id: current_user.id})
            @output = PersonalData.new(personal_data_params)
            status = @output.update(@user_record)
        end
        
        if status
            redirect_to user_record_path(@user_record), success: "PHR updated successfully."
        else
            flash[:error] = ["Please check the data you provided."]
            render :edit_data
        end
    end
    
    private

    def set_user_record
        user_record = UserRecord.find(params[:id])
        if user_record.has_access?(current_user)
            @user_record = UserRecord.find(params[:id])
        else
            redirect_to root_path, warning: 'You do not have permission to access that record'
        end
    end
    
    def user_record_params
        params.require(:user_record).permit(:password)
    end

    def share_user_record_params
        params.require(:user_record).permit(:password, :share_recipient)
    end
    
    def medical_history_params
        params.require(:medical_history).permit(:owner_id, :password,
            allergies_attributes: Allergy::ATTRIBUTES,
            vaccinations_attributes: Vaccination::ATTRIBUTES,
            health_conditions_attributes: HealthCondition::ATTRIBUTES,
            medications_attributes: Medication::ATTRIBUTES
        )
    end

    def personal_data_params
        params.require(:personal_data).permit(:owner_id, :password,
            personal_demographics_attributes: PersonalDemographics::ATTRIBUTES,
            emergency_contacts_attributes: EmergencyContact::ATTRIBUTES,
            insurances_attributes: Insurance::ATTRIBUTES
        )
    end
end