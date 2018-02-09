package ;

import js.jquery.JQuery;
import js.jquery.Event;
import object.*;
import view.*;
import utils.*;

class Main {

	public static function main():Void {

		new JQuery('document').ready(init);

	}

	/* =======================================================================
		Constractor
	========================================================================== */
	private static function init():Void {

		Window.init();
		EventManager.init();
		RendererManager.init();
		SceneManager.init();
		Enviroment.init();

		MediaManager.isUseWebCamera = true;
		MediaManager.load([

			{ id:'movie',type:'video',src:'files/movie/movie.mp4?2' }

		]);


	}

		/* =======================================================================
			Create
		========================================================================== */
		public static function create():Void {

			ObjectManager.init();
			EventManager.setEvent();

			RendererManager.start();

		}

}
