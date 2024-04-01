import { collection, doc, getDoc, getDocs } from "firebase/firestore";
import { db } from "../database/db_connection.js";

const getBatchStudents = async (requestBody) => {
  // Department , year , div , batch 
  const { Department, Year, Div, Batch } = requestBody;
  // check all field is correct or not.
  console.log(Department, `${Year}-batch`, Div, Batch);
  // get list of student for firebase.
  try {
    const studentList = await (await getDoc(doc(db, 'student_data', `${Department}`))).get(`${Year}`)
    // console.log('done call',studentList[Div][Batch]);
    // Assuming studentList[Div][Batch] is an object with key-value pairs
    const studentMap = new Map(Object.entries(studentList[Div][Batch]));
    // console.log(studentMap.entries());
    let studentsList=new Array();
      studentMap.forEach((key, value) => {
      studentsList.push(new student(key,value));
    })
    return studentsList;
  } catch (e) {
    console.log(`get student batch error ${e} `);
  }

  // convert to a well format in json.
  // return json.

}

class student {
  constructor(name, id,present=false) {
    this.name = name
    this.id = id
    this.present=present
  }
  set(present){
    this.present=present
  }
}


export { getBatchStudents };