namespace :access_token do
  desc "Assign an access token to all designer submission who don't have one"
  task assign: :environment do
    DesignerSubmission.where(access_token: nil).each do |submission|
      submission.access_token = SecureRandom.hex(20)
      submission.save
    end
  end
end
