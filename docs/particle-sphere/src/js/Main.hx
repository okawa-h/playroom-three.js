package ;

import js.jquery.JQuery;
import js.jquery.Event;
import object.*;
import view.*;
import utils.*;
import jp.okawa.utils.NumberTools;

class Main {

	public static function main():Void {

		new JQuery('document').ready(init);

	}

	/* =======================================================================
		Constractor
	========================================================================== */
	private static function init(event:Event):Void {

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
		ObjectManager.create();

		OrbitControlsManager.init();
		EventManager.setEvent();
		RendererManager.rendering();

		Helper.init();

	}

}
