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
import utils.SceneManager;
import jp.okawa.utils.MathTools;
import jp.okawa.utils.ImageTools;

class Particle {

	private static var _object  : Points;
	private static var isCreate : Bool = false;
	private static inline var VIEW_WIDTH  : Int = 3000;
	private static inline var VIEW_HEIGHT : Int = 600;
	private static inline var LENGTH : Int = 100;

		/* =======================================================================
	    	Create
	    ========================================================================== */
		public static function create():Void {

			var material  : PointsMaterial = new PointsMaterial({
				size : 3,
				sizeAttenuation : false,
				transparent : true,
				opacity     : 1,
				vertexColors: Colors.VertexColors
			});

			var geometry : Geometry = getGeometry();
			_object = new Points(geometry,material);
			SceneManager.add(_object);
			isCreate = true;

		}

		/* =======================================================================
			On Update
		========================================================================== */
		public static function onUpdate():Void {

			if (!isCreate) return;
			var vertices : Array<Vector3> = _object.geometry.vertices;
			for (i in 0 ... vertices.length) {

				updateParticle(vertices[i]);
				for (l in 0 ... vertices.length) {

					bindInLine(vertices[i],vertices[l]);

				}
				
			}

			_object.geometry.verticesNeedUpdate = true;

		}

	/* =======================================================================
		Get Geometry
	========================================================================== */
	private static function getGeometry():Geometry {

		var geometry : Geometry = new Geometry();

		for (i in 0 ... LENGTH) {

			var x : Float = MathTools.randomFloatSpread(VIEW_WIDTH);
			var y : Float = MathTools.randomFloatSpread(VIEW_HEIGHT);
			var particle : Vector3 = new Vector3(x,y,0);

			untyped particle.speed  = MathTools.randomFloat(.5,1);
			untyped particle.ySpeed = MathTools.randomFloat(.5,1);
			untyped particle.maxY   = y + MathTools.randomFloatSpread(20);
			geometry.vertices.push(particle);
			geometry.colors.push( new Color('rgb(255,255,255)') );

		}

		return geometry;

	}

	/* =======================================================================
		Update Particle
	========================================================================== */
	private static function updateParticle(particle:Vector3):Void {

		untyped particle.x += 3 * particle.speed;
		untyped particle.y += 1 * particle.ySpeed;

		untyped if (particle.maxY <= particle.y) {
			particle.ySpeed *= -1;
		}

		untyped if (-particle.maxY >= particle.y) {
			particle.ySpeed *= -1;
		}

		if ((VIEW_WIDTH * .5) <= particle.x) {
			particle.x = -(VIEW_WIDTH * .5);
		}

	}

	/* =======================================================================
		Bind In Line
	========================================================================== */
	private static function bindInLine(target:Vector3,other:Vector3):Void {

		if (target == other) return;
		var diffX : Float = target.x - other.x;
		var diffY : Float = target.y - other.y;


	}

}
