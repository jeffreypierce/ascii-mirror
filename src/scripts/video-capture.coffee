window.requestAnimationFrame = window.requestAnimationFrame or
  window.webkitRequestAnimationFrame or
  window.mozRequestAnimationFrame

navigator.getUserMedia = navigator.getUserMedia or
  navigator.webkitGetUserMedia or
  navigator.mozGetUserMedia

width = 1280/2
height = 720/2

resolution = 0.0033
blackThreshold = 12
whiteThreshold = 230

videoEl = document.querySelector("video")
snapshot = document.querySelector('.snapshot')
mirror = document.querySelector('.mirror')
# resSlider = document.querySelector('#resolution input')
# resValue = document.querySelector('#resolution .value')
# scaleSlider = document.querySelector('#scale input')
# scaleValue = document.querySelector('#scale .value')
# contrastSlider = document.querySelector('#contrast input')
# contrastValue = document.querySelector('#contrast .value')
startLink = document.querySelector('.start')
errorTxt = document.querySelector('.error')
introTxt = document.querySelector('.intro')

snapshot.width = videoEl.videoWidth = width
snapshot.height = videoEl.videoHeight = height
captureCtx = snapshot.getContext('2d')

mirrorScale = 3
mirror.width = width * mirrorScale
mirror.height = height * mirrorScale
mirrorCtx = mirror.getContext('2d')
mirrorCtx.font = "400 12px Andale Mono"
mirrorCtx.fillStyle = '#000000'

palette = "@#$%&8BMW*mwqpdbkhaoQ0OZXYUJCLtfjzxnuvcr[]{}1()|/?Il!i><+_~-;,. "

reversePalette = ->
  palette = palette.split("").reverse().join("")

  # resSlider.onchange = (e) ->
  #   resValue.innerHTML = this.value
  #   resolution = (100 - this.value) / 10000 + 0.0025
  #
  # scaleSlider.onchange = (e) ->
  #   scaleValue.innerHTML = this.value
  #   mirrorScale = this.value * 0.02
  #
  # contrastSlider.onchange = (e) ->
  #   contrastValue.innerHTML = this.value
  #   blackThreshold = Math.abs (this.value - 75 ) / 2
  #   whiteThreshold = 255 - 75 + parseInt(this.value, 10)

mirror.onclick = (e) ->
  reversePalette()

captureImage = ->
  if window.stream
    captureCtx.drawImage videoEl, 0, 0

    imageData = captureCtx.getImageData 0, 0, width, height
    data = imageData.data

    drawAscii(data)

drawAscii = (data) ->
  result = ''
  vRes = width * resolution
  # letters aren't square
  hRes = vRes * 1.5
  mirrorCtx.clearRect 0, 0, mirror.width, mirror.height

  y = 0
  while y < height
    x = 0
    while x < width
      y = Math.floor y
      x = Math.floor x
      colorData = ((width * y) + x) * 4

      # get pixel colors
      r = data[colorData]
      g = data[colorData + 1]
      b = data[colorData + 2]

      # greyscale conversion
      grey = Math.floor 0.3 * r + 0.59 * g + 0.11 * b

      # contrast
      if grey > whiteThreshold
        grey = 255
      else if grey < blackThreshold
        grey = 0
      else
        grey = Math.floor(255 *
          ((grey - blackThreshold) /
          (whiteThreshold - blackThreshold))
        )

      index = Math.floor grey / 4
      char = palette.charAt index

      # resolution and scale
      xoffset = (1920/ 2) - (width * mirrorScale / 2)
      yoffset = (1080 / 2) - (height * mirrorScale / 2)

      mirrorCtx.fillText(
        char,
        ((width - x) * mirrorScale) + xoffset,
        y * mirrorScale + yoffset
      )
      result+= char
      x+= vRes

    result+= "\n"
    y+= hRes

  # return string in case we want it later
  result

animationLoop = ->
  console.log 'loop'
  captureImage()
  requestAnimationFrame animationLoop

successCallback = (stream) ->
  window.stream = stream
  videoEl.src = window.URL.createObjectURL stream
  videoEl.play()
  start()

errorCallback = (error) ->
  introTxt.addClass('hidden')
  errorTxt.innerHTML =
    '''Sorry. There was an error trying to reach your camera.<br/>
      Your browser is probably out of date.<br/>
      Why not try Chrome?<br/><br/>
      If you are using Chrome and have a camera connected,<br/>
      refesh the page and try again.
      '''

  introTxt.className += ' hidden'
  console.log "navigator.getUserMedia error: ", error

init = ->
  unless not window.stream
    videoElement.src = null
    window.stream.stop()
  constraints = {video: true}

  if navigator.getUserMedia
    navigator.getUserMedia constraints, successCallback, errorCallback
  else
    errorCallback

start = ->
  # introTxt.className += ' hidden'
  animationLoop()

# startLink.onclick = (e) ->
init()
