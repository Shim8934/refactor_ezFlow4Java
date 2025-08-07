<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezApprovalG.pjj03'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <style>
			P { margin-top: 0px;margin-bottom: 0px; }
		</style>
	    <script type="text/javascript">
	
	        var myVar;
	        var NoneActiveX = "YES";
	        document.onselectstart = function () { return false; };
	        if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
	            window.onblur = function () {
	                window.focus();
	            }
	        }
	        
	        /* 2020-07-01 홍승비 - 문서기안 및 보기 시 div_Content 하위 테이블에 word-break속성이 공통적으로 존재하므로, 인쇄 시에도 해당 스타일을 적용함 */
	        window.onload = function () {
				if (isTeamsDesktop()) {
					document.getElementById("printDocument").innerHTML = parent.PrtBodyContent;
				} else {
	            	document.getElementById("printDocument").innerHTML = opener.PrtBodyContent;
				}
	            $('#printDocument #body').css('overflow', 'visible');
	            $('#BodyContent table').css('word-break', 'break-word');
	            
	            myVar = setInterval(function () { DocumentComplate() }, 2000);
	        }
	        function DocumentComplate() {
	            if (!CrossYN() && NoneActiveX == "NO") {
	                preview_print();
	            }
	            else{
	                window.print();
	            }
	            clearInterval(myVar);
	        }
	
	        function FieldsAvailable() {
	            document.getElementById("printDocument").innerHTML = message.div_Content.innerHTML;
	            $('#printDocument #body').css('overflow', 'visible');
	            myVar = setInterval(function () { DocumentComplate() }, 2000);
	        }
	
	        function preview_print() { //미리보기 기능 선언
	            var OLECMDID = 7; //7이 미리보기,6이 인쇄,8이 페이지설정
	            var PROMPT = 1;
	            var WebBrowser = '<OBJECT ID="WebBrowser1" WIDTH=0 HEIGHT=0 CLASSID="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2"></OBJECT>';
	            document.body.insertAdjacentHTML('beforeEnd', WebBrowser);
	            WebBrowser1.ExecWB(OLECMDID, PROMPT);
	            WebBrowser1.outerHTML = "";
	            return false;
	        }
			
			function close_Click() {
				if (window.parent.location.href.indexOf("docViewerCompare.do") != -1) {
					parent.printPopUpHidden();
				} else {
					parent.DivPopUpHidden();
				}
			}
			
			window.addEventListener("load", function() {
				if (isTeamsDesktop()) {
					document.getElementById("close").style.display = "";
				}
			})
	    </script>
		<style>
			#close ul {
				list-style: none; margin: 0; padding: 0;
			}
			#close ul li {
				text-align: right;
				margin-left: auto;
				margin-right: 0;
			}
			#close ul li span {
				display:inline-block;
				width:25px;
				height:28px;
				background-image: url('/images/close_xBtn.png');
				background-repeat: no-repeat;
				background-position: 4px 6px;
				text-align: right;
			}
		</style>
	</head>
	<body scroll="auto" style="background: #fff">
	    <table align="center">
	        <tr>
	            <td>
					<div id="close" style="display: none">
						<ul><li><span onclick="return close_Click()"></span></li></ul>
					</div>
	                <div id="printDocument"></div>
	            </td>
	        </tr>
	    </table>
	</body>
</html>