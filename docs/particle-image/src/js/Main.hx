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
			EventManager.init();
			RendererManager.init();
			SceneManager.init();
			ObjectManager.init();
			Stage.init(RendererManager.getElement());

			setup();
			Window.setEvent({ 'materialLoaded':create });
			Window.setEvent({ 'objectCreated':start });
			MaterialManager.load();

		}

		/* =======================================================================
			Setup
		========================================================================== */
		private static function setup():Void {

			Camera.init();
			Light.init();
			Helper.init();
			OrbitControlsManager.init();

		}

		/* =======================================================================
			Create
		========================================================================== */
		private static function create():Void {

			ObjectManager.create();
			EventManager.setEvent();

		}

		/* =======================================================================
			Start
		========================================================================== */
		private static function start():Void {

			Stage.show();
			RendererManager.rendering();

		}

}
