class AdminregistrationsController < ApplicationController
    def new
        @admin =Admin.new
    end
    
    def create 
        @admin =Admin.new(admin_params)

        if @admin.save
            session[:admin_id] = @admin.id
            redirect_to  root_path,  notice: "Successully create acount"
        else 
           
            render :new 
        end
    end
    

private
  
def admin_params
    params.require(:admin).permit(:email,:password_degest)
end

end