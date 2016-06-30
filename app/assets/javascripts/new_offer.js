$(function() {
	//preventing default button action on form
	$('.new_offer button').on('click', function(e){
		e.preventDefault();
	});

  // offer objective options more info (hidden by default)
  $('.new_offer .free_or_pre_paid fieldset p').hide();
  $('.new_offer #options_info').click(function(e){
    e.preventDefault();
    
    if($(this).text() == "more info") {
      $(this).text('hide info');
      $('.new_offer .free_or_pre_paid fieldset p').slideDown();
    } else {
      $(this).text('more info');
      $('.new_offer .free_or_pre_paid fieldset p').slideUp();
    }
  });

  //pre-paid offer cc box hide/show
  function prePaidChange() {
  $('.targeted_state').slideUp(300);
  }
  $('.pre_paid_offer > input').on('click', prePaidChange);
  if($('.pre_paid_offer > input').is(':checked')){
    $('.targeted_state').hide();
  }
  $('.free_offer > input, .free_targeted_offer > input').on('click',function(){
    $('.targeted_state').slideDown(300); 
  });  

  //pre-paid & targeted objectives hide/show
  $('.pre_paid_offer > input, .free_targeted_offer > input').on('click',function(){
    $('#drive_traffic').fadeIn(300);
    $('#get_customers').fadeIn(300);
    $('#shift_stock').fadeIn(300);
    $('#find_shoppers').fadeIn(300);
    $('#reward_best').fadeIn(300);
  });

	//Whats your objective, adding class selected to the selected button
	$('.objective_buttons button').on('click', function(){
		$('.objective_buttons button').removeAttr('class');
		$(this).addClass('selected');
    $("#offer_objective").val($(this).attr('data-value'));
	});

  //date picker on input
  $('.date_input').simpleDatepicker();

	// pricing details calculations
	$('.new_offer_details .offer_pricing input').change(function(){

		var standard_price = $(this).parent().parent().find('input').eq(0).val().replace(/[^\d.]/g, '');
		var offer_price = $(this).parent().parent().find('input').eq(1).val().replace(/[^\d.]/g, '');
		var precentage_discount = $(this).parent().parent().find('input').eq(2).val().replace(/[^\d.]/g, '');

    // calc offer price from standard and percentage
    if($(this).attr('name') == 'discount_percentage') {
       if( $.isNumeric(standard_price) && $.isNumeric(precentage_discount) ) {
        offer_price = standard_price * (1-(precentage_discount/100.0));
        $(this).parent().parent().find('input').eq(1).val( "£" + offer_price.toFixed(2));
       }
    }
    // calc percentage from standard and offer
    else {
       if($.isNumeric(standard_price) && $.isNumeric(offer_price) ) {
			   precentage_discount = ((standard_price-offer_price)/standard_price) * 100;
			   $(this).parent().parent().find('input').eq(2).val(precentage_discount.toFixed(2) + "%");
		  }
     } 
	});

	// input filtering for Pricing details
	$(".new_offer_details .offer_pricing input").keydown(function(event) {
        // Allow: backspace, delete, tab, escape, enter, 
        if ( event.keyCode == 46 || event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 27 || event.keyCode == 13 || 
             // Allow: Ctrl+A
            (event.keyCode == 65 && event.ctrlKey === true) || 
             // Allow: home, end, left, right
            (event.keyCode >= 35 && event.keyCode <= 39) ||
            // allow decimal
             (event.keyCode >= 190 )) {
                 // let it happen, don't do anything
                 return;
        }
        else {
            // Ensure that it is a number and stop the keypress
            if (event.shiftKey || (event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105 )) {
                event.preventDefault(); 
            }   
        }
    });

  // how to redeem, Voucher Code, and Restrictions radio buttons
  $('.service_phone_redeem .redeem_how ul li ul, .voucher_codes fieldset ul li ul, .own_image_contact').hide();
  var prev_button_redeeem = "";
  var prev_button_codes = "";
  
  $('.online_offer_checkbox').live('change',function(){
    itemChecked(this);
  });

  $('.over_phone_checkbox').live('change',function(){
    itemChecked(this);
  });

  $('#offer_choose_own_offer_image').live('change',function(){
    useOwnImage(this);
  });

  //function to check for input checked
  function itemChecked(thisItem){
    if($(thisItem).is(':checked')){
      $(thisItem).siblings().slideDown();
    }else{
      $(thisItem).siblings().slideUp();
    }
  }

  //function for use own image
  function useOwnImage(thisItem){
    if($(thisItem).is(':checked')){
      $(thisItem).parent().next().slideDown();
    }else{
      $(thisItem).parent().next().slideUp();
    }
  }

  //call checkboxes on page load to test current status
  itemChecked($('.online_offer_checkbox'));
  itemChecked($('.over_phone_checkbox'));
  useOwnImage($('#offer_choose_own_offer_image'));
 
  $('.service_phone_redeem .redeem_how > ul > li > input:radio').click(function(){
    
    if(prev_button_redeeem != $(this).val()){
      $('.service_phone_redeem .redeem_how input:radio').filter(function(index) {
        return $(this).val().match(prev_button_redeeem);
      }).siblings('ul').slideUp();    
      $(this).siblings('ul').stop().slideDown(500);
    } 
    prev_button_redeeem = $(this).val();
  });

  $('.service_phone_redeem .redeem_how ul li input:checkbox').click(function(){
    if($(this).val() == "all_location"){
      $(this).parent().siblings('li').find('input').attr('checked', true);
    }
  });

  $('.voucher_codes fieldset > ul > li > input:radio').click(function(){
    if(prev_button_codes != $(this).val()){
      $('.voucher_codes fieldset input:radio').filter(function(index) {
        return $(this).val().match(prev_button_codes);
      }).siblings('ul').slideUp();    
      $(this).siblings('ul').stop().slideDown(500);
    } 
    prev_button_codes = $(this).val();
  });

  $('#exclusion_dates, #age_restrictions, #notification_time').parent().find('ul').hide();

  $('.restrictions fieldset > ul > li > input').click(function(){
    if( $(this).val() == 'exclusion_dates' ||
      $(this).val() == 'age_restrictions' ||
      $(this).val() == 'notification_time'){
      $(this).parent().find('ul').slideDown(500);
    } 

  });



  // popup for offer preview
  //prettyPhoto Call for sample offers
    $("a[rel^='prettyPhotoPreview']").prettyPhoto({
      modal:true,
      social_tools: false,
      allow_resize: true,
      changepicturecallback: function(){
        $('.pp_right button').show();
        $('.pp_left button').show();
      },
      markup: '<div class="pp_pic_holder"> \
          <div class="ppt">&nbsp;</div> \
          <a class="pp_close" href="#">Close</a> \
          <div class="pp_top"> \
            <div class="pp_left"></div> \
            <div class="pp_middle"></div> \
            <div class="pp_right"></div> \
          </div> \
          <div class="pp_content_container"> \
            <div class="pp_left"> \
            <div class="pp_right"> \
              <div class="pp_content"> \
                <div class="pp_loaderIcon"></div> \
                <div class="pp_fade"> \
                  <a href="#" class="pp_expand" title="Expand the image">Expand</a> \
                  <div class="pp_hoverContainer"> \
                    <a class="pp_next" href="#">next</a> \
                    <a class="pp_previous" href="#">previous</a> \
                  </div> \
                  <div id="pp_full_res"></div> \
                  <div id="loaded_container"></div> \
                  <div class="pp_details"> \
                    <div class="pp_nav"> \
                      <a href="#" class="pp_arrow_previous">Previous</a> \
                      <p class="currentTextHolder">0/0</p> \
                      <a href="#" class="pp_arrow_next">Next</a> \
                    </div> \
                    <p class="pp_description"></p> \
                    {pp_social} \
                  </div> \
                </div> \
              </div> \
            </div> \
            </div> \
          </div> \
          <div class="pp_bottom"> \
            <div class="pp_left"><button style="display:none"><img src="/assets/lightbox-print.png"/></button></div> \
            <div class="pp_middle"></div> \
            <div class="pp_right"></div> \
          </div> \
        </div> \
        <div class="pp_overlay"></div>'
    });
	
	//Voucher Length input
	$('.voucher_length').change(function(){
		var input = $(this).val();
		var days = parseFloat(input);
		
		if(isNaN (days)) {
			$('#voucher_length_info').html("Sorry, but that doesn't seem to be a valid input.<span style='color:#D22275;'>Please enter a real number from 1 - 180.</span>");
			$(this).focus();
		} else if (days >= 181) {
			$('#voucher_length_info').html("From 1 to 180 days"),
			$(this).val('180 days')
		} else if (days <= 1) {
			$('#voucher_length_info').html("From 1 to 180 days"),
			$(this).val('1 day')
		} else {
			$('#voucher_length_info').html("From 1 to 180 days"),
			$(this).val(days + ' days')
		}
	});
	
	//Fixing the preview popup error for when user presses enter within an input box
	$('.new_offer_details input').keydown(function(e) {
		if (e.keyCode == 13 && $(this).attr('type') != 'submit') {
			e.preventDefault();
		} else {}
	});
	
	//On new_offer_details this gives the offer_description textarea a character counter
	//Note the format $('input_or_textarea').charCounter('element_to_display_number_of_characters')
	// $('#offer_description').charCounter('.characters');
	

  //input number - append day or days after number
  $numberDaysInput = $('#number_of_days');
  $numberSpan = $('.number_day');
  $numberDaysInput.live('change', function(){
    var daysVal = parseInt($numberDaysInput.val());
    if(daysVal === 1){
      $numberSpan.text('Day');
    }else if(daysVal>1){
      $numberSpan.text('Days');
      if(daysVal>90){
        $numberDaysInput.val(90);
      }
    }else if(daysVal<0 ||daysVal===0 ){
      $numberDaysInput.val(0);
      $numberSpan.text('');
    }
  });
  //Show/hide secondary category based on primary category selection
  $('.category_two_wrapper').hide();

  function secondaryCategory(selector){
    if($(selector).val()){
      $('.category_two_wrapper').hide();
      $('.category_two_wrapper').slideToggle();
    }
  }
  
  //calling on load
  secondaryCategory($('#offer_primary_category')||$('#registration_primary_business_category'));

  $('#offer_primary_category, #registration_primary_business_category').change(function () {
    secondaryCategory($(this));
  });
  
  // show/hide redeem option fields
  $('#offer_redemption_website_url, #offer_redemption_phone_number').parent().hide();

  $('#offer_can_redeem_online, #offer_can_redeem_by_phone').change(function(){
    if ($(this).is(':checked')) {
      $(this).parent().next().slideDown();
    } else {
      $(this).parent().next().slideUp();  
    }
  });

  // gallery
  $('#gallery_image_preview_box .submit').live('click', function() {
    var id = $(this).attr('data-library-image-id');
    var url = $(this).attr('data-library-image-url');
    $('#offer_library_image_id').val(id);
    $('#library_image').html('<img src="' + url + '" />');
  });
});
