<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezEmail.t341' /></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/ie_methods.js')}"></script>
		<style>
			//.popuplist #TDID input[type="checkbox"]{height: 12px !important;}
		</style>
	    <script type="text/javascript">
	        var arrKeyword = "";
	        var ReturnFunction;
	        var Ret;
	        var DivPopup = false;
	        window.onload = function () {
	            Ret = "cancel";
	            var Argument;
	            try {
	                Argument = opener.denial_cross_dialogArguments[0];
	                ReturnFunction = opener.denial_cross_dialogArguments[1];
	            } catch (e) {
	                Argument = parent.denial_cross_dialogArguments[0];
	                ReturnFunction = parent.denial_cross_dialogArguments[1];
	                DivPopup = true;
	            }
	            if (Argument != null)
	            {
	                var arrEmailAddr = Argument["email"];
	                arrKeyword = Argument["link"];
	                for (var i = 0 ; i < arrEmailAddr.length ; i++) {
	                    var emailValue = arrEmailAddr[i];
	                    if (emailValue != "") {
	                        var objTr = document.createElement("TR");
	                        objTr.setAttribute("valign", "top");
	                        var objTdcheck = document.createElement("TD");
	                        //objTdcheck.setAttribute('id', "TDID");
	                        //objTdcheck.style.padding = "5px";

                            const divWrapper = document.createElement("div");
                            divWrapper.className = "custom_checkbox";

	                        var objIn = document.createElement("INPUT");
	                        objIn.setAttribute('type', "checkbox");
	                        //objIn.setAttribute('id', "addr");
	                        objIn.setAttribute('name', "addr");
	                        objIn.setAttribute('addr', emailValue);
	                        objIn.setAttribute("email", emailValue);
	                        //objTdcheck.appendChild(objIn);
	                        objIn.setAttribute('checked', true);
	                        divWrapper.appendChild(objIn);

	                        //var text = "\"" + emailValue + "\"" + '<spring:message code="ezEmail.t343" />';
	                        //objIn.insertAdjacentText("afterEnd", text);
                           const label = document.createElement("label");
                           label.textContent = "\"" + emailValue + "\"" + '<spring:message code="ezEmail.t343" />';
                           divWrapper.appendChild(objIn);
                           divWrapper.appendChild(label);

                            objTdcheck.appendChild(divWrapper);
	                        objTr.appendChild(objTdcheck);
	                        msg.appendChild(objTr);
	                    }
	                }
	                for (var i = 0 ; i < arrKeyword.length ; i++) {
	                    var keyWord = arrKeyword[i];
	                    if (keyWord != "") {
                            const divWrapper = document.createElement("div");
                            divWrapper.className = "custom_checkbox";

	                        var objIn = document.createElement("INPUT");
	                        objIn.setAttribute('type', "checkbox");
	                        //objIn.setAttribute('id', "content");
	                        objIn.setAttribute('name', "content");
	                        objIn.setAttribute('addr', keyWord);
	                        
	                        const label = document.createElement("label");
                            label.setAttribute("for", uniqueId);
                            label.innerHTML = `"&nbsp;<spring:message code='ezEmail.t344' /> ${keyWord} <spring:message code='ezEmail.t345' />"`;

                            divWrapper.appendChild(objIn);
                            divWrapper.appendChild(label);
                            const objBr = document.createElement("br");

                            msg.appendChild(divWrapper);
                            msg.appendChild(objBr);

	                        /*msg.appendChild(objIn);
	                        objIn.setAttribute('checked', true);
	                        objIn.insertAdjacentText('afterEnd', "\"" + '<spring:message code="ezEmail.t344" /> ' + keyWord + '<spring:message code="ezEmail.t345" />');
	                        var objBr = document.createElement("BR");
	                        msg.appendChild(objBr);*/
	                    }
	                }
	            }
	        }
	        function btn_click() {
                var params = new Array();
                params["email"] = new Array();
                params["link"] = new Array();
                var arrAddr = document.getElementsByName('addr');
                var arrLink = document.getElementsByName('content');
                var idx = 0;
                var bSel = false;
                var count = document.getElementById("msg").childNodes.length;
                if (typeof (count) == "undefined") count = 0;
                if (document.getElementById("msg").childNodes.item(0).childNodes.item(0).childNodes.item(0).getAttribute("Email") != null) {
                    {
                        for (var i = 0 ; i < count ; i++) {
                            if (arrAddr.item(i).checked) {
                                params[idx] = arrAddr.item(i).getAttribute("Email");

                                bSel = true;
                                idx++;
                            }
                        }
                    }
                }
                params["link"] = arrKeyword;
                idx = 0;
                if (!bSel) {
                    alert('<spring:message code="ezEmail.t346" />');
                    return;
                }
                Ret = params;
                
                var result = ReturnFunction(Ret);
                
                if (result == 'OK') {
                    alert(strLang61);
                }
                else if (result == "DOMAINERROR")
                    alert(strLang352);
                else {
                    alert(strLang138);
                }
                
                if(!DivPopup) {
                    window.close();
                }
	        }
	        function btn_cancel() {
	            if (DivPopup)
	                ReturnFunction("cancel");
	            else
	                window.close();
	        }
	    </script>
	</head>
	<body class="popup">
	    <h1><spring:message code='ezEmail.t270' /></h1>
	    <div id="close">
            <ul>
                <li><span onclick="btn_cancel()"></span></li>
            </ul>
        </div>
	    <div style="overflow: auto; height: 203px;">
	    	<table class="popuplist" id="msg" style="overflow: auto; width: 100%; word-break: break-all;"></table>
	    </div>
	    <div class="btnpositionNew">
	        <a class="imgbtn"><span onclick="btn_click()" id="btn_close"><spring:message code='ezEmail.t38' /> </span></a>
	    </div>
	    <div id="tmp" style="display: none"></div>
	</body>
</html>



