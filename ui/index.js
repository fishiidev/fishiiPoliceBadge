$(function() {
    

    window.addEventListener('message', function(event) {
        let data = event.data;

        // Show the badge and after 5 seconds hide it
        if (data.type == 'displayBadge') {
            $('.badge').css('background-image', `url(${data.badge_photo})`);
            $('.badge').show();
            $('.badge').css('animation', 'slideIn .5s ease-in-out forwards');
            setTimeout(function() {
                $('.badge').css('animation', 'slideOut .5s ease-in-out forwards');
            }, 5000);
            
        }

    });
});


