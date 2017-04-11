package view;

import js.three.DirectionalLight;
import utils.SceneManager;

class Light {

	private static var _light : DirectionalLight;

	/* =======================================================================
    	Constractor
    ========================================================================== */
	public static function init():Void {

		_light = new DirectionalLight(0xffffff);
		_light.position.set(20,40,-15);
		// _light.castShadow         = true;
		// _light.shadowCameraLeft   = -60;
		// _light.shadowCameraTop    = -60;
		// _light.shadowCameraRight  = 60;
		// _light.shadowCameraBottom = 60;
		// _light.shadowCameraNear   = 20;
		// _light.shadowCameraFar    = 200;
		// _light.shadowBias         = -.0001;
		// _light.shadowMapWidth     = _light.shadowMapHeight = 2048;
		// _light.shadowDarkness     = .7;

		SceneManager.add(_light);

	}

		/* =======================================================================
			On Update
		========================================================================== */
		public static function onUpdate():Void {

		}

		/* =======================================================================
			On Resize
		========================================================================== */
		public static function onResize(winW:Float,winH:Float):Void {

		}

}
