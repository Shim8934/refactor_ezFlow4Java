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
    <h3 class="contents_title">메일환경설정</h3>
	<h4 class="sub_title"> 포탈, 유틸메뉴에서 환경설정 아이콘 클릭 후 좌측 <b>메일환경설정</b> 매뉴를 클릭합니다. </h4>

    <!--내용시작 -->
    <h2> 기본환경설정 </h2>
	<h3 class="sub_content"> <b>메일용량확인</b> </h3>
	<ol class="content">
		<li>우측 <b>/메일/</b> 탭을 클릭합니다. </li>
		<li>메일용량확인 란에 현재 <b>총사용량/현재사용량</b>을 <b>그래프/용량표시(MB)</b>로 확인합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/mail/mailset_1.png" alt="용량확인" title="용량확인" />
	
	<h3 class="sub_content"> <b>기본환경설정</b> </h3>
	<ol class="content">
		<li>리스트개수를 변경하려면 리스트갯수의 10 ~ 100까지 10개 단위로 선택합니다. </li>
		<li>미리보기 위치를 조정하려면 미리보기의 표시안함, 오른쪽, 아래쪽중 선택합니다. </li>
		<li>미리보기위치의 사이즈를 조정하려면 리스트영역, 미리보기영역의 사이즈를 선택합니다. </li>
		<li>새로고침간격을 조정하려면 1~300 사이의 정수를 입력합니다 </li>
		<li>자동임시저장시간(초)를 변경하려면 사용안함, 30, 60, 90, 120중 선택합니다. </li>
		<li>보내는사람이름을 변경하려면 등록한 이름을 리스트에서 선택합니다. </li>
		<li>보내는사람이름을 수정하려면 <b>[수정]</b> 버튼을 클릭합니다. </li>
		<li>이름입력창에서 이름을 추가하려면 입력박스에 입력 후 <b>[추가]</b> 버튼을 클릭합니다. </li>
		<li>이름입력창에서 이름을 삭제하려면 입력박스에 입력 후 <b>[삭제]</b> 버튼을 클릭합니다. </li>
		<li>이름입력을 마치면 <b>[확인]</b> 버튼을 클릭합니다. 등록한 이름이 보내는사람이름 드롭박스 리스트에 추가됩니다. </li>
		<li>설정을 마치면 <b>[저장]</b> 버튼을 클릭합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/mail/mailset_2.png" alt="기본환경설정" title="기본환경설정" />
	
	<h2> 외부메일설정 </h2>
	<h3 class="sub_content"> POP3를 지원하는 외부메일서버를 등록해두면 메일을 가져올 수 있습니다. <br>
		단, 설정한 외부메일서버가 정상적으로 동작하지 않거나 ID와 비밀번호가 다를 경우는 메일을 가져올 수 없습니다. <br>
		외부메일은 3개 까지 설정할 수 있습니다. </h3>
	<ol class="content">
		<li>우측 /외부메일설정/ 탭을 클릭합니다. </li>
		<li>1번째 POP3설정의 POP3 서버 이름을 입력하거나, 선택하세요 에서 서버를 선택합니다. </li>
		<li>Port번호를 확인후, SSL을 적용하려면, SSL에 체크 합니다. </li>
		<li>사용자아이디/비밀번호란에 아이디, 비밀번호를 입력 후 <b>[접속확인]</b> 버튼을 클릭합니다. </li>
		<li>접속성공메세지가 나타나면 <b>[검색]</b> 버튼을 눌러 편지를 가져올 편지함을 선택합니다. </li>
		<li>가져온서버에서 메일을 삭제하고 가져오려면 가져온 서버에서 메일삭제를 체크 합니다. </li>
		<li>POP3서버를 여러 개 등록할 경우 2번째, 3번째 POP3 설정도 위와 동일하게 설정합니다. </li>
		<li>설정을 마치면 <b>[저장]</b> 버튼을 클릭합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/mail/pop3.png" alt="외부메일설정" title="외부메일설정" />
	
	<h2> 도착한메일전달 </h2>
	<h3 class="sub_content"> 자신의 메일계정으로 도착한 메일을 다른메일계정으로 자동전달할 수 있습니다. </h3>
	<ol class="content">
		<li>우측 /도착한메일전달/ 탭을 클릭합니다.</li>
		<li>자동전달할 메일계정란에 전달할 메일주소를 입력하거나, <b>[선택]</b> 버튼을 클릭합니다. </li>
		<li>메일계정설정 창에서 조직도에서 사용자를 선택 후, 더블클릭하거나, <b>[->]</b> 버튼으로 추가합니다. </li>
		<li>주소록에서 사용자를 선택하려면, 주소록탭을 선택 후, 사용자를 선택후, 더블클릭하거나, <b>[->]</b> 버튼으로 추가합니다.</li>
		<li>추가를 마치면 <b>[확인]</b> 버튼을 클릭합니다.</li>
		<li>설정을 마치면 <b>[저장]</b> 버튼을 클릭합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/mail/auto_forward.png" alt="" title="" />
	
	<h2> 자동분류 </h2>
	<h3 class="sub_content"> 메일 자동분류를 설정하면, 새로 수신된 메일이 등록된 기준에 따라 자동분류가 됩니다. </h3>
	<ol class="content">
		<li>우측 <b>/자동분류/</b> 탭을 클릭합니다. </li>
		<li><b>[분류추가]</b> 버튼을 클릭합니다. </li>
		<li>분류추가 창에서 규칙이름을 입력합니다. </li>
		<li>메시지가 도착하면 다음작업수행에 조건을 선택합니다. </li>
		<li>조건을 추가하려면 <b>[조건추가]</b> 버튼을 클릭합니다. </li>
		<li>다음을수행/다음의경우제외 조건을 선택후 분류추가를 마치면 상단 <b>[분류추가]</b> 버튼을 클릭합니다. </li>
		<li>등록된 분류의 내용을 확인하려면 분류이름 선택 후 상단 <b>[자세히보기]</b> 버튼을 클릭합니다. </li>
		<li>등록된 분류를 삭제하려면 분류이름을 선택 후 상단 <b>[삭제]</b> 버튼을 클릭합니다. </li>
		<li>등록된 분류의 순서를 조정하려면 분류이름을 선택 후 상단 위, 아래로 버튼을 클릭하여 순서를 조정합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/mail/auto_categorization.png" alt="" title="" />
	
	<h2> 자동삭제 </h2>
	<h3 class="sub_content"> 편지함별로 자동삭제할 일자를 지정해두어, 메일용량관리를 편리하게 할 수 있습니다. </h3>
	<ol class="content">
		<li>우측 <b>/자동삭제/</b> 탭을 클릭합니다. </li>
		<li>편지함선택의 <b>[편지함선택]</b> 버튼을 클릭합니다. </li>
		<li>편지함선택 창에서 편지함을 선택 후 <b>[확인]</b> 버튼을 클릭합니다. </li>
		<li>편지함하위 편지함을 추가하려면 <b>[추가]</b> 버튼을 클릭합니다. </li>
		<li>보관기간 일수를 입력합니다. </li>
		<li>읽지않은 메일을 삭제하려면 읽지않은 메일삭제란에 체크합니다. </li>
		<li>설정을 마치면 <b>[조건추가]</b> 버튼을 클릭합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/mail/auto_delete.png" alt="" title="" />
	
	<h2> 서명관리 </h2>
	<h3 class="sub_content"> 메일을 보낼 때 메일본문 끝에 입력할 자신의 서명을 등록 할 수 있습니다. </h3>
	<ol class="content">
		<li>우측 <b>/서명관리/</b> 탭을 클릭합니다. </li>
		<li>기본서명설정에서 설정안함, 서명1, 서명2, 서명3중 선택합니다. 기본서명설정을 설정해두면 메일작성창에 기본서명설정한 것이 표시됩니다. </li>
		<li>서명1, 서명2, 서명3 탭중 서명을 입력할 탭을 선택합니다. </li>
		<li>서명입력본문에 에디터툴을 이용하여 서명을 입력합니다. </li>
		<li>html편집을 하려면 <b>[Html편집]</b> 버튼을 클릭합니다. </li>
		<li>html편집창에서 내용을 편집 후 <b>[확인]</b> 버튼을 클릭합니다. </li>
		<li>서명설정을 마치면 <b>[저장]</b> 버튼을 클릭합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/mail/sign_set.png" alt="서명관리" title="서명관리" />
	
	<h2> 부재중설정 </h2>
	<h3 class="sub_content"> 부재중일시 보낸사람에게 자동회신 보낼 메시지를 등록할 수 있습니다. </h3>
	<ol class="content">
		<li>우측 <b>/부재중설정/</b> 탭을 클릭합니다. </li>
		<li>부재중 자동회신 보내지않음/부재중자동회신보내기 중 선택합니다. </li>
		<li>부재중 메시지를 등록하려면 부재중 자동회신 보내기를 선택합니다. </li>
		<li>특정기간동안에만, 부재중 메시지를 보내려면 다음기간동안에만 부재중 자동회신 보내기에 체크합니다. </li>
		<li>시작시간, 종료시간에 달력으로 날짜를 선택후 시간을 선택합니다. </li>
		<li>메시지입력란에 에디터툴를 메세지를 입력합니다. </li>
		<li>외부의 보낸사람에게 부재중 자동회신보내기를 선택하면 내연락처목록에 있는 보낸 사람 에게만 부재중 자동회신 보내기/ 조직의 외부인에게 부재중 자동회신 보내기중 선택합니다. </li>
		<li>메시지입력란에 에디터툴를 메세지를 입력합니다. </li>
		<li>부재중 메시지 설정을 마치면 <b>[저장]</b> 버튼을 클릭합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/mail/absentee_set.png" alt="부재중설정" title="부재중설정" />
	

    <!--내용끝 -->
</body>
</html>