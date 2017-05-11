package utils;

import js.Browser;
import js.html.Window;
import js.jquery.JQuery;
import js.jquery.Event;
import js.three.Vector;
import js.three.Vector3;
import js.three.Raycaster;
import utils.RendererManager;
import view.Camera;

class EventManager {

	private static var _window  : Window;
	private static var _jWindow : JQuery;
	private static var _mouseX  : Float;
	private static var _mouseY  : Float;
	private static var _mouseVector : Vector3;

	/* =======================================================================
    	Constractor
    ========================================================================== */
	public static function init():Void {

		_window  = Browser.window;
		_jWindow = new JQuery(_window);
		_mouseX  = 0;
		_mouseY  = 0;
		_mouseVector = null;

	}

	/* =======================================================================
		On Mousemove
	========================================================================== */
	private static function onMousemove(event:Event):Void {

		var rect    : Dynamic = untyped event.target.getBoundingClientRect();
		var clientX : Float   = event.clientX;
		var clientY : Float   = event.clientY;

		_mouseX = clientX - rect.left;
		_mouseY = clientY - rect.top;
		_mouseX = _mouseX - width() * 2 - 1;
		_mouseY = -(_mouseY - height()) * 2 + 1;

		_mouseVector = new Vector3(_mouseX,_mouseY,1);
		_mouseVector.unproject(Camera.getParent());

		var cameraPosi : Vector3 = Camera.getPosition();
		var normalize  : Vector  = _mouseVector.sub(cameraPosi).normalize();
		var ray        : Raycaster = new Raycaster(cameraPosi,cast normalize);

	}

	/* =======================================================================
		On Resize
	========================================================================== */
	private static function onResize(event:Event):Void {

		var winW : Float = width();
		var winH : Float = height();

		RendererManager.onResize(winW,winH);
		Camera.onResize(winW,winH);

	}

		/* =======================================================================
			Set Event
		========================================================================== */
		public static function setEvent():Void {

			_jWindow.on({

				'mousemove' : onMousemove,
				'resize'    : onResize

			}).trigger('resize');

		}

		/* =======================================================================
			On Update
		========================================================================== */
		public static function onUpdate(frame:Dynamic):Void {

			_window.requestAnimationFrame(frame);

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
			mouseX
		========================================================================== */
		public static function mouseX():Float {

			return _mouseX;

		}

		/* =======================================================================
			mouseY
		========================================================================== */
		public static function mouseY():Float {

			return _mouseY;

		}

		/* =======================================================================
			Get Mouse Vector
		========================================================================== */
		public static function getMouseVector():Vector3 {

			return _mouseVector;

		}

}
