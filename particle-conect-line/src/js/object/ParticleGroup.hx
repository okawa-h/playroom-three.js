package object;

import js.three.Group;
import js.three.Object3D;
import object.*;
import utils.SceneManager;

class ParticleGroup {

	private static var _parent : Group;

	/* =======================================================================
		Init
	========================================================================== */
	public static function init():Void {

		_parent = new Group();
		create();
		SceneManager.add(_parent);

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

			var timer : Float = Date.now().getTime() * .001;
			Particle.onUpdate();
			// _parent.rotation.y = timer * 0.1;

		}

		/* =======================================================================
			Add
		========================================================================== */
		public static function add(obj:Object3D):Void {

			_parent.add(obj);

		}

}
