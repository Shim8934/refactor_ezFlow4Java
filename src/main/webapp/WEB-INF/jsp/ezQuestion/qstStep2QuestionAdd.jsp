<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="/css/default_kr.css" type="text/css" />
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezQuestion/common.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script language="javascript" type="text/javascript">
			var index = -1;
			var g_DelAttachList = "";
			var pBeforeCheck = "";
			var pEditIndex = "${pEditIndex}";
		    var pAnswerType = "${questionAddVO.answerType}";
    		pAnswerType = (parseInt(pAnswerType)-1).toString();
    		var pMode = "${pMode}";
    		var pMultiSel = "${questionAddVO.pMultiSel}";
    		var pDataXml = "${pDataXML}";
    		
    		var g_windowReference = null;
    
			window.onload = function () {
	    		Ques_Answer.txtQuestion.focus();
	    		document.Ques_Answer.selView[0].checked = true;
	    		TypeDetermination(1);
	    		TypeArray(5);
	    		AttachSetting();
	    		if(pMode == "EDIT"){
	        		if(parseInt(pAnswerType) > 3){
	            		TypeArray(parseInt(pAnswerType)+2, pDataXml);
	        		} else{
	            		document.Ques_Answer.selView[pAnswerType].checked = true;
	            		if(pMultiSel == "false") {
	            			document.Ques_Answer.MultiResponse.checked = false;
	            		} else {
	            			document.Ques_Answer.MultiResponse.checked = true;
	            		}
	            			TypeDetermination(parseInt(pAnswerType) + 1);
	        		}
	    		}
			}

			function AttachSetting() {
	    		if (CrossYN()) {
	    			return;
	    		} else {
	        		for (var i = 0; i < Ques_Answer.input_Ans.length; i++) {
	            		if (Ques_Answer.input_Ans[i].getAttribute("ansinfo") != null) {
	                		var m_AttachInfo = { "type": new Array(), "attachTitle": new Array(), "href": new Array() };
			                m_AttachInfo["type"][0] = getNodeText(loadXMLString(Ques_Answer.input_Ans[i].getAttribute("ansinfo")).getElementsByTagName("TYPE")[0]);
	                		m_AttachInfo["attachTitle"][0] = getNodeText(loadXMLString(Ques_Answer.input_Ans[i].getAttribute("ansinfo")).getElementsByTagName("ATTACHTITLE")[0]);        ///
	                		m_AttachInfo["href"][0] = getNodeText(loadXMLString(Ques_Answer.input_Ans[i].getAttribute("ansinfo")).getElementsByTagName("HREF")[0])
			                Ques_Answer.input_Ans[i].AnsInfo = m_AttachInfo;
	    		            m_AttachInfo = null;
	            		}
	        		}
	        		td_Question.innerHTML = "";
	        		var m_AttachInfo = { "type": new Array(), "attachTitle": new Array(), "href": new Array() };
	        		var xml = loadXMLString(pDataXml);
	        		if (pDataXml != "") {
	            		if (SelectNodes(xml, "ROW/ATTACH/ROW").length > 0) {
	                		for (var i = 0; i < SelectNodes(xml, "ROW/ATTACH/ROW") .length; i++) {
	                    		td_Question.innerHTML += getNodeText(xml.getElementsByTagName("ATTACHTITLE")[i]);            /////
	                    		m_AttachInfo["type"][i] = getNodeText(xml.getElementsByTagName("TYPE")[i]);
	                    		m_AttachInfo["attachTitle"][i] = getNodeText(xml.getElementsByTagName("ATTACHTITLE")[i]);           ////////
	                    		m_AttachInfo["href"][i] = getNodeText(xml.getElementsByTagName("HREF")[i]);
	                    		if (i != xml.getElementsByTagName("ATTACHTITLE").length - 1)        //////////
	                        		td_Question.innerHTML += ";";
	                		}
	                		Ques_Answer.txtQuestion.AnsInfo = m_AttachInfo;
	            		}
	        		}
	    		}
			}

		    function TypeArray(para, pDataXml){
        		var resultDiv = document.getElementById("ResultDiv");
        		if(para == 5){
            		Ques_Answer.selType[0].checked = true;
            		resultDiv.style.display = "none";
            		document.getElementById("Objectivity_step4").style.display = "none";
            		document.getElementById("selViewTrTable").style.display = "block";
            		document.getElementById("Objectivity").style.display = "block";   
        		} else{
            		Ques_Answer.selType[1].checked = true;
            		resultDiv.style.display = "block";
            		document.getElementById("Objectivity_step4").style.display = "block";
            		document.getElementById("selViewTrTable").style.display = "none";
            		document.getElementById("Objectivity").style.display = "none";
            		var option;
            		document.getElementById("horizon").innerHTML = "";
            		document.getElementById("vertical").innerHTML = "";
            		for (var i = 1; i <= 7; i++) {
                		option = document.createElement("option");
                		option.value = i;
                		option.text = i;
                		document.getElementById("horizon").appendChild(option);
            		}
            		for (var i = 1; i <= 7; i++) {
                		option = document.createElement("option");
                		option.value = i;
                		option.text = i;
                		document.getElementById("vertical").appendChild(option);
            		}
            		 if(document.getElementById("ResultTable") == null)
                 		createTable(pDataXml);  
        		}
    		}

    		function TypeDetermination(vdata) {
        		if(vdata == 5 || vdata == 6){
            		TypeArray(vdata);
            		return;
        		}
        		if(pBeforeCheck == vdata) {
        			return;
        		} else {
            		pBeforeCheck = vdata;
		            if (vdata == 1){ //객관식
        		        if (document.Ques_Answer.selView[0].checked) {
                    		Objectivity.style.display = "";
                    		Objectivity_step1.style.display="";
                    		Objectivity_step2.style.display="";
                    		Objectivity_step3.style.display="";
                    		document.Ques_Answer.sNum.value="";
                    		document.Ques_Answer.eNum.value="";
                    		document.Ques_Answer.sNum.disabled =true;
                    		document.Ques_Answer.eNum.disabled =true;
                    		document.Ques_Answer.MultiResponse.disabled =false;
                    		var TmpOption= new Option("", "",true);
                    		if (document.Ques_Answer.input_Ans.length == 0) {
                        		document.Ques_Answer.input_Ans.options[0] = TmpOption;
                    		}
                    		document.Ques_Answer.txtAnswer.value = "";
                		}
            		} else if(vdata == 2){ 
                		var viewcnt= parseInt(document.Ques_Answer.input_Ans.length);
                		if (viewcnt>0) {
                    		for(ii = viewcnt ; ii > -1 ; ii--) {
                        		document.Ques_Answer.input_Ans[ii] = null;
                    		}
                		}
                		if (document.Ques_Answer.selView[1].checked) {
                    		Objectivity.style.display = "none";
                    		Objectivity_step1.style.display="none";
                    		Objectivity_step2.style.display="none";
                    		Objectivity_step3.style.display="none";
                    		document.Ques_Answer.MultiResponse.checked=false;
                    		document.Ques_Answer.MultiResponse.disabled =true;
                    		document.Ques_Answer.sNum.value="";
                    		document.Ques_Answer.eNum.value="";
                    		document.Ques_Answer.sNum.disabled =true;
                    		document.Ques_Answer.eNum.disabled =true;
                		}	
            		} else if(vdata == 4) {
                		if (document.Ques_Answer.selView[3].checked ) {
                    		Objectivity.style.display = "";
                    		Objectivity_step1.style.display="";
                    		Objectivity_step2.style.display="";
                    		Objectivity_step3.style.display="";
                    		document.Ques_Answer.sNum.value="";
                    		document.Ques_Answer.eNum.value="";
                    		document.Ques_Answer.sNum.disabled =true;
                    		document.Ques_Answer.eNum.disabled =true;
                    		document.Ques_Answer.MultiResponse.checked=false;
                    		document.Ques_Answer.MultiResponse.disabled =true;					
                    		var TmpOption= new Option("", "",true);
                    		document.Ques_Answer.txtAnswer.value = "";
                		}
            		} else {
                		if (document.Ques_Answer.selView[2].checked) {
                    		Objectivity_step1.style.display="none";
                    		Objectivity_step2.style.display="none";
                    		Objectivity_step3.style.display="none";
                    		document.Ques_Answer.sNum.value="1";
                    		document.Ques_Answer.sNum.disabled =false;
                    		document.Ques_Answer.eNum.disabled =false;
                    		document.Ques_Answer.MultiResponse.checked=false;
                    		document.Ques_Answer.MultiResponse.disabled=true;
                    		document.Ques_Answer.txtAnswer.value = "";
                		}	
            		}
        		}
    		}
    		function fun_AddAns() {
        		if( document.Ques_Answer.txtQuestion.value == "" ) {
            		alert("<spring:message code='ezQuestion.t492' />");
            		document.Ques_Answer.txtQuestion.value = "";
            		document.Ques_Answer.txtQuestion.focus();
            		return;
        		}
        		if( document.Ques_Answer.txtAnswer.value == "" ) {
            		alert("<spring:message code='ezQuestion.t493' />");
            		document.Ques_Answer.txtAnswer.value = "";
            		document.Ques_Answer.txtAnswer.focus();
            		return;
        		}
        		if( CheckChar(document.Ques_Answer.txtAnswer.value) ) {
            		alert("<spring:message code='ezQuestion.t494' />");
            		return;
        		}
        		var idx = 0;
        		if( Ques_Answer.input_Ans[0].text != "" )
            		idx = Ques_Answer.input_Ans.length;
        		if( Ques_Answer.txtAnswer.value != "" ) {
            		var v_ans =  Ques_Answer.txtAnswer.value;
            		var TmpOption= new Option((idx+1) + "." + v_ans, v_ans, true);
            		Ques_Answer.input_Ans.options[idx] = TmpOption;
            		Ques_Answer.input_Ans.options[idx].AnsInfo = null;
        		}
        		Ques_Answer.txtAnswer.focus();	
        		Ques_Answer.txtAnswer.value = "";
    		}
    		function fun_AnsEdit() {
        		if( index == -1 ) {
            		alert("<spring:message code='ezQuestion.t496' />");
            		return;
        		}
        		if( document.Ques_Answer.input_Ans[0].text == "" ) {
            		alert("<spring:message code='ezQuestion.t496' />");
            		return;
        		}
        		if( document.Ques_Answer.txtQuestion.value == "" ) {
            		alert("<spring:message code='ezQuestion.t492' />");
            		document.Ques_Answer.txtQuestion.value = "";
            		document.Ques_Answer.txtQuestion.focus();
            		return;
        		}
        		if( document.Ques_Answer.txtAnswer.value == "" ) {
            		alert("<spring:message code='ezQuestion.t493' />");
            		document.Ques_Answer.txtAnswer.value = "";
            		document.Ques_Answer.txtAnswer.focus();
            		return;
        		}
        		if( CheckChar(document.Ques_Answer.txtAnswer.value) ) {
            		alert("<spring:message code='ezQuestion.t494' />");
            		return;
        		}
        		Ques_Answer.input_Ans[index].value = document.Ques_Answer.txtAnswer.value;
        		Ques_Answer.input_Ans[index].text = (index+1) + "." + document.Ques_Answer.txtAnswer.value;
        		Ques_Answer.txtAnswer.value = "";
    		}
    		function fun_AnsDelete() {
        		if( index != -1 ) {
            		var tmpArr = Ques_Answer.input_Ans[index].AnsInfo;
            		if( tmpArr != null ) {
                		for( var k = 0 ; k < tmpArr.type.length ; k++ ) {
                    		if( tmpArr.type[k] == "1" || tmpArr.type[k] == "2" )
                        		g_DelAttachList += tmpArr.href[k] + ";";
                		}
            		}		
            		Ques_Answer.input_Ans[index] = null;
            		for(i=index ; i < Ques_Answer.input_Ans.length ; i ++ )
                		Ques_Answer.input_Ans[i].text = (i+1) +"." + Ques_Answer.input_Ans[i].value
		            if (Ques_Answer.input_Ans.length == 0)
        		        Ques_Answer.input_Ans.length = 1;
            		index = -1;
            		Ques_Answer.txtAnswer.value = "";
        		}
    		}
    		function AnsOrder_Up() {
        		var _MSIE = 'MSIE';
        		var useragentstr = navigator.userAgent;
        		if (useragentstr.indexOf(_MSIE) != -1) {
            		if (index > 0) {
                		var tmpValue = Ques_Answer.input_Ans[index - 1].value;
                		var tmpArray = Ques_Answer.input_Ans[index-1].AnsInfo;
                		Ques_Answer.input_Ans[index-1].value = Ques_Answer.input_Ans[index].value;
                		Ques_Answer.input_Ans[index-1].text = (index) +"." + Ques_Answer.input_Ans[index].value;
                		Ques_Answer.input_Ans[index-1].AnsInfo = Ques_Answer.input_Ans[index].AnsInfo;
                		Ques_Answer.input_Ans[index].value = tmpValue;
                		Ques_Answer.input_Ans[index].text = (index+1) +"." + tmpValue;
                		Ques_Answer.input_Ans[index].AnsInfo = tmpArray;
                		Ques_Answer.input_Ans.selectedIndex = index-1;
                		index --;
            		}
        		} else {
            		if(typeof(g_windowReference) == 'undefined' || g_windowReference == null || g_windowReference.closed) {
                		if (index > 0) {
                    		var tmpValue = Ques_Answer.input_Ans[index - 1].value;
                    		var tmpArray = Ques_Answer.input_Ans[index-1].AnsInfo;
                    		Ques_Answer.input_Ans[index-1].value = Ques_Answer.input_Ans[index].value;
                    		Ques_Answer.input_Ans[index-1].text = (index) +"." + Ques_Answer.input_Ans[index].value;
                    		Ques_Answer.input_Ans[index-1].AnsInfo = Ques_Answer.input_Ans[index].AnsInfo;
                    		Ques_Answer.input_Ans[index].value = tmpValue;
                    		Ques_Answer.input_Ans[index].text = (index+1) +"." + tmpValue;
                    		Ques_Answer.input_Ans[index].AnsInfo = tmpArray;
                    		Ques_Answer.input_Ans.selectedIndex = index-1;
                    		index --;
                		}
            		} else{
                		g_windowReference.focus();
            		}
        		}
    		}
    		function AnsOrder_Down() {
        		var _MSIE = 'MSIE';
        		var useragentstr = navigator.userAgent;
        		if (useragentstr.indexOf(_MSIE) != -1) {
            		if (index < (Ques_Answer.input_Ans.length - 1)  && index != -1) {
                		var tmpValue = Ques_Answer.input_Ans[index + 1].value;
                		var tmpArray = Ques_Answer.input_Ans[index + 1].AnsInfo;
                		Ques_Answer.input_Ans[index+1].value = Ques_Answer.input_Ans[index].value;
                		Ques_Answer.input_Ans[index+1].text = (index+2) +"." + Ques_Answer.input_Ans[index].value;
                		Ques_Answer.input_Ans[index+1].AnsInfo = Ques_Answer.input_Ans[index].AnsInfo;
                		Ques_Answer.input_Ans[index].value = tmpValue;
                		Ques_Answer.input_Ans[index].text = (index + 1) +"." + tmpValue;
                		Ques_Answer.input_Ans[index].AnsInfo = tmpArray;
                		Ques_Answer.input_Ans.selectedIndex = index+1;
                		index ++;
            		}
        		} else{
            		if(typeof(g_windowReference) == 'undefined' || g_windowReference == null || g_windowReference.closed) {
                		if (index < (Ques_Answer.input_Ans.length - 1)  && index != -1) {
                    		var tmpValue = Ques_Answer.input_Ans[index + 1].value;
                    		var tmpArray = Ques_Answer.input_Ans[index + 1].AnsInfo;
                    		Ques_Answer.input_Ans[index+1].value = Ques_Answer.input_Ans[index].value;
                    		Ques_Answer.input_Ans[index+1].text = (index+2) +"." + Ques_Answer.input_Ans[index].value;
                    		Ques_Answer.input_Ans[index+1].AnsInfo = Ques_Answer.input_Ans[index].AnsInfo;
                    		Ques_Answer.input_Ans[index].value = tmpValue;
                    		Ques_Answer.input_Ans[index].text = (index + 1) +"." + tmpValue;
                    		Ques_Answer.input_Ans[index].AnsInfo = tmpArray;
                    		Ques_Answer.input_Ans.selectedIndex = index+1;
                    		index ++;
                		}
            		} else{
                		g_windowReference.focus();
            		}
        		}
    		}
    		function Form_Check() {
        		if (document.Ques_Answer.txtQuestion.value=="") {
            		alert("<spring:message code='ezQuestion.t492' />");
            		return false;
        		}
        		if (document.Ques_Answer.selView[0].checked) {
            		if (document.Ques_Answer.input_Ans.length < 1) {	
                		alert("<spring:message code='ezQuestion.t493' />");
                		return false;
            		}
            		if (document.Ques_Answer.input_Ans[0].text=="") {
                		alert("<spring:message code='ezQuestion.t493' />");
                		return false;
            		}
        		} else if (document.Ques_Answer.selView[1].checked) {
		        } else if (document.Ques_Answer.selView[2].checked) {
            		if(document.Ques_Answer.sNum.value=="" || document.Ques_Answer.eNum.value=="") {
                		alert("<spring:message code='ezQuestion.t501' />")
                		document.Ques_Answer.sNum.focus();
                		return false;
            		}
            		var rtnValue=IsNumeric(trim_Cross(document.Ques_Answer.sNum.value));
            		if (!rtnValue) {
                		alert("<spring:message code='ezQuestion.t502' />");
                		Ques_Answer.sNum.value="";
                		Ques_Answer.sNum.focus();
                		return false;
            		}	
            		rtnValue=IsNumeric(trim_Cross(document.Ques_Answer.eNum.value));
            		if (!rtnValue) {
                		alert("<spring:message code='ezQuestion.t502' />");
                		Ques_Answer.eNum.value="";
                		Ques_Answer.eNum.focus();
                		return false;
            		}	
            		if(parseInt(Ques_Answer.sNum.value) >= parseInt(Ques_Answer.eNum.value)) {
                		alert("<spring:message code='ezQuestion.t503' />");
                		Ques_Answer.eNum.value="";
                		Ques_Answer.eNum.focus();
                		return false;
            		}	
        		} else if (document.Ques_Answer.selView[3].checked) {
            		if (document.Ques_Answer.input_Ans.length < 1) {	
                		alert("<spring:message code='ezQuestion.t493' />");
                		return false;
            		}
            		if (document.Ques_Answer.input_Ans[0].text=="") {
                		alert("<spring:message code='ezQuestion.t493' />");
                		return false;
            		}
        		} else {
            		alert("<spring:message code='ezQuestion.t504' />")
            		return false;
        		}
    		}
    		function GetAttachList(objInfo) {
        		var strRet = "";
        		if(CrossYN()) {
            		if(trim_Cross(objInfo) != "") {
                		strRet = objInfo;
            		}
        		} else{
            		if(objInfo) {
                		strRet = objInfo;
            		}
        		}
        		return strRet;
    		}
    		function fun_QuesSave() {
        		if(Ques_Answer.selType[0].checked){
            		if (Form_Check()==false)
                		return;
        		} else{
            		if(document.getElementById("ResultTable") == null){
                		alert("<spring:message code='ezQuestion.t493' />");
                		return;
            		}
        		}
        		var sviewno = 0;
        		var eviewno = 0;
        		var multi = 0;
        		var v_viewtype = "1";
        		var viewcnt = Ques_Answer.input_Ans.length;
        		var xmlDoc = createXmlDom();
        		var objNode;
        		var RootNode = createNodeInsert(xmlDoc, objNode, "ROW");
        		createNodeAndInsertCDataText(xmlDoc, objNode, "QUESTIONCONTENT", document.Ques_Answer.txtQuestion.value);
        		if (Ques_Answer.txtQuestion.AnsInfo != null && Ques_Answer.txtQuestion.AnsInfo != null && typeof (Ques_Answer.txtQuestion.AnsInfo) != "undefined") {
            		var _MSIE = 'MSIE';
            		var useragentstr = navigator.userAgent;
            		if (useragentstr.indexOf(_MSIE) != -1) {
		                if (Ques_Answer.txtQuestion.AnsInfo != null) {
        		            attachQ = GetAttachList_ie(Ques_Answer.txtQuestion.AnsInfo);
                		    xmlDoc.documentElement.appendChild(SelectSingleNode(attachQ, "ATTACH"))
                		}

		                if (viewcnt > 0) {
        		            for (var ii = 0 ; ii < viewcnt ; ii++) {
                		        view += Ques_Answer.input_Ans[ii].text + ";";

                        		if (Ques_Answer.input_Ans[ii].AnsInfo != null) {
                            		attach += GetAttachList_ie(Ques_Answer.input_Ans[ii].AnsInfo).xml;
                        		}

                        		attach += "^";
                    		}
                		}
            		} else{
                		var xmlDom_Attach = loadXMLString(Ques_Answer.txtQuestion.AnsInfo);
                		xmlDoc.documentElement.appendChild(xmlDoc.importNode(SelectSingleNode(xmlDom_Attach, "ATTACH"), true));
            		}
        		}
        		if (document.Ques_Answer.selView[2].checked && Ques_Answer.selType[0].checked) {
            		sviewno = trim_Cross(document.Ques_Answer.sNum.value);
            		eviewno = trim_Cross(document.Ques_Answer.eNum.value);
            		view = "NO";
            		v_viewtype = "3"
        		} else if (document.Ques_Answer.selView[1].checked && Ques_Answer.selType[0].checked) {
            		view="NO";
            		v_viewtype = "2"
        		} else if (document.Ques_Answer.selView[3].checked && Ques_Answer.selType[0].checked) {
            		v_viewtype = "4"
        		} else if(Ques_Answer.selType[1].checked) {
            		v_viewtype = "5"
        		}

		        createNodeAndInsertText(xmlDoc, objNode, "ANSWERTYPE", v_viewtype);
        
        		if (document.Ques_Answer.MultiResponse.checked)
            		multi=1;
        		
        		createNodeAndInsertText(xmlDoc, objNode, "MULTISELECT", multi);
        		createNodeAndInsertText(xmlDoc, objNode, "SELVIEWSTART", sviewno);
        		createNodeAndInsertText(xmlDoc, objNode, "SELVIEWEND", eviewno);

        		if(Ques_Answer.selType[0].checked){
					var inputAns = "";
            		if (viewcnt > 0) {
                		var DeptNode = null;
                		for(var ii=0 ; ii < viewcnt ; ii++) {
                    		DeptNode = null;
                    		DeptNode = createNodeAndAppandNode(xmlDoc, RootNode, objNode, "ANSWER");
                    		createNodeAndAppandNodeText(xmlDoc, DeptNode, objNode, "ANSWERTITLE", Ques_Answer.input_Ans[ii].value);

                    	if (Ques_Answer.input_Ans[ii].AnsInfo != null) {
                        		var xmlDom_AnswerAttach;
		                        if (CrossYN()) {
        		                    xmlDom_AnswerAttach = loadXMLString(Ques_Answer.input_Ans[ii].AnsInfo);
                		            if (document.importNode) {
                        		        var imported = xmlDoc.importNode(SelectSingleNode(xmlDom_AnswerAttach, "ATTACH"), true);
                                		if (imported) {
                                    		DeptNode.appendChild(imported);
                                		} else {
                                		}
                            		} else {
                                		var importedNode = SelectSingleNode(xmlDom_AnswerAttach, "ATTACH").cloneNode(true);
                                		DeptNode.appendChild(importedNode);
                            		}
                        		} else {
		                            xmlDom_AnswerAttach = GetAttachList_ie(Ques_Answer.input_Ans[ii].AnsInfo);
        		                    DeptNode.appendChild(SelectSingleNode(xmlDom_AnswerAttach, "ATTACH"));
                        		}
                    		}
                		}
		            }
        		    else if (v_viewtype == 2) {
                		var DeptNode = createNodeAndAppandNode(xmlDoc, RootNode, objNode, "ANSWER");
                		createNodeAndAppandNodeText(xmlDoc, DeptNode, objNode, "ANSWERTITLE", "");
            		}
        		} else{
            		var table = document.getElementById("ResultTable");
            		var DeptNode = null;
            		for(var i =1; i<table.childNodes.length;i++){
                		DeptNode = createNodeAndAppandNode(xmlDoc, RootNode, objNode, "ANSWER");
                		createNodeAndAppandNodeText(xmlDoc, DeptNode, objNode, "ANSWERTITLE", table.childNodes[i].childNodes[0].getElementsByTagName("input")[0].value); // i+1
                		DeptNode = null;
            		}
            		for(var j = 1 ; j<table.childNodes[0].childNodes.length;j++){
                		DeptNode = createNodeAndAppandNode(xmlDoc, RootNode, objNode, "ANSWER_ANSWER");
                		createNodeAndAppandNodeText(xmlDoc, DeptNode, objNode, "ANSWER_TITLE", table.childNodes[0].childNodes[j].getElementsByTagName("input")[0].value); // i+1
                		DeptNode = null;
            		}
        		}
		        var view = "";
		        var attach = "";
        		var attachQ = "";
        		if (Ques_Answer.txtQuestion.AnsInfo != null) {
            		if(CrossYN()) {
            			attachQ = GetAttachList(Ques_Answer.txtQuestion.AnsInfo);
            		} else {
            			attachQ = GetAttachList_ie(Ques_Answer.txtQuestion.AnsInfo).xml;
            		}
                		
        		}
        		if(Ques_Answer.selType[0].checked){
		            if (viewcnt > 0) {
        		        for(var ii=0 ; ii < viewcnt ; ii++) {
                		    view += Ques_Answer.input_Ans[ii].text +  ";";

                    		if( Ques_Answer.input_Ans[ii].AnsInfo != null ) {
                        		if(CrossYN()) {
                        			attach += GetAttachList(Ques_Answer.input_Ans[ii].AnsInfo);
                        		} else {
                        			attach += GetAttachList_ie(Ques_Answer.input_Ans[ii].AnsInfo).xml;
                        		}
                    		}
                    		attach += "^";
		                }
            		}
        		}
        		var pAttachYN = "";
        		attach = attach.replace(/\^/g, "");
        		if ( trim(attach) != "" &&  trim(attachQ) != "" ) {
            		pAttachYN =  "Y";
        		} else {
            		pAttachYN = "";
        		}
		
        		if(pEditIndex != "") {
             		window.opener.EditQues(Ques_Answer.txtQuestion.value,pEditIndex, pAttachYN, getXmlString(xmlDoc)); 
        		} else {
            		window.opener.AddQuesList_DATA(Ques_Answer.txtQuestion.value, pAttachYN, getXmlString(xmlDoc));
        		}
        		window.close();
    		}
    		function GetAttachList_ie(objInfo) {
        		var strRet = "";
        		var xmlpara = createXmlDom();
        		if (typeof (objInfo.type) != "undefined") {
            		var objRoot, objRow, objNode;
		            objRoot = createNodeInsert(xmlpara, objRoot, "ATTACH");
            		if (objInfo.type.length > 0) {
                		var attachcnt = objInfo.type.length;
                		for (var jj = 0 ; jj < attachcnt ; jj++) {
                    		objRow = createNodeAndAppandNode(xmlpara, objRoot, objRow, "ROW");
                    		objNode = createNodeAndAppandNodeText(xmlpara, objRow, objNode, "TYPE", objInfo.type[jj]);
                    		objNode = createNodeAndAppandNodeText(xmlpara, objRow, objNode, "ATTACHTITLE", objInfo.attachTitle[jj]);         ////////
                    		objNode = createNodeAndAppandNodeText(xmlpara, objRow, objNode, "HREF", objInfo.href[jj]);
                		}
            		}
        		}

        		return xmlpara;
    		}
    		function fun_QuesCancel() {
        		window.self.close();
    		}
    		function fun_SelClick() {
        		if(Ques_Answer.input_Ans.selectedIndex >= 0) {
            		index = Ques_Answer.input_Ans.selectedIndex;
            		Ques_Answer.txtAnswer.value = Ques_Answer.input_Ans.options[index].value;
        		}
    		}
    		function IsNumeric(vdata) {
        		var num="0123456789"; 	
        		var returnValue = true;
        		for (var i=0 ; i < vdata.length; i++) { 
            		if (-1 == num.indexOf(vdata.charAt(i))) {
                		returnValue = false;
                		break;
            		} else {
            			returnValue=true;
            		}
        		}
        		return returnValue;
    		}
    		function fun_SetAns(pID, pCmd) {
        		var rgParams = new Array();
        		rgParams["m_Return"] = "";
        		rgParams["m_AttachInfo"] = null;
        		rgParams["m_DelAttach"] = g_DelAttachList;
        		if( pID == "A" ) {
            		if( pCmd == "MOD" && index == -1 ) {
                		alert("<spring:message code='ezQuestion.t496' />");
                		return;
            		}
            		if( pCmd == "MOD" && document.Ques_Answer.input_Ans[0].text == "" ) {
                		alert("<spring:message code='ezQuestion.t496' />");
                		return;
            		}
            		if( pCmd == "MOD" ) {
                		if (Ques_Answer.input_Ans.options[index].AnsInfo == undefined) {
                			rgParams["m_AttachInfo"] = Ques_Answer.input_Ans.options[index].getAttribute("ansinfo")
                		} else {
                			rgParams["m_AttachInfo"] = Ques_Answer.input_Ans.options[index].AnsInfo;
                		}
            		}
        		} else {
            		var td_QuestionText = "";
            		if (navigator.userAgent.indexOf("Firefox")>-1) {
                		var ret = td_Question.innerHTML;
                		ret = ret.replace(/&nbsp;/ig," ");
                		ret = ret.replace(/<br>/ig,"\n");
                		ret = ret.replace(/<br[^>]+>/ig,"\n");
                		ret = ret.replace(/<[^>]+>/g,"");
                		td_QuestionText = ret;
            		} else{
                		td_QuestionText = td_Question.innerText;
            		}
            		if(td_QuestionText != ""){
                		if(Ques_Answer.txtQuestion.AnsInfo == undefined) {
                			rgParams["m_AttachInfo"] = Ques_Answer.txtQuestion.getAttribute("ansinfo");
                		} else {
                			rgParams["m_AttachInfo"] = Ques_Answer.txtQuestion.AnsInfo;
                		}
            		}
        		}
        		var _MSIE = 'MSIE';
        		var useragentstr = navigator.userAgent;
        		if (useragentstr.indexOf(_MSIE) != -1) {
            		var szParam = "dialogHeight:370px; dialogWidth:500px; status:no;scroll:no; help:no; edge:sunken" + GetShowModalPosition(500, 370);
            		var szUrl = "/ezQuestion/qstAttachNonActX.do?idName=" + pID;
            		var rv = window.showModalDialog(szUrl, rgParams, szParam);
            		if (rgParams["m_Return"] == "OK") {
                		if (pID == "A") {
                    		var tmpIdx;
                    		if (pCmd == "MOD") {
                    			tmpIdx = index;
                    		} else {
                        		if (document.Ques_Answer.input_Ans[0].text == "") {
                        			tmpIdx = 0;
                        		} else {
                        			tmpIdx = Ques_Answer.input_Ans.options.length;
                        		}
                    		}
                    		Ques_Answer.input_Ans.options[tmpIdx].AnsInfo = rgParams["m_AttachInfo"];
                		} else {
                    		td_Question.innerText = "";

		                    if (rgParams["m_AttachInfo"] != null) {
        		                Ques_Answer.txtQuestion.AnsInfo = rgParams["m_AttachInfo"];
                		        var tmpText = "";
                        		for (var count = 0; count < rgParams["m_AttachInfo"].attachTitle.length; count++) {
                            		var pTitle = rgParams["m_AttachInfo"].attachTitle[count]
                            		tmpText += pTitle + ";";
                        		}
                        		xmlDom = null;
                        		td_Question.innerHTML = tmpText;
                    		} else {
                        		//Ques_Answer.txtQuestion.AnsInfo = null;
                    		}
                		}
                		g_DelAttachList = rgParams["m_DelAttach"];
            		}
        		} else {
            		if ((g_windowReference == null) || (g_windowReference.closed == true)) {
                		var szUrl = "/ezQuestion/qstAttachNonActX.do?idName=" + pID;
                		g_windowReference = window.open("","AttachAdd","height=370px,width=500px,resizable=no,center=yes" + GetOpenPosition(500, 370));                
                		document.AttachAdd.m_AttachInfo.value = rgParams["m_AttachInfo"];
                		document.AttachAdd.m_AttachType.value = pID;
                		document.AttachAdd.m_AttachMode.value = pCmd;
                		document.AttachAdd.m_AttachModIndex.value = index;
                		document.AttachAdd.method="post";
                		document.AttachAdd.action=szUrl;
                		document.AttachAdd.target="AttachAdd";
                		document.AttachAdd.submit();
            		}
            		g_windowReference.focus();
        		}
    		}
    		function AttachComplete_NonIE(pID, pCmd, pAttachXml, pAttachModeIndex) {
        		if( pID == "A" ) {
            		var tmpIdx;
            		if( pCmd == "MOD" ) {
            			tmpIdx = parseInt(pAttachModeIndex);
            		} else {
                		if( document.Ques_Answer.input_Ans[0].text == "" ) {
                			tmpIdx = 0;
                		} else {
                			tmpIdx = Ques_Answer.input_Ans.options.length;
                		}
            		}
            		Ques_Answer.input_Ans.options[tmpIdx].AnsInfo = pAttachXml;
        		} else {
            		td_Question.innerText = "";
            		if(pAttachXml != "" ) {
                		Ques_Answer.txtQuestion.AnsInfo = pAttachXml;
                		var pAttachInfo = pAttachXml;
                		var xmlDom = createXmlDom();
                		xmlDom = loadXMLString(pAttachInfo);
                		var tmpText = "";
                		var lastindex = SelectNodes(xmlDom, "ATTACH/ROW").length;
                		for (var count=0; count<lastindex; count++) {
                    		var pTitle  = SelectSingleNodeValue(SelectNodes(xmlDom, "ATTACH/ROW")[count], "ATTACHTITLE");
                    		tmpText += pTitle + ";";
                		}
                		xmlDom = null;
                		td_Question.innerHTML = tmpText;
            		} else {
                		Ques_Answer.txtQuestion.AnsInfo = null;
            		}
        		}
    		}
    		function CheckChar(pVal) {
        		if( pVal.indexOf(";") > -1 || pVal.indexOf("|") > -1 || pVal.indexOf("^") > -1 ) {
            		return true;
        		}
		        return false;
    		}
    
		    var vertical_no, horizon_no;
    		function createTable(pXmlString) {
        		var pDataXml = createXmlDom();
        		if (pXmlString != undefined)
            		pDataXml = loadXMLString(pXmlString);

		        var div = document.getElementById("ResultDiv");
		        var horizon = document.getElementById("horizon");
		        var vertical = document.getElementById("vertical");

        		if (pXmlString != undefined) {
            		horizon.value = pDataXml.getElementsByTagName("ANSWER").length;
            		vertical.value = pDataXml.getElementsByTagName("ANSWER_ANSWER").length;
        		}

		        div.innerHTML = "";
        		var oTable = document.createElement("TABLE");
        		var oTr = document.createElement("TR");
        		var oTd = document.createElement("TD");
        		var oTh = document.createElement("TH");
        		var radioBtn = document.createElement("input");

		        oTable.setAttribute("style", "width:100%;");
		        oTable.setAttribute("id", "ResultTable");
		        vertical_no = vertical.value;
		        horizon_no = horizon.value;

		        for (var j = 0; j <= horizon.value; j++) {
            		for (var i = 0; i <= vertical.value; i++) {
                		if (j == 0) {
                    		oTh = document.createElement("TH");
                    		if (i != 0) {
                        		if (pXmlString != undefined) {
                        			oTh.innerHTML = "<a class='imgbtn'><span onclick='DelVertical(this)'><spring:message code='ezQuestion.t177' /></span></a><br/><input onclick='CleareText(this)' type='text' value='" + getNodeText(pDataXml.getElementsByTagName("ANSWER_TITLE")[i - 1]) + "' style='width:70px;' maxlength='50'/>";                        			
                        		} else {
                        			oTh.innerHTML = "<a class='imgbtn'><span onclick='DelVertical(this)'><spring:message code='ezQuestion.t177' /></span></a><br/><input onclick='CleareText(this)' type='text' value='<spring:message code='ezQuestion.t910027' /> " + i + "' style='width:70px;' maxlength='50'/>";                        			
                        		}
                    		} else {
                    			oTh.innerHTML = "";
                    		}
                    		oTh.setAttribute("style", "text-align:center;width:150px;");
                    		oTr.appendChild(oTh);
                    		oth = null;
		                } else if (i == 0 && j != 0) {
                    		oTh = document.createElement("TH");
                    		if (pXmlString != undefined) {
                    			oTh.innerHTML = "<a class='imgbtn'><span onclick='DelHorizon(this)'><spring:message code='ezQuestion.t177' /></span></a> <input onclick='CleareText(this)' type='text' value='" + getNodeText(pDataXml.getElementsByTagName("TITLE")[j - 1]) + "' style='width:70px;' maxlength='50'/>";
                    		} else {
                        		oTh.innerHTML = "<a class='imgbtn'><span onclick='DelHorizon(this)'><spring:message code='ezQuestion.t177' /></span></a> <input onclick='CleareText(this)' type='text' value='<spring:message code='ezQuestion.t910026' /> " + j + "' style='width:70px;' maxlength='50'/>";
                    		}
                    		oTh.setAttribute("style", "text-align:center;");
                    		oTr.appendChild(oTh);
                    		oth = null;
                		} else {
                    		oTd = document.createElement("TD");
                    		radioBtn = document.createElement("input");
                    		radioBtn.setAttribute("type", "radio");
                    		radioBtn.setAttribute("name", "radio" + j);
                    		radioBtn.setAttribute("disabled", "true")
                    		oTd.setAttribute("style", "border: 1px solid #b6b6b6;text-align:center;");
                    		oTd.appendChild(radioBtn);
                    		oTr.appendChild(oTd);
                    		oTd = null;
                		}
            		}
            		oTable.appendChild(oTr);
            		oTr = document.createElement("TR");
        		}
        		div.appendChild(oTable);
    		}
	
    		function DelVertical(e) {
        		var num;
        		var table = document.getElementById("ResultTable");
        		if (table.childNodes[0].childNodes.length == 2) {
            		alert("<spring:message code='ezQuestion.t910029' />");
            		return;
        		}

		        var Tr = e.parentElement.parentElement.parentElement;
        		for (var i = 0; i < Tr.childNodes.length; i++) {
            		if (Tr.childNodes[i] == e.parentElement.parentElement) {
                		num = i;
                		break;
            		}
        		}

		        Tr.removeChild(e.parentElement.parentElement);
        		for (var i = 1; i < table.childNodes.length; i++) {
            		table.childNodes[i].removeChild(table.childNodes[i].childNodes[num]);
        		}
    		}

		    function DelHorizon(e) {
        		var table = e.parentElement.parentElement.parentElement.parentElement;
        		if (table.childNodes.length == 2) {
            		alert("<spring:message code='ezQuestion.t910028' />");
            		return;
        		}
        		table.removeChild(e.parentElement.parentElement.parentElement);
    		}
    		var beforeText = "";
    
		    function CleareText(e) {
        		if (e != beforeText) {
            		beforeText = e;
            		e.select();
        		}
    		}

		    function createHorizon() {
        		horizon_no++;
        		var table = document.getElementById("ResultTable");
        		if (table == null)
            		return;
        		var oTr = document.createElement("TR");
        		var oTh = document.createElement("TH");
        		var oTd, oRadioBtn;
        		oTh.innerHTML = "<a class='imgbtn'><span id='horizon_" + horizon_no + "' onclick='DelHorizon(this)'><spring:message code='ezQuestion.t177' /></span></a> <input onclick='CleareText(this)' type='text' value='<spring:message code='ezQuestion.t910026' />' style='width:70px;' maxlength='50' />";
        		oTr.appendChild(oTh);
        		for (var i = 0; i < table.childNodes[0].childNodes.length - 1; i++) {
            		oTd = document.createElement("TD");
            		oRadioBtn = document.createElement("input");
            		oRadioBtn.setAttribute("type", "radio")
            		oRadioBtn.setAttribute("disabled", "true")
            		oTd.appendChild(oRadioBtn);
            		oTd.setAttribute("style", "border: 1px solid #b6b6b6;text-align:center;");
            		oTr.appendChild(oTd);
        		}
        		table.appendChild(oTr);
    		}

		    function createVetical() {
		        vertical_no++;
		        var table = document.getElementById("ResultTable");
		        if (table == null)
            		return;
        		var oTr, oTh, oTd, oRadioBtn;

		        for (var i = 0; i < table.childNodes.length; i++) {
            		oTr = table.childNodes[i];
            		if (i == 0) {
                		oTh = document.createElement("TH");
                		oTh.innerHTML = "<a class='imgbtn'><span onclick='DelVertical(this)'><spring:message code='ezQuestion.t177' /></span></a><br/><input onclick='CleareText(this)' type='text' value='<spring:message code='ezQuestion.t910027' />' style='width:70px;' maxlength='50'/>";
                		oTh.setAttribute("style", "text-align:center;width:150px;");
                		oTr.appendChild(oTh);
            		} else {
                		oTd = document.createElement("TD");
                		oRadioBtn = document.createElement("input");
                		oRadioBtn.setAttribute("type", "radio");
                		oRadioBtn.setAttribute("disabled", "true");
                		oTd.appendChild(oRadioBtn);
                		oTd.setAttribute("style", "border: 1px solid #b6b6b6;text-align:center;");
                		oTr.appendChild(oTd);
            		}
        		}
    		}
		</script>
	</head>
	<body class="popup" style="overflow:auto">
    	<form name="Ques_Answer" method="post" action="">
        	<div id="menu">
            	<ul><li><span onclick="javascript:fun_QuesSave();"><spring:message code='ezQuestion.t516' /></span></li></ul>
        	</div>
        	<div id="close">
            	<ul><li><span onclick="javascript:fun_QuesCancel();"><spring:message code='ezQuestion.t88' /></span></li></ul>
        	</div>
        	<script type="text/javascript">
            	selToggleList(document.getElementById("menu"), "ul", "li", "0");
            	selToggleList(document.getElementById("close"), "ul", "li", "0");
        	</script>
        	<table class="content"> <!------------------ 질문 ------------------------->
            	<tr>
                	<th rowspan="2"><spring:message code='ezQuestion.t333' /></th>
                	<td class="pos1"><input type="text" size="9" maxlength="500" style="WIDTH:100%" name="txtQuestion" value="${questionAddVO.questionContent}" AnsInfo="${questionAddVO.pQstAnsInfo}" /></td>
                	<td class="pos2"><a class="imgbtn"><span onclick="javascript:fun_SetAns('Q', 'MOD');"><spring:message code='ezQuestion.t154' /></span></a></td>
            	</tr>
            	<tr>
                	<td colspan="2"><div name="td_Question" id="td_Question" style="overflow-y:auto;HEIGHT:17px" class="viewtxt">${questionAddVO.pQstAttach}</div></td>
            	</tr>

            	<tr>
                	<th><spring:message code='ezQuestion.t50001' /></th>
                	<td colspan="2">
	                    <input type="radio" name="selType" onclick="TypeArray(5)" value="default" /><spring:message code='ezQuestion.t50002' />
    	                <input type="radio" name="selType" onclick="TypeArray(6)" value="table"/><spring:message code='ezQuestion.t50003' />
        	        </td>
            	</tr>
	        </table>

    	    <table id="selViewTrTable" class="content" style="margin-top:10px; border:0px;">
        	    <tr>
            	    <th rowspan="3"><spring:message code='ezQuestion.t517' /></th>
                	<td colspan="2">
                    	<input onclick="javascript:TypeDetermination(1)" type="radio" value="1" name="selView" style="vertical-align:-2px;"/><spring:message code='ezQuestion.t487' />
                    	<input type="checkbox" value="0" name="MultiResponse" disabled="disabled" style="vertical-align:-2px;"/>
                    	<%-- <%if(userinfo.lang != "3"){ %> --%>
                    	<spring:message code='ezQuestion.t518' />
                    	<%-- <%}%> --%>
                    	<spring:message code='ezQuestion.t519' />
	                </td>
    	        </tr>
	            <tr>
    	            <td colspan="2"><input onclick="javascript:TypeDetermination(2)" type="radio" value="2" name="selView" checked=checked style="vertical-align:-2px;"/><spring:message code='ezQuestion.t372' /></td>
        	    </tr>
            	<tr>
                	<td colspan="2">    <!-------------- 보기선택형(우선순위) ----------------->
                    	<input style="DISPLAY: none; WIDTH: 50px" type="text" value="1" name="sNum">
                    	<input style="DISPLAY: none; WIDTH: 50px" type="text" name="eNum">
                    	<input type="radio" name="selView" value="3" style="vertical-align:-2px;DISPLAY:none" onclick="javascript:TypeDetermination(3)">
                    	<input onclick="javascript:TypeDetermination(4)" type="radio" value="4" name="selView" style="vertical-align:-2px;"><spring:message code='ezQuestion.t373' />
                	</td>
            	</tr>
        	</table>

        	<table class="content" id="Objectivity" style="margin-top:10px; border:0px;">  <!----------------------- 객관식 보기 입력 부분 --------------------------------->
	            <tr id="Objectivity_step2" style="DISPLAY:none">
    	            <th><spring:message code='ezQuestion.t523' /></th>
        	        <td>
            	        <table border="0" style="width:100%">
                	        <tr>
                    	        <td>
                        	        <a class="imgbtn"><span onclick="javascript:fun_AddAns();"><spring:message code='ezQuestion.t176' /></span></a>
                            	    <a class="imgbtn"><span onclick="javascript:fun_AnsEdit();"><spring:message code='ezQuestion.t480' /></span></a>
                                	<a class="imgbtn"><span onclick="javascript:fun_AnsDelete();"><spring:message code='ezQuestion.t177' /></span></a>
                                	<a class="imgbtn"><span onclick="javascript:fun_SetAns('A', 'MOD');"><spring:message code='ezQuestion.t154' /></span></a>
                            	</td>
                            	<td style="text-align:right; white-space:nowrap"><spring:message code='ezQuestion.t525' /></td>
                            	<!------------ 위로 -------------->
                            	<td><a onclick="javascript:AnsOrder_Up();"><img src="/images/arr_up.gif" width="16" height="16" border="0"></a></td>
                            	<!------------ 아래로 -------------->
                            	<td><a onclick="javascript:AnsOrder_Down();"><img src="/images/arr_down.gif" width="16" height="16" border="0"></a></td>
                        	</tr>
                    	</table>
                	</td>
            	</tr>
            	<tr id="Objectivity_step1" style="DISPLAY:none">
	                <th><spring:message code='ezQuestion.t528' /></th>
    	            <td><input type="text" size="9" maxlength="500" style="WIDTH:100%" name="txtAnswer" /></td>
        	    </tr>
            	<tr id="Objectivity_step3" style="DISPLAY:none">
                	<th></th>
                	<td>
	                    <select AnsInfo name="input_Ans" id="input_Ans" size="4" onclick="javascript:fun_SelClick();" style="WIDTH:100%;HEIGHT:100px">${questionAddVO.pSelectOption}</select>
    	            </td>
        	    </tr>
        	</table>
        	<table id="Objectivity_step4" class="content" style="margin-top: 10px; border:0px;">
	            <tr>
    	            <th><spring:message code='ezQuestion.t91001' /></th>
        	        <td><spring:message code='ezQuestion.t91002' />&nbsp;
            	        <select id="horizon">
                	    </select>
                    	&nbsp;*&nbsp;<spring:message code='ezQuestion.t910021' /> &nbsp;
                    	<select id="vertical">
                    	</select>
                    	&nbsp;&nbsp;
                    	<a class="imgbtn"><span onclick="createTable()"><spring:message code='ezQuestion.t910023' /></span></a>
                    	<a class="imgbtn"><span onclick="createVetical()"><spring:message code='ezQuestion.t910024' /></span></a>
                    	<a class="imgbtn"><span onclick="createHorizon()"><spring:message code='ezQuestion.t910025' /></span></a>
                	</td>
            	</tr>
        	</table>
        	<div id="ResultDiv" style="margin-top: 10px; width: 100%; height: 220px; overflow: auto; display:none;"></div>
    	</form>
    	<form method="post" action="" name="AttachAdd" id="AttachAdd">
	        <input type="hidden" name="m_AttachInfo" id="m_AttachInfo" />
    	    <input type="hidden" name="m_AttachType" id="m_AttachType" />
        	<input type="hidden" name="m_AttachMode" id="m_AttachMode" />
        	<input type="hidden" name="m_AttachModIndex" id="m_AttachModIndex" />
    	</form>
	</body>
</html>