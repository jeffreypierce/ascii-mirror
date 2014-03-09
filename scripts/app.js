(function() {
  var animationLoop, blackThreshold, captureCtx, captureImage, contrastSlider, contrastValue, drawAscii, errorCallback, errorTxt, height, init, introTxt, mirror, mirrorCtx, mirrorScale, palette, resSlider, resValue, resolution, reversePalette, scaleSlider, scaleValue, snapshot, start, startLink, successCallback, videoEl, whiteThreshold, width;

  window.requestAnimationFrame = window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame;

  navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia;

  width = 640;

  height = 360;

  resolution = 0.0075;

  blackThreshold = 12;

  whiteThreshold = 230;

  videoEl = document.querySelector("video");

  snapshot = document.querySelector('.snapshot');

  mirror = document.querySelector('.mirror');

  resSlider = document.querySelector('#resolution input');

  resValue = document.querySelector('#resolution .value');

  scaleSlider = document.querySelector('#scale input');

  scaleValue = document.querySelector('#scale .value');

  contrastSlider = document.querySelector('#contrast input');

  contrastValue = document.querySelector('#contrast .value');

  startLink = document.querySelector('.start');

  errorTxt = document.querySelector('.error');

  introTxt = document.querySelector('.intro');

  snapshot.width = videoEl.videoWidth = width;

  snapshot.height = videoEl.videoHeight = height;

  captureCtx = snapshot.getContext('2d');

  mirrorScale = 1.5;

  mirror.width = width * mirrorScale;

  mirror.height = height * mirrorScale;

  mirrorCtx = mirror.getContext('2d');

  mirrorCtx.font = "300 10px Source Sans Pro";

  mirrorCtx.fillStyle = '#D3C7BF';

  palette = "@#$%&8BMW*mwqpdbkhaoQ0OZXYUJCLtfjzxnuvcr[]{}1()|/?Il!i><+_~-;,. ";

  reversePalette = function() {
    return palette = palette.split("").reverse().join("");
  };

  resSlider.onchange = function(e) {
    resValue.innerHTML = this.value;
    return resolution = (100 - this.value) / 10000 + 0.0025;
  };

  scaleSlider.onchange = function(e) {
    scaleValue.innerHTML = this.value;
    return mirrorScale = this.value * 0.02;
  };

  contrastSlider.onchange = function(e) {
    contrastValue.innerHTML = this.value;
    blackThreshold = Math.abs((this.value - 75) / 2);
    return whiteThreshold = 255 - 75 + parseInt(this.value, 10);
  };

  mirror.onclick = function(e) {
    return reversePalette();
  };

  captureImage = function() {
    var data, imageData;
    if (window.stream) {
      captureCtx.drawImage(videoEl, 0, 0);
      imageData = captureCtx.getImageData(0, 0, width, height);
      data = imageData.data;
      return drawAscii(data);
    }
  };

  drawAscii = function(data) {
    var b, char, colorData, g, grey, hRes, index, r, result, vRes, x, xoffset, y, yoffset;
    result = '';
    vRes = width * resolution;
    hRes = vRes * 1.5;
    mirrorCtx.clearRect(0, 0, mirror.width, mirror.height);
    y = 0;
    while (y < height) {
      x = 0;
      while (x < width) {
        y = Math.floor(y);
        x = Math.floor(x);
        colorData = ((width * y) + x) * 4;
        r = data[colorData];
        g = data[colorData + 1];
        b = data[colorData + 2];
        grey = Math.floor(0.3 * r + 0.59 * g + 0.11 * b);
        if (grey > whiteThreshold) {
          grey = 255;
        } else if (grey < blackThreshold) {
          grey = 0;
        } else {
          grey = Math.floor(255 * ((grey - blackThreshold) / (whiteThreshold - blackThreshold)));
        }
        index = Math.floor(grey / 4);
        char = palette.charAt(index);
        xoffset = (960 / 2) - (width * mirrorScale / 2);
        yoffset = (540 / 2) - (height * mirrorScale / 2);
        mirrorCtx.fillText(char, ((width - x) * mirrorScale) + xoffset, y * mirrorScale + yoffset);
        result += char;
        x += vRes;
      }
      result += "\n";
      y += hRes;
    }
    return result;
  };

  animationLoop = function() {
    console.log('loop');
    captureImage();
    return requestAnimationFrame(animationLoop);
  };

  successCallback = function(stream) {
    window.stream = stream;
    videoEl.src = window.URL.createObjectURL(stream);
    videoEl.play();
    return start();
  };

  errorCallback = function(error) {
    introTxt.addClass('hidden');
    errorTxt.innerHTML = 'Sorry. There was an error trying to reach your camera.<br/>\nYour browser is probably out of date.<br/>\nWhy not try Chrome?<br/><br/>\nIf you are using Chrome and have a camera connected,<br/>\nrefesh the page and try again.';
    introTxt.className += ' hidden';
    return console.log("navigator.getUserMedia error: ", error);
  };

  init = function() {
    var constraints;
    if (!!window.stream) {
      videoElement.src = null;
      window.stream.stop();
    }
    constraints = {
      video: true
    };
    if (navigator.getUserMedia) {
      return navigator.getUserMedia(constraints, successCallback, errorCallback);
    } else {
      return errorCallback;
    }
  };

  start = function() {
    introTxt.className += ' hidden';
    reversePalette();
    return animationLoop();
  };

  startLink.onclick = function(e) {
    return init();
  };

}).call(this);
