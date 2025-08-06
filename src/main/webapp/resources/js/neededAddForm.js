document.addEventListener("DOMContentLoaded", function () {
    const form = document.querySelector("form");

    form.addEventListener("submit", function (e) {
        const itemName = document.getElementById("itemName").value.trim();
        const quantity = parseInt(document.getElementById("quantity").value);

        if (itemName === "") {
            alert("물품 이름을 입력해주세요.");
            e.preventDefault();
            return;
        }

        if (isNaN(quantity) || quantity < 1) {
            alert("수량은 1 이상이어야 합니다.");
            e.preventDefault();
        }
    });
});
