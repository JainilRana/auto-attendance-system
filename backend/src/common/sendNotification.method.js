import { getStudentDeviceToken } from "./getDeviceIDs.method.js";
import { admin } from "../app.js"
const sendNotification=async(studentlist,subject)=>{
    let getDeviceToken= await getStudentDeviceToken(studentlist);
    if (getDeviceToken.size == 0) return false;
    const messages = [];

    getDeviceToken.forEach((token,id)=>{
        console.log("token:", token);
        const message = {
            token: token,
            notification: {
                title: `${subject} Attendance`,
                body: `${id} Attendance is taken`
            }
        }
        messages.push(message);
    })
    try {
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