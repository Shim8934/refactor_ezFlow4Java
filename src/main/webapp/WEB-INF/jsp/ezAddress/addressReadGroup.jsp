<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezAddress.t302' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezAddress.e2' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript">
			var creatorid = "${addressInfo.creatorId}";
			var modifierid = "${addressInfo.modifierId}";
			var userid = "${userInfo.id}";
			var foldertype = "${pFolderType}";
			var addressid = "${pAddressId}";
			var deptAdmin = "${deptAdmin}";
			var compAdmin = "${compAdmin}";
			var useWebMail = "NO";
			var pUse_Editor = "${useEditor}";
		    var pUse_IE11Browser = "${useIE11Browser}";
		    var pNoneActiveX = "${noneActiveX}";
			window.onload = function () {
				window.resizeTo(370,560);
			}
			function show_personinfo(whoto) {
			    var userid = "";
			    if (whoto == 0)
			        userid = creatorid;
			    else
			        userid = modifierid;
		
			    window.open("/ezCommon/showPersonInfo.do?id=" + userid, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
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
				
			    location.replace("/ezAddress/addressWriteGroup.do?addressid=" + encodeURIComponent(addressid) + "&foldertype=" + foldertype, "",
		        "height = 655px, width = 970px, status = no, toolbar=no, menubar=no,location=no, resizable=0");
		
			}
		    function write_letter() {
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
		        var pLeft = (pwidth - 890) / 2;
		        
	            window.open("/ezEmail/mailWrite.do?cmd=NEW&msgto=" + encodeURIComponent(email), "",
	            	"top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
		    }
		</script>
	</head>
	<body class="popup">
		<form method="post">
		  <div id="normalScreen">
		    <div id="menu">
		      <ul>
		        <li><span onClick="modify_address()"><spring:message code='ezAddress.t174' /></span></li>
		        <li><span onClick="window.print()"><spring:message code='ezAddress.t283' /></span></li>
		        <li><span onClick="write_letter()"><spring:message code='ezAddress.t303' /></span></li>
		      </ul>
		    </div>
		    <div id="close">
		      <ul>
		        <li><span onClick="window.close()"><spring:message code='ezAddress.t5' /></span></li>
		      </ul>
		    </div>
		    <script type="text/javascript">
				selToggleList(document.getElementById("menu"), "ul", "li", "0");
				selToggleList(document.getElementById("close"), "ul", "li", "0");
			</script>
		    <table  class="content">
		      <tr>
		        <th><spring:message code='ezAddress.t304' /></th>
		        <td><span id="TextName">${addressInfo.sName}</span></td>
		      </tr>
		      <tr>
		        <th><spring:message code='ezAddress.t286' /></th>
		        <td title="<spring:message code='ezAddress.t287' />" style="CURSOR:pointer" onClick="show_personinfo(0)"><span id="TextCreator">${addressInfo.creatorName}</span></td>
		      </tr>
		      <tr>
		        <th><spring:message code='ezAddress.t288' /></th>
		        <td><span id="TextCreateDate">${addressInfo.createDate}</span></td>
		      </tr>
		      <tr>
		        <th><spring:message code='ezAddress.t289' /></th>
		        <td title="<spring:message code='ezAddress.t287' />" style="CURSOR:pointer" onClick="show_personinfo(1)"><span id="TextModifier">${addressInfo.modifierName}</span></td>
		      </tr>
		      <tr>
		        <th><spring:message code='ezAddress.t290' /></th>
		        <td><span id="TextModifyDate">${addressInfo.modifyDate}</span></td>
		      </tr>
		    </table>
		    <div class="nobox" style="margin-top:10px">
		    	<select id="ListMember" name="ListMember" style="width:100%;height:258px" size="4">${listMember}</select>
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