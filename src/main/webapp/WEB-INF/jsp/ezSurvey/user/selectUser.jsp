<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"      %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"    %>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezSurvey.t52"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="${util.addVer('ezSurvey.css', 'msg')       }">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/ezSurvey/survey.css')  }">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/Tab.css')              }">
	</head>
	<body class="popup survey-target">
		<h1><spring:message code="ezSurvey.t52"/></h1>
		<div id="surveyCloseBttn" class="closeImgBttn"><ul><li><span></span></li></ul></div>
		
		<table class="target-slt">
			<tr>
				<td>
					<table id="TreeViewTD">
						<tr>
							<!-- left -->
							<td>
								<table class="infor-tbl">
									<tr>
										<th>전자 설문</th>
										<td>전자 설문 대상자 설택</td>
									</tr>
								</table>
								
								<!-- 검색 -->
								<div class="infor-searchPanel">
									<div class="inforsub-searchPanel">
										<table class="inf-searchTbl">
											<tr>
												<td>
													<div>
														<select id="searchType">
															<option selected value="displayname"              ><spring:message code="ezSurvey.t57"/></option>
															<option          value="cn"                       ><spring:message code="ezSurvey.t58" /></option>
															<option          value="description"              ><spring:message code="ezSurvey.t59" /></option>
															<option          value="title"                    ><spring:message code="ezSurvey.t60" /></option>
															<option          value="telephonenumber"          ><spring:message code="ezSurvey.t61" /></option>
															<option          value="mobile"                   ><spring:message code="ezSurvey.t62" /></option>
															<option          value="homePhone"                ><spring:message code="ezSurvey.t63"/></option>
															<option          value="facsimileTelephoneNumber" ><spring:message code="ezSurvey.t64"/></option>
															<option          value="mail"                     ><spring:message code="ezSurvey.t65"/></option>
															<option          value="streetAddress"            ><spring:message code="ezSurvey.t66"/></option>
														</select>
														<input type="text" id="keyword">
														<a class="imgbtn" id="searchBtn"><span><spring:message code='ezSurvey.t20'/></span></a>
													</div>
												</td>
												<td>
													<div>
														<a class="imgbtn" id="addDeptBttn"><span><spring:message code='ezSurvey.t67'/></span></a>
														<a class="imgbtn" id="userInfBttn"><span><spring:message code='ezSurvey.t68'/></span></a>
													</div>
												</td>
											</tr>
										</table>
									</div>
								</div>
									
								<!-- 조직도 -->
								<table class="organ-tbl">
									<tr>
										<td class="box">
											<div id="treeView" class="bnkOrgTree"></div>
										</td>
										<td class="listview" id="orglistView">
											<!-- 부서 정보 -->
											<table class="organ-deptTbl">
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
											
											<div id="txtlist_Layer" class="organ-txtList">
												<table id="shareTable" class="organ-subTbl">
 													<tr class="trCabTxt">
														<td><spring:message code="ezSurvey.t57" /></td>
														<td><spring:message code="ezSurvey.t60" /></td>
														<td><spring:message code="ezSurvey.t61" /></td>
													</tr>
												</table>
											</div>
											<div id="tblPageRayer" class=pgshare></div>
										</td>
									</tr>
								</table>
							</td>
								
							<!-- shareBttn -->
							<td class="slt-userBttn">
								<img id="addBttn"    src="/images/kr/cm/arr_right.gif">
								<img id="removeBttn" src="/images/kr/cm/arr_left.gif" >
							</td>
							
							<!-- right -->
							<td>
								<h2 class="receiver_tltype01">
									<span><spring:message code="ezSurvey.t69"/></span>
								</h2>
									
								<div class="slt-listDiv">
									<div>
										<table id="sharedTable" class="mainlist">
											<tr>
												<td><spring:message code='ezSurvey.t70'/></td>
												<td><spring:message code='ezSurvey.t71'/></td>
												<td><spring:message code='ezSurvey.t72'/></td>
												<td><spring:message code='ezSurvey.t73'/></td>
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
			<a class="imgbtn"><span><spring:message code='ezSurvey.t17'/></span></a>
			<a class="imgbtn"><span><spring:message code='ezSurvey.t18'/></span></a>
		</div>
		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezSurvey.lang', 'msg')           }"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSurvey/surveyTree.js')     }"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSurvey/surveyNavi.js')    }"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSurvey/surveyTable.js')   }"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSurvey/surveyShare.js')   }"></script>
		<script type="text/javascript">CabinetShareItem.init("<c:out value='${cabinetId}'/>", "<c:out value='${userId}'/>");</script>
	</body>
</html>