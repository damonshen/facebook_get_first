getFriends = ()->
  FB.api(
    {
      method: 'fql.query'
      query: 'select name from profile where id in (select uid2 from friend where uid1 = me())'
    },
    (response)->
      data = JSON.stringify(response)
      data = JSON.parse(data)
      console.log(data + data.length)
  )

getCheckins = ()->
  FB.api(
    {
      method: 'fql.query'
      query: 'select message, type, actor_id, place from stream where source_id in ( SELECT uid2 from friend where uid1 = me()) and place and tagged_ids limit 300'
    },
    (response)->
      for key,value of response
        console.log "#{key} #{JSON.stringify value}"
      console.log(response.length)
  )

getFriendsLikes = ()->
  FB.api('/me/taggable_friends',
    (response) ->
      console.log JSON.stringify response
      for key, value of response.data
        console.log "#{key} #{JSON.stringify value}"
  )

getPermission = ()->
  FB.api('/me/permissions',
    (response) ->
      for key, value of response.data
        console.log "#{key} #{JSON.stringify value}"
  )

comment = ()->
  FB.api(
    "/681775615215777_681777018548970/comments",
    "POST",
    {
        "message": "test"
    },
    (response) ->
      console.log JSON.stringify response
  )

#get the ID of the page 
getPageID = (url)->
  id = url.substring(url.lastIndexOf('/'))
  graphUrl = "https://graph.facebook.com#{id}"
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
            console.log val.link + val.type
            $('.postPage').append("<div class=\"fb-post\" data-href=#{val.link} data-width=\"500\"></div>")
            $('.postPage').append("<div> 123</div>")
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
