/*
Description: Function to create a task from TB3_Tasks in missionConifg
Author: Toadball

Parameters:
_taskClass = classname of task from missionConfig (STRING)
_owners = array of owners as in BIS_fnc_taskCreate (ARRAY)

Return: ID of created task
*/

params ["_taskClass","_owners"];

if (!isClass (missionConfigFile >> "TB3_Tasks" >> _taskClass)) exitWith {false};
private _taskConfig = missionConfigFile >> "TB3_Tasks" >> _taskClass;

if (isNil "_owners") then {
    _owners = getArray (_taskConfig >> "owners");
    _owners = _owners apply {call compile _x};
};

private _taskID = getArray (_taskConfig >> "taskID");
private _label = getArray (_taskConfig >> "label");
private _destination = getText (_taskConfig >> "destination");
private _priority = getNumber (_taskConfig >> "priority");
private _showNotification = (_taskConfig >> "showNotification") call BIS_fnc_getCfgDataBool;
private _type = getText (_taskConfig >> "type");
private _visiblein3d = (_taskConfig >> "visiblein3d") call BIS_fnc_getCfgDataBool;

private _task = [
    _owners,
    _taskID,
    _label,
    call compile _destination,
    "CREATED",
    _priority,
    _showNotification,
    _type,
    _visiblein3d
] call BIS_fnc_taskCreate;

if (isServer) then {
    private _monitor = getNumber (_taskConfig >> "monitor");
    if (_monitor > 0) then {
        private _conditions = getArray (_taskConfig >> "conditions");
        _monitorPFH = [
            {
                params ["_pfhValues","_pfhId"];

                _pfhValues params ["_task","_conditions"];
                _conditions params ["_successCon","_failCon"];

                _success = call compile _successCon;
                _fail = call compile _failCon;
                if (_success && !_fail) then {

                    [_task,"SUCCEEDED"] remoteExecCall ["BIS_fnc_taskSetState", 0];
                    [_pfhId] call CBA_fnc_removePerFrameHandler;

                };
                if (_fail && !_success) then {

                    [_task,"FAILED"] remoteExecCall ["BIS_fnc_taskSetState", 0];
                    [_pfhId] call CBA_fnc_removePerFrameHandler;
                };
                //systemChat str [_task,_success,_fail];
            },
            _monitor,
            [_task,_conditions]
        ] call CBA_fnc_addPerFrameHandler;
        missionNamespace setVariable [format ["tb3_tasks_%1",_taskClass],[_task,_monitorPFH],true];
    };
};

missionNamespace getVariable format ["tb3_tasks_%1",_taskClass];
