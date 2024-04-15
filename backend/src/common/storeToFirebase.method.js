import { FieldValue, Timestamp, deleteField } from "firebase/firestore";
import { admin, messageRef } from "../app.js";
import { getCurrentDate, getCurrentTime } from "../utils/getCurrentTime.js";

async function storeMessage(listOfMessage) {
    const curDate = getCurrentDate();
    const timestamp = Timestamp.now();
    try {
        listOfMessage.forEach((message, value) => {
            const getRef = messageRef.doc(value).collection(curDate);
            console.log(message, "--->", value);
            getRef.add({ 'title': message.title, 'message': message.body, 'sortingTime': timestamp.toDate() });
        });    
        return true;
    } catch (e) {
        console.log('error while adding message', e);
        return false;
    }
}

export { storeMessage };