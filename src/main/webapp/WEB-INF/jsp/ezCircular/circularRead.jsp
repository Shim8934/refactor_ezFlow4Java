<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCircular.t111'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="<spring:message code="ezCircular.c1" />" type="text/css" />
		<script type="text/javascript" src="<spring:message code='ezCircular.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="<spring:message code='ezResource.e1'/>"></script>
		<script type="text/javascript" src="/js/ezResource/composeappt_cross.js"></script>
		<script type="text/javascript" src="/js/ezResource/Schedule_cross.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/ezCircular/circularComment.js"></script>
		<script type="text/javascript" src="/js/ezCircular/circular.js"></script>
		
		<style>
			#btnCircularConfirm {
				display: inline-block;
			    background: url(/images/kr/cm/btn_popup_onright.gif) no-repeat center;
			    height: 23px;
			    padding: 0px 6px 0px 6px;
			    line-height: 24px;
			    font-size: 12px;
			    color: #333;
			    cursor : pointer;
			    border: 1px solid;
			}
		</style>
		
		<script type="text/javascript" >
			var circularID = "${result.circularID}";
			var circularUserID = "${result.memberID}";
			var updateStatus = "${result.updateStatus}";
			var status = "${result.status}";
			var userInfoID = "${userInfo.id}";
			var option = "${result.option}";
			var attachList = "";

			$(document).ready(function() {
	            document.getElementById("divCross").innerHTML = sigBody.innerHTML
	            document.getElementById("printDocument").innerHTML = sigBody.innerHTML;
	            
	            document.getElementById("divCross").style.height = window.innerHeight - 320 + "px";
	            
				if ("${attachList}" != "") {
					attachList = true;
				}
	        });
			
			window.onresize = function () {
				var contentHeight;
				document.getElementById("divCross").style.height = window.innerHeight - 320 + "px";
			};
			
			function circularConfirm() {
				if(!confirm("<spring:message code='ezCircular.t68' />")) {
					return;
				}
				
				$.ajax({
					type : "POST",
					url : "/ezCircular/circularConfirm.do",
					dataType : "json",
					data : {
						circularID : circularID
					},
					success : function(result) {
						getConfirmStatus();
						window.opener.getLeftCount();
						window.opener.refresh_onclick();
					},error : function(jqXHR, textStatus, errorThrown) {
						alert("<spring:message code='ezCircular.t102' />");
					}
				});
			}
			
			function getConfirmStatus() {
				$.ajax({
					type : "POST",
					url : "/ezCircular/getConfirmStatus.do",
					dataType : "json",
					data : {
						circularID : circularID
					},
					success : function(result) {
						var confirmStatus = result.confirmStatus;
						
						if (confirmStatus == "1") {
							confirmStatus = "<img src='/images/ImgIcon/msg-rd.gif' style='vertical-align:middle;'/>&nbsp;<spring:message code='ezCircular.t65' />";
							$("#circularConfirm").hide();
							
							$(".confirmStatus").html(confirmStatus);
						}
					},error : function(jqXHR, textStatus, errorThrown) {
						alert("<spring:message code='ezCircular.t102' />");
					}
				});
			}
			
			function getCommentCount() {
				$.ajax({
					type : "POST",
					url : "/ezCircular/getCommentCount.do",
					dataType : "json",
					data : {
						circularID : circularID
					},
					success : function(result) {
// 						result.totalCommentCount;
// 						result.myCommentCount;
						
						$("#commentCount").html("<spring:message code='ezCircular.t180' />[" + result.myCommentCount + "/" + result.totalCommentCount + "]");
					},error : function(jqXHR, textStatus, errorThrown) {
						alert("<spring:message code='ezCircular.t102' />");
					}
				});
			}

		    //삭제버튼 클릭시
	        function btn_delete() {
	            if (!confirm("<spring:message code='ezCircular.t46'/>")) {
	                return;
	            }
	            
	            if (updateStatus == "2" || status == "2") {
	            	$.ajax({
						type : "POST",
						dataType : "json",
						async : false,
						url : "/ezCircular/deleteCircular.do",
						data : { 
							circularID : circularID,
							memberID : circularUserID
						},
						success: function() {
							window.opener.refresh_onclick();
			                closing();
						},
						error: function(err) {
							alert("<spring:message code='ezCircular.t102' />");
						}
					});
	            } else {
	            	$.ajax({
						type : "POST",
						dataType : "json",
						async : false,
						url : "/ezCircular/circularDeleteTemp.do",
						data : { 
							circularIDList : circularID + ";"
						},
						success: function() {
							window.opener.getLeftCount();
							window.opener.refresh_onclick();
			                closing();
						},
						error: function(err) {
							alert("<spring:message code='ezCircular.t102' />");
						}
					});
	            }
	        }
		    
	        var ezprtquestion_cross_dialogArguments = new Array();

	        //인쇄버튼 클릭시
	        function print_onClick() {
	        	var parameter = "";
	        	
	            var url = "/ezCircular/circularprtQuestion.do?attachList=" + attachList;

	            if (CrossYN()) {
	                ezprtquestion_cross_dialogArguments[0] = parameter;
	                ezprtquestion_cross_dialogArguments[1] = OpenQuestionUI_Complete;

	                DivPopUpShow(380, 210, url);
	            }
	            else {
	                var feature = "status:no;dialogWidth:380px;dialogHeight:210px;help:no;";
	                feature = feature + GetShowModalPosition(380, 210);
	                var RtnVal = window.showModalDialog(url, parameter, feature);

	                return RtnVal;
	            }
	        }
	        
	        function OpenQuestionUI_Complete(ret) {
	            DivPopUpHidden();

	            if (ret[0] == "0" && ret[1] == "0") // 취소
	                return;
	            var rtnVal = "";

	            if (ret[0] == "Y" && ret[1] == "N") { // 의견만 인쇄
	            	$("#attachView").remove();
	            	getCircularPrintComment(circularID, userInfoID, status);
	            } else if (ret[0] == "N" && ret[1] == "Y") { // 첨부파일만 인쇄
	            	$("#printCommentLists").remove();
					$("#printCircularUserList").remove();
	            	SetAttachmentInfo();
	            } else if (ret[0] == "N" && ret[1]== "N") { // 문서만 인쇄
	            	$("#printCommentLists").remove();
					$("#printCircularUserList").remove();
					$("#attachView").remove();
	            } else {
	            	getCircularPrintComment(circularID, userInfoID, status);
	            	SetAttachmentInfo();
	            }

				print_onClick2();
	        }
	        
	        function print_onClick2() {
				var feature = GetOpenPosition(700, 700);
	            printWindow = window.open("", "mywindow", "width=700, height=700,location=0,status=0,scrollbars=1,resizable=1" + feature);
	            var strContent = "<html><head>";
	            strContent = strContent + "<title>" + strLangLHM02 + "</title>";
	            strContent = strContent + "<link rel=\"stylesheet\" href=\"/css/" + strLangLHM01 + ".css\" type=\"text/css\" />";
	            strContent = strContent + "</head><body style='padding:10px;'onload='window.print();' >";
	            strContent = strContent + "<div style='width:100%'>";
	            strContent = strContent + "<table id='printScreen' class='layout'>";
	            strContent = strContent + document.getElementById("printScreen").innerHTML;
	            strContent = strContent + "</table></div>";
	            strContent = strContent + "</body>";
	            printWindow.document.write(strContent);
	            printWindow.document.close();
	            printWindow.focus();
	        }

	        function attach_SelectAll() {
			    var checks = document.getElementById('attachedfileDIV').getElementsByTagName("input");
			    for (var i = 0; i < checks.length; i++)
			        checks.item(i).checked = true;
			}
        
			function attach_Download() {
			    checks = document.getElementById('attachedfileDIV').getElementsByTagName("input");
			    downloadAll(checks)
			}

			var suffix = 0;
			function downloadAll(checks) {
			    if (checks.item(suffix)) {
			        if (checks.item(suffix).checked) {
			            if (GetAttribute(checks.item(suffix), "attachid") != "" && GetAttribute(checks.item(suffix), "attachid") != null) {
			                location.href = GetAttribute(checks.item(suffix++), "filepath");
			            } else {		            	
			                location.href = "/ezCircular/downloadAttach.do?filePath=" + GetAttribute(checks.item(suffix), "filePath") + "&fileName=" + GetAttribute(checks.item(suffix++), "fileName") + "&circularID=" + circularID;
			            }
			            setTimeout(function () { downloadAll(checks) }, 1000);
			        } else {
			            suffix++;
			            downloadAll(checks);
			        }
			    } else
			        suffix = 0;
			}
			
			function closing() {
	          	window.close();
			}
			
			function getCircularPrintComment(circularID, userInfoID, status) {
				if ($("#printCommentLists").length == 0) {
					$("#printDocument").html($("#printDocument").html() + '<div id = "printCommentLists" style="border-top:1px solid; height:30px; vertical-align:middle;"><p style="font-size:15px; font-weight:bold; margin-left:10px;"><spring:message code = "ezCircular.t180" /></p></div><table id="printCircularUserList" style="width:100%;margin-top:15px;table-layout: fixed;border:1px solid #e2e2e2"></table>');					
				}

				printCircularUserList = ""
	        	$.ajax({
            		type : "POST",
            		url : "/ezCircular/getCircularComment.do",
            		dataType : "json",
            		async : false,
            		data : {
            			circularID : circularID,
            			commentType : "totalComment",
            			searchValue : ""
            		},
            		success : function(result) {
            			printCircularUserList = "<colgroup><col width='20%' /><col width='60%' /><col width='20%' /></colgroup>";    			
            			list = result.circularUserList;
            			list.forEach(function(vo, index) {
            				printCircularUserList += "<tr class='printCircularUser' circularUserID='" + vo.memberID + "' style='height:40px;text-align:left;vertical-align:middle;'>";
            				printCircularUserList += "<th style='border-top:0px;border-bottom:1px solid #e2e2e2;border-right:0px;border-left:0px;text-align:left;background-color:white;'>";
            				
            				if (vo.status == 1) {
            					//확인 이미지
            					printCircularUserList += "<img src='/images/ImgIcon/circular_read.gif' style='vertical-align:middle;'/>&nbsp;" + vo.memberName + "&nbsp;";
            				} else {
            					//미확인 이미지
            					printCircularUserList += "<img src='/images/ImgIcon/circular_unread.gif' style='vertical-align:middle;'/>&nbsp;" + vo.memberName + "&nbsp;";
            				}
            				
            				printCircularUserList += "</th>";
            				printCircularUserList += "<th style='border-top:0px;border-bottom:1px solid #e2e2e2;border-right:0px;border-left:0px;text-align:right;background-color:white;' colspan='2'>";
            				//확인일
            				if (vo.status == 1) {
            					printCircularUserList += vo.confirmDate.substring(0, 16);
            				}
            				
            				printCircularUserList += "</th>";
            				printCircularUserList += "</tr>";
            			});

            			$("#printCircularUserList").html("");
            			$("#printCircularUserList").append(printCircularUserList);
            			
            			var now = new Date();

            			printCircularCommentList = "";
            			list = result.circularCommentList ;
            			list.forEach(function(vo, index) {
            				printCircularCommentList  = "<tr class='printCircularComment' circularUserID='" + vo.circularUserID + "' memberID='" + vo.memberID + "' circularCommentID='" + vo.circularCommentID + "' circularCommentStatus='" + vo.status + "'>";
            				printCircularCommentList += "<td style='padding-left:3px; border-bottom:1px solid #e2e2e2; background-color:#fafafa;'>&nbsp;&nbsp;<img src='/images/ImgIcon/commentRe.gif' style='vertical-align:middle;'/>&nbsp;" + vo.memberName + "</td>";
            				printCircularCommentList += "<td style='text-align:left;padding:8px; border-bottom:1px solid #e2e2e2; background-color:#fafafa;'>" + vo.circularComment + "&nbsp;&nbsp;";
            				
            				printCircularCommentList += "</td>";
            				printCircularCommentList += "<td style='text-align:right; border-bottom:1px solid #e2e2e2; background-color:#fafafa;'>" + vo.regDate.substring(0, 16) + "</td>";
            				printCircularCommentList += "</tr>";
            				
            				if (vo.status == 0) {
            					if ($(".printCircularComment[circularUserID='" + vo.circularUserID + "']").length == 0) {
            						$(".printCircularUser[circularUserID='" + vo.circularUserID + "']").after(printCircularCommentList);
            					} else {
            						$(".printCircularComment[circularUserID='" + vo.circularUserID + "']:last").after(printCircularCommentList);
            					}
            				} else {//비공개
            					if (vo.memberID == userInfoID || vo.circularUserID == userInfoID) {
            						if ($(".printCircularComment[circularUserID='" + vo.circularUserID + "']").length == 0) {
            							$(".printCircularUser[circularUserID='" + vo.circularUserID + "']").after(printCircularCommentList);
            						} else {
            							$(".printCircularComment[circularUserID='" + vo.circularUserID + "']:last").after(printCircularCommentList);
            						}
            					}
            				}
            			});
            		},
            		error : function(jqXHR, textStatus, errorThrown) {
            			
            		}
            	});
			}

			function SetAttachmentInfo() {
				var xmlhttp = createXMLHttpRequest();
		        var xmldom = createXmlDom();
		        xmlhttp.open("POST", "/ezCircular/getItemAttachments.do?pcircularId=" + circularID, false);
		        xmlhttp.send();
		        xmldom = loadXMLString(xmlhttp.responseText);
		        xmlhttp = null;
		        var filename = "";
		        var filetype = "";
		        var imagePath = "";
		        var strAttachView = "";
		        var strAttach = new Array();

		        strAttachView += "<table id='attachView' class='layout' style='margin-top:5px; height:66px;'>";
		        strAttachView += "<tr><td class='pad1'><table class='file2'>";
		        strAttachView += "<tr><th><spring:message code='ezBoard.t292'/></th>";
		        strAttachView += "<td style='width:100%;'><div id='lstAttachLink' style='padding-top:3px;padding-bottom:3px;padding-left:3px;OVERFLOW:visible;background-color:white; text-align:left'></div></td>";
		        strAttachView += "<td id='ItemLevel' style='display:none;'></td>";
		        strAttachView += "</tr></table></td></tr></table>";

		        if ($("#attachView").length == 0) {
			        $(".content2").after(strAttachView);		        	
		        }

		        var xmldomNodes = SelectNodes(xmldom, "NODES/NODE");
		        for (var i = 0; i < xmldomNodes.length; i++) {
		            filepath = getNodeText(SelectSingleNode(xmldomNodes[i], "FilePath"));
		            filename = getNodeText(SelectSingleNode(xmldomNodes[i], "FileName"));
		            filesize = getNodeText(SelectSingleNode(xmldomNodes[i], "FileSize"));
		            filetype = getNodeText(SelectSingleNode(xmldomNodes[i], "FileType"));
           
		            if (filetype == "jpg" || filetype == "jpeg" || filetype == "bmp" || filetype == "gif" || filetype == "png" || filetype == "tif" || filetype == "tiff") {
		            	imagePath = "/images/image.png";
		            } else if (filetype == "doc" || filetype == "docx") {
		            	imagePath = "/images/doc.png";
		            } else if (filetype == "xls" || filetype == "xlsx") {
		            	imagePath = "/images/xls.png";
		            } else if (filetype == "ppt" || filetype == "pptx" || filetype == "pps" || filetype == "ppsx") {
		            	imagePath = "/images/ppt.png";
		            } else if (filetype == "txt") {
		            	imagePath = "/images/txt.png";
		            } else if (filetype == "zip") {
		            	imagePath = "/images/zip.png";
		            } else if (filetype == "pdf") {
		            	imagePath = "/images/pdf.png";
		            } else if (filetype == "ecm") {
		            	imagePath = "/images/ecm.png";
		            }

		            strAttach[i] = "<img src='" + imagePath + "'/>&nbsp;" + filename + "&nbsp;(" + filesize + ")<br>";
		        }

		        $("#lstAttachLink").html("");
		        for (var i = 0; i<strAttach.length; i++) {
		        	$("#lstAttachLink").append(strAttach[i]);
		        }
		    }
			
			function circularModify() {
				window.location.href = "/ezCircular/circularWrite.do?circularID=" + circularID + "&mode=modify" + "&updateStatus=" + updateStatus;
			}
			
			var xhr = new XMLHttpRequest();
			function circularReUse() {
// 				xhr.open("POST","/ezCircular/circularWrite.do?circularID=" + circularID + "&mode=reuse");
				window.location.href = "/ezCircular/circularWrite.do?circularID=" + circularID + "&mode=reuse";
			}
		</script>
	</head>
	<style>
		.content td{ 
			width:160px;
		}
	</style>
 	<xmp id="sigBody" style="display: none;">${result.content}</xmp>
 	
	<body id="mainbodytag" class="popup">
    	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	    <table id="normalScreen" class="layout">
    	    <tr>
        	    <td style="height: 20px">
            	    <div id="menu">
                	    <ul>
                	    	<c:if test="${result.confirmStatus == '0'}">
								<li id="circularConfirm"><span onclick="circularConfirm()"><spring:message code='ezCircular.t38' /></span></li>
                	    	</c:if>
                	    	
               	    		<li><span onclick="openCircularComment()" id="commentCount"><spring:message code='ezCircular.t180' />[${myCommentCount}/${totalCommentCount }]</span></li>
	                        <li style="background:none; padding-right:2px;" class="off"><img src="/images/ImgIcon/circular_bar.gif"></li>
	                        
	                        <c:if test="${result.memberID == userInfo.id}">
		                        <li><span onclick="circularModify()"><spring:message code='ezCircular.t184' /></span></li>
		                        <li><span onclick="circularReUse()"><spring:message code='ezCircular.t183' /></span></li>
	                        </c:if>
	                        
               	    		<li id="deletebtbn"><span onclick="btn_delete()"><spring:message code='ezCircular.t30' /></span></li>
	                        <li><span onclick="print_onClick()"><spring:message code='ezCircular.t114' /></span></li>
                    	</ul>
                	</div>
                	<div id="close">
	                    <ul>
    	                    <li><span onclick="closing();"><spring:message code='ezCircular.t84' /></span></li>
        	            </ul>
            	    </div>
            	    
            	    <script type="text/javascript" >
		      			selToggleList(document.getElementById("menu"), "ul", "li", "0");
		      			selToggleList(document.getElementById("close"), "ul", "li", "0");
		  			</script>
            	    
					<table class="content" style="width:100%;">
	                    <tr>
    	                    <th style="width: 10%; -webkit-column-width:15%;"><spring:message code='ezCircular.t32' /></th>
        	                <td colspan="3" style="padding-left: 4px;">${result.title}</td>
                    	</tr>
                    	<tr>
							<th style="width:10%; -webkit-column-width:15%;"><spring:message code='ezCircular.t122' /></th>
	       					<td style="padding-left: 4px;"><div id="writer" >${result.memberName }</div></td>
							<th style="width:10%; -webkit-column-width:15%;"><spring:message code='ezCircular.t33' /></th> 
 							<td style="padding-left: 6px;"><div id="printStatus">${result.regDate }</div></td>
						</tr>
                    	<tr>
	                        <th style="width:10%; -webkit-column-width:15%;"><spring:message code='ezCircular.t115' /></th>
    	                    <td id="Td_Importance" style="padding-left: 4px;">
    	                    	<c:if test="${result.importance == '0' }">
	    	                    	<span><spring:message code='ezCircular.t116' /></span>  	                    	
    	                    	</c:if>
    	                    	<c:if test="${result.importance == '1' }">
	    	                    	<span><spring:message code='ezCircular.t117' /></span>  	                    	
    	                    	</c:if>
    	                    </td>
		            		<th style="width:10%; -webkit-column-width:15%;"><spring:message code='ezCircular.t118' /></th>
		            		<td>
		                		<c:choose>
		                			<c:when test="${result.option eq '1'}">
		                				<span id="option" style="padding-left: 4px;"><spring:message code='ezCircular.t119' /></span>
		                			</c:when>
		                			<c:when test="${result.option eq '2'}">
		                				<span id="AllDay" style="padding-left: 4px;"><spring:message code='ezCircular.t120' /></span>
		                			</c:when>
		                			<c:when test="${result.option eq '3'}">
		                				<span id="option" style="padding-left: 4px;"><spring:message code='ezCircular.t119' /></span>,  
										<span id="AllDay"><spring:message code='ezCircular.t120' /></span>
		                			</c:when>
		                			<c:otherwise>
		                				<span id="option" style="padding-left: 4px;"><spring:message code='ezCircular.t121' /></span>
		                			</c:otherwise>
		                		</c:choose>
							</td>
                    	</tr>
						<tr>
		        			<th style="width:10%; -webkit-column-width:15%;"><spring:message code='ezCircular.t74' /></th>
	       					<td><div id="statusNum" style="padding-left: 4px;">${result.confirmCount} / ${result.confirmTotalCount}</div></td>
	         				<th style="width:10%; -webkit-column-width:15%;"><spring:message code='ezCircular.t124' /></th>
		            		<td>
		            			<c:choose>
			            			<c:when test="${result.status eq '0'}">
			            				<div id="status" style="padding-left: 4px;"><spring:message code='ezCircular.t125' /></div>
			            			</c:when>
			            			<c:when test="${result.status eq '1'}">
			            				<div id="status" style="padding-left: 4px;"><spring:message code='ezCircular.t126' /></div>
			            			</c:when>
			            			<c:otherwise>
			            				<div id="status" style="padding-left: 4px;"><spring:message code='ezCircular.t127' /></div>
			            			</c:otherwise>
		                		</c:choose>
		            		</td>
		        		</tr>
		        		<tr>
		            		<th style="width:10%; -webkit-column-width:15%;"><spring:message code='ezCircular.t86' /></th>
		            		<td colspan="3" class="confirmStatus" style="padding-left: 4px; vertical-align: middle;">
		            			<c:choose>
		            				<c:when test="${result.confirmStatus == '0'}">
		            					<img src='/images/ImgIcon/msg-unrd.gif' style='vertical-align:middle;'/>&nbsp;<spring:message code='ezCircular.t143' />
		            				</c:when>
		            				
		            				<c:when test="${result.confirmStatus == '1'}">
		            					<img src='/images/ImgIcon/msg-rd.gif' style='vertical-align:middle;'/>&nbsp;<spring:message code='ezCircular.t65' />
		            				</c:when>
		            			</c:choose>
		            		</td>
		        		</tr>
	        			<tr style="height:100%">
	            			<td colspan="4" style="height:100%;"><div id="divCross" style="margin:8px; height:100%; overflow:auto;"></div></td>
	        			</tr>
	        		</table>
	        		<br/>
                    <table class="file">
                        <tr>
                            <th>
                                <spring:message code='ezCircular.t108' />
                            </th>
                            <td class="pos1">
                                <div id="attachedfileDIV" style="margin-top: 0px; overflow: auto; padding-top: 0px;height: 70px; border-top-width: 0px;" align="left">
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
                                    		<img src="${imagePath}" />&nbsp;<a href="/ezCircular/downloadAttach.do?circularFileID=${item.circularFileID}" id="regData_${status.count}">${item.fileName} (${item.fileTranSize})</a>
                                    	</div>
                                    </c:forEach>
                                </div>
                            </td>
                            <td class="pos2">	                                
                                <a href="#" class="imgbtn">
                                	<span style="width:57px;" onclick="attach_SelectAll()"><spring:message code='ezCircular.t112' /></span>
                                </a><br/>	                                
                                <a href="#" class="imgbtn">
                                	<span style="width:57px;" onclick="attach_Download()"><spring:message code='ezCircular.t25' /></span>
                                </a>
                            </td>
                        </tr>
                    </table>
	        	</td>
        	</tr>
		</table>

		<table id="printScreen" style="display: none;">
			<tr style="text-align:center">
				<td style="vertical-align:top">
					<table style="width:100%; border:0px; padding:1px; border-collapse:collapse; border-spacing:0px; " class="content2">
						<tr style="height:25px"> 
 							<th style="padding-left:10px"><spring:message code='ezCircular.t32' /></th> 
 							<td style="padding-left:4px; width:100%" colspan="3">
 								<div id="printTitle">
 									${result.title}
 								</div>
 							</td> 
						</tr>
						<tr style="height:25px">
							<th style="padding-left: 10px;"><spring:message code='ezCircular.t122' /></th>
	       					<td style="padding-left: 4px;">								
	         					<div id="writer" >${result.memberName }</div>
	         				</td>
							<th style="padding-left:10px"><spring:message code='ezCircular.t33' /></th> 
 							<td style="padding-left:6px">
 								<div id="printStatus">${result.regDate }</div>
 							</td> 
						</tr>
						<tr style="height:25px"> 
 							<th style="padding-left:10px"><spring:message code='ezCircular.t115' /></th> 
 							<td style="padding-left: 4px; width:200px">
    	                    	<c:if test="${result.importance == '0' }">
	    	                    	<span><spring:message code='ezCircular.t116' /></span>  	                    	
    	                    	</c:if>
    	                    	<c:if test="${result.importance == '1' }">
	    	                    	<span><spring:message code='ezCircular.t117' /></span>  	                    	
    	                    	</c:if>
    	                    </td>
    	                    <th style="padding-left:10px;"><spring:message code='ezCircular.t118' /></th>
		            		<td style="width:200px;">
		                		<c:choose>
		                			<c:when test="${result.option eq '1'}">
		                				<span id="option" style="padding-left: 4px;"><spring:message code='ezCircular.t119' /></span>
		                			</c:when>
		                			<c:when test="${result.option eq '2'}">
		                				<span id="AllDay" style="padding-left: 4px;"><spring:message code='ezCircular.t120' /></span>
		                			</c:when>
		                			<c:when test="${result.option eq '3'}">
		                				<span id="option" style="padding-left: 4px;"><spring:message code='ezCircular.t119' /></span>,  
										<span id="AllDay"><spring:message code='ezCircular.t120' /></span>
		                			</c:when>
		                			<c:otherwise>
		                				<span id="option" style="padding-left: 4px;"><spring:message code='ezCircular.t121' /></span>
		                			</c:otherwise>
		                		</c:choose>
							</td>
						</tr>
						<tr style="height:25px">
							<th style="padding-left:10px"><spring:message code='ezCircular.t74' /></th>
	       					<td style="padding-left: 4px;">								
	         					<div id="statusNum">${result.confirmCount} / ${result.confirmTotalCount}</div>
	         				</td>
							<th style="padding-left:10px"><spring:message code='ezCircular.t124' /></th> 
 							<td style="padding-left:4px">
 								<div id="printStatus">
 									<c:choose>
				            			<c:when test="${result.status eq '0'}">
				            				<div id="status"><spring:message code='ezCircular.t125' /></div>
				            			</c:when>
				            			<c:when test="${result.status eq '1'}">
				            				<div id="status"><spring:message code='ezCircular.t126' /></div>
				            			</c:when>
				            			<c:otherwise>
				            				<div id="status"><spring:message code='ezCircular.t127' /></div>
				            			</c:otherwise>
		                			</c:choose>
 								</div>
 							</td> 
						</tr>
						<tr style="height:25px"> 
 							<th style="padding-left:10px"><spring:message code='ezCircular.t86' /></th>
		            		<td colspan="3" class="confirmStatus" style="padding-left: 4px; vertical-align: middle;">
		            			<c:choose>
		            				<c:when test="${result.confirmStatus == '0'}">
		            					<img src='/images/ImgIcon/msg-unrd.gif' style='vertical-align:middle;'/>&nbsp;<spring:message code='ezCircular.t143' />
		            				</c:when>
		            				
		            				<c:when test="${result.confirmStatus == '1'}">
		            					<img src='/images/ImgIcon/msg-rd.gif' style='vertical-align:middle;'/>&nbsp;<spring:message code='ezCircular.t65' />
		            				</c:when>
		            			</c:choose>
		            		</td>
						</tr>
						<tr> 
 							<td colspan="4"> <div align="left" id="printDocument" style="padding: 5px; margin: 8px; width: 100%; display:inherit;"></div></td> 
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</body>
</html>