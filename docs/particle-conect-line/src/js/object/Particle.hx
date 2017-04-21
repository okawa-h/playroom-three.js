package object;

import js.html.Float32Array;
import js.three.Blending;
import js.three.BufferAttribute;
import js.three.BufferGeometry;
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
	numConnections : Int,
};

class Particle {

	private static var _points        : Points;
	private static var _lineObjects   : LineSegments;
	private static var _particlesData : Array<ParticleData>;
	private static var _linePositions     : Float32Array;
	private static var _lineColors        : Float32Array;
	private static var _particlePositions : Float32Array;
	private static inline var MAX_WIDTH : Int = 1000;
	private static inline var LENGTH    : Int = 500;
	private static inline var RANGE     : Int = 500;
	private static inline var MIN_DISTANCE  : Int = 150;
	private static inline var MAX_CONECTIONS   : Int = 20;
	private static inline var LIMIT_CONECTIONS : Bool = false;

		/* =======================================================================
	    	Create
	    ========================================================================== */
		public static function create():Void {

			var segments  : Int = MAX_WIDTH * MAX_WIDTH;
			_lineColors        = new Float32Array(segments * 3);
			_linePositions     = new Float32Array(segments * 3);
			_particlePositions = new Float32Array(MAX_WIDTH * 3);
			_particlesData = [];

			setParticleObject();
			setLineObject();

		}

		/* =======================================================================
			On Update
		========================================================================== */
		public static function onUpdate():Void {

			var rHalf        : Float = RANGE * .5;
			var vertexpos    : Int = 0;
			var colorpos     : Int = 0;
			var numConnected : Int = 0;

			for (i in 0 ... LENGTH) {

				_particlesData[i].numConnections = 0;

			}
				
			for (i in 0 ... LENGTH) {

				var targetData : ParticleData = _particlesData[i];
				_particlePositions[ i * 3 ]     += targetData.velocity.x;
				_particlePositions[ i * 3 + 1 ] += targetData.velocity.y;
				_particlePositions[ i * 3 + 2 ] += targetData.velocity.z;

				if ( _particlePositions[ i * 3 + 1 ] < -rHalf || _particlePositions[ i * 3 + 1 ] > rHalf )
					targetData.velocity.y = -targetData.velocity.y;
				if ( _particlePositions[ i * 3 ] < -rHalf || _particlePositions[ i * 3 ] > rHalf )
					targetData.velocity.x = -targetData.velocity.x;
				if ( _particlePositions[ i * 3 + 2 ] < -rHalf || _particlePositions[ i * 3 + 2 ] > rHalf )
					targetData.velocity.z = -targetData.velocity.z;
				if ( LIMIT_CONECTIONS && targetData.numConnections >= MAX_CONECTIONS )
					continue;

				for (l in 0 ... LENGTH) {

					var j : Int = i + 1;
					var targetDataB : ParticleData = _particlesData[ j ];
					var diffX    : Float = _particlePositions[ i * 3     ] - _particlePositions[ j * 3 ];
					var diffY    : Float = _particlePositions[ i * 3 + 1 ] - _particlePositions[ j * 3 + 1 ];
					var diffZ    : Float = _particlePositions[ i * 3 + 2 ] - _particlePositions[ j * 3 + 2 ];
					var distance : Float = Math.sqrt( diffX * diffX + diffY * diffY + diffZ * diffZ );

					if (distance < MIN_DISTANCE) {

						targetData.numConnections++;
						targetDataB.numConnections++;

						var alpha : Float = 1.0 - distance / MIN_DISTANCE;
						_linePositions[ vertexpos++ ] = _particlePositions[ i * 3 ];
						_linePositions[ vertexpos++ ] = _particlePositions[ i * 3 + 1 ];
						_linePositions[ vertexpos++ ] = _particlePositions[ i * 3 + 2 ];
						_linePositions[ vertexpos++ ] = _particlePositions[ j * 3 ];
						_linePositions[ vertexpos++ ] = _particlePositions[ j * 3 + 1 ];
						_linePositions[ vertexpos++ ] = _particlePositions[ j * 3 + 2 ];
						_lineColors[ colorpos++ ] = alpha;
						_lineColors[ colorpos++ ] = alpha;
						_lineColors[ colorpos++ ] = alpha;
						_lineColors[ colorpos++ ] = alpha;
						_lineColors[ colorpos++ ] = alpha;
						_lineColors[ colorpos++ ] = alpha;

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

		var material : PointsMaterial = new PointsMaterial({
			color: 0xFFFFFF,
			size: 3,
			blending: Blending.AdditiveBlending,
			transparent: true,
			sizeAttenuation: false
		});

		var geometry : BufferGeometry = new BufferGeometry();

		for (i in 0 ... MAX_WIDTH) {

			var x : Float = MathTools.randomFloatSpread(RANGE);
			var y : Float = MathTools.randomFloatSpread(RANGE);
			var z : Float = MathTools.randomFloatSpread(RANGE);
			_particlePositions[ i * 3 ]     = x;
			_particlePositions[ i * 3 + 1 ] = y;
			_particlePositions[ i * 3 + 2 ] = z;
			_particlesData.push({
					velocity: new Vector3( -1 + Math.random() * 2, -1 + Math.random() * 2,  -1 + Math.random() * 2 ),
					numConnections: 0
				});
		}

		geometry.computeBoundingSphere();
		geometry.setDrawRange(0,LENGTH);
		geometry.addAttribute('position', new BufferAttribute(_particlePositions, 3).setDynamic(true) );
		_points = new Points(geometry,material);
		ParticleGroup.add(_points);

	}

	/* =======================================================================
		Set Line Object
	========================================================================== */
	private static function setLineObject():Void {

		var material = new LineBasicMaterial( {
			vertexColors: VertexColors,
			blending    : AdditiveBlending,
			transparent : true
		});

		var geometry : BufferGeometry = new BufferGeometry();
		geometry.addAttribute('position', new BufferAttribute( _linePositions, 3 ).setDynamic( true ));
		geometry.addAttribute('color', new BufferAttribute( _lineColors, 3 ).setDynamic( true ));
		geometry.computeBoundingSphere();
		geometry.setDrawRange( 0, 0 );
		
		_lineObjects = new LineSegments( geometry, material);
		ParticleGroup.add(_lineObjects);

	}

}
