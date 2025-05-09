<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link href="${util.addVer('/css/theme01.css')}" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
			var xmlhttp = createXMLHttpRequest();
	        var arr_userinfo = new Array();
	        arr_userinfo[0] = "user";
	        arr_userinfo[1] = "${userInfo.id}";
	        arr_userinfo[2] = "${userInfo.displayName1}";
	        arr_userinfo[3] = "${userInfo.title1}";
	        arr_userinfo[4] = "${userInfo.deptID}";
		    arr_userinfo[5] = "${userInfo.deptName1}";
		    arr_userinfo[6] = "${userInfo.jikChek}";
		    arr_userinfo[8] = "${userInfo.email}";  
	        var pUserID = arr_userinfo[1];
	        var companyID = "${userInfo.companyID}";
	        var pListTypeValue = "1";
	        var pUse_Editor = "${useEditor}";
	        var strlang = "${userInfo.lang}";
	        var strLang1 = "<spring:message code='main.t00026' />";
	        var pNoneActiveX = "${noneActiveX}";
	        var selTab = "";
	        
	        window.onload = window_onload;
	        
	        function window_onload() {
	            getAppr();
	            selTab = "doingTab";
	            
	            try { top.onresize() } catch (e) { }
	        }

	        function getAppr() {
	            var xmlpara = createXmlDom();
	            var objNode;
	            createNodeInsert(xmlpara, objNode, "PARAMETER");
	            createNodeAndInsertText(xmlpara, objNode, "pListTypeName", pListTypeValue);
	            createNodeAndInsertText(xmlpara, objNode, "pDocTypeName", "A01000");
	            createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);
	            createNodeAndInsertText(xmlpara, objNode, "pUserDeptID", arr_userinfo[4]);
	            createNodeAndInsertText(xmlpara, objNode, "pPageSize", "1000");
	            createNodeAndInsertText(xmlpara, objNode, "pPageNum", "1");
	            createNodeAndInsertText(xmlpara, objNode, "companyID", companyID);
	            createNodeAndInsertText(xmlpara, objNode, "orderCell", "");
	            createNodeAndInsertText(xmlpara, objNode, "orderOption", "");
	            createNodeAndInsertText(xmlpara, objNode, "SearchQuery", "");
	            createNodeAndInsertText(xmlpara, objNode, "SubQuery", "");

	            xmlhttp = null;
	            xmlhttp = createXMLHttpRequest();
	            
	            if ("${userApprovalG}" == "YES") {
	            	$.ajax({
	      	        	type : "POST",
	      	        	dataType : "text",
	      	        	url : "/ezApprovalG/getPortletAprDocList.do",
	      	        	data : {
	      	        		pListTypeName   : pListTypeValue, 
	      	        		pDocTypeName 	 : "A01000", 
	      	        		pUserID 	 : pUserID, 
	      	        		pUserDeptID 	 : arr_userinfo[4], 
	      	        		pPageSize : "1000",
	      	        		pPageNum : "1",
	      	        		companyID : companyID,
	      	        		orderCell : "",
	      	        		orderOption : "",
	      	        		searchQuery : "",
	      	        		subQuery : ""
	      	        	},
	      	        	success : function(xml){		        		
	      	        		getDocList_after(loadXMLString(xml));
	      	        	},
	      	        	error : function(error){
	      	        		console.log("<spring:message code='ezBoard.t22'/>wpNewApprMail" + error);	
	      	        	}
	      	        });
	            } else {
	       		 $.ajax({
	       	        	type : "POST",
	       	        	dataType : "text",
	       	        	url : "/ezApproval/getPortletAprDocList.do",
	       	        	data : {
	       	        		pListTypeName   : pListTypeValue, 
	       	        		pDocTypeName 	 : "A01000", 
	       	        		pUserID 	 : pUserID, 
	       	        		pUserDeptID 	 : arr_userinfo[4], 
	       	        		pPageSize : "1000",
	       	        		pPageNum : "1",
	       	        		companyID : companyID,
	       	        		orderCell : "",
	       	        		orderOption : "",
	       	        		searchQuery : "",
	       	        		subQuery : ""
	       	        	},
	       	        	success : function(xml){
	       	        		getDocList_after(loadXMLString(xml));
	       	        	},
	       	        	error : function(error){
	       	        		console.log("<spring:message code='ezBoard.t22'/>wpNewApprMail2" + error);	
	       	        	}
	       	        });	
	            }
	        }
	        
	        function getDocList_after(xml) {
	        	if (xml == null) return;
	            try {
	                document.getElementById("apr_list").innerHTML = "";

	                var listHTML = "";
	                var xmldom = xml;
	                if (pListTypeValue == "1") {
	                    document.getElementById("count1").innerHTML = "(" + getNodeText(xmldom.getElementsByTagName("TOTALCNT1").item(0)) + ")";
	                    document.getElementById("count2").innerHTML = "(" + getNodeText(xmldom.getElementsByTagName("TOTALCNT3").item(0)) + ")";
	                    document.getElementById("count3").innerHTML = "(" + getNodeText(xmldom.getElementsByTagName("TOTALCNT2").item(0)) + ")";
	                }

	                if (xmldom.getElementsByTagName("CELL").length > 0) {
	                    for (var i = 0; i < 5; i++) {
	                        if (i == xmldom.getElementsByTagName("CELL").length) break;
	                        var DOCTITLE = getNodeText(xmldom.getElementsByTagName("DOCTITLE").item(i));
	                        var WRITERNAME = getNodeText(xmldom.getElementsByTagName("WRITERNAME").item(i));
	                        var STARTDATE = getNodeText(xmldom.getElementsByTagName("STARTDATE").item(i));

	                        var DOCID = getNodeText(xmldom.getElementsByTagName("DOCID").item(i));
	                        var HREF = getNodeText(xmldom.getElementsByTagName("HREF").item(i));
	                        var APRMEMBERID = getNodeText(xmldom.getElementsByTagName("APRMEMBERID").item(i));
	                        var APRMEMBERNAME = getNodeText(xmldom.getElementsByTagName("APRMEMBERNAME").item(i));
	                        var APRMEMBERDEPTID = getNodeText(xmldom.getElementsByTagName("APRMEMBERDEPTID").item(i));
	                        var DOCSTATE = getNodeText(xmldom.getElementsByTagName("DOCSTATE").item(i));
	                        var FUNCTIONTYPE = getNodeText(xmldom.getElementsByTagName("FUNCTIONTYPE").item(i));
	                        listHTML += "<li style='cursor: pointer;' onclick=\"opendocview('" + DOCID + "','" + HREF + "','" + APRMEMBERID + "','" + APRMEMBERNAME + "','" + APRMEMBERDEPTID + "','" + DOCSTATE + "','" + FUNCTIONTYPE + "')\"><span class='title'>" + DOCTITLE + "</span> <span class='name'>" + WRITERNAME + "</span> <span class='date'>" + STARTDATE + "</span></li>";
	                    }
	                }
	                else {
	                        listHTML = "<div class='nodata_w'>";
	                        listHTML += "<p><img src='/images/kr/theme01/main/nodata_gray.png'></p>";
	                        listHTML += "<p>" + strLang1 + "</p>";
	                        listHTML += "</div>";
	                    }
	                    document.getElementById("apr_list").innerHTML = listHTML;

	                }
	                catch (e) {
	                }
	            }
	        
	            function Appmore_btnClick() {
                	var mainUrl = "";
	                if ("${userApprovalG}" == "YES"){
	                    if (pListTypeValue != "2")
                            mainUrl = "/ezApprovalG/apprGMain.do?listType=1";
	                    else
                            mainUrl = "/ezApprovalG/apprGMain.do?listType=2";
	                }
	                else {
	                    if (pListTypeValue != "2")
                            mainUrl = "/ezApprovalG/apprGMain.do?listType=1";
	                    else
                            mainUrl = "/ezApprovalG/apprGMain.do?listType=2";
	                }
                    parent.document.querySelector("iframe[name=main]").src = mainUrl;
                }
	            
	            function apprChangeTab(obj) {
	                switch (obj.id) {
	                    case "doingTab":
	                        pListTypeValue = "1";
	                        selTab = "doingTab";
	                        document.getElementById("doingTab").className = "on";
	                        document.getElementById("rejectTab").className = "";
	                        document.getElementById("draftTab").className = "";
	                        break;

	                    case "rejectTab":
	                        pListTypeValue = "4";
	                        selTab = "rejectTab";
	                        document.getElementById("doingTab").className = "";
	                        document.getElementById("rejectTab").className = "on";
	                        document.getElementById("draftTab").className = "";
	                        break;

	                    case "draftTab":
	                        pListTypeValue = "2";
	                        selTab = "draftTab";
	                        document.getElementById("doingTab").className = "";
	                        document.getElementById("rejectTab").className = "";
	                        document.getElementById("draftTab").className = "on";
	                        break;
	                }
	                getAppr();
	            }

	            function openApprovUI(pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType) {

	                var pArgument = new Array();
	                pArgument[0] = pDocID;
	                pArgument[1] = pAprMemberID;
	                pArgument[2] = pAprMemberName;
	                pArgument[3] = pAprMemberDeptID;

	                var formURL = pHref;
	                if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "doc") {
	                    openLocation = "/myoffice/ezApprovalG/ezViewWord/ezAproveUI_word_Cross.aspx?DocID=" + escape(pArgument[0]);
	                    openLocation = openLocation + "&uID=" + escape(pArgument[1]) + "&uName=" + escape(pArgument[2]);
	                    openLocation = openLocation + "&uDeptID=" + escape(pArgument[3]) + "&AllFlag=0";
	                } else if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "hwp") {
	                	if (isIE()) {
		                    openLocation = "/ezApprovalG/approvuiHWP.do?docID=" + escape(pArgument[0]);
		                    openLocation = openLocation + "&uID=" + escape(pArgument[1]) + "&uName=" + escape(pArgument[2]);
		                    openLocation = openLocation + "&uDeptID=" + escape(pArgument[3]) + "&AllFlag=0" + "&docState=" + escape(pDocState);
	                	} else {
	                		var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
	                        alert(pAlertContent);
	                        
	                        return;
	                	}
	                } else {
                        openLocation = "/ezApprovalG/approvui.do?docID=";
	                    openLocation = openLocation + escape(pArgument[0]);
	                    openLocation = openLocation + "&id=" + escape(pArgument[1]) + "&name=" + escape(pArgument[2]);
	                    openLocation = openLocation + "&deptID=" + escape(pArgument[3]) + "&allFlag=0" + "&docState=" + escape(pDocState);
	                }
	                openwindow(openLocation, "", 880, 550);
	            }

	            function openViewDocInfo(pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType) {
	                var pArgument = new Array();
	                var formURL = pHref;
	                var DocID = pDocID;
	                pArgument[0] = DocID;
	                pArgument[1] = formURL;
	                pArgument[2] = "";
	                pArgument[3] = pDocState;
	                pArgument[4] = "";
	                pArgument[5] = "";
	                pArgument[6] = "OPINION_SHOW";
	                pArgument[7] = "2";

	                var openLocation;
	                if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "doc") {
	                    openLocation = "/myoffice/ezApprovalG/ezViewWord/ezViewApr_Word_Cross.aspx?DocID=" + escape(pArgument[0]) + "&DocHref=" + escape(pArgument[1]);
	                    openLocation = openLocation + "&OpinionFlag=" + escape(pArgument[2]) + "&docState=" + escape(pArgument[3]) + "&ListSusin=" + escape(pArgument[4]) + "&odoc=" + escape(pArgument[5]);
	                    openLocation = openLocation + "&isOpinion=" + escape(pArgument[6]);
	                    openLocation = openLocation + "&ListType=" + escape(pArgument[7]);
	                }
	                else if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "hwp") {
	                	if (isIE()) {
		                    openLocation = "/ezApprovalG/ezviewAprHWP.do?docID=" + escape(pArgument[0]) + "&docHref=" + escape(pArgument[1]);
		                    openLocation = openLocation + "&opinionFlag=" + escape(pArgument[2]) + "&docState=" + escape(pArgument[3]) + "&listSusin=" + escape(pArgument[4]) + "&odoc=" + escape(pArgument[5]);
		                    openLocation = openLocation + "&isOpinion=" + escape(pArgument[6]);
		                    openLocation = openLocation + "&listType=" + escape(pArgument[7]);
	                	} else {
	                		var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
	                        alert(pAlertContent);
	                        
	                        return;
	                	}
	                }
	                else {
                    	openLocation = "/ezApprovalG/aprDocView.do?docID=";
	                    openLocation = openLocation + escape(pArgument[0]) + "&docHref=" + escape(pArgument[1]);
	                    openLocation = openLocation + "&opinionFlag=" + escape(pArgument[2]) + "&docState=" + escape(pArgument[3]) + "&ListSusin=" + escape(pArgument[4]) + "&odoc=" + escape(pArgument[5]);
	                    openLocation = openLocation + "&isOpinion=" + escape(pArgument[6]);
	                    openLocation = openLocation + "&listType=" + escape(pArgument[7]);
	                }

	                openwindow(openLocation, "", 880, 570);
	            }

	            function OpenReceiveDraftUI(pDocID, pURL, pDraftFlag) {
	                var openLocation;

	                if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "doc") {
	                    openLocation = "/myoffice/ezApprovalG/ezViewWord/ezDeptRecevUI_word_Cross.aspx?DocID=" + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag);
	                }
	                else if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "hwp") {
	                    openLocation = "/myoffice/ezApprovalG/ezViewHWP/ezDeptRecevUI_HWP_Cross.aspx?DocID=" + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag);
	                }
	                else {

	                    if (CrossYN()) {
	                        openLocation = "/myoffice/ezApprovalG/ReceivUI/recev_CK.aspx?DocID=";
	                    }
	                    else {
	                    	openLocation = "/myoffice/ezApprovalG/ReceivUI/recev_TFI.aspx?DocID=";
	                    }

	                    openLocation = openLocation + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag);
	                }
	                openwindow(openLocation, "receive", 880, 550);
	            }

	            function opendocview(pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType) {
	                var openLocation = "";

	                if ("${userApprovalG}" == "YES") {
	                    if (pListTypeValue != "2") {
	                        if (pFunctionType == "004" || pFunctionType == "006" || pFunctionType == "015") {
	                            if (pDocState == "012" || pDocState == "014" || pDocState == "018") {
	                                OpenReceiveDraftUI(pDocID, pHref, "REDRAFT");
	                            }
	                            else {
	                                openDraftUI("REDRAFT", pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType);
	                            }
	                        }
	                        else
	                            openApprovUI(pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType);
	                    }
	                    else {
	                        openViewDocInfo(pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType);

	                    }
	                }
	                else {
	                    if (pListTypeValue != "2") {
	                        if (pFunctionType == strAprState4 || pFunctionType == strAprState6 || pFunctionType == strAprState15) {
	                            if (pDocState == strDocState12 || pDocState == strDocState14 || pDocState == strDocState18) {
	                                var pDraftFlag = "REDRAFT";
	                                if (pHref.substr(pHref.length - 3, pHref.length).toLowerCase() == "doc") {
	                                    openLocation = "/myoffice/ezApproval/ezViewWord/ezDeptRecevUI_word.aspx?DocID=" + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag);
	                                }
	                                else if (pHref.substr(pHref.length - 3, pHref.length).toLowerCase() == "hwp") {
	                                    openLocation = "/myoffice/ezApproval/ezViewHWP/ezDeptRecevUI_HWP.aspx?DocID=" + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag);
	                                }
	                                else {
	                                	<% if (request.getHeader("User-Agent").indexOf("MSIE") > -1 || request.getHeader("User-Agent").indexOf("Trident") > -1)
	 	                               		{%>
	                                    var openLocation = "";
	                                    
	                                    if (pNoneActiveX == "YES") {
	                                        openLocation = "/myoffice/ezApproval/ReceivUI/recev_Cross.aspx?DocID=" + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag);
	                                    } else {
	                                    	openLocation = "/myoffice/ezApproval/ReceivUI/recev.aspx?DocID=" + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag);
	                                    }
	                                    <%}
	                                       else
	                                       { %>
	                                    openLocation = "/myoffice/ezApproval/ReceivUI/recev_Cross.aspx?DocID=" + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag);
	                                    <%}%>
	                                }
	                            }
	                            else if (pDocState == strDocState11) {
	                                var pDraftFlag = "REDRAFT";
	                                var openLocation = "";

	                                if (pHref.substr(pHref.length - 3, pHref.length).toLowerCase() == "doc") {
	                                    openLocation = "/myoffice/ezApproval/ezViewWord/ezRecevUI_word.aspx?DocID=" + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag);
	                                }
	                                else if (pHref.substr(pHref.length - 3, pHref.length).toLowerCase() == "hwp") {
	                                    openLocation = "/myoffice/ezApproval/ezViewHWP/ezRecevUI_HWP.aspx?DocID=" + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag);
	                                }
	                                else {
	                                    <% if (request.getHeader("User-Agent").indexOf("MSIE") > -1 || request.getHeader("User-Agent").indexOf("Trident") > -1)
	                               		{%>
	                                    if (pNoneActiveX == "YES") {
	                                        openLocation = "/myoffice/ezApproval/ReceivUI/Recev_End_Cross.aspx?DocID=" + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag);
	                                    }
	                                    else {
	                                    	openLocation = "/myoffice/ezApproval/ReceivUI/recev_end.aspx?DocID=" + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag);
	                                    }
	                                    <%}
	                                       else
	                                       { %>
	                                    openLocation = "/myoffice/ezApproval/ReceivUI/Recev_End_Cross.aspx?DocID=" + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag);
	                                    <%}%>
	                                }
	                            }
	                            else {
	                                var pDraftFlag = "REDRAFT";
	                                var tempDocState = strDocState1;
	                                var SusinSn = "0";
	                                if (pDocState == strDocState11) {
	                                    tempDocState = strDocState11;
	                                    SusinSn = "1";
	                                }

	                                var AprState = strAprState4;
	                                if (pFunctionType == strAprState6)
	                                    AprState = strAprState6;

	                                if (pHref.substr(pHref.length - 3, pHref.length).toLowerCase() == "doc") {
	                                    openLocation = "/myoffice/ezApproval/ezViewWord/ezDraftUI_word.aspx?formURL=" + escape(pHref) + "&DraftFlag=" + escape(pDraftFlag) + "&formDocType=";
	                                    openLocation = openLocation + "&susinSN=" + escape(SusinSn) + "&DocState=" + escape(tempDocState) + "&ListType=1&AprState=" + escape(AprState);
	                                    openLocation = openLocation + "&isTmpDoc=";
	                                }
	                                else if (pHref.substr(pHref.length - 3, pHref.length).toLowerCase() == "hwp") {
	                                    openLocation = "/myoffice/ezApproval/ezViewHWP/ezDraftUI_HWP.aspx?formURL=" + escape(pHref) + "&DraftFlag=" + escape(pDraftFlag) + "&formDocType=";
	                                    openLocation = openLocation + "&susinSN=" + escape(SusinSn) + "&DocState=" + escape(tempDocState) + "&ListType=1&AprState=" + escape(AprState);
	                                    openLocation = openLocation + "&isTmpDoc=";
	                                }
	                                else {
	                                    if (CrossYN() || pNoneActiveX == "YES") {
	                                        openLocation = "/myoffice/ezApproval/DraftUI/Draftui_Cross.aspx?formURL=" + escape(pHref) + "&DraftFlag=" + escape(pDraftFlag) + "&formDocType=";
	                                        openLocation = openLocation + "&susinSN=" + escape(SusinSn) + "&DocState=" + escape(tempDocState) + "&ListType=1&AprState=" + escape(AprState);
	                                        openLocation = openLocation + "&isTmpDoc=";
	                                    }
	                                    else {
                                            openLocation = "/myoffice/ezApproval/DraftUI/Draftui.aspx?formURL=" + escape(pHref) + "&DraftFlag=" + escape(pDraftFlag) + "&formDocType=";
	                                        openLocation = openLocation + "&susinSN=" + escape(SusinSn) + "&DocState=" + escape(tempDocState) + "&ListType=1&AprState=" + escape(AprState);
	                                        openLocation = openLocation + "&isTmpDoc=";
	                                    }
	                                }
	                            }
	                        }
	                        else {
	                            if (pHref.substr(pHref.length - 3, pHref.length).toLowerCase() == "doc") {
	                                var openLocation = "/myoffice/ezApproval/ezViewWord/ezAproveUI_word.aspx?DocID=" + escape(pDocID);
	                                openLocation = openLocation + "&uID=" + escape(pAprMemberID) + "&uName=" + escape(pAprMemberName);
	                                openLocation = openLocation + "&uDeptID=" + escape(pAprMemberDeptID);
	                            }
	                            else if (pHref.substr(pHref.length - 3, pHref.length).toLowerCase() == "hwp") {
	                                var openLocation = "/myoffice/ezApproval/ezViewHWP/ezAproveUI_HWP.aspx?DocID=" + escape(pDocID);
	                                openLocation = openLocation + "&uID=" + escape(pAprMemberID) + "&uName=" + escape(pAprMemberName);
	                                openLocation = openLocation + "&uDeptID=" + escape(pAprMemberDeptID);
	                            }
	                            else {
	                                if (CrossYN() || pNoneActiveX == "YES") {
	                                    var openLocation = "/myoffice/ezApproval/ApprovUI/ApprovUI_Cross.aspx?DocID=" + escape(pDocID);
	                                    openLocation = openLocation + "&uID=" + escape(pAprMemberID) + "&uName=" + escape(pAprMemberName);
	                                    openLocation = openLocation + "&uDeptID=" + escape(pAprMemberDeptID);
	                                }
	                                else {
                                        var openLocation = "/myoffice/ezApproval/ApprovUI/Approvui.aspx?DocID=" + escape(pDocID);
	                                    openLocation = openLocation + "&uID=" + escape(pAprMemberID) + "&uName=" + escape(pAprMemberName);
	                                    openLocation = openLocation + "&uDeptID=" + escape(pAprMemberDeptID);
	                                }
	                            }
	                        }
	                    }
	                    else {

	                        if (pHref.substr(pHref.length - 3, pHref.length).toLowerCase() == "doc") {
	                            var openLocation = "/myoffice/ezApproval/ezViewWord/ezViewApr_Word.aspx?DocID=" + escape(pDocID) + "&DocHref=" + escape(pHref);
	                            openLocation = openLocation + "&OpinionFlag=&docState=&ListSusin=&odoc=&isOpinion=&ListType=2";
	                        }
	                        else if (pHref.substr(pHref.length - 3, pHref.length).toLowerCase() == "hwp") {
	                            var openLocation = "/ezApprovalG/ezviewAprHWP.do?docID=" + escape(pDocID) + "&docHref=" + escape(pHref);
	                            openLocation = openLocation + "&opinionFlag=&docState=&listSusin=&odoc=&isOpinion=&listType=2";
	                        }
	                        else {
	                            <% if (request.getHeader("User-Agent").indexOf("MSIE") > -1 || request.getHeader("User-Agent").indexOf("Trident") > -1)
	                       		{%>
	                            if (pNoneActiveX == "YES") {
	                                var openLocation = "/myoffice/ezApp roval/aprDocView_Cross.aspx?DocID=" + escape(pDocID) + "&DocHref=" + escape(pHref);
	                                openLocation = openLocation + "&OpinionFlag=&docState=&ListSusin=&odoc=&isOpinion=&ListType=2";
	                            }
	                            else {
	                            	var openLocation = "/myoffice/ezApproval/AprDocView.aspx?DocID=" + escape(pDocID) + "&DocHref=" + escape(pHref);
									openLocation = openLocation + "&OpinionFlag=&docState=&ListSusin=&odoc=&isOpinion=&ListType=2";
	                            }
	                            <%}
	                               else
	                               { %>
	                            var openLocation = "/myoffice/ezApp roval/aprDocView_Cross.aspx?DocID=" + escape(pDocID) + "&DocHref=" + escape(pHref);
	                            openLocation = openLocation + "&OpinionFlag=&docState=&ListSusin=&odoc=&isOpinion=&ListType=2";
	                            <%}%>
	                        }
	                    }
	                    openwindow(openLocation);
	                }
	            }
	            function openwindow(wfileLocation) {
	                var height = window.screen.availHeight;
	                var width = window.screen.availWidth;
	                var left = 0;
	                var top = 0;

	                if (window.screen.width > 800) {
	                    var pleftpos;
	                    pleftpos = parseInt(width) - 967;
	                    height = parseInt(height) - 30;
	                    width = parseInt(width) - pleftpos;
	                    left = pleftpos / 2;
	                }
	                else {
	                    heigth = parseInt(height) - 30;
	                    width = parseInt(width) - 10;
	                }
	                window.open(wfileLocation, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + height + ",width=" + width + ",top=" + top + ",left = " + left);
	            }
	            
	            /* 2018-09-04 홍승비 - 탭메뉴 마우스오버 시 하이라이트 설정 */
		        function tabover(tabObj) {
		        	tabObj.setAttribute("class", "on");
		        }
		        function tabout(tabObj) {
		        	if (tabObj.id != selTab) {
		        		tabObj.setAttribute("class", "");
		        	}
		        }
		        
		</script>
	</head>
	<body>
		 <div class="content_appr">
        	<dl class="content_title01">
            	<dt><spring:message code='main.t25'/></dt>
            	<dd onclick="Appmore_btnClick()"><spring:message code='main.t1008'/></dd>
        	</dl>
        	<ul class="content_tabTitle">
            	<li id="doingTab" class="on" onclick="apprChangeTab(this)" onmouseover="tabover(this)" onmouseout="tabout(this)">
                	<span class="title"><spring:message code='main.t302'/></span>
                	<span class="count" id="count1"></span>
            	</li>
            	<li id="rejectTab" class="" onclick="apprChangeTab(this)" onmouseover="tabover(this)" onmouseout="tabout(this)">
                	<span class="title"><spring:message code='main.t00004'/></span>
                	<span class="count" id="count2"></span>
            	</li>
            	<li id="draftTab" class="" onclick="apprChangeTab(this)" onmouseover="tabover(this)" onmouseout="tabout(this)">
                	<span class="title"><spring:message code='main.t304'/></span>
                	<span class="count" id="count3"></span>
            	</li>
        	</ul>
        	<ul class="content_list01" id="apr_list"></ul>
    	</div>
	</body>
</html>
