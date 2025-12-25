/**
 * FairPlay 프로젝트 전용 캘린더 로직
 */
let calendar; 

// 1. 달력 모달 열기
function openCalendarModal() {
    const modalDiv = document.getElementById('calendarModal');
    modalDiv.style.display = 'block';

    const calendarEl = document.getElementById('calendar-full');
    
    // 달력이 아직 생성되지 않았다면 초기화
    if (!calendar) {
        calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
            locale: 'ko',
            height: '100%',
            headerToolbar: {
                left: 'prev,next',
                center: 'title',
                right: 'today'
            },
            
            events: contextPath + '/schedule/events', 
            
            // 날짜 클릭 시 (일정 등록)
            dateClick: function(info) {
                // 부트스트랩 모달의 날짜 input에 클릭한 날짜 세팅
                $("#selectedDate").val(info.dateStr); 
                $("#scheduleModal").modal("show");
            },
            
            // 일정 클릭 시 (상세보기)
            eventClick: function(info) {
                const event = info.event;
                const memo = event.extendedProps.memo || "메모가 없습니다.";
                alert(`📌 일정: ${event.title}\n📝 메모: ${memo}`);
            }
        });
        calendar.render();
    } else {
        // 이미 생성된 상태라면 다시 그리면서 데이터를 새로고침함
        calendar.updateSize();
        calendar.refetchEvents();
    }
}

// 2. 달력 모달 닫기
function closeModal() {
    document.getElementById('calendarModal').style.display = 'none';
}

// 3. 일정 등록 AJAX (JQuery 사용)
$(document).ready(function() {
    $("#scheduleForm").on("submit", function(e) {
        e.preventDefault(); // 폼 기본 제출 막기
        
        // 서버로 보낼 데이터 구성
        const scheduleData = {
            title: $("input[name='title']").val(),
            memo: $("textarea[name='memo']").val(),
            scheduleDate: $("#selectedDate").val(),
            visibility: $("select[name='visibility']").val()
        };

        $.ajax({
            url: contextPath + "/schedule/create",
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify(scheduleData),
            success: function(res) {
                alert("일정이 등록되었습니다! 🚀");
                $("#scheduleModal").modal("hide");
                $("#scheduleForm")[0].reset(); // 폼 초기화
                
                if(calendar) {
                    calendar.refetchEvents(); // 달력 데이터 갱신
                }
            },
            error: function(err) {
                console.error(err);
                alert("일정 등록에 실패했습니다. 다시 시도해주세요.");
            }
        });
    });
});