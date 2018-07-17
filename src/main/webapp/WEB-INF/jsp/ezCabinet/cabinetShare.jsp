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
											<div id="treeView">
													
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
		
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"        ></script>
		<script type="text/javascript" src="<spring:message code='ezCabinet.lang'/>"></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetTree.js"           ></script>
		<script type="text/javascript">
			(function() {
				var companyTree = new CabinetTree();
				initEvents();
				
				function initEvents() {
					document.onselectstart  = function () { return false;};
					
					var cabShareBttnElmt    = document.getElementById("cabShareBttn");
					var listBttns           = cabShareBttnElmt.children;
					listBttns[0].onclick    = function(e) {saveShareUsers();};
					listBttns[1].onclick    = function(e) {closeWindow();};
					
					//Set Company Tree
					companyTree.setTreeInfo({
						treeId     : "treeView",
						treeType   : "organ",
						type       : "normal",
						initialUrl : "/ezCabinet/getCompanyTree.do",
						extendUrl  : "/ezCabinet/getSubNodes.do",
						click      : null,
						dblClick   : null,
						companyId  : ""
					});

					companyTree.makeTree();
				}
				
				function closeWindow() {window.close();}
				
				function saveShareUsers() {
					//*Note add function here
				}
			})();
			
		</script>
	</body>
</html>