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
    <h3 class="contents_title"> 결재 </h3>
	<h4 class="sub_title"> 기안자가 기안한 문서는 다음 결재자의 결재할문서에 도착합니다. <br> 도착된 문서는 결재자가 승인, 반송, 보류 중 선택하여 결재처리를 할 수 있습니다. </h4>

    <!--내용시작 -->
    <h2> 결재 </h2>
	<ol class="content">
		<li>좌측 결재할문서 매뉴를 선택합니다. </li>
		<li>우측 결재할문서목록에서 결재할 문서를 선택 후 상단 <b>[결재]</b> 버튼을 클릭합니다. </li>
		<li>기안자가 긴급결재로 설정한 결재문서는 목록에 빨간색으로 표시됩니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/approval/approval_1.png" alt="결재" title="결재" />
	
	<h2> 결재정보 변경 </h2>
	<h3 class="sub_content"> 기안자가 지정한 결재선을 필요에 따라 결재자가 변경할 수 있습니다. </h3>
	<ol class="content">
		<li>결재 창에서 상단 <b>[결재정보]</b> 버튼을 클릭합니다. </li>
		<li>결재정보 창에서 <b>/결재선/</b>, <b>/수신처/</b>, <b>/분류코드/</b>, <b>/정보/</b> 중 변경할 탭을 선택 후 정보를 변경하고, <b>[확인]</b> 버튼을 클릭합니다. </li>
		<li>결재선변경시 이미 결재를 마친 사용자는 삭제할 수 없으며 결재진행자의 다음 결재자로만 추가하거나 삭제할 수 있습니다. </li>
	</ol>
	<h4 class="explan"> ※ 결재유형이 “결재”, “확인”인 결재자만 결재정보탭이 보여집니다. 또한 최종결재자는 결재선를 수정할 수 없습니다. </h4>
	<img src="../../images/ezNewPortal/help/approval/modify_information.png" alt="결재정보 변경" title="결재정보 변경" />
	
	<h2> 편집모드 </h2>
	<h3 class="sub_content"> 기안자가 작성한 결재문서의 내용을 결재자가 변경할 수 있습니다. 변경사항에 대해서는 변경내역확인이 가능합니다. </h3>
	<ol class="content">
		<li>결재 창에서 상단 <b>[편집모드]</b> 버튼을 클릭합니다. </li>
		<li>제목/본문에 대해 편집을 마치면 상단 <b>[보기모드]</b> 버튼을 클릭합니다. </li>
		<li>편집내용 적용 확인메세지가 표시되면 <b>[확인]</b> 버튼을 클릭합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/approval/edit_mode.png" alt="편집모드" title="편집모드" />
	
	<h2> 변경내역 </h2>
	<h3 class="sub_content"> 문서가 결재과정에서 변경되는 경우 해당 이력이 저장되며 확인할 수 있습니다. </h3>
	<ol class="content">
		<li>결재 창에서 상단 <b>[변경내역]</b> 버튼을 클릭합니다. </li>
		<li><b>/결재선이력/</b>, <b>/첨부파일이력/</b>, <b>/결재문서이력/</b>이 탭으로 표시되며 각 탭 클릭시 변경이력을 확인할 수 있습니다. </li>
		<li><b>/결재문서이력/</b> 탭에서 변경정보 목록을 더블클릭하면 해당 버전의 결재문서 내용을 확인할 수 있습니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/approval/doc_history.png" alt="변경내역" title="변경내역" />
	
	<h2> 통합PC저장 </h2>
	<h3 class="sub_content"> 결재문서를 열람 시 문서와 첨부파일을 압축하여 PC로 저장할 수 있습니다. </h3>
	<ol class="content">
		<li>결재 창에서 상단 <b>[통합PC저장]</b> 버튼을 클릭합니다. </li>
		<li>문서, 첨부를 확인 후 저장할 파일을 선택합니다. </li>
		<li>선택을 마치면 <b>[저장]</b> 버튼을 클릭합니다. </li>
		<li>PC에 저장할 경로를 선택 후 <b>[저장]</b> 버튼을 클릭합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/approval/pc_save.png" alt="통합pc저장" title="통합pc저장" />
	
	<h2> 인쇄 </h2>
	<h3 class="sub_content"> 결재할 문서를 인쇄할 수 있습니다. </h3>
	<ol class="content">
		<li>결재 창에서 <b>[인쇄]</b> 버튼을 클릭합니다. </li>
		<li>인쇄항목 선택 창에서 의견정보, 첨부정보, 결재선정보중 문서하단에 함께 인쇄할 항목을 선택합니다. <br>선택을 마치면 <b>[선택인쇄]</b> 버튼을 클릭합니다.</li>
		<li>모두 인쇄할 경우 <b>[모두인쇄]</b> 버튼을 클릭합니다. </li>
		<li>문서만 인쇄할 경우 <b>[문서만인쇄]</b> 버튼을 클릭합니다.</li>
		<li>인쇄미리보기 화면을 확인하고 프린터를 선택 후 인쇄합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/approval/approval_print.png" alt="인쇄" title="인쇄" />
	
	<h2> 결재 </h2>
	<h3 class="sub_content"> 결재할문서를 결재처리 합니다. 중간결재자가 결재를 하면 다음결재자에게 전달되며 최종결재자가 결재를 완료하면 결재문서함으로 저장됩니다. </h3>
	<ol class="content">
		<li>결재 창에서 <b>[결재]</b> 버튼을 클릭합니다. </li>
	</ol>
	<h4 class="explan"> ※ 서명불러오기로 선택시 </h4>
	<ul class="explan_list">
		<li>서명선택 창에서 싸인을 선택합니다. </li>
		<li>싸인을 선택 후 <b>[확인]</b> 버튼을 클릭합니다. </li>
		<li>문서의 결재칸 중 기안자 서명란에 싸인이미지가 표시됩니다. </li>
	</ul>
	<h4 class="explan"> ※ 문자서명하기로 선택시 </h4>
	<ul class="explan_list">
		<li>서명선택 창 하단에 <b>[문자서명]</b> 버튼을 클릭합니다. </li>
		<li>기안문서 사용자 서명란에 문자서명(사용자명) 이 표시됩니다. </li>
	</ul>
	<img src="../../images/ezNewPortal/help/approval/approval_2.png" alt="결재" title="결재" />
	
	<h2> 반송 </h2>
	<h3 class="sub_content"> 결재할문서를 반송처리 합니다. 반송시 기안자의 결재할문서목록에 도착되며 기안자는 재기안하거나 삭제할 수 있습니다. </h3>
	<ol class="content">
		<li>결재 창에서 <b>[반송]</b> 버튼을 클릭합니다. </li>
		<li>“반송하시겠습니까” 메시지창에서 <b>[확인]</b> 버튼을 클릭합니다. </li>
		<li>의견 창에서 의견을 입력후 <b>[저장]</b> 버튼을 클릭합니다. </li>
		<li>의견 창에서 닫기 버튼 클릭시 “결재문서를 <b>[반송]</b> 하였습니다” 메시지창이 나타나며 <b>[확인]</b> 버튼 클릭시 반송 처리 됩니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/approval/rejection.png" alt="반송" title="반송" />
	
	<h2> 보류 </h2>
	<h3 class="sub_content"> 결재할문서를 보류처리 합니다. 보류한문서는 다시 결재 또는 반송 처리할 수 있습니다. </h3>
	<ol class="content">
		<li>결재 창에서 <b>[보류]</b> 버튼을 클릭합니다. </li>
		<li>의견 창에서 의견을 입력후 <b>[저장]</b> 버튼을 클릭합니다. </li>
		<li>의견 창에서 닫기 버튼 클릭시 “결재문서를 <b>[보류]</b> 하였습니다” 메시지창이 나타나며 <b>[확인]</b> 버튼 클릭시 보류 처리 됩니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/approval/hold.png" alt="보류" title="보류" />

    <!--내용끝 -->
</body>
</html>