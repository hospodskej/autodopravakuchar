require "test_helper"

class GalleryPhotoTest < ActiveSupport::TestCase
  test "every photo and thumbnail exists on disk" do
    images = Rails.root.join("app/assets/images")
    GalleryPhoto.all.each do |photo|
      assert images.join(photo.path).file?, "missing #{photo.path}"
      assert images.join(photo.thumbnail_path).file?, "missing #{photo.thumbnail_path}"
      assert photo.alt.present?
    end
  end

  test "find raises for unknown file" do
    assert_raises(ArgumentError) { GalleryPhoto.find("nope.jpg") }
  end
end
