<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>회람 상세정보</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="<spring:message code="ezResource.e2" />" type="text/css" />
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="<spring:message code='ezResource.e1'/>"></script>
		<script type="text/javascript" src="/js/ezResource/datepicker.htc_cross.js"></script>
		<script type="text/javascript" src="/js/ezResource/composeappt_cross.js"></script>
		<script type="text/javascript" src="/js/ezResource/Schedule_cross.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" >
		 	var g_data = new Array();
		 	//writerID trim
	        var writerIDVal = '${writerID}';
	        var org_ownerNM = "${ownerNm}";
	        var org_deptNM = "${deptNm}";
	        var org_num = '${num}';
	        var org_ownerID = "${ownerID}";
	        var ss_companyID = '${userInfo.companyID}';
	        var org_companyID = ss_companyID;
	        var pAdminFg = "${adminFg}";
	        var s_userID = '${userInfo.id}';
	        var org_brdName = "${brdName}";
	        var iReFlag = "${reFlagVal}";
	        var pUse_Editor = "${useEditor}";
	        var typeVal = '${typeVal}';
	        var startDateVal = '${startDateVal}';
	        var endDateVal = '${endDateVal}';
	        var sDT = "${startDateTime}";
	        var eDT = "${endDateTime}";
	        var ApproveFlag = "${approveFlag}";
	        var SavedApproveFlag = "${saveApproveFlag}";
	        var reFlagVal = '${reFlag}';
	        var server_name = "${serverName}";
	        var pnumVal = '${pNum}';
	        var gFlagVal = '${gresFlag}';
	        var g_fromStr = '${fromStr}';
	        var allDayFlag = "${allDay}";
	        var ItemArray = new Array();
	        var pNoneActiveX = "${pNoneActiveX}";
	        var brdName = "${brdName}";
	        var resID = "${resID}";
	        // var contentpath = "/doc/{b70a579c-1468-4b93-9ec8-3bd42ba738cc}";
	        
	        window.onload = function () {
	        	
	            //document.getElementById("displayNM").innerHTML = "<a href=# onClick=MemberInfo_onClick('" + writerIDVal + "')>" + org_ownerNM + "</a> (" + org_deptNM + ")";
	            document.getElementById('itemList').innerHTML = "${listUser}";
	            
	            if (brdName != "" && resID != "") {
	                ItemArray[0] = Array(resID);
	                ItemArray[1] = Array(brdName);
	                //document.getElementById('itemList').innerHTML = "${brdName}";
	            }
	            
	            document.getElementById("divCross").innerHTML = sigBody.innerHTML
	            var Bodytd = document.getElementById("divCross").getElementsByTagName("TD");
	            for (var i = 0; i < Bodytd.length; i++) {
	                if (Bodytd[i].width != "") {
	                    Bodytd[i].style.width = Bodytd[i].width + "px";
	                }
	                if (Bodytd[i].height != "") {
	                    Bodytd[i].style.height = Bodytd[i].height + "px";
	                }
	            }
	            
	            document.getElementById("divCross").style.width = document.getElementById("mainbodytag").offsetWidth - 24 + "px";
	            document.getElementById("divCross").style.height = window.innerHeight - 265 + "px";
	        }
			
	        window.onresize = function () {
	        	document.getElementById("divCross").style.width = document.getElementById("mainbodytag").offsetWidth - 24 + "px";
	        	document.getElementById("divCross").style.height = window.innerHeight - 220 + "px";
	        }
			
		    //수정버튼 클릭시
	        function btn_modify() {
		    	var circularID = "${result.circularId}";

	            window.location.href = "/ezCircular/circularModify.do?circularID="+circularID+"&num=" + org_num + "&ownerID=" + org_ownerID + "&type=" + typeVal + "&startDate=" + startDateVal + "&endDate=" + endDateVal + "&brdName=" + encodeURIComponent(org_brdName);
	        }

	        function window_onUnload() {
	            if (window.dialogArguments == undefined) {
	                if (window.opener != null && g_fromStr == "schedule" && trim(s_userID) != "") {
	                    window.opener.btnRefresh_onclick();
	                }
	                else if (window.opener != null && g_fromStr == "schedule2" && trim(s_userID) != "") {
	                    window.opener.parent.main.document.location.reload();
	                }
	                else if (window.opener != null && g_fromStr == "frame" && trim(s_userID) != "") {
	                    window.opener.document.all.iframeWin2.document.location.reload();
	                }
	                else if (window.opener != null && g_fromStr == "frame2" && trim(s_userID) != "") {
	                    window.opener.document.all.iframeWin.document.location.reload();
	                }
	                else if (window.opener != null && g_fromStr == "todaySchedule" && trim(s_userID) != "") {
	                    window.opener.location.reload();
	                }
	            }
	        }
	        
	        function print_onClick2(printTrueFalse) {
	            g_printTrueFalse = printTrueFalse;
	            
	            document.getElementById("printDocument").innerHTML = sigBody.innerHTML;
	            
	            onbeforeprint2();

	            var feature = GetOpenPosition(700, 700);
	            printWindow = window.open("", "mywindow", "width=700, height=700,location=0,status=0,scrollbars=1,resizable=1" + feature);
	            var strContent = "<html><head>";
	            strContent = strContent + "<title>" + strLangLHM02 + "</title>";
	            strContent = strContent + "<link rel=\"stylesheet\" href=\"/css/" + strLangLHM01 + ".css\" type=\"text/css\" />";
	            strContent = strContent + "</head><body style='padding:10px;'onload='window.print();' >";
	            strContent = strContent + "<div style='width:100%'><table id='printScreen' class='layout'>";
	            strContent = strContent + document.getElementById("printScreen").innerHTML;
	            strContent = strContent + "</table></div>";
	            strContent = strContent + "</body>";
	            printWindow.document.write(strContent);
	            printWindow.document.close();
	            printWindow.focus();
	        }

	        function onbeforeprint2() {
	            document.getElementById("printOwner").textContent = document.getElementById("displayNM").textContent;
	            document.getElementById("printImportance").textContent = document.getElementById("importanceDIV").textContent;
	            /* document.getElementById("printDate").textContent = document.getElementById("AllDayDisplay").textContent; */
	            document.getElementById("printTitle").textContent = document.getElementById("titleDIV").textContent;
	        }

	        function SetApproval_onClick2(pCmd, pFlag) {
	            var msg = ""
	            if (pFlag == "1") {
	                msg = "" + strLang176 + "";
	            } else {
	                msg = "" + strLang177 + "";
	            }

	            var result = confirm(msg);
	            if (result) {
	                if (bDupCheck == true && pFlag == "1") {
	                    var STime = "";
	                    var ETime = "";

	                    var AllDayCheck;
	                    if (allDayFlag == "1") {
	                        STime = startDateVal + " 00:00:01";
	                        ETime = endDateVal + " 23:59:59";
	                        AllDayCheck = true;
	                    } else {
	                        AllDayCheck = false;
	                    }

	                    var bUsingResource = isUsingResource(ownerID.value, "${checkSDT}", "${checkEDT}", ss_companyID, num.value, pCmd, AllDayCheck);
	                    if (bUsingResource) {
	                        alert("" + strLang141 + "");
	                        return;
	                    }
	                }
	                
	                var xmlHTTP = createXMLHttpRequest();
	                var xmlDOM = createXmlDom();
	                var objNode;

	                createNodeInsert(xmlDOM, objNode, "DATA");
	                createNodeAndInsertText(xmlDOM, objNode, "COMPANYID", ss_companyID);
	                createNodeAndInsertText(xmlDOM, objNode, "RESID", document.getElementById("ownerID").value);
	                createNodeAndInsertText(xmlDOM, objNode, "NUM", document.getElementById("num").value);
	                createNodeAndInsertText(xmlDOM, objNode, "APPROVE", pFlag);

	                xmlHTTP.open("POST", "/ezResource/updateApprovalFlag.do", false);
	                xmlHTTP.send(xmlDOM);

	                var rtnValue = xmlHTTP.responseText;


	                xmlHTTP = null;

	                if (rtnValue == "True") {
	                    xmlHTTP = createXMLHttpRequest();
	                    xmlHTTP.open("POST", "/ezResource/sendmailToUser.do", false);
	                    xmlHTTP.send(xmlDOM);
	                    var ResponseXML = xmlHTTP.responseXML;
	                    xmlHTTP = createXMLHttpRequest();
	                    xmlHTTP.open("POST", "/ezEmail/remote/mailSendNoti.do", false);
	                    xmlHTTP.send(ResponseXML);
	                    xmlHTTP = null;
	                    alert("" + strLang33 + "");
	                } else {
	                    alert("" + strLang178 + "");
	                }

	                xmlDOM = null;
	                
	                if (window.opener != null) {
	                    window.opener.btnRefresh_onclick();
	                }
	                window.close();
	            }
	        }

	        function MemberInfo_onClick(pSelUserID) {
	            var c_Width = 420;
	            var c_Height = 438;

	            //스크린의 크기
	            var s_Width = screen.availWidth;
	            var s_Height = screen.availHeight;

	            //열 창의 포지션
	            var px = (s_Width - c_Width) / 2;
	            var py = (s_Height - c_Height) / 2;

	            if (pSelUserID != "") {
	                window.open("/ezCommon/showPersonInfo.do?id=" + pSelUserID, "", "left=" + px + ",top=" + py + ",height=" + c_Height + "px,width=" + c_Width + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
	            }
	        }  
		</script>
	</head>
	
 	<xmp id="sigBody" style="display: none;">${result.content}</xmp>
 	
	<body id="mainbodytag" class="popup" style="height: 100%; overflow:hidden;">
    	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		
	    <table id="normalScreen" class="layout">
    	    <tr>
        	    <td style="height: 20px">
            	    <div id="menu">
                	    <ul>
                        	<li id="btn_modify"><span onclick="btn_modify()">수정</span></li>
                        	<li id="deletebtbn"><span onclick="delSchedule_onClick('${num}','${ownerID}')">삭제</span></li>
                        	<li><span>회람종료</span></li>
	                        <li><span onclick="print_onClick2( false )">인쇄</span></li>
                    	</ul>
                	</div>
                	<div id="close">
	                    <ul>
    	                    <li><span onclick="window.close();"><spring:message code='ezResource.t150' /></span></li>
        	            </ul>
            	    </div>
            	    
            	    <script type="text/javascript" >
		      			selToggleList(document.getElementById("menu"), "ul", "li", "0");
		      			selToggleList(document.getElementById("close"), "ul", "li", "0");
		  			</script>
            	    
					<table class="content">
	                    <tr>
    	                    <th style="width: 70px;">제목</th>
        	                <td colspan="3" style="width: 100%">
            	                <!-- <div id="displayNM"></div> -->
            	                ${result.title}
                	        </td>
                    	</tr>
                    	<tr>
	                        <th>중요도</th>
    	                    <!-- <td colspan="3"><span id="AllDayDisplay"></span></td> -->
    	                    <td colspan="3">${result.importance == '0' ? '일반' : '중요'}</td>
                    	</tr>
		        		<tr>
		            		<th>옵션</th>
		            		<td colspan="3" style="width: 100%">
		                		<c:choose>
		                			<c:when test="${result.option eq '0'}">
		                				<input type="checkbox" id="option" checked onClick="display_time_Unshow()" />댓글기능 사용
		                				<input type="checkbox" id="AllDay" onClick="display_time_Unshow()" />메일공지 사용
		                			</c:when>
		                			<c:when test="${result.option eq '1'}">
		                			<input type="checkbox" id="option" onClick="display_time_Unshow()" />댓글기능 사용
		                				<input type="checkbox" id="AllDay" checked onClick="display_time_Unshow()" />메일공지 사용
		                			</c:when>
		                			<c:otherwise>
		                				<input type="checkbox" id="option" checked onClick="display_time_Unshow()" />댓글기능 사용
										<input type="checkbox" id="AllDay" checked onClick="display_time_Unshow()" />메일공지 사용
		                			</c:otherwise>
		                		</c:choose>
							</td>
		        		</tr>
		        		<tr>
		            		<th>회람자</th>
		            		<td colspan="7" id="itemList" style="padding-left: 4px;"></td>
		        		</tr>
		        		<tr>
		            		<th>상태</th>
		            		<td colspan="3">
		                		<div id="titleDIV">${result.status == '0' ? '진행중' : '종료'}</div>
		            		</td>
		        		</tr>
	        			<tr style="height:100%">
	            			<td colspan="4" style="height:100%;">
	                 			<div id="divCross" style="overflow:auto;"></div>
	            			</td>
	        			</tr>
	        			
	        			<tr>
                		    <!-- <td height="20"> -->
			                    <table class="file">
			                        <tr>
			                            <th>
			                                <spring:message code='ezSchedule.t316' />
			                            </th>
			                            <td class="pos1">
			                                <div id="attachedfileDIV" style="margin-top: 0px; overflow: auto; padding-top: 0px;height: 50px;" align="left">	                                
			                                    <!-- <asp:Literal ID="LiteralAttach" runat="server"></asp:Literal> -->	                                    
			                                    <c:forEach var="item" items="${attachList}" varStatus="status">
			                                    	<div style="margin-top:3px;height:20px">
			                                    		<c:set var="imagePath" value="/images/file.gif" />
			                                    		<input type="checkbox" filename="${item.fileEncodeName}" filepath="${item.filePath}">
			                                    		<c:if test="${item.fileType == 'jpg' || item.fileType == 'jpeg' || item.fileType == 'bmp' || item.fileType == 'gif' || item.fileType == 'png' || item.fileType == 'tif' || item.fileType == 'tiff'}">
			                                    			<c:set var="imagePath" value="/images/image.png" />
			                                    		</c:if>
			                                    		<c:if test="${item.fileType == 'doc' || item.fileType == 'docx'}">
			                                    			<c:set var="imagePath" value="/images/doc.png" />
			                                    		</c:if>
			                                    		<c:if test="${item.fileType == 'xls' || item.fileType == 'xlsx'}">
			                                    			<c:set var="imagePath" value="/images/xls.png" />
			                                    		</c:if>
			                                    		<c:if test="${item.fileType == 'ppt' || item.fileType == 'pptx' || item.fileType == 'pps' || item.fileType == 'ppsx'}">
			                                    			<c:set var="imagePath" value="/images/ppt.png" />
			                                    		</c:if>
			                                    		<c:if test="${item.fileType == 'txt'}">
			                                    			<c:set var="imagePath" value="/images/txt.png" />
			                                    		</c:if>
			                                    		<c:if test="${item.fileType == 'zip'}">
			                                    			<c:set var="imagePath" value="/images/zip.png" />
			                                    		</c:if>
			                                    		<c:if test="${item.fileType == 'pdf'}">
			                                    			<c:set var="imagePath" value="/images/pdf.png" />
			                                    		</c:if>
			                                    		<c:if test="${item.fileType == 'ecm'}">
			                                    			<c:set var="imagePath" value="/images/ecm.png" />
			                                    		</c:if>	                                    		
			                                    		<img src="${imagePath}" />&nbsp;<a href="/ezSchedule/downloadAttach.do?fileName=${item.fileEncodeName}&filePath=${item.filePath}" id="regData_${status.count}">${item.fileName} (${item.fileTranSize})</a>	                                    		
			                                    	</div>
			                                    </c:forEach>
			                                </div>
			                            </td>
			                            <td class="pos2">	                                
			                                <a href="#" class="imgbtn">
			                                	<span style="width:57px;" onclick="attach_SelectAll()"><spring:message code='ezSchedule.t317' /></span>
			                                </a><br/>	                                
			                                <a href="#" class="imgbtn">
			                                	<span style="width:57px;" onclick="attach_Download()"><spring:message code='ezSchedule.t157' /></span>
			                                </a>
			                            </td>
			                        </tr>
			                    </table>
			                <!-- </td> -->
	            		</tr>
	        			
	        		</table>
	        	</td>
        	</tr>
		</table>
		
		<input type="hidden" id="iReFlag" value="${reFlagVal}" />
		<input type="hidden" id="tmpReFlag" value="${tmpReFlag}" />
		<input type="hidden" id="gresFlag" value="${gresFlag}" />
		<input type="hidden" id="num" value="${num}" />
		<input type="hidden" id="pnum" value="${pNum}" />
		<input type="hidden" id="ownerID" value="${ownerID}" />
		<input type="hidden" id="writerID" value="${writerID}" />

		<table id="printScreen" style="display: none;">
			<tr style="text-align:center">
				<td style="vertical-align:top">
					<table style="width:100%; border:0px; padding:1px; border-collapse:collapse; border-spacing:0px; " class="content2">
						<tr style="height:25px"> 
 							<th style="padding-left:10px" width="80"><spring:message code='ezResource.t193' /></th> 
 							<td style="padding-left:10px"> <div id="printOwner"></div></td> 
						</tr> 
						<tr style="height:25px"> 
 							<th style="padding-left:10px"><spring:message code='ezResource.t213' /></th> 
 							<td style="padding-left:10px"> <div id="printImportance"></div></td> 
						</tr> 
						<tr style="height:25px"> 
 							<th style="padding-left:10px"><spring:message code='ezResource.t197' /></th> 
 							<td style="padding-left:10px"> <div id="printDate"></div></td> 
						</tr> 
						<tr style="height:25px"> 
 							<th style="padding-left:10px"><spring:message code='ezResource.t224' /></th> 
 							<td style="padding-left:10px"> <div id="printTitle"></div></td> 
						</tr> 
						<tr> 
 							<td colspan="2"> <div align="left" id="printDocument" style="PADDING-RIGHT: 5px; PADDING-LEFT: 5px; PADDING-BOTTOM: 5px; WIDTH: 100%; PADDING-TOP: 5px;"></div></td> 
						</tr> 
					</table>
				</td>
			</tr>
		</table>
	</body>
</html>