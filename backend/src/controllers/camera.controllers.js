import { getBatchStudents } from "../common/getBatchStudents.method.js";
import { sendNotification } from "../common/sendNotification.method.js";
import { ApiResponse } from "../utils/ApiResponse.js";
import { asyncHandler } from "../utils/asyncHandler.js";

const onLabCamera = asyncHandler(async (req, res) => {
    const requestBody = req.body;
    const labNumber = req.query.lab_Number;
    const setStatus = req.query.setStatus;
    console.log(typeof setStatus, setStatus);
    // for start camera.
    if (typeof labNumber == 'string' && setStatus == 'true') {
        // call camrea api.
        res.json(
            new ApiResponse(200, requestBody, `camera Active ${setStatus} lab Number ${labNumber}`)
        );
    }
    // for stop camera and return json.
    else if (typeof labNumber == 'string' && setStatus == 'false') {
        const detectedList = await getPresentID();
        const batchList = await getBatchStudents(requestBody);
        // // const sendmessage=await sendNotification(detectedList);
        if (Number(batchList ?? 0) == 0) return res.json(new ApiResponse(200, [], "No student in  batch"))
        const { presentIds,__ } = getOnlyPresentList(detectedList, batchList);
        // console.log(presentIds, "--", absentList);
        const response = sendNotification(presentIds, req.body.Subject);
        if (!response) console.log(response);
        return res.json(new ApiResponse(200, [requestBody, batchList], "detected Student List"))
    }
    // Invaild Request.
    else {
        res.status(404).json(
            new ApiResponse(404, null, "Invaid request")
        )
    }

})

const getPresentID = async () => {
    // get detected StudentList.
    return ['21CS054', '21CS028']
}
function getOnlyPresentList(detectedList, batchStudens) {
    const presentIds = new Array();
    const absentList = new Array();
    batchStudens.forEach((obj) => {
        let id = getemailIds(obj.id);
        if (detectedList.includes(obj.id)) {
            obj.set(true);
            presentIds.push(id);
        } else {
            absentList.push(id);
        }
    })
    return { presentIds, absentList };
}
function getemailIds(str) {
    const number = str.toString();
    let id = number.replace('CS', 'cs');
    id += "@charusat.edu.in";
    console.log("id", id);
    return id;
}
function getIdFromEmail(str) {
    const number = str.toString();
    let id = number.replace('cs', 'CS').replace("@charusat.edu.in", "");
    return id;
}
export {
    onLabCamera,
    getPresentID,
    getemailIds,
    getIdFromEmail
}