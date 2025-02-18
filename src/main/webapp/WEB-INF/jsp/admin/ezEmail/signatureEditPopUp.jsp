<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title></title>
	    <link rel="stylesheet" href="${util.addVer('/css/ezEmail/style.css')}" />		
	    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script  type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	</head>
	<style>
		.inputInfoBtn {
		    float: left;
		    position: relative;
		    left: 43%;
		}
	</style>
	<script>
		var type = "${type}"
		var signNo = "${signNo}";
		var displayname = "";
		var displayname2 = "";
		var defaultFontAndSize = "${defaultFontAndSize}";
		var editor = "${editor}";
		var m_strColorSelect = "#edf4fd";
		var m_strColorOver = "#f4f5f5";
		var m_strColorDefault = "#ffffff";
		var m_strColorOpened = "#fafafa";
		var companyId = "${companyId}";
		
		window.onload = function() {
			$("#tbContentElement").attr("src", "/ezEditor/selectEditor.do?type=SIGNATURETEMPLATE");
			var titleTxt = "<spring:message code='ezBoard.t602'/>";
			
			if (type == "modify") {
				titleTxt = "<spring:message code='ezQuestion.t480'/>";
			} 
			
			document.title = titleTxt + " <spring:message code='ezEmail.ls012'/> ";
			$(".leTitle")[0].innerText = titleTxt + " <spring:message code='ezEmail.ls012'/>";
			
			
			// 입력정보 클릭, mouse over 이벤트 추가
			// 입력정보 리스트 기준은 (조직도>사원추가>우편번호, 집주소 빼고 전부)
			inputInfoListEvent();
		}
		
		function applyInfo() {
			var selected = $("#inputInfoBody tr[selected=true]")[0];
			
			if (selected != undefined) {
				var selectedId = selected.getAttribute("infoId");
				window.message.setCursorAtText("$" + "{" + selectedId + "}");
			}
			
		}
		
		function inputInfoListEvent() {
			var infoBody = document.getElementById("inputInfoBody");
			var infoBodyChild = infoBody.children;
			
			for (var i = 0; i < infoBodyChild.length; i++) {
				infoBodyChild[i].onclick = function() { event_listclick(this); };
				infoBodyChild[i].onmouseover = function() { 
					event_listMover(this); 
					
					if (editor == "TAGFREE") {
						window.message.xfe.saveRange();
					}
					
				};
				infoBodyChild[i].onmouseout = function() { event_listMout(this); };
				infoBodyChild[i].ondblclick = function() { applyInfo(); };
			}
		}
		
		function event_listclick(obj) {
			var prevSelected = $("#inputInfoBody tr[selected=true]")[0];
        	if (prevSelected != undefined) {
        		prevSelected.childNodes[1].style.backgroundColor = m_strColorDefault;
	        	prevSelected.setAttribute("selected", "false");
        	}
        	
			obj.childNodes[1].style.backgroundColor = m_strColorSelect;
        	obj.setAttribute("selected", "true");
        	
        	changeInfoTarget(obj);
		}
		
		function changeInfoTarget(obj) {
			document.getElementById("infoIdTarget").innerHTML = obj.getAttribute("infoid");
			document.getElementById("infoContentTarget").innerHTML = obj.getAttribute("infocontent");
		}
		
		function event_listMover(obj) {
        	if (obj.getAttribute("selected") != "true") {
        		obj.childNodes[1].style.backgroundColor = m_strColorOver;
        	}
        	
        }
        
        function event_listMout(obj) {
        	if (obj.getAttribute("selected") != "true") {
        		obj.childNodes[1].style.backgroundColor = m_strColorDefault;
        	}
        }
		
		
		function saveSignTemplate() {
			displayname = document.getElementById("displayname").value;
			displayname2 = document.getElementById("displayname2").value;
			content = window.message.GetEditorContent();
			
			var disName1Chk = strChk(displayname);
			var disName2Chk = false;
			
			if (disName1Chk) {
				disName2Chk = strChk(displayname2);
			} else {
				return;
			} 
			
			if (disName1Chk && disName2Chk) {
				var url = "/admin/ezEmail/setSignatureTemplate.do";
				var params = "displayname=" + encodeURIComponent(displayname) + "&displayname2=" + encodeURIComponent(displayname2) + "&content=" + encodeURIComponent(content);
				
				if (type == "modify") {
				    params += "&signNo=" + signNo + "&type=" + type;
				} else {
				    params += "&type=" + type + "&companyId=" + companyId;
				}
				
				console.log("params = " + params);
				$.ajax({
	        		type : "POST",
	        		url : url,
	        		data : params,
	        		error : function(data) {
	        			alert("error");
	        			console.log(data);
	        		},
	        		complete : function(data) {
	        			alert("<spring:message code='main.sp10'/>");
	        			window.close();
	        			$(opener.document).find("#signList *").remove();
	        			opener.signatureTemplateView();
	        	    }
	        	});
			}
		}
		
		// 템플릿명 체크
		function strChk(txt) {
			var strTrim = txt.trim();
			
			//var speCha = /[`~!<>@#$%^&*|\\\"\';:\/?]/gi;
			
			if (strTrim == '' || strTrim.length == 0) {
				alert("<spring:message code='ezEmail.jje08'/>");
				return;
			}
			
			if (txt.length > 50) {
				alert("<spring:message code='ezEmail.jje09'/>");
				return;
			}
			
			/* if (speCha.test(strTrim)) {
				alert("템플릿명을 정확히 입력해주세요.");
				return;
			} */
			
			return true;
		}
		
		// editor onload 됐을때
		function Editor_Complete() {
			if (type == "modify") {
				modifyDataView();
			}
			
			rebody();
		}
		
		function rebody() {
			if (type != "modify") {
				window.message.SetEditorContent("");
			}
	    }
		
		function modifyDataView() {
			//document.getElementById("displayname").value = displayname;
			//document.getElementById("displayname2").value = displayname2;
			window.message.SetEditorContent(document.getElementById("signatureTemplate").innerHTML);
		}
		
		function previewSignTemplate() {
			var contentStr = window.message.GetEditorContent();
			
			/* if (contentStr !== undefined) {
				url = "/admin/ezEmail/signaturePreviewContent.do?content=" + encodeURIComponent(contentStr);
		    	window.open(url,"_blank","width=890, height=660");
			} */
			
		    var mapForm = document.createElement("form");
		    mapForm.target = "Map";
		    mapForm.method = "POST"; // or "post" if appropriate
		    mapForm.action = "/admin/ezEmail/signaturePreviewContent.do";

		    var mapInput = document.createElement("textarea");
		    mapInput.style.display = "none";
		    mapInput.innerText = contentStr;
		    mapInput.name = "content";
		    mapForm.appendChild(mapInput);

		    document.body.appendChild(mapForm);

		    map = window.open("", "Map", "width=890, height=660");

			if (map) {
			    mapForm.submit();
			} 
			
		}
	
	</script>
	
	<body style="background: url(/images/kr/cm/popup_bg.gif) #ffffff repeat-x left top">
		<div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
		<div id="leTop">
			<div class="leTitle" style="margin-left:5px;"></div>
			<div class="leLetter"  style="padding:8px; padding-top:3px;">
				<div class="leLetterInfo">
					<table>
						<colgroup>
							<col width="100">
							<col width="">
						</colgroup>
						<tr>
							<th style="font-weight: normal"><spring:message code='ezEmail.jje10'/>(${primary}) </th>
							<td><input type="text" id="displayname" name="displayname" maxlength="40" value="<c:out value='${displayname}'/>" ></td>
						</tr>
						<tr>
							<th style="font-weight: normal"><spring:message code='ezEmail.jje11'/>(${secondary})</th>
							<td><input type="text" id="displayname2" name="displayname2" maxlength="40" value="<c:out value='${displayname2}'/>" ></td>
						</tr>
					</table>
				</div>
				
				<div style="height: 570px;">
				<div class="leLetterEditer" style="height:490px;">
					<iframe id="tbContentElement" class="viewbox" src="/ezEditor/selectEditor.do?type=SIGNATURETEMPLATE" name="message" style="padding:0; height:100%; width:70%;float:left; overflow:auto;"></iframe>
					<div style="margin-left:10px; float:left; height:100%; width:280px;">
						<table class="content" style="width:100%; border:none;">
							<thead id="inputInfoHeader">
								<tr>
									<th style="text-align:center;"><b><spring:message code='ezEmail.jje13'/></b></th>
								</tr>
							</thead>
							
							<tbody id="inputInfoBody">
								<tr style="cursor: pointer;" infoId="name" infoContent="<spring:message code='ezStatistics.t1068'/>">
									<td><spring:message code='ezStatistics.t1068'/></td>
								</tr>
								<tr style="cursor: pointer;" infoId="email" infoContent="<spring:message code='ezPortal.t38'/>">
									<td><spring:message code='ezPortal.t38'/></td>
								</tr>
								<tr style="cursor: pointer;" infoId="department" infoContent="<spring:message code='ezPortal.t5'/>">
									<td><spring:message code='ezPortal.t5'/></td>
								</tr>
								<tr style="cursor: pointer;" infoId="position" infoContent="<spring:message code='ezPersonal.t175'/>">
									<td><spring:message code='ezPersonal.t175'/></td>
								</tr>
								<tr style="cursor: pointer;" infoId="title" infoContent="<spring:message code='ezPersonal.t69'/>">
									<td><spring:message code='ezPersonal.t69'/></td>
								</tr>
								<tr style="cursor: pointer;" infoId="birth" infoContent="<spring:message code='ezOrgan.t00003'/>">
									<td><spring:message code='ezOrgan.t00003'/></td>
								</tr>
								<tr style="cursor: pointer;" infoId="empNo" infoContent="<spring:message code='ezEmail.jje14'/>">
									<td><spring:message code='ezEmail.jje14'/></td>
								</tr>
								<tr  style="cursor: pointer;"infoId="officePhone" infoContent="<spring:message code='main.t79'/>">
									<td><spring:message code='main.t79'/></td>
								</tr>
								<tr style="cursor: pointer;" infoId="homePhone" infoContent="<spring:message code='main.t82'/>">
									<td><spring:message code='main.t82'/></td>
								</tr >
								<tr style="cursor: pointer;" infoId="mobile" infoContent="<spring:message code='main.t80'/>">
									<td><spring:message code='main.t80'/></td>
								</tr>
								<tr style="cursor: pointer;" infoId="fax" infoContent="<spring:message code='main.t83'/>">
									<td><spring:message code='main.t83'/></td>
								</tr>
								<tr style="cursor: pointer;" infoId="zipCode" infoContent="<spring:message code='ezOrgan.t286'/>">
									<td><spring:message code='ezOrgan.t286'/></td>
								</tr>
								<tr style="cursor: pointer;" infoId="address" infoContent="<spring:message code='ezSchedule.t23'/>">
									<td><spring:message code='ezSchedule.t23'/></td>
								</tr>
							</tbody>
						</table>
						
						<table class="content" style="width:100%; border:none; margin-top:10px;">
							<tbody id="inputInfoDetail">
								<tr>
									<th style="text-align:center;"><b>ID</b></th>
									<td id="infoIdTarget"></td>
								</tr>
								<tr>
									<th style="text-align:center;"><b><spring:message code='ezEmail.t649'/></b></th>
									<td id="infoContentTarget"></td>
								</tr>
								<tr>
									<td align="center" colspan="2" height="40px" style="border: 0px;">
										<div id="mainmenu" style="margin-top: 7px;">
											<ul style="width: 100%;">
												<li class="inputInfoBtn"><span onclick="applyInfo()"><spring:message code='ezApprovalG.t336'/></span></li>
											</ul>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				
				</div>
				
				<div class="btnpositionNew">
		            <a class="imgbtn"><span onClick="saveSignTemplate()"><spring:message code='main.sp09'/></span></a>
		            <a class="imgbtn"><span onClick="previewSignTemplate()"><spring:message code='ezApproval.t350'/></span></a>
			    </div>
			</div>
		</div>
		
		<xml id="signatureTemplate" style="display: none;">${content}</xml>
	</body>
</html>
