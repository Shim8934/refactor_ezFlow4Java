<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	    <link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />
        <script type="text/javascript" src="/js/mouseeffect.js"></script>
        <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
        <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>        
		<title>
			<spring:message code='ezSchedule.t298'/>
			<c:if test="${scheduleInfo.scheduleType == 1}"><spring:message code='ezSchedule.t321' /></c:if>
			<c:if test="${scheduleInfo.scheduleType == 2}"><spring:message code='ezSchedule.t322' /></c:if>
			<c:if test="${scheduleInfo.scheduleType == 3}"><spring:message code='ezSchedule.t323' /></c:if>
			<c:if test="${scheduleInfo.scheduleType == 7}"><spring:message code='ezSchedule.t324' /></c:if>
			<c:if test="${scheduleInfo.scheduleType == 8}"><spring:message code='ezSchedule.t996' />(</c:if>
			<c:if test="${primary == '1'}"><c:out value="${scheduleInfo.creatorName}" /></c:if>
	        <c:if test="${primary != '1'}"><c:out value="${scheduleInfo.creatorName2}" /></c:if>)
		</title>
		<style> P { MARGIN-BOTTOM: 0mm; MARGIN-TOP: 0mm; line-height:20px }</style>
		<script>
			var contentpath = "${scheduleInfo.contentPath}";
			var ownerid = "<c:out value='${scheduleInfo.ownerId}' />";
			var creatorid = "<c:out value='${scheduleInfo.creatorId}' />";
			var modifierid = "<c:out value='${scheduleInfo.modifierId}' />";
			var scheduletype = "<c:out value='${scheduleInfo.scheduleType}' />";
			var scheduleid = "<c:out value='${_scheduleid}' />";			
			var datetype = "<c:out value='${scheduleInfo.dateType}' />";			
			var changekey = "";
			var pattern = "<c:out value='${_pattern}' />";
			var pageFrom = "<c:out value='${pageFrom}' />";			
			var s_DateForAttandant = "";			
			var e_DateForAttandant = "";
			var _otherid = "<c:out value='${otherid}' />";
	        var pUse_Editor = "CK";
	        var ResourceInfo = "<c:out value='${resourceCnt}' />";	        
	        
	        <%-- var parentid = "<%= _parentid %>"; --%>			
			<%-- var admin = "<%= _admin %>"; --%>
			<%-- var userid = "<%= userinfo.UserID %>"; --%>
			<%-- var groupname = "<%= groupname %>"; --%>
			<%-- var changekey = "<%= _changekey %>"; --%>
			<%-- var s_DateForAttandant = "<%= s_DateForAttandant %>"; --%>
			<%-- var e_DateForAttandant = "<%= e_DateForAttandant %>"; --%>
	        
	        window.onload = function () {	            
                if (document.getElementById('managespan') && (scheduletype != "1" && scheduletype != "6")) {
                    managespan.style.display = "none";
                    manageli.style.display = "none";
                }
                
                $.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezCommon/mhtToHTMLContent.do",
					data : { 
						type   : "SCHEDULECONTENT", 
						itemID 	 : contentpath
					},
					success: function(result){
						document.getElementById('message').innerHTML = result;
					}        			
				});
	            
	            window.onresize();
	        }
	
	        window.onresize = function () {
	            if (document.all.message.style.width != document.body.clientWidth - 25)
	                document.all.message.style.width = document.body.clientWidth - 25;
	
	            if ((scheduletype != "1" && scheduletype != "6" && scheduletype != "7") || (scheduletype != "7" && scheduletype != "1")) {
	                if (document.getElementById('managespan') && (scheduletype != "1" && scheduletype != "6")) {
	                    document.getElementById("messagetd").style.height = document.body.clientHeight - 250 + "PX";
	                }
	            } else
	                document.getElementById("messagetd").style.height = document.body.clientHeight - 298 + "PX";
	        }
				
	        function show_personinfo(userid) {
	            if (userid == "0")
	                userid = creatorid;
	            else if (userid == "1")
	                userid = modifierid;
	            
	            var feature = GetOpenPosition(420, 450);
	            if (userid.indexOf('@') > 0)
	                window.open("/ezCommon/showPersonInfo.do?email=" + userid, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	            else
	                window.open("/ezCommon/showPersonInfo.do?id=" + userid, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	        }
	
			/* function group_info() {
	            var feature = GetOpenPosition(430, 450);
	            window.open("/myoffice/ezSchedule/schedule_group_info.aspx?id=" + ownerid + "&scheduleid=" + scheduleid, "",
	                "height = 451px, width = 430px, status = no, toolbar=no, menubar=no,location=no, resizable=0" + feature);
	        } */
				
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
			                location.href = "/ezSchedule/downloadAttach.do?filePath=" + GetAttribute(checks.item(suffix), "filePath") + "&fileName=" + GetAttribute(checks.item(suffix++), "fileName");
			            }
			            setTimeout(function () { downloadAll(checks) }, 1000);
			        } else {
			            suffix++;
			            downloadAll(checks);
			        }
			    } else
			        suffix = 0;
			}	

	        function manage_attendant() {	
	            var pheight = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            var pTop = (pheight - 355) / 2;
	            var pLeft = (pwidth - 530) / 2;
	            window.open("/ezSchedule/scheduleManageAttendant.do?ownerid=" + ownerid + "&id=" + encodeURIComponent(scheduleid) + "&changekey=" + encodeURIComponent(changekey) + "&type=" + scheduletype + "&dtype=" + datetype + "&pattern=" + pattern + "&StartTime=" + s_DateForAttandant + "&EndTime=" + e_DateForAttandant, "",
	                "height = 355px, width = 530px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=0");
	        }
	        
	        var schedule_delete_confirm_cross_dialogArguments = new Array();
	        function repetiton_check() {	
	        	schedule_delete_confirm_cross_dialogArguments[0] = "";
	        	schedule_delete_confirm_cross_dialogArguments[1] = deleteSchedule_Complete;
	            GetOpenWindow("/ezSchedule/scheduleDeleteConfirm.do", "schedule_delete_confirm_Cross", 400, 170);
	        }
	        
	        function deleteSchedule_Complete(ret) {
				if (ret == "0") {
					once_delete_schedule();
				} else if (ret == "1") {
					delete_schedule();
				}
		    }
	        
	        function check_schedule() {
	        	if ("${scheduleInfo.dateType}" == "3") {
	        		repetiton_check();	        	
	        	} else {
	        		delete_schedule();
	        	}
	        }
	
	        function delete_schedule() {	        	
	            if (!confirm("<spring:message code='ezSchedule.t209' />"))
	                return;
	
	            var ResourceDel = "FALSE";;
	            if (ResourceInfo != "0") {
	                confirm("<spring:message code='ezSchedule.t1300' />") ? ResourceDel = "TRUE" : ResourceDel = "FALSE";
	            }           
	            
	            $.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezSchedule/scheduleDelete.do",
					data : { 
						scheduleId : scheduleid,
						resDel : ResourceDel,
						dateType : datetype
					},
					success: function() {
						alert("<spring:message code='ezSchedule.t213' />");
						
		                try { window.opener.RefreshView() } catch (e) { }
		
		                if (window.opener.reload != undefined)
		                    window.opener.reload();
		                window.close();
					},
					error: function(err) {
						alert("<spring:message code='ezSchedule.t212' />");
					}
				});	
	        }
	        
	        function once_delete_schedule() {
	        	if (!confirm("<spring:message code='ezSchedule.t209' />"))
	                return;
		            
	            $.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezSchedule/scheduleOnceDelete.do",
					data : { 
						scheduleId : scheduleid,
						selectDate : "${_date}",
						startDate : "${scheduleInfo.startDate}"						
					},
					success: function() {
						alert("<spring:message code='ezSchedule.t213' />");
						
		                try { window.opener.RefreshView() } catch (e) { }
		
		                if (window.opener.reload != undefined)
		                    window.opener.reload();
		                window.close();
					},
					error: function(err) {
						alert("<spring:message code='ezSchedule.t212' />");
					}
				});
	        }
				
	        function edit_schedule() {
	            var id = scheduleid;
	            var win = null;
	
	            var pheight = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            var pTop = (pheight - 760) / 2;
	            var pLeft = (pwidth - 790) / 2;
	            
	            if (CrossYN()) {
	                win = window.open("/ezSchedule/scheduleWrite.do?id=" + encodeURIComponent(id) + "&type=" + scheduletype + "&datetype=" + datetype + "&pattern=" + pattern + "&pageFrom=" + pageFrom + "&otherid=" + _otherid, "",
	                                    "height = 830px, width = 790px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
	            } else {
	                if (pUse_Editor == "" || pUse_Editor == "CK") {
	                    win = window.open("/ezSchedule/scheduleWrite.do?id=" + encodeURIComponent(id) + "&type=" + scheduletype + "&datetype=" + datetype + "&pattern=" + pattern + "&pageFrom=" + pageFrom + "&otherid=" + _otherid, "",
	                                        "height = 760px, width = 790px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
	                }/*  else {
	                    win = window.open("schedule_write_IE.aspx?id=" + encodeURIComponent(id) + "&type=" + scheduletype + "&datetype=" + datetype + "&pattern=" + pattern + "&pageFrom=" + pageFrom + "&otherid=" + _otherid, "",
	                                        "height = 760px, width = 790px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
	                } */
	            }
	
	            win.opener = window.opener;
	            window.close();
	        }
	        
	        function Print_onClick() {	
	            var printCreator = "";
	            var printCreateDate = "";
	            var printAttendant = "";
	            var printIsPublic = "";
	            var printImportance = "";
	            var printRepetition = "";
	            var printDate = "";
	            var printLocation = "";
	            var printTitle = "";
	            var printAttach = "";
	            var printDocument = "";
	
	            printCreator = getNodeText(document.getElementById("LabelCreator"));
	            printCreateDate = getNodeText(document.getElementById("LabelCreateDate"));
	            printIsPublic = getNodeText(document.getElementById("LabelPublic"));
	            printImportance = getNodeText(document.getElementById("LabelImportance"));
	  			if (scheduletype == "1" || scheduletype == "6") {
	            	printAttendant = getNodeText(document.getElementById("LabelAttendant"));
	            }	            
	            printDate = getNodeText(document.getElementById("LabelDate"));
	            printLocation = getNodeText(document.getElementById("LabelLocation"));
	            printTitle = getNodeText(document.getElementById("LabelSubject"));
	            printDocument = document.getElementById("message").innerHTML;
	            printAttach = document.getElementById("attachedfileDIV").innerHTML;
	
	            var params = { 'type': 'READ', 'printCreator': printCreator, 'printCreateDate': printCreateDate, 'printAttendant': printAttendant, 'printIsPublic': printIsPublic, 'printImportance': printImportance, 'printRepetition': printRepetition, 'printDate': printDate, 'printLocation': printLocation, 'printTitle': printTitle, 'printAttach': printAttach, 'printDocument': printDocument };
	
	            post_to_url("/ezSchedule/scheduleContentsPrint.do", params, "post");
	        }
	
	        function post_to_url(path, params, method) {
	            method = method || "post";
	
	            var pheight = window.screen.availHeight;
	            var conHeight = pheight * 0.8;
	            var pwidth = window.screen.availWidth;
	            var conWidth = pwidth * 0.8;
	            if (conWidth > 890)
	                conWidth = 890;
	            var pTop = (pheight - conHeight) / 2;
	            var pLeft = (pwidth - 890) / 2;
	
	            var title = "Print";
	            var status = "toolbar=no,directories=no,scrollbars=no,resizable=no,status=no,menubar=no,width=" + conWidth + "px, height=" + conHeight + "px, top=" + pTop.toString() + ",left=" + pLeft.toString();
	            window.open("", title, status);
	
	            var form = document.createElement("form");
	            form.setAttribute("method", method);
	            form.setAttribute("target", title);
	            form.setAttribute("action", path);
	            for (var key in params) {
	                var hiddenField = document.createElement("input");
	                hiddenField.setAttribute("type", "hidden");
	                hiddenField.setAttribute("name", key);
	                hiddenField.setAttribute("value", params[key]);
	                form.appendChild(hiddenField);
	            }
	            document.body.appendChild(form);
	            form.submit();
	        }
		</script>
	</head>
	
	<body class="popup" scroll="no" style="height:98%">
	    <form method="post" style="height:98%">
	        <table id="normalScreen" style="height:100%; width:100%;" class="layout">
	            <tr>
	                <td style="height:20px">	                    
	                    <div id="menu">
	                        <ul>
	                        	<c:if test="${_editPosible == 'Y'}">
                                <li>
                                	<span onclick="edit_schedule()"><spring:message code='ezSchedule.t302' /></span>
                                </li>
                                <li>
                                	<span onclick="check_schedule()"><spring:message code='ezSchedule.t215' /></span>
                                </li>	                                
                                <li id ="manageli">
                                	<span id=managespan onclick="manage_attendant()"><spring:message code='ezSchedule.t303' /></span>
                                </li>
                                </c:if>
                            	<li>
                            		<span onclick="Print_onClick()"><spring:message code='ezSchedule.t217' /></span>
                            	</li>                            	
	                        </ul>
	                    </div>	                    
	                    <div id="close">
	                        <ul>
	                            <li>
	                            	<span onclick="window.close()"><spring:message code='ezSchedule.t16' /></span>
	                            </li>
	                        </ul>
	                    </div>
	                </td>
	            </tr>
	            <tr>
	                <td style="height:20px">
	                    <table style="width:100%" class="popuplist">	                         
	                        <c:if test="${scheduleInfo.scheduleType == '7'}">
	                        	<tr>
		                            <th style="white-space:nowrap">
		                                <spring:message code='ezSchedule.jjh04' />
		                            </th>
		                            <td colspan="3" style="white-space:nowrap;">
		                                <div style="cursor: pointer;width:270px">
		                                    <c:out value="${scheduleInfo.groupName}" />
		                                </div>
		                            </td>                            
		                        </tr>
	                        </c:if>
	                        <tr>
	                            <th style="white-space:nowrap">
	                                <spring:message code='ezSchedule.jjh05' />
	                            </th>
	                            <td style="white-space:nowrap;">
	                                <div style="cursor: pointer;width:270px;" onclick="show_personinfo('0')" id="LabelCreator">	                                    
	                                    <c:if test="${primary == '1'}"><c:out value="${scheduleInfo.creatorName}" /></c:if>
	                                    <c:if test="${primary != '1'}"><c:out value="${scheduleInfo.creatorName2}" /></c:if>	                                    
	                                </div>
	                            </td>
	                            <th style="white-space:nowrap; width:80px">
	                                <spring:message code='ezSchedule.jjh06' />
	                            </th>
	                            <td style="white-space:nowrap; width:100%">
	                                <div id="LabelCreateDate">	                                    
	                                    <c:out value="${fn:substring(scheduleInfo.createDate,0,16)}" />
	                                </div>
	                            </td>
	                        </tr>	                        
	                        <tr>
	                            <th style="white-space:nowrap">
	                                <spring:message code='ezSchedule.t309' />
	                            </th>
	                            <td>
	                                <div id="LabelPublic">
	                                    <c:if test="${scheduleInfo.isPublic == 'Y'}"><spring:message code='ezSchedule.t359' /></c:if>
	                                    <c:if test="${scheduleInfo.isPublic == 'N'}"><spring:message code='ezSchedule.t360' /></c:if>
	                                </div>
	                            </td>
	                            <th style="white-space:nowrap">
	                                <spring:message code='ezSchedule.jjh07' />
	                            </th>
	                            <td>
	                                <div id="LabelImportance">
	                                    <c:if test="${scheduleInfo.importance == '1'}"><spring:message code='ezSchedule.t325' /></c:if>
	                                    <c:if test="${scheduleInfo.importance == '2'}"><spring:message code='ezSchedule.t326' /></c:if>
	                                    <c:if test="${scheduleInfo.importance == '3'}"><spring:message code='ezSchedule.t327' /></c:if>
	                                </div>
	                            </td>
	                        </tr>
	                        <c:if test="${scheduleInfo.scheduleType == '1' || scheduleInfo.scheduleType == '6'}"> 
	                        <tr>
	                            <th style="white-space:nowrap">
	                                <spring:message code='ezSchedule.t311' />
	                            </th>
	                            <td colspan="3" width="100%">
	                                <div style="overflow-y: auto; height: 17px; padding-top: 2px" id="LabelAttendant">	                                
	                                	<c:forEach var="item" items="${attendantList}" varStatus="status">	                                		  		
	                                	 	<span title="<spring:message code='ezSchedule.t162'/>" style="cursor:pointer" onclick="show_personinfo('${item.attendantId}')">
	                                	 		<c:if test="${lang == '1'}"><c:out value="${item.attendantName}" /></c:if>
	                                	 		<c:if test="${lang != '1'}"><c:out value="${item.attendantName2}" /></c:if>
                                    			<c:if test="${item.status == '1'}">(<spring:message code='ezSchedule.t251' />)</c:if>
	                                			<c:if test="${item.status == '2'}">(<spring:message code='ezSchedule.t168' />)</c:if>
	                                			<c:if test="${item.status == '3'}">(<spring:message code='ezSchedule.t169' />)</c:if>
	                                			<c:if test="${item.status != '1' && item.status != '2' && item.status != '3'}">(<spring:message code='ezSchedule.t166' />)</c:if>
	                                			<c:if test="${fn:length(attendantList) != status.count}">,</c:if>	                                				                                		
                                    		</span>
	                                	</c:forEach>                            
	                                </div>
	                            </td>
	                        </tr>
	                        </c:if>	                        
	                        <tr>
	                            <th style="white-space:nowrap">
	                                <spring:message code='ezSchedule.t312' />
	                            </th>
	                            <td style="white-space:nowrap">
	                                <div id="LabelDate">
	                                    <!-- <asp:Label ID="LabelDate" runat="server"></asp:Label> -->
	                                    <c:out value="${dateString}" />
	                                </div>
	                            </td>
	                            <th style="white-space:nowrap">
	                                <spring:message code='ezSchedule.t313' />
	                            </th>
	                            <td>
	                                <div style="word-break: break-all; overflow-y: auto; height: 17px; padding-top: 2px" id="LabelLocation">	                                    
	                                    <c:out value="${scheduleInfo.location }" />
	                                </div>
	                            </td>
	                        </tr>
	                        <tr>
	                            <th style="white-space:nowrap">
	                                <spring:message code='ezSchedule.t314' />
	                            </th>
	                            <td colspan="3">
	                                <div style="word-break: break-all; overflow-y: auto; height: 17px; padding-top: 2px" id="LabelSubject">	                                    
	                                    <c:out value="${scheduleInfo.title}" />
	                                </div>
	                            </td>
	                        </tr>
	                    </table>
	                </td>            
	            </tr>
	            <tr>
	                <td class="pad1" style="vertical-align: top; height: 100%" id="messagetd">
	                    <div id="message" style="border: #b6b6b6 1px solid; padding-left: 5px; overflow: auto;width: 99.1%; padding-top: 6px; height: 370px; background-color: white"></div>
	                </td>
	            </tr>
	            <tr>
	                <td height="20">
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
	                </td>
	            </tr>
	        </table>
	        <div id="printScreen" style="display: none">
	            <table class="popuplist" style="width:100%">
	                <tr>
	                    <th style="white-space:nowrap"><spring:message code='ezSchedule.t161' />
	                    </th>
	                    <td style="white-space:nowrap">
	                        <div id="printCreator"></div>
	                    </td>
	                </tr>
	                <tr>
	                    <th style="white-space:nowrap">
	                        <spring:message code='ezSchedule.t306' />
	                    </th>
	                    <td>
	                        <div id="printCreateDate"></div>
	                    </td>
	                </tr>	                
	                <tr>
	                    <th style="white-space:nowrap">
	                        <spring:message code='ezSchedule.t309' />
	                    </th>
	                    <td>
	                        <div id="printIsPublic"></div>
	                    </td>
	                </tr>
	                <tr>
	                    <th style="white-space:nowrap"><spring:message code='ezSchedule.t310' />
	                    </th>
	                    <td>
	                        <div id="printImportance"></div>
	                    </td>
	                </tr>
	                <tr>
	                    <th style="white-space:nowrap"><spring:message code='ezSchedule.t163' />
	                    </th>
	                    <td>
	                        <div id="printAttendant"></div>
	                    </td>
	                </tr>
	                <tr>
	                    <th style="white-space:nowrap">
	                        <spring:message code='ezSchedule.t318' />
	                    </th>    
	                    <td>
	                        <div id="printDate"></div>
	                    </td>
	                </tr>
	                <tr>
	                    <th style="white-space:nowrap">
	                        <spring:message code='ezSchedule.t273' />
	                    </th>
	                    <td>
	                        <div id="printLocation"></div>
	                    </td>
	                </tr>
	                <tr>
	                    <th style="white-space:nowrap">
	                        <spring:message code='ezSchedule.t272' />
	                    </th>
	                    <td>
	                        <div id="printTitle"></div>
	                    </td>
	                </tr>
	                <tr>
	                    <th style="white-space:nowrap">
	                        <spring:message code='ezSchedule.t319' />
	                    </th>
	                    <td>
	                        <div id="printAttach"></div>
	                    </td>
	                </tr>	                
	                <tr>
	                    <td colspan="2">
	                        <div id="printDocument" style="padding-right: 5px; padding-left: 5px;padding-bottom: 5px; width: 100%; padding-top: 5px; text-align:left"></div>
	                    </td>
	                </tr>
	            </table>
	        </div>	
	        <script type="text/javascript">
				selToggleList(document.getElementById("menu"), "ul", "li", "0");
				selToggleList(document.getElementById("close"), "ul", "li", "0");
	        </script>	
	    </form>
	</body>
</html>