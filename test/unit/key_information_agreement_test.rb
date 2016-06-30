require_relative '../test_helper'

class KeyInformationAgreementTest < ActiveSupport::TestCase
  should have_attached_file(:signature)
  should validate_attachment_presence(:signature)

  should "not be valid with blank html" do
    subject = build_key_information_agreement(html: " ", signature: File.new("#{Rails.root}/test/files/small.jpg"))
    assert subject.invalid?, "Should not be valid with blank html"
  end

  should "save and load its html attribute" do
    subject = build_key_information_agreement(html: "<div></div>", signature: File.new("#{Rails.root}/test/files/small.jpg"))
    subject.save!
    assert_equal "<div></div>", subject.reload.html
  end

  should "set its signature when signature_params is assigned" do
    subject = build_key_information_agreement(html: "<div></div>")
    subject.signature_params = { name: "small.jpg", type: "image/jpg", data: File.new("#{Rails.root}/test/files/small.jpg").read }
    subject.save!
  end

  context '#valid?' do
    setup do
      @kig = KeyInformationAgreement.new
    end

    should 'require a signature if electronically_signed is blank' do
      refute @kig.valid?
      assert_match /can't be blank/, @kig.errors[:signature].first
      @kig.electronically_signed = true
      @kig.valid?
      assert @kig.errors[:signature].blank?
    end

    should 'require electronically_signed if signature is blank' do
      refute @kig.valid?
      assert_match /can't be blank/, @kig.errors[:electronically_signed].first
      @kig.stubs(:signature).returns(mock)
      @kig.valid?
      assert @kig.errors[:electronically_signed].blank?
    end
  end

  private

  def build_key_information_agreement(attrs = {})
    FactoryGirl.create(:merchant).key_information_agreements.new do |instance|
      attrs.each_pair { |key, val| instance.send "#{key}=", val }
      instance.expects(:save_attached_files).at_least(0).returns(true)
    end
  end
end
