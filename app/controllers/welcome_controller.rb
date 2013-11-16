class WelcomeController < ApplicationController
  def index

    sender = params[:From]

    user = User.find_sender(sender[1..11])
#this code will help to debug whats happening in Heroku 
#    puts "[DEBUG]" + [sender, User.all.collect{ |u| u.phone_number }].inspect
    if user.nil?
      render :text => sms_message("You are not registered to request parking codes.")

    else
#      text_data = TextData.new(params)
#      text_data.user = user
#      text_data.save
      render :text => sms_message(text_date.codedate)
    end
  end

  private

  def sms_message(txt)
    twiml = Twilio::TwiML::Response.new do |r|
      r.Message txt
    end
    twiml.text
  end
end
