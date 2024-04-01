import { Router } from "express";
import { onLabCamera } from "../controllers/camera.controllers.js";

const route =Router();
route.route("/active").post(onLabCamera);


export default route