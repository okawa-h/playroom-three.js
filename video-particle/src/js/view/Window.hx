package view;

import js.Browser;
import js.html.Window as WindowElement;
import js.jquery.JQuery;

class Window {

	private static var _window :WindowElement;
	private static var _jWindow:JQuery;

	/* =======================================================================
    	Constractor
    ========================================================================== */
	public static function init():Void {

		_window  = Browser.window;
		_jWindow = new JQuery(_window);

	}

		/* =======================================================================
			width
		========================================================================== */
		public static function width():Float {

			return _jWindow.innerWidth();

		}

		/* =======================================================================
			Height
		========================================================================== */
		public static function height():Float {

			return _jWindow.innerHeight();

		}

		/* =======================================================================
			On
		========================================================================== */
		public static function setEvent(event:Dynamic):Void {

			_jWindow.on(event);

		}

		/* =======================================================================
			Trigger
		========================================================================== */
		public static function trigger(eventName:String):Void {

			_jWindow.trigger(eventName);

		}

		/* =======================================================================
			Device Pixel Ratio
		========================================================================== */
		public static function devicePixelRatio():Float {

			return _window.devicePixelRatio;

		}

		/* =======================================================================
			Request Animation Frame
		========================================================================== */
		public static function requestAnimationFrame(rendering:Dynamic):Void {

			_window.requestAnimationFrame(function(time:Float) {
				rendering();
			});

		}

}
