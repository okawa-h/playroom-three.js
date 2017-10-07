package view.object;

import js.three.Color;
import js.three.Colors;
import js.three.Geometry;
import js.three.Points;
import js.three.PointsMaterial;
import js.three.Vector3;
import utils.SceneManager;
import jp.okawa.utils.MathTools;

class Particle {

	private static var _object : Points;
	private static inline var VIEW_WIDTH  : Int = 800;
	private static inline var VIEW_HEIGHT : Int = VIEW_WIDTH;
	private static inline var LENGTH      : Int = 2000;

		/* =======================================================================
	    	Create
	    ========================================================================== */
		public static function create():Void {

			var material : PointsMaterial =
				new PointsMaterial({
					size : 1,
					sizeAttenuation : false,
					transparent : true,
					opacity     : 1,
					vertexColors: Colors.VertexColors
				});

			var geometry : Geometry = getGeometry();
			_object = new Points(geometry,material);
			SceneManager.add(_object);

		}

		/* =======================================================================
			On Update
		========================================================================== */
		public static function onUpdate():Void {

			if (_object == null) return;
			_object.geometry.verticesNeedUpdate = true;

			var vertices : Array<Vector3> = _object.geometry.vertices;
			for (vertice in vertices) {
				updateParticle(vertice);
			}


		}

	/* =======================================================================
		Get Geometry
	========================================================================== */
	private static function getGeometry():Geometry {

		var geometry : Geometry = new Geometry();

		for (i in 0 ... LENGTH) {

			var x : Float = MathTools.randomFloatSpread(VIEW_WIDTH);
			var y : Float = MathTools.randomFloatSpread(VIEW_HEIGHT);
			var z : Float = MathTools.randomInt(-10,10);
			var particle : Vector3 = new Vector3(x,y,z);

			untyped particle.xSpeed = MathTools.randomFloat(.5,3);
			untyped particle.ySpeed = MathTools.randomFloat(.5,1);
			untyped particle.maxY   = MathTools.randomFloatSpread(20) + y;
			geometry.vertices.push(particle);

			var r : Int = MathTools.randomInt(0,100);
			var g : Int = MathTools.randomInt(30,255);
			var b : Int = MathTools.randomInt(0,20);
			geometry.colors.push( new Color('rgb($r,$g,$b)') );


		}

		return geometry;

	}

	/* =======================================================================
		Update Particle
	========================================================================== */
	private static function updateParticle(particle:Vector3):Void {

		untyped particle.x += particle.xSpeed;
		untyped particle.y += particle.ySpeed;

		if (untyped particle.maxY <= particle.y || untyped -particle.maxY >= particle.y) {
			untyped particle.ySpeed *= -1;
		}

		if ((VIEW_WIDTH * .5) <= particle.x) {
			particle.x = -(VIEW_WIDTH * .5);
		}

	}

}
