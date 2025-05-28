<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t20'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
			var selectType = "${ selectType }";
			var ReturnFunction;
			var winFlag;
			var execFuncArray = [];
			var execBtnArray = [];

		    if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
		        window.onblur = function () {
		            window.focus();
		        };
		    }
		    if (new RegExp(/Chrome/).test(navigator.userAgent)) {
		        window.resizeTo(330+ (window.outerWidth - window.innerWidth), 205+ (window.outerHeight - window.innerHeight));
		    }
		    if (navigator.userAgent.indexOf('Firefox') != -1) {
		        window.resizeTo(348, 277);
		    }
		    else if (navigator.userAgent.indexOf("Safari") > 0 && navigator.userAgent.indexOf("Chrome") == -1) {
		        window.resizeTo(348, 240);
		    }

		    window.onload = function () {
		        try {
		            RetValue = parent.ezapralert_cross_dialogArguments[0];
		            ReturnFunction = parent.ezapralert_cross_dialogArguments[1];
		            winFlag = parent.ezapralert_cross_dialogArguments[2];

					ReturnFunction.forEach((d, i) => {
						var btnArea = document.getElementById("btnArea");

						extractData(d, i);
					});
		        } catch (e) {
		            try {
		                RetValue = opener.ezapralert_cross_dialogArguments[0];
		                ReturnFunction = opener.ezapralert_cross_dialogArguments[1];
			            winFlag = opener.ezapralert_cross_dialogArguments[2];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }

		        document.getElementById("pMessageContent").innerHTML = RetValue;

		        if (MACSAFARIYN())
		            window.resizeTo(330, 251);
		    }

			function extractData(d, i) {
				var tmp = (
					new Function(
						"return " + (d.fl === "" ? "" : d.fl + ".") + d.rtnF
					)
				)();

				execBtnArray.push(d.msg);
				makeBtnEvent(d, tmp, i);
			}

			function makeBtnEvent(d, fn, i) {
				var ei = "event_" + i;

				btnArea.insertAdjacentHTML(
					"beforeend",
					"<input id = '" + ei + "' type = 'submit' value = '" + d.msg + "' style = '" + d.css + "'>"
				);

				document.getElementById(ei).addEventListener("click", fn);
			}
		</script>
	</head>
	<body style="overflow:hidden;">
	    <!--  popup -->
	    <div class="popup_noti">
		    <div class="popup_noti_title" style="height:10px;"><span class="tl"> </span>  <span class="tr"> </span></div>
	 	<div class="popup_noti_content">
	        <div  style="padding:10px;">
	          <table>
	            <tr>
	              <td  class="cimg"></td>
	              <td  class="ctxt" ><span id="pMessageContent" ></span></td>
	            </tr>
	     </table>
	 	    </div>
	    </div>
	    <div class="popup_noti_btnarea"> 
	   	    <div id = "btnArea" class="btnposition"></div>
	        <span class="bl"> </span> <span class="br"></span>
	    </div>
	    </div>
	</body>
</html>
