<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezPersonal.t250' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/font-awesome-5.0.10/css/fontawesome-all.css')}">
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
		<link rel="stylesheet" href="${util.addVer('ezNewPortal.e2', 'msg')}">
		
		<script type="text/javascript">
			var compid = "<c:out value = '${companyID}' />";
			var itemseq = "<c:out value = '${personalPopupVO.itemSeq}' />";
			var startdate = "<c:out value = '${personalPopupVO.startDate}' />";
			var enddate = "<c:out value = '${personalPopupVO.endDate}' />";
			var flag = "<c:out value = '${flag}' />";
			var MHTLoadComplete="";
			var initdate = "<c:out value = '${initDate}' />";
			var skinValue = "<c:out value = '${personalPopupVO.skinValue}' />";
			
			/* 팝업공지 대상자 지정 */
	        var authList = [];
	        
	        window.onload = window_onload;
	        function window_onload() {
	            //compid = window.dialogArguments;
				// 2020-12-04 이혁진 팝업공지사항 이미지 삽입 하단 버튼 클릭 불가 수정하기위해 팝업 사이즈 재조정
				window.resizeTo (750,860);
	            if (startdate == "" && enddate == "") {
	                var nowDate = new Date();
	                document.getElementById("Sdatepicker").value = DateFormat(nowDate);
	    	        document.getElementById("Edatepicker").value = DateFormat(nowDate);
	            }
	            
	            if (startdate != "") {
	            }
	            
	            var wPosition = "<c:out value = '${personalPopupVO.position}' />";

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
				
				setUserList();
				eventSetting();
			}
	        
			/* window.onresize = function () {
				document.getElementById("addPopEditor").style.height = document.documentElement.clientHeight - 293 + "PX";
			} */

			$(function () {
				$("#Sdatepicker").datepicker({
					changeMonth: true,
					changeYear: true,
					autoSize: true,
					showOn: "both",
					buttonImage: "/images/ImgIcon/calendar-month.png",
					buttonImageOnly: true,
					minDate : 0
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

				var SDate;
				var EDate;
				if (startdate != "") {
					var startArr = startdate.split("-"); 
					SDate = new Date(startArr[0] + "/" + startArr[1] + "/" + startArr[2]);
					var endArr = enddate.split("-"); 
					EDate = new Date(endArr[0] + "/" + endArr[1] + "/" + endArr[2]);
				} else {
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
				setSkinVal();
			});


			var setSkinVal = function() {
				var doc = window.document;
				var skinObjs = doc.getElementsByClassName('skins');
				for(var i=0; i<4; i++) {
					skinObjs[i].classList.add('unchecked');
					skinObjs[i].addEventListener('click', addSkinEvent);
					//skinObjs[i].addEventListener('dblclick', addSkinDblEvent);
				}

				if(flag === "mod") {
					var skinDom = doc.getElementById('skin' + skinValue);
					skinDom.classList.remove('unchecked');	
					skinDom.classList.add('checked');
					var isDefaultDiv = doc.createElement("div");
					var isDefaultImg = doc.createElement("img");
					
					isDefaultDiv.className = "isDefault";
					isDefaultImg.src = "/images/admin/themeDefault.png";
					
					isDefaultDiv.appendChild(isDefaultImg);
					
					skinDom.appendChild(isDefaultDiv);
				} else {
					skinObjs[0].classList.remove("unchecked");
					skinObjs[0].classList.add("checked");
					
					var isDefaultDiv = doc.createElement("div");
					var isDefaultImg = doc.createElement("img");
					
					isDefaultDiv.className = "isDefault";
					isDefaultImg.src = "/images/admin/themeDefault.png";
					
					isDefaultDiv.appendChild(isDefaultImg);
					
					var firstSkin = skinObjs[0].id;
					
					document.getElementById(firstSkin).appendChild(isDefaultDiv);
				}
			}


			var addSkinEvent = function() {
				var doc = window.document;
				var skinDom = doc.getElementById('skin' + skinValue);
				skinDom.classList.remove('checked');
				skinDom.classList.add('unchecked');
				var isDefault = skinDom.getElementsByClassName("isDefault");
				console.log(isDefault[0]);
				skinDom.removeChild(isDefault[0]);
				skinValue = this.id.substring(4);

				skinDom = doc.getElementById('skin' + skinValue);
				skinDom.classList.remove('unchecked');
				skinDom.classList.add('checked');

				var isDefaultDiv = doc.createElement("div");
				var isDefaultImg = doc.createElement("img");
				
				isDefaultDiv.className = "isDefault";
				isDefaultImg.src = "/images/admin/themeDefault.png";
				
				isDefaultDiv.appendChild(isDefaultImg);
				
				skinDom.appendChild(isDefaultDiv);
			}


			var addSkinDblEvent = function(obj) {
				if(document.getElementById("skinPopup")) {
					document.getElementById("skinPopup").remove();
				}

				var skinId       = this.id.substring(4);
				var content      = document.getElementsByClassName("content")[0];
				var skinDiv      = document.createElement("div");
				var skinDivTop   = document.createElement("div");
				var skinCloseBtn = document.createElement("i");
				var skinPopImg   = document.createElement("img");

				skinDiv.className = "skinPopup";
				skinDivTop.className = "skinDivTop";
				skinPopImg.className = "skinPopImg";
				skinCloseBtn.className = "fa fa-times-circle skinCloseBtn";

				skinDiv.setAttribute("id", "skinPopup");
				skinCloseBtn.addEventListener("click", closeSkinEvent);

				switch (skinId) {
					case "0" : skinPopImg.setAttribute("src", "/images/ezNewPortal/Theme1.JPG"); break;
					case "1" : skinPopImg.setAttribute("src", "/images/ezNewPortal/Theme2.JPG"); break;
					case "2" : skinPopImg.setAttribute("src", "/images/ezNewPortal/Theme3.JPG"); break;
					case "3" : skinPopImg.setAttribute("src", "/images/ezNewPortal/Theme3.JPG"); break;
				}

				skinDivTop.appendChild(skinCloseBtn);
				skinDiv.appendChild(skinDivTop);
				skinDiv.appendChild(skinPopImg);
				content.appendChild(skinDiv);
			}


			function closeSkinEvent() {
				var skinDiv = document.getElementById("skinPopup");
				while (skinDiv.firstChild) {
					skinDiv.removeChild(skinDiv.firstChild);
				}
				skinDiv.parentNode.removeChild(skinDiv);
			}


			function DateFormat(obj) {
				var yy = String(obj.getFullYear()).substring(0, 4);
				if (String(obj.getMonth() + 1).length == 1) {
					var mm = "0" + (obj.getMonth() + 1);
				} else {
					var mm = obj.getMonth() + 1;
				}

				if (String(obj.getDate()).length == 1) {
					var dd = "0" + obj.getDate();
				} else {
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

				if (parseInt(document.getElementById("wWidth").value, 10) != document.getElementById("wWidth").value) {
					alert("<spring:message code = 'ezPersonal.t251' />");
					return;
				}

				if (parseInt(document.getElementById("wHeight").value, 10) != document.getElementById("wHeight").value) {
					alert("<spring:message code = 'ezPersonal.t252' />");
					return;
				}

				if (parseInt(document.getElementById("wWidth").value, 10) > 1000) {
					alert("<spring:message code = 'ezPersonal.t253' />");
					return;
				}

				if (parseInt(document.getElementById("wHeight").value, 10) > 800) {
					alert("<spring:message code = 'ezPersonal.t254' />");
					return;
				}

				if (parseInt(document.getElementById("wWidth").value, 10) < 100) {
					alert("<spring:message code = 'ezAdmin.jjh01' />");
					return;
				}

				if (parseInt(document.getElementById("wHeight").value, 10) < 250) {
					alert("<spring:message code = 'ezAdmin.jjh02' />");
					return;
				}

				if (document.getElementById("Title").value == "") {
					alert("<spring:message code = 'ezPersonal.t148' />");
					return;
				}

				if (document.getElementById("Title2").value == "") {
					alert("<spring:message code = 'ezPersonal.t148' />");
					return;
				}

				if (get_length(document.getElementById("Title").value, 10) > 250) {
					alert("<spring:message code = 'ezPersonal.t149' />");
					document.getElementById("Title").focus();
					return;
				}

				if (get_length(document.getElementById("Title2").value, 10) > 250) {
					alert("<spring:message code = 'ezPersonal.t149' />");
					document.getElementById("Title2").focus();
					return;
				}

				var tmpStartDateTime = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00:00:01";
				var tmpEndDateTime = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 23:59:59";

				if (tmpStartDateTime > tmpEndDateTime) {
					alert("<spring:message code='ezResource.dateChk' />");
					return;
				}

				if($(".skins").hasClass("checked") === false) {
					alert("<spring:message code = 'ezPersonal.hyh15' />");
					return;
				}
				
				if (authList == null || authList.length < 1) {
					alert("<spring:message code= 'ezPersonal.yej02'/>");
					return;
				}
				
				if (typeof authList == "string") {
					authList = JSON.parse(authList);
				}
				
				var data = JSON.stringify({
					companyID : compid,
					itemSeq : itemseq,
					title : Title.value,
					title2 : Title2.value,
					startDate : tmpStartDateTime,
					endDate : tmpEndDateTime,
					width : wWidth.value,
					height : wHeight.value,
					position : document.getElementById("selectPos").value,
					content : message.GetEditorContent(),
					skinValue : skinValue,
					authList : authList
				});
				
				$.ajax({
					type : "POST",
					url : "/admin/ezPersonal/savePopup.do",
					async : false,
					data : data,
					contentType : "application/json",
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

							try {
								window.opener.changeCompany();
								if(flag === "mod") {
									// 수정사항 반영
									window.opener.showPreview(2, itemseq);
								}
							} catch(e) {
								window.close();
							}
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
				<%--message.SetEditorContent("${personalPopupVO.content}");--%>
				message.SetEditorContent(sigBody.innerHTML);
			}
			
	        var eventSetting = function() {
	        	var setAuth = document.getElementById("setAuth");
	        	setAuth.addEventListener("click", openPopupAuth);
	        }
			
	        var openPopupAuth = function() {
	    		var companyId = window.opener.$("#ListCompany option:selected").val();
	    		var feature = "dialogHeight:670px; dialogWidth:970px; scroll:no;status:no; help:no; edge:sunken";
	    		feature = feature + GetShowModalPosition(970, 670);
	    		
	    		if (CrossYN()) {
	    			var OpenWin = window.open("/admin/ezPersonal/personalPopupUser.do?companyId="
	    					+ companyId, "", GetOpenWindowfeature(970, 670));
	    			try {
	    				OpenWin.focus();
	    			} catch (e) {
	    			}
	    		} else {
	    			var rtnValue = window.showModalDialog("/admin/ezPersonal/personalPopupUser.do",
	    					companyId, feature);
	    		}
	        }
	        
	        var setUserList = function() {
	        	var url = "/admin/ezPersonal/personalPopupGetUserList?itemSeq=" + itemseq + "&companyId=" + compid;
	        	var request = new XMLHttpRequest(); 
	        	request.open('GET', url, true);
				request.setRequestHeader('content-type', 'application/json');

	        	request.onload = function() {
	        	  if (this.status >= 200 && this.status < 400) {
	        	    // Success!
	        	    var result = JSON.parse(request.responseText);
	        	    var status = result.status;
	        	    
	        	    if (status == "ok") {
	        	    	var userList = result.userList;
	        	    	var userListLength = userList.length;
	        	    	authList = userList;
	        	    	var userListText = "";
	        	    	
	        	    	for (var i = 0; i < userListLength; i++) {
	        	    		userListText += ", " + userList[i].userName;
	        	    	}
	        	    	
	        	    	document.getElementById("authList_div").textContent = userListText.substring(1);
	        	    }
	        	    
	        	  } else {
	        	    // We reached our target server, but it returned an error

	        	  }
	        	};

	        	request.onerror = function() {
	        	  // There was a connection error of some sort
	        	};

	        	request.send();
	        }
	        
		    /* 2020-08-06 홍승비 - 숫자 이외의 값 입력 방지 함수 */
		    function KeEventControl(obj) {
	            if ((window.event.keyCode >= 48 && window.event.keyCode <= 57) || (window.event.keyCode >= 96 && window.event.keyCode <= 105)) {
	                return true;
	            }
	            else {
	            	obj.value = obj.value.replace(/[\a-zㄱ-ㅎㅏ-ㅣ가-힣]/g, '');
	            }
	        }
		    
		</script>
		<style type="text/css">
			.popup_setting {display : inline-block; margin-top:3px; margin-right:3px;}
			#wWidth, #wHeight {vertical-align : initial;width:50px;height:22px;margin-right:20px;}
			#selectPos {vertical-align:initial; min-height:22px;}
			.skinImages {}
			.bg01 {background : url(/images/admin/popup_bg01.png) #0078fe top right no-repeat;}
			.bg02 {background : url(/images/admin/popup_bg02.png) #ffb4b4 top right no-repeat;}
			.bg03 {background : url(/images/admin/popup_bg03.png) #ffd161 top right no-repeat;}
			.bg04 {background : url(/images/admin/popup_bg04.png) #CCC top right no-repeat;}
			#authList_td {height : 35px;}
			#authList_div {height:100%; overflow:auto;}
		</style>
	</head>
	<body class = "popup">
<%--		<xmp id="sigBody" style="display:none;"><c:out value = '${personalPopupVO.content}' /></xmp>--%>
		<xmp id="sigBody" style="display:none;">${personalPopupVO.content}</xmp>
		<h1><spring:message code = 'ezPersonal.t258' /></h1>
		<div id="close">
			<ul>
				<li><span onclick="window.close()"></span></li>
			</ul>
		</div>
		<table class="content">
			<tr> 
				<th><spring:message code = 'ezPersonal.t262' /></th>
				<td>
					<span class="popup_setting"><spring:message code = 'ezPersonal.t263' /></span>
					<input type="text" id=wWidth value="<c:out value = '${personalPopupVO.width}' />" onkeypress="return KeEventControl(this);" onkeydown="return KeEventControl(this);" onkeyup="return KeEventControl(this);"> <span class="popup_setting"><spring:message code = 'ezPersonal.t264' /></span>
					<input type="text" id=wHeight value="<c:out value = '${personalPopupVO.height}' />" onkeypress="return KeEventControl(this);" onkeydown="return KeEventControl(this);" onkeyup="return KeEventControl(this);"> <span class="popup_setting"><spring:message code = 'ezPersonal.tt9' /></span>
					<select id="selectPos"> 
						<option value="0"><spring:message code = 'ezPersonal.tt2' /></option>
						<option value="5"><spring:message code = 'ezPersonal.tt3' /></option>
						<option value="6"><spring:message code = 'ezPersonal.tt4' /></option>
						<option value="1"><spring:message code = 'ezPersonal.tt5' /></option>
						<option value="2"><spring:message code = 'ezPersonal.tt6' /></option>
						<option value="3"><spring:message code = 'ezPersonal.tt7' /></option>
						<option value="4"><spring:message code = 'ezPersonal.tt8' /></option>
					</select>
				</td> 
			</tr>
			<tr>
				<th><spring:message code = 'ezPersonal.t265' /></th>
				<td>
					<input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"> ~
					<input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly">
				</td>
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
			<tr style="display:none">
				<td>
					<input id='_T1' class='datepicker_time' readonly>
					<IMG align="absmiddle" border="0" height="16" id="img_StartTime" src="/images/arr_right.gif" style="CURSOR: hand; POSITION: relative" width="16">
					<input id='_T2' class='datepicker_time' readonly>
					<IMG align="absmiddle" border="0" height="16" id="img_EndTime" src="/images/arr_right.gif" style="CURSOR: hand; POSITION: relative" width="16">
				</td>
			</tr> 
			<tr> 
				<th>
					<a class="imgbtn" style="user-select: auto;">
						<span id="setAuth" style="width: 48px; text-align: center; user-select: auto;"><spring:message code="ezPersonal.yej03"/></span>
					</a>
				</th>
				<td id="authList_td"><div id="authList_div">&nbsp;</div></td> 
			</tr>
			<tr>
				<th><spring:message code = 'ezPersonal.hyh16' /></th>
				<td id="skinView" style="padding:3px; height:40px">
					<ul class="skinList" id ="skinList">
						<li>
							<div class="skins" id="skin0">
								<div class="skinImg">
									<span class="skinImages bg01"></span>
								</div>
							</div>	
						</li>
						<li>
							<div class="skins" id="skin1">
								<div class="skinImg">
									<span class="skinImages bg02"></span>
								</div>
							</div>
						</li>
						<li>
							<div class="skins" id="skin2">
								<div class="skinImg">
									<span class="skinImages bg03"></span>
								</div>
							</div>
						</li>
						<li>
							<div class="skins" id="skin3">
								<div class="skinImg">
									<span class="skinImages bg04"></span>
								</div>
							</div>
						</li>
					</ul>
				</td>
			</tr>
			<tr>
				<th><spring:message code = 'ezPersonal.t155' /></th>
				<!-- 2020-12-07 이혁진 팝업공지사항 이미지 삽입 하단 버튼 클릭 불가 수정하기위해 에디터 사이즈 재조정 -->
				<td id="addPopEditor" style="padding:3px; height:450px">
					<iframe id="message" class="viewbox"  name="message" src="/ezEditor/selectEditor.do" style="padding:0px; height:100%; width:100%; overflow:auto;border:none; margin-bottom:-3px;"></iframe>
				</td>
			</tr>
		</table>
		<div class="btnpositionNew">
			<a class="imgbtn"><span onclick="OK_Click()"><spring:message code = 'ezPersonal.t12' /></span></a>
		</div>

		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>