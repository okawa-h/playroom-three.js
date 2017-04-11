package utils;

import js.Error;
import js.Promise;
import js.html.Image;
import js.jquery.JQuery;
import js.html.Uint8ClampedArray;
import createjs.preloadjs.LoadQueue;
import view.Window;
import jp.okawa.utils.ImageTools;

using Lambda;
typedef MaterialData = {
	src     : String,
	?width  : Int,
	?height : Int,
	?pixelData : Uint8ClampedArray
};

class MaterialManager {

	private static var _jText           : JQuery;
	private static var _materialData    : Map<String,MaterialData>;
	private static inline var BASE_PATH : String  = '../../files/img/';
	private static var _manifest : Array<Dynamic> = [];

	/* =======================================================================
    	Constractor
    ========================================================================== */
	public static function load():Void {

		_jText = new JQuery('#load');
		_materialData = new Map();
		promise();

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
				onImageLoaded();
			}
		);

		promise = promise.catchError(function(reason:String) {
				trace(reason);
			}
		);

	}

	/* =======================================================================
		On Image Loaded
	========================================================================== */
	private static function onImageLoaded():Void {

		_jText.fadeOut(200);
		Window.trigger('materialLoaded');

	}

	/* =======================================================================
		On Progress
	========================================================================== */
	private static function onProgress(current:Int,length:Int):Void {

		var progress : Int = Math.floor(current / length * 100);
		_jText.text('Loading... ${progress}%');

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
