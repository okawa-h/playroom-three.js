package utils;

import js.three.OrbitControls;
import utils.RendererManager;
import view.Camera;

class OrbitControlsManager {

	private static var _parent : OrbitControls;

	/* =======================================================================
    	Constractor
    ========================================================================== */
	public static function init():Void {

		_parent = new OrbitControls(Camera.getParent(),cast RendererManager.getElement());

	}

		/* =======================================================================
			On Update
		========================================================================== */
		public static function onUpdate():Void {

			_parent.update();

		}

}
