<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link href="${util.addVer('/css/theme01.css')}" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
		    var pUse_Editor = "${useEditor}";
		    
		    window.onload = function () {
	            getnewapprovalcount();
	            getnewmailcount();
	            GetScheduleCount();
				getNewCircularCount();
	            
	            try { top.onresize() } catch (e) { }
	        }
		    
			var xmlHttp_getnewapprovalcount_total = null;
			function getnewapprovalcount() {
			    xmlHttp_getnewapprovalcount_total = createXMLHttpRequest();//new ActiveXObject("Microsoft.XMLHTTP");
				if (("${userApprovalG}") == ("YES"))
				    xmlHttp_getnewapprovalcount_total.open("Post", "/ezApprovalG/getWebPartCount.do", true);
				else
				    xmlHttp_getnewapprovalcount_total.open("Post", "/myoffice/ezApproval/WebPartFolder/getWebPartCount.aspx", true);
			    xmlHttp_getnewapprovalcount_total.onreadystatechange = event_newapprovalcount;
			    xmlHttp_getnewapprovalcount_total.send("<DATA><FLAG>1</FLAG></DATA>");
			}
			
			//회람판 신규 갯수 가져오기 2018-03-05 강민수92
	        function getNewCircularCount() {
	        	$.ajax({
					type : "POST",
					dataType : "json",
					async : false,
					url : "/ezCircular/getListCount.do",
					data : {
						listType : 'newCircular'
					},
					success: function(result){
						console.log("회람판 신규 갯수 : " + result.count);
					}
				});
	        }
			
			function event_newapprovalcount() {
			    if (xmlHttp_getnewapprovalcount_total != null && xmlHttp_getnewapprovalcount_total.readyState == 4) {
			    	if ((xmlHttp_getnewapprovalcount_total.status < 200) && (xmlHttp_getnewapprovalcount_total.status > 300))
					{
			            xmlHttp_getnewapprovalcount_total = null;
						return;
					}
					else 
					{
						try {
//							document.getElementById("aprnum").innerText = xmlHttp2.responseXML.text;
		                    if(browserIE) {
		                        document.getElementById("aprnum").innerText = xmlHttp_getnewapprovalcount_total.responseXML.firstChild.text;
		                    } else {		                    	
		                        document.getElementById("aprnum").textContent = xmlHttp_getnewapprovalcount_total.responseXML.firstChild.textContent;
		                    }
		                    xmlHttp_getnewapprovalcount_total = null;
						} catch(e)
						{
						    xmlHttp_getnewapprovalcount_total = null;
							return;
						}
					}
				}
			}
			
			var xmlHttp_getnewmailcount_total = null;
			function getnewmailcount() {
				var xmlpara = createXmlDom();
                var objNode;
                createNodeInsert(xmlpara, objNode, "DATA");
                createNodeAndInsertText(xmlpara, objNode, "URL", "INBOX");
				
			    xmlHttp_getnewmailcount_total = createXMLHttpRequest();
			    xmlHttp_getnewmailcount_total.open("POST", "/ezEmail/getFolderUnreadCount.do", true);
			    xmlHttp_getnewmailcount_total.onreadystatechange = event_newmailcount;
			    xmlHttp_getnewmailcount_total.send(xmlpara);
			}

			function event_newmailcount() {
			    if (xmlHttp_getnewmailcount_total != null && xmlHttp_getnewmailcount_total.readyState == 4) {
			        if (xmlHttp_getnewmailcount_total.status > 199 && xmlHttp_getnewmailcount_total.status < 300) {
			        	var unreadcount = getNodeText(SelectNodes(xmlHttp_getnewmailcount_total.responseXML, "FOLDERUNREADCOUNT")[0]);
			        	
		                if(CrossYN()) {
		                    document.getElementById("mailnum").textContent = unreadcount;
		                }
		                else {
		                    document.getElementById("mailnum").innerText = unreadcount;
		                }
			        }
			        xmlHttp_getnewmailcount_total = null;
			    }
			}
			
			var xmlHttp_GetScheduleCount_total = null;
			function GetScheduleCount() {
				var newDate = new Date();
				var date = newDate.getFullYear() + "-" + (parseInt((newDate.getMonth()+1)) < 10 ? "0"+(newDate.getMonth()+1) : newDate.getMonth()+1) + "-" +(newDate.getDate() < 10 ? "0"+newDate.getDate() : newDate.getDate());

				$.ajax({
		    		type : "GET",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezSchedule/scheduleNewWebPartList.do",
		    		data : {
		    			selectDate  : date		    			
		    		},
		    		success: function(text){
						var xmldom = createXmlDom();
						xmldom = loadXMLString(text);
			        	if(CrossYN())
			            	document.getElementById("schedulenum").textContent = xmldom.getElementsByTagName("ROW").length;
			            else
			            	document.getElementById("schedulenum").innerText = xmldom.getElementsByTagName("ROW").length;
		    		}    	
			    });
			}
				
			function event_GetScheduleCount()
			{
			    if (xmlHttp_GetScheduleCount_total != null && xmlHttp_GetScheduleCount_total.readyState == 4)
				    {
			        if (xmlHttp_GetScheduleCount_total.status > 199 && xmlHttp_GetScheduleCount_total.status < 300) {
		                if(CrossYN())
		                    document.getElementById("schedulenum").textContent = xmlHttp_GetScheduleCount_total.responseText;
		                else
		                    document.getElementById("schedulenum").innerText = xmlHttp_GetScheduleCount_total.responseText;
				    }
			        xmlHttp_GetScheduleCount_total = null;
				    }
			}

			function btnSumming_click(objThis) {
                var mainUrl
				switch (objThis.id)
				{
					case "NewMail" :
                        mainUrl = "/ezEmail/mailMain.do?funCode=1";
						break;
						
										
					case "AprSign" : 		
						var listType;
						listType = 1;
						if ("${userApprovalG}" == ("YES"))
                            mainUrl = "/ezApprovalG/apprGMain.do?listType=" + listType;
						else
                        mainUrl = "/ezApproval/apprMain.do?listType=" + listType;
						break;
					case "aprnum" : 
						// 문서Type 선택 1=결재할문서 2=기안할문서  3=결재진행문서  4=수신문서처리(접수기)
						var listType;
						listType = 1;
						if ("${userApprovalG}" == ("YES"))
                            mainUrl = "/ezApprovalG/apprGMain.do?listType=" + listType;
						else
                        mainUrl = "/ezApproval/apprMain.do?listType=" + listType;
						break;
						
					// 표준모듈 (2007.03.23) 수정 : 메모보고 
					case "Memo" :
                        mainUrl = "/myoffice/ezMemo/index_memo.aspx?listType=1";
						break;
						
					case "Schedule" :
                        mainUrl = "/ezSchedule/scheduleIndex.do?funCode=2";
						break;
					case "schedulenum" :
                        mainUrl = "/ezSchedule/scheduleIndex.do?funCode=2";
						break;
						
					case "Poll" :
                        mainUrl = "/ezBoard/boardMain.do?func=1";
						break;
						
					case "pollnum" :
                        mainUrl = "/ezBoard/boardMain.do?func=1";
						break;
					
					case "Env" :
                        mainUrl = "/myoffice/main/index_environment.htm";
						break;
					case "My_Board" :
                        mainUrl = "/ezBoard/boardMain.do";
						break;
					case "Address" :
                        mainUrl = "/myoffice/main/index_myoffice.aspx?funCode=4";
						break;
				    case "ModInfo":
                        mainUrl = "/ezPortal/environmentMain.do?funCode=1";
				        break;
				}
                parent.document.querySelector("iframe[name=main]").src = mainUrl;
			}

		    function btnWrite_onclick(objThis) {

		        switch (objThis.id) {
		            case "mailwrite":
		                new_mail_onclick();
		                break;


		            case "approvalwrite":
		                openForm();
		                break;

		            case "schedulewrite":
	                    var wWeight = "790";
	                    var wHeight = "830";

	                    var heigth = window.screen.availHeight;
	                    var width = window.screen.availWidth;

	                    var left = (width - wWeight) / 2;
	                    var top = (heigth - wHeight) / 2;
	                    
                        window.open("/ezSchedule/scheduleWrite.do?defaultid=0", "",
                        "height = " + wHeight + ", width = " + wWeight + ", status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
		                break;

		            case "addresswrite":
		                var wWeight = "600";
		                var wHeight = "500";

		                var heigth = window.screen.availHeight;
		                var width = window.screen.availWidth;

		                var left = (width - wWeight) / 2;
		                var top = (heigth - wHeight) / 2;
		                window.open("/ezAddress/addressWrite.do?ownerid=" + encodeURIComponent("${userInfo.id}") + "&folderid=&foldertype=", "",
		                "height = " + wHeight + ", width = " + wWeight + ", status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
		                break;

		            case "resourcewrite":
		                if (CrossYN()) {
		                    var url = "/ezResource/scheduleAddSelect.do";

		                    schedule_add_select_cross_dialogArguments[0] = "";
		                    schedule_add_select_cross_dialogArguments[1] = btnWrite_onclick_Complete;
		                    var Schedule_Add_Select_Cross = GetOpenWindow(url, "Schedule_Add_Select_Cross", 552, 435);
		                    try { Schedule_Add_Select_Cross.focus(); } catch (e) {
		                    }
		                }
		                else {
		                    var url = "/ezResource/scheduleAddSelect.do";
		                    var feature = "status:no;dialogWidth:552px;dialogHeight:430px;help:no;scroll:no;edge:sunken";
		                    feature = feature + GetShowModalPosition(552, 422);
		                    var ret = window.showModalDialog(url, "", feature);

		                    if (ret != undefined && ret[0][0] != undefined) {
		                        url = "/ezResource/scheduleAdd.do?cmd=add&from=schedule&selsd=&seled=&dayView=&ownerID=" + ret[0][0];
		                        feature = "status:no;dialogWidth:770px;dialogHeight:700px;help:no;scroll:no;edge:sunken";
		                        feature = feature + GetShowModalPosition(700, 700);
		                        window.showModalDialog(url, ret, feature);
		                    }
		                }
		                break;

		            case "boardwrite":
		                var wWeight = "355";
		                var wHeight = "600";

		                var heigth = window.screen.availHeight;
		                var width = window.screen.availWidth;

		                var left = (width - wWeight) / 2;
		                var top = (heigth - wHeight) / 2;
		                window.open("/ezBoard/writeBoardSelect.do", "",
		                    "height = " + wHeight + ", width = " + wWeight + ", status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
		                break;
		                
		            case "help":
	                    var pheight = window.screen.availHeight;
	                    var pwidth = window.screen.availWidth;
	                    var pTop = (pheight - 750) / 2;
	                    var pLeft = (pwidth - 1000) / 2;

	                    window.open("/ezPortal/help/help.do", "", "height=700px,width=1000px,top=" + pTop + ",left = " + pLeft + "status = no, toolbar=no, menubar=no, location=no, resizable=0");
	                    break;
		        }
		    }
		    
		    function btnWrite_onclick_Complete(ret) {
		        if (ret != "close" && ret != undefined && ret[0][0] != undefined) {
		            url = "/ezResource/scheduleAdd.do?cmd=add&from=schedule&selsd=&seled=&dayView=&ownerID=" + ret[0][0];

		            var Schedule_Add_ck = window.open(url, "Schedule_Add_Cross", GetOpenWindowfeature(820, 700));
		            try { Schedule_Add_ck.focus(); } catch (e) {
		            }
		        }
		    }

			function getScheduleList_after(date) {
			    
			    if (xmlhttp_getScheduleList_total == null || xmlhttp_getScheduleList_total.readyState != 4) return;

			    try {
			        var listHTML = "<ul class=\"schedule_list \">";

			        var xmldom = createXmlDom();
			        xmldom = xmlhttp_getScheduleList_total.responseXML;
			        var count = 0;
			        for (var i = 0; i < xmldom.getElementsByTagName("ROW").length; i++) {
			            var SCHEDULEID = getNodeText(xmldom.getElementsByTagName("SCHEDULEID").item(i));
			            var SCHEDULETYPE = getNodeText(xmldom.getElementsByTagName("SCHEDULETYPE").item(i));
			            var DATETYPE = getNodeText(xmldom.getElementsByTagName("DATETYPE").item(i));
			            var REPEATCOUNT = getNodeText(xmldom.getElementsByTagName("REPEATCOUNT").item(i));
			            var STARTDATE = getNodeText(xmldom.getElementsByTagName("STARTDATE").item(i));
			            var ENDDATE = getNodeText(xmldom.getElementsByTagName("ENDDATE").item(i));
			            var TITLE = getNodeText(xmldom.getElementsByTagName("TITLE").item(i));

			            var startdate = new Date(STARTDATE.split(' ')[0].split('-')[0], STARTDATE.split(' ')[0].split('-')[1], STARTDATE.split(' ')[0].split('-')[2]);
			            var enddate = new Date(ENDDATE.split(' ')[0].split('-')[0], ENDDATE.split(' ')[0].split('-')[1], ENDDATE.split(' ')[0].split('-')[2]);
			            var selDateType = new Date(selDate.substring(0, 4), selDate.substring(5, 7), selDate.substring(8, 10));
			            //if (startdate.getFullYear() == selDateType.getFullYear() && startdate.getMonth() == parseInt(selDateType.getMonth()) && startdate.getDate() == selDateType.getDate()) {
		                if ((((startdate <= selDateType) && (enddate >= selDateType))) || (startdate >= selDateType && enddate <= selDateType)) {
			                listHTML += "<li style='text-overflow: ellipsis; overflow: hidden; width: 240px; white-space: pre;'>";
			                listHTML += "<span style='CURSOR:pointer;'  onClick=\"open_schedule('" + SCHEDULEID + "','" + SCHEDULETYPE + "','" + DATETYPE + "','" + REPEATCOUNT + "','" + STARTDATE + "')\" title='" + MakeXMLString(TITLE) + "'>";
			                listHTML += "<nobr><b>&nbsp;" + MakeXMLString(TITLE) + "</b></nobr></span></li>";
			                count++;
			            }	           
			        }
			        listHTML += "</ul>";
			        

			        if (count > 0)
			            document.getElementById("ScheduleList").innerHTML = listHTML;
			        else
			        {
			            var nodata = "<div class='nodata_schedule '>";
			            nodata += "<p><img src='/images/" + strLang1_total + "/main/nodata_plan.gif' width='92' height='84' style='margin-top:0px;margin-bottom:5px;'></p>";
			            nodata += "<p>" + strLang2_total + "</p></div>";

			            var scrollbox = {};
			            scrollbox.content1 = new Scrollbox();
			            scrollbox.best = new Scrollbox();
			            scrollbox.player = new Scrollbox();

			            var pulldown = {};
			            pulldown.choose = new Pulldown();
			            document.onselectstart = function () { return false; };

			            scrollbox.content1.touch("content1-scrbox", {
			                overflowY: "auto" // auto, scroll 
			            });
			            scrollbox.best.touch("best-scrbox", {
			                overflowY: "scroll" // auto, scroll 
			            });
			            scrollbox.player.touch("player-scrbox", {
			                overflowY: "scroll" // auto, scroll 
			            });
			            
			            document.getElementById("ScheduleList").innerHTML = nodata;
			            return;
			        }

			        var scrollbox = {};
			        scrollbox.content1 = new Scrollbox();
			        scrollbox.best = new Scrollbox();
			        scrollbox.player = new Scrollbox();

			        var pulldown = {};
			        pulldown.choose = new Pulldown();
			        document.onselectstart = function () { return false; };

			        scrollbox.content1.touch("content1-scrbox", {
			            overflowY: "auto" // auto, scroll 
			        });
			        scrollbox.best.touch("best-scrbox", {
			            overflowY: "scroll" // auto, scroll 
			        });
			        scrollbox.player.touch("player-scrbox", {
			            overflowY: "scroll" // auto, scroll 
			        });


			    }
			    catch (e) {
			    }
			}

			


			function event_newmailcount_end() {
				if (xmlHttp != null && xmlHttp.readyState == 4) {
					if (xmlHttp.status > 199 && xmlHttp.status < 300) {
						document.getElementById("mailnum").innerText = xmlHttp.responseXML.getElementsByTagName("d:unreadcount").item(0).text;
					}
					xmlHttp = null;
				}
			}



		    //
			
		    //
			
			// 표준모듈 (2007.03.23) 수정 : 전자메모보고 처리할 메모 갯수 		
			var xmlHttp_getMemocount_total = null;
			function getMemocount()
			{		
			    xmlHttp_getMemocount_total = createXMLHttpRequest();// new ActiveXObject("Microsoft.XMLHTTP");
			    xmlHttp_getMemocount_total.open("Post", "/myoffice/ezMemo/WebPartFolder/getWebPartCount.aspx", true);
			    xmlHttp_getMemocount_total.onreadystatechange = event_getMemocount;
			    xmlHttp_getMemocount_total.send("<DATA><FLAG>1</FLAG></DATA>");
			}
			
			function event_getMemocount()
			{
			    if (xmlHttp_getMemocount_total != null && xmlHttp_getMemocount_total.readyState == 4)
				{
			    	if ((xmlHttp_getMemocount_total.status < 200) && (xmlHttp_getMemocount_total.status > 300))
					{
			            xmlHttp_getMemocount_total = null;
						return;
					}
					else 
					{
						try {
						    document.getElementById("Memonum").innerText = xmlHttp_getMemocount_total.responseXML.text;
							xmlHttp_getMemocount_total = null;
						} catch(e)
						{
						    xmlHttp_getMemocount_total = null;
							return;
						}
					}
				}
			}
		 
		    var schedule_add_select_cross_dialogArguments = new Array();
		    function new_mail_onclick() {
		        var pheight = window.screen.availHeight;
		        var conHeight = pheight * 0.8;
		        var pwidth = window.screen.availWidth;
		        var conWidth = pwidth * 0.8;
		        if (conWidth > 890)
		            conWidth = 890;
		        var pTop = (pheight - conHeight) / 2;
		        var pLeft = (pwidth - 890) / 2;

	            window.open("/ezEmail/mailWrite.do?cmd=NEW", "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no,resizable=1");
		    }

		    var formURL = "";
		    var formDocType = "";
		    var getformcont_cross_dialogArguments = new Array();
		    var url = "";
		    function openForm() {
		        var parameter = new Array();
		        parameter[0] = "${userInfo.deptID}";
		        parameter[1] = "A01000";

		        if ("${userApprovalG}" == ("YES")) {
		            url = "/ezApprovalG/getFormCont.do";
		        } else {
		            url = "/ezApproval/getFormCont.do";
		        }
		        
		        if (CrossYN()) {
		            getformcont_cross_dialogArguments[0] = parameter;
		            getformcont_cross_dialogArguments[1] = openForm_Complete;
		            var getFormCont_Cross = window.open(url, "/ezApproval/getFormCont.do", GetOpenWindowfeature(713, 570));
		            try { getFormCont_Cross.focus(); } catch (e) {
		            }
		        }
		        else {
		            var feature = "status:no;dialogWidth:713px;dialogHeight:570px;edge:sunken;scroll:no";
		            var ret = window.showModalDialog(url, parameter, feature);
		            formURL = ret[0];
		            formDocType = ret[1];
		            if (formURL != "cancel") {
		                openDraftUI(formURL, formDocType);
		            }
		        }
		    }

		    function openForm_Complete(ret) {
		        formURL = ret[0];
		        formDocType = ret[1];

		        if (formURL != "cancel") {
		            openDraftUI();
		        }
		    }

		    function openDraftUI() {
		        var pArgument = new Array();
		        var gb = "";
		        if ("${userApprovalG}" == ("YES"))
		            gb = "G";
		        
	        	pArgument[0] = "${userInfo.id}";
	            pArgument[1] = formURL;
	            pArgument[2] = "DRAFT";
	            pArgument[3] = formDocType;
	            pArgument[4] = "0"
	            pArgument[5] = ""
	            pArgument[6] = ""
	            pArgument[7] = "";

	            var openLocation = "";
	            if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "hwp") {
	                if (!isIE()) {
	                    alert("<spring:message code='main.t3000' />");
	                    return;
	                } else {
	                    var openLocation = "/ezApprovalG/draftuiHWP.do";
	                }
	            } else {
                	var openLocation = "/ezApprovalG/draftui.do";
	            }
	            
                openLocation = openLocation + "?formURL=" + escape(pArgument[1]) + "&draftFlag=" + escape(pArgument[2]) + "&formDocType=" + escape(pArgument[3]);
                openLocation = openLocation + "&susinSN=" + escape(pArgument[4]) + "&docState=" + escape(pArgument[5]) + "&listType=1" + "&aprState=" + escape(pArgument[6]);
                openLocation = openLocation + "&isTmpDoc=" + escape(pArgument[7]);
	            openwindow(openLocation, "", 890, 620);
		    }


		    function openwindow(wfileLocation, wName, wWeigth, wHeigth) {
		        try {
		            var heigth = window.screen.availHeight;
		            var width = window.screen.availWidth;

		            var left = 0;
		            var top = 0;

		            if (window.screen.width > 800) {
		                var pleftpos;

		                pleftpos = parseInt(width) - 967;
		                heigth = parseInt(heigth) - 30;
		                width = parseInt(width) - pleftpos;

		                left = pleftpos / 2;
		            } else {

		                heigth = parseInt(heigth) - 30;
		                width = parseInt(width) - 10;
		            }
		            window.open(wfileLocation, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);

		        } catch (e) {
		        }
		    }

			// 직원조회
			function Emp_Search() {
			    if (document.getElementById('input_search').value != "") {
			        var wHeight = 670;
			        var wWidth = 750;
			        var wVertical = Math.floor(screen.height / 2) - (wHeight / 2);
			        var wHorizontal = Math.floor(screen.width / 2) - (wWidth / 2);

			        window.open("/ezPersonal/personSearch.do?searchString=" + encodeURI(document.getElementById('input_search').value), "", "height=" + wHeight + "px,width=" + wWidth + "px, left=" + wHorizontal + "px, top=" + wVertical + "px, status=no, toolbar=no, menubar=no,location=no, resizable=0");
			        document.getElementById('input_search').value = '';
			    }
			}
		</script>
	</head>
	<body>
		<section class="section1">
			<div class="section1_left">
				<article  class="personal">
					<div class="info">
						<p><strong>${displayName}</strong>${title}</p>
	    				<dl class="info_txt">
	        				<dt>${companyNm }<br></dt>
				 			<dd>${department}</dd>
				 			<span class="modify" id="ModInfo" onClick="btnSumming_click(this)"><spring:message code="main.t00028" /></span>
	    				</dl>
	    			</div>
	    			<div class="personal_content">
						<a id="NewMail" onClick="btnSumming_click(this)">
							<ul>
								<li class="icon"><img src="/images/kr/theme01/main/icon_personal01.gif" alt="<spring:message code="main.t00017" />" /></li>
								<li class="count">
									<div>
										<span id="mailnum">0</span>
									</div>
								</li>
								<li class="title"><spring:message code="main.t00017" /></li>
							</ul>
						</a>
						<a id="AprSign" onClick="btnSumming_click(this)">
							<ul>
								<li class="icon"><img src="/images/kr/theme01/main/icon_personal02.gif" alt="<spring:message code="main.t00018" />" /></li>
									<li class="count">
										<div>
											<span id="aprnum">0</span>
										</div>
									</li>
									<li class="title"><spring:message code="main.t00018" /></li>
							</ul>
						</a>
						<a id="Schedule" onClick="btnSumming_click(this)">
							<ul>
								<li class="icon"><img src="/images/<spring:message code="main.t00025" />/theme01/main/icon_personal03.gif" alt="<spring:message code="main.t00019" />" /></li>
								<li class="count">
									<div>
										<span id="schedulenum">0</span>
									</div>
								</li>
								<li class="title"><spring:message code="main.t00019" /></li>
							</ul>
						</a>
						<a id="Poll" onClick="btnSumming_click(this)">
							<ul class="last">
								<li class="icon"><img src="/images/<spring:message code="main.t00025" />/theme01/main/icon_personal04.gif" alt="<spring:message code="main.t00020" />" /></li>
								<li class="count">
									<div>
										<span>${pollNum }</span>
									</div>
								</li>
								<li class="title"><spring:message code="main.t00020" /></li>
							</ul>
						</a>			
					</div>
				</article>
				
				  <!-- top_search  -->
	     		<article class="top_search">
	        		<p class="search_title"><spring:message code="main.t00029" /></p>
					<input id="input_search" class="input_text" type="text" onblur="if (this.value.length==0) {this.className='input_text'}else {this.className='input_text focusnot'};" onfocus="this.className='input_text focus'" /><input type="image" src="/images/kr/theme01/main/top_search_btn.gif" alt="<spring:message code='ezPortal.t252' />"  class="topsearch_btn " onclick="Emp_Search()">
	    		</article> 
	     		<!-- /top_search  -->
	     		<!-- //section1_left -->
			</div>	
			
			<div class="section1_right">
	
			    <!-- quickmenu -->
				<div class="quickmenu_area">
					<p class="btn_quick_left"><img src="/images/kr/theme01/main/quickmenu_btn_up.gif" ></p>
					<ul class="quickmenu">
						<li id="mailwrite" onclick="btnWrite_onclick(this)">
							<span class="icon" ><img src="/images/kr/theme01/main/quickmenu_icon01.gif"  ></span>
			     			<span class="txt"><spring:message code="main.t177" /></span>
			     		</li>
			     		<li id="schedulewrite" onclick="btnWrite_onclick(this)">
			     			<span class="icon"><img src="/images/kr/theme01/main/quickmenu_icon02.gif"  ></span>
			     			<span class="txt"><spring:message code="main.t00032" /></span>
			     		</li>
			     		<li id="approvalwrite" onclick="btnWrite_onclick(this)">
			     			<span class="icon"><img src="/images/kr/theme01/main/quickmenu_icon03.gif"  ></span>
			     			<span class="txt"><spring:message code="main.t00031" /></span>
			     		</li>
			     		<li id="addresswrite" onclick="btnWrite_onclick(this)">
			     			<span class="icon"><img src="/images/kr/theme01/main/quickmenu_icon04.gif"  ></span>
			     			<span class="txt"><spring:message code="main.t00033" /></span>
			     		</li>
			     		<li id="resourcewrite" onclick="btnWrite_onclick(this)">
			     			<span class="icon"><img src="/images/kr/theme01/main/quickmenu_icon05.gif"  ></span>
			     			<span class="txt"><spring:message code="main.t00034" /></span>
			     		</li>
			     		<li id="boardwrite" onclick="btnWrite_onclick(this)">
			     			<span class="icon"><img src="/images/kr/theme01/main/quickmenu_icon06.gif"  ></span>
			     			<span class="txt"><spring:message code="main.t00039" /></span>
			     		</li>
			     		<%-- <li>
			     			<span class="icon"><img src="/images/kr/theme01/main/quickmenu_icon07.gif"  ></span>
			     			<span class="txt"><spring:message code="main.t00040" /></span>
			     		</li> --%>
			      		<li id="help" onclick="btnWrite_onclick(this)">
			      			<span class="icon"><img src="/images/kr/theme01/main/quickmenu_icon08.gif"  ></span>
			     			<span class="txt"><spring:message code="main.t00037" /></span></li>
			      		<!-- <li>
			      			<span class="icon"><img src="/images/kr/theme01/main/quickmenu_icon09.gif"  ></span>
			     			<span class="txt">홈페이지</span>
			     		</li> -->
					</ul>
					<p class="btn_quick_right"><img src="/images/kr/theme01/main/quickmenu_btn_down.gif" ></p>
				</div>
			<!-- //quickmenu -->
			</div>
      	</section>
	</body>
</html>
