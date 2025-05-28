<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<html>
	<head>
		<title><spring:message code='ezBoard.t242'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezBoard.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/jsbn.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rsa.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/prng4.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rng.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/common.js')}"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
		    var pReplyID = "${replyID}";
		    var pItemID = "${itemID}";
		    var pBoardID = parent.pBoardID;
		    var gubun = parent.gubun;
			var gUserID = "";
		    var rtnVal = "cancel";
		    var ReturnFunction;
		    var rsa = new RSAKey();
		    var delpReplyID = pReplyID;
			
		    $(document).ready(function() {
			    
			    rsa.setPublic(document.getElementById('publicModulus').value, document.getElementById('publicExponent').value);
		        try {
		            var ua = navigator.userAgent;
		            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1)
		                KeEventControl(document.getElementById("inpPassword"));
		        }
		        catch (e) {
		        }
			});
		    
		    function ReplaceText( orgStr, findStr, replaceStr ) {
		        var re = new RegExp( findStr, "gi" );
		        return ( orgStr.replace( re, replaceStr ) );
		    }
		
		    /* 2020-01-17 홍승비 - 커뮤니티 익명게시물 또는 익명게시물의 댓글 삭제 시 암호 확인 분기 추가 */
		    function btn_OpinionOK_onclick() {
		        if (inpPassword.value == "") 
		        {
		            alert("<spring:message code='ezBoard.t243'/>");
		            return;
		        }
		        $.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezCommunity/confirmPassword.do",
					data : {
						newPassword   : rsa.encrypt(document.getElementById("inpPassword").value),
						oldPassword : "",
						replyID : "${replyID}",
						itemID  : "${itemID}"
					},
					success: function(result){
						rtnVal = result;
						if(rtnVal == "OK") {
							closePopup2();
							delete_onelinereply_Complete(rtnVal);
							parent.getBoardComment();
						} else {
							alert("<spring:message code='ezBoard.t267'/>");
							$('#inpPassword').val("");
							return;
						}
					}        			
				});
		        
		    }
		    function btn_OpinionCANCEL_onclick() {
		        if (ReturnFunction != null) {
		            rtnVal = "cancel";
		        } else {
		            window.returnValue = "cancel";
		        }
		        closePopup2();
		    }
		</script>
	</head>
	<body class="popup" style="overflow:hidden;">
		<h1><spring:message code='ezBoard.t244'/></h1>
		<div id="close">
            <ul>
                <li><span name="btn_OpinionCANCEL" id="btn_OpinionCANCEL" onclick="return btn_OpinionCANCEL_onclick()"></span></li>
            </ul>
        </div>
	    <div class="txt" style="margin-top:15px">
	        ▒&nbsp;<spring:message code='ezBoard.t245'/>
	    </div>	    
	    <div style="margin-top:10px">
	        <input type="password" class="textarea" id="inpPassword" name="inpPassword" style="WIDTH:100%;height:25px;border:1px solid #ccc">
	    </div>
	    <div class="btnposition btnpositionNew">
	        <a name="btn_OpinionOK" id="btn_OpinionOK" class="imgbtn" onClick="return btn_OpinionOK_onclick()"  ><span><spring:message code='ezBoard.t14'/></span></a>
	    </div>
		<input id="publicModulus" value="${publicModulus}" type="hidden"/>
		<input id="publicExponent" value="${publicExponent}" type="hidden"/>
		<input id="onelinereply" value="" type="hidden"/>
	</body>
</html>