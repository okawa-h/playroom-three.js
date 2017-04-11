package object;

import js.three.Vector3;
import jp.okawa.utils.MathTools;

class Particle {

	private static inline var BOX_WIDTH  : Int = 500;
	private static inline var BOX_HEIGHT : Int = BOX_WIDTH;
	private static inline var BOX_DEPTH  : Int = BOX_WIDTH;
	private static inline var SPEED      : Float = 5;

		/* =======================================================================
	    	Constractor
	    ========================================================================== */
		public static function create():Vector3 {

			var x : Float = MathTools.randomFloatSpread(50);
			var y : Float = MathTools.randomFloatSpread(50);
			var z : Float = MathTools.randomFloatSpread(50);
			var vectolX : Float = Math.random() * 2 - 1;
			var vectolY : Float = Math.random() * 2 - 1;
			var vectolZ : Float = (vectolX + vectolY == 0) ? 1 : Math.random() * 2 - 1;

			var vector  : Vector3   = new Vector3(x,y,z);
			untyped vector.velocity = new Vector3(vectolX,vectolY,vectolZ);

			return vector;

		}

		/* =======================================================================
			On Update
		========================================================================== */
		public static function onUpdate(target:Vector3):Void {

			// untyped target.velocity.x += target.velocity.x * 0.001;
			// untyped target.velocity.y += target.velocity.y * 0.001;
			// untyped target.velocity.y += target.velocity.z * 0.001;

			// if (mouseX + 10 >= target.x && mouseX - 10 <= target.x) {
			// 	if (mouseY + 10 >= target.y && mouseY - 10 <= target.y) {
			// 		target.x = mouseX;
			// 		target.y = -mouseY;
			// 		target.z = mouseZ;
			// 	}
			// }

			untyped target.x += target.velocity.x * SPEED;
			untyped target.y += target.velocity.y * SPEED;
			untyped target.z += target.velocity.z * SPEED;
				
			if (target.y > BOX_HEIGHT || target.y < -BOX_HEIGHT) {

				untyped target.velocity.y *= -1;

			}
			
			if (target.x > BOX_WIDTH || target.x < -BOX_WIDTH) {

				untyped target.velocity.x *= -1;

			}
			
			if (target.z > BOX_DEPTH || target.z < -BOX_DEPTH) {

				untyped target.velocity.z *= -1;

			}

		}

}
