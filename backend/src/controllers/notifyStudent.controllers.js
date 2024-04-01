import { getStudentDeviceToken } from "../common/getDeviceIDs.method.js";
import { ApiResponse } from "../utils/ApiResponse.js";
import { asyncHandler } from "../utils/asyncHandler.js";

import { sendNotification } from "../common/sendNotification.method.js";

const notifyStudentController = asyncHandler(async (req, res) => {
    // get device token form detect student list;
    const { list, subject } = req.body;
    
    if (Number(list ?? 0) == 0) return res.status(405).json(new ApiResponse(405, list, "Empty List"));
    const responseStatus=await sendNotification(list,subject);
    if(responseStatus) res.status(200).json(new ApiResponse(200, [], "Notifications sent successfully"));
    res.status(500).json(new ApiResponse(500, [], "Error sending notifications"));
    
});

export { notifyStudentController }