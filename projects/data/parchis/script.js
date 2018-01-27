text = '\
<p> This fun project was my first \"big\" project ever.</p>\
<p> <b>Parchis USB</b>, as named by our teachers, was the last assigment of <i>Laboratory of Algorithms and Structure I</i> course in the <i>Universidad Simón Bolívar</i>.\
It was implemented using <k> Free Pascal </k> and built-in libraries.</p></br>\
'

projects['parchis'] = {
	'title'  : 'Parchis USB',
	'desc'   : 'Simple board game using Pascal',
	'text'   :  text,
	'bullets': ['Free Pascal', 'Introduction to algorithm', 'First programming project', "UI Wasn't required, yet implemented"],
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