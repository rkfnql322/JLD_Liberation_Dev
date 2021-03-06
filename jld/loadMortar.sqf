systemChat "박격포 차량 탑재 스크립트 활성화";


staticLoadDistance = 5;
_loadMortar = -1;
_unloadMortar = -1;
loadWeapons = ["Mortar_01_base_F", "HMG_01_base_F", "GMG_01_base_F", "AA_01_base_F", "AT_01_base_F"];

truck_Mortar = {
	params ["_truck"];
	_return = objNull;
	{
		_obj=_x;
		{
			if(_obj isKindOf _x)then{
				_return = _obj;
			}
		}forEach loadWeapons;				
	}forEach attachedObjects _truck;
	_return
};

while{true}do{
	while{true}do{
		
		{
			_x enableWeaponDisassembly false;
		}forEach (player nearEntities ["StaticWeapon", 10]);
		
		_mortar = nearestObject [player, "StaticWeapon"];
		_truck = (nearestObjects [player, ["Truck_F","Car_F"],10]-nearestObjects [player, ["Wheeled_APC_F"],10])#0;	
		if(count (nearestObjects [player, ["Truck_F","Car_F"],10]-nearestObjects [player, ["Wheeled_APC_F"],10]) == 0 ) then {_truck = objNull};
		
		_isAllowed = false;
		{if(_mortar isKindOf _x)then{_isAllowed = true;}}forEach loadWeapons;
		
		if(_truck distance player < staticLoadDistance && _mortar distance player < staticLoadDistance && (isNull ([_truck] call truck_Mortar)) && count crew _mortar == 0)then{
			if(_loadMortar == -1)then{
				if(_isAllowed)then{
					_loadMortar = player addAction 
					[
					"고정무기 적재", 
					{
						_mortar = nearestObject [player, "StaticWeapon"];
						_truck = (nearestObjects [player, ["Truck_F","Car_F"],10]-nearestObjects [player, ["Wheeled_APC_F"],10])#0;	
						[_mortar,true] remoteExec ["hideObjectGlobal"];
						_mortar attachTo [_truck, [0,0,1]];
						hint "고정무기를 차량에 적재하였습니다.";
					},
					[],
					6, 
					true, 
					true, 
					"",
					"true", // _target, _this, _originalTarget
					staticLoadDistance,
					false,
					"",
					""
					];
				};				
			};
		}else {
			if(_loadMortar != -1)then{
				player removeAction _loadMortar; 
				_loadMortar = -1;
			};
		};
		
		if((_truck distance player < staticLoadDistance) && (count attachedObjects _truck > 0) && (!isNull ([_truck] call truck_Mortar)))then{
			if(_unloadMortar == -1)then{
				_unloadMortar = player addAction 
				[
				"고정무기 하역", 
				{
					_truck = (nearestObjects [player, ["Truck_F","Car_F"],10]-nearestObjects [player, ["Wheeled_APC_F"],10])#0;	
					_mortar = [_truck] call truck_Mortar;
					detach _mortar;
					_mortar setPos getPos player;
					_mortar setDir getDir player;
					[_mortar,false] remoteExec ["hideObjectGlobal"];
					hint "고정무기를 차량에서 하역하였습니다.";
				},
				[],
				6, 
				true, 
				true, 
				"",
				"vehicle player == player", // _target, _this, _originalTarget
				staticLoadDistance,
				false,
				"",
				""
				];
			};
		}else{	
			if(_unloadMortar != -1)then{		
				player removeAction _unloadMortar; 
				_unloadMortar = -1;
			};
		};
		
		sleep 1;
	};
};