require_relative '../../test_helper'

class Admin::LibraryImagesControllerTest < ActionController::TestCase
  should "redirect to sign-in page from index when not logged in" do
    get :index
    assert_redirected_to sign_in_url
  end

  should "redirect to sign-in page from index when logged in as a non-admin" do
    get :index
    sign_in_as FactoryGirl.build(:sales_user)
    assert_redirected_to sign_in_url
  end

  context "with 3 images in the library and signed in as an admin user" do
    setup do
      @library_images = []
      @library_images << create_library_image(1)
      @library_images << create_library_image(2)
      @library_images << create_library_image(3)

      sign_in_as FactoryGirl.build(:admin_user)
    end

    should "update the image positions in sort" do
      post :sort, :library_image => [2, 0, 1].map { |index| @library_images[index].id }
      assert_response :success

      assert_equal 1, @library_images[2].reload.position
      assert_equal 2, @library_images[0].reload.position
      assert_equal 3, @library_images[1].reload.position
    end
  end

  private

  def create_library_image(position)
    LibraryImage.new(:position => position, :photo => File.new("#{Rails.root}/test/files/small.jpg")) do |instance|
      instance.expects(:save_attached_files).returns(true)
      instance.save!
    end
  end
end
