$(document).ready(function(){
    var target = $('a.help');

    //target the ipad and iphone --probably need to add android here at some point
    if((navigator.userAgent.match(/iPhone/i)) || (navigator.userAgent.match(/iPod/i)) || (navigator.userAgent.match(/iPad/i))) {
        target.on('click', function(){
            //just attaching a click event listener to provoke iPhone/iPod/iPad's hover event for now
        });
        
        $(document).on('touchstart', function() {
        });
    }
});