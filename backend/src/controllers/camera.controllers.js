import { getBatchStudents } from "../common/getBatchStudents.method.js";
import { ApiResponse } from "../utils/ApiResponse.js";
import { asyncHandler } from "../utils/asyncHandler.js";

const onLabCamera = asyncHandler(async (req, res) => {
    const requestBody = req.body;
    const labNumber = req.query.lab_Number;
    const setStatus = req.query.setStatus;
    // console.log(labNumber,setStatus,typeof labNumber,typeof labNumber=='string' && setStatus=='true', typeof labNumber=='string' && setStatus=='false');
    // for start camera.
    if (typeof labNumber == 'string' && setStatus == 'true') {
        res.json(
            new ApiResponse(200, requestBody, `camera Active ${setStatus} lab Number ${labNumber}`)
        );
    }
    // for stop camera and return json.
    if (typeof labNumber == 'string' && setStatus == 'false') {
        const detectedList=await getPresentID();
        const batchList = await getBatchStudents(requestBody);
        if(Number(batchList??0)==0) return res.json(new ApiResponse(200,[],"No student in  batch"))
        getOnlyPresentList(detectedList, batchList);
        return res.json(new ApiResponse(200, [requestBody,batchList], "detected Student List"))
    }
    // Invaild Request.
    res.status(404).json(
        new ApiResponse(404, null, "Invaid request")
    )

})

const getPresentID = async () => {
    // get detected StudentList.
    return ['21CS054', '21CS004', '21CS029', '21CS016']
}
function getOnlyPresentList(detectedList, batchStudens) {
    batchStudens.forEach((obj) => {
        if (detectedList.includes(obj.id)) {
            obj.set(true);
        }
    })
}
export {
    onLabCamera,
    getPresentID
}