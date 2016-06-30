// Fading tabs designed for home page
$(document).ready(function(){
  // hide all then show first tab by default
  $('.home .tabs > div').hide();
  $('.home .tabs > div:first').show();
  $('.home .tabs ul li:first').addClass('active');
 
  $('.home .tabs ul li a, .home #offers h3 a').click(function(){
    var currentTab = $(this).attr('href');
    var prevTab = $('.home .tabs ul li.active a').attr('href');
    // mark active tab
    $('.home .tabs ul li').removeAttr('class');
    $('.home .tabs ul li a[href$="'+ currentTab +'"]').parent().addClass('active');
    
    // fade out/in if not current tab
    if( prevTab != currentTab ) {
      $(prevTab).queue(function(next) {
        $(this).stop().fadeOut(200, function() {
          $(currentTab).fadeIn(600);
        });
        next();
      });
    }
    
    return false;
  });
});
