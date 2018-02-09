package utils;

import js.html.CanvasElement;
import js.jquery.JQuery;
import js.three.WebGLRenderer;
import js.three.PerspectiveCamera;
import js.three.Scene;
import js.three.Vector3;
import object.ObjectManager;
import view.Window;

class RendererManager {

	private static var _renderer:WebGLRenderer;
	private static var _jStage  :JQuery;

	/* =======================================================================
    	Constractor
    ========================================================================== */
	public static function init():Void {

		_renderer = new WebGLRenderer({ antialias:true });
		_renderer.setClearColor( 0x353535, 1 );
		_renderer.setPixelRatio(Window.devicePixelRatio());
		_renderer.gammaInput  = true;
		_renderer.gammaOutput = true;
		_jStage = new JQuery('#stage').append(getElement()).hide();


	}

		/* =======================================================================
			Start
		========================================================================== */
		public static function start():Void {

			_jStage.fadeIn(400);
			rendering();
			
		}

	/* =======================================================================
		Show
	========================================================================== */
	private static function rendering():Void {

		var mouseX:Float = EventManager.mouseX();
		var mouseY:Float = EventManager.mouseY();
		var mouseVector:Vector3 = EventManager.getMouseVector();

		Window.requestAnimationFrame(rendering);
		ObjectManager.onUpdate();
		Enviroment.onUpdate();
		
		_renderer.render(SceneManager.get(),Enviroment._camera);

	}

		/* =======================================================================
			On Resize
		========================================================================== */
		public static function onResize(winW:Float,winH:Float):Void {

			_renderer.setSize(winW,winH);

		}

		/* =======================================================================
			Get Element
		========================================================================== */
		public static function getElement():CanvasElement {

			return _renderer.domElement;

		}

}
