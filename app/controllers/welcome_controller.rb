class WelcomeController < ApplicationController
  def index

    sender = params[:From]
    user = User.find_sender(sender[1..11])

    if user.nil?
      render :text => sms_message("You are not registered to request parking codes.")

#Successfull Text
    else
      if user.under_code_limit?
        text_data = TextData.from_twilio(params)
        text_data.user = user
        text_data.save
        render :text => sms_message("The parking code for #{text_data.text_date} is #{text_data.codedate}. You have #{user.text_limit - user.text_count} free codes left.")

#Warning User has reached their limit
      else
        text_data = TextData.from_twilio(params)
        text_data.user = user
        text_data.save
        render :text => sms_message("The parking code for #{text_data.text_date} is #{text_data.codedate}. You're #{user.text_count - user.text_limit} over your limit.")

      end
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
