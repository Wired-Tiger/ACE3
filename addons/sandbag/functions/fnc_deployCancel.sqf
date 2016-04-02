/*
 * Author: Garth 'L-H' de Wet, Ruthberg, edited by commy2 for better MP and eventual AI support
 * Cancels sandbag deployment
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Key <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [ACE_player] call ace_sandbag_fnc_deployCancel
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_unit", "_key"];

if (_key != 1 || {GVAR(deployPFH) == -1}) exitWith {};

// enable running again
[_unit, "forceWalk", "ACE_Sandbag", false] call CFUNC(statusEffect_set);

// delete placement dummy
deleteVehicle GVAR(sandBag);

// remove deployment pfh
[GVAR(deployPFH)] call CBA_fnc_removePerFrameHandler;
GVAR(deployPFH) = -1;

// remove mouse button actions
call EFUNC(interaction,hideMouseHint);

[_unit, "DefaultAction", _unit getVariable [QGVAR(Deploy), -1]] call CFUNC(removeActionEventHandler);
[_unit, "zoomtemp",      _unit getVariable [QGVAR(Cancel), -1]] call CFUNC(removeActionEventHandler);

_unit setVariable [QGVAR(isDeploying), false, true];
