class CarsController < ApplicationController
  before_action :set_car, only: %i[ show edit update destroy ]
  before_action :authenticate_user!,except: [:index, :show]

  # GET /cars or /cars.json
  def index
    

    @cars = Car.all

  #   if session[:admin_id]
  #     @admin =Admin.find_by(id: session[:admin_id])
  #  end

  end




  # GET /cars/1 or /cars/1.json
  def show
    
  end

  # GET /cars/new
  def new
    @car = current_user.cars.build
  end

  # GET /cars/1/edit
  def edit
  end


  def search
    keyword="%" + params[:search].to_s + "%"
    @cars =Car.find_by_sql ["Select * from cars WHERE brand like ? ",keyword]
  end





  def checkout

  	if request.post?

  	amount = session[:amount]
ActiveMerchant::Billing::Base.mode = :test

# Create a new credit card object
credit_card = ActiveMerchant::Billing::CreditCard.new(
  :number     => params[:number],
  :month      => params[:month],
  :year       => params[:year],
  :first_name => params[:first_name],
  :last_name  => params[:last_name],
  :verification_value  => params[:verification_value]
)


if credit_card.valid?
  # Create a gateway object to the TrustCommerce service
  gateway = ActiveMerchant::Billing::TrustCommerceGateway.new(
    :login    => 'TestMerchant',
    :password => 'password'
  )



  # Authorize for $10 dollars (1000 cents)
  response = gateway.authorize(amount.to_i, credit_card)

  if response.success?
    # Capture the money
    #Triger the mailer
    session[:cart]=nil
    gateway.capture(amount.to_i, response.authorization)
    redirect_to :action=>:purchase_complete
  end
  else
    flash[:notice] = "Invalid credit card. Give proper inputs"
    render :action=>:checkout
  end
 end
end



  # POST /cars or /cars.json
  def create
    @car = current_user.cars.build(car_params)

    respond_to do |format|
      if @car.save
        format.html { redirect_to @car, notice: "Car was successfully created." }
        format.json { render :show, status: :created, location: @car }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cars/1 or /cars/1.json
  def update
    respond_to do |format|
      if @car.update(car_params)
        format.html { redirect_to @car, notice: "Car was successfully updated." }
        format.json { render :show, status: :ok, location: @car }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cars/1 or /cars/1.json
  def destroy
    @car.destroy
    respond_to do |format|
      format.html { redirect_to cars_url, notice: "Car was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car
      puts "#{params[:id]}yeeeeeeee" 
      @car = Car.find(params[:id])
      
    end

    # Only allow a list of trusted parameters through.
    def car_params
      params.require(:car).permit(:brand, :model, :description, :condition, :finish, :title, :price,:image)
    end
end
