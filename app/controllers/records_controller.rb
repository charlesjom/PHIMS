class RecordsController < ApplicationController
    # only authenticated users can access
    before_action :authenticate_user!

    # GET
    def index
        @records = current_user.records
    end
    
    # GET 
    def new
    end

    # POST
    def create
    end

    # GET
    def show
    end

    # GET
    def edit
    end

    # PATCH
    def update
    end

    private
    def record_params
        params.require(:record).permit(:content)
    end
end
