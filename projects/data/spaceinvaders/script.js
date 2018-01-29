text = '\
<p> This game was the last assigment of <i>Organization of the computer</i> course in the <i>Universidad Simón Bolívar</i>.\
It was implemented using <k> MARS (MIPS Assembler and Runtime Simulator)</k>.</p>\
<p>The task was to use the MARS tools of keyboard and bitmap simulator to create a simpler copy of the classic game. It was meant to have an smaller resolution, as the assigment\
only asked for colorized pixels to represent each element. I chose to use a bigger resolution of 512x1024 in order to display the invaders as they really were. It added additionall complexity to\
the project, but the outcome worth the effort. I developed multiples \'functions\' to draw each element, play the sounds and handle the exceptions in order to just implement the main loop of the game.</p>\
<p> Being honest, this was one of the projects I ejoyed most developing. </p> </br>\
'

projects['spaceinvaders'] = {
	'title'  : 'Space Invaders USB',
	'desc'   : 'Classic game implemented on MARS',
	'text'   :  text,
	'bullets': ['Mips Assembly', "Individual"],
	'banner' : 'projects/data/spaceinvaders/banner.png',
	'cats'   : ['academic'],
	'images' : [
	{
		description: 'Early development',
		href: 'projects/data/spaceinvaders/images/1.png',
		poster: 'projects/data/spaceinvaders/images/1.png'
	},
	{
		description: 'In-Game Capture',
		href: 'projects/data/spaceinvaders/images/2.png',
		poster: 'projects/data/spaceinvaders/images/2.png'
	},
	{
		description: 'Game over (it can be destroyed)',
		href: 'projects/data/spaceinvaders/images/3.png',
		poster: 'projects/data/spaceinvaders/images/3.png'
	},
	{
		description: 'In-Game Capture',
		href: 'projects/data/spaceinvaders/images/4.png',
		poster: 'projects/data/spaceinvaders/images/4.png'
	},
	{
		description: 'The ship (USB Logo)',
		href: 'projects/data/spaceinvaders/images/5.png',
		poster: 'projects/data/spaceinvaders/images/5.png'
	},
	{
		description: 'The invaders',
		href: 'projects/data/spaceinvaders/images/6.png',
		poster: 'projects/data/spaceinvaders/images/6.png'
	},
	{
		description: 'Laser design',
		href: 'projects/data/spaceinvaders/images/7.png',
		poster: 'projects/data/spaceinvaders/images/7.png'
	},
	{
		description: 'Invader pose 1 design',
		href: 'projects/data/spaceinvaders/images/8.png',
		poster: 'projects/data/spaceinvaders/images/8.png'
	},
	{
		description: 'Invader pose 2 design',
		href: 'projects/data/spaceinvaders/images/9.png',
		poster: 'projects/data/spaceinvaders/images/9.png'
	},
	{
		description: 'Ship design',
		href: 'projects/data/spaceinvaders/images/10.png',
		poster: 'projects/data/spaceinvaders/images/10.png'
	}
	],
	'videos' : [],
}