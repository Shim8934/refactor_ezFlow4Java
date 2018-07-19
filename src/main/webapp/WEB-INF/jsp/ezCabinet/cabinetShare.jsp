<%@ page language="java"   contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"      %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"    %>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions" %>
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
											<div id="treeView" class="bnkOrgTree"></div>
										</td>
										<td class="listview" style="width: 440px" id="orglistView">
											<!-- 부서 정보 -->
											<table style="margin-top: -1px;" class="cabOrganDeptTbl">
												<tr>
													<th>
														<span class="selectDeptNm">
															<img src="/images/OrganTree_cross/ic-open.gif"><span id="searchResult"></span><span id="memberCount"></span>
														</span>
														<span>
															<span id="txtSpanView" role="${listType == 'TXT' ? 'on' : 'off'}"><img src="${listType == 'TXT' ? '/images/kr/cm/btn_onlist.gif'    : '/images/kr/cm/btn_list.gif'   }" class="icon_btn" id="txtlist"></span>
															<span id="imgSpanView" role="${listType == 'TXT' ? 'on' : 'off'}"><img src="${listType == 'IMG' ? '/images/kr/cm/btn_onimglist.gif' : '/images/kr/cm/btn_imglist.gif'}" class="icon_btn" id="imglist"></span>
														</span>
													</th>
												</tr>	
											</table>
											<!-- 조직도 텍스트 리스트  --> <!-- class="organCabTbl" --> 
											<div id="txtlist_Layer" class="cabOrganTextListDiv">
												<table id="txtlist_table" class="mainlist">
 													<tr class="trCabTxt">
														<td>이름</td>
														<td>직위</td>
														<td>사내전화</td>
													</tr>
													<!-- <tr>
														<td style="background-color: rgb(240, 246, 255);">지정석</td>
														<td style="background-color: rgb(240, 246, 255);">대리</td>
														<td style="background-color: rgb(240, 246, 255);">02-1234-555</td>
													</tr> -->
													<!-- <tr>
														<td class="imgCabTd">
															<div style="display: flex; height: 99px; border: 1px solid #ddd; margin-top: 5px;">
																<div style="height: 99px; width: 99px; display: flex; align-items: center; min-width: 99px; justify-content: center;"><div class="pic"></div></div>
																<div style="display: flex; align-items: center;">
																	<table class="organinfo">
																		<tr>
																			<td class="name" style="text-align: left;">hyo1[사원]</td>
																		</tr>
																		<tr>
																			<td style="text-align: left;">테스트부서</td>
																		</tr>
																		<tr>
																			<td style="text-align: left;"><img class="icon" src="/images/OrganTree/icon_hp.gif"> -</td>
																		</tr>
																		<tr>
																			<td style="text-align: left;"><img class="icon" src="/images/OrganTree/icon_mail.gif">hyo1@svn.opensol2014.com</td>
																		</tr>
																	</table>
																</div>
															</div>
														</td>
														<td class="txtCabTd">지정석</td>
														<td class="txtCabTd">대리</td>
														<td class="txtCabTd">02-1234-555</td>
													</tr> -->
													
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
		<script type="text/javascript" src="/js/ezCabinet/cabinetNavi.js"           ></script>
		<script type="text/javascript">
			var cabinetId = "<c:out value='${cabinetId}'/>";
			
			(function() {
				var companyTree = new CabinetTree();
				var searchOpt   = "";
				var searchValue = "";
				var deptId      = "";
				var searchMode  = "normal";
				var cabinetNavi = null;
				initEvents();
				
				function initEvents() {
					document.onselectstart  = function () { return false;};
					
					//Cabinet navigation
					var naviMessages = {
						next     : CabinetMessages.strNext,
						previous : CabinetMessages.strPrev,
						item     : CabinetMessages.strItem,
						total    : CabinetMessages.strTotal
					};
					
					cabinetNavi = new CabinetNavi({
						messages : naviMessages,
						divId    : "tblPageRayer",
						divClass : "cabpagenavi",
						callback : getUsers
					});
					
					var cabShareBttnElmt    = document.getElementById("cabShareBttn");
					var listBttns           = cabShareBttnElmt.children;
					listBttns[0].onclick    = function(e) {saveShareUsers();};
					listBttns[1].onclick    = function(e) {closeWindow();};
					document.getElementById("txtSpanView").addEventListener("click", function(e) {changeListView('TXT');}, false);
					document.getElementById("imgSpanView").addEventListener("click", function(e) {changeListView('IMG');}, false);
					
					//Set Company Tree
					companyTree.setTreeInfo({
						treeId     : "treeView",
						treeType   : "organ",
						type       : "normal",
						initialUrl : "/ezCabinet/getCompanyTree.do",
						extendUrl  : "/ezCabinet/getSubNodes.do",
						click      : getSelectedList,
						dblClick   : null,
						companyId  : ""
					});

					companyTree.makeTree();
					getShareList();
					
					function getSelectedList(node) {
						deptId     = node.getAttribute("role");
						document.getElementById("searchResult").textContent = node.textContent;
						searchMode = "normal";
						getUsers("1");
					}
					
					function getUsers(page) {
						var url  = "";
						var data = {};
						
						switch(searchMode) {
							case "normal" : url = "/ezCabinet/getDeptMembers.do";
										data = {deptId : deptId, currentPage : page};
										break;
							case "search" : url = "";
										data = {srchOption : searchOpt, srchValue : searchValue, currentPage : page};
										break;
						}
						
						$.ajax({
							type: "POST",
							url: url,
							data: data,
							dataType: "JSON",
							async: true,
							success : function(data) {
								console.log(data);
								var result = data.memberList;
								cabinetNavi.init(data.currentPage, data.memberCount, data.totalPages);
								document.getElementById("memberCount").innerHTML = " - [" + "<span class='cabColor'>" + data.memberCount + "명" + "</span>" + "]";
								processUserList(result);
							},
							error : function(error) {
							}
						});
					}
					
					function processUserList(result) {
						var tableList       = document.getElementById("txtlist_table");
						var txtSpanView     = document.getElementById("txtSpanView").getAttribute("role");
						tableList.className = txtSpanView == "on" ? "mainlist" : "organCabTbl";
						
						while (tableList.rows.length > 1) {
							tableList.deleteRow(1);
						}
						
						if(result == null || result.length == 0) {
							var trElmt = document.createElement("tr");
							var tdElmt = document.createElement("td");
							
							trElmt.appendChild(tdElmt);
							tableList.appendChild(trElmt);
						}
						else {
							for(var i = 0, len = result.length; i < len ; i++) {
								var trElmt  = document.createElement("tr");
								var tdElmt1 = document.createElement("td");
								var tdElmt2 = document.createElement("td");
								var tdElmt3 = document.createElement("td");
								var tdElmt4 = document.createElement("td");
								
								tdElmt1.textContent = result[i]["userName"];
								tdElmt2.textContent = result[i]["position"];
								tdElmt3.textContent = result[i]["telNumber"];
								
								tdElmt1.className   = "txtCabTd";
								tdElmt2.className   = "txtCabTd";
								tdElmt3.className   = "txtCabTd";
								
								//Process td4
								var divElemt  = document.createElement("div");
								var divChild1 = document.createElement("div");
								var divChild2 = document.createElement("div");
								
								//Process divChild1
								var divInner = document.createElement("div");
								divInner.className = "pic";
								if (result[i]["userImg"]) {
									var imgElmt = document.createElement("img");
									imgElmt.src = result[i]["userImg"];
									divInner.appendChild(imgElmt);
								}
								
								divChild1.appendChild(divInner);
								
								//Process DivChild2
								var innerTable = document.createElement("table");
								innerTable.className = "organinfo";
								var innderTr1  = document.createElement("tr");
								var innderTr2  = document.createElement("tr");
								var innderTr3  = document.createElement("tr");
								var innderTr4  = document.createElement("tr");
								
								var innerTd1   = document.createElement("td");
								var innerTd2   = document.createElement("td");
								var innerTd3   = document.createElement("td");
								var innerTd4   = document.createElement("td");
								
								innerTd1.className = "name cUserInfor";
								innerTd2.className = "cUserInfor";
								innerTd3.className = "cUserInfor";
								innerTd4.className = "cUserInfor";
								
								innerTd1.textContent = result[i]["userName"] + "[" + result[i]["position"] + "]";
								innerTd2.textContent = result[i]["deptName"];
								innerTd3.innerHTML   = "<img class='icon' src='/images/OrganTree/icon_hp.gif'>"   + result[i]["telNumber"];
								innerTd4.innerHTML   = "<img class='icon' src='/images/OrganTree/icon_mail.gif'>" + result[i]["mail"];
								
								innderTr1.appendChild(innerTd1);
								innderTr2.appendChild(innerTd2);
								innderTr3.appendChild(innerTd3);
								innderTr4.appendChild(innerTd4);
								innerTable.appendChild(innderTr1);
								innerTable.appendChild(innderTr2);
								innerTable.appendChild(innderTr3);
								innerTable.appendChild(innderTr4);
								divChild2.appendChild(innerTable);
								
								divElemt.appendChild(divChild1);
								divElemt.appendChild(divChild2);
								
								divElemt.className = "imgCabDivMain";
								tdElmt4.className  = "imgCabTd";
								tdElmt4.appendChild(divElemt);
								
								trElmt.appendChild(tdElmt1);
								trElmt.appendChild(tdElmt2);
								trElmt.appendChild(tdElmt3);
								trElmt.appendChild(tdElmt4);
								
								tableList.appendChild(trElmt);
							}
						}
					}
					
					function changeListView(flag) {
						console.log("Flag: " + flag);
						setOrganListType(flag);
						var txtImgElmt = document.getElementById("txtlist");
						var imgImgElmt = document.getElementById("imglist");
						var tableList  = document.getElementById("txtlist_table");
						
						if (flag == 'TXT') {
							txtImgElmt.src      = "/images/kr/cm/btn_onlist.gif";
							imgImgElmt.src      = "/images/kr/cm/btn_imglist.gif";
							tableList.className = "mainlist";
						}
						else {
							txtImgElmt.src      = "/images/kr/cm/btn_list.gif";
							imgImgElmt.src      = "/images/kr/cm/btn_onimglist.gif";
							tableList.className = "organCabTbl";
						}
					}
					
					function setOrganListType(pListType) {
						$.ajax({
							type: "POST",
							dataType: "text",
							url: "/ezOrgan/setListType.do",
							async: false,
							data: {listType : pListType},
							success: function(result) {
							}
						});
					}
					
					function getShareList() {
						$.ajax({
							type: "POST",
							url: "/ezCabinet/getShareUserList.do",
							data: {
								"cabinetId": cabinetId
							},
							dataType: "JSON",
							async: false,
							success: function(data) {
							},
							error: function(error) {
							}
						});
					}
				}
				
				function closeWindow() {window.close();}
				
				function saveShareUsers() {
					//*Note add function here
				}
			})();
			
		</script>
	</body>
</html>