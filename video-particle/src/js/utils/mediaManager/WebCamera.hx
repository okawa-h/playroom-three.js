package utils.mediaManager;

import js.Browser;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.URL;
import js.html.MediaStream;
import js.html.MediaStreamConstraints;
import js.html.LocalMediaStream;
import js.html.VideoElement;
import js.three.Texture;
import view.Window;
import utils.MediaManager.VideoMedia;

class WebCamera {

	public static var videoMedia     :VideoMedia;
	public static var isUsePermission:Bool;

	/* =======================================================================
    	Setup
    ========================================================================== */
	public static function setup(onComplete:Void->Void):Void {

		isUsePermission = false;
		var constraints:MediaStreamConstraints = { video:true,audio:false };
		var getUserMedia = untyped __js__('navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia');
		getUserMedia.call(Browser.navigator,constraints,function (stream:MediaStream) {
			var canvas:CanvasElement = Browser.document.createCanvasElement();
			var video :VideoElement  = Browser.document.createVideoElement();
			video.onloadedmetadata = function() {
			// video.oncanplaythrough = function() {

				isUsePermission = true;
				videoMedia = {
					video  :video,
					canvas :canvas,
					texture:new Texture(canvas)
				};
				onComplete();

			};

			video.src = URL.createObjectURL(stream);
			video.load();

		},function(event) {

			Browser.console.log(event.name + ' : ' + event.message);
			onComplete();
			
		});

	}

}
