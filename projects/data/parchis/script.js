text = '\
<p> This fun project was my first \"big\" project ever.</p>\
<p> <b>Parchis USB</b>, as named by our teachers, was the last assigment of <i>Laboratory of Algorithms and Structure I</i> course in the <i>Universidad Simón Bolívar</i>.\
It was implemented using <k> Free Pascal </k> and built-in libraries.</p>\
<p>It was divided in two deliveries. In first one, we had to modularize all of our program and set the expected preconditions and postconditions of each module. In the final part, we had to\
have a working game. We were assigned on groups of two (pair-programming introduction) and we had 4 weeks to achieve so. </p>\
<p> This one was not a hard project, as we were only expected to describe each turn in text ("Player moves: 5 steps" or so) but I decided to go further and implement a whole working interface. \
I implemented some text-drawing methods and playing with console-clear we ended up having a nice looking game, even with animations included. </p> \
<p> Overall, this one was a fun and enriching project. As I was eager and excited to experiment with programming, I learnt a lot and was quite happy with the result. </p>\
<p> I must add, that game-developing as motivation was a smart move from our teachers. It should be applied in multiples programming learning courses. </p>\
<p><i>Below you may find some captures and video clips of the project. Sadly, I was only able to find unfinished versions of the project.</i></p> </br>\
'

projects['parchis'] = {
	'title'  : 'Parchis USB',
	'desc'   : 'Simple board game using Pascal',
	'text'   :  text,
	'bullets': ['Free Pascal', 'Introduction to algorithm', 'First programming project', "UI Wasn't required, yet implemented", "4 weeks long", "2 Person teams"],
	'banner' : 'projects/data/parchis/banner.png',
	'cats'   : ['academic'],
	'images' : [
	{
		description: 'Main menu',
		href: 'projects/data/parchis/images/1.png',
		poster: 'projects/data/parchis/images/1.png'
	},
	{
		description: 'Possible actions',
		href: 'projects/data/parchis/images/2.png',
		poster: 'projects/data/parchis/images/2.png'
	},
	{
		description: 'Player\'s Turn',
		href: 'projects/data/parchis/images/2.png',
		poster: 'projects/data/parchis/images/2.png'
	},
	],
	'videos' : [
	{
		description: 'Intro',
		href: 'projects/data/parchis/videos/1.mp4',
		type: 'video/mp4',
		poster: 'img/play-icon.png'
	},
	{
		description: 'Pawn "eating" other.',
		href: 'projects/data/parchis/videos/2.mp4',
		type: 'video/mp4',
		poster: 'img/play-icon.png'
	},
	{
		description: 'Game animations (screen refresh)',
		href: 'projects/data/parchis/videos/3.mp4',
		type: 'video/mp4',
		poster: 'img/play-icon.png'
	}
	],
}