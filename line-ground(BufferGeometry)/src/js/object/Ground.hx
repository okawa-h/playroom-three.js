package object;

import js.html.Float32Array;
import js.three.Blending;
import js.three.BufferAttribute;
import js.three.BufferGeometry;
import js.three.Colors;
import js.three.Geometry;
import js.three.Object3D;
import js.three.Vector3;
import js.three.LineBasicMaterial;
import js.three.LineSegments;
import js.three.Points;
import js.three.PointsMaterial;
import object.GroundGroup;
import utils.MaterialManager;
import jp.okawa.utils.MathTools;

typedef ParticleData = {
	velocity : Vector3
};

class Ground {

	private static var _points        : Points;
	private static var _lineObjects   : LineSegments;
	private static var _particlesData : Array<ParticleData>;
	private static var _linePositions     : Float32Array;
	private static var _lineColors        : Float32Array;
	private static var _particlePositions : Float32Array;
	private static var _lineLength : Int;
	private static inline var DEPTH      : Int = 100;
	private static inline var WIDTH      : Int = 100;
	private static inline var INTERVAL   : Int = 10;
	private static inline var VERTICAL_INTERVAL : Int = 6;

	/* =======================================================================
		Init
	========================================================================== */
	public static function create():Void {

		setParticleObject();
		setLineObject();

	}

		/* =======================================================================
			On Resize
		========================================================================== */
		public static function onUpdate():Void {

			// var particlePosi : Int = 0;
			// for (i in 0 ... WIDTH) {
			// 	for (l in 0 ... DEPTH) {
			// 		var targetData : ParticleData = _particlesData[i];
			// 		particlePosi++;
			// 		var yPosi : Float = _particlePositions[ particlePosi++ ] += targetData.velocity.y;
			// 		particlePosi++;

			// 		if ( yPosi < -10 || yPosi > 10 ) {
			// 			targetData.velocity.y = -targetData.velocity.y;
			// 		}
			// 		_particlePositions[ i * 3 + 1 ] = MathTools.randomFloat(0,10);
			// 	}
			// }

			var posi       : Int = 0;
			var startWPosi : Int = 0;
			var endWPosi   : Int = 3;

			var startDPosi : Int = 0;
			var endDPosi   : Int = DEPTH * 3;

			for (i in 0 ... _lineLength) {

				if (i > 0 && (posi - (6 * i)) % ((DEPTH - 1) * 6) == 0) {
					startWPosi += 3;
					endWPosi += 3;
				}

				_linePositions[ posi++ ] = _particlePositions[ startWPosi++ ];
				_linePositions[ posi++ ] = _particlePositions[ startWPosi++ ];
				_linePositions[ posi++ ] = _particlePositions[ startWPosi++ ];

				_linePositions[ posi++ ] = _particlePositions[ endWPosi++ ];
				_linePositions[ posi++ ] = _particlePositions[ endWPosi++ ];
				_linePositions[ posi++ ] = _particlePositions[ endWPosi++ ];

				_linePositions[ posi++ ] = _particlePositions[ startDPosi++ ];
				_linePositions[ posi++ ] = _particlePositions[ startDPosi++ ];
				_linePositions[ posi++ ] = _particlePositions[ startDPosi++ ];

				_linePositions[ posi++ ] = _particlePositions[ endDPosi++ ];
				_linePositions[ posi++ ] = _particlePositions[ endDPosi++ ];
				_linePositions[ posi++ ] = _particlePositions[ endDPosi++ ];

			}

			var lGeometry   : BufferGeometry = _lineObjects.geometry;
			var pGeometry   : BufferGeometry = cast _points.geometry;
			var updateArray : Array<BufferAttribute> = [
				lGeometry.getAttribute('position'),
				lGeometry.getAttribute('color'),
				pGeometry.getAttribute('position')
			];

			lGeometry.setDrawRange( 0, _lineLength * 2 );
			for (i in 0 ... updateArray.length) {
				updateArray[i].needsUpdate = true;
			}

		}

	/* =======================================================================
		Set Particle Object
	========================================================================== */
	private static function setParticleObject():Void {

		var particleLength : Int = DEPTH * WIDTH;
		_particlePositions = new Float32Array(particleLength * 3);
		_particlesData = [];

		var material : PointsMaterial = new PointsMaterial({
			color: 0xffffff,
			blending: Blending.AdditiveBlending,
			transparent: true,
			sizeAttenuation: false
		});

		var posi  : Int = 0;
		var halfW : Float = (WIDTH * INTERVAL) * .5;
		var halfD : Float = (DEPTH * INTERVAL) * .5;

		for (i in 0 ... WIDTH) {
			for (l in 0 ... DEPTH) {

				var x : Float = (i * INTERVAL) - halfW;
				var z : Float = (l * INTERVAL) - halfD;
				var y : Float = getVerticlPosition(i,l,posi);

				// var v : Vector3 = new Vector3( -1 + Math.random() * 2, -1 + Math.random() * 2,  -1 + Math.random() * 2 );
				_particlePositions[ posi++ ] = x;
				_particlePositions[ posi++ ] = y;
				_particlePositions[ posi++ ] = z;
				// _particlesData.push({ velocity:v });

			}
		}

		var geometry : BufferGeometry = new BufferGeometry();
		geometry.setDrawRange(0,particleLength);
		geometry.addAttribute('position', new BufferAttribute(_particlePositions,3).setDynamic(true) );
		_points = new Points(geometry,material);
		GroundGroup.add(_points);

	}

	/* =======================================================================
		Get Vertical Position
	========================================================================== */
	private static function getVerticlPosition(i:Int,l:Int,posi:Int):Float {

		if (i == 0 && l == 0) return 0;

		var frontPosi : Float = null;
		var leftPosi  : Float = null;

		if (l > 0) {
			var leftY : Float = _particlePositions[ posi - 2 ];
			leftPosi = MathTools.randomFloat(leftY - VERTICAL_INTERVAL,leftY + VERTICAL_INTERVAL);
		}
		if (i > 0) {
			var frontY : Float = _particlePositions[ posi - (3 * WIDTH) + 1 ];
			frontPosi = MathTools.randomFloat(frontY - VERTICAL_INTERVAL,frontY + VERTICAL_INTERVAL);
		}

		if (frontPosi == null) frontPosi = leftPosi;
		if (leftPosi == null) leftPosi = frontPosi;
		var yPosi : Float = (frontPosi + leftPosi) * .5;

		return MathTools.randomFloat(yPosi - VERTICAL_INTERVAL,yPosi + VERTICAL_INTERVAL);

	}

	/* =======================================================================
		Set Line Object
	========================================================================== */
	private static function setLineObject():Void {

		_lineLength = (DEPTH - 1) * WIDTH * 2;
		var lineVertexLength    : Int = _lineLength * 2;
		var linePositionsLength : Int = _lineLength * 2 * 3;
		_linePositions = new Float32Array(linePositionsLength);
		_lineColors    = new Float32Array(linePositionsLength);

		var material : LineBasicMaterial = new LineBasicMaterial( {
			color: 0xfec659,
			// vertexColors : Colors.VertexColors,
			// blending     : Blending.AdditiveBlending,
			transparent  : true
		});

		var geometry : BufferGeometry = new BufferGeometry();
		geometry.addAttribute('position', new BufferAttribute(_linePositions,3).setDynamic( true ));
		geometry.addAttribute('color', new BufferAttribute(_lineColors,3).setDynamic( true ));
		geometry.computeBoundingSphere();
		geometry.setDrawRange(0,100);
		
		_lineObjects = new LineSegments(geometry,material);
		GroundGroup.add(_lineObjects);

	}

}
