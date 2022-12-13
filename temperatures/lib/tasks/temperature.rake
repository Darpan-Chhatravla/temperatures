namespace :temperature do
  desc "Refersh temperature for cities created"
  task refresh: :environment do
    City.all.each do |city|
      puts "Enqueued Job for '#{city.slug}'"
      ResetTemperaturesJob.perform_later(city.id)
    end
  end
end
