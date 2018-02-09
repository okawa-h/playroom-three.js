package object;

import js.three.Group;
import js.three.Object3D;
import object.*;
import utils.SceneManager;

class ViewerGroup {

	private static var _parent:Group;

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
		private static function create():Void {

			Viewer.create();

		}

		/* =======================================================================
			On Resize
		========================================================================== */
		public static function onUpdate():Void {

			// var timer:Float = Date.now().getTime() * .001;
			// _parent.rotation.y = timer * .2;
			Viewer.onUpdate();

		}

		/* =======================================================================
			Add
		========================================================================== */
		public static function add(obj:Object3D):Void {

			_parent.add(obj);

		}

}
