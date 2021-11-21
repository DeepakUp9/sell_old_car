class SessionsController < ApplicationController

    def new 
    end

    def create 
       admin =Admin.find_by(email: params[:email])
        if admin.present? #&& Admin.authenticate(params[:email],params[:password])
             session[:admin_id]= admin.id
           redirect_to root_path , notice: "Logged in successfully"
        else 
            flash[:alert]="Invalid email/password"
            render :new
        end

    end

    def destroy
       session[:admin_id]=nil;
       redirect_to root_path ,notice: "Logged Out!!"
    end
       



    def authenticate(email,password)
        admin = find_by_email(email)
        return admin if admin && admin.password_valid?(password)
    
      end 
    
      def password_valid?(password)
        self.hashed_password == encrypt(password)
      end
    
    
    private
          def encrypt_password
            return if password.blank?
            self.hashed_password = encrypt(password)
          end
        
          def encrypt(password)
              Digest::SHA1.hexdigest(password)
          end
    
end