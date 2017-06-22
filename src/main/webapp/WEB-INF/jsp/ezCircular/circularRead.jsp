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
		<script type="text/javascript" src="/js/ezResource/composeappt_cross.js"></script>
		<script type="text/javascript" src="/js/ezResource/Schedule_cross.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/ezCircular/circularComment.js"></script>
		<script type="text/javascript" >
			var circularID = "${result.circularID}";
			var status = "${result.status}";
			
			$(document).ready(function(){
	            document.getElementById('itemList').innerHTML = "${listUser}";
	            
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
	            
	            document.getElementById("divCross").style.height = window.innerHeight - 300 + "px";
	            
	            getcircularComment();
	        });
	        
		    //수정버튼 클릭시
	        function btn_modify() {
		    	var circularID = "${result.circularID}";
				
	            window.location.href = "/ezCircular/circularModify.do?circularID="+circularID;
	        }
		    
		    //삭제버튼 클릭시
	        function btn_delete() {
		    	var circularID = "${result.circularID}";
				
	            if (!confirm("회람을 삭제하시겠습니까?"))
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
						alert("회람을 삭제하였습니다.");
						
		                try { window.opener.RefreshView() } catch (e) { }
		
		                if (window.opener.reload != undefined)
		                    window.opener.reload();
		                window.opener.window_reload();
		                window.close();
					},
					error: function(err) {
						alert("<spring:message code='ezSchedule.t212' />");
					}
				});	
	        }
		    
	        //인쇄버튼 클릭시
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
	        	//프린트 관련
	            /* document.getElementById("printOwner").textContent = document.getElementById("displayNM").textContent;
	            document.getElementById("printImportance").textContent = document.getElementById("importanceDIV").textContent;
	            document.getElementById("printDate").textContent = document.getElementById("AllDayDisplay").textContent;
	            document.getElementById("printTitle").textContent = document.getElementById("titleDIV").textContent; */
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
				window.opener.location.reload();
	          	window.close();
			}
		</script>
	</head>
	
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
<!--                         	<li id="btn_modify"><span onclick="btn_modify()">수정</span></li> -->
<!--                         	<li id="deletebtbn"><span onclick="btn_delete()">삭제</span></li> -->
<!--                         	<li><span>회람종료</span></li> -->
	                        <li><span onclick="print_onClick2( false )">인쇄</span></li>
                    	</ul>
                	</div>
                	<div id="close">
	                    <ul>
    	                    <li><span onclick="closing();"><spring:message code='ezResource.t150' /></span></li>
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
            	                ${result.title}
                	        </td>
                    	</tr>
                    	<tr>
	                        <th>중요도</th>
    	                    <td colspan="3">${result.importance == '0' ? '일반' : '중요'}</td>
                    	</tr>
		        		<tr>
		            		<th>옵션</th>
		            		<td colspan="3" style="width: 100%">
		                		<c:choose>
		                			<c:when test="${result.option eq '1'}">
		                				<input type="checkbox" id="option" checked  />댓글기능 사용
		                				<input type="checkbox" id="AllDay"  />메일공지 사용
		                			</c:when>
		                			<c:when test="${result.option eq '2'}">
		                				<input type="checkbox" id="option"  />댓글기능 사용
		                				<input type="checkbox" id="AllDay" checked />메일공지 사용
		                			</c:when>
		                			<c:when test="${result.option eq '3'}">
		                				<input type="checkbox" id="option" checked />댓글기능 사용
										<input type="checkbox" id="AllDay" checked />메일공지 사용
		                			</c:when>
		                			<c:otherwise>
		                				<input type="checkbox" id="option" />댓글기능 사용
										<input type="checkbox" id="AllDay" />메일공지 사용
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
		            			<c:choose>
			            			<c:when test="${result.status eq '0'}">
			            				<div id="status">진행중</div>
			            			</c:when>
			            			<c:when test="${result.status eq '1'}">
			            				<div id="status">종료</div>
			            			</c:when>
			            			<c:otherwise>
			            				<div id="status">임시</div>
			            			</c:otherwise>
		                		</c:choose>
		            		</td>
		        		</tr>
	        			<tr style="height:100%">
	            			<td colspan="4" style="height:100%;">
	                 			<div id="divCross" style="overflow:auto;"></div>
	            			</td>
	        			</tr>
	        			
	        		</table>
	        		<br/>
                    <table class="file">
                        <tr>
                            <th>
                                <spring:message code='ezSchedule.t316' />
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
                                	<span style="width:57px;" onclick="attach_SelectAll()"><spring:message code='ezSchedule.t317' /></span>
                                </a><br/>	                                
                                <a href="#" class="imgbtn">
                                	<span style="width:57px;" onclick="attach_Download()"><spring:message code='ezSchedule.t157' /></span>
                                </a>
                            </td>
                        </tr>
                    </table>
                    <br/>

	        		<table class="mainlist">
	                    <tr>
    	                    <th style="width: 70px;">댓글상세보기</th>
    	                    <th style="text-align:right;"><input type='text' id='searchValue' /><a class='imgbtn'><span onclick="getcircularComment()">검색</span></a></th>
    	                    <th style="width: 40px; text-align:right;"><a class='imgbtn'><span onclick="alert('확인메일')">확인재촉메일발송</span></a></th>
						</tr>
						<tr>
        	                <td style="width: 100%; border:0px;" colspan='3'>
            	                <table id="comments" style="width:100%">
									<tr>
										<td style="border:0px;">
											<table id="commentUserList" class="mainlist" style="width:100%"></table>
										</td>
									</tr>	
								</table>
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