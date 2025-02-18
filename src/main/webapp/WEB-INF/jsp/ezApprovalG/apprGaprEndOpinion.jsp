<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezApprovalG.t55'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <style>
	    	.mainlist tr th {
	    		border-top:0px;
	    	}
			.listview {
				width: 100%; height: 190px; overflow-x:hidden; overflow-y: AUTO;
			}
			#txt_OpinionContent {
				width: 100%; height: 180px; box-sizing:border-box;-moz-box-sizing:border-box; resize:none;
			}
	    </style>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
	    <script type="text/javascript" id="clientEventHandlersJS">
	        var pDocID;
	        var pDisplay;
	        var OrderCell = "";
	        var Resultxml = createXmlDom();
	        var xmlhttp = createXMLHttpRequest();
	        if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
	            window.onblur = function () {
	                window.focus();
	            };
	        }
	        var orgCompanyID;
	        var ReturnFunction;
			var resize = "<c:out value='${resize}'/>"; // 결재완료문서 > 하단 수신자탭 > 의견
	        window.onload = function () {
	            try {
	                dialogArguments = parent.aprendopinion_dialogArgument[0];
	                ReturnFunction = parent.aprendopinion_dialogArgument[1];
	            } catch (e) {
	                try {
	                    dialogArguments = parent.aprendopinion_dialogArgument[0];
	                    ReturnFunction = parent.aprendopinion_dialogArgument[1];
	                } catch (e) {
	                }
	            }                            
	            pDocID = dialogArguments[0];
	            pDisplay = dialogArguments[1];
	            orgCompanyID = dialogArguments[2];
	
	            /* 2022-06-28 홍승비 - 진행중문서를 완료문서 보기창으로 접근하는 경우가 있으므로, 진행중/완료문서를 체크하도록 분기처리 추가 */
	            if (getAprOrEndStr() == "APR") {
	            	getAPROpinionInfo();
	            } else {
	            	getEndOpinionInfo();
	            }
	            
	            DisplayFirstOpinionInfo();
	
	            document.getElementById("txt_OpinionContent").readOnly = true;
	            document.getElementById("bbtn_OpinionAdd").style.display = "none";
	            document.getElementById("bbtn_OpinionDel").style.display = "none";
	
	            if (pDisplay == "Show") {
	                document.getElementById("bbtn_OpinionAdd").style.display = "none";
	                document.getElementById("bbtn_OpinionDel").style.display = "none";
	            }
	            if (!CrossYN())
	                window.returnValue = "cancel";
				
				if (resize == "true") { // 결재완료문서 > 하단 수신자탭 > 의견
					document.getElementById("newbtnPosition").style.display = "none";
					document.getElementById("txt_OpinionContent").style.height = "119px";
				}
	        };
	        function DisplayFirstOpinionInfo() {
	            var listview = new ListView();
	            listview.LoadFromID("optionForm");
	            var TotRow = listview.GetDataRows();
	            var TotRowLen = listview.GetRowCount();
	
	            if (TotRow[0].id.indexOf("noItems") == -1) {
	                document.getElementById("txt_OpinionContent").value = TotRow[0].getAttribute("DATA3");
	            }
	        }
	        function getEndOpinionInfo() {
	            document.getElementById("OPINION").innerText = "";
	            
		    	var result = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/getEndOpinionInfo.do",
		    		data : {
		    			docID : pDocID,
		    			orgCompanyID : orgCompanyID
		    		},
		    		success: function(xml){
		    			result = loadXMLString(xml);
		    		}
		    	});
		    	
	            Resultxml = result;
	            var listview = new ListView();
	            listview.SetID("optionForm");
	            listview.SetMulSelectable(false);
	            listview.SetRowOnClick("OPINIONOnSelChange_onclick");
	            listview.DataSource(Resultxml);
	            listview.DataBind("OPINION");
	        }
	        function btn_OpinionCancel_onclick() {
	            if (ReturnFunction != null)
	            {
	                ReturnFunction("OK");
	            }
	            else
	            {
	                window.returnValue = "cancel";
	                window.close();
	            }
	        }
	        function btn_OpinionSave_onclick() {
	            if (ReturnFunction != null) {
	                ReturnFunction("OK");
	            }
	            else {
	                window.close();
	            }
	        }
	        function OPINIONOnSelChange_onclick() {
	            var listview = new ListView();
	            listview.LoadFromID("optionForm");
	            var Selcur = listview.GetSelectedRows();
	            if (Selcur != null) {
	                document.getElementById("txt_OpinionContent").value = GetAttribute(Selcur[0], "DATA3");
	            }
	        }
	        function txt_OpinionContent_onfocus() {
	            if (pDisplay == "Show") {
	                document.getElementById("btn_OpinionCancel").focus();
	                document.getElementById("txt_OpinionContent").blur();
	            }
	        }
	        function txt_OpinionContent_onchange() { }
			
			/* 2022-06-28 홍승비 - 완료문서 의견창이지만 진행중문서 접근 시에 대응하도록 의견 함수 추가 */
			function getAPROpinionInfo() {
				document.getElementById("OPINION").innerText = "";

		    	var result = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/opinionRequest.do",
		    		data : {
		    			docID : pDocID,
		    			orgCompanyID : orgCompanyID,
						state : getAprOrEndStr()
		    		},
		    		success: function(xml){
		    			result = loadXMLString(xml);
		    		}
		    	});
		    	
	            Resultxml = result;
	            var listview = new ListView();
	            listview.SetID("optionForm");
	            listview.SetMulSelectable(false);
	            listview.SetRowOnClick("OPINIONOnSelChange_onclick");
	            listview.DataSource(Resultxml);
	            listview.DataBind("OPINION");
	        }
			
			/* 2022-06-28 홍승비 - 전달한 DOCID로 진행중문서(APR) 또는 완료문서(END) 여부를 문자열로 리턴 */
			function getAprOrEndStr() {
				var result = "";
		    	
		    	$.ajax({
		    		type : "GET",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/getAprOrEndStr.do",
		    		data : {
		    			docID : pDocID,
		    			orgCompanyID : orgCompanyID
		    		},
		    		success: function(text){
		    			result = text;
		    		}
		    	});
		    	
		    	return result;
			}
			
	    </script>
	    
	</head>
	<body class="popup">
	    <h1><spring:message code='ezApprovalG.t55'/></h1>
	    <div id="close">
            <ul>
                <li><span onclick="return btn_OpinionCancel_onclick()"></span></li>
            </ul>
        </div>
	    <div class="listview">
	        <div id="OPINION" style="border: 0; Height: 190px;" onselchanged="OPINIONOnSelChange_onclick()"></div>
	    </div>
	
	    <h2 style="margin-top:10px;margin-bottom:3px" ><spring:message code='ezApprovalG.t423'/></h2>
	
	    <textarea id="txt_OpinionContent" name="txt_OpinionContent" class="textarea" onfocus="return txt_OpinionContent_onfocus()" onchange="return txt_OpinionContent_onchange()"></textarea>
	
	  	<div class="btnposition btnpositionNew" id="newbtnPosition">
	      <a class="imgbtn" id="bbtn_OpinionAdd" ><span id="btn_OpinionAdd" onClick="return btn_OpinionAdd_onclick()" ><spring:message code='ezApprovalG.t268'/></span></a>
	      <a class="imgbtn" id="bbtn_OpinionDel"><span id="btn_OpinionDel" onClick="return btn_OpinionDel_onclick()" ><spring:message code='ezApprovalG.t266'/></span></a>
	      <a class="imgbtn" id="bbtn_OpinionCancel" style="display:none"><span id="btn_OpinionCancel" onClick="return btn_OpinionCancel_onclick()"><spring:message code='ezApprovalG.t64'/></span></a>
		</div>
	</body>
</html>