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
            height: '650',
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
							// 1. 모달 각 요소에 데이터 집어넣기
					    $("#detailTitle").text(event.title);
					    
					    // extendedProps에 들어있는 메모 가져오기 (없으면 기본값)
					    const memo = event.extendedProps.memo || "등록된 메모가 없습니다.";
					    $("#detailMemo").text(memo);
					    
					    // 날짜 예쁘게 포맷팅 (YYYY-MM-DD)
					    const dateStr = event.startStr;
					    $("#detailDate").text(dateStr);

					    // 2. 상세보기 모달 띄우기
					    $("#eventDetailModal").modal("show");
            }
        });
        calendar.render();
    } else {
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
                alert("일정이 등록되었습니다!");
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