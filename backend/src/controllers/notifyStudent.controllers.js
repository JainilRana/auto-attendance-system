import { getStudentDeviceToken } from "../common/getDeviceIDs.method.js";
import { ApiResponse } from "../utils/ApiResponse.js";
import { asyncHandler } from "../utils/asyncHandler.js";

import { sendNotification } from "../common/sendNotification.method.js";
import { getemailIds } from "./camera.controllers.js";

const notifyStudentController = asyncHandler(async (req, res) => {
    // get device token form detect student list;
    const { updateList,absentList,subject } = req.body;
    const updateListIds=new Array();
    const absentListIds=new Array();
    updateList.forEach(number => {
        updateListIds.push(getemailIds(number));
    });
    absentList.forEach((number)=>{
        absentListIds.push(getemailIds(number));
    })
    const responseStatus=await sendNotification(updateListIds,subject,absentListIds);
    if(responseStatus) res.status(200).json(new ApiResponse(200, [updateList,absentList], "Notifications sent successfully"));
    else res.status(500).json(new ApiResponse(500, [], "Error sending notifications"));    
});

export { notifyStudentController }