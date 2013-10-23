require 'twilio-ruby'

  num = '+18666582925'
  blocknum = '+13302833616'

  if num === '+18666582925'
    if blocknum === '+13302833616'    #this is my cell number i've been trying to block for the test
      response = Twilio::TwiML::Response.new do |r|
        r.Reject
      end
    else
      response = Twilio::TwiML::Response.new do |r|
        r.Say "This call may be recorded for quality assurance", :voice => 'woman'
        r.Dial '814-833-6805', :record => 'true'
      end
    end
  puts response.text
  end