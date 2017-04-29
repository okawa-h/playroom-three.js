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
import jp.okawa.externals.SimplexNoise;

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
	private static inline var DEPTH      : Int = 300;
	private static inline var WIDTH      : Int = 200;
	private static inline var INTERVAL   : Int = 10;
	private static inline var NOIZE_X    : Int = 100;
	private static inline var NOIZE_Y    : Int = 100;

	/* =======================================================================
		Init
	========================================================================== */
	public static function create():Void {

		var bufferLength : Int = DEPTH * WIDTH;
		setParticleObject(bufferLength);
		setLineObject(bufferLength);

	}

		/* =======================================================================
			On Resize
		========================================================================== */
		public static function onUpdate():Void {

		}

	/* =======================================================================
		Set Particle Object
	========================================================================== */
	private static function setParticleObject(bufferLength:Int):Void {

		_particlePositions = new Float32Array(bufferLength * 3);
		_particlesData = [];

		var material : PointsMaterial = new PointsMaterial({
			color: 0xffffff,
			blending: Blending.AdditiveBlending,
			transparent: true,
			sizeAttenuation: false
		});

		var geometry       : BufferGeometry = new BufferGeometry();
		var bufferCounter  : Int = 0;
		var halfW    : Float = (WIDTH * INTERVAL) * .5;
		var halfD    : Float = (DEPTH * INTERVAL) * .5;
		var simplexNoise : SimplexNoise = new SimplexNoise();

		for (i in 0 ... WIDTH) {
			for (l in 0 ... DEPTH) {

				var x : Float = (i * INTERVAL) - halfW;
				var z : Float = (l * INTERVAL) - halfD;
				var y : Float = simplexNoise.noise( x / NOIZE_X, z / NOIZE_Y );
				// var v : Vector3 = new Vector3( -1 + Math.random() * 2, -1 + Math.random() * 2,  -1 + Math.random() * 2 );
				_particlePositions[ bufferCounter ]     = x;
				_particlePositions[ bufferCounter + 1 ] = y;
				_particlePositions[ bufferCounter + 2 ] = z;
				// _particlesData.push({ velocity:v });
				bufferCounter += 3;

			}
		}

		geometry.setDrawRange(0,bufferLength);
		geometry.addAttribute('position', new BufferAttribute(_particlePositions, 3).setDynamic(true) );
		_points = new Points(geometry,material);
		GroundGroup.add(_points);

	}

	/* =======================================================================
		Set Line Object
	========================================================================== */
	private static function setLineObject(bufferLength:Int):Void {

		bufferLength   = bufferLength * 2;
		var lineLength : Int = (DEPTH - 1) * WIDTH;
		var lineVertexLength : Int = lineLength * 2;
		var linePositionsLength : Int = lineLength * 2 * 3;
		_linePositions = new Float32Array(linePositionsLength);
		_lineColors    = new Float32Array(linePositionsLength);

		var material : LineBasicMaterial = new LineBasicMaterial( {
			vertexColors : Colors.VertexColors,
			blending     : Blending.AdditiveBlending,
			transparent  : true
		});

		var geometry : BufferGeometry = new BufferGeometry();
		geometry.addAttribute('position', new BufferAttribute(_linePositions,3).setDynamic( true ));
		geometry.addAttribute('color', new BufferAttribute(_lineColors,3).setDynamic( true ));
		geometry.computeBoundingSphere();
		geometry.setDrawRange(0,100);
		
		_lineObjects = new LineSegments(geometry,material);
		GroundGroup.add(_lineObjects);

		var posi      : Int = 0;
		var startPosi : Int = 0;
		var endPosi   : Int = 3;

		for (i in 0 ... lineLength) {

			if (i > 0 && posi % ((DEPTH - 1) * 6) == 0) {
				startPosi += 3;
				endPosi += 3;
			}

			_linePositions[ posi++ ] = _particlePositions[ startPosi++ ];
			_linePositions[ posi++ ] = _particlePositions[ startPosi++ ];
			_linePositions[ posi++ ] = _particlePositions[ startPosi++ ];

			_linePositions[ posi++ ] = _particlePositions[ endPosi++ ];
			_linePositions[ posi++ ] = _particlePositions[ endPosi++ ];
			_linePositions[ posi++ ] = _particlePositions[ endPosi++ ];

		}

		var lGeometry   : BufferGeometry = _lineObjects.geometry;
		var updateArray : Array<BufferAttribute> = [
			lGeometry.getAttribute('position'),
			lGeometry.getAttribute('color')
		];

		lGeometry.setDrawRange( 0, lineVertexLength );
		for (i in 0 ... updateArray.length) {
			updateArray[i].needsUpdate = true;
		}

	}

}
