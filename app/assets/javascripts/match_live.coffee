vote = (match_id, team_id, cb)->
  $.get("/matches/#{match_id}/vote_for_team", {team_id}).done (data)-> cb(data)

$ ->
  $(document).on 'click', '.vote_button', (e)->
    e.preventDefault()
    $link = $(@)
    link = @
    $links = $('.vote_button')
    $teamHomeSpan = $('.vote-buttons').find('.team-home').find('span')
    $teamGuestSpan = $('.vote-buttons').find('.team-guest').find('span')
    $span = $link.find('span')
    match_id = $link.data('matchId')
    team_id = $link.data('teamId')
    vote match_id, team_id, (data)->
      if data.error? 
        return showNotices(data.error)
      $teamHomeSpan.text(data.home_votes)
      $teamGuestSpan.text(data.guest_votes)
      $links.removeClass('active')
      $link.addClass('active')
      showNotices(data.success)
#      $('.socials').show()
      $.fn.custombox(link, customClass: 'share-modal')

  $(document).on 'click', '.close-button', (e)->
    e.preventDefault()
#    $('.socials').hide()


  $(document).on 'click', '.share-facebook', (e)->
    e.preventDefault()
    FB.ui
      method: 'share'
      message: $(this).data("matchTitle")
      href: $(this).data("matchUrl")

  $(document).on 'click', '.share-vk', (e)->
    e.preventDefault()
    window.open($(this).attr("href"),'displayWindow', 'width=700,height=400,left=300,top=200,location=no, directories=no,status=no,toolbar=no,menubar=no');







