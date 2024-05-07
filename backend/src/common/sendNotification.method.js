import { getStudentDeviceToken } from "./getDeviceIDs.method.js";
import { admin } from "../app.js"
import { storeMessage } from "./storeToFirebase.method.js";
import { getIdFromEmail } from "../controllers/camera.controllers.js";
const sendNotification=async(studentlist,subject,absentList)=>{
    console.log("list of present Student::",studentlist,absentList);
    let getDeviceToken= await getStudentDeviceToken(studentlist);
    let getDeviceTokenForab=await getStudentDeviceToken(absentList);
    if (getDeviceToken.size == 0) return false;
    const messages = [];
    const studentId=[];
    console.log("present Token::",getDeviceToken);
    console.log("absent::",getDeviceTokenForab);
    const mapStudentMessage=new Map();
    getDeviceToken.forEach((token,id)=>{
        console.log("token:", token);
        const message = {
            token: token,
            notification: {
                title: "Present",
                body: `${subject}`
            }
        }
        studentId.push(id);
        mapStudentMessage.set(id,message.notification);
        
        if(typeof undefined!==typeof token) messages.push(message);
    })
    getDeviceTokenForab.forEach((token,id)=>{
        const message={
            token: token,
            notification: {
                title: "Absent",
                body: `${subject}`
            }
        }
        mapStudentMessage.set(id,message.notification);
       if(typeof undefined!==typeof token) messages.push(message);
    })
    try {
        const result=await storeMessage(mapStudentMessage);
        console.log('result of store message',result,messages);
        const responses = await Promise.all(messages.map(message =>
            admin.messaging().send(message)
        ));
        console.log('Notifications sent successfully:', responses);
        return true;
    } catch (e) {
        console.log(`Error while sending message: ${e}`);
        return false;
    }
}

export {sendNotification};