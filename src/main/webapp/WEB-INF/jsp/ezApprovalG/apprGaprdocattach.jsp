<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE HTML>
<html>
	<head>
	    <title><spring:message code='ezApprovalG.t364'/></title>    
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/aprDocAttach_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Pagenation_Cross.js')}"></script>
	    <script id="clientEventHandlersJS" type="text/javascript">
	        var xmlhttp = createXMLHttpRequest();
	        var xmldoc = createXmlDom();
	        var approvalFlag = "<c:out value ='${approvalFlag}'/>";
	        var Check = false;
	        var NodeList, curpage, nowblock, totalPage, block, p_page, p_nowblock, NodeListLen, Init_Flag, pChackYN, subCondition;
	        var DocListType = "getDocList";
	        var NodeList2, PageSize, ListView, ScontID;
	        var pUserName, pUserJobTitle, pDeptID, pDeptName, pCompanyID, pDocID;
	        var arr_userinfo = new Array();
	        var OrderCell = "";
	        arr_userinfo[0] = "user";
		    arr_userinfo[1]  = "<c:out value ='${userInfo.id}'/>";
		    arr_userinfo[2]  = "<c:out value ='${userInfo.displayName}'/>";
		    arr_userinfo[3]  = "<c:out value ='${title}'/>";
		    arr_userinfo[4]  = "<c:out value ='${userInfo.deptID}'/>";
		    arr_userinfo[5]  = "<c:out value ='${userInfo.deptName}'/>";
		    arr_userinfo[6]  = "<c:out value ='${userInfo.jikChek}'/>";
	        arr_userinfo[7] = "N";
	        arr_userinfo[8]  = "<c:out value ='${userInfo.email}'/>";
	        arr_userinfo[9] = "";
	        arr_userinfo[10] = "<c:out value ='${susinAdmin}'/>";
	        arr_userinfo[11]  = "<c:out value ='${userInfo.displayName1}'/>";
		    arr_userinfo[12]  = "<c:out value ='${userInfo.displayName2}'/>";
		    arr_userinfo[13]  = "<c:out value ='${userInfo.title1}'/>";
		    arr_userinfo[14]  = "<c:out value ='${userInfo.title2}'/>";
		    arr_userinfo[15]  = "<c:out value ='${userInfo.deptName1}'/>";
		    arr_userinfo[16]  = "<c:out value ='${userInfo.deptName2}'/>";
		    var companyID = "<c:out value ='${userInfo.companyID}'/>";       
		 	var orgCompanyID = "<c:out value ='${orgCompanyID}'/>";
	        /*2021-03-05 남학선 첨부를 올린사람 이외의 사람도 삭제가능여부를  결정하는 값*/
	        var delAttachByOthers = "<c:out value ='${delAttachByOthers}'/>";
			var useWebHWP = "<c:out value='${useWebHWP}'/>";
		 	
	        subCondition = "";

			/* Header sorting variable */
			var SortHeader;
			var sortType = "asc";

			var orgResultxml;

            // 일괄기안 관련 변수 추가
            var draftAllFlag = "<c:out value ='${draftAllFlag}'/>";
            var anNo = "<c:out value ='${anNo}'/>";
	        
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
	
	        var ReturnFunction;
	        window.onload = function () {
	            pUserID = arr_userinfo[1];
	            pUserName = arr_userinfo[2];
	            pUserJobTitle = "<c:out value ='${title }'/>";
	            pDeptID = "<c:out value ='${detpID }'/>";
	            pDeptName = "<c:out value ='${detpNM }'/>";
// 	            pUserID = arr_userinfo[1];
// 	            pUserName = arr_userinfo[2];
// 	            pUserJobTitle = arr_userinfo[3];
// 	            pDeptID = arr_userinfo[4];
// 	            pDeptName = arr_userinfo[5];
	
	            if (CrossYN()) {
	                pDocID = parent.aprcabinetattach_cross_dialogArguments[0];
	                ReturnFunction = parent.aprcabinetattach_cross_dialogArguments[1];
	            }
	            else {
	                pDocID = window.dialogArguments;
	            }
	            pCompanyID = "<c:out value ='${userInfo.companyID}'/>";
	            getDocType();
	            PageSize = 10;
	            pChackYN = "FALSE";
	            getDocList();
	            AttachList();
	            
	            if (parent.pOrgDocID != '') {
	            	orgResultxml = orgAttachList(parent.pOrgDocID);
	            	if (orgResultxml != null && SelectNodes(orgResultxml, "LISTVIEWDATA/ROWS/ROW").length > 0) {
	            		var DocList = new ListView();
			            DocList.LoadFromID("lvTDocList");
			            var attachSel = DocList.GetDataRows();
			            var length = attachSel.length;
			            for (var i = 0; i < length; i++) {
			            	var href = GetAttribute(attachSel[i], "data1");
			            	for (var j = 0; j < SelectNodes(orgResultxml, "LISTVIEWDATA/ROWS/ROW").length; j++) {
			            		var orgHref = getNodeText(GetChildNodes(GetChildNodes(SelectNodes(orgResultxml, "LISTVIEWDATA/ROWS/ROW")[j])[0])[1]);
								if (href == orgHref) {
									SetAttribute(attachSel[i], "DELETE", "N");
									break;
								}
			            	}
			            }
	            	}
	            }
				
				if (navigator.maxTouchPoints > 4 || isTeamsDesktop()) {
					document.getElementById("lvSDoc").style.width = document.getElementById("tableSizeChk").offsetWidth - 340 + "px";
				}
	        }
	        function lvTDoc_onSel_Click() {
	            var listview = new ListView();
	            listview.LoadFromID("lvTDocList");
	            if (arr_userinfo[1] != trim_Cross(GetAttribute(listview.GetSelectedRows()[0], "userid")))
	                arrow_left.Enable = "false";
	            else
	                arrow_left.Enable = "true";
	        }
	        
	        function bt_selSContName_onclick() {
	            ScontID = selSContName.value;
	            if (DocListType == "GetDocSearch") {
	            	
					/* 2022-08-05 홍승비 - 문서함 선택 시, 검색조건 배열 길이에 따라 동적으로 초기화시키도록 수정 + 검색조건 생성 함수도 한번만 동작하도록 수정 */
					var conLength = condition.length;
					for (var i = 0; i < conLength; i++) {
	                    condition[i] = "";
					}
	                MakeSubCondition();
	                GetDocSearch();
	            }
	            else
	                getDocList();
	        }
	        function btnIns_onclick() {
	            DocMove();
	        }
	        function btndel_onclick() {
	            var listview = new ListView();
	            listview.LoadFromID("lvTDocList");
	            var selRow;
	            var count1;
	            var pCurSel = listview.GetSelectedRows();
	            var plength = pCurSel.length;
	            var plength2 = listview.GetDataRows().length;
	            if (plength <= 0) {
	            	OpenAlertUI("<spring:message code='ezApprovalG.t360'/>");
	            	return;
	            }
	            
	            for (var i = 0; i < plength; i++) {
	            	if (typeof(GetAttribute(pCurSel[i], "DELETE")) != "undefined" && GetAttribute(pCurSel[i], "DELETE") == "N") {
	            		OpenAlertUI("<spring:message code='ezApprovalG.t365'/>");
	            		return;
	            	}
	            }
	            
	            var userCheck = true;
	            for (var i = 0; i < plength; i++) {
	            	if (arr_userinfo[1].toLowerCase() != trim_Cross(GetAttribute(pCurSel[i], "DATA4")).toLowerCase()) {
	            		userCheck = false;
	            		break;
	            	}
	            }
	            
	            if (!userCheck) {
	            	if(delAttachByOthers == "0"){
	            		OpenAlertUI("<spring:message code='ezApprovalG.t365'/>");
		                return;	            		
	            	} else {
		                if (plength > 0 && plength2 > 0) {
		                    for (count1 = plength; count1 > 0; count1--) {
		                        selRow = listview.GetSelectedRows()[count1 - 1];
		                        listview.DeleteRow(GetAttribute(selRow, "id"));
		                    }
		                    if (listview.GetDataRows().length == 0){
		                    	$("#lvTDoc tbody").append("<tr id='lvTDocList_TR_noItems'><td align='center' colspan='1'>" + strLang944 + "</td></tr>");
		                    }
		                }
		                else
		                	OpenAlertUI("<spring:message code='ezApprovalG.t360'/>");   		
	            	}
	            }
	            else {
	                if (plength > 0 && plength2 > 0) {
	                    for (count1 = plength; count1 > 0; count1--) {
	                        selRow = listview.GetSelectedRows()[count1 - 1];
	                        listview.DeleteRow(GetAttribute(selRow, "id"));
	                    }
	                    if (listview.GetDataRows().length == 0){
	                    	$("#lvTDoc tbody").append("<tr id='lvTDocList_TR_noItems'><td align='center' colspan='1'>" + strLang944 + "</td></tr>");
	                    }
	                }
	                else
	                	OpenAlertUI("<spring:message code='ezApprovalG.t360'/>");
	            }
	        }
	        function bt_OK_onclick() {
	            var listview = new ListView();
	            listview.LoadFromID("lvTDocList");
	            var length = listview.GetDataRows().length;
	            if (length > 0) {
	                var tr = listview.GetDataRows();
	                if (tr[0].id.indexOf("noItems") > 0) {
	                    length = 0;
	                    delAttachDoc();
	                    window.close();
	                }
	
	                var AprDocAttachxml = DocMoveParser();

                    if (draftAllFlag == "Y") {
                        parent.pHasDocAttachYN = "Y";
                        parent.pHasDocAttachYNAry[anNo] = "Y";
                    }

	                if (CrossYN()) {
	                    ReturnFunction(AprDocAttachxml);
	                }
	                else {
	                    window.returnValue = AprDocAttachxml;
	                    window.close();
	                }
	            }
	            else {
	                delAttachDoc();
	                var AprDocAttachxml = DocMoveParser();

                    if (draftAllFlag == "Y") {
                        parent.pHasDocAttachYN = "N";
                        parent.pHasDocAttachYNAry[anNo] = "N";
                    }

	                if (CrossYN()) {
	                    ReturnFunction(AprDocAttachxml);
	                }
	                else {
	                    window.returnValue = AprDocAttachxml;
	                    window.close();
	                }
	            }
	        }
	        function bt_Cancel_onclick() {
	            if (CrossYN()) {
	                ReturnFunction("cancel");
	            }
	            else {
	                window.returnValue = "cancel";
	                window.close();
	            }            
	        }
	
	        var condition = new Array();
	        var setsearchinfo_cross_dialogArguments = new Array();
	        function SearchCondi_onclick() {
	            var para;
	            var url = "/ezApprovalG/setSearchInfo.do";
	
	            if (CrossYN()) {
	            	setsearchinfo_cross_dialogArguments[0] = "";
	            	setsearchinfo_cross_dialogArguments[1] = SearchCondi_Complete;
	                DivPopUpShow(510, 405, url);
	            }
	            else {
	                var feature = "dialogWidth:510px;dialogHeight:495px;status:no;scroll:no;edge:sunken"
	                feature = feature + GetShowModalPosition(510, 495);
	                condition = window.showModalDialog(url, para, feature);
	                if (condition) {
	                    MakeSubCondition();
	                    GetDocSearch();
	                }                
	            }
	        }
	        function SearchCondi_Complete(RtnVal)
	        {
	            if (RtnVal) {
	                condition = RtnVal;
	                MakeSubCondition();
	                GetDocSearch();
	            }            
	            DivPopUpHidden();
	        }

			function showDocView_onclick() {
				var listview = new ListView();
				listview.LoadFromID("lvSDocList");
				var selRow = listview.GetSelectedRows()[0];

				if (typeof selRow == "undefined" || selRow.length <= 0) {
					var pAlertContent = "<spring:message code='ezApprovalG.t1533'/>";
					showAlert(pAlertContent);
					return;
				}
				showDocView_onclick_Complete("True");
			}

			function showDocView_onclick_Complete() {
				var listview = new ListView();
				listview.LoadFromID("lvSDocList");
				var selRow = listview.GetSelectedRows()[0];
				var DocID = GetAttribute(selRow, "DATA1");
				var pURL = GetAttribute(selRow, "DATA2");
				var orgdocid = trim_Cross(selRow.getAttribute("DATA5"));
				var formid = selRow.getAttribute("DATA6");
				var docState =  selRow.getAttribute("DATA7");
				var openLocation;
				var tempURL = pURL;

				if (tempURL.substr(tempURL.length - 4, tempURL.length).toLowerCase() == ".ezd") {
					tempURL = tempURL.substr(0, tempURL.length - 4);
				}

				if (tempURL.substr(tempURL.length - 3, tempURL.length).toLowerCase() == "hwp" && useWebHWP == "NO" && !isIE()) {
                    var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
                    showAlert(pAlertContent);
                    return;
				}
                openLocation = "/ezApprovalG/view.do?docID=" + encodeURI(DocID);
				openwindow(openLocation, "", 880, 570);
			}
			
			function moveDataRow(e) {
				let listView = new ListView();
				listView.LoadFromID("lvTDocList");

				var msg = checkIsValidReq(listView, e);

				if (!msg) {
					return;
				}

				relocateAttachedList(listView, e);
			}

			function checkIsValidReq(listView, e) {
				let bool = false;
				let selectedRow = listView.GetSelectedRows();
				let selectedRowCnt = selectedRow.length;
				let curIdx;

				if (selectedRowCnt == 0) {
					alert("<spring:message code = 'ezApprovalG.docAttach.msg1' />");

					return;
				} else if (selectedRowCnt >= 2) {
					alert("<spring:message code = 'ezApprovalG.docAttach.msg2' />");

					return;
				}

				selectedRow = selectedRow[0];
				curIdx = selectedRow.getAttribute("data2");

				switch (e) {
					case "up" : {
						bool = curIdx != 1;

						break;
					}

					case "down" : {
						bool = curIdx < listView.GetDataRows().length;

						break;
					}
				}

				return bool;
			}

			function relocateAttachedList(listView, e) {
				let curIdx = parseInt(listView.GetSelectedIndexes());
				let destIdx;

				switch (e) {
					case "up" : {
						destIdx = curIdx - 1;
						break;
					}

					case "down" : {
						destIdx = curIdx + 1;
						break;
					}
				}

				moveRow(listView, curIdx, destIdx);
			}

			function moveRow(listView, curIdx, destIdx) {
				let attachedList = listView.GetDataRows();
				
				if (destIdx < 0 || destIdx >= attachedList.length) {
					return;
				}
				
				let tbody = document.getElementById(listView.GetID()).querySelector("tbody");
				let tmp1 = attachedList[curIdx];
				let tmp2 = attachedList[destIdx];
				let newNode;

				attachedList[curIdx] = tmp2;
				attachedList[destIdx] = tmp1;

				tbody.replaceChildren();

				var cnt = 0;
				while ((newNode = attachedList[cnt]) != null) {
					tbody.insertAdjacentElement("beforeend", newNode);
					newNode.setAttribute("data2", cnt + 1);

					cnt++;
				}
			}
			
			innerIfrmaeOffset();
			
			window.addEventListener("resize", function() {
				if (navigator.maxTouchPoints > 4 || isTeamsDesktop()) {
					document.getElementById("lvSDoc").style.width = document.getElementById("tableSizeChk").offsetWidth - 340 + "px";
				}
			})
	    </script>
	    <style>
			.mainlist tr th {border-top:0px}
			#lvSDocList_TR_noItems td {
				text-align:left;
				padding-left:300px;
			}
		</style>
	</head>
	<body class="popup">
		<xml id='FORMLIST' style="display: none">
			<LISTVIEWDATA>
		    	<HEADERS>
		      		<HEADER>
		        		<NAME><spring:message code='ezApprovalG.t362'/></NAME>
		        		<WIDTH>165</WIDTH>
		      		</HEADER>
		    	</HEADERS>
		  	</LISTVIEWDATA>
		</xml>
	    <h1 id="tableSizeChk"><spring:message code='ezApprovalG.t364'/></h1>
	    <div id="close">
            <ul>
                <li><span onclick="return bt_Cancel_onclick()"></span></li>
            </ul>
        </div>
	    <table>
	        <tr>
	            <td style="padding-bottom: 5px; width: 350px;">
	                <h2><spring:message code='ezApprovalG.t366'/>
	                    <select id="selSContName" name="selSContName" onchange="return bt_selSContName_onclick()" style="height:22px"></select>
	                    <a class="imgbtn imgbck"><span id="SearchCondi" onclick="return SearchCondi_onclick()" style="font-weight: normal"><spring:message code='ezApprovalG.t111'/></span></a>
	                    <a class="imgbtn imgbck"><span onclick="return showDocView_onclick()" style="font-weight: normal"><spring:message code='ezApprovalG.t367'/></span></a>
					</h2>
	            </td>
	            <td style="text-align: right; white-space: nowrap; float: right; margin-top: 10px;">
	                <table style="border: 0; border-collapse: collapse; border-spacing: 0; padding: 0px; text-align: right;">
	                    <tr id="PageNum"></tr>
	                </table>
	            </td>
	            <td>&nbsp;</td>
	            <td>
					<a class = "imgBtn" onclick = "moveDataRow('up')" style="height:22px; margin : 0 5px 0 0;">
						<span>
							<img src="/images/ImgIcon/prev.gif" alt="" style="width : 20px; margin-top: 4px;">
						</span>
					</a>

					<a onclick = "moveDataRow('down')">
						<span>
							<img src="/images/ImgIcon/next.gif" alt="" style="width : 20px; margin-top: 4px;">
						</span>
					</a>
				</td>
	        </tr>
	        <tr>
	            <td colspan="2" style="vertical-align: top;">
	                <div class="listview">
	                    <div id="lvSDoc" style="BORDER: 0; WIDTH: 690px; HEIGHT: 365px; overflow-x: auto"></div>
	                </div>
	            </td>
	            <td style="width: 25px; text-align: center; margin-top: 3px;">
	                <img src="/images/arr_right.gif" style="cursor: pointer" width="16" height="16" id="arrow_right" onclick="return btnIns_onclick()"><img src="/images/arr_left.gif" style="cursor: pointer" width="16" height="16" id="arrow_left" onclick="return btndel_onclick()">
	            </td>
	            <td style="width: 310px; vertical-align: top;">
	                <div class="listview" style="WIDTH: 310px; HEIGHT: 365px">
	                    <div id="lvTDoc" style="BORDER: 0; WIDTH: 310px; HEIGHT: 365px; overflow-x: hidden"></div>
	                </div>
	            </td>
	        </tr>
	    </table>
	    <div class="btnposition btnpositionNew">
	        <a class="imgbtn" onclick="return bt_OK_onclick()"><span><spring:message code='ezApprovalG.t1760'/></span></a>
	    </div>
	
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>
