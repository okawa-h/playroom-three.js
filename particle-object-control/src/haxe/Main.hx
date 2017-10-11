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
		setup();

	}

		/* =======================================================================
			Setup
		========================================================================== */
		public static function setup():Void {

			EventManager.init();
			RendererManager.init();
			SceneManager.init();
			ObjectManager.init();

			Browser.document.getElementById('stage').appendChild(RendererManager.getElement());
			create();

		}

	/* =======================================================================
		Create
	========================================================================== */
	private static function create():Void {

		Camera.init();
		Light.init();
		OrbitControlsManager.init();

		ObjectManager.create();
		EventManager.setEvent();
		RendererManager.rendering();

	}

}
