package object;

import object.*;
import utils.EventManager;

class ObjectManager {

	/* =======================================================================
    	Constractor
    ========================================================================== */
	public static function init():Void {

	}

		/* =======================================================================
	    	Create
	    ========================================================================== */
		public static function create():Void {

			GroundGroup.init();
			EventManager.trigger('objectCreated');

		}

		/* =======================================================================
			On Resize
		========================================================================== */
		public static function onUpdate():Void {

			GroundGroup.onUpdate();

		}

}
