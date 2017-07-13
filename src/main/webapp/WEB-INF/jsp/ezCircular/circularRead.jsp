<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCircular.t111'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="<spring:message code="ezCircular.c1" />" type="text/css" />
		<script type="text/javascript" src="/js/ezCircular/lang/ezCircular.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="<spring:message code='ezResource.e1'/>"></script>
		<script type="text/javascript" src="/js/ezResource/composeappt_cross.js"></script>
		<script type="text/javascript" src="/js/ezResource/Schedule_cross.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/ezCircular/circularComment.js"></script>
		<script type="text/javascript" >
			var circularID = "${result.circularID}";
			var circularUserID = "${result.memberID}";
			var status = "${result.status}";
			var userInfoID = "${userInfo.id}";
			var option = "${result.option}";

			$(document).ready(function(){
				window.opener.getLeftCount();
	            document.getElementById('circularUserList1').innerHTML = "${listUser}";
	            document.getElementById("divCross").innerHTML = sigBody.innerHTML
	            /* getCircularComment(circularID, userInfoID, status); */
	            
	            document.getElementById("divCross").style.height = window.innerHeight - 320 + "px";
	        });
			
			window.onresize = function () {
				var contentHeight;
				contentHeight = document.documentElement.innerHeight - 320;
				document.getElementById("divCross").style.height = contentHeight + "PX";
			};

		    //삭제버튼 클릭시
	        function btn_delete() {
	            if (!confirm("<spring:message code='ezCircular.t46'/>"))
	                return;
	            
	            $.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezCircular/circularDelete.do",
					data : { 
						circularID : circularID
					},
					success: function() {
						alert("<spring:message code='ezCircular.t45'/>");
						
						window.opener.getLeftCount();
						window.opener.refresh_onclick();
		                window.close();
					},
					error: function(err) {
						alert("<spring:message code='ezCircular.t102' />");
					}
				});	
	        }
		    
	        //인쇄버튼 클릭시
	        function print_onClick2(printTrueFalse) {
	            g_printTrueFalse = printTrueFalse;
	            
	            document.getElementById("printDocument").innerHTML = sigBody.innerHTML;

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
			                location.href = "/ezCircular/downloadAttach.do?filePath=" + GetAttribute(checks.item(suffix), "filePath") + "&fileName=" + GetAttribute(checks.item(suffix++), "fileName");
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
			
			/* function getCircularComment(circularID, userInfoID, status) {
				$("#divCross").html($("#divCross").html() + '<div id = "commentLists" style="border-top:1px solid; height:30px; vertical-align:middle;"><p style="font-size:15px; font-weight:bold; margin-left:10px;"><spring:message code = "ezCircular.t82" /></p></div><table id="circularUserList" style="width:100%;margin-top:15px;table-layout: fixed;border:1px solid #e2e2e2"></table>');
	        	
	        	$.ajax({
            		type : "POST",
            		url : "/ezCircular/getCircularComment.do",
            		dataType : "json",
            		data : {
            			circularID : circularID,
            			searchValue : ""
            		},
            		success : function(result) {
            			circularUserList = "<colgroup><col width='20%' /><col width='60%' /><col width='20%' /></colgroup>";
            			
            			list = result.circularUserList;
            			list.forEach(function(vo, index) {
            				circularUserList += "<tr class='circularUser' circularUserID='" + vo.memberID + "' style='height:40px;text-align:left;vertical-align:middle;'>";
            				circularUserList += "<th style='border-top:0px;border-bottom:1px solid #e2e2e2;border-right:0px;border-left:0px;text-align:left;background-color:white;'>";
            				
            				if (vo.status == 1) {
            					//확인 이미지
            					circularUserList += "<img src='/images/ImgIcon/circular_read.gif' style='vertical-align:middle;'/>&nbsp;" + vo.memberName + "&nbsp;";
            				} else {
            					//미확인 이미지
            					circularUserList += "<img src='/images/ImgIcon/circular_unread.gif' style='vertical-align:middle;'/>&nbsp;" + vo.memberName + "&nbsp;";
            				}
            				
            				circularUserList += "</th>";
            				circularUserList += "<th style='border-top:0px;border-bottom:1px solid #e2e2e2;border-right:0px;border-left:0px;text-align:right;background-color:white;' colspan='2'>";
            				//확인일
            				if (vo.status == 1) {
            					circularUserList += vo.confirmDate.substring(0, 16);
            				}
            				
            				circularUserList += "</th>";
            				circularUserList += "</tr>";
            			});
            			
            			$("#circularUserList").html("");
            			$("#circularUserList").append(circularUserList);
            			
            			var now = new Date();

            			circularCommentList = "";
            			list = result.circularCommentList ;
            			list.forEach(function(vo, index) {
            				circularCommentList  = "<tr class='circularComment' circularUserID='" + vo.circularUserID + "' memberID='" + vo.memberID + "' circularCommentID='" + vo.circularCommentID + "' circularCommentStatus='" + vo.status + "'>";
           					circularCommentList += "<td style='padding-left:3px; border-bottom:1px solid #e2e2e2; background-color:#fafafa;'>&nbsp;&nbsp;<img src='/images/ImgIcon/commentRe.gif' style='vertical-align:middle;'/>&nbsp;" + vo.memberName + "</td>";
            				circularCommentList += "<td style='text-align:left;padding:8px; border-bottom:1px solid #e2e2e2; background-color:#fafafa;'>" + vo.circularComment + "&nbsp;&nbsp;";
            				
            				var arry = vo.regDate.substring(0, 10).split('-');
            				var d = new Date(arry[0], arry[1]-1, arry[2]);
            				var getDiffTime = now.getTime() - d.getTime();
            				
            				if (getDiffTime / (1000 * 60 * 60 * 24) < 3) {
            					circularCommentList += "<img src='/images/ImgIcon/circular_newIcon1.gif' />&nbsp;";
            				}
            				
            				circularCommentList += "</td>";
            				circularCommentList += "<td style='text-align:right; border-bottom:1px solid #e2e2e2; background-color:#fafafa;'>" + vo.regDate.substring(0, 16) + "</td>";
            				circularCommentList += "</tr>";
            				
            				if (vo.status == 0) {
            					if ($(".circularComment[circularUserID='" + vo.circularUserID + "']").length == 0) {
            						$(".circularUser[circularUserID='" + vo.circularUserID + "']").after(circularCommentList);
            					} else {
            						$(".circularComment[circularUserID='" + vo.circularUserID + "']:last").after(circularCommentList);
            					}
            				} else {//비공개
            					if (vo.memberID == userInfoID || vo.circularUserID == userInfoID) {
            						if ($(".circularComment[circularUserID='" + vo.circularUserID + "']").length == 0) {
            							$(".circularUser[circularUserID='" + vo.circularUserID + "']").after(circularCommentList);
            						} else {
            							$(".circularComment[circularUserID='" + vo.circularUserID + "']:last").after(circularCommentList);
            						}
            					}
            				}
            			});
            		},
            		error : function(jqXHR, textStatus, errorThrown) {
            			
            		}
            	});
	        } */
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
               	    		<li><span onclick="openCircularComment()"><spring:message code='ezCircular.t113' />[${commentCount}]</span></li>                        	
                	    	<c:if test="${result.memberID == userInfo.id}">
                	    		<li id="deletebtbn"><span onclick="btn_delete()"><spring:message code='ezCircular.t30' /></span></li>
                	    	</c:if>
	                        <li><span onclick="print_onClick2( false )"><spring:message code='ezCircular.t114' /></span></li>
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
							<th style="width:10%; -webkit-column-width:15%;"><spring:message code='ezCircular.t122' /></th>
	       					<td style="padding-left: 4px;"><div id="writer" >${result.memberName }</div></td>
							<th style="width:10%; -webkit-column-width:15%;"><spring:message code='ezCircular.t33' /></th> 
 							<td style="padding-left: 6px;"><div id="printStatus">${result.regDate }</div></td>
						</tr>
						<tr>
		        			<th style="width:10%; -webkit-column-width:15%;"><spring:message code='ezCircular.t65' /></th>
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
		            		<th style="width:10%; -webkit-column-width:15%;"><spring:message code='ezCircular.t34' /></th>
		            		<td colspan="3" id="circularUserList1" style="padding-left: 4px; vertical-align: middle;"></td>
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
                                    		<img src="${imagePath}" />&nbsp;<a href="/ezCircular/downloadAttach.do?fileName=${item.fileEncodeName}&filePath=${item.filePath}" id="regData_${status.count}">${item.fileName} (${item.fileTranSize})</a>	                                    		
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
							<th style="padding-left:10px"><spring:message code='ezCircular.t65' /></th>
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
 							<th style="padding-left:10px"><spring:message code='ezCircular.t34' /></th> 
 							<td style="padding-left:4px; width:100%" colspan="3">
 								<div id="printCircularUser">
 									${listUser}
 								</div>
 							</td>
						</tr>
						<tr> 
 							<td colspan="4"> <div align="left" id="printDocument" style="paddingt: 5px; margin: 8px; width: 100%; "></div></td> 
						</tr>	
					</table>
				</td>
			</tr>
		</table>
	</body>
</html>