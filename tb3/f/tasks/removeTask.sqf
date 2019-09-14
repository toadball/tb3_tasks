/*
Description: Function to delete a task created from TB3_Tasks in missionConifg
Author: Toadball

Parameters:
_taskClass = classname of task from missionConfig (STRING)
_owners = array of owners as in BIS_fnc_taskCreate (ARRAY, optional)

Return: ID of created task
*/

params ["_taskClass","_owners"];
//Was this created with tb3_tasks, if it wasn't: exit
//If it wasn't created with tb3 tasks there should not be a tb3 task array for it created in missionNamespace
private _taskArr = missionNamespace getVariable [format ["tb3_tasks_%1",_taskClass],nil];
if (isNil "_taskArr") exitWith {false};
private _monitorPfh = _taskArr # 1;

private _taskConfig = missionConfigFile >> "TB3_Tasks" >> _taskClass;
_task = (getArray (_taskConfig >> "taskID")) # 0;

if (isNil "_owners") then {
    _owners = getArray (_taskConfig >> "owners");
    _owners = _owners apply {call compile _x};
};
[
    _task,
    _owners
] call BIS_fnc_deleteTask;
//delete monitoring PFH on the server
[_monitorPfh] remoteExecCall ["CBA_fnc_removePerFrameHandler", 2];

true;
