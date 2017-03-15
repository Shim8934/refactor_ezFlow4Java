<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezPersonal.t250' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezPersonal.e3'/>" type="text/css">
		<script type="text/javascript" src="/js/ezPersonal/controls/dhtml.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/ezPersonal/controls/datepicker.htc.js"></script>
		<script type="text/javascript" src="/js/ezPersonal/controls/composeappt.js"></script>
		
		<script type="text/javascript">
			var compid = "<c:out value = '${companyID}' />";
			var itemseq = "<c:out value = '${personalPopupVO.itemSeq}' />";
			var startdate = "<c:out value = '${personalPopupVO.startDate}' />";
			var enddate = "<c:out value = '${endDate}' />";
			var flag = false;
			var MHTLoadComplete="";
	        var initdate = "<c:out value = '${initDate}' />";
	        
	        window.onload = window_onload;
	        function window_onload() {
	            //compid = window.dialogArguments;
	            initdatepicker();
	
	            if (startdate == "" && enddate == "") {
	                var nowDate = new Date();
	                var weekstr = "<spring:message code='ezPersonal.t25'/>";
	                var arry = weekstr.split(";");
	                document.getElementById("idDatepickers").value = DateFormat(nowDate) + " (" + arry[nowDate.getDay()] + ")";
	                document.getElementById("_D2").value = DateFormat(nowDate) + " (" + arry[nowDate.getDay()] + ")";
	                idDatepicker_Temp = document.getElementById("idDatepickers").value;
	                D2_Temp = document.getElementById("_D2").value;
	            }

	            message.SetEditorContent("${personalPopupVO.content}");
	            
	            if (startdate != "") {
	            }
	            
	            var wPosition = "<c:out value = '${position}' />";
	
	            if (wPosition == 0)
	                document.getElementById("selectPos").selectedIndex = 0;
	            else if (wPosition == 1)
	                document.getElementById("selectPos").selectedIndex = 3;
	            else if (wPosition == 2)
	                document.getElementById("selectPos").selectedIndex = 4;
	            else if (wPosition == 3)
	                document.getElementById("selectPos").selectedIndex = 5;
	            else if (wPosition == 4)
	                document.getElementById("selectPos").selectedIndex = 6;
	            else if (wPosition == 5)
	                document.getElementById("selectPos").selectedIndex = 1;
	            else if (wPosition == 6)
	                document.getElementById("selectPos").selectedIndex = 2;
	        }
	        
			function initdatepicker() {
			    var idDatepicker = new datepicker('idDatepicker', "idDatepickers");
			    idDatepicker.attachEvent('datechange', onStartDateChanged);
			    idDatepicker.attachEvent('enddatechange', onEndDateChanged);
			
			    idDatepicker.elemDateButtons = "img2;img1";
			    idDatepicker.elemDateInputs = "idDatepickers;_D2";
			    idDatepicker.popupType = "both";
			    idDatepicker.pickerDateFormat = "[yyyy]년 [M]월";
			    idDatepicker.inputDateFormat = "[yyyy]-[MM]-[dd] ([ddd])";
			    idDatepicker.firstDayOfWeek = "0";
			    idDatepicker.textDecimal = ".";
			    idDatepicker.textMustSpecifyValidTime = "<spring:message code = 'ezPersonal.t26' />";
			    idDatepicker.daynameLetters = "<spring:message code = 'ezPersonal.t25' />";
			    idDatepicker.daynamesShort = "<spring:message code = 'ezPersonal.t25' />";
			    idDatepicker.daynamesLong = "<spring:message code = 'ezPersonal.t24' />";
			    idDatepicker.monthnamesShort = "1;2;3;4;5;6;7;8;9;10;11;12";
			    idDatepicker.monthnamesLong = "<spring:message code = 'ezPersonal.t23' />";
			    idDatepicker.isoDateUTF = "<c:out value = '${isoUTFstartDate}' />";
			    idDatepicker.isoEndDateUTF = "<c:out value = '${isoUTFEndDate}' />";
			
			    idDatepicker.ready();
			}
			
			function DateFormat(obj) {
			    var yy = String(obj.getFullYear()).substring(0, 4);
			    if (String(obj.getMonth() + 1).length == 1) {
			        var mm = "0" + (obj.getMonth() + 1);
			    }
			    else {
			        var mm = obj.getMonth() + 1;
			    }
			    if (String(obj.getDate()).length == 1) {
			        var dd = "0" + obj.getDate();
			    }
			    else {
			        var dd = obj.getDate();
			    }
			    var date = String(yy) + "-" + String(mm) + "-" + String(dd);
			    return date;
			}
			
			function GetEditorContent()
			{
			    return CKEDITOR.instances.editor1.getData();
			}
			
			function OK_Click() {
				if (specialChk(document.getElementById("Title").value)) {
			    	alert("<spring:message code='ezResource.special' />");
			    	return;
			   	}
				
				if (document.getElementById("Title").value == "") {
					alert("<spring:message code = 'ezPersonal.t148' />");
					return;
				}
				
				if (document.getElementById("Title2").value == "")
				{
					alert("<spring:message code = 'ezPersonal.t148' />");
					return;
				}
	
				if (parseInt(document.getElementById("wWidth").value, 10) != document.getElementById("wWidth").value)
				{
					alert("<spring:message code = 'ezPersonal.t251' />");
					return;
				}
	
				if (parseInt(document.getElementById("wHeight").value, 10) != document.getElementById("wHeight").value)
				{
					alert("<spring:message code = 'ezPersonal.t252' />");
					return;
				}
	
				if (parseInt(document.getElementById("wWidth").value, 10) > 1000)
				{
					alert("<spring:message code = 'ezPersonal.t253' />");
					return;
				}
	
				if (parseInt(document.getElementById("wHeight").value, 10) > 800)
				{
					alert("<spring:message code = 'ezPersonal.t254' />");
					return;
				}
	
				if (get_length(document.getElementById("Title").value, 10) > 250)
				{
					alert("<spring:message code = 'ezPersonal.t149' />");
					document.getElementById("Title").focus();
					return;
				}
				
				if (get_length(document.getElementById("Title2").value, 10) > 250)
				{
					alert("<spring:message code = 'ezPersonal.t149' />");
					document.getElementById("Title2").focus();
					return;
				}
				
	            
				var tmpStartDateTime = idDatepicker.startFullYear() + "-"
								+ CheckTimeRevision((parseInt(idDatepicker.startMonth()) + 1)) + "-"
								+ CheckTimeRevision(idDatepicker.startDate()) + " "
						        + CheckTimeRevision(idDatepicker.startHours()) + ":"
								+ CheckTimeRevision(idDatepicker.startMinutes()) + ":01";
				var tmpEndDateTime = idDatepicker.endFullYear() + "-"
								+ CheckTimeRevision((parseInt(idDatepicker.endMonth()) + 1)) + "-"
								+ CheckTimeRevision(parseInt(idDatepicker.endDate() + 1)) + " "
								+ CheckTimeRevision(idDatepicker.endHours()) + ":"
								+ CheckTimeRevision(idDatepicker.endMinutes()) + ":01";

				$.ajax({
		        	type : "POST",
		        	url : "/admin/ezPersonal/savePopup.do",
		        	async : false,
		        	data : {companyID : compid,
		        			itemSeq : itemseq,
		        			title : Title.value,
		        			title2 : Title2.value,
		        			startDate : tmpStartDateTime,
		        			endDate : tmpEndDateTime,
		        			width : wWidth.value,
		        			height : wHeight.value,
		        			position : document.getElementById("selectPos").value,
		        			content : message.GetEditorContent() },
		        	dataType : "text",
		        	success : function (result) {
		        		if (result != "OK") {
							alert("<spring:message code = 'ezPersonal.t255' />");
		        		} else {
		        			if (itemseq != "") {
								alert("<spring:message code = 'ezPersonal.t256' />");
							} else {
								alert("<spring:message code = 'ezPersonal.t257' />");
							}
				            
		        			window.opener.company_change();
							window.close();
		        		}
		        	}
		        });
			}
			
			function CheckTimeRevision(szTime) {
			    if (parseInt(szTime) == 0) {
			        szTime = "00";
			    } else if (parseInt(szTime) > 0 && parseInt(szTime) < 10) {
			        szTime = "0" + szTime;
			    }
			
			    return szTime;
			}
			
			function html_edit() {
			    var rtnValue = window.showModalDialog("/myoffice/ezEmail/htm/html_edit.aspx", message.GetEditorContent(), "dialogHeight:480px; dialogWidth:538px; status:no; scroll:no; help:no; edge:sunken" + GetShowModalPosition(538, 480));
			    if (typeof (rtnValue) != "undefined") {
			        message.SetEditorContent(rtnValue);
			    }
			}
			
			function get_length(chkstr) {
			    var length = 0;
			    var i;
			
			    for (i = 0; i < chkstr.length; i++) {
			        if (chkstr.charCodeAt(i) > 256) {
			            length = length + 2;
			        } else {
			            length++;
			        }
			    }
			    
			    return length;
			}
		</script>
	</head>
	<body class = "popup">
		<xmp id="sigBody" style="display:none;"><c:out value = '${personalPopupVO.content}' /></xmp> 
		<h1><spring:message code = 'ezPersonal.t258' /></h1>
		<table class="content"> 
  			<tr> 
    			<th><spring:message code = 'ezPersonal.t259' /></th> 
    			<td>
    				<spring:message code = 'ezPersonal.t260' /><br> 
      				<spring:message code = 'ezPersonal.t261' />
      			</td> 
  			</tr> 
  			<tr> 
    			<th><spring:message code = 'ezPersonal.t262' /></th> 
    			<td>
    				<spring:message code = 'ezPersonal.t263' />
      				<input type="text" id=wWidth style="WIDTH:50" value="<c:out value = '${personalPopupVO.width}' />"> &nbsp;&nbsp;&nbsp;&nbsp; <spring:message code = 'ezPersonal.t264' />
      				<input type="text" id=wHeight style="WIDTH:50" value="<c:out value = '${personalPopupVO.height}' />">
      			</td> 
  			</tr> 
  			<tr> 
    			<th><spring:message code = 'ezPersonal.tt9' /></th> 
    			<td>
					<select id="selectPos"> 
						<option value="0"><spring:message code = 'ezPersonal.tt2' /></option> 
						<option value="5"><spring:message code = 'ezPersonal.tt3' /></option> 
						<option value="6"><spring:message code = 'ezPersonal.tt4' /></option> 
						<option value="1"><spring:message code = 'ezPersonal.tt5' /></option> 
						<option value="2"><spring:message code = 'ezPersonal.tt6' /></option> 
						<option value="3"><spring:message code = 'ezPersonal.tt7' /></option> 
						<option value="4"><spring:message code = 'ezPersonal.tt8' /></option>
					</select> </td> 
  			</tr> 
  			<tr> 
    			<th><spring:message code = 'ezPersonal.t154' /></th> 
    			<td style="padding:0">
    				<table width="100%">
			        	<tr class="primary">
			          		<th><c:out value = '${langPrimary}' /></th>
			          		<td><input type="text" name="Input" id=Title style="WIDTH:98%" value="<c:out value = '${personalPopupVO.title}' />"></td>
			        	</tr>
			        	<tr class="secondary">
			          		<th><c:out value = '${langSecondary}' /></th>
			          		<td><input type="text" id=Title2 style="WIDTH:98%" value="<c:out value = '${personalPopupVO.title2}' />"></td>
			        	</tr>
			    	</table>
    			</td> 
  			</tr> 
  			<tr> 
    			<th><spring:message code = 'ezPersonal.t265' /></th> 
    			<td>
    				<input class='datepicker' id='idDatepickers'  readonly="readonly" />
			        <img width="19" height="15" align="absmiddle" border="0" popupLocation='bottomright' forceMarginLeft='-20' id="img2" src="/images/i_scheduler.gif" style="cursor:pointer; POSITION: relative;"> ~
			        <input id='_D2' class='datepicker_date' readonly="readonly"> 
			        <img width="19" height="15" align="absmiddle" border="0" popupLocation='bottomright' forceMarginLeft='-20' id="img1" src="/images/i_scheduler.gif" style="cursor:pointer; POSITION: relative;"> 
  					<tr style="display:none"> 
    					<td>
    						<input id='_T1' class='datepicker_time' readonly> 
      						<IMG align="absmiddle" border="0" height="16" id="img_StartTime" src="/images/arr_right.gif" style="CURSOR: hand; POSITION: relative" width="16"> 
      						<input id='_T2' class='datepicker_time' readonly> 
      						<IMG align="absmiddle" border="0" height="16" id="img_EndTime" src="/images/arr_right.gif" style="CURSOR: hand; POSITION: relative" width="16"></td> 
  					</tr> 
  					<tr> 
    					<th><spring:message code = 'ezPersonal.t155' /></th> 
   						<td style="padding:0px; height:320px">
    						<iframe id="message" class="viewbox"  name="message" src="/admin/ezPersonal/addPopupCKContent.do" style="padding:0px; height:100%; width:100%; overflow:auto;border:none;"></iframe>
    					</td> 
  					</tr>
  				</td>
  			</tr>
		</table> 
		<div class="btnposition"> 
		    <%-- <a class="imgbtn"><span onclick="html_edit()">HTML<spring:message code = 'ezPersonal.t156' /></span></a> --%>
		    <a class="imgbtn"><span onclick="OK_Click()"><spring:message code = 'ezPersonal.t12' /></span></a>
		    <a class="imgbtn"><span onclick="window.close()"><spring:message code = 'ezPersonal.t13' /></span></a>
		</div>
	</body>
</html>