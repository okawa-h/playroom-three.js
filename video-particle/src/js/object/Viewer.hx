package object;

import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.Float32Array;
import js.html.VideoElement;
import js.html.Uint8ClampedArray;
import js.three.Blending;
import js.three.BufferAttribute;
import js.three.BufferGeometry;
import js.three.Color;
import js.three.Colors;
import js.three.Geometry;
import js.three.Points;
import js.three.PointsMaterial;
import js.three.PixelFormat;
import js.three.Vector3;
import object.*;
import utils.MediaManager;
import utils.mediaManager.*;
import jp.okawa.utils.MathTools;
import jp.okawa.js.canvas.ImageProcessing;

typedef ParticleData = {
	velocity : Vector3
};

class Viewer {

	private static var _particlePositions:Float32Array;
	private static var _parent:Points;
	private static var _ctx   :CanvasRenderingContext2D;
	private static var _canvas:CanvasElement;
	private static var _video :VideoElement;
	private static inline var INTERVAL:Int = 5;

	/* =======================================================================
		Init
	========================================================================== */
	public static function create():Void {

		var data:VideoMedia = WebCamera.isUsePermission ? WebCamera.videoMedia : MediaManager.getVideo('movie');
		_video  = data.video;
		_canvas = data.canvas;
		_ctx    = _canvas.getContext2d();

		_video.loop     = true;
		_video.muted    = true;
		_video.autoplay = true;
		_video.setAttribute('playsinline','true');

		_canvas.width  = Math.floor(_video.videoWidth);
		_canvas.height = Math.floor(_video.videoHeight);
		_video.play();
		setParticleObject();

	}

		/* =======================================================================
			On Resize
		========================================================================== */
		public static function onUpdate():Void {

			_ctx.drawImage(_video,0,0);

			var width  : Int = _canvas.width;
			var height : Int = _canvas.height;
			var pixels2: Uint8ClampedArray = _ctx.getImageData(0,0,width,height).data;

			ImageProcessing.drawDetectEdge(_canvas);
			var pixels : Uint8ClampedArray = _ctx.getImageData(0,0,width,height).data;
			var particleLength : Int = width * height;
			var index  : Int = 0;
			var length : Int = 0;
			var posi   : Int = 0;

			for (i in 0 ... width) {
				for (l in 0 ... height) {

					var r : Int = pixels[index];
					var g : Int = pixels[index + 1];
					var b : Int = pixels[index + 2];
					var a : Int = pixels[index + 3];
					index = (i * 4) + l * (4 * width);

					var total:Int = pixels2[index] + pixels2[index + 1] + pixels2[index + 2];
					if (r + g + b > 1) continue;

					var x : Float =  (i - width  * .5) * INTERVAL;
					var y : Float = -(l - height * .5) * INTERVAL;
					_particlePositions[ posi++ ] = x;
					_particlePositions[ posi++ ] = y;
					_particlePositions[ posi++ ] = total;
					length++;
					
				}
			}

			var geometry : BufferGeometry = cast _parent.geometry;
			geometry.setDrawRange(0,length);
			var attr : BufferAttribute = geometry.getAttribute('position');
			attr.needsUpdate = true;

		}

	/* =======================================================================
		Get Geometry
	========================================================================== */
	private static function setParticleObject():Void {

		var width  : Int = _canvas.width;
		var height : Int = _canvas.height;
		var particleLength : Int = width * height;
		_particlePositions = new Float32Array(particleLength * 3);

		var material  : PointsMaterial = new PointsMaterial({
			size : 3,
			color: 0xffffff,
			transparent: true,
			blending: Blending.AdditiveBlending,
			sizeAttenuation: false
		});

		var posi  : Int = 0;
		var halfW : Float = (width  * INTERVAL) * .5;
		var halfH : Float = (height * INTERVAL) * .5;

		for (i in 0 ... width) {
			for (l in 0 ... height) {

				var x : Float = (i * INTERVAL) - halfW;
				var y : Float = (l * INTERVAL) - halfH;
				var z : Float = 0;

				_particlePositions[ posi++ ] = x;
				_particlePositions[ posi++ ] = y;
				_particlePositions[ posi++ ] = z;

			}
		}

		var geometry : BufferGeometry = new BufferGeometry();
		geometry.setDrawRange(0,particleLength);
		geometry.addAttribute('position', new BufferAttribute(_particlePositions,3).setDynamic(true) );
		_parent = new Points(geometry,material);
		ViewerGroup.add(_parent);

	}

}
