set :output, "/log/cron_log.log"

every 3.hours do
  rake "temperature:refresh"
end