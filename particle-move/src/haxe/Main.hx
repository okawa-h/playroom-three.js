package ;

import js.Browser;
import js.html.Event;
import view.*;
import utils.*;

class Main {

	public static function main():Void {

		Browser.document.addEventListener('DOMContentLoaded',init);

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
			Window.setEvent('objectCreated',start);

			setup();
			create();

		}

		/* =======================================================================
			Setup
		========================================================================== */
		private static function setup():Void {

			Camera.init();
			Light.init();
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

			RendererManager.show();
			RendererManager.rendering();

		}

}
