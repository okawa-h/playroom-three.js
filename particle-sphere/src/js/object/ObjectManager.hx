package object;

import js.three.SphereGeometry;
import js.three.Geometry;
import js.three.Vector3;
import js.three.Object3D;
import js.three.Points;
import js.three.PointsMaterial;
import object.*;
import utils.SceneManager;

using Lambda;

class ObjectManager {

	private static var flag     : Bool;
	private static var _objects : Points;
	private static inline var LENGTH : Int = 500000;

	/* =======================================================================
    	Constractor
    ========================================================================== */
	public static function init():Void {

		flag = true;

	}

		/* =======================================================================
	    	Create
	    ========================================================================== */
		public static function create():Void {

			var geometry : Geometry = new Geometry();

			for (i in 0 ... LENGTH) {
				geometry.vertices.push(Particle.create());
			}

			var material : PointsMaterial = new PointsMaterial({ color:0x000000, size:5 });
			_objects = new Points(geometry,material);
			SceneManager.add(_objects);

		}

		/* =======================================================================
			On Resize
		========================================================================== */
		public static function onUpdate():Void {

			// _objects.rotation.y += .02;
			var vertices : Array<Vector3> = _objects.geometry.vertices;

			for (i in 0 ... LENGTH) {

				var particle : Vector3 = vertices[i];
				Particle.onUpdate(particle);

			}

			_objects.geometry.verticesNeedUpdate = true;

		}

}
