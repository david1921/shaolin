$(function() {
  var updateVisibility = function() {
    if ($('#merchant_registered_with_companies_house').is(':checked')) {
      $('#non_registered_company_fields').hide();
      $('#registered_company_fields').show();
      $('#trading_name_fields').toggle(!$('#merchant_trading_name_is_registered_company_name').is(':checked'));
      $('#trading_address_fields').toggle(!$('#merchant_trading_address_is_registered_company_address').is(':checked'));
      $('#billing_address_is_trading_address_fields').toggle(!$('#merchant_trading_address_is_registered_company_address').is(':checked') && !$('#merchant_billing_address_is_registered_company_address').is(':checked'));
      $('#billing_address_fields').toggle(
        !$('#merchant_billing_address_is_registered_company_address').is(':checked') && (
          $('#merchant_trading_address_is_registered_company_address').is(':checked') || !$('#merchant_billing_address_is_trading_address').is(':checked')
        )
      );
    } else {
      $('#registered_company_fields').hide();
      $('#non_registered_company_fields').show();
      $('#billing_address_fields').toggle(!$('#merchant_billing_address_is_business_address').is(':checked'));
    }
    $('#barclaycard_gpa_number_fields').toggle($('#merchant_barclaycard_gpa_merchant').is(':checked'));
    $('#negotiated_pre_paid_offer_commission_rate_fields').toggle(!$('#merchant_standard_pre_paid_offer_commission_rate').is(':checked'));
  };
  $('input[type=checkbox]').change(updateVisibility);
  updateVisibility();
});
