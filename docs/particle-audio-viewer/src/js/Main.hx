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
		private static function init(event:Event):Void {

			Window.init();
			Window.setEvent({ 'audioLoaded':setup });
			AudioManager.load();

		}

	/* =======================================================================
		Setup
	========================================================================== */
	public static function setup():Void {

		EventManager.init();
		RendererManager.init();
		SceneManager.init();
		ObjectManager.init();

		new JQuery('#stage').append(RendererManager.getElement());
		create();

	}

		/* =======================================================================
			Create
		========================================================================== */
		private static function create():Void {

			Camera.init();
			Light.init();
			Helper.init();
			OrbitControlsManager.init();

			ObjectManager.create();
			EventManager.setEvent();
			RendererManager.rendering();

		}

}
