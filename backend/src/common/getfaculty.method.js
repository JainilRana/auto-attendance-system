import { FieldPath, collection, getDocs, query, where } from "firebase/firestore";
import { db } from "../database/db_connection.js"

const getFacultyTokens = async (faculty_id) => {
  try {
    const getFaculty = await getDocs(collection(db, "faculty_id"));
    let token;
    getFaculty.forEach((doc) => {
      if (doc.id === faculty_id) {
        token = doc.data().uid;
        return;
      }
    });
    return token
  } catch (e) {
    return e;
  }
}
export { getFacultyTokens }