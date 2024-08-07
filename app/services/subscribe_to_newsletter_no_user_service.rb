class SubscribeToNewsletterNoUserService
  def initialize(email)
    @email = email
    @gibbon = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])
    @audience_id = ENV['MAILCHIMP_LIST_ID']
  end

  def call
    # Gibbon::Request.lists(@audience_id).members(@user.email).retrieve.body["status"]
    begin
      Gibbon::Request.lists(@audience_id).members(@email).retrieve.nil?
    rescue
      @gibbon.lists(@audience_id).members.create(
        body: {
          email_address: @email,
          status: "subscribed",
          # merge_fields: {
          #   FNAME: @user.username,
          #   LNAME: @user.last_name
          # }
        }
      )
    end
  end
end
