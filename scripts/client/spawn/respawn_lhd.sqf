private [ "_lhd_x", "_lhd_y", "_lhd_z", "_spread", "_rotation", "_posx", "_posy" ];

if ( GRLIB_isAtlasPresent ) then {

	_lhd_x = 6;
	_lhd_y = -16;
	_lhd_z = 16.5;
	_spread = 6;

	_lhd_z = 23.5295;

	_rotation = 180;
	_posx = (getposasl lhd select 0) + _lhd_x;
	_posy = (getposasl lhd select 1) + _lhd_y;
	_posx = (_posx + (random _spread)) - (_spread / 2);
	_posy = (_posy + (random _spread)) - (_spread / 2);
	player setposasl [759.407, 16216.7, _lhd_z ];
	player setDir 180;

} else {
	player setpos ( [ getpos lhd, random 6, random 360 ] call BIS_fnc_relPos );
};
