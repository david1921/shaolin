if (typeof(MerchantPortal) == 'undefined') {
    var MerchantPortal = {};
}

MerchantPortal.Registration = function ($) {
    function trimmedValue($input) {
        $input.val().trim();
    }

    return {
        init:function () {
            this.setupOnReady();
            this.setupCompaniesHouseClick();
        },

        setupOnReady:function () {
            $.ready(function () {
                $('#companies_house_yes').hide();
                MerchantPortal.Registration($).toggleCompaniesHouseInputs();
                $('#signatory_terms_wrapper').hide();

                if ($('#registration_contact_first_name').length) {
                    MerchantPortal.Registration($).showTermsWrapper();
                }
            });
        },

        setupCompaniesHouseClick:function () {
            $('#companies_house input').click(function () {
                MerchantPortal.Registration($).toggleCompaniesHouseInputs();
            });
        },

        toggleCompaniesHouseInputs:function () {
            var $yesSection = $('#companies_house_yes');
            var answer = $('#companies_house input:checked').val();
            if (answer == "true") {
                $yesSection.slideDown();
            } else {
                $yesSection.slideUp();
            }
        },

        showTermsWrapper:function () {
            var $termsWrapper = $('#signatory_terms_wrapper');
            if (trimmedValue($('#registration_contact_first_name')).length &&
                trimmedValue($('#registration_contact_last_name')).length &&
                trimmedValue(($('#registration_registered_company_name')).length || trimmedValue($('#registration_trading_name')).length)) {
                $termsWrapper.fadeIn();
            } else {
                $termsWrapper.fadeOut();
            }
        }
    };
};
