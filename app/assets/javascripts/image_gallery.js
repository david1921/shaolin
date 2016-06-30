//
// Offer image gallery UI
//
(function($) {
  var pp_gallery_markup = '                               \
    <div class="pp_gallery">                              \
      <a href="#" class="pp_arrow_previous">Previous</a>  \
      <div>                                               \
        <ul>                                              \
          {gallery}                                       \
        </ul>                                             \
      </div>                                              \
      <a href="#" class="pp_arrow_next">Next</a>          \
    </div>';

  var pp_markup = '                                                          \
    <div class="pp_pic_holder image_ui">                                     \
      <a class="pp_close" href="#">Close</a>                                 \
      <div class="pp_loaderIcon"><img src="/assets/ajax-loader.gif"/></div>  \
      <div class="innner-wrap">                                              \
        <div class="pp_fade">                                                \
          <a href="#" class="pp_expand" title="Expand the image">Expand</a>  \
          <div class="pp_hoverContainer">                                    \
            <a class="pp_next" href="#">next</a>                             \
            <a class="pp_previous" href="#">previous</a>                     \
          </div>                                                             \
          <div id="pp_full_res"></div>                                       \
          <div class="pp_details">                                           \
            <div class="pp_nav">                                             \
              <a href="#" class="pp_arrow_previous">Previous</a>             \
              <p class="currentTextHolder">0/0</p>                           \
              <a href="#" class="pp_arrow_next">Next</a>                     \
            </div>                                                           \
            <p class="pp_description"></p>                                   \
            <div class="pp_social">{pp_social}</div>                         \
          </div>                                                             \
        </div>                                                               \
      </div>                                                                 \
    </div>                                                                   \
    <div class="pp_overlay"></div>';


  $(function() {
    $('.image_ui_btn')
      .prettyPhoto({
        show_title: false,
        social_tools: '',
        allow_resize: false,
        default_width: '',
        default_height: '',
        markup: pp_markup,
        gallery_markup: pp_gallery_markup,
        callback: function() {
          $('body').removeClass('noscroll');
        }
      })
     .click(function() {
        $(this).addClass('active');
        $('body').addClass('noscroll');
      });
    //
    // Show preview when gallery image is clicked
    //
    $(".view_gallery_img").live('click', function(event) {
      var url = $(this).attr('href');
      var thumbnailUrl = $(this).attr('data-library-image-thumbnail-url');
      var id = $(this).attr('data-library-image-id');
      event.preventDefault();
      $('#gallery_image_preview_box').stop().fadeOut(400, function() {
        $('.gallery_image').find('img').remove().end().append('<img src="'+url+'"/>');
        $('.submit').attr('data-library-image-id', id);
        $('.submit').attr('data-library-image-url', thumbnailUrl);
        $(this).fadeIn(400);
      });
      //
      // Hide preview if click is outside preview box
      //
      $('#gallery_image_preview_box').click(function(event) {
        if($(event.target).closest('.preview_wrap').length == 0) {
          $(this).fadeOut(200);
        }
      });
      $('.cancel').click(function() {
        $('#gallery_image_preview_box').fadeOut(200);
      });
      $('.submit').click(function() {
        $.prettyPhoto.close();
      });
    });
    //
    // Hover action on thumbnail
    //
    $('.image_box')
      .live('mouseenter', function() {
        $(this).children('.image_gallery_over').stop().fadeIn(200);
      })
      .live('mouseleave', function() {
        $(this).children('.image_gallery_over').fadeOut(200);
      });
  });
})(jQuery);
