<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
		    var userId = "<c:out value='${userId}'/>";
		    var receiverLine = [];
		    var receiverFavoriteName;
		    
		    function saveReceiverLineName() {
		        receiverFavoriteName = $("#receiverFavoriteName").val().trim();
		        
		        if (receiverFavoriteName == "" || receiverFavoriteName == null) {
	        		alert("<spring:message code='ezJournal.t94'/>");
		
		        } else {
		        	saveReceiverLine();
		        }
		    }
		    
		    function saveReceiverLine() {
		    	$.ajax({
		    		type : "POST",
		    		url : "/ezJournal/saveReceiverFavorite.do",
		    		data : {"favoriteName"	: receiverFavoriteName, 
		    				"receiverLine"	: JSON.stringify(receiverLine),
		    				"type"			: parent.type,
		    				"favoriteId"	: parent.favoriteId},
    				success : function() {
    					alert("<spring:message code='ezJournal.t137'/>");
    					parent.type = "new";
    					parent.DivPopUpHidden();
    			    	window.close(); 					
    			    	parent.getFavoriteList();
    				},
    				error : function(request, status, error) {
		    			alert("code : " + request.status + "\nmessage: " + request.responseText + "\nerror : " + error);
		    		}
		    	}); 
		    }
		    
		    function cancelNamePop() {
		    	parent.DivPopUpHidden();
		    	window.close();
		    //	parent.location.reload();
		    }
		
		    function checkEnterKey() {
		    	if (window.event.keyCode == 13) {
		    		saveReceiverLineName();
		    	}
		    }
		    
		    window.onload = function () {
		    	
		    	if (parent.type == "mod") {
		    		$("h1").text("<spring:message code='ezJournal.t167'/>");
		    		$("#receiverFavoriteName").val(parent.favoriteNameForMod);
		    	}
		    	
		    	$("#receiverFavoriteName").focus();
		    	
		        try {
		        	receiverLine = parent.receiverList;
		        } catch (e) {
		            try {
		            	receiverLine = opener.receiverList;
		            } catch (e) {   }
		        }
		
		        // 한글 입력시 maxlength + 1이 입력되는 현상 제어
			    $("#receiverFavoriteName").keyup(function(e){
			    	var maxlength = $(this).prop("maxlength");
			    	if ($(this).val().length >= maxlength) {
			    		$(this).val($(this).val().substr(0, maxlength));
			    	}
			    });
		    };
		
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code='ezJournal.t93'/></h1>
		<div id="close">
            <ul>
                <li><span onclick="cancelNamePop()"></span></li>
            </ul>
        </div>
		<span>▒ <spring:message code='ezJournal.t94'/></span>
		<div class="nobox" style="margin-top:10px">
			<input type="text" class="text" style="width:100%;height:25px;border:1px solid #ccc" id="receiverFavoriteName" name="receiverFavoriteName" onkeypress="checkEnterKey()" maxlength="20">
		</div>		
			
		<div class="btnposition btnpositionNew">
			<a class="imgbtn" id="saveReceiverLineName" name="saveReceiverLineName" onClick="saveReceiverLineName()"><span><spring:message code='ezJournal.t15'/></span></a>
		</div>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='ezJournal.t185' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>
