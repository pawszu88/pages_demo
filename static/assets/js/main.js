// Mobile menu toggle
document.addEventListener('DOMContentLoaded', function() {
    const toggle = document.getElementById('mobile-menu-toggle');
    const navList = document.getElementById('nav-list');

    if (toggle) {
        toggle.addEventListener('click', function() {
            navList.classList.toggle('active');
        });
    }
});
