package view;

import js.three.Vector3;
import js.three.PerspectiveCamera;
import utils.EventManager;
import utils.SceneManager;
import view.Window;

class Camera {

	private static var _camera     : PerspectiveCamera;
	private static inline var FOV  : Int = 60;
	private static inline var NEAR : Int = 1;
	private static inline var FAR  : Int = 10000;

	/* =======================================================================
    	Constractor
    ========================================================================== */
	public static function init():Void {

		var winW : Float = Window.width();
		var winH : Float = Window.height();
		_camera = new PerspectiveCamera(FOV, winW/winH, NEAR, FAR);
		_camera.position.set(200,200,3000);
		_camera.lookAt(new Vector3(0,0,0));
		SceneManager.add(_camera);

	}

		/* =======================================================================
			On Update
		========================================================================== */
		public static function onUpdate(mouseX:Float,mouseY:Float):PerspectiveCamera {

			// _camera.rotation.y += .1;
			// _camera.lookAt(SceneManager.getPosition());

			return _camera;

		}

		/* =======================================================================
			On Resize
		========================================================================== */
		public static function onResize(winW:Float,winH:Float):Void {

			_camera.aspect = winW/winH;
			_camera.updateProjectionMatrix();

		}

		/* =======================================================================
			Get Parent
		========================================================================== */
		public static function getParent():PerspectiveCamera {

			return _camera;

		}

		/* =======================================================================
			Get Position
		========================================================================== */
		public static function getPosition():Vector3 {

			return _camera.position;

		}

}
