<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="refresh" content="300">
		
		<%
		 String userLang = (String)request.getAttribute("userLang");
		 String userApprovalG = (String)request.getAttribute("userApprovalG");
		 String pExist = (String)request.getAttribute("pExist");
		 %>
		<section class="body_bg2">
			<article  class="personal">
				<p>
					<span class="btn_green">
						<span id="ModInfo" onClick="btnSumming_click(this)"><spring:message code="ezHome.t00015" />
						</span>
					</span>
				 	<strong style="position:absolute;">${displayName} ${mailAddress } </strong>
				 </p>
				<div class="info">
    				<p class="pic">${userPhoto }</p>
    				<dl class="info_txt">
        				<dt>${companyNm }<br></dt>
			 			<dd><strong>${department} ${title}</strong></dd>
						<dd><spring:message code="ezHome.t00016" />  ${lastLogin }</dd>
    				</dl>
    				<div class="bottom"></div>
    			</div>
    			<div class="personal_content">
					<a id="NewMail" onClick="btnSumming_click(this)" href="#">
						<ul>
							<li class="icon"><img src="/images/<spring:message code="ezHome.t00025" />/main/icon_personal01.gif" alt="<spring:message code="ezHome.t00017" />" /></li>
							<li class="count">
								<div>
									<span id="mailnum" runat="server">0</span>
								</div>
							</li>
                    		<%if(userLang != "3"){ %>
								<li class="title"><spring:message code="ezHome.t00017" /></li>
                    		<%}else{ %>
                    			<li class="title1"><spring:message code="ezHome.t00017" /></li>
                    		<%} %>
						</ul>
					</a>
					<a id="AprSign" onClick="btnSumming_click(this)" href="#">
						<ul>
							<li class="icon"><img src="/images/<spring:message code="ezHome.t00025" />/main/icon_personal02.gif" alt="<spring:message code="ezHome.t00018" />" /></li>
								<li class="count">
									<div>
										<span id="aprnum" runat="server">0</span>
									</div>
								</li>
                    			<%if(userLang != "3"){ %>
									<li class="title"><spring:message code="ezHome.t00018" /></li>
                    			<%}else{ %>
                    				<li class="title1"><spring:message code="ezHome.t00018" /></li>
                    			<%} %>
						</ul>
					</a>
					<a id="Schedule" onClick="btnSumming_click(this)" href="#">
						<ul>
							<li class="icon"><img src="/images/<spring:message code="ezHome.t00025" />/main/icon_personal03.gif" alt="<spring:message code="ezHome.t00019" />" /></li>
							<li class="count">
								<div>
									<span id="schedulenum" runat="server">0</span>
								</div>
							</li>
                    		<%if(userLang != "3"){ %>
								<li class="title"><spring:message code="ezHome.t00019" /></li>
                    		<%}else{ %>
                    			<li class="title1"><spring:message code="ezHome.t00019" /></li>
                    		<%} %>
						</ul>
					</a>
					<a id="Poll" onClick="btnSumming_click(this)" href="#">
						<ul class="last">
							<li class="icon"><img src="/images/<spring:message code="ezHome.t00025" />/main/icon_personal04.gif" alt="<spring:message code="ezHome.t00020" />" /></li>
							<li class="count">
								<div>
									<span>${pollNum }</span>
								</div>
							</li>
                    		<%if(userLang != "3"){ %>
								<li class="title"><spring:message code="ezHome.t00020" /></li>
                    		<%}else{ %>
                    		<li class="title1"><spring:message code="ezHome.t00020" /></li>
                    		<%} %>
						</ul>
					</a>			
				</div>
			</article>
      		<div class="blue_bar"></div>
         	<div class="schedule">
	  			<article class="list"> 
   			 		<div class="maintab01">
             			<p id="Psch" class="left_on" onclick="scheduleChangeTab(this)"><spring:message code="ezHome.t00021" /></p>
             			<p id="Allsch" class="right" onclick="scheduleChangeTab(this)"><spring:message code="ezHome.t00022" /></p>
             		</div>
          			<div class="scrollbox-play-light" style="position:relative; width:260px;height:105px;  "> 
						<div class="scrollbox" id="best-scrbox" style="width:260px; height:105px;overflow:hidden;"> 
    						<div class="content"> 
  								<div id="ScheduleList">
  						<%-- 			<%if(pExist.equals("true")){ %>
    									<ul class="schedule_list">
    										<asp:Repeater ID="ScheduleListRepeater" runat="server">  
        										<ItemTemplate>
        										 	<li style='text-overflow: ellipsis; overflow: hidden; width: 240px;'>
            											<span style='CURSOR:pointer;'  onClick="open_schedule('<%# ((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("SCHEDULEID")[0].InnerText %>',
                											'<%# ((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("SCHEDULETYPE")[0].InnerText %>',
                											'<%# ((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("DATETYPE")[0].InnerText %>',
                											'<%# ((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("REPEATCOUNT")[0].InnerText %>',
                											'<%# ((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("STARTDATE")[0].InnerText %>')" 
                											title='<%# ((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("TITLE")[0].InnerText %>'>
                											<nobr>
                    											<b>&nbsp;<%# ((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("TITLE")[0].InnerText %></b>
                											</nobr>
            											</span>
       												 </li> 
        										</ItemTemplate>
    										</asp:Repeater>
    									</ul>
								<%}else{ %>        
									<div class='nodata_schedule '>
    									<p><img src='/images/<spring:message code='ezHome.t00025' />/main/nodata_plan.gif' width='92' height='84' style='margin-top:0px;margin-bottom:5px;'></p>
    									<p><spring:message code='ezHome.t00026' /></p>
									</div>
								<%} %> --%>      
  							</div>
					    </div> 
					    <div class="scrollbar-v"> 
    						<img src="/images/<spring:message code='ezHome.t00025' />/main/scrollbar_arrow_up_w.gif" class="button-up"> 
    						<img src="/images/<spring:message code='ezHome.t00025' />/main/scrollbar_ball_w.gif" class="thumb-v"> 
    						<img src="/images/<spring:message code='ezHome.t00025' />/main/scrollbar_arrow_down_w.gif" class="button-down"> 
    					</div> 
					</div> 
				</div> 
   	   		</article>
       		<!-- calender -->
        	<article class="calender">
	            <div id="CalendarMini"></div>
			</article>
      		<!-- /calender -->   
			</div>
    			<div class="blue_bar"></div>
			    <div class="bannerlink_area">
    				<article class="writebanner">
        				<p><span id="mailwrite" onclick="btnWrite_onclick(this)"><img src="/images/<spring:message code='ezHome.t00025' />/main/writebanner01.gif" width="58" height="85"></span><span id="schedulewrite" onclick="btnWrite_onclick(this)"><img src="/images/<spring:message code='ezHome.t00025' />/main/writebanner02.gif" width="56" height="85"></span><span id="approvalwrite" onclick="btnWrite_onclick(this)"><img src="/images/<spring:message code='ezHome.t00025' />/main/writebanner03.gif" width="56" height="85"></span></p>
        				<p><span id="addresswrite" onclick="btnWrite_onclick(this)"><img src="/images/<spring:message code='ezHome.t00025' />/main/writebanner04.gif" width="58" height="85"></span><span id="resourcewrite" onclick="btnWrite_onclick(this)"><img src="/images/<spring:message code='ezHome.t00025' />/main/writebanner05.gif" width="56" height="85"></span><span id="boardwrite" onclick="btnWrite_onclick(this)"><img src="/images/<spring:message code='ezHome.t00025' />/main/writebanner06.gif" width="56" height="85"></span></p>
        				<%--<span id="mailwrite" onclick="btnWrite_onclick(this)"><img src="/images/<%=RM.GetString("t00025")%>/main/writebanner01.gif" width="58" height="85"></span><span id="approvalwrite" onclick="btnWrite_onclick(this)"><img src="/images/<%=RM.GetString("t00025")%>/main/writebanner02.gif" width="56" height="85"></span><span id="schedulewrite" onclick="btnWrite_onclick(this)"><img src="/images/<%=RM.GetString("t00025")%>/main/writebanner03.gif" width="56" height="85"></span><span><img src="/images/<%=RM.GetString("t00025")%>/main/writebanner04.gif" width="58" height="85"></span><span><img src="/images/<%=RM.GetString("t00025")%>/main/writebanner05.gif" width="56" height="85"></span><span><img src="/images/<%=RM.GetString("t00025")%>/main/writebanner06.gif" width="56" height="85"></span>--%>
    				</article>
    			</div>
        		<div class="blue_bar"></div>
    			<article class="time">
    				<p class="title"><spring:message code='ezHome.t00023' /></p>
    				<div id="clock_id" style="width: 120px; height: 120px; background: url(/images/WebPartSliderCI/analogu.png) no-repeat ; "></div>    
    				<div id="timeinput" style=" margin-left:10px ;width:104px; height:25px; border:1px solid #205f61; background:url(/images/WebPartSliderCI/digitaltime_bg.gif);font-weight:bold; color:#FFF; letter-spacing:4px; font-size:15px; font-family:Arial, Helvetica, sans-serif; text-align:center; line-height:25px;"></div>
   				 </article>
			</section>
			
		 <%
		 String browser = "";
		 String userAgent = request.getHeader("User-Agent");
		 		
		 %>
		
		<link rel="stylesheet" href="/css/main.css" type="text/css" />
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezSchedule/jindo.all.js"></script>
		<script type="text/javascript" src="/js/ezSchedule/selectbox.js"></script>
		<script type="text/javascript" src="/js/ezSchedule/scrollbox.js"></script>
		<%if (request.getHeader("User-Agent").indexOf("Trident") < 0 && request.getHeader("User-Agent").toUpperCase().indexOf("MSIE") > 0){ %>
			<script type="text/javascript" src="/js/ezSchedule/Calendar/CalendarMini_IEEIP.js"></script>
    	<%} else { %>
    		<script type="text/javascript" src="/js/ezSchedule/Calendar/CalendarMini_EIP.js"></script>
    	<%} %>
		
		<script type="text/javascript" src="<spring:message code='ezHome.t00024'/>"></script>
		<script type="text/javascript" src="/js/jquery/raphael-min.js"></script>   
		<script type="text/javascript">
			var UserAgentState = navigator.userAgent.toLowerCase();
		    var browserIE = (UserAgentState.indexOf("msie") != -1) ? true : false;
		    var pMode = "P";
		    var date = "";
		    var strLang1_total = "<spring:message code='ezHome.t00025' />";
		    var strLang2_total = "<spring:message code='ezHome.t00026' />";
		    var pUse_Editor = "${useEditor}";
		    var pUse_IE11Browser = "${useIE11Browser}";
		    var pNoneActiveX = "YES";

		    function window_onload_total() {
			    if (navigator.userAgent.indexOf('Firefox') != -1) {
			        document.body.style.MozUserSelect = 'none';
			        document.body.style.WebkitUserSelect = 'none';
			        document.body.style.khtmlUserSelect = 'none';
			        document.body.style.oUserSelect = 'none';
			        document.body.style.UserSelect = 'none';
			    }
			    CalendarMiniView("CalendarMini");

			    draw_clock();
			    yourClock();

			    CalendarMiniDataSource();

		        try { top.onresize() } catch (e) { }

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

		        draw_clock();
		        yourClock();

		        try { top.onresize() } catch (e) { }
			}


			function open_schedule(scheduleid, scheduletype, datetype, repeatcount, date) {
			    date = date.substr(0, 10);

			    var wWeight = "760";
			    var wHeight = "660";
			    var heigth = window.screen.availHeight;
			    var width = window.screen.availWidth;
			    var left = (width - wWeight) / 2;
			    var top = (heigth - wHeight) / 2;

			    //PNO-3
			    if (CrossYN() || pNoneActiveX == "YES")
			        window.open("/myoffice/ezSchedule/schedule_read_Cross.aspx" + "?id=" + encodeURIComponent(scheduleid) + "&type=" + scheduletype + "&datetype=" + datetype + "&repeatcount=" + repeatcount + "&date=" + date + "&pattern=0", "",
		                "top = " + top + ", left = " + left + ",height = " + wHeight + "px, width = " + wWeight + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
			    else
			        window.open("/myoffice/ezSchedule/schedule_read.aspx" + "?id=" + encodeURIComponent(scheduleid) + "&type=" + scheduletype + "&datetype=" + datetype + "&repeatcount=" + repeatcount + "&date=" + date + "&pattern=0", "",
		                "top = " + top + ", left = " + left + ",height = " + wHeight + "px, width = " + wWeight + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
			    //PNO-3 END
			}

			var xmlhttp_getScheduleList_total = createXMLHttpRequest();
			var selDate = "";
			function getScheduleList(date,pGubun) {
			    selDate = date;
			    var xmlpara = createXmlDom();

			    var objNode;
			    createNodeInsert(xmlpara, objNode, "PARAMETER");
			    createNodeAndInsertText(xmlpara, objNode, "pSelectDate", date);
			    createNodeAndInsertText(xmlpara, objNode, "MODE", pGubun);


			    xmlhttp_getScheduleList_total = null;
			    xmlhttp_getScheduleList_total = createXMLHttpRequest();
			    xmlhttp_getScheduleList_total.open("POST", "/myoffice/ezSchedule/schedule_newwebpartlist.aspx", true);
			    xmlhttp_getScheduleList_total.onreadystatechange = getScheduleList_after;
			    xmlhttp_getScheduleList_total.send(xmlpara);
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
			                listHTML += "<li style='text-overflow: ellipsis; overflow: hidden; width: 240px;'>";
			                listHTML += "<span style='CURSOR:pointer;'  onClick=\"open_schedule('" + SCHEDULEID + "','" + SCHEDULETYPE + "','" + DATETYPE + "','" + REPEATCOUNT + "','" + STARTDATE + "')\" title='" + TITLE + "'>";
			                listHTML += "<nobr><b>&nbsp;" + TITLE + "</b></nobr></span></li>";
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

			var xmlHttp_getnewmailcount_total = null;
			function getnewmailcount() {
			    xmlHttp_getnewmailcount_total = createXMLHttpRequest();
			    xmlHttp_getnewmailcount_total.open("POST", "/myoffice/ezEmail/remote/mail_get_unreadcount.aspx", true);
			    xmlHttp_getnewmailcount_total.onreadystatechange = event_newmailcount;
			    xmlHttp_getnewmailcount_total.send();
			}

			function event_newmailcount() {
			    if (xmlHttp_getnewmailcount_total != null && xmlHttp_getnewmailcount_total.readyState == 4) {
			        if (xmlHttp_getnewmailcount_total.status > 199 && xmlHttp_getnewmailcount_total.status < 300) {
		                if(CrossYN())
		                    document.getElementById("mailnum").textContent = xmlHttp_getnewmailcount_total.responseText;
		                else
		                    document.getElementById("mailnum").innerText = xmlHttp_getnewmailcount_total.responseText;
			        }
			        xmlHttp_getnewmailcount_total = null;
			    }
			}


			function event_newmailcount_end()
			{
				if(xmlHttp != null && xmlHttp.readyState == 4)
				{
					if(xmlHttp.status > 199 && xmlHttp.status < 300)
						document.getElementById("mailnum").innerText = xmlHttp.responseXML.getElementsByTagName("d:unreadcount").item(0).text
					xmlHttp = null;
				}
			}

			var xmlHttp_getnewapprovalcount_total = null;
			function getnewapprovalcount() 
			{
			    xmlHttp_getnewapprovalcount_total = createXMLHttpRequest();//new ActiveXObject("Microsoft.XMLHTTP");
				if (("<%=userApprovalG%>") == ("YES"))
				    xmlHttp_getnewapprovalcount_total.open("Post", "/myoffice/ezApprovalG/WebPartFolder/getWebPartCount.aspx", true);
				else
				    xmlHttp_getnewapprovalcount_total.open("Post", "/myoffice/ezApproval/WebPartFolder/getWebPartCount.aspx", true);
			    xmlHttp_getnewapprovalcount_total.onreadystatechange = event_newapprovalcount;
			    xmlHttp_getnewapprovalcount_total.send("<DATA><FLAG>1</FLAG></DATA>");
			}
			
			function event_newapprovalcount()
			{
			    if (xmlHttp_getnewapprovalcount_total != null && xmlHttp_getnewapprovalcount_total.readyState == 4)
				{
			    	if ((xmlHttp_getnewapprovalcount_total.status < 200) && (xmlHttp_getnewapprovalcount_total.status > 300))
					{
			            xmlHttp_getnewapprovalcount_total = null;
						return;
					}
					else 
					{
						try {
//							document.getElementById("aprnum").innerText = xmlHttp2.responseXML.text;
		                    if(browserIE)
		                        document.getElementById("aprnum").innerText = xmlHttp_getnewapprovalcount_total.responseXML.firstChild.text;
		                    else
		                        document.getElementById("aprnum").textContent = xmlHttp_getnewapprovalcount_total.responseXML.firstChild.textContent;
		                    xmlHttp_getnewapprovalcount_total = null;
						} catch(e)
						{
						    xmlHttp_getnewapprovalcount_total = null;
							return;
						}
					}
				}
			}

		    //
			var xmlHttp_GetScheduleCount_total = null;
			function GetScheduleCount()
			{
			    xmlHttp_GetScheduleCount_total = createXMLHttpRequest();//new ActiveXObject("Microsoft.XMLHTTP");
			    xmlHttp_GetScheduleCount_total.open("POST", "/myoffice/ezSchedule/remote/schedule_get_count.aspx", true);
			    xmlHttp_GetScheduleCount_total.onreadystatechange = event_GetScheduleCount;
			    xmlHttp_GetScheduleCount_total.send();
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
					
			function btnSumming_click(objThis)
			{

				switch (objThis.id)
				{
					case "NewMail" : 
						window.open("/myoffice/MAIN/index_myoffice.aspx?funCode=1", "main");
						break;
						
										
					case "AprSign" : 		
						var listType;
						listType = 1;
						if ("<%=userApprovalG%>" == ("YES"))
							window.open("/ezApprovalG/apprGMain.do?listType=" + listType, "main");
						else
							window.open("/myoffice/ezApproval/index_approval.aspx?listType=" + listType, "main");
						break;
					case "aprnum" : 
						// 문서Type 선택 1=결재할문서 2=기안할문서  3=결재진행문서  4=수신문서처리(접수기)
						var listType;
						listType = 1;
						if ("<%=userApprovalG%>" == ("YES"))
							window.open("/ezApprovalG/apprGMain.do?listType=" + listType, "main");
						else
							window.open("/myoffice/ezApproval/index_approval.aspx?listType=" + listType, "main");
						break;
						
					// 표준모듈 (2007.03.23) 수정 : 메모보고 
					case "Memo" : 					
						window.open("/myoffice/ezMemo/index_memo.aspx?listType=1", "main");
						break;
						
					case "Schedule" : 
						window.open("/myoffice/main/index_pims.aspx?funCode=2","main");
						break;
					case "schedulenum" :
						window.open("/myoffice/main/index_pims.aspx?funCode=2","main");
						break;
						
					case "Poll" :
						window.open("/ezBoard/boardMain.do?func=1","main");
						break;
						
					case "pollnum" : 
						window.open("/ezBoard/boardMain.do?func=1","main");
						break;
					
					case "Env" :
						window.open("/myoffice/main/index_environment.htm","main");
						break;
					case "My_Board" :
						window.open("/ezBoard/boardMain.do","main");
						break;
					case "Address" : 
						window.open("/myoffice/main/index_myoffice.aspx?funCode=4", "main");
						break;
				    case "ModInfo":
				        window.open("/myoffice/main/index_environment.aspx?funCode=1", "main");
				        break;
					
				}
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

		                if (CrossYN() || pNoneActiveX == "YES") {
		                    var wWeight = "790";
		                    var wHeight = "830";

		                    var heigth = window.screen.availHeight;
		                    var width = window.screen.availWidth;

		                    var left = (width - wWeight) / 2;
		                    var top = (heigth - wHeight) / 2;
		                    
		                        window.open("/myoffice/ezschedule/schedule_write_Cross.aspx?defaultid=0", "",
		                        "height = " + wHeight + ", width = " + wWeight + ", status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
		                }
		                else {
		                    var wWeight = "790";
		                    var wHeight = "760";

		                    var heigth = window.screen.availHeight;
		                    var width = window.screen.availWidth;

		                    var left = (width - wWeight) / 2;
		                    var top = (heigth - wHeight) / 2;
		                    if (CrossYN() || pNoneActiveX == "YES") {
		                        window.open("/myoffice/ezschedule/schedule_write_Cross.aspx?defaultid=0", "",
		                        "height = " + wHeight + ", width = " + wWeight + ", status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
		                    }
		                    else {
		                        if (pUse_Editor == "" || pUse_Editor == "CK") {
		                            window.open("/myoffice/ezschedule/schedule_write_Cross.aspx?defaultid=0", "",
		                                     "height = " + wHeight + ", width = " + wWeight + ", status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
		                        }
		                        else {
		                            window.open("/myoffice/ezschedule/schedule_write_IE.aspx?defaultid=0", "",
		                                "height = " + wHeight + ", width = " + wWeight + ", status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
		                        }
		                    }
		                }
		                break;

		            case "addresswrite":
		                var wWeight = "600";
		                var wHeight = "500";

		                var heigth = window.screen.availHeight;
		                var width = window.screen.availWidth;

		                var left = (width - wWeight) / 2;
		                var top = (heigth - wHeight) / 2;
		                window.open("/myoffice/ezaddress/address_write.aspx?ownerid=" + escape("${userInfo.id}") + "&folderid=&foldertype=", "",
		                "height = " + wHeight + ", width = " + wWeight + ", status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
		                break;

		            case "resourcewrite":
		                if (CrossYN() || pNoneActiveX == "YES") {
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
		                        url = "/ezResource/scheduleAdd.do?cmd=add&from=schedule&selsd=&seled=&dayView=&ownerID=" + ret[0][0] + "&brdName=" + escape(ret[1][0]);
		                        feature = "status:no;dialogWidth:770px;dialogHeight:700px;help:no;scroll:no;edge:sunken";
		                        feature = feature + GetShowModalPosition(700, 700);
		                        window.showModalDialog(url, ret, feature);
		                    }
		                }
		                break;

		            case "boardwrite":
		                var wWeight = "345";
		                var wHeight = "680";

		                var heigth = window.screen.availHeight;
		                var width = window.screen.availWidth;

		                var left = (width - wWeight) / 2;
		                var top = (heigth - wHeight) / 2;
		                window.open("/ezBoard/writeBoardSelectModal.do", "",
		                    "height = " + wHeight + ", width = " + wWeight + ", status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
		                break;
		        }
		    }
		    function btnWrite_onclick_Complete(ret) {
		        if (ret != "close" && ret != undefined && ret[0][0] != undefined) {
		            url = "/ezResource/scheduleAdd.do?cmd=add&from=schedule&selsd=&seled=&dayView=&ownerID=" + ret[0][0] + "&brdName=" + escape(ret[1][0]);

		            var Schedule_Add_ck = window.open(url, "Schedule_Add_Cross", GetOpenWindowfeature(820, 700));
		            try { Schedule_Add_ck.focus(); } catch (e) {
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

		        if (CrossYN() || pNoneActiveX == "YES") {
		            window.open("/ezEmail/mailWrite.do?cmd=NEW", "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no,resizable=1");
		        } else {
		            if (pUse_Editor == "") {
		                window.open("/ezEmail/mailWrite.do?cmd=NEW", "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no,resizable=1");
		            } else {
		                window.open("/ezEmail/mailWrite.do?cmd=NEW", "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no,resizable=1");
		            }
		        }
		    }

		    var formURL = "";
		    var formDocType = "";
		    var getformcont_cross_dialogArguments = new Array();
		    var url = "";
		    function openForm() {
		        var parameter = new Array();
		        parameter[0] = "${userInfo.deptID}";
		        parameter[1] = "A01000";

		        if ("<%=userApprovalG%>" == ("YES")) {
		            url = "/ezApprovalG/getFormCont.do";
		        } else {
		            url = "/ezApproval/getFormCont.do";
		        }
		        
		        if (CrossYN() || pNoneActiveX == "YES") {
		            getformcont_cross_dialogArguments[0] = parameter;
		            getformcont_cross_dialogArguments[1] = openForm_Complete;
		            var getFormCont_Cross = window.open(url, "getFormCont_Cross", GetOpenWindowfeature(713, 570));
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
		        if ("<%=userApprovalG%>" == ("YES"))
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
		                if (CrossYN() || pNoneActiveX == "YES") {
		                    alert("<spring:message code='ezHome.t3000' />");
		                    return;
		                }
		                else {
		                    var openLocation = "/myoffice/ezApproval" + gb + "/ezViewHWP/ezDraftUI_HWP.aspx";
		                }
		            }
		            else {
		                if (CrossYN() || pNoneActiveX == "YES") {
		                    openLocation = "/myoffice/ezApproval" + gb + "/DraftUI/DraftUI_Cross.aspx";
		                }
		                else {
		                    if (pUse_IE11Browser == "CK")
		                        openLocation = "/myoffice/ezApproval" + gb + "/DraftUI/DraftUI_Cross.aspx";
		                    else {
		                        if (pUse_Editor == "")
		                            openLocation = "/myoffice/ezApproval" + gb + "/DraftUI/draftui.aspx";
		                        else {
		                            openLocation = "/myoffice/ezApproval" + gb + "/DraftUI/draftui_IE.aspx";
		                        }
		                    }
		                }
		                openLocation = openLocation + "?formURL=" + escape(pArgument[1]) + "&DraftFlag=" + escape(pArgument[2]) + "&formDocType=" + escape(pArgument[3]);
		                openLocation = openLocation + "&susinSN=" + escape(pArgument[4]) + "&DocState=" + escape(pArgument[5]) + "&ListType=1" + "&AprState=" + escape(pArgument[6]);
		                openLocation = openLocation + "&isTmpDoc=" + escape(pArgument[7])
		            }
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

		    function scheduleChangeTab(obj) {
		        
		        switch (obj.id) {
		            case "Psch":
		                pMode = "P";
		                document.getElementById("Psch").className = "left_on";
		                document.getElementById("Allsch").className = "right";
		                break;
		            case "Allsch":
		                pMode = "ALL";
		                document.getElementById("Psch").className = "left";
		                document.getElementById("Allsch").className = "right_on";
		              
		                break;
		        }
		        if(selDate != "")
		            getScheduleList(selDate, pMode);
		        else
		            getScheduleList(nowDay, pMode);
		    }
		    function draw_clock() {
		        document.getElementById("clock_id").innerHTML = "";
		        canvas = Raphael("clock_id", 120, 120);
		        hour_hand = canvas.path("M60 60L60 30");
		        hour_hand.attr({ stroke: "#444444", "stroke-width": 3 });
		        minute_hand = canvas.path("M60 60L60 23");
		        minute_hand.attr({ stroke: "#444444", "stroke-width": 2 });
		        second_hand = canvas.path("M60 77L60 18");
		        second_hand.attr({ stroke: "#a0282a", "stroke-width": 1 });
		        var pin = canvas.circle(60, 60, 3);
		        pin.attr("fill", "#000000");
		        update_clock()
		        setInterval("update_clock()", 1000);
		    }
		    var UserOffset = "${userOffset}";
		    function update_clock() {
		        var hours = getWorldTime(parseInt(UserOffset.split(':')[0])).split(":")[0];
		        var minutes = getWorldTime(parseInt(UserOffset.split(':')[0])).split(":")[1];
		        var seconds = getWorldTime(parseInt(UserOffset.split(':')[0])).split(":")[2];
		        hour_hand.rotate(30 * hours + (minutes / 2.5), 60, 60);
		        minute_hand.rotate(6 * minutes, 60, 60);
		        second_hand.rotate(6 * seconds, 60, 60);
		    }
		    function stopClock() {
		        clearTimeout(gizmo);
		    }

		    function yourClock() {
		        var nd = new Date();
		        var h, m;
		        var s;
		        var time = " ";
		        time = getWorldTime(parseInt(UserOffset.split(':')[0]));
		        document.getElementById("timeinput").innerHTML = time;
		        gizmo = setTimeout("yourClock()", 1000);
		    }

		    function getWorldTime(tzOffset) { // 24시간제
		        var now = new Date();
		        var tz = now.getTime() + (now.getTimezoneOffset() * 60000) + (tzOffset * 3600000);
		        now.setTime(tz);
		        var s =
		          leadingZeros(now.getHours(), 2) + ':' +
		          leadingZeros(now.getMinutes(), 2) + ':' +
		          leadingZeros(now.getSeconds(), 2);
		        return s;
		    }

		    function leadingZeros(n, digits) {
		        var zero = '';
		        n = n.toString();

		        if (n.length < digits) {
		            for (i = 0; i < digits - n.length; i++)
		                zero += '0';
		        }
		        return zero + n;
		    }
			
		    function MonthMiniDbClick() {
		    }
		    function reload() {
		        if (CrossYN()) {
		            if (document.getElementById("Psch").className == "left_on") {
		                document.getElementById("Psch").onclick();
		            } else {
		                document.getElementById("Allsch").onclick();
		            }
		        } else {
		            if (document.getElementById("Psch").className == "left_on") {
		                document.getElementById("Psch").click();
		            } else {
		                document.getElementById("Allsch").click();
		            }
		        }
		    }

		    window_onload_total();
		</script>
	</head>
</html>