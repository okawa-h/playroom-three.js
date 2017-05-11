package view;

import js.three.Vector3;
import js.three.PerspectiveCamera;
import tween.TweenMaxHaxe;
import tween.easing.Expo;
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
		_camera.position.set(0,-600,150);
		_camera.lookAt(new Vector3(0,0,0));
		SceneManager.add(_camera);
		animation();

	}

	/* =======================================================================
		animation
	========================================================================== */
	private static function animation():Void {

		TweenMaxHaxe.to(_camera.position,1,{
			z : 0,
			ease: Expo.easeInOut,
			delay:1,
			onComplete:function() {
				TweenMaxHaxe.to(_camera.position,5,{
					y:600,
					ease: Expo.easeInOut,
					onComplete:function() {
						TweenMaxHaxe.to(_camera.position,3,{
							y:10,
							ease: Expo.easeInOut,
							onComplete:function() {
								TweenMaxHaxe.to(_camera.position,2,{
									z:600,
									ease: Expo.easeInOut
								});
							}
						});
					}
				});
			}
		});

	}

		/* =======================================================================
			On Update
		========================================================================== */
		public static function onUpdate(mouseX:Float,mouseY:Float):PerspectiveCamera {

			// var timer : Float = Date.now().getTime();
			// _camera.position.set(mouseX + 400,mouseY + 400,1000);
			_camera.lookAt(SceneManager.getPosition());
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
