package object;

import js.html.CanvasRenderingContext2D;
import js.html.VideoElement;
import js.three.PlaneGeometry;
import js.three.Mesh;
import js.three.MeshBasicMaterial;
import js.three.Texture;
import js.three.TextureFilter;
import js.three.Side;
import object.*;
import utils.MaterialManager;

class Viewer {

	private static var _parent : Mesh;
	private static var _ctx    : CanvasRenderingContext2D;
	private static var _video  : VideoElement;
	private static var _texture : Texture;

	/* =======================================================================
		Init
	========================================================================== */
	public static function create():Void {

		var data : MaterialData = MaterialManager.getItem('cloud');
		_video   = data.video;
		_ctx     = data.ctx;
		_texture = data.texture;

		_texture.minFilter = TextureFilter.LinearFilter;
		_texture.magFilter = TextureFilter.LinearFilter;
		var geometry : PlaneGeometry = new PlaneGeometry(_video.videoWidth, _video.videoHeight);
		var material : MeshBasicMaterial = new MeshBasicMaterial({
			side : Side.DoubleSide,
			map  : _texture
		});

		_video.loop = true;
		_video.play();
		_parent = new Mesh(geometry,material);
		_parent.position.set(0,0,0);

		ViewerGroup.add(_parent);

	}

		/* =======================================================================
			On Resize
		========================================================================== */
		public static function onUpdate():Void {

			var timer : Float = Date.now().getTime() * .001;
			_parent.rotation.y = timer * .2;
			_ctx.drawImage(_video, 0, 0);
			_texture.needsUpdate = true;

		}

}
