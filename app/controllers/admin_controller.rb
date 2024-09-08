class AdminController < ApplicationController
    before_action :authenticate_user!
    before_action :check_if_admin

    def index
        @users = User.all
    end
end
