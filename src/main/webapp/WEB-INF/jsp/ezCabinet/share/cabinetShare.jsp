<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"      %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"    %>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezCabinet.t04"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/ezCabinet/cabinet.css')}">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/Tab.css')              }">
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	</head>
	<body class="popup cabShareFile">
		<h1><spring:message code="ezCabinet.t04"/></h1>
		<div id="cabRlClose" class="cabClose"><ul><li><span></span></li></ul></div>
		
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
										<td><c:out value='${cabinet.cabinetName}'/></td>
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
															<option selected value="displayname"              ><spring:message code="ezCabinet.t18" /></option>
															<option          value="cn"                       ><spring:message code="ezCabinet.t96" /></option>
															<option          value="description"              ><spring:message code="ezCabinet.t19" /></option>
															<option          value="title"                    ><spring:message code="ezCabinet.t97" /></option>
															<option          value="telephonenumber"          ><spring:message code="ezCabinet.t98" /></option>
															<option          value="mobile"                   ><spring:message code="ezCabinet.t99" /></option>
															<option          value="homePhone"                ><spring:message code="ezCabinet.t100"/></option>
															<option          value="facsimileTelephoneNumber" ><spring:message code="ezCabinet.t101"/></option>
															<c:if test="${primaryLang eq '3' }">
		                                                    <option value="extensionPhone" usedefault="0"><spring:message code='main.ksa02' /></option>
		                                                    <option value="officeMobile" usedefault="0"><spring:message code='main.ksa03' /></option>
		                                                    </c:if>
															<option          value="mail"                     ><spring:message code="ezCabinet.t102"/></option>
															<option value="streetAddress" style="display:none"><spring:message code="ezCabinet.t107"/></option>
														</select>
														<input type="text" id="keyword">
														<a class="imgbtn" id="searchBtn"><span><spring:message code='ezCabinet.t49'/></span></a>
													</div>
												</td>
												<td>
													<div>
														<a class="imgbtn" id="addDeptBttn"><span><spring:message code='ezCabinet.t128'/></span></a>
														<a class="imgbtn" id="userInfBttn"><span><spring:message code='ezCabinet.t129'/></span></a>
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
										<td class="listview" id="orglistView">
											<!-- 부서 정보 -->
											<table class="cabOrganDeptTbl">
												<tr>
													<th>
														<span class="selectDeptNm">
															<img src="/images/OrganTree_cross/ic-open.gif"><span id="searchResult"></span><span id="memberCount"></span>
														</span>
														<span>
															<span id="txtSpanView"><img ${listType == 'TXT' ? "src='/images/kr/cm/btn_onlist.gif' role='on'"    : "src='/images/kr/cm/btn_list.gif' role='off'"   } class="icon_btn" id="txtlist"></span>
															<span id="imgSpanView"><img ${listType == 'IMG' ? "src='/images/kr/cm/btn_onimglist.gif' role='on'" : "src='/images/kr/cm/btn_imglist.gif' role='off'"} class="icon_btn" id="imglist"></span>
														</span>
													</th>
												</tr>
											</table>
											
											<div id="txtlist_Layer" class="cabOrganTextListDiv">
												<table id="shareTable" class="mainlist">
 													<tr class="trCabTxt">
														<td><spring:message code="ezCabinet.t18" /></td>
														<td><spring:message code="ezCabinet.t97" /></td>
														<td><spring:message code="ezCabinet.t98" /></td>
													</tr>
												</table>
											</div>
											<div id="tblPageRayer" class="cabpgshare"></div>
										</td>
									</tr>
								</table>
							</td>
								
							<!-- shareBttn -->
							<td class="cabShareBttn">
								<img id="addBttn"    src="/images/kr/cm/arr_right.gif">
								<img id="removeBttn" src="/images/kr/cm/arr_left.gif" >
							</td>
							
							<%-- 2020-01-23 홍승비 - 공유자 TD에 min-width 추가(IE 브라우저 대응) --%>
							<!-- right -->
							<td style="min-width:410px;">
								<h2 class="receiver_tltype01">
									<span style="min-width: 45px;"><spring:message code="ezCabinet.t130" /></span>
								</h2>
								
								<div class="cabShareSearPanel">
									<div class="cabShareSearPanelSub">
										<table class="cabShareSearTbl">
											<tr>
												<td>
													<div>
														<select id="searchType2">
															<option selected value="displayname"><spring:message code="ezCabinet.t18" /></option>
															<option          value="userId"         ><spring:message code="ezCabinet.t137"/></option>
															<option          value="description"><spring:message code="ezCabinet.t19" /></option>
														</select>
														<input type="text" id="keyword2">
														<a class="imgbtn" id="searchBtn2"><span><spring:message code='ezCabinet.t49'/></span></a>
														<c:if test="${cabinet.cabinetLevel != '0'}"><a class="imgbtn" id="ancestorshare"><span><spring:message code='ezCabinet.t159'/></span></a></c:if>
													</div>
												</td>
											</tr>
										</table>
									</div>
								</div>
									
								<div class="cabShareListDiv">
									<div>
										<table id="sharedTable" class="mainlist">
											<tr>
												<td><spring:message code='ezCabinet.t103'/></td>
												<td><spring:message code='ezCabinet.t104'/></td>
												<td><spring:message code='ezCabinet.t105'/></td>
												<td><spring:message code='ezCabinet.t106'/></td>
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
		
		<div class="btnposition btnpositionNew" id="cabShareBttn">
			<a class="imgbtn"><span><spring:message code='ezCabinet.t14'/></span></a>
			<a class="imgbtn"><span><spring:message code='ezCabinet.t15'/></span></a>
		</div>
		<input type="hidden" id="userLang" value="${lang}">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezCabinet.lang', 'msg')          }"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCabinet/cabinetTree.js')   }"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCabinet/cabinetNavi.js')   }"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCabinet/cabinetTable.js')  }"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCabinet/cabinetShare.js')  }"></script>
		<script type="text/javascript">
			var cabinetId = "<c:out value='${cabinetId}'/>";
			CabinetShareItem.init(cabinetId, "<c:out value='${userId}'/>");
			var firstList;

			// 최초로 창이 로드될때 div에 존재하는 공유자 리스트 배열에 저장.
			window.onload = function() {
				var selectedUsers = document.getElementById("sharedTable");
				var listTr        = selectedUsers.rows;
				firstList      = [];

				for (var i = 1, len = listTr.length; i < len; i++) {
					var userId   = listTr[i].getAttribute("role");
					var userType = listTr[i].getAttribute("userType");
					var perSlBox = listTr[i].children[2].firstElementChild;
					var subSlBox = listTr[i].children[3].firstElementChild;
					var permiss  = perSlBox.options[perSlBox.selectedIndex].value;
					var subPerm  = subSlBox.options[subSlBox.selectedIndex].value;
					firstList.push({userId: userId, userType : userType, permis: permiss, subPerm: subPerm, searchFlag : 'N'});
				}
			};
		</script>
	</body>
</html>