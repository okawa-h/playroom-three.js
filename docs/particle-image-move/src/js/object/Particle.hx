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
import tween.easing.Circ;
import tween.easing.Expo;
import tween.easing.Elastic;
import tween.easing.Sine;
import utils.EventManager;
import utils.MaterialManager;
import utils.SceneManager;
import jp.okawa.externals.SimplexNoise;
import jp.okawa.utils.ArrayTools;
import jp.okawa.utils.MathTools;
import jp.okawa.utils.ImageTools;

class Particle {

	private static var _object   : Points;
	private static var IS_CREATE : Bool = false;
	private static inline var INTERVAL : Int = 1;
	private static inline var NOIZE_X  : Int = 30;
	private static inline var NOIZE_Y  : Int = 30;

		/* =======================================================================
	    	Create
	    ========================================================================== */
		public static function create():Void {

			var material  : PointsMaterial = new PointsMaterial({
				size : 5,
				sizeAttenuation : false,
				transparent : true,
				opacity     : .8,
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
			_object.geometry.verticesNeedUpdate = true;

		}

	/* =======================================================================
		Get Geometry
	========================================================================== */
	private static function getGeometry():Geometry {

		var materialData : MaterialData  = MaterialManager.getItem('image');
		var pixels   : Uint8ClampedArray = materialData.pixelData;
		var imageW   : Int = materialData.width;
		var imageH   : Int = materialData.height;
		var index    : Int = 0;
		var geometry : Geometry = new Geometry();
		var simplexNoise : SimplexNoise = new SimplexNoise();
		var easeArray    : Array<Dynamic> = [Expo.easeOut,Circ.easeOut,Sine.easeOut];

		for (i in 0 ... imageW) {
			for (l in 0 ... imageH) {

				var r : Int = pixels[index];
				var g : Int = pixels[index + 1];
				var b : Int = pixels[index + 2];
				var a : Int = pixels[index + 3];
				var is_trans : Bool = (r + g + b < 1);

				if (!is_trans) {

					var x : Float = (i - imageW * .5) * INTERVAL;
					var y : Float = -(l - imageH * .5) * INTERVAL;
					var rz: Float = simplexNoise.noise( x / NOIZE_X, y / NOIZE_Y );
					var particle : Vector3 = new Vector3(x,y,rz);

					untyped particle.animation = TweenMaxHaxe.to(particle,.5,{
							z     : MathTools.randomFloatSpread(20),
							ease  : Elastic.easeInOut,
							paused: true,
							repeat: -1,
							yoyo  : true
						});

					geometry.vertices.push(particle);
					geometry.colors.push( new Color('rgb($r,$g,$b)') );

				}

				index = (i * 4) + l * (4 * imageW);
				
			}
		}

		// for (i in 0 ... geometry.vertices.length) {

		// 	untyped geometry.vertices[i].animation.play();
			
		// }

		return geometry;

	}

}
