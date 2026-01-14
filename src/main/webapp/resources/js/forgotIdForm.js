// forgotIdForm.js
document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("findIdForm");

    form.addEventListener("submit", function (e) {
        const emailInput = document.getElementById("email").value.trim();

        if (emailInput === "") {
            e.preventDefault();
            alert("이메일을 입력해주세요.");
        }
    });
});