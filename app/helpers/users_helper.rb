module UsersHelper
    def login(user)
        session[:user_id] = user.id
    end

    def current_user
        User.where(id: session[:user_id])
    end

    def logged_in?
        !current_user.nil?
    end

    def logout
        session.delete(:user_id)
    end
end
