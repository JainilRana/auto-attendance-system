import axios from 'axios';
import { collection, getDocs } from 'firebase/firestore';
import { db } from '../database/db_connection.js';

const getStudentDeviceToken=async (studentIds)=>{
     if(Array(studentIds).length==0) studentIds=['21cs051@charusat.edu.in'];
     try{
        const DeviceToken=await getDocs(collection(db,'student_id'));
        const studentDeviceToken=new Map();
        DeviceToken.forEach(doc => {
          console.log('get device id',doc.id);
          if(studentIds.includes(doc.id)){
               studentDeviceToken.set(doc.id,doc.data().token);
               console.log("token : ",doc.data().token);
          }
        });
        return studentDeviceToken;
     }catch(e){
        console.log(`Error while fetch device ids: ${e}`);  
        return "";
     }
}

export {getStudentDeviceToken}