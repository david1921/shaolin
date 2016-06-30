//javascript ready() which is waiting for the dom (and jQuery) to load.
function ready(callback) {
  /in/.test(document.readyState) ? setTimeout('ready('+callback+')', 9) : callback();
}

ready(function() {
  //feature test for placeholder. If placeholder is not supported, mimic it.
  if(!Modernizr.input.placeholder){
    $('[placeholder]').focus(function(){
      var input = $(this);
      if (input.val() == input.attr('placeholder')){
        input.val('');
        input.removeClass('placeholder');
      }
    }).blur(function() {
      var input = $(this);
      if (input.val() == '' || input.val() == input.attr('placeholder')){
        input.addClass('placeholder');
        input.val(input.attr('placeholder'));
      }
    }).blur();
    $('[placeholder]').parents('form').submit(function(){
      $(this).find('[placeholder]').each(function(){
        var input = $(this);
        if (input.val() == input.attr('placeholder')){
          input.val('');
        }
      });
    });
  }
  
  // Tooltip for IE7.
  if($.browser.msie && parseInt($.browser.version, 10) == 7){
    $('.help').hover(function(){
      var tooltip = $(this).data('tooltip');
      $(this).data('zindex', $(this).parent('fieldset').css('z-index'))
      $(this).parent('fieldset').css('z-index','10000');
      $(this).after('<div class="ie7-tooltip">'+ tooltip +'</div>');
    },function(){
      $(this).next('.ie7-tooltip').remove();
      $(this).parent('fieldset').css('z-index',$(this).data('zindex'));
    });
  } 
});

