<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ page import="egovframework.ezEKP.ezApprovalG.vo.ApprGContInfoVO" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezApprovalG.e2', 'msg')}" type="text/css">
		<link href="${util.addVer('/css/jquery.selectbox.css')}" type="text/css" rel="stylesheet" />
		<link href="${util.addVer('/css/jquery.selectbox.css')}" type="text/css" rel="stylesheet" />
		<link href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css" rel="stylesheet" />
	    <style type="text/css">
	        .instance.sbHolder{
	            width: 100%;
	        }
	        /* 2018-04-30 천성준 - (#12523)선택메뉴 bold체로 표시안됨 */
	        #left ul li.on, #TopBoards ul li.on{
				font-weight:bold;
				color:black;
			}
 			#left ul li.ing, #TopBoards ul li.ing{
				font-weight:normal !important;
				color:#9b9b9b !important;
			}
			#ITEMCONT {
				width:170px;
				overflow:hidden;
				text-overflow:ellipsis;
			}
			<%-- 2018-08-22 홍승비 - 개인문서함 폴더명 ellipsis 처리 --%>
			.node_div span {
				overflow: hidden;
			    text-overflow: ellipsis;
			    display: inline-block;
			}			
			
	    </style>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.7.2.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.selectbox-0.2.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CabRoleInfo_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeView.js')}"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
			var pUserID = "${userInfo.id}";
		    var pListTypeValue = "${listType}";
		    var PresentOpen = "APPROVAL";
		    var CompanyID = '${userInfo.companyID}';
		    var CompanyName = '${userInfo.companyName}';
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
		    var approvalFlag = "${approvalFlag}";     //전자결재 일반/공공 여부 (G : 공공 , S : 일반)
		    var ViewLeftCount = "${viewLeftCount}";
		    var primaryStr = "${userInfo.primary}";
		    var SubContCount = "${subContCount}";
		    var tmpValue = "";
		    var nodeIdx;
		    var localValue = "";
		    var hideSusin = "${hideSusin}";
		    var whoKyulYN = "${whoKyulYN}";
		    
		    $(function () {
		      	if(approvalFlag == "G") {
	        		$(".approvalG").css("display","");
	        		$(".approval").css("display","none");
	        	} else{
	        		$(".approvalG").css("display","none");
	        		$(".approval").css("display","");
	        	}
		      	
		        if ("${isSubTitle}" == "true")
		            $("#country_id").selectbox();
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
		        initUserRoleinfo();
		        
		        if(approvalFlag == "G") {
			        if (g_bRecAdmin || AdminYN == "TRUE") {
			            /* document.getElementById("tag07").style.display = "";
			            document.getElementById("tag08").style.display = ""; */
			            document.getElementById("tag09").style.display = "";
			            document.getElementById("tag10").style.display = "";
			        }
			        else if (g_bDeptCharger) {
			            /* document.getElementById("tag07").style.display = "";
			            document.getElementById("tag08").style.display = ""; */
			            document.getElementById("tag09").style.display = "";
			            document.getElementById("tag10").style.display = "none";
			        }
			        else {
			            /* document.getElementById("tag07").style.display = "none";
			            document.getElementById("tag08").style.display = "none"; */
			            document.getElementById("tag09").style.display = "none";
			            document.getElementById("tag10").style.display = "none";
			        }
		        }
		        
		        
		        var idx = "4", navigation_info = "<spring:message code='ezApprovalG.t102'/>";
		        if(approvalFlag == "S") {
		        	Tree_setconfig();
		            var xmlDom2 = createXmlDom();
		            xmlDom2 = loadXMLString('${userCont}');
		            var treeView = new TreeView();
		            treeView.SetID("UserContTree");
		            treeView.SetUseAgency(true);
		            treeView.SetRequestData("UserContRequestData");
		            treeView.SetNodeClick("UserContNodeClick");
		            treeView.DataSource(xmlDom2);
		            treeView.DataBind("divUserContTree");

		            //title3[0].setAttribute("TITLE", title3[0].innerHTML); 
 		            $(".node_normal").css("width", "135px");
 		            
					var node = $(".node_normal");
					
					for(var i=0; i<node.length; i++) {
						node[i].setAttribute("TITLE", node[i].innerHTML);
					} 

		        } 
			        if (parseInt(pListTypeValue) < 10) {
			            window.open("/ezApprovalG/aprManage.do?listType=" + pListTypeValue + "&subQuery=", "right");
			
			            if (pListTypeValue == "1") {
			                setPresentValue("<spring:message code='ezApprovalG.t1747'/>");
			                document.getElementById('APPROVAL1').click();
			                //document.getElementById('APPROVAL1').parentElement.setAttribute("class", "on");
			            }
			            else if (pListTypeValue == "2") {
			                setPresentValue("<spring:message code='ezApprovalG.t1748'/>");
			                document.getElementById('APPROVAL3').click();
			                //document.getElementById('APPROVAL3').parentElement.setAttribute("class", "on");
			            }
			            else if (pListTypeValue == "3") {
			                setPresentValue("<spring:message code='ezApprovalG.t1706'/>");
			                document.getElementById('APPROVAL2').click();
			                //document.getElementById('APPROVAL2').parentElement.setAttribute("class", "on");
			            }
			            else if (pListTypeValue == "4") {
			                setPresentValue("<spring:message code='ezApprovalG.t1749'/>");
			                document.getElementById('APPROVAL4').click();
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
			            if (pListTypeValue == "99") {
			            	setPresentValue("<spring:message code='ezApprovalG.hyj04'/>");
			                document.getElementById('APPROVAL99').click();
			            }
			            if (pListTypeValue == '21') {
			            	setPresentValue("<spring:message code='ezApprovalG.t3000'/>");
			                document.getElementById('APPROVAL21').click();
			            }
		        }
			        getAprCount();
		    };
		    
		    function UserContRequestData(pNodeID, pTreeID) {
	            nodeIdx = pNodeID;
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(pNodeID);

	            var xmlHTTP = createXMLHttpRequest();
	            var strQuery = "<DATA><USERID>" + pUserID + "</USERID><ParentContID>" + treeNode.GetNodeData("DATA1") + "</ParentContID><NAME></NAME></DATA>";
	            xmlHTTP.open("POST", "/ezApprovalG/getUserContSubTree.do", false);
	            xmlHTTP.send(strQuery);

	            var treeView = new TreeView();
	            treeView.LoadFromID(pTreeID);
	            treeView.AppendChildNodes(loadXMLString(xmlHTTP.responseText).documentElement, pNodeID);
	            
	            var node = document.getElementById(pNodeID);
		        var title2 = node.getElementsByClassName("node_div");
		        var nodeLevel = title2[0].getAttribute("nodelevel");
		        
		        if(nodeLevel > 9) {
		        	nodeLevel = 9;
		        }
		        for(var i=0; i<title2.length; i++) {
		        	var title3 = title2[i].getElementsByClassName("node_normal");
		        	title3[0].setAttribute("TITLE", title3[0].innerHTML); 
		        	title3[0].style.width = 135 - 16*(nodeLevel-1) +'px';
		        	title3[0].style.textOverflow = 'ellipsis';
		        	title3[0].style.overflow = 'hidden';
		        }		        
	        }
		    
		    function Tree_setconfig() {
		        var xmlHTTP = createXMLHttpRequest();
		        xmlHTTP.open("GET", "/xml/ezApproval/conttree_config.xml", false);
		        xmlHTTP.send();

		        if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
		            var treeView = new TreeView();
		            treeView.SetConfig(loadXMLString(xmlHTTP.responseText));
		        }
		    }
		    
		       function UserContNodeClick(pNodeID, pNodeNM) {
		            var treeNode = new TreeNode();
		            treeNode.LoadFromID(pNodeID);
		            nodeIdx = pNodeID;
		            setPresentValue(treeNode.GetNodeData("VALUE"));
		            if (PresentOpen != "CONTAINER") {
		                PresentOpen = "CONTAINER";
		                window.parent.frames.right.document.location.href = "/ezApprovalG/getContainerInfo.do?contID=" + escape(treeNode.GetNodeData("DATA1")) + "&sQuery=usercontlist" + "&tmpValue=" + escape(tmpValue);
		            }
		            else {
		                try {

		                    window.parent.frames.right.document.location.href = "/ezApprovalG/getContainerInfo.do?contID=" + escape(treeNode.GetNodeData("DATA1")) + "&sQuery=usercontlist" + "&tmpValue=" + escape(tmpValue);
		                    window.parent.frames("right").document.Script.SelCont_onclick4(treeNode.GetNodeData("DATA1"));
		                } catch (e) { }
		            }
		        }
		       
	        var mngusercont_dialogArgument = new Array();
	        function MngUserOnclick() {
	            var url = "/ezApprovalG/mngUserCont.do";
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
	            xmlHTTP.open("POST", "/ezApprovalG/getUserContSubTree.do", false);
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
	            
	            $(".node_normal").css("width", "135px");
 		          
				var node = $(".node_normal");
					
				for(var i=0; i<node.length; i++) {
					node[i].setAttribute("TITLE", node[i].innerHTML);
				} 
	        }
	        
		    function Open_Func(pthis) {
		        try {
		            switch (pthis.id) {
		                case "APPROVAL":
		                    setPresentValue("<spring:message code='ezApprovalG.t1747'/>");
		                    convMain('1', '');
		                    break;
		                case "MYCONT":
		                    //cmdOK_onclick('', "<spring:message code='ezApprovalG.t1750'/>",'');
		                    cmdOK_onclick('', "<spring:message code='ezApproval.t990042'/>",'');
		                    break;
		                case "MYDRAFTCONT":
		                    cmdOK_onclick3("TBENDAPRLINEINFO.AprMemberSN:1:EXACT");
		                    break;
		                case "MYAPRCONT":
		                    cmdOK_onclick3("TBENDAPRLINEINFO.AprMemberSN:1:NOT");
		                    break;
		                case "MYDEPTCONT":
		                		document.getElementById('myDeptCont0').onclick();
		                    break;
		                case "ITEMCONT":
		                	document.getElementById('itemList0').onclick();
		                    break;
		                case "DEPTCONT":
		                    break;
		                case "USERCONT":
		                	document.getElementById('spn_UserContTree_0').onclick();
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
		                case "approvalForDoc":
		                	window.open("/admin/ezApprovalG/forAprDoc.do?type=user", "right");
		                	break;
		                case "ApprovalConfig":
		                    PresentOpen = "CONFIG";
		                    window.open("/ezPersonal/ezApprovalConfig.do", "right");
		                    break;    
		                case "MYCONTWHO":
		                    cmdOK_onclick('', "<spring:message code='ezApproval.t990042'/>", "TBL_ENDAPRLINEINFO.AprType = '" + strAprType40 + "' AND TBL_ENDAPRLINEINFO.AprState = '" + strAprState2 + "'");
		                    break;
		                default:
		                    break;
		            }
		            parent.frames["right"].$('#sel_year').val("ALL");
		            /* parent.frames["right"].$('#sel_year').selectmenu('refresh'); */
		        }
		        catch (e) { }
		    }
		
 		    function setPresentValue(tempValue) {
		    	if(approvalFlag == 'G') {
			        if (tempValue == "") {
			            tempValue = localValue;
			        } else {
			            localValue = tempValue;
			        }
			        document.getElementById("presentcell").innerHTML = "<b>[" + tempValue + "]</b>";
			        try {
			            if (CrossYN())
			                parent.frames["right"].document.getElementById("presentcell").textContent = tempValue;
			            else
			                parent.frames["right"].document.getElementById("presentcell").innerText = tempValue;
			        
			            parent.frames["right"].initselyear();

			        }
			        catch (e) { }
			        
			        
		    	} else {
/* 		    	    if (tempValue == "")
		    	        tempValue = localValue;
		    	    else
		    	        localValue = tempValue;   */
				        if (tempValue == "") {
				            tempValue = localValue;
				        } else {
				            localValue = tempValue;
				        }
		    	        
				        document.getElementById("presentcell").innerHTML = "<b>[" + tempValue + "]</b>";
				        try {
				       		if (CrossYN())
				        		parent.frames["right"].document.getElementById("presentcell").textContent = tempValue;
				            else
				        		parent.frames["right"].document.getElementById("presentcell").innerText = tempValue;
				        }
				        catch (e) { }		    	        
		    	}
		    } 
		
		    function convMain(listtype, SubQuery) {
		        try {
		        		if (approvalFlag == 'G') {
				            if (PresentOpen != "APPROVAL" || pListTypeValue == "") {
				                pListTypeValue = listtype;
				                PresentOpen = "APPROVAL";
				                window.parent.frames.right.document.location.href = "/ezApprovalG/aprManage.do?listType=" + listtype  + "&SubQuery=" + escape(SubQuery) + "&tmpValue=" + escape(tmpValue);
				            }
				            else {
				                if (listtype == "1") {
				                    parent.frames["right"].passValLeftMenu("1");
				                    parent.frames["right"].checkBujaeInfo();
				                }
				                else if (listtype == "3") {
				                    parent.frames["right"].passValLeftMenu("3");
				                    parent.frames["right"].checkBujaeInfo();
				                }
				                else if (listtype == "2") {
				                    parent.frames["right"].passValLeftMenu("2");
				                    parent.frames["right"].checkBujaeInfo();
				                }
				                else if (listtype == "4") {
				                    parent.frames["right"].passValLeftMenu("4");
				                    parent.frames["right"].checkBujaeInfo();
				                }
				                else if (listtype == "6") {
				                    parent.frames["right"].passValLeftMenu("6");
				                    parent.frames["right"].checkBujaeInfo();
				                }
				                else if (listtype == "7") {
				                    parent.frames["right"].passValLeftMenu("7");
				                    parent.frames["right"].checkBujaeInfo();
				                }
				                else if (listtype == "8") {
				                    parent.frames["right"].passValLeftMenu("8");
				                    parent.frames["right"].checkBujaeInfo();
				                }
				                else if (listtype == "9") {
				                    parent.frames["right"].passValLeftMenu("9");
				                    parent.frames["right"].checkBujaeInfo();
				                }
				                else if (listtype == "10") {
				                    parent.frames["right"].passValLeftMenu("10");
				                    parent.frames["right"].checkBujaeInfo();
				                }
				                else if (listtype == "99") {
				                    parent.frames["right"].passValLeftMenu("99");
				                    parent.frames["right"].checkBujaeInfo();
				                }
				                else if (listtype == "21") {
				                    parent.frames["right"].passValLeftMenu("21");
				                    parent.frames["right"].checkBujaeInfo();
				                }
				                else {
				                    parent.frames["right"].passValLeftMenu("1");
				                    parent.frames["right"].checkBujaeInfo();
				                }
				            }
				            try { parent.frames["right"].document.getElementById("txt_keyword").value = ""; } catch (e) { }
				            parent.frames["right"].$('#sel_year').val("ALL");
				            /* parent.frames["right"].$('#sel_year').selectmenu('refresh'); */
		        		} else {
				        	if (PresentOpen != "APPROVAL") {
				                PresentOpen = "APPROVAL";
				                window.parent.frames.right.document.location.href = "/ezApprovalG/aprManage.do?listType=" + listtype  + "&SubQuery=" + encodeURIComponent(SubQuery) + "&tmpValue=" + encodeURIComponent(tmpValue);
				            }
				            else {
				                window.parent.frames.right.document.location.href = "/ezApprovalG/aprManage.do?listType=" + listtype  + "&SubQuery=" + encodeURIComponent(SubQuery) + "&tmpValue=" + encodeURIComponent(tmpValue);
				            }
				        }
		        }
			        catch (e) { }
		    }
		
		    function btnDraft_onclick() {
		        parent.frames["right"].btnDraft_onclick();
		    }
		
		    function cmdOK_onclick(ContainerID, ContName, SubQuery) {
		        if (PresentOpen != "CONTAINER") {
		            PresentOpen = "CONTAINER";
	                window.parent.frames.right.document.location.href = "/ezApprovalG/getContainerInfo.do?contID=" + encodeURI(ContainerID) + "&sQuery="+ escape(SubQuery) + "&tmpValue=" + encodeURI(ContName) + "&ENDAPRTYPE=" + strAprType40 + "&ENDAPRSTATE=" + strAprState2;
		        } else {
		            try {
		            	 window.parent.frames.right.document.location.href = "/ezApprovalG/getContainerInfo.do?contID=" + encodeURI(ContainerID) + "&sQuery="+ escape(SubQuery) + "&tmpValue=" + encodeURI(ContName) + "&ENDAPRTYPE=" + strAprType40 + "&ENDAPRSTATE=" + strAprState2;
// 		                parent.frames["right"].SelCont_onclick2(ContainerID, ContName);
		            } catch (e) { }
		        }
		    }
		
		    function cmdOK_onclick2(ContainerID, ContainerName, ContName) {
		        if (primaryStr == "1") {
	                if (PresentOpen != "CONTAINER") {
	                    PresentOpen = "CONTAINER";
	                    var subCondition = "TBL_EXPENDAPRDOCINFO.TASKCODE = '" + ContainerID + "'";
	                    window.parent.frames.right.document.location.href = "/ezApprovalG/getContainerInfo.do?contID=" + encodeURIComponent(Containers) + "&sQuery=" + encodeURIComponent(subCondition) + "&tmpValue=" + encodeURIComponent(tmpValue) + "&itemID=" + ContainerID;
	                }
	                else {
	                    try {
	                        var subCondition = "TBL_EXPENDAPRDOCINFO.TASKCODE = '" + ContainerID + "'";
	                        window.parent.frames.right.document.location.href = "/ezApprovalG/getContainerInfo.do?contID=" + encodeURIComponent(Containers) + "&sQuery=" + encodeURIComponent(subCondition) + "&tmpValue=" + encodeURIComponent(tmpValue) + "&itemID=" + ContainerID;
	                        window.parent.frames("right").document.Script.SelCont_onclick3(subCondition, Containers, ContName);
	                    } catch (e) { }
	                }
	            } else {
	                if (PresentOpen != "CONTAINER") {
	                    PresentOpen = "CONTAINER";
	                    var subCondition = "TBL_EXPENDAPRDOCINFO.TASKCODE = '" + ContainerID + "'";
	                    window.parent.frames.right.document.location.href = "/ezApprovalG/getContainerInfo.do?contID=" + encodeURIComponent(Containers) + "&sQuery=" + encodeURIComponent(subCondition) + "&tmpValue=" + encodeURIComponent(tmpValue) + "&itemID=" + ContainerID;
	                }
	                else {
	                    try {
	                        var subCondition = "TBL_EXPENDAPRDOCINFO.TASKCODE = '" + ContainerID + "'";
	                        window.parent.frames.right.document.location.href = "/ezApprovalG/getContainerInfo.do?contID=" + encodeURIComponent(Containers) + "&sQuery=" + encodeURIComponent(subCondition) + "&tmpValue=" + encodeURIComponent(tmpValue) + "&itemID=" + ContainerID;
	                        window.parent.frames("right").document.Script.SelCont_onclick3(subCondition, Containers, ContName);                     
	                    } catch (e) { }
	                }
	            }
	        }
		
		    function getAprCount() {
		        try {
		            getAprTotalCount();
// 		            presentValue = 0;
// 		            getAprCountTemp();
		        } catch (e) { }
		    }
		    
		    var xmlhttp_temp = createXMLHttpRequest();
	        function getAprCountTemp() {
	            if (ViewLeftCount == "YES") {
	                if (presentValue < SubContCount) {
	                	$.ajax({
							type : "POST",
							dataType : "text",
							async : true,
							url : "/ezApprovalG/getListCount.do",
							data : { 
									mode : "LEFT",
									listType : GetAttribute(document.getElementById("countsub" + presentValue), "type"),
									subQuery : GetAttribute(document.getElementById("countsub" + presentValue),"subquery")
									},
							success: function(text){
								getAprCount_temp(text);
							}
						});
	                }
	            }
	        }
	        
	        function getAprCount_temp(text) {
	            try {
	                if (text == "") {
	                    presentValue++;
	                    getAprCountTemp();
	                }
	                else {
	                    var tempString = "";
	                    ResultXML = loadXMLString(text);
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
		                    count1.innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(0)) + ")";
		                else
		                    count1.innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(0)) + ")";
		            }
		            // 결재진행문서
		            if (pListTypeValue != "3") {
		                if (getNodeText(ResultXML.getElementsByTagName("COUNT").item(1)) > 0)
		                    count2.innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(1)) + ")";
		                else
		                    count2.innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(1)) + ")";
		            }
		            // 기안한문서
		            if (pListTypeValue != "2") {
		                if (getNodeText(ResultXML.getElementsByTagName("COUNT").item(2)) > 0)
		                    count3.innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(2)) + ")";
		                else
		                    count3.innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(2)) + ")";
		            }
		            // 부서수신함
		            if (pListTypeValue != "4") {
		                if (getNodeText(ResultXML.getElementsByTagName("COUNT").item(3)) > 0)
		                    count4.innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(3)) + ")";
		                else
		                    count4.innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(3)) + ")";
		            }
		            // 발송의뢰문서
		            if (pListTypeValue != "6") {
		                if (getNodeText(ResultXML.getElementsByTagName("COUNT").item(4)) > 0)
		                    count6.innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(4)) + ")";
		                else
		                    count6.innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(4)) + ")";
		            }
		            
		            if (document.getElementById('countWHO') != null) {
			            if (getNodeText(ResultXML.getElementsByTagName("COUNT").item(10)) > 0)
		                    document.getElementById('countWHO').innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(10)) + ")";
		                else
		                    document.getElementById('countWHO').innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(10)) + ")";
		            }
		            
		            // 임시보관함
		            if (pListTypeValue != "21") {
		                if (getNodeText(ResultXML.getElementsByTagName("COUNT").item(9)) > 0)
		                    count21.innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(9)) + ")";
		                else
		                    count21.innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(9)) + ")";
		            }
		            
		            // 공유결재문서
		            if (pListTypeValue != "11") {
		            	if (getNodeText(ResultXML.getElementsByTagName("COUNT").item(11)) > 0)
		            		count11.innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(11)) + ")";
		            	else
		            		count11.innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(11)) + ")";
		            }
		            
		            try {
		                // 공람할문서
		                if (pListTypeValue != "99") {
		                    if (getNodeText(ResultXML.getElementsByTagName("COUNT").item(7)) > 0)
		                    	count99.innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(7)) + ")";
		                    else
		                    	count99.innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(7)) + ")";
		                }
		                // 공람한문서
		                if (pListTypeValue != "10") {
		                    if (getNodeText(ResultXML.getElementsByTagName("COUNT").item(8)) > 0)
		                    	count10.innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(8)) + ")";
		                    else
		                    	count10.innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(8)) + ")";
		                }
		            } catch (e) { }
		            try {
		                // 직인의뢰함
		                if (pListTypeValue != "7") {
		                	//겸직 시 겸직된 부서로 이동할 경우 직인의뢰함의 count가 표시되지 않는 현상 제거
		                	//if("${userSendOut}" == "YES") {
		                    	if (getNodeText(ResultXML.getElementsByTagName("COUNT").item(5)) > 0)
		                        	count7.innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(5)) + ")";
		                    	else
		                        	count7.innerHTML = "(" + getNodeText(ResultXML.getElementsByTagName("COUNT").item(5)) + ")";
		                	//}
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
		                    window.parent.frames.right.document.location.href = "/ezApprovalG/taskManage.do";
		                    break;
		                case "admin_sub02":
		                    PresentOpen = "DOC_ADMIN";
		                    window.parent.frames.right.document.location.href = "/ezApprovalG/cabTransfer.do";
		                    break;
		                case "admin_sub03":
		                    PresentOpen = "DOC_ADMIN";
		                    window.parent.frames.right.document.location.href = "/ezApprovalG/adminPage.do?initFlag=4";
		                    break;
		                case "admin_sub04":
		                    PresentOpen = "DOC_ADMIN";
		                    window.parent.frames.right.document.location.href = "/ezApprovalG/adminPage.do?initFlag=0";
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
		                case "approvalForDoc_sub01":
		                	PresentOpen = "DOC_ADMIN";
		                	window.parent.frames.right.document.location.href = "/admin/ezApprovalG/forAprDoc.do?type=user";
		                	break;
		                case "approvalForDoc_sub02":
		                	PresentOpen = "DOC_ADMIN";
		                	window.parent.frames.right.document.location.href = "/admin/ezApprovalG/forDoc.do?type=user";
		                	break;
		            }
		        } catch (e) { }
		    }
		
		    function DocManageMain(sFlag) {
		        try {
		            if (PresentOpen != "DOCMANAGE") {
		                PresentOpen = "DOCMANAGE";
		                window.parent.frames.right.document.location.href = "/ezApprovalG/cabinetMain.do?sFlag=" + sFlag;
		            }
		            else {
		                window.parent.frames["right"].g_uFlag = sFlag;
		                switch (sFlag) {
		                    case "m01":
		                    	window.parent.frames.right.document.location.href = "/ezApprovalG/cabinetMain.do?sFlag=" + sFlag;
		                        break;
		                    case "m02":
		                        window.parent.frames.right.document.location.href = "/ezApprovalG/cabinetMain.do?sFlag=" + sFlag;
		                        break;
		                    case "m03":
		                        window.parent.frames.right.document.location.href = "/ezApprovalG/cabinetMain.do?sFlag=" + sFlag;
		                        break;
		                    case "m04":
		                        window.parent.frames.right.document.location.href = "/myoffice/ezApprovalG/ezCabinet/cabinetmain_Cross.aspx?sFlag=" + sFlag;
		                        break;
		                    case "m05":
		                        window.parent.frames.right.document.location.href = "/ezApprovalG/cabinetMain.do?sFlag=" + sFlag;
		                        break;
		                    case "m06":
		                        window.parent.frames.right.document.location.href = "/ezApprovalG/cabinetMain.do?sFlag=" + sFlag;
		                        break;
		                    case "m07":
		                        window.parent.frames.right.document.location.href = "/ezApprovalG/cabinetMain.do?sFlag=" + sFlag;
		                        break;
		                    case "m08":
		                        window.parent.frames.right.document.location.href = "/ezApprovalG/cabinetMain.do?sFlag=" + sFlag;
		                        break;
		                    case "m09":
		                        window.parent.frames.right.document.location.href = "/ezApprovalG/cabinetMain.do?sFlag=" + sFlag;
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
		            companyID = UseSelectTitle[7];
		            CompanyName = UseSelectTitle[8];
		            CompanyName2 = UseSelectTitle[9];
		            DeptID = UseSelectTitle[0];
		            ChangeCookies();
		
		            if (pListTypeValue == "7" || pListTypeValue == "8" || pListTypeValue == "9")
		                pListTypeValue = "1";
		
		            parent.frames["left"].location.href = "/ezApprovalG/apprGLeft.do?listType=" + pListTypeValue;
		        }
		    }
		    function ChangeCookies() {
	            $.ajax({
	        		type : "POST",
	        		async : false,
	        		url : "/ezApprovalG/ChangeUserInfo.do",
	        		data : {
	        				deptID : arr_userinfo[4],
	        				deptName  : arr_userinfo[5],
	        				deptName2 : arr_userinfo[16],
	        				position  : arr_userinfo[3],
	        				position2 : arr_userinfo[14],
	        				companyID : companyID,
	        				companyName : CompanyName,
	        				companyName2 : CompanyName2
	        		},
	        		success: function(xml){
	        		}        			
	        	});
		    }
		    
		    
		    var xmlhttp_WHO = createXMLHttpRequest();
	        function getAprCountWHO() {
	            var strQuery = "<DATA><CONT></CONT><QUERY>TBL_ENDAPRLINEINFO.AprType = '" + strAprType40 + "' AND TBL_ENDAPRLINEINFO.AprState = '" + strAprState2 + "'</QUERY></DATA>";
	            xmlhttp_WHO = null;
	            xmlhttp_WHO = createXMLHttpRequest();
	            xmlhttp_WHO.open("POST", "/ezApprovalG/getContDocCount.do", true);
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
		</script>
	</head>
	<body ondragstart="return false" onselectstart="return false" class="leftbody" style="overflow-y:auto; ">
		<span  id="presentcell" style="display:none"></span>
		<div id="left" style="overflow-x:hidden">
			<div class="left_appr" title="<spring:message code='ezApprovalG.t102'/>"><span><spring:message code='main.t25'/></span></div>
			<c:if test="${isSubTitle}">
		        <select name="country_id" id="country_id" tabindex="1">
		            ${subTitleString}
				</select>
			</c:if>
			<h2><span style="width:100%; display:inline-block;" id="APPROVAL" onClick="Open_Func(this)"><spring:message code='main.t00018'/></span></h2>
			<ul id="iconul">
				<li onclick="setPresentValue('<spring:message code='ezApprovalG.t1747'/>');convMain('1','')"><span style="width:100%;display:inline-block;" id="APPROVAL1"><img src="/images/ImgIcon/icon_approval.gif" width="16" height="16" class="icon"><spring:message code='ezApprovalG.t1747'/><span id=count1></span></span></li>
				
				<c:if test="${approvalFlag == 'S' && useShareApproval == 'YES' }">
					<li onclick="setPresentValue('공유결재문서');convMain('11','')"><span style="width:100%;display:inline-block;" id="APPROVAL11"><img src="/images/ImgIcon/icon_approval.gif" width="16" height="16" class="icon">공유결재문서<span id=count11></span></span></li>
				</c:if>
				<li onclick="setPresentValue('<spring:message code='ezApprovalG.t1706'/>');convMain('3','')"><span style="width:100%;display:inline-block;" id="APPROVAL2"><img src="/images/ImgIcon/icon_ingapproval.gif" width="16" height="16" class="icon"><spring:message code='ezApprovalG.t1706'/><span id=count2></span></span></li>

				<li onclick="setPresentValue('<spring:message code='ezApprovalG.t1748'/>');convMain('2','')"><span style="width:100%;display:inline-block;" id="APPROVAL3"><img src="/images/ImgIcon/icon_writeapproval.gif" width="16" height="16" class="icon"><spring:message code='ezApprovalG.t1748'/><span id=count3></span></span></li>
				<c:if test="${approvalFlag == 'S'}">
				<li onclick="setPresentValue('<spring:message code='ezApprovalG.hyj04'/>');convMain('99','')"><span style="width:100%; display:inline-block;" id="APPROVAL99"><img src="/images/ImgIcon/icon_displaypaper.gif" width="16" height="16" class="icon"><spring:message code='ezApprovalG.hyj04'/><span id="count99"></span></span></li>
				</c:if>
				<c:if test="${hideSusin != 'N'}">
				<li onclick="setPresentValue('<spring:message code='ezApprovalG.t1749'/>');convMain('4','')"><span style="width:100%;display:inline-block;" id="APPROVAL4"><img src="/images/ImgIcon/icon_partapproval.gif" width="16" height="16" class="icon"><spring:message code='ezApprovalG.t1749'/><span id=count4></span></span></li>
				</c:if>
				<c:if test="${approvalFlag == 'G'}">
					<li onclick="setPresentValue('<spring:message code='ezApprovalG.t10011'/>');convMain('99','')"><span style="width:100%; display:inline-block;" id="APPROVAL99"><img src="/images/ImgIcon/icon_displaypaper.gif" width="16" height="16" class="icon"><spring:message code='ezApprovalG.t10011'/><span id="count99"></span></li>
				</c:if>		
				<c:if test="${whoKyulYN == '1'}">
					<li id="MYCONTWHO" onclick="setPresentValue('<spring:message code='ezApproval.pjj34'/>');Open_Func(this)"><span style="width: 100%; display: inline-block;">
	                <img src="../../images/ImgIcon/icon_afterapproval.gif" width="16" height="16" class="icon"><spring:message code='ezApproval.pjj34'/><span id="countWHO"></span></span></li>
                </c:if>
	            <c:if test="${userInfoEnforce == '2'}">
	            	<li onclick="setPresentValue('<spring:message code='ezApproval.t839'/>');convMain('6', '')">
	            		<span style="width: 100%; display: inline-block;" id="APPROVAL5">
	                	<img src="../../images/ImgIcon/icon_inspection.gif" width="16" height="16" class="icon"><spring:message code='ezApproval.t839'/><span id="count6"></span></span>
	               	</li>
	            </c:if>
				<li class = "approvalG" onClick="setPresentValue('<spring:message code='ezApprovalG.t257'/>');convMain('6','')"><span style="width:100%;display:inline-block;" id="APPROVAL5"><img src="/images/ImgIcon/icon_senddoc.gif" width="16" height="16" class="icon"><spring:message code='ezApprovalG.t257'/><span id=count6></span></span></li>
				<c:if test="${approvalFlag == 'G'}">
				<c:if test="${infoXML != '' && infoXML != null }">
					<li onclick="setPresentValue('<spring:message code='ezApprovalG.t1751'/>');convMain('9','')"><span style="width:100%;display:inline-block;cursor:pointer;"  id="APPROVAL9"><img src="/images/ImgIcon/icon_listsenddoc.gif" width="16" height="16" class="icon"><spring:message code='ezApprovalG.t1751'/></span></li>
				</c:if>
				</c:if>
				<c:if test="${userSendOut == 'YES'}">
					<li onclick="setPresentValue('<spring:message code='ezApprovalG.t1752'/>');convMain('7','')"><span style="width:100%;display:inline-block;cursor:pointer;"  id="APPROVAL7"><img src="/images/ImgIcon/icon_stamp.gif" width="16" height="16" class="icon"><spring:message code='ezApprovalG.t1752'/><span id=count7></span></span></li>
					<li onclick="setPresentValue('<spring:message code='ezApprovalG.t1275'/>');convMain('8','')"><span style="width:100%;display:inline-block;cursor:pointer;"  id="APPROVAL8"><img src="/images/ImgIcon/icon_liststamp.gif" width="16" height="16" class="icon"><spring:message code='ezApprovalG.t1275'/></span></li>
				</c:if>
	            <li onclick="setPresentValue('<spring:message code='ezApprovalG.t3000'/>');convMain('21','')"><span id="APPROVAL21"><img src="/images/ImgIcon/icon_extraappr.gif" width="16" height="16" class="icon"><spring:message code='ezApprovalG.t3000'/></span><span id=count21></span></li>
			</ul>
			<c:if test="${approvalFlag == 'S'}">
				<h2><span style="width:100%;display:inline-block;"  id="MYCONT" onClick="setPresentValue('<spring:message code='ezApproval.t990042'/>');Open_Func(this)"><spring:message code='ezApproval.t990042'/></span><ul></ul></h2>
		        <h2><span style="width:100%; display:inline-block;" id="APPROVAL10" onClick="setPresentValue('<spring:message code='ezApprovalG.hyj03'/>');convMain('10','')"><spring:message code='ezApprovalG.hyj03'/></span></h2>
		        <ul>
				</ul>
			</c:if>
			<c:if test="${approvalFlag == 'G'}">
			<h2><span style="width:100%;display:inline-block;"  id="MYCONT" onClick="setPresentValue('<spring:message code='ezApproval.t990042'/>');Open_Func(this)"><spring:message code='ezApproval.t990042'/></span><ul></ul></h2>
			</c:if>
			<c:if test="${approvalFlag == 'G'}">
		        <h2><span style="width:100%; display:inline-block" id="APPROVAL10" onClick="setPresentValue('<spring:message code='ezApprovalG.t1787'/>');convMain('10','')"><spring:message code='ezApprovalG.t1787'/></span><ul></ul></h2>
		         <%-- <ul id="iconul">
				    <li><span style="width:100%; display:inline-block;" id="APPROVAL99" onClick="setPresentValue('<spring:message code='ezApprovalG.t10011'/>');convMain('99','')"><img src="/images/ImgIcon/icon_displaypaper.gif" width="16" height="16" class="icon"><spring:message code='ezApprovalG.t10011'/><span id="count99"></span></li>
				    <li><span style="width:100%; display:inline-block;" id="APPROVAL10" onClick="setPresentValue('<spring:message code='ezApprovalG.t1787'/>');convMain('10','')"><spring:message code='ezApprovalG.t1787'/><span id="count10"></span></li>
				</ul> --%>
			</c:if>
			<h2><span style="width:100%;display:inline-block;"  id="MYDEPTCONT" onClick="setPresentValue('<spring:message code='ezApprovalG.t1755'/>');Open_Func(this)"><spring:message code='ezApprovalG.t1755'/></span></h2>
			<ul>
				<c:choose>
					<c:when test="${fn:length(apprGLeftVOList) > 0}">
						<c:forEach var="apprGLeftVOList" items="${apprGLeftVOList}" varStatus="status">
							<c:choose>
								<c:when test="${strLang == ''}">
									<li onclick="setPresentValue('${apprGLeftVOList.containerTypeName}');cmdOK_onclick('\'${apprGLeftVOList.containerID}\'', '${apprGLeftVOList.containerTypeName}', '')"><span style="width:100%;display:inline-block;" id="myDeptCont${status.count - 1}">${apprGLeftVOList.containerTypeName}</span></li>
								</c:when>
								<c:otherwise>
									<li onclick="setPresentValue('${apprGLeftVOList.containerTypeName2}');cmdOK_onclick('\'${apprGLeftVOList.containerID}\'', '${apprGLeftVOList.containerTypeName2}', '')"><span style="width:100%;display:inline-block;" id="myDeptCont${status.count - 1}">${apprGLeftVOList.containerTypeName2}</span></li>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</c:when>
					<c:when test="${fn:indexOf(optGamsabu, userInfo.deptID) < 0}">
						<li><span style="width:100%;display:inline-block;"><spring:message code='ezApprovalG.t1788'/></span></li>
					</c:when>
				</c:choose>
				<c:if test="${fn:indexOf(optGamsabu, userInfo.deptID) > -1}">
					<li onclick="setPresentValue('<spring:message code='ezApprovalG.t1517'/>');cmdOK_onclick('GAMSAHAM', '<spring:message code='ezApprovalG.t1517'/>')"><span style="width:100%;display:inline-block;"><spring:message code='ezApprovalG.t1517'/></span></li>
				</c:if>
			</ul>
			<c:if test="${approvalFlag == 'S'}">
			<h2><span id="ITEMCONT" onclick="setPresentValue('<spring:message code='ezApproval.t844'/>');Open_Func(this)" style="display: inline-block;"><spring:message code='ezApproval.t844'/></span></h2>
			<ul>
          	<c:forEach var="itemList" items="${itemList}" varStatus="status">
          	    <li onclick="setPresentValue('${itemList.taskName}(${itemList.keepingPeriod})');cmdOK_onclick2('${itemList.taskCode}', '${itemList.taskName}', '${itemList.taskName}(${itemList.keepingPeriod})')"><span id = "itemList${status.count - 1}" style="width: 100%; display: inline-block;">${itemList.taskName}(${itemList.keepingPeriod}) </span></li>
          	</c:forEach>
        	</ul>

        <h2><span id="USERCONT" onclick="Open_Func(this)" style="width: 100%; display: inline-block;"><spring:message code='ezApproval.t848'/></span></h2>
        <ul>
            <div class="tree" id="divUserContTree" style="height: 160px; overflow-x: hidden; overflow-y: auto; background-color: #FFFFFF; padding-left: 10px; vertical-align: top; background-color: #ffffff; border-bottom:1px solid #eaeaea"></div>
            <h3><span id="MNGUSERCONT"  onclick="MngUserOnclick()" style="width: 100%; display: inline-block;"><spring:message code='ezApproval.t316'/></span></h3>
        </ul>
        </c:if>
			<c:if test="${approvalFlag eq 'G'}">
			<h2><span style="width:100%;display:inline-block;" id="m01" onClick="Open_Func(this)"><spring:message code='ezApprovalG.t552'/></span><ul></ul></h2>
			<h2><span style="width:100%;display:inline-block;" id="m03" onClick="Open_Func(this)"><spring:message code='ezApprovalG.t911'/></span><ul></ul></h2>
			<h2><span style="width:100%;display:inline-block;" id="m02" onClick="Open_Func(this)"><spring:message code='ezApprovalG.t912'/></span><ul></ul></h2>
			<h2><span style="width:100%;display:inline-block;" id="m05" onClick="Open_Func(this)"><spring:message code='ezApprovalG.t905'/></span><ul></ul></h2>
			<h2><span style="width:100%;display:inline-block;" id="m06" onClick="Open_Func(this)"><spring:message code='ezApprovalG.t906'/></span><ul></ul></h2>			
			<h2 id="tag09"><span style="width:100%;display:inline-block;" id="m07" onClick="Open_Func(this)" ><spring:message code='ezApprovalG.t999'/></span></h2>
			<ul>
				<li id="m07" onclick="Open_Func(this)"><span style="width:100%;display:inline-block;"><spring:message code='ezApprovalG.t524'/></span></li>
				<li id="m08" onclick="Open_Func(this)"><span style="width:100%;display:inline-block;"><spring:message code='ezApprovalG.t908'/></span></li>
			</ul>	
			<h2 id="tag10"><span style="width:100%;display:inline-block;" id="m09" onClick="Open_Func(this)" ><spring:message code='ezApprovalG.t1753'/></span></h2>
			<ul>
				<li id="m09" onclick="Open_Func(this)"><span style="width:100%;display:inline-block;"><spring:message code='ezApprovalG.t909'/></span></li>
				<li id="admin_sub01" onclick="Menu_Click(this)"><span style="width:100%;display:inline-block;"><spring:message code='ezApprovalG.t717'/></span></li>
				<li id="admin_sub02" onclick="Menu_Click(this)"><span style="width:100%;display:inline-block;"><spring:message code='ezApprovalG.t1754'/></span></li>
				<li id="admin_sub03" onclick="Menu_Click(this)"><span style="width:100%;display:inline-block;"><spring:message code='ezApprovalG.t524'/></span></li>
				<li id="admin_sub04" onclick="Menu_Click(this)"><span style="width:100%;display:inline-block;"><spring:message code='ezApprovalG.t520'/></span></li>
			</ul>
			</c:if>
			<c:if test="${approvalForDoc == 'Y'}">
			<c:if test="${fn:contains(userInfo.rollInfo, 'c=1') || fn:contains(userInfo.rollInfo, 'k=1') || fn:contains(userInfo.rollInfo, 'ff=1')}">
				<h2><span  style="width:100%;display:inline-block;" id="approvalForDoc" onClick="Open_Func(this)"><spring:message code='ezApprovalG.lhj13'/></span></h2>
				<ul>
					<li id="approvalForDoc_sub01" onclick="Menu_Click(this)"><span style="width:100%;display:inline-block;"><spring:message code='ezApprovalG.lhj14'/></span></li>
					<li id="approvalForDoc_sub02" onclick="Menu_Click(this)"><span style="width:100%;display:inline-block;"><spring:message code='ezApprovalG.lhj15'/></span></li>
				</ul>
			</c:if>
			</c:if>
	        <h3><span  style="width:100%;display:inline-block;" id="ApprovalConfig" onClick="Open_Func(this)"><spring:message code='ezApprovalG.t1800'/></span></h3>
		</div>
		<script type="text/javascript">
			initToggleList(document.getElementById("left"), "h2", "ul", "li");
		</script>
	</body>
</html>
