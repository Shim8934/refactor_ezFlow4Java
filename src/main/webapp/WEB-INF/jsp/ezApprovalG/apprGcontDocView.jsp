<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:97%">
	<head>
		<title><spring:message code='ezApprovalG.t367'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/getDocAttach_Cross.js"></script>
		<script type="text/javascript" src="/js/escapenew.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/conn_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/appandbody_Cross.js"></script>
		<script type="text/javascript" ID="clientEventHandlersJS">
		    var pDocID = '${docID}';
		    var pDocHref = '${docHref}';
		    var pListSusin = '${listSusin}';
		    var porgDocID = '${orgDocID}';
		    var pFormID = '${formID}';
		    var pTitle = '${docTitle}';
		    var pOpinionFlag;
		    var pListTypeValue = 4;
		    var flag = false;
		    var PrevOpinionFlag = false;
		    var NextOpinionFlag = true;
		    var doctitle = "";
		    var pOrgAttach = "";
		    var pendDir = "${endDir}";
		    var xmlhttp = createXMLHttpRequest();
		    var arr_userinfo = new Array();
		    arr_userinfo[0]  = "user";
		    arr_userinfo[1]  = "${userInfo.id}";
		    arr_userinfo[2]  = "${userInfo.displayName}";
		    arr_userinfo[3]  = "${userInfo.title}";
		    arr_userinfo[4]  = "${userInfo.deptID}";
		    arr_userinfo[5]  = "${userInfo.deptName}";
		    arr_userinfo[6]  = "${userInfo.jikChek}";
		    arr_userinfo[8]  = "${userInfo.email}";
		    arr_userinfo[9]  = "";
		    arr_userinfo[10] = "${susinAdmin}";
		    arr_userinfo[11]  = "${userInfo.displayName1}";
		    arr_userinfo[12]  = "${userInfo.displayName2}";
		    arr_userinfo[13]  = "${userInfo.title1}";
		    arr_userinfo[14]  = "${userInfo.title2}";
		    arr_userinfo[15]  = "${userInfo.deptName1}";
		    arr_userinfo[16]  = "${userInfo.deptName2}";
		    var companyID = "${userInfo.companyID}";
		    var pUserID = arr_userinfo[1];
		    var SignCheckFlag = "${signCheck}";
		    var pUse_Editor = "${editor}";
		    var NonActiveX = "YES";
		    $(function () {
			    if ("${pass}" != "<RESULT>TRUE</RESULT>") {
			        QuitWindow();
			    }
		    });
	
		    var aprendopinion_dialogArgument = new Array();
		    function btnOpinion_onclick() {
		        var parameter = new Array();
		        parameter[0] = pDocID;
		        parameter[1] = "Show";
		
		        aprendopinion_dialogArgument[0] = parameter;
		        aprendopinion_dialogArgument[1] = openOpinionUI_Complete;
		        DivPopUpShow(530, 520, "/ezApprovalG/aprEndOpinion.do");
		    }
		    function openOpinionUI_Complete() {
		        DivPopUpHidden();
		    }
		
		    function DocumentComplete() {
		        if (flag == false) {
		            flag = true;
		
		            if ("${pass}" != "<RESULT>TRUE</RESULT>") {
		                QuitWindow();
		            }
		            else {
		                if (pDocHref != "") {
		                    message.Set_EditorContentURL(pDocHref);
		                }
		            }
		            if (pFormID == "") {
		                document.getElementById("btnSave").style.display = "none";
		            }
		        }
		    }
		    function QuitWindow() {
// 		        OpenAlertUI(strLang929);
				alert(strLang1139);
		        btnClose_onclick();
		        window.close();
		    }
		    function CheckOpinionInfo() {
		    	var result = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/getEndOpinionInfo.do",
		    		data : {
		    			docID : pDocID
		    		},
		    		success: function(xml){
		    			result = loadXMLString(xml);
		    		}
		    	});
		
		        Resultxml = result;
		
		        var NodeList = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW");
		
		        if (NodeList.length != "0")
		            return true;
		        else
		            return false;
		    }
		    function FieldsAvailable() {
		        CheckSignImg();
		        if (SignCheckFlag == "N")
		            SignCheck();
		
		        var fields = message.GetFieldsList();
		        if (pListSusin == 1 || pListSusin == "") {
		            var field = message.GetListItem(fields, "susinhide");
		            if (field) {
		                field.style.display = 'none';
		            }
		
		            var field = message.GetListItem(fields, "susinhideP");
		            if (field) {
		                field.style.display = 'none';
		            }
		        }
		        else {
		            var field = message.GetListItem(fields, "drafthide");
		            if (field) {
		                field.style.display = 'none';
		            }
		        }
		        setAttachInfo(pDocID, "END", lstAttachLink);
		
		        var Rtnval = CheckOpinionInfo();
		        if (Rtnval) {
		            var pInformationContent = "<spring:message code='ezApprovalG.t9'/>" + "<br>" +"<spring:message code='ezApprovalG.t170'/>";
		            OpenInformationUI(pInformationContent, btnOpinion_onclick_Complete);
		        }
		    }
		
		    function btnOpinion_onclick_Complete(Ans) {
		        if (Ans) {
		            btnOpinion_onclick();
		        }
		        else {
		            DivPopUpHidden();
		        }
		    }
		
		    var PrtBodyContent;
		    function btnPrint_onclick() {
		        PrintClick("Cross", pDocID, "END");
		    }
		    function btnClose_onclick() {
		        window.close();
		    }
		    var ezapropinion_cross_dialogArguments = new Array();
		    function OpenInformationUI(pInformationContent, CompleteFunction) {
		        var parameter = pInformationContent;
		        var url = "/ezApprovalG/ezAprOpinion.do";
		        if (CrossYN()) {
		            ezapropinion_cross_dialogArguments[0] = parameter;
		            if (CompleteFunction != undefined)
		                ezapropinion_cross_dialogArguments[1] = CompleteFunction;
		            else
		                ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
		            DivPopUpShow(330, 205, url);
		        }
		        else {
		            var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		            feature = feature + GetShowModalPosition(330, 205);
		            var RtnVal = window.showModalDialog(url, parameter, feature);
		        }
		        return RtnVal;
		    }
		
		    function OpenInformationUI_Complete() {
		        DivPopUpHidden();
		    }
		    var ezapralert_cross_dialogArguments = new Array();
		
		    function OpenAlertUI(pAlertContent, CompleteFunction) {
		        var parameter = pAlertContent;
		        var url = "/ezApprovalG/ezAprAlert.do";
		
		        if (CrossYN()) {
		            ezapralert_cross_dialogArguments[0] = parameter;
		            if (CompleteFunction != undefined)
		                ezapralert_cross_dialogArguments[1] = CompleteFunction;
		            else
		                ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
		            DivPopUpShow(330, 205, url);
		        }
		        else {
		            var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		            feature = feature + GetShowModalPosition(330, 205);
		            var RtnVal = window.showModalDialog(url, parameter, feature);
		        }
		    }
		
		    function OpenAlertUI_Complete() {
		        DivPopUpHidden();
		    }
		    function btnSave_onclick() {
		    }
		    function openwindow(wfileLocation, wName, wWeigth, wHeigth) {
		        try {
		            var heigth = window.screen.availHeight;
		            var width = window.screen.availWidth;
		            var left = 0;
		            var top = 0;
		            if (window.screen.width > 800) {
		                var pleftpos;
		                pleftpos = parseInt(width) - 725;
		                heigth = parseInt(heigth) - 30;
		                width = parseInt(width) - pleftpos;
		                left = pleftpos / 2;
		            } else {
		                heigth = parseInt(heigth) - 30;
		                width = parseInt(width) - 10;
		            }
		            var param = "status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left
		            window.open(wfileLocation, "view", param);
		        } catch (e) {
		            alert("openwindow :: " + e.description);
		        }
		    }
		    function btnMail_onclick() {
		        var pheight = window.screen.availHeight;
		        var conHeight = pheight * 0.8;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - conHeight) / 2;
		        var pLeft = (pwidth - 890) / 2;
		        var pURL = "/ezApprovalG/sendToMailApproval.do?cmd=docsend&docID=" + pDocID + "&docHref=" + encodeURIComponent(pDocHref);
// 				var pURL = "/ezEmail/mailWrite.do?docHref=" + encodeURIComponent(pDocHref) + "&cmd=docsend&docID=" + pDocID + "&imageCnt=&target=APPROVALG";
		        var newwin = window.open(pURL, "mailsend", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width =890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
		        newwin.focus();
		    }
		
		    var writeboardselect_modal_dialogArguments = new Array();
		    function NewItem_onclick() {
		        writeboardselect_modal_dialogArguments[1] = NewItem_onclick_Complete;
		        var OpenWin = window.open("/ezBoard/writeBoardSelectModal.do", "WriteBoardSelect_Modal", GetOpenWindowfeature(345, 660));
		        try { OpenWin.focus(); } catch (e) { }
		    }
		
		    function NewItem_onclick_Complete(ret) {
		        if (typeof (ret) != "undefined") {
		            pBoardID = ret[0];
		
		            if (pBoardID == "" || typeof (pBoardID) == "undefined") {
		                return;
		            }
		
		            var pheight = window.screen.availHeight;
		            var pwidth = window.screen.availWidth;
		            var pTop = (pheight - 720) / 2;
		            var pLeft = (pwidth - 765) / 2;
		
		            if (ret[2] == "2" || ret[2] == "3" || ret[2] == "4") {
		                alert(strLang1031);
		            }
		            else {
		                window.open("/ezBoard/boardNewItem.do?boardID=" + pBoardID + "&mode=New&pbrdGbn=SiteNewBoard&pFromScreen=Mail&docID=" + pDocID + "&url=" + pDocHref, '', 'height=870,width=765,resizable=yes,scrollbars=no');
		            }
		        }
		    }
		
		    function btnBoard_onclick() {
		        if (pUse_Editor == "TAGFREE")
		            window.open("/myoffice/ezBoardSTD/NewBoardItem_TFX.aspx?Mod=New&pbrdGbn=SiteNewBoard&pFromScreen=Mail&DocID=" + pDocID + "&Url=" + pDocHref, '', 'height=720,width=765,resizable=yes,scrollbars=no' + GetOpenPosition(765, 720));
		        else
		            window.open("/myoffice/ezBoardSTD/NewBoardItem_CK.aspx?Mod=New&pbrdGbn=SiteNewBoard&pFromScreen=Mail&DocID=" + pDocID + "&Url=" + pDocHref, '', 'height=870,width=765,resizable=yes,scrollbars=no' + GetOpenPosition(765, 870));
		    }
		    var ezaprhistory_cross_dialogArguments = new Array();
		    function btnhistory_onclick() {
		        ezaprhistory_cross_dialogArguments[0] = "";
		        ezaprhistory_cross_dialogArguments[1] = btnhistory_onclick_Complete;
		
		        DivPopUpShow(730, 430, "/ezApprovalG/ezAprHistory.do?docID=" + pDocID);
		    }
		   
		    function btnhistory_onclick_Complete() {
		        DivPopUpHidden();
		    }
		
		    var ezdocinfog_view_cross_dialogArguments = new Array();
		    function btnDocInfo_onclick() {
		        ezdocinfog_view_cross_dialogArguments[0] = "";
		        ezdocinfog_view_cross_dialogArguments[1] = btnDocInfo_onclick_Complete;
		
		        DivPopUpShow(420, 500, "/ezApprovalG/ezDocInfoGView.do?docID=" + pDocID + "&ingFlag=END");
		    }
		    function btnDocInfo_onclick_Complete() {
		        DivPopUpHidden();
		    }
		    function SignCheck() {
		    	var result = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/getSignInfo.do",
		    		data : {
		    			docID : pDocID
		    		},
		    		success: function(xml){
		    			result = xml;
		    		}
		    	});
		        var SignXML = createXmlDom();
		        
		        if (result == "") {
		            SaveSignCheck();
		            return;
		        }
		        result = loadXMLString(result);
		        var NodeList;
		        NodeList = SelectNodes(result, "SIGNINFOS/SIGNINFO");
		        if (NodeList.length <= 0) {
		            SaveSignCheck();
		            return;
		        }
		        return;
		        SignXML = result;
		        var rtnVal = putSignXML(SignXML);
		        if (rtnVal) {
		            SaveFile();
		            SaveSignCheck();
		        }
		    }
		    function putSignXML(SignXML) {
		        var retVal = false;
		        try {
		            var NodeList;
		            var fields = message.GetFieldsList();
		            var field;
		            NodeList = SelectNodes(SignXML, "SIGNINFOS/SIGNINFO");
		            if (NodeList.length > 0) {
		                for (i = 0; i < NodeList.length; i++) {
		                    var SignType = getNodeText(SelectSingleNode(NodeList[i], "SIGNTYPE"));
		                    var SignName = getNodeText(SelectSingleNode(NodeList[i], "SIGNNAME"));
		                    var SignCont = getNodeText(SelectSingleNode(NodeList[i], "CONTENT"));
		                    var field = GetListItem(fields, SignName);
		                    if (field) {
		                        retVal = true;
		                        if (SignType == "TEXT" || SignType == "HTML") {
		                            field.textContent = SignCont;
		                        }
		                        else if (SignType == "HTML") {
		                            field.innerHTML = SignCont;
		                        }
		                        else {
		                            var img = SignCont.split("::");
		                            var signWidth = parseInt(field.offsetWidth) - 4 - 15;
		                            var signHeight = parseInt(field.offsetHeight) - 4;
		                            signWidth = 50;
		                            signHeight = 28;
		
		                            var strimg;
		                            if (img.length >= 1) {
		                                strimg = "<img src='" + encodeURI(img[0]) + "' border=0 embedding='1' ";
		                                strimg = strimg + " width=" + signWidth;
		                                strimg = strimg + " height=" + signHeight + " spath='" + encodeURI(img[0]) + "'>";
		                                message.BodySetAttribute(SignName, img[0]);
		                            }
		                            if (img.length >= 2 && img[1] != "") {
		                                field.innerHTML = img[1] + "<br>" + strimg;
		                            }
		                            else {
		                                field.innerHTML = strimg;
		                            }
		                        }
		                    }
		                }
		            }
		        } catch (e) {
		            alert("putSignXML : " + e.description);
		            return false;
		        }
		        return retVal;
		    }
		    function SaveFile() {
		        var xmlhttp = createXMLHttpRequest();
		        var xmlpara = createXmlDom();
		        var mhtBody = "";
		        mhtBody = message.Get_EditorBodyHTML();
		        mhtBody = "<HTML>" + GetCKEditerHeader() + mhtBody + "</HTML>";
		        mhtBody = ConvertHTMLtoMHT(mhtBody);
		        var objNode;
		        createNodeInsert(xmlpara, objNode, "PARAMETER");
		        createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
		        createNodeAndInsertText(xmlpara, objNode, "Html", mhtBody);
		        xmlhttp.open("POST", "../aspx/saveEndFile.aspx", false);
		        xmlhttp.send(xmlpara);
		        return xmlhttp.responseText;
		    }
		    function SaveSignCheck() {
		    	var result = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/updateSignCheck.do",
		    		data : {
		    			docID : pDocID,
		    			signCheck : "Y"
		    		},
		    		success: function(text){
		    			result = text;
		    		}
		    	});
		    	
		        return result;
		    }
		
		    var totalsavefileinfo_dialogArguments = new Array();
		    function TotalSave_onclick() {
		        totalsavefileinfo_dialogArguments[0] = "";
		        totalsavefileinfo_dialogArguments[1] = TotalSave_onclick_Complete;
		
		        DivPopUpShow(600, 450, "/ezApprovalG/totalSaveFileInfo.do?docID=" + pDocID + "&type=END");
		    }
		    function TotalSave_onclick_Complete() {
		        DivPopUpHidden();
		    }
		</script>
	</head>
	<body class="popup" style="OVERFLOW:hidden;height:100%">
		<table class="layout">
		  <tr>
		    <td style="height:20px"><div id="menu">
		        <ul>
		          <li id="btnMail"><span id="span_btnMail" onClick="return btnMail_onclick()"><spring:message code='ezApprovalG.t1513'/></span></li>
		          <li id="btnBoard"><span id="span_btnBoard" onClick="return NewItem_onclick()"><spring:message code='ezApprovalG.t1514'/></span></li>
		          <li id="btnPrint"><span id="span_btnPrint" onClick="return btnPrint_onclick()"><spring:message code='ezApprovalG.t60'/></span></li>
		          <li id="btnDocInfo"><span id="span_btnDocInfo" onClick="return btnDocInfo_onclick()"><spring:message code='ezApprovalG.t54'/></span></li>
		          <li id="btnhistory"><span id="span_btnhistory" onClick="btnhistory_onclick()"><spring:message code='ezApprovalG.t61'/></span></li>
		          <li id="tbtnTotalSave"><span id="btnTotalSave" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
		        </ul>
		      </div>
		      <div id="close">
		        <ul>
		          <li id="btnClose" ><span onClick="return btnClose_onclick()"><spring:message code='ezApprovalG.t64'/></span></li>
		        </ul>
		      </div></td>
		  </tr>
		  <tr>
		    <td style="padding-bottom:10px;height:90%"> 
		          <iframe id="message" name="message" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox" style="width: 100%; height:100%" src="ConDocViewContent.do" frameborder="0"></iframe>                
		    </td>
		  </tr>
		  <tr>
		    <td style="height:20px"><table class="file">
		        <tr>
		          <th><spring:message code='ezApprovalG.t65'/></th>
		          <td><div id="lstAttachLink"></div></td>
		        </tr>
		      </table></td>
		  </tr>
		</table>
	
		<script type="text/javascript" >
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>