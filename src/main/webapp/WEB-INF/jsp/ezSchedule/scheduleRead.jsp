<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
			<%-- ${title} --%>
		</title>
		<style> P { MARGIN-BOTTOM: 0mm; MARGIN-TOP: 0mm; line-height:20px }</style>
		<script>
			var contentpath = "${scheduleInfo.contentPath}";
			<%-- var ownerid = "<%= _ownerid %>"; --%>
			<%-- var creatorid = "<%= _creatorid %>"; --%>
			<%-- var modifierid = "<%= _modifierid %>"; --%>
			var scheduletype = "${_scheduletype}";
			<%-- var scheduleid = "<%= _scheduleid %>";
			var parentid = "<%= _parentid %>";
			var repeatcount = "<%= _repeatcount %>";
			var admin = "<%= _admin %>";
			var userid = "<%= userinfo.UserID %>";
			var groupname = "<%= groupname %>";
			var datetype = "<%= _datetype %>";
			var changekey = "<%= _changekey %>";
			var pattern = "<%= _pattern %>";
			var pageFrom = "<%= pageFrom %>";
			var s_DateForAttandant = "<%= s_DateForAttandant %>";
			var e_DateForAttandant = "<%= e_DateForAttandant %>";
			var _otherid = "<%= otherid %>";
	        var pUse_Editor = "<%= Use_Editor%>";
	        var use_exchange_pims = "<%= _use_exchange_pims %>";
	        var ResourceInfo = "<%= ResourceInfo %>"; --%>
	        
	        window.onload = function () {	            
                if (document.getElementById('managespan') && (scheduletype != "1" && scheduletype != "6")) {
                    managespan.style.display = "none";
                    manageli.style.display = "none";
                }
                
                var html = "";
alert(contentpath);

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
						html = result;
					}        			
				});
alert(html);                
				var doc = document.getElementById('message').contentWindow.document;
				doc.open();
				doc.write(html);
				doc.close();
				
                <%-- var URL = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/ezCommon_InterFace.aspx?TYPE=SCHEDULECONTENT&DOCID=" + "<%= _contentpath %>";
                var tempStr = ConvertMHTtoHTML(URL);
                var tempXML = createXmlDom();
                var XmlBodyATT = createXmlDom();
                var XmlBodyDATA = createXmlDom();
                tempXML = loadXMLString(tempStr);
                XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
                XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
                document.getElementById('message').innerHTML = getNodeText(XmlBodyDATA); --%>
	            
	            window.onresize();
	        }
	
	        window.onresize = function () {
	            if (document.all.message.style.width != document.body.clientWidth - 25)
	                document.all.message.style.width = document.body.clientWidth - 25;
	
	            if ((scheduletype != "1" && scheduletype != "6" && scheduletype != "7") || (use_exchange_pims != "YES" && scheduletype != "7" && scheduletype != "1")) {
	                if (document.getElementById('managespan') && (scheduletype != "1" && scheduletype != "6")) {
	                    document.getElementById("messagetd").style.height = document.body.clientHeight - 250 + "PX";
	                }
	            }
	            else
	                document.getElementById("messagetd").style.height = document.body.clientHeight - 298 + "PX";
	        }
				
	        function show_personinfo(userid) {
	            if (userid == "0")
	                userid = creatorid;
	            else if (userid == "1")
	                userid = modifierid;
	
	            var feature = GetOpenPosition(420, 450);
	            if (userid.indexOf('@') > 0)
	                window.open("/myoffice/common/ShowPersonInfo.aspx?email=" + userid, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	            else
	                window.open("/myoffice/common/ShowPersonInfo.aspx?id=" + userid, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	        }
	
	        function group_info() {
	            var feature = GetOpenPosition(430, 450);
	            window.open("/myoffice/ezSchedule/schedule_group_info.aspx?id=" + ownerid + "&scheduleid=" + scheduleid, "",
	                "height = 451px, width = 430px, status = no, toolbar=no, menubar=no,location=no, resizable=0" + feature);
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
			                location.href = "/myoffice/common/DownloadAttach.aspx?filepath=/Upload_Schedule/File/" + GetAttribute(checks.item(suffix), "filepath") + "&filename=" + GetAttribute(checks.item(suffix++), "filename");
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
	            window.open("schedule_manage_attendant_Cross.aspx?ownerid=" + ownerid + "&id=" + encodeURIComponent(scheduleid) + "&changekey=" + encodeURIComponent(changekey) + "&type=" + scheduletype + "&dtype=" + datetype + "&pattern=" + pattern + "&StartTime=" + s_DateForAttandant + "&EndTime=" + e_DateForAttandant, "",
	                "height = 355px, width = 530px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=0");
	        }
	
	        function delete_schedule() {
	            if (!confirm("<spring:message code='ezSchedule.t209' />"))
	                return;
	
	            var ResourceDel = "FALSE";;
	            if (ResourceInfo != "") {
	                confirm("<spring:message code='ezSchedule.t1300' />") ? ResourceDel = "TRUE" : ResourceDel = "FALSE";
	            }
	
	            var xmlHTTP = createXMLHttpRequest();
	            var xmlDom = createXmlDom();
	
	            var objNode;
	            createNodeInsert(xmlDom, objNode, "DATA");
	            createNodeAndInsertText(xmlDom, objNode, "SCHEDULEID", scheduleid);
	            createNodeAndInsertText(xmlDom, objNode, "SCHEDULETYPE", scheduletype);
	            createNodeAndInsertText(xmlDom, objNode, "DATETYPE", datetype);
	            createNodeAndInsertText(xmlDom, objNode, "PATTERN", pattern);
	            createNodeAndInsertText(xmlDom, objNode, "OTHERID", _otherid);
	
	            xmlHTTP.open("POST", "remote/schedule_delete.aspx?RESDEL=" + ResourceDel, false);
	            xmlHTTP.send(xmlDom);
	
	            if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK") {
	                alert("<spring:message code='ezSchedule.t212' />");
	            } else {
	                alert("<spring:message code='ezSchedule.t213' />");
	
	                try { window.opener.RefreshView() } catch (e) { }
	
	                if (window.opener.reload != undefined)
	                    window.opener.reload();
	                window.close();
	            }
	        }
				
	        function edit_schedule() {
	            var id = scheduleid;
	            var win = null;
	
	            var pheight = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            var pTop = (pheight - 760) / 2;
	            var pLeft = (pwidth - 790) / 2;
	            if (CrossYN() || pNoneActiveX == "YES") {
	                win = window.open("schedule_write_Cross.aspx?id=" + encodeURIComponent(id) + "&type=" + scheduletype + "&datetype=" + datetype + "&pattern=" + pattern + "&pageFrom=" + pageFrom + "&otherid=" + _otherid, "",
	                                    "height = 830px, width = 790px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
	            } else {
	                if (pUse_Editor == "" || pUse_Editor == "CK") {
	                    win = window.open("schedule_write.aspx?id=" + encodeURIComponent(id) + "&type=" + scheduletype + "&datetype=" + datetype + "&pattern=" + pattern + "&pageFrom=" + pageFrom + "&otherid=" + _otherid, "",
	                                        "height = 760px, width = 790px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
	                } else {
	                    win = window.open("schedule_write_IE.aspx?id=" + encodeURIComponent(id) + "&type=" + scheduletype + "&datetype=" + datetype + "&pattern=" + pattern + "&pageFrom=" + pageFrom + "&otherid=" + _otherid, "",
	                                        "height = 760px, width = 790px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
	                }
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
	  <%--           <% if (_scheduletype == "1" || _scheduletype == "6")
	            { %>
	            printAttendant = getNodeText(document.getElementById("LabelAttendant"));
	            <% } %> --%>
	            printDate = getNodeText(document.getElementById("LabelDate"));
	            printLocation = getNodeText(document.getElementById("LabelLocation"));
	            printTitle = getNodeText(document.getElementById("LabelSubject"));
	            printDocument = document.getElementById("message").innerHTML;
	            printAttach = document.getElementById("attachedfileDIV").innerHTML;
	
	            var params = { 'type': 'READ', 'printCreator': printCreator, 'printCreateDate': printCreateDate, 'printAttendant': printAttendant, 'printIsPublic': printIsPublic, 'printImportance': printImportance, 'printRepetition': printRepetition, 'printDate': printDate, 'printLocation': printLocation, 'printTitle': printTitle, 'printAttach': printAttach, 'printDocument': printDocument };
	
	            post_to_url("schdule_ContentsPirnt.aspx", params, "post");
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
	                    <%-- <% if(!isGoogleSchedule){ %>
	                    <div id="menu">
	                        <ul>
	                            <asp:PlaceHolder ID="HolderEdit" runat="server">
	                                <li><span onclick="edit_schedule()">
	                                    <spring:message code='ezSchedule.t302' />
	                                </span></li>
	                                <li><span onclick="delete_schedule()">
	                                    <spring:message code='ezSchedule.t215' />
	                                </span></li>
	                                <% if (_isMeCreate == true)
	                                   { %>
	                                <li id ="manageli"><span id=managespan onclick="manage_attendant()">
	                                    <spring:message code='ezSchedule.t303' />
	                                </span></li>
	                                <% }  %>
	                            </asp:PlaceHolder>
	                            <li><span onclick="Print_onClick()">
	                                <spring:message code='ezSchedule.t217' />
	                            </span></li>
	                            
	                            <asp:PlaceHolder ID="HolderGroup" runat="server" Visible="False">
	                                <li><span onclick="group_info()">
	                                    <spring:message code='ezSchedule.t305' />
	                                </span></li>
	                            </asp:PlaceHolder>
	                        </ul>
	                    </div>
	                    <%}else{ %>
	                    <div id="menu">
	                        <ul>
	                            <li></li>
	                        </ul>
	                    </div>
	                    <%} %> --%>
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
	                         <%-- <% if (_scheduletype == "7") { %>
	                          <tr>
	                            <th style="white-space:nowrap">
	                                <spring:message code='ezSchedule.t159' />
	                            </th>
	                            <td colspan="3" style="white-space:nowrap; width:240px;">
	                                <div style="cursor: pointer;">
	                                    <asp:Label ID="LabelGroup" runat="server"></asp:Label>
	                                </div>
	                            </td>                            
	                        </tr>
	                        <% } %> --%>
	                        <tr>
	                            <th style="white-space:nowrap">
	                                <spring:message code='ezSchedule.t161' />
	                            </th>
	                            <td style="white-space:nowrap; width:240px;">
	                                <div style="cursor: pointer;" onclick="show_personinfo('0')">
	                                    <!-- <asp:Label ID="LabelCreator" runat="server"></asp:Label> -->
	                                </div>
	                            </td>
	                            <th style="white-space:nowrap; width:80px">
	                                <spring:message code='ezSchedule.t306' />
	                            </th>
	                            <td style="white-space:nowrap; width:100%">
	                                <div>
	                                    <!-- <asp:Label ID="LabelCreateDate" runat="server"></asp:Label> -->
	                                </div>
	                            </td>
	                        </tr>
	                        
	                        <%-- <% if(!isGoogleSchedule){ %>
	                        <tr>
	                            <th style="white-space:nowrap">
	                                <spring:message code='ezSchedule.t309' />
	                            </th>
	                            <td>
	                                <div>
	                                    <asp:Label ID="LabelPublic" runat="server"></asp:Label></div>
	                            </td>
	                            <th style="white-space:nowrap">
	                                <spring:message code='ezSchedule.t310' />
	                            </th>
	                            <td>
	                                <div>
	                                    <asp:Label ID="LabelImportance" runat="server"></asp:Label></div>
	                            </td>
	                        </tr>
	                        <% if (_scheduletype == "1" || _scheduletype == "6")
	                           { %>
	                        <tr>
	                            <th style="white-space:nowrap">
	                                <spring:message code='ezSchedule.t311' />
	                            </th>
	                            <td colspan="3" width="100%">
	                                <div style="overflow-y: auto; height: 17px; padding-top: 2px">
	                                    <asp:Label ID="LabelAttendant" runat="server"></asp:Label></div>
	                            </td>
	                        </tr>
	                        <%} %>
	                        <%} %> --%>
	                        <tr>
	                            <th style="white-space:nowrap">
	                                <spring:message code='ezSchedule.t312' />
	                            </th>
	                            <td style="white-space:nowrap">
	                                <div>
	                                    <!-- <asp:Label ID="LabelDate" runat="server"></asp:Label> -->
	                                </div>
	                            </td>
	                            <th style="white-space:nowrap">
	                                <spring:message code='ezSchedule.t313' />
	                            </th>
	                            <td>
	                                <div style="word-break: break-all; overflow-y: auto; height: 17px; padding-top: 2px">
	                                    <!-- <asp:Label ID="LabelLocation" runat="server"></asp:Label> -->
	                                </div>
	                            </td>
	                        </tr>
	                        <tr>
	                            <th style="white-space:nowrap">
	                                <spring:message code='ezSchedule.t314' />
	                            </th>
	                            <td colspan="3">
	                                <div style="word-break: break-all; overflow-y: auto; height: 17px; padding-top: 2px">
	                                    <!-- <asp:Label ID="LabelSubject" runat="server"></asp:Label> -->
	                                </div>
	                            </td>
	                        </tr>
	                    </table>
	                </td>            
	            </tr>
	            <tr>
	                <td class="pad1" style="vertical-align: top; height: 100%" id="messagetd">
	                    <div id="message" style="border: #b6b6b6 1px solid; padding-left: 5px; overflow: auto;width: 100%; padding-top: 6px; height: 370px; background-color: white">
	                    	<%-- <%= _content %> --%>
	                    </div>
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
	                    <th style="white-space:nowrap; width:80px">
	                        <spring:message code='ezSchedule.t161' />
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
	                    <th style="white-space:nowrap">
	                        <spring:message code='ezSchedule.t310' />
	                    </th>
	                    <td>
	                        <div id="printImportance"></div>
	                    </td>
	                </tr>
	                <tr>
	                    <th style="white-space:nowrap">
	                        <spring:message code='ezSchedule.t163' />
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