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
	private static inline var WIDTH      : Int = 100;
	private static inline var DEPTH      : Int = 100;
	private static inline var INTERVAL   : Int = 10;

	/* =======================================================================
		Init
	========================================================================== */
	public static function create():Void {

		setParticleObject();

	}

		/* =======================================================================
			On Resize
		========================================================================== */
		public static function onUpdate():Void {

		}

	/* =======================================================================
		Set Particle Object
	========================================================================== */
	private static function setParticleObject():Void {

		var length : Int = WIDTH * DEPTH;
		_particlePositions = new Float32Array(length * 3);
		_particlesData = [];

		var material : PointsMaterial = new PointsMaterial({
			color: 0xffffff,
			size: 3,
			blending: Blending.AdditiveBlending,
			transparent: true,
			sizeAttenuation: false
		});

		var geometry       : BufferGeometry = new BufferGeometry();
		var bufferCounter  : Int = 0;
		var halfW    : Float = WIDTH * .5 * INTERVAL;
		var halfD    : Float = DEPTH * .5 * INTERVAL;
		for (i in 0 ... WIDTH) {
			for (l in 0 ... DEPTH) {

				var x : Float = (i * INTERVAL) - halfW;
				var y : Float = 0;
				var z : Float = (l * INTERVAL) - halfD;
				// var v : Vector3 = new Vector3( -1 + Math.random() * 2, -1 + Math.random() * 2,  -1 + Math.random() * 2 );
				_particlePositions[ bufferCounter ]     = x;
				_particlePositions[ bufferCounter + 1 ] = y;
				_particlePositions[ bufferCounter + 2 ] = z;
				// _particlesData.push({ velocity:v });
				bufferCounter += 3;

			}
		}

		geometry.setDrawRange(0,length * 3);
		geometry.addAttribute('position', new BufferAttribute(_particlePositions, 3).setDynamic(true) );
		_points = new Points(geometry,material);
		GroundGroup.add(_points);

	}

}
