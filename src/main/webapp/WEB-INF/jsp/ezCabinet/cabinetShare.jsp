<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCabinet.css'/>" type="text/css">
		<link rel="stylesheet" href="/css/ezCabinet/cabinet.css"             type="text/css">
	</head>
	<body class="popup cabShareFile">
		<h1><spring:message code="ezCabinet.t04"/></h1>
		
		<div id="cabShareClose" class="cabClose"><ul><li><span><spring:message code='ezCabinet.t66'/></span></li></ul></div>
		
		<div class="cabShareTtl">
			<div><spring:message code="ezCabinet.t95"/></div>
			<div>그룹웨어 업무</div>
		</div>
		
		<div class="cabShareOrgTree">
			<div class="orgTreeLeft">
				<div class="cabShareSearch">
					<div class="cabShareTxt">조직도</div>
					<div class="cabShareSeachPanel">
						<select id="searchType">
							<option selected value="name"     ><spring:message code="ezCabinet.t18" /></option>
							<option          value="userId"   ><spring:message code="ezCabinet.t96" /></option>
							<option          value="dept"     ><spring:message code="ezCabinet.t19" /></option>
							<option          value="title"    ><spring:message code="ezCabinet.t97" /></option>
							<option          value="telNumber"><spring:message code="ezCabinet.t98" /></option>
							<option          value="mobile"   ><spring:message code="ezCabinet.t99" /></option>
							<option          value="homePhone"><spring:message code="ezCabinet.t100"/></option>
							<option          value="faxNumber"><spring:message code="ezCabinet.t101"/></option>
							<option          value="mail"     ><spring:message code="ezCabinet.t102"/></option>
							<option          value="address"  ><spring:message code="ezCabinet.t103"/></option>
						</select>
						<input type="text">
						<a class="cabBttn2"><span><spring:message code='ezCabinet.t49'/></span></a>
					</div>
				</div>
				
				<div class="cabShareTreeSl">
					<div class="organTree">
						<div><img id="S907000" level="0" src="/images/OrganTree_cross/minus.gif" class="webfolderMinus"><img class="webfolderImg" src="/images/OrganTree_cross/ic-company.gif"><span class="spanName" name="S907000" level="0">(주)가온아이</span><div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="sua" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="sua" level="1"> </span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="tempdept" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="tempdept" level="1">"임시"</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="444" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="444" level="1">2323뎁스</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="cs112" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="cs112" level="1">고객&amp;관리부서</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="hyejeong" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="hyejeong" level="1">김혜정부서</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="dpdept" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="dpdept" level="1">대표부서</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="addepth1" level="1" src="/images/OrganTree_cross/plus.gif" class="webfolderPlus"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="addepth1" level="1">뎁스1</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="garm" level="1" src="/images/OrganTree_cross/plus.gif" class="webfolderPlus"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="garm" level="1">민수부서</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="minsu2" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="minsu2" level="1">민수부서2</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="boh" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="boh" level="1">보혜부서</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="bindept" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="bindept" level="1">빈부서</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="deptchan1" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="deptchan1" level="1">성준부서1</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="deptchan2" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="deptchan2" level="1">성준부서2</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="deptchan3" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="deptchan3" level="1">성준부서3</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="soso" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="soso" level="1">소소</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="suua" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="suua" level="1">솨솨솨</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="jongdept" level="1" src="/images/OrganTree_cross/plus.gif" class="webfolderPlus"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="jongdept" level="1">에이디디디</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="yunho1" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="yunho1" level="1">윤호부서1</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="1234" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="1234" level="1">은석부서</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="321" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="321" level="1">은석부서2</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="seojaewon" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="seojaewon" level="1">재원스</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="jongpdept2" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="jongpdept2" level="1">종균부서2</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="jongpdept3" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="jongpdept3" level="1">종균부서3</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="jjoasd" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="jjoasd" level="1">주소록텟</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="hyohyo" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="hyohyo" level="1">직인부서</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="cleanbu" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="cleanbu" level="1">클-린전결부서</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="hwp1" level="1" src="/images/OrganTree_cross/plus.gif" class="webfolderPlus"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="hwp1" level="1">한글양식1</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="hyejeongkk" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="hyejeongkk" level="1">혜정부서</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="abc123123" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="abc123123" level="1">123</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="b001" level="1" src="/images/OrganTree_cross/plus.gif" class="webfolderPlus"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="b001" level="1">QC_팀</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="c001" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="c001" level="1">solution팀</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="s010395" level="1" src="/images/OrganTree_cross/plus.gif" class="webfolderPlus"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="s010395" level="1">ㅁㄴㅇㅁ</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="dev1" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="dev1" level="1">개발1팀</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="opensol" level="1" src="/images/OrganTree_cross/plus.gif" class="webfolderPlus"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="opensol" level="1">오픈솔루션팀</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="myteam" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="myteam" level="1">마이팀</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="mingdept" level="1" src="/images/OrganTree_cross/plus.gif" class="webfolderPlus"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="mingdept" level="1">밍구부서</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="yourteam" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="yourteam" level="1">유어팀</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="fomaces" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="fomaces" level="1">장상스부서</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="jongp1" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="jongp1" level="1">종균부서</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="qweqwe" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="qweqwe" level="1">&lt;strong&gt;부서</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="test1" level="1" src="/images/OrganTree_cross/minus.gif" class="webfolderMinus"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="test1" level="1" style="color: rgb(0, 74, 135); font-weight: bold;">테스트부서</span><div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="test11" level="2" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="test11" level="2">테스트부서1&amp;</span></div></div></div></div></div>
					</div>
					<div class="organInf">
						<table class="rlSelectTbl">
							<tr>
								<th><spring:message code='ezCabinet.t18'/></th>
								<th><spring:message code='ezCabinet.t97'/></th>
								<th><spring:message code='ezCabinet.t98'/></th>
							</tr>
							<tr>
								<td>지정석</td>
								<td>대리</td>
								<td>02-1234-555</td>
							</tr>
							<tr>
								<td>지정석</td>
								<td>대리</td>
								<td>02-1234-555</td>
							</tr>
						</table>
					</div>
				</div>
			</div>
			
			<div class="cabShareBttnDiv">
				<div>
					<img src="/images/arr_right.gif">
					<img src="/images/arr_left.gif" >
				</div>
			</div>
			
			<div class="cabShareUsers">
				<div class="cabShareSearch">
					<div class="cabShareTxt">공유자</div>
					<div class="cabShareSeachPanel">
						<select id="searchType">
							<option selected value="name"     ><spring:message code="ezCabinet.t18" /></option>
							<option          value="userId"   ><spring:message code="ezCabinet.t96" /></option>
							<option          value="dept"     ><spring:message code="ezCabinet.t19" /></option>
							<option          value="title"    ><spring:message code="ezCabinet.t97" /></option>
							<option          value="telNumber"><spring:message code="ezCabinet.t98" /></option>
							<option          value="mobile"   ><spring:message code="ezCabinet.t99" /></option>
							<option          value="homePhone"><spring:message code="ezCabinet.t100"/></option>
							<option          value="faxNumber"><spring:message code="ezCabinet.t101"/></option>
							<option          value="mail"     ><spring:message code="ezCabinet.t102"/></option>
							<option          value="address"  ><spring:message code="ezCabinet.t103"/></option>
						</select>
						<input type="text">
						<a class="cabBttn2"><span><spring:message code='ezCabinet.t49'/></span></a>
					</div>
				</div>
				
				<div class="cabShareUserDiv">
					<table class="rlSelectTbl">
						<tr>
							<th><spring:message code='ezCabinet.t103'/></th>
							<th><spring:message code='ezCabinet.t104'/></th>
							<th><spring:message code='ezCabinet.t105'/></th>
							<th><spring:message code='ezCabinet.t106'/></th>
						</tr>
						<tr>
							<td>솔루션 3팀</td>
							<td>강민수</td>
							<td>
								<select>
									<option>읽기</option>
									<option>쓰기</option>
								</select>
							</td>
							<td>
								<select>
									<option>추가 안함</option>
									<option>추가</option>
								</select>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
		<div class="cabdivBttn" id="cabShareBttn">
			<a class="cabBttn"><span><spring:message code='ezCabinet.t14'/></span></a>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t15'/></span></a>
		</div>
		
		<script type="text/javascript">
			(function() {
				initEvents();
				
				function initEvents() {
					document.onselectstart  = function () { return false;};
					closeBttn               = document.getElementById("cabShareClose").firstElementChild.firstElementChild.firstElementChild;
					closeBttn.onclick       = function(e) {closeWindow();};
					
					var cabdivBttnElmt      = document.getElementById("cabShareBttn");
					var listBttns           = cabdivBttnElmt.children;
					listBttns[0].onclick    = function(e) {saveShareUsers();};
					listBttns[1].onclick    = function(e) {closeWindow();};
				}
				
				function closeWindow() {window.close();}
				
				function saveShareUsers() {
					//*Note add function here
				}
			})();
		</script>
	</body>
</html>