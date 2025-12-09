<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezAddress.t302' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<style>
			select {
				background: none;
			}
		</style>
		<script type="text/javascript">
			var creatorid = "${addressInfo.creatorId}";
			var modifierid = "${addressInfo.modifierId}";
			var userid = "${userInfo.id}";
			var foldertype = "<c:out value='${pFolderType}'/>";
			var addressid = "${pAddressId}";
			var deptAdmin = "${deptAdmin}";
			var compAdmin = "${compAdmin}";
			var useWebMail = "NO";
			var pUse_Editor = "${useEditor}";
		    var pNoneActiveX = "${noneActiveX}";
		    var ret = new Array();
		    var ReturnFunction;
		    
			window.onload = function () {
				try {
					ReturnFunction = parent.address_group_edit_dialogArguments[0];
			    } catch (e) {
			        try {
			        	ReturnFunction = opener.address_group_edit_dialogArguments[0];
			        } catch (e) {
			            console.log(e);
			        }
			    }
			    
			    document.getElementById("ListMember").style.height = document.documentElement.clientHeight - 165 + "px";
			}
			
			window.onresize = function () {
				document.getElementById("ListMember").style.height = document.documentElement.clientHeight - 165 + "px";
			}
			
			function show_personinfo(whoto) {
			    var userid = "";
			    if (whoto == 0)
			        userid = creatorid;
			    else
			        userid = modifierid;
			    
			    // 2018.07.26  - 팝업을 창 가운데 띄우도록 개선 (재은 수정)
				var popupX = Math.ceil((window.screen.width - 500)/2);
				var popupY = Math.ceil((window.screen.height - 500)/2);
		
			    window.open("/ezCommon/showPersonInfo.do?id=" + userid, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1, left=" + popupX + ",top=" + popupY);
			}
			function modify_address() {
				if (creatorid != userid && modifierid != userid) {
					if (deptAdmin != "Y" && foldertype == "D") {
						alert("<spring:message code='ezAddress.t278' />");
						return;
					} else if (compAdmin != "Y" && foldertype == "C") {
						alert("<spring:message code='ezAddress.t278' />");
						return;
					}
				}
				
				ret[0] = addressid;
				ret[1] = foldertype;
				
				if (ReturnFunction != null)
				    ReturnFunction(ret);
				else
				    window.returnValue = ret;
				
				window.close();
			}
		    function write_letter() {
			    if(document.getElementById("ListMember").getElementsByTagName("tr").length > 0){
			                
			        var xmlHTTP = createXMLHttpRequest();
			        var xmlDom = createXmlDom();
			
			        var objNode, objRow, objRows, objRowRow;
			        objNode = createNodeInsert(xmlDom, objNode, "DATA");
			        createNodeAndInsertText(xmlDom, objNode, "ADDRESSID", addressid);
			        createNodeAndInsertText(xmlDom, objNode, "FOLDERTYPE", foldertype);
			
			        /* if(foldertype == "P")
			            xmlHTTP.open("POST", "RemoteEWS/address_get_groupemail.aspx", false);
			        else
			            xmlHTTP.open("POST", "Remote/address_get_groupemail.aspx", false); */
			        xmlHTTP.open("POST", "/ezAddress/addressGetGroupEmail.do", false);
			        
			        xmlHTTP.send(xmlDom);
			        xmlDom = loadXMLString(xmlHTTP.responseText);
			        var email = "";
			        var emailRows = SelectNodes(xmlDom, "DATA/ROW");
			        
	                if (emailRows.length > 0) {
	                    var addrname = getNodeText(document.getElementById("TextName"));
	                    if (foldertype == "P")
	                        var addremail = addressid + "|!|P";
	                    else
	                        var addremail = addressid + "|!|D";
	
	                    if (email == "")
	                        email = "\"" + addrname + "\" <" + addremail + ">";
	                    else
	                        email += ",\"" + addrname + "\" <" + addremail + ">";
	                }
			        		        
			        var pheight = window.screen.availHeight;
			        var conHeight = pheight * 0.8;
			        var pwidth = window.screen.availWidth;
			        var pTop = (pheight - conHeight) / 2;
			        var pLeft = (pwidth - 1200) / 2;
			        
		            window.open("/ezEmail/mailWrite.do?cmd=NEW&msgto=" + encodeURIComponent(email), "",
		            	"top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 1200px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
			    } else {
			    	alert(document.getElementById("TextName").innerText + " <spring:message code='ezAddress.t277' />");
			    }
			}
			
			function addRelatedCabinet() {
				//* moon 2018.07.26
				var openWidth = 480;
				
				if (navigator.userAgent.includes("Edg")) {
					openWidth = 600;
				}
				window.open("/ezCabinet/cabinetAddRelated.do?module=addrs", "addRelated", getOpenWindowfeature(openWidth, 505));
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
	<body class="popup" style="margin:5px 10px 9px;">
		<form method="post">
		  <div id="normalScreen">
		    <div id="menu" style="margin-bottom:19px; margin-top:7px;">
		      <ul>
		        <li><span onClick="modify_address()"><spring:message code='ezAddress.t174' /></span></li>
				<li><span class="icon16 popup_icon16_print" onClick="pagePrint()"></span></li>
		        <li><span class="icon16 popup_icon16_mail_gray" onClick="write_letter()"></span></li>
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
				<table  class="content">
				  <tr>
					<th><spring:message code='ezAddress.t304' /></th>
					<td colspan="3"><span id="TextName"><c:out value='${addressInfo.sName}' /></span></td>
				  </tr>
				  <tr>
					<th><spring:message code='ezAddress.t286' /></th>
					<td title="<spring:message code='ezAddress.t287' />" style="cursor:pointer;width:50%;" onClick="show_personinfo(0)"><span id="TextCreator"><c:out value='${addressInfo.creatorName}' /></span></td>
					<th><spring:message code='ezAddress.t289' /></th>
					<td title="<spring:message code='ezAddress.t287' />" style="cursor:pointer" onClick="show_personinfo(1)"><span id="TextModifier"><c:out value='${addressInfo.modifierName}' /></span></td>
				  </tr>
				  <tr>
					<th><spring:message code='ezAddress.t288' /></th>
					<td style="width:50%;"><span id="TextCreateDate"><c:out value='${addressInfo.createDate}' /></span></td>
					<th><spring:message code='ezAddress.t290' /></th>
					<td style="width:50%;"><span id="TextModifyDate"><c:out value='${addressInfo.modifyDate}' /></span></td>
				  </tr>
				  <tr>
					
				  </tr>
				  <tr>
					
				  </tr>
				</table>
		    
				<div id="ListMember" style="width:100%;height:415px;margin-top:10px;padding:0;overflow:auto;border:1px solid #d2d2d2;">
					<table style="width:100%;">
						<c:forEach items="${listMember}" var="member">
							<tr onmouseover="" style="height:20px;border-bottom:1px solid #d2d2d2;">
								<td style="padding:6px;" title="${member}">${member}</td>
							</tr>
						</c:forEach>
					</table>
				</div>
			</div>
		  </div>
		  <div id="printScreen" style="DISPLAY: none">
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
		        <th><spring:message code='ezAddress.t305' /></th>
		        <td id="printModifier"></td>
		      </tr>
		      <tr>
		        <th><spring:message code='ezAddress.t306' /></th>
		        <td id="printModifyDate"></td>
		      </tr>
		      <tr>
		        <th><spring:message code='ezAddress.t307' /></th>
		        <td id="printName"></td>
		      </tr>
		      <tr>
		        <th><spring:message code='ezAddress.t308' /></th>
		        <td id="printMember"></td>
		      </tr>
		    </table>
		  </div>
		</form>
	</body>
</html>