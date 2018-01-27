/*
 * blueimp Gallery Demo JS
 * https://github.com/blueimp/Gallery
 *
 * Copyright 2013, Sebastian Tschan
 * https://blueimp.net
 *
 * Licensed under the MIT license:
 * https://opensource.org/licenses/MIT
 */

 /* global blueimp, $ */

 $(function () {
  'use strict'

  // Load demo images from flickr:
  $.ajax({
    url: 'https://api.flickr.com/services/rest/',
    data: {
      format: 'json',
      method: 'flickr.interestingness.getList',
      api_key: '7617adae70159d09ba78cfec73c13be3' // jshint ignore:line
    },
    dataType: 'jsonp',
    jsonp: 'jsoncallback'
  }).done(function (result) {
    var carouselLinks = []
    var linksContainer = $('#links')
    var baseUrl
    // Add the demo images as links with thumbnails to the page:
    carouselLinks.push(    {
      description: 'Sintel',
      href: 'https://archive.org/download/Sintel/' +
      'sintel-2048-surround.mp4',
      type: 'video/mp4',
      poster: 'https://i.imgur.com/MUSw4Zu.jpg'
    })
    
    $('<a/>')
    .append($('<img class="galleryImg">').prop('src', '../img/play-icon.png'))
    .prop('href', 'https://archive.org/download/Sintel/sintel-2048-surround.mp4')
    .attr('data-description', 'Sintel')
    .prop('type', 'video/mp4')
    .attr('data-gallery', '')
    .appendTo(linksContainer)    


    $.each(result.photos.photo, function (index, photo) {
      baseUrl = 'https://farm' + photo.farm + '.static.flickr.com/' +
      photo.server + '/' + photo.id + '_' + photo.secret
      $('<a/>')
      .append($('<img class="galleryImg">').prop('src', baseUrl + '_s.jpg'))
      .prop('href', baseUrl + '_b.jpg')
      .attr('data-description', photo.title)
      .attr('data-gallery', '')
      .appendTo(linksContainer)
      carouselLinks.push({
        href: baseUrl + '_c.jpg',
        title: photo.title,
        description: photo.title,
      })
    })
    // Initialize the Gallery as image carousel:
    blueimp.Gallery(carouselLinks, {
      container: '#blueimp-image-carousel',
      carousel: true
    })
  })
})