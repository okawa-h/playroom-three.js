package object;

import js.html.CanvasRenderingContext2D;
import js.html.VideoElement;
import js.three.BoxGeometry;
import js.three.Color;
import js.three.Colors;
import js.three.Group;
import js.three.PixelFormat;
import js.three.Mesh;
import js.three.MeshLambertMaterial;
import js.three.Material;
import js.three.Texture;
import js.three.TextureFilter;
import js.three.Side;
import js.three.Vector2;
import js.three.Vector3;
import tween.TweenMaxHaxe;
import tween.easing.Expo;
import object.*;
import utils.MaterialManager;
import jp.okawa.utils.MathTools;

class Viewer {

	private static var _parent    : Group;
	private static var _meshs     : Array<Mesh>;
	private static var _materials : Array<Material>;
	private static var _ctx    : CanvasRenderingContext2D;
	private static var _video  : VideoElement;
	private static var _texture : Texture;
	private static inline var INTERVAL : Int = 1;
	private static inline var X_GRID : Int = 20;
	private static inline var Y_GRID : Int = 10;

	/* =======================================================================
		Init
	========================================================================== */
	public static function create():Void {

		_parent    = new Group();
		_meshs     = [];
		_materials = [];

		var data : MaterialData = MaterialManager.getItem('cloud');
		_video   = data.video;
		_ctx     = data.ctx;
		_texture = data.texture;
		_texture.minFilter = TextureFilter.LinearFilter;
		_texture.magFilter = TextureFilter.LinearFilter;
		_texture.format    = PixelFormat.RGBFormat;

		createMesh(_video.videoWidth / X_GRID, _video.videoHeight / Y_GRID);

		_video.loop = true;
		_video.play();

		ViewerGroup.add(_parent);

	}

		/* =======================================================================
			On Resize
		========================================================================== */
		public static function onUpdate():Void {

			// var timer : Float = Date.now().getTime() * .001;
			// // _parent.rotation.y = timer * .2;
			_ctx.drawImage(_video, 0, 0);
			_texture.needsUpdate = true;

		}

	/* =======================================================================
		Create Mesh
	========================================================================== */
	private static function createMesh(xsize:Float,ysize:Float):Void {

		var cubeCounter : Int = 0;
		var unitx : Float = 1 / X_GRID;
		var unity : Float = 1 / Y_GRID;

		for (i in 0 ... X_GRID) {
			for (l in 0 ... Y_GRID) {

				var geometry : BoxGeometry = new BoxGeometry(xsize,ysize,xsize);
				changeUvs(geometry,unitx,unity,i,l);

				var material : MeshLambertMaterial = new MeshLambertMaterial({
					color: 0xffffff,
					map  : _texture
				});
				_materials[cubeCounter] = material;

				var mesh : Mesh = new Mesh(geometry,material);
				mesh.position.x = ( i - X_GRID/2 ) * xsize;
				mesh.position.y = ( l - Y_GRID/2 ) * ysize;
				mesh.position.z = 0;

				_parent.add(mesh);
				cubeCounter++;

				TweenMaxHaxe.to(mesh.position,1,{
					z    : MathTools.randomFloatSpread(200),
					ease : Expo.easeInOut,
					repeat: -1,
					yoyo: true
				});
				
			}
		}

	}

	/* =======================================================================
		Change Uvs
	========================================================================== */
	private static function changeUvs(geometry:BoxGeometry,unitx:Float,unity:Float,offsetx:Float,offsety:Float):Void {

		var faceVertexUvs : Array<Array<Vector2>> = geometry.faceVertexUvs[0];
		for (i in 0 ... faceVertexUvs.length) {
			var uvs : Array<Vector2> = faceVertexUvs[i];
			for (l in 0 ... uvs.length) {
				var uv : Vector2 = uvs[ l ];
				uv.x = ( uv.x + offsetx ) * unitx;
				uv.y = ( uv.y + offsety ) * unity;
			}
		}

	}

}
