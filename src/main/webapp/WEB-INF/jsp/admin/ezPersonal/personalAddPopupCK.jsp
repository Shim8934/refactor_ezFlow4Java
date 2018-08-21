<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezPersonal.t250' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezPersonal.e3', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}"/>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}"/>
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" />
		<script type="text/javascript" src="${util.addVer('/js/ezPersonal/controls/dhtml.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
		<!-- <script type="text/javascript" src="${util.addVer('/js/ezPersonal/controls/datepicker.htc.js')}"></script> -->
		<!-- <script type="text/javascript" src="${util.addVer('/js/ezPersonal/controls/composeappt.js')}"></script> -->
		
		<script type="text/javascript">
			var compid = "<c:out value = '${companyID}' />";
			var itemseq = "<c:out value = '${personalPopupVO.itemSeq}' />";
			var startdate = "<c:out value = '${personalPopupVO.startDate}' />";
			var enddate = "<c:out value = '${personalPopupVO.endDate}' />";
			var flag = false;
			var MHTLoadComplete="";
	        var initdate = "<c:out value = '${initDate}' />";
	        
	        window.onload = window_onload;
	        function window_onload() {
	            //compid = window.dialogArguments;

	            if (startdate == "" && enddate == "") {
	                var nowDate = new Date();
	                document.getElementById("Sdatepicker").value = DateFormat(nowDate);
	    	        document.getElementById("Edatepicker").value = DateFormat(nowDate);
	            }
	            
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
			
			function OK_Click() {
				if (specialChk(document.getElementById("Title").value)) {
			    	alert("<spring:message code='ezResource.special' />");
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
				
				if (parseInt(document.getElementById("wWidth").value, 10) < 100)
				{
					alert("<spring:message code = 'ezAdmin.jjh01' />");
					return;
				}
	
				if (parseInt(document.getElementById("wHeight").value, 10) < 250)
				{
					alert("<spring:message code = 'ezAdmin.jjh02' />");
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
				
				var tmpStartDateTime = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00:00:01";
			    var tmpEndDateTime = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 23:59:59";

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
			
			function Editor_Complete() {
				message.SetEditorContent("${personalPopupVO.content}");
			}
		</script>
	</head>
	<body class = "popup">
		<xmp id="sigBody" style="display:none;"><c:out value = '${personalPopupVO.content}' /></xmp> 
		<h1><spring:message code = 'ezPersonal.t258' /></h1>
		<div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
		<table class="content"> 
  			<tr> 
    			<th><spring:message code = 'ezPersonal.t259' /></th> 
    			<td style="height:35px">
    				<spring:message code = 'ezPersonal.t260' /><br> 
      				<spring:message code = 'ezPersonal.t261' />
      			</td> 
  			</tr> 
  			<tr> 
    			<th><spring:message code = 'ezPersonal.t262' /></th> 
    			<td>
    				<spring:message code = 'ezPersonal.t263' />
      				<input type="text" id=wWidth style="width:50px;height:22px;" value="<c:out value = '${personalPopupVO.width}' />"> &nbsp;&nbsp;&nbsp;&nbsp; <spring:message code = 'ezPersonal.t264' />
      				<input type="text" id=wHeight style="width:50px;height:22px;" value="<c:out value = '${personalPopupVO.height}' />">
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
    			<td style="padding:0px">
    				<table width="100%">
			        	<tr class="primary">
			          		<th><c:out value = '${langPrimary}' /></th>
			          		<td><input type="text" name="Input" id=Title style="WIDTH:100%" value="<c:out value = '${personalPopupVO.title}' />"></td>
			        	</tr>
			        	<tr class="secondary">
			          		<th><c:out value = '${langSecondary}' /></th>
			          		<td><input type="text" id=Title2 style="WIDTH:100%" value="<c:out value = '${personalPopupVO.title2}' />"></td>
			        	</tr>
			    	</table>
    			</td> 
  			</tr> 
  			<tr> 
    			<th><spring:message code = 'ezPersonal.t265' /></th> 
    			<td>
			        <input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"> ~
        			<input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly">
			     </td>    
  					<tr style="display:none"> 
    					<td>
    						<input id='_T1' class='datepicker_time' readonly> 
      						<IMG align="absmiddle" border="0" height="16" id="img_StartTime" src="/images/arr_right.gif" style="CURSOR: hand; POSITION: relative" width="16"> 
      						<input id='_T2' class='datepicker_time' readonly> 
      						<IMG align="absmiddle" border="0" height="16" id="img_EndTime" src="/images/arr_right.gif" style="CURSOR: hand; POSITION: relative" width="16"></td> 
  					</tr> 
  					<tr> 
    					<th><spring:message code = 'ezPersonal.t155' /></th> 
   						<td style="padding:3px; height:325px">
    						<iframe id="message" class="viewbox"  name="message" src="/ezEditor/selectEditor.do" style="padding:0px; height:100%; width:100%; overflow:auto;border:none; margin-bottom:-3px;"></iframe>
    					</td> 
  					</tr>
  				</td>
  			</tr>
		</table> 
		<div class="btnpositionNew"> 
		    <%-- <a class="imgbtn"><span onclick="html_edit()">HTML<spring:message code = 'ezPersonal.t156' /></span></a> --%>
		    <a class="imgbtn"><span onclick="OK_Click()"><spring:message code = 'ezPersonal.t12' /></span></a>
		</div>
		
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>