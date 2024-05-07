import { labCameraRef } from "../app.js";
import { ApiResponse } from "../utils/ApiResponse.js";

// import axios from "axios";
const checkCameraStatus = async (req, res, next) => {
    const labNumber = req.query.lab_Number;
    const reqStatus = req.query.setStatus;
    console.log(labNumber);
    if (reqStatus == 'false') next();
    else {
        // api request for check that lab camera.
        try {
            let status, id;
            await labCameraRef.doc(labNumber).get().then((v) => {
                status = v.data().status;
                id = v.data().activeBy;
            })
            if (status == 'true') return res.json(new ApiResponse(200, { active: false, info: `This camera active by ${id}` }, 'Already Active camera'));
        } catch (error) {
            console.log('lab  error Data::::', error);
        }
        next()
    }
}

export { checkCameraStatus }