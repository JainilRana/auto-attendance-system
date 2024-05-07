import { asyncHandler } from "../utils/asyncHandler.js";
import { getFacultyTokens } from "../common/getfaculty.method.js";
import { ApiResponse } from "../utils/ApiResponse.js";

const verifyTokenMiddleware = async (req, res, next) => {
    const { api_key } = req.headers;
    const { teacherId } = req.body;
    const facultyKey = await getFacultyTokens(teacherId);
    if (!api_key || !(api_key === facultyKey)) {
        return res.status(401).json(new ApiResponse(401, req.body, "unauthorized Request"));
    }
    next();
}

export { verifyTokenMiddleware }