package object;

import js.three.Group;
import js.three.Object3D;
import object.*;
import utils.SceneManager;

class GroundGroup {

	private static var _parent : Group;

	/* =======================================================================
		Init
	========================================================================== */
	public static function init():Void {

		Ground.create();

	}

		/* =======================================================================
			On Resize
		========================================================================== */
		public static function onUpdate():Void {

			// var timer : Float = Date.now().getTime() * .001;
			// _parent.rotation.y = timer * .2;
			// Ground.onUpdate();

		}

}
