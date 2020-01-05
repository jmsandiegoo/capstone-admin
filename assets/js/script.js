/* ---------------------------------------------------
    SIDE BAR JS
----------------------------------------------------- */

var sidebarBtn = document.querySelector('#sidebarCollapse');
var sidebar = document.querySelector('#sidebar');

sidebarBtn.addEventListener('click', () => {
    sidebar.classList.toggle('active');
})

