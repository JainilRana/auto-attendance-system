import { getStudentDeviceToken } from "../common/getDeviceIDs.method.js";
import { ApiResponse } from "../utils/ApiResponse.js";
import { asyncHandler } from "../utils/asyncHandler.js";

const notifyStudentController = asyncHandler(async (req, res) => {
    // get device token form detect student list;
    const { list } = req.body;
    if (Number(list) == 0) return res.status(405).json(new ApiResponse(405, list, "Empty List"));
    //get Device token from database.
    const getDeviceToken = await getStudentDeviceToken(list);
    return res.json(new ApiResponse(200, [], "send Suceesfuly.."))
});

export { notifyStudentController }