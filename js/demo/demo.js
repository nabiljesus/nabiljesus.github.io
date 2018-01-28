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

 function shuffle(array) {
  var currentIndex = array.length, temporaryValue, randomIndex;

  while (0 !== currentIndex) {

    randomIndex = Math.floor(Math.random() * currentIndex);
    currentIndex -= 1;

    temporaryValue = array[currentIndex];
    array[currentIndex] = array[randomIndex];
    array[randomIndex] = temporaryValue;
  }

  return array;
}




$(function () {
  'use strict'
  //console.log(projects);
  // Load demo images from flickr:
  var gallery = currProject['images'].concat(currProject['videos']);
  gallery = shuffle(gallery);

  var linksContainer = $('#links')
  $.each(gallery, function (index, item) {
    console.log(item)
    $('<a/>')
    .append($('<img class="galleryImg">').prop('src', item.poster))
    .prop('href', item.href)
    .attr('data-description', item.description)
    .prop('type', item.type)
    .attr('data-gallery', '')
    .appendTo(linksContainer)
      /*carouselLinks.push({
        href: baseUrl + '_c.jpg',
        title: photo.title,
        description: photo.title,
      })*/
    }) 


})