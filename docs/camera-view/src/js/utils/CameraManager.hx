package utils;

import js.Browser;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.URL;
import js.html.MediaStream;
import js.html.MediaStreamConstraints;
import js.html.VideoElement;
import js.three.Texture;
import view.Window;
import utils.MaterialManager.MaterialData;

class CameraManager {

	private static var _materialData : MaterialData;

	/* =======================================================================
    	Constractor
    ========================================================================== */
	public static function init():Void {

		var constraints : MediaStreamConstraints = {video: true, audio: false};
		var promise : Dynamic = untyped Browser.navigator.mediaDevices.getUserMedia(constraints);
		promise.then(function(stream:MediaStream) {

			var video : VideoElement = Browser.document.createVideoElement();
			video.src = URL.createObjectURL(stream);
			video.oncanplaythrough = function() {

				var canvas : CanvasElement = Browser.document.createCanvasElement();
				var ctx : CanvasRenderingContext2D = canvas.getContext2d();
				canvas.width  = video.videoWidth;
				canvas.height = video.videoHeight;
				_materialData = {
					video   : video,
					ctx     : ctx,
					texture : new Texture(canvas)
				};
				Window.trigger('okCamera');

			};

			video.load();

		});

	}

	/* =======================================================================
    	Get
    ========================================================================== */
	public static function get():MaterialData {

		return _materialData;

	}

}
