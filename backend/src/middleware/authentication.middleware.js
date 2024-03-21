import { asyncHandler } from "../utils/asyncHandler.js";
import { getFacultyTokens } from "../models/getfaculty.method.js";
import { ApiError } from "../utils/ApiError.js";
const verifyTokenMiddleware = async (req, res, next) => {
    const { api_key } = req.headers;
    const { teacherId } = req.body;
    if (!teacherId) return res.status(404).json({ msg: "Please Enter email ID" })
    const facultyKey = await getFacultyTokens(teacherId);
    console.log("---->",facultyKey);
    if (facultyKey === "") return res.status(404).json({ msg: "missing key error" })
    console.log(api_key, facultyKey);
    if (!api_key || !(api_key === facultyKey)) {
        return res.status(401).json({ msg: "unauthorized Request" });
    }

    // You can add additional logic here to validate the token against your private key
    // For example, verify the token using a library like jsonwebtoken (JWT)
    // If the token is valid, proceed to the next middleware

    next();
}

export { verifyTokenMiddleware }