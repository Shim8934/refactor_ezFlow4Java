<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
		<link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezResource.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript">
	    var types = parent.types;
	    var ReturnFunction;
	    
	    function window_onload() {
		    getFavoriteList();
            RetValue = parent.inputnamedlg_dialogArguments[0];
            ReturnFunction = parent.inputnamedlg_dialogArguments[1];
	    }
	    
	    function winclonse() {
	    	parent.DivPopUpHidden();
	    }
	    
	    function Wclose(resultType) {
	    	parent.types = "";
            if (CrossYN()) {
            	if (types == "M") {
            		alert('<spring:message code="ezResource.resFav.ygs12" />');
            		parent.location.reload();
            	} else {
            		switch (resultType) {
                	case "equalfail" :
                		alert(strLangFvYGS09)
                		break;
                	case "no" :
                		alert('<spring:message code="ezResource.resFav.ygs10" />');
                		break;
                	default:
                		alert('<spring:message code="ezResource.resFav.ygs12" />');
    		           	parent.location.reload();
                	}
            	}
            }
            else {
                window.close();
            }
        }
	    
    	</script>
	</head>
	<body class="popup" onload="javascript:window_onload()">
	    <h1 style="margin-bottom: 0px;"><spring:message code="ezResource.resFav.ygs05"/></h1> 
     	<input type="hidden" id="moveCategoryId" placeholder="moveCategoryId">
	    <div id="close">
	        <ul>
	            <li><span onclick="winclonse();"></span></li>
	        </ul>
	    </div>
	
	    <table class="popuplist" style="width: 100%">
	        <tr>
	            <td class="pos1" style="border:1px solid #ddd">
	                <div class="tree" style="width: 277px; overflow-x: auto; overflow-y: auto; height: 255px;" id="MoveTree"></div>
	            </td>	
	        </tr>
	    </table>
	    <div class="btnpositionNew">
	    	<a class="imgbtn"><span onClick="moveCategory();"><spring:message code="ezResource.resFav.ygs05"/></span></a>
	    </div>
	    <script type="text/javascript" src="${util.addVer('/js/ezResource/resFavoriteMove.js')}"></script>
	</body>
</html>