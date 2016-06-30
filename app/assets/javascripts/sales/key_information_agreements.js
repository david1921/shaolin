(function($) {
  $(function() {
    var $signatureBox = $('#signature_box');

    $signatureBox.jSignature();

    $('#signature_reset').click(function(event){
      event.preventDefault();
      $signatureBox.jSignature("reset");
    });

    $('#submit').click(function(event) {
      var content;
      content = $signatureBox.jSignature("getData", "svg");

      if (400 > content[1].length) {
        event.preventDefault();
        alert("A signature is required");
      }
      $('#key_information_agreement_signature_params_type').val(content[0]);
      $('#key_information_agreement_signature_params_data').val(content[1]);
    });
  });
})(jQuery);
