class TB3_Tasks {
    class ExampleTask1 {
        CreateOnInit = 1;
        owners[] = {INDEPENDENT,group player};
        taskID[] = {"task1"};
        label[] = {"This is an example task","Example Task 1"};
        destination = "getMarkerPos 'task_marker1'";
        priority = 0;
        showNotification = 1;
        type = "default";
        visiblein3d = 0;
        monitor = 5; //interval to check conditions, if 0 no monitor PFH is created
        conditions[] = {
            (TaskFlag1 && (!TaskFlag2)), //Succeed
            (TaskFlag2 && (!TaskFlag1)) //Fail
        }; //boolean check that will trigger the success or failure of this task
    };
    class ExampleTask2: ExampleTask1 {
        CreateOnInit = 0;
        taskID[] = {"task2","task1"};
        label[] = {
            "Use something explosive, that usually helps",
            "Destroy the MRAP"
        };
        destination = "task_vehicle";
        conditions[] = {
            (!alive task_vehicle), //Succeed if the vehicle is destroyed
            (false) //no fail condition, this will never return true
        };
        visiblein3d = 1;
    };
};
