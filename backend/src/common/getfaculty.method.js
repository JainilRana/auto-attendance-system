import { FieldPath, collection, getDocs, query, where } from "firebase/firestore";
import { db } from "../database/db_connection.js"

const getFacultyTokens = async (faculty_id) => {
  try {
    const getFaculty = await getDocs(collection(db, "faculty_id"));
    getFaculty.forEach((doc) => {
      if (doc.id === faculty_id){
        console.log(faculty_id === doc.id, " ", faculty_id, " ", doc.id, "--", doc.data().uid);
        return doc.data().uid
      } 
    });
    return ""
  } catch (e) {
    return e;
  }
}
export { getFacultyTokens }