<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezPortal.t87'/></title>
		<link rel="stylesheet" href="<spring:message code='ezPortal.i2'/>" type="text/css" />
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript">
		 	var uid = "${uID}";
		    window.resizeTo("600", "620");
		    function AddRight() {
		        if (newAccessID.value == "") {
		            alert("<spring:message code='ezPortal.t85'/>");
				    return;
				}

			    // 1: 불가, 2: 가능
	            var editRight = "1";
	            var viewRight = "1";

	            if (document.getElementsByName("SelectEditRight")[1].checked == true)
	                editRight = "2";

	            if (document.getElementsByName("SelectViewRight")[1].checked == true)
	                viewRight = "2";

	            var strXML = "<DATA>";
	            strXML += "<UID>" + uid + "</UID>";
	            strXML += "<ACCESSID>" + newAccessID.value + "</ACCESSID>";
	            strXML += "<ACCESSNAME>" + newAccessName.value + "</ACCESSNAME>";
	            strXML += "<EDIT_RIGHT>" + editRight + "</EDIT_RIGHT>";
	            strXML += "<VIEW_RIGHT>" + viewRight + "</VIEW_RIGHT>";
	            strXML += "</DATA>";

	            var xmlhttp = createXMLHttpRequest();
	            xmlhttp.open("POST", "/admin/ezPortal/addRight.do", false);
	            xmlhttp.send(strXML);


	            xmlhttp = null;
	            location.href = "/ezPortal/portalPageACL.do?uID=" + uid;

	        }
		    var selecttarget_dialogArguments = new Array();
	        function SelectID() {
	            var config = "status:false;dialogWidth:690px;dialogHeight:630px;scroll:no;status:no;edge:sunken"
	            if (CrossYN()) {
	                selecttarget_dialogArguments[1] = SelectID_Complete;
	                var OpenWin = window.open("/admin/ezPortal/selectTarget.do", "SelectTarget", GetOpenWindowfeature(690, 630));
	                try { OpenWin.focus(); } catch (e) { }
	            }
	            else {
	                var ret = window.showModalDialog("/admin/ezPortal/selectTarget.do", "", config);

	                if (typeof (ret) != "undefined") {
	                    newAccessID.value = ret.split(";")[0];
	                    newAccessName.value = ret.split(";")[1];
	                }
	            }
	        }
	        function SelectID_Complete(ret) {
	            if (typeof (ret) != "undefined") {
	                newAccessID.value = ret.split(";")[0];
	                newAccessName.value = ret.split(";")[1];
	            }
	        }

	        function DeleteRight(pAccessID) {
	            var strXML = "<DATA>";
	            strXML += "<UID>" + uid + "</UID>";
	            strXML += "<ACCESSID>" + pAccessID + "</ACCESSID>";
	            strXML += "</DATA>";

	            var xmlhttp = createXMLHttpRequest();
	            xmlhttp.open("POST", "/admin/ezPortal/removeACL.do", false);
	            xmlhttp.send(strXML);
	            xmlhttp = null;

	            document.location.reload();
	        }

    	</script>
    </head>	
    <body class="popup" >
        <h1> <spring:message code='ezPortal.t87'/> </h1>
        <div id="close">
          <ul>
            <li><span onClick="window.returnValue=0;window.close()"><spring:message code='ezPortal.t8'/></span></li>
          </ul>
        </div>
        <div id="tabnav">
  			<ul class="on">
    			<li id="menu_1" class="on"><span><spring:message code='ezPortal.t87'/></span></li>
  			</ul>
		</div>
        <div style="width:100%;height:300px;overflow-x:hidden;overflow-y:auto;border:1px solid #B6B6B6;">
        <table class="content">
            <tr>
			<th style="width:150px;" class="pstitle"><spring:message code='ezPortal.t91'/></th>
			<th style="width:50%;" class="pstitle"><spring:message code='ezPortal.t92'/></th>
			<th style="width:80px;" class="pstitle"><spring:message code='ezPortal.t93'/></th>
			<th style="width:80px;" class="pstitle"><spring:message code='ezPortal.t94'/></th>
			<th style="width:80px;">&nbsp;</th>
            </tr>

		    <c:forEach items="${list}" var="item">
		    	<tr>
			    	<td style="width:150px;">${item.accessID}</td>
			    	<td style="width:50%;">${item.accessName}</td>
			    	<td style="text-align:center;width:80px;">
			    		<c:choose>
			    			<c:when test="${item.edit_Right == 2}">
			    				<spring:message code='ezPortal.t95'/>
			    			</c:when>
			    			<c:otherwise>
			    				<spring:message code='ezPortal.t96'/>
			    			</c:otherwise>
			    		</c:choose>	
			    	</td>
			    	<td style="text-align:center;width:80px;">
			    		<c:choose>
			    			<c:when test="${item.view_Right == 2}">
				    			<spring:message code='ezPortal.t95'/>
				    		</c:when>
				    		<c:otherwise>
				    			<spring:message code='ezPortal.t96'/>
			    			</c:otherwise>
			    		</c:choose>	
			    	</td>
			    	<td style="width:70px;text-align:center;">
                		<a class="imgbtn"><span onClick="DeleteRight('${item.accessID}')"><spring:message code='ezPortal.t67'/></span></a>
					</td>
			    </tr>
		    </c:forEach>
		</table>
        </div>
        <table class="content">
            <tr>
                <th><spring:message code='ezPortal.t91'/></th>
                <td>
                    <table>
                    <tr>
						<td><input type="text" id="newAccessID" style="width:100%" readonly> </td>
						<td>
                            <a class="imgbtn"><span onClick="SelectID()"><spring:message code='ezPortal.t45'/></span></a>
						</td>
                        
					</tr>
                    </table>
                </td>
            </tr>
            <tr>
                <th><spring:message code='ezPortal.t92'/></th>
                <td ><input type="text" id="newAccessName" style="width:100%" readonly></td>
            </tr>
            <tr>
                <th><spring:message code='ezPortal.t93'/></th>
                <td style="text-align:center;">
                    <input type="radio" name="SelectEditRight" value="1" checked> <spring:message code='ezPortal.t97'/>
				    <input type="radio" name="SelectEditRight" value="2"> <spring:message code='ezPortal.t95'/>
                </td>
            </tr>
            <tr>
			<th ><spring:message code='ezPortal.t94'/></th>
			<td style="text-align:center;">
				<input type="radio" name="SelectViewRight" value="1" checked> <spring:message code='ezPortal.t97'/>
				<input type="radio" name="SelectViewRight" value="2"> <spring:message code='ezPortal.t95'/>
			</td>
		</tr>
	     <tr style="display:none" >
	       <td><input type="text" id="AccessDeptName" style="display:none"></td>
	     </tr>
        </table>

        <div style="text-align:center;margin-top:10px;">
            <a class="imgbtn"><span onClick="AddRight()"><spring:message code='ezPortal.t62'/></span></a>
        </div>
  </body>
</html>