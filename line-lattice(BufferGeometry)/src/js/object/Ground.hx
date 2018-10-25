package object;

import js.three.Geometry;
import js.three.Vector3;
import js.three.LineBasicMaterial;
import js.three.LineSegments;
import utils.SceneManager;

typedef ParticleData = {
	velocity : Vector3
};

class Ground {

	/* =======================================================================
		Init
	========================================================================== */
	public static function create():Void {

		setParticleObject();

	}

		/* =======================================================================
			On Resize
		========================================================================== */
		public static function onUpdate():Void {

		}

	/* =======================================================================
		Set Particle Object
	========================================================================== */
	private static function setParticleObject():Void {

		var geometry:Geometry = new Geometry();

		function getZ(x:Float,y:Float) {

			return 70* Math.exp( -(x*x+y*y)/400 );

		}

		var N:Int   = 100;
		var w:Float = 2;

		//x軸方向
		for (i in 0 ... N) {
			for (j in 0 ... N) {
				var x0:Float = (i - N/2 ) * w;
				var y0:Float = (j - N/2 ) * w;
				var z0:Float = getZ(x0, y0);
				var x1:Float = ((i+1) - N/2 ) * w;
				var y1:Float = (j - N/2 ) * w;
				var z1:Float = getZ(x1, y1);
				//頂点座標データの追加
				geometry.vertices.push( new Vector3(x0, y0, z0) );
				geometry.vertices.push( new Vector3(x1, y1, z1) );
			}
			for (j in 0 ... N) {
				var x0:Float = (j - N/2 ) * w;
				var y0:Float = (i - N/2 ) * w;
				var z0:Float = getZ(x0, y0);
				var x1:Float = (j - N/2 ) * w;
				var y1:Float = ((i+1) - N/2 ) * w;
				var z1:Float = getZ(x1, y1);
				//頂点座標データの追加
				geometry.vertices.push( new Vector3(x0, y0, z0) );
				geometry.vertices.push( new Vector3(x1, y1, z1) );
			}
			
		}

		var material:LineBasicMaterial = new LineBasicMaterial({ color: 0xFFFFFF, transparent:true, opacity:0.5 });
		var lines   :LineSegments = new LineSegments(geometry, material);
		SceneManager.add(lines);
		lines.position.set(0, 0, 0);

	}

}
