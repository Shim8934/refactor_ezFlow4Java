<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery.modal.css')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezWebFolder.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/popup.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezWebFolder/adminTable.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/adminFile.js')}"></script>
		<style>
			#listContentDIV tr{
			    cursor: pointer;
			}
			#listContentDIV tr#selectedRow{
		        background-color: #f1f8ff;
			}
			#listContentDIV tr:not(#nodataRow):not(#selectedRow):hover{
			    background-color: #f4f5f5;
			}
			#listContentDIV td {
				box-sizing: border-box;
				padding: 5px;
			}
			.wfAppformHTML div{
				box-sizing: border-box; padding: 5px;
			}
			.memList {
				width:100%; overflow:auto;
			}
			.memList ul {
				list-style: none; padding: 0;
			}
			.memList ul > li{
				box-sizing: border-box; padding: 5px;
			}
			#applicationPopup th {
				text-align: center;
			}
			#applicationPopup td {
				padding-left: 5px;
			}
			#applicationPopup li {
				padding-left: 0;
			}
		</style>
	</head>
	<body class="mainbody" style="overflow:auto; height:93%" onresize="reSizePage()">
		<h1>
			<spring:message code="ezWebFolder.ksa02"/>
			
			<span id="mailBoxInfo"><span class='txt_color'>0</span></span>
		</h1>
		
		<div id="companySelect" style="margin-left: 5px;">
			<span><b><spring:message code='ezWebFolder.t129'/></b></span>
			<select id="companyList" onChange="changeCompany()">
				<c:forEach var="item" items="${list}">
					<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
				</c:forEach>
			</select>
		</div>
		
		<div id="mainmenu" style="position: relative; margin-left: 5px;">
			<ul class="on">
				<div class="sub_frameIcon" style="float:right">
					<div class="sub_frameIconUL02" id="wfOptionDiv" style="margin: 0 !important; ">
					  	<p class="frameIconLI"><span mode="off" class="icon16 btn_arrow_down" id="webfolderlistoptiondiv" src="/images/kr/cm/btn_arrow_up.gif"></span></p>  
					</div>
				</div>
			</ul>
		</div>
		
		<div id="listTableWrapDIV" style="width:100%;">
			<div id="listTableWrap" style="margin:0px 0px 0px !important;" >
				<table class="mainlist" style="width:100%;" id="listHead">
					<tr>
						<th key="folderName">
							<spring:message code="ezWebFolder.ksa04"/>
						</th>
						<th key="applicantName"><spring:message code='ezWebFolder.ksa06'/></th>
						<th key="masterName"><spring:message code='ezWebFolder.ksa07'/></th>
						<th key="applicationDate"><spring:message code='ezWebFolder.ksa09'/></th>
						<th key="approvalStatus"><spring:message code='ezWebFolder.ksa64'/></th>
						<th key="scroll" id="forScroll" style="width: 14px; border-left: 0;"></th>
					</tr>
				</table>
				<div id="listContentDIV" style="overflow-y:auto; min-height:150px; ">
					<table class="mainlist" style="width:100%;" id="listContent"><tbody></tbody></table>
				</div>
			</div>
		</div>
		<div id="tblPageRayer" style="height:8%;"></div>
		<div class="wfFogPanel" style="display: none;" id="mailPanel" tabindex="0">&nbsp;</div>
		
		<div id="layer_Viewpopup" style="width: 250px; position: absolute; left: 1440px; top: 130px; background-color: rgb(255, 255, 255); display:none;">
	        <div class="popupwrap1">	
	            <div class="popupwrap2">
	                <table style="width: 100%; border-spacing: 0px; border-collapse: collapse; border: none;" class="list_element">
	                    <caption></caption>
	                    <colgroup>
	                        <col style="width: 90px;">
	                        <col>
	                    </colgroup>
	                    <tbody><tr>
	                        <th><spring:message code='ezWebFolder.t29' /></th>
	                        <td>
	                            <select id="listCount" class="wfListCnt" onChange="changeListCount(this.value)">
	                                <option value="10">10</option>
	                                <option value="20">20</option>
	                                <option value="30">30</option>
	                                <option value="40">40</option>
	                                <option value="50">50</option>
	                            </select>    
	                        </td>
	                    </tr>
	                </tbody></table>
	            </div>
	        </div>
	        <div class="shadow">
	        </div>
	 	</div>
	 	
	 	<div id="applicationPopup" class="popupwrap3" style="display:none;">
	 		<div class="popupJQLayer refusalPopUp">
				<div class="title"><spring:message code='ezWebFolder.ksa52' /></div>
				<div id="close">
		            <ul>
		                <li><a rel="modal:close"><span onclick="closePopUp()"></span></a></li>
		            </ul>
		        </div>
		        
		        <table class="content" style="margin-top:10px ">
		        	<tr>
		        		<th><spring:message code='ezWebFolder.ksa52' /></th>
		        		<td><input type="text" id="reasonCont" class="wfAppformINPUT" style="width:100%;" maxlength="200"></td>
		        	</tr>
		        </table>
		        
		        <table style="width:100%">
					<tr>
						<td style="text-align:center;">
							<div class="btnpositionLayer">
								<a class="imgbtn"><span onClick="appliRefusal()"><spring:message code='ezWebFolder.ksa46' /></span></a>
							</div>	
						</td>
					</tr>
				</table>
			</div>
			<div class="popupJQLayer detailPopUp">
				<div class="title"><spring:message code="ezWebFolder.ksa02"/></div>
				<div id="close">
		            <ul>
		                <li><a rel="modal:close"><span onclick="closePopUp()"></span></a></li>
		            </ul>
		        </div>
		        
		        <table class="content" style="margin-top:10px ">
		        	<tr>
		        		<th>
		        			<spring:message code="ezWebFolder.ksa04"/>
		        		</th>
		        		<td><div key="folderName" class="wfAppformHTML historyInfo"></div></td>
		        	</tr>
		        	<tr>
		        		<th>
		        			<spring:message code="ezWebFolder.ksa09"/>
		        		</th>
		        		<td><div key="applicationDate" class="wfAppformHTML historyInfo"></div></td>
		        	</tr>
		        	<tr>
		        		<th>
		        			<spring:message code="ezWebFolder.ksa66"/>
		        		</th>
		        		<td><div key="approvalStatusUpdateDt" class="wfAppformHTML historyInfo"></div></td>
		        	</tr>
		        	<tr>
		        		<th>
		        			<span><spring:message code="ezWebFolder.ksa06"/></span>
		        		</th>
		        		<td><div key="applicant" class="wfAppformHTML memList"></div></td>
		        	</tr>
		        	<tr style="height:80px;">
		        		<th>
		        			<span><spring:message code="ezWebFolder.ksa07"/></span>
		        			<br/>
		        			<span class="masterCnt"></span>
		        		</th>
		        		<td><div style="height:80px;" key="master" class="wfAppformHTML memList"></div></td>
		        	</tr>
		        	<tr style="height:80px;">
		        		<th>
		        			<span><spring:message code="ezWebFolder.ksa08"/></span>
		        			<br/>
		        			<span class="memberCnt"></span>
		        		</th>
		        		<td><div style="height:80px;" key="member" class="wfAppformHTML memList"></div></td>
		        	</tr>
		        	<tr style="height:150px;">
		        		<th>
		        			<spring:message code="ezWebFolder.ksa14"/>
		        		</th>
		        		<td><textarea readonly style="resize:none; border:none; height:150px; overflow:auto; box-sizing: border-box; padding: 5px 5px 5px 0;" key="content" class="wfAppformHTML historyInfo"></textarea></td>
		        	</tr>
		        </table>
		        
		        <table style="width:100%">
					<tr>
						<td style="text-align:center;">
							<div class="btnpositionLayer">
								<a class="imgbtn"><span onClick="closePopUp()"><spring:message code='main.t3' /></span></a>
							</div>	
						</td>
					</tr>
				</table>
			</div>
		</div>	
		
		<div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:5000;display:none;background:rgba(0,0,0,0.5)" id="dimPanel">
			<div id="listload_div" class="loadingBox2" style="z-index: 7500;">
				<div class="loader loader-3">
					<div class="dot dot1"></div>
					<div class="dot dot2"></div>
					<div class="dot dot3"></div>
					<div class="dot dot4"></div>
				</div>
			</div>
		</div>
	</body>
	
	<script type="text/javascript" >
		var p_companyId = "${userCompany}";
		var approvalMsg = "<spring:message code='ezWebFolder.ksa45' />";
		var approvalMsg2 = "<spring:message code='ezWebFolder.ksa62' />";
		var RefusalMsg = "<spring:message code='ezWebFolder.ksa46' />";
		var RefusalMsg2 = "<spring:message code='ezWebFolder.ksa63' />";
		var peopleMsg = "<spring:message code='ezWebFolder.ksa65' />";
		var companyId = p_companyId;
		var p_pageNum = 1;
		var p_pageListSize = 10;
		var p_pageBtnSize = 10;
		
		var now_pageNum = p_pageNum;
		var pageListSize = p_pageListSize;
		
		var now_btnNum = 1;
		var pageBtnTotalSize = 1;
		
		var app_TotalSize = 0;
		var app_historyList = null;
		var listHead_TH_Key = []; // table header is data keys
		var leftFrame = parent.frames["left"];
		
		window.onload = function() {
			listHead(); // 선행작업
			cssListCountPopUp();
			
			reSizePage();
			changeCompany();
		}
		
		function listHead() {
			listHead_TH_Key = [];
			
			var listHead_TH = document.getElementById("listHead").children[0].children[0].children;
			for (var i=0; i < listHead_TH.length; i++) {
				var kk = listHead_TH[i].getAttribute("key");
				
				if (kk != "scroll") {
					listHead_TH_Key.push(kk);
				}
			}
		}
		
		function cssListCountPopUp() {
			var a_left = $("#wfOptionDiv").offset().left - ($("#layer_Viewpopup").width() - $("#wfOptionDiv").width());
			var a_top = $("#wfOptionDiv").offset().top + $("#wfOptionDiv").outerHeight() + 2
			
			$("#layer_Viewpopup").css({"left":a_left, "top":a_top});
		}
		function changeListCount(val) {
			clearPage();
			
			pageListSize = val;
			getAppliHisotryList();
			$("#wfOptionDiv").click();
		}
		
		function clearPage() {
			now_pageNum = 1;
			now_btnNum = 1;
		}
		
		function changeCompany() {
			companyId = $("#companyList").val();
			clearPage();
			getAppliHisotryList();
		}
		
		function getAppliHisotryList() {
			$.ajax({
				type: "post",
				async : false,
				url: "/admin/ezWebFolder/getApplicationHistoryList.do",
				dataType: "json",
				data: {
					companyId : companyId,
					pageNum  : now_pageNum,
					pageListSize : pageListSize
				}, success: function(data) {
					if (data.status == "OK") {
						app_TotalSize = data.totalSize;
						app_historyList = JSON.parse(data.historyList);
						
						setAppliHistoryList();
						makePagination();
					} else {
						alert("<spring:message code='ezWebFolder.ksa23' /> : " + data.status);
					}
				}, error: function(e) {
					alert("<spring:message code='ezWebFolder.ksa23' /> : " + e);
				}
			});
		}

		function getAppliHisotry() {
			var selectedRow = document.getElementById("selectedRow");
			if (selectedRow == null) {return; }
			
			var applyId = selectedRow.getAttribute("applyid");
			
			$.ajax({
				type: "post",
				url: "/admin/ezWebFolder/getApplicationHistory.do",
				dataType: "json",
				data: {
					applyId : applyId
				}, success: function(data) {
					if (data.status == "OK") {
						setAppliHistory(data.appHistory, data.appHistoryMember);
						showPopUp("detailPopUp");
					} else {
						alert("<spring:message code='ezWebFolder.ksa23' /> : " + data.status);
					}
				}, error: function(e) {
					alert("<spring:message code='ezWebFolder.ksa23' /> : " + e);
				}, complete : function() {
					clickChk = false;
				}
			});
		}
		
		function setAppliHistoryList() {
			$("#mailBoxInfo span").text(app_TotalSize);
			
			var listTbody = document.querySelector("#listContent tbody");
			listTbody.innerHTML = "";
			
			var approvalBtn_A_Node = document.createElement("A");
			approvalBtn_A_Node.classList.add("imgbtn", "imgbck");
			var approvalBtn_SPAN_Node = document.createElement("SPAN");
			approvalBtn_A_Node.appendChild(approvalBtn_SPAN_Node);
			
			if (app_historyList.length > 0) {
				$.each(app_historyList, function(i, e) {
					var listTR = document.createElement("TR");
					listTR.setAttribute("applyId", e["applyId"]);
					
					for (var j=0; j < listHead_TH_Key.length; j++) { // make TD
						var kk = listHead_TH_Key[j];
						var kkVal = e[kk];
						
						if (kk == "masterName") { // 관리자
							var masterCnt = parseInt(e["masterCnt"]) - 1;
							if (masterCnt > 0) {
								var others = "<spring:message code='ezWebFolder.ksa38' />";
								kkVal += others.replace("\'%s\'", masterCnt);
							}
						} else if (kk == "approvalStatus") { // 승인 상태
							var approvalBtnTemp;
						
							if (kkVal == null || kkVal == "") {
								var tmp = "<a class=\"imgbtn imgbck apprBtn\" style=\"margin-right: 3px;\" data-type=\"approval\"><span>"+approvalMsg+"</span></a>";
								tmp += "<a class=\"imgbtn imgbck apprBtn\" data-type=\"refusal\"><span>"+RefusalMsg+"</span></a>";
								
								approvalBtnTemp = tmp;
							} else {
								var spanTxt = (kkVal == "Y") ? approvalMsg2 : RefusalMsg2;
								approvalBtnTemp = "<span>"+spanTxt+"</span>";	
							}
							
							kkVal = approvalBtnTemp;
						}
						
						var listTD = document.createElement("TD");
						listTD.innerHTML = kkVal;

						listTR.appendChild(listTD);
					}

					listTbody.appendChild(listTR); // append TR
				});
			} else  {
				var listTR = document.createElement("TR");
				listTR.setAttribute("id", "nodataRow");
				listTR.style.textAlign = "center";
				listTR.style.cursor = "default";
				
				var listTD = document.createElement("TD");
				listTD.setAttribute("cellspan", listHead_TH_Key.length);
				listTD.textContent = "<spring:message code='ezWebFolder.t144' />";
				
				listTR.appendChild(listTD);
				listTbody.appendChild(listTR);
			}
			
			scroll();
		}
		
		function setAppliHistory(history, historyMember) {
			var historyJson = JSON.parse(history);
			var historyMemJson = JSON.parse(historyMember);
			
			var historyInfoDIV = document.getElementsByClassName("historyInfo");

			$.each(historyInfoDIV, function(i, e) { // info   
				var kk = e.getAttribute("key");
				var kkVal = historyJson[kk];
				kkVal = kkVal == null ? "" : kkVal;
				
				e.innerHTML = kkVal;
			});
			
			var applicantListDiv = document.querySelector(".memList[key='applicant']");
			var masterListDiv = document.querySelector(".memList[key='master']");
			var memeberListDiv = document.querySelector(".memList[key='member']");
			var masterCntSpan = document.querySelector(".masterCnt");
			var memeberCntSpan = document.querySelector(".memberCnt");
			var aUL = document.createElement("UL");
			var msUL = document.createElement("UL");
			var mUL = document.createElement("UL");
			var msCnt = 0, mCnt = 0;
			
			$.each(historyMemJson, function(i, e) { // member
				var memItem = e["memberItem"];
			
				var memListLI = document.createElement("LI");
				memListLI.textContent = e["memberName"];
				
				switch(memItem) {
					case "a" : aUL.appendChild(memListLI); 
					break;
					case "ms" : 
						msUL.appendChild(memListLI); 
						msCnt++;
					break;
					case "m" : 
						mUL.appendChild(memListLI);
						mCnt++;
					break;
				}
			});
			
			var msTxt = msCnt == 0 ? "" : "(" + msCnt + peopleMsg + ")";
			var mTxt = mCnt == 0 ? "" : "(" + mCnt + peopleMsg + ")";
			masterCntSpan.innerText = msTxt;
			memeberCntSpan.innerText = mTxt;

			applicantListDiv.appendChild(aUL);
			masterListDiv.appendChild(msUL);
			memeberListDiv.appendChild(mUL);
		}
		
		function showPopUp(popType) {
			$("#applicationPopup > div").css("display", "none");
			$("#applicationPopup > ." + popType).css("display", "");
			
			showPopUpModal();
		}
		
		function showPopUpModal(w, h) {
			if (typeof leftFrame.dimBlockLeft == "undefined") {
				$("<div id=\"dimBlockLeft\" class=\"blockLeft\" style=\"width:100%; height:100%; display: none; z-index: 10;\"></div>").appendTo(leftFrame.document.body);
			}
	    	leftFrame.dimBlockLeft.style.display = "block";
	    	var popupX = parent.document.body.clientWidth / 2 - (500 / 2) - 220;
	    	$("#applicationPopup").css("left", popupX);
	    	
	    	$("#applicationPopup").modal();
	    	$("#applicationPopup").off("modal:close").on("modal:close", function() {
	    		clearPopUp();
	    		leftFrame.dimBlockLeft.style.display = "none";
	    	});
		}

		function clearPopUp() {
			$(".wfAppformHTML").html("");
			$(".wfAppformINPUT").val("");
			$(".masterCnt, .memberCnt").text("");
		}
		
		function closePopUp() {
			clearPopUp();
	    	$.modal.close();
	    }
		
		function reSizePage() {
			var divList          = document.getElementById("listContentDIV");
			var reheight         = document.documentElement.clientHeight - 240;
			divList.style.height = reheight + "px";
			
			scroll();
			cssListCountPopUp();
		}
		
		function scroll() {
			var listContentDIV_H = document.getElementById("listContentDIV").clientHeight;
			var listContent_H = document.getElementById("listContent").clientHeight;
			
			 if (listContent_H > listContentDIV_H) {
				$("#listHead th#forScroll").css("display","table-cell");
			} else {
				$("#listHead th#forScroll").css("display","none");
			}
		}
		
		function setPage(pageNum) {
			$("span[class='on']").removeClass();
			$(this).addClass("on");
			
			now_pageNum = pageNum;
			now_btnNum = Math.ceil(now_pageNum / p_pageBtnSize);
			
			getAppliHisotryList();
		}
		
		function makePagination() {
			pageBtnTotalSize = Math.ceil(app_TotalSize / pageListSize);
			pageBtnTotalSize = pageBtnTotalSize == 0 ? 1 : pageBtnTotalSize;
			
			var sNum = (now_btnNum * p_pageBtnSize) - (p_pageBtnSize-1);
			var eNum = (sNum + (p_pageBtnSize-1));
				eNum = eNum >= pageBtnTotalSize ? pageBtnTotalSize: eNum;
			
			var pageNaviRayerDIV = $("#tblPageRayer");
			var pageNaviDiv = $("<div class='pagenavi'></div>");
				
			var pPrevSpan = $("<span class='btnimg first disabled'></span>");
			var prevSpan = $("<span class='btnimg prev disabled'></span>");
			var nextSpan = $("<span class='btnimg next disabled'></span>");
			var nNextSpan = $("<span class='btnimg last disabled'></span>");

			$(pPrevSpan).click(function() {setPage(1) });
			$(nNextSpan).click(function() { setPage(pageBtnTotalSize) });
			
			if (now_pageNum > 1) {
				$(prevSpan).click(function() {setPage(now_pageNum-1) });
			}
			if (now_pageNum < pageBtnTotalSize) {
				$(nextSpan).click(function() {setPage(now_pageNum+1) });
			}
			
			$(pPrevSpan).appendTo(pageNaviDiv);
			$(prevSpan).appendTo(pageNaviDiv);
			for (var i=sNum; i <= eNum; i++) {
				var numSpan = $("<span onClick='setPage("+i+")'>" + i + "</span>");
				
				if (i == now_pageNum) {
					$(numSpan).attr("class","on");
				}
				$(numSpan).appendTo(pageNaviDiv);
			}
			$(nextSpan).appendTo(pageNaviDiv);
			$(nNextSpan).appendTo(pageNaviDiv);

			$(pageNaviRayerDIV).html("");
			$(pageNaviRayerDIV).prepend(pageNaviDiv);
		}
		
		function appliApproval(applyId) {
			if (confirm("<spring:message code='ezWebFolder.ksa47'/>")) {
				
				setDim(true);
				var sTimeOut = setTimeout(function() {
					$.ajax({
						type: "post",
						url: "/admin/ezWebFolder/setApprovalToApplyForOpening.do",
						async: false,
						dataType: "json",
						data: {
							applyId : applyId
						}, success: function(data) {
							if (data.status == "OK") {
								alert("<spring:message code='ezWebFolder.ksa49' />");
								setApprovalBtn(true, applyId);
							} else if (data.status == "DUPLICATE_FOLDER_NAME") {
								alert("<spring:message code='ezWebFolder.ksa51' />");
							} else {
								alert("<spring:message code='ezWebFolder.ksa23' /> : " + data.status);
							}
						}, error: function(e) {
							alert("<spring:message code='ezWebFolder.ksa23' /> : " + e);
						}
					});
					
					setDim(false);
					clearTimeout(sTimeOut);
				}, 500);
			}
		}

		function appliRefusal() {
			var applyId = $(".refusalPopUp").attr("applyid");
			var reasonCont = $("#reasonCont").val();
			
			if (confirm("<spring:message code='ezWebFolder.ksa48'/>")) {

				closePopUp();
				setDim(true);
				var sTimeOut = setTimeout(function() {
					$.ajax({
						type: "post",
						url: "/admin/ezWebFolder/setRefusalToApplyForOpening.do",
						async: false,
						dataType: "json",
						data: {
							applyId : applyId,
							reasonCont : reasonCont
						}, success: function(data) {
							if (data.status == "OK") {
								alert("<spring:message code='ezWebFolder.ksa50' />");
								setApprovalBtn(false, applyId);
							} else {
								alert("<spring:message code='ezWebFolder.ksa23' /> : " + data.status);
							}
						}, error: function(e) {
							alert("<spring:message code='ezWebFolder.ksa23' /> : " + e);
						}
					});
					
					setDim(false);
					clearTimeout(sTimeOut);
				}, 500);
			}
		}

		function appliRefusalPopUp(applyId) {
			$(".refusalPopUp").attr("applyid", applyId);
			showPopUp("refusalPopUp");
		}
		
		function setApprovalBtn(status, applyId) { // true = approval, false=refusal
			var chgTd = $("#listContentDIV tr[applyid='"+applyId+"'] td:last-child")[0];
			
			var spanTxt = (status) ? approvalMsg2 : RefusalMsg2;
			$(chgTd).html("<span>"+spanTxt+"</span>");
		}
		
		function setDim(dim) {
			var dimPanelDIV = document.getElementById("dimPanel");
			
			if (!!leftFrame) {
				if (typeof leftFrame.dimBlockLeft == "undefined") {
					$("<div id=\"dimBlockLeft\" class=\"blockLeft\" style=\"width:100%; height:100%; display: none; z-index: 10;\"></div>").appendTo(leftFrame.document.body);
				}
			}
			
			if (dim) {
				dimPanelDIV.style.display = "block";
				if (!!leftFrame) {
					leftFrame.dimBlockLeft.style.display = "block";
				}
			} else {
				dimPanelDIV.style.display = "none";
				if (!!leftFrame) {
					leftFrame.dimBlockLeft.style.display = "none";
				}
			}
		}
		
		var clickChk = false;
		$(document).on("click", "#listContent tr:not(#nodataRow)", function() {
			$("#listContent tr").removeAttr("id");
			$(this).attr("id", "selectedRow")
		}).on("dblclick", "#listContent tr:not(#nodataRow)", function() {
			if (clickChk) {return; }
			
			clickChk = true;
			getAppliHisotry();
		}).on("click", "#wfOptionDiv", function() {
			optionView($(this).find("span")[0]);
		}).on("click", ".apprBtn", function() {
			var applyId = $(this).parents("tr").attr("applyid");
			var type = $(this).attr("data-type");
			var appFun = type == "approval" ? appliApproval : appliRefusalPopUp;
			
			appFun(applyId);
		});
		
	</script>
</html>
