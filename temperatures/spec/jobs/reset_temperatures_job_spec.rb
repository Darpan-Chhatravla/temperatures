require "rails_helper"

RSpec.describe ResetTemperaturesJob, :type => :job do
  let(:city) { create(:city) }

  describe "#perform_later" do
    it "Create min and max forecasted temperature using timer api" do
      ActiveJob::Base.queue_adapter = :test
      expect {
        ResetTemperaturesJob.perform_now(city.id)
      }.to enqueue_job
    end

    it "Destroy and Create min and max forecasted temperature using timer api" do
      ActiveJob::Base.queue_adapter = :test
      expect {
        ResetTemperaturesJob.perform_now(city.id, true)
      }.to enqueue_job
    end
  end
end