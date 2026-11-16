require "test_helper"

class ZipCollectionJobTest < ActiveJob::TestCase
  test "in_progress? matches only unfinished jobs for the requested download" do
    order = Struct.new(:id).new(42)
    collection = Struct.new(:id).new(7)
    job = SolidQueue::Job.create!(
      queue_name: "default",
      class_name: "ZipCollectionJob",
      arguments: { "arguments" => [{ "collection" => "7", "order" => "42" }] }
    )

    assert ZipCollectionJob.in_progress?(order: order, collection: collection)
    refute ZipCollectionJob.in_progress?(order: order, collection: Struct.new(:id).new(8))
    refute ZipCollectionJob.in_progress?(order: order)

    job.update!(finished_at: Time.current)
    refute ZipCollectionJob.in_progress?(order: order, collection: collection)
  ensure
    job&.destroy!
  end
end
