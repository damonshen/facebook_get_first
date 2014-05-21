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
                compareTime(val.created_time,new Date())
              else
                for actionKey, actionVal of val.actions
                  if Number(actionKey) is 0
                    $('.postPage').append("<div class=\"fb-post\" data-href=#{actionVal.link.replace(id,userName)} data-width=\"100%\"></div>")
                    console.log "actionlink=#{actionVal.link.replace(id,userName)}"
          #reload the post page to show the facebook posts
          FB.XFBML.parse($('.postPage').get(0))
      )
  )

#compare the time of the post tp the beginning time
compareTime = (pTime, sTime, callback)->
  postTime = new Date pTime
  startTime = new Date sTime
  if postTime > startTime
    console.log 'comment!!!'
  else
    console.log 'old post'


refreshPageInfo = ()->
  getPage($('input[name=searchString]').val())

#when search button is click
#call the getPageID ti get the ID of the page
exe = null
$('.searchBtn').click ()->
  $('.postPage').html('')
  exe = setInterval("refreshPageInfo()", 5000)

$('.cancelBtn').click ()->
  clearInterval(exe)

$('#get-checkins').click ()->
  getCheckins()

$('#get-info').click ()->
  alert "\"hi\""

$('#get-access-token').click ()->
    console.log response.authResponse.accessToken
