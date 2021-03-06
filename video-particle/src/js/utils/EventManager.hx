package utils;

import js.jquery.Event;
import js.three.Vector;
import js.three.Vector3;
import js.three.Raycaster;
import utils.RendererManager;
import Enviroment;
import view.Window;

class EventManager {

	private static var _mouseX:Float;
	private static var _mouseY:Float;
	private static var _mouseVector:Vector3;

	/* =======================================================================
    	Constractor
    ========================================================================== */
	public static function init():Void {

		_mouseX = 0;
		_mouseY = 0;
		_mouseVector = null;

	}

	/* =======================================================================
		On Mousemove
	========================================================================== */
	private static function onMousemove(event:Event):Void {

		var rect   :Dynamic = untyped event.target.getBoundingClientRect();
		var clientX:Float   = event.clientX;
		var clientY:Float   = event.clientY;

		_mouseX = clientX - rect.left;
		_mouseY = clientY - rect.top;
		_mouseX = _mouseX - Window.width() * 2 - 1;
		_mouseY = -(_mouseY - Window.height()) * 2 + 1;

		_mouseVector = new Vector3(_mouseX,_mouseY,1);
		_mouseVector.unproject(Enviroment._camera);

		var cameraPosi : Vector3 = Enviroment._camera.position;
		var normalize  : Vector  = _mouseVector.sub(cameraPosi).normalize();
		var ray        : Raycaster = new Raycaster(cameraPosi,cast normalize);

	}

	/* =======================================================================
		On Resize
	========================================================================== */
	private static function onResize(event:Event):Void {

		var winW : Float = Window.width();
		var winH : Float = Window.height();

		RendererManager.onResize(winW,winH);
		Enviroment.onResize(winW,winH);

	}

		/* =======================================================================
			Set Event
		========================================================================== */
		public static function setEvent():Void {

			Window.setEvent({

				'mousemove' : onMousemove,
				'resize'    : onResize

			});

			Window.trigger('resize');

		}

		/* =======================================================================
			Trigger
		========================================================================== */
		public static function trigger(event:String):Void {

			Window.trigger(event);

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
