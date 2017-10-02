package utils;

import js.html.CanvasElement;
import js.three.OrbitControls;
import utils.RendererManager;
import view.Camera;

class OrbitControlsManager {

	private static var _parent : OrbitControls;

	/* =======================================================================
    	Constractor
    ========================================================================== */
	public static function init():Void {

		var canvas : CanvasElement = RendererManager.getElement();
		_parent = new OrbitControls(Camera.getParent(),cast canvas);

	}

		/* =======================================================================
			On Update
		========================================================================== */
		public static function onUpdate():Void {

			_parent.update();

		}

}
