package object;

import js.three.Color;
import js.three.Mesh;
import js.three.MeshNormalMaterial;
import js.three.Material;
import object.ModelGroup;
import utils.MaterialManager;
import jp.okawa.utils.MathTools;

class Model {

	/* =======================================================================
		Init
	========================================================================== */
	public static function create():Void {

		var data : Dynamic = MaterialManager.getItem('ladybug');
		var material : MeshNormalMaterial = new MeshNormalMaterial(data.materials);

		var mesh : Mesh = new Mesh( data.geometry, material );
		mesh.position.set( 0,0,0);
		mesh.scale.set( 10, 10, 10 );
		ModelGroup.add(mesh);

		var length : Int = 100;
		for (i in 0 ... length) {
			
			var mesh2 : Mesh = new Mesh( data.geometry, material );
			mesh2.position.set( MathTools.randomFloatSpread(1000),0,MathTools.randomFloatSpread(1000));
			mesh2.scale.set( 10, 10, 10 );
			ModelGroup.add(mesh2);

		}

	}

		/* =======================================================================
			On Resize
		========================================================================== */
		public static function onUpdate():Void {

		}

}
