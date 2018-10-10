class UsersController < ApplicationController
    # only authenticated users can access

    # GET /user/:user_id
    def show
        @records = current_user
    end
end
