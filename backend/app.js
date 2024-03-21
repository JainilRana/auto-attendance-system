import express from 'express';

const app=express();
app.use(express.json({limit:"30kb"}));


import cameraRoute from "./routes/cameraAccess.route.js"
import { verifyTokenMiddleware } from './middlewares/authentication.middleware.js';

app.use("/api/v1/labcamera",verifyTokenMiddleware,cameraRoute)

//http://localhost:8000/api/v1/labcamera/12
export {app}