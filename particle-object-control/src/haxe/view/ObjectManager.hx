package view;

import js.three.Object3D;
import utils.SceneManager;
import view.object.*;

class ObjectManager {

	/* =======================================================================
    	Constractor
    ========================================================================== */
	public static function init():Void {

	}

		/* =======================================================================
	    	Add
	    ========================================================================== */
		public static function add(object:Object3D):Void {

			SceneManager.add(object);

		}

		/* =======================================================================
	    	Create
	    ========================================================================== */
		public static function create():Void {

			Particle.create();

		}

		/* =======================================================================
			On Resize
		========================================================================== */
		public static function onUpdate():Void {

			Particle.onUpdate();

		}

}
