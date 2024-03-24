import { Router } from "express";
import { notifyStudentController } from "../controllers/notifyStudent.controllers.js";

const route = Router()

route.route('/notifyStudent').put(notifyStudentController);


export default route