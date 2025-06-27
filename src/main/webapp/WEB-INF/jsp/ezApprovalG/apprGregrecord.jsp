<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code='ezApprovalG.t1043'/></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/RegRecord_Cross.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CabinetInfo_Cross.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/RecordInfo_Cross.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/InitSCPopup_Cross.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/MiscFunc_Cross.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery-ui.css')}">
<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery-ui.min.css')}">
<style type="text/css">
	#tdAVType div input {
		padding:3px;
	}
</style>
<script type="text/javascript" ID="clientEventHandlersJS">
	var regRecordFlag = false;
    var g_VisualAudioFlag="0";
    var g_NodesRcdgAVType=null;
    var g_NodesPhotoAVType=null;
    var rtnVal = new Array();
   	var g_SCFlag;
    var xmlhttp = createXMLHttpRequest();
    var pUserID = "<c:out value = '${userInfo.id}' />";
    var CompanyID = "<c:out value = '${userInfo.companyID}' />";
    var arr_userinfo = new Array();
    arr_userinfo[0]  = "user";								
    arr_userinfo[1]  = "<c:out value = '${userInfo.id}'/>";            
    arr_userinfo[2]  = "<c:out value = '${userInfo.displayName}'/>";        
    arr_userinfo[3]  = "<c:out value = '${userInfo.title}'/>";
    arr_userinfo[4]  = "<c:out value = '${userInfo.deptID}'/>";
    arr_userinfo[5]  = "<c:out value = '${userInfo.deptName}' escapeXml='false'/>";
    arr_userinfo[6]  = "<c:out value = '${userInfo.jikChek}'/>";
    arr_userinfo[8]  = "<c:out value = '${userInfo.email}'/>";            
    arr_userinfo[9]  = CompanyID;
    arr_userinfo[11]  = "<c:out value = '${userInfo.displayName1}'/>";
    arr_userinfo[12]  = "<c:out value = '${userInfo.displayName2}'/>";
    arr_userinfo[13]  = "<c:out value = '${userInfo.title1}'/>";
    arr_userinfo[14]  = "<c:out value = '${userInfo.title2}'/>";
    arr_userinfo[15]  = "<c:out value = '${userInfo.deptName1}' escapeXml='false'/>";
    arr_userinfo[16]  = "<c:out value = '${userInfo.deptName2}' escapeXml='false'/>";		
    var UserLang = "<c:out value = '${userInfo.lang}'/>";
    var pUserID			= arr_userinfo[1];
    var pUserName		= arr_userinfo[2];
    var pUserJobTitle	= arr_userinfo[3];
    var pDeptID			= arr_userinfo[4];
    var pDeptName		= arr_userinfo[5];
    var pDocID =""; 
    var pDocSN = "0";
    var orgCompanyID = "";
    var ext = "mht";
    var tooltipLevelFlag = "Y"

  	// 2023-05-25 조수빈 - 전자결재 첨부파일 미리보기 사용 여부
	var useAprFilePrvw = "<c:out value ='${useAprFilePrvw}'/>";
    
    window.onload = function () {
        if (window.dialogArguments != null) {
            var objWinDlgArgs = window.dialogArguments;
        }

        g_CabListXml = "";
        ListTypeFlag = "0"

        rtnVal[0] = "FALSE";
        InitCode();

        if (g_CabListXml != "") {
            InitCabinetInfo();
        }
        else {
            btnChangeCabinet_onclick();
        }
        
        selRegisterType_onchange();

        rdoSecType_onclick("1");

        // 등록구분에서 일반문서 접수가 디폴트로 선택 되도록 수정. 2019-09-26 홍대표
        selRegisterType.value = 2;
        selRegisterType_onchange()
     	// 2020-11-23 등급 툴팁 추가 - 박기범
        giveTooltipLevel();
    }
    function KeEventControl(obj) {
        useragt = navigator.userAgent.toUpperCase();
        if (useragt.indexOf("SAFARI") > 0 && useragt.indexOf("CHROME") < 0) //사파리 브라우저일 경우
        {
            return;
        }
        obj.onkeydown = function () {
            if (parseInt(window.event.keyCode) >= 48 && parseInt(window.event.keyCode) <= 126)
                return false;
            if (parseInt(window.event.keyCode) == 189 || parseInt(window.event.keyCode) == 187 ||
                    parseInt(window.event.keyCode) == 220 || parseInt(window.event.keyCode) == 219 ||
                    parseInt(window.event.keyCode) == 221 || parseInt(window.event.keyCode) == 222 ||
                    parseInt(window.event.keyCode) == 186 || parseInt(window.event.keyCode) == 188 ||
                    parseInt(window.event.keyCode) == 190 || parseInt(window.event.keyCode) == 191 || parseInt(window.event.keyCode) == 32)
                return false;
        };
    }
    function cmdCancel_onclick() {
        rtnVal[0] = "FALSE";
        window.returnValue = rtnVal;
        window.close();
    }
    function CheckInputField() {
        var pRegType = selRegisterType.value;
        if (typeof (g_CabID) == "undefined") {
            alert("<spring:message code='ezApprovalG.t513'/>");
            return false;
        }

        if (g_CabID == "") {
            alert("<spring:message code='ezApprovalG.t513'/>");
            return false;
        }

        if (selRegisterType.value == "") {
            alert("<spring:message code='ezApprovalG.t1044'/>");
            return false;
        }

        if (txtTitle.value == "") {
            alert("<spring:message code='ezApprovalG.t955'/>");
            return false;
        }
        
        if (regDate.value.trim() == "" || regTime.value.trim() == "") {
            alert("<spring:message code='ezApprovalG.t1045'/>");
            return false;
        }

        if (pRegType == "1")
        {
            if (txtAprMemberTitle.value == "") {
                alert("<spring:message code='ezApprovalG.t1054'/>");
                return false;
            }
        }

        if (txtDrafter.value == "") {
            alert("<spring:message code='ezApprovalG.t1055'/>");
            return false;
        }

        if (pRegType == "2" || pRegType == "4" || pRegType == "8")
        {
            if (txtReceiptMember.value == "") {
                alert("<spring:message code='ezApprovalG.t1056'/>");
                return false;
            }
        }

        if (pRegType == "2" || pRegType == "4")
        {
            if (txtOriginSN.value == "") {
                alert("<spring:message code='ezApprovalG.t1057'/>");
                return false;
            }
        }

        if (pRegType == "5" || pRegType == "6")
        { 
            if (txtSummary.value == "") {
                alert("<spring:message code='ezApprovalG.t1058'/>");
                return false;
            }

            if (GetAVTypeCode() == "") {
                alert("<spring:message code='ezApprovalG.t1059'/>");
                return false;
            }
        }

        if (!ValidateNumber(txtTotalPage.value, 'Y')) {
            alert("<spring:message code='ezApprovalG.t1060'/>");
            return false;
        }

        if (txtTotalPage.value.length > 3) {
            alert("<spring:message code='ezApprovalG.t1061'/>");
            return false;
        }

        return true;
    }
    function cmdConfirm_onclick() {
            // 2018-10-01 중복 등록 버그 수정
        if (regRecordFlag == false && CheckInputField()) {
        	regRecordFlag = true;
           
        	if (pDocID == "")
                pDocID = createNewDocID();
            
            	var regRecordFlag2 = RegisterRecord();
            	if(regRecordFlag2) {
	                rtnVal[0] = "TRUE";
	                
	                rtnVal[1] = g_szSCListXml;
	                window.opener.GetRecordList();
	                window.close();
            } else {
            	alert("대장등록에 실패하였습니다.");
            }
        }
    }
    function btnFileAttach_onclick() {
        try {
            if (pDocID == "") {
                pDocID = createNewDocID();
            }

            var ret = openFileAttachUI();
        }
        catch (e) {
            alert("btnFileAttach_onclick : " + e.description);
        }
    }
    function createNewDocID() {
        try {
            var objRoot;
            var objNode;

            var xmlpara = createXmlDom()
            var xmlhttp = createXMLHttpRequest();

            var objNode;
            createNodeInsert(xmlpara, objNode, "PARAMETER");
            createNodeAndInsertText(xmlpara, objNode, "docID", "");

            xmlhttp.open("POST", "/ezApprovalG/createNewDocId.do", false);
            xmlhttp.send(xmlpara);

            if (xmlhttp.responseText == "") {
                alert(strLang131);
            }
            else {
                return xmlhttp.responseText;
            }
        }
        catch (e) {
            alert("createNewDoc()" + e.description);
        }
    }
    function openFileAttachUI() {
        try {
            DivPopUpShow(800, 610, "/ezApprovalG/aprAttach.do?formID=&docID=" + encodeURI(pDocID) + "&draftFlag=DRAFT" + "&orgCompanyID=" + CompanyID + "&ext=" + ext);
        }
        catch (e) {
            alert("openFileAttachUI()" + e.description);
        }
    }

    window.onbeforeunload = function () {
        window.returnValue = rtnVal;

        if (pDocID != "")
            Del_DocAttach();
    }
    function Del_DocAttach() {
        try {
            var objRoot;
            var objNode;

            var xmlpara = createXmlDom();
            var xmlhttp = createXMLHttpRequest();

            createNodeInsert(xmlpara, objNode, "PARAMETER");
            createNodeAndInsertText(xmlpara, objNode, "docid", pDocID);

            xmlhttp.open("POST", "/myoffice/ezApprovalG/ezCabinet/aspx/API_DelAttach.aspx", false);
            xmlhttp.send(xmlpara);
        }
        catch (e) {
            alert("createNewDoc()" + e.description);
        }
    }
    function selRegisterType_onchange() {
        var Val = selRegisterType.value;

        if (Val == "5" || Val == "6") {
            divAudioVisualDummy.style.display = "none";
            divAudioVisual.style.display = "";
            g_VisualAudioFlag = "1";
            
            trDeliveryNo.style.display = "none";
            trOriginSN.style.display = "none";
            trAprMemberTitle.style.display = "";
            
            blank_1.style.display = "";
            blank_2.style.display = "";

            if (Val == 5) {
                if (CrossYN())
                    //window.resizeTo(1030, 780);
                InitAVTypeTD(g_NodesPhotoAVType, tdAVType, "");
            }
            else if (Val == 6) {
                if (CrossYN())
                    //window.resizeTo(1030, 810);
                InitAVTypeTD(g_NodesRcdgAVType, tdAVType, "");
            }
        }
        else {
            divAudioVisualDummy.style.display = "";
            divAudioVisual.style.display = "none";
            g_VisualAudioFlag = "0";

            if (Val == "1" || Val == "3" || Val == "5" || Val == "6")
            {
                if (CrossYN())
                    //window.resizeTo(1030, 710);

                trDeliveryNo.style.display = "none";
                trOriginSN.style.display = "none";
                trAprMemberTitle.style.display = "";
                
                blank_1.style.display = "";
                blank_2.style.display = "";
            }
            else if (Val == "2" || Val == "4")
            {
                if (CrossYN())
                    //window.resizeTo(1030, 710);

                //trDeliveryNo.style.display = ""; //2018-07-19 천성준 - 문서과배부번호 안보이게 주석처리
                trOriginSN.style.display = "";
                trAprMemberTitle.style.display = "none";
                
                blank_1.style.display = "";
                blank_2.style.display = "none";
            }
            else {
                if (CrossYN())
                    //window.resizeTo(1030, 750);

                //trDeliveryNo.style.display = ""; //2018-07-19 천성준 - 문서과배부번호 안보이게 주석처리
                trOriginSN.style.display = "";
                trAprMemberTitle.style.display = "";
                
                blank_1.style.display = "none";
                blank_2.style.display = "none";
            }
        }
    }
    var g_SepAttachLVXml = "";
    var inssepattach_cross_dialogArguments = new Array();
    function btnAddSepAttach_onclick() {
        if (g_CabID != "") {
            var para = new Array();
            para[0] = g_SepAttachLVXml;
            para[1] = g_CabID;
			para[3] = ext;
			
            var url = "/ezApprovalG/insSepAttach.do";

            inssepattach_cross_dialogArguments[0] = para;
            inssepattach_cross_dialogArguments[1] = btnAddSepAttach_onclick_Complete;

            DivPopUpShow(950, 630, url);
        }
        else
        {
            alert("<spring:message code='ezApprovalG.t1062'/>");
            btnChangeCabinet_onclick();
        }
    }

    function btnAddSepAttach_onclick_Complete(rtn) {
        DivPopUpHidden();
        if (rtn[0] == "TRUE") {
            g_SepAttachLVXml = rtn[1];
        }
    }
    var AddSpecialCatalog_Cross_dialogArguments = new Array();
    function btnAddSpecialCatalog_onclick() {
        var para = new Array();
        para[0] = g_szSCListXml;
        para[1] = g_arrSCName[0];
        para[2] = g_arrSCName[1];
        para[3] = g_arrSCName[2];
        var url = "/ezApprovalG/insSpecialList.do";
        var rtn;
        AddSpecialCatalog_Cross_dialogArguments[0] = para;
        AddSpecialCatalog_Cross_dialogArguments[1] = btnAddSpecialCatalog_onclick_Complete;
        var OpenWin;
        
            OpenWin = window.open(url, "AddSpecialCatalog_Cross", GetOpenWindowfeature(500, 435));

        try { OpenWin.focus(); } catch (e) { }
    }
    function btnAddSpecialCatalog_onclick_Complete(rtn) {
    	   DivPopUpHidden();
    	   if (rtn[0] == "TRUE") {
    	        g_szSCListXml = rtn[1];
    	    }
    }
    function GetSepAttParamXml() {
        var rtnXml = createXmlDom();

        var objRoot, objNode, subNode;

        objRoot = createNodeInsert(rtnXml, objRoot, "SEPATTACHINFO");

        var sepAtt, Data, i;
        if (g_SepAttachLVXml != "") {
            var sepLVXml = createXmlDom();
            sepLVXml = loadXMLString(g_SepAttachLVXml);

            var rows = SelectNodes(sepLVXml, "LISTVIEWDATA/ROWS/ROW")

            for (i = 0; i < rows.length; i++) {
                objNode = createNodeAndAppandNode(sepLVXml, objRoot, objNode, "SEPATTACH");
                createNodeAndAppandNodeText(sepLVXml, objNode, subNode, "CABINETID", getNodeText(rows[i].getElementsByTagName("DATA1")[0]));
                createNodeAndAppandNodeText(sepLVXml, objNode, subNode, "TITLE", getNodeText(GetChildNodes(rows[i])[1]));
                createNodeAndAppandNodeText(sepLVXml, objNode, subNode, "NUMOFPAGE", getNodeText(GetChildNodes(rows[i])[4]));
                createNodeAndAppandNodeText(sepLVXml, objNode, subNode, "REGTYPE", getNodeText(rows[i].getElementsByTagName("DATA2")[0]));
                createNodeAndAppandNodeText(sepLVXml, objNode, subNode, "SUMMARY", getNodeText(GetChildNodes(rows[i])[6]));
                createNodeAndAppandNodeText(sepLVXml, objNode, subNode, "AVTYPE", getNodeText(rows[i].getElementsByTagName("DATA3")[0]));
            }
        }
        return rtnXml;
    }
    function MM_swapImgRestore() {
        var i, x, a = document.MM_sr; for (i = 0; a && i < a.length && (x = a[i]) && x.oSrc; i++) x.src = x.oSrc;
    }
    function MM_preloadimages() {
        var d = document; if (d.images) {
            if (!d.MM_p) d.MM_p = new Array();
            var i, j = d.MM_p.length, a = MM_preloadimages.arguments; for (i = 0; i < a.length; i++)
                if (a[i].indexOf("#") != 0) { d.MM_p[j] = new Image; d.MM_p[j++].src = a[i]; }
        }
    }
    function MM_findObj(n, d) {
        var p, i, x; if (!d) d = document; if ((p = n.indexOf("?")) > 0 && parent.frames.length) {
            d = parent.frames[n.substring(p + 1)].document; n = n.substring(0, p);
        }
        if (!(x = d[n]) && d.all) x = d.all[n]; for (i = 0; !x && i < d.forms.length; i++) x = d.forms[i][n];
        for (i = 0; !x && d.layers && i < d.layers.length; i++) x = MM_findObj(n, d.layers[i].document); return x;
    }
    function MM_swapImage() {
        var i, j = 0, x, a = MM_swapImage.arguments; document.MM_sr = new Array; for (i = 0; i < (a.length - 2) ; i += 3)
            if ((x = MM_findObj(a[i])) != null) { document.MM_sr[j++] = x; if (!x.oSrc) x.oSrc = x.src; x.src = a[i + 2]; }
    }
    
    function GetPublicCode2() {
    	var publicCode2 = "";
        var rdoSecType2SelectBox = document.getElementById("rdoSecType2");
        if (rdoSecType2SelectBox){
            publicCode2 = rdoSecType2SelectBox.value;
        }

        return publicCode2;
    }
    
    /* 2020-09-11 홍승비 - 숫자 이외의 값 입력 방지 함수 */
    function KeEventControl2(obj) {
        if ((window.event.keyCode >= 48 && window.event.keyCode <= 57) || (window.event.keyCode >= 96 && window.event.keyCode <= 105)) {
            return true;
        }
        else {
        	obj.value = obj.value.replace(/[\a-zㄱ-ㅎㅏ-ㅣ가-힣]/g, '');
        }
    }
    
 	// 2020-11-23 공개등급 tooltip 추가 - 박기범
	function giveTooltipLevel() {
		if (tooltipLevelFlag != "Y"){
			return;
		}
		document.querySelector('input[name=selSecLevel1]').nextSibling.setAttribute('title','법률 또는 명령에 의하여 비밀로 유지되거나 비공개사항으로 규정된 항목'														);
		document.querySelector('input[name=selSecLevel2]').nextSibling.setAttribute('title','공개될 경우 국가안보,국방,통일 외교관계 등 국익을 해할 우려가 있는 정보'													);
		document.querySelector('input[name=selSecLevel3]').nextSibling.setAttribute('title','공개될 경우 국민의 생명,신체,재산 등 공공안전 및 이익을 해할 우려가 있는 정보'													);
		document.querySelector('input[name=selSecLevel4]').nextSibling.setAttribute('title','수사,재판,범죄예방 등의 관련정보로서 공개될 경우 직무수행이 곤란하거나 형사피고인의 공정한 재판받을 권리를 침해할 우려가 있는 정보'					);
		document.querySelector('input[name=selSecLevel5]').nextSibling.setAttribute('title','감사,감독,검사,시험,규제,입찰계약,기술개발,인사관리,의사결정 또는 내부검토과정에\n있는 사항으로서 공개될 경우 업무수행 등에 지장을 초래할 우려가 있는 정보'	);
		document.querySelector('input[name=selSecLevel6]').nextSibling.setAttribute('title','이름,주민등록번호 등에 의해 특정인을 식별할 수 있는 개인에 관한 정보'														);
		document.querySelector('input[name=selSecLevel7]').nextSibling.setAttribute('title','법인,단체 또는 개인의 영업상 비밀에 관한 정보로서 공개될 경우 법인 등의 정당한 이익을 해할 우려가 있는 정보'								);
		document.querySelector('input[name=selSecLevel8]').nextSibling.setAttribute('title','공개될 경우 부동산투기,매점매석 등으로 특정인에게 이익 보는 불이익을 줄 우려가 있는 정보'											);
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
    }

    function OpenAlertUI_Complete() {
        window.close();
    }
    
</SCRIPT>
</head>
<body class="popup">
<h1 style="height:30px;"><spring:message code='ezApprovalG.t1043'/></h1>
<div id="close">
    <ul>
        <li><span id="btnCancel" onclick="return cmdCancel_onclick()"></span></li>
    </ul>
</div>

<table style="width: 100%;">
	<tr>
		<td colspan="2">
			<h2 class="h2_dot" style="font-weight: normal; margin-top: 4px;"><spring:message code='ezApprovalG.t1018'/></h2>
		</td>
	</tr>
	<tr>
		<td style="width: 50%;">
			<table style="width:100%; border-bottom: 0px; border-right: 0px;" class="content">
				<tr>
					<th style="border-bottom: 0px; padding-right:31px;"><spring:message code='ezApprovalG.t1063'/></th>
       				<td style="border-bottom: 0px; border-right: 0px;">
       				<span id="tdCabinetName" style="display:inline-block; vertical-align:middle; width:80%;">&nbsp;</span>
       				<a class="imgbtn imgbck" style="display:inline-block; vertical-align:middle;"><span onClick="return btnChangeCabinet_onclick()"><spring:message code='ezApprovalG.t1064'/></span></a>
       				</td>
				</tr>
			</table>
		</td>
		<td>
			<table style="width:100%; border-bottom: 0px;" class="content">
				<tr>
					<th style="border-bottom: 0px; padding-right:81px;"><spring:message code='ezApprovalG.t572'/></th>
		    		<td style="border-bottom: 0px;" id="tdCabinetSN">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table style="width:100%; border-right: 0px;" class="content">
				<tr>
					<th style="padding-right:82px;"><spring:message code='ezApprovalG.t1065'/></th>
    				<td style="border-right: 0px;" id="tdCabinetType">&nbsp;</td>
				</tr>
			</table>
		</td>
		<td>
			<table style="width:100%;" class="content">
				<tr>
					<th style="padding-right:69px;"><spring:message code='ezApprovalG.t573'/></th>
	    			<td id="tdCabinetVolNo">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<table style="width:100%">
  <tr>
    <td style="vertical-align:top"><table style="width: 100%">
        <tr>
          <td style="vertical-align:top;width:50%;height:419px;">
          <h2 class="h2_dot" style="font-weight: normal;"><spring:message code='ezApprovalG.t1066'/></h2>
            <table style="width:100%" id="tbBasicInfo" class="content" >
              <tr>
                <th style="padding-right: 58px;"><spring:message code='ezApprovalG.t859'/></th>
                <td>
                	<select id="selRegisterType" style="width:150px; height: 25px;" onChange="return selRegisterType_onchange()" name="select">
                    </select>
                </td>
              </tr>
              <tr>
                <th ><spring:message code='ezApprovalG.t1067'/></th>
                <td><input type="text" name="txtTitle" id="txtTitle" class="text" style="Width:100%;">
                </td>
              </tr>
              <tr>
                <th ><spring:message code='ezApprovalG.t831'/></th>
                <td>
                    <input type="date" class="text" name="regDate" id="regDate" /><input type="time" name="regTime" id="regTime" />
                </td>
              </tr>
              <tr>
                <th ><spring:message code='ezApprovalG.t979'/></th>
                <td><input type="text" name="txtTotalPage" id="txtTotalPage" class="text" style="Width:60px;height:25px;padding:0px;margin:0px;" onkeypress="return KeEventControl2(this);" onkeydown="return KeEventControl2(this);" onkeyup="return KeEventControl2(this);">
                &nbsp;<span style="height:14px;padding:0px;margin:0px;vertical-align:middle;"><spring:message code='ezApprovalG.t980'/></span></td>
              </tr>
              <tr  id="trAprMemberTitle">
                <th ><spring:message code='ezApprovalG.t862'/></th>
                <td><input type="text" name="txtAprMemberTitle" id="txtAprMemberTitle" class="text" style="Width:100%;">
                </td>
              </tr>
              <tr>
                <th ><spring:message code='ezApprovalG.t445'/></th>
                <td><input type="text" name="txtDrafter" id="txtDrafter" class="text" style="Width:100%;">
                </td>
              </tr>
              <tr>
                <th ><spring:message code='ezApprovalG.t863'/></th>
                <td>
                    <input type="date" class="text" name="exeDate" id="exeDate" />
                </td>
              </tr>
              <tr>
                <th ><spring:message code='ezApprovalG.t864'/></th>
                <td><input type="text" name="txtReceiptMember" id="txtReceiptMember" class="text" style="Width:100%;">
                </td>
              </tr>
              <tr  id="trDeliveryNo">
                <th ><spring:message code='ezApprovalG.t1069'/></th>
                <td><input type="text" name="txtDeliveryNo" id="txtDeliveryNo" class="text" style="Width:100%;" maxlength="6">
                </td>
              </tr>
              <tr  id="trOriginSN">
                <th ><spring:message code='ezApprovalG.t866'/></th>
                <td><input type="text" name="txtOriginSN" id="txtOriginSN" class="text" style="Width:100%;" maxlength="20">
                </td>
              </tr>
              <tr>
                <th><spring:message code='ezApprovalG.t94'/></th>
                <td><table border="0" style="width:100%;border-collapse:collapse; border-spacing:0;padding:0px;" >
                    <tr>
                      <td id="tdSpecialFlag">&nbsp;</td>
                      <td style="width:70px">
                      <a class="imgbtn imgbck" id="btnAddSC" style="position: absolute; top: 400px; left: 453px; display:none;"><span onClick="return btnAddSpecialCatalog_onclick()"><spring:message code='ezApprovalG.t268'/></span></a>
                      <!-- <img src="/images/btn_add.gif" style="display:none;cursor:pointer;vertical-align:middle" id="btnAddSC" name="btnAddSC" onClick="return btnAddSpecialCatalog_onclick()" width="39" height="20"> -->
                      </td>
                    </tr>
                  </table></td>
              </tr>
              <tr>
                <th ><spring:message code='ezApprovalG.t868'/></th>
                  <td style="text-align:left"><div class='custom_radio'><input type="radio" name="rdoElectronicFlag" value="1" style="height:13px;width:13px;padding:0px;margin:0px;vertical-align:top;" checked></div>
                  <span><spring:message code='ezApprovalG.t981'/></span>
                  <div class='custom_radio'><input type="radio" name="rdoElectronicFlag" style="height:13px;width:13px;padding:0px;margin:0px;" value="2"></div>
                  <span><spring:message code='ezApprovalG.t1070'/></span></td>
              </tr>
              <tr>
                <th ><spring:message code='ezApprovalG.t58'/></th>
                <td><a class="imgbtn imgbck" style="height: 21px; margin-top: 2px;"><span id="btnAddSepAttach" onClick="return btnAddSepAttach_onclick()" style="line-height: 22px;" ><spring:message code='ezApprovalG.t949'/></span></a></td>
              </tr>
              <tr>
             	<td id="blank_1" colspan="2" style="display: none;background-color: #f8f8fa;">&nbsp;</td>
              </tr>
              <tr>
              	<td id="blank_2" colspan="2" style="display: none;background-color: #f8f8fa;">&nbsp;</td>
              </tr>
            </table></td>
          <td style="vertical-align:top" ><h2 class="h2_dot" style="font-weight: normal;"><spring:message code='ezApprovalG.t1071'/></h2>
            <table style="border-left: 0px; height: 181px;"  class="content">
              <tr>
                <th style="border-left: 0px; padding-right: 46px; height: 85px;"><spring:message code='ezApprovalG.t875'/></th>
                <td style="width:98%; padding:3px;">
                    <div class='custom_checkbox'><input type="checkbox" name="special1" value="checkbox" style="height:13px;width:13px;padding:0px;margin:1.5px;"></div><span>&nbsp;<spring:message code='ezApprovalG.t983'/></span><br />
                    <div class='custom_checkbox'><input type="checkbox" name="special2" value="checkbox" style="height:13px;width:13px;padding:0px;margin:1.5px;"></div><span>&nbsp;<spring:message code='ezApprovalG.t984'/></span><br>
                    <div class='custom_checkbox'><input type="checkbox" name="special3" value="checkbox" style="height:13px;width:13px;padding:0px;margin:1.5px;"></div><span>&nbsp;<spring:message code='ezApprovalG.t985'/></span><br />
                    <div class='custom_checkbox'><input type="checkbox" name="special4" value="checkbox" style="height:13px;width:13px;padding:0px;margin:1.5px;"></div><span>&nbsp;<spring:message code='ezApprovalG.t986'/></span><br>
                    <div class='custom_checkbox'><input type="checkbox" name="special5" value="checkbox" style="height:13px;width:13px;padding:0px;margin:1.5px;"></div><span>&nbsp;<spring:message code='ezApprovalG.t987'/></span></td>
              </tr>
              <tr>
                <th style="border-left: 0px;"><spring:message code='ezApprovalG.kes06'/></th>
                  <td><div class='custom_radio'><input type="radio" name="rdoSecType" value="1" checked onClick="return rdoSecType_onclick(this.value)"  style="height:13px;width:13px;padding:0px;margin:0px;"></div>
                  <span><spring:message code='ezApprovalG.t47'/></span>
                  <div class='custom_radio'><input type="radio" name="rdoSecType" value="2" onClick="return rdoSecType_onclick(this.value)"  style="height:13px;width:13px;padding:0px;margin:0px;"></div>
                  <span><spring:message code='ezApprovalG.t150'/></span>
                  <div class='custom_radio'><input type="radio" name="rdoSecType" value="3" onClick="return rdoSecType_onclick(this.value)"  style="height:13px;width:13px;padding:0px;margin:0px;"></div>
                  <span><spring:message code='ezApprovalG.t1072'/></span>
                  <select id="selSecLevel" style="width:60px;display:none" name="select2">
                  </select>
                </td>
              </tr>
              <tr>
                <th style="border-left: 0px; height: 55px;"><spring:message code='ezApprovalG.t989'/></th>
                  <td style="padding:3px;"><div class='custom_checkbox'><input type="checkbox" name="selSecLevel1" value="checkbox" style="height:13px;width:13px;padding:0px;margin:3px 0px 3px 3px;"></div><span>&nbsp;1<spring:message code='ezApprovalG.t1768'/></span>
                    <div class='custom_checkbox'><input type="checkbox" name="selSecLevel2" value="checkbox" style="height:13px;width:13px;padding:0px;margin:3px 0px 3px 3px;"></div><span>&nbsp;2<spring:message code='ezApprovalG.t1768'/></span>
                    <div class='custom_checkbox'><input type="checkbox" name="selSecLevel3" value="checkbox" style="height:13px;width:13px;padding:0px;margin:3px 0px 3px 3px;"></div><span>&nbsp;3<spring:message code='ezApprovalG.t1768'/></span>
                    <div class='custom_checkbox'><input type="checkbox" name="selSecLevel4" value="checkbox" style="height:13px;width:13px;padding:0px;margin:3px 0px 3px 3px;"></div><span>&nbsp;4<spring:message code='ezApprovalG.t1768'/></span><br>
                    <div class='custom_checkbox'><input type="checkbox" name="selSecLevel5" value="checkbox" style="height:13px;width:13px;padding:0px;margin:3px 0px 3px 3px;"></div><span>&nbsp;5<spring:message code='ezApprovalG.t1768'/></span>
                    <div class='custom_checkbox'><input type="checkbox" name="selSecLevel6" value="checkbox" style="height:13px;width:13px;padding:0px;margin:3px 0px 3px 3px;"></div><span>&nbsp;6<spring:message code='ezApprovalG.t1768'/></span>
                    <div class='custom_checkbox'><input type="checkbox" name="selSecLevel7" value="checkbox" style="height:13px;width:13px;padding:0px;margin:3px 0px 3px 3px;"></div><span>&nbsp;7<spring:message code='ezApprovalG.t1768'/></span>
                    <div class='custom_checkbox'><input type="checkbox" name="selSecLevel8" value="checkbox" style="height:13px;width:13px;padding:0px;margin:3px 0px 3px 3px;"></div><span>&nbsp;8<spring:message code='ezApprovalG.t1768'/></span></td>
              </tr>
               <tr>
                <th style="border-left: 0px;"><spring:message code='ezApprovalG.t109'/></th>
                <td>
                    <select id="rdoSecType2" name="rdoSecType2" style="WIDTH: 85px">
                        <option value="Y"><spring:message code='ezApprovalG.kmh03'/></option>
                        <option value="B"><spring:message code='ezApprovalG.kmh04'/></option>
                        <option value="N"><spring:message code='ezApprovalG.kmh05'/></option>
                    </select>
                  <%--<input type="radio" name="rdoSecType2" value="Y" checked onClick="return rdoSecType2_onclick(this.value)" checked  style="height:13px;width:13px;padding:0px;margin:0px;">
                  <span><spring:message code='ezApprovalG.t47'/></span>
                  <input type="radio" name="rdoSecType2" value="N" onClick="return rdoSecType2_onclick(this.value)"  style="height:13px;width:13px;padding:0px;margin:0px;">
                  <span><spring:message code='ezApprovalG.t1072'/></span>
                  <select id="selSecLevel" style="width:60px;display:none" name="select2">
                  </select>--%>
                </td>
              </tr>
              <tr>
                <th style="border-left: 0px;"><spring:message code='ezApprovalG.t876'/></th>
                <td><input type="text" name="txtLimitRange" id="txtLimitRange" class="text" style="Width:170px;">
                  (<spring:message code='ezApprovalG.t1073'/></td>
              </tr>
            </table>
            <div id="divAudioVisualDummy" style="display:none"> </div>
            <div id="divAudioVisual">
             <%--  <h2 class="h2_dot" style="font-weight: normal;"><spring:message code='ezApprovalG.t1074'/></h2> --%>
              <table style="width:100%; height:100%; border-left: 0px;border-top: 0px;" class="content">
                <tr>
                  <th style="border-left: 0px;border-top: 0px;"><spring:message code='ezApprovalG.t1183'/></th>
                  <td style="border-top: 0px;"><TextArea style="width:97%; height:43px; margin: 2px 0px; resize:none; overflow: auto" id=txtSummary name=txtSummary></TextArea>
                  </td>
                </tr>
                <tr>
                  <th style="border-left: 0px;"><spring:message code='ezApprovalG.t873'/></th>
                  <td>
                  <div id=tdAVType style="overflow:auto;"></div>
                  </td>
                </tr>
              </table>
            </div></td>
        </tr>
        <tr>
            <td colspan="2">&nbsp;</td>
        </tr>
        <tr>
            <td colspan="2" style="height:20px">
                <table class="file">
	                <tr>
		                <th id="btn_Attach" style="font-weight: normal; text-align: left; padding-right: 58px;"><spring:message code='ezApprovalG.t65'/></th>
		                <td style="border-right: 0px;"><div id="lstAttachLink"></div></td>
	                    <td style="border-left: 0px;">
                            <a class="imgbtn imgbck" style="height: 44px; margin: 0px;">
                                <span onclick="return btnFileAttach_onclick()" style="line-height: 45px;"><spring:message code='ezApprovalG.t268'/></span>
                            </a>
                        </td>
	                </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td colspan="2" style="height:20px">
                <div style="text-align:left; line-height:20px;">
		      		<img src="/images/i_notice.gif" style="vertical-align: middle;padding-left:1px;">
                    <span style="color:#3a76c3;height:18px;display:inline-block;">${pAttachWarning0}</span><br>
                    <span style="color:#3a76c3;height:18px;display:${spanDisplayStyle}; margin-left:29px;">${pAttachWarning1}</span>
		      	</div>
            </td>
        </tr>
      </table></td>
  </tr>
</table>
<div class="btnposition btnpositionNew">
	<a class="imgbtn"><span id="btnOK" onclick="return cmdConfirm_onclick()"><spring:message code='ezApprovalG.t20'/></span></a>
</div>
    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>
