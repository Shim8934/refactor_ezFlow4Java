<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<HEAD>
		<title><spring:message code='ezApprovalG.t9993'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<style> 
			.IMG_BTN { behavior:url("/js/ezApprovalG/ImgBtn.htc") }
			<%-- 2021-10-26 홍승비 - 수기 기록물 정보창 내부에서 첨부파일의 체크박스 숨김처리 --%>
			.content input[type=checkbox] { display:none; }
			.content span { margin: 3px 3px 3px 4px; }
		</style>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
		<script type="text/javascript" ID="clientEventHandlersJS">
		var pDocID = "<c:out value ='${docID}'/>";
		var pOpinionFlag;//의견 유무 Flag
		var pListTypeValue = 4;
		var flag = false;
		var PrevOpinionFlag = false;
		var NextOpinionFlag = true;
		var doctitle = "";
		var pOrgAttach = "";
		var xmlhttp = createXMLHttpRequest();
		
		var arr_userinfo = new Array();
		arr_userinfo[0]  = "user";								// 사용자-부서구분
		arr_userinfo[1]  = "<c:out value ='${userInfo.id}'/>";	                // 사용자ID
		arr_userinfo[2]  = "<c:out value ='${userInfo.displayName}'/>";         // 사용자명
		arr_userinfo[3]  = "<c:out value ='${userInfo.title}'/>";              // 사용자 직위
		arr_userinfo[4]  = "<c:out value ='${userInfo.deptID}'/>";              // 사용자 부서 ID
		arr_userinfo[5]  = "<c:out value ='${userInfo.deptName}'/>";            // 사용자 부서 이름
		arr_userinfo[6]  =  "<c:out value ='${userInfo.jikChek}'/>";            // 사용자 직책            
		arr_userinfo[8]  = "<c:out value ='${userInfo.email}'/>";             // E-Mail Address 
		arr_userinfo[9]  = "";
		arr_userinfo[10] = "<c:out value ='${susinAdmin}'/>";                 // 수신 접수담당자
		var CompanyID = "<c:out value ='${userInfo.companyID}'/>";
		
		var pUserID = arr_userinfo[1];     //사용자ID
		
		//기록물 기본정보, 부가정보
		var g_BInfoXml
		var pDocSN = "1";
		var orgCompanyID = "";

	  	// 2023-05-25 조수빈 - 전자결재 첨부파일 미리보기 사용 여부
		var useAprFilePrvw = "<c:out value ='${useAprFilePrvw}'/>";
		
		window.onload = function () {
		    g_arrayDIV = new Array(divTabDis1);
		
		    //var Para = dialogArguments;
		    g_RecID = "<c:out value ='${g_RecID}'/>";//Para[0];
		    g_SepAttNo = "<c:out value ='${g_SepAttNo}'/>";//Para[1];
		    //기록물 정보를 가져와 g_szBInfoXml, g_szEInfoXml를 초기화한다.
		    GetRecInfo();
		
		    //기본정보를 화면에 display
		    if (g_BInfoXml)
		        InitBasicInfo();
		
		    if ("${pass}" != "<RESULT>TRUE</RESULT>") {
		        QuitWindow();
		    }
		    else {
		        setAttachInfo(pDocID, "END_RECORD", lstAttachLink);
		    }
		}
		function GetRecInfo()
		{
			var xmlhttp = createXMLHttpRequest();
			var xmlpara = createXmlDom();	// 매개변수 전달을 위한 XMLDOM
			
			var objNode;
			createNodeInsert(xmlpara, objNode, "PARAMETERS");
			createNodeAndInsertText(xmlpara, objNode, "RECORDID", g_RecID);
			createNodeAndInsertText(xmlpara, objNode, "SEPATTACHNO", g_SepAttNo);
			createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);
				
			xmlhttp.open("POST","/ezApprovalG/getRecordInfo.do",false);
			xmlhttp.send(xmlpara);
			
			var rtnXml = xmlhttp.responseXML;
			if(getNodeText(GetChildNodes(rtnXml)[0])=="NORECORD")
			{
				alert(strLang713);//"기록물 정보를 찾을 수 없습니다."
				g_BInfoXml=null;
				g_EInfoXml=null;
			}
			else if(getNodeText(GetChildNodes(rtnXml)[0])=="FALSE")
			{
				alert(strLang928);
				g_BInfoXml=null;
				g_EInfoXml=null;
			}
			else
			{
				g_BInfoXml=SelectSingleNode(rtnXml.documentElement, "BASICINFO");
				g_EInfoXml=SelectSingleNode(rtnXml.documentElement, "EXTRAINFO");
			}
		}
		
		function InitBasicInfo()
		{
			if (g_BInfoXml)
			{
				InsValueIntoTD(document.getElementById("tdTitle"), SelectSingleNodeValue(g_BInfoXml, "TITLE"));
				InsValueIntoTD(document.getElementById("tdRegType"), SelectSingleNodeValue(g_BInfoXml, "REGTYPE"));
				InsValueIntoTD(document.getElementById("tdDeptName"), SelectSingleNodeValue(g_BInfoXml, "DEPTNAME"));
				InsValueIntoTD(document.getElementById("tdRegNo"), SelectSingleNodeValue(g_BInfoXml, "REGNO"));
				InsValueIntoTD(document.getElementById("tdSepAttNo"), SelectSingleNodeValue(g_BInfoXml, "SEPATTACHNO"));
				InsValueIntoTD(document.getElementById("tdDrafter"), SelectSingleNodeValue(g_BInfoXml, "DRAFTER"));
				InsValueIntoTD(document.getElementById("tdApprover"), SelectSingleNodeValue(g_BInfoXml, "APRMEMBER"));
				InsValueIntoTD(document.getElementById("tdRegDate"), SelectSingleNodeValue(g_BInfoXml, "REGDATE"));
				
				g_SCFlag = SelectSingleNodeValue(g_BInfoXml, "SPECIALFLAG");
			}
		}
		
		function InsValueIntoTD(objTD,szValue)
		{
			if(szValue=="")
			{	    
				objTD.innerHTML=" ";		
			}   
			else
			{
			    objTD.innerHTML=szValue;	
			}
		}
		
		function QuitWindow()
		{
			icons.style.display = "none";
			OpenAlertUI(strLang929);
			btnClose_onclick();
			window.close();
		}
		
		function btnClose_onclick()
		{
		  window.close();
		}
		
		function OpenAlertUI(pAlertContent)
		{
			var parameter = pAlertContent;
			var url = "../ezAPRALERT.htm";
			var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
			Feature =  Feature + GetShowModalPosition(330, 205);
			var RtnVal = window.showModalDialog(url,parameter,feature);
		}
		</script>
		</HEAD>
		<body class="popup" style="overflow-x:hidden; overflow-y:auto;">
		<h1><spring:message code='ezApprovalG.t9992'/></h1> 
		
		<div id="close"><ul><li id=btnClose ><span onClick="return btnClose_onclick()"></span></li></ul></div>
		<div ID="divTabDis1" style="DISPLAY: block; WIDTH:100%; HEIGHT: 215px;"> 
		    <table class="content">
		        <tr>
		            <th><spring:message code='ezApprovalG.t106'/></th>
		            <td id="tdTitle" colspan=3 >&nbsp;</td>
		        </tr>
		        <tr> 
		            <th><spring:message code='ezApprovalG.t1107'/></th>
		            <td id="tdRegType" colspan=3 >&nbsp;</td>
		        </tr>
		        <tr> 
		            <th><spring:message code='ezApprovalG.t1105'/></th>
		            <td id="tdDeptName" colspan=3 >&nbsp;</td>
		        </tr>
		        <tr> 
		            <th><spring:message code='ezApprovalG.t860'/></th>
		            <td id="tdRegNo"style="padding-right:15px;width:200px;white-space:nowrap">&nbsp;</td>
		            <th style="width:80px"><spring:message code='ezApprovalG.t861'/></th>
		            <td id="tdSepAttNo" style="padding-right:15px;width:200px;white-space:nowrap">&nbsp;</td>
		        </tr>
		        <tr> 
		            <th><spring:message code='ezApprovalG.t445'/></th>
		            <td id="tdDrafter" style="padding-right:15px;width:200px;white-space:pre-wrap;">&nbsp;</td>
		            <th><spring:message code='ezApprovalG.t862'/></th>
		            <td id="tdApprover" style="padding-right:15px;width:200px;white-space:pre-wrap;">&nbsp;</td>
		        </tr>
		        <tr> 
		            <th><spring:message code='ezApprovalG.t831'/></th>
		            <td id="tdRegDate" colspan=3 >&nbsp;&nbsp;</td>
		        </tr>
		        <tr class="file">
		          <th><spring:message code='ezApprovalG.t65'/></th>
		          <td colspan=3 ><div id="lstAttachLink"></div></td>
		        </tr>
		    </table>
		</div>
		</body>
</HTML>
