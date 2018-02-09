package object;

import object.*;
import utils.EventManager;

class ObjectManager {

	/* =======================================================================
    	Init
    ========================================================================== */
	public static function init():Void {

		ViewerGroup.init();

	}

		/* =======================================================================
			On Resize
		========================================================================== */
		public static function onUpdate():Void {

			ViewerGroup.onUpdate();

		}

}
