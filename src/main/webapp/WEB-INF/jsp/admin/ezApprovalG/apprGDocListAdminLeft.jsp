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
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link href="${util.addVer('/css/jquery.selectbox.css')}" type="text/css" rel="stylesheet" />
		<link href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css" rel="stylesheet" />
		<%-- <link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css"> --%>
		<link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
	    <style type="text/css">
	        .instance.sbHolder{
	            width: 100%;
	        }
	        .sbOptions {
	        	z-index: 50;
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
			#mCSB_1_container {
				margin-right: 0px;
			}
			.node_normal, .node_selected {
				overflow: hidden;
			    text-overflow: ellipsis;
			    display: inline-block;
			    font-size: 14px;
			    line-height: 26px;
			    padding: 0px 0px 0px 3px;
			}
			.node_selected{
				text-decoration: underline !important;
			}
	    </style>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.7.2.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.selectbox-0.2.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CabRoleInfo_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeViewFolder.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
	    
		<script ID="clientEventHandlersJS" type="text/javascript">
			var pUserID = "<c:out value = '${userInfo.id}'/>";
		    var pListTypeValue = '16';//'<c:out value="${listType}"/>';
		    var PresentOpen = "APPROVAL";
		    var CompanyID = '<c:out value = '${userInfo.companyID}'/>';
		    var CompanyName = "<c:out value = '${userInfo.companyName}'/>";
		    var gMenuFlag = 1;
		    var pDeptID = "<c:out value = '${userInfo.deptID}'/>";
		    var contFlag = "END";
		    var pChackYN = "FALSE";
		    var ContainerID;
		    var PageSize   = 10;
		    var szRoleInfo = "<c:out value = '${szRoleInfo}'/>";
		    var Containers = "${containers}";
		    var DocList_Flag="";
		    var DocDeptYN;
		    var DeptID = "<c:out value = '${userInfo.deptID}'/>";
		    var g_bRecAdmin=false;
		    var g_bDeptCharger=false;
		    var AdminYN;
		    var approvalFlag = "<c:out value = '${approvalFlag}'/>";     //전자결재 일반/공공 여부 (G : 공공 , S : 일반)
		    var ViewLeftCount = "<c:out value = '${viewLeftCount}'/>";
		    var primaryStr = "<c:out value = '${userInfo.primary}'/>";
		    var SubContCount = "<c:out value = '${subContCount}'/>";
		    var tmpValue = "";
		    var nodeIdx;
		    var localValue = "";
		    var hideSusin = "<c:out value = '${hideSusin}'/>";
		    var whoKyulYN = "<c:out value = '${whoKyulYN}'/>";
		    var useWebHWP = "<c:out value = '${useWebHWP}'/>";
		    var userTitle = "<c:out value = '${userInfo.title}'/>";
		    var useDraftAll = "<c:out value = '${useDraftAll}'/>";
            var attachedDocList;
            var selectDeptID = "<c:out value = '${selectDeptID}'/>";
            var selectDeptName = "<c:out value = '${selectDeptName}'/>";
		    
		    $(function () {
		      	if(approvalFlag == "G") {
	        		$(".approvalG").css("display","");
	        		$(".approval").css("display","none");
	        	} else{
	        		$(".approvalG").css("display","none");
	        		$(".approval").css("display","");
	        	}
		      	
		        if ("<c:out value = '${isSubTitle}'/>" == "true") {
		        	$("#country_id option").each(function (i) {
		        		var optionVal = this.value.split("|");
		        		if(pDeptID == optionVal[0] && userTitle == optionVal[2]) {
		        			$(this).attr("selected", "selected");
		        		} else {
		        			$(this).removeAttr("selected");
		        		}
		        	});
		        	$("#country_id").selectbox();
		        }
	            $(".sbHolder").each(function (index) {
	                $(this).addClass('instance');
	            });
		         //19.08.05 김보미 - 마우스 클릭시 볼드체   
		         $(document).on("click", "span.list_text", function(){
		        	 $("#left li").removeClass("on");
		        	 $(".node_selected").addClass("node_normal");
		        	 $(".node_selected").removeClass("node_selected");
		        	 $(this).parent().addClass("on");
		         })
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
		        
		        var idx = "4", navigation_info = "<spring:message code='ezApprovalG.t102'/>";
		        //if(approvalFlag == "S") {
		        	Tree_setconfig();
		            var xmlDom2 = createXmlDom();
		            xmlDom2 = loadXMLString("${userCont}");
		            var treeView = new TreeView();
		            treeView.SetID("UserContTree");
		            treeView.SetUseAgency(true);
		            treeView.SetRequestData("UserContRequestData");
		            treeView.SetNodeClick("UserContNodeClick");
		            treeView.DataSource(xmlDom2);
		            treeView.DataBind("divUserContTree");

		            //title3[0].setAttribute("TITLE", title3[0].innerHTML); 
 		            $(".node_normal").css("width", "145px");
 		            
					var node = $(".node_normal");
					
					/* 2020-06-29 홍승비 - 개인문서함 tile 특문처리 */
					for(var i=0; i<node.length; i++) {
						node[i].setAttribute("TITLE", node[i].innerText);
					} 

		       // } 
			        if (parseInt(pListTypeValue) < 10) {
			            window.open("/ezApprovalG/aprManage.do?listType=" + pListTypeValue + "&subQuery=", "right");
			
			            if (pListTypeValue == "1" || pListTypeValue == "11") {
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
			            	window.open("/ezApprovalG/aprManage.do?listType=" + pListTypeValue + "&subQuery=", "right");
			            	setPresentValue("<spring:message code='ezApprovalG.hyj04'/>");
			                document.getElementById('APPROVAL99').click();
			            }
			            if (pListTypeValue == '21') {
			            	setPresentValue("<spring:message code='ezApprovalG.t3000'/>");
			                document.getElementById('APPROVAL21').click();
			            }
						if (pListTypeValue == '24') {
							setPresentValue("<spring:message code='ezApprovalG.t1756'/>");
							document.getElementById('APPROVAL24').click();
						}
		        }
		        getAprCount();
		        leftResize();
		        $(".apprListBox").mCustomScrollbar({
	        		theme : "dark"
	        	});
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
		        if (title2[0] !=null ) {
		        	var nodeLevel = title2[0].getAttribute("nodelevel");
		        }
		        
		        if (nodeLevel > 9) {
		        	nodeLevel = 9;
		        }
		        for (var i = 0; i < title2.length; i++) {
		        	var title3 = title2[i].getElementsByClassName("node_normal");
		        	//title3[0].setAttribute("TITLE", title3[0].innerHTML); 
		        	if (title3[0] != null) {
		        		title3[0].style.width = 145 - 16*(nodeLevel-1) +'px';
		        	//title3[0].style.textOverflow = 'ellipsis';
		        	//title3[0].style.overflow = 'hidden';
		        	// 개인문서함 하위폴더 확장 시, title 속성 부여
		        		title3[0].title = title3[0].innerText;
		        	}
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
	            
	            $(".node_normal").css("width", "145px");
 		          
				var node = $(".node_normal");
					
				for(var i=0; i<node.length; i++) {
					node[i].setAttribute("TITLE", node[i].innerText);
				} 
	        }
	        
		    function Open_Func(pthis) {
		        try {
		            switch (pthis.id) {
		                case "APPROVAL":
		                    //setPresentValue("<spring:message code='ezApprovalG.t1747'/>");
		                    //convMain('1', '');
		                    DocManageMain(pthis.id);
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
	                		//document.getElementById('myDeptCont0').onclick();
	                		document.getElementById('myDeptCont0').parentElement.onclick();	//#14477
		                    break;
		                case "ITEMCONT":
		                	//document.getElementById('itemList0').onclick();
		                	document.getElementById('itemList0').parentElement.onclick(); //#14477
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
						case "m15" :
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
		                case "m12":
							DocManageMain(pthis.id);
		                    break;
		                case "m13":
							DocManageMain(pthis.id);
		                    break;
		                case "m14":
							DocManageMain(pthis.id);
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
		                case "UNTREATED":
							pListTypeValue = "23";
		                    DocManageMain(pthis.id);
		                    break;
		                case "readingRecord" : 
		                	DocManageMain(pthis.id);
		                	break;
		                default:
		                    break;
		            }
		            
		            if($(pthis).hasClass('shareCont')){
	                    cmdOK_onclick('', "<spring:message code='ezApproval.t990042'/>",'',$(pthis).attr("shareUserId"));
	                    $(".list_text").parent().removeClass("on");
		            }
		            if($(pthis).hasClass('deptShare')){
		            	pListTypeValue = "";
                		window.parent.frames.right.document.location.href = "/ezApprovalG/cabinetMain.do?sFlag=docShare&shareDeptId=" + pthis.id;          		 
		            }
		            
		            parent.frames["right"].$('#sel_year').val("ALL");
		            parent.frames["right"].$('#sel_status').val("ALL");
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
		 		    	if (event.target.tagName == "SPAN" && event.target.classList.contains("list_text") && !event.target.classList.contains("deptShare")) {
		 		    		var divElements = document.querySelectorAll('div');
		 		    		divElements.forEach(function(div) {
		 		    	        if (div.id.endsWith('_sub')) {
		 		    	            div.style.display = "none";
		 		    	        }
		 		    	    });
		 		    		$(".tree_minus").attr("class", "sub_iconLNB tree_plus");
			 		    	$(".node_selected").attr("class","node_normal");
		 		    	}
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
		
		    function convMain(listtype, SubQuery, shareUserId) {
		        try {
		            	parent.frames["right"].$('#sel_status').val("ALL");
		            	
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
				                else if (listtype == "5") {
				                    parent.frames["right"].passValLeftMenu("5");
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
				                	parent.frames.right.document.location.href = "/ezApprovalG/aprManage.do?listType=" + listtype  + "&SubQuery=" + escape(SubQuery) + "&tmpValue=" + escape(tmpValue);
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
				                else if (listtype == "23") {
				                    parent.frames["right"].passValLeftMenu("23");
				                    parent.frames["right"].checkBujaeInfo();
				                }
								else if (listtype == "24") {
									parent.frames["right"].passValLeftMenu("24");
									parent.frames["right"].checkBujaeInfo();
								}
				                else {
				                    parent.frames["right"].passValLeftMenu("1");
				                    parent.frames["right"].checkBujaeInfo();
				                }
				            }
				            try { parent.frames["right"].document.getElementById("txt_keyword").value = ""; } catch (e) { }
				            parent.frames["right"].$('#sel_year').val("ALL");
				            parent.frames.right.change_statusCell();
				            /* parent.frames["right"].$('#sel_year').selectmenu('refresh'); */
		        		} else {
		        			if(!shareUserId){
		        				shareUserId = "";
		        			}
				        	if (PresentOpen != "APPROVAL") {
				                PresentOpen = "APPROVAL";
				                window.parent.frames.right.document.location.href = "/ezApprovalG/aprManage.do?listType=" + listtype  + "&SubQuery=" + encodeURIComponent(SubQuery) + "&tmpValue=" + encodeURIComponent(tmpValue) + "&shareUserId=" + shareUserId;
				            }
				            else {
				                window.parent.frames.right.document.location.href = "/ezApprovalG/aprManage.do?listType=" + listtype  + "&SubQuery=" + encodeURIComponent(SubQuery) + "&tmpValue=" + encodeURIComponent(tmpValue) + "&shareUserId=" + shareUserId;
				            }
				        }
		        }
			        catch (e) { }
		    }
		
		    var getformcont_cross_dialogArguments = new Array();
		    var getformcont_Cross_OpenWin = "";
		    function btnDraft_onclick() {
		    	var parameter = new Array();
		        parameter[0] = "sol2";
		        parameter[1] = "A01000";
                parameter[2] = attachedDocList;

		        if ("YES" == ("YES")) {
		            url = "/ezApprovalG/getFormCont.do";
		        } else {
		            url = "/ezApproval/getFormCont.do";
		        }
		        
		        if (CrossYN()) {
		            getformcont_cross_dialogArguments[0] = parameter;
		            getformcont_cross_dialogArguments[1] = openForm_Complete;
		            var getFormCont_Cross = window.open(url, "/ezApproval/getFormCont.do", GetOpenWindowfeature(713, 570));
		            
		            try { getFormCont_Cross.focus(); } catch (e) {}
		        } else {
		            var feature = "status:no;dialogWidth:713px;dialogHeight:570px;edge:sunken;scroll:no";
		            var ret = window.showModalDialog(url, parameter, feature);
		            formURL = ret[0];
		            formDocType = ret[1];
		            
		            if (formURL != "cancel") {
		                openDraftUI(formURL, formDocType);
		            }
		        }

				attachedDocList = "";
		    }
		    
		    /* 2022-01-11 홍승비 - 전자결재G 일괄기안 기능 추가 (웹한글) */
		    function btnDraftAll_onclick() {
		    	var parameter = new Array();

				parameter.push(attachedDocList);

	            getformcont_cross_dialogArguments[0] = parameter; // 일괄기안창으로 전달할 파라미터 있다면 배열에 추가
	            getformcont_cross_dialogArguments[1] = draftAll_Complete;
	            
	            // 양식 선택창 없이 바로 일괄기안창을 호출한다.
	            var getFormCont_Cross = window.open("/ezApprovalG/draftuiAll_WHWP.do", "/ezApproval/draftuiAll_WHWP.do", GetOpenWindowfeature(1150, 950));
	            try { getFormCont_Cross.focus(); } catch (e) {}

				attachedDocList = "";
		    }
		    
		    function draftAll_Complete(ret) {}
		    
		    function openForm_Complete(ret) {
		        formURL = ret[0];
		        formDocType = ret[1];
                attachedDocList = ret[5];
		        var officeFlag = "";

		        if(ret[4] !== null) {
	    	    	officeFlag = ret[4];
	    	    }
		        
		        if (formURL != "cancel") {
		            openDraftUI("DRAFT","",officeFlag);
		        }
		    }

		    function openDraftUI(pDraftFlag,pCurSelRow,officeFlag) {
		        var pArgument = new Array();
		        var gb = "";
		        
		        if ("YES" == ("YES"))
		            gb = "G";
		        
	        	pArgument[0] = pUserID;
	            pArgument[1] = formURL;
	            pArgument[2] = "DRAFT";
	            pArgument[3] = formDocType;
	            pArgument[4] = "0"
	            pArgument[5] = ""
	            pArgument[6] = ""
	            pArgument[7] = "";

	            var openLocation = "";
	            if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "hwp") {
	            	if(useWebHWP == "NO") {
		                if (!isIE()) {
		                    alert("한글양식은 Cross Browser 를 지원하지 않습니다.");
		                    return;
		                } else {
		                   var openLocation = "/ezApprovalG/draftuiHWP.do";
		                }
	            	} else {
	            		var openLocation = "/ezApprovalG/draftuiWHWP.do";
	            	}
	            } else {
	                var openLocation = "/ezApprovalG/draftui.do";
	            }
	            <%-- 2021-01-21 심기영 오피스결재 추가 --%>
				var p_officeFlag = "";
	            
	            if(officeFlag !== null) {
	            	p_officeFlag = officeFlag;
	            }
	            
                openLocation = openLocation + "?formURL=" + escape(pArgument[1]) + "&draftFlag=" + escape(pArgument[2]) + "&formDocType=" + escape(pArgument[3]);
                openLocation = openLocation + "&susinSN=" + escape(pArgument[4]) + "&docState=" + escape(pArgument[5]) + "&listType=1" + "&aprState=" + escape(pArgument[6]);
                openLocation = openLocation + "&isTmpDoc=" + escape(pArgument[7]) + "&officeFlag=" + encodeURI(p_officeFlag) + "&attachedDocList=" + (typeof attachedDocList == "undefined" ? "" : attachedDocList);
                
	            openwindow(openLocation, "", 1150, 950);
	        }
		    
		    function openwindow(wfileLocation, wName, wWeigth, wHeigth) {
		        try {
		            var heigth = window.screen.availHeight;
		            var width = window.screen.availWidth;

		            var left = 0;
		            var top = 0;

		            if (window.screen.width > 800) {
		                var pleftpos;

		                pleftpos = parseInt(width) - 1150;
		                heigth = parseInt(heigth) - 30;

		                if (CrossYN())
		                    heigth = parseInt(heigth) - 25;

		                if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1)
		                    heigth = parseInt(heigth) - 40;

		                width = parseInt(width) - pleftpos;

		                left = pleftpos / 2;
		            }
		            else {

		                heigth = parseInt(heigth) - 30;

		                if (CrossYN())
		                    heigth = parseInt(heigth) - 25;

		                if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1)
		                    heigth = parseInt(heigth) - 40;

		                width = parseInt(width) - 10;
		            }

		            window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
		        }
		        catch (e) {
		            alert("openwindow :: " + e.description);
		        }
		    }	
		
		    function cmdOK_onclick(ContainerID, ContName, SubQuery, shareUserId) {
		    	if(!shareUserId){
		    		shareUserId = "";
		    	}else{
		    	    PresentOpen = "APPROVAL";
		        }
		        if (PresentOpen != "CONTAINER") {
		            PresentOpen = "CONTAINER";
	                window.parent.frames.right.document.location.href = "/ezApprovalG/getContainerInfo.do?contID=" + encodeURI(ContainerID) + "&sQuery="+ escape(SubQuery) + "&tmpValue=" + encodeURI(ContName) + "&ENDAPRTYPE=" + strAprType40 + "&ENDAPRSTATE=" + strAprState2 + "&shareUserId=" + shareUserId;
		        } else {
		            try {
		            	 window.parent.frames.right.document.location.href = "/ezApprovalG/getContainerInfo.do?contID=" + encodeURI(ContainerID) + "&sQuery="+ escape(SubQuery) + "&tmpValue=" + encodeURI(ContName) + "&ENDAPRTYPE=" + strAprType40 + "&ENDAPRSTATE=" + strAprState2 + "&shareUserId=" + shareUserId;
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
		    
		    function goFormContainer(ContainerID, shareDeptId){
		    	if(!shareDeptId){
		    		shareDeptId = "";
		    	}
		    	PresentOpen = "CONTAINER";
                var subCondition = "TBL_EXPENDAPRDOCINFO.FORMNAME = '" + ContainerID + "'";
                window.parent.frames.right.document.location.href = "/ezApprovalG/getContainerInfo.do?contID=" + encodeURIComponent(Containers) + "&sQuery=" + encodeURIComponent(subCondition) + "&tmpValue=" + encodeURIComponent(tmpValue) + "&itemID=" + encodeURIComponent(ContainerID) + "&shareDeptId=" + shareDeptId;
		    }
		    
		    function setBoldText(elem) {
		    	$(".node_selected").each(function (index) {
	                $(this).removeClass('node_selected');
	                $(this).addClass('node_normal');
	                $("#left li").removeClass('on')
	            });
		    	$(elem).removeClass('node_normal');
                $(elem).addClass('node_selected');
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
	                        document.getElementById("countsub" + presentValue).innerHTML = "&nbsp;&nbsp;<b>" + count + "</b>";
	                    else
	                        document.getElementById("countsub" + presentValue).innerHTML = "";
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
					var countXml = xmlhttp_total.responseXML;
					var countList = GetChildNodes(countXml.documentElement);

					var listCountMap = {
						"1" : "COUNT1",
						"2" : "COUNT3",
						"3" : "COUNT2",
						"4" : "COUNT4",
						"5" : "COUNT5",
						"6" : "COUNT6",
						"7" : "COUNT7",
						"10" : "COUNT10",
						"11" : "COUNT11",
						"21" : "COUNT21",
						"23" : "COUNTUNTREATED",
						"24" : "COUNT24",
						"99" : "COUNT99"
					}

					for (var i = 0, iLen = countList.length; i < iLen; i++) {
						try {
							var countNode = countList[i];
							var countNodeName = countNode.nodeName;

							//if (listCountMap[pListTypeValue] !== countNodeName) {
								var countElem = document.querySelector("#" + countNodeName);
								if (countElem) {
									// 2023-06-23 황인경 - 디자인 개선 > 전자결재 > 좌측메뉴 > 문서 카운트 괄호 추가
									countElem.innerHTML = getNodeText(countNode) === "0" ? "" : "(" + getNodeText(countNode) + ")";
								}
							//}
						} catch (e) { }
					}
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
		                count1.innerHTML = "&nbsp;&nbsp;<b>" + cnt + "</b>";
		            else
		                count1.innerHTML = "";
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
		                count2.innerHTML = "&nbsp;&nbsp;<b>" + cnt + "</b>";
		            else
		                count2.innerHTML = "";
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
		                count3.innerHTML = "&nbsp;&nbsp;<b>" + cnt + "</b>";
		            else
		                count3.innerHTML = "";
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
		                count4.innerHTML = "&nbsp;&nbsp;<b>" + cnt + "</b>";
		            else
		                count4.innerHTML = "";
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
		                count6.innerHTML = "&nbsp;&nbsp;<b>" + cnt + "</b>";
		            else
		                count6.innerHTML = "";
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
		                count7.innerHTML = "&nbsp;&nbsp;<b>" + cnt + "</b>";
		            else
		                count7.innerHTML = "";
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
		                count99.innerHTML = "&nbsp;&nbsp;<b>" + cnt + "</b>";
		            else
		                count99.innerHTML = "";
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
						case "openGov":
							//원문공개문서함
							PresentOpen = "DOC_ADMIN";
							window.parent.frames.right.document.location.href = "/admin/ezApprovalG/openGovForDoc.do?type=admin";
							openFolder(pthis.id);
							break;	
		            }
		        } catch (e) { }
		    }
		
		    function DocManageMain(sFlag) {
		        try {
		            if (PresentOpen != "DOCMANAGE" && sFlag != "readingRecord") {
		                PresentOpen = "DOCMANAGE";
		                window.parent.frames.right.document.location.href = "/admin/ezApprovalG/cabinetMain.do?sFlag=" + sFlag;
		            }
		            else {
		                window.parent.frames["right"].g_uFlag = sFlag;
		                switch (sFlag) {
		                    case "m01":
		                    	window.parent.frames.right.document.location.href = "/admin/ezApprovalG/cabinetMain.do?sFlag=" + sFlag;
		                        break;
		                    case "m02":
							case "m15" :
		                        window.parent.frames.right.document.location.href = "/admin/ezApprovalG/cabinetMain.do?sFlag=" + sFlag;
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
							case "UNTREATED":
		                        window.parent.frames.right.document.location.href = "/ezApprovalG/cabinetMain.do?sFlag=" + sFlag;
								break;
							case "m12":
		                        window.parent.frames.right.document.location.href = "/ezApprovalG/cabinetMain.do?sFlag=" + sFlag;
								break;
							case "m13":
		                        window.parent.frames.right.document.location.href = "/ezApprovalG/cabinetMain.do?sFlag=" + sFlag;
								break;
							case "m14":
		                        window.parent.frames.right.document.location.href = "/ezApprovalG/cabinetMain.do?sFlag=" + sFlag;
								break;
							case "readingRecord" : 
								window.parent.frames.right.document.location.href = "/ezApprovalG/readingRecord.do";
								break;
		                }
		            }
		        } catch (e) { }
		    }
		    var arr_userinfo = new Array();
		    function ChangeSubtitle(obj) {
		        var UseSelectTitle = obj.getAttribute("onclick").split("#")[1].split("|");
		        if ("<c:out value = '${userInfo.deptID}'/>" != UseSelectTitle[0] || userTitle != UseSelectTitle[2]) {
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
		            // 2023-08-28 전인하 > 겸직/사용자 기준 권한 설정 옵션이 추가됨에 따라 권한 정보 호출에 필요한 JobId 데이터를 추가
		            pJobId = UseSelectTitle[10];
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
	        				deptName  : arr_userinfo[15],
	        				deptName2 : arr_userinfo[16],
	        				position  : arr_userinfo[13],
	        				position2 : arr_userinfo[14],
	        				companyID : companyID,
	        				companyName : CompanyName,
	        				companyName2 : CompanyName2,
	        				jobId : pJobId
	        		},
	        		success: function(xml){
	        			/* 2021-10-07 홍승비 - 부재자설정 후 겸직 셀렉트박스에서 겸직정보 변경 시 undefined 알러트 메세지 발생하지 않도록 수정 */
	        			// 좌측 페이지가 먼저 갱신되므로, 우측 페이지가 갱신되기 전에 겸직정보 파라미터를 사용하지 않도록 공백으로 처리함
	        			if (typeof(parent.frames["right"].arr_userinfo[7]) != "undefined") {
	        				parent.frames["right"].arr_userinfo[7] = "";
	        			}
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
	                    document.getElementById('countWHO').innerHTML = "&nbsp;&nbsp;<b>" + (getNodeText(dataNodes[0]) == "0" ? "" : getNodeText(dataNodes[0])) + "</b>";
	                else
	                    document.getElementById('countWHO').innerHTML = "";
	            } catch (e) { }
	        }
	        
	        function openFolder(val01) {
	        	if ($("#" + val01 + "H2").attr("class") == "on") {

	        		if (val01 != "openGov") {
	        			$("#" + val01 + "H2").attr("class", "off");
		        		$("#" + val01 + "UL").attr("class", "lnbUL off");
		        		// 2023-06-23 황인경 - 디자인 개선 > 전자결재 > 좌측메뉴 > 트리구조 LNB 이미지 수정
		        		
		        		if (val01 == 'person') {
							$("#" + val01 + "H2").children().eq(1).attr("class", "sub_iconLNB tree_plus"); 
						} else {
							$("#" + val01 + "H2").children().eq(0).attr("class", "sub_iconLNB tree_plus"); 
						}
	        		}
	        	} else {
	        		$(".lnb H2").attr("class", "off");
	        		$(".lnb UL").attr("class", "lnbUL off");
	        		
	        		$("#" + val01 + "H2").attr("class", "on")
	        		$("#" + val01 + "UL").attr("class", "lnbUL");
	        		$('.tree_arrow_down').attr("class", "sub_iconLNB tree_plus");

	        		if (val01 != "openGov") {
		        		
		        		if (val01 == 'person') {
		        			$("#" + val01 + "H2").children().eq(1).attr("class", "sub_iconLNB tree_arrow_down");
		        		} else {
			        		$("#" + val01 + "H2").children().eq(0).attr("class", "sub_iconLNB tree_arrow_down");
		        		}
	        		}
	        	}
	        }
	        
	        function leftResize(){
	        	$(".apprListBox").height(window.innerHeight-105<c:if test="${isSubTitle}">-30</c:if>);
	        }
	        
	        $( window ).resize(function() {
	        	leftResize();
        	});

			function openergetDocInfo() {
				try {
					window.parent.frames.right.openergetDocInfo();
				} catch (e) {
					console.log(e);
				}
			}
		</script>
	</head>
	<body ondragstart="return false" onselectstart="return false" class="newLeft">
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel_left">&nbsp;</div>
		<span  id="presentcell" style="display:none"></span>
		<div id="left" class="lnb">
	    	<!-- <div class="lnb_btn"></div> -->
	        <!-- <div class="lnb_btn_hidden"></div> lnb 숨기기 버튼-->
	    	<div class="left_title" title="<spring:message code='ezApprovalG.t102'/>">
	    		<spring:message code='ezApprovalG.t102'/> - <span id="selectDeptName" dataDeptId="${selectDeptID}">${selectDeptName}</span>
	        	<!--<span class="sub_iconLNB tree_leftconfig" id="ApprovalConfig" onClick="Open_Func(this)" title="<spring:message code='ezApprovalG.t1800'/>"></span>-->
	        </div>
	        
	        <%-- 25022-01-11 홍승비 - 전자결재G 일괄기안 버튼 추가 (웹한글) --%>
	        <%--<div class="btn_writeBox">
	        	<c:choose>
	        	<c:when test="${approvalFlag == 'G' && useWebHWP == 'YES' && useDraftAll == 'YES'}">
	        		<p class="btn_write01" onclick="btnDraft_onclick();" style="width:83px; display:inline-block; float:none;"><spring:message code='main.t00031'/></p>
	        		<p class="btn_write01" onclick="btnDraftAll_onclick();" style="width:83px; display:inline-block; float:right;"><spring:message code='ezApprovalG.HSBDa01'/></p>
	        	</c:when>
	        	<c:otherwise>
	        		<p class="btn_write01" onclick="btnDraft_onclick();"><spring:message code='main.t00031'/></p>
	        	</c:otherwise>
	        	</c:choose>
	        </div>--%>
	        
	        <c:if test="${isSubTitle}">
		        <select name="country_id" id="country_id" tabindex="1">
		            ${subTitleString}
				</select>
			</c:if>
			<div class="apprListBox" style="overflow:hidden; padding-right: 0; height: 912px;">
		        <h2 class="off" id="apprH2" style="display:none;">
		            <span class="sub_iconLNB tree_arrow_down"></span><span class="h2Title" id="APPROVAL" onclick="openFolder('appr')"><spring:message code='main.t00018'/></span>
		        </h2>
		        <ul class="lnbUL off" id="apprUL" style="display:none;">
					<li><span class="list_text" id="APPROVAL1" onclick="setPresentValue('<spring:message code='ezApprovalG.t1747'/>');convMain('1','')"><spring:message code='ezApprovalG.t1747'/><span id=COUNT1></span></span></li>
                   	<c:if test="${whoKyulYN == '1'}">
                       	<li><span class="list_text" id="MYCONTWHO" onclick="setPresentValue('<spring:message code='ezApproval.pjj34'/>');Open_Func(this)"><spring:message code='ezApproval.pjj34'/><span id="COUNTWHO"></span></span></li>
	                </c:if>
                   	<c:if test="${approvalFlag == 'S' && useShareApproval == 'YES' }">
                       	<li><span class="list_text" id="APPROVAL11" onclick="setPresentValue('<spring:message code='ezApprovalG.bhs03'/>');convMain('11','')"><spring:message code='ezApprovalG.bhs03'/><span id=COUNT11></span></span></li>
					</c:if>
                   	<li><span class="list_text" id="APPROVAL2" onclick="setPresentValue('<spring:message code='ezApprovalG.t1706'/>');convMain('3','')"><spring:message code='ezApprovalG.t1706'/><span id=COUNT2></span></span></li>
                   	<li><span class="list_text" id="APPROVAL3" onclick="setPresentValue('<spring:message code='ezApprovalG.t1748'/>');convMain('2','')"><spring:message code='ezApprovalG.t1748'/><span id=COUNT3></span></span></li>
					<%-- 2023-03-23 양지혜 - 반송된문서함 추가 --%>
					<li><span class="list_text" id="APPROVAL24" onclick="setPresentValue('<spring:message code='ezApprovalG.t1756'/>');convMain('24','')"><spring:message code='ezApprovalG.t1756'/><span id=COUNT24></span></span></li>

					<c:if test="${approvalFlag eq 'G' && autoSendOfferFlag eq '1'}">
                   	<li><span class="list_text" id="UNTREATED" onclick="setPresentValue('미처리문서');Open_Func(this);">미처리문서함<span id=COUNTUNTREATED></span></span></li>
                   	</c:if>
                   	<li><span class="list_text" id="APPROVAL21" onclick="setPresentValue('<spring:message code='ezApprovalG.t3000'/>');convMain('21','')"><spring:message code='ezApprovalG.t3000'/><span id=COUNT21></span></span></li>
                   	<c:if test="${hideSusin != 'N'}">
                       	<li><span class="list_text" id="APPROVAL4" onclick="setPresentValue('<spring:message code='ezApprovalG.t1749'/>');convMain('4','')"><spring:message code='ezApprovalG.t1749'/><span id=COUNT4></span></span></li>
					</c:if>
                   	<c:if test="${approvalFlag == 'S'}">
                       	<li></span><span class="list_text" id="APPROVAL99" onclick="setPresentValue('<spring:message code='ezApprovalG.hyj04'/>');convMain('99','')"><spring:message code='ezApprovalG.hyj04'/><span id="COUNT99"></span></span></li>
					</c:if>
					<c:if test="${approvalFlag == 'G'}">
                       	<li><span class="list_text" id="APPROVAL99" onclick="setPresentValue('<spring:message code='ezApprovalG.t10011'/>');convMain('99','')"><spring:message code='ezApprovalG.t10011'/><span id="COUNT99"></span></span></li>
					</c:if>
					<c:if test="${approvalFlag eq 'S' && userInfoEnforce == '2'}">
                       	<li><span class="list_text" id="APPROVAL5" onclick="setPresentValue('<spring:message code='ezApproval.t839'/>');convMain('6', '')"><spring:message code='ezApproval.t839'/><span id="COUNT6"></span></span></li>
					</c:if>
					<c:if test="${approvalFlag eq 'G'}">
						<c:if test="${relayShowFlag eq 'Y'}">
							<li class="approvalG"><span class="list_text" id="APPROVAL5" onclick="setPresentValue('<spring:message code='ezApprovalG.kbh04'/>');convMain('5');"><spring:message code='ezApprovalG.kbh04'/><span id="COUNT5"></span></span></li>
						</c:if>
						<c:if test="${relayShowFlag eq 'Y' || howToSendOffer eq '1'}">
							<li class="approvalG"><span class="list_text" id="APPROVAL6" onclick="setPresentValue('<spring:message code='ezApprovalG.kbh05'/>');convMain('6');"><spring:message code='ezApprovalG.kbh05'/><span id="COUNT6"></span></span></li>
						</c:if>
                   	</c:if>
					<c:if test="${userSendOut == 'YES'}">
                       	<li class="approvalG"><span class="list_text" id="APPROVAL7" onclick="setPresentValue('<spring:message code='ezApprovalG.t1752'/>');convMain('7','')"><spring:message code='ezApprovalG.t1752'/><span id=COUNT7></span></span></li>
                       	<li class="approvalG"><span class="list_text" id="APPROVAL8" onclick="setPresentValue('<spring:message code='ezApprovalG.t1275'/>');convMain('8','')"><spring:message code='ezApprovalG.t1275'/></span></li>
					</c:if>
		        </ul>
		        <h2 class="off" id="compH2" style="display:none;">
		            <span class="sub_iconLNB tree_plus"></span><span class="h2Title" id="APPROVAL" onclick="openFolder('comp')"><spring:message code='ezApprovalG.lhj15'/></span>
		        </h2>
		        <ul class="lnbUL off" id="compUL" style="display:none;">
                   	<li><span class="list_text" id="MYCONT" onClick="setPresentValue('<spring:message code='ezApproval.t990042'/>');Open_Func(this)"><spring:message code='ezApproval.t990042'/></span></li>
                   	<c:if test="${approvalFlag == 'S'}">
                           	<li><span class="list_text" id="APPROVAL10" onClick="setPresentValue('<spring:message code='ezApprovalG.hyj03'/>');convMain('10','')"><spring:message code='ezApprovalG.hyj03'/></span></li>
                   	</c:if>
                   	<c:if test="${approvalFlag == 'G'}">
                           	<li><span class="list_text" id="APPROVAL10" onClick="setPresentValue('<spring:message code='ezApprovalG.t1787'/>');convMain('10','')"><spring:message code='ezApprovalG.t1787'/></span></li>
                   	</c:if>
		        </ul>
		        <h2 class="off" id="deptH2" style="display:none;">
		            <span class="sub_iconLNB tree_plus"></span><span class="h2Title" onclick="openFolder('dept')"><spring:message code='ezApprovalG.t1755'/></span>
		        </h2>
		        <ul class="lnbUL off" id="deptUL" style="display:none;">
                   	<c:choose>
						<c:when test="${fn:length(apprGLeftVOList) > 0}">
							<c:forEach var="apprGLeftVOList" items="${apprGLeftVOList}" varStatus="status">
								<c:choose>
									<c:when test="${strLang == ''}">
		                            	<li><span class="list_text" id="myDeptCont${status.count - 1}" onclick="setPresentValue('${apprGLeftVOList.containerTypeName}');cmdOK_onclick('\'${apprGLeftVOList.containerID}\'', '${apprGLeftVOList.containerTypeName}', '')">${apprGLeftVOList.containerTypeName}</span></li>
									</c:when>
									<c:otherwise>
		                            	<li><span class="list_text" id="myDeptCont${status.count - 1}" onclick="setPresentValue('${apprGLeftVOList.containerTypeName2}');cmdOK_onclick('\'${apprGLeftVOList.containerID}\'', '${apprGLeftVOList.containerTypeName2}', '')">${apprGLeftVOList.containerTypeName2}</span></li>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</c:when>
						<%-- <c:when test="${fn:indexOf(optGamsabu, userInfo.deptID) < 0}">
							<li><span style="width:100%;display:inline-block;"><spring:message code='ezApprovalG.t1788'/></span></li>
						</c:when> --%>
					</c:choose>
					<c:if test="${fn:indexOf(optGamsabu, userInfo.deptID) > -1}">
                       	<li><span class="list_text" onclick="setPresentValue('<spring:message code='ezApprovalG.t1517'/>');cmdOK_onclick('GAMSAHAM', '<spring:message code='ezApprovalG.t1517'/>')"><spring:message code='ezApprovalG.t1517'/></span></li>
					</c:if>
		        </ul>
		        <c:if test="${approvalFlag == 'S'}">
		        	<c:if test="${useApprFormCont == 'YES'}">
		        	<h2 class="off" id="ITEMCONTH2">
		        		<span class="sub_iconLNB tree_plus"></span>
		        		<span class="h2Title" onclick="openFolder('ITEMCONT');"><spring:message code='ezApprovalG.apprLeft01'/></span>
		        	</h2>
					<ul class="lnbUL off" id="ITEMCONTUL">
			          	<c:forEach var="form" items="${itemList}" varStatus="status">
			          	    <li><span class="list_text" id="itemList${status.count - 1}"  onclick="setPresentValue('${form.formName}'); goFormContainer('${form.formName}');"><c:out value="${form.formName}"></c:out></span></li>
			          	</c:forEach>
		          	</ul>
		          	</c:if>
		          	<c:if test="${useApprCodeCont == 'YES'}">
		        	<h2 class="off" id="ITEMCONT2H2">
		        		<span class="sub_iconLNB tree_plus"></span>
		        		<span class="h2Title" onclick="openFolder('ITEMCONT2');"><spring:message code='ezApproval.t844'/></span>
		        	</h2>
		        	<ul class="lnbUL off" id="ITEMCONT2UL">
			          	<c:forEach var="itemList" items="${taskItemList}" varStatus="status">
			          	    <li><span class="list_text" id="itemList${status.count - 1}"  onclick="setPresentValue('${itemList.taskName}(${itemList.keepingPeriod})');cmdOK_onclick2('${itemList.taskCode}', '${itemList.taskName}', '${itemList.taskName}(${itemList.keepingPeriod})');">${itemList.taskName}(${itemList.keepingPeriod}) </span></li>
			          	</c:forEach>
		          	</ul>
		          	</c:if>
		          	<c:if test="${fn:length(userShareList) > 0 }">
			        	<h2 class="off" id="USERSHAREH2">
			        		<span class="sub_iconLNB tree_plus"></span>
			        		<span class="h2Title" onclick="openFolder('USERSHARE');"><spring:message code='ezApprovalG.apprLeft02'/></span>
			        	</h2>
						<ul class="lnbUL off" id="USERSHAREUL">
							<div id="UserShare_0">
				          	<c:forEach var="userShare" items="${userShareList}" varStatus="status">				          	
								<i id="imgNode_UserShare_${status.index}" class="sub_iconLNB tree_plus" border="0" onclick="treeicon_toggle('UserShare_${status.index}', 'UserContTree', UserContRequestData, 'imgNode_UserShare_${status.index}');" style="width: 18px;height: 18px;cursor: pointer;margin-left: 23px;"></i>
<%-- 								<img id="subImgNode_UserShare_${status.index}" border="0" src="/images/OrganTree_cross/fldr.gif" style="width: 18px; height: 18px;" class="mCS_img_loaded"> --%>
								<span id="spn_UserShare_${status.index}" class="node_normal" onclick="treeicon_toggle('UserShare_${status.index}', 'UserContTree', UserContRequestData, 'imgNode_UserShare_${status.index}');" style="cursor: pointer; width: 135px;" title='<c:out value="${userShare.shareName }"></c:out>'><c:out value="${userShare.shareName }"></c:out></span>
								<div id="UserShare_${status.index}_sub" style="display:none;">
<%-- 					    			<div class="node_div" id="DeptShare_${status.index}_0" nodename="결재진행문서" nodelevel="1" endnode="true" value="결재진행문서" isleaf="TRUE" expanded="FALSE" style="white-space: nowrap;"> --%>
<!-- 										<img border="0" class="DOT" src="/images/OrganTree/dot_end.gif" style="width: 18px; height: 18px;"> -->
<%-- 										<img id="imgNode_DeptShare_${status.index}_0}" border="0" src="/images/OrganTree_cross/dot_end.gif" style="width: 18px; height: 18px;"> --%>
<%-- 										<img id="subImgNode_DeptShare_${status.index}_0" border="0" src="/images/OrganTree_cross/fldr.gif" style="width: 18px; height: 18px;"> --%>
<%-- 										<span onclick="setPresentValue('결재진행문서');convMain('3','','${userShare.shareId}')" style="cursor: pointer; width: 135px;" title="결재진행문서" id="spn_DeptShare_${status.index}_0" class="node_normal">결재진행문서</span> --%>
<!-- 									</div> -->
					    			<div class="node_div" id="DeptShare_${status.index}_1" nodename="결재완료문서" nodelevel="1" endnode="true" value="결재완료문서" isleaf="TRUE" expanded="FALSE" style="white-space: nowrap;">
										<img border="0" class="DOT" src="/images/OrganTree/dot_end.gif" style="width: 18px; height: 18px;">
										<img id="imgNode_DeptShare_${status.index}_1" border="0" src="/images/OrganTree_cross/dot_end.gif" style="width: 18px; height: 18px;">
										<img id="subImgNode_DeptShare_${status.index}_1" border="0" src="/images/OrganTree_cross/dot_end.gif" style="width: 18px; height: 18px;">
										<span onclick="setPresentValue('결재완료문서'); Open_Func(this); setBoldText(this);" style="cursor: pointer; width: 135px;" shareUserId="${userShare.shareId }" title="결재완료문서" id="spn_DeptShare_${status.index}_1" class="node_normal shareCont">결재완료문서</span>
									</div>
								</div>
				          	</c:forEach>
				          	</div>
			          	</ul>
		          	</c:if>
		          	<c:if test="${fn:length(deptShareList) > 0 }">
			        	<h2 class="off" id="DEPTSHAREH2">
			        		<span class="sub_iconLNB tree_plus"></span>
			        		<span class="h2Title" onclick="openFolder('DEPTSHARE');"><spring:message code='ezApprovalG.apprLeft03'/></span>
			        	</h2>
						<ul class="lnbUL off" id="DEPTSHAREUL">
				          	<c:forEach var="deptShare" items="${deptShareList}" varStatus="status">				          	
								<i id="imgNode_DeptShare_${status.index}" class="sub_iconLNB tree_plus" border="0" onclick="treeicon_toggle('DeptShare_${status.index}', 'UserContTree', UserContRequestData, 'imgNode_DeptShare_${status.index}');" style="width: 18px;height: 18px;cursor: pointer;margin-left: 23px;"></i>
<%-- 								<img id="subImgNode_DeptShare_${status.index}" border="0" src="/images/OrganTree_cross/fldr.gif" style="width: 18px; height: 18px;" class="mCS_img_loaded"> --%>
								<span id="spn_DeptShare_${status.index}" class="node_normal" style="cursor: pointer; width: 135px;" title='<c:out value="${deptShare.shareName }"></c:out>'><c:out value="${deptShare.shareName }"></c:out></span>
								<div id="DeptShare_${status.index}_sub" style="display:none;">
									<c:if test="${fn:length(shareUsersItemList) > 0 }">
										<c:forEach items="${shareUsersItemList }" var="shareUsersItemListMap">
									    	<c:if test="${shareUsersItemListMap.key eq deptShare.shareId}">
									    		<c:forEach items="${shareUsersItemListMap.value}" var="item" varStatus="status2">
									    			<div class="node_div" id="DeptShare_${status.index}_${status2.index}" nodename="${item.formName}" nodelevel="1" endnode="true" value="${item.formName}" isleaf="TRUE" expanded="FALSE" style="white-space: nowrap;">
														<img border="0" class="DOT" src="/images/OrganTree/dot_end.gif" style="width: 18px; height: 18px;">
														<img id="imgNode_DeptShare_${status.index}_${status2.index}" border="0" src="/images/OrganTree_cross/dot_end.gif" style="width: 18px; height: 18px;">
														<img id="subImgNode_DeptShare_${status.index}_${status2.index}" border="0" src="/images/OrganTree_cross/dot_end.gif" style="width: 18px; height: 18px;">
														<span onclick="setPresentValue('${item.formName}'); goFormContainer('${item.formName}', '${deptShare.shareId}'); setBoldText(this);" style="cursor: pointer; width: 135px;" title="${item.formName}" id="spn_DeptShare_${status.index}_${status2.index}" class="node_normal">${item.formName}</span>
													</div>
									    		</c:forEach>
									    	</c:if>
										</c:forEach>
									</c:if>
								</div>
				          	</c:forEach>
			          	</ul>
		          	</c:if>
<%-- 		          	<h2 class="off" id="ITEMCONTH2"> --%>
<%-- 		        		<span class="sub_iconLNB tree_arrow_up"></span> --%>
<%-- 		        		<span class="h2Title" onclick="openFolder('ITEMCONT');"><spring:message code='ezApproval.t844'/></span> --%>
<%-- 		        	</h2> --%>
<%-- 					<ul class="off" id="ITEMCONTUL"> --%>
<%-- 			          	<c:forEach var="itemList" items="${itemList}" varStatus="status"> --%>
<%-- 			          	    <li><span class="sub_iconLNB tree_appr_record1"></span><span class="list_text" id="itemList${status.count - 1}"  onclick="setPresentValue('${itemList.taskName}(${itemList.keepingPeriod})');cmdOK_onclick2('${itemList.taskCode}', '${itemList.taskName}', '${itemList.taskName}(${itemList.keepingPeriod})');">${itemList.taskName}(${itemList.keepingPeriod}) </span></li> --%>
<%-- 			          	</c:forEach> --%>
<%-- 		          	</ul> --%>
			        <h2 class="off" id="personH2">
			        	<span class="sub_iconLNB tree_manage" onclick="MngUserOnclick()"></span>
			            <span class="sub_iconLNB tree_plus"></span><span class="h2Title" onclick="openFolder('person')"><spring:message code='ezApproval.t848'/></span>			            
			        </h2>
			        <ul class="lnbUL off" id="personUL">
			        	<div class="tree onlytree" id="divUserContTree"></div>
			        </ul>
		        </c:if>
		        <c:if test="${approvalFlag eq 'G'}">
		        	<h2 class="off" id="readingRecordH2" style="display:none;">
		        		<span class="sub_iconLNB tree_plus"></span><span class="h2Title" id="readingRecord" onclick="openFolder('readingRecord'), Open_Func(this)"><spring:message code='ezApprovalG.kwc001'/></span>
			        </h2>
		        	<h2 class="on" id="recordCabinetH2">
		        		<span class="sub_iconLNB tree_plus"></span><span class="h2Title" onclick="openFolder('recordCabinet')"><spring:message code='ezApprovalG.LeftMenu01'/></span>
			        </h2>
			        <ul class="lnbUL" id="recordCabinetUL">
			        	<li class="on"><span class="list_text" id="m01" onclick="Open_Func(this)"><spring:message code='ezApprovalG.t552'/></span></li>
			        	<li><span class="list_text" id="m02" onclick="Open_Func(this)"><spring:message code='ezApprovalG.t912'/></span></li>
			        </ul>
			        <c:if test="${fn:contains(userInfo.rollInfo, 'm=1') || fn:contains(userInfo.rollInfo, 'w=1') || fn:contains(userInfo.rollInfo, 'c=1')}">
				        <h2 class="off" id="manageCabinetH2" style="display:none;">
			        		<span class="sub_iconLNB tree_plus"></span><span class="h2Title" onclick="openFolder('manageCabinet')"><spring:message code='ezApprovalG.LeftMenu02'/></span>
				        </h2>
				        <ul class="lnbUL off" id="manageCabinetUL" style="display:none;">
				        	<li><span class="list_text" id="m07" onclick="Open_Func(this)"><spring:message code='ezApprovalG.t907'/></span></li>
				        	<li><span class="list_text" id="m08" onclick="Open_Func(this)"><spring:message code='ezApprovalG.t908'/></span></li>
				        	 <c:if test="${fn:contains(userInfo.rollInfo, 'm=1') || fn:contains(userInfo.rollInfo, 'c=1')}">
					        	<li><span class="list_text" id="m09" onclick="Open_Func(this)"><spring:message code='ezApprovalG.t909'/></span></li>
					        	<li><span class="list_text" id="admin_sub01" onclick="Menu_Click(this)"><spring:message code='ezApprovalG.t717'/></span></li>
					        	<li><span class="list_text" id="admin_sub02" onclick="Menu_Click(this)"><spring:message code='ezApprovalG.t1754'/></span></li>
					        	<li><span class="list_text" id="admin_sub03" onclick="Menu_Click(this)"><spring:message code='ezApprovalG.LeftMenu03'/></span></li>
					        	<li><span class="list_text" id="admin_sub04" onclick="Menu_Click(this)"><spring:message code='ezApprovalG.t520'/></span></li>
								<li>
									<span class = "list_text" id = "m15" onclick = "Open_Func(this)">
										<spring:message code = 'ezApprovalG.listOfDeletedIron' />
									</span>
								</li>
							 </c:if>
				        </ul>
			        </c:if>
			        
			        <c:if test="${fn:length(userShareList) > 0 }">
			        	<h2 class="off" id="USERSHAREH2" style="display:none;">
			        		<span class="sub_iconLNB tree_plus"></span>
			        		<span class="h2Title" onclick="openFolder('USERSHARE');"><spring:message code='ezApprovalG.apprLeft02'/></span>
			        	</h2>
						<ul class="lnbUL off" id="USERSHAREUL" style="display:none;">
							<div id="UserShare_0">
				          	<c:forEach var="userShare" items="${userShareList}" varStatus="status">				          	
<%-- 								<img id="imgNode_UserShare_${status.index}" border="0" src="/images/OrganTree_cross/plus.gif" onclick="treeicon_toggle('UserShare_${status.index}', 'UserContTree', UserContRequestData, 'imgNode_UserShare_${status.index}');" style="width: 18px;height: 18px;cursor: pointer;margin-left: 10px;"> --%>
								<i id="imgNode_UserShare_${status.index}" class="sub_iconLNB tree_plus" border="0" onclick="treeicon_toggle('UserShare_${status.index}', 'UserContTree', UserContRequestData, 'imgNode_UserShare_${status.index}');" style="width: 18px;height: 18px;cursor: pointer;margin-left: 23px;"></i>
<%-- 								<img id="subImgNode_UserShare_${status.index}" border="0" src="/images/OrganTree_cross/fldr.gif" style="width: 18px; height: 18px;" class="mCS_img_loaded"> --%>
								<span id="spn_UserShare_${status.index}" class="node_normal" onclick="treeicon_toggle('UserShare_${status.index}', 'UserContTree', UserContRequestData, 'imgNode_UserShare_${status.index}');" style="cursor: pointer; width: 135px;" title='<c:out value="${userShare.shareName }"></c:out>'><c:out value="${userShare.shareName }"></c:out></span>
								<div id="UserShare_${status.index}_sub" style="display:none;">
<%-- 					    			<div class="node_div" id="DeptShare_${status.index}_0" nodename="결재진행문서" nodelevel="1" endnode="true" value="결재진행문서" isleaf="TRUE" expanded="FALSE" style="white-space: nowrap;"> --%>
<!-- 										<img border="0" class="DOT" src="/images/OrganTree/dot_end.gif" style="width: 18px; height: 18px;"> -->
<%-- 										<img id="imgNode_DeptShare_${status.index}_0}" border="0" src="/images/OrganTree_cross/dot_end.gif" style="width: 18px; height: 18px;"> --%>
<%-- 										<img id="subImgNode_DeptShare_${status.index}_0" border="0" src="/images/OrganTree_cross/fldr.gif" style="width: 18px; height: 18px;"> --%>
<%-- 										<span onclick="setPresentValue('결재진행문서');convMain('3','','${userShare.shareId}')" style="cursor: pointer; width: 135px;" title="결재진행문서" id="spn_DeptShare_${status.index}_0" class="node_normal">결재진행문서</span> --%>
<!-- 									</div> -->
					    			<div class="node_div" id="DeptShare_${status.index}_1" nodename="결재완료문서" nodelevel="1" endnode="true" value="결재완료문서" isleaf="TRUE" expanded="FALSE" style="white-space: nowrap;">
										<img border="0" class="DOT" src="/images/OrganTree/dot_end.gif" style="width: 18px; height: 18px;">
										<img id="imgNode_DeptShare_${status.index}_1" border="0" src="/images/OrganTree_cross/dot_end.gif" style="width: 18px; height: 18px;">
										<img id="subImgNode_DeptShare_${status.index}_1" border="0" src="/images/OrganTree_cross/dot_end.gif" style="width: 18px; height: 18px;">
										<span onclick="setPresentValue('결재완료문서'); Open_Func(this); setBoldText(this);" style="cursor: pointer; width: 135px;" shareUserId="${userShare.shareId }" title="결재완료문서" id="spn_DeptShare_${status.index}_1" class="node_normal shareCont">결재완료문서</span>
									</div>
								</div>
				          	</c:forEach>
				          	</div>
			          	</ul>
		          	</c:if>
		          	<c:if test="${fn:length(deptShareList) > 0 }">
			        	<h2 class="off" id="DEPTSHAREH2" style="display:none;">
			        		<span class="sub_iconLNB tree_plus"></span>
			        		<span class="h2Title" onclick="openFolder('DEPTSHARE');"><spring:message code='ezApprovalG.apprLeft03'/></span>
			        	</h2>
						<ul class="lnbUL off" id="DEPTSHAREUL" style="display:none;">
				          	<c:forEach var="deptShare" items="${deptShareList}" varStatus="status">	
				          		<li class="on">
				          			<span class="list_text deptShare" id="${deptShare.shareId}" onclick="Open_Func(this); setBoldText(this);"><c:out value="${deptShare.shareName }"></c:out></span>
				          		</li>			          	
				          	</c:forEach>
			          	</ul>
		          	</c:if>
		        </c:if>
		        
	        <%-- 전자결재 G - 이후에 css작업 해야됨 -- %>
		        <%-- <c:if test="${approvalFlag eq 'G'}">
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
				</c:if> --%>
				<c:if test="${approvalForDoc == 'Y'}">
					<c:if test="${fn:contains(userInfo.rollInfo, 'c=1') || fn:contains(userInfo.rollInfo, 'k=1') || fn:contains(userInfo.rollInfo, 'q=1')}">
						<h2 class="off" id="adminH2" style="display:none;">
			            	<span class="sub_iconLNB tree_plus"></span><span class="h2Title" onclick="openFolder('admin')"><spring:message code='ezApprovalG.lhj13'/></span>
						</h2>
						<ul class="lnbUL off" id="adminUL" style="display:none;">
                           	<li><span class="list_text" id="approvalForDoc_sub01" onclick="Menu_Click(this)"><spring:message code='ezApprovalG.lhj14'/></span></li>
                           	<li><span class="list_text" id="approvalForDoc_sub02" onclick="Menu_Click(this)"><spring:message code='ezApprovalG.lhj15'/></span></li>
						</ul>
					</c:if>
				</c:if>
				<%-- <c:if test="${useOpenGov == 'YES'}">
					<c:if test="${fn:contains(userInfo.rollInfo, 'c=1') || fn:contains(userInfo.rollInfo, 'k=1') || fn:contains(userInfo.rollInfo, 'q=1')}">
						<h2 class="off" id="openGovH2">
							<span class="sub_iconLNB tree_plus"></span><span class="h2Title" id="openGov" onClick="Menu_Click(this)"><spring:message code='ezApprovalG.LeftMenu04'/></span>
						</h2>
					</c:if>
				</c:if>--%>
			</div>
	    </div>
		<%-- <span  id="presentcell" style="display:none"></span>
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
					<li onclick="setPresentValue('<spring:message code='ezApprovalG.bhs03'/>');convMain('11','')"><span style="width:100%;display:inline-block;" id="APPROVAL11"><img src="/images/ImgIcon/icon_approval.gif" width="16" height="16" class="icon"><spring:message code='ezApprovalG.bhs03'/><span id=count11></span></span></li>
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
		         <ul id="iconul">
				    <li><span style="width:100%; display:inline-block;" id="APPROVAL99" onClick="setPresentValue('<spring:message code='ezApprovalG.t10011'/>');convMain('99','')"><img src="/images/ImgIcon/icon_displaypaper.gif" width="16" height="16" class="icon"><spring:message code='ezApprovalG.t10011'/><span id="count99"></span></li>
				    <li><span style="width:100%; display:inline-block;" id="APPROVAL10" onClick="setPresentValue('<spring:message code='ezApprovalG.t1787'/>');convMain('10','')"><spring:message code='ezApprovalG.t1787'/><span id="count10"></span></li>
				</ul>
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
				<c:if test="${fn:indexOf(optGamsabu, userInfo.deptID) > -1 && approvalFlag == 'S'}">
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
			<c:if test="${fn:contains(userInfo.rollInfo, 'c=1') || fn:contains(userInfo.rollInfo, 'k=1') || fn:contains(userInfo.rollInfo, 'q=1')}">
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
		</script> --%>
	</body>
</html>