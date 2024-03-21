import { ApiResponse } from "../utils/ApiResponse.js";
import { asyncHandler } from "../utils/asyncHandler.js";

const onLabCamera = asyncHandler(async (req, res) => {
    const requestBody = req.body;
    const query = req.query.active;
    if(query==undefined){
        res.status(404).json(
            new ApiResponse(404,null,"Invaid request")
        )
    }
    if (query) {
        res.json(
            new ApiResponse(200, requestBody, `camera Active ${query}`)
        );
    }
})

const getPresentID = asyncHandler(async (req, res) => {

})
export {
    onLabCamera,
    getPresentID
}