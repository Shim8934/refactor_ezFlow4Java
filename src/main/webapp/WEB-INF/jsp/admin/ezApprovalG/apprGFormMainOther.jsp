<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><c:out value = '${title}' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezForm_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Kaoni_ActiveX.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/control_Cross/ListView_list.js')}" ></script>
	    <c:choose>
	    	<c:when test="${approvalFlag eq 'G'}">
		    	<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeView.js')}"></script>
				<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeViewCtrl_Cross.js')}" ></script>
	    	</c:when>	    	<c:otherwise>
			    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/control_Cross/TreeView.js')}" ></script>
			    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeViewCtrlS_Cross.js')}"></script>
	    	</c:otherwise>
	    </c:choose>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/admin/FormMain_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/admin/AutoLineRuleMaker.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/admin/AutoLineRuleMaker_AprLine.js')}"></script>
				
		<script type="text/javascript">
			var linealt1 = "<spring:message code='ezApprovalG.t1742'/>";
			var linealt2 = "<spring:message code='ezApprovalG.t228'/>";
			var linealt3 = "<spring:message code='ezApprovalG.t226'/>";
			var linealt4 = "<spring:message code='ezApprovalG.t227'/>";
			var companyID = "<c:out value='${companyID}'/>";
		    var contID = "<c:out value='${contID}'/>";
		    var formID = "<c:out value='${formID}'/>";
		    var isInsUp = "<c:out value='${tCheck}'/>";
		    var TreeIdx;
		    var treeNode;
		    var listview;
		    var TreeIdx;
		    var g_toggleFlag = false;
		    var formURL = "";
		    var beforeHTML = "";
		    var AutoRule_Listview;
		    var rtnVal = "";    
		    var AprTypeXML = createXmlDom();
		    var strResx436 = "<spring:message code='ezApprovalG.t445'/>";
		    var pDocType = "";
		    var thisSelGUID = ""; 
		    var FormProcSpelling = "<c:out value='${formProcSpelling}'/>";
		    var htmlData = "";
		    var ConnData = "";
		    var WorkData = "";
		    var useEditor = "<c:out value='${useEditor}'/>";
		    var approvalFlag = "<c:out value = '${approvalFlag}' />";
		    var realPath = "<c:out value = '${realPath}' />";
		    var ext = "<c:out value='${ext}'/>";
		    var locale = "<c:out value = '${locale}' />";
		    // FormBuilder
		    var useReform = "${useReform}" === "true";
		    var reformUrl = "${reformUrl}";
		    // FormBuilder end
		    <%-- 2021-01-21 심기영 오피스결재 여부 변수 추가 --%>
		    var useOfficeApproval = "<c:out value = '${useOfficeApproval}'/>";
		    var useOpenGov = "<c:out value = '${useOpenGov}'/>";
		    var openGovFlag = "<c:out value = '${openGovFlag}'/>";
		    
		    var usePassAprLine = "<c:out value = '${usePassAprLine}'/>";
			var passAprLineFlag = "<c:out value='${passAprLineFlag}'/>";
			var receptGubunYN = "<c:out value='${receptGubunYN}'/>";
			
			/* 2022-01-07 홍승비 - 일괄기안 옵션 추가 */
			var useDraftAll = "<c:out value='${useDraftAll}'/>";
			
			var useReceiveInfoName = "<c:out value='${useReceiveInfoName}'/>";
		
		    if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
		        window.onblur = function () {
		            window.focus();
		        }
		    }
		
		    document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
		            return false;
		        else
		            return true;
		    };
		    
// 		    var onloadflag = false;
		    $(document).ready(function() {
// 			window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        
		        if (approvalFlag == 'S') {
					$(".approvalG").hide();
					$(".approvalS").show();
				} else {
					$(".approvalS").hide();
					$(".approvalG").show();
				}
				
				if (approvalFlag === "G" && receptGubunYN === "Y") {
					if (document.querySelector("#selFormKind").value === "001") {
						document.querySelector("#selSihangType").style.display = "";
					}
				}
		        document.getElementById("1tab1").setAttribute("class", "tabon");
		        Tab1_SelectID = "1tab1";
		        ChangeTab(document.getElementById("1tab1"));

		        getDeptFullTree("<c:out value='${companyID}'/>");

		        getFormRecv();
		        AprTypeXML = loadXMLString(bodyForm.hidAprTypeXml.value);
		        pDocType = document.getElementsByName("selDocType")[0].options[document.getElementsByName("selDocType")[0].selectedIndex].value;
		        MakeListXML(pDocType);
		        
		        if (approvalFlag == "G") {
			        TreeViewinitialize("", companyID, "extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName", "<c:out value='${serverName}'/>", "aprG", null, true);
		        } else {
			        TreeViewinitialize("", companyID+"/other", "extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName", "<c:out value='${serverName}'/>", true);
		        }
		        $("#tr_setAutoItemCode").hide();
		        
		        if (formID != "") {
		            get_FormInfo();
		            if (!(useEditor == "HWP" || useEditor == "WebHWP")) {
		                var tempXML = createXmlDom();
// 		                var XmlBodyATT = createXmlDom();
		                var XmlBodyDATA = createXmlDom();
		                var tempStr = "";
		                
		                tempStr = ConvertMHTtoHTML(formURL);
		
	                    tempXML.async = "false";
	                    tempXML = loadXMLString(tempStr);
		
// 		                XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
		                XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
		
		                var Doc_ContentHtml = document.createElement("DIV");
		                Doc_ContentHtml.innerHTML = getNodeText(XmlBodyDATA);
		
		                for (var i = 0; i < GetChildNodes(Doc_ContentHtml).length ; i++) {
		                    var TagID = GetChildNodes(Doc_ContentHtml)[i].id;
		                    if (TagID != "" && TagID != undefined)
		                        TagID = TagID.toUpperCase();
		
		                    /* 2020-07-17 홍승비 - 저장한 연동정보의 개행과 탭이 제대로 표출되지 않는 오류 수정 */
		                    if (TagID == "CONN") {
		                        ConnData = Doc_ContentHtml.children[i].innerHTML;
								
		                        if (ConnData) {
		                            setNodeText(txt_OpinionContent, ConnData.replace(/<[/]?connroot>/g, "").replace(/conn><conn/g, "conn>\n<conn"));
		                        }
		                    }
		                    else if (TagID == "WORKFLOW") {
		                        WorkData = Doc_ContentHtml.children[i].innerHTML;
		                        if (WorkData) {
									WorkData = Doc_ContentHtml.children[i];
		                            var VALIDATIONS = GetElementsByTagName(WorkData, "validations")[0].innerHTML;
		                            setNodeText(txt_OpinionContent1, VALIDATIONS.replace(/><VALIDATION/g, ">\n<VALIDATION"));
		
		                            var STATUS = GetElementsByTagName(WorkData, "aprlines")[0].innerHTML;
		                            setNodeText(txt_OpinionContent2, STATUS.replace(/><APRLINE/g, ">\n<APRLINE"));
		                        }
		                    }
		                    else if (TagID == "BODYCONTENT") {
		                        htmlData += GetChildNodes(Doc_ContentHtml)[i].outerHTML;
		                    }
		                    else if (TagID == "") {
		                        htmlData += GetChildNodes(Doc_ContentHtml)[i].outerHTML;
		                    }
		                }
		            } else if(useEditor == "HWP"){
						setTimeout(function() {
							Editor_Complete();
						}, 200);
		            }
		        } else {
		        	// 웹 한글 기안기 최초 작성시 한글 파일 추가 기능으로 사용함
		        	if(useEditor == "WebHWP") {
		        		document.getElementById("ApvForm_sub2").style.display = "none";
		        		document.getElementById("ApvForm_sub3").style.display = "none";
		        		document.getElementById("ApvForm_sub4").style.display = "none";
		        	}
		        }
		        
		        /* 2021-12-16 홍승비 - 양식타입 별 고정수신자 탭 표출 제어 (수신문, 시행문에서만 표출) */
		         var selFormTypeVal = $("#selFormKind").val();
		         changeSelFormKind(selFormTypeVal);
		        
	        	// IE scroll enable
	        	if (document.body.scroll === "") {
	        		document.body.scroll = "yes";
	        	}
		    });
		
		        
		    window.onload = function () {
		    	<c:if test="${useEditor eq 'WebHWP'}">
		            var mHeight = document.documentElement.clientHeight - 200 - document.getElementById("message").offsetTop + "px";
		            message.Resize(mHeight);            
		        </c:if>
		    }
		        
		    function Editor_Complete() {
	            if (formURL != "") {
	                if (useEditor == "HWP") {
	                    message.HWP_LoadFile(formURL);
	                    
	                    if (message.HWP_GetDocumentElement() != "") {
	                        var connXML= message.HWP_GetDocumentElement().replace(/&amp;/gi, "&").replace(/&lt;/gi, "<").replace(/&gt;/gi, ">");
	                        
	                        if (connXML == "") {
	                            return;
	                        }
	                        
	                        g_XmlDoc = loadXMLString(connXML);
	                        
	                        for (i = 0; i < g_XmlDoc.documentElement.childNodes.length; i++) {
	                            if (i == 0) {
	                                setNodeText(txt_OpinionContent, getXmlString(g_XmlDoc.documentElement.childNodes[i]));
	                            } else {
	                                setNodeText(txt_OpinionContent, getNodeText(txt_OpinionContent) + "\n" + getXmlString(g_XmlDoc.documentElement.childNodes[i]));
	                            }
	                        }
	                    }
	                } else if (useEditor == "WebHWP") {
	                	var URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(formURL);
	                	message.Open(URL, "", "", function (res) { FieldsAvailable(res.result) }, null);
	                } else {
	                    document.getElementById("ApvForm_sub4").style.display = "";
	                    //위임전결
// 		                    document.getElementById("ApvForm_sub6").style.display = "";
	                    document.getElementById("rootTD").style.display = "";
	                    message.SetEditorContent(htmlData);
	                }
	            } else {
	                if (useEditor != "HWP" && useEditor != "WebHWP") {
	                    document.getElementById("ApvForm_sub4").style.display = "";
	                    //위임전결
// 		                    document.getElementById("ApvForm_sub6").style.display = "";
	                    document.getElementById("rootTD").style.display = "";
	                    message.SetEditorContent('');
	                } else {
// 		                    document.getElementById("btn_OpinionSave").style.display = "";
	                }
	            }
		        
		        add_doc_maker();
		        
		        if (locale != "ko") {
		        	document.getElementById("ApvForm_sub3").style.display = "none";
		        	document.getElementById("ApvForm_sub4").style.display = "none";
		        }
		    }
		    
		    function FieldsAvailable(isTrue) {
		    	try {                
		            if (isTrue) {
						message.EditMode(1);	// 0:읽기 전용, 1:일반 편집모드, 2:양식 모드, 16:배포용 문서
						message.SetViewProperties(2, 100);

						var docElemInfo = message.WHWP_GetDocumentElement();
						txt_OpinionContent.value = docElemInfo[0];
						txt_OpinionContent1.value = docElemInfo[1];
						txt_OpinionContent2.value = docElemInfo[2];
		                //  if (document.getElementById("setConnFlag").checked) {
		                //      //ConnInfoXmlRead();
		                //  }
		            }
		        } catch (e) {
		            alert("FieldsAvailable() :: " + e);
		        }
		    }
		
		    function Attribute_Write(value) {
		        setNodeText(BottonTDValue[1],value);
		        setNodeText(BottonTDValue[2],""); 
		        document.getElementById("EditInput").value = "";
		    }
		    
		    function get_FormInfo() {
		        $.ajax({
		        	type : "POST",
		        	dataType : "json",
		        	url : "/admin/ezApprovalG/getFormInfo.do",
		        	async : false,
		        	data : {formID : formID,
		        			companyID : companyID
		        	},
		        	success : function(result) {
						if (result != "") {
		        			tbFormName.value = result.vo.formName;
		        			tbFormName2.value = result.vo.formName2;
		        			tbDescript.value = result.vo.formDescription;
		        			selFormKind.value = result.vo.formDocType;
		        			formURL = encodeURI(result.vo.formFileLocation);
		        			
		        			if (result.vo.formConnFlag == "Y") {
			                    document.getElementById("setConnFlag").checked = true;
			                    $("input:checkbox[id='setPassAprLineFlag']").attr("disabled", true);
			                    $("input:checkbox[id='setDraftAllFlag']").attr("disabled", true);
			                }
			                
		        			if (result.vo.officeFlag == "Y") {
		        				document.getElementById("officeFlag").checked = true;
		        			}
		        			
			                if (approvalFlag == 'S') {
				                if (result.vo.useFlag == "Y") {
				                    setAutoItemCode.checked = true;
				                    $('#tr_setAutoItemCode').show();
				                    document.getElementById("isPublic").value = result.vo.isPublic;
				                    document.getElementById("tbItemCode").value = result.vo.itemCode;
				                    document.getElementById("tbItemName").value = result.vo.itemName;
				                    document.getElementById("tbItemName2").value = result.vo.itemName2;
				                    document.getElementById("keepperiod").value = result.vo.keepPeriodCode;
				                    document.getElementById("securitylevel").value = result.vo.securityLevel;
			                	}
			                } else {
								if (useOpenGov == "YES" && result.vo.openGovFlag == "Y") {
									document.getElementById("setOpenGovFlag").checked = true;	
								}
								
							}
                            /* 2022-01-07 홍승비 - 전자결재G 일괄기안 옵션 추가 2024-07-04 S 버전도 사용 */
                            if (result.vo.formDraftAllFlag == "Y") {
                                document.getElementById("setDraftAllFlag").checked = true;
                                $("input:checkbox[id='setConnFlag']").attr("disabled", true);
                                $("input:checkbox[id='setPassAprLineFlag']").attr("disabled", true);
                            }

							var formXslt = result.vo.formXslt;
							if(formXslt) {
								formXslt = ConvertEntityReferenceToChar(formXslt);

								document.querySelector("#setBodyXslt").checked = true;
								document.querySelector("#BodyXslt").value = formXslt;
							}
							
			                /* 2020-05-14 홍승비 - 양식세부옵션 null 체크 추가 */
							//양식세부옵션
							if (result.vo.aprOption != null) {
								var OptArr = result.vo.aprOption.split(",");
								for (var i = 0; i < OptArr.length; i++) {
									if (document.getElementById(OptArr[i]) != null) {
										document.getElementById(OptArr[i]).checked = true;
									}
								}
							}

							if (result.vo.sihangType) {
								document.querySelector("#selSihangType").value = result.vo.sihangType;
							} else {
								document.querySelector("#selSihangType").value = "inner";
							}
							if (approvalFlag === "G" && receptGubunYN === "Y") {
								if (document.querySelector("#selFormKind").value === "001") {
									document.querySelector("#selSihangType").style.display = "";
								} else {
									document.querySelector("#selSihangType").style.display = "none";
								}
							}
			            }
						
						if (usePassAprLine == "YES" && result.vo.passAprLineFlag == "Y") {
							document.getElementById("setPassAprLineFlag").checked = true;
        					$("input:checkbox[id='setConnFlag']").attr("disabled", true);
        					$("input:checkbox[id='setDraftAllFlag']").attr("disabled", true);
						}
						
						<c:if test="${isReform}">
							document.getElementById("reform-checkbox").checked = true;
							onReformCheckboxClickEvent();
						</c:if>
		        	}
		        });
		    }
		
		    function SaveFormInfo_after(text) {
		        try {
		            var resultXML = createXmlDom();
		            resultXML = loadXMLString(text);
		
		            var result = getNodeText(SelectNodes(resultXML, "DATA")[0]);
		            if (result == "OK") {
		                alert("<spring:message code='ezApprovalG.t1663'/>");
		            }
		            else {
		                alert("<spring:message code='ezApprovalG.t1669'/>");
		            }
		
		            try {
		            	window.close();
		                window.opener.GetFormInfo(contID, "000", "", "");
		            }
		            catch (ee) {
		            	alert("SaveFormInfo_after error :: " + ee);
		            }
		        }
		        catch (e) {
		            alert(e.message);
		        }
		    }
		
		    function FormMaker_RtnMht() {
		        return document.getElementById("ApvForm_div2_ifrm").contentWindow.RtnFormMht();
		    }
		
		    function getDeptFullTree(deptid) {
		        try {
		            Tree_setconfig();
		            var xmlpara = createXmlDom();
		            var objNode;
		            createNodeInsert(xmlpara, objNode, "DATA");
		            createNodeAndInsertText(xmlpara, objNode, "DEPTID", deptid);
		            createNodeAndInsertText(xmlpara, objNode, "TOPID", "<c:out value='${companyID}'/>");
		            createNodeAndInsertText(xmlpara, objNode, "PROP", "extensionAttribute2;displayName1;displayName2");
		            createNodeAndInsertText(xmlpara, objNode, "DISPLAYTRASHDEPT", "true");
		            
		            var xmlHTTP = createXMLHttpRequest();
		            xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
		            xmlHTTP.send(xmlpara);
		            xmlpara = loadXMLString(xmlHTTP.responseText);
		            
		            var treeView = new TreeView();
		            treeView.SetID("UserContTree");
		            treeView.SetUseAgency(true);
		            treeView.SetRequestData("RequestData");
		            treeView.SetNodeClick("TreeViewNodeClick");
		            treeView.DataSource(xmlpara);
		            treeView.DataBind("TreeView");
		
		            treeView.SetID("LineUserTree");
		            treeView.SetUseAgency(true);
		            treeView.SetRequestData("RequestData");
		            treeView.SetNodeClick("TreeView2NodeClick");
		            treeView.DataSource(xmlpara);
		            treeView.DataBind("divLineUserTree");
		        } catch (e) {
		        	alert(e.description);
		        }
		    }
		
		    function Tree_setconfig() {
		    	var treeView = new TreeView();
		    	treeView.SetConfig(loadXMLFile("/xml/organtree_config.xml"));
		    }
		
		    function RequestData(pNodeID, pTreeID) {
		        TreeIdx = pNodeID;
		        treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		
		        var xmlHTTP = createXMLHttpRequest();
		        var xmlpara = createXmlDom();
		        var objNode;
		        createNodeInsert(xmlpara, objNode, "DATA");
		        createNodeAndInsertText(xmlpara, objNode, "DEPTID", treeNode.GetNodeData("CN"));
		        createNodeAndInsertText(xmlpara, objNode, "PROP", "extensionAttribute2;displayName1;displayName2");
		
		        xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
		        xmlHTTP.send(xmlpara);
		
		        var treeView = new TreeView();
		        treeView.LoadFromID(pTreeID);
		        treeView.AppendChildNodes(loadXMLString(xmlHTTP.responseText).documentElement, pNodeID)
		    }
		    
		    function RequestDataG(pNodeID, pTreeID) {
		        TreeIdx = pNodeID;
		        treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		
		        var xmlHTTP = createXMLHttpRequest();
		        var xmlpara = createXmlDom();
		        var objNode;
		        createNodeInsert(xmlpara, objNode, "DATA");
		        createNodeAndInsertText(xmlpara, objNode, "DEPTID", treeNode.GetNodeData("CN"));
		        createNodeAndInsertText(xmlpara, objNode, "PROP", "extensionAttribute2;displayName1;displayName2");
		
		        xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
		        xmlHTTP.send(xmlpara);
		
		        var treeView = new TreeView();
		        treeView.LoadFromID(pTreeID);
		        treeView.AppendChildNodes(loadXMLString(xmlHTTP.responseText).documentElement, pNodeID)
		    }
		
		    function TreeView2NodeClick(pNodeID, pNodeNM) {
		        TreeIdx = pNodeID;
		        treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		        displayUserList2(treeNode.GetNodeData("CN"));
		    }
		
		    function TreeViewNodeClick(pNodeID, pNodeNM) {
		        TreeIdx = pNodeID;
		        nodeIdx = pNodeID;
		        treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		        displayUserList(treeNode.GetNodeData("CN"));
		    }
		
		    function getFormRecv() {
				var result = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezApprovalG/getFormRecvAdmin.do",
		    		data : {
		    			formID : formID,
		    			companyID : companyID
		    		},
		    		success: function(text){
		    			result = text;
		    		}
		    	});
		    	
		        var xmlpara = createXmlDom();
		        xmlpara = loadXMLString(result);
		
		        listview = new ListView();
		        listview.SetID("lvtForm");
		        listview.SetMulSelectable(true);
		        listview.SetRowOnClick("lvtDeptSelect_SelChange");
		        listview.SetRowOnDblClick("lvtDeptSelect_rowdblclick");
		        listview.DataSource(xmlpara);
		        listview.DataBind("divlvtForm");        
		    }
		
		    function insertCont_onclick() {
		        var DuplicateFlag = DuplicateAprDeptCheck(treeNode.GetNodeData("CN"));
		        
		        if (GetEntryInfo(treeNode.GetNodeData("CN")) == "N") {
                    var pAlertContent = strLang1105;
                    OpenAlertUI(pAlertContent);
                    return;
                }
		        //고정수신처 부서 등록 시, 수발신 담당자 유/무 체크
		        if (!isReceiverChk(treeNode.GetNodeData("CN"))) {
		            var pAlertContent = strLang1101 + strLang1102;
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		        
		        if (DuplicateFlag) {
		            AprLineAddDept(treeNode.GetNodeData("VALUE"), treeNode.GetNodeData("CN"), "D");
		        } else {
		            var pAlertContent = "<spring:message code='ezApproval.t205'/><br>  <spring:message code='ezApproval.t206'/>";
		            OpenAlertUI(pAlertContent);
		        }
		    }
		
		    function insertAllCont_onclick() {
		    	var deptid = $("#"+TreeIdx).attr("cn");
		    	if (GetEntryInfo(deptid) == "N") {
		    		var pAlertContent = strLang1105;
		    		OpenAlertUI(pAlertContent);
		    		return;
		    	}		    	
		    	
		    	if (isReceiverChk(deptid)) {
                    var pAlertContent = "<spring:message code='ezApprovalG.t1361'/><spring:message code='ezApprovalG.t1362'/>";
                    var Ans = OpenInformationUI(pAlertContent, insertAllCont_complete);
		        
		        } else {
		            var pAlertContent = strLang1101+strLang1102;
                    var Ans = OpenInformationUI(pAlertContent, insertAllCont_complete);
		        }
		    }
		    
		    function insertAllCont_complete(ret) {
		    	if (!ret) {
		    		DivPopUpHidden();
		    		return;
		    	}
		    	
		    	chkAllDept(treeNode.GetNodeData("CN"), treeNode.GetNodeData("VALUE"));
		    	DivPopUpHidden();
		    }
		    
		    var nodeIdx;
		    function chkAllDept(aDeptID, aDeptName) {
		        try {
		            if (nodeIdx != "") {
		                if (isExistDept(true)) {
                            var pAlertContent = strLang244 + "</br>" + strLang245;
                            OpenAlertUI(pAlertContent);
                            return;
                        }
		            
                        var treeNode = new TreeNode();
                        treeNode.LoadFromID(nodeIdx);
                    
                        var DuplicateFlag = DuplicateAprDeptCheck(aDeptID);
                        if (DuplicateFlag && isReceiverChk(aDeptID))
                            AprLineAddDept(aDeptName, aDeptID, "D");
            
                        var xmlHTTP = createXMLHttpRequest();
                        var xmlpara = createXmlDom();
            
                        var objNode;
                        createNodeInsert(xmlpara, objNode, "DATA");
                        createNodeAndInsertText(xmlpara, objNode, "DEPTID", aDeptID);
                        createNodeAndInsertText(xmlpara, objNode, "PROP", "extensionAttribute2;displayName1;displayName2");
            
                        xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
                        xmlHTTP.send(xmlpara);
            
                        var xmlNodes = createXmlDom();
                        xmlNodes = loadXMLString(xmlHTTP.responseText);
            
                        var objNodes = SelectNodes(xmlNodes, "NODES/NODE");
                        if (objNodes.length > 0) {
                            for (var i = 0; i < objNodes.length; i++) {
                                chkAllDept(objNodes[i].getElementsByTagName("CN")[0].childNodes[0].nodeValue, objNodes[i].getElementsByTagName("VALUE")[0].childNodes[0].nodeValue);
                            }
                        }
		            }
		            return;
		        }
		        catch (e) { alert(e.description); }
		    }
		
		    function DuplicateAprDeptCheck(DeptID) {
		        var AprDeptList = listview.GetDataRows();
		        var deptID;
		        var i;
		
		        for (i = 0 ; i < listview.GetRowCount() ; i++) {
		            deptID = GetAttribute(listview.GetDataRows()[i], "DATA1");
		
		            if (deptID == DeptID) {
		                return false;
		                break;
		            }
		        }
		        return true;
		    }
		    
		    function isExistDept(ExtFlag) {
                var listview = new ListView();
                listview.LoadFromID("lvtForm");
                var CurSelRow = listview.GetDataRows();
                var rtnVal = false;
                for (i = 0; i < CurSelRow.length; i++) {
                    if (ExtFlag) {
                        if (GetAttribute(CurSelRow[0], "DATA3") == "Y")
                            rtnVal = true;
                    }
                    else {
                        if (GetAttribute(CurSelRow[0], "DATA3") == "N")
                            rtnVal = true;
                    }
            
                    if (GetAttribute(CurSelRow[0], "DATA1") == "Address1") {
                        rtnVal = true;
                    }
                }
                return rtnVal;
            }
		
		    function AprLineAddDept(TNAME, TID, TYPE) {
		        var Resultxml = createXmlDom();
		        
		        if (approvalFlag == 'S') {
		        	Resultxml = loadXMLString("<LISTVIEWDATA><ROWS><ROW><CELL><VALUE></VALUE><DATA1></DATA1><DATA2></DATA2></CELL><CELL><VALUE></VALUE></CELL></ROW></ROWS></LISTVIEWDATA>");
		        } else {
		        	Resultxml = loadXMLString("<LISTVIEWDATA><ROWS><ROW><CELL><VALUE></VALUE><DATA1></DATA1></CELL></ROW></ROWS></LISTVIEWDATA>");
		        }
		        
		        //2015-05-08 추가 - KSK
                if (GetEntryInfo(TID) == "N") {
                    return;
                }
        
                if (!isgetUser(TID)) {
                    return;
                }
        
                if (!isReceiverChk(TID)) {
                    return;
                }
		        
		        var objNodes = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW/CELL");
		        //setNodeText(GetChildNodes(objNodes[0])[0], TNAME); //연본
		        
                var upperDeptName = getParentDeptNameForDB(TID);
                if (useReceiveInfoName == '1') {
                    //현재부서명 + 장
                    setNodeText(GetChildNodes(objNodes[0])[0], TNAME + strLang93);
                } else if (useReceiveInfoName == '2') {
                    // 상위부서명(현재부서명 + 장)

                    if (!upperDeptName || TID === companyID) { // 회사
                        reName = TNAME + strLang93
                    } else { // 부서
                        reName = upperDeptName + "(" + TNAME + strLang93 + ")";
                    }
                    setNodeText(GetChildNodes(objNodes[0])[0], reName);
                } else {
                    //default
                    setNodeText(GetChildNodes(objNodes[0])[0], TNAME);
                }
		        
		        setNodeText(GetChildNodes(objNodes[0])[1], TID);
		        
		        if (approvalFlag == 'S') {
		        	if (TYPE == "D") {
			            setNodeText(GetChildNodes(objNodes[0])[2], "");
			            setNodeText(GetChildNodes(objNodes[1])[0], "");
			        } else {
			            var pUserList = new ListView();
			            pUserList.LoadFromID("lvUserList");
			
			            var selnode = pUserList.GetSelectedRows();
			            setNodeText(GetChildNodes(objNodes[0])[2], GetAttribute(selnode[0], "DATA2"));
			            setNodeText(GetChildNodes(objNodes[1])[0], GetAttribute(selnode[0], "DATA4"));
			        }
		        }

		        var lvtFormView = new ListView();
		        lvtFormView.LoadFromID("lvtForm");

		        var InitTr = lvtFormView.GetDataRows();
		        var length = InitTr.length;
		        var noitem = false;
		        if (listview.GetRowCount() == 1) {
		            if (InitTr[0].id.indexOf("_TR_noItems") > -1) {
		                lvtFormView.DeleteRow('lvtForm_TR_noItems');
		                length = 0;
		                noitem = true;
		            }
		        }

		        var MaxID = 0;

		        if (noitem) {
		            MaxID = 0;
		        } else {
		            for (var j = 0; j < length; j++) {
		                var curnum = Number(lvtFormView.GetSelectedRowID(j).substring(lvtFormView.GetSelectedRowID(j).lastIndexOf('_') + 1), lvtFormView.GetSelectedRowID(j).length);
		                if (MaxID < curnum) {
		                    MaxID = curnum;
		                }
		            }
		        }
		        MaxID += 1;

		        var objTr = lvtFormView.AddRow(length);
		        SetAttribute(objTr, "id", "lvtForm" + "_TR_" + MaxID);
		        lvtFormView.AddDataRow(objTr, GetElementsByTagName(Resultxml.documentElement, "ROW")[0]);
		        lvtFormView.SetSelectFlag(false);
		        lvtFormView = null;
		    }
		
		    function deleteCont_onclick() {
		        var lvtFormView = new ListView();
		        lvtFormView.LoadFromID("lvtForm");
		        var selRow = lvtFormView.GetSelectedRows();
		        if (selRow.length > 0) {
		            for (i = 0; i < selRow.length; i++) {
		                lvtFormView.DeleteRow(GetAttribute(selRow[i], "id"));
		            }
		        }
		        
		        if (lvtFormView.GetDataRows().length <= 0) {
		        	var objTr = document.createElement("TR");
		        	objTr.setAttribute("id", "lvtForm_TR_noItems");
		        		
		        	var oText = document.createTextNode(strLang944);
		        	var objTd = document.createElement("TD");
		        	objTd.align = "center";
		        	
		        	var colCount = document.getElementById("lvtForm").getElementsByTagName("th").length;
		        	objTd.setAttribute("colSpan", colCount);
		        	objTd.appendChild(oText);
		        	objTr.appendChild(objTd);
		        	
		        	document.getElementById("lvtForm").appendChild(objTr);
		        }
		        
		        lvtFormView = null;
		    }
		
		    function deleteAllCont_onclick() {
		    	var lvtFormView = new ListView();
		        lvtFormView.LoadFromID("lvtForm");
		        
		        var selRow = lvtFormView.GetRowCount();
		        if (selRow > 0 && lvtFormView.GetDataRows()[0].id != "lvtForm_TR_noItems") {
		            while (true) {
		                if (listview.GetRowCount() < 1)
		                    break;
		
		                listview.DeleteRow(listview.GetSelectedRowID(0));
		            }
		        }
		        
		        if (lvtFormView.GetDataRows().length <= 0) {
		        	var objTr = document.createElement("TR");
		        	objTr.setAttribute("id", "lvtForm_TR_noItems");
		        		
		        	var oText = document.createTextNode(strLang944);
		        	var objTd = document.createElement("TD");
		        	objTd.align = "center";
		        	
		        	var colCount = document.getElementById("lvtForm").getElementsByTagName("th").length;
		        	objTd.setAttribute("colSpan", colCount);
		        	objTd.appendChild(oText);
		        	objTr.appendChild(objTd);
		        	
		        	document.getElementById("lvtForm").appendChild(objTr);
		        }
		    }
		
		    function lvtDeptSelect_SelChange() {
		
		    }
		
		    function lvtDeptSelect_rowdblclick() {
		        deleteCont_onclick();
		    }
		
		    function moveUp_onclick() {
		        listview.RowMoveUp();
		    }
		
		    function moveDown_onclick() {
		        listview.RowMoveDown();
		    }
		
		    function idPropertyBtn_onclick() {
		        add_doc_maker();
		    }
		
		    function idSetField_onclick() {
		    	g_toggleFlag = !g_toggleFlag
		    	
		        message.View_CellProperty(g_toggleFlag);
		    }
		
		    var FormConnInfo_dialogarguments = new Array();
		    function btn_FormConnInfo_onclick() {
		        FormConnInfo_dialogarguments[0] = "";
		        FormConnInfo_dialogarguments[1] = FormConnInfo_onclick_Complete;
		        var url = "/admin/ezApprovalG/formConnInfo.do?companyID=" + encodeURIComponent(companyID);
		        GetOpenWindow(url, "FormConnInfo", 440, 500, "NO");
		    }
		
		    function FormConnInfo_onclick_Complete(retVal) {
		        if (retVal != "cancel") {
		            if (txt_OpinionContent.value == "") {
		                txt_OpinionContent.value = retVal;
		            } else {
		                txt_OpinionContent.value = txt_OpinionContent.value + "\n" + retVal;
		            }
		        }
		    }
		
		    function viewAutoItemCode() {
		        if (setAutoItemCode.checked) {
		            $("#tr_setAutoItemCode").show();
		            btnItemCode_onclick();
		        }
		        else {
		            $("#tr_setAutoItemCode").hide();
		            DeleteItemCode();
		        }
		    }
		
		    var itemcode_dialogArgument = new Array();
		    function btnItemCode_onclick() {
		
		        itemcode_dialogArgument[0] = "";
		        itemcode_dialogArgument[1] = btnItemCode_Complete;
		        var url = "/admin/ezApprovalG/apprGDocNumUI.do";
		        GetOpenWindow(url, "docnumui_Cross", 795, 370, "NO");
		    }
		
		    function btnItemCode_Complete(retVal) {
		        if (retVal[0] != "cancel") {
		            document.getElementById("tbItemCode").value = retVal[0];
		            document.getElementById("tbItemName").value = retVal[1];
		            document.getElementById("keepperiod").value = retVal[2];
		            document.getElementById("securitylevel").value = retVal[3];
		            document.getElementById("isPublic").value = retVal[4];
		            document.getElementById("tbItemName2").value = retVal[6];
		            document.getElementById("setAutoItemCode").checked = true;
		        }
		        else {
		            if (document.getElementById("tbItemCode").value == "")
		                document.getElementById("setAutoItemCode").checked = false;
		        }
		    }
		
		    function DeleteItemCode() {
		        document.getElementById("tbItemCode").value = "";
		        document.getElementById("tbItemName").value = "";
		        document.getElementById("tbItemName2").value = "";
		        document.getElementById("securitylevel").selectedIndex = 0;
		        document.getElementById("keepperiod").selectedIndex = 0;
		        document.getElementById("isPublic").selectedIndex = 0;
		        document.getElementById("setAutoItemCode").checked = false;
		    }
		
		    var xmlhttpUserlist;
		    function displayUserList(pDeptID) {
		    	var result = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezOrgan/getDeptMemberList.do",
		    		data : {
		    				deptID   : pDeptID, 
		    				cell 	 : "displayName;description;title;telephonenumber",
		    				prop     : "department;displayName;description;title",
		    				type 	 : "user"
		    				},
		    		success: function(result){
		    			var retXml = createXmlDom();
		    			
			            if (document.getElementById("UserList").innerHTML != "")
			                document.getElementById("UserList").innerHTML = "";
			
			            var headerData = createXmlDom();
			            headerData = loadXMLString(userlist_h.innerHTML.toUpperCase());
			            
			            if (result != "") {
			                var xmlRtn = loadXMLString(result).documentElement.getElementsByTagName("ROWS")[0];
			                headerData.documentElement.appendChild(xmlRtn);
			            }
			            
			            var pUserList = new ListView();
			            pUserList.SetID("lvUserList");
			            pUserList.SetRowOnClick("list_onSel_Click");
			            pUserList.SetRowOnDblClick("list_onSel_DBclick");
			            pUserList.SetSelectFlag(false);
			            pUserList.SetHeightFree(true);
			            pUserList.DataSource(headerData);
			            pUserList.DataBind("UserList");
			
			            var userRows = pUserList.GetDataRows();
			            if (userRows.length <= 0) {
			                OpenAlertUI(linealt1);
			            }
		    		}
		    	});
		    }
		
		    function displayUserList2(pDeptID) {
				var result = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezOrgan/getDeptMemberList.do",
		    		data : {
		    				deptID   : pDeptID, 
		    				cell 	 : "displayName;description;title;telephonenumber",
		    				prop     : "department;displayName;description;title",
		    				type 	 : "user"
		    				},
		    		success: function(result){
		                var retXml = createXmlDom();
		        		
			            if (document.getElementById("LineUserList").innerHTML != "")
			                document.getElementById("LineUserList").innerHTML = "";
			
			            var headerData = createXmlDom();
			            headerData = loadXMLString(userlist_h.innerHTML.toUpperCase());
			            
			            if (result != "") {
			                var xmlRtn = loadXMLString(result).documentElement.getElementsByTagName("ROWS")[0];
			                headerData.documentElement.appendChild(xmlRtn);
			            }
			            
			            var pUserList = new ListView();
			            pUserList.SetID("lvLineUserList");
			            pUserList.SetRowOnClick("list2_onSel_Click");
			            pUserList.SetRowOnDblClick("list2_onSel_DBclick");
			            pUserList.SetSelectFlag(false);
			            pUserList.SetHeightFree(true);
			            pUserList.DataSource(headerData);
			            pUserList.DataBind("LineUserList");
			
			            var userRows = pUserList.GetDataRows();
			            if (userRows.length <= 0) {
			                OpenAlertUI(linealt1);
			            }
		    		}
		    	});
		    }
		    function list_onSel_Click() {
		
		    }
		
		    function list_onSel_DBclick() {
		        insertContUser_onclick();
		    }
		
		    function list2_onSel_Click() {
		
		    }
		
		    function list2_onSel_DBclick() {
		        var pUserList = new ListView();
		        pUserList.LoadFromID("lvLineUserList");
		
		        var selnode = pUserList.GetSelectedRows();
		        var RtnVal = CheckSignCellValue();
		        InsertMode = "Add";
		        var pAPRLINE = new ListView();
		        pAPRLINE.LoadFromID("lvAPRAUTORULELINE");
		
		        if (RtnVal) {
		            APRLINEATTENDADDFunction(selnode, "PERSON");
		            initJunGyul();
		        }
		    }
		    function insertContUser_onclick() {
		        var DuplicateFlag = DuplicateAprDeptCheck(treeNode.GetNodeData("CN"));
		        if (DuplicateFlag) {
		            AprLineAddDept(treeNode.GetNodeData("VALUE"), treeNode.GetNodeData("CN"), "U");
		        } else {
		            var pAlertContent = "<spring:message code='ezApproval.t205'/><br>  <spring:message code='ezApproval.t206'/>";
		            OpenAlertUI(pAlertContent);
		        }
		    }
		
		    function btnClose_onclick() {
		    	btnfiledel();
		    	window.opener.GetFormInfo(contID, "000", "", "");
		        window.close();
		    }
		
		    function btn_OpinionAdd1_onclick() {
				var SampleXML = "<VALIDATION>\n\t<FIELD></FIELD>\n\t<CLASS></CLASS>\n\t<DESC></DESC>\n</VALIDATION>";
				if (txt_OpinionContent1.value) {
					txt_OpinionContent1.value += "\n";
				}
		        txt_OpinionContent1.value += SampleXML;
		    }
		
		    function btn_OpinionAdd2_onclick() {
		        // var SampleXML = "<CHECK>\n	<CASES>\n		<CASE>\n			<FIELD></FIELD>\n			<VALUE></VALUE>\n			<TYPE></TYPE>\n		</CASE>\n	</CASES>\n		<APRLINES>\n	    <APRLINE>\n			<APRTYPE></APRTYPE>\n			<CLASS></CLASS>\n			<VALUE></VALUE>\n			<DESC></DESC>\n		</APRLINE>\n	</APRLINES>\n</CHECK>";
				var SampleXML = "<APRLINE>\n\t<APRTYPE></APRTYPE>\n\t<CLASS></CLASS>\n\t<VALUE></VALUE>\n\t<DESC></DESC>\n</APRLINE>";
				if (txt_OpinionContent2.value) {
					txt_OpinionContent2.value += "\n";
				}
		        txt_OpinionContent2.value += SampleXML;
		    }
		    
		    function btn_FormConnSave_onclick() {
		        var pInformationContent = "<spring:message code='ezApprovalG.t1455'/>";
		        var Ans = OpenInformationUI(pInformationContent, FormConnSave_Complete);
		        
		        if (Ans) {
		        	FormConnSave_Complete(Ans);
		        }
		    }
		    
		    function FormConnSave_Complete(Ans) {
		        if (Ans) {
		        	$.ajax({
			        	type : "POST",
			        	dataType : "json",
			        	url : "/admin/ezApprovalG/formConnSave.do",
			        	async : false,
			        	data : {
			        		formID : formID,
			        		formText : "<?xml version=\"1.0\" encoding=\"euc-kr\"?>\n<CONNROOT>\n" + txt_OpinionContent.value + "\n</CONNROOT>",
			        		companyID : companyID	
			        	},
			        	success : function(result) {
			        		message.HWP_SetDocumentElement(result.result);
			                alert(strLang814);
			        	}
			        });
		        }
		        
		        OpenInformationUI_Complete();
			}

		    function GetEntryInfo(_DEPTID) {
		        var ReceiveDocument = "";

		        try {
		        	var result = "";
		        	$.ajax({
		        		type : "POST",
		        		dataType : "text",
		        		async : false,
		        		url : "/admin/ezOrgan/getEntryInfo.do",
		        		data : {
		        			cn 	  : _DEPTID,
		        			prop  : "extensionAttribute11"
		        		},
		        		success: function(xml){
		        			result = xml;
		        		}        			
		        	});
		        	
		            ReceiveDocument = SelectSingleNodeValueNew(loadXMLString(result), "DATA/EXTENSIONATTRIBUTE11");
		        } catch (e) {
		        } 
		        
		        return ReceiveDocument;
		    }
		    
		    //2018-09-04 수신자명변경
		    var aprdeptname_cross_dialogArguments = new Array();
		    function btnaddressChange() {
		        var listview = new ListView();
		        listview.LoadFromID("lvtForm");
		        var CurSelRow = listview.GetSelectedRows();
		        var windowName = "/admin/ezApprovalG/aprDeptName.do";
		        var parameter = "status:no;dialogWidth:340px;dialogHeight:195px;scroll:no;edge:sunken;help:no";
		
		        if (CurSelRow[0] == undefined) {
		            alert("<spring:message code='ezApprovalG.t10501'/>");
		            return;
		        }
		        
		        var dialogValue = CurSelRow[0].cells[0].innerText;
		        if (CrossYN()) {
		            aprdeptname_cross_dialogArguments[0] = dialogValue;
		            aprdeptname_cross_dialogArguments[1] = btnaddressChange_Complete;
		            
		            var feature = "width=360, height=220, toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1";
		            feature = feature + GetOpenPosition(360, 220);
		            window.open(windowName, "", feature);
		            
// 		            DivPopUpShow(360, 220, windowName);
		        } else {
		            parameter = parameter + GetShowModalPosition(330, 205);
		            var AddressName = window.showModalDialog(windowName, dialogValue, parameter);
		            if (AddressName == "cancel" || AddressName == undefined)
		                return;
		            if (CrossYN()) {
		                CurSelRow[0].cells[0].textContext = AddressName;
		                CurSelRow[0].cells[0].innerText = AddressName;
		            }
		            else {
		                CurSelRow[0].cells[0].innerText = AddressName;
		            }
		        }
		    }
		
		    function btnaddressChange_Complete(AddressName) {
		        if (AddressName == "cancel" || AddressName == undefined)
		            return;
		
		        var listview = new ListView();
		        listview.LoadFromID("lvtForm");
		        var CurSelRow = listview.GetSelectedRows();
		
		        if (CrossYN()) {
		            CurSelRow[0].cells[0].textContext = AddressName;
		            CurSelRow[0].cells[0].innerText = AddressName;
		        } else {
		            CurSelRow[0].cells[0].innerText = AddressName;
		        }
		    }
		    
		    /* 2020-07-24 홍승비 - 연동양식, 기결재통과 옵션 사용 시 다른 옵션 disabled 처리 함수 추가 (NeoJavaRel 참고) */
		    // 일괄기안의 경우, 2020-07-24 기준으로 표준 기능이 아니므로 주석처리
		    function changeConnFlag() {
		    	if ($("input:checkbox[id='setConnFlag']").is(":checked")) {
			    	$("input:checkbox[id='setPassAprLineFlag']").attr("checked", false);
			    	$("input:checkbox[id='setPassAprLineFlag']").attr("disabled", true);
			    	
 			    	if (useDraftAll == "YES") {
				    	$("input:checkbox[id='setDraftAllFlag']").attr("checked", false);
				    	$("input:checkbox[id='setDraftAllFlag']").attr("disabled", true);
			    	}
		    	} else {
		    		$("input:checkbox[id='setPassAprLineFlag']").attr("disabled", false);
		    		
 		    		if (useDraftAll == "YES") {
		    			$("input:checkbox[id='setDraftAllFlag']").attr("disabled", false);
		    		}
		    	}
		    }
		    
		    function changeDraftAllFlag() {
		    	if ($("input:checkbox[id='setDraftAllFlag']").is(":checked")) {
			    	$("input:checkbox[id='setPassAprLineFlag']").attr("checked", false);
			    	$("input:checkbox[id='setPassAprLineFlag']").attr("disabled", true);
			    	$("input:checkbox[id='setConnFlag']").attr("checked", false);
			    	$("input:checkbox[id='setConnFlag']").attr("disabled", true);
		    	} else {
		    		$("input:checkbox[id='setPassAprLineFlag']").attr("disabled", false);
		    		$("input:checkbox[id='setConnFlag']").attr("disabled", false);
		    	}
		    }
		    
		    function changePassAprLineFlag() {
		    	if ($("input:checkbox[id='setPassAprLineFlag']").is(":checked")) {
 		    		
		    		if (useDraftAll == "YES") {
			    		$("input:checkbox[id='setDraftAllFlag']").attr("checked", false);
				    	$("input:checkbox[id='setDraftAllFlag']").attr("disabled", true);
		    		}
			    	$("input:checkbox[id='setConnFlag']").attr("checked", false);
			    	$("input:checkbox[id='setConnFlag']").attr("disabled", true);
		    	} else {
 		    		if (useDraftAll == "YES") {
			    		$("input:checkbox[id='setDraftAllFlag']").attr("disabled", false);
		    		}
		    		$("input:checkbox[id='setConnFlag']").attr("disabled", false);
		    	}
		    }
		    
		    /* 2021-12-16 홍승비 - 고정수신처 탭 표출이 S버전과 G버전에 대응하도록 분기 추가 (버전별로 수신문과 시행문의 코드값이 다름)  */
			function changeSelFormKind(value) {
		    	var selSihangTypeVal = $("#selSihangType").val();
		    	
		    	// G버전 시행문인 경우, 테넌트 컨피그를 확인하여 내부/외부 선택 셀렉트박스 제어
				if (approvalFlag === "G" && receptGubunYN === "Y" && value === "001") {
					document.querySelector("#selSihangType").style.display = "";
				} else {
					document.querySelector("#selSihangType").style.display = "none";
				}
		    	
				// G버전 : 001이 시행문, 003이 수신문
				if (approvalFlag == "G") { // 내부, 외부 선택 가능한 경우 (receptGubunYN === "Y") 내부시행문일때만 표출
	 		        if ((value == "001" && receptGubunYN === "N") || (value == "001" && receptGubunYN === "Y" && selSihangTypeVal == "inner") || value == "003") {
	 		        	$("#ApvForm_sub5").show();
			        } else {
			        	$("#ApvForm_sub5").hide();
					}
		        }
		        else { // S버전 : 003이 수신문, 004가 시행문 (내부시행문만 존재)
	 		        if (value == "003" || value == "004") {
						$("#ApvForm_sub5").show();	
			        } else {
			        	$("#ApvForm_sub5").hide();
					}
		        }
			}
		    
		    /* 2021-12-16 홍승비 - G버전 시행문 내부, 외부 선택 시 고정수신처 탭 표출 제어 (내부, 외부 선택 가능한 경우 내부시행문일때만 표출) */
		    function changeSelSihangType(value) {
		    	var selFormKindVal = $("#selFormKind").val();
		    	
		    	if (selFormKindVal == "001" && receptGubunYN === "Y" && value == "inner") {
					$("#ApvForm_sub5").show();	
		        } else {
		        	$("#ApvForm_sub5").hide();
				}
		    }
			
			//양식 세부설정 기본값 설정
			var aprtypeCheckBoxInt = new Array("_a1_", "_a2_", "_a3_");
			function btnintAprType_onclick() {
				$("input[name=aprOption_a]").each(function () {
					$(this).prop("checked", false);
				});

				$(aprtypeCheckBoxInt).each(function () {
					$("#" + this).prop("checked", true);
				});
			}
			
			function btnfileup() { document.getElementById("hwpFile").click(); }
			
	        var xhr = new XMLHttpRequest();
			function btn_AttachAdd_onclick() {
				var extension = document.getElementById("hwpFile").value;
	            extension = extension.substring(extension.lastIndexOf(".") + 1, extension.length);
		        
		        // 첨부파일 확장자 체크(hwp만 가능)
		        if (extension.toLowerCase() != "hwp") {
		        	document.getElementById("hwpFile").files[0] = "";
		        	alert("한글 파일만 가능합니다.");
		        	return;
		        }
		        
		        var filelist = document.getElementById("hwpFile").files;
		       
	            var fd = new FormData();
	            
	            if(document.getElementById("hidfileNM").value != "") {
					btnfiledel();
				}
		        
	            fd.append("fileToUpload", filelist[0]);
	            
	            xhr.addEventListener("load", uploadComplete, false);
	            xhr.open("POST", "/ezApprovalG/uploadAttachForHwp.do?companyID=" + companyID);
	            xhr.send(fd); 
			}
			
			function uploadComplete() {
                document.getElementById("hwpFile").type = "text";
                document.getElementById("hwpFile").type = "file";
	            var xml = loadXMLString(xhr.responseText);

	            document.getElementById("tbFilename").value = getNodeText(SelectNodes(xml, "ROOT/NODES/DATA1")[0]);
	            document.getElementById("hidfileNM").value = getNodeText(SelectNodes(xml, "ROOT/NODES/DATA2")[0]);
			}
			
			function btnfiledel() {
				var file = document.getElementById("hidfileNM").value;
				
				if(file !=  "") {
					$.ajax({
						async : false,
						url : '/ezApprovalG/tempUploadFileDelete.do',
		                type : 'POST',
		                dataType : 'text',
		                data : {
							fileName : file,
							companyID : companyID
		                },
		                success: function() {
		                	document.getElementById("hidfileNM").value = "";
		                }
					});
				}
			}
            
            function getParentDeptNameForDB(deptID) {
                var rtnVal = "";
                
                $.ajax({
                    type : "GET",
                    dataType : "json",
                    async : false,
                    url : "/ezOrgan/getUpperDeptName.do",
                    data : {
                        deptID : deptID
                    },
                    success: function(result) {
                        rtnVal = result.upperDeptName;
                    },
                    error: function(xhr, status, error){
                        console.log(error);
                        alert(strLang199);
                    },
                });
                
                return rtnVal;
            }
		</script>
		<!-- FormBuilder -->
		<c:if test="${useReform}">
		<script>
			function onReformCheckboxClickEvent() {
				if (document.getElementById("reform-checkbox").checked) {
					document.getElementById("ApvForm_sub7").style.display = "";
					document.getElementById("ApvForm_sub8").style.display = "";
				} else {
					document.getElementById("ApvForm_sub7").style.display = "none";
					document.getElementById("ApvForm_sub8").style.display = "none";
				}
			}
		</script>
		</c:if>
		<!-- FormBuilder - end -->
		
		<style>
			#mainmenu ul li {float:right !important}
			#mainmenu ul li span {height:13px !important; background: none !important; margin-top:2px !important}
		</style>
	</head>
    <body class="popup">
        <div id="menu">
            <ul>
                <li><span id="btnSave" onClick="return btnSave_onclick()"><spring:message code='ezApprovalG.t59'/></span></li>
            </ul>
        </div>
        <div id="close">
            <ul>
                <li><span id="btnClose" onClick="return btnClose_onclick()"></span></li>
            </ul>
        </div>
        <div class="portlet_tabpart01">
	        <div class="portlet_tabpart01_top" id="tab1">
				<p id = "ApvForm_sub1"><span divname="ApvForm_div1" id="1tab1"><spring:message code='ezApprovalG.t00004'/></span></p>
				<p id = "ApvForm_sub9" style="display:none"><span divname="ApvForm_div9" id="1tab9"><spring:message code='ezApprovalG.t900008'/></span></p>
                <p id = "ApvForm_sub2"><span divname="ApvForm_div2" id="1tab2"><spring:message code='ezApprovalG.t1456'/></span></p>
                <p id = "ApvForm_sub3"><span divname="ApvForm_div3" id="1tab3"><spring:message code='ezApprovalG.t00005'/></span></p>
                <p id = "ApvForm_sub4"><span divname="ApvForm_div4" id="1tab4">WORKFLOW</span></p>
                <p id = "ApvForm_sub5"><span divname="ApvForm_div5" id="1tab5"><spring:message code='ezApprovalG.t1629'/></span></p>
                <p id = "ApvForm_sub6" style = 'display:none;'><span divname="ApvForm_div6" id="1tab6"><spring:message code='ezApproval.t990012'/></span></p>
				<!-- FormBuilder -->
				<c:if test="${useReform}">
					<p id = "ApvForm_sub7" style="display:none;"><span divname="ApvForm_div7" id="1tab7"><spring:message code='reform.menuitem.editor'/></span></p>
					<p id = "ApvForm_sub8" style="display:none;"><span divname="ApvForm_div8" id="1tab8"><spring:message code='reform.menuitem.function'/></span></p>
				</c:if>
				<!-- FormBuilder - end -->
				<p id = "ApvForm_sub10"><span divname="ApvForm_div10" id="1tab10">XSLT</span></p>
	        </div>
        </div>
        
        <div id="ApvForm_content1" style="width:100%;height:90%; padding-top:10px; display:none">
			<h2 id="form" class="receiver_tltype01" style="margin-bottom:5px;">
				<span style="min-width: 45px;" id="formstr"><spring:message code='ezApprovalG.t825'/></span>
			</h2>
			
			<table class="content" style="width:100%;">
				<tr>                
					<th style="width:100px; text-align:center">${primary}</th>
                    <td style="width:40%;">
                        <input type="text" id="tbFormName" name="tbFormName" maxlength="50" style="width:100%">
                        <input type="text" id="tbFormID" name="tbFormID" style="display: none" readonly>
                    </td>
                    <th style="width:100px; text-align:center">${secondary}</th>
                    <td style="width:40%;" colspan="5">
                        <input type="text" id="tbFormName2" name="tbFormName2" maxlength="50" style="width:100%" >
                    </td>
                </tr>
                <tr>
                    <th style="width:100px; text-align:center"><spring:message code='ezApprovalG.t598'/></th>
                    <td style="width:40%;">
                        <input type="text" id="tbDescript" name="tbDescript" style="WIDTH: 100%" maxlength="50">
                    </td>
                    <th style="width:100px; text-align:center"><spring:message code='ezApproval.t758'/></th>
                    <td style="width:40%;" colspan="5">
						<div style="width: 100%; display: flex; justify-content: space-between;">
							<select id="selFormKind" name="selFormKind" style="flex: 2;" onchange="changeSelFormKind(this.value)">${docType}</select>
							<select id="selSihangType" name="selSihangType" style="flex: 1; margin-left: 2px; display:none;" onchange="changeSelSihangType(this.value)">
								<option value="inner" selected>내부</option>
								<option value="outer">외부</option>
							</select>
						</div>
                    </td>
                </tr>
                <c:if test="${useEditor == 'WebHWP' && formID eq null}">
                <tr>
                    <th style="width:100px; text-align:center"><spring:message code = 'ezApprovalG.KMH10' /></th>
                    <td style="width:40%;" colspan="7">
                    	<input type="text" readonly="" id="tbFilename" name="tbFilename" style="width: 350px;">
                    	<a class="imgbtn imgbck" style="margin-top:1px;">
        					<span onclick="btnfileup()"><spring:message code = 'ezApprovalG.nonElecAt03' /></span>
        				</a>
                    </td>
                </tr>
                <input type="file" id="fileBtn" multiple="multiple" class="hiddenBttn">
                </c:if>
                <tr>
					<td colspan="8" style="width:10%; text-align:center;">
						<div class='custom_checkbox'>
							<input type="checkbox" id="setConnFlag" onclick="changeConnFlag()"/><label for="setConnFlag"><spring:message code = 'ezApprovalG.t1665' /></label>
							<!-- FormBuilder -->
							<c:if test="${useReform}">
								<input type="checkbox" id="reform-checkbox" name="reform-checkbox" onchange="onReformCheckboxClickEvent()"/>
								<label for="reform-checkbox"><span><spring:message code='reform.using'/></span></label>
							</c:if>
							<!-- FormBuilder - end -->
							
							<%-- 2021-01-21  심기영 오피스 결재 추가 여부용  --%>
							<c:if test="${useOfficeApproval == 'YES' && approvalFlag == 'G'}">
								<input type="checkbox" id="officeFlag" name="officeFlag">
								<label for="officeFlag"><span><spring:message code='ezApproval.t933'/></span></label>
							</c:if>
							<%-- 2021-01-21  심기영 오피스 결재 추가 여부용  --%>
							<c:if test="${useOfficeApproval == 'YES' && approvalFlag == 'S'}">
								<input type="checkbox" id="officeFlag" name="officeFlag">
								<label for="officeFlag"><span><spring:message code='ezApproval.t933'/></span></label>
							</c:if>
							<span style="<c:if test="${useOpenGov != 'YES' || approvalFlag != 'G'}">display:none;</c:if>"><input type="checkbox" id="setOpenGovFlag" /><label for="setOpenGovFlag"><spring:message code='ezApprovalG.openGovK01'/></label></span>
							<%-- 2022-01-07 홍승비 - 전자결재G 웹한글 일괄기안 기능 표준모듈 반영 --%>
							<span style="<c:if test="${useDraftAll != 'YES'}">display:none;</c:if> margin-left: 20px;"><input type="checkbox" id="setDraftAllFlag" onclick="changeDraftAllFlag()" /><label for="setDraftAllFlag"><spring:message code='ezApprovalG.groupdocK01'/></label></span>
							<span style="<c:if test="${usePassAprLine != 'YES'}">display:none;</c:if> margin-left: 20px;"><input type="checkbox" id="setPassAprLineFlag" onclick="changePassAprLineFlag()"/><label for="setPassAprLineFlag"><spring:message code='ezApprovalG.garm09'/></label></span>
						</div>
					</td>
				</tr>
			</table>
            <br />
            <div style="padding-bottom:5px; vertical-align:middle; <c:if test="${approvalFlag != 'S' }">display:none;</c:if>">
				<div class='custom_checkbox'><input type="checkbox" id="setAutoItemCode" name="setAutoItemCode" onclick="viewAutoItemCode()" style="vertical-align: middle;"/>
            		<label for="setAutoItemCode"><span><spring:message code='ezApproval.t00004'/></span></label>
				</div>
            </div>
            <table class="content" style="width:100%;">
				<tr id="tr_setAutoItemCode">
					<th style="width:10%; text-align:center"><spring:message code='ezApprovalG.t1197'/></th>
                    <td style="width:400px;">
                        <input type="text" id="tbItemCode" name="tbItemCode" style="WIDTH: 80px" readonly>
                        <input type="text" id="tbItemName" name="tbItemName" style="WIDTH: 100px" readonly>
                        <input type="hidden" id="tbItemName2" name="tbItemName2">
                        <a class="imgbtn imgbck"><span onclick="return btnItemCode_onclick()"><spring:message code='ezApproval.t321'/></span></a>
                        <a class="imgbtn imgbck"><span onclick="DeleteItemCode()"><spring:message code='ezApprovalG.t266'/></span></a>
                    </td>
                    <th style="width:10%; text-align:center"><spring:message code='ezApprovalG.t118'/></th>
                    <td style="width:100px; text-align:center">
                        <select id="securitylevel" name="select">${securityNode}</select>
                    </td>
                    <th style="width:10%; text-align:center"><spring:message code='ezApproval.t336'/></th>
                    <td style="width:100px; text-align:center">
                        <select id="keepperiod" name="select">${periodNode}</select>
                    </td>
                    <th style="width:10%; text-align:center"><spring:message code='ezApproval.t82'/></th>
                    <td style="width:100px; text-align:center">
                        <select id="isPublic" name="select">
                            <option value="Y" selected><spring:message code='ezApprovalG.t47'/></option>
                            <option value="N"><spring:message code='ezApprovalG.t46'/></option>
                        </select>
                    </td>
                </tr>
            </table>
		</div>
		<!--양식 세부설정-->
		<div id="ApvForm_content9" style="width:100%;height:90%; padding-top:10px; display:none">
			<h2 id="form" class="receiver_tltype01" style="margin-bottom:5px;">
				<span style="min-width: 45px;" id="formstr" name="aprOption" code="a" ><spring:message code='ezApprovalG.t900003'/></span>&nbsp;&nbsp;&nbsp;<a class="imgbtn"><span onclick="btnintAprType_onclick()"><spring:message code='ezApprovalG.t900004'/></span></a>
			</h2>
			<table class="content" style="width:100%;">
				<tr><!--의견-->
					<th style="width:10%"><spring:message code='ezApprovalG.F0013'/></th>
					<td style="width:10%"><div class='custom_checkbox'><input type="checkbox" id="_a1_" name="aprOption_a"><label for="_a1_"><spring:message code='ezApprovalG.t900009'/></label></div></td>
					<td><spring:message code='ezApprovalG.t900005'/></td>
				</tr>
				<tr><!--파일첨부-->
					<th style="width:10%"><spring:message code='ezApprovalG.t264'/></th>
					<td style="width:10%"><div class='custom_checkbox'><input type="checkbox" id="_a2_" name="aprOption_a"><label for="_a2_"><spring:message code='ezApprovalG.t900009'/></label></div></td>
					<td><spring:message code='ezApprovalG.t900006'/></td>
				</tr>
				<tr><!--문서첨부-->
					<th style="width:10%"><spring:message code='ezApprovalG.t57'/></th>
					<td style="width:10%"><div class='custom_checkbox'><input type="checkbox" id="_a3_" name="aprOption_a"><label for="_a3_"><spring:message code='ezApprovalG.t900009'/></label></div></td>
					<td><spring:message code='ezApprovalG.t900007'/></td>
				</tr>								
			</table>
		</div>
		
        <div id="ApvForm_content2" style="width:100%;display:none; padding-top:10px;">
            <h2 id="H1" class="receiver_tltype01" style="margin-bottom:5px;">
			<span style="min-width: 45px;" id="Span1"><spring:message code='ezApproval.t00007'/></span>
            </h2>
			<div id="editor_content" style="padding-top:5px;">
				<div id="mainmenu">
					<ul>
                    	<li id="property"><span onclick="return idSetField_onclick()"><spring:message code='ezApproval.t641'/></span></li>
                    </ul>
                </div>
                <script type="text/javascript">
                    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
                </script>
				<table id="TForm" style="height:770px; width: 100%;">
					<tr>
                        <td style="height:770px; vertical-align:top">
                        	<c:choose>
                        		<c:when test="${useEditor == 'HWP'}">
	                                <iframe id="message" class="viewbox" src="/admin/ezApprovalG/HWPEditor.do?type=ADMIN" name="message" frameborder="0" style="padding: 0; height: 99%; width: 1030px; overflow: auto;"></iframe>
                        		</c:when>
                        		<c:when test="${useEditor == 'WebHWP'}">
	                                <iframe id="message" class="viewbox" src="/admin/ezApprovalG/WHWPEditor.do?type=ADMIN" name="message" frameborder="0" style="padding: 0; height: 99%; width: 1030px; overflow: auto;"></iframe>
                        		</c:when>
                        		<c:otherwise>
	                                <iframe id="message" class="viewbox" src="/admin/ezEditor/selectApprovalEditor.do?type=ADMIN&height=770&formID=${formID}" name="message" frameborder="0" style="padding: 0; height: 99%; width: 100%; min-width:800px; overflow: auto;"></iframe>
                        		</c:otherwise>
                        	</c:choose>
                        </td>
                        <td id="rootTD" name="rootTD" style="width:280px; vertical-align:top; text-align:left; padding-left:10px; display:none"></td>
                    </tr>
                </table>
			</div>
		</div>
        <div id="ApvForm_content3" style="width:100%;height:90%;display:none; padding-top:10px;">
            <h2 id="H2" class="receiver_tltype01" style="margin-bottom:5px;">
            	<span style="min-width: 45px;" id="Span2"><spring:message code='ezApproval.t504'/></span>
            </h2>
			
            <table class="content">
                <tr>
                    <td style="height:800px">&lt;xml id=conn&gt;<br>
                        &lt;connroot&gt;<br>
                        <textarea class="textarea" ID="txt_OpinionContent" style="FONT-SIZE:9pt; WIDTH:98.5%; HEIGHT:734px"></textarea>
                        <br>
                        &lt;/connroot&gt;<br>
                        &lt;/xml&gt;
                    </td>
                    <th>
                        <a class="imgbtn" id="btn_OpinionAdd"><span onclick="btn_FormConnInfo_onclick()"><spring:message code='ezApprovalG.t268'/></span></a><br>
                        
                        <c:if test="${useEditor == 'HWP' }">
                       		<a class="imgbtn" id="btn_OpinionSave"><span onclick="btn_FormConnSave_onclick()"><spring:message code='ezApprovalG.t1767'/></span></a><br>
                        </c:if>
                        
                    </th>
                </tr>
            </table>
        </div>

        <div id="ApvForm_content4" style="width:100%;height:60%;display:none; padding-top:10px;">
        	<table class="content"> 
                <tr>
                	<td>&lt;xml id=WORKFLOW&gt;<br>
	                    &lt;WORKFLOW&gt;<br>
	                    &lt;VALIDATIONS&gt;<br>
	                    <textarea name="txt_OpinionContent1" style="FONT-SIZE:9pt; WIDTH:98.5%; HEIGHT:350px" id="txt_OpinionContent1"></textarea>
	                    <br> &lt;/VALIDATIONS&gt;<br>
	                    &lt;APRLINES&gt;<br>
	                    <textarea name="txt_OpinionContent2" style="FONT-SIZE:9pt; WIDTH:98.5%; HEIGHT:350px" id="txt_OpinionContent2"></textarea>
	                    <br> &lt;/APRLINES&gt;<br>
	                    &lt;/WORKFLOW&gt;<br>
	                    &lt;/xml&gt;
	                </td>
                	<th>
	                    <a class="imgbtn" id="Submit1"><span onclick="btn_OpinionAdd1_onclick()"><spring:message code='ezApproval.t529'/></span></a><br>
	                    <a class="imgbtn" id="Submit2"><span onclick="btn_OpinionAdd2_onclick()"><spring:message code='ezApproval.t530'/></span></a><br>
		            </th>
                </tr>
            </table>
        </div>
        

        <!-- 고정 수신처 -->
        <div id="ApvForm_content5" style="width:100%;height:90%;display:none; padding-top:10px;">         
            <h2 id="group" class="receiver_tltype01" style="margin-bottom:5px;">
            	<span style="min-width: 45px;" id="groupstr"><spring:message code='ezApprovalG.t1577'/></span>
            </h2>
            
            <table style="width:100%; height:810px;">
                <tr>
                    <td style="width:400px; vertical-align:top; padding-top:5px; border-right:none">
                        <h2><spring:message code='ezApprovalG.t232'/></h2>
                        <div id="TreeView" style="<c:if test="${approvalFlag != 'S'}">height: 775px;</c:if><c:if test="${approvalFlag == 'S'}">height: 355px;</c:if> width: 100%; overflow-x: auto; overflow-y: auto; BORDER: #ddd 1px solid; BACKGROUND-COLOR: #ffffff;"></div>
                        <c:if test="${approvalFlag == 'S'}"><br /></c:if>
                        <div class="div_scroll" style="border:none; <c:if test="${approvalFlag != 'S'}">display:none;</c:if>">
                            <div id="UserList" style="height: 405px; width: 100%; overflow-x: auto; overflow-y: auto; BORDER: #ddd 1px solid; BACKGROUND-COLOR: #ffffff;border-top:none"></div>
                        </div>
                    </td>
                    <td style="text-align:center; width:50px; border-left:none; border-right:none">
                        <img style="cursor:pointer;" src="/images/arr_r.gif" width="24" height="24" onclick="return insertCont_onclick()"><br>
                        <img style="cursor:pointer" src="/images/arr_l.gif" width="24" height="24" onclick="return deleteCont_onclick()"><br>
                        <img style="cursor:pointer" src="/images/arr_rr.gif" width="24" height="24" onclick="return insertAllCont_onclick()"><br>
                        <img style="cursor:pointer" src="/images/arr_ll.gif" width="24" height="24" onclick="return deleteAllCont_onclick()"><br>
                        <img style="cursor:pointer" src="/images/arr_u.gif" width="24" height="24" onclick="return moveUp_onclick()"><br>
                        <img style="cursor:pointer" src="/images/arr_d.gif" width="24" height="24" onclick="return moveDown_onclick()"><br>
                        <div style="height:300px;<c:if test="${approvalFlag != 'S'}">display:none;</c:if>">&nbsp;</div>
                        <img style="cursor:pointer;margin-bottom:50px;<c:if test="${approvalFlag != 'S' }">display:none;</c:if>" src="/images/arr_r.gif" width="24" height="24" onclick="return insertContUser_onclick()">
                    </td>
                    <td style="width:600px; vertical-align:top; padding-top:5px; border-left:none;">
                        <h2><spring:message code='ezApproval.t61'/><a class="imgbtn imgbck" style="float: right; margin-bottom: 0px;"><span id="Span6" onclick="return btnaddressChange()"><c:if test="${approvalFlag == 'G'}"><spring:message code='ezApprovalG.t348'/></c:if><c:if test="${approvalFlag == 'S'}"><spring:message code='ezApproval.t1104'/></c:if></span></a></h2>
                        <div class="div_scroll" style="border:none; height:775px;">
                            <div id="divlvtForm" style="WIDTH: 100%; HEIGHT: 100%;overflow-x: auto; overflow-y: auto; BORDER: #ddd 1px solid; BACKGROUND-COLOR: #ffffff;border-top:none"></div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <div id="ApvForm_content6" style="width:100%;height:90%;display:none; padding-top:10px;">
            <h2 id="H3" class="receiver_tltype01" style="margin-bottom:5px;"><span style="min-width: 45px;" id="Span3"><spring:message code='ezApproval.t990012'/></span></h2>
            
            <table>
	            <tr>
		            <th><spring:message code='ezApprovalG.t1540'/></th>
		            <td><select id="selDocType" name="selDocType" onChange="return OnChange_DocType()">${docType}</select></td>
	            </tr>
            </table>
            <br />
            <table style="width:100%; border:none;">
                <tr>
                    <td colspan="2" style="text-align:right;vertical-align:bottom;">
                        <img src="/images/arr_u.gif" width="24" height="24" style="cursor: pointer;" onclick="MoveUp_List_AutoRule_onclick()">
                        <img src="/images/arr_d.gif" width="24" height="24" style="cursor: pointer" onclick="MoveDown_List_AutoRule_onclick()">
                    </td>
                </tr>
            	<tr>
                	<td style="vertical-align:top;height: 135px;" colspan="2">
                    	<div class="listview" style="border:1px solid #ddd;width:100%">
                        	<div id="div_List_AutoRule" style="border: 0; font-size:9pt;width: 100%; height: 130px;overflow:auto;"></div>
                    	</div>
                	</td>
            	</tr>
            	<tr>
                	<td style="vertical-align:top" colspan="2">
                    	<table class="content" style="width:100%;border:0">
                        	<tr>
                            	<th style="text-align:center;width:10%"><spring:message code='ezApproval.t990016'/></th>
                            	<td>
	                                <select id="DDL_CHECKTYPE" style="width:130px" onchange="DDL_CHECKTYPE_onChange()">
	                                    <option value="FIELD"><spring:message code='ezApproval.t990020'/></option>
	                                    <option value="DRAFTER_DEPT"><spring:message code='ezApproval.t990021'/></option>
	                                </select>
	                                <select id="DDL_FIELDIDLIST" onchange="FieldIdList_onChange()">
	                                    <option value=""><spring:message code='ezApproval.t990022'/></option>
	                                </select>
	                                <input type="text" id="txtCondVal" style="width:150px;ime-mode:disabled;margin-top:-1px" />
	                            </td>
	                            <td rowspan="4" style="width:150px;">
	                                <a class="imgbtn" onclick="return btn_Add();" ><span style="font-size:8pt"><spring:message code='ezApproval.t990043'/></span></a>
	                            </td>
                        	</tr>
                        	<tr>
	                            <th style="text-align:center;"><spring:message code='ezApproval.t990023'/></th>
	                            <td>
	                                <select id="DDL_DATATYPE" style="width:80px" onchange="DDL_DATATYPE_onChange()">
	                                    <option value="TXT"><spring:message code='ezApproval.t990024'/></option>
	                                    <option value="NUM"><spring:message code='ezApproval.t990025'/></option>
	                                </select>
	                                <select id="DDL_NUMBER_EQUAL" style="width:80px;display:none">
	                                    <option value="NUM_GE">>= <spring:message code='ezApproval.t990029'/></option>
	                                    <option value="NUM_LE"><= <spring:message code='ezApproval.t990030'/></option>
	                                    <option value="NUM_GT">> <spring:message code='ezApproval.t990031'/></option>
	                                    <option value="NUM_LT">< <spring:message code='ezApproval.t990032'/></option>
	                                    <option value="NUM_EQ">= <spring:message code='ezApproval.t990026'/></option>
	                                </select>
	                                <select id="DDL_TEXT_EQUAL" style="width:80px">
	                                    <option value="TXT_EQ"><spring:message code='ezApproval.t990026'/></option>
	                                    <option value="TXT_INC"><spring:message code='ezApproval.t990027'/></option>
	                                    <option value="TXT_NOTINC"><spring:message code='ezApproval.t990028'/></option>
	                                </select>
	                            </td>
	                        </tr>
	                        <tr>
	                            <th style="text-align:center;"><spring:message code='ezApproval.t990019'/></th>
	                            <td>
	                                <select id="DDL_STANDVAL" onchange="ChangeStandVal()" >
	                                    <option value="DeptId"><spring:message code='ezApproval.t171'/></option>
	                                    <option value="TitleCd" style="display:none"><spring:message code='ezApproval.t170'/></option>
	                                    <option value="Direct"><spring:message code='ezApproval.t990022'/></option>
	                                </select>
	                                <input type="button" value="<spring:message code='ezApproval.t344'/>" id="btnSelDept" onclick="SelectDept()" />
	                                <select id="DDL_TITLE" style="display:none" onchange="DDL_TITLE_OnChange()">
	                                    <option><spring:message code='ezApproval.t990046'/></option>
	                                </select>
	                                <input type="text" id="txtStandVal" value="" style="width:150px;margin-top:-5px" />
	                            </td>
	                        </tr>
						</table>
                	</td>
            	</tr>
        	</table>
        	
            <div id="DIVAPRLINE" style="width:100%;height:500px;display:none">
	            <table>
	                <tr>
	                    <td style="height:480px;width:330px;margin-left:5px;vertical-align:top;">
	                        <div class="portlet_tabpart01" align="right" style="margin-top:3px;">
		                        <div class="portlet_tabpart01_top" id="tab2">
	                                    <p><span divname="Organ" id="2tab1"><spring:message code='ezApprovalG.t232'/></span></p>
		                        </div>
	                        </div>
	                        <div id="OrganLineTab">
	                            <table style="margin-left:0px">
	                                <tr>
	                                    <td valign="top">
	                                        <div id ="divLineUserTree" style="margin-top:5px;overflow-x:auto;overflow-y:auto;height:200px;width:330px;border:1px solid #ddd;background-color:#FFFFFF;margin:1px 1px 1px 1px;">
	                                    </div>
	                                    </td>
	                                </tr>
	                                <tr>
	                                    <td style="">
	                                        <div class="listview" style="border:0px;">
	                                            <div id= "LineUserList" style="border:0px;margin:0px;Width:330px; Height:220px;overflow:auto;border:1px solid #ddd;margin:1px 1px 1px 1px;"></div>
	                                        </div>
	                                    </td>
	                                </tr>
	                                <tr>
	                                    <td height="30" style="background-color:transparent;border:0px;">
	                                        <div style="border:1px solid #ddd;margin:0px 1px 1px 1px;height:27px;">
	                                    <input id="textUser" style="width:160px" name="textUser" onKeyPress="return textUser_onkeypress()" tabindex="1" maxlength="50">
	                                    <a class="imgbtn" onKeyPress="return btn_searchUser_onclick()" onClick="return btn_searchUser_onclick()" name="btn_searchUser" id="btn_searchUser" tabindex="1"><span  style="width:60px;text-align:center" ><spring:message code='ezApproval.t175'/></span></a>
	                                            </div>
	                                    </td>
	                                </tr>
	                            </table>
	                        </div>
	                    </td>
	                    <td style="border:0px solid red;vertical-align:central;padding-left:4px;padding-right:4px">
	                        <img src="/images/arr_up.gif" width="16" height="16" vspace="2" style="cursor: pointer;" onclick="AprlineUpper_onclick()" alt="<spring:message code='ezApproval.hyj9'/>"><br />
	                        <img src="/images/arr_down.gif" width="16" height="16" vspace="2" style="cursor: pointer" onclick="AprlineDown_onclick()" alt="<spring:message code='ezApproval.hyj10'/>"><br />
	                    </td>
	                    <td style="border:0px solid red;height:550px;width:650px;vertical-align:top;">
	                      <table style="margin-left:1px;height:450px;">
	                        <tr>
	                            <td valign="top">
	                                <h2 style ="vertical-align:top;" >
	                                    <div style="text-align:right;vertical-align: top; height: 20px;">
	                                        <a class="imgbtn" onclick="return AddDeptmentSelected();" ><span><spring:message code='ezApproval.t990036'/></span></a>
	                                        <a class="imgbtn" onclick="AprlineNullAdd_onclick('user')"><span><spring:message code='ezApproval.t990037'/></span></a>
	                                        <a class="imgbtn" onclick="AprlineNullAdd_onclick('dept')"><span><spring:message code='ezApproval.t1101'/></span></a>
	                                        <a class="imgbtn" onclick="AprlineNullAdd_onclick('draft')"><span><spring:message code='ezApproval.t990038'/></span></a>
	                                        <a class="imgbtn" onclick="AprlineNullAdd_onclick('all')"><span><spring:message code='ezApproval.t990039'/></span></a>
	                                        <a class="imgbtn" onclick="AprlineNullAdd_onclick('temp')"><span><spring:message code='ezApproval.t990040'/></span></a>
	                                    </div>
	                                </h2>
	                                <div class="listview">
	                                    <div id ="APRLINE" style="Width:650px; Height:425px; overflow:auto;border:0;font-size:9pt; margin:1px 1px 1px 1px;padding-top:1px;"></div>
	                                </div>
	                            </td>
	                        </tr>
	                        <tr>
	                            <td style="height:30px;border:1px solid #ddd;text-align:center;">
									<div class='custom_checkbox'>
										<input type="checkbox" name="FixYN" id="FixYN" value ="checkbox" onclick="return FixFlag_onclick()">
										<label for="FixYN"><spring:message code='ezApproval.t990041'/> &nbsp;&nbsp;&nbsp;&nbsp;</label>
	                            	</div>
								</td>
	                        </tr>
	                      </table>
	                    </td>
	                </tr>
	            </table>
        	</div>
        </div>
        
        <!-- FormBuilder -->
        <c:if test="${useReform}">
		    <div id="ApvForm_content7" style="width:100%; height:900px; display:none; padding-top:10px;">
		        <h2 id="H4" class="receiver_tltype01" style="margin-bottom:5px;">
		        	<span style="min-width: 45px;" id="Span4"><spring:message code='reform.menuitem.editor'/></span>
		        </h2>
		        <iframe id="iframe_ApvReForm" class="viewbox" src="/admin/ezApprovalG/reformDesignProcessor.do?height=880&id=editor2" name="iframe_ApvReForm" frameborder="0" style="padding: 0; height: 100%; width: 100%; min-width:1080px;  overflow: auto; border:none"></iframe>
		    </div>
		    <div id="ApvForm_content8" style="width:100%;height:90%;display:none; padding-top:10px;">
		        <h2 id="H8" class="receiver_tltype01" style="margin-bottom:5px;">
		        	<span style="min-width: 45px;" id="Span8"><spring:message code='reform.menuitem.editor'/></span>
		        </h2>
		        <table class="content">
		            <tr>
		                <td>
		                    <textarea class="textarea" id="txt_reformFunction" onkeydown="if (event.keyCode===9){var v=this.value,s=this.selectionStart,e=this.selectionEnd;this.value=v.substring(0, s)+'    '+v.substring(e);this.selectionStart=this.selectionEnd=s+4;return false;}" style="font-size:12pt; width:820px; height:790px; ime-mode: inactive;"><c:if test="${!empty reformFunction}"><c:out value='${reformFunction}'/></c:if></textarea>
		                </td>
		            </tr>
		        </table>
		    </div>  
       	</c:if>
       	<!-- FormBuilder - end -->
		<%-- XSLT --%>
		<div id="ApvForm_content10" style="width: 100%; height: 828px; padding-top: 10px; overflow-y: auto; display: none;">                          
            <ul class="contentlayout">
            	<li class="contentlayout_none">
                	<h2 class="receiver_tltype01" style="margin-bottom:5px;">
		            	<span style="min-width: 45px;">XSLT</span>
		            </h2>
					<span><div class='custom_checkbox'><input type="checkbox" style="margin-left: 0; vertical-align: middle;" id="setBodyXslt" name="setBodyXslt"><label for="setBodyXslt"><spring:message code='ezApprovalG.xslt'/></label></div></span>
                    <table class="content" style="width:100%; margin-top: 2px;">
                        <tbody>
	                        <tr id="tr_setXslt">
	                            <th style="width:5%; text-align:center">XSLT</th>
	                            <td style="width:45%;">                                
	                                <textarea id="BodyXslt" rows="15" style="resize: none; box-sizing: border-box; margin-top: 3px;"></textarea>
	                            </td>
	                            <th style="width:5%; text-align:center">XML</th>
	                            <td style="width:45%;">                                
	                                <textarea id="BodyXml" rows="15" style="resize: none; box-sizing: border-box; margin-top: 3px;"></textarea>  
	                            </td>
	                        </tr>                        
	                    </tbody>
	            	</table>
                </li>
                <br/> 
                <li class="contentlayout_none">
                	<h2 class="receiver_tltype01" style="margin-bottom:5px;">
		            	<span style="min-width: 45px;">HTML Sample</span>
		            </h2>
                    <a class="imgbtn">
                    	<span onclick="ViewHTML()" style="font-weight: bold;"><spring:message code='ezApprovalG.xslt.html'/></span>   
                    </a>                                                      
                    <table class="content" style="width:100%; margin-top: 5px;">
                        <tbody>
                        	<tr id="tr_htmlView">
	                            <td> 
	                                <iframe name="iframeView" id="iframeView" style="height:400px;width:100%;overflow-y:auto" frameborder="0"></iframe>
	                            </td>
	                        </tr>
	                    </tbody>
	            	</table>
                </li>
            </ul>            
        </div>
		<%-- XSLT end --%>
		
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background:none rgba(0,0,0,0.5); display:none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		    <iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
	    </div>
	    <form method="post" id="form" name="form" enctype="multipart/form-data" action="/ezApprovalG/uploadHwpForm.do" style="display:none">
			<input type="file" name="file" id="hwpFile" onchange="btn_AttachAdd_onclick()" style="display:none" accept=".hwp"/>
  		</form>
        <input type="hidden" id="hidfileNM" name="hidfileNM" value="">
        <form id="bodyForm">
        	<input type="hidden" id="hidCompanyID" value="${companyID}">
        	<input type="hidden" id="hidFormID" value="${formID}">
        	<input type="hidden" id="hidListHeader" value="${listHeader}">
        	<input type="hidden" id="hidAprRule" value="${aprRule}">
        	<input type="hidden" id="hidAprRuleLine" value="${aprRuleLine}">
        	<input type="hidden" id="hidAprTypeXml" value="${aprTypeXML}">
        </form>
        <script type="text/javascript">
            Tab1_NewTabIni("tab1");

			function ViewHTML() {
				var pAlertContent = ""

				var xsltCode = document.querySelector("#BodyXslt").value.trim();
				var xmlCode = document.querySelector("#BodyXml").value.trim();

				if(!xsltCode) {
					pAlertContent = "<spring:message code='ezApprovalG.xslt01'/>";
		    		OpenAlertUI(pAlertContent);
		    		return;
				}

				if(!xmlCode) {
					pAlertContent = "<spring:message code='ezApprovalG.xslt02'/>";
		    		OpenAlertUI(pAlertContent);
		    		return;
				}

				var xhr = new XMLHttpRequest();
				xhr.open("POST", "/admin/ezApprovalG/convertXmltoHtml.do");
				xhr.setRequestHeader("Content-Type", "application/json");
				xhr.onreadystatechange = function() {
					if(xhr.readyState === XMLHttpRequest.DONE) {
						if(xhr.status === 200) {
							var htmlCode = xhr.responseText;

							if(htmlCode) {
								iframeView.document.body.innerHTML = htmlCode;
							}
						} else if(xhr.status === 409) {
							var pAlertContent = "<spring:message code='ezApprovalG.xslt03'/>";
							OpenAlertUI(pAlertContent);
							return;
						}
					}
				}

				xhr.send(JSON.stringify({
					xsltCode: xsltCode,
					xmlCode: xmlCode
				}));
			}
        </script>
        <xml id="userlist_h" style="display: none">
            <LISTVIEWDATA>
                <HEADERS>
                    <HEADER>
                        <NAME><spring:message code='ezApproval.t265'/></NAME>
                        <WIDTH>70</WIDTH>
                    </HEADER>
                    <HEADER>
                        <NAME><spring:message code='ezApproval.t216'/></NAME>
                        <WIDTH>100</WIDTH>
                    </HEADER>
                    <HEADER>
                        <NAME><spring:message code='ezApproval.t266'/></NAME>
                        <WIDTH>60</WIDTH>
                    </HEADER>
                    <HEADER>
                        <NAME><spring:message code='ezApproval.t172'/></NAME>
                        <WIDTH>80</WIDTH>
                    </HEADER>
                </HEADERS>
                <ROWS></ROWS>
            </LISTVIEWDATA>
        </xml>
	</body>
</html>
