$('.tlt').textillate({
  autoStart: true,
  loop: true,
  minDisplayTime: 1000,
  // custom set of 'in' effects. This effects whether or not the
  // character is shown/hidden before or after an animation
  inEffects: ['flipInY'],

  // custom set of 'out' effects
  outEffects: [ 'hinge' ],

  // in animation settings
  in: {
    // set the effect name
    effect: 'flipInY',

    // set the delay factor applied to each consecutive character
    delayScale: 0.5,

    // set the delay between each character
    delay: 50,

    // set to true to animate all the characters at the same time
    sync: false,

    // randomize the character sequence
    // (note that shuffle doesn't make sense with sync = true)
    shuffle: false,

    // reverse the character sequence
    // (note that reverse doesn't make sense with sync = true)
    reverse: false,

    // callback that executes once the animation has finished
    callback: function () {}
},

  // out animation settings.
  out: {
    effect: 'flipOutY',
    delayScale: 0.5,
    delay: 50,
    sync: false,
    shuffle: false,
    reverse: false,
    callback: function () {}
},
type: 'char'
});