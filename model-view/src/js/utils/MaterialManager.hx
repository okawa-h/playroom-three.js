package utils;

import haxe.Timer;
import js.Error;
import js.Promise;
import js.jquery.JQuery;
import js.three.JSONLoader;
import view.Window;

using Lambda;
typedef MaterialData = {
	geometry : Dynamic,
	materials: Dynamic
};

class MaterialManager {

	private static var _timer           : Timer;
	private static var _persent         : Int;
	private static var _loadProgress    : Int;
	private static var _jText           : JQuery;
	private static var _materialData    : Map<String,MaterialData>;
	private static inline var BASE_PATH : String  = 'files/model/';
	private static inline var INTERVAL  : Int     = 10;
	private static var _manifest : Array<Dynamic> = [
		{ id:'ladybug',src:'ladybug.json' }
	];

	/* =======================================================================
    	Constractor
    ========================================================================== */
	public static function load():Void {

		_jText = new JQuery('#load');
		_materialData = new Map();
		_persent = 0;
		_loadProgress = 0;
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

			if (_loadProgress <= _persent) {
				_persent = _loadProgress;
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

		function loadData(num:Int):Promise<Dynamic> {
			return new Promise(function(resolve,reject) {

				var data   : Dynamic    = _manifest[num];
				var loader : JSONLoader = new JSONLoader();
				loader.load(BASE_PATH + data.src,function( geometry, materials) {
					_materialData[data.id] = {
						geometry  : geometry,
						materials : materials
					};
					counter++;
					onProgress(counter,length);
					resolve(num);
				});
			});

		}

		var promise : Promise<Dynamic> = Promise.resolve();

		for (i in 0 ... length) {

			promise = promise.then(function(src:String) {

				return loadData(i);

			});

		}

		promise = promise.then(function(num) {});
		promise = promise.catchError(function(reason:String) {
				trace(reason);
			});

	}

	/* =======================================================================
		On Progress
	========================================================================== */
	private static function onProgress(current:Int,length:Int):Void {

		_loadProgress = Math.floor(current / length * 100);

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

			return _materialData.get(id);

		}

}
