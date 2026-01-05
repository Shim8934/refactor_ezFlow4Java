<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezAddress.t275' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
			var creatorid = "<c:out value='${addressInfo.creatorId}'/>";
			var modifierid = "<c:out value='${addressInfo.modifierId}'/>";
			var userid = "<c:out value='${userInfo.id}'/>";
			var foldertype = "<c:out value='${pFolderType}'/>";
			var addressid = "<c:out value='${pAddressId}'/>";
			var deptAdmin = "<c:out value='${deptAdmin}'/>";
			var compAdmin = "<c:out value='${compAdmin}'/>";
		    var pFolderID = "<c:out value='${pFolderId}'/>";
		    var pUse_Editor = "<c:out value='${useEditor}'/>";
		    var pNoneActiveX = "<c:out value='${noneActiveX}'/>";
		    var getMemo = "<c:out value='${getsMemo}'/>";
		    /* 2021-06-24 김은실 - var address가 쓰이는 것 같지 않은데 메모에 Enter가 있는 경우 불필요하게 에러가 남.
		    var address = "<c:out value='${addressInfo}'/>"
		     */
		    
		    window.onload = function () {
		        var name = '<c:out value="${addressInfo.sName}"/>';
		        name = replaceEntityCodeToStr(name);
				document.getElementById("TextName").innerText = name;		        		        
		        document.getElementById("TextName").title = name;
		        
		        // 2021-06-24 김은실 - 대체 어디서 변경하는 지를 모르겠는데(핸들러??) 특수문자가 변경됨. &'"<> → &amp;&#039;&#034;&lt;&gt;
		    	getMemo = getMemo.replace(/&amp;#92;n/gi, "\n").replace(/\\\\/gi, "\\")
								 .replace(/&amp;/gi, "&")
								 .replace(/&#039;/gi, "'")
								 .replace(/&#034;/gi, '\"')
								 .replace(/&lt;/gi, "<")
								 .replace(/&gt;/gi, ">"); 
		        document.getElementById("TextMemo").innerText = getMemo;
		    }
		    
			function show_personinfo(whoto)
			{
				var userid = whoto;
				if (whoto == 0)
					userid = creatorid;
				else if (whoto == 1)
					userid = modifierid;
		
				// 2018.07.24  - 팝업을 창 가운데 띄우도록 개선 (재은 수정)
				var popupX = Math.ceil((window.screen.width - 500)/2);
				var popupY = Math.ceil((window.screen.height - 500)/2);

				window.open("/ezCommon/showPersonInfo.do?id=" + userid, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1, left=" + popupX + ",top=" + popupY);
			}
			function open_homepage()
			{
				if (document.getElementById("TextHomePage").innerText != "")
				{
					if (document.getElementById("TextHomePage").innerText.indexOf("//") == -1)
						window.open("http://" + document.getElementById("TextHomePage").innerText);
					else
						window.open(document.getElementById("TextHomePage").innerText);
				}
				else
					alert("<spring:message code='ezAddress.t276' />");
			}
			function send_email()
			{
				if (document.getElementById("TextEmail").innerHTML != "")
				{
					email = "\"" + document.getElementById("TextName").innerHTML + "\" <" + document.getElementById("TextEmail").innerHTML + ">";
		                    
		            var pheight = window.screen.availHeight;
		            var conHeight = pheight * 0.8;
		            var pwidth = window.screen.availWidth;
		            var pTop = (pheight - conHeight) / 2;
		            var pLeft = (pwidth - 1200) / 2;
		              
		            window.open("/ezEmail/mailWrite.do?cmd=NEW&msgto=" + encodeURIComponent(email), "",
		                "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 1200px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
				}
				else
				    alert(document.getElementById("TextName").innerText + " <spring:message code='ezAddress.t277' />");
			}
			function modify_address()
			{
				if (creatorid != userid && modifierid != userid) {
					if (deptAdmin != "Y" && foldertype == "D") {
						alert("<spring:message code='ezAddress.t278' />");
						return;
					} else if (compAdmin != "Y" && foldertype == "C") {
						alert("<spring:message code='ezAddress.t278' />");
						return;
					}
				}
				
				location.replace("/ezAddress/addressWrite.do?addressid=" + encodeURIComponent(addressid) + "&folderid=" + encodeURIComponent(pFolderID) + "&foldertype=" + foldertype, "",
					"height = 420px, width = 600px, status = no, toolbar=no, menubar=no,location=no, resizable=0");
						
			}
			function attach_SelectAll()
			{
				var checks = document.getElementById("attachedfileDIV").getElementsByTagName("input");
						
				for (var i=0; i<checks.length; i++)
					checks.item(i).checked = true;
			}
			function attach_Download() {
				var param = { "href": new Array(), "name": new Array(), "folderpath": new String(), "attachid": new String(), "foldertype": new String() };
		
				var count = 0;
				var checks = document.getElementById("attachedfileDIV").getElementsByTagName("input");
		
				for (var i = 0; i < checks.length; i++) {
					if (checks.item(i).checked == true) {
					    param["href"][count] = checks.item(i).filepath;
					    param["name"][count] = checks.item(i).filename;
		
					    param["attachid"][count] = checks.item(i).attachid;
					    param["foldertype"][count] = checks.item(i).foldertype;
					    count++;
					}
				}
				if (count == 0) {
					alert("<spring:message code='ezAddress.t279' />");
					return;
				}
		
				var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
				ezUtil.UseUTF8 = true;
				var folderpath = ezUtil.BrowseFolder();
				if (folderpath != "") {
				    param["folderpath"] = folderpath;
				    var feature = "dialogWidth:428px; dialogHeight:139px; scroll:no; status:no; help:no; scroll:no; edge:sunken";
				    feature = feature + GetShowModalPosition(428, 139);
				    window.showModalDialog("htm/attachdownload.aspx", param, feature);
				}
			}
			
			function addRelatedCabinet() {
				//* moon 2018.07.26
				window.open("/ezCabinet/cabinetAddRelated.do?module=addrs", "addRelated", getOpenWindowfeature(480, 505));
			}
			
			function getOpenWindowfeature(popUpW, popUpH) {
				var heigth   = window.screen.availHeight;
				var width    = window.screen.availWidth;
				var left     = 0;
				var top      = 0;
				var pleftpos = parseInt(width) - popUpW;
				heigth       = parseInt(heigth) - popUpH;
				left         = pleftpos / 2;
				top          = heigth / 2;
				var feature  = "height = " + popUpH + "px, width = " + popUpW + "px,left=" + left + ",top=" + top + ", status=no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=yes";
				return feature;
			}
			
			function replaceEntityCodeToStr(str) {
				return str.replace(/&amp;/g, "&")
						  .replace(/&lt;/g, "<")
						  .replace(/&gt;/g, ">")
						  .replace(/&quot;/g, '\"')
						  .replace(/&#40;/g, "\(")
						  .replace(/&#41;/g, "\)")
						  .replace(/&#39;/g, "'")
						  .replace(/&#34;/g, '\"')
						  .replace(/&amp;/g, "&");
			}
			
			function pagePrint() {
				var initBody = $('body').html();
				
				// window.print()이전 이벤트 발생
				window.onbeforeprint = function () {
					document.body.innerHTML = $('#printContent').html();
					//메모가 길 경우 스크롤바가 생기는데 프린트를 하면 스크롤 아래 내역은 출력이 안되어 auto로 변경해주는 작업
					document.getElementById('memoDiv').style.height = 'auto';
				}

				// window.print()이후 이벤트 발생
				window.onafterprint = function () {
					// window.onbeforeprint 에서 변경한 화면단을 다시 원래로 돌리는 작업
					document.body.innerHTML = initBody;
				}
				
				window.print();
			}
		</script>
	</head>
	<body class="popup" >
		<form method="post">
		  <div id="normalScreen">
		    <div id="menu" style="margin-top:7px;margin-bottom:19px;">
		      <ul style="margin:0;">
		        <li><span onClick="modify_address()"><spring:message code='ezAddress.t174' /></span></li>
				<li><span class="icon16 popup_icon16_print" onClick="pagePrint()"></span></li>
		        <li><span class="icon16 popup_icon16_mail_gray" onClick="send_email()"></span></li>
		      	<c:if test="${useCabinet == 'YES'}">
					<li><span onClick="addRelatedCabinet()"><spring:message code='ezCabinet.t125'/></span></li>
				</c:if>
		      </ul>
		    </div>
		    <div id="close">
		      <ul>
		        <li><span onClick="window.close()"></span></li>
		      </ul>
		    </div>
		    
		    <script type="text/javascript">
			    selToggleList(document.getElementById("menu"), "ul", "li", "0");
		    </script>
			<div id="printContent">
		    	<table class="popuplist" style="width:100%; table-layout: fixed; ">
		          <tr style=<c:out value="${primaryLang eq '3' ? 'display:table-row' : 'display:none' }"/>>
		            <th style="width: 71px;"><spring:message code='main.ksa01' /></th>
		            <td colspan="3" style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"><span id="TextFurigana" title="<c:out value='${addressInfo.sFurigana}' />"> <c:out value='${addressInfo.sFurigana}' /></span></td>
		          </tr>
		          <tr>
		            <th width="13%"><spring:message code='ezAddress.t124' /></th>
		            <td style="width:32%; overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"><span id="TextName"></span></td>
		            <th width="13%"><spring:message code='ezAddress.t286' /></th>
		            <td title="<spring:message code='ezAddress.t287' />" style="width:30%; overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"><span onClick="show_personinfo(0)" style="cursor:pointer"><span id="TextCreator"><c:out value='${addressInfo.creatorName}' /></span></span></td>
		          </tr>
		          <tr>
		            <th><spring:message code='ezAddress.t51' /></th>
		            <td style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"><span id="TextCompany" title="<c:out value='${addressInfo.sCompany}' />"><c:out value='${addressInfo.sCompany}' /></span></td>
		            <th><spring:message code='ezAddress.t288' /></th>
		            <td style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"><span id="TextCreateDate"><c:out value='${addressInfo.createDate}' /></span></td>
		          </tr>
		          <tr>
		            <th><spring:message code='ezAddress.t54' /></th>
		            <td style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"><span id="TextDept" title="<c:out value='${addressInfo.sDept}' />"><c:out value='${addressInfo.sDept}' /></span></td>
		            <th><spring:message code='ezAddress.t289' /></th>
		            <td title="<spring:message code='ezAddress.t287' />" style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"> <span onClick="show_personinfo(1)" style="cursor:pointer"><span id="TextModifier"><c:out value='${addressInfo.modifierName}' /></span></span></td>
		          </tr>
		          <tr>
		            <th><spring:message code='main.t77' /></th>
		            <td style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"><span id="TextTitle" title="<c:out value='${addressInfo.sTitle}' />" ><c:out value='${addressInfo.sTitle}' /></span></td>
		            <th><spring:message code='ezAddress.t290' /></th>
		            <td style="white-space:nowrap;"><span id="TextModifyDate"><c:out value='${addressInfo.modifyDate}' /></span></td>
		          </tr>
		          <tr>
		            <th><spring:message code='ezAddress.t291' /></th>
		            <td colspan="3" title="<spring:message code='ezAddress.t285' />" style="color:steelblue; overflow: hidden;"><span onClick="send_email()"><span id="TextEmail" style="cursor:pointer"><c:out value='${addressInfo.sEmail}' /></span></span></td>
		          </tr>
		          <tr style="height:10px;">
		              <td colspan="4" style="height:10px;border-left:1px solid #ffffff;border-right:1px solid #ffffff;">&nbsp;</td>
		          </tr>
		          <tr>
		            <th><spring:message code='ezAddress.t192' /></th>
		            <td style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"><span id="TextCompanyPhone"><c:out value='${addressInfo.sCompanyPhone}' /></span></td>
		            <th><spring:message code='ezAddress.t189' /></th>
		            <td style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"><span id="TextMobile"><c:out value='${addressInfo.sMobile}' /></span></td>
		          </tr>
		          <tr>
		            <th><spring:message code='ezAddress.t292' /></th>
		            <td style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"><span id="TextFax"><c:out value='${addressInfo.sFax}' /></span></td>
		            <th><spring:message code='ezAddress.t293' /></th>
		            <td style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;" title="<spring:message code='ezAddress.t294' />" ><span onClick="open_homepage()" style="cursor:pointer"><span id="TextHomePage" style="width:100%"><c:out value='${addressInfo.sHomePage}' /></span></span></td>
		          </tr>
		          <tr>
		            <th rowSpan="2" style="white-space:normal;"><spring:message code='ezAddress.t295' /></th>
		            <td colSpan="3" style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"><span id="TextComZip" style="width:70px" ReadOnly="true"><c:out value='${addressInfo.sCompanyZip}' /></span></td>
		          </tr>
		          <tr>
		            <td colSpan="3" style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"><span id="TextComAddr" style="width:100%"><c:out value='${addressInfo.sCompanyAddr}' /></span></td>
		          </tr>
		          <tr>
		            <th rowSpan="2"><spring:message code='ezAddress.t296' /></th>
		            <td colSpan="3" style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"><span id="TextHomeZip" style="width:70px" ReadOnly="true"><c:out value='${addressInfo.sHomeZip}' /></span></td>
		          </tr>
		          <tr>
		            <td colSpan="3" style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"><span id="TextHomeAddr" style="width:100%"><c:out value='${addressInfo.sHomeAddr}' /></span></td>
		          </tr>
		          <tr>
		            <th><spring:message code='ezAddress.t91' /></th>
		            <td colSpan="3" style="height:50px;overflow:auto;"><div id="memoDiv" style="height:85px;overflow:auto"><span id="TextMemo" style="width:100%;height:60px" TextMode="MultiLine"></span></div></td>
		          </tr>
		        </table>
			</div>
		  </div>
		  <div id="printScreen" style="DISPLAY:none">
		    <table class="content">
		      <tr>
		        <th><spring:message code='ezAddress.t286' /></th>
		        <td id="printCreator"></td>
		      </tr>
		      <tr>
		        <th><spring:message code='ezAddress.t288' /></th>
		        <td id="printCreateDate"></td>
		      </tr>
		      <tr>
		        <th><spring:message code='ezAddress.t289' /></th>
		        <td id="printModifier"></td>
		      </tr>
		      <tr>
		        <th><spring:message code='ezAddress.t290' /></th>
		        <td id="printModifyDate"></td>
		      </tr>
		      <tr>
		        <th><spring:message code='ezAddress.t301' /></th>
		        <td id="printPhoto"></td>
		      </tr>
		      <tr>
		        <th><spring:message code='ezAddress.t124' /></th>
		        <td id="printName"></td>
		      </tr>
		      <tr>
		        <th><spring:message code='ezAddress.t51' /></th>
		        <td id="printCompany"></td>
		      </tr>
		      <tr>
		        <th><spring:message code='ezAddress.t54' /></th>
		        <td id="printDept"></td>
		      </tr>
		      <tr>
		        <th><spring:message code='ezAddress.t52' /></th>
		        <td id="printTitle"></td>
		      </tr>
		      <tr>
		        <th><spring:message code='ezAddress.t192' /></th>
		        <td id="printPhone"></td>
		      </tr>
		      <tr>
		        <th><spring:message code='ezAddress.t292' /></th>
		        <td id="printFax"></td>
		      </tr>
		      <tr>
		        <th><spring:message code='ezAddress.t189' /></th>
		        <td id="printMobile"></td>
		      </tr>
		      <tr>
		        <th><spring:message code='ezAddress.t224' /></th>
		        <td id="printEmail"></td>
		      </tr>
		      <tr>
		        <th><spring:message code='ezAddress.t293' /></th>
		        <td id="printHomePage"></td>
		      </tr>
		      <tr>
		        <th><spring:message code='ezAddress.t295' /></th>
		        <td id="printComAddr"></td>
		      </tr>
		      <tr>
		        <th><spring:message code='ezAddress.t296' /></th>
		        <td id="printHomeAddr"></td>
		      </tr>
		      <tr>
		        <th><spring:message code='ezAddress.t91' /></th>
		        <td id="printMemo"></td>
		      </tr>
		    </table>
		  </div>
		</form>
	</body>
</html>


