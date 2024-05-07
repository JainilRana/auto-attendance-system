import express from 'express';
import admin from 'firebase-admin'


// Parse the JSON data into a JavaScript object

const serviceAccount =
{
  "type": process.env.type,
  "project_id": process.env.project_id,
  "private_key_id": process.env.private_key_id,
  "private_key": process.env.private_key,
  "client_email": process.env.client_email,
  "client_id": process.env.client_id,
  "auth_uri": process.env.auth_uri,
  "token_uri": process.env.token_uri,
  "auth_provider_x509_cert_url": process.env.auth_provider_x509_cert_url,
  "client_x509_cert_url": process.env.client_x509_cert_url,
  "universe_domain": process.env.universe_domain
}


// Now you can use `serviceAccount` as you would with `require()`


// Now you can use `serviceAccount` as you would with `require()`

const app = express();



admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: process.env.project_id
});
app.use(express.json({ limit: "30kb" }));
const dbRef=admin.firestore();
const messageRef=dbRef.collection('notifications');
const labCameraRef=dbRef.collection('labCamera');

import cameraRoute from "./routes/cameraAccess.route.js"
import notifyStudentRoute from "./routes/notifyStudent.route.js"
import { verifyTokenMiddleware } from './middlewares/authentication.middleware.js';
import { checkCameraStatus } from './middlewares/checkCameraStatus.middleware.js';

const BASE_URL = process.env.baseURL;

app.use(`${BASE_URL}/labcamera`, verifyTokenMiddleware, checkCameraStatus, cameraRoute)
app.use(`${BASE_URL}/classAttend`, verifyTokenMiddleware, notifyStudentRoute)
export { app, admin ,messageRef,labCameraRef}