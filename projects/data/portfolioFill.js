    function goIndex() {
      // Redirect home if wrong hash or non-existent project
      window.location.replace("/index.html");
    }

    function setCategories(cats) {
      myCats = "";
      $.each(cats, function(i,cat) {
        myCats = myCats + ('<em class="'+cat+' titlecase">'+cat+'</em>');
      });
      return myCats;
    }

    console.log(projects);
    $.each(projects, function(key,project) {
      var projectItem = '<div class="col-md-4 col-sm-6 '+project['cats'].join(' ')+'">\
      <a href="single-project.html#'+key+' " class="portfolio_item">\
      <img src="'+project['banner']+'" alt="image" class="img-responsive" />\
      <div class="portfolio_item_hover">\
      <div class="portfolio-border clearfix">\
      <div class="item_info">\
      <span>'+project['title']+'</span>'+
      setCategories(project['cats'])+
      '</div>\
      </div>\
      </div>\
      </a>\
      </div>'
      $('.portfolio_container').append(projectItem)
    })