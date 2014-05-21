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

postsList = []
#get the ID of the page 
getPage = (url)->
  pageId = url.substring(url.lastIndexOf('/'))
  graphUrl = "https://graph.facebook.com#{pageId}"
  #send ajax request for the ID of this page
  $.ajax(
    url: graphUrl,
    success: (data)->
      console.log data.id
      id = data.id
      userName = data.username
      #get the posts in the page by graph api
      FB.api("/#{id}?fields=posts.limit(5)",
        (response)->
          console.log response.posts.data.length
          #parse all the result of the posts in the page
          for key, val of response.posts.data
            console.log val.created_time
            console.log val.link
            postID = val.id
            if postID not in postsList
              postsList.unshift(postID)
              #if the post has link, the link will be the url of this post
              if val.link and String(val.link).search('facebook') > 0
                $('.postPage').append("<div class=\"fb-post\" data-href=#{val.link} data-width=\"100%\"></div>")
              else
                for actionKey, actionVal of val.actions
                  if Number(actionKey) is 0
                    $('.postPage').append("<div class=\"fb-post\" data-href=#{actionVal.link.replace(id,userName)} data-width=\"100%\"></div>")
                    console.log "actionlink=#{actionVal.link.replace(id,userName)}"
              compareTime(val.created_time, (response)->
                if response is true
                  comment(postID,$('input[name=message]').val())
              )
          #reload the post page to show the facebook posts
          FB.XFBML.parse($('.postPage').get(0))
      )
  )

#compare the time of the post tp the beginning time
compareTime = (pTime, callback)->
  postTime = new Date pTime
  if postTime > startTime
    callback? true
  else
    callback? false


refreshPageInfo = ()->
  getPage($('input[name=searchString]').val())

#when search button is click
#call the getPageID ti get the ID of the page
exe = null
#the time start executing
startTime = null
$('.searchBtn').click ()->
  FB.getLoginStatus (response) ->
    if response.status is "connected"
      $('.postPage').html('')
      startTime = new Date()
      exe = setInterval("refreshPageInfo()", 3000)
    else
      alert 'please login first'

$('.cancelBtn').click ()->
  clearInterval(exe)

$('#get-checkins').click ()->
  getCheckins()

$('#get-info').click ()->
  alert "\"hi\""

$('#get-access-token').click ()->
    console.log response.authResponse.accessToken
