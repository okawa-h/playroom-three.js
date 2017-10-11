package view.object;

import js.three.CircleGeometry;
import js.three.MeshBasicMaterial;
import js.three.Mesh;
import view.ObjectManager;

class Particle {

	private static var _object : Mesh;

		/* =======================================================================
	    	Create
	    ========================================================================== */
		public static function create():Void {

			var geometry : CircleGeometry = new CircleGeometry( 5,20 );
			var material : MeshBasicMaterial = new MeshBasicMaterial({ color:0xffffff });

			_object = new Mesh(geometry,material);
			ObjectManager.add(_object);


		}

		/* =======================================================================
			On Update
		========================================================================== */
		public static function onUpdate():Void {

			if (_object == null) return;

		}

}
