$(function() {
	$.fn.charCounter = function(display) {
		var display = display;
		
		$(this).each(function(){
			// get current number of characters
			var length = $(this).val().length;
			// Uncomment the line below to get number of words rather than characters
			// var length = $(this).val().split(/\b[\s,\.-:;]*/).length;
			
			// update characters
			$(display).html( length + ' characters');
			
			// bind on key up event
			$(this).keyup(function(){
				// get new length of characters
				var new_length = $(this).val().length;
				// Uncomment the line below to get numbers of words rather than characters
				// var new_length = $(this).val().split(/\b[\s,\.-:;]*/).length;
				$(display).html( new_length + ' characters');
			});
		});
	}
});