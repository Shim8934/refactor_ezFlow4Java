<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezAttitude.t287' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt_util.js')}"></script>
		
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}" type="text/css" >
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}" type="text/css" >
		<link rel="stylesheet" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" type="text/css" />
		
		<script type="text/javascript" src="${util.addVer('/js/ezSchedule/schedule_write_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSchedule/Calendar/TabMenu.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezSchedule/lang/ezSchedule.js')}"></script>
		
		<script type="text/javascript">
			var userId = "<c:out value='${userId}'/>";
			var formHtml = '${formInfo.formHtml}';
			var typeId = "<c:out value='${attitudeInfo.typeId}'/>";
			var typeName = "<c:out value='${attitudeInfo.typeName}'/>";
			var writerName = "<c:out value='${attitudeInfo.writerName}'/>";
			var region = "<c:out value='${attitudeInfo.region}'/>";
			var mobile = "<c:out value='${attitudeInfo.mobile}'/>";
			var bizSub = "<c:out value='${attitudeInfo.bizSub}'/>";
			var attitudeId = "<c:out value='${attitudeInfo.attitudeId}'/>";
			var dateType = "<c:out value='${attitudeInfo.dateType}'/>";
			var startDate = "<c:out value='${attitudeInfo.startDate}'/>";
			var endDate = "<c:out value='${attitudeInfo.endDate}'/>";
			var font = "<c:out value='${font}'/>"
			var g_attendant = null;
			var namelength = 0;
			var checknametype = "";
			var schedule_select_attendant_dialogArguments = new Array();
			
			
			window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		    }
			
			window.onload = function () {
				setHtml();
			}
			
			window.onresize = function () {   	
                document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 280 + "PX";
		    }
			
			function Editor_Complete() {
				message.SetEditorContent("");
		    }
			
			function setHtml() {
				
				var tempHtml = "";
				
				tempHtml += "<tr>";
				tempHtml += "<th rowspan='2' style='border-bottom:0px'><spring:message code='ezAttitude.t282' /></th>";
				tempHtml += "<td colspan='7' id ='itemList' style='padding-left:2px;'>";
				tempHtml += "<a class='imgbtn imgbck'><span id='clickbtn' onclick='_manage_attendant()'><spring:message code='ezAttitude.t283' /></span></a>";
				tempHtml += "</td>";
				tempHtml += "</tr>";
				tempHtml += "<tr>";
				tempHtml += "<td colspan='3' id ='itemList' style='border-bottom:0px'>";
				tempHtml += "<input name='Input' id='receiverinput' style='WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box; display:none;' onkeyup='return on_keydown(event)'>";
				tempHtml += "<div id='receiverlist' style='OVERFLOW-Y: auto; HEIGHT: 28px; display: inline;'></div>";
				tempHtml += "<div id='receiverlist2' style='OVERFLOW-Y: auto; HEIGHT: 17px; display:none;'></div>";
				tempHtml += "<div id='receiverID' style='OVERFLOW-Y: auto; HEIGHT: 17px; display:none;'></div>";
				tempHtml += "</td>";
				tempHtml += "</tr>";
				
				
				$("#attiInfoView").append(formHtml);
				
				$("#attiInfoView tr td *").remove();
				
				$("#attiInfoView").append(tempHtml);
				//$("#attiInfoView tr").eq(3).css("display", "none");
				$("#attiInfoView tr").eq(4).css("display", "none");
				
				/* for(var i = 0; i <= listSize; i ++) {
					if (i == 0) {
		            	document.getElementById("receiverlist").innerHTML = rtn["name"][i];
		            	document.getElementById("receiverID").innerHTML = rtn["id"][i];
		            	document.getElementById("receiverlist2").innerHTML = rtn["name1"][i];
		            } else {
		            	document.getElementById("receiverlist").innerHTML += ", " + rtn["name"][i];
		            	document.getElementById("receiverID").innerHTML += ", " + rtn["id"][i];
		            	document.getElementById("receiverlist2").innerHTML += ", " + rtn["name1"][i];
		            }

				} */
				
				//유형명
            	typeName = ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(typeName, "&amp;", "&"), "&#39;", "'"), "&lt;", "<"), "&gt;", ">"), "&quot;", '"'), "&amp;", "&");
				
				var uselang = "<c:out value='${userInfo.lang}'/>";
				if (uselang != "1") {		
					$("#writerName").siblings("th").text("<spring:message code='ezAttitude.t93'/>");
					$("#attiTime").siblings("th").text("<spring:message code='ezAttitude.t149'/>");
					$("#mobile").siblings("th").text("<spring:message code='ezOrgan.t285'/>");
					$("#bizsub").siblings("th").text("<spring:message code='ezAttitude.t311'/>");
				}
								
				$("#typeName").text(" " + typeName);
				$("#writerName").text(" " + writerName);
				$("#region").html(" " + region);
				$("#mobile").html(" " + mobile);
				//$("#bizsub").html(" " + bizSub);
				
				$.ajax({
	    			data : "GET",
	    			dataType : "json",
	    			url : "/ezAttitude/getAttitudeAprInfo.do",
	    			data : {
	    				attitudeId : attitudeId
    				},
	    			success : function(result) {
						if (result.list.length > 0) {
							if (g_attendant == null) {
 			                	g_attendant = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array() };
							}
							result.list.forEach(function(vo, i) {
								if(userId != vo.aprMemberId) {
									if (i == 1) {
						            	document.getElementById("receiverlist").innerHTML = vo.aprMemberName;
						            	document.getElementById("receiverID").innerHTML = vo.aprMemberId;
						            	document.getElementById("receiverlist2").innerHTML = vo.aprMemberName;
						            } else {
						            	document.getElementById("receiverlist").innerHTML += ", " + vo.aprMemberName;
						            	document.getElementById("receiverID").innerHTML += ", " + vo.aprMemberId;
						            	document.getElementById("receiverlist2").innerHTML += ", " + vo.aprMemberName;
						            }
						            g_attendant["name"][i - 1] = vo.aprMemberName;
			    			        g_attendant["id"][i - 1] = vo.aprMemberId;
								}
							});
			    		}
	    			},
	    			error : function() {
	    				alert("<spring:message code='ezAttitude.t59'/>");
	    			}
	    		});
				
				
				var showTime = "";
				switch (dateType) {
					case "1":
						showTime = startDate.substring(0, 10);
						break;
					case "2":
						showTime = startDate.substring(0, 16);
						break;
					case "3":
						showTime = startDate.substring(0, 16) + " ~ " + endDate.substring(11, 16);
						break;
					case "4":
						showTime = startDate.substring(0, 10) + " ~ " + endDate.substring(0, 10);
						break;
					case "5":
						showTime = startDate.substring(0, 16) + " ~ " + endDate.substring(0, 16);
						break;
				}
				
				$("#attiTime").text(" " + showTime);
			}
			
			//삭제
			function saveCancelAnnual() {
				
				var idList = "";
		    	
				if(g_attendant != null) {
			    	for (var i = 0; i < g_attendant.id.length; i++) {
			    		idList += g_attendant.id[i] + ","
			    	}
				}
				
				var obj = new Object();
				obj.attitudeId = attitudeId;
		    	obj.content = message.GetEditorContent();
		    	obj.idList = idList.slice(0,-1);
				$.ajax({
					type : "POST",
					async : true,
					url : "/ezAttitude/saveCancelAnnual.do",
					dataType : "text",
					data : obj,
					success : function(resultStatus) {
	            		if (resultStatus == "success") {
	            			try {
								window.opener.getUserAnnualList();
								window.opener.parent.frames["left"].getAttitudeList();
								//신청갯수
						    	window.opener.parent.frames["left"].leftAnnualCount();
	            			} catch (e) { }
							window.close();
	            		} else {
	            			alert("<spring:message code='ezAttitude.t175' />");
	            		}
					},
					error: function(xhr, status, error){
				    	alert("<spring:message code='ezAttitude.t175' />");
				    }
				})
			}
			
			//메일로발송
			function sendMailAttitude() {
				var pheight = window.screen.availHeight;
				var conHeight = pheight * 0.8;
				var pwidth = window.screen.availwidth;
				var pTop = (pheight - conHeight) / 2;
				var pLeft = (pwidth - 1200) / 2;
				var szUrl = "/ezEmail/mailWrite.do?attitudeId=" + attitudeId + "&cmd=attitude";
				window.open(szUrl, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height=" + conHeight + "px, width=1200px, status=no, toolbar=no, menubar=no, location=no, resizable=1");
				window.close();
			}
			
			function _manage_attendant() {
			    check_name("attendant");
			}
			
			function check_name(type) {
			    if (type != undefined)
			        checknametype = type;
			    else
			        checknametype = "";

			    var name = document.getElementById("receiverinput").value;
			    name = ReplaceText(name, ",", ";");

			    var names = name.split(";");
			    namelength = names.length;

			    for (; i < names.length; i++) {
			        names[i] = TrimText(names[i]);

			        if (names[i] == "")
			            continue;

			        var adCount = 0;        
			        var xmlDOM = createXmlDom();
			        
			        $.ajax({
			    		type : "POST",
			    		dataType : "text",
			    		async : false,
			    		url : "/ezOrgan/getSearchList.do",
			    		data : {
			    			search : "displayName::" + names[i],
			    			cell   : "company;description;title;displayName;mail",
			    			prop   : "displayName;description",
			    			type   : "user"
			    		},
			    		success: function(xml){
			    			xmlDOM = loadXMLString(xml);
			                adCount = xmlDOM.getElementsByTagName("ROW").length;    			
			    		}    		
			    	});

			        if (adCount == 0) {
			            alert("'" + names[i] + "'" + strLang21);
			            continue;
			        } else if (adCount == 1) {
			            if (g_attendant == null)
			                g_attendant = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array() };

			            if (getNodeText(xmlDOM.getElementsByTagName("DATA2")[0]) != userid) {
			                var length = g_attendant["name"].length;

			                for (var j = 0; j < length; j++) {
			                    if (g_attendant["id"][j] == getNodeText(xmlDOM.getElementsByTagName("DATA2")[0])) {
			                        alert(strLang22);
			                        return;
			                    }
			                }
			            } else {
			                alert(strLang24);
			                return;
			            }

			            g_attendant["name"][length] = getNodeText(GetChildNodes(SelectNodes(xmlDOM, "LISTVIEWDATA/ROWS/ROW")[0])[3])
			            g_attendant["id"][length] = getNodeText(xmlDOM.getElementsByTagName("DATA2")[0]);
			            g_attendant["deptname"][length] = getNodeText(xmlDOM.getElementsByTagName("DATA7")[0]);
			            g_attendant["name1"][length] = getNodeText(xmlDOM.getElementsByTagName("DATA5")[0]);
			            g_attendant["name2"][length] = getNodeText(xmlDOM.getElementsByTagName("DATA6")[0]);
			            g_attendant["deptname2"][length] = getNodeText(xmlDOM.getElementsByTagName("DATA8")[0]);

			            if (length == 0) {
			            	document.getElementById("receiverlist").innerHTML = g_attendant["name"][length];
			            	document.getElementById("receiverlist2").innerHTML = g_attendant["name2"][length];            	
			            }
			            else {
			            	document.getElementById("receiverlist").innerHTML += ", " + g_attendant["name"][length];
			            	document.getElementById("receiverlist2").innerHTML += ", " + g_attendant["name2"][length];
			            }
			        } else {
			            var rgParams = new Array();
			            rgParams["addrBook"] = xmlDOM;
			            rgParams["name"] = "";
			            rgParams["id"] = "";
			            rgParams["deptname"] = "";
			            rgParams["name1"] = "";
			            rgParams["name2"] = "";
			            rgParams["deptname2"] = "";

			            checkname_cross_dialogArguments[0] = rgParams;       
			            checkname_cross_dialogArguments[1] = check_name_Complete;
			            DivPopUpShow(610, 293, "/ezSchedule/checkName.do");
			            i++;
			            return;
			        }
			    }
			    document.getElementById("receiverinput").value = "";
			    i = 0;
			    if (checknametype != "")
			        manage_attendant_after();
			}
			
			function manage_attendant_after() {
			    schedule_select_attendant_dialogArguments[0] = g_attendant;
			    schedule_select_attendant_dialogArguments[1] = manage_attendant_Complete;

			    GetOpenWindow("/ezAttitude/attitudeSelectReference.do", "schedule_select_attendant", 970, 680);
			}
			
			function manage_attendant_Complete(rtn) {
			    if (typeof (rtn) != "undefined") {
			        g_attendant = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "jikwe": new Array(), "phone": new Array() };
			        document.getElementById("receiverlist").innerHTML = "";
			        
			        for (var i = 0; i < rtn["id"].length; i++) {
			            if (i == 0) {
			            	document.getElementById("receiverlist").innerHTML = rtn["name"][i];
			            	document.getElementById("receiverID").innerHTML = rtn["id"][i];
			            	document.getElementById("receiverlist2").innerHTML = rtn["name1"][i];
			            } else {
			            	document.getElementById("receiverlist").innerHTML += ", " + rtn["name"][i];
			            	document.getElementById("receiverID").innerHTML += ", " + rtn["id"][i];
			            	document.getElementById("receiverlist2").innerHTML += ", " + rtn["name1"][i];
			            }

			            g_attendant["name"][i] = rtn["name"][i];
			            g_attendant["id"][i] = rtn["id"][i];
			            g_attendant["deptname"][i] = rtn["deptname"][i];
			            g_attendant["name1"][i] = rtn["name1"][i];
			            g_attendant["name2"][i] = rtn["name2"][i];
			            g_attendant["deptname2"][i] = rtn["deptname2"][i];
			            g_attendant["jikwe"][i] = rtn["jikwe"][i];
			            g_attendant["phone"][i] = rtn["phone"][i];

			        }
			    }
			}
			
		</script>
	</head>
	<body class="popup" style="overflow:hidden;">
		<form method="post">
	        <div id="main_body">
	            <table id="normalScreen" class="layout">
	                <tr>
	                    <td style="height: 20px">
	                        <div id="menu">
	                        	<ul id="menuTable">	
	                                <li class="sel"><h1 style="padding:0px; margin-top:-5px;"><spring:message code='ezAttitude.t287' /></h1></li>
	                            </ul>
	                        </div>
	                        <div id="close">
	                            <ul>
	                                <li><span onclick="window.close()"></span></li>
	                            </ul>
	                        </div>
	                    </td>
	                </tr>
	                <tr>
	                    <td style="height: 20px">
	                        <table id="attiInfoView" class="content" style="margin-top:5px">
	                               <tr id="HolderWrite">
	                                   <th><spring:message code='ezAttitude.t134'/></th>
	                                   <td id="typeName" colspan="2">
	                                   </td>
	                               </tr>
	                        </table>
	                    </td>
	                </tr>
	                <tr>
	                    <td style="vertical-align:top;height:100%;" id="EdtorSize">
		                    <iframe id="message" class="viewbox" name="message" src="/ezEditor/selectEditor.do" style="padding:0; height:100%; width:100%; overflow:auto; margin-top:-1px"></iframe>
	                    </td>
	                </tr>
	            </table>
	            <div class="btnpositionNew" id="menuTable">
	            	<c:if test="${userId == attitudeInfo.writerId}">
						<a class="imgbtn"><span onclick="saveCancelAnnual();"><spring:message code='ezAttitude.t16' /></span></a>
					</c:if>
	            </div>
	        </div>
	        <script type="text/javascript">
		        document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 280 + "PX";
		    </script>
	    </form>
	</body>
</html>