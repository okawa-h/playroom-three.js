package view;

import js.three.SphereGeometry;
import js.three.Geometry;
import js.three.Vector3;
import js.three.Object3D;
import js.three.Points;
import js.three.PointsMaterial;
import view.object.*;
import utils.SceneManager;

using Lambda;

class ObjectManager {

	private static var _objects : Points;
	private static inline var LENGTH : Int = 500000;

	/* =======================================================================
    	Constractor
    ========================================================================== */
	public static function init():Void {

		var geometry : Geometry = new Geometry();

		for (i in 0 ... LENGTH) {
			geometry.vertices.push(Particle.create());
		}

		var material : PointsMaterial = new PointsMaterial({ color:0x01608C, size:2 });
		_objects = new Points(geometry,material);
		SceneManager.add(_objects);


	}

		/* =======================================================================
			On Resize
		========================================================================== */
		public static function onUpdate():Void {

			_objects.rotation.y += .002;
			var vertices : Array<Vector3> = _objects.geometry.vertices;

			for (i in 0 ... LENGTH) {

				var particle : Vector3 = vertices[i];
				Particle.onUpdate(particle);

			}

			_objects.geometry.verticesNeedUpdate = true;

		}

}
