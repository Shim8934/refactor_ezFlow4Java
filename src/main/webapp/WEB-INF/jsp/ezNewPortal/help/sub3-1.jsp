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
    <h3 class="contents_title">기안하기</h3>
	<h4 class="sub_title"></h4>

    <!--내용시작 -->
    <h2> 양식선택 </h2>
	<ol class="content">
		<li>좌측 결재할문서 매뉴를 선택 후 우측 상단 <b>[기안]</b> 버튼을 클릭합니다. </li>
		<li>양식선택 창에서 양식리스트 탭을 선택 후 기안할 양식을 선택합니다. </li>
		<li>자주 사용하는 양식인 경우 양식리스트에서 양식선택 후 상단 <b>[즐겨찾기등록]</b> 버튼을 클릭합니다. </li>
		<li>즐겨찾기탭을 선택하면 즐겨찾기로 등록된 양식리스트가 나타납니다. </li>
		<li>양식선택을 마치면 <b>[확인]</b> 버튼을 클릭합니다. </li>
	</ol>
	<h4 class="explan"> ※ 양식 종류 </h4>
	<ul class="explan_list">
		<li>기안문: 내부적으로 보고형태를 취하고자 할 경우 사용 </li>
		<li>수신문: 기안부서와 수신부서의 결재칸을 동시에 가지고 있는 형태로 기안부서 결재가 완료되면 수신부서로 발송됨 </li>
		<li>시행문: 결재완료된 기안문을 내부 시행이나 외부기관으로 발송 시 변환하는 양식 </li>
	</ul>
	<img src="../../images/ezNewPortal/help/approval/select_form.png" alt="양식선택" title="양식선택" />
	
	<h2> 결재정보 </h2>
	<h3 class="sub_content"> 결재정보는 결재선, 수신처, 분류코드, 문서옵션, 회람으로 구분하여 지정할 수 있습니다. <br> 기안작성 창에서 상단 <b>[결재정보]</b> 버튼을 클릭합니다. </h3>
	
	<h2> 결재선 지정 </h2>
	<h3 class="sub_content"> 기안문 작성시 결재선을 지정하면, 순서대로 결재가 진행됩니다. </h3>
	<ol class="content">
		<li>결재정보 창에서 <b>/결재선/</b> 탭을 선택 후 <b>/조직도/</b> 탭을 클릭합니다. </li>
		<li>조직도에서 결재자로 지정할 사용자가 속한 부서를 선택하면 하단에 부서원리스트가 표시됩니다. </li>
		<li>결재자로 지정할 사용자를 부서원리스트에서 더블클릭하여 우측 결재선리스트에 추가합니다. </li>
		<li>결재선리스트에 추가된 사용자를 선택하여 결재유형을 지정합니다. </li>
		<li>결재유형은 결재, 확인, 전결, 참조, 개인순차합의, 개인병렬합의 중 선택할 수 있습니다. </li>
		<li>결재유형 지정시 전결을 선택하면 이후 결재자의 결재유형은 결재안함으로 자동으로 변경됩니다. </li>
		<li>결재선리스트에 추가된 사용자의 결재순서를 변경시에는 사용자 선택 후 상단 <b>[↑]</b>, <b>[↓]</b> 버튼으로 순서변경합니다. <br> (기안자는 순서변경할 수 없음)</li>
		<li>추가된 사용자를 결재선리스트에서 삭제 시에는 사용자를 더블클릭합니다. </li>
		<li>자주 사용하는 결재선리스트인경우 <b>[결재선 즐겨찾기 저장]</b> 버튼을 클릭하여, 현재 결재선을 저장합니다. </li>
		<li>저장된 결재선은 <b>/즐겨찾기/</b> 탭을 클릭하여, 즐겨찾기리스트에서 선택합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/approval/route.png" alt="결재선" title="결재선" />
	
	<h2> 수신처 지정 </h2>
	<h3 class="sub_content"> 수신처를 지정하는 양식인 경우 수신처를 지정하여 발송합니다. <br> 양식유형이 수신문으로 등록되어 있는 경우에만 결재선정보 창에 수신처 탭이 나타납니다. </h3>
	<ol class="content">
		<li>결재정보 창에서 <b>/수신처/</b> 탭을 선택 후 <b>/조직도/</b> 탭을 클릭합니다. </li>
		<li>조직도에서 수신부서를 선택 후 <b>[부서추가]</b> 버튼을 클릭합니다. </li>
		<li>개인을 수신자로 지정하려면 부서원리스트에서 사용자를 선택 후 더블클릭 합니다. </li>
		<li>추가된 수신처를 삭제하려면 부서 또는 사용자를 더블클릭합니다. </li>
		<li>자주 사용하는 수신처리스트인경우 <b>[수신처 즐겨찾기 저장]</b> 버튼을 클릭하여, 결재선을 저장합니다. </li>
		<li>저장된 수신처는 <b>/즐겨찾기/</b> 탭을 클릭하여 즐겨찾기리스트에서 수신처를 선택합니다. </li>
		<li><b>/수신처그룹/</b> 탭을 선택하면, 관리자가 등록해 놓은 공용수신처그룹을 확인하고 선택할 수 있습니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/approval/trustee.png" alt="수신처" title="수신처" />
	
	<h2> 분류코드 </h2>
	<h3 class="sub_content"> 기안문서가 완료되고 분류될 정보를 선택합니다. <br> 보존기간, 보안등급, 공개여부가 자동으로 지정되며, 결재완료 후 분류코드별로 조회할 수 있습니다. <br> 문서분류는 시스템관리자가 관리자기능에서 등록합니다. </h3>
	<ol class="content">
		<li>결재정보 창에서 <b>/분류코드/</b> 탭을 클릭합니다. </li>
		<li>문서분류에서 해당 분류를 선택 후 코드리스트에서 코드를 선택합니다. </li>
		<li>자주 사용하는 코드인 경우, 코드리스트에서 코드 선택 후 <b>[즐겨찾기 등록]</b> 버튼을 클릭하여, 즐겨찾기에 추가합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/approval/code.png" alt="분류코드" title="분류코드" />
	
	<h2> 문서옵션 </h2>
	<h3 class="sub_content"> 기안문서의 옵션설정과 요약전을 입력할 수 있습니다. </h3>
	<ol class="content">
		<li>결재정보 창에서 <b>/문서옵션/</b> 탭을 클릭합니다. </li>
		<li>분류코드에서 선택한 코드명이 기능명칭에 표시됩니다.  보안등급, 보존기간, 공개여부가 선택한 분류코드의 내용대로 설정이 되어 있는지 확인합니다. </li>
		<li>분류코드를 변경할경우 기능명칭의 <b>[분류코드선택]</b> 버튼을 클릭하여, 재설정할 수 있습니다. </li>
		<li>보안등급, 보존기간, 공개여부에 대하여 해당 기안문서 내용에 맞게 선택하여 지정합니다. </li>
		<li>해당 기안문이 긴급결재인경우 긴급결재에 체크 합니다. </li>
		<li>검색에 할용할 수 있는 키워드는 키워드란에 입력합니다. </li>
		<li>해당 기안문에 대하여 요약내용이 있는 경우 요약전 란에 내용을 입력합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/approval/option.png" alt="문서옵션" title="문서옵션" />
	
	<h2> 회람 </h2>
	<h3 class="sub_content"> 회람처를 지정하는 양식인 경우 회람처를 지정하여 발송합니다. </h3>
	<ol class="content">
		<li>결재정보 창에서 <b>/회람/</b> 탭을 선택 후 <b>/조직도/</b> 탭을 클릭합니다. </li>
		<li>조직도에서 회람부서를 선택 후 <b>[부서추가]</b> 버튼을 클릭합니다. </li>
		<li>개인을 수신자로 지정하려면 부서원리스트에서 사용자를 선택 후 더블클릭 합니다. </li>
		<li>추가된 회람처를 삭제하려면 부서 또는 사용자를 더블클릭합니다. </li>
		<li>자주 사용하는 수신처리스트인경우 <b>[회람 즐겨찾기 저장]</b> 버튼을 클릭하여, 결재선을 저장합니다.</li>
		<li>저장된 수신처는 <b>/즐겨찾기/</b> 탭을 클릭하여 즐겨찾기리스트에서 수신처를 선택합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/approval/circulated.png" alt="회람" title="회람" />
	
	<h2> 제목 </h2>
	<h3 class="sub_content"> 기안문서의 제목을 입력합니다. </h3>
	
	<h2> 본문 </h2>
	<h3 class="sub_content"> 기안문서의 본문을 작성합니다. 편집기를 이용하여 본문 텍스트 편집, 이미지 추가, 표삽입을 할 수 있습니다. </h3>
	<img src="../../images/ezNewPortal/help/approval/content.png" alt="본문" title="본문" />
	
	<h2> 의견 </h2>
	<h3 class="sub_content"> 결재자들에게 기안의도를 명확하게 전달하기 위해 의견을 작성할 수 있습니다. </h3>
	<ol class="content">
		<li>기안작성 창에서 상단의 <b>[의견]</b> 버튼을 클릭합니다. </li>
		<li>의견 창에서 의견을 입력하고 <b>[저장]</b> 버튼을 클릭합니다. </li>
		<li>작성한 의견의 수정은 <b>[수정]</b> 버튼을 클릭합니다. </li>
		<li>작성한 의견의 삭제는 <b>[삭제]</b> 버튼을 클릭합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/approval/opinion.png" alt="의견" title="의견" />
	
	<h2> 첨부 </h2>
	<h3 class="sub_content"> 기안문서에 관련된 첨부가 있는경우 파일을 추가할 수 있습니다. </h3>
	<ol class="content">
		<li>기안작성 창에서 <b>[첨부]</b> 버튼을 클릭합니다. </li>
		<li>파일첨부 창에서 <b>[추가]</b> 버튼을 클릭합니다. </li>
		<li>파일선택화면에서 파일을 선택한 후 <b>[열기]</b> 버튼을 클릭하여 추가합니다. <br>(Ctrl, Shift키를 이용하여 복수개의 파일을 선택하여 추가할 수 있음)</li>
		<li>첨부파일을 Drag&Drop하여 첨부파일영역에 추가할 수 있습니다.</li>
		<li>삭제는 첨부앞에 있는 박스에 체크후 <b>[파일삭제]</b> 버튼을 클릭합니다.</li>
		<li>파일첨부를 마치면 <b>[확인]</b> 버튼을 클릭합니다. 기안작성창 하단 첨부란에 첨부 제목이 표시됩니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/approval/attach.png" alt="첨부" title="첨부" />
	
	<h2> 문서첨부 </h2>
	<h3 class="sub_content"> 기안문서에 결재문서함에 저장되어 있는 완료된 문서를 추가할 수 있습니다. </h3>
	<ol class="content">
		<li>기안작성 창에서 <b>[문서첨부]</b> 버튼을 클릭합니다. </li>
		<li>결재문서첨부화면 창에서 문서함명에서 문서함을 선택합니다. </li>
		<li>문서리스트에서 추가할 문서를 선택후 더블클릭하거나 <b>[&gt;]</b> 버튼을 클릭하여 추가합니다. </li>
		<li>추가된 문서의 삭제는 우측 문서명리스트에서 문서를 더블클릭하거나 <b>[&lt;]</b> 버튼을 클릭합니다. </li>
		<li>결재문서첨부 추가를 마치면 <b>[확인]</b> 버튼을 클릭합니다. 기안작성창 하단 첨부란에 결재문서 제목이 표시됩니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/approval/doc_attach.png" alt="문서첨부" title="문서첨부" />
	
	<h2> 임시저장 </h2>
	<h3 class="sub_content"> 작성중 인 문서를 보관하였다 향후에 다시 기안할 경우 임시보관함에 저장할 수 있습니다. <br> 단, 임시보관함에 들어간 문서를 읽어와 기안을 올린 경우 임시보관함에서 삭제됩니다. </h3>
	<ol class="content">
		<li>기안작성 창에서 <b>[임시저장]</b> 버튼을 클릭합니다. </li>
		<li>임시저장한 문서는 전자결재>임시보관함 에서 저장한 문서를 더블클릭하여 다시 작성할 수 있습니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/approval/save.png" alt="임시저장" title="임시저장" />
	
	<h2> 인쇄 </h2>
	<h3 class="sub_content"> 기안작성 중인 문서를 인쇄할 수 있습니다. </h3>
	<ol class="content">
		<li>기안작성 창에서 <b>[인쇄]</b> 버튼을 클릭합니다. </li>
		<li>인쇄항목 선택 창에서 의견정보, 첨부정보, 결재선정보중 문서하단에 함께 인쇄할 항목을 선택합니다. 선택을 마치면 <b>[선택인쇄]</b> 버튼을 클릭합니다. </li>
		<li>모두 인쇄할 경우 <b>[모두인쇄]</b> 버튼을 클릭합니다. </li>
		<li>문서만 인쇄할 경우 <b>[문서만인쇄]</b> 버튼을 클릭합니다. </li>
		<li>인쇄미리보기 화면을 확인하고 프린터를 선택 후 인쇄합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/approval/print.png" alt="인쇄" title="인쇄" />
	
	<h2> 결재올림 </h2>
	<h3 class="sub_content"> 기안작성을 마치면 상위 결재자에게 결재를 올립니다. 결재올림 시 결재서명은 등록된 서명, 직접서명, 문자서명 중 선택할 수 있습니다. </h3>
	<ol class="content">
		<li>기안작성 창에서 <b>[결재올림]</b> 버튼을 클릭합니다. </li>
		<li>기안 승인을 마치면 “문서를 <b>[기안]</b> 하였습니다” 확인 메시지 창이 나타납니다. </li>
		<li>해당 창에서 <b>[확인]</b> 버튼 클릭시 기안이 종료되며 다음 결재자에게 문서가 전달됩니다. </li>
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
	<img src="../../images/ezNewPortal/help/approval/submit.png" alt="결재올림" title="결재올림" />

    <!--내용끝 -->
</body>
</html>