<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
	<head>
		<title>업무검색</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezTask.e2' />" type="text/css">
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css">
		<link rel="stylesheet" href="/js/jquery/timeControls/jquery.timepicker.css" type="text/css" />
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
		<script type="text/javascript">
			var startdate = "_startdate";
			var enddate = "_enddate";
			var filter = "_filter";
		    var orgfilter = "_OrgFilter";
		    var pUse_Editor = "Use_Editor";
		    var pSearchType = "pSearchType";
		    document.onselectstart = function () { return false; };
		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
// 				if (startdate != "")
// 				{
// 					document.getElementById("usedate").checked = true;
// 					document.getElementById('search_class').value = "_tclass";
// 				    document.getElementById("keyword").value = "_OrgFilter";
// 				}
// 		        if (pSearchType != "") {
// 		            if (pSearchType == "person")
// 		                document.getElementById("search_field").selectedIndex = 1;
// 		        }
		    }

		    $(function () {
		        $("#Sdatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.gif",
		            buttonImageOnly: true
		        });
		        $("#Edatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.gif",
		            buttonImageOnly: true
		        });
		        var SDate;
		        var EDate;
		        if (startdate != "") {
		            SDate = new Date(startdate);
		            EDate = new Date(enddate);
		        }
		        else {
		            SDate = new Date();
		            EDate = new Date();
		        }
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', SDate);
		
		        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Edatepicker").datepicker('setDate', EDate);
		    });

		    $(function () {
		    	$.datepicker.regional["<spring:message code='main.t0619' />"] = {
					closeText: "<spring:message code='main.t3' />",
					prevText: "<spring:message code='main.t0604' />",
					nextText: "<spring:message code='main.t0605' />",
					currentText: "<spring:message code='main.t0606' />",
					monthNames: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
					             "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
					             "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
					             "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
					monthNamesShort: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
					                  "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
					                  "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
					                  "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
					dayNames: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
					           "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />",
					           "<spring:message code='main.t0627' />"],
					dayNamesShort: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
					                "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
					                "<spring:message code='main.t0627' />"],
					dayNamesMin: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
					              "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
					              "<spring:message code='main.t0627' />"],
					weekHeader: "Wk",
					dateFormat: "yy-mm-dd",
					firstDay: 0,
					isRTL: false,
					duration: 200,
					showAnim: "show",
					showMonthAfterYear: true
				};
				
				$.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
		    });

// 		    $(function () {
// 		        $.datepicker.regional['en'] = {
// 		            dateFormat: 'yy-mm-dd',
// 		            firstDay: 0,
// 		            isRTL: false,
// 		            duration: 200,
// 		            showAnim: 'show',
// 		            showMonthAfterYear: true
// 		        };
// 		        $.datepicker.setDefaults($.datepicker.regional['en']);
// 		    });

			function search()
			{
				var sdate = "";
				var edate = "";
				
				var filter = "";
				if (document.getElementById("usedate").checked)
				{
				    sdate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
				    edate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
				}
				if (document.getElementById("keyword").value != "")
					filter = document.getElementById("keyword").value;
				
				window.location.href = "/myoffice/ezTask/task_search_Cross.aspx?sdate=" + sdate + "&edate=" + edate + "&filter=" + escape(filter) + "&searchtype=" + document.getElementById("search_field").value + "&tclass=" + document.getElementById("search_class").value + "&event=search";
			}

			function ReplaceText( orgStr, findStr, replaceStr )
			{
				var re = new RegExp( findStr, "gi" );
				return ( orgStr.replace( re, replaceStr ) );
			}

			function open_task(taskid, repeatcount, date)
			{
				date = date.substr(0,10);
				
				var feature = GetOpenPosition(760, 656);
				if (CrossYN() || pNoneActiveX == "YES") {
				    window.open("/myoffice/ezTask/task_read_Cross.aspx" + "?id=" + taskid + "&repeatcount=" + repeatcount + "&date=" + date, "",
					"height = 656px, width = 760px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
				}
				else {
				    if (pUse_Editor == "" || pUse_Editor == "CK") {
				        window.open("/myoffice/ezTask/task_read.aspx" + "?id=" + taskid + "&repeatcount=" + repeatcount + "&date=" + date, "",
					"height = 656px, width = 760px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
				    }
				    else {
				        window.open("/myoffice/ezTask/task_read_IE.aspx" + "?id=" + taskid + "&repeatcount=" + repeatcount + "&date=" + date, "",
					"height = 656px, width = 760px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
				    }
				}
			}

			function RefreshView()
			{
			    window.location.reload(true);
			}		

			function onmouseOver(elem)
			{
				elem.style.color = "blue";
				elem.style.backgroundColor = "#ECF3BA";
			}

			function onmouseOut(elem)
			{
				elem.style.color = "";
				elem.style.backgroundColor = "#FFFFFF";
			}

			function search_keypress(evt)
			{	
			    if(window.event)
			    {
			        if(evt.keyCode != 13)
			            return;
			    }
		        else
		        {
			        if(evt.which != 13)
			            return;
		        }
		        search();
			}

			var usedate = false;
			function DateSearch_Click() {
		        if(usedate){
		        	usedate = false;
		            $("#Sdatepicker").datepicker('disable');
		            $("#Edatepicker").datepicker('disable');
		        } else {
		        	usedate = true;
		            $("#Sdatepicker").datepicker('enable');
		            $("#Edatepicker").datepicker('enable');
		        }
		    }
		</script>
	</head>
	<body class="mainbody">
	<form method="post" runat="server">
		<h1><spring:message code='ezTask.t180' /></h1>
		<table class="content">
			<tr>
				<th style="height:auto"><spring:message code='ezTask.t181' /></th>
				<td>
					<select id="search_field" name="search_field" style="WIDTH: 70px;vertical-align:middle">
						<option  value="title" selected><spring:message code='ezTask.t182' /></option>
						<option  value="person" ><spring:message code='ezTask.t2005' /></option>
					</select>
					<select name="search_class" id="search_class" style="WIDTH: 80px;vertical-align:middle">
						<option  value="" selected ><spring:message code='ezTask.t240' /></option>
						<option  value="1" ><spring:message code='ezTask.t97' /></option>
						<option  value="2"><spring:message code='ezTask.t98' /></option>
						<option  value="3"><spring:message code='ezTask.t99' /></option>
						<option  value="4"><spring:message code='ezTask.t100' /></option>
					</select>
					<input name="text" type="text" id="keyword" onKeyPress="return search_keypress(event)" size="21" style="vertical-align:middle">
					<span style="vertical-align:middle"><a class="imgbtn" style="vertical-align:middle"><span onClick="search()"><spring:message code='ezTask.t183' /></span></a></span>
				</td>
			</tr>
			<tr>
				<th style="height:auto"><spring:message code='ezTask.t184' /></th>
				<td>
					<input type="checkbox" id="usedate" value="1" onclick="DateSearch_Click();">
					<span style="vertical-align:middle"><spring:message code='ezTask.t185' /></span>
					<input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly" disabled> ~
					<input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly" disabled>
					<span style="vertical-align:middle" >&nbsp;&nbsp;&nbsp;(<spring:message code='ezTask.t188' />)</span>
				</td>
			</tr>
		</table>
		<br>
		<div class="txt">
			<h2 class="h2_dot"><spring:message code='ezTask.t190' /><span class="point">
<!-- 			<asp:Label ID="LabelCount" class="point" Runat="server"></asp:Label> -->
			</span><span id="resultCount"></span><spring:message code='ezTask.t191' /></h2>
		</div>
		
		<table class="mainlist" style="width:100%" >
			<tr>
				<th style="width:50px"><spring:message code='ezTask.t156' /></th>
				<th style ="width:30px"><img src="/images/newAttach.gif"></th>
				<th style ="width:80px" ><spring:message code='ezTask.t2005' /></th>
				<th><spring:message code='ezTask.t118' /></th>
				<th style ="width:90px"><spring:message code='ezTask.t2003' /></th>
				<th style ="width:90px"><spring:message code='ezTask.t119' /></th>
				<th style ="width:110px" ><spring:message code='ezTask.t120' /></th>
				<th style ="width:80px" ><spring:message code='ezTask.t121' /></th>
				<th style ="width:97px"><spring:message code='ezTask.t122' /></th>
			</tr>
<!-- 			<asp:Repeater ID="ListTask" Runat="server"> -->
<!-- 				<ItemTemplate> -->
<%-- 					<tr style="cursor:pointer;" onClick="open_task('<%# ((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("TASKID").InnerText %>','<%# ((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("REPEATCOUNT").InnerText %>','<%# ((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("STARTDATE").InnerText %>')"> --%>
<%-- 						<td style="white-space:nowrap;text-align:center"><%# ((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("IMPORTANCE").InnerText %> </td> --%>
<%-- 						<td style="white-space:nowrap"><%# ((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("HASATTACH").InnerText %> </td> --%>
<%-- 						<% if(userinfo.primary == "1")%> --%>
<%-- 						<% {%> --%>
<%-- 						<td style="white-space:nowrap"><%# Server.HtmlEncode(((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("TASKPERSONNAME").InnerText) %> </td> --%>
<%-- 						<%} --%>
<!-- // 						else -->
<%-- 						{ %> --%>
<%-- 						<td style="white-space:nowrap"><%# Server.HtmlEncode(((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("TASKPERSONNAME2").InnerText) %> </td> --%>
<%-- 						<%}%> --%>
						
<%-- 						<td > <%# Server.HtmlEncode(((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("TITLE").InnerText) %> <font color = "#c64200"><%# Server.HtmlEncode(((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("HASCOMMENT").InnerText) %></font></td> --%>
<%-- 						<td style="white-space:nowrap;"><%# ((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("TASKTYPE").InnerText %></td> --%>
<%-- 						<td style="white-space:nowrap;"><%# ((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("TASKSTATUS").InnerText %> </td> --%>
<!-- 						<td style="white-space:nowrap;"> -->
<%-- 						<span class="workprogress" style="margin-right:0px"><span class="bar" style="width:  <%# ((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("COMPLETERATE").InnerText %>%"></span></span> --%>
<%-- 						<span style="width:30px;display:inline-block"><%# ((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("COMPLETERATE").InnerText %>%</span> --%>
<!-- 						</td> -->
<%-- 						<td style="white-space:nowrap;"><%# ((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("STARTDATE").InnerText %> </td> --%>
<%-- 						<td style="white-space:nowrap;"><div class="point"><%# ((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("ENDDATE").InnerText %></div></td> --%>
<!-- 					</tr> -->
<!-- 				</ItemTemplate> -->
<!-- 			</asp:Repeater> -->
<!-- 			<asp:PlaceHolder ID="HolderNone" Runat="server"> -->
			<tr>
			<td colspan="9" style="height:25px;background-color:white;text-align:center"><spring:message code='ezTask.t192' /></td>
			</tr>
<!-- 			</asp:PlaceHolder> -->
		</table>
		<br>
		<br>
	</form>
	</body>
</html>