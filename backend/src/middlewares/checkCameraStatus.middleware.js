const checkCameraStatus = async(req,res,next)=>{
    const labNumber=req.query.lab_Number;
    console.log(labNumber);
    // api request for check that lab camera.
    
    next();
}

export {checkCameraStatus}