/*
 * Author: KoffeinFlummi
 * Adjusts the direction of a shell. Called from the unified fired EH only if the gunner is a player.
 *
 * Arguments:
 * None. Parameters inherited from CFUNC(firedEH)
 *
 * Return Value:
 * None
 *
 * Public: No
 */
#include "script_component.hpp"

//IGNORE_PRIVATE_WARNING ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle", "_gunner", "_turret"];
TRACE_10("firedEH:",_unit, _weapon, _muzzle, _mode, _ammo, _magazine, _projectile, _vehicle, _gunner, _turret);

private _FCSMagazines = _vehicle getVariable [format ["%1_%2", QGVAR(Magazines), _turret], []];
private _FCSElevation = _vehicle getVariable format ["%1_%2", QGVAR(Elevation), _turret];

if !(_magazine in _FCSMagazines) exitWith {};

// GET ELEVATION OFFSET OF CURRENT MAGAZINE
private _offset = 0;

{
    if (_x == _magazine) exitWith {
        _offset = _FCSElevation select _forEachIndex;
    };
} forEach _FCSMagazines;

[_projectile, (_vehicle getVariable format ["%1_%2", QGVAR(Azimuth), _turret]), _offset, 0] call CFUNC(changeProjectileDirection);

// Remove the platform velocity
if (vectorMagnitude velocity _vehicle > 2) then {
    private _sumVelocity = (velocity _projectile) vectorDiff (velocity _vehicle);

    _projectile setVelocity _sumVelocity;
};

// Air burst missile
// handle locally only
if (!local _gunner) exitWith {};

if (getNumber (configFile >> "CfgAmmo" >> _ammo >> QGVAR(Airburst)) == 1) then {
    private _zeroing = _vehicle getVariable [format ["%1_%2", QGVAR(Distance), _turret], currentZeroing _vehicle];

    if (_zeroing < 50) exitWith {};
    if (_zeroing > 1500) exitWith {};

    [FUNC(handleAirBurstAmmunitionPFH), 0, [_vehicle, _projectile, _zeroing]] call CBA_fnc_addPerFrameHandler;
};
