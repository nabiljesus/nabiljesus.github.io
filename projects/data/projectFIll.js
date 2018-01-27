    function goIndex() {
      // Redirect home if wrong hash or non-existent project
   		window.location.replace("/index.html");
    }

    var hash = window.location.hash
    if (hash)
    	hash=hash.split('#')[1];
   	else
   		goIndex();

   	currProject = projects[hash];
   	if (!currProject){
   		goIndex();
   	}

    // Set project Title
    $('.projectTitle').text(currProject['title']);

    // Set project brief Desc
    $('.projectDesc').text(currProject['desc']);

    // Set project brief Text
    $('.projectText').text(currProject['text']);

    // Set project brief Banner
    $('.projectBanner').html('<img src="'+currProject['banner']+'" alt="" class="img-responsive" />');

    // Set project bullets
    console.log(currProject['bullets'])
    if (currProject['bullets']){
      $('.projectText').addClass('col-md-9');
      $('.projectBullets').addClass('col-md-3');

      var bullets = '<ul class="cat-ul">'
      for (var i=0; i < currProject['bullets'].length; i++){
        bullets = bullets + '<li><i class="ion-ios-circle-filled"></i>'+currProject['bullets'][i]+'</li>'
      }

      bullets = bullets + '</ul>'
      console.log(bullets)
      $('.projectBullets').html(bullets);
    }
    else {
      $('.projectText').addClass('col-md-12');
      $('.projectBullets').hide();
    }
