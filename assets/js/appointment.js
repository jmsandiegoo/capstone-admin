/* ---------------------------------------------------
    APPOINTMENT TABLES JS
----------------------------------------------------- */

// Identify if it is general or not
var course_id = getUrlParameter('course_id');

// Fetch the pending List
document.addEventListener("DOMContentLoaded", () => {
    getAjaxAppointments('Pending', course_id);
    setInterval(function(){ getAjaxAppointments('Pending', course_id); } , 5000);
    // setTimeout(function(){ getAjaxAppointments('Pending', course_id); } , 5000);
});

// Fetch Now Serving List
document.addEventListener("DOMContentLoaded", () => {
    getAjaxAppointments('NowServing');
    setInterval(function(){ getAjaxAppointments('NowServing', course_id); }, 5000);
    // setTimeout(function(){ getAjaxAppointments('NowServing', course_id); }, 5000);
});

// Functions
function getUrlParameter(name) {
    name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
    var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
    var results = regex.exec(location.search);
    return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
};

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
            if (type == "Pending") {
                populatePendingTable(response.data, course_id);
            } else {
                populateNowServingTable(response.data, course_id);
            }
        } else { // if response is 400 or 404
            // redirect to server error TO-DO*
            return null;
        }
    }
    xhr.send();
}

function populatePendingTable(response, course_id) {
    // TO-DO
    var tableBody = document.querySelector('.pending-table tbody');
    tableBody.innerHTML = "";

    for (var i = 0; i < response.length; i++) {
        var appointment = response[i];
        var tr = document.createElement('tr');
        tr.innerHTML = `<th scope="row"> ${appointment.appointment_id} </th>` + 
                        `<td>${appointment.appointment_name}</td>` +
                        `<td>${appointment.waiting_time}</td>` +
                        `<td><form action="../process/appointmentFunctions.php" method="POST">` +
                        `<input type="hidden" name="appointment_id" value="${appointment.appointment_id}" />` +
                        `<button type="submit" class="btn btn-dark" name="call-submit">Call</button>` +
                        `</form>` +
                        `<form action="../process/appointmentFunctions.php" method="POST">` +
                        `<input type="hidden" name="appointment_id" value="${appointment.appointment_id}" />` +
                        `<button type="submit" class="btn btn-light" name="skip-submit">Skip</button>` +
                        `</form></td>`;
        tableBody.appendChild(tr);
    }

    if (response.length == 0) {
        var tr = document.createElement('tr');
        tr.innerHTML = `<td colspan="100%" class="text-center">There are no pending appointments currently.</td>`;
        tableBody.appendChild(tr);
    }
}

function populateNowServingTable(response, course_id) {
    // TO-DO
    var tableBody = document.querySelector('.now-serving-table tbody');
    tableBody.innerHTML = "";

    for (var i = 0; i < response.length; i++) {
        var appointment = response[i];
        var tr = document.createElement('tr');
        tr.innerHTML = `<th scope="row"> ${appointment.appointment_id} </th>` + 
                        `<td>${appointment.appointment_name}</td>`;

        if (appointment.course_abbreviations) {
            tr.innerHTML += `<td>${appointment.course_abbreviations}</td>` ;
        } else {
            tr.innerHTML += `<td>General</td>` ;
        }
        tr.innerHTML += `<td>${appointment.last_called} seconds </br> (Called: ${appointment.appointment_calls} times)</td>`;

        var forms = `<td><form action="../process/appointmentFunctions.php" method="POST">` +
                    `<input id="appointment_id_input" type="hidden" name="appointment_id" value="${appointment.appointment_id}" />`;
                    
        if (course_id) {
            forms += `<input id="course_id_input" type="hidden" name="course_id" value="${course_id}" />`;
        }

        forms  +=   `<button type="submit" class="btn btn-dark" name="end-submit">End</button>` +
                    `</form>` +
                    `<form action="../process/appointmentFunctions.php" method="POST">` +
                    `<input id="appointment_id_input" type="hidden" name="appointment_id" value="${appointment.appointment_id}" />`;

        if (course_id) {
            forms += `<input id="course_id_input" type="hidden" name="course_id" value="${course_id}" />`;
        }

        forms  +=   `<button type="submit" class="btn btn-light" name="recall-submit">Re-Call</button>` +
                    `</form></td>`;

        tr.innerHTML += forms;
        tableBody.appendChild(tr);
    }

    if (response.length == 0) {
        var tr = document.createElement('tr');
        tr.innerHTML = `<td colspan="100%" class="text-center">There are no appointments being served currently.</td>`;
        tableBody.appendChild(tr);
    }
}