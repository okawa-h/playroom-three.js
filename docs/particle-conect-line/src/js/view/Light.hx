package view;

import js.three.DirectionalLight;
import utils.SceneManager;

class Light {

	private static var _parent : DirectionalLight;

	/* =======================================================================
    	Constractor
    ========================================================================== */
	public static function init():Void {

		_parent = new DirectionalLight(0xffffff);
		_parent.position.set(20,40,-15);
		SceneManager.add(_parent);

	}

}
