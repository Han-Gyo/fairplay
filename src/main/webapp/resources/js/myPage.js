// 프로필 이미지 클릭 시 모달 열기
function showImageModal(src) {
    const modal = document.getElementById("imageModal");
    const modalImg = document.getElementById("modalImg");
    modalImg.src = src;
    modal.style.display = "block";
}

// 모달 클릭 시 닫기
function hideImageModal() {
    const modal = document.getElementById("imageModal");
    modal.style.display = "none";
}