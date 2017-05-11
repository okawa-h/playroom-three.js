package view;

import js.html.CanvasElement;
import js.jquery.JQuery;

class Stage {

	private static var _jParent : JQuery;

	/* =======================================================================
    	Constractor
    ========================================================================== */
	public static function init(element:CanvasElement):Void {

		_jParent = new JQuery('#stage').append(element).hide();

	}

	/* =======================================================================
    	Show
    ========================================================================== */
	public static function show():Void {

		_jParent.fadeIn(2000);

	}

}
