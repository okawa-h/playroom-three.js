package utils;

import haxe.Timer;
import js.Error;
import js.Promise;
import js.html.Image;
import js.jquery.JQuery;
import js.html.Uint8ClampedArray;
import createjs.preloadjs.LoadQueue;
import view.Window;
import jp.okawa.js.ImageTools;

using Lambda;
typedef MaterialData = {
	src     : String,
	?width  : Int,
	?height : Int,
	?pixelData : Uint8ClampedArray
};

class MaterialManager {

	private static var _timer           : Timer;
	private static var _persent         : Int;
	private static var _imageProgress   : Int;
	private static var _jText           : JQuery;
	private static var _materialData    : Map<String,MaterialData>;
	private static inline var BASE_PATH : String  = '../files/img/';
	private static inline var INTERVAL  : Int     = 10;
	private static var _manifest : Array<Dynamic> = [
		{ id:'go',src:'go.png',isImage:true }
	];

	/* =======================================================================
    	Constractor
    ========================================================================== */
	public static function load():Void {

		_jText = new JQuery('#load');
		_materialData = new Map();
		_persent = 0;
		_imageProgress = 0;
		setTimer();
		promise();

	}

	/* =======================================================================
		Timer
	========================================================================== */
	private static function setTimer():Void {

		_timer = new Timer(INTERVAL);
		_timer.run = function() {

			if (_persent >= 100) {
				_timer.stop();
				Timer.delay(onImageLoaded,300);
				return;
			}

			_persent++;

			if (_imageProgress <= _persent) {
				_persent = _imageProgress;
			}

			_jText.text('Loading... ${_persent}%');
		};

	}

	/* =======================================================================
		Promise
	========================================================================== */
	private static function promise():Void {

		var length  : Int = _manifest.length;
		var counter : Int = 0;

		function loadImage(num:Int):Promise<Dynamic> {
			return new Promise(function(resolve,reject) {

				var data  : Dynamic = _manifest[num];
				var image : Image   = new Image();
				image.onload = function(){

					counter++;
					_materialData[data.id] = {
						src       : data.src,
						width     : image.width,
						height    : image.height,
						pixelData : ImageTools.getPixelData(image)
					};
					onProgress(counter,length);
					resolve(num);

				}
				image.onerror = function() {
					reject(new Error('Not Found'));
				}
				image.src = BASE_PATH + data.src;
			});

		}

		var promise : Promise<Dynamic> = Promise.resolve();

		for (i in 0 ... length) {

			promise = promise.then(function(src:String) {

				return loadImage(i);

			});

		}

		promise = promise.then(function(num) {
			}
		);

		promise = promise.catchError(function(reason:String) {
				trace(reason);
			}
		);

	}

	/* =======================================================================
		On Progress
	========================================================================== */
	private static function onProgress(current:Int,length:Int):Void {

		_imageProgress = Math.floor(current / length * 100);

	}

	/* =======================================================================
		On Image Loaded
	========================================================================== */
	private static function onImageLoaded():Void {

		_jText.fadeOut(400);
		Window.trigger('materialLoaded');

	}

		/* =======================================================================
			Get Item
		========================================================================== */
		public static function getItem(id:String):MaterialData {

			if (_materialData.exists(id)) {
				return _materialData.get(id);
			} else {
				trace(new Error('Not Found'));
				return {
					src: null
				};
			}

		}

}
