/* ---------------------------------------------------
    SIDE BAR JS
----------------------------------------------------- */

var sidebarBtn = document.querySelector('#sidebarCollapse');
var sidebar = document.querySelector('#sidebar');

sidebarBtn.addEventListener('click', () => {
    sidebar.classList.toggle('active');
})

function sanitize(html){
    var doc = new DOMParser().parseFromString(html, 'text/html');
    return doc.body.textContent || "";
 }
