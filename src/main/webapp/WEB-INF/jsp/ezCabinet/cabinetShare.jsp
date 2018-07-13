<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezCabinet.t04"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCabinet.css'/>" type="text/css">
		<link rel="stylesheet" href="/css/ezCabinet/cabinet.css"             type="text/css">
		<link rel="stylesheet" href="/css/Tab.css"                           type="text/css">
	</head>
	<body class="popup cabShareFile">
		<h1><spring:message code="ezCabinet.t04"/></h1>
		
		<table style="width:100%;">
			<tr>
				<td>
					<table id="TreeViewTD">
						<tr>
							<!-- left -->
							<td>
								<table class="cabShareInf">
									<tr>
										<th><spring:message code="ezCabinet.t95"/></th>
										<td>그룹웨어 업무</td>
									</tr>
								</table>
								
								<!-- 검색 -->
								<div class="cabShareSearPanel">
									<div class="cabShareSearPanelSub">
										<table class="cabShareSearTbl">
											<tr>
												<td>
													<div>
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
															<option          value="address"  ><spring:message code="ezCabinet.t107"/></option>
														</select>
														<input type="text">
														<a class="imgbtn"><span><spring:message code='ezCabinet.t49'/></span></a>
													</div>
												</td>
												<td>
													<div>
														<a class="imgbtn"><span>부서선택</span></a>
														<a class="imgbtn"><span>직원정보보기</span></a>
													</div>
												</td>
											</tr>
										</table>
									</div>
								</div>
									
								<!-- 조직도 -->
								<table class="cabOrganTbl">
									<tr>
										<td class="box">
											<div id="TreeView">
													<div><img id="S907000" level="0" src="/images/OrganTree_cross/minus.gif" class="webfolderMinus"><img class="webfolderImg" src="/images/OrganTree_cross/ic-company.gif"><span class="spanName" name="S907000" level="0">(주)가온아이</span><div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="sua" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="sua" level="1"> </span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="tempdept" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="tempdept" level="1">"임시"</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="444" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="444" level="1">2323뎁스</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="cs112" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="cs112" level="1">고객&amp;관리부서</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="hyejeong" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="hyejeong" level="1">김혜정부서</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="dpdept" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="dpdept" level="1">대표부서</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="addepth1" level="1" src="/images/OrganTree_cross/plus.gif" class="webfolderPlus"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="addepth1" level="1">뎁스1</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="garm" level="1" src="/images/OrganTree_cross/plus.gif" class="webfolderPlus"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="garm" level="1">민수부서</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="minsu2" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="minsu2" level="1">민수부서2</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="boh" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="boh" level="1">보혜부서</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="bindept" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="bindept" level="1">빈부서</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="deptchan1" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="deptchan1" level="1">성준부서1</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="deptchan2" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="deptchan2" level="1">성준부서2</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="deptchan3" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="deptchan3" level="1">성준부서3</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="soso" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="soso" level="1">소소</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="suua" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="suua" level="1">솨솨솨</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="jongdept" level="1" src="/images/OrganTree_cross/plus.gif" class="webfolderPlus"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="jongdept" level="1">에이디디디</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="yunho1" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="yunho1" level="1">윤호부서1</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="1234" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="1234" level="1">은석부서</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="321" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="321" level="1">은석부서2</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="seojaewon" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="seojaewon" level="1">재원스</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="jongpdept2" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="jongpdept2" level="1">종균부서2</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="jongpdept3" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="jongpdept3" level="1">종균부서3</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="jjoasd" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="jjoasd" level="1">주소록텟</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="hyohyo" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="hyohyo" level="1">직인부서</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="cleanbu" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="cleanbu" level="1">클-린전결부서</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="hwp1" level="1" src="/images/OrganTree_cross/plus.gif" class="webfolderPlus"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="hwp1" level="1">한글양식1</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="hyejeongkk" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="hyejeongkk" level="1">혜정부서</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="abc123123" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="abc123123" level="1">123</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="b001" level="1" src="/images/OrganTree_cross/plus.gif" class="webfolderPlus"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="b001" level="1">QC_팀</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="c001" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="c001" level="1">solution팀</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="s010395" level="1" src="/images/OrganTree_cross/plus.gif" class="webfolderPlus"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="s010395" level="1">ㅁㄴㅇㅁ</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="dev1" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="dev1" level="1">개발1팀</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="opensol" level="1" src="/images/OrganTree_cross/plus.gif" class="webfolderPlus"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="opensol" level="1">오픈솔루션팀</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="myteam" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="myteam" level="1">마이팀</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="mingdept" level="1" src="/images/OrganTree_cross/plus.gif" class="webfolderPlus"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="mingdept" level="1">밍구부서</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="yourteam" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="yourteam" level="1">유어팀</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="fomaces" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="fomaces" level="1">장상스부서</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="jongp1" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="jongp1" level="1">종균부서</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="qweqwe" level="1" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="qweqwe" level="1">&lt;strong&gt;부서</span></div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="test1" level="1" src="/images/OrganTree_cross/minus.gif" class="webfolderMinus"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="test1" level="1" style="color: rgb(0, 74, 135); font-weight: bold;">테스트부서</span><div><div><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif"><img id="test11" level="2" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg"><img class="webfolderImg" src="/images/OrganTree_cross/ic-open.gif"><span class="spanName" name="test11" level="2">테스트부서1&amp;</span></div></div></div></div></div>												
											</div>
										</td>
										<td></td>
										<td class="listview" style="width: 440px" id="orglistView">
											<!-- 부서 정보 -->
											<table style="margin-top: -1px;" class="cabOrganDeptTbl">
												<tr>
													<th>
														<span id="SelectDeptNM" countinfo="1">
															<img src="/images/OrganTree_cross/ic-open.gif">김혜정부서-[<span>6명</span>]
														</span>
														<span>
															<span><img src="/images/kr/cm/btn_list.gif" class="icon_btn" id="txtlist"></span>
															<span><img src="/images/kr/cm/btn_imglist.gif" class="icon_btn" id="imglist"></span>
														</span>
													</th>
												</tr>	
											</table>
											<!-- 조직도 리스트  -->
											<div id="txtlist_Layer" class="cabOrganListDiv">
												<table id="txtlist_table" class="mainlist">
													<tr>
														<td>이름</td>
														<td>직위</td>
														<td>사내전화</td>
													</tr>
													<tr>
														<td style="background-color: rgb(240, 246, 255);">지정석</td>
														<td style="background-color: rgb(240, 246, 255);">대리</td>
														<td style="background-color: rgb(240, 246, 255);">02-1234-555</td>
													</tr>
												</table>
											</div>
											<div id="tblPageRayer" class="cabOrganPageDiv"></div>
										</td>
									</tr>
								</table>
							</td>
								
							<!-- shareBttn -->
							<td class="cabShareBttn">
								<img src="/images/kr/cm/arr_right.gif">
								<img src="/images/kr/cm/arr_left.gif">
							</td>
							
							<!-- right -->
							<td>
								<h2 class="receiver_tltype01">
									<span style="min-width: 45px;">공유자</span>
								</h2>
								
								<div class="cabShareSearPanel">
									<div class="cabShareSearPanelSub">
										<table class="cabShareSearTbl">
											<tr>
												<td>
													<div>
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
															<option          value="address"  ><spring:message code="ezCabinet.t107"/></option>
														</select>
														<input type="text">
														<a class="imgbtn"><span><spring:message code='ezCabinet.t49'/></span></a>
													</div>
												</td>
											</tr>
										</table>
									</div>
								</div>
									
								<div class="cabShareListDiv">
									<div>
										<table id="txtlist_table" class="mainlist">
											<tr>
												<td><spring:message code='ezCabinet.t103'/></td>
												<td><spring:message code='ezCabinet.t104'/></td>
												<td><spring:message code='ezCabinet.t105'/></td>
												<td><spring:message code='ezCabinet.t106'/></td>
											</tr>
											<tr>
												<td>솔루션 3팀</td>
												<td>강민수</td>
												<td>
													<select width="65%">
														<option>읽기</option>
														<option>쓰기</option>
													</select>
												</td>
												<td>
													<select width="80%">
														<option>추가 안함</option>
														<option>추가</option>
													</select>
												</td>
											</tr>
											<tr>
												<td>솔루션 3팀</td>
												<td>응웬바오</td>
												<td>
													<select width="65%">
														<option>읽기</option>
														<option>쓰기</option>
													</select>
												</td>
												<td>
													<select width="80%">
														<option>추가 안함</option>
														<option>추가</option>
													</select>
												</td>
											</tr>
										</table>
									</div>
								</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		
		<div class="btnposition" id="cabShareBttn">
			<a class="imgbtn"><span><spring:message code='ezCabinet.t14'/></span></a>
			<a class="imgbtn"><span><spring:message code='ezCabinet.t15'/></span></a>
		</div>
		
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript">
			$(document).ready(function() {
				
			});
			
			(function() {
				initEvents();
				
				function initEvents() {
					document.onselectstart  = function () { return false;};
					
					var cabShareBttnElmt    = document.getElementById("cabShareBttn");
					var listBttns           = cabShareBttnElmt.children;
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