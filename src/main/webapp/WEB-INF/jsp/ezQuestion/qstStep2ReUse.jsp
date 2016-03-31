<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>Step2</title>
		<meta name="vs_defaultClientScript" content="JavaScript" />
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link rel="stylesheet" href="<spring:message code='ezQuestion.i1' />" type="text/css">
		<link rel="stylesheet" href="/css/default_kr.css" type="text/css" />
		<script src="https://code.jquery.com/jquery-1.10.2.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezQuestion/common.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript">
			var index = -1;
			var flgClose= true;
			var surveyState = "";
			var WinRef;
			var pNoneActiveX = "";
			var pBrdSubject = '${qstUserPollItemVO.content}';
			
			var m_rgParams4PostOption = new Array();
			m_rgParams4PostOption["delaySendDate"] = "";
			m_rgParams4PostOption["successMailSendFlag"] = "";
			
			var g_szUserID = "Useremail";
		    var displayname = "UserDisplayName";
		    var usermail = "UserEmail";
		    var usertitle = "UserTitle";
		    var userdept = "UserDepteName";
		    var g_senderinfo = "UserCompanyName"+" UserDepteName "+"UserTitle";
		    var v_brdid = "${qstUserPollItemVO.brdId}";
		    var v_itemid = "${qstUserPollItemVO}.itemNo";
			var surveyState = "";
			var WinRef;

			function Init_QuesAdd(vdata,vquesno) {
				if(frmCreate.selQues[0].text=="")
		    		i=0;
				else   
		    		i = frmCreate.selQues.length;
				var TmpOption1= new Option((i+1) + "." + vdata, vquesno,true);
				frmCreate.selQues.options[i] = TmpOption1;
			}
			function fun_Prev() {	
	    		if (!confirm("<spring:message code='ezQuestion.t453' />")) return;
	    		history.back();
			}
    		function AddQuesList_DATA(vdata, vAttachYN, QstXML) {
        		var selCnt=frmCreate.selQues.length;
        		if (selCnt > 0) {
            		while(1) {
                		if(selCnt > 1){
                    		if (frmCreate.selQues[frmCreate.selQues.length-1].text=="") {
                        		frmCreate.selQues.remove(frmCreate.selQues[frmCreate.selQues.length-1]);
		                    }
        		            else {
                		        break;
                    		}
                		}
                		else {
                    		break;
                		}
            		}			
        		}
        		var v_ques =  vdata;
        		if (selCnt > 0 ) {
            		if (frmCreate.selQues[0].text == "")
                		i = 0;
            		else 
                		i = frmCreate.selQues.length;
            		var TmpOption= new Option((i+1) + "." + v_ques, QstXML,true);

            		frmCreate.selQues.options[i] = TmpOption;
            		frmCreate.selQues.options[i].AttachYN = vAttachYN;
        		}
        		else {
            		var TmpOption= new Option((1) + "." + v_ques, QstXML,true);
            		frmCreate.selQues.options[0] = TmpOption;
            		frmCreate.selQues.options[0].AttachYN = vAttachYN;
        		}
    		}
    		function AddQuesList(vdata,vAttachYN) {
        		var selCnt=frmCreate.selQues.length;
		        if (selCnt > 0) {
		            while(1) {
                		if(selCnt > 1) {
                    		if (frmCreate.selQues[frmCreate.selQues.length-1].text=="") {
                        		frmCreate.selQues.remove(frmCreate.selQues[frmCreate.selQues.length-1]);
		                    }
        		            else {
                        		break;
                    		}
                		}
                		else {
                    		break;
                		}
            		}			
        		}
        		var v_ques =  vdata;
		        if (selCnt > 0 ){
        		    if (frmCreate.selQues[0].text == "")
                		i = 0;
            		else 
                		i = frmCreate.selQues.length;
		            var TmpOption= new Option((i+1) + "." + v_ques, i+1,true);
        		    frmCreate.selQues.options[i] = TmpOption;
		        }
		        else {
        		    var TmpOption= new Option((1) + "." + v_ques, 1,true);
            		frmCreate.selQues.options[0] = TmpOption;
        		}
    		}
    		function fun_OK() {

        		var Qlen = frmCreate.selQues.length;
        		var email = "";
                var name = "";
                var result = "";
                
        		if( Qlen == 0 ) {
            		alert("<spring:message code='ezQuestion.t456' />");
            		return;
        		}
        		if (frmCreate.selQues.options[0].text=="") {
        			alert("<spring:message code='ezQuestion.t456' />");	
            		return;
        		}	

        		var v_QuesID = "";

        		for (i=0; i < Qlen ; i++) {
            		v_QuesID += frmCreate.selQues[i].value + ";"
        		}
        		var xmlHttp = createXMLHttpRequest();
        		var xmlDoc = createXmlDom();
        		var objNode;
        		xmlDoc = loadXMLString(frmCreate.STEP1DATA.value);
        		var QuestionNode = createNode(xmlDoc, "QUESTION"); 

        		var pQstCnt = document.frmCreate.selQues.length;

        		for(var i = 0;i < pQstCnt; i++) {
            		 if(document.frmCreate.selQues[i].value != null && document.frmCreate.selQues[i].value != "" && typeof(document.frmCreate.selQues[i].value) != "undefined") {
                		var xmlDom_Question = loadXMLString(document.frmCreate.selQues[i].value);
                		var importedNode = SelectSingleNode(xmlDom_Question, "ROW").cloneNode(true);
                		QuestionNode.appendChild(importedNode);
            		}
        		}
        		xmlDoc.documentElement.appendChild(QuestionNode);
        		xmlHttp.open("POST","/ezQuestion/qstComplete.do",false);
        		xmlHttp.send(xmlDoc); 
        	 	if(getXmlString(xmlHttp.responseXML) == "")
            		alert("<spring:message code='ezQuestion.t263' />" + "\n" + "<spring:message code='ezQuestion.t264' />"); 
        		else {
            		var resultXML = xmlHttp.responseXML;
            		State = SelectSingleNodeValue(resultXML, "DATA");
            		/* if (State !="OK")
                		alert("<spring:message code='ezQuestion.t263' />" + "\n" + "<spring:message code='ezQuestion.t264' />"); 
            		else { */
                		menuQst_List();
            		//}		
        		}	
        		surveyState = "OK"; 
        			
    		}
    		function fun_Ques_UP() {
        		if (index > 0) {
            		var vsubdata1=trim_Cross(frmCreate.selQues[index-1].text).split(".");
            		var vsublen1=vsubdata1[0].length+1;
            		var tmpValue = trim_Cross(frmCreate.selQues[index -1].value);
            		var tmpText=frmCreate.selQues[index-1].text.substring(vsublen1);
            		var vsubdata=trim_Cross(frmCreate.selQues[index].text).split(".");
            		var vsublen=vsubdata[0].length+1;
            		frmCreate.selQues[index-1].value = trim_Cross(frmCreate.selQues[index].value);
            		frmCreate.selQues[index-1].text = index + "." + trim_Cross(frmCreate.selQues[index].text).substring(vsublen);
            		frmCreate.selQues[index].value = tmpValue;
            		frmCreate.selQues[index].text = index+1 + "." + tmpText;
            		frmCreate.selQues.selectedIndex = index-1;
            		index--;
        		}	
    		}
    		function fun_Ques_Down() {
        		if (index < (frmCreate.selQues.length - 1)  && index != -1) {
            		var vsubdata=trim_Cross(frmCreate.selQues[index+1].text).split(".");
            		var vsublen=vsubdata[0].length+1;
            		var tmpValue =trim_Cross(frmCreate.selQues[index +1].value);
            		var tmpText = trim_Cross(frmCreate.selQues[index+1].text).substring(vsublen);
            		var vsubdata1=trim_Cross(frmCreate.selQues[index].text).split(".");
            		var vsublen1=vsubdata1[0].length+1;
            		frmCreate.selQues[index+1].value = trim_Cross(frmCreate.selQues[index].value);
            		frmCreate.selQues[index+1].text = index+2 + "." + trim_Cross(frmCreate.selQues[index].text).substring(vsublen1);
            		frmCreate.selQues[index].value = tmpValue;
            		frmCreate.selQues[index].text = index+1 + "." + tmpText;
            		frmCreate.selQues.selectedIndex = index+1;
            		index ++;
        		}
    		}
    		function fun_QuesAdd() {
        		if (!WinRef || WinRef.closed) {
            		 WinRef = GetOpenWindow("qstStep2QuestionAdd.do?brd_id=5" + "&item_id='<c:out value='${qstUserPollItemVO.itemNo}'/>'" , "addques", 700, 440); 
		        }
		        else {
            		WinRef.focus();
            		return;
        		}		    
    		}
    		function fun_QuesEdit() {
        		if(frmCreate.selQues.selectedIndex >= 0) {
            		if (!WinRef || WinRef.closed) {
                		index = frmCreate.selQues.selectedIndex;
                		if (frmCreate.selQues[index].text == ""){
                    		alert("<spring:message code='ezQuestion.t461' />");
                    		return;
                		}
                		if (window.navigator.userAgent.indexOf("Safari") > 0 && window.navigator.userAgent.indexOf("Chrome") == -1)
                    		WinRef = window.open("", "addques", "width=700,height=430,location=no" + GetOpenPosition(700, 430));
                		else
                    		WinRef = window.open("", "addques", "width=700,height=430,location=no" + GetOpenPosition(700, 430));
                		document.QstEdit.DataXML.value = frmCreate.selQues[index].value;
                		document.QstEdit.DataIndex.value = index.toString();
                		document.QstEdit.method="post";
                		document.QstEdit.action = "qstStep2QuestionAdd.do?brd_id=" + '<c:out value='${qstUserPollItemVO.brdId}'/>' + "&item_id=" + '<c:out value='${qstUserPollItemVO.itemNo}'/>';
                		document.QstEdit.target="addques";
                		document.QstEdit.submit();

            		}
            		else {
                		WinRef.focus();
                		return;
            		}	
        		}
        		else {
            		alert("<spring:message code='ezQuestion.t461' />");
        		}
    		}
    		function EditQues(data, index, vAttachYN, QstXML) {
        		frmCreate.selQues[index].text=String(parseInt(index)+1) +"." + data;
        		frmCreate.selQues[index].value = QstXML;
        		frmCreate.selQues[index].AttachYN = vAttachYN;
    		}
    		function fun_QuesDelete() {
        		if (index == -1 ) return;
        		if (frmCreate.selQues.length <= 0 ) return;
        		if (frmCreate.selQues[index].text==""){
            		alert("<spring:message code='ezQuestion.t463' />");
            		return;
        		}	
        		var vdata=parseInt(frmCreate.selQues[index].value);
        		var curidxno=frmCreate.selQues.length 
        		for(jk = index;jk < curidxno - 1 ; jk++){
            		var tmpValue = frmCreate.selQues[jk+1].text.split(".");
            		frmCreate.selQues[jk].value = frmCreate.selQues[jk+1].value;
            		frmCreate.selQues[jk].text = jk+1 + "." + frmCreate.selQues[jk+1].text.substring(tmpValue[0].length+1);
        		}
        		frmCreate.selQues.remove(curidxno-1);
    		}
    		function fun_SelClick() {
        		if(frmCreate.selQues.selectedIndex >= 0) {
            		index = frmCreate.selQues.selectedIndex
        		}
    		}
    		function fun_Cancel() {
        		var compTemp = "";
        		compTemp = confirm("<spring:message code='ezQuestion.t434' />");
        		if (compTemp == true) {
            		surveyState = "CANCEL";
            		menuQst_List();
        		}
    		}
    		document.onselectstart = function () { return false; };
    		function window_onunload() {
        		if (navigator.userAgent.indexOf('Firefox') != -1) {
            		document.body.style.MozUserSelect = 'none';
            		document.body.style.WebkitUserSelect = 'none';
            		document.body.style.khtmlUserSelect = 'none';
            		document.body.style.oUserSelect = 'none';
            		document.body.style.UserSelect = 'none';
        		}
        		if (self.screenTop > 9000) {
            		if (surveyState != "OK" && surveyState != "PREV" && surveyState != "CANCEL") {
                		var xmlHttp = createXMLHttpRequest();
                		var xmlDoc = createXmlDom();
                		var objNode;
                		createNodeInsert(xmlDoc, objNode, "PARAMETER");
                		createNodeAndInsertText(xmlDoc, objNode, "BRD_ID", '<c:out value='${qstUserPollItemVO.brdId}'/>'); 
                		createNodeAndInsertText(xmlDoc, objNode, "ITEM_ID", '<c:out value='${qstUserPollItemVO.itemNo}'/>'); 
                		xmlHttp.open("POST","qstCancel.do",false);
                		xmlHttp.send(xmlDoc);
                		var resultXML = xmlHttp.responseXML;
                		State = SelectSingleNodeValue(resultXML, "DATA");
                		if (resultXML.xml=="")
                    		alert(desc10 + "\n" + desc2); 
                		else {
                    		if (State !="DELETE_OK"	)
                        		alert(desc10 + "\n" + desc2); 
                    		else {
                        		menuQst_List();
                    		}	
                		}
            		}
        		} else {
            		if (document.readyState == "complete") {
            		} else  if (document.readyState == "loading") {
                		if (surveyState != "OK" && surveyState != "PREV" && surveyState != "CANCEL") {
                    		var xmlHttp = createXMLHttpRequest();
                    		var xmlDoc = createXmlDom();
                    		var objNode;
                    		createNodeInsert(xmlDoc, objNode, "PARAMETER");
                    		createNodeAndInsertText(xmlDoc, objNode, "BRD_ID", '<c:out value='${qstUserPollItemVO.brdId}'/>');
                    		createNodeAndInsertText(xmlDoc, objNode, "ITEM_ID", '<c:out value='${qstUserPollItemVO.itemNo}'/>'); 
                    		xmlHttp.open("POST","qstCancel.do",false);
                    		xmlHttp.send(xmlDoc);
                    		var resultXML = xmlHttp.responseXML;
                    		State = SelectSingleNodeValue(resultXML, "DATA");
                    		if (resultXML.xml=="")
                        		alert(desc10 + "\n" + desc2); 
                    		else {
                        		if (State !="DELETE_OK"	)
                            		alert(desc10 + "\n" + desc2); 
                        		else {
                            		menuQst_List();
                        		}	
                    		}
                		}
            		}
        		}
    		}
    		function menuQst_List() {
        		if(CrossYN())
            		var szUrl = "/ezQuestion/qstList.do?brd_ID=5"
        		else
            		var szUrl = "/ezQuestion/qstList.do?brd_ID=5"
        		window.location.href = szUrl;	
    		}
    		function menuQst_FileOpen() {
        		if (window.ActiveXObject && pNoneActiveX == "NO") {
            		var ezUtil = new ActiveXObject( "EzUtil.MiscFunc.1" );
            		var fileName = ezUtil.OpenLoadDlg("Question files (*.qst)\0*.qst\0\0", "txt");	
            		if (fileName == "") return;
            		var ezUtil = new ActiveXObject( "EzUtil.MiscFunc.1" );
            		ezUtil.UseUTF8 = true;
            		var strQuestion = ezUtil.LoadTextFromFile(fileName);
            		ezUtil = null;
            		LoadTempQuestionData(strQuestion);
        		}
        		else {
            		document.all("cmuds").click();
        		}
    		}
    		function menuQst_tempSave() {
        		var cnt = frmCreate.selQues.length;
        		var pAttachYN = "";
		        if (cnt > 0) {
        		    var pContent = "<QUESTION>";
            		for (i = 0; i < cnt; i++) {
                		var xmlDom = createXmlDom();
                		xmlDom = loadXMLString(frmCreate.selQues[i].value);
                		var AttachNodeList = SelectNodes(xmlDom, "ATTACH");
                		if (AttachNodeList.length > 0)
                    		pAttachYN = "Y";
		                for (j = AttachNodeList.length - 1 ; j > -1; j--) {
        		            AttachNodeList[j].parentNode.removeChild(AttachNodeList[j]);
                		}
                		pContent += getXmlString(xmlDom);
            		}
            		pContent += "</QUESTION>";
		            if (pAttachYN == "Y") {
        		        alert("<spring:message code='ezQuestion.t470' />");
		                return;
        		    }
		            if (window.ActiveXObject && pNoneActiveX == "NO") {
        		        var fileObj = new ActiveXObject("EzUtil.MiscFunc.1");
                		var fileName = fileObj.OpenSaveDlg("Question files (*.qst)\0*.qst\0\0", "txt");
                		if (fileName != "") {
                    		fileObj.UseUTF8 = true;
                    		var bResult = fileObj.SaveTextToFile(fileName, pContent);
                    		fileObj.UseUTF8 = false;
                    		if (bResult == true) {
                        		alert("<spring:message code='ezQuestion.t471' />");
                    		}
                    		fileObj = null;
                		}
            		}
            		else {
                		document.getElementById("TempSaveData").value = pContent;
                		form_TempSave.submit();
            		}
        		}
        		else {
            		alert("<spring:message code='ezQuestion.t472' />");
        		}
    		}
				function removeQue() {
					var cnt;
					var max = frmCreate.selQues.length;
					for ( cnt = 0 ; cnt < max ; cnt ++ ) {
						frmCreate.selQues.removeChild(frmCreate.selQues.childNodes[0]);
					}
				}
				function TempFileOpen_onClick(thisObj) {
		    		if (typeof FileReader != "undefined") {
		        		var reader = new FileReader();
		        		reader.onloadend = function (evt) {
		            		LoadTempQuestionData(evt.target.result);
		        		};
		        		reader.readAsText(thisObj.files[0]);
		    		}
		    		else {
		        		ifrm_TempLoad_Safari
		        		form_TempLoad_Safari.submit();
		    		}
				}
				function LoadTempQuestionData(DataXML) {
		    		var xmlDom = createXmlDom();
		    		xmlDom = loadXMLString(DataXML);
		    		removeQue();
		    		for (i = 0 ; i < SelectNodes(xmlDom, "ROW").length ; i++) {
		        		var TmpOption = new Option((i + 1) + "." + SelectSingleNodeValue(SelectNodes(xmlDom, "ROW")[i], "QUESTIONCONTENT"), getXmlString(SelectNodes(xmlDom, "ROW")[i]), true);
		        		frmCreate.selQues.options[i] = TmpOption;
		    		}
		    		AttachFile.innerHTML = AttachFile.innerHTML;
				}
				
				function DelQuestion() {
		    		if (surveyState != "OK" && surveyState != "PREV" && surveyState != "CANCEL") {
		        		var xmlHttp = createXMLHttpRequest();
		        		var xmlDoc = createXmlDom();
		        		var objNode;
		        		createNodeInsert(xmlDoc, objNode, "PARAMETER");
		        		createNodeAndInsertText(xmlDoc, objNode, "BRD_ID", '<c:out value='${qstUserPollItemVO.brdId}'/>');
                		createNodeAndInsertText(xmlDoc, objNode, "ITEM_ID", '<c:out value='${qstUserPollItemVO.itemNo}'/>');
		        		xmlHttp.open("POST", "/ezQuestion/qstCancel.do", false);
		        		xmlHttp.send(xmlDoc);
		        		var resultXML = xmlHttp.responseXML;
		        		State = SelectSingleNodeValue(resultXML, "DATA");
		        		if (resultXML.xml == "")
		            		alert(desc10 + "\n" + desc2);
		        		else {
		            		if (State != "DELETE_OK")
		                		alert(desc10 + "\n" + desc2);
		            		else {
		                		menuQst_List();
		            		}
		        		}
		    		}
				}
				
				  function menuQst_tempSave_old() {
				        var xmlHttp = createXMLHttpRequest();

				        xmlHttp.open("POST", "callTempSave.do?brd_id=${qstUserPollItemVO.brdId}&item_id=${qstUserPollItemVO.itemNo}", false);
				            xmlHttp.send();
				        //alert(xmlHttp.responseText);
				            var tempxml = loadXMLString(xmlHttp.responseText);
				            if (xmlHttp.responseText != "") {
				                var result = getNodeText(tempxml.getElementsByTagName("DATA").item(0));
				                if (result != "") {
				                    return result;
				                }
				                else {
				                    alert("<spring:message code='ezQuestion.t472' />");
				                }
				            }
				            else {
				                alert("<spring:message code='ezQuestion.t473' />");
				            }
				        }
				  
				  function insert_item() {
			            var olditem_data = menuQst_tempSave_old();

			            if (olditem_data == "") {
			                alert("현재 작성된 질문이 없습니다.");
			            }
			            else {
			                olditem_Open(olditem_data);
			            }
			        }
				  
				  function olditem_Open(item_data) {
				        //alert("olditem_Open : "+item_data);
				        // 설문 불러 왔을때 마지막 설문 보기 오류 있어 수정 (2008.04.18 최주관)
				        //var strQuestion = "<DATA>" + item_data + "</DATA>";
				        // 설문 불러 왔을때 thml 테그 dom 로드시 오류 있어 수정 (2008.09.02 최주관)
				        var strQuestion = "<DATA><![CDATA[" + item_data + " ]]></DATA>";
				        //alert("strQuestion : "+strQuestion);
				        
				        var xmlHttp2 = createXMLHttpRequest();
				        var xmlDom2 = createXmlDom();
				
				        xmlDom2 = loadXMLString(strQuestion);
				
				        xmlHttp2.open("POST","callTempLoad.do?brd_id=${qstUserPollItemVO.brdId}&item_id=${qstUserPollItemVO.itemNo}" ,false);
				        xmlHttp2.send(xmlDom2)	
				
				        if ( xmlHttp2.responseText == "" ) return;

				        //alert("xmlHttp2.responseXML.xml : "+xmlHttp2.responseText);

				        var strResult = getNodeText(loadXMLString(xmlHttp2.responseText).getElementsByTagName("QUESTION").item(0)).split("| ");
			            //alert("strResult : "+strResult);
				
				        removeQue()
				        
				        var cnt;
				        var cnt2;

				        var j = 0;
				        for (var i = 0; i < loadXMLString(xmlHttp2.responseText).getElementsByTagName("ROW").length; i++) {
				            if (loadXMLString(xmlHttp2.responseText).getElementsByTagName("ROW")[i].getElementsByTagName("CONTENT").length > 0) {
				                strSeq = strResult[j + 1].split(';');
				                if (CrossYN())
				                    AddQuesList_DATA(strSeq[0], "", loadXMLString(xmlHttp2.responseText).getElementsByTagName("ROW").item(i).outerHTML);
				                else
				                    AddQuesList_DATA(strSeq[0], "", loadXMLString(xmlHttp2.responseText).getElementsByTagName("ROW").item(i).xml);
				                j++;
				            }
				        }

			            //for (cnt = 1 ; cnt < strResult.length+1 ; cnt++) {
			            //    for (cnt2 = 1; cnt2 < strResult.length; cnt2++) {
			            //        strSeq = strResult[cnt2].split(';');
			            //        if (cnt == strSeq[1]) {
			            //            AddQuesList_DATA(strSeq[0], "", loadXMLString(xmlHttp2.responseText).getElementsByTagName("ROW").item(cnt2-1).outerHTML);
			            //        }
			            //    }
			            //}
			        }

		</script>
	</head>
	<body class="mainbody">
		<form method="post" name="frmCreate" id="frmCreate" action="qstList.do?brd_id=5">
			<h1><spring:message code="ezQuestion.t436" /></h1>
			<div id="Main_List">
        		<div id="mainmenu">
            		<ul>
               			<li style="padding-left: 4px"><span onclick="javascript:fun_Cancel()"><spring:message code="ezQuestion.t130" /></span></li>
                		<li style="padding-left: 4px"><span onclick="javascript:menuQst_FileOpen()"><spring:message code="ezQuestion.t474" /></span></li>
                		<li style="padding-left: 4px"><span onclick="javascript:menuQst_tempSave()"><spring:message code="ezQuestion.t475" /></span></li>
            		</ul>
        		</div>
			    <script type="text/javascript">
           			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
       			</script>
       			<h2><spring:message code="ezQuestion.t476" /></span>- <spring:message code="ezQuestion.t477" /></h2>
       			<table width="100%" class="popuplist">
           			<!------------------ 설문제목 ------------------------>
           			<tr>
               			<th style="text-align: center; width: 70px"><spring:message code="ezQuestion.t255" /></th>
               			<td colspan="3">
                   			<input name="text" type="text" style="FONT-SIZE: 9pt; WIDTH: 98%;" readonly="true" value="<c:out value='${qstUserPollItemVO.title}'/>"/></td>
           			</tr>
           			<tr>
               			<th style="text-align: center"><spring:message code="ezQuestion.t479" /></th>
               			<td>
                   			<a class="imgbtn"><span onclick="javascript:fun_QuesAdd();"><spring:message code="ezQuestion.t176" /></span></a>
                   			<a class="imgbtn"><span onclick="javascript:fun_QuesEdit();"><spring:message code="ezQuestion.t480" /></span></a>
                   			<a class="imgbtn"><span onclick="javascript:fun_QuesDelete();"><spring:message code="ezQuestion.t177" /></span></a>
                		</td>
                		<th style="text-align: center; width: 100px"><spring:message code="ezQuestion.t481" /></th>
                		<td style="width: 250px; white-space: nowrap">
                    		<a onclick="fun_Ques_UP();">
                        		<img src="/images/arr_up.gif" width="16" height="16" border="0"></a>
                    		<a onclick="fun_Ques_Down();">
                        		<img src="/images/arr_down.gif" width="16" height="16" border="0"></a>
                		</td>
            		</tr>
            		<!------------------ 질문리스트 ------------------------>
            		<tr>
                		<td colspan="4" bgcolor="#f5f5f5">
                    		<select id="selQues" name="selQues" onclick="javascript:fun_SelClick();" ondblclick="javascript:fun_QuesEdit();" size="20" style="WIDTH: 100%; HEIGHT: 300px;"></select>
                		</td>
            		</tr>
        		</table>
        		<br>
        		<div class="btnposition">
            		<a class="imgbtn" name="Submit" onclick="javaScript:fun_Prev()"><span><spring:message code="ezQuestion.t483" /></span></a>
            		<a class="imgbtn" name="Submit2" onclick="fun_OK()"><span><spring:message code="ezQuestion.t484" /></span></a>
            		<a class="imgbtn" name="Submit3" onclick="fun_Cancel()"><span><spring:message code="ezQuestion.t38" /></span></a>
        		</div>
        		<input type="hidden" name="STEP1DATA" id="STEP1DATA" value="<c:out value='${requestScope.pStep1DataXML}'/>" />
			</div>
		</form>
	    	<div id="Privew_List" style="display: none;">
    	    	<div id="mainmenu">
        	    	<ul>
            	    	<li style="padding-left: 4px"><span onclick="Back_List()"><spring:message code="ezQuestion.t100002" /></span></li>
            		</ul>
        		</div>
        		<div id="Preview_Content">
        		</div>
    		</div>
			<form method="post" id="form_TempSave" name="form_TempSave" enctype="multipart/form-data" action="qstTempSave.do" target="_self">
		    	<input type="hidden" name="TempSaveData" id="TempSaveData" />
			</form>
			<form method="post" action="" name="QstEdit" id="QstEdit">
    			<input type="hidden" name="DataXML" id="DataXML" />
    			<input type="hidden" name="DataIndex" id="DataIndex" />
			</form>
			<form method="post" id="form_TempLoad_Safari" name="form_TempLoad_Safari" enctype="multipart/form-data" action="formTempLoadSafari.do" target="ifrm_TempLoad_Safari" style="width:1px; height:1px;">
    			<div id="AttachFile" style="width:1px; height:1px;">
        			<input type="file" name="cmuds" onchange="javascript:TempFileOpen_onClick(this)" style="width:1px; height:1px;" />
    			</div>
			</form>
		<iframe name="ifrm_TempLoad_Safari" src="about:blank" style="display:none"></iframe>
	</body>
</html>


