$(document).ready(function() {

/*------------simple menu-------------*/
	$("#menu_top > li > a").wrapInner('<span></span>');
	$("#menu_top li").hover(function(){
		$(this).addClass('hover');
		$(this).find("ul:first").fadeIn("fast");
	},function(){
		$(this).removeClass('hover');
		$(this).find("ul:first").fadeOut("fast");
	});

/*-------------accordion menu-----------*/
	$(".accordion").find("h3.active").parent().children('div.box').slideDown('fast');
	$('.accordion h3').click(function(){
		var newCurrentListItem = $(this);
		var currentDropDown = newCurrentListItem.parent().children(".box");
		if (newCurrentListItem.is('.active')) {
			$(newCurrentListItem).removeClass("active");
			currentDropDown.slideUp("fast");
		} else {
			currentDropDown.slideDown("fast");
			$('.accordion h3').removeClass("active");
			newCurrentListItem.closest('.accordion').find('.box').not(currentDropDown).slideUp("fast");
			newCurrentListItem.addClass("active");
		}
		});


	$('select').selectBox();


	$('.match_list').each(function(){
		var match_list = $(this).find('.match_pad');
		var elem;
		var z_index = $(match_list).length + 1;
		for ( i = 0 ; i<$(match_list).length ; i++) {
				elem = $(match_list).get(i);
				$(elem).css('z-index',z_index);
				z_index--;
			}
		});

	$('.side_results .open_btn').click(function(){
			var elem = $(this);
			var table_height = $(this).closest('.side_results').find('.list table').height();
			if ( $(elem).hasClass('active') ) {
				$(elem).removeClass('active');
				$(elem).closest('.side_results').find('.list').animate({height:176},300);
			} else {
				$(elem).addClass('active');
				$(elem).closest('.side_results').find('.list').animate({height:table_height},300);
			};
			return false;
		});

/*-----------static-------------*/
	$("div.text").append("<div class='clear'></div>");

	$('table tr:odd').addClass('odd');
	$('table').each(function(){
		$(this).find('tr:even').addClass('even');
	});

	$('.tournaiment_table .list a:odd').addClass('even');

/*-----------scroll top btn---------*/
	$('#up_btn').click(function(){
	   $('html, body').animate({scrollTop:0},{duration:'2000',easing:'swing'});
	   return false;
	});

	var w_h = $(window).height();
	$( window ).scroll(function() {
		w_pos = $(window).scrollTop();
		if ( w_pos >= w_h/2)
			{ $('#up_btn').fadeIn(400); }
			else
			{ $('#up_btn').fadeOut(400); }
	});

/*--------radiobutton-------------*/
	function rCheck(obj) {
		if (!(obj.attr("change"))) {
			obj.closest('form').find('input[name='+ obj.attr('name') +']').removeAttr("change").parent().removeClass('r-chd');
			obj.parent().addClass('r-chd');
			obj.attr("change","change");
		}
	}
  	$("input[type=radio]").each(function() {
		var obj = $(this);
		if ((obj.attr("change"))) {
			obj.closest('form').find('input[name='+ obj.attr('name') +']').removeAttr("change").parent().removeClass('r-chd');
			obj.parent().addClass('r-chd');
			obj.attr("change","change");
		}
		obj.click(function() {rCheck(obj)}).parent().addClass("radio");
	});

/*----------check box----------*/
	function changeCheck(el){
	     var el = el,
		    input = el.find("input").eq(0);
		if(!input.attr("checked")) {
			el.css({backgroundPosition:'0 -20px'});
			input.attr("checked", true)
			} else {
			el.css({backgroundPosition:'0 0'});
			input.attr("checked", false)
			}
	return true;};

	function changeCheckStart(el)
	{var el = el,
			input = el.find("input").eq(0);
		 el.find('span').prepend(el.find("input").attr('value'));
		if(input.attr("checked")) {
			el.css({backgroundPosition:'0 -20px'});
			}
		if(input.attr("disabled"))
			{el.fadeTo(100,0.6);};
	     return true;};

	jQuery(".niceCheck").click(	function() { changeCheck(jQuery(this));	});
	jQuery(".niceCheck").each(	function() { changeCheckStart(jQuery(this));});

/*----end-------checkbox------------------*/

/*----jcarousel----------*/
	$('#jcarousel').jcarousel({
		'wrap':'circular'
	}).jcarouselAutoscroll({
		'interval': 4000
	});

	$('.jcarousel2').jcarousel({
		'wrap':'circular'
	});

/*---simple-tooltip-------*/
var tooltip_structure='<div id="tooltip"> <span class="arw">&nbsp;</span> <span class="txt">&nbsp;</span> </div>';
$('body').append(tooltip_structure);

function show_ttip() {
var titl = $(this).attr('title');
$(this).removeAttr('title');
$("#tooltip").fadeIn(100).children('.txt').html(titl);
}
function move_ttip(kmouse) {
$("#tooltip").css({left:kmouse.pageX-58, top:kmouse.pageY+25});
}
function hide_ttip() {
$(this).attr('title',$('#tooltip .txt').html());
$("#tooltip").fadeOut('fast');
}
$(".tooltip").mouseenter(show_ttip);
$(".tooltip").mousemove(move_ttip);
$(".tooltip").mouseout(hide_ttip);
/*--end--tooltip-------*/

/*----------scrollpane---------*/
    var pane_params = {
        scrollbarWidth:20,
        autoReinitialise: true,
        verticalDragMaxHeight:200,
        verticalDragMinHeight:15,
        verticalGutter:0
    };

	$('.pane').jScrollPane(pane_params);

/*-------------footer at the bottom----------*/
	var hh1 = $('.wrapper').height(); var hh2 = 0;
	function window_height() {
		hh2 = $(window).height();
		if ( hh2 > hh1 ) {
				hh2 = (hh2 - $('header').height() - $('footer ').height());
				$('.content').height(hh2);} 
			else{
				$('.content').css('height','auto');
			};
	};
	window_height();
	$(window).resize(function() {window_height();});

});
