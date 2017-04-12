package object;

import js.html.Image;
import js.html.Uint8ClampedArray;
import js.three.Color;
import js.three.Colors;
import js.three.Geometry;
import js.three.Object3D;
import js.three.Points;
import js.three.PointsMaterial;
import js.three.Vector3;
import tween.TweenMaxHaxe;
import tween.easing.Expo;
import utils.EventManager;
import utils.AudioManager;
import utils.SceneManager;
import jp.okawa.externals.SimplexNoise;
import jp.okawa.utils.MathTools;
import jp.okawa.utils.ImageTools;

class Particle {

	private static var _object   : Points;
	private static var IS_CREATE : Bool = false;
	private static inline var INTERVAL : Float = 1;
	private static inline var NOIZE_X  : Int = 30;
	private static inline var NOIZE_Y  : Int = 30;
	private static inline var WIDTH    : Int = 1000;
	private static inline var HEIGHT   : Int = WIDTH;

		/* =======================================================================
	    	Create
	    ========================================================================== */
		public static function create():Void {

			var material  : PointsMaterial = new PointsMaterial({
				size : 2,
				sizeAttenuation : false,
				vertexColors: Colors.VertexColors
			});

			var geometry : Geometry = getGeometry();
			_object = new Points(geometry,material);
			SceneManager.add(_object);
			IS_CREATE = true;

		}

		/* =======================================================================
			On Update
		========================================================================== */
		public static function onUpdate():Void {

			if (!IS_CREATE) return;
			// _object.rotation.y += .1;
			_object.geometry.verticesNeedUpdate = true;

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

					geometry.vertices.push(particle);
					geometry.colors.push( new Color('rgb($r,$g,$b)') );

				}

				index = (i * 4) + l * (4 * WIDTH);
				
			}
		}

		// for (i in 0 ... geometry.vertices.length) {

		// 	var particle : Vector3 = geometry.vertices[i];
		// 	untyped particle.animation.play();
			
		// }

		return geometry;

	}

}
