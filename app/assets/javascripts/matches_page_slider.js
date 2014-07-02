var hwSlideSpeed = 700;
var hwTimeOut = 3000;
var hwNeedLinks = true;
$(document).ready(function(e) {
  $sectionPlayers = $('.section-players')
    $(document).on('click', '.tabs li', function(){
      $(this).addClass('current').siblings().removeClass('current')
        .parents('div.section-players')
          .find('div.box')
          .eq($(this).index())
          .fadeIn(150)
          .siblings('div.box')
          .hide();
    })



    var $developmentsBox = $('.developments')
    var $spoilerButton = $developmentsBox.find('.spoiler')
    var $outerGoals = $('.outer-goals')
    var $goalsBox = $outerGoals.find('.goals-js')
    var $spanTextBox = $goalsBox.find('.text')
    $(document).on('click', '.spoiler', function(e){
      e.preventDefault();
      if (/spoiler_close/.test($('.spoiler').attr('class'))){
        $spoilerButton.css({bottom: 6 + 'px'});
      }else{
        $spoilerButton.css({bottom: '-' + ($goalsBox.height() - 80) + 'px'});
      }
      $spoilerButton.toggleClass('spoiler_close').toggleClass('spoiler_open')
      $('.outer-goals').toggleClass('visible-goals');
    })

    $('.slide').css(
        {"position" : "absolute",
         "top":'0', "left": '0'}).hide().eq(0).show();
    var slideNum = 0;
    var slideTime;
    slideCount = $("#slider .slide").size();
    var animSlide = function(arrow){
        clearTimeout(slideTime);
        $('.slide').eq(slideNum).fadeOut(hwSlideSpeed);
        if(arrow == "next"){
            if(slideNum == (slideCount-1)){slideNum=0;}
            else{slideNum++}
            }
        else if(arrow == "prew")
        {
            if(slideNum == 0){slideNum=slideCount-1;}
            else{slideNum-=1}
        }
        else{
            slideNum = arrow;
            }
        $('.slide').eq(slideNum).fadeIn(hwSlideSpeed, rotator);
        $(".control-slide.active").removeClass("active");
        $('.control-slide').eq(slideNum).addClass('active');
        }
        if(hwNeedLinks){
        var $linkArrow = $('<a id="prewbutton" href="#"></a><a id="nextbutton" href="#"></a>')
            .prependTo('#slider');
            $('#nextbutton').click(function(e){
                e.preventDefault();
                animSlide("next");
                })
            $('#prewbutton').click(function(e){
                e.preventDefault();
                animSlide("prew");
                })
        }
        var pause = true;
        var rotator = function(){
        if(!pause){slideTime = setTimeout(function(){animSlide('next')}, hwTimeOut);}
                }
        $('#slider-wrap').hover(   
            function(){clearTimeout(slideTime); pause = true;},
            function(){pause = true; rotator();
            });
        rotator();
});