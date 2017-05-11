package ;

import js.jquery.JQuery;
import js.jquery.Event;
import object.*;
import view.*;
import utils.*;

class Main {

	public static function main():Void {

		new JQuery('document').ready(cameraInit);

	}

		/* =======================================================================
			Constractor
		========================================================================== */
		private static function cameraInit(event:Event):Void {

			Window.init();
			Window.setEvent({ 'okCamera':init });
			CameraManager.init();

		}

		/* =======================================================================
			Constractor
		========================================================================== */
		private static function init():Void {

			EventManager.init();
			RendererManager.init();
			SceneManager.init();
			ObjectManager.init();
			MaterialManager.init();
			Window.setEvent({ 'materialLoaded':create });
			Window.setEvent({ 'objectCreated':start });

			setup();

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

			RendererManager.show();
			RendererManager.rendering();

		}

}
