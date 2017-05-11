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

			Particle.create();
			EventManager.trigger('objectCreated');

		}

		/* =======================================================================
			On Resize
		========================================================================== */
		public static function onUpdate():Void {

			Particle.onUpdate();

		}

}
