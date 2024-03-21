import { Router } from "express";
import { onLabCamera } from "../controllers/camera.controllers.js";

const route =Router();
route.route("/:labID").post(onLabCamera);
// route.route("/presentIds/:labID").get();

export default route