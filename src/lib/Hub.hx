package lib;


import lib.Data;
import lib.Channel;

class Hub {	
	var base(default, null):Base;
	
	var chs:Array<Channel>;
	
	public function new(b:Base) {
		base = b;
		chs = [];
	}
	
	public function add(site:Channel):Void {
		if (site.base == base) {
			for(c in chs){
				if (Channel.eq(c, site)) throw new js.Error("already exists");
			}	
			chs.push(site);
		}
		throw new js.Error("Base-type inconsistent");
	}
	
	public function remove(site:Channel):Bool {
		var pos = chs.indexOf(site);
		return pos != -1 ? chs.splice(pos, 1).length > 0 : false;
	}
}