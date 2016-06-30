require_relative '../test_helper'

class LibraryImageTest < ActiveSupport::TestCase
  should have_attached_file(:photo)
  should_validate_attribute_with_validator(LibraryImage, :photo, Paperclip::Validators::AttachmentPresenceValidator)

  should "set deleted_at in delete! on a non-deleted library image" do
    library_image = create_library_image
    library_image.delete!
    assert_not_nil library_image.reload.deleted_at
  end

  should "not set deleted_at in delete! on a deleted library image" do
    timestamp = Time.zone.now - 1.minute
    library_image = create_library_image(:deleted_at => timestamp)
    library_image.delete!
    assert_equal timestamp.to_i, library_image.reload.deleted_at.to_i
  end

  should "include only non-deleted library images in position order in all_active" do
    library_images = []
    library_images << create_library_image
    library_images << create_library_image
    library_images << create_library_image
    library_images << create_library_image
    library_images[1].move_higher
    library_images[2].delete!

    assert_equal [1, 0, 3].map { |i| library_images[i] }, LibraryImage.all_active
  end

  private

  def create_library_image(attrs = {})
    LibraryImage.new(photo: File.new("#{Rails.root}/test/files/small.jpg")) do |instance|
      attrs.each_pair { |key, val| instance.send "#{key}=", val }
      instance.expects(:save_attached_files).at_least_once.returns(true)
      instance.save!
    end
  end
end
