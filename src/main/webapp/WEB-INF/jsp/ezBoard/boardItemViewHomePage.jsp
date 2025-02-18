<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<title><spring:message code='ezBoard.t293' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezBoard/common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezBoard.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt_util.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/asn1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/jsbn.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/prng4.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rng.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rsa.js')}"></script>
		<script  type="text/javascript">
		    window.offscreenBuffering = true;
		    var pItemID = "${itemID}";
			var pBoardID = "${boardID}";
		    var strContentLocation = "${contentLocation}";
		    var Access_FG = "${boardInfo.access_FG}";
		    var BoardAdmin_FG = "${boardInfo.boardAdmin_FG}";
		    var ListView_FG = "${boardInfo.listView_FG}";
		    var Read_FG = "${boardInfo.read_FG}";
		    var Write_FG = "${boardInfo.write_FG}";
		    var Reply_FG = "${boardInfo.reply_FG}";
		    var Delete_FG = "${boardInfo.delete_FG}";
		    var BoardGroupAdmin_FG = "${boardInfo.boardGroupAdmin_FG}";
			var gubun = "${boardInfo.guBun}";
			var pNoneActiveX = "YES";
		    var rsa = new RSAKey();

		    window.onload = function () {
		        try {
		        	var html = "";
		        	
					$.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezCommon/mhtToHTMLContent.do",
						data : { type   : "BOARDCONTENT", 
								 itemID : pItemID,
								 href   : strContentLocation 
							   },
						success: function(result){
							html = "<div class='contentDiv' id='txtContent'>" + result + "<div>";
						}        			
					});
					
					var doc = document.getElementById("message").contentWindow.document;
					doc.open();
					doc.write("<!doctype html>");
					doc.write(html);
					doc.close();
						
					/* 2024-12-17 김은실 - default.css 추가 */
					var cssLink0 = document.createElement("link");
					cssLink0.href = "${util.addVer('/css/default.css')}";
					cssLink0.rel = "stylesheet";
					cssLink0.type = "text/css";
					
					/* 2020-07-10 홍승비 - 게시물 본문 내부에도 기본적인 css가 적용되도록 수정 */
					var cssLink1 = document.createElement("link");
					cssLink1.href = "${util.addVer('main.default.css', 'msg')}";
					cssLink1.rel = "stylesheet";
					cssLink1.type = "text/css";
					
					/* 2021-09-02 홍승비 - 게시물 본문 내부의 헤딩 태그(h1, h2...)의 스타일은 default.css가 아닌 기본적인 브라우저의 user-agent 속성을 사용하도록 수정 (글자 자체의 인라인 속성이 있다면 해당 속성이 우선 적용됨) */
					// chrome의 경우 각 속성 revert로 간단히 처리가 가능하나, IE에서 해당 속성을 지원하지 않아 각 폰트 사이즈와 마진을 명시함
 					var cssHeading = "<style type='text/css'>.contentDiv h1, .contentDiv h2, .contentDiv h3, .contentDiv h4, .contentDiv h5, .contentDiv h6 {margin-left:0px; margin-right:0px; color:#000000;}";
					cssHeading += " .contentDiv h1 {font-size:2em; margin-top:0.67em; margin-bottom:0.67em;}";
					cssHeading += " .contentDiv h2 {font-size:1.5em; margin-top:0.83em; margin-bottom:0.83em;}";
					cssHeading += " .contentDiv h3 {font-size:1.17em; margin-top:1em; margin-bottom:1em;}";
					cssHeading += " .contentDiv h4 {font-size:1em; margin-top:1.33em; margin-bottom:1.33em;}";
					cssHeading += " .contentDiv h5 {font-size:0.83em; margin-top:1.67em; margin-bottom:1.67em;}";
					cssHeading += " .contentDiv h6 {font-size:0.67em; margin-top:2.33em; margin-bottom:2.33em;}";
					cssHeading += "</style>";
					
					$("#message").contents().find("head").append(cssLink0).append(cssLink1).append(cssHeading);
					$("#message").contents().find("body").css("word-wrap", "break-word");
					
					rsa.setPublic(document.getElementById('publicModulus').value, document.getElementById('publicExponent').value);
					
		            AddLinkTarget();
		        }
		        catch (e) {
		            alert(e.description);
		        }
		    };
		    
		    function AddLinkTarget() {
		        try {
		            var objTags = document.getElementById('message').getElementsByTagName("a");
		            for (var i = 0 ; i < objTags.length ; i++) {
		                if (objTags.item(i).href.indexOf("javascript:") == -1)
		                    objTags.item(i).target = "_blink";
		            }
		        }
		        catch (e) { }
		    }
		    
		    function btnClose_onclick() {
		        window.close();
		    }
		    
		    function ReplaceText(orgStr, findStr, replaceStr) {
		        var re = new RegExp(findStr, "gi");
		        return (orgStr.replace(re, replaceStr));
		    }
		    
		    /* 2020-01-30 홍승비 - 특수문자 파싱 추가 */
		    function MakeXMLString(p_str) {
		        p_str = ReplaceText(p_str, "&", "&amp;");
		        p_str = ReplaceText(p_str, "<", "&lt;");
		        p_str = ReplaceText(p_str, ">", "&gt;");
		        p_str = ReplaceText(p_str, "'", "&apos;");
		        p_str = ReplaceText(p_str, "\"", "&quot;");
		        return p_str;
		    }
		    
		    /* 2020-12-23 홍승비 - 익명게시물 게시자명 특문처리 추가 */
		    function ConvMakeXMLString(str) {
		        str = ReplaceText(str, "&lt;", "<");
		        str = ReplaceText(str, "&gt;", ">");
		        str = ReplaceText(str, "&#039;", "'");
		        str = ReplaceText(str, "&#034;", "\"");
		  		str = ReplaceText(str, "&#92;", "\\");
		  	    str = ReplaceText(str, "&amp;", "&");
		        return str;
		    }
		    
		</script>
	</head>
	<body id="body" style="width:100%; height:100%; overflow:hidden;">
		<table class="layout">
		  <tr>
		    <td class="pad1" id="pad1" style="vertical-align: top;">
		        <iframe id="message" class="viewbox" name="message" style="padding:0; width:100%; height:100%; overflow:auto; border:none;"></iframe>
			</td>
		  </tr>
		</table>
		
		<input id="publicModulus" value="${publicModulus}" type="hidden"/>
	    <input id="publicExponent" value="${publicExponent}" type="hidden"/>
	</body>
</html>
