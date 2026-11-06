require 'test_helper'

class CollectionsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get collections_create_url
    assert_response :success
  end

  test "visitor can create a builder pack and add and remove tracks" do
    track_to_add = single_tracks(:one)
    track_to_remove = single_tracks(:two)
    existing_user_ids = User.pluck(:id)
    CollectionCategory.create!(points: 20)
    CollectionCategory.create!(points: 50)

    post create_builder_pack_url, params: { track: track_to_add.id }

    guest_user = User.where.not(id: existing_user_ids).first!
    collection = guest_user.collections.find_by!(purchased: false)
    assert_equal [track_to_add.id], collection.tracks.map(&:to_i)

    patch add_builder_track_url, params: { collection: collection.id, track: track_to_remove.id }
    collection.reload
    assert_equal [track_to_add.id, track_to_remove.id], collection.tracks.map(&:to_i)

    delete remove_builder_track_url(collection_id: collection.id, track_id: track_to_add.id)
    collection.reload
    assert_equal [track_to_remove.id], collection.tracks.map(&:to_i)
  end

end
