$(document).ready(function(){
/*
if($('#location_photos').val() == ''){
	$('#submit_new_location').attr({'disabled':true});
}

$('#location_photos').change(function(){
	if($('#location_photos').val() == ''){
		$('#submit_new_location').attr({'disabled':true});
	}
	else{
		$('#submit_new_location').attr({'disabled':false});
	}
});
*/

$('#mainRightBar .review-page').css({'min-height':$('.left-bar').height()-38});

$('.tabs-container').liteTabs({
  borders : false,
  boxed : false,          
  fadeIn : false,       
  height : 'auto',       
  hideHash : false,      
  rounded : true,        
  selectedTab : 1,      
  width : 1000
});

$(".fancybox").fancybox({
    openEffect  : 'none',
    closeEffect : 'none'
  });

$('.fancybox-media').fancybox({
    openEffect  : 'none',
    closeEffect : 'none',
    helpers : {
      media : {}
    }
  });
});
