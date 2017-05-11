package utils.materialManager;

import utils.MaterialManager;

class Data {

	private static var _data : Map<String,Map<String,DataMaterial>>;

	/* =======================================================================
		Constractor
	========================================================================== */
	public static function init():Void {

		_data = new Map();
		_data['image'] = _data['video'] = new Map();

	}

		/* =======================================================================
			Get
		========================================================================== */
		public static function get(id:String):DataMaterial {

			for (key in _data.keys()) {
				if (_data[key].exists(id)) {
					return _data[key].get(id);
				}
			}

			return null;

		}

		/* =======================================================================
			Set
		========================================================================== */
		public static function set(type:String,id:String,prop:DataMaterial):Void {

			_data[type][id] = prop;

		}

}
