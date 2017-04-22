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
import js.three.InterleavedBufferAttribute;
import js.three.Points;
import js.three.PointsMaterial;
import jp.okawa.utils.MathTools;
import object.ParticleGroup;

typedef ParticleData = {
	velocity : Vector3,
	numConnections : Int
};

class Particle {

	private static var _points        : Points;
	private static var _lineObjects   : LineSegments;
	private static var _particlesData : Array<ParticleData>;
	private static var _linePositions     : Float32Array;
	private static var _lineColors        : Float32Array;
	private static var _particlePositions : Float32Array;
	private static inline var MAX_LENGTH : Int = 1000;
	private static inline var LENGTH     : Int = 500;
	private static inline var RANGE      : Int = 800;
	private static inline var MIN_DISTANCE     : Int = 150;
	private static inline var MAX_CONECTIONS   : Int = 20;
	private static inline var LIMIT_CONECTIONS : Bool = false;

		/* =======================================================================
	    	Create
	    ========================================================================== */
		public static function create():Void {

			setParticleObject();
			setLineObject();

		}

		/* =======================================================================
			On Update
		========================================================================== */
		public static function onUpdate():Void {

			var rHalf        : Float = RANGE * .5;
			var vertexPos    : Int = 0;
			var colorPos     : Int = 0;
			var numConnected : Int = 0;

			for (i in 0 ... LENGTH) {

				_particlesData[i].numConnections = 0;

			}
				
			for (i in 0 ... LENGTH) {

				var targetData : ParticleData = _particlesData[i];
				var xPos : Float = _particlePositions[ i * 3 ] += targetData.velocity.x;
				var yPos : Float = _particlePositions[ i * 3 + 1 ] += targetData.velocity.y;
				var zPos : Float = _particlePositions[ i * 3 + 2 ] += targetData.velocity.z;

				if ( xPos < -rHalf || xPos > rHalf ) {
					targetData.velocity.x = -targetData.velocity.x;
				}
				if ( yPos < -rHalf || yPos > rHalf ) {
					targetData.velocity.y = -targetData.velocity.y;
				}
				if ( zPos < -rHalf || zPos > rHalf ) {
					targetData.velocity.z = -targetData.velocity.z;
				}
				if ( LIMIT_CONECTIONS && targetData.numConnections >= MAX_CONECTIONS )
					continue;

				var p = i + 1;
				for (l in 0 ... LENGTH - p) {

					var j : Int = p + l;
					var targetDataB : ParticleData = _particlesData[j];
					if ( LIMIT_CONECTIONS && targetDataB.numConnections >= MAX_CONECTIONS )
							continue;
					var xPairPos : Float = _particlePositions[ j * 3 ];
					var yPairPos : Float = _particlePositions[ j * 3 + 1 ];
					var zPairPos : Float = _particlePositions[ j * 3 + 2 ];
					var diffX    : Float = xPos - xPairPos;
					var diffY    : Float = yPos - yPairPos;
					var diffZ    : Float = zPos - zPairPos;
					var distance : Float = Math.sqrt( diffX * diffX + diffY * diffY + diffZ * diffZ );

					if (distance < MIN_DISTANCE) {

						targetData.numConnections++;
						targetDataB.numConnections++;

						var alpha : Float = 1 - distance / MIN_DISTANCE;
						_linePositions[ vertexPos++ ] = xPos;
						_linePositions[ vertexPos++ ] = yPos;
						_linePositions[ vertexPos++ ] = zPos;
						_linePositions[ vertexPos++ ] = xPairPos;
						_linePositions[ vertexPos++ ] = yPairPos;
						_linePositions[ vertexPos++ ] = zPairPos;
						_lineColors[ colorPos++ ] = alpha;
						_lineColors[ colorPos++ ] = alpha;
						_lineColors[ colorPos++ ] = alpha;
						_lineColors[ colorPos++ ] = alpha;
						_lineColors[ colorPos++ ] = alpha;
						_lineColors[ colorPos++ ] = alpha;

						numConnected++;
						
					}
					
				}
				
			}

			var lGeometry : BufferGeometry = _lineObjects.geometry;
			var pGeometry : BufferGeometry = cast _points.geometry;
			var updateArray : Array<BufferAttribute> = [
				lGeometry.getAttribute('position'),
				lGeometry.getAttribute('color'),
				pGeometry.getAttribute('position')
			];

			lGeometry.setDrawRange( 0, numConnected * 2 );
			for (i in 0 ... updateArray.length) {
				updateArray[i].needsUpdate = true;
			}

		}

	/* =======================================================================
		Set Particle Object
	========================================================================== */
	private static function setParticleObject():Void {

		_particlePositions = new Float32Array(MAX_LENGTH * 3);
		_particlesData = [];

		var material : PointsMaterial = new PointsMaterial({
			color: 0xFFFFFF,
			size: 3,
			blending: Blending.AdditiveBlending,
			transparent: true,
			sizeAttenuation: false
		});

		var geometry : BufferGeometry = new BufferGeometry();

		for (i in 0 ... MAX_LENGTH) {

			var x : Float = MathTools.randomFloatSpread(RANGE);
			var y : Float = MathTools.randomFloatSpread(RANGE);
			var z : Float = MathTools.randomFloatSpread(RANGE);
			var v : Vector3 = new Vector3( -1 + Math.random() * 2, -1 + Math.random() * 2,  -1 + Math.random() * 2 );
			_particlePositions[ i * 3 ]     = x;
			_particlePositions[ i * 3 + 1 ] = y;
			_particlePositions[ i * 3 + 2 ] = z;
			_particlesData.push({ velocity:v, numConnections:0 });
		}

		geometry.setDrawRange(0,LENGTH);
		geometry.addAttribute('position', new BufferAttribute(_particlePositions, 3).setDynamic(true) );
		_points = new Points(geometry,material);
		ParticleGroup.add(_points);

	}

	/* =======================================================================
		Set Line Object
	========================================================================== */
	private static function setLineObject():Void {

		var segments : Int = MAX_LENGTH * MAX_LENGTH;
		_lineColors    = new Float32Array(segments * 3);
		_linePositions = new Float32Array(segments * 3);

		var material = new LineBasicMaterial( {
			vertexColors: Colors.VertexColors,
			blending    : Blending.AdditiveBlending,
			transparent : true
		});

		var geometry : BufferGeometry = new BufferGeometry();
		geometry.addAttribute('position', new BufferAttribute(_linePositions,3).setDynamic( true ));
		geometry.addAttribute('color', new BufferAttribute(_lineColors,3).setDynamic( true ));
		geometry.computeBoundingSphere();
		geometry.setDrawRange(0,0);
		
		_lineObjects = new LineSegments(geometry,material);
		ParticleGroup.add(_lineObjects);

	}

}
