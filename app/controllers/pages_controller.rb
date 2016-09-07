class PagesController < ApplicationController
  require "stripe"
  Stripe.api_key = "#{ENV["STRIPE_TEST_SECRET_KEY"]}"
  require 'twilio-ruby'

  def home
  end

  def signup
  end

  def thanks2
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

  def send_text_notification(lead_id)
    @lead = Lead.find(lead_id)

  

    require 'twilio-ruby'
    @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
    @client.messages.create(
     from: '+16476910992',
      to: '+14164578795',
      
     
      body: 'Hey a new lead was just created:  
      ' + @lead.inspect
      
      )
    @client.messages.create(
     from: '+16476910992',
      to: '+12893399193',
      
     
      body: 'Hey a new lead was just created:  
      ' + @lead.inspect
      
      )
    @client.messages.create(
     from: '+16476910992',
      to: '+16475226996',
      
     
      body: 'Hey a new lead was just created:  
      ' + @lead.inspect
      
      )

  end 

  def create_lead
  	@lead = Lead.create(
      city: params[:city], 
      car_type: params[:car_type], 
      date_request: params[:date_request], 
      time_request: params[:time_request], 
      phone_number: params[:phone_number],
      service_type: params[:service_type], 
      funnel_step: 1
      )

  
    post_to_formkeep(@lead.id)

  	redirect_to thanks2_path
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

  def jobcomplete

  end 


  def job_submit
    
    customer = Stripe::Customer.create(
    :email => params[:email],
    :source  => params[:stripeToken],

    :description => " #{params[:first_name]} #{params[:last_name]} #{params[:job_number]}"
    
    )
    
    @job = Job.create(
      customer_id: customer.id,
      email: params[:email],
      jobber_id: params[:job_number],
      detailer: params[:detailer],
      amount: params[:amount],
      rating: params[:rating],
      tip_percent: params[:tip_percent],
      first_name: params[:first_name],
      last_name: params[:last_name],
      notes: params[:notes]

      )
      
    

      Stripe::Charge.create(customer: customer.id,
                            amount: (@job.amount.to_i*113*(1+(@job.tip_percent/100))).to_i,
                            description: " Jobber id: #{@job.jobber_id} Detailer: #{@job.detailer}"  ,
                            currency: 'cad')
    
    redirect_to root_path
rescue Stripe::CardError => e
  flash[:error] = e.message
  redirect_to jobcomplete_path

    

  end 


  def area_pricing
  end 

  def post_to_formkeep(lead_id)
    
 
    @lead = Lead.find(lead_id)

    @options = {
      body: {
        name: "New Inbound Request",
        city: @lead.city, 
        car_type: @lead.car_type,
        date_request: @lead.date_request,
        time_request: @lead.time_request,
        phone_number: @lead.phone_number,
        service_type: @lead.service_type

      }
    }

    HTTParty.post('https://formkeep.com/f/a4820f36cafc?', @options)
  end 

end
