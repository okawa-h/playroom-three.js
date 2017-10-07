package ;

import js.Browser.document;
import js.html.Event;
import view.*;
import utils.*;

class Main {

	public static function main():Void {

		document.addEventListener('DOMContentLoaded',init);

	}

	/* =======================================================================
		Constractor
	========================================================================== */
	private static function init(event:Event):Void {

		EventManager.init();
		RendererManager.init();
		SceneManager.init();

		document.getElementById('stage').appendChild(RendererManager.getElement());
		start();

	}

	/* =======================================================================
		Create
	========================================================================== */
	private static function start():Void {

		Camera.init();
		Light.init();
		ObjectManager.init();

		OrbitControlsManager.init();
		EventManager.setEvent();
		RendererManager.rendering();


	}

}
