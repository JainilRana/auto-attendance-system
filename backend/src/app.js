import express from 'express';

const app = express();
app.use(express.json({ limit: "30kb" }));


import cameraRoute from "./routes/cameraAccess.route.js"
import notifyStudentRoute from "./routes/notifyStudent.route.js"
import { verifyTokenMiddleware } from './middlewares/authentication.middleware.js';
import { checkCameraStatus } from './middlewares/checkCameraStatus.middleware.js';
const BASE_URL = process.env.baseURL;

app.use(`${BASE_URL}/labcamera`, verifyTokenMiddleware, checkCameraStatus, cameraRoute)
app.use(`${BASE_URL}/classAttend`, verifyTokenMiddleware, notifyStudentRoute)
export { app }