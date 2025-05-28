<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezApprovalG.t359'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/aprCabinetAttach_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getContainerInfo_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CabinetInfo_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CabRoleInfo_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/MiscFunc_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezCabinet_Cross.js')}"></script>
	    <script id="clientEventHandlersJS" type="text/javascript">
	        var OrderCell = "";
	        var xmlhttp = createXMLHttpRequest();
	        var xmldoc = createXmlDom();
	        var Check = false;
	        var NodeList, curpage, nowblock, totalPage, block, p_page, p_nowblock, NodeListLen, Init_Flag, pChackYN, DocListType;
	        var NodeList2, PageSize, ListView, ScontID, jobState;
	        var pUserName, pUserJobTitle, pDeptID, pDeptName, pCompanyID, pDocID;
	        var pUserName2, pUserJobTitle2, pDeptName2;
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
	        arr_userinfo[11] = "<c:out value ='${userInfo.displayName1}'/>";
	        arr_userinfo[12] = "<c:out value ='${userInfo.displayName2}'/>";
	        arr_userinfo[13] = "<c:out value ='${userInfo.title1}'/>";
	        arr_userinfo[14] = "<c:out value ='${userInfo.title2}'/>";
	        arr_userinfo[15] = "<c:out value ='${userInfo.deptName1}'/>";
	        arr_userinfo[16] = "<c:out value ='${userInfo.deptName2}'/>";
	        var DeptID, deptName, UserID, AdminYN, CompanyID, PageSize, Block_Size;
	        var deptName2;
	        var UserLang = "<c:out value ='${userInfo.lang}'/>";
	        var RetValue;
	        var ReturnFunction;
	        var pDraftFlag = "<c:out value ='${draftFlag}'/>";
	        var approvalFlag = "<c:out value ='${approvalFlag}'/>";
			//페이징이 달라 구분값 추가
			var diffPaging = "attachDoc";
			// 일괄기안 관련 변수 추가
			var draftAllFlag = "<c:out value ='${draftAllFlag}'/>";
			var anNo = "<c:out value ='${anNo}'/>";
			var selRowChangeFlag = false;
			var cabinetAttachPage = true; // 문서 첨부 검색 페이지에서 의견 아이콘 삭제하기 위해 추가
			var orgResultxml;
			var useWebHWP = "<c:out value='${useWebHWP}'/>";
	        
	        window.onload = function () {
	            var ua = navigator.userAgent;
	            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
	                KeEventControl(document.getElementById("txt_PageInputNum"));
	            }
	            pUserID = "<c:out value ='${userInfo.id}'/>";
	            pUserName = arr_userinfo[2];
	            pUserJobTitle = arr_userinfo[3];
	            pDeptID = arr_userinfo[4];
	            pDeptName = arr_userinfo[5];
	
	            try {
	                RetValue = parent.aprcabinetattach_cross_dialogArguments[0];
	                ReturnFunction = parent.aprcabinetattach_cross_dialogArguments[1];
	            } catch (e) {
	                try {
	                    RetValue = opener.aprcabinetattach_cross_dialogArguments[0];
	                    ReturnFunction = opener.aprcabinetattach_cross_dialogArguments[1];
	                } catch (e) {
	                    RetValue = window.dialogArguments;
	                }
	            }
	
	            pDocID = RetValue;
	            pCompanyID = "<c:out value ='${userInfo.companyID}'/>";
	            pUserName2 = arr_userinfo[11];
	            pUserJobTitle2 = arr_userinfo[12];
	            pDeptName2 = arr_userinfo[13];
	            DeptID = pDeptID;
	            UserID = pUserID;
	            deptName = pDeptName;
	            deptName2 = pDeptName2;
	            CompanyID = pCompanyID;
	            PageSize = 10;
	            Block_Size = 10;
	            InitGlobals("RECORD", "9", "1");
	            GetRecordList_lv();
	            AttachList();
	            
	            if (parent.pOrgDocID != '') {
	            	orgResultxml = orgAttachList(parent.pOrgDocID);
	            	if (orgResultxml != null && SelectNodes(orgResultxml, "LISTVIEWDATA/ROWS/ROW").length > 0) {
	            		var DocList = new ListView();
			            DocList.LoadFromID("lvTDocLV");
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
	            if (!CrossYN())
	                window.returnValue = "cancel";
	        }
	
	        function lvSDocResize() {
	            lvSDoc.headers.headerTable.style.width = 350 - 14;
	            lvSDoc.rows.rowTable.style.width = 350 - 14;
	        }
	        function lvTDocResize() {
	            lvTDoc.headers.headerTable.style.width = 180 - 14;
	            lvTDoc.rows.rowTable.style.width = 180 - 14;
	        }
	        function InitSubMenu(MenuType) {
	        }
	        function lvtDoclist_onSel_Changed() {
	            return;
	        }
	        function lvtDoclist_onSel_Click() {
	            return;
	        }
	        function lvtDoclist_onSel_DBclick() {
	            btnIns_onclick();
	        }
	        function lvtDoclist_onclick() {
	            return;
	        }
	        function lvTDoc_onSel_Changed() {
	            return;
	        }
	        function lvTDoc_onSel_Click() {
	            var DocList = new ListView();
	            DocList.LoadFromID("lvTDocLV");
	            var pCurSel = DocList.GetSelectedRows();
	            if (arr_userinfo[1].toLowerCase() != GetAttribute(pCurSel[0], "DATA4").toLowerCase())
	                arrow_left.Enable = "false";
	            else
	                arrow_left.Enable = "true";
	        }
	        function lvTDoc_onSel_DBclick() {
	            btndel_onclick()
	        }
	
	        function lvTDoc_onclick() {
	            return;
	        }
	        function btnIns_onclick() {
	            //2018-08-23 강민수92 전자결재G일 경우 문서첨부시 PUBLICITYYN이 N이면 문서첨부 할 수 없도록 변경
	            if (approvalFlag == "G") {
		        	var DocList = new ListView();
		            DocList.LoadFromID("DocList");
		            var pCurSel = DocList.GetSelectedRows();
		            var curArray = new Array;
		            
		            for (var count1 = 0; count1 < pCurSel.length; count1++) {
			            if (GetAttribute(pCurSel[count1], "DATA16") == "N") {
			            	OpenAlertUI("<spring:message code='ezApprovalG.garm04'/>");
			            	return;
			            }
						if (GetAttribute(pCurSel[count1], "DATA16") == "B") {
							OpenAlertUI("<spring:message code='ezApprovalG.kmh06'/>");
							return;
						}
			            //2018-10-12 김보미 - 문서첨부시 보안문서일 경우 보안날짜가 지나기 전엔 첨부할 수 없도록 변경
			            if (GetAttribute(pCurSel[count1], "DATA14") != null && GetAttribute(pCurSel[count1], "DATA14") != "") {
			            	date = GetAttribute(pCurSel[count1], "DATA14");
			            	today = GetTodayDate();
			            	if (date >= today) {
			            		OpenAlertUI("<spring:message code='ezApprovalG.kbm07'/>");
				            	return;
			            	}
			            }
		            }
	            }
	           
	            DocMove();
	        }
	        function btndel_onclick() {
	            var selRow;
	            var count1;
	            var DocList = new ListView();
	            DocList.LoadFromID("lvTDocLV");
	            var pCurSel = DocList.GetSelectedRows();
	            var length = pCurSel.length;
	            
	            if (length == 0) {
	                OpenAlertUI("<spring:message code='ezApprovalG.t360'/>");
	                return;
	            }
	            
	            for (var i = 0; i < length; i++) {
	            	if (typeof(GetAttribute(pCurSel[i], "DELETE")) != "undefined" && GetAttribute(pCurSel[i], "DELETE") == "N") {
	            		OpenAlertUI("<spring:message code='ezApprovalG.t277'/>");
	            		return;
	            	}
	            }
	            
	            var userCheck = true;
	            for (var i = 0; i < length; i++) {
	            	if (arr_userinfo[1].toLowerCase() != GetAttribute(pCurSel[i], "DATA4").toLowerCase()) {
	            		userCheck = false;
	            		break;
	            	}
	            }
	            
	            if (!userCheck && pDraftFlag != "REDRAFT") {
	                OpenAlertUI("<spring:message code='ezApprovalG.t361'/>");
	                return;
	            }
	            else {
	                if (length > 0) {
	                    for (count1 = length; count1 > 0; count1--) {
	                        DocList.DeleteRow(pCurSel[count1 - 1].id);
	                    }
	                }
	                else
	                    OpenAlertUI("<spring:message code='ezApprovalG.t360'/>");
	            }
	        }
	        
			function bt_OK_onclick() {
			    var listview = new ListView();
			    listview.LoadFromID("lvTDocLV");
			    var TotalList = listview.GetDataRows();
			    var length = TotalList.length;
			    
			    if (length > 0) { // 문서첨부가 존재
			        var AprDocAttachxml = DocMoveParser();
			    
			    	/* 2022-01-20 홍승비 - 일괄기안 문서 내에서 문서첨부하는 경우, 부모창과 각 안별 문서첨부 플래그를 변경 */
			    	if (draftAllFlag == "Y") {
			    		parent.pHasDocAttachYN = "Y";
			    		parent.pHasDocAttachYNAry[anNo] = "Y";
			    	}
			    
			        if (ReturnFunction != null) {
			            ReturnFunction(AprDocAttachxml);
			        }
			        else {
			            window.returnValue = AprDocAttachxml;
			            window.close();
			        }
			    }
			    else { // 문서첨부가 없음
			        delAttachDoc();
			        var AprDocAttachxml = DocMoveParser();
			        
			    	if (draftAllFlag == "Y") {
			    		parent.pHasDocAttachYN = "N";
			    		parent.pHasDocAttachYNAry[anNo] = "N";
			    	}
			    	
			        if (ReturnFunction != null) {
			            ReturnFunction(AprDocAttachxml);
			        }
			        else {
			            window.returnValue = AprDocAttachxml;
			            window.close();
			        }
			    }
			}
			function bt_Cancle_onclick() {
			    if (ReturnFunction != null) {
			        ReturnFunction("cancel");
			    }
			    else {
			        window.returnValue = "cancel";
			        window.close();
			    }
			}
			function btnSearch_onclick() {
			    btnSearchRec_onclick("1");
			}

			function showDocView_onclick() {
				var listview = new ListView();
				listview.LoadFromID("DocList");
				var selRow = listview.GetSelectedRows()[0];
				
				if (selRow.length <= 0) {
					var pAlertContent = "<spring:message code='ezApprovalG.t1533'/>";
					alert(pAlertContent);
					return;
				}

				/* 2024-07-31 김유진 - 문서첨부>문서보기 시 보안결재 문서 체크 */
				var securityApprovalFlag = GetAttribute(selRow, "DATA14");
				if (securityApprovalFlag != "null" && securityApprovalFlag != "" && securityApprovalFlag >= GetTodayDate()) {
					if (CheckAprLine(selRow.getAttribute("DATA1")) == "TRUE" || GetUserRole() != "User" ) {
						chk_Passwd(UserID, showDocView_onclick_Complete);
					} else {
						OpenAlertUI(strLang580);
						return;
					}
				} else {
					showDocView_onclick_Complete("True");
				}
			}


			function showDocView_onclick_Complete() {
				var listview = new ListView();
				listview.LoadFromID("DocList");
				var selRow = listview.GetSelectedRows()[0];
				var DocID = GetAttribute(selRow, "DATA1");
				var pURL = GetAttribute(selRow, "DATA2");
				
				if (trim_Cross(pURL) == "") {
					var para2 = new Array();
					para2[0] = GetAttribute(selRow, "DATA6");
					para2[1] = GetAttribute(selRow, "DATA8");

					var url = "/ezApprovalG/contDocView_NoDoc.do?docID=" + encodeURI(DocID) + "&g_RecID=" + encodeURI(para2[0]) + "&g_SepAttNo=" + encodeURI(para2[1]);
					var left = 0;
					var top = 0;
					var wWidth = 600;
					var wHeigth = 300;

					left = window.outerWidth / 2 + window.screenX - (wWidth / 2);
					top = window.outerHeight / 2 + window.screenY - (wHeigth / 2);

					window.open(url, strLang1135, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + wHeigth + ",width=" + wWidth + ",top=" + top + ",left = " + left);
				} else {
					var para = new Array();
					var tempUrl = pURL;
					var openLocation = "";

					if (tempUrl.substr(tempUrl.length - 4, tempUrl.length).toLowerCase() == ".ezd") {
						tempUrl = tempUrl.substr(0, tempUrl.length - 4);
					}

					if (tempUrl.substr(tempUrl.length - 3, tempUrl.length).toLowerCase() == "hwp") {
						if(useWebHWP == "NO") {
							if (isIE()) {
								openLocation = "/ezApprovalG/ezViewEnd_HWP.do";
							} else {
								var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
								alert(pAlertContent);
								return;
							}
						} else {
							openLocation = "/ezApprovalG/ezViewEnd_WHWP.do";
						}
					} else {
						openLocation = "/ezApprovalG/contDocView.do";
					}
					openLocation = openLocation + "?docID=" + encodeURI(DocID) + "&docHref=" + encodeURI(pURL) + "&formID=" + encodeURI(selRow.getAttribute("DATA5")) + "&orgDocID=";
					openwindow(openLocation, "", 880, 570);
				}
			}

			function moveDataRow(e) {
				let listView = new ListView();
				listView.LoadFromID("lvTDocLV");

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
				let attrData2 = parseInt(listView.GetSelectedRows()[0].getAttribute("data2"));
				let curIdx;
				let destIdx;

				if (isNaN(attrData2)) {
					let nodeID = listView.GetSelectedRows()[0].id;

					attrData2 = nodeID.substring(nodeID.length - 1);
				}

				curIdx = attrData2 - 1;

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
		</script>
	    <style>
	    	.mainlist tr th {border-top:0px}
	    </style>
	</head>
	<body class="popup">
	    <xml id='FORMLIST' style="display: none;">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <NAME><spring:message code='ezApprovalG.t362'/></NAME>
		        <WIDTH>165</WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
	    <div id="menu">
	        <ul>
	        	<c:if test="${approvalFlag == 'S'}">
					<li style="background-image: none;font-size:11pt;font-weight:bold;color:white;padding-top:6px;margin-right:12px;padding-left:0px">
						<spring:message code='ezApprovalG.t1429'/>
					</li>
				</c:if>	
	            <li><span onclick="return btnSearch_onclick()"><spring:message code='ezApprovalG.t111'/></span></li>
				<li><span onclick="return showDocView_onclick()"><spring:message code='ezApprovalG.t367'/></span></li>
	        </ul>
	    </div>
	    <div id="close">
            <ul>
                <li><span onclick="return bt_Cancle_onclick()"></span></li>
            </ul>
        </div>
	    <table style="margin-top: -10px; width: 455px;display:none"><!--2020-04-28 : 페이지네이션 공통변경-->
	        <tr>
	            <td style="height: 25px; vertical-align: bottom;"><span class="point" id="listcount">&nbsp;</span></td>
	            <td>
	                <div class="page" style="margin-right:50px">
	                    <img src="/images/page_previous.gif" id="td_Previous" onclick="goToPage_lv('front')" style="vertical-align: middle;">
	                    <span><spring:message code='ezApprovalG.t103'/></span><span id="td_pTotalCount" style="color:black;"></span>&nbsp;&nbsp;<span style="color:black;"><spring:message code='ezApprovalG.t363'/></span>
	                    <input id="txt_PageInputNum" onkeydown="goToPage_lv('page', event)" onselectstart="event.cancelBubble=true;event.returnValue=true">
	                    <img src="/images/page_next.gif" id="td_Next" onclick="goToPage_lv('next')" style="vertical-align: middle;">
	                </div>
	            </td>
	        </tr>
	    </table>
	
	    <table>
			<tr>
				<td style = "height : 35px;" colspan = 2>
					<%-- S버전과 동일한 화면 구성을 가져가기 위해 임의의 공백 td 삽입 --%>
					&nbsp;
				</td>
				<td>
					<a class = "imgBtn" onclick = "moveDataRow('up')" style="height:22px; /*margin : 0 5px 0 0;*/">
						<span>
							<img src="/images/ImgIcon/prev.gif" alt="" style="width : 20px;/* margin-top: 4px;*/">
						</span>
					</a>

					<a onclick = "moveDataRow('down')">
						<span>
							<img src="/images/ImgIcon/next.gif" alt="" style="width : 20px;/* margin-top: 4px;*/">
						</span>
					</a>
				</td>
			</tr>
	        <tr>
	            <td style="vertical-align: top;">
	                <div class="listview">
	                    <div id="lvtDoclist" style="border: 0; width: 680px; height: 385px; overflow-x: auto; overflow-y:hidden;"></div>
					</div>
					<div id="tblPageRayer"></div>
	            </td>
	            <td style="width: 25px; text-align: center;">
	                <img id="arrow_right" onclick="return btnIns_onclick()" src="/images/arr01.gif" style="cursor: pointer"><img id="arrow_left" onclick="return btndel_onclick()" src="/images/arr02.gif" style="cursor: pointer">
				</td>
	            <td>
	                <div class="listview" style="margin-bottom:45px">
	                    <div id="lvTDoc" style="border: 0; width: 320px; height: 385px; overflow: auto"></div>
	                </div>
	            </td>
	        </tr>
	    </table>
	
	    <div class="btnposition btnpositionNew">
	        <a class="imgbtn"><span onclick="return bt_OK_onclick()"><spring:message code='ezApprovalG.t20'/></span></a>
	    </div>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("menu"), "ul", "li", "0");
	    </script>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>
