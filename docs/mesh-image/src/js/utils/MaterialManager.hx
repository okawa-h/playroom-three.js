package utils;

import haxe.Timer;
import haxe.extern.EitherType;
import js.Browser;
import js.html.CanvasRenderingContext2D;
import js.html.Uint8ClampedArray;
import js.html.VideoElement;
import js.jquery.JQuery;
import js.three.Texture;
import view.Window;
import utils.materialManager.*;

typedef DataMaterial = EitherType<VideoMaterial,ImageMaterial>;

typedef VideoMaterial = {
	video   : VideoElement,
	ctx     : CanvasRenderingContext2D,
	texture : Texture
};

typedef ImageMaterial = {
	src       : String,
	width     : Int,
	height    : Int,
	pixelData : Uint8ClampedArray
};

typedef OrderItem = {
	id   : String,
	src  : String,
	type : String
};

class MaterialManager {

	private static var _loadProgress : Int;
	private static var _jText        : JQuery;
	private static var _orderList    : Array<OrderItem> = [
		{ id:'pokemon',src:'files/img/pokemon.png',type:'image' },
		{ id:'houou',src:'files/img/houou.png',type:'image' },
		{ id:'kabigon',src:'files/img/kabigon.png',type:'image' },
		{ id:'pikachu',src:'files/img/pikachu.png',type:'image' }
	];

	/* =======================================================================
    	Constractor
    ========================================================================== */
	public static function init():Void {

		_jText = new JQuery('#load');
		_loadProgress = 100;
		start();
		Data.init();
		Order.load(_orderList);

	}

	/* =======================================================================
		Timer
	========================================================================== */
	private static function start():Void {

		var persent : Int = 0;
		var timer   : Timer = new Timer(10);
		timer.run = function() {

			if (persent >= 100) {
				timer.stop();
				Timer.delay(onLoadedMaterial,300);
				return;
			}

			persent++;

			if (_loadProgress <= persent) persent = _loadProgress;

			_jText.text('Loading... ${persent}%');
		};

	}

	/* =======================================================================
		On Loaded Material
	========================================================================== */
	private static function onLoadedMaterial():Void {

		_jText.fadeOut(400);
		Window.trigger('materialLoaded');

	}

		/* =======================================================================
			On Progress
		========================================================================== */
		public static function onProgress(current:Int,max:Int):Void {

			_loadProgress = Math.floor(current / max * 100);

		}

		/* =======================================================================
			Get
		========================================================================== */
		public static function get(id:String):DataMaterial {

			return Data.get(id);

		}

}
