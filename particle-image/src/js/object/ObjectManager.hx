package object;

import object.*;
import view.Window;

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
			Window.trigger('objectCreated');

		}

		/* =======================================================================
			On Resize
		========================================================================== */
		public static function onUpdate():Void {

			Particle.onUpdate();

		}

}
