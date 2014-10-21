// A quick toolbox for 'gaming' Dragons of Atlantis: Heirs of the Dragon
// truthfully the intent is not to cheat, just to use resources most
// effectively and thus reduce the amount of interaction one actually has
// with the game. Because who has time for games? Let the game play itself,
// come back later, conquer, and go back to work. Right?
//

// pass in a dictionary with values.
function doaUnit(attribs, cost) {
	// since time-to-create is variable per-player, it's tough to factor in
	// actual time to build the unit.
	//
	this.attributes = { };
	this.cost       = { };

	// initialise all the things
	// TODO: just check the dict for valueness and unstupidness and then
	// co-opt it rather than setting all the things.
	//
	this.attributes.unit_name = attribs.unit_name;
	this.attributes.life = attribs.life;
	this.attributes.range = attribs.range;
	this.attributes.load = attribs.load;
	this.attributes.defense = attribs.defense;
	this.attributes.speed = attribs.speed;
	this.attributes.upkeep = attribs.upkeep;
	this.attributes.ranged_attack = attribs.ranged_attack;
	this.attributes.melee_attack = attribs.melee_attack;

	// same as above
	//
	this.cost.food  = cost.food;
	this.cost.wood  = cost.wood;
	this.cost.stone = cost.stone;
	this.cost.metal = cost.metal;

}

// export the class
//
module.exports = doaUnit;

/*
 * thoughts:
 * woodhour, metalhour, etc
 *
 * pow per metalhour
 * pow per hour training
 */


// jane@cpan.org * vim:tw=80:ts=2:noet
