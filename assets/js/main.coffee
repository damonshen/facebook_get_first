getPermission = ()->
  FB.api('/me/permissions',
    (response) ->
      for key, value of response.data
        console.log "#{key} #{JSON.stringify value}"
  )

#comment on the page
comment = (postID, message)->
  FB.api(
    "/#{postID}/comments",
    "POST",
    {
        "message": message
    },
    (response) ->
      console.log JSON.stringify response
  )

#get the ID of the page 
getPageID = (url)->
  id = url.substring(url.lastIndexOf('/'))
  graphUrl = "https://graph.facebook.com#{id}"
  #send ajax request for the ID of this page
  $.ajax(
    url: graphUrl,
    success: (data)->
      console.log data.id
      id = data.id
      FB.api("/#{id}?fields=posts.limit(5)",
        (response)->
          console.log response.posts.data.length
          #console.log JSON.stringify response
          for key, val of response.posts.data
            console.log val.created_time
            console.log val.link
            #if the post has link, the link will be the url of this post
            if val.link isnt undefined
              $('.postPage').append("<div class=\"fb-post\" data-href=#{val.link} data-width=\"100%\"></div>")
              comment(val.id,"nice")
            else
              for actionKey, actionVal of val.actions
                console.log actionKey + " " + JSON.stringify actionVal
                if actionKey is 0
                  $('.postPage').append("<div class=\"fb-post\" data-href=#{actionVal.link} data-width=\"100%\"></div>")
                  console.log "actionlink=#{actionVal.link}"
          FB.XFBML.parse($('.postPage').get(0))
      )
  )

#when search button is click
#call the getPageID ti get the ID of the page
$('.searchBtn').click ()->
  getPageID($('input[name=searchString]').val())

$('#get-checkins').click ()->
  getCheckins()

$('#get-info').click ()->
  alert "\"hi\""

$('#get-access-token').click ()->
    console.log response.authResponse.accessToken
