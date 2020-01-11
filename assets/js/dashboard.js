/* ---------------------------------------------------
    APPOINTMENT DASHBOARD JS
----------------------------------------------------- */

// Fetch Dashboard data
document.addEventListener("DOMContentLoaded", () => {
    getAjaxDashboard();
    setInterval(getAjaxDashboard, 5000);
});

// Functions
function getAjaxDashboard() {
    var xhr = new XMLHttpRequest();
    var url = `../process/fetchDashboard.php`;
    xhr.open('GET', url);

    xhr.onload = function() {
        var response = JSON.parse(xhr.response);
        console.log('response', response);
        if (response.status === 200) {
            populateDashboardStat(response.data[0]);
            populateDashboardTable(response.data[1]);
        } else { // if response is 400 or 404
            // redirect to server error TO-DO*
            return null;
        }
    }
    xhr.send();
}

function populateDashboardStat(statsData) {
    
    var queueCountElem = document.querySelector('.queue-count');
    var servedCountElem = document.querySelector('.served-count');
    var cancelledCountElem = document.querySelector('.cancelled-count');
    
    // Populate the queueCount, ServedCount, cancelledCount 
    var queueCount = 0;
    var servedCount = 0;
    var cancelledCount = 0;
    for (var i = 0; i < statsData.length; i++) {
        var currentStat = statsData[i];
        if (currentStat['appointment_status'] === 'Pending') {
            queueCount = currentStat['today_count'];
        } else if (currentStat['appointment_status'] === 'Finished') {
            servedCount = currentStat['today_count'];
        } else if (currentStat['appointment_status'] === 'Cancelled') {
            cancelledCount = currentStat['today_count'];
        }
    }

    queueCountElem.innerText = queueCount;
    servedCountElem.innerText = servedCount;
    cancelledCountElem.innerText = cancelledCount;
}

function populateDashboardTable(appointmentData) {
    var tableBody = document.querySelector('.dashboard-table tbody');
    tableBody.innerHTML = "";
    for (var i = 0; i < appointmentData.length; i++) {
        var currentAppt = appointmentData[i];
        var tr = document.createElement('tr');
        if (currentAppt['course_abbreviations']) {
            tr.innerHTML += `<td>${sanitize(currentAppt['course_name'])} (${sanitize(currentAppt['course_abbreviations'])})</td>`;
        } else {
            tr.innerHTML += `<td>${sanitize(currentAppt['course_name'])}</td>`;
        }
        tr.innerHTML += `<td>${sanitize(currentAppt['today_count'])}</td>`
        if (currentAppt['course_id']) {
            tr.innerHTML += `<td><a href="./appointment.php?course_id=${currentAppt['course_id']}#pending-table">View</a></td`;
        } else {
            tr.innerHTML += `<td><a href="./appointment.php#pending-table">View</a></td`;
        }

        tableBody.appendChild(tr);
    }
}