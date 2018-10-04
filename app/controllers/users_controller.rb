class UsersController < ApplicationController
    # only authenticated users can access
    before_action :authenticate_user!

    # GET /user/:user_id
    def show
        raise
        @records = current_user
    end
end
