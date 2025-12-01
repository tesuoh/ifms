/**
 * 
 */

function isEmpty(val, def){
	if(def == null) {
		if(typeof val === 'undefined' || val === undefined || val == null || val.length == 0) {
			return true;
		} else {
			return false;
		}
	} else {
		if(typeof val === 'undefined' || val === undefined || val == null || val.length == 0) {
			return def;
		} else {
			return val;
		}
	}
}