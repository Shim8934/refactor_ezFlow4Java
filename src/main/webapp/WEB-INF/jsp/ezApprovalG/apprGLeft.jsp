<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title></title>
		<meta HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<link href="/css/jquery.selectbox.css" type="text/css" rel="stylesheet" />
	    <style type="text/css">
	        .instance.sbHolder{
	            width: 100%;
	        }
	    </style>
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery.selectbox-0.2.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/CabRoleInfo_Cross.js"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
		    var pListTypeValue = "${listType}";
		    var PresentOpen = "APPROVAL";
		    var CompanyID = '${userInfo.companyID}';
		    var CompanyName = '${userInfo.companyName1}';
		    var gMenuFlag = 1;
		    var pDeptID = "${userInfo.deptID}";
		    var contFlag = "END";
		    var pChackYN = "FALSE";
		    var ContainerID;
		    var PageSize   = 10;
		    var szRoleInfo = "${szRoleInfo}";
		    var Containers = "${containers}";
		    var DocList_Flag="";
		    var DocDeptYN;
		    var DeptID = "${userInfo.deptID}";
		    var g_bRecAdmin=false;
		    var g_bDeptCharger=false;
		    var AdminYN;
		    var ViewLeftCount = "${viewLeftCount}";
		    $(function () {
		        if ("${isSubTitle}" == "true")
		            $("#country_id").selectbox();
		            $(".sbHolder").each(function (index) {
		                $(this).addClass('instance');
		            });
		    });
		    document.onselectstart = function () { return false; };
		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        initUserRoleinfo();
		        if (g_bRecAdmin || AdminYN == "TRUE") {
		            document.getElementById("tag07").style.display = "";
		            document.getElementById("tag08").style.display = "";
		            document.getElementById("tag09").style.display = "";
		            document.getElementById("tag10").style.display = "";
		        }
		        else if (g_bDeptCharger) {
		            document.getElementById("tag07").style.display = "";
		            document.getElementById("tag08").style.display = "";
		            document.getElementById("tag09").style.display = "none";
		            document.getElementById("tag10").style.display = "none";
		        }
		        else {
		            document.getElementById("tag07").style.display = "none";
		            document.getElementById("tag08").style.display = "none";
		            document.getElementById("tag09").style.display = "none";
		            document.getElementById("tag10").style.display = "none";
		        }
		        var idx = "4", navigation_info = "<spring:message code='ezApprovalG.t102'/>";
		        if (parseInt(pListTypeValue) < 10) {
		            window.open("/ezApprovalG/aprManage.do?listType=" + pListTypeValue, "right");
		
		            if (pListTypeValue == "1") {
		                setPresentValue("<spring:message code='ezApprovalG.t1747'/>");
		                document.getElementById('APPROVAL1').parentElement.onclick();
		                document.getElementById('APPROVAL1').onclick();
		                //document.getElementById('APPROVAL1').parentElement.setAttribute("class", "on");
		            }
		            else if (pListTypeValue == "2") {
		                setPresentValue("<spring:message code='ezApprovalG.t1748'/>");
		                document.getElementById('APPROVAL3').parentElement.onclick();
		                document.getElementById('APPROVAL3').onclick();
		                //document.getElementById('APPROVAL3').parentElement.setAttribute("class", "on");
		            }
		            else if (pListTypeValue == "3") {
		                setPresentValue("<spring:message code='ezApprovalG.t1706'/>");
		                document.getElementById('APPROVAL2').parentElement.onclick();
		                document.getElementById('APPROVAL2').onclick();
		                //document.getElementById('APPROVAL2').parentElement.setAttribute("class", "on");
		            }
		            else if (pListTypeValue == "4") {
		                setPresentValue("<spring:message code='ezApprovalG.t1749'/>");
		                document.getElementById('APPROVAL4').parentElement.onclick();
		                document.getElementById('APPROVAL4').onclick();
		                //document.getElementById('APPROVAL4').parentElement.setAttribute("class", "on");
		            }
		            else if (pListTypeValue == "6") {
		                setPresentValue("<spring:message code='ezApprovalG.t257'/>");
		            }
		        }
		        else {
		            if (pListTypeValue == "11") {
		                setPresentValue("<spring:message code='ezApprovalG.t1554'/>");
		                cmdOK_onclick('', "<spring:message code='ezApprovalG.t1750'/>");
		            }
		            if (pListTypeValue == "16") {
		                setPresentValue("<spring:message code='ezApprovalG.t552'/>");
		                DocManageMain("m01");
		            }
		            if (pListTypeValue == "17") {
		                setPresentValue("<spring:message code='ezApprovalG.t912'/>");
		                DocManageMain("m02");
		            }
		        }
		    };
		
		    function Open_Func(pthis) {
		        try {
		            switch (pthis.id) {
		                case "APPROVAL":
		                    setPresentValue("<spring:message code='ezApprovalG.t1747'/>");
		                    convMain('1', '');
		                    break;
		                case "MYCONT":
		                    cmdOK_onclick('', "<spring:message code='ezApprovalG.t1750'/>");
		                    break;
		                case "MYDRAFTCONT":
		                    cmdOK_onclick3("TBENDAPRLINEINFO.AprMemberSN:1:EXACT");
		                    break;
		                case "MYAPRCONT":
		                    cmdOK_onclick3("TBENDAPRLINEINFO.AprMemberSN:1:NOT");
		                    break;
		                case "MYDEPTCONT":
		                    break;
		                case "ITEMCONT":
		                    break;
		                case "DEPTCONT":
		                    break;
		                case "USERCONT":
		                    break;
		                case "m01":
		                    DocManageMain(pthis.id);
		                    break;
		                case "m02":
		                    DocManageMain(pthis.id);
		                    break;
		                case "m03":
		                    DocManageMain(pthis.id);
		                    break;
		                case "m05":
		                    DocManageMain(pthis.id);
		                    break;
		                case "m06":
		                    DocManageMain(pthis.id);
		                    break;
		                case "m07":
		                    DocManageMain(pthis.id);
		                    break;
		                case "m08":
		                    DocManageMain(pthis.id);
		                    break;
		                case "m09":
		                    DocManageMain(pthis.id);
		                    break;
		                case "m10":
		                    break;
		                case "ApprovalConfig":
		                    PresentOpen = "CONFIG";
		                    window.open("/MyOffice/ezPersonal/PersonInfo/ezApproval_Config_Cross.aspx", "right");
		                    break;         
		                default:
		                    break;
		            }
		            parent.frames["right"].$('#sel_year').val("ALL");
		            parent.frames["right"].$('#sel_year').selectmenu('refresh');
		        }
		        catch (e) { }
		    }
		
		    var localValue = "";
		    function setPresentValue(tempValue) {
		        if (tempValue == "")
		            tempValue = localValue;
		        else
		            localValue = tempValue;
		        document.getElementById("presentcell").innerHTML = "<b>[" + tempValue + "]</b>";
		        try {
		            if (CrossYN())
		                parent.frames["right"].document.getElementById("presentcell").textContent = " - " + tempValue;
		            else
		                parent.frames["right"].document.getElementById("presentcell").innerText = " - " + tempValue;
		        }
		        catch (e) { }
		    }
		
		    function convMain(listtype) {
		        try {
		            if (PresentOpen != "APPROVAL" || pListTypeValue == "") {
		                pListTypeValue = listtype;
		                PresentOpen = "APPROVAL";
		                window.parent.frames.right.document.location.href = "/myoffice/ezApprovalG/aprmanage_B_Cross.aspx?listType=" + listtype;
		            }
		            else {
		                if (listtype == "1") {
		                    parent.frames["right"].passValLeftMenu("1");
		                    parent.frames["right"].getDocList();
		                }
		                else if (listtype == "3") {
		                    parent.frames["right"].passValLeftMenu("3");
		                    parent.frames["right"].getDocList();
		                }
		                else if (listtype == "2") {
		                    parent.frames["right"].passValLeftMenu("2");
		                    parent.frames["right"].getDocList();
		                }
		                else if (listtype == "4") {
		                    parent.frames["right"].passValLeftMenu("4");
		                    parent.frames["right"].getReceivedDocList();
		                }
		                else if (listtype == "6") {
		                    parent.frames["right"].passValLeftMenu("6");
		                    parent.frames["right"].getSimsaDocList();
		                }
		                else if (listtype == "7") {
		                    parent.frames["right"].passValLeftMenu("7");
		                    parent.frames["right"].getSendOutDocList();
		                }
		                else if (listtype == "8") {
		                    parent.frames["right"].passValLeftMenu("8");
		                    parent.frames["right"].getSendOutDocList();
		                }
		                else if (listtype == "9") {
		                    parent.frames["right"].passValLeftMenu("9");
		                    parent.frames["right"].getSendOutDocList();
		                }
		                else if (listtype == "10") {
		                    parent.frames["right"].passValLeftMenu("10");
		                    parent.frames["right"].getDocList();
		                }
		                else if (listtype == "99") {
		                    parent.frames["right"].passValLeftMenu("99");
		                    parent.frames["right"].getDocList();
		                }
		                else if (listtype == "21") {
		                    parent.frames["right"].passValLeftMenu("21");
		                    parent.frames["right"].getDocList();
		                }
		                else {
		                    parent.frames["right"].passValLeftMenu("1");
		                    parent.frames["right"].getDocList();
		                }
		            }
		            try { parent.frames["right"].document.getElementById("txt_keyword").value = ""; } catch (e) { }
		            parent.frames["right"].$('#sel_year').val("ALL");
		            parent.frames["right"].$('#sel_year').selectmenu('refresh');
		        }
		        catch (e) { }
		    }
		
		    function btnDraft_onclick() {
		        parent.frames["right"].btnDraft_onclick();
		    }
		
		    function cmdOK_onclick(ContainerID, ContName) {
		        if (PresentOpen != "CONTAINER") {
		            PresentOpen = "CONTAINER";
		            if (ContName == "<spring:message code='ezApprovalG.t1517'/>"){
		                window.parent.frames.right.document.location.href = "/ezApprovalG/getContainerInfo.do?contID=" + encodeURI(ContainerID) + "&sQuery=&type=1";
		            }
		            else {
		                window.parent.frames.right.document.location.href = "/ezApprovalG/getContainerInfo.do?contID=" + encodeURI(ContainerID) + "&sQuery=";
		            }
		        }
		        else {
		            try {
		                parent.frames["right"].SelCont_onclick2(ContainerID, ContName);
		            } catch (e) { }
		        }
		    }
		
		    function cmdOK_onclick2(ContainerID, ContName) {
		        if (PresentOpen != "CONTAINER") {
		            PresentOpen = "CONTAINER";
		            window.parent.frames.right.document.location.href = "/ezApprovalG/getContainerInfo.do?contID=" + encodeURI(Containers) + "&sQuery=" + encodeURI(ContainerID);
		        }
		        else {
		            try {
		                parent.frames["right"].SelCont_onclick3(ContainerID, Containers, ContName);
		            } catch (e) { }
		        }
		    }
		
		    function getAprCount() {
		        try {
		            getAprTotalCount();
		
		        } catch (e) { }
		    }
		
		    var xmlhttp_total = createXMLHttpRequest();
		    function getAprTotalCount() {
		        if (ViewLeftCount == "YES") {
		            var strQuery = "<DATA><LISTTYPE>1</LISTTYPE></DATA>";
		            xmlhttp_total = null;
		            xmlhttp_total = createXMLHttpRequest();
		            xmlhttp_total.open("POST", "/ezApprovalG/getListCount.do?mode=LEFT", true);
		            xmlhttp_total.onreadystatechange = getAprTotalCount_after;
		            xmlhttp_total.send(strQuery);
		        }
		    }
		
		    function getAprTotalCount_after() {
		        if (xmlhttp_total == null || xmlhttp_total.readyState != 4) return;
		        try {
		            if (xmlhttp_total.responseText == "") return;
		            var ResultXML = "";
		            ResultXML = xmlhttp_total.responseXML;
		            
		            // 결재할 문서
		            if (pListTypeValue != "1") {
		                if (getNodeText(ResultXML.getElementsByTagName("COUNT").item(0)) > 0)
		                    count1.innerHTML = "<b>(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(0)) + ")</b>";
		                else
		                    count1.innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(0)) + ")";
		            }
		            // 결재진행문서
		            if (pListTypeValue != "3") {
		                if (getNodeText(ResultXML.getElementsByTagName("COUNT").item(1)) > 0)
		                    count2.innerHTML = "<b>(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(1)) + ")</b>";
		                else
		                    count2.innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(1)) + ")";
		            }
		            // 기안한문서
		            if (pListTypeValue != "2") {
		                if (getNodeText(ResultXML.getElementsByTagName("COUNT").item(2)) > 0)
		                    count3.innerHTML = "<b>(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(2)) + ")</b>";
		                else
		                    count3.innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(2)) + ")";
		            }
		            // 부서수신함
		            if (pListTypeValue != "4") {
		                if (getNodeText(ResultXML.getElementsByTagName("COUNT").item(3)) > 0)
		                    count4.innerHTML = "<b>(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(3)) + ")</b>";
		                else
		                    count4.innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(3)) + ")";
		            }
		            // 발송의뢰문서
		            if (pListTypeValue != "6") {
		                if (getNodeText(ResultXML.getElementsByTagName("COUNT").item(4)) > 0)
		                    count6.innerHTML = "<b>(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(4)) + ")</b>";
		                else
		                    count6.innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(4)) + ")";
		            }
		            // 임시보관함
		            if (pListTypeValue != "21") {
		                if (getNodeText(ResultXML.getElementsByTagName("COUNT").item(8)) > 0)
		                    count21.innerHTML = "<b>(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(8)) + ")</b>";
		                else
		                    count21.innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(8)) + ")";
		            }
		            try {
		                // 공람문서
		                if (pListTypeValue != "99") {
		                    if (getNodeText(ResultXML.getElementsByTagName("COUNT").item(7)) > 0)
		                        count99.innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(7)) + ")";
		                    else
		                        count99.innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(7)) + ")";
		                }
		            } catch (e) { }
		            try {
		                // 직인의뢰함
		                if (pListTypeValue != "7") {
		                    if (getNodeText(ResultXML.getElementsByTagName("COUNT").item(5)) > 0)
		                        count7.innerHTML = "<b>(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(5)) + ")</b>";
		                    else
		                        count7.innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(5)) + ")";
		                }
		            } catch (e) { }
		            
		        } catch (e) { }
		    }
		
		    var xmlhttp_1 = createXMLHttpRequest();
		    function getAprCount1() {
		        var strQuery = "<DATA><LISTTYPE>1</LISTTYPE></DATA>";
		        xmlhttp_1.open("POST", "/ezApprovalG/getListCount.do", true);
		        xmlhttp_1.onreadystatechange = getAprCount1_after;
		        xmlhttp_1.send(strQuery);
		    }
		
		    function getAprCount1_after() {
		        if (xmlhttp_1 == null || xmlhttp_1.readyState != 4) return;
		        try {
		            if (xmlhttp_1.responseText == "") return;
		            var ResultXML = xmlhttp_1.responseXML;
		            var cnt = getNodeText(GetChildNodes(ResultXML)[0]);
		            if (cnt > 0)
		                count1.innerHTML = "<b>(" + cnt + ")</b>";
		            else
		                count1.innerHTML = "(" + cnt + ")";
		        } catch (e) { }
		    }
		
		    var xmlhttp_2 = createXMLHttpRequest();
		    function getAprCount2() {
		        var strQuery = "<DATA><LISTTYPE>2</LISTTYPE></DATA>";
		        xmlhttp_2.open("POST", "/ezApprovalG/getListCount.do", true);
		        xmlhttp_2.onreadystatechange = getAprCount2_after;
		        xmlhttp_2.send(strQuery);
		    }
		
		    function getAprCount2_after() {
		        if (xmlhttp_2 == null || xmlhttp_2.readyState != 4) return;
		        try {
		            if (xmlhttp_2.responseText == "") return;
		            var ResultXML = xmlhttp_2.responseXML;
		            var cnt = getNodeText(GetChildNodes(ResultXML)[0]);
		
		            if (cnt > 0)
		                count2.innerHTML = "<b>(" + cnt + ")</b>";
		            else
		                count2.innerHTML = "(" + cnt + ")";
		        } catch (e) { }
		    }
		
		    var xmlhttp_3 = createXMLHttpRequest();
		    function getAprCount3() {
		        var strQuery = "<DATA><LISTTYPE>3</LISTTYPE></DATA>";
		        xmlhttp_3.open("POST", "/ezApprovalG/getListCount.do", true);
		        xmlhttp_3.onreadystatechange = getAprCount3_after;
		        xmlhttp_3.send(strQuery);
		    }
		
		    function getAprCount3_after() {
		        if (xmlhttp_3 == null || xmlhttp_3.readyState != 4) return;
		        try {
		            if (xmlhttp_3.responseText == "") return;
		            var ResultXML = xmlhttp_3.responseXML;
		            var cnt = getNodeText(GetChildNodes(ResultXML)[0]);
		            if (cnt > 0)
		                count3.innerHTML = "<b>(" + cnt + ")</b>";
		            else
		                count3.innerHTML = "(" + cnt + ")";
		        } catch (e) { }
		    }
		
		    var xmlhttp_4 = createXMLHttpRequest();
		    function getAprCount4() {
		        var strQuery = "<DATA><LISTTYPE>4</LISTTYPE></DATA>";
		        xmlhttp_4.open("POST", "/ezApprovalG/getListCount.do", true);
		        xmlhttp_4.onreadystatechange = getAprCount4_after;
		        xmlhttp_4.send(strQuery);
		    }
		
		    function getAprCount4_after() {
		        if (xmlhttp_4 == null || xmlhttp_4.readyState != 4) return;
		        try {
		            if (xmlhttp_4.responseText == "") return;
		            var ResultXML = xmlhttp_4.responseXML;
		            var cnt = getNodeText(GetChildNodes(ResultXML)[0]);
		            if (cnt > 0)
		                count4.innerHTML = "<b>(" + cnt + ")</b>";
		            else
		                count4.innerHTML = "(" + cnt + ")";
		        } catch (e) { }
		    }
		
		    var xmlhttp_6 = createXMLHttpRequest();
		    function getAprCount6() {
		        var strQuery = "<DATA><LISTTYPE>5</LISTTYPE></DATA>";
		        xmlhttp_6.open("POST", "/ezApprovalG/getListCount.do", true);
		        xmlhttp_6.onreadystatechange = getAprCount6_after;
		        xmlhttp_6.send(strQuery);
		    }
		
		    function getAprCount6_after() {
		        if (xmlhttp_6 == null || xmlhttp_6.readyState != 4) return;
		        try {
		            if (xmlhttp_6.responseText == "") return;
		            var ResultXML = xmlhttp_6.responseXML;
		            var cnt = getNodeText(GetChildNodes(ResultXML)[0]);
		            if (cnt > 0)
		                count6.innerHTML = "<b>(" + cnt + ")</b>";
		            else
		                count6.innerHTML = "(" + cnt + ")";
		        } catch (e) { }
		    }
		
		    var xmlhttp_7 = createXMLHttpRequest();
		    function getAprCount7() {
		        var strQuery = "<DATA><LISTTYPE>7</LISTTYPE></DATA>";
		        xmlhttp_7.open("POST", "/ezApprovalG/getListCount.do", true);
		        xmlhttp_7.onreadystatechange = getAprCount7_after;
		        xmlhttp_7.send(strQuery);
		    }
		
		    function getAprCount7_after() {
		        if (xmlhttp_7 == null || xmlhttp_7.readyState != 4) return;
		        try {
		            if (xmlhttp_7.responseText == "") return;
		            var ResultXML = xmlhttp_7.responseXML;
		            var cnt = getNodeText(GetChildNodes(ResultXML)[0]);
		            if (cnt > 0)
		                count7.innerHTML = "<b>(" + cnt + ")</b>";
		            else
		                count7.innerHTML = "(" + cnt + ")";
		        } catch (e) { }
		    }
		
		    var xmlhttp_99 = createXMLHttpRequest();
		    function getAprCount99() {
		        var strQuery = "<DATA><LISTTYPE>99</LISTTYPE></DATA>";
		        xmlhttp_99.open("POST", "/ezApprovalG/getListCount.do", true);
		        xmlhttp_99.onreadystatechange = getAprCount99_after;
		        xmlhttp_99.send(strQuery);
		    }
		
		    function getAprCount99_after() {
		        if (xmlhttp_99 == null || xmlhttp_99.readyState != 4) return;
		        try {
		            if (xmlhttp_99.responseText == "") return;
		            var ResultXML = xmlhttp_99.responseXML;
		            var cnt = getNodeText(GetChildNodes(ResultXML)[0]);
		            if (cnt > 0)
		                count99.innerHTML = "<b>(" + cnt + ")</b>";
		            else
		                count99.innerHTML = "(" + cnt + ")";
		        } catch (e) { }
		    }
		
		    function Menu_Click(pthis) {
		        try {
		            switch (pthis.id) {
		                case "admin_sub01":
		                    PresentOpen = "DOC_ADMIN";
		                    window.parent.frames.right.document.location.href = "/myoffice/ezApprovalG/ezCabinet/Manage/TaskManage_Cross.aspx";
		                    break;
		                case "admin_sub02":
		                    PresentOpen = "DOC_ADMIN";
		                    window.parent.frames.right.document.location.href = "/myoffice/ezApprovalG/ezCabinet/Manage/CabTransfer_Cross.aspx";
		                    break;
		                case "admin_sub03":
		                    PresentOpen = "DOC_ADMIN";
		                    window.parent.frames.right.document.location.href = "/myoffice/ezApprovalG/ezCabinet/Manage/AdminPage_Cross.aspx?InitFlag=4";
		                    break;
		                case "admin_sub04":
		                    PresentOpen = "DOC_ADMIN";
		                    window.parent.frames.right.document.location.href = "/myoffice/ezApprovalG/ezCabinet/Manage/AdminPage_Cross.aspx?InitFlag=0";
		                    break;
		                case "admin_sub05":
		                    PresentOpen = "DOC_ADMIN";
		                    window.parent.frames.right.document.location.href = "/myoffice/ezApprovalG/ezCabinet/Manage/AdminPage_Cross.aspx?InitFlag=1";
		                    break;
		                case "admin_sub06":
		                    PresentOpen = "DOC_ADMIN";
		                    window.parent.frames.right.document.location.href = "/myoffice/ezApprovalG/ezCabinet/Manage/AdminPage_Cross.aspx?InitFlag=2";
		                    break;
		                case "admin_sub07":
		                    PresentOpen = "DOC_ADMIN";
		                    window.parent.frames.right.document.location.href = "/myoffice/ezApprovalG/ezCabinet/Manage/AdminPage_Cross.aspx?InitFlag=3";
		                    break;
		            }
		        } catch (e) { }
		    }
		
		    function DocManageMain(sFlag) {
		        try {
		            if (PresentOpen != "DOCMANAGE") {
		                PresentOpen = "DOCMANAGE";
		                window.parent.frames.right.document.location.href = "/myoffice/ezApprovalG/ezCabinet/CabinetMain_Cross.aspx?sFlag=" + sFlag;
		            }
		            else {
		                window.parent.frames["right"].g_uFlag = sFlag;
		                switch (sFlag) {
		                    case "m01":
		                        window.parent.frames.right.document.location.href = "/myoffice/ezApprovalG/ezCabinet/cabinetmain_Cross.aspx?sFlag=" + sFlag;
		                        break;
		                    case "m02":
		                        window.parent.frames.right.document.location.href = "/myoffice/ezApprovalG/ezCabinet/cabinetmain_Cross.aspx?sFlag=" + sFlag;
		                        break;
		                    case "m03":
		                        window.parent.frames.right.document.location.href = "/myoffice/ezApprovalG/ezCabinet/cabinetmain_Cross.aspx?sFlag=" + sFlag;
		                        break;
		                    case "m04":
		                        window.parent.frames.right.document.location.href = "/myoffice/ezApprovalG/ezCabinet/cabinetmain_Cross.aspx?sFlag=" + sFlag;
		                        break;
		                    case "m05":
		                        window.parent.frames.right.document.location.href = "/myoffice/ezApprovalG/ezCabinet/cabinetmain_Cross.aspx?sFlag=" + sFlag;
		                        break;
		                    case "m06":
		                        window.parent.frames.right.document.location.href = "/myoffice/ezApprovalG/ezCabinet/cabinetmain_Cross.aspx?sFlag=" + sFlag;
		                        break;
		                    case "m07":
		                        window.parent.frames.right.document.location.href = "/myoffice/ezApprovalG/ezCabinet/cabinetmain_Cross.aspx?sFlag=" + sFlag;
		                        break;
		                    case "m08":
		                        window.parent.frames.right.document.location.href = "/myoffice/ezApprovalG/ezCabinet/cabinetmain_Cross.aspx?sFlag=" + sFlag;
		                        break;
		                    case "m09":
		                        window.parent.frames.right.document.location.href = "/myoffice/ezApprovalG/ezCabinet/cabinetmain_Cross.aspx?sFlag=" + sFlag;
		                        break;
		                }
		            }
		        } catch (e) { }
		    }
		    var arr_userinfo = new Array();
		    function ChangeSubtitle(obj) {
		        var UseSelectTitle = obj.getAttribute("href").split("#")[1].split("|");
		        if ("${userInfo.deptID}" != UseSelectTitle[0]) {
		            arr_userinfo[4] = UseSelectTitle[0];
		            arr_userinfo[5] = UseSelectTitle[1];
		            arr_userinfo[3] = UseSelectTitle[2];
		            arr_userinfo[13] = UseSelectTitle[5];
		            arr_userinfo[14] = UseSelectTitle[6];
		            arr_userinfo[15] = UseSelectTitle[3];
		            arr_userinfo[16] = UseSelectTitle[4];
		            DeptID = UseSelectTitle[0];
		            ChangeCookies();
		
		            if (pListTypeValue == "7" || pListTypeValue == "8" || pListTypeValue == "9")
		                pListTypeValue = "1";
		
		            parent.frames["left"].location.href = "/myoffice/ezApprovalG/left_approval_Cross.aspx?listType=" + pListTypeValue;
		        }
		    }
		    function ChangeCookies() {
		        var xmlhttp = createXMLHttpRequest();
		        var xmlpara = createXmlDom();
		        var objNode;
		        createNodeInsert(xmlpara, objNode, "DATA");
		        createNodeAndInsertText(xmlpara, objNode, "DEPTID", arr_userinfo[4]);
		        createNodeAndInsertText(xmlpara, objNode, "DEPTNAME", arr_userinfo[5]);
		        createNodeAndInsertText(xmlpara, objNode, "POSITION", arr_userinfo[3]);
		        createNodeAndInsertText(xmlpara, objNode, "DEPTNAME1", arr_userinfo[15]);
		        createNodeAndInsertText(xmlpara, objNode, "DEPTNAME2", arr_userinfo[16]);
		        createNodeAndInsertText(xmlpara, objNode, "POSITION1", arr_userinfo[13]);
		        createNodeAndInsertText(xmlpara, objNode, "POSITION2", arr_userinfo[14]);
		        xmlhttp.open("POST", "Include/ChangeUserInfo.aspx", false);
		        xmlhttp.send(xmlpara);
		    }
		</script>
	</head>
	<body class="leftbody" style="overflow-y:auto; ">
		<span  id="presentcell" style="display:none"></span>
		<div id="left" style="overflow-x:hidden">
			<div class="left_appr" title="<spring:message code='ezApprovalG.t102'/>"></div>
			<c:if test="${isSubTitle}">
		        <select name="country_id" id="country_id" tabindex="1">
		            ${subTitleString}
				</select>
			</c:if>
			<h2><span style="width:100%; display:inline-block;" id="APPROVAL" onClick="Open_Func(this)"><spring:message code='ezApprovalG.t102'/></span></h2>
			<ul id="iconul">
				<li><span style="width:100%;display:inline-block;" id="APPROVAL1" onClick="setPresentValue('<spring:message code='ezApprovalG.t1747'/>');convMain('1')"><img src="/images/ImgIcon/icon_approval.gif" width="16" height="16" class="icon"><spring:message code='ezApprovalG.t1747'/><span id=count1></span></span></li>
				<li><span style="width:100%;display:inline-block;" id="APPROVAL2" onClick="setPresentValue('<spring:message code='ezApprovalG.t1706'/>');convMain('3')"><img src="/images/ImgIcon/icon_ingapproval.gif" width="16" height="16" class="icon"><spring:message code='ezApprovalG.t1706'/><span id=count2></span></span></li>
				<li><span style="width:100%;display:inline-block;" id="APPROVAL3" onClick="setPresentValue('<spring:message code='ezApprovalG.t1748'/>');convMain('2')"><img src="/images/ImgIcon/icon_writeapproval.gif" width="16" height="16" class="icon"><spring:message code='ezApprovalG.t1748'/><span id=count3></span></span></li>
				<li><span style="width:100%;display:inline-block;" id="APPROVAL4" onClick="setPresentValue('<spring:message code='ezApprovalG.t1749'/>');convMain('4')"><img src="/images/ImgIcon/icon_partapproval.gif" width="16" height="16" class="icon"><spring:message code='ezApprovalG.t1749'/><span id=count4></span></span></li>
				<li><span style="width:100%;display:inline-block;" id="APPROVAL5" onClick="setPresentValue('<spring:message code='ezApprovalG.t257'/>');convMain('6')"><img src="/images/ImgIcon/icon_senddoc.gif" width="16" height="16" class="icon"><spring:message code='ezApprovalG.t257'/><span id=count6></span></span></li>
				<c:if test="${infoXML != ''}">
					<li><span style="width:100%;display:inline-block;cursor:pointer;"  id="APPROVAL9" onClick="setPresentValue('<spring:message code='ezApprovalG.t1751'/>');convMain('9')" ><img src="/images/ImgIcon/icon_listsenddoc.gif" width="16" height="16" class="icon"><spring:message code='ezApprovalG.t1751'/></span></li>
				</c:if>
				<c:if test="${userSendOut == 'YES'}">
					<li><span style="width:100%;display:inline-block;cursor:pointer;"  id="APPROVAL7" onClick="setPresentValue('<spring:message code='ezApprovalG.t1752'/>');convMain('7')"><img src="/images/ImgIcon/icon_stamp.gif" width="16" height="16" class="icon"><spring:message code='ezApprovalG.t1752'/><span id=count7></span></span></li>
					<li><span style="width:100%;display:inline-block;cursor:pointer;"  id="APPROVAL8" onClick="setPresentValue('<spring:message code='ezApprovalG.t1275'/>');convMain('8')"><img src="/images/ImgIcon/icon_liststamp.gif" width="16" height="16" class="icon"><spring:message code='ezApprovalG.t1275'/></span></li>
				</c:if>
	            <li><span id="APPROVAL21" onClick="setPresentValue('<spring:message code='ezApprovalG.t3000'/>');convMain('21')" ><img src="/images/ImgIcon/icon_extraappr.gif" width="16" height="16" class="icon"><spring:message code='ezApprovalG.t3000'/></span><span id=count21></span></li>
			</ul>
	        <h2><span style="width:100%; display:inline-block" onClick="setPresentValue('<spring:message code='ezApprovalG.t10011'/>');convMain('99')"><spring:message code='ezApprovalG.t10010'/><span id=count99></span></span></h2>
	         <ul id="iconul">
			    <li><span style="width:100%;display:inline-block;"  id="APPROVAL99" onClick="setPresentValue('<spring:message code='ezApprovalG.t10011'/>');convMain('99')"><img src="/images/ImgIcon/icon_displaypaper.gif" width="16" height="16" class="icon"><spring:message code='ezApprovalG.t10011'/></span></li>
			    <li><span style="width:100%;display:inline-block;"  id="APPROVAL10" onClick="setPresentValue('<spring:message code='ezApprovalG.t1787'/>');convMain('10')"><img src="/images/ImgIcon/icon_enddisplaypaper.gif" width="16" height="16" class="icon"><spring:message code='ezApprovalG.t1787'/></span></li>
			</ul>
	
			<h2><span style="width:100%;display:inline-block;"  id="MYCONT" onClick="setPresentValue('<spring:message code='ezApprovalG.t1554'/>');Open_Func(this)"><spring:message code='ezApprovalG.t1554'/></span><ul></ul></h2>
			<h2><span style="width:100%;display:inline-block;"  id="MYDEPTCONT" onClick="Open_Func(this)"><spring:message code='ezApprovalG.t1755'/></span></h2>
			<ul>
				<c:choose>
					<c:when test="${fn:length(apprGLeftVOList) > 0}">
						<c:forEach var="apprGLeftVOList" items="${apprGLeftVOList}" varStatus="status">
							<c:choose>
								<c:when test="${strLang == ''}">
									<li><span style="width:100%;display:inline-block;" id="myDeptCont${status.count - 1}" onClick="setPresentValue('${apprGLeftVOList.containerTypeName}');cmdOK_onclick('\'${apprGLeftVOList.containerID}\'', '${apprGLeftVOList.containerTypeName}')" >${apprGLeftVOList.containerTypeName}</span></li>
								</c:when>
								<c:otherwise>
									<li><span style="width:100%;display:inline-block;" id="myDeptCont${status.count - 1}" onClick="setPresentValue('${apprGLeftVOList.containerTypeName2}');cmdOK_onclick('\'${apprGLeftVOList.containerID}\'', '${apprGLeftVOList.containerTypeName2}')" >${apprGLeftVOList.containerTypeName2}</span></li>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</c:when>
					<c:when test="${fn:indexOf(optGamsabu, userInfo.deptID) < 0}">
						<li><span style="width:100%;display:inline-block;"><spring:message code='ezApprovalG.t1788'/></span></li>
					</c:when>
				</c:choose>
				<c:if test="${fn:indexOf(optGamsabu, userInfo.deptID) > -1}">
					<li><span style="width:100%;display:inline-block;" onClick="setPresentValue('<spring:message code='ezApprovalG.t1517'/>');cmdOK_onclick('GAMSAHAM', '<spring:message code='ezApprovalG.t1517'/>')" ><spring:message code='ezApprovalG.t1517'/></span></li>
				</c:if>						
			</ul> 		
			<h2><span style="width:100%;display:inline-block;" id="m01" onClick="Open_Func(this)"><spring:message code='ezApprovalG.t552'/></span><ul></ul></h2>
			<h2><span style="width:100%;display:inline-block;" id="m02" onClick="Open_Func(this)"><spring:message code='ezApprovalG.t912'/></span><ul></ul></h2>
			<h2><span style="width:100%;display:inline-block;" id="m03" onClick="Open_Func(this)"><spring:message code='ezApprovalG.t911'/></span><ul></ul></h2>
			<h2><span style="width:100%;display:inline-block;" id="m05" onClick="Open_Func(this)"><spring:message code='ezApprovalG.t905'/></span><ul></ul></h2>
			<h2><span style="width:100%;display:inline-block;" id="m06" onClick="Open_Func(this)"><spring:message code='ezApprovalG.t906'/></span><ul></ul></h2>
			<h2 id="tag07"><span style="width:100%;display:inline-block;" id="m07" onClick="Open_Func(this)"><spring:message code='ezApprovalG.t524'/></span><ul></ul></h2>
			<h2 id="tag08"><span style="width:100%;display:inline-block;" id="m08" onClick="Open_Func(this)"><spring:message code='ezApprovalG.t908'/></span><ul></ul></h2>
			<h2 id="tag09"><span style="width:100%;display:inline-block;" id="m09" onClick="Open_Func(this)" ><spring:message code='ezApprovalG.t909'/></span><ul></ul></h2>
			<h2 id="tag10"><span style="width:100%;display:inline-block;" id="m10" onClick="Open_Func(this)" ><spring:message code='ezApprovalG.t1753'/></span></h2>
			<ul>
				<li><span style="width:100%;display:inline-block;" id="admin_sub01" onClick="Menu_Click(this)" ><spring:message code='ezApprovalG.t717'/></span></li>
				<li><span style="width:100%;display:inline-block;" id="admin_sub02" onClick="Menu_Click(this)" ><spring:message code='ezApprovalG.t1754'/></span></li>
				<li><span style="width:100%;display:inline-block;" id="admin_sub03" onClick="Menu_Click(this)" ><spring:message code='ezApprovalG.t524'/></span></li>
				<li><span style="width:100%;display:inline-block;" id="admin_sub04" onClick="Menu_Click(this)" ><spring:message code='ezApprovalG.t520'/></span></li>
			</ul>
	        <h3><span  style="width:100%;display:inline-block;" id="ApprovalConfig" onClick="Open_Func(this)"><spring:message code='ezApprovalG.t1800'/></span></h3>
		</div>
		<script type="text/javascript">
			initToggleList(document.getElementById("left"), "h2", "ul", "li");
		</script> 
	</body>
</html>
