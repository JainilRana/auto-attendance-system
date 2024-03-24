import { ApiResponse } from "../utils/ApiResponse.js";
import { asyncHandler } from "../utils/asyncHandler.js";

const onLabCamera = asyncHandler(async (req, res) => {
    const requestBody = req.body;
    const labNumber=req.query.lab_Number;
    const setStatus=req.query.setStatus;
    console.log(labNumber,setStatus);

    if (labNumber && setStatus) {
        res.json(
            new ApiResponse(200, requestBody, `camera Active ${setStatus} lab Number ${labNumber}`)
        );
    }else{
        res.status(404).json(
            new ApiResponse(404,null,"Invaid request")
        )
    }
})

const getPresentID = asyncHandler(async (req, res) => {

})
export {
    onLabCamera,
    getPresentID
}