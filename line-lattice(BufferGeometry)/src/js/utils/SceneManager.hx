package utils;

import js.three.FogExp2;
import js.three.Object3D;
import js.three.Vector3;
import js.three.Scene;

class SceneManager {

	private static var _parent : Scene;

	/* =======================================================================
    	Constractor
    ========================================================================== */
	public static function init():Void {

		_parent = new Scene();
		_parent.fog = new FogExp2(0xf49231,.002);

	}

		/* =======================================================================
			Add
		========================================================================== */
		public static function add(object:Object3D):Void {

			_parent.add(object);

		}

		/* =======================================================================
			Get
		========================================================================== */
		public static function get():Scene {

			return _parent;

		}

		/* =======================================================================
			Get Position
		========================================================================== */
		public static function getPosition():Vector3 {

			return _parent.position;

		}

}
