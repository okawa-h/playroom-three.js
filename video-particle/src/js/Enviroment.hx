package ;

import js.three.Vector3;
import js.three.PerspectiveCamera;

import js.three.DirectionalLight;

import js.three.OrbitControls;

import js.three.AxisHelper;
import js.three.GridHelper;

import utils.SceneManager;
import utils.RendererManager;
import view.Window;

class Enviroment {

	public static var _camera      :PerspectiveCamera;
	private static var _orbitControl:OrbitControls;

	/* =======================================================================
    	Constractor
    ========================================================================== */
	public static function init():Void {

		setupCamera();
		setupLight();
		setupHelper();
		setupOrbitControls();

	}

		/* =======================================================================
			On Resize
		========================================================================== */
		public static function onResize(winW:Float,winH:Float):Void {

			_camera.aspect = winW/winH;
			_camera.updateProjectionMatrix();

		}

		/* =======================================================================
			On Update
		========================================================================== */
		public static function onUpdate():Void {

			_orbitControl.update();

		}

	/* =======================================================================
    	Setup Light
    ========================================================================== */
	private static function setupCamera():Void {

		var FOV :Int = 60;
		var NEAR:Int = 1;
		var FAR :Int = 10000;
		var winW:Float = Window.width();
		var winH:Float = Window.height();
		_camera = new PerspectiveCamera(FOV, winW/winH, NEAR, FAR);
		_camera.position.set(200,200,3000);
		_camera.lookAt(new Vector3(0,0,0));
		SceneManager.add(_camera);

	}

	/* =======================================================================
    	Setup Light
    ========================================================================== */
	private static function setupLight():Void {

		var light:DirectionalLight = new DirectionalLight(0xffffff);
		light.position.set(20,40,30);
		SceneManager.add(light);

	}

	/* =======================================================================
    	Setup OrbitControls
    ========================================================================== */
	private static function setupOrbitControls():Void {

		_orbitControl = new OrbitControls(_camera,cast RendererManager.getElement());

	}

	/* =======================================================================
    	Setup Helper
    ========================================================================== */
	private static function setupHelper():Void {

		return;
		var array:Array<Dynamic> = [];

		array.push(new GridHelper(1000,10));
		array.push(new AxisHelper(1000));

		for (i in 0 ... array.length) {
			SceneManager.add(array[i]);
		}

	}

}
