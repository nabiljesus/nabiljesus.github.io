$(document).ready(function() {
    defineCanvas();
    window.onresize = defineCanvas;

    function defineCanvas() {
        var canvas = document.getElementById("myCanvas");
        var width = $('#myCanvasContainer').width(); 
        var height = $(window).height(); 
        canvas.width =width;
        canvas.height = canvas.width;
        $("#myCanvas").tagcanvas("delete");
        if( ! $('#myCanvas').tagcanvas({
            dragControl: true,
            textColour : '#999',
            outlineThickness : 1,
            maxSpeed : 0.03,
            imageMode: 'both',
            imagePosition: 'top',
            fadeIn: 1,
            imagePadding: 1,
            initial: [0.3,-0.3],
            outlineColour: 'transparent',
            depth : 0.80    ,
            zoomMin: 0.85,   
            zoomMax: 1.10,
            wheelZoom: false,
            centreImage: 'img/fav.png'
        })) {
         $('#myCanvasContainer').hide();
     }
 }
});