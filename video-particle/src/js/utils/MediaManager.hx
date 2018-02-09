package utils;

import haxe.Timer;
import haxe.extern.EitherType;
import js.Browser;
import js.Error;
import js.Promise;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.VideoElement;
import js.html.Image;
import js.html.Uint8ClampedArray;
import js.jquery.JQuery;
import js.three.Texture;
import utils.mediaManager.*;
import jp.okawa.js.ImageTools;

typedef Order = {
	id  :String,
	type:String,
	src :String
};

typedef ImageMedia = {
	src      :String,
	width    :Int,
	height   :Int,
	pixelData:Uint8ClampedArray
};

typedef VideoMedia = {
	video  :VideoElement,
	canvas :CanvasElement,
	texture:Texture
};

class MediaManager {

	public static var isUseWebCamera:Bool = false;

	private static var _progress:Int;
	private static var _jText   :JQuery;
	private static var _materialData:Map<String,EitherType<ImageMedia,VideoMedia>>;

	/* =======================================================================
    	Constractor
    ========================================================================== */
	public static function load(orders:Array<Order>):Void {

		_materialData = new Map();
		_jText    = new JQuery('#load');
		_progress = 100;

		countProgress();
		start(orders);

	}

	/* =======================================================================
		Count Progress
	========================================================================== */
	private static function countProgress():Void {

		var mater:Int = 0;
		var timer:Timer = new Timer(10);
		timer.run = function() {

			if (100 <= mater) {
				timer.stop();
				onComplete();
				return;
			}

			mater++;
			if (_progress <= mater) mater = _progress;
			_jText.text('Loading... $mater%');

		};

	}

	/* =======================================================================
		Start
	========================================================================== */
	private static function start(orders:Array<Order>):Void {

		var length :Int = orders.length;
		var counter:Int = 0;

		function loadData(num:Int):Promise<Dynamic> {
			return new Promise(function(resolve,reject) {

				function complete() {
					counter++;
					onProgress(counter,length);
					resolve(num);
				}

				var data:Order = orders[num];
				switch (data.type) {
					case 'video':return loadVideo(data,complete);
					case 'image':return loadImage(data,complete);
					default     :return complete();
				}

			});

		}

		var promise:Promise<Dynamic> = Promise.resolve();
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
		Load Video
	========================================================================== */
	private static function loadVideo(data:Order,callback:Void->Void):Void {

		var canvas:CanvasElement = Browser.document.createCanvasElement();
		var video :VideoElement  = Browser.document.createVideoElement();

		video.oncanplaythrough = function() {
			
			canvas.width  = video.videoWidth;
			canvas.height = video.videoHeight;
			_materialData[data.id] = {
				video   : video,
				canvas  : canvas,
				texture : new Texture(canvas)
			};
			callback();

		}

		video.src = data.src;
		video.load();

	}

	/* =======================================================================
		Load Image
	========================================================================== */
	private static function loadImage(data:Order,callback:Void->Void):Void {

		var image:Image = new Image();
		image.onload = function():Void {

			_materialData[data.id] = {
				src    : data.src,
				width  : image.width,
				height : image.height,
				pixelData : ImageTools.getPixelData(image)
			};

			callback();

		}

		image.src = data.src;

	}

	/* =======================================================================
		On Progress
	========================================================================== */
	private static function onProgress(current:Int,length:Int):Void {

		_progress = Math.floor(current / length * 100);

	}

	/* =======================================================================
		On Complete
	========================================================================== */
	private static function onComplete():Void {

		function complete() {
			_jText.fadeOut(400);
			Main.create();
		}

		if (isUseWebCamera) WebCamera.setup(complete);
		else complete();

	}

		/* =======================================================================
			Get Image
		========================================================================== */
		public static function getImage(id:String):ImageMedia {

			return _materialData.exists(id) ? _materialData[id] : null;

		}

		/* =======================================================================
			Get Video
		========================================================================== */
		public static function getVideo(id:String):VideoMedia {

			return _materialData.exists(id) ? _materialData[id] : null;

		}

}
