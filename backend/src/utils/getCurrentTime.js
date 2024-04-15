
const getCurrentDate = () => {
    const today = new Date();
    const dd = String(today.getDate()).padStart(2, '0');
    const mm = String(today.getMonth() + 1).padStart(2, '0'); // Months start at 0!
    const yyyy = today.getFullYear();

    const formattedDate = `${dd}-${mm}-${yyyy}`;
    console.log(formattedDate);
    return formattedDate;
}
const getCurrentTime = () => {
    const today = new Date();
    let hours = today.getHours();
    let minutes = today.getMinutes();
    let seconds = today.getSeconds();

    // Format the time
    hours = hours < 10 ? "0" + hours : hours;
    minutes = minutes < 10 ? "0" + minutes : minutes;
    seconds = seconds < 10 ? "0" + seconds : seconds;

    // Display the time
    return `${hours}:${minutes}:${seconds}`;
}
export {
    getCurrentDate,
    getCurrentTime
}