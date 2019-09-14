/*
    Function to create tasks from missionConfigFile on init if they are set to be created on init.
*/

private _tasks = (missionConfigFile >> "TB3_tasks") call BIS_fnc_getCfgSubClasses;
{
    if ((missionConfigFile >> "TB3_tasks" >> _x >> "CreateOnInit") call BIS_fnc_getCfgDataBool) then {
        [_x] call tb3_fnc_createTask;
    };
} forEach _tasks;
/*
addMissionEventHandler ["Ended", {
    if (!isServer) exitWith {false};
	params ["_endType"];
    private _tasks = (missionConfigFile >> "TB3_tasks") call BIS_fnc_getCfgSubClasses;
    {
        private _taskArgs = missionNamespace getVariable [format ["tb3_tasks_%1",_x],nil];
        if (!isNil _taskArgs) then {
            [_taskArgs # 1] remoteExecCall ["CBA_fnc_removePerFrameHandler", 2];
        }:
        systemChat str _x;
    } forEach _tasks;
}];*/
