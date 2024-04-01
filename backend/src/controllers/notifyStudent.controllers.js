import { getStudentDeviceToken } from "../common/getDeviceIDs.method.js";
import { ApiResponse } from "../utils/ApiResponse.js";
import { asyncHandler } from "../utils/asyncHandler.js";
import { admin } from "../app.js"

const notifyStudentController = asyncHandler(async (req, res) => {
    // get device token form detect student list;
    const { list, subject } = req.body;
    
    if (Number(list ?? 0) == 0) return res.status(405).json(new ApiResponse(405, list, "Empty List"));
    //get Device token from database.
    let getDeviceToken = await getStudentDeviceToken(list);
    // getDeviceToken=new Map(getDeviceToken)
   
    if (getDeviceToken.size == 0) return res.status(405).json(new ApiResponse(405, req.body, "device Token not available"));

    //List of message
    const messages = [];

    getDeviceToken.forEach((token,id)=>{
        console.log("token:", token);
        const message = {
            token: token,
            notification: {
                title: `${subject} Attendance`,
                body: `${id} Attendance is taken`
            }
        }
        messages.push(message);
    })
    try {
        const responses = await Promise.all(messages.map(message =>
            admin.messaging().send(message)
        ));
        console.log('Notifications sent successfully:', responses);


        res.status(200).json(new ApiResponse(200, responses, "Notifications sent successfully"));
    } catch (e) {
        console.log(`Error while sending message: ${e}`);
        return res.status(500).json(new ApiResponse(500, [], "Error sending notifications"));
    }
    return res.json(new ApiResponse(200, [], "send Suceesfuly.."))
});

export { notifyStudentController }