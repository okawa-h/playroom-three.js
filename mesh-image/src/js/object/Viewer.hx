package object;

import js.html.Uint8ClampedArray;
import js.three.BoxGeometry;
import js.three.CubeGeometry;
import js.three.SphereGeometry;
import js.three.Color;
import js.three.Colors;
import js.three.Group;
import js.three.Mesh;
import js.three.MeshBasicMaterial;
import js.three.Side;
import tween.TweenMaxHaxe;
import tween.easing.Expo;
import tween.easing.Sine;
import object.*;
import utils.MaterialManager;
import jp.okawa.utils.MathTools;

class Viewer {

	private static var _parent   : Group;
	private static var _meshData : Array<Dynamic>;
	private static inline var BOX_SIZE : Int = 10;

	/* =======================================================================
		Init
	========================================================================== */
	public static function create():Void {

		_parent = new Group();
		_meshData = [];

		var data : ImageMaterial = MaterialManager.get('pikachu');
		createMesh(data.width,data.height,data.pixelData);

		ViewerGroup.add(_parent);

	}

		/* =======================================================================
			On Resize
		========================================================================== */
		public static function onUpdate():Void {

			// var timer : Float = Date.now().getTime() * .001;
			// // _parent.rotation.y = timer * .2;

		}

	/* =======================================================================
		Create Mesh
	========================================================================== */
	private static function createMesh(width:Int,height:Int,pixels:Uint8ClampedArray):Void {

		var pixelCounter : Int = 0;
		var halfW : Float = width * .5;
		var halfH : Float = height * .5;

		for (i in 0 ... width) {
			for (l in 0 ... height) {

				var r : Int = pixels[pixelCounter];
				var g : Int = pixels[pixelCounter + 1];
				var b : Int = pixels[pixelCounter + 2];
				var opacity : Int = pixels[pixelCounter + 3];
				pixelCounter = (i * 4) + l * (4 * width);

				// var geometry : BoxGeometry = new BoxGeometry(BOX_SIZE,BOX_SIZE,BOX_SIZE);
				var geometry : SphereGeometry = new SphereGeometry(BOX_SIZE);
				var material : MeshBasicMaterial = new MeshBasicMaterial({
					side : Side.FrontSide,
					transparent : true,
					opacity : opacity
				});

				material.color = new Color('rgb(${r},${g},${b})');

				var mesh : Mesh = new Mesh(geometry,material);
				// mesh.position.x =  ( i - halfW ) * BOX_SIZE;
				// mesh.position.y = -( l - halfH ) * BOX_SIZE;
				// mesh.position.z = MathTools.randomFloatSpread(200);
				// mesh.position.z = 0;
				mesh.position.x = 0;
				mesh.position.y = 0;
				mesh.position.z = 0;

				_parent.add(mesh);

				TweenMaxHaxe.to(mesh.position,1,{
					x    : ( i - halfW ) * BOX_SIZE,
					y    : -( l - halfH ) * BOX_SIZE,
					z    : MathTools.randomFloatSpread(0),
					ease : Expo.easeInOut,
					onComplete : function() {
						animate(mesh.position);
					}
				});
				
			}
		}

	}

	/* =======================================================================
		Animate
	========================================================================== */
	private static function animate(position:js.three.Vector3):Void {

		var x : Float = position.x;
		var y : Float = position.y;

		TweenMaxHaxe.to(position,1,{
			x : x + MathTools.randomFloatSpread(20),
			y : y + MathTools.randomFloatSpread(20),
			ease   : Sine.easeIn,
			repeat : -1,
			yoyo   : true,
			onComplete : function() {

				// TweenMaxHaxe.to(position,1,{
				// 	x : x,
				// 	y : y,
				// 	ease : Sine.easeIn,
				// });

			}
		});

	}

}
