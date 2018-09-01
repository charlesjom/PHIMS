class ApplicationController < ActionController::Base

    include UsersHelper

    private
        def require login
            unless logged_in?
                redirect_to root_path
            end
        end
end
