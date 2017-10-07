package view;

import js.Browser;
import js.html.Event;
import js.html.Window as WindowElement;

class Window {

	private static var _window : WindowElement;

	/* =======================================================================
    	Constractor
    ========================================================================== */
	public static function init():Void {

		_window  = Browser.window;

	}

		/* =======================================================================
			width
		========================================================================== */
		public static function width():Float {

			return _window.innerWidth;

		}

		/* =======================================================================
			Height
		========================================================================== */
		public static function height():Float {

			return _window.innerHeight;

		}

		/* =======================================================================
			On
		========================================================================== */
		public static function setEvent(eventName:String,func:Dynamic):Void {

			_window.addEventListener(eventName,func);

		}

		/* =======================================================================
			Trigger
		========================================================================== */
		public static function trigger(eventName:String):Void {

			var event : Event = Browser.document.createEvent('HTMLEvents');
			event.initEvent(eventName,true,true);
			_window.dispatchEvent(event);

		}

		/* =======================================================================
			Request Animation Frame
		========================================================================== */
		public static function requestAnimationFrame(frame:Dynamic):Void {

			_window.requestAnimationFrame(frame);

		}

		/* =======================================================================
			Get Device Pixel Ratio
		========================================================================== */
		public static function getDevicePixelRatio():Float {

			return _window.devicePixelRatio;

		}

}
