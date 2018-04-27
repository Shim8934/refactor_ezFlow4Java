<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>프로젝트 목록</title>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript"
	src="/js/ezTask/jquery.lineProgressbar.js"></script>
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />"
	type="text/css">
<link href="/css/previewmail.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="/css/jquery.lineProgressbar.css"
	type="text/css">
<script type="text/javascript" src="/js/ezBoard/ListView_list.js"></script>
<script type="text/javascript">
var CurrentHeight = document.documentElement.clientHeight - 110;
//setTotalCount("${totalCount}");

$(function(){
	var projectList = new Array();
	
	<c:forEach items="${projectList}" var="project">
		var json = new Object();
		json.projectId = "${project.projectId}";
		json.progress = "${project.progress}";
		projectList.push(json);
	</c:forEach>
	
	for (var i = 0; i < projectList.length; i++) {
		$("div[name=" + projectList[i].projectId+"]").LineProgressbar({
			percentage : projectList[i].progress,
			fillBackGroundColor:"#9b59b6",
			height:'15px',
			radius:'15px',
			width : '80%'
		});
		
		$("div[complete=" + projectList[i].projectId+"]").LineProgressbar({
			percentage : projectList[i].progress,
			fillBackGroundColor:"#9b59b6",
			height:'15px',
			radius:'15px',
			width : '80%'
		});
		
		$("div[overdue=" + projectList[i].projectId+"]").LineProgressbar({
			percentage : projectList[i].progress,
			fillBackGroundColor:"#9b59b6",
			height:'15px',
			radius:'15px',
			width : '80%'
		});
	}
	
	if(viewType == 0) {
		$("#memoStyleDiv").css("display", "");
		$("#memoStyle").attr("src", "/images/kr/cm/btn_onnoframe.gif");
		document.getElementById("memoStyleDiv").style.height = (CurrentHeight - 50) + "px";
	} else {
		$("#MailListRayer").css("display", "inline-block");
		$("#boardStyle").attr("src", "/images/kr/cm/btn_onbottomframe.gif");
		
		document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
		document.getElementById("divList").style.height = (CurrentHeight - 50) + "px";

	}

});

</script>
<body>
	<c:choose>
		<c:when test="${viewType eq 0 }">
			<div id="memoStyleDiv"
				style="height: 80%; width: 100%; overflow: auto; display: none;">
				<c:forEach items="${projectList }" var="project">
					<table id="${project.projectId }" class="projectList"
						style="margin: 10px 20px; float: left; position: relative; border: solid 1px gray; clear: none; width: 360px; left: 2%;">
						<tr>
							<th colspan="2" style="height: 30px; font-size: 15px;"><input
								type="checkbox" onchange="checkedCheckboxMemo(this);"
								name="memoCheckbox"
								style="margin: 0px; padding: 0px; width: 13px; height: 13px; cursor: pointer; float: left">
							<c:out value="${project.projectName }" /><img class="star"
								style="cursor: pointer; float: right;" draggable="false"
								src="/images/ImgIcon/view-flag.gif"
								onclick="addFavorite(${project.projectId })"></th>
						</tr>
						<tr onclick="selectedMemoTR(this);">
							<td colspan="2">&nbsp;&nbsp;<c:out
									value="${project.status }" /></td>
						</tr>
						<tr>
							<td colspan="2">&nbsp;</td>
						</tr>
						<tr onclick="selectedMemoTR(this);">

							<td colspan="2" style="text-align: center; font-size: 20px;"
								class="restDueday">D <c:choose>
									<c:when test="${project.restDueday ge 0 }">- <c:out
											value="${project.restDueday }" />
									</c:when>
									<c:otherwise>+ <c:out
											value="${-project.restDueday }" />
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
						<tr onclick="selectedMemoTR(this);">
							<td colspan="2" style="text-align: center">(<c:out
									value="${project.planStartDate }" /> ~ <c:out
									value="${project.planEndDate }" />)
							</td>
						</tr>
						<tr onclick="selectedMemoTR(this);">
							<td colspan="2">&nbsp;</td>
						</tr>
						<tr onclick="selectedMemoTR(this);">
							<td colspan="2">&nbsp;</td>
						</tr>
						<tr onclick="selectedMemoTR(this);">
							<td class="memoTd">&nbsp;&nbsp;총괄 담당자</td>
							<td><c:out value="${project.headManagerName }" /></td>
						</tr>
						<tr onclick="selectedMemoTR(this);">
							<td class="memoTd">&nbsp;&nbsp;전체 진행률</td>
							<td><div name="${project.projectId }"
									style="margin-right: 2px;"></div>&nbsp;
								<div style="margin-top: 5px; display: inline-block;">
									<c:out value="${project.progress }" />
								</div></td>

						</tr>
						<tr onclick="selectedMemoTR(this);">
							<td class="memoTd">&nbsp;&nbsp;완료된 업무</td>
							<td><div complete="${project.projectId }"
									style="margin-right: 2px;"></div>&nbsp;
								<div style="margin-top: 5px; display: inline-block;">
									<c:out value="${project.progress }" />
								</div></td>
						</tr>
						<tr onclick="selectedMemoTR(this);">
							<td class="memoTd">&nbsp;&nbsp;지연된 업무</td>
							<td><div overdue="${project.projectId }"
									style="margin-right: 2px;"></div>&nbsp;
								<div style="margin-top: 5px; display: inline-block;">
									<c:out value="${project.progress }" />
								</div></td>
						</tr>
					</table>
				</c:forEach>
			</div>
		</c:when>
		<c:otherwise>
			<span id="MailListRayer"
				style="border: 0px solid blue; vertical-align: top; overflow: hidden; display: none;">
				<div style="width: 100%; overflow: auto;" id="divList">
					<div id="lvBoardList">
						<table id="projectList" cellspacing="0" cellpadding="0"
							multiselectable="false" useocs="false"
							rowondblclick="ItemRead_onclick(this)" width="100%" border="0"
							class="mainlist" style="min-width: 569px;">
							<thead id="BoardList_THEAD">
								<tr id="BoardList_TH">
									<th id="BoardList_TH_0"
										style="text-align: left; overflow: hidden; white-space: nowrap; cursor: pointer; width: 20px;"
										class="h4_center" bgcolor="#CCCCCC"><input
										type="checkbox" id="HeaderAllCheckBox" name="boardCheckbox"
										id="HeaderAllCheckBox" onchange="selectedAllTR(this);"
										style="margin: 0px; padding: 0px; width: 13px; height: 13px; vertical-align: middle;">
									</th>
									<th id="BoardList_TH_1" onclick="setListOrder(this)" order="2"
										style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: *;"
										class="h5_center">프로젝트명</th>
									<th id="BoardList_TH_2" onclick="setListOrder(this)" order="6"
										style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 10%;"
										class="h5_center">총괄 담당자</th>
									<th id="BoardList_TH_3" onclick="setListOrder(this)" order="6"
										style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 10%;"
										class="h5_center">전체 진행률</th>
									<th id="BoardList_TH_4" onclick="setListOrder(this)" order="6"
										style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 10%;"
										class="h5_center">완료된 업무</th>
									<th id="BoardList_TH_5" onclick="setListOrder(this)" order="6"
										style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 10%;"
										class="h5_center">기한 지난 업무</th>
									<th id="BoardList_TH_6" onclick="setListOrder(this)" order="6"
										style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 10%;"
										class="h5_center">남은 기간</th>
									<th id="BoardList_TH_7" onclick="setListOrder(this)" order="6"
										style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 15%;"
										class="h5_center">프로젝트 기간</th>
									<th id="BoardList_TH_8" onclick="setListOrder(this)" order="6"
										style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 5%;"
										class="h5_center">상태</th>
								</tr>
							</thead>
							<tbody style="background-color: rgb(255, 255, 255);">
								<c:forEach items="${projectList }" var="project">
									<tr style="cursor: pointer;">
										<td style="width: 50px; cursor: default; text-align: center"><input
											type="checkbox" onchange="checkedCheckbox(this);"
											name="boardCheckbox"
											style="margin: 0px; padding: 0px; width: 13px; height: 13px; cursor: pointer;"></td>
										<td onclick="selectedTR(this);"
											style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;"><c:out
												value="${project.projectName }" /></td>
										<td onclick="selectedTR(this);"
											style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;"><c:out
												value="${project.headManagerName }" /></td>
										<td onclick="selectedTR(this);"
											style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;"><div
												name="${project.projectId }" style="margin-right: 2px;"></div>&nbsp;
											<div style="margin-top: 5px; display: inline-block;">
												<c:out value="${project.progress }" />
											</div></td>
										<td onclick="selectedTR(this);"
											style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;"><div
												complete="${project.projectId }" style="margin-right: 2px;"></div>&nbsp;
											<div style="margin-top: 5px; display: inline-block;">
												<c:out value="${project.progress }" />
											</div></td>
										<td onclick="selectedTR(this);"
											style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;"><div
												overdue="${project.projectId }" style="margin-right: 2px;"></div>&nbsp;
											<div style="margin-top: 5px; display: inline-block;">
												<c:out value="${project.progress }" />
											</div></td>
										<td onclick="selectedTR(this);"
											style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">D
											<c:choose>
												<c:when test="${project.restDueday ge 0 }">- <c:out
														value="${project.restDueday }" />
												</c:when>
												<c:otherwise>+ <c:out
														value="${-project.restDueday }" />
												</c:otherwise>
											</c:choose>
										</td>
										<td onclick="selectedTR(this);"
											style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;"><c:out
												value="${project.planStartDate }" /> ~ <c:out
												value="${project.planEndDate }" /></td>
										<td onclick="selectedTR(this);"
											style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;"><c:out
												value="${project.status }" /></td>
									</tr>
								</c:forEach>
							</tbody>

						</table>
					</div>
				</div> <c:choose>
					<c:when test="${paging.endPage>0 }">
						<div id="tblPageRayer" style="width: 470px; margin: 6px auto;">
							<div class="pagenavi">
								<c:choose>
									<c:when test="${paging.currentPage gt 1}">
										<span onclick="goToPageByNum(1)" class="btnimg"><img
											src="/images/sub/btn_p_prev.gif" width="16" height="16"></span>
									</c:when>
									<c:otherwise>
										<span class="btnimg"><img
											src="/images/sub/btn_p_prev01.gif" width="16" height="16"></span>
									</c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${paging.startPage gt 1}">
										<span onclick="goToPageByNum(${paging.startPage-1})"
											class="btnimg"><img src="/images/sub/btn_prev.gif"
											width="16" height="16"></span>
									</c:when>
									<c:otherwise>
										<span class="btnimg"><img
											src="/images/sub/btn_prev01.gif" width="16" height="16"></span>
									</c:otherwise>
								</c:choose>
								<span class="ptxt"
									onclick="<c:if test="${paging.currentPage gt 1 }">goToPageByNum(${paging.currentPage-1})</c:if>"><spring:message
										code='ezApproval.t931' /></span>
								<c:forEach begin="0" end="${paging.endPage-paging.startPage }"
									varStatus="status">
									<c:choose>
										<c:when
											test="${paging.startPage+status.index eq  paging.currentPage}">
											<span class="on">${paging.currentPage }</span>
										</c:when>
										<c:otherwise>
											<span
												onclick="goToPageByNum(${paging.startPage+status.index})">${paging.startPage+status.index}</span>
										</c:otherwise>
									</c:choose>
								</c:forEach>
								<span class="ptxt"
									onclick="<c:if test="${paging.totalPage gt paging.currentPage }">goToPageByNum(${paging.currentPage+1})</c:if>"><spring:message
										code='ezApproval.t932' /></span>
								<c:choose>
									<c:when test="${paging.totalPage gt paging.endPage }">
										<span class="btnimg"
											onclick="goToPageByNum(${paging.endPage+1})"><img
											src="/images/sub/btn_next.gif" width="16" height="16"></span>
									</c:when>
									<c:otherwise>
										<span class="btnimg"><img
											src="/images/sub/btn_next01.gif" width="16" height="16"></span>
									</c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${paging.totalPage gt paging.currentPage }">
										<span class="btnimg"
											onclick="goToPageByNum(${paging.totalPage})"><img
											src="/images/sub/btn_n_next.gif" width="16" height="16"></span>
									</c:when>
									<c:otherwise>
										<span class="btnimg"><img
											src="/images/sub/btn_n_next01.gif" width="16" height="16"></span>
									</c:otherwise>
								</c:choose>
							</div>
						</div>
					</c:when>
					<c:otherwise>
						<div id="tblPageRayer" style="width: 470px; margin: 6px auto;">
							<div class="pagenavi">
								<span class="btnimg"><img
									src="/images/sub/btn_p_prev01.gif" width="16" height="16"></span>
								<span class="btnimg"><img
									src="/images/sub/btn_prev01.gif" width="16" height="16"></span>
								<span class="ptxt"> <spring:message
										code='ezApproval.t931' /></span> <span class="on">1</span> <span
									class="ptxt"><spring:message code='ezApproval.t932' /></span> <span
									class="btnimg"><img src="/images/sub/btn_next01.gif"
									width="16" height="16"></span> <span class="btnimg"><img
									src="/images/sub/btn_n_next01.gif" width="16" height="16"></span>
							</div>
						</div>
					</c:otherwise>
				</c:choose>

			</span>

		</c:otherwise>
	</c:choose>
</body>
</html>