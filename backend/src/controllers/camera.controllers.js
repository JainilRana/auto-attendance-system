import axios from "axios";
import { labCameraRef } from "../app.js";
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
        await axios.get(`${process.env.CAMERA_START_URI}`).then((response)=>
             console.log(response)
        ).catch((e)=>console.log("error while start camera",e));
        await setCameraStatus(labNumber,setStatus,requestBody.teacherId);
        res.json(
            new ApiResponse(200, requestBody, `camera Active ${setStatus} lab Number ${labNumber}`)
        );
    }
    // for stop camera and return json.
    else if (typeof labNumber == 'string' && setStatus == 'false') {
        const detectedList = await getPresentID();
        const batchList = await getBatchStudents(requestBody);
        if (Number(batchList ?? 0) == 0) return res.json(new ApiResponse(200, [], "No student in  batch"))
        const { presentIds,__ } = getOnlyPresentList(detectedList, batchList);   
        const response = sendNotification(presentIds, req.body.Subject);
        await setCameraStatus(labNumber,setStatus,requestBody.teacherId);
        return res.json(new ApiResponse(200, [requestBody, batchList], "detected Student List"))
    }
    // Invaild Request.
    else {
        res.status(404).json(
            new ApiResponse(404, null, "Invaid request")
        )
    }

})
const setCameraStatus=async(lab_Number,setStatus,id)=>{
    if(setStatus=='false') id="";
   try {
    labCameraRef.doc(lab_Number).set({
        'status':setStatus,
        'activeBy':id
    })

   } catch (error) {
      console.log(`error while add camrea status : ${error}`);
   }
}
const getPresentID = async () => {
    // get detected StudentList.
    let listofStudent=[];
    await axios.get(`${process.env.GET_ATTENDANCE_URI}`).then((response)=>{
         console.log(response.data)
         listofStudent=response.data
        }
    ).catch((e)=>console.log("error while get present id:",e));
    return listofStudent;
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