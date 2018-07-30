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
															<option          value="mail"                     ><spring:message code="ezCabinet.t102"/></option>
															<option          value="streetAddress"            ><spring:message code="ezCabinet.t107"/></option>
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
										<td class="listview" style="width: 440px" id="orglistView">
											<!-- 부서 정보 -->
											<table style="margin-top: -1px;" class="cabOrganDeptTbl">
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
												<table id="shareTable" class="organCabTbl">
 													<tr class="trCabTxt">
														<td><spring:message code="ezCabinet.t18" /></td>
														<td><spring:message code="ezCabinet.t97" /></td>
														<td><spring:message code="ezCabinet.t98" /></td>
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
								<img id="addBttn"    src="/images/kr/cm/arr_right.gif">
								<img id="removeBttn" src="/images/kr/cm/arr_left.gif" >
							</td>
							
							<!-- right -->
							<td>
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
															<option          value="cn"         ><spring:message code="ezCabinet.t137"/></option>
															<option          value="description"><spring:message code="ezCabinet.t19" /></option>
														</select>
														<input type="text" id="keyword2">
														<a class="imgbtn" id="searchBtn2"><span><spring:message code='ezCabinet.t49'/></span></a>
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
		
		<div class="btnposition" id="cabShareBttn">
			<a class="imgbtn"><span><spring:message code='ezCabinet.t14'/></span></a>
			<a class="imgbtn"><span><spring:message code='ezCabinet.t15'/></span></a>
		</div>
		
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"        ></script>
		<script type="text/javascript" src="<spring:message code='ezCabinet.lang'/>"></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetTree.js"           ></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetNavi.js"           ></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetTable.js"          ></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetShare.js"          ></script>
		<script type="text/javascript">CabinetShareItem.init("<c:out value='${cabinetId}'/>");</script>
	</body>
</html>