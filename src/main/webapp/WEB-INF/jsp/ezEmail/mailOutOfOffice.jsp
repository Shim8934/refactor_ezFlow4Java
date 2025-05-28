<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title>mail_outofoffice</title>
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/composeappt.js')}"></script>
	    <!-- data picker-->
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}">
	    <!-- time picker-->
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" />
	    <script type="text/javascript">
	    	var offsetMin = "${offsetMin}";
		    var g_oofstate = "${gOofState}";
		    var g_startdate = "${gStartDate}";
		    var g_enddate = "${gEndDate}";
		    var g_externalaudience = "${gExternalAudience}";
		    var useOnlyInnerMail = "${useOnlyInnerMail}";
		    $(function () {
		        $("#Sdatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        $("#Edatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        var NowDate = utcDate2(offsetMin);
		        NowDate.setHours(NowDate.getHours() + 1);
		        var NowDate2 = utcDate2(offsetMin);
		        NowDate2.setHours(NowDate2.getHours() + 1);
		        //NowDate2.setMinutes(NowDate2.getMinutes() + 30);
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', NowDate);
		        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Edatepicker").datepicker('setDate', NowDate2);
		        $('#Stimepicker').timepicker();
		        $('#Stimepicker').timepicker('setTime', NowDate);
		        $('#Stimepicker').timepicker({
		            'timeFormat': 'H:i',
		            'disableTextInput': true
		        });
		        $('#Etimepicker').timepicker();
		        $('#Etimepicker').timepicker('setTime', NowDate2);
		        $('#Etimepicker').timepicker({
		            'timeFormat': 'H:i',
		            'disableTextInput': true
		        });
		        
		        //timepicker input 요소에 키보드 입력할 수 없도록 수정.
				$("#Etimepicker, #Stimepicker").on("focus", function(){
					$(this).trigger("blur");
				});
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
		    
	        document.onselectstart = function () { return false; };
	        window.onload = function () {
				if (useOnlyInnerMail == "YES") {
					$('#externalDiv').css('display', 'none');
					$('#externalTable').css('display', 'none');
				}
	        	
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        try {
		            if (g_externalaudience == "none") {
		                chkOut.checked = false;
		                document.getElementById("SetOut0").checked = true;
		            }
		            else if (g_externalaudience == "known") {
		                chkOut.checked = true;
		                document.getElementById("SetOut0").checked = true;
		            }
		            else {
		                chkOut.checked = true;
		                document.getElementById("SetOut1").defaultChecked = true;
		            }
		            try{
		                var StarDate = new Date(g_startdate.replace(/-/gi, "/"));
		                var EndDate = new Date(g_enddate.replace(/-/gi, "/"));
		                $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		                $("#Sdatepicker").datepicker('setDate', StarDate);
		                $('#Stimepicker').timepicker('setTime', StarDate);
		                $('#Stimepicker').timepicker({
		                    'timeFormat': 'H:i',
		                    'disableTextInput': true
		                });
		                 $("#Stimepicker").on("focus", function(){
							$(this).trigger("blur");
						});
						
		                $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		                $("#Edatepicker").datepicker('setDate', EndDate);
		                $('#Etimepicker').timepicker('setTime', EndDate);
		                $('#Etimepicker').timepicker({
		                    'timeFormat': 'H:i',
		                    'disableTextInput': true
		                });
		                 $("#Etimepicker").on("focus", function(){
							$(this).trigger("blur");
						});
		            } catch (e) {console.log(e);}
		          
		            if (g_oofstate == "disabled") {
		                document.getElementById("SetRadio0").defaultChecked = true;
		                document.getElementById("chkDate").defaultChecked = false;
		                SetToggle("0");
		            }
		            else if (g_oofstate == "scheduled") {
		                document.getElementById("SetRadio1").defaultChecked = true;
		                document.getElementById("chkDate").defaultChecked = true;
		                SetToggle("1");
		            }
		            else {
		                document.getElementById("SetRadio1").defaultChecked = true;
		                document.getElementById("chkDate").defaultChecked = false;
		
		                SetToggle("1");
		            }
		            //tbContentElement1.SetEditorContent("<span>" + document.getElementById("BujaeBody1").innerHTML + "</span>");
		            //tbContentElement2.SetEditorContent("<span>" + document.getElementById("BujaeBody2").innerHTML + "</span>");
		                        
		        }
		        catch (e) {
		            alert(e.message);
		        }
		    }
		    function Editor_Complete() {
		    	try {
		        	if (tbContentElement1.editorLoadFlag) {
			            tbContentElement1.SetEditorContent(document.getElementById("BujaeBody1").innerHTML);
		        	}
		        } catch (e) {console.log(e);}
		        
		        try {
		        	if (tbContentElement2.editorLoadFlag) {
			            tbContentElement2.SetEditorContent(document.getElementById("BujaeBody2").innerHTML);
		        	}
		        } catch (e) {console.log(e);}
		        
		        try {document.body.scrollTop = 0;} catch (e) {console.log(e);}
		    }
		    function SetToggle(param) {
		        document.getElementById("Stimepicker").disabled = true;
		        $("#Sdatepicker").datepicker('disable');
		        document.getElementById("Etimepicker").disabled = true;
		        $("#Edatepicker").datepicker('disable');
		        if (param == "0") {
		            chkDate.disabled = true;
		            chkOut.disabled = true;
		            document.getElementById("SetOut0").disabled = true;
		            document.getElementById("SetOut1").disabled = true;
		            document.getElementById("SetRadio1").checked = false;
		        }
		        else {
		
		            chkDate.disabled = false;
		            CheckDate();
		            chkOut.disabled = false;
		            CheckOut();
		            document.getElementById("SetRadio0").checked = false;
		        }
		    }
		    function CheckDate() {
		        if (document.getElementById("chkDate").checked) {
		            document.getElementById("Stimepicker").disabled = false;
		            $("#Sdatepicker").datepicker('enable');
		            document.getElementById("Etimepicker").disabled = false;
		            $("#Edatepicker").datepicker('enable');
		        }
		        else {
		            document.getElementById("Stimepicker").disabled = true;
		            $("#Sdatepicker").datepicker('disable');
		            document.getElementById("Etimepicker").disabled = true;
		            $("#Edatepicker").datepicker('disable');
		        }
		    }
		
		    function CheckOut(pObj) {
		        if (document.getElementById("chkOut").checked) {
		            document.getElementById("SetOut0").disabled = false;
		            document.getElementById("SetOut1").disabled = false;
		        }
		        else {
		            document.getElementById("SetOut0").disabled = true;
		            document.getElementById("SetOut1").disabled = true;
		
		        }
		    }
		    function BujaeTextFontCheck(BujaeText) {
		        var Div = document.createElement("DIV");
		        Div.innerHTML = BujaeText;
		    }
		    function Save() {
		        var pstartdate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val();
		        var penddate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Etimepicker').val();
		
		        var dateStart = new Date(pstartdate.substring(0, 4), (pstartdate.substring(5, 7) - 1), pstartdate.substring(8, 10), pstartdate.substring(11, 13), pstartdate.substring(14, 16), 0, 0);
		        var dateEnd = new Date(penddate.substring(0, 4), (penddate.substring(5, 7) - 1), penddate.substring(8, 10), penddate.substring(11, 13), penddate.substring(14, 16), 0, 0);
		        var now = utcDate2(offsetMin);
		
		        var poofstate = "disabled";
		        if (document.getElementById("SetRadio0").checked == true)
		            poofstate = "disabled";
		        else if (document.getElementById("SetRadio1").checked == true && chkDate.checked == true)
		            poofstate = "scheduled";
		        else if (document.getElementById("SetRadio1").checked == true && chkDate.checked == false)
		            poofstate = "enabled";
				
		        if (poofstate == "scheduled") {
		        	if (dateStart.toString() == dateEnd.toString()) {
		        		alert("<spring:message code='ezPersonal.pjj1' />");
			            return;
		        	} else if (dateStart < now) {
			            alert("<spring:message code='ezEmail.t99000036' />");
			            return;
			        }
			        else if (dateStart > dateEnd || dateEnd < now) {
			            alert("<spring:message code='ezEmail.t99000037' />");
			            return;
			        }
		        }
		        
		        var pexternalaudience = "none";
		        if (chkOut.checked == false)
		            pexternalaudience = "none"
		        else if (chkOut.checked == true && document.getElementById("SetOut0").checked == true)
		            pexternalaudience = "known"
		        else if (chkOut.checked == true && document.getElementById("SetOut1").checked == true)
		            pexternalaudience = "all"
		
		        var BujaeText1 = tbContentElement1.GetEditorContent();
		        var BujaeText2 = tbContentElement2.GetEditorContent();
		        BujaeTextFontCheck(BujaeText1);
		        
		        // 재은 수정
		        //if (document.getElementById("chkOut").checked == false) {
		        	if (BujaeText2 == "" || BujaeText2 == null) {
		        		BujaeText2 = "<p></p>"; // 기본으로 넣어주기
		        		//BujaeText2 = "<p style='font-family: 굴림; font-size: 13px;'> </p>";
		        		
		        	}
		        //}
		
		
		        var xmlHTTP = createXMLHttpRequest();
		        var xmlDom = createXmlDom();
		
		        var objNode;
		        createNodeInsert(xmlDom, objNode, "DATA");
		        createNodeAndInsertText(xmlDom, objNode, "OOFSTATE", poofstate);
		        createNodeAndInsertText(xmlDom, objNode, "STARTDATE", pstartdate);
		        createNodeAndInsertText(xmlDom, objNode, "ENDDATE", penddate);
		        createNodeAndInsertText(xmlDom, objNode, "INTERNAL", BujaeText1);
		        createNodeAndInsertText(xmlDom, objNode, "EXTERNAL", BujaeText2);
		        createNodeAndInsertText(xmlDom, objNode, "EXTERNALAUDIENCE", pexternalaudience);
		
		
		        xmlHTTP.open("POST", "/ezEmail/mailOutOfOfficeSave.do", false);
		        xmlHTTP.send(xmlDom);
		
		        if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK")
		            alert("<spring:message code='ezEmail.t201' />");
		        else
		            alert("<spring:message code='ezEmail.t202' />");
		
		        xmlHTTP = null;
		        xmlDom = null;
		    }
		    function ReplaceText(orgStr, findStr, replaceStr) {
		        var re = new RegExp(findStr, "gi");
		        return (orgStr.replace(re, replaceStr));
		    }
		    function Cancel_Click() {
		        window.location.reload(true);
		    }
		    
		    function selectOOOTemplate(selectObj) {
		    	var objVal = selectObj.value;
		    	var tbContentElement = selectObj.dataset.ele;
		    	var editorIframe = document.getElementById(tbContentElement).contentWindow;
		    	
		    	var content = " ";
		    	if (objVal === undefined) {
		    		return;
		    	} else if (objVal == "none") {
		    		editorIframe.SetEditorContent(content);
		    	} else {
		    		$.ajax({
		        		type : "POST",
		        		url : "/ezEmail/getMailOutOfOfficeTemplate.do",
		        		datatype : 'json',
		        		data : {"displayName" : objVal},
		        		error : function(data) {
		        			alert("error.");
		        		}, success : function(data) {
		        			editorIframe.SetEditorContent(data.content);
		        	    }
		        	});
		    	}
		    }
		</script>
	</head>
	<body style="margin-left:10px;margin-right:10px;">	
	<br>
	<span class="txt">▒ <spring:message code='ezEmail.t204' /><br>
	▒ <spring:message code='ezEmail.t205' /></span>
	<table style="width:768px;margin-top:5px;" class="box">
	  <tr>
	    <td style="padding:5px">
	       <input name="SetRadio0" type="radio" onclick="SetToggle('0')" id = "SetRadio0" style="height: 13px !important; margin-top: 4px !important">
	      <spring:message code='ezEmail.t206' /><br>
	       <input name="SetRadio1" type="radio" onclick="SetToggle('1')" id = "SetRadio1" style="height: 13px !important; margin-top: 4px !important">
	      <spring:message code='ezEmail.t207' /><br>
	       <input type="checkbox" name="chkDate" value="checkbox" onclick="CheckDate()" id = "chkDate" style="height: 13px !important; margin-top: 4px !important">
	      <spring:message code='ezEmail.t208' /></td>
	  </tr>
	</table>
	<table class="content" style="width:768px;margin-top:5px;">
	  <tr>
	    <th><spring:message code='ezEmail.t209' /></th>
	    <td>
	        <input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"><input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;"/>
	     </td>
	  </tr>
	  <tr>
	    <th><spring:message code='ezEmail.t217' /></th>
	    <td>
	        <input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly"><input id="Etimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;"/>
	    </td>
	  </tr>
	</table>
	<div style="width:768px; height:30px; line-height:35px;">
		<div style="float:right; margin-right:5px;">
	    	<span><b><spring:message code='ezEmail.jje16'/> : </b></span>
	    	<select id="signatureSelect" onchange="selectOOOTemplate(this)" style="width:255px;" data-ele="tbContentElement1">
	    		<option value="none"><spring:message code='ezEmail.jje15'/></option>
        		<c:forEach var="item" items="${templateList}">
        			<option value="<c:out value='${item.displayName}'/>"><c:out value='${item.displayName}'/></option>
           		</c:forEach>
	    	</select>
	    </div>
	</div>
	<div class="nobox" style="width:768px; height:500px;margin-top:5px;">
		<iframe id="tbContentElement1" class="viewbox" src="/ezEditor/selectEditor.do?type=MAILOUTOFOFFICE" name="tbContentElement1" style="padding:0; height:500px; width:100%; overflow:auto;"></iframe>
	</div>
	<table id="externalTable" style="width:768px; margin-top:10px;" class="box">
	  <tr>
	    <td style="padding:5px">
		  <input type="checkbox" name="chkOut" onclick="CheckOut()" id="chkOut" style="height: 12px !important;">
	      <spring:message code='ezEmail.t218' /><br>
	      <input name="SetOut" type="radio" id="SetOut0" style="height: 12px !important;">
	      <spring:message code='ezEmail.t219' /><br>
	      <input name="SetOut" type="radio" id="SetOut1" style="height: 12px !important;">
	      <spring:message code='ezEmail.t220' /></td>
	  </tr>
	</table>
	<div style="width:768px; height:30px; line-height:35px;">
		<div style="float:right; margin-right:5px;">
	    	<span><b><spring:message code='ezEmail.jje16'/> : </b></span>
	    	<select id="signatureSelect" onchange="selectOOOTemplate(this)" style="width:255px;" data-ele="tbContentElement2">
	    		<option value="none"><spring:message code='ezEmail.jje15'/></option>
        		<c:forEach var="item" items="${templateList}">
        			<option value="<c:out value='${item.displayName}'/>"><c:out value='${item.displayName}'/></option>
           		</c:forEach>
	    	</select>
	    </div>
	</div>
	<div id="externalDiv" class="nobox" style="width:768px; height:500px;margin-top:5px;">
		<iframe id="tbContentElement2" class="viewbox" src="/ezEditor/selectEditor.do?type=MAILOUTOFOFFICE" name="tbContentElement2" style="padding:0; height:500px; width:100%; overflow:auto;"></iframe>
	</div> 
	<div style="width:735px;text-align:center;">
		<div class="btnpositionJsp">
	    	<a class="imgbtn" onClick="Save()"><span><spring:message code='main.sp09' /></span></a>
	    	<a class="imgbtn" onClick="Cancel_Click()"><span><spring:message code='ezEmail.t39' /></span></a>
	    </div>	
	</div>
	<XMP id="BujaeBody1" style="DISPLAY: none">${gInternal}</XMP> 
	<XMP id="BujaeBody2" style="DISPLAY: none">${gExternal}</XMP> 
	</body>
</html>



