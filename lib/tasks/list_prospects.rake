namespace :list_prospects do
  desc "List new prospects in DB"
  task list_new: :environment do
    emails = [
      "demarcq.theophile@gmail.com",
      "pablo@cerberosoundlab.com",
      "marottadevan@gmail.com",
      "maria.milewska@yahoo.com",
      "hello@moisescomposer.com",
      "cepe.arts@gmail.com",
      "Evan_Kitchener@hotmail.com",
      "ianfishersongs@gmail.com",
      "info@dimvach.com",
      "edwin.montgomery@gmail.com",
      "salmeron.abilio@gmail.com",
      "ravi.nidamarthy@gmail.com",
      "francocugusi@gmail.com",
      "galante.daniele@gmail.com",
      "rdaskas@sonypicturesanimation.com",
      "phil@philarcher.tv",
      "Joe@JoeActor.com",
      "KoleAudioSolutions@gmail.com",
      "mccarley@alumni.usc.edu",
      "communication@aifr.fr"
    ]

    emails.each do |email|
      if Prospect.exists?(email: email)
        prospect = Prospect.find_by(email: email)
        SentEmail.create!(prospect: prospect, email_sequence: "2")
      else
        prospect = Prospect.create!(email: email)
        SentEmail.create!(prospect: prospect, email_sequence: "1")
      end
      puts 'What is the source of these prospects?'
      prospect.source = "Battlbards"
      prospect.save!
    end
  end
end
