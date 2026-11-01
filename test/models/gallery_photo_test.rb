require "test_helper"

class GalleryPhotoTest < ActiveSupport::TestCase
  test "every photo and thumbnail exists on disk as webp" do
    images = Rails.root.join("app/assets/images")
    GalleryPhoto.all.each do |photo|
      assert_equal ".webp", File.extname(photo.file)
      assert images.join(photo.path).file?, "missing #{photo.path}"
      assert images.join(photo.thumbnail_path).file?, "missing #{photo.thumbnail_path}"
      assert images.join(photo.small_path).file?, "missing #{photo.small_path}"
      assert photo.alt.present?
    end
  end

  test "photos belong to their category" do
    category = GalleryCategory.find_by!(key: "avia")
    assert(category.photos.all? { |photo| photo.category == "avia" })
  end

  test "each photo appears once" do
    files = GalleryPhoto.all.map(&:file)
    assert_equal files.uniq, files
  end

  test "find_by! raises for unknown records" do
    assert_raises(KeyError) { GalleryPhoto.find_by!(file: "nope.webp") }
  end
end
