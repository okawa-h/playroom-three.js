package view.object;

import js.three.Color;
import js.three.Colors;
import js.three.Geometry;
import js.three.Points;
import js.three.PointsMaterial;
import js.three.Vector3;
import view.ObjectManager;
import jp.okawa.externals.SimplexNoise;
import jp.okawa.utils.MathTools;
import jp.okawa.js.ImageTools;

class Particle {

	private static var _object    : Points;
	private static inline var INTERVAL : Float = 0.5;
	private static inline var NOIZE_X  : Int = 30;
	private static inline var NOIZE_Y  : Int = 30;
	private static inline var WIDTH    : Int = 500;
	private static inline var HEIGHT   : Int = WIDTH;

		/* =======================================================================
	    	Create
	    ========================================================================== */
		public static function create():Void {

			var material : PointsMaterial = new PointsMaterial({
				size : 1,
				sizeAttenuation : false,
				vertexColors: Colors.VertexColors
			});

			_object = new Points(getGeometry(),material);
			ObjectManager.add(_object);

		}

		/* =======================================================================
			On Update
		========================================================================== */
		public static function onUpdate():Void {

			if (_object == null) return;
			_object.geometry.verticesNeedUpdate = true;
			_object.geometry.colorsNeedUpdate   = true;
			
			for (i in 0 ... _object.geometry.vertices.length) {

				var particle : Vector3 =_object.geometry.vertices[i];
				if (particle.y > 3) untyped particle.vy = -1;
				if (particle.y < -3) untyped particle.vy = 1;
				particle.y += 0.01 * untyped particle.vy;

			}

		}

	/* =======================================================================
		Get Geometry
	========================================================================== */
	private static function getGeometry():Geometry {

		var geometry : Geometry = new Geometry();
		var simplex  : SimplexNoise = new SimplexNoise();

		for (i in 0 ... WIDTH) {
			for (l in 0 ... HEIGHT) {

				var r : Int = MathTools.randomInt(10,90);
				var g : Int = MathTools.randomInt(20,230);
				var b : Int = MathTools.randomInt(200,230);
				var color : Color = new Color('rgb($r,$g,$b)');

				var x : Float = (i - WIDTH * .5) * INTERVAL;
				var z : Float = -(l - HEIGHT * .5) * INTERVAL;
				var y : Float = simplex.noise( x / NOIZE_X, z / NOIZE_Y );
				var particle : Vector3 = new Vector3(x,y,z);
				untyped particle.vy = 1;

				geometry.vertices.push(particle);
				geometry.colors.push(color);
				
			}
		}

		return geometry;

	}

}
