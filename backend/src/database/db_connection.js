import { initializeApp} from "firebase/app";
import { Firestore, collection, getFirestore } from "firebase/firestore";
import { getCurrentDate } from "../utils/getCurrentTime.js";
import { admin } from "../app.js";

const firebaseConfig = {
    apiKey: process.env.apiKey,
    authDomain: process.env.authDomain,
    projectId: process.env.projectId,
    storageBucket: process.env.storageBucket,
    messagingSenderId: process.env.messagingSenderId,
    appId: process.env.appId
};

const app=initializeApp(firebaseConfig);
const db=getFirestore(app);
export {
    db,
};