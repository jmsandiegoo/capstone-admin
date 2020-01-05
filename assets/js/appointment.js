/* ---------------------------------------------------
    APPOINTMENT TABLES JS
----------------------------------------------------- */

// Identify if it is general or not
var course_id = getUrlParameter('course_id');

// Fetch the pending List
document.addEventListener("DOMContentLoaded", () => {
    populatePendingTable(course_id);
    setInterval(function(){ populatePendingTable(course_id); } , 5000);
});

// Fetch Now Serving List
document.addEventListener("DOMContentLoaded", () => {
    populateNowServingTable();
    setInterval(populateNowServingTable, 5000);
});

// Functions
function getUrlParameter(name) {
    name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
    var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
    var results = regex.exec(location.search);
    return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
};

function populatePendingTable(course_id) {
    // TO-DO
    var response = getAjaxAppointments('Pending', course_id);
}

function populateNowServingTable() {
    // TO-DO
    var response = getAjaxAppointments('NowServing');
}

function getAjaxAppointments(type, course_id = null) {
    var xhr = new XMLHttpRequest();
    var url = `../process/fetchAppointments.php?type=${type}`;
    if (course_id) {
        url += `&course_id=${course_id}`;
    }
    xhr.open('GET', url);

    xhr.onload = function() {
        var response = JSON.parse(xhr.response);
        console.log('type', type);
        console.log('response', response);
        if (response.status === 200) {
            return response.data;
        } else { // if response is 400 or 404
            // redirect to server error TO-DO*
            return null;
        }
    }
    xhr.send();
}