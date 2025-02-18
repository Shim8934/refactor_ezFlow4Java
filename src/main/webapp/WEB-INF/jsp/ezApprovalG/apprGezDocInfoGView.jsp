<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t1201'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	</head>
	<script type="text/javascript" ID="clientEventHandlersJS">
	    var ReturnFunction;
	    window.onload = function () {
	        try {
	            ReturnFunction = parent.ezdocinfog_view_cross_dialogArguments[1];
	        } catch (e) {
	            try {
	                ReturnFunction = opener.ezdocinfog_view_cross_dialogArguments[1];
	            } catch (e) {
	            }
	        }
	        var vdocdisplay, vPublicFlag;
	        vdocdisplay = "<c:out value ='${specialRecordCode}'/>";			//특수기록물 5자리
	        vPublicFlag = "<c:out value ='${publicityCode}'/>";			//공개여부 9자리
	        var summary = "<c:out value ='${summary}'/>"; // 요약전
	
	        document.getElementById("selSecLevel").value = "${securityCode}";
	        document.getElementById("selSecLevel").style.display = "none";
	        if (document.getElementById("selSecLevel").selectedIndex >= 0)
	            document.getElementById("SecLevel").innerText = document.getElementById("selSecLevel").options[document.getElementById("selSecLevel").selectedIndex].innerText;
	
	        if (vdocdisplay != "")
	            setdocdisplay(vdocdisplay);
	
	        if (vPublicFlag != "")
	            setPublicFlag(vPublicFlag);
	        
			if (summary != null && summary.trim() != "")
				txtAreaSW();
	    };
	    function setPublicFlag(vPublicFlag) {
	        var TypeText = "";
	        var ClassText = "";
	        switch (vPublicFlag.substring(0, 1)) {
	            case "1":
	                TypeText = "<spring:message code='ezApprovalG.t47'/>";
	                break;
	
	            case "2":
	                TypeText = "<spring:message code='ezApprovalG.t150'/>";
	                break;
	
	            case "3":
	                TypeText = "<spring:message code='ezApprovalG.t46'/>";
	                break;
	        }
	
	        for (var i = 1; i <= 8; i++) {
	            if (vPublicFlag.substring(i, i + 1) == "Y") {
	                if (ClassText == "")
	                    ClassText = ClassText + i + "<spring:message code='ezApprovalG.t151'/>";
	                else
	                    ClassText = ClassText + ",  " + i + "<spring:message code='ezApprovalG.t151'/>";
	            }
	        }
	
	        if (ClassText != "")
	            TypeText = TypeText + " ( " + ClassText + " ) ";
	
	        document.getElementById("publicity").innerHTML = "&nbsp;" + TypeText;
	  	 }
	    function setdocdisplay(vdocdisplay) {
	        var specialText = "";
	        if (vdocdisplay.substring(0, 1) == "Y")
	            if (specialText == "")
	                specialText = specialText + "<spring:message code='ezApprovalG.t1211'/>";
	            else
	                specialText = specialText + ",  " + "<spring:message code='ezApprovalG.t1211'/>";
	
	        if (vdocdisplay.substring(1, 2) == "Y")
	            if (specialText == "")
	                specialText = specialText + "<spring:message code='ezApprovalG.t984'/>";
	            else
	                specialText = specialText + ",  " + "<spring:message code='ezApprovalG.t984'/>";
	
	        if (vdocdisplay.substring(2, 3) == "Y")
	            if (specialText == "")
	                specialText = specialText + "<spring:message code='ezApprovalG.t1212'/>";
	            else
	                specialText = specialText + ",  " + "<spring:message code='ezApprovalG.t1212'/>";
	
	        if (vdocdisplay.substring(3, 4) == "Y")
	            if (specialText == "")
	                specialText = specialText + "<spring:message code='ezApprovalG.t986'/>";
	            else
	                specialText = specialText + ",  " + "<spring:message code='ezApprovalG.t986'/>";
	
	        if (vdocdisplay.substring(3, 4) == "Y")
	            if (specialText == "")
	                specialText = specialText + "<spring:message code='ezApprovalG.t1207'/>";
	            else
	                specialText = specialText + ",  " + "<spring:message code='ezApprovalG.t1207'/>";
	
	        document.getElementById("special").innerHTML = "&nbsp;" +  specialText;
	    }
	    function window_close() {
	        if (ReturnFunction != null) {
	            parent.ezdocinfog_view_cross_dialogArguments[1]();
	        }
	        else {
	            window.close();
	        }
	    }
	    function txtAreaSW() {
			var txtArea = document.getElementById("taSummary");
			if (txtArea != null && txtArea != undefined) {
				txtArea.disabled = false;
			}
	    }
	</script>
	<body class="popup">
		<h1><spring:message code='ezApprovalG.t1201'/></h1>
		<div id="close">
		  <ul>
		    <li><span onClick="window_close()"></span></li>
		  </ul>
		</div>
		<h2><spring:message code='ezApprovalG.t1203'/></h2>
		<TEXTAREA id="taSummary" name="taSummary" style="HEIGHT: 142px; WIDTH:97%; resize:none;" readonly disabled="disabled">${summary}</TEXTAREA>
		
		<h2><spring:message code='ezApprovalG.t1204'/></h2>
		<table class="content">
		  <tr>
		    <th ><spring:message code='ezApprovalG.t875'/></th>
		    <td id="special"></td>
		  </tr>
		  <tr>
		    <th><spring:message code='ezApprovalG.t118'/></th>
		    <td>&nbsp;<span id="SecLevel"></span>
		      <select id="selSecLevel" name="select" style="WIDTH:85px;display:none">
		        <option value="" selected></option>
		        ${securityNode}
		      </select>
		    </td>
		  </tr>
		  <tr>
		    <th><spring:message code='ezApprovalG.t1213'/><br><spring:message code='ezApprovalG.t989'/></th>
		    <td id="publicity"></td>
		  </tr>
		  <tr>
		    <th> <spring:message code='ezApprovalG.t876'/></th>
		    <td>&nbsp;${limitRange} </td>
		  <tr>
		    <th> <spring:message code='ezApprovalG.t979'/></th>
		    <td>&nbsp;${pageNum} </td>
		  </tr>
		  <tr>
		    <th> <spring:message code='ezApprovalG.t1199'/></th>
		    <td>&nbsp;${urgentApproval} </td>
		  </tr>
		  <tr>
		    <th><spring:message code='ezApprovalG.t1210'/></th>
		    <td>&nbsp;${securityDate }</td>
		  </tr>
		</table>
	</body>
</html>