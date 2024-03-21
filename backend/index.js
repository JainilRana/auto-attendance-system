import { app } from "./app.js";
import dotenv from "dotenv";
dotenv.config({
    path:'./.env'
})
app.on('error',(e)=>{
    console.log("Error:",e);
 })
app.listen(process.env.Port||8080,()=>{
    console.log(`Server Start at http://localhost:${process.env.Port}`)
    
})




