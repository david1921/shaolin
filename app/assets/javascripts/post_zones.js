var Analog = Analog || {};

Analog.PostZone = (function($) {
  var $container;
  var config = { server_url: '/post_zones/:post_code:.json' };

  var lookup_result = function(address) {
    return $('<span>'+address.lines.join(", ")+', '+address.post_town+'</span>')
      .addClass("post-zone-address")
      .click(function() {
        $container.trigger("analog.post-zone.select-address", address);
      });
  };
  return {
    attach: function(container, options) {
      $container = $(container);
      if (options) {
        $.extend(config, options);
      }
    },
    lookup: function(post_code, $addresses) {
      var url = '/post_zones/'+post_code+'.json';
      $addresses = $($addresses);

      $.ajax({
        url: config.server_url.replace(/:post_code:/, post_code),
        dataType: 'jsonp',
        success: function(data) {
          if ($addresses) {
            $.each(data.addresses, function(index, value) {
              var result = lookup_result({ post_code: data.post_code, post_town: data.post_town, lines: value });
              $addresses.append(result);
            });
          }
          $container.trigger("analog.post-zone.lookup-results", data);
        },
        error: function() {
          $container.trigger("analog.post-zone.lookup-failure");
        }
      });
    }
  };
})(jQuery);