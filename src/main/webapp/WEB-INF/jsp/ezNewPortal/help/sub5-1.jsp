<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${util.addVer('/css/ezNewPortal/webguide.css')}">
<title><spring:message code='main.t00037' /></title>
</head>
<body class="main_frame" id="top_main">
    <div class="btn_top"><a href="#" title="top">TOP</a></div>
    <!--breadcrumb -->
    <ul class="breadcrumb">
        <li><a href="javascript:history.go(-1)">< 뒤로</a></li>
        <li><a href="/ezNewPortal/help/sub1-1.do">&#8226; 맨앞으로 돌아가기</a></li>
        <li class="btn_print "><a href="javascript: window.print();">인쇄</a></li>
    </ul>
    <!--title -->
    <h3 class="contents_title">일정등록</h3>
	<h4 class="sub_title"></h4>

    <!--내용시작 -->
    <h2> 일정작성 </h2>
	<ol class="content">
		<li>일정관리 상단 <b>[일정작성]</b> 버튼을 클릭합니다. </li>
		<li>일정작성 창에서 일정작성 탭을 선택 후 일정대상을 선택합니다. </li>
		<li>위치, 제목을 입력 후 기간을 선택합니다. 기간은 하루종일 일정이면 하루종일에 체크 합니다.</li>
		<li>기간선택시 시작일, 종료일을 달력에서 선택합니다. </li>
		<li>일정작성을 마치면 <b>[저장]</b> 버튼을 클릭합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/schedule/write.png" alt="일정작성" title="일정작성" />
	
	<h2> 일정반복 </h2>
	<h3 class="sub_content">반복적으로 일정이 이루어지는경우, 일정반복을 설정할 수 있습니다. </h3>
	<ol class="content">
		<li>일정작성 창에서 일정반복 및 참석자 탭을 선택 후 <b>[반복설정]</b> 버튼을 클릭합니다.</li>
		<li>일정반복설정 팝업창에서 약속시간, 반복주기, 반복주기 설정범위를 설정 후 <b>[확인]</b> 버튼을 클릭합니다. </li>
		<li>반복일정을 해제하려면, 일정반복설정 팝업창에서 <b>[일정반복제거]</b> 버튼을 클릭합니다. </li>
	</ol>
	<h4 class="explan"> ※ 반복설정 항목 </h4>
	<ul class="explan_list">
		<li>약속시간: 약속의 시작시간과 종료시간 지정</li>
		<li>반복주기: 매일, 매주, 매월, 매년 또는 주단위로 요일마다 반복여부 지정</li>
		<li>반복주기 설정범위<br>&emsp; 시작: 반복 시작날짜 지정<br>&emsp; 종료일 지정 안함: 해당 일정 무한대 반복<br>&emsp; 다음횟수 반복 후 종료: 반복횟수 지정, 지정횟수 이후 해당일정 종료<br>&emsp; 끝날짜: 반복 끝날짜 지정 </li>
	</ul>
	<img src="../../images/ezNewPortal/help/schedule/repetition.png" alt="일정반복" title="일정반복" />
	
	<h2> 참석자 </h2>
	<h3 class="sub_content">해당일정에 참석자가 있는경우, 참석자를 설정할 수 있습니다. </h3>
	<ol class="content">
		<li>일정작성 창에서 일정반복 및 참석자 탭을 선택 후 <b>[참석자초대]</b> 버튼을 클릭합니다.</li>
		<li>참석자리스트 팝업창에서 참석자를 조직도에서 선택한 후 더블클릭 하거나 <b>[&#9654;]</b> 버튼을 클릭합니다.  </li>
		<li><b>[참석자일정조회]</b> 버튼을 클릭하여 참석자들이 해당 기간에 이미 등록된 일정이 있는지 참고할 수 있습니다. </li>
		<li>참석자 구성을 마치면 참석자리스트 팝업창에서 <b>[확인]</b> 버튼을 클릭합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/schedule/attendee.png" alt="참석자" title="참석자" />
	
	<h2> 자원설정 </h2>
	<h3 class="sub_content">일정등록시 회의실과 같은 공용자원도 함께 예약할 수 있습니다. </h3>
	<ol class="content">
		<li>일정작성 창에서 자원설정 탭을 선택 후 <b>[자원선택]</b> 버튼을 클릭합니다. </li>
		<li>자원선택 팝업창에서 해당 자원을 선택 후 더블클릭하거나 <b>[&#9654;]</b> 버튼을 클릭합니다. </li>
		<li>선택된 자원의 예약현황을 조회하려면 <b>[자원현황조회]</b> 버튼을 클릭합니다. </li>
		<li>자원선택을 마치면 <b>[선택]</b> 버튼을 클릭합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/schedule/resource.png" alt="자원설정" title="자원설정" />
	
	<h2> 자원반복 </h2>
	<h3 class="sub_content">자원예약시 자원의 반복예약도 할 수 있습니다. </h3>
	<ol class="content">
		<li>자원을 반복예약할 경우에는 <b>[자원반복설정]</b> 버튼을 클릭합니다. </li>
		<li>자원예약반복설정 팝업창에서 약속시간, 반복주기, 반복주기 설정범위를 설정 후 <b>[확인]</b> 버튼을 클릭합니다. </li>
		<li>예약반복을 해제하려면 자원예약반복설정 팝업창에서 <b>[예약반복제거]</b> 버튼을 클릭합니다. </li>
	</ol>
	<h4 class="explan"> ※ 반복설정 항목 </h4>
	<ul class="explan_list">
		<li>약속시간: 약속의 시작시간과 종료시간 지정</li>
		<li>반복주기: 매일, 매주, 매월, 매년 또는 주단위로 요일마다 반복여부 지정</li>
		<li>반복주기 설정범위<br>&emsp; 시작: 반복 시작날짜 지정<br>&emsp; 종료일 지정 안함: 해당 일정 무한대 반복<br>&emsp; 다음횟수 반복 후 종료: 반복횟수 지정, 지정횟수 이후 해당일정 종료<br>&emsp; 끝날짜: 반복 끝날짜 지정 </li>
	</ul>
	<img src="../../images/ezNewPortal/help/schedule/resource_repetition.png" alt="자원반복" title="자원반복" />
	
	<h2> 이름확인 </h2>
	<h3 class="sub_content">참석자 초대란에 참석할 사용자의 이름을 직접 입력한 경우 동명이인이 있는지 이름확인을 할 수 있습니다. </h3>
	<ol class="content">
		<li>일정작성 창에서 일정반복 및 참석자 탭을 선택합니다. </li>
		<li>참석자초대란에 참석자로 초대할 사용자의 이름을 입력후 상단 <b>[이름확인]</b> 버튼을 클릭합니다. </li>
		<li>동명이인이 있는경우 이름확인 팝업창에서 초대할 사용자를 선택 후 <b>[확인]</b> 버튼을 클릭합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/schedule/name_check.png" alt="이름확인" title="이름확인" />
	
	<h2> 인쇄 </h2>
	<h3 class="sub_content"> 작성한 일정의 내용을 인쇄합니다. </h3>
	<ol class="content">
	<li>일정작성 창에서 상단의 <b>[인쇄]</b> 버튼을 클릭합니다. </li>
	<li>인쇄가 가능한 프린터를 선택 후 <b>[인쇄]</b> 버튼을 클릭합니다.</li>
	</ol>
	<img src="../../images/ezNewPortal/help/schedule/print.png" alt="인쇄" title="인쇄" />
	
	<h2> 중요도 </h2>
	<h3 class="sub_content">작성중인 일정의 중요도를 선택할 수 있습니다.</h3>
	<ol class="content">
		<li>일정작성창 상단의 중요도에서 <b>“낮음, 보통, 높음”</b>중 선택합니다. 기본값은 <b>“보통”</b>으로 선택되어 있습니다.</li>
		<li>중요도를 낮음이나 높음으로 선택한 경우 일정목록에 낮음, 높음 아이콘이 표시됩니다.</li>
	</ol>
	<img src="../../images/ezNewPortal/help/schedule/importance_1.png" alt="일정작성창" title="일정작성창" /><br>
	<img src="../../images/ezNewPortal/help/schedule/importance_2.png" alt="일정목록" title="일정목록" />
	
	<h2> 공개여부 </h2>
	<h3 class="sub_content">작성중인 일정의 공개여부를 선택할 수 있습니다.</h3>
	<ol class="content">
		<li>일정작성 창의 상단에에서 공개, 비공개 중 선택합니다. 기본적으로 비공개로 되어 있습니다.</li>
		<li>공개로 선택한 경우(공개일정), 일정관리>공개일정검색에서 다른 사용자가 조회할 수 있습니다.<br>(개인일정은 비공개 상태가 기본설정이며 부서/회사일정은 공개 상태가 기본설정임)</li>
	</ol>
	<img src="../../images/ezNewPortal/help/schedule/public_setting.png" alt="일정작성창" title="일정작성창" />
	
	<h2> 위치 </h2>
	<h3 class="sub_content"> 일정이 진행되는 위치를 입력합니다. </h3>
	<img src="../../images/ezNewPortal/help/schedule/location.png" alt="위치" title="위치" />
	
	<h2> 제목 </h2>
	<h3 class="sub_content"> 일정의 제목을 입력합니다. </h3>
	
	<h2> 본문 </h2>
	<h3 class="sub_content"> 일정의 본문을 작성합니다. 편집기를 이용하여 본문 텍스트 편집, 이미지추가, 표삽입을 할 수 있습니다. <h3>
	<img src="../../images/ezNewPortal/help/schedule/content.png" alt="본문" title="본문" />
	
	<h2> 첨부 </h2>
	<h3 class="sub_content"> 일정에 관련된 파일이 있는 경우 추가하여 발송할 수 있습니다. </h3>
	<ol class="content">
		<li>일정작성 창에서 <b>[파일추가]</b> 버튼을 클릭합니다. </li>
		<li>파일선택화면에서 파일을 선택한 후 <b>[열기]</b> 버튼을 클릭하여 추가합니다. <br>(Ctrl, Shift키를 이용하여 복수개의 파일을 선택하여 추가할 수 있음) </li>
		<li>첨부파일을 Drag&Drop하여 첨부파일영역에 추가할 수 있습니다. </li>
		<li>삭제는 첨부 앞에 있는 박스에 체크 후 <b>[파일삭제]</b> 버튼을 클릭합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/schedule/attached_1.png" alt="첨부추가" title="첨부추가" /><br>
	<img src="../../images/ezNewPortal/help/schedule/attached_2.png" alt="첨부삭제" title="첨부삭제" />

    <!--내용끝 -->
</body>
</html>