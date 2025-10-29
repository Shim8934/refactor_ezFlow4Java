<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezResource.t9900013'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<style type="text/css">
		
		.content tr{
			height:25px;
		}
		.content td{
			padding-left:10px;
		}

		</style>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		  <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezResource.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezResource/datepicker.htc_cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezResource/composeappt_cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezResource/Schedule_cross.js')}"></script>
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
	        var startDateVal = "<c:out value='${startDateVal}'/>";
	        var endDateVal = "<c:out value='${endDateVal}'/>";
	        var sDT = "${startDateTime}";
	        var eDT = "${endDateTime}";
	        var ApproveFlag = "${approveFlag}";
	        var SavedApproveFlag = "${saveApproveFlag}";
	        var reFlagVal = '${reFlag}';
	        var server_name = "${serverName}";
	        var pnumVal = '${pNum}';
	        var gFlagVal = '${gresFlag}';
	        var g_fromStr = "<c:out value='${fromStr}'/>";
	        var allDayFlag = "${allDay}";
	        var ItemArray = new Array();
	        var pNoneActiveX = "${pNoneActiveX}";
	        var brdName = "${brdName}";
	        var resID = "${resID}";
	        var iframeH = "";
	        var deptID = "${deptID}";
	        var cmd = "${cmdStr}";
			var DstartDateVal = "<c:out value='${DstartDateVal}'/>";
			var DendDateVal = "<c:out value='${DendDateVal}'/>";
            var title = "${title}";
	        
	        window.onload = function () {
	            document.getElementById("displayNM").innerHTML = "<a onClick=MemberInfo_onClick('" + writerIDVal +"','" + deptID + "')>" + org_ownerNM + "</a> (" + org_deptNM + ")";

	            if (brdName != "" && resID != "") {
	                ItemArray[0] = Array(resID);
	                ItemArray[1] = Array(brdName);
	                document.getElementById('itemList').innerHTML = "${brdName}";
	            }
	            var xmlHttp = createXMLHttpRequest();
	            var xmlpara = createXmlDom();
	            var objNode;
	            createNodeInsert(xmlpara, objNode, "PARAMETER");
	            createNodeAndInsertText(xmlpara, objNode, "NUM", org_num);
	            createNodeAndInsertText(xmlpara, objNode, "OWNERID", org_ownerID);
	            createNodeAndInsertText(xmlpara, objNode, "GROUPID", "");
	            createNodeAndInsertText(xmlpara, objNode, "companyID", org_companyID);
	            
	            if (reFlagVal == "1") {
	                if (org_num != "" && org_ownerID != "") {
	                    xmlHttp.open("POST", "/ezResource/scheduleRepetitionProc.do?cmd=get", false);
	                    xmlHttp.send(xmlpara);
	                    resultXML = xmlHttp.responseXML;

	                    if (resultXML != "") {
	                        g_data["recurrence"] = getXmlString(resultXML);
	                    }
	                }
	                show_repetition_info2();
	            } else {
					if(allDayFlag == "1") {
						document.getElementById("AllDayDisplay").innerHTML = sDT.substring(0, 10) + " (" + strLang126 + ") ~ " + eDT.substring(0, 10) + " (" + strLang126 + ")";
					}
					else {
						document.getElementById("AllDayDisplay").innerHTML = sDT.substring(0, sDT.lastIndexOf(":")) + " ~ " + eDT.substring(0, eDT.lastIndexOf(":"));
					}
	            }
                
                document.getElementById("titleDIV").innerHTML = ReplaceHTML(title).replaceAll("&#092;", "\\");
	            
	            var iframeStyle = "<style>";
	            iframeStyle += "P { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; }";
	            iframeStyle += "DIV { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; }";
	            iframeStyle += "TD { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; }";
	            iframeStyle += "UL { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; }";
	            iframeStyle += "OL { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; }";
	            iframeStyle += "LI { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; }";
	            iframeStyle += "BODY { MARGIN-RIGHT: 8px; FONT-SIZE:10PT;LINE-HEIGHT:1.3; FONT-FAMILY:Malgun Gothic, Meiryo UI; }";
	            iframeStyle += "TABLE TD { text-indent: 0px }";
	            iframeStyle += "BLOCKQUOTE { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px;}";
	            iframeStyle += "</style>";	            
	            
	            var doc = document.getElementById('message').contentWindow.document;
				doc.open();
				doc.write(iframeStyle + sigBody.innerHTML);
				
				//인쇄 시 iframe의 내부 높이 조정(*img의 기본 width, height 지정 필요)
				if(doc.body == null){
					iframeH = 467 + "px";	
				}else if(doc.body.scrollHeight != null){
					iframeH = doc.body.scrollHeight + "px";
				}
				doc.close();
	            
	            var Bodytd = document.getElementById("message").getElementsByTagName("TD");
	            for (var i = 0; i < Bodytd.length; i++) {
	                if (Bodytd[i].width != "") {
	                    Bodytd[i].style.width = Bodytd[i].width + "px";
	                }
	                if (Bodytd[i].height != "") {
	                    Bodytd[i].style.height = Bodytd[i].height + "px";
	                }
	            }	            
	            document.getElementById("message").style.height = window.innerHeight - 233 + "px";
	        }
			
	        window.onresize = function () {
	        	document.getElementById("message").style.height = window.innerHeight - 233 + "px";
	        }
	        
		    function show_repetition_info2() {
		        var repeatinfo = "" + strLang122 + "";
		        xmlinDoc = createXmlDom();
		        xmlinDoc.async = false;
		        xmlinDoc = loadXMLString(g_data["recurrence"]);
		        szType = getNodeText(SelectNodes(xmlinDoc, "recurrence/frequency")[0]);
	
		        switch (szType) {
		            case "4":
		            	var selType = getNodeText(SelectNodes(xmlinDoc, "recurrence/selType")[0]);
		    			if(selType == "0") {			// 매일마다
		    				var interval = getNodeText(SelectNodes(xmlinDoc, "recurrence/interval")[0]);
		    				
		    				if(interval == "1") {
		    					repeatinfo += "" + strLang123;
		    				}
		    				else {
		    					repeatinfo += "" + interval + strLang550;
		    				}
		    			}
		    			else {
		    				repeatinfo += "" + strLang551;
		    			}
		                break;
		            case "5":
		            	var interval = getNodeText(SelectNodes(xmlinDoc, "recurrence/interval")[0]);
		    			
		    			var resdayList = getNodeText(SelectNodes(xmlinDoc, "recurrence/daysOfWeek")[0]);
		    			resdayList = resdayList.substring(0, resdayList.length - 1);
		    			
		    			if(interval == "1") {		// 매주
		    				repeatinfo += " " + strLang124 + " ";
		    			}
		    			else {
		    				repeatinfo += " " + interval + strLang552 + " ";
		    			}
		    			repeatinfo += " " + resdayList.replace("0", strLang270).replace("1", strLang271).replace("2", strLang272).replace("3", strLang273).replace("4", strLang274).replace("5", strLang275).replace("6", strLang276);
		                break;
		            case "6":
		            	var selType = getNodeText(SelectNodes(xmlinDoc, "recurrence/selType")[0]);
		    			var interval = getNodeText(SelectNodes(xmlinDoc, "recurrence/interval")[0]);
		    			
		    			if(selType == "0") {
		    				var dayOfMonth = getNodeText(SelectNodes(xmlinDoc, "recurrence/daysOfMonth")[0]);
		    				if(interval == "1") {
		    					repeatinfo += "" + strLang97 + " " + dayOfMonth + strLang270;
		    				}
		    				else {
		    					repeatinfo += interval + strLang553 + " " + dayOfMonth + strLang270;
		    				}
		    			}
		    			else {
		    				var byPosition = getNodeText(SelectNodes(xmlinDoc, "recurrence/byPosition")[0]);
		    				var daysOfWeek = getNodeText(SelectNodes(xmlinDoc, "recurrence/daysOfWeek")[0]);
		    				
		    				if(interval == "1") {
		    					repeatinfo += strLang97 + " ";
		    				}
		    				else {
		    					repeatinfo += interval + strLang553 + " ";
		    				}
		    				
		    				repeatinfo += byPosition.replace("-1", strLang558).replace("1", strLang554).replace("2", strLang555).replace("3", strLang556).replace("4", strLang557);
		    				if(daysOfWeek.length < 2) {
		    					repeatinfo += " " + daysOfWeek.replace("0", strLang561).replace("1", strLang562).replace("2", strLang563).replace("3", strLang564).replace("4", strLang565).replace("5", strLang566).replace("6", strLang567);
		    				}
		    				else if(daysOfWeek.length < 6){
		    					repeatinfo += " " + strLang560;
		    				}
		    				else {
		    					repeatinfo += " " + strLang559;
		    				}
		    			}
		                break;
		            case "7":
		            	var selType = getNodeText(SelectNodes(xmlinDoc, "recurrence/selType")[0]);
		    			var month = getNodeText(SelectNodes(xmlinDoc, "recurrence/monthsOfYear")[0]);
		    			
		    			if(selType == "0") {
		    				var day = getNodeText(SelectNodes(xmlinDoc, "recurrence/daysOfMonth")[0]);
		    				
		    				repeatinfo += "" + strLang98 + " " + month + strLang271 + " " + day + strLang278;
		    			}
		    			else {
		    				var byPosition = getNodeText(SelectNodes(xmlinDoc, "recurrence/byPosition")[0]);
		    				var daysOfWeek = getNodeText(SelectNodes(xmlinDoc, "recurrence/daysOfWeek")[0]);
		    				
		    				repeatinfo += "" + strLang98 + " " + month + strLang271 + " ";
		    				repeatinfo += byPosition.replace("-1", strLang558).replace("1", strLang554).replace("2", strLang555).replace("3", strLang556).replace("4", strLang557) + " ";
		    				if(daysOfWeek.length < 2) {
		    					repeatinfo += daysOfWeek.replace("0", strLang561).replace("1", strLang562).replace("2", strLang563).replace("3", strLang564).replace("4", strLang565).replace("5", strLang566).replace("6", strLang567);
		    				}
		    				else if(daysOfWeek.length < 6) {
		    					repeatinfo += " " + strLang560;
		    				}
		    				else {
		    					repeatinfo += " " + strLang559;
		    				}
		    			}
		                break;
		        }
		        repeatinfo += ", " + strLang125 + "";
	
		        if (allDayFlag != "1") {
		            var reStartDate = getNodeText(SelectNodes(xmlinDoc, "recurrence/startDateTime")[0]);
		            var reEndDate = getNodeText(SelectNodes(xmlinDoc, "recurrence/endDateTime")[0]);
		            var reStartHour = reStartDate.split(" ")[1].split(":")[0];
		            var reEndHour = reEndDate.split(" ")[1].split(":")[0];
	
		            var reStartMinute = reStartDate.split(" ")[1].split(":")[1];
		            var reEndMinute = reEndDate.split(" ")[1].split(":")[1];
	
		            if (Number(reStartHour) == 0)
	                    reStartHour = 12;
		            /* if (Number(reStartHour) < 12) {
		                repeatinfo += "" + strLang246 + " ";
	
		                if (Number(reStartHour) == 0)
		                    reStartHour = 12;
		            }
		            else {
		                repeatinfo += "" + strLang247 + " ";
	
		                if (Number(reStartHour) > 12)
		                    reStartHour = Number(reStartHour) - 12;
		            } */
	
		            repeatinfo += reStartHour + ":" + reStartMinute + "" + " ~ " + "";
	
		            if (Number(reEndHour) == 0)
	                    reEndHour = 12;
		            /* if (Number(reEndHour) < 12) {
		                repeatinfo += "" + strLang246 + " ";
	
		                if (Number(reEndHour) == 0)
		                    reEndHour = 12;
		            }
		            else {
		                repeatinfo += "" + strLang247 + " ";
	
		                if (Number(reEndHour) > 12)
		                    reEndHour = Number(reEndHour) - 12;
		            } */
	
		            repeatinfo += reEndHour + ":" + reEndMinute;
		        }
		        else
		            repeatinfo += strLang126;
				
		        repeatinfo += ", " + strLang580 + getNodeText(xmlinDoc.getElementsByTagName("startDateTime")[0]).split(' ')[0] + " ~ ";
	
		        if (getNodeText(xmlinDoc.getElementsByTagName("endRecurType")[0]) == "0") {
		            repeatinfo += strLang581;
		        } else if (getNodeText(xmlinDoc.getElementsByTagName("endRecurType")[0]) == "1") {
		            repeatinfo += getNodeText(xmlinDoc.getElementsByTagName("instances")[0]) + strLang582;
		        } else if (getNodeText(xmlinDoc.getElementsByTagName("endRecurType")[0]) == "2") {
		            repeatinfo += getNodeText(xmlinDoc.getElementsByTagName("endDateTime")[0]).split(' ')[0];
		        }
		        
		        document.getElementById("AllDayDisplay").innerHTML = repeatinfo;
		    }

	        function btn_modify() {
	        	var win = null;
	            var pheight = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            var pTop = (pheight - 760) / 2;
	            var pLeft = (pwidth - 790) / 2;
	            if (CrossYN() || pNoneActiveX == "YES") {
	                filename = "/ezResource/persPortletAdd.do";
	            }
	            else {
                    filename = "/ezResource/persPortletAdd.do";
	            }
	    	    if (CrossYN()) {
	                win = window.open(filename + "?cmd=mod&from=schedule&" + "num=" + org_num + "&ownerID=" + org_ownerID + "&type=" + typeVal + "&startDate=" + startDateVal + "&endDate=" + endDateVal, "",
	                                    "height = 700, width = 820, top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
	            } else {
	            	win = window.open(filename + "?cmd=mod&from=schedule&" + "num=" + org_num + "&ownerID=" + org_ownerID + "&type=" + typeVal + "&startDate=" + startDateVal + "&endDate=" + endDateVal, "",
                            "height = 700, width = 820, top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
	
	            }
	    	    win.opener = window.opener;
	    	    window.close();
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
	            
	            onbeforeprint2();

	            var feature = GetOpenPosition(800, 700);
	            printWindow = window.open("", "mywindow", "width=800, height=700,location=0,status=0,scrollbars=1,resizable=1" + feature);
	            var strContent = "<html><head>";
	            strContent = strContent + "<title>" + strLangLHM02 + "</title>";
	            strContent = strContent + "<link rel=\"stylesheet\" href=\"/css/" + strLangLHM01 + ".css\" type=\"text/css\" />";
	            strContent = strContent + "<style> .content2 tr{height:30px;} .content2 td{padding-left:10px;} </style>";
	            strContent = strContent + "</head><body style='padding:10px;'onload='window.print();' >";
	            strContent = strContent + "<div style='width:100%'><table id='printScreen' class='layout'>";
	            strContent = strContent + document.getElementById("printScreen").innerHTML;
	            strContent = strContent + "</table></div>";
	            strContent = strContent + "</body>";
	            printWindow.document.write(strContent);

	            var iframeStyle = "<style>";
	            iframeStyle += "P { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; }";
	            iframeStyle += "DIV { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; }";
	            iframeStyle += "TD { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; }";
	            iframeStyle += "UL { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; }";
	            iframeStyle += "OL { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; }";
	            iframeStyle += "LI { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; }";
	            iframeStyle += "BODY { MARGIN-RIGHT: 8px; FONT-SIZE:10PT;LINE-HEIGHT:1.3; FONT-FAMILY:Malgun Gothic, Meiryo UI }";
	            iframeStyle += "TABLE TD { text-indent: 0px }";
	            iframeStyle += "BLOCKQUOTE { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px;}";
	            iframeStyle += "</style>";
	            
	            var iframe = printWindow.document.getElementById("printDocument");

	            iframe.style.border = "0px";
	            iframe.style.minHeight = "467px";
	            iframe.style.height = iframeH;
	            
	            var doc = iframe.document;

	            if (iframe.contentDocument)
	              doc = iframe.contentDocument; // For NS6
	            else if(iframe.contentWindow)
	              doc = iframe.contentWindow.document; // For IE5.5 and IE6
	             
	            // Put the content in the iframe
	            doc.open();
	            doc.writeln(iframeStyle+sigBody.innerHTML);
	            doc.close();
            
	            printWindow.document.close();
	            printWindow.focus();
	        }

	        function onbeforeprint2() {
	            document.getElementById("printOwner").textContent = document.getElementById("displayNM").textContent;
	            document.getElementById("printImportance").textContent = document.getElementById("importanceDIV").textContent;
	            document.getElementById("printDate").textContent = document.getElementById("AllDayDisplay").textContent;
	            document.getElementById("printItem").textContent = document.getElementById("itemList").textContent;
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
	                    createNodeAndInsertText(xmlDOM, objNode, "STARTDATETIME", sDT);
	                	createNodeAndInsertText(xmlDOM, objNode, "ENDDATETIME", eDT);
	                    xmlHTTP.open("POST", "/ezResource/sendMailToUser.do", false);
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
					
	                window.close();
	            }
	        }

	        function MemberInfo_onClick(pSelUserID, deptID) {
	            var c_Width = 420;
	            var c_Height = 450;

	            //스크린의 크기
	            var s_Width = screen.availWidth;
	            var s_Height = screen.availHeight;

	            //열 창의 포지션
	            var px = (s_Width - c_Width) / 2;
	            var py = (s_Height - c_Height) / 2;

	            if (pSelUserID != "") {
	                window.open("/ezCommon/showPersonInfo.do?id=" + pSelUserID + "&dept=" + deptID, "", "left=" + px + ",top=" + py + ",height=" + c_Height + "px,width=" + c_Width + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
	            }
	        }
			
			function addRelatedCabinet() {
				//* moon 2018.07.26
				window.open("/ezCabinet/cabinetAddRelated.do?module=resrc", "addRelated", getOpenWindowfeature(480, 505));
			}
			
			function getOpenWindowfeature(popUpW, popUpH) {
				var heigth   = window.screen.availHeight;
				var width    = window.screen.availWidth;
				var left     = 0;
				var top      = 0;
				var pleftpos = parseInt(width) - popUpW;
				heigth       = parseInt(heigth) - popUpH;
				left         = pleftpos / 2;
				top          = heigth / 2;
				var feature  = "height = " + popUpH + "px, width = " + popUpW + "px,left=" + left + ",top=" + top + ", status=no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=yes";
				return feature;
			}
			
			var schedule_repetition_del_cross_dialogArguments = new Array();
			var m_num;
			var m_ownerID;
			function delSchedule_onClick( num, ownerID)  {
			    var isRepetition = false;

				if( num != "" && ownerID != "" ) {
					if (ApproveFlag == "1" && SavedApproveFlag == "1" && pAdminFg != "Y" && cmd == "mod") {
						alert("" + strLang148 + "");
						return;
					}

					if (CheckAdmin() == false && OwnerCheck() == false) {
						alert("" + strLang94 + "");
						return;
					}

				    if (parseInt(reFlagVal) == 1 || parseInt(reFlagVal) == 3) {		    	
				        // 20070511 add
				        isRepetition = true;

				        var rgParams = new Array();
				        rgParams["CancelOpen"] = false;
				        rgParams["InstanceType"] = "";

				        // 수정(2007.03.28) : 반복예약 기능
				        if (CrossYN()) {
				            m_num = num;
				            m_ownerID = ownerID;

				            schedule_repetition_del_cross_dialogArguments[0] = rgParams;
				            schedule_repetition_del_cross_dialogArguments[1] = delSchedule_onClick_Complete;

				            DivPopUpShow(390, 175, "/ezResource/scheduleRepetitionDel.do");
				        } else {
				            var feature = "dialogHeight:175px;dialogWidth:390px;status:no;help:no;center:yes;edge:sunken";
				            feature = feature + GetShowModalPosition(390, 175);
				            var hWin = window.showModalDialog("/ezResource/scheduleRepetitionDel.do", rgParams, feature);

				            if (false != rgParams["CancelOpen"]) return (false);
				            var szType = rgParams["InstanceType"];

				            if (parseInt(reFlagVal) == 1) {
				                if (szType == "Instance") {
				                    pnumVal = num;
				                    writerIDVal = ownerID;
				                    num = "0";
				                    reFlagVal = "3";
				                }
				            } else if (parseInt(reFlagVal) == 3) {
				                if (szType == "Master") {
				                    num = pnumVal;
				                    ownerID = writerIDVal;
				                    reFlagVal = "1";
				                }
				            }
				        }
				    }

				    if ((!isRepetition && CrossYN()) || !CrossYN()) {
				    	var ans = confirm("" + strLang90 + "");
				    	
				    	if (ans) {
					        var xmlHttp = createXMLHttpRequest();
					        var xmlDoc = createXmlDom();
				
					        var objNode;
				
					        createNodeInsert(xmlDoc, objNode, "PARAMETER");
				
					        createNodeAndInsertText(xmlDoc, objNode, "NUM", num);
					        createNodeAndInsertText(xmlDoc, objNode, "OWNERID", ownerID);
					        createNodeAndInsertText(xmlDoc, objNode, "PNUM", pnumVal);
					        createNodeAndInsertText(xmlDoc, objNode, "WRITERID", writerIDVal);
					        createNodeAndInsertText(xmlDoc, objNode, "INSTYPE", reFlagVal);
					        createNodeAndInsertText(xmlDoc, objNode, "GFLAG", gFlagVal);
					        createNodeAndInsertText(xmlDoc, objNode, "STARTDATE", DstartDateVal);
					        createNodeAndInsertText(xmlDoc, objNode, "ENDDATE", DendDateVal);
				
					        xmlHttp.open("POST", "/ezResource/scheduleAddOk.do?cmd=del", false);
					        xmlHttp.send(xmlDoc);
				
					        var res = xmlHttp.responseText;
				
					        if (trim(res) == "OK") {
					        	window.opener.getPersPortlet();
					            window.close();
				
					            window_onUnload();
					        } else {
					            alert("" + strLang149 + "");
					        }
				    	}
					}
				} else {
					window.opener.getPersPortlet();
					window.close();
				}
			}

			function delSchedule_onClick_Complete(retVal) {
			    if (false != retVal["CancelOpen"]) {
			        DivPopUpHidden();
			        return (false);
			    }
			    var szType = retVal["InstanceType"];

			    if (parseInt(reFlagVal) == 1) {
			        if (szType == "Instance") {
			            pnumVal = m_num;
			            writerIDVal = m_ownerID;
			            m_num = "0";
			            reFlagVal = "3";
			        }
			    } else if (parseInt(reFlagVal) == 3) {
			        if (szType == "Master") {
			            m_num = pnumVal;
			            m_ownerID = writerIDVal;
			            reFlagVal = "1";
			        }
			    }

			    var xmlHttp = createXMLHttpRequest();
			    var xmlDoc = createXmlDom();

			    var objNode;

			    createNodeInsert(xmlDoc, objNode, "PARAMETER");

			    createNodeAndInsertText(xmlDoc, objNode, "NUM", m_num);
			    createNodeAndInsertText(xmlDoc, objNode, "OWNERID", m_ownerID);
			    createNodeAndInsertText(xmlDoc, objNode, "PNUM", pnumVal);
			    createNodeAndInsertText(xmlDoc, objNode, "WRITERID", writerIDVal);
			    createNodeAndInsertText(xmlDoc, objNode, "INSTYPE", reFlagVal);
			    createNodeAndInsertText(xmlDoc, objNode, "GFLAG", gFlagVal);
			    createNodeAndInsertText(xmlDoc, objNode, "STARTDATE", DstartDateVal);
			    createNodeAndInsertText(xmlDoc, objNode, "ENDDATE", DstartDateVal);

			    xmlHttp.open("POST", "/ezResource/scheduleAddOk.do?cmd=del", false);
			    xmlHttp.send(xmlDoc);

			    var res = xmlHttp.responseText;

			    if (trim(res) == "OK") {
			    	window.opener.getPersPortlet();
			        window.close();
			        window_onUnload();
			    } else {
			        alert("" + strLang149 + "");
			    }
			    DivPopUpHidden();
			}

			function SetReturnFlag(pFlag) {
				var msg = ""
				if (pFlag == "2") {
					msg = "" + strLang331 + "";
				} else if(pFlag == "1"){
					msg = "" + strLang332 + "";
				} else {
					msg = "" + strLang333 + "";
				}

				var result = confirm(msg);
				if (result) {
					var xmlHTTP = createXMLHttpRequest();
					var xmlDOM = createXmlDom();
					var objNode;

					createNodeInsert(xmlDOM, objNode, "DATA");
					createNodeAndInsertText(xmlDOM, objNode, "COMPANYID", ss_companyID);
					createNodeAndInsertText(xmlDOM, objNode, "RESID", document.getElementById("ownerID").value);
					createNodeAndInsertText(xmlDOM, objNode, "NUM", document.getElementById("num").value);
					createNodeAndInsertText(xmlDOM, objNode, "RETURN", pFlag);

					xmlHTTP.open("POST", "/ezResource/updateReturnFlag.do", false);
					xmlHTTP.send(xmlDOM);

					var rtnValue = xmlHTTP.responseText;

					if(pFlag == 2) {
						alert(strLang334);
					}
					else {
						alert(strLang335);
					}

					xmlHTTP = null;
					xmlDOM = null;
					
					window.close();
				}
			}

		</script>
	</head>
	
 	<xmp id="sigBody" style="display: none;">${content}</xmp>
 	
	<body id="mainbodytag" class="popup" style="height: 100%; overflow:hidden;">
    	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		
	    <table id="normalScreen" class="layout">
    	    <tr>
        	    <td style="height: 20px">
            	    <div id="menu">
                	    <ul>
                        	<c:if test="${adminFg eq 'Y' || writerID eq userInfo.id}">
                        		<li id="btn_modify"><span onclick="btn_modify()"><spring:message code="ezResource.t54" /></span></li>
                        	</c:if>
	                        
							<c:if test = "${typeVal ne 'Readonly'}">
								<c:if test="${approveFlag eq '1' && adminFg eq 'Y' && cmdStr eq 'mod'}">
									<c:choose>
										<c:when test="${saveApproveFlag eq '1'}">
                                  			<li><span  onClick="SetApproval_onClick2('${cmdStr}', 0)"> <spring:message code='ezResource.t190' /></span></li>
										</c:when>
										<c:otherwise>
                                  			<li><span  onClick="SetApproval_onClick2('${cmdStr}', 1)"> <spring:message code='ezResource.t191' /></span></li>
										</c:otherwise>
									</c:choose>
								</c:if>
							</c:if>
							<c:if test="${writerID eq userInfo.id && resReturnFlag eq '1' && saveApproveFlag eq '1' && returnFlag eq '1'}">
								<li><span onclick="SetReturnFlag(2)"> <spring:message code='ezResource.kmsr26' /></span></li>
							</c:if>
							<c:if test="${adminFg eq 'Y' && resReturnFlag eq '1' && returnFlag eq '2'}">
								<li><span onclick="SetReturnFlag(0)"> <spring:message code='ezResource.kmsr27' /></span></li>
							</c:if>
							<c:if test="${useCabinet == 'YES'}">
								<li><span onClick="addRelatedCabinet()"><spring:message code='ezCabinet.t125'/></span></li>
							</c:if>
							<c:if test="${adminFg eq 'Y' || writerID eq userInfo.id}">
                        		<li id="deletebtbn"><span class="icon16 popup_icon16_delete" onclick="delSchedule_onClick('${num}','${ownerID}')"></span></li>
                        	</c:if>
                        	
                        	<li><span class="icon16 popup_icon16_print" onclick="print_onClick2( false )"></span></li>
                    	</ul>
                	</div>
                	<div id="close">
	                    <ul>
    	                    <li><span onclick="window.close();"></span></li>
        	            </ul>
            	    </div>
            	    
            	    <script type="text/javascript" >
		      			selToggleList(document.getElementById("menu"), "ul", "li", "0");
		  			</script>
            	    
					<table class="content">
	                    <tr>
    	                    <th style="width: 70px;"><spring:message code='ezResource.t193' /></th>
        	                <td colspan="3" style="width: 100%">
            	                <div id="displayNM"></div>
                	        </td>
                    	</tr>
                    	<tr>
	                        <th><spring:message code='ezResource.t197' /></th>
    	                    <td colspan="3"><span id="AllDayDisplay"></span></td>
                    	</tr>
		        		<tr>
		            		<th><spring:message code='ezResource.t213' /></th>
		            		<td colspan="3" style="width: 100%">
		                		<div id="importanceDIV">
		                			<c:choose>
		                				<c:when test="${importance eq '1'}">
		                					<spring:message code='ezResource.t214' />
										</c:when>
		                				<c:when test="${importance eq '2'}">
		                					<spring:message code='ezResource.t215' />
		                				</c:when>
		                				<c:otherwise>
		                					<spring:message code='ezResource.t216' />
		                				</c:otherwise>
		                			</c:choose>
		                		</div>
		            		</td>
		        		</tr>
		        		<tr>
		            		<th><spring:message code='ezResource.t374' /></th>
		            		<td colspan="7" id="itemList"></td>
		        		</tr>
		        		<tr>
		            		<th><spring:message code='ezResource.t224' /></th>
		            		<td colspan="3">
		                		<div id="titleDIV"></div>
		            		</td>
		        		</tr>	        			
	        		</table>
	        	</td>
        	</tr>
        	<tr>
                <td class="pad1" style="vertical-align: top; height: 100%" id="messagetd">
                    <iframe id="message" style="border: #ddd 1px solid; overflow: auto; width: 100%; height: 100%;background-color: white"></iframe>	                    
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
						<tr> 
		 					<th style="max-width:50px;"><spring:message code='ezResource.t193' /></th> 
		 					<td style="width:100%;"><div id="printOwner"></div></td> 
						</tr>
						<tr> 
 							<th><spring:message code='ezResource.t197' /></th> 
 							<td> <div id="printDate"></div></td> 
						</tr>
						<tr> 
 							<th><spring:message code='ezResource.t213' /></th>
 							<td> <div id="printImportance"></div></td>
						</tr>
						<tr>
		            		<th><spring:message code='ezResource.t374' /></th>
		            		<td> <div id="printItem"></div></td>
		        		</tr> 
						<tr> 
 							<th><spring:message code='ezResource.t224' /></th> 
 							<td><div id="printTitle"></div></td> 
						</tr> 
						<tr style="height:10px;"></tr>
						<tr> 
		 					<td colspan="2" style="padding:0px;"> <iframe id="printDocument" style="WIDTH: 100%; height:100%; PADDING:0px; text-align:left;"></iframe></td> 
						</tr> 
					</table>
				</td>
			</tr>
		</table>
	</body>
</html>