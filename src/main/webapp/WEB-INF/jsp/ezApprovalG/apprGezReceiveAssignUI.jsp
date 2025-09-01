<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezApprovalG.t424'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeView.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeViewCtrl_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/SelectSubTitles_Cross.js')}"></script>
	    <script id="clientEventHandlersJS" type="text/javascript">
	        var OrderCell = "";
	        var labelcolor = "c6c6c6"
	        var xmlhttp = createXMLHttpRequest();
	        var InitTreeVal = "";
	        var pDocID;
	        var pReceiveSN;
	        var CurSelNode;
	        var pAprSate;
	        var arr_userinfo = new Array();
	        arr_userinfo[0] = "user";
	        arr_userinfo[1] = "<c:out value ='${userInfo.id}'/>";
	        arr_userinfo[2] = "<c:out value ='${userInfo.displayName}'/>";
	        arr_userinfo[3] = "<c:out value ='${userInfo.title}'/>";
	        arr_userinfo[4] = "<c:out value ='${userInfo.deptID}'/>";
	        arr_userinfo[5] = "<c:out value ='${userInfo.deptName}'/>";
	        arr_userinfo[6] = "<c:out value ='${userInfo.jikChek}'/>";
	        arr_userinfo[8] = "<c:out value ='${userInfo.email}'/>";
	        arr_userinfo[9] = "";
	        arr_userinfo[10] = "<c:out value ='${susinAdmin}'/>";
	        arr_userinfo[11] = "<c:out value ='${userInfo.displayName1}'/>";
	        arr_userinfo[12] = "<c:out value ='${userInfo.displayName2}'/>";
	        arr_userinfo[13] = "<c:out value ='${userInfo.title1}'/>";
	        arr_userinfo[14] = "<c:out value ='${userInfo.title2}'/>";
	        arr_userinfo[15] = "<c:out value ='${userInfo.deptName1}'/>";
	        arr_userinfo[16] = "<c:out value ='${userInfo.deptName2}'/>";
	        var pUserID = arr_userinfo[1];
	        var RetValue;
	        var ReturnFunction;
	        var pDocState;
	        var isReDraft;
	        var approvalFlag = "<c:out value ='${approvalFlag}'/>";
	        var orgCompanyID;
	        var mode = "<c:out value ='${mode}'/>";
	        
	        window.onload = function () {
	            try {
	                var ua = navigator.userAgent;
	                if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
	                    KeEventControl(document.getElementById("textUser"));
	                }
	                try {
						if(mode == 'ALL'){
							if (isParentCommonArgsUsed()) {
								RetValue = opener == null ? parent.ezCommon_cross_dialogArguments[0] : opener.ezCommon_cross_dialogArguments[0];
								ReturnFunction = opener == null ? parent.ezCommon_cross_dialogArguments[1] : opener.ezCommon_cross_dialogArguments[1];
							} else {
								RetValue = parent.ezreceivejijungall_cross_dialogArguments[0];
							}
						}else{
							RetValue = parent.ezreceiveassignui_cross_dialogArguments[0];
							ReturnFunction = parent.ezreceiveassignui_cross_dialogArguments[1];
						}
	                } catch (e) {
	                    try {
							if(mode == 'ALL'){
								RetValue = opener.ezreceivejijungall_cross_dialogArguments[0];
							}else{
								RetValue = opener.ezreceiveassignui_cross_dialogArguments[0];
								ReturnFunction = opener.ezreceiveassignui_cross_dialogArguments[1];
							}
	                    } catch (e) {
	                        RetValue = window.dialogArguments;
	                    }
	                }
	
	                pDocID = RetValue[0];
	                pReceiveSN = RetValue[1];
	                pAprSate = RetValue[2];
					pDocState = RetValue[3];
					isReDraft = RetValue[4];
					orgCompanyID = RetValue[5];

					if(mode == 'ALL'){
						var Rdata = pReceiveSN.split(','); // 각 요소에 조건 적용 
						for (var i = 0; i < Rdata.length; i++) {
							if (Rdata[i] == "s") {
								Rdata[i] = "1"; 
							} else {
								Rdata[i] = Rdata[i].replace("s", "");
							} 
						}
						pReceiveSN = Rdata.join(',');
					}else{
						if (pReceiveSN == "s")
							pReceiveSN = "1";
						else
							pReceiveSN = pReceiveSN.replace("s", "");
					}
	                InitTreeVal = arr_userinfo[4];
	                Tree_setconfig();
	                TreeViewinitialize(InitTreeVal, "<c:out value ='${userInfo.companyID}'/>", "", "<c:out value ='${serverName}'/>");
	
	                var listview = new ListView();
	                listview.SetID("OrganList");
	                listview.SetMulSelectable(false);
					if(mode == 'ALL'){
						listview.SetRowOnDblClick("jijungALL_onclick");
					}else{
						listview.SetRowOnDblClick("btnAssign_onclick");
					}
	                /* 2023-01-30 홍승비 - 부서수신함 > 접수 > 수신자 지정 레이어 팝업 > 리스트뷰의 첫번째 row가 자동선택되지 않도록 수정 (대부분의 사용자지정화면 리스트뷰 UI와 통일, 지정 실수 방지) */
	                listview.SetSelectFlag(false);
	
	                if (CrossYN())
	                    listview.DataSource(listviewheader);
	                else {
	                    var objXML = createXmlDom();
	                    objXML = loadXMLString(listviewheader.xml);
	                    listview.DataSource(objXML);
	                }
	
	                listview.DataBind("OrganListView");
	
	                if (!CrossYN())
	                    window.returnValue = "cancel";
	
	            } catch (ErrMsg) {
	            showAlert("window_onload : " + ErrMsg.description);
	        }
	    };
	    function Tree_setconfig() {
	        var xmlHTTP = createXMLHttpRequest();
	        xmlHTTP.open("GET", "/xml/organtree_config.xml", false);
	        xmlHTTP.send();
	
	        if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
	            var treeView = new TreeView();
	            treeView.SetConfig(xmlHTTP.responseXML);
	        }
	    }
	    function btnAssign_onclick() {
	        try {
	        	var result = "";
	        	if (approvalFlag == "S" && isReDraft != undefined && isReDraft == "Y") {
	        		$.ajax({
			    		type : "POST",
			    		dataType : "text",
			    		async : false,
			    		url : "/ezApprovalG/checkAprState.do",
			    		data : {
			    			docID : pDocID,
			    			docState : pDocState,
			    			userID : '',
			    			aprMemberSN : pReceiveSN,
			    			orgCompanyID : orgCompanyID
			    		},
			    		success : function(text) {
			    			result = text;
			    		}
			    	});
	        		if (result == "FALSE") {
	        			// if (ReturnFunction != null) {
                        //     ReturnFunction("DUPL");
                        // }
                        // else {
                        //     window.returnValue = "DUPL";
                        //     window.close();
                        // }
						btnClose_onclick("DUPL");
		    			return;
	        		}
	        	}
	            var listview = new ListView();
	            listview.LoadFromID("OrganList");
	            var pCurSelRow = listview.GetSelectedRows();
	            if (pCurSelRow.length == 0) {
	                var pAlertContent = "<spring:message code='ezApprovalG.t425'/>";
	                OpenAlertUI(pAlertContent);
	            }
	            else { // G버전
	                if (trim_Cross(pCurSelRow[0].getAttribute("DATA3")) == InitTreeVal 
							|| checkIdInList(trim_Cross(pCurSelRow[0].getAttribute("DATA3")))) { // 상위부서문서함 사용중인 부서인지 확인
	                    var RtnVal = setReceiveAssign(pCurSelRow);
	                    if (RtnVal == "TRUE") {
	                        // if (ReturnFunction != null) {
	                        //     ReturnFunction("OK");
	                        // }
	                        // else {
	                        //     window.returnValue = "OK";
	                        //     window.close();
	                        // }
							btnClose_onclick("OK")
	                    } else {
	                        var pAlertContent = "<spring:message code='ezApprovalG.t426'/>";
	                        OpenAlertUI(pAlertContent);
	                    }
	                }
	                else {
	                    var pAlertContent = "<spring:message code='ezApprovalG.t225'/>";
	                    OpenAlertUI(pAlertContent);
	                    return;
	                }
	            }
	        } catch (ErrMsg) {
	            showAlert(ErrMsg.description);
	        }
	    }
	    // function btnCancel_onclick() {
	    //     if (ReturnFunction != null) {
	    //         ReturnFunction("cancel");
	    //     }
	    //     else {
	    //         window.returnValue = "cancel";
	    //         window.close();
	    //     }
	    // }
	    function setReceiveAssign(pCurSelRow) {
	    	
	        try {
	        	var result = "";

				/* 2024-07-18 양지혜 - 상위부서문서함을 사용하고 있는 부서원 지정 처리 */
				// 기본 : 선택한 사용자의 부서정보
				var receivedDeptID = trim_Cross(pCurSelRow[0].getAttribute("DATA3"));
				var receivedDeptName = trim_Cross(pCurSelRow[0].getAttribute("DATA12"));
				if (parent.upperDeptCode !== "" && parent.upperDeptCode !== undefined) { // 현재부서가 상위부서문서함 사용 : 상위부서정보로 진행
					receivedDeptID = parent.upperDeptCode;
					receivedDeptName = parent.upperDeptName;
				} else if (parent.upperDeptCode === "" && parent.allowDeptIDs !== "") { // 현재부서를 상위부서문서함으로 사용 : 현재부서(상위부서) 정보로 진행
					receivedDeptID = arr_userinfo[4];
					receivedDeptName = arr_userinfo[5];
				}
	        	
	            $.ajax({
	        		type : "POST",
	        		dataType : "text",
	        		async : false,
	        		url : "/ezApprovalG/setJijung.do",
	        		data : {
	        			docID : pDocID,
	        			receiveSN : pReceiveSN,
	        			processorID : trim_Cross(pCurSelRow[0].getAttribute("DATA2")),
	        			processorName : trim_Cross(pCurSelRow[0].getAttribute("DATA8")),
	        			processorJobTitle : trim_Cross(pCurSelRow[0].getAttribute("DATA10")),
	        			receivedDeptID : receivedDeptID,
	        			receivedDeptName : receivedDeptName,
	        			docState : pAprSate,
	        			processorName2 : trim_Cross(pCurSelRow[0].getAttribute("DATA9")),
	        			processorJobTitle2 : trim_Cross(pCurSelRow[0].getAttribute("DATA11")),
	        			receivedDeptName2 : trim_Cross(pCurSelRow[0].getAttribute("DATA13"))
	        		},
	        		success: function(xml){
	        			result = loadXMLString(xml);
	        		}        			
	        	});
	            
	            return getNodeText(GetChildNodes(result)[0]);
	        } catch (ErrMsg) {
	            showAlert(ErrMsg.description);
	        }
	    }
	    function btn_searchUser_onclick() {
	        try {
	            var strSearch = document.getElementById("textUser").value + "";
	            if (textUser.value == "") {
	                var pAlertContent = "<spring:message code='ezApprovalG.t226'/>";
	                OpenAlertUI(pAlertContent);
	                TreeViewNodeClick();
	            }
	            else if (strSearch.length < 2) {
	                var pAlertContent = "<spring:message code='ezApprovalG.t227'/>";
	                OpenAlertUI(pAlertContent);
	                textUser.focus();
	            }
	            else {
                	$.ajax({
                		type : "POST",
                		dataType : "text",
                		async : true,
                		url : "/ezOrgan/getSearchList.do",
                		data : {
                			search : "displayname::" + strSearch + ";;physicalDeliveryOfficeName::" + "<c:out value ='${userInfo.companyID}'/>",
                			cell   : "displayname;title;description;telephonenumber",
                			prop   : "department;extensionAttribute4;displayname;title;description",
                			type   : "user"
                		},
                		success: function(xml){
                			event_displayUserList(loadXMLString(xml));
                		}        			
                	});
	            }
	    } catch (ErrMsg) {
	        showAlert(ErrMsg.description);
	    }
	}
	function textUser_onkeypress() {
	    if (window.event.keyCode == "13") {
	    	btn_searchUser_onclick();
	        btn_searchUser.focus();
	    }
	
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
	function TreeViewNodeClick() {
	    var treeView = new TreeView();
	    treeView.LoadFromID("FromTreeView");
	    var nodeIdx = treeView.GetSelectNode();
	    displayUserList(nodeIdx.GetNodeData("CN"));
	}
	function displayUserList(DeptID) {
		$.ajax({
			type : "POST",
			dataType : "text",
			async : true,
			url : "/ezOrgan/getDeptMemberList.do",
			data : {
					deptID   : DeptID, 
					cell 	 : "displayName;title;description;telephoneNumber",
					prop     : "department;extensionAttribute4;displayName;title;description",
					type 	 : "user"
					},
			success: function(xml){
				event_displayUserList(loadXMLString(xml));
			}        			
		});
		
	}
	function event_displayUserList(xml) {
         if (SelectNodes(xml, "LISTVIEWDATA/ROWS/ROW").length > 0) {
             var listview = new ListView();
             listview.LoadFromID("OrganList");
             listview.SetSelectFlag(false);
             listview.DataSource(xml);
             listview.RowDataBind();
         }
         else {
             document.getElementById("OrganListView").innerHTML = "";
             var listview = new ListView();
             listview.SetID("OrganList");
             listview.SetMulSelectable(false);
             listview.SetRowOnDblClick("btnAssign_onclick");
             listview.SetSelectFlag(false);
             listview.DataSource(listviewheader);
             listview.DataBind("OrganListView");
         }

        textUser.focus();
	}
	function TreeViewNodeDbClick(pNodeID, pTreeID) {
	    var TreeIdx = pNodeID;
	
	    var treeNode = new TreeNode();
	    treeNode.LoadFromID(TreeIdx);
	
	    var deptID = treeNode.GetNodeData("CN");
	
	    GetDeptSubTreeInfo(deptID, TreeIdx);
	
	}
	
	function jijungALL_onclick(){
		try {
			var listview = new ListView();
			listview.LoadFromID("OrganList");
			var selectRows = listview.GetSelectedRows();

			if (selectRows.length == 0) {
				var pAlertContent = "<spring:message code='ezApprovalG.t425'/>";
				OpenAlertUI(pAlertContent);
			} else {
				if (trim_Cross(selectRows[0].getAttribute("DATA3")) == InitTreeVal) {
					showLoadingProgress();
					setTimeout(function() {
						$.ajax({
							type : "POST",
							dataType : "text",
							async : false,
							url : "/ezApprovalG/setJijungALL.do",
							data : {
								docID : pDocID,
								receiveSN : pReceiveSN,
								processorID : trim_Cross(selectRows[0].getAttribute("DATA2")),
								processorName : trim_Cross(selectRows[0].getAttribute("DATA8")),
								processorJobTitle : trim_Cross(selectRows[0].getAttribute("DATA10")),
								receivedDeptID : trim_Cross(selectRows[0].getAttribute("DATA3")),
								receivedDeptName : trim_Cross(selectRows[0].getAttribute("DATA12")),
								processorName2 : trim_Cross(selectRows[0].getAttribute("DATA9")),
								processorJobTitle2 : trim_Cross(selectRows[0].getAttribute("DATA11")),
								receivedDeptName2 : trim_Cross(selectRows[0].getAttribute("DATA13"))
							},
							success: function(res){
												hideLoadingProgress();
												var arrRtnVal = res.split("/");
												var pAlertContent = strLang933 + (Number(arrRtnVal[0])) + strLang934_1 + "<br/>";
												if (arrRtnVal[1] != 0) {
																	pAlertContent += strLang935 + arrRtnVal[1] + strLang934_1;
												}
												
												if (arrRtnVal[2] != 0) {
													if (arrRtnVal[1] != 0) {
															pAlertContent += " / ";
													}
													pAlertContent += strLang938 + arrRtnVal[2] + strLang934_1;
												}
								
												if (arrRtnVal[3] != 0) {
													if (arrRtnVal[1] != 0 || arrRtnVal[2] != 0) {
														pAlertContent += " / ";
													}
													pAlertContent += strLang936 + arrRtnVal[3] + strLang934_1;
												}
												pAlertContent += "<br/>" + "<spring:message code='ezApprovalG.t1420'/>";
	
												// if (window.opener && window.opener.pListTypeValue) {
												// 	if (window.opener.pListTypeValue == "97") {
												// 		window.opener.parent.frames[0].convMain('97', '');
												// 	} else {
												// 		window.opener.parent.frames[0].convMain('4', '');
												// 	}
												// }
								OpenAlertUI(pAlertContent, () => btnClose_onclick("true"));
							
							}
						});
					}, 0);
				}  else {
					var pAlertContent = "<spring:message code='ezApprovalG.t225'/>";
					OpenAlertUI(pAlertContent);
					return;
				}
			}
		} catch (ErrMsg) {
			showAlert(ErrMsg.description);
		}
	}

	function checkIdInList (checkID) {
		if (typeof parent.allowDeptIDs === "undefined") {
			return false;
		} else {
			var idList = parent.allowDeptIDs.split(";").filter(id => id !== '');
			return idList.includes(checkID);
		}
	}
	</script>
	<style>
	   .mainlist tr th {border-top:0px}
	</style>
	</head>
	<body class="popup">
	    <xml id="listviewheader" style="display: none">
			<LISTVIEWDATA>
				<HEADERS>
					<HEADER>
						<NAME><spring:message code='ezApprovalG.t229'/></NAME>
						<WIDTH>50</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code='ezApprovalG.t230'/></NAME>
						<WIDTH>50</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code='ezApprovalG.t108'/></NAME>
						<WIDTH>70</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code='ezApprovalG.t231'/></NAME>
						<WIDTH>70</WIDTH>
					</HEADER>
				</HEADERS>
			</LISTVIEWDATA>
		</xml>
	    <h1><spring:message code='ezApprovalG.t424'/></h1>
		<div id="close">
            <ul>
				<c:if test="${mode == 'ALL'}"> <li><span onclick="return btnClose_onclick();"></span></li> </c:if> 
				<c:if test="${mode != 'ALL'}"> <li><span onclick="return btnClose_onclick('cancel');"></span></li> </c:if>
            </ul>
        </div>
	    <table style="margin-top: -15px;">
	        <tr>
	            <td style="vertical-align: top;">
	                <h2 class="h2_dot" style="margin-top:7px;"><spring:message code='ezApprovalG.t232'/></h2>
	                <div class="box" style="overflow: auto; height: 470px; width: 380px" id="TreeView"></div>
	            </td>
	            <td style="vertical-align: top;padding-left:10px;">
	                <h2 class="h2_dot" style="margin-top:7px;float:left"><spring:message code='ezApprovalG.t233'/></h2>
	                <div style="float:right;margin-top:6px;vertical-align: top">
	                	<input type="text" id="textUser" name="textUser" style="width: 130px;height:21px;border:1px solid #aaa" value="" onkeypress="return textUser_onkeypress()" tabindex="1"><a class="imgbtn imgbck" style="margin-left:5px;"><span id="btn_searchUser" onkeypress="return btn_searchUser_onclick()" onclick="return btn_searchUser_onclick()"><spring:message code='ezApprovalG.t234'/></span></a>
	                </div>
	                <div style="clear:both"></div>
	                <div class="listview">

	                    <div id="OrganListView" style="border: 0; Width: 385px; Height: 472px; overflow: auto;"></div>

	                </div>	                
	            </td>
	        </tr>
	    </table>
	    <div class="btnposition btnpositionNew">
			<c:if test="${mode == 'ALL'}"> <a class="imgbtn"><span onclick="return jijungALL_onclick()"><spring:message code='ezApprovalG.t20'/></span></a> </c:if>
			<c:if test="${mode != 'ALL'}"> <a class="imgbtn"><span onclick="return btnAssign_onclick()"><spring:message code='ezApprovalG.t20'/></span></a> </c:if>
		</div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<div style="width: 200px; height: 50px; border: 0px solid red; text-align: center; vertical-align: middle; display: none; z-index: 9000; position: absolute;" id="loadingLayer">
			<img src="/images/email/progress_img.gif" style="vertical-align: middle;" />
		</div>
	</body>
</html>