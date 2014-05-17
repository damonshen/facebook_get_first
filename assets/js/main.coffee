initialize = ->
  mapOptions =
    center: new google.maps.LatLng(-34.397, 150.644)
    zoom: 8
    mapTypeId: google.maps.MapTypeId.ROADMAP
  map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions)

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



$('#get-checkins').click ()->
  getCheckins()

$('#get-info').click ()->
  alert "\"hi\""

$('#get-access-token').click ()->
    console.log response.authResponse.accessToken
