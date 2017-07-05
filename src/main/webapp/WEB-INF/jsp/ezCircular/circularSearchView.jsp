<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="<spring:message code='ezCircular.c1' />" type="text/css" />		
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
		<link rel="stylesheet" href="/js/jquery/timeControls/jquery.timepicker.css" type="text/css" />
		<script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>	    
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>		
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
	    <script type="text/javascript">
	    	var checkval = "f";
			var startdate = "<c:out value='${startDate}' />";
			var enddate = "<c:out value='${endDate}' />";
			var filter = "<c:out value='${filter}' />";
			var keyword = "<c:out value='${keyword}' />";
			var offSetMin = "<c:out value='${offSetMin}' />";

		    document.onselectstart = function () { return false; };
		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }

		        $("keyword").text = "";
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
		        } else {
		            SDate = utcDate(offSetMin);
		            EDate = utcDate(offSetMin);		            
		        }
		        
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', SDate);
		
		        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Edatepicker").datepicker('setDate', EDate);
		    });
		    
		    var monthMsg = "<spring:message code='ezCircular.t129' />";
		    var monthStr = monthMsg.split(";");		    
		    var dayMsg = "<spring:message code='ezCircular.t128' />";
		    var dayStr = dayMsg.split(";");
		    
		    $(function () {
		        $.datepicker.regional["<spring:message code='ezCircular.t130' />"] = {
		        	closeText: "<spring:message code='ezCircular.t84' />",
		            prevText: "<spring:message code='ezCircular.t131' />",
		            nextText: "<spring:message code='ezCircular.t132' />",
					currentText: "<spring:message code='ezCircular.t133' />",
		            monthNames: monthStr,
		            monthNamesShort: monthStr,
		            dayNames: dayStr,
		            dayNamesShort: dayStr,
		            dayNamesMin: dayStr,
		            weekHeader: 'Wk',
		            dateFormat: 'yy-mm-dd',
		            firstDay: 0,
		            isRTL: false,
		            duration: 200,
		            showAnim: 'show',
		            showMonthAfterYear: true
		        };
		        $.datepicker.setDefaults($.datepicker.regional["<spring:message code='ezCircular.t130' />"]);
		    });
		
		    function search() {		    	
		    	if (specialChk(document.getElementById("keyword").value)) {
		    		alert("<spring:message code='ezCircular.t134' />");
		    		return;
		    	}
		    	
		        if (document.getElementById("keyword").value == "") {
		            alert("<spring:message code='ezCircular.t135'/>");
		            document.getElementById("keyword").focus();
		            return;
		        }
		        		
		        var sdate = "";
		        var edate = "";
		        var keyword = "";
		        var strSearch = "";
		        var filter = "";

		        if ($("#Sdatepicker").is(":enabled")) {
		            sdate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		            edate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		        }		

		        if (sdate > edate) {
		        	alert("<spring:message code='ezCircular.t136' />");
		        	return;
		        }

		        if (document.getElementById("keyword").value != "") {
		            filter = document.getElementsByName("search_field")[0].value;
		            keyword = document.getElementById("keyword").value;
		        }

		        window.location.href = "/ezCircular/circularSearchView.do?sdate=" + sdate + "&edate=" + edate + "&filter=" + encodeURIComponent(filter) + "&keyword=" + keyword;
		    }
		    
		    function check_change(checkbox) {
// 			    if (checkval == "f") {
// 			        var Rows = searchList1.childNodes.item(0).childNodes.item(0).childNodes;
// 			        for (var i = 0; i < Rows.length; i++) {
// 			            if (!Rows.item(i).childNodes.item(0).childNodes.item(0).disabled) {
// 			                Rows.item(i).childNodes.item(0).childNodes.item(0).checked = true;
// 			                for (var RowCnt = 0; RowCnt < Rows.item(i).childNodes.length; RowCnt++) {
// 			                    Rows.item(i).childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
// 			                }
// 			                listContentArry[listContentArry.length] = Rows.item(i).getAttribute("id");
// 			            }
// 			        }
// 			        checkval = "t";
// 			    }
// 			    else if (checkval == "t") {
// 			        var Rows = searchList1.childNodes.item(0).childNodes.item(0).childNodes;
// 			        for (var i = 0; i < Rows.length; i++) {
// 			            Rows.item(i).childNodes.item(0).childNodes.item(0).checked = false;
// 			            for (var RowCnt = 0; RowCnt < Rows.item(i).childNodes.length; RowCnt++) {
// 			                Rows.item(i).childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
// 			            }
// 			        }
// 			        listContentArry = new Array();
// 			        checkval = "f";

// 			    }
			}
			
		    var usepostDate = false;
		    function DateSearch_Click() {
		        if(usepostDate){
		            usepostDate = false;
		            $("#Sdatepicker").datepicker('disable');
		            $("#Edatepicker").datepicker('disable');
		        }
		        else {
		            usepostDate = true;
		            $("#Sdatepicker").datepicker('enable');
		            $("#Edatepicker").datepicker('enable');
		        }
		    }
		    
		    function ReplaceText(orgStr, findStr, replaceStr) {
		        var re = new RegExp(findStr, "gi");
		        return (orgStr.replace(re, replaceStr));
		    }
		    
		    function event_click(obj) {
		    	
		    }
			
		    function ItemRead_onclick(circularID) {
		        var circularID = circularID;

		        if (CrossYN()) {
		            var feature = GetOpenPosition(820, 900);
	            	window.open("/ezCircular/circularRead.do?circularID=" + circularID, "", "width=820, height=900, status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=1" + feature);
	        	} else {
	            	var feature = GetOpenPosition(790, 900);
	            	window.open("/ezCircular/circularRead.do?circularID=" + circularID, "", "width=790, height=900, status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=1" + feature);
	        	}
		    }
			
		    function RefreshView() {
		        window.location.href = "/ezCircular/circularSearchView.do?sdate=" + startdate + "&edate=" + enddate + "&filter=" + encodeURIComponent(filter) + "&keyword=" + encodeURIComponent(keyword);
		    }
			
		    function onmouseOver(elem) {
		        elem.style.color = "blue";
		        elem.style.backgroundColor = "rgb(233, 241, 244)";
		    }
		
		    function onmouseOut(elem) {
		        elem.style.color = "";
		        elem.style.backgroundColor = "#FFFFFF";
		    }
			
		    function search_keypress(evt) {
		        var evtKeyCode = (window.event) ? event.keyCode : evt.which;
		
		        if (evtKeyCode == "13") {
		            search();
		        }
		    }
		</script>
	</head>
	<body class="mainbody"> 
		<form method="post"> 
			<h1><spring:message code='ezCircular.t8' /></h1> 
		  	<table style="width:100%" class="content">  
		    	<tr> 
		      		<th><spring:message code='ezCircular.t139' /></th> 
		      		<td style="width:100%">
		      			<select name="search_field" id="search_field" style="WIDTH: 130px"> 
		          			<option value="circularNew" ${filter == 'circularNew' ? 'selected' : ''}><spring:message code='ezCircular.t2' /></option> 
		          			<option value="circularComplete" ${filter == 'circularComplete' ? 'selected' : ''}><spring:message code='ezCircular.t3' /></option>
		          			<option value="circularMy" ${filter == 'circularMy' ? 'selected' : ''}><spring:message code='ezCircular.t4' /></option>
		          			<option value="circularTemp" ${filter == 'circularTemp' ? 'selected' : ''}><spring:message code='ezCircular.t5' /></option>
		          			<option value="circularFolder" ${filter == 'circularFolder' ? 'selected' : ''}><spring:message code='ezCircular.t7' /></option> 
		        		</select>
		        		<input type="text" id="keyword" size="21" onkeypress="return search_keypress(event)" /> 
		        		<a href="#" class="imgbtn"><span onClick="search()"><spring:message code='ezCircular.t85' /></span></a>
		        	</td> 
		    	</tr> 
		    	<tr> 
		      		<th><spring:message code='ezCircular.t137' /></th>
		      		<td>
						<input type="checkbox" value="1" id="usepostdate" style="display:none;"><a class="imgbtn"><span onclick="DateSearch_Click();"><spring:message code='ezCircular.t138' /></span></a>
		            	<input type="text" id="Sdatepicker" style="width:80px;text-align:center" disabled/> ~
		      			<input type="text" id="Edatepicker" style="width:80px;text-align:center" disabled/>
			  		</td>
			  	</tr>
		  	</table> 
		 	<br/>
		 	<h2 class="h2_dot">
		 		<spring:message code='ezCircular.t146'/>&nbsp;<span class="point">${totalCount}</span>&nbsp;<span id="resultCount"></span><spring:message code='ezCircular.t145'/>
		    </h2>		
		  	<table class="mainlist" style="table-layout:fixed;width:100%">
		    	<tr> 
		      		<th style="width:20px; padding: 0px; color: black;padding-left:3px;" nowrap title><input type="checkbox" id="Checkbox1" onClick="check_change(this)"></th>
			        <th style="width:18px; padding: 0px; color: black;padding-left:3px;cursor:pointer;text-align:center" nowrap title onclick="event_HeaderClick(this)"><img src="/images/ImgIcon/view-importance.gif" border="0"></th>
			        <th style="width:18px; padding: 0px; color: black;cursor:pointer;text-align:center" nowrap title onclick="event_HeaderClick(this)"><img src="/images/newAttach.gif" border="0"></th>
					<c:if test="${type == 'N'}">
						<th style="width:30px;cursor:pointer;text-align:center" id="updateStatus" onclick="event_HeaderClick(this)"><spring:message code='ezCircular.t140' /></th> 
						<th style="width:50px;cursor:pointer;text-align:center" id="tofromname" onclick="event_HeaderClick(this)"><spring:message code='ezCircular.t124' /></th>
					</c:if>
					<c:if test="${type == 'C'}">
						<th style="width:30px;cursor:pointer;text-align:center" id="updateStatus" onclick="event_HeaderClick(this)"><spring:message code='ezCircular.t65' /></th> 
						<th style="width:50px;cursor:pointer;text-align:center" id="tofromname" onclick="event_HeaderClick(this)"><spring:message code='ezCircular.t124' /></th>
					</c:if>
					<c:if test="${type != 'N' && type != 'C'}">
						<th style="width:80px;cursor:pointer;text-align:center" id="tofromname" onclick="event_HeaderClick(this)"><spring:message code='ezCircular.t124' /></th>					
					</c:if>
					<th style="width:350px;cursor:pointer" align="left" onclick="event_HeaderClick(this)"><spring:message code='ezCircular.t32' /></th> 
					<th style="width:120px;cursor:pointer" align="left" id="tofromdate" onclick="event_HeaderClick(this)"><spring:message code='ezCircular.t122' /></th> 
					<th style="width:150px;" align="left"><spring:message code='ezCircular.t123' /></th> 
					<th style="width:100px;cursor:pointer;text-align:center" onclick="event_HeaderClick(this)"><spring:message code='ezCircular.t141' /></th>
					<th style="width:150px;cursor:pointer" align="left" onclick="event_HeaderClick(this)"><spring:message code='ezCircular.t142' /></th> 
		    	</tr>
		    	<c:forEach var="item" items="${list}" varStatus="status">
			    	<tr id="searchList${status.count}" style="cursor:pointer;padding:0" onClick="event_click(this)" ondblClick="ItemRead_onclick('${item.circularID}')" bgcolor=#ffffff>
			    		<td style="width:20px"><input type="checkbox" id="checkbox${status.count }"></td>
			    		<td style="width:18px; padding: 0px; color: black;padding-left:3px;cursor:pointer;text-align:center">
			    			<c:if test="${item.importance == '0'}">&nbsp;</c:if>
			    			<c:if test="${item.importance == '1'}"><img src='/images/ImgIcon/view-importance.gif'/></c:if>
			    		</td>
			    		<td style="width:18px; padding: 0px; color: black;cursor:pointer;text-align:center">
			    			<c:if test="${item.hasFile == '0'}">&nbsp;</c:if>
			    			<c:if test="${item.hasFile == '1'}"><img src='/images/newAttach.gif'/></c:if>
			    		</td>
			    		<c:if test="${type == 'N'}">
			    			<c:if test="${item.updateStatus == '0'}">
								<td style="width:30px;cursor:pointer;text-align:center;font-weight:bold;color:red;">신</td>
							</c:if>
				    		<c:if test="${item.updateStatus == '4'}">
				    			<td style="width:30px;cursor:pointer;text-align:center;font-weight:bold;color:blue;">의</td>
				    		</c:if>
				    		<td style="width:50px;cursor:pointer;text-align:center;">
				    			<c:if test="${item.status == '0'}"><spring:message code='ezCircular.t125' /></c:if>
				    			<c:if test="${item.status == '1'}"><spring:message code='ezCircular.t126' /></c:if>
				    			<c:if test="${item.status == '2'}"><spring:message code='ezCircular.t127' /></c:if>
				    		</td>
						</c:if>
						<c:if test="${type == 'C'}">
			    			<c:if test="${item.updateStatus == '0'}">
								<td style="width:30px;cursor:pointer;text-align:center;font-weight:bold;"><spring:message code='ezCircular.t143' /></td>
							</c:if>
				    		<c:if test="${item.updateStatus == '1'}">
				    			<td style="width:30px;cursor:pointer;text-align:center;;"><spring:message code='ezCircular.t65' /></td>
				    		</c:if>
				    		<td style="width:50px;cursor:pointer;text-align:center;">
				    			<c:if test="${item.status == '0'}"><spring:message code='ezCircular.t125' /></c:if>
				    			<c:if test="${item.status == '1'}"><spring:message code='ezCircular.t126' /></c:if>
				    			<c:if test="${item.status == '2'}"><spring:message code='ezCircular.t127' /></c:if>
				    		</td>
						</c:if>
						<c:if test="${type != 'N' && type != 'C'}">
							<td style="width:80px;cursor:pointer;text-align:center">
				    			<c:if test="${item.status == '0'}"><spring:message code='ezCircular.t125' /></c:if>
				    			<c:if test="${item.status == '1'}"><spring:message code='ezCircular.t126' /></c:if>
				    			<c:if test="${item.status == '2'}"><spring:message code='ezCircular.t127' /></c:if>
				    		</td>
						</c:if>
			    		<td style="width:350px" align="left">${item.title}</td> 
		          		<td style="width:120px" align="left">${item.memberName}</td>		         
		            	<td style="width:150px" align="left">${item.regDate}</td>
		            	<c:if test="${type == 'T' }">
			            	<td style="width:100px;cursor:pointer;text-align:center"></td>
		            	</c:if>
		            	<c:if test="${type != 'T' }">
			            	<td style="width:100px;cursor:pointer;text-align:center">${item.confirmCount}/${item.confirmTotalCount}</td>
		            	</c:if>
		            	<td style="width:150px;cursor:pointer" align="left">${item.confirmDate}</td>
			    	</tr>
		    	</c:forEach>		    	
		    	<c:if test="${totalCount == 0 && keyword != null && startDate != null}">
			    	<tr> 
			    		<c:if test="${type == 'N' || type == 'C'}">
				        	<td colspan="10" style="text-align:center"><spring:message code='ezCircular.t144' /></td> 
			    		</c:if>
			    		<c:if test="${type != 'N' && type != 'C'}">
				        	<td colspan="9" style="text-align:center"><spring:message code='ezCircular.t144' /></td> 
			    		</c:if>
			      	</tr>
		      	</c:if>
		  	</table>		
		</form> 
	</body>
</html>

