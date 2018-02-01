function goIndex(){window.location.replace("/index.html");}var hash=window.location.hash
if(hash)hash=hash.split('#')[1];else
goIndex();currProject=projects[hash];if(!currProject){goIndex();}$('.projectTitle').text(currProject['title']);$('.projectDesc').text(currProject['desc']);$('.projectText').html(currProject['text']);$('.projectBanner').html('<img src="'+currProject['banner']+'" alt="" class="img-responsive project-banner" />');if(currProject['bullets']){$('.projectText').addClass('col-md-9');$('.projectBullets').addClass('col-md-3');var bullets='<ul class="cat-ul">'
for(var i=0;i<currProject['bullets'].length;i++){bullets=bullets+'<li><i class="ion-ios-circle-filled"></i>'+currProject['bullets'][i]+'</li>'}bullets=bullets+'</ul>'
console.log(bullets)
$('.projectBullets').html(bullets);}else{$('.projectText').addClass('col-md-12');$('.projectBullets').hide();}if(currProject['images'].length||currProject['videos'].length){}else{$('.projectGallery').hide();}