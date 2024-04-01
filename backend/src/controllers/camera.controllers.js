import { getBatchStudents } from "../common/getBatchStudents.method.js";
import { sendNotification } from "../common/sendNotification.method.js";
import { ApiResponse } from "../utils/ApiResponse.js";
import { asyncHandler } from "../utils/asyncHandler.js";

const onLabCamera = asyncHandler(async (req, res) => {
    const requestBody = req.body;
    const labNumber = req.query.lab_Number;
    const setStatus = req.query.setStatus;
    // for start camera.
    if (typeof labNumber == 'string' && setStatus == 'true') {
        res.json(
            new ApiResponse(200, requestBody, `camera Active ${setStatus} lab Number ${labNumber}`)
        );
    }
    // for stop camera and return json.
    if (typeof labNumber == 'string' && setStatus == 'false') {
        const detectedList = await getPresentID();
        const batchList = await getBatchStudents(requestBody);
        // const sendmessage=await sendNotification(detectedList);
        if (Number(batchList ?? 0) == 0) return res.json(new ApiResponse(200, [], "No student in  batch"))
        const batchDetectedList = getOnlyPresentList(detectedList, batchList);
        const response = sendNotification(batchDetectedList,req.body.Subject);
        if(!response) console.log(response);
        return res.json(new ApiResponse(200, [requestBody, batchList], "detected Student List"))
    }
    // Invaild Request.
    res.status(404).json(
        new ApiResponse(404, null, "Invaid request")
    )

})

const getPresentID = async () => {
    // get detected StudentList.
    return ['21CS054', '21CS028']
}
function getOnlyPresentList(detectedList, batchStudens) {
    const presentIds = new Array();
    batchStudens.forEach((obj) => {
        if (detectedList.includes(obj.id)) {
            obj.set(true);
            let id=getemailIds(obj.id);
            presentIds.push(id);
        }
    })
    return presentIds;
}
function getemailIds(str){
    const number=str.toString();
    let id=number.replace('CS','cs');
    id+="@charusat.edu.in";
    console.log("id",id);
    return id;
}
export {
    onLabCamera,
    getPresentID
}