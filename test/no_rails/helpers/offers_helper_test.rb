require_relative '../test_helper'
require File.expand_path('app/helpers/offers_helper.rb')
require 'active_support/core_ext/string/output_safety'

class OffersHelper::OffersHelperTest < Test::Unit::TestCase
  include OffersHelper

  context '#offer_title' do
    setup do
      @offer = stub
    end

    should 'have a title for each step' do
      (1..5).each do |step|
        assert_equal STEP_TITLES[step], offer_title(step)
      end
    end

    should "return nil when the step doesn't exist of the offer is nil" do
      @offer.stubs(:step).returns(-1)
      assert_nil offer_title(@offer)
      assert_nil offer_title(nil)
    end
  end

  context '#offer_progress_span' do
    setup do 
      @offer = stub
    end
    should 'have a progress span and save button for each step' do
      (1..4).each do |step|
        @offer.stubs(:step).returns(step)
        html = offer_progress_span(@offer, save_button: true)
        assert html.html_safe?
        result = ::Nokogiri.HTML(html)
        assert_equal 1, result.css("button.save_progress").length
        assert_equal 1, result.css("span.percent_#{STEP_PERCENTS[@offer.step]}").length
        assert_match STEP_PERCENTS[@offer.step].to_s, result.css("span").text
      end
    end

    should 'have a progress span for each step' do
      (1..4).each do |step|
        @offer.stubs(:step).returns(step)
        html = offer_progress_span(@offer)
        assert html.html_safe?
        result = ::Nokogiri.HTML(html)
        assert_equal 0, result.css("button.save_progress").length
        assert_equal 1, result.css("span.percent_#{STEP_PERCENTS[@offer.step]}").length
        assert_match STEP_PERCENTS[@offer.step].to_s, result.css("span").text
      end
    end


    should "return nil when the step doesn't exist of the offer is nil" do
      @offer.stubs(:step).returns(-1)
      assert_nil offer_progress_span(@offer)
      assert_nil offer_progress_span(nil)
    end
  end
end


