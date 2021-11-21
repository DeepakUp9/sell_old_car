module CarsHelper

    def car_admin(car)
        user_signed_in? && current_user.id == car.user_id 
    end


end
