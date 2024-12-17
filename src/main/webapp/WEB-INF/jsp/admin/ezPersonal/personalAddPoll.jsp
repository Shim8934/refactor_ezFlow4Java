<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezPersonal.t214' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}"/>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}"/>
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
		<script type="text/javascript">
			var compid = "";
			var ReturnFunction;
			var RetValue;
			var itemSeq = "<c:out value = '${infoVO.itemSeq}' />";
			var startdate = "<c:out value = '${infoVO.startDate}' />";
			var enddate = "<c:out value = '${infoVO.endDate}' />";
			var Title = "<c:out value = '${infoVO.pollTitle}' />";
			var Title2 = "<c:out value = '${infoVO.pollTitle2}' />";
			var pollCount = "<c:out value = '${infoVO.pollSelectionCount}' />";
			var flag = "<c:out value='${flag}' />";
			var nowDate = new Date();

			window.onload = window_onload;
			function window_onload() {
				try {
					RetValue = parent.addpoll_cross_dialogArguments[0];
					ReturnFunction = parent.addpoll_cross_dialogArguments[1];
				} catch (e) {
					try {
						RetValue = opener.addpoll_cross_dialogArguments[0];
						ReturnFunction = opener.addpoll_cross_dialogArguments[1];
					} catch (e) {
						RetValue = window.dialogArguments;
					}
				}
				compid = RetValue;
				selectnum_change();

				try {
					var ua = navigator.userAgent;
					if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
						var input = document.getElementsByTagName("input");
						for (var i = 0; i < input.length; i++) {
							if (input[i].getAttribute("type") == "text")
							KeEventControl(input[i]);
						}
					}
				}
				catch (e)
				{ }

				if (startdate == "" && enddate == "") {
					document.getElementById("Sdatepicker").value = DateFormat(nowDate);
					document.getElementById("Edatepicker").value = DateFormat(nowDate);
				}
			}


 			$(function () {
 				if(flag === "add") {
					$("#Sdatepicker").datepicker({
						changeMonth: true,
						changeYear: true,
						autoSize: true,
						showOn: "both",
						buttonImage: "/images/ImgIcon/calendar-month.png",
						buttonImageOnly: true,
						minDate : 0,
						maxDate : new Date()
					});
	
					$("#Edatepicker").datepicker({
						changeMonth: true,
						changeYear: true,
						autoSize: true,
						showOn: "both",
						buttonImage: "/images/ImgIcon/calendar-month.png",
						buttonImageOnly: true,
						minDate : 0
					});
 				} else {
 					checkPollCount();
					$("#Sdatepicker").datepicker({
						changeMonth: true,
						changeYear: true,
						autoSize: true,
						showOn: "both",
						buttonImage: "/images/ImgIcon/calendar-month.png",
						buttonImageOnly: true,
						maxDate : new Date()
					});
	
					$("#Edatepicker").datepicker({
						changeMonth: true,
						changeYear: true,
						autoSize: true,
						showOn: "both",
						buttonImage: "/images/ImgIcon/calendar-month.png",
						buttonImageOnly: true
					});
				}

 				if(flag === "mod") {
 					modItemSet();
 				}
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


			var totalCount = 0;
			var checkPollCount = function() {
				$.ajax({
					type: "POST",
					dataType: "json",
					async: false,
					url: "/admin/ezPersonal/getPollItem.do",
					data: {itemseq: itemSeq},
					success: function(result) {
						totalCount = result["totalCount"];
					}
				});
			}


			var onUseVO;
			var getOnUsePoll = function() {
				$.ajax({
					type: "POST",
					dataType: "json",
					async: false,
					url: "/admin/ezPersonal/getOnUsePoll.do",
					data: {itemseq: itemSeq},
					success: function(result) {
						var onUse = result["progressFlag"];
						if(onUse === "OK") {
							onUseVO = result["progressVO"];	
						}
					}
				});
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


			var strToDate = function(str) {
				var y = str.substr(0,4),
					m = str.substr(5,2) -1,
					d = str.substr(8,2);
				return new Date(y,m,d);
			}

			function selectnum_change() {
				if(totalCount > 0) {
					// 설문 결과가 있을 경우
					document.getElementById("Title").disabled = true;
					document.getElementById("Title2").disabled = true;
					document.getElementById("selectnum").disabled = true;
					document.getElementsByTagName('select')[0].style.background = "#dddddd";

					for (var i=1; i<11; i++) {
						document.getElementById("answer" + i).disabled = true;
					}
				} else {
					var number = parseInt(selectnum.value);
					for (var i = 1; i < number + 1; i++) {
						document.getElementById("answer" + i).readOnly = false;
						document.getElementById("answer" + i).disabled = false;
					}
	
					for (var i=number+1; i<11; i++) {
						document.getElementById("answer" + i).disabled = true;
						document.getElementById("answer" + i).value = "";
					}
				}
			}


			function OK_Click() {
				if (specialChk(document.getElementById("Title").value) || specialChk(document.getElementById("Title2").value)) {
					alert("<spring:message code='ezResource.special'/>");
					return;
				}

				if (compid == "") {
					return;
				}

				if( document.getElementById("Title").value == "" ) {
					alert("<spring:message code = 'ezPersonal.t215'/>");
					document.getElementById("Title").focus();
					return;
				}

				if (get_length(document.getElementById("Title").value) > 500) {
					alert("<spring:message code = 'ezPersonal.t216'/>");
					return;
				}

				if (get_length(document.getElementById("Title2").value) > 500) {
					alert("<spring:message code = 'ezPersonal.t216'/>");
					return;
				}

				// Sdatepicker*Edatepicker check
				var Sdate = $('#Sdatepicker').datepicker('getDate');
				var Edate = $('#Edatepicker').datepicker('getDate');

				// startDate
				if (!Sdate) {
					alert("<spring:message code = 'ezPersonal.hyh7'/>");
					return;
				}

				var days = (Sdate - nowDate) / 86400000;
				if(flag === "add") {
					if(days<=-1) {
						alert("<spring:message code = 'ezPersonal.hyh8'/>");
						return;
					}
				}

				// endDate
				if (!Edate) {
					alert("<spring:message code = 'ezPersonal.hyh9'/>");
					return;
				}

				days = (Edate - Sdate) / 86400000
				if(days<0) {
					alert("<spring:message code = 'ezPersonal.hyh10'/>");
					return;
				}

				var tmpStartDateTime = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00:00:01";
				var tmpEndDateTime = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 23:59:59";

				for (var i=1; i<11; i++) {
					if ($("#answer"+i).val().length > 100) {
						alert("<spring:message code = 'ezPersonal.t217'/>");
						eval("answer" + i).focus();
						return;
					}

					if (specialChk(document.getElementById("answer" + i).value)) {
						alert("<spring:message code='ezResource.special' />");
						return;
					}
					
				}

				//2017-02-19
				//보기에 아무것도 넣지 않았을때, 보기를 입력해야 하도록 수정
				for (var i=1; i<parseInt(selectnum.value)+1; i++) {
					if (document.getElementById("answer" + i).value == "") {
						alert("<spring:message code = 'ezPersonal.jjs01'/>"+i+"<spring:message code = 'ezPersonal.jjs02'/>");
						return;
					}
				}

				if(flag !== "add") {
					if(totalCount == 0) {
						checkPollCount();
						if(totalCount>0) {
							alert("<spring:message code = 'ezPersonal.hyh11'/>");
							window.location.reload();
							return;
						}
					}
				}

				// 진행중인 설문의 종료시간 업데이트 여부 flag 
				var updateFlag= "yes";
				// 행중인 설문 종료할지 체크
				getOnUsePoll();
				if(onUseVO) {
					if(!(itemSeq == onUseVO.itemSeq)) {
						var tempSD = strToDate(onUseVO.startDate);
						var tempED = strToDate(onUseVO.endDate);

						if((Sdate<= tempSD) && (tempSD <= Edate)) {
							if(!confirm("<spring:message code = 'ezPersonal.hyh12'/>")) {
								return;
							};
						} else if((Sdate <= tempED) && (tempED <= Edate)) {
							if(!confirm("<spring:message code = 'ezPersonal.hyh12'/>")) {
								return;
							};
						} else if ((Edate < tempSD)) {
							updateFlag = "no";
						}
					}
				}

				var objRoot, objNode;
				var xmlDom = createXmlDom();
				var xmlHTTP = createXMLHttpRequest();
				createNodeInsert(xmlDom, objRoot, "DATA"); 
				createNodeAndInsertText(xmlDom, objNode, "COMPID", compid);
				createNodeAndInsertText(xmlDom, objNode, "TITLE", document.getElementById("Title").value);
				createNodeAndInsertText(xmlDom, objNode, "TITLE2", document.getElementById("Title2").value);
				createNodeAndInsertText(xmlDom, objNode, "STARTDATE", tmpStartDateTime);
				createNodeAndInsertText(xmlDom, objNode, "ENDDATE", tmpEndDateTime);
				createNodeAndInsertText(xmlDom, objNode, "NUM", document.getElementById("selectnum").value);
				createNodeAndInsertText(xmlDom, objNode, "ITEMSEQ", itemSeq);
				createNodeAndInsertText(xmlDom, objNode, "UPDATEFLAG", updateFlag);

				for (var i=1; i<11; i++) {
					createNodeAndInsertText(xmlDom, objNode, "ANSWER", eval("answer" + i).value);
				}

				xmlHTTP.open("POST", "/admin/ezPersonal/savePoll.do", false);
				xmlHTTP.send(xmlDom);

				if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK") {
					alert("<spring:message code = 'ezPersonal.t218' />");
				} else {
					if(flag === "add") {
						alert("<spring:message code = 'ezPersonal.t219' />");
					} else {
						alert("<spring:message code = 'ezPersonal.hyh13'/>");
					}

					if (ReturnFunction != null) {
						ReturnFunction("");
					} else {
						window.returnValue = "";
					}
					if(flag === "mod") {
						try{
							window.opener.showPreview(2, itemSeq);
						} catch(e) {
							window.close();
						}
					}
					window.close();
				}
			}

			function get_length(chkstr) {
				var length = 0;
				var i;
				
				for (i=0; i<chkstr.length; i++) {
					if (chkstr.charCodeAt(i) > 256) {
						length = length + 2;
					} else {
						length++;
					}
				}
				return length;
			}


			var answerArray;
 			function modItemSet() {
				var SDate;
				var EDate;
				if (startdate != "") {
					var startArr = startdate.split("-"); 
					SDate = new Date(startArr[0] + "/" + startArr[1] + "/" + startArr[2]);
					var endArr = enddate.split("-"); 
					EDate = new Date(endArr[0] + "/" + endArr[1] + "/" + endArr[2]);
					$( "#Sdatepicker").datepicker( "option", "disabled", true );
				} else {
					SDate = new Date();
					EDate = new Date();
				}

				$("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
				$("#Sdatepicker").datepicker('setDate', SDate);

				$("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
				$("#Edatepicker").datepicker('setDate', EDate);

				document.getElementById("Title").value = replaceEntityCodeToStr(Title);
				document.getElementById("Title2").value = replaceEntityCodeToStr(Title2);

				selectnum.value = pollCount;
				selectnum_change();
				answerArray = ["<c:out value = '${infoVO.answer1}' />", "<c:out value = '${infoVO.answer2}' />", "<c:out value = '${infoVO.answer3}' />",
									"<c:out value = '${infoVO.answer4}' />", "<c:out value = '${infoVO.answer5}' />", "<c:out value = '${infoVO.answer6}' />",
									"<c:out value = '${infoVO.answer7}' />", "<c:out value = '${infoVO.answer8}' />", "<c:out value = '${infoVO.answer9}' />",
									"<c:out value = '${infoVO.answer10}' />"]
				for (var i=1; i<=pollCount; i++) {
				    document.getElementById("answer" + i).value = answerArray[i-1];
				}
 			}
		</script>
	</head>
	<body class = "popup">
		<h1>
			<c:choose>
				<c:when test="${flag == 'add' }">
					<spring:message code = 'ezPersonal.t220' />
				</c:when>
				<c:otherwise>
					<spring:message code = 'ezPersonal.hyh6' />
				</c:otherwise>
			</c:choose>
		</h1>
		<div id="close">
			<ul>
				<li><span onclick="window.close()"></span></li>
			</ul>
		</div>
		<table class="content" style="margin-top:3px">
			<tr>
				<th><spring:message code = 'ezPersonal.t221' /></th>
				<td style="padding:0">
					<table width="100%">
						<tr class="primary">
							<th><c:out value = '${langPrimary}' /></th>
							<td><input type="text" name="Input" id=Title style="WIDTH:100%"></td>
						</tr>
						<tr class="secondary">
							<th><c:out value = '${langSecondary}' /></th>
							<td><input type="text" id=Title2 style="WIDTH:100%"></td>
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
			</tr> 
		  	<tr style="display:none"> 
				<td>
					<input id='_T1' class='datepicker_time' readonly> 
					<IMG align="absmiddle" border="0" height="16" id="img_StartTime" src="/images/arr_right.gif" style="CURSOR: hand; POSITION: relative" width="16"> 
					<input id='_T2' class='datepicker_time' readonly> 
					<IMG align="absmiddle" border="0" height="16" id="img_EndTime" src="/images/arr_right.gif" style="CURSOR: hand; POSITION: relative" width="16">
				</td> 
			</tr>
		  	<tr>
		    	<th><spring:message code = 'ezPersonal.t222' /></th>
		    	<td>
		    		<select id=selectnum onChange="selectnum_change()">
				        <option value=2>2<spring:message code = 'ezPersonal.t223' /></option>
				        <option selected value=3>3<spring:message code = 'ezPersonal.t223' /></option>
				        <option value=4>4<spring:message code = 'ezPersonal.t223' /></option>
				        <option value=5>5<spring:message code = 'ezPersonal.t223' /></option>
				        <option value=6>6<spring:message code = 'ezPersonal.t223' /></option>
				        <option value=7>7<spring:message code = 'ezPersonal.t223' /></option>
				        <option value=8>8<spring:message code = 'ezPersonal.t223' /></option>
				        <option value=9>9<spring:message code = 'ezPersonal.t223' /></option>
				        <option value=10>10<spring:message code = 'ezPersonal.t223' /></option>
		      		</select>
		      	</td>
			</tr> 
			<tr> 
		    	<th><spring:message code = 'ezPersonal.t224' /></th> 
		  		<td><input type="text" id=answer1 style="WIDTH: 100%"></td>
		  	</tr> 
		  	<tr> 
		    	<th><spring:message code = 'ezPersonal.t225' /></th> 
		  		<td><input type="text" id=answer2 style="WIDTH: 100%"></td>
		  	</tr> 
		  	<tr> 
		    	<th><spring:message code = 'ezPersonal.t226' /></th> 
		  		<td><input type="text" id=answer3 style="WIDTH: 100%"></td>
		  	</tr> 
		  	<tr> 
		    	<th><spring:message code = 'ezPersonal.t227' /></th> 
		  		<td><input type="text" id=answer4 style="WIDTH: 100%"></td>
		  	</tr> 
		  	<tr> 
		    	<th><spring:message code = 'ezPersonal.t228' /></th> 
		  		<td><input type="text" id=answer5 style="WIDTH: 100%"></td>
		  	</tr> 
		  	<tr> 
		    	<th><spring:message code = 'ezPersonal.t229' /></th> 
		  		<td><input type="text" id=answer6 style="WIDTH: 100%"></td>
		  	</tr> 
		  	<tr> 
		    	<th><spring:message code = 'ezPersonal.t230' /></th> 
		  		<td><input type="text" id=answer7 style="WIDTH: 100%"></td>
		  	</tr> 
		  	<tr> 
		    	<th><spring:message code = 'ezPersonal.t231' /></th> 
		  		<td><input type="text" id=answer8 style="WIDTH: 100%"></td>
		  	</tr> 
		  	<tr> 
		    	<th><spring:message code = 'ezPersonal.t232' /></th> 
		  		<td><input type="text" id=answer9 style="WIDTH: 100%"></td>
		   	</tr> 
		  	<tr> 
			    <th><spring:message code = 'ezPersonal.t233' /></th> 
		  		<td><input type="text" id=answer10 style="WIDTH: 100%"></td>
		  	</tr> 
		</table> 
		<div class="btnpositionNew"> 
		    <a class="imgbtn"><span onclick="OK_Click()"><spring:message code = 'ezPersonal.t12' /></span></a>
	    </div>
	</body>
</html>