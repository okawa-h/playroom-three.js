package utils;

import js.three.AxisHelper;
import js.three.GridHelper;
import utils.SceneManager;

class Helper {

	private static inline var ON_HELPER : Bool = true;
	private static inline var ON_AXIS : Bool = true;
	private static inline var ON_GRID : Bool = false;

	/* =======================================================================
    	Constractor
    ========================================================================== */
	public static function init():Void {

		if (!ON_HELPER) return;
		var array : Array<Dynamic> = [];

		if (ON_GRID) array.push(new GridHelper(1000,10));
		if (ON_AXIS) array.push(new AxisHelper(1000));

		for (i in 0 ... array.length) {
			SceneManager.add(array[i]);
		}

	}

}
