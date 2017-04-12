package utils;

import js.Error;
import js.html.XMLHttpRequest;
import js.html.XMLHttpRequestResponseType;
import js.Promise;
import js.html.audio.AudioContext;
import js.jquery.JQuery;
import view.Window;

using Lambda;
typedef MaterialData = {
	src : String,
	ctx : AudioContext
};

class AudioManager {

	private static var _jText           : JQuery;
	private static var _materialData    : Map<String,MaterialData>;
	private static inline var BASE_PATH : String  = 'files/mp3/';
	private static var _manifest : Array<Dynamic> = [
		{ id:'bgm',src:'toikioku_healing.mp3' }
	];

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

		function loadAudio(num:Int):Promise<Dynamic> {
			return new Promise(function(resolve,reject) {

				var data    : Dynamic = _manifest[num];
				var request : XMLHttpRequest = new XMLHttpRequest();
				request.open('GET',BASE_PATH + data.src,true);
				request.responseType = untyped 'arraybuffer';
				request.onload = function() {
					var ctx : AudioContext = new AudioContext();
					ctx.decodeAudioData(request.response);

					_materialData[data.id] =  {
						src : data.src,
						ctx : ctx
					};
					resolve(num);
				};
				request.send();

			});

		}

		var promise : Promise<Dynamic> = Promise.resolve();

		for (i in 0 ... length) {

			promise = promise.then(function(src:String) {

				return loadAudio(i);

			});

		}

		promise = promise.then(function(num) {
				onLoaded();
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
	private static function onLoaded():Void {

		_jText.fadeOut(200);
		Window.trigger('audioLoaded');

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
		public static function getItem(id:String):Dynamic {

			if (_materialData.exists(id)) {
				return _materialData.get(id);
			} else {
				trace(new Error('Not Found'));
				return {
					status: 'error'
				};
			}

		}

}
