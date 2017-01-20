<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE HTML>
<html>
	<head>
	    <title></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=uft-8">
	    <link rel="stylesheet" href="<spring:message code='ezApproval.e2'/>" type="text/css">
	    <link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
	    <link href="/css/jquery.selectbox.css" type="text/css" rel="stylesheet" />
	    <script type="text/javascript" src="<spring:message code='ezApproval.e1'/>" ></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery.selectbox-0.2.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/ezApproval/control/TreeView.js"></script>
	    <script type="text/javascript" src="/js/ezApproval/aprmanage_comm.js"></script>
	    <style>
	        .instance.sbHolder{
	            width: 100%;
	        }
	    </style>
	    <script type="text/javascript">
	        var pListTypeValue = "${listType}";
	        var PresentOpen = "";
	        var pUserID = "${userInfo.id}";
	        var pDeptID = "${userInfo.deptID}";
	        var CompanyID = '${userInfo.companyID}';
	        var CompanyName = '${userInfo.companyName}';
	        var gMenuFlag = 1
	        var contFlag = "END";
	        var pChackYN = "FALSE";
	        var ContainerID;
	        var PageSize = 10;
	        var Containers = "${containers}";
	        var AprListCont = "<%=AprListCont%>";
	        var RtnListCont = "<%=RtnListCont%>";
	        var SubContCount = "<%=SCont.GetElementsByTagName("SC001").Count + SCont.GetElementsByTagName("SC002").Count + SCont.GetElementsByTagName("SC003").Count + SCont.GetElementsByTagName("SC004").Count + SCont.GetElementsByTagName("SC006").Count%>";
	        var presentValue = 0;
	        var tmpValue = "";
	        var nodeIdx;
	        var ViewLeftCount = "<%=ViewLeftCount%>";
	        $(function () {
	            if ("<%=isSubTitle %>" == "True")
	                $("#SubTitle_obj").selectbox();
	            $(".sbHolder").each(function (index) {
	                $(this).addClass('instance');
	            });
	        });
	        document.onselectstart = function () {
	            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	                return false;
	            else
	                return true;
	        };
	        window.onload = function () {
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }
	            var idx = "4", navigation_info = "<%=RM.GetString("t824")%>";
	            Tree_setconfig();
	            var xmlDom2 = createXmlDom();
	            xmlDom2 = loadXMLString("<%=strXML3%>");
	            var treeView = new TreeView();
	            treeView.SetID("UserContTree");
	            treeView.SetUseAgency(true);
	            treeView.SetRequestData("UserContRequestData");
	            treeView.SetNodeClick("UserContNodeClick");
	            treeView.DataSource(xmlDom2);
	            treeView.DataBind("divUserContTree");
	            var xmlDom3 = createXmlDom();
	            xmlDom3 = loadXMLString("<%=strXML5%>");
	            var treeView = new TreeView();
	            treeView.SetID("DeptContTree");
	            treeView.SetUseAgency(true);
	            treeView.SetRequestData("DeptContRequestData");
	            treeView.SetNodeClick("DeptContNodeClick");
	            treeView.DataSource(xmlDom3);
	            treeView.DataBind("divDeptContTree");
	            if (pListTypeValue == "1") {
	                setPresentValue("<%=RM.GetString("t837")%>");
	                document.getElementById('APPROVAL1').parentElement.onclick();
	                document.getElementById('APPROVAL1').onclick();
	                
	            }
	            else if (pListTypeValue == "3") {
	                setPresentValue("<%=RM.GetString("t791")%>");
	                document.getElementById('APPROVAL2').parentElement.onclick();
	                document.getElementById('APPROVAL2').onclick();
	                
	            }
	            else if (pListTypeValue == "2") {
	                setPresentValue("<%=RM.GetString("t838")%>");
	                document.getElementById('APPROVAL3').parentElement.onclick();
	                document.getElementById('APPROVAL3').onclick();
	                
	            }
	            else if (pListTypeValue == "4") {
	                setPresentValue("<%=RM.GetString("t796")%>");
	                document.getElementById('APPROVAL4').parentElement.onclick();
	                document.getElementById('APPROVAL4').onclick();
	                
	            }
	            else if (pListTypeValue == "6") {
	                setPresentValue("<%=RM.GetString("t839")%>");
	            }
	            else if (pListTypeValue == "9") {
	                setPresentValue("<%=RM.GetString("t920")%>");
	                document.getElementById('APPROVAL9').parentElement.onclick();
	                document.getElementById('APPROVAL9').onclick();
	                
	            }
	
	            getAprCount();
	        }
			function getAprCount() {
			    try {
			        getAprTotalCount();
			        presentValue = 0;
			        getAprCountTemp();
			    } catch (e) { }
			}
			function Tree_setconfig() {
			    var xmlHTTP = createXMLHttpRequest();
			    xmlHTTP.open("GET", "/myoffice/ezApproval/control_Cross/conttree_config.xml", false);
			    xmlHTTP.send();
			
			    if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
			        var treeView = new TreeView();
			        treeView.SetConfig(loadXMLString(xmlHTTP.responseText));
			    }
			}
			function Open_Func(pthis) {
			    try {
			        switch (pthis.id) {
			            case "APPROVAL":
			                break;
			            case "MYCONT":
			                cmdOK_onclick('', '<%=RM.GetString("t840")%>', '');
			                break;
			            case "MYCONTWHO":
			                cmdOK_onclick('', '<%=RM.GetString("t841")%>', "TBENDAPRLINEINFO.AprType = '" + strAprType40 + "' AND TBENDAPRLINEINFO.AprState = '" + strAprState2 + "'");
			                break;
			            case "MYDRAFTCONT":
			                cmdOK_onclick3("TBENDAPRLINEINFO.AprMemberSN:1:EXACT")
			                break;
			            case "MYAPRCONT":
			                cmdOK_onclick3("TBENDAPRLINEINFO.AprMemberSN:1:NOT")
			                break;
			            case "MYDEPTCONT":
			                break;
			            case "ITEMCONT":
			                break;
			            case "DEPTCONT":
			                break;
			            case "USERCONT":
			                break;
			            case "LIST":
			                break;
			            case "ApprovalConfig":
			                PresentOpen = "CONFIG";
			                window.open("/myoffice/ezPersonal/PersonInfo/ezApproval_Config.aspx", "right");
			                break;
			            default:
			                break;
			        }
			    } catch (e) { }
			}
			var localValue = "";
			function setPresentValue(tempValue) {
			    if (tempValue == "")
			        tempValue = localValue;
			    else
			        localValue = tempValue;
			    try {
			        tmpValue = tempValue;
			    } catch (e) { }
			}
			function convMain(listtype, SubQuery) {
			    try {
			        if (PresentOpen != "APPROVAL") {
			            PresentOpen = "APPROVAL";
			            window.parent.frames.right.document.location.href = "/myoffice/ezApproval/AprManage_B.aspx?listType=" + listtype + "&SubQuery=" + escape(SubQuery) + "&tmpValue=" + escape(tmpValue);
			        }
			        else {
			            window.parent.frames.right.document.location.href = "/myoffice/ezApproval/AprManage_B.aspx?listType=" + listtype + "&SubQuery=" + escape(SubQuery) + "&tmpValue=" + escape(tmpValue);
			        }
			    } catch (e) { }
			}
			function btnDraft_onclick() {
			    window.parent.frames("right").document.Script.btnDraft_onclick();
			}
			function cmdOK_onclick(ContainerID, ContName, SubQuery) {
			    if (PresentOpen != "CONTAINER") {
			        PresentOpen = "CONTAINER";
			        window.parent.frames.right.document.location.href = "/myoffice/ezApproval/formContainer/getContainerInfo2.aspx?contID=" + escape(ContainerID) + "&SQuery=" + escape(SubQuery) + "&tmpValue=" + escape(ContName) + "&ENDAPRTYPE=" + strAprType40 + "&ENDAPRSTATE=" + strAprState2;
			    }
			    else {
			        try {
			            window.parent.frames.right.document.location.href = "/myoffice/ezApproval/formContainer/getContainerInfo2.aspx?contID=" + escape(ContainerID) + "&SQuery=" + escape(SubQuery) + "&tmpValue=" + escape(ContName) + "&ENDAPRTYPE=" + strAprType40 + "&ENDAPRSTATE=" + strAprState2;
			            
			        } catch (e) { }
			    }
			}
			var primaryStr = "<%=primaryStr%>";
	        function cmdOK_onclick2(ContainerID, ContainerName, ContName) {
	            if (primaryStr == "1") {
	                if (PresentOpen != "CONTAINER") {
	                    PresentOpen = "CONTAINER";
	                    var subCondition = "TBEXPENDAPRDOCINFO.itemcode = '" + ContainerID + "' and TBEXPENDAPRDOCINFO.itemName = '" + ContainerName + "'";
	                    window.parent.frames.right.document.location.href = "/myoffice/ezApproval/formContainer/getContainerInfo2.aspx?contID=" + escape(Containers) + "&SQuery=" + escape(subCondition) + "&tmpValue=" + escape(tmpValue) + "&itemID=" + ContainerID;
	                }
	                else {
	                    try {
	                        var subCondition = "TBEXPENDAPRDOCINFO.itemcode = '" + ContainerID + "' and TBEXPENDAPRDOCINFO.itemName = '" + ContainerName + "'";
	                        window.parent.frames.right.document.location.href = "/myoffice/ezApproval/formContainer/getContainerInfo2.aspx?contID=" + escape(Containers) + "&SQuery=" + escape(subCondition) + "&tmpValue=" + escape(tmpValue) + "&itemID=" + ContainerID;
	                        window.parent.frames("right").document.Script.SelCont_onclick3(subCondition, Containers, ContName);
	                    } catch (e) { }
	                }
	            } else {
	                if (PresentOpen != "CONTAINER") {
	                    PresentOpen = "CONTAINER";
	                    var subCondition = "TBEXPENDAPRDOCINFO.itemcode = '" + ContainerID + "' and TBEXPENDAPRDOCINFO.itemName2 = '" + ContainerName + "'";
	                    window.parent.frames.right.document.location.href = "/myoffice/ezApproval/formContainer/getContainerInfo2.aspx?contID=" + escape(Containers) + "&SQuery=" + escape(subCondition) + "&tmpValue=" + escape(tmpValue) + "&itemID=" + ContainerID;
	                }
	                else {
	                    try {
	                        var subCondition = "TBEXPENDAPRDOCINFO.itemcode = '" + ContainerID + "' and TBEXPENDAPRDOCINFO.itemName2 = '" + ContainerName + "'";
	                        window.parent.frames.right.document.location.href = "/myoffice/ezApproval/formContainer/getContainerInfo2.aspx?contID=" + escape(Containers) + "&SQuery=" + escape(subCondition) + "&tmpValue=" + escape(tmpValue) + "&itemID=" + ContainerID;
	                        window.parent.frames("right").document.Script.SelCont_onclick3(subCondition, Containers, ContName);
	                    } catch (e) { }
	                }
	            }
	        }
	        function cmdOK_onclick_List(ContainerID) {
	            if (PresentOpen != "CONTAINER") {
	                PresentOpen = "CONTAINER";
	                window.parent.frames.right.document.location.href = "/myoffice/ezApproval/formContainer/getContainerInfo2.aspx?contID=" + escape(ContainerID) + "&SQuery=list" + "&tmpValue=" + escape(tmpValue);
	            }
	            else {
	                try {
	
	                    window.parent.frames.right.document.location.href = "/myoffice/ezApproval/formContainer/getContainerInfo2.aspx?contID=" + escape(ContainerID) + "&SQuery=list" + "&tmpValue=" + escape(tmpValue);
	                    window.parent.frames("right").document.Script.SelCont_onclick5(ContainerID);
	                } catch (e) { }
	            }
	        }
	        var xmlhttp_total = createXMLHttpRequest();
	        function getAprTotalCount() {
	            if (ViewLeftCount == "YES") {
	                var strQuery = "<DATA><LISTTYPE>1</LISTTYPE></DATA>";
	                xmlhttp_total = null;
	                xmlhttp_total = createXMLHttpRequest();
	                xmlhttp_total.open("POST", "/myoffice/ezApproval/aspx/getListCount.aspx?mode=LEFT", true);
	                xmlhttp_total.onreadystatechange = getAprTotalCount_after;
	                xmlhttp_total.send(strQuery);
	            }
	        }
	        function getAprTotalCount_after() {
	            if (xmlhttp_total == null || xmlhttp_total.readyState != 4) return;
	            try {
	                if (xmlhttp_total.responseText == "") return;
	                var ResultXML = "";
	                ResultXML = loadXMLString(xmlhttp_total.responseText);
	
	                var tempListTypeValue = window.parent.frames["right"].pListTypeValue;
	
	                
	                if (tempListTypeValue != "1") {
	                    if (getNodeText(ResultXML.getElementsByTagName("COUNT").item(0)) > 0)
	                        document.getElementById('count1').innerHTML = "<b>(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(0)) + ")</b>";
	                    else
	                        document.getElementById('count1').innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(0)) + ")";
	                }
	                
	                if (tempListTypeValue != "2") {
	                    if (getNodeText(ResultXML.getElementsByTagName("COUNT").item(1)) > 0)
	                        document.getElementById('count2').innerHTML = "<b>(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(1)) + ")</b>";
	                    else
	                        document.getElementById('count2').innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(1)) + ")";
	                }
	                
	                if (tempListTypeValue != "3") {
	                    if (getNodeText(ResultXML.getElementsByTagName("COUNT").item(2)) > 0)
	                        document.getElementById('count3').innerHTML = "<b>(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(2)) + ")</b>";
	                    else
	                        document.getElementById('count3').innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(2)) + ")";
	                }
	                
	                if (tempListTypeValue != "4") {
	                    if (getNodeText(ResultXML.getElementsByTagName("COUNT").item(3)) > 0)
	                        document.getElementById('count4').innerHTML = "<b>(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(3)) + ")</b>";
	                    else
	                        document.getElementById('count4').innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(3)) + ")";
	                }
	                
	                if (tempListTypeValue != "6") {
	                    if ("<%=_UserInfo_Enforce%>" == "2") {
	                        if (getNodeText(ResultXML.getElementsByTagName("COUNT").item(4)) > 0)
	                            document.getElementById('count6').innerHTML = "<b>(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(4)) + ")</b>";
	                        else
	                            document.getElementById('count6').innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(4)) + ")";
	                    }
	                }
	                
	                if (getNodeText(ResultXML.getElementsByTagName("COUNT").item(5)) > 0)
	                    document.getElementById('countWHO').innerHTML = "<b>(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(5)) + ")</b>";
	                else
	                    document.getElementById('countWHO').innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(5)) + ")";
	
	                
	                if (getNodeText(ResultXML.getElementsByTagName("COUNT").item(6)) > 0)
	                    document.getElementById('count7').innerHTML = "<b>(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(6)) + ")</b>";
	                else
	                    document.getElementById('count7').innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(6)) + ")";
	            } catch (e) { }
	        }
	        var xmlhttp_temp = createXMLHttpRequest();
	        function getAprCountTemp() {
	            if (ViewLeftCount == "YES") {
	                if (presentValue < SubContCount) {
	                    var strQuery = "<DATA><LISTTYPE>" + GetAttribute(document.getElementById("countsub" + presentValue), "type") + "</LISTTYPE><SUBQUERY>" + GetAttribute(document.getElementById("countsub" + presentValue),"subquery") + "</SUBQUERY></DATA>";
	                    xmlhttp_temp = null;
	                    xmlhttp_temp = createXMLHttpRequest();
	                    xmlhttp_temp.open("POST", "/myoffice/ezApproval/aspx/getListCount.aspx", true);
	                    xmlhttp_temp.onreadystatechange = getAprCount_temp;
	                    xmlhttp_temp.send(strQuery);
	                }
	            }
	        }
	        function getAprCount_temp() {
	            if (xmlhttp_temp == null || xmlhttp_temp.readyState != 4) return;
	            try {
	                if (xmlhttp_temp.responseText == "") {
	                    presentValue++;
	                    getAprCountTemp();
	                }
	                else {
	                    var tempString = "";
	                    ResultXML = loadXMLString(xmlhttp_temp.responseText);
	                    var dataNodes = GetChildNodes(ResultXML);
	                    var count = getNodeText(dataNodes[0]);
	                    if (count > 0)
	                        document.getElementById("countsub" + presentValue).innerHTML = "<b>(" + count + ")</b>";
	                    else
	                        document.getElementById("countsub" + presentValue).innerHTML = "(" + count + ")";
	                    presentValue++;
	                    getAprCountTemp();
	                }
	            } catch (e) { }
	        }
	        var xmlhttp_1 = createXMLHttpRequest();
	        function getAprCount1() {
	            var strQuery = "<DATA><LISTTYPE>1</LISTTYPE></DATA>";
	            xmlhttp_1 = null;
	            xmlhttp_1 = createXMLHttpRequest();
	            xmlhttp_1.open("POST", "/myoffice/ezApproval/aspx/getListCount.aspx", true);
	            xmlhttp_1.onreadystatechange = getAprCount1_after;
	            xmlhttp_1.send(strQuery);
	        }
	        function getAprCount1_after() {
	            if (xmlhttp_1 == null || xmlhttp_1.readyState != 4) return;
	            try {
	                if (xmlhttp_1.responseText == "") return;
	                var ResultXML = "";
	                ResultXML = loadXMLString(xmlhttp_1.responseText);
	                var dataNodes = GetChildNodes(ResultXML);
	
	                if (dataNodes.length > 0)
	                    document.getElementById('count1').innerHTML = "<b>(" + getNodeText(dataNodes[0]) + ")</b>";
	                else
	                    document.getElementById('count1').innerHTML = "(" + getNodeText(dataNodes[0]) + ")";
	            } catch (e) { }
	        }
	        var xmlhttp_2 = createXMLHttpRequest();
	        function getAprCount2() {
	            var strQuery = "<DATA><LISTTYPE>2</LISTTYPE></DATA>";
	            xmlhttp_2 = null;
	            xmlhttp_2 = createXMLHttpRequest();
	            xmlhttp_2.open("POST", "/myoffice/ezApproval/aspx/getListCount.aspx", true);
	            xmlhttp_2.onreadystatechange = getAprCount2_after;
	            xmlhttp_2.send(strQuery);
	        }
	        function getAprCount2_after() {
	            if (xmlhttp_2 == null || xmlhttp_2.readyState != 4) return;
	            try {
	                if (xmlhttp_2.responseText == "") return;
	
	                var ResultXML = "";
	                ResultXML = loadXMLString(xmlhttp_2.responseText);
	                var dataNodes = GetChildNodes(ResultXML);
	
	                if (dataNodes.length > 0)
	                    document.getElementById('count2').innerHTML = "<b>(" + getNodeText(dataNodes[0]) + ")</b>";
	                else
	                    document.getElementById('count2').innerHTML = "(" + getNodeText(dataNodes[0]) + ")";
	            } catch (e) { }
	        }
	        var xmlhttp_3 = createXMLHttpRequest();
	        function getAprCount3() {
	            var strQuery = "<DATA><LISTTYPE>3</LISTTYPE></DATA>";
	            xmlhttp_3 = null;
	            xmlhttp_3 = createXMLHttpRequest();
	            xmlhttp_3.open("POST", "/myoffice/ezApproval/aspx/getListCount.aspx", true);
	            xmlhttp_3.onreadystatechange = getAprCount3_after;
	            xmlhttp_3.send(strQuery);
	        }
	        function getAprCount3_after() {
	            if (xmlhttp_3 == null || xmlhttp_3.readyState != 4) return;
	            try {
	                if (xmlhttp_3.responseText == "") return;
	
	                var ResultXML = "";
	                ResultXML = loadXMLString(xmlhttp_3.responseText);
	                var dataNodes = GetChildNodes(ResultXML);
	
	                if (dataNodes.length > 0)
	                    document.getElementById('count3').innerHTML = "<b>(" + getNodeText(dataNodes[0]) + ")</b>";
	                else
	                    document.getElementById('count3').innerHTML = "(" + getNodeText(dataNodes[0]) + ")";
	            } catch (e) { }
	        }
	        var xmlhttp_4 = createXMLHttpRequest();
	        function getAprCount4() {
	            var strQuery = "<DATA><LISTTYPE>4</LISTTYPE></DATA>";
	            xmlhttp_4 = null;
	            xmlhttp_4 = createXMLHttpRequest();
	            xmlhttp_4.open("POST", "/myoffice/ezApproval/aspx/getListCount.aspx", true);
	            xmlhttp_4.onreadystatechange = getAprCount4_after;
	            xmlhttp_4.send(strQuery);
	        }
	        function getAprCount4_after() {
	            if (xmlhttp_4 == null || xmlhttp_4.readyState != 4) return;
	            try {
	                if (xmlhttp_4.responseText == "") return;
	
	                var ResultXML = "";
	                ResultXML = loadXMLString(xmlhttp_4.responseText);
	                var dataNodes = GetChildNodes(ResultXML);
	
	                if (dataNodes.length > 0)
	                    document.getElementById('count4').innerHTML = "<b>(" + getNodeText(dataNodes[0]) + ")</b>";
	                else
	                    document.getElementById('count4').innerHTML = "(" + getNodeText(dataNodes[0]) + ")";
	            } catch (e) { }
	        }
	        var xmlhttp_6 = createXMLHttpRequest();
	        function getAprCount6() {
	            var strQuery = "<DATA><LISTTYPE>6</LISTTYPE></DATA>";
	            xmlhttp_6 = null;
	            xmlhttp_6 = createXMLHttpRequest();
	            xmlhttp_6.open("POST", "/myoffice/ezApproval/aspx/getListCount.aspx", true);
	            xmlhttp_6.onreadystatechange = getAprCount6_after;
	            xmlhttp_6.send(strQuery);
	        }
	        function getAprCount6_after() {
	            if (xmlhttp_6 == null || xmlhttp_6.readyState != 4) return;
	            try {
	                if (xmlhttp_6.responseText == "") return;
	
	                var ResultXML = "";
	                ResultXML = loadXMLString(xmlhttp_6.responseText);
	                var dataNodes = GetChildNodes(ResultXML);
	
	                if (dataNodes.length > 0)
	                    document.getElementById('count6').innerHTML = "<b>(" + getNodeText(dataNodes[0]) + ")</b>";
	                else
	                    document.getElementById('count6').innerHTML = "(" + getNodeText(dataNodes[0]) + ")";
	            } catch (e) { }
	        }
	        var xmlhttp_WHO = createXMLHttpRequest();
	        function getAprCountWHO() {
	            var strQuery = "<DATA><CONT></CONT><QUERY>TBENDAPRLINEINFO.AprType = '" + strAprType40 + "' AND TBENDAPRLINEINFO.AprState = '" + strAprState2 + "'</QUERY></DATA>";
	            xmlhttp_WHO = null;
	            xmlhttp_WHO = createXMLHttpRequest();
	            xmlhttp_WHO.open("POST", "/myoffice/ezApproval/formContainer/aspx/getContDocCount.aspx", true);
	            xmlhttp_WHO.onreadystatechange = getAprCountWHO_after;
	            xmlhttp_WHO.send(strQuery);
	        }
	        function getAprCountWHO_after() {
	            if (xmlhttp_WHO == null || xmlhttp_WHO.readyState != 4) return;
	            try {
	                if (xmlhttp_WHO.responseText == "") return;
	
	                var ResultXML = "";
	                ResultXML = loadXMLString(xmlhttp_WHO.responseText);
	                var dataNodes = GetChildNodes(ResultXML);
	
	                if (dataNodes.length > 0)
	                    document.getElementById('countWHO').innerHTML = "<b>(" + getNodeText(dataNodes[0]) + ")</b>";
	                else
	                    document.getElementById('countWHO').innerHTML = "(" + getNodeText(dataNodes[0]) + ")";
	            } catch (e) { }
	        }
	        function UserContRequestData(pNodeID, pTreeID) {
	            nodeIdx = pNodeID;
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(pNodeID);
	
	            var xmlHTTP = createXMLHttpRequest();
	            var strQuery = "<DATA><USERID>" + pUserID + "</USERID><ParentContID>" + treeNode.GetNodeData("DATA1") + "</ParentContID><NAME></NAME></DATA>";
	            xmlHTTP.open("POST", "/myoffice/ezApproval/ezContInfo/aspx/getUserContSubTree.aspx", false);
	            xmlHTTP.send(strQuery);
	
	            var treeView = new TreeView();
	            treeView.LoadFromID(pTreeID);
	            treeView.AppendChildNodes(loadXMLString(xmlHTTP.responseText).documentElement, pNodeID)
	        }
	        function UserContNodeClick(pNodeID, pNodeNM) {
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(pNodeID);
	            nodeIdx = pNodeID;
	            setPresentValue(treeNode.GetNodeData("VALUE"));
	            if (PresentOpen != "CONTAINER") {
	                PresentOpen = "CONTAINER";
	                window.parent.frames.right.document.location.href = "/myoffice/ezApproval/formContainer/getContainerInfo2.aspx?contID=" + escape(treeNode.GetNodeData("DATA1")) + "&SQuery=usercontlist" + "&tmpValue=" + escape(tmpValue);
	            }
	            else {
	                try {
	
	                    window.parent.frames.right.document.location.href = "/myoffice/ezApproval/formContainer/getContainerInfo2.aspx?contID=" + escape(treeNode.GetNodeData("DATA1")) + "&SQuery=usercontlist" + "&tmpValue=" + escape(tmpValue);
	                    window.parent.frames("right").document.Script.SelCont_onclick4(treeNode.GetNodeData("DATA1"));
	                } catch (e) { }
	            }
	        }
	
	        var mngusercont_dialogArgument = new Array();
	        function MngUserOnclick() {
	            var url = "/myoffice/ezApproval/ezContInfo/MngUserCont.aspx";
	            mngusercont_dialogArgument[0] = "";
	            mngusercont_dialogArgument[1] = MngUserOnclick_Complete;
	            var Opener = GetOpenWindow(url, "MngUserCont", 465, 395, "NO");
	        }
	        function MngUserOnclick_Complete(RtnVal) {
	            TreeViewRefresh();
	        }
	
	        function TreeViewRefresh() {
	            var xmlHTTP = createXMLHttpRequest();
	            var strQuery = "<DATA><USERID>" + pUserID + "</USERID><ParentContID>ROOT</ParentContID><NAME></NAME></DATA>";
	            xmlHTTP.open("POST", "/myoffice/ezApproval/ezContInfo/aspx/getUserContSubTree.aspx", false);
	            xmlHTTP.send(strQuery);
	
	            var xmlDomRet = createXmlDom();
	            xmlDomRet = loadXMLString(getXmlString(loadXMLString(xmlHTTP.responseText).documentElement));
	
	            document.getElementById('divUserContTree').innerHTML = '';
	            var treeView = new TreeView();
	            treeView.SetID("UserContTree");
	            treeView.SetUseAgency(true);
	            treeView.SetRequestData("UserContRequestData");
	            treeView.SetNodeClick("UserContNodeClick");
	            treeView.DataSource(xmlDomRet);
	            treeView.DataBind("divUserContTree");
	        }
	        function DeptContRequestData(pNodeID, pTreeID) {
	            nodeIdx = pNodeID;
	
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(nodeIdx);
	
	            var xmlHTTP = createXMLHttpRequest();
	            var strQuery = "<DATA><USERID>" + pDeptID + "</USERID><ParentContID>" + treeNode.GetNodeData("DATA1") + "</ParentContID><NAME></NAME></DATA>";
	            xmlHTTP.open("POST", "/myoffice/ezApproval/ezContInfo/aspx/getDeptContSubTree.aspx", false);
	            xmlHTTP.send(strQuery);
	
	            var treeView = new TreeView();
	            treeView.LoadFromID(pTreeID);
	            treeView.AppendChildNodes(loadXMLString(xmlHTTP.responseText).documentElement, pNodeID)
	        }
	        function DeptContNodeClick(pNodeID, pNodeNM) {
	            nodeIdx = pNodeID;
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(nodeIdx);
	            setPresentValue(treeNode.GetNodeData("VALUE"));
	            if (PresentOpen != "CONTAINER") {
	                PresentOpen = "CONTAINER";
	                window.parent.frames.right.document.location.href = "/myoffice/ezApproval/formContainer/getContainerInfo2.aspx?contID=" + escape(treeNode.GetNodeData("DATA1")) + "&SQuery=deptcontlist" + "&tmpValue=" + escape(tmpValue);
	            }
	            else {
	                try {
	                    window.parent.frames.right.document.location.href = "/myoffice/ezApproval/formContainer/getContainerInfo2.aspx?contID=" + escape(treeNode.GetNodeData("DATA1")) + "&SQuery=deptcontlist" + "&tmpValue=" + escape(tmpValue);
	                    window.parent.frames("right").document.Script.SelCont_onclick6(treeNode.GetNodeData("DATA1"));
	                } catch (e) { }
	            }
	        }
	        var mngdeptcont_dialogArgument = new Array();
	        function MngDeptOnclick() {
	            var url = "/myoffice/ezApproval/ezContInfo/MngDeptCont.aspx";
	            mngdeptcont_dialogArgument[0] = "";
	            mngdeptcont_dialogArgument[1] = MngDeptOnclick_Complete;
	            var result = GetOpenWindow(url, "MngDeptCont", 465, 395, "NO");
	        }
	        function MngDeptOnclick_Complete(RtnVal) {
	            DeptTreeViewRefresh();
	        }
	
	        function DeptTreeViewRefresh() {
	            var xmlHTTP = createXMLHttpRequest();
	            var strQuery = "<DATA><USERID>" + pDeptID + "</USERID><ParentContID>ROOT</ParentContID><NAME></NAME></DATA>";
	            xmlHTTP.open("POST", "/myoffice/ezApproval/ezContInfo/aspx/getDeptContSubTree.aspx", false);
	            xmlHTTP.send(strQuery);
	
	            var xmlDomRet = createXmlDom();
	            xmlDomRet = loadXMLString(getXmlString(loadXMLString(xmlHTTP.responseText).documentElement));
	
	            document.getElementById('divDeptContTree').innerHTML = '';
	
	            var treeView = new TreeView();
	            treeView.SetID("DeptContTree");
	            treeView.SetUseAgency(true);
	            treeView.SetRequestData("DeptContRequestData");
	            treeView.SetNodeClick("DeptContNodeClick");
	            treeView.DataSource(xmlDomRet);
	            treeView.DataBind("divDeptContTree");
	        }
	        function logout() {
	            window.top.location.href = "/Loginnopass.aspx";
	        }
	        var arr_userinfo = new Array();
	        function ChangeSubtitle(obj) {
	            var UseSelectTitle = GetAttribute(obj,"href").split("#")[1].split("|")
	            if ("<%=userinfo.DeptID%>" != UseSelectTitle[0]) {
	                arr_userinfo[4] = UseSelectTitle[0];
	                arr_userinfo[5] = UseSelectTitle[1];
	                arr_userinfo[3] = UseSelectTitle[2];
	                arr_userinfo[13] = UseSelectTitle[5];
	                arr_userinfo[14] = UseSelectTitle[6];
	                arr_userinfo[15] = UseSelectTitle[3];
	                arr_userinfo[16] = UseSelectTitle[4];
	                DeptID = UseSelectTitle[0];
	                ChangeCookies();
	                window.parent.frames["left"].document.location.href = "/myoffice/ezApproval/left_approval.aspx?listType=" + pListTypeValue;
	            }
	        }
	    </script>
	</head>
	<body class="leftbody" style="overflow-y: auto; overflow-x: hidden">
	    <span style="display: none" id="presentcell"></span>
	    <div id="left">
	
	        <div class="left_appr" title="<%=RM.GetString("t824")%>"></div>
	        <% if (isSubTitle)
	           { %>
	        <select name="SubTitle_obj" id="SubTitle_obj" tabindex="1">
	            <%=pSubTitleString %>
	        </select>
	        <%} %>
	        <h2><span style="width: 100%; display: inline-block;" id="APPROVAL" onclick="Open_Func(this);setPresentValue('<%=RM.GetString("t837")%>');convMain('1', '');"><%=RM.GetString("t824")%></span></h2>
	        <ul id="iconul">
	            <li><span style="width: 100%; display: inline-block;" id="APPROVAL1" onclick="setPresentValue('<%=RM.GetString("t837")%>');convMain('1', '')">
	                <img src="../../images/ImgIcon/icon_approval.gif" width="16" height="16" class="icon"><%=RM.GetString("t837")%><span id="count1"></span></span></li>
	            <% for (i = 0; i < SCont.GetElementsByTagName("SC001").Count; i++)
	               {%>
	            <li><span style="margin-left: 15px; width: 90%; display: inline-block;" onclick="setPresentValue('<%=SCont.GetElementsByTagName("SC001").Item(i).ChildNodes.Item(0).InnerText.Replace("'", "\\'").Trim()%>');convMain('1', '<%=SCont.GetElementsByTagName("SC001").Item(i).ChildNodes.Item(1).InnerText.Replace("'", "\\'").Trim()%>')">-&nbsp;<%=SCont.GetElementsByTagName("SC001").Item(i).ChildNodes.Item(0).InnerText.Trim()%><span id="countsub<%=SubContCount++%>" type='1' subquery="<%=SCont.GetElementsByTagName("SC001").Item(i).ChildNodes.Item(1).InnerText.Trim()%>"></span></span></li>
	            <% }%>
	            <li><span style="width: 100%; display: inline-block;" id="APPROVAL2" onclick="setPresentValue('<%=RM.GetString("t791")%>');convMain('3', '')">
	                <img src="../../images/ImgIcon/icon_ingapproval.gif" width="16" height="16" class="icon"><%=RM.GetString("t791")%><span id="count3"></span></span></li>
	            <% for (i = 0; i < SCont.GetElementsByTagName("SC003").Count; i++)
	               { %>
	            <li><span style="width: 90%; display: inline-block; margin-left: 15px;" onclick="setPresentValue('<%=SCont.GetElementsByTagName("SC003").Item(i).ChildNodes.Item(0).InnerText.Replace("'", "\\'").Trim()%>');convMain('3', '<%=SCont.GetElementsByTagName("SC003").Item(i).ChildNodes.Item(1).InnerText.Replace("'", "\\'").Trim()%>')">-&nbsp;<%=SCont.GetElementsByTagName("SC003").Item(i).ChildNodes.Item(0).InnerText.Trim()%><span id="Span1" type='3' subquery="<%=SCont.GetElementsByTagName("SC003").Item(i).ChildNodes.Item(1).InnerText.Trim()%>"></span></span></li>
	            <% }%>
	            <li><span style="width: 100%; display: inline-block; cursor: pointer;" id="APPROVAL3" onclick="setPresentValue('<%=RM.GetString("t838")%>');convMain('2', '')">
	                <img src="../../images/ImgIcon/icon_writeapproval.gif" width="16" height="16" class="icon"><%=RM.GetString("t838")%><span id="count2"></span></span></li>
	            <% for (i = 0; i < SCont.GetElementsByTagName("SC002").Count; i++)
	               { %>
	            <li><span style="width: 90%; display: inline-block; margin-left: 15px;" onclick="setPresentValue('<%=SCont.GetElementsByTagName("SC002").Item(i).ChildNodes.Item(0).InnerText.Replace("'", "\\'").Trim()%>');convMain('2', '<%=SCont.GetElementsByTagName("SC002").Item(i).ChildNodes.Item(1).InnerText.Replace("'", "\\'").Trim()%>')">-&nbsp;<%=SCont.GetElementsByTagName("SC002").Item(i).ChildNodes.Item(0).InnerText.Trim()%><span id="Span2" type='2' subquery="<%=SCont.GetElementsByTagName("SC002").Item(i).ChildNodes.Item(1).InnerText.Trim()%>"></span></span></li>
	            <%}%>
	            <li><span style="width: 100%; display: inline-block;" id="APPROVAL4" onclick="setPresentValue('<%=RM.GetString("t796")%>');convMain('4', '')">
	                <img src="../../images/ImgIcon/icon_partapproval.gif" width="16" height="16" class="icon"><%=RM.GetString("t796")%><span id="count4"></span></span></li>
	            <% for (i = 0; i < SCont.GetElementsByTagName("SC004").Count; i++)
	               { %>
	            <li><span style="width: 90%; display: inline-block; margin-left: 15px;" onclick="setPresentValue('<%=SCont.GetElementsByTagName("SC004").Item(i).ChildNodes.Item(0).InnerText.Replace("'", "\\'").Trim()%>');convMain('4', '<%=SCont.GetElementsByTagName("SC004").Item(i).ChildNodes.Item(1).InnerText.Replace("'", "\\'").Trim()%>')">-&nbsp;<%=SCont.GetElementsByTagName("SC004").Item(i).ChildNodes.Item(0).InnerText.Trim()%><span id="Span3" type='4' subquery="<%=SCont.GetElementsByTagName("SC004").Item(i).ChildNodes.Item(1).InnerText.Trim()%>"></span></span></li>
	            <%}%>
	            <%if (_UserInfo_Enforce == "2")
	              {%>
	            <li><span style="width: 100%; display: inline-block;" id="APPROVAL5" onclick="setPresentValue('<%=RM.GetString("t839")%>');convMain('6', '')">
	                <img src="../../images/ImgIcon/icon_inspection.gif" width="16" height="16" class="icon"><%=RM.GetString("t839")%><span id="count6"></span></span></li>
	            <% for (i = 0; i < SCont.GetElementsByTagName("SC005").Count; i++)
	               {%>
	            <li><span style="width: 90%; display: inline-block; margin-left: 15px;" onclick="setPresentValue('<%=SCont.GetElementsByTagName("SC005").Item(i).ChildNodes.Item(0).InnerText.Replace("'", "\\'").Trim()%>');convMain('6', '<%=SCont.GetElementsByTagName("SC005").Item(i).ChildNodes.Item(1).InnerText.Replace("'", "\\'").Trim()%>')">-&nbsp;<%=SCont.GetElementsByTagName("SC005").Item(i).ChildNodes.Item(0).InnerText.Trim()%><span id="Span4" type='6' subquery="<%=SCont.GetElementsByTagName("SC005").Item(i).ChildNodes.Item(1).InnerText.Trim()%>"></span></span></li>
	            <%}%>
	            <%}%>
	            <li><span id="MYCONTWHO" style="width: 100%; display: inline-block;" onclick="setPresentValue('<%=RM.GetString("t841")%>');Open_Func(this)">
	                <img src="../../images/ImgIcon/icon_afterapproval.gif" width="16" height="16" class="icon"><%=RM.GetString("t841")%><span id="countWHO"></span></span></li>
	            <li><span id="APPROVAL9" style="width: 100%; display: inline-block;" onclick="setPresentValue('<%=RM.GetString("t920")%>');convMain('9', '')">
	                <img src="../../images/ImgIcon/icon_extraappr.gif" width="16" height="16" class="icon"><%=RM.GetString("t920")%><span id="count7"></span></span></li>
	        </ul>
	        <h2><span id="MYCONT" onclick=";Open_Func(this)" style="width: 100%; display: inline-block;"><%=RM.GetString("t618")%></span><ul></ul></h2>
	        <h2><span id="MYDEPTCONT" onclick="Open_Func(this)" style="width: 100%; display: inline-block;"><%=RM.GetString("t587")%></span></h2>
	        <ul>
	            <% if (resultXML.GetElementsByTagName("VALUE").Count > 0)
	               { %>
	            <% for (i = 0; i < resultXML.GetElementsByTagName("VALUE").Count; i++)
	               { %>
	            <li><span style="width: 100%; display: inline-block;" onclick="setPresentValue('<%=resultXML.GetElementsByTagName("VALUE").Item(i).InnerText.Trim()%>');cmdOK_onclick('\'<%=resultXML.GetElementsByTagName("DATA1").Item(i).InnerText%>\'', '<%=resultXML.GetElementsByTagName("VALUE").Item(i).InnerText%>', '')"><%=resultXML.GetElementsByTagName("VALUE").Item(i).InnerText.Trim()%></span></li>
	            <% for (k = 0; k < SCont.GetElementsByTagName("SC" + resultXML.GetElementsByTagName("DATA2").Item(i).InnerText.Trim()).Count; k++)
	               { %>
	            <li><span style="width: 100%; display: inline-block;" onclick="setPresentValue('<%=SCont.GetElementsByTagName("SC" + resultXML.GetElementsByTagName("DATA2").Item(i).InnerText.Trim()).Item(k).ChildNodes.Item(0).InnerText.Replace("'", "\\'").Trim()%>');cmdOK_onclick('<%=resultXML.GetElementsByTagName("DATA1").Item(i).InnerText%>', '<%=SCont.GetElementsByTagName("SC" + resultXML.GetElementsByTagName("DATA2").Item(i).InnerText.Trim()).Item(k).ChildNodes.Item(0).InnerText.Replace("'", "\\'").Trim()%>', '<%=SCont.GetElementsByTagName("SC" + resultXML.GetElementsByTagName("DATA2").Item(i).InnerText.Trim()).Item(k).ChildNodes.Item(1).InnerText.Replace("'", "\\'").Trim()%>')">&nbsp;-&nbsp;<%=SCont.GetElementsByTagName("SC" + resultXML.GetElementsByTagName("DATA2").Item(i).InnerText.Trim()).Item(k).ChildNodes.Item(0).InnerText.Trim()%></span></li>
	            <% } %>
	
	            <% } %>
	            <% }
	               else
	               { %>
	            <li><span><%=RM.GetString("t843")%></span></li>
	            <% } %>
	        </ul>
	        <h2><span id="ITEMCONT" onclick="Open_Func(this)" style="width: 100%; display: inline-block;"><%=RM.GetString("t844")%></span></h2>
	        <ul>
	            <% if (objXML.DocumentElement.ChildNodes.Count > 0)
	               { %>
	            <% for (i = 0; i < objXML.DocumentElement.ChildNodes.Count; i++)
	               { %>
	            <li><span style="width: 100%; display: inline-block;" onclick="setPresentValue('<%=objXML.DocumentElement.ChildNodes[i].ChildNodes[1].InnerText%>(<%=objXML.DocumentElement.ChildNodes[i].ChildNodes[0].InnerText.Trim()%>)');cmdOK_onclick2('<%=objXML.DocumentElement.ChildNodes[i].ChildNodes[0].InnerText%>', '<%=objXML.DocumentElement.ChildNodes[i].ChildNodes[1].InnerText%>', '<%=objXML.DocumentElement.ChildNodes[i].ChildNodes[1].InnerText%>(<%=objXML.DocumentElement.ChildNodes[i].ChildNodes[0].InnerText%>)') "><%=objXML.DocumentElement.ChildNodes[i].ChildNodes[1].InnerText.Trim()%>(<%=objXML.DocumentElement.ChildNodes[i].ChildNodes[0].InnerText%>)</span></li>
	            <% } %>
	            <% }
	               else
	               { %>
	            <li><span><%=RM.GetString("t843")%></span></li>
	            <% } %>
	        </ul>
	
	        <h2><span id="USERCONT" onclick="Open_Func(this)" style="width: 100%; display: inline-block;"><%=RM.GetString("t848")%></span></h2>
	        <ul>
	            <div class="tree" id="divUserContTree" style="margin-left: 4px; height: 160px; width: 169px; overflow-x: auto; overflow-y: auto; background-color: #FFFFFF; padding: 4px 6px 6px 4px; vertical-align: top; margin-left: 20px; background-color: #e6e6e6;"></div>
	            <h3><span id="MNGUSERCONT" onclick="MngUserOnclick()" style="width: 100%; display: inline-block;"><%=RM.GetString("t316")%></span></h3>
	        </ul>
	        <h2><span id="DEPTCONT" onclick="Open_Func(this)"><%=RM.GetString("t849")%></span></h2>
	        <ul>
	            <div class="tree" id="divDeptContTree" style="height: 160px; width: 169px; overflow-x: auto; overflow-y: auto; background-color: #FFFFFF; padding: 4px 6px 6px 4px; vertical-align: top; margin-left: 20px; background-color: #e6e6e6;"></div>
	            <%if (_HoldAdmin == "YES")
	              {%>
	            <h3><span id="MNGDEPTCONT" onclick="MngDeptOnclick()" style="width: 100%; display: inline-block;"><%=RM.GetString("t298")%></span></h3>
	            <% } %>
	        </ul>
	        <h3><span style="width: 100%; display: inline-block;" id="ApprovalConfig" onclick="Open_Func(this)"><%=RM.GetString("t1504")%></span></h3>
	    </div>
	    <script type="text/javascript">
	        initToggleList(document.getElementById("left"), "h2", "ul", "li");
	    </script>
	</body>
</html>