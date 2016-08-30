class PagesController < ApplicationController
  require "stripe"
  Stripe.api_key = "#{ENV["STRIPE_TEST_SECRET_KEY"]}"

  def home
  end

  def signup
  end

  def pricing
    if params[:id]
    @lead = Lead.find(params[:id])
  else 
    redirect_to go_path
  end 
  end

  def pricing_step_2
    @lead = Lead.find(params[:id])
    @lead.update(
      address: params[:address], 
      
       
      phone_number: params[:phone_number],
      address_line_2: params[:address_line_2], 
      frequency: params[:frequency],
      first_name: params[:first_name],
      last_name: params[:last_name],
      email: params[:email],
      city: params[:city],
      province: params[:province],
      postal_code: params[:postal_code],
      country: params[:country],
      
      condo: params[:condo],
   
      license_plate: params[:license_plate],
      funnel_step: 2

      )
    
  end 

  def create_lead
  	@lead = Lead.create(
      address: params[:address], 
      car_type: params[:car_type], 
      date_request: params[:date_request], 
      time_request: params[:time_request], 
      phone_number: params[:phone_number],
      service_type: params[:service_type], 
      funnel_step: 1
      )
  	redirect_to pages_pricing_path(id: @lead.id)
  end 

  def thanks
    @lead = Lead.find(params[:id])
  end 

   def stripe_create
    @lead = Lead.find(params[:id])
    customer = Stripe::Customer.create(
    :email => @lead.email,
    :source  => params[:stripeToken],

    :description => " #{@lead.email} + #{@lead.first_name} + #{@lead.last_name}"
    
    )
    @lead.update(
      customer_id: customer.id,
      funnel_step: 3
      )
    
redirect_to thanks_path(id: @lead.id)

rescue Stripe::CardError => e
  flash[:error] = e.message
  redirect_to step_2_path(id: @lead.id)

    


  end 


  def area_pricing
  end 

end
