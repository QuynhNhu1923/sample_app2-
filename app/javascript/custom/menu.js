// Menu manipulation
// Add toggle listeners to listen for clicks.
document.addEventListener("turbo:load", function() {
  let account = document.querySelector("#account");
  account.addEventListener("click", function(event) {
    event.preventDefault(); // Ngăn chặn hành vi mặc định của liên kết
    let menu = document.querySelector("#dropdown-menu");
    menu.classList.toggle("active"); // Chuyển đổi lớp 'active'
  });
});
