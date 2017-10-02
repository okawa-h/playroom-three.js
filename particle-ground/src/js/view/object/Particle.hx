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
	private static var is_created : Bool = false;
	private static inline var INTERVAL : Float = 1;
	private static inline var NOIZE_X  : Int = 30;
	private static inline var NOIZE_Y  : Int = 30;
	private static inline var WIDTH    : Int = 1000;
	private static inline var HEIGHT   : Int = WIDTH;

		/* =======================================================================
	    	Create
	    ========================================================================== */
		public static function create():Void {

			var material : PointsMaterial = new PointsMaterial({
				size : 2,
				sizeAttenuation : false,
				vertexColors: Colors.VertexColors
			});

			_object = new Points(getGeometry(),material);
			ObjectManager.add(_object);
			is_created = true;

		}

		/* =======================================================================
			On Update
		========================================================================== */
		public static function onUpdate():Void {

			if (!is_created) return;
			_object.geometry.verticesNeedUpdate = true;
			
			for (i in 0 ... _object.geometry.vertices.length) {

				var particle : Vector3 =_object.geometry.vertices[i];
				particle.y += 0.1 * untyped particle.vy;
				if (particle.y > 3) {
					untyped particle.vy = -1;
				}
				if (particle.y < -3) {
					untyped particle.vy = 1;
				}
				
			}

		}

	/* =======================================================================
		Get Geometry
	========================================================================== */
	private static function getGeometry():Geometry {

		var index    : Int = 0;
		var geometry : Geometry = new Geometry();
		var simplexNoise : SimplexNoise = new SimplexNoise();

		for (i in 0 ... WIDTH) {
			for (l in 0 ... HEIGHT) {

				var r : Int = MathTools.randomInt(10,90);
				var g : Int = MathTools.randomInt(200,230);
				var b : Int = MathTools.randomInt(200,230);
				var is_trans : Bool = (r + g + b < 1);

				if (!is_trans) {

					var x : Float = (i - WIDTH * .5) * INTERVAL;
					var z : Float = -(l - HEIGHT * .5) * INTERVAL;
					var y : Float = simplexNoise.noise( x / NOIZE_X, z / NOIZE_Y );
					var particle : Vector3 = new Vector3(x,y,z);
					untyped particle.vy = 1;

					geometry.vertices.push(particle);
					geometry.colors.push( new Color('rgb($r,$g,$b)') );

				}

				index = (i * 4) + l * (4 * WIDTH);
				
			}
		}

		return geometry;

	}

}
