<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html style="height:97%;">
	<head>
		<title><spring:message code='ezApprovalG.t367'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/AprDocView_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/getDocAttach_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/attachG_Cross.js"></script>
		<script type="text/javascript" src="/js/escapenew.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/appandbody_Cross.js"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
		    var	DocID = '${docID}';
		    var	DocHref = '${docHref}';
		    var	OpinionFlag = '${opinionFlag}';
		    var	ListTypeValue = '${listType}';
		    var	ListSusin = '${listSusin}';
		    var pDocState =  '${docState}';
		    var pOrgDocID = '${orgDocID}';
		    var isOpinion = '${isOpinion}';
		    var pDocID;
		    var pDocHref;
		    var pOpinionFlag;
		    var pUserID;
		    var pListTypeValue;
		    var arrPrevDoc = new Array();
		    var arrNextDoc = new Array();
		    var flag = false;
		    var pOrgDocHref;
		    var pDocTitle;
		    var AppendFileAttach = "";
		    var AppenAprDocAttachList = "";
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
		    pUserID = arr_userinfo[1];
		    var pHasOpinion = "${hasOpinionYN}";
		    var pOpinionType = "Show";
		    var pMailEditor = "${crossEditor}";
		    var NonActiveX = "YES";
		
		    function btnOpinion_onclick() {
		        openOpinionViewUI();
		    }
		    function DocumentComplete() {
		        if (flag == false) {
		            if (DocHref == "") {
		                var pAlertContent = "<spring:message code='ezApprovalG.t1439'/>" + "<br>" + "<spring:message code='ezApprovalG.t440'/>";
		                OpenAlertUI(pAlertContent);
		                btnClose_onclick();
		                return;
		            }
		            if (pDocState == "015" && pOrgDocID.length >= 20 && "${listType}" == "99") {
		                document.getElementById("btnGongRam").style.display = "";
		                pOpinionType = "";
		            }
		            LoadpzFormDocInfo();
		        }
		    }
		    var PrtBodyContent;
		    function btnPrint_onclick() {
		        PrintClick("Cross", pDocID, "ING");
		    }
		    function btnClose_onclick() {
		        window.close();
		    }
		
		    function btnMail_onclick() {
		        var pheight = window.screen.availHeight;
		        var conHeight = pheight * 0.8;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - conHeight) / 2;
		        var pLeft = (pwidth - 890) / 2;
		        var pURL = "/myoffice/ezApprovalG/aspx/SendToMailApproval.aspx?CMD=docsend&DOCID=" + DocID + "&DOCHREF=" + encodeURIComponent(DocHref);
		        var newwin = window.open(pURL, "mailsend", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width =890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
		        newwin.focus();
		    }
		    function btnhistory_onclick() {
		        getHistory();
		    }
		    function btnGongRam_onclick() {
		        var result = "";
		        
		        $.ajax({
		    		type : "POST",
		    		dataType : "xml",
		    		async : false,
		    		url : "/ezApprovalG/gongRamUpdate.do",
		    		data : {
		    			docID : DocID,
		    			userID: ListSusin
		    		},
		    		success: function(xml){
		    			result = xml;
		    		}        			
		    	});
		        
		        var dataNodes = GetChildNodes(result);
		        var tempValue = getNodeText(dataNodes[0]);
		
		        if (tempValue == "TRUE") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1441'/>";
		            OpenAlertUI(pAlertContent, OpenAlertUI_Close);
		        }
		    }
		    function OpenAlertUI_Close() {
		        window.close();
		    }
		    window.onbeforeunload = function () {
		        try {
		            window.opener.openergetDocInfo();
		        }
		        catch (e) { }
		        try {
		            window.opener.Refresh_Window();
		        } catch (e) { }
		    };
		    var ezdocinfog_view_cross_dialogArguments = new Array();
		    function btnDocInfo_onclick() {
		        ezdocinfog_view_cross_dialogArguments[0] = "";
		        ezdocinfog_view_cross_dialogArguments[1] = btnDocInfo_onclick_Complete;
		
		        DivPopUpShow(420, 500, "/ezApprovalG/ezDocInfoGView.do?docID=" + DocID + "&ingFlag=APR");
		    }
		    function btnDocInfo_onclick_Complete() {
		        DivPopUpHidden();
		    }
		    function FieldsAvailable() {
		        message.SetEditable(false);
		    }
		
		    var totalsavefileinfo_dialogArguments = new Array();
		    function TotalSave_onclick() {
		        totalsavefileinfo_dialogArguments[0] = "";
		        totalsavefileinfo_dialogArguments[1] = TotalSave_onclick_Complete;
		
		        DivPopUpShow(600, 450, "/ezApprovalG/totalSaveFileInfo.do?docID=" + pDocID + "&type=APR");
		    }
		    function TotalSave_onclick_Complete() {
		        DivPopUpHidden();
		    }
		</script>
	</head>
	<body class="popup" style="height:100%">
		<table class="layout">
		  <tr>
		    <td style="height:20px" ><div id="menu">
		        <ul>
		          <li id="btnGongRam" style="display:none"><span onclick ="return btnGongRam_onclick()" ><spring:message code='ezApprovalG.t1720'/></span></li>
		          <li id="btnMail"><span onClick="return btnMail_onclick()" ><spring:message code='ezApprovalG.t1513'/></span></li>
		          <li id="btnOpinion"><span onClick="return btnOpinion_onclick()" ><spring:message code='ezApprovalG.t55'/></span></li>
		          <li id="btnPrint" ><span  onClick="return btnPrint_onclick()" ><spring:message code='ezApprovalG.t60'/></span></li>
		          <li id="btnDocInfo"><span onClick="return btnDocInfo_onclick()" ><spring:message code='ezApprovalG.t54'/></span></li>
		          <li id="btnhistory"><span onClick="btnhistory_onclick()" ><spring:message code='ezApprovalG.t61'/></span></li>
		          <li id="tbtnTotalSave"><span id="btnTotalSave" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
		        </ul>
		      </div>
		      <div id="close">
		        <ul>
		          <li id="btnClose"><span onClick="return btnClose_onclick()"><spring:message code='ezApprovalG.t64'/></span></li>
		        </ul>
		      </div></td>
		  </tr>
		  <tr>
		    <td style="vertical-align:top;height:90%;">
		            <iframe id="message" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox"  src="aprDocViewContent.do" name="message" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
		    </td>
		  </tr>
		  <tr>
		    <td style="height:20px"><table class="file" style="margin-top:5px;">
		        <tr>
		          <th><spring:message code='ezApprovalG.t65'/></th>
		          <td><div id="lstAttachLink"></div></td>
		        </tr>
		      </table></td>
		  </tr>
		</table>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
	</body>
</html>