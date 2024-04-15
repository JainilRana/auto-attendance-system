import axios from 'axios';
import { collection, getDocs } from 'firebase/firestore';
import { db } from '../database/db_connection.js';

const getStudentDeviceToken=async (studentIds)=>{
     if(Array(studentIds).length==0 || typeof studentIds === typeof undefined) return [];
     try{
        const DeviceToken=await getDocs(collection(db,'student_id'));
        const studentDeviceToken=new Map();
        DeviceToken.forEach(doc => {
          console.log('get device id',doc.id);
          if(studentIds.includes(doc.id)){
            console.log("type of token: ",typeof doc.data()?.token, typeof doc.data()?.token!==typeof undefined);
               if(typeof doc.data()?.token!==typeof undefined){
                   studentDeviceToken.set(doc.id,doc.data().token);
                  }else{
                  studentDeviceToken.set(doc.id,undefined);
               }
               console.log("token : ",doc.data().token);
          }
        });
        return studentDeviceToken;
     }catch(e){
        console.log(`Error while fetch device ids: ${e}`);  
        return [];
     }
}

export {getStudentDeviceToken}