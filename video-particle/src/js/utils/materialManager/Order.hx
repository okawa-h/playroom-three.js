package utils.materialManager;

import js.Browser.document as Document;
import js.Promise;
import js.html.CanvasElement;
import js.html.Image;
import js.html.VideoElement;
import js.three.Texture;
import utils.MaterialManager;
import jp.okawa.js.ImageTools;

class Order {

	private static var _counter : Int;
	private static var _length  : Int;

	/* =======================================================================
		Load
	========================================================================== */
	public static function load(order:Array<OrderItem>):Void {

		_length  = order.length;
		_counter = 0;

		function loadData(num:Int):Promise<Int> {

			var data : OrderItem = order[num];
			switch (data.type) {
				case 'video':
					return loadVideo(num,data);
				case 'image':
					return loadImage(num,data);
				default:
					return null;
			}

		}

		var promise : Promise<Dynamic> = Promise.resolve();

		for (i in 0 ... _length) {

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
	private static function loadVideo(num:Int,data:OrderItem):Promise<Int> {

		return new Promise(function(resolve,reject):Void {

			var canvas : CanvasElement = Document.createCanvasElement();
			var video  : VideoElement  = Document.createVideoElement();
			video.src = data.src;
			video.oncanplaythrough = function():Void {
				
				canvas.width  = video.videoWidth;
				canvas.height = video.videoHeight;
				Data.set(data.type,data.id,{
					video  : video,
					canvas : canvas,
					ctx    : canvas.getContext2d(),
					texture: new Texture(canvas)
				});

				loadProgress(num,resolve);

			}

			video.load();

		});

	}

	/* =======================================================================
		Load Image
	========================================================================== */
	private static function loadImage(num:Int,data:OrderItem):Promise<Int> {

		return new Promise(function(resolve,reject):Void {

			var image : Image = new Image();
			image.onload = function():Void {

				Data.set(data.type,data.id,{
					src    : data.src,
					width  : image.width,
					height : image.height,
					pixelData : ImageTools.getPixelData(image)
				});

				loadProgress(num,resolve);

			}

			image.src = data.src;

		});

	}

	/* =======================================================================
		Load Progress
	========================================================================== */
	private static function loadProgress(num:Int,resolve):Void {

		_counter++;
		MaterialManager.onProgress(_counter,_length);
		resolve(num);

	}

}
