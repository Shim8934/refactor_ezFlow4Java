<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezBoard.t75" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <style>
	    <%-- 2018-07-26 홍승비 - 관리자 > 게시판 권한설정 헤더 겹치는 부분, 가로 축소 시 스크롤 수정 --%>
	    	#AccessListView {
	    		min-width: 800px;
	    	}
	    	#AccessListView_TH th {
	    		overflow: hidden;
    			text-overflow: ellipsis;
	    	} 
	    </style>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>	    
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>    
	    <script type="text/javascript" src="${util.addVer('/js/ezBoard/ListView_list_admin.js')}"></script>
	    <script type="text/javascript">
	        var pBoardID = "<c:out value='${boardID}'/>";
	        var pParentBoardID = "<c:out value='${parentBoardID}'/>";
	        var strList = "${strList}";
	        var primary = "${primary}";  // 값을 넘기지 않던(""으로 전달하고 있었음) userLang 대신 primary로 다국어 데이터 표시
	        var pBoardName = "<c:out value='${pBoardName}'/>";
	        var pType = "<c:out value='${pType}'/>";
	        var pParentNeed = "<c:out value='${pParentNeed}'/>";
	        var selectedTargetID = "";
	        var selectedTargetName = "";
	        var selectedTargetName2 = "";
	        var selectTargetListXML = "";
	        var selectTargetNewListXML = "";
			
	        document.onselectstart = function () {
	            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	                return false;
	            else
	                return true;
	        };
	
	        window.onload = function () {
	            FillAccessList();
	            
	            if (pBoardID == "{MMMMMMMM-MMMM-MMMM-MMMM-MMMMMMMMMMMM}") {
	            	PostSpan.style.display = "none";
	            }

				// VOC #163284 관리자 탭 선택 오류 
				if (window.parent && window.parent !== window) {
					try {
						const parentUrl = window.parent.location.href;

						if (parentUrl.includes("admin/ezBoard/boardConfig.do")) {
							const parentDoc = window.parent.document;

							const container = parentDoc.querySelector(".portlet_tabnew01_top");

							if (container) {
								const spans = container.querySelectorAll('span[divname="BoardEnv_div1"], span[divname="BoardEnv_div2"], span[divname="BoardEnv_div3"], span[divname="BoardEnv_div4"], span[divname="BoardEnv_div5"]');

								spans.forEach(span => {
									span.removeAttribute("class");
								});

								const targetSpan = container.querySelector('span[divname="BoardEnv_div3"]');
								if (targetSpan) {
									targetSpan.classList.add("tabon");
									window.parent.Tab1_SelectID = "1tab3";
								}
							}
						}
					} catch (e) {
						console.log(e);
					}
				}
	        }
	
	        /* 2018-07-19 홍승비 - 권한설정 정보 리스트로 표출하는 분기 스크립트 오류 수정 */
	        function FillAccessList() {
	            var xmldom = loadXMLString(strList);
	            var listTR, listTD, listTDText;
	            var listview = new ListView();
	            listview.SetID("AccessListView");
	            listview.SetMulSelectable(true);
	            listview.SetRowOnClick("AccessList_onDblclick");
	            
	            var pattern = /<([\/]*)([a-zA-Z_0-9]+)([^>]*)>/g 
            	var newXml = document.getElementById("listviewheader").innerHTML.replace(pattern, function(full, before, tag, after) { 
	            	return "<" + before + tag.toUpperCase() + after + ">"
	            });
	            
	            listview.DataSource(loadXMLString(newXml));
	            listview.DataBind("AccessList");
	            var xmldomNode = SelectNodes(xmldom, "DATA/ROW")
	            
	            /* 다국어 설정인 경우, 4번째부터 값을 가져온다. */
	            if (primary != "1") {
	                for (i = 0; i < xmldomNode.length; i++) {
	                    listTR = listview.AddRow(listview.GetRowCount());
	                    for (j = 4; j < SelectNodes(xmldom, "DATA/ROW")[i].childNodes.length; j++) {
	                        listTD = document.createElement("TD");
	                        
	                       /* 동그라미로 플래그를 그린다.(13~20) / 21값은 권한의 TYPE으로, 속성으로만 부여한다. */
	                       if (j >=13 && j < 21) {
		                        if (getNodeText(xmldomNode[i].childNodes[j]) == "true" || getNodeText(xmldomNode[i].childNodes[j]) == "1") {
		                            listTDText = document.createTextNode("●");
		                        } else if (getNodeText(xmldomNode[i].childNodes[j]) == "false" || getNodeText(xmldomNode[i].childNodes[j]) == "0") {
		                            listTDText = document.createTextNode("");
		                        }else if (getNodeText(xmldomNode[i].childNodes[j]) == "" || getNodeText(xmldomNode[i].childNodes[j]) == null) {
		                            listTDText = document.createTextNode("");
		                        }
	                       } else if (j == 21) { // 권한의 TYPE인 경우 스킵
	                    	   continue;
	                       }
	                       /* 회사(4), 부서(5), 이름(6), 직위직책(7) 부분은 값이 1이더라도 동그라미를 찍지 않도록 한다. */
	                       else {
	                    	   listTDText = document.createTextNode(getNodeText(xmldomNode[i].childNodes[j]));
	                       }
	                        if (j == 7) {
	                            j = 12;
	                        }
	                        if (j >= 13 && j < 21) {
								listTD.setAttribute("style", "text-align:center;color:#268fff;");
	                        }
	                        listTD.appendChild(listTDText);
	                        listTR.appendChild(listTD);
	                        listTD = null;
	                        listTDText = null;
	                    }
	                    
	                    listTR.setAttribute("DATA", SelectSingleNodeValue(xmldomNode[i], "ACCESSNAME"));
	                    listTR.setAttribute("DATA2", SelectSingleNodeValue(xmldomNode[i], "ACCESSNAME2"));
	                    listTR.setAttribute("DATA1", SelectSingleNodeValue(xmldomNode[i], "ACCESSID"));
	                    listTR.setAttribute("DATA3", SelectSingleNodeValue(xmldomNode[i], "BOARDGROUPACL"));
	                    listTR.setAttribute("TYPE", SelectSingleNodeValue(xmldomNode[i], "TYPE")); // 권한의 TYPE값 부여
	                    listTR = null;
	                }
	            }
	            else {
	                for (i = 0; i < xmldomNode.length; i++) {
	                    listTR = listview.AddRow(listview.GetRowCount());
	                    for (j = 0; j < SelectNodes(xmldom, "DATA/ROW")[i].childNodes.length; j++) {
	                        listTD = document.createElement("TD");
	                        
	                        if (j >= 13 && j < 21) {
		                        if (getNodeText(xmldomNode[i].childNodes[j]) == "true" || getNodeText(xmldomNode[i].childNodes[j]) == "1") {
		                            listTDText = document.createTextNode("●");
		                        } else if (getNodeText(xmldomNode[i].childNodes[j]) == "false" || getNodeText(xmldomNode[i].childNodes[j]) == "0") {
		                            listTDText = document.createTextNode("");
		                        } else if (getNodeText(xmldomNode[i].childNodes[j]) == "" || getNodeText(xmldomNode[i].childNodes[j]) == null) {
		                            listTDText = document.createTextNode("");
		                        }
	                        } else if (j == 21) { // 권한의 TYPE인 경우 스킵
								continue;
		                    }
	                        /* 회사(0), 부서(1), 이름(2), 직위직책(3) 부분은 값이 1이더라도 동그라미를 찍지 않도록 한다. */
	                        else {
								listTDText = document.createTextNode(getNodeText(xmldomNode[i].childNodes[j]));
	                        }
	                        if (j == 3) {
	                            j = 12;
	                        }
	                        if (j >= 13 && j < 21) {
	                            listTD.setAttribute("style", "text-align:center;color:#268fff;");
	                        }
	                        listTD.appendChild(listTDText);
	                        listTR.appendChild(listTD);
	                        listTD = null;
	                        listTDText = null;
	                    }
	                    
	                    listTR.setAttribute("DATA", SelectSingleNodeValue(xmldomNode[i], "ACCESSNAME"));
	                    listTR.setAttribute("DATA2", SelectSingleNodeValue(xmldomNode[i], "ACCESSNAME2"));
	                    listTR.setAttribute("DATA1", SelectSingleNodeValue(xmldomNode[i], "ACCESSID"));
	                    listTR.setAttribute("DATA3", SelectSingleNodeValue(xmldomNode[i], "BOARDGROUPACL"));
	                    listTR.setAttribute("TYPE", SelectSingleNodeValue(xmldomNode[i], "TYPE")); // 권한의 TYPE값 부여
	                    listTR = null;
	                }
	            }
	            xmldomNode = null;
	            xmldom = null;
	        }
	
	        /* 2019-01-28 홍승비 - 권한 저장 시 그룹사게시판 여부 데이터 추가 */
	        function SaveACL() {
	            if (selectTargetListXML == "") {
	                alert("<spring:message code='ezBoard.t600'/>")
	                return;
	            }
	            if (_type)
	                AccessList_onDblclick("false");
	            var xmldom2 = loadXMLString(selectTargetListXML);
	            var xmlhttp = createXMLHttpRequest();
	            for (var i = 0; i < xmldom2.getElementsByTagName("CN").length; i++) {
	                var strXML = "";
	                strXML += "<NODES>";
	                strXML += "<NODE>";
	                strXML += "<TARGETID>" + getNodeText(xmldom2.getElementsByTagName("CN")[i]) + "</TARGETID>";
	                strXML += "<TARGETNAME>" + MakeXMLString(getNodeText(xmldom2.getElementsByTagName("NAME")[i])) + "</TARGETNAME>";
	                strXML += "<TARGETNAME2>" + MakeXMLString(getNodeText(xmldom2.getElementsByTagName("NAME2")[i])) + "</TARGETNAME2>";
	                // 하위부서 허용 여부 (TARGETGROUP -> BoardGroupACL)
	                strXML += "<TARGETGROUP>" + MakeXMLString(getNodeText(xmldom2.getElementsByTagName("GROUP")[i])) + "</TARGETGROUP>";
	                strXML += "<BOARDID>" + pBoardID + "</BOARDID>";
	                strXML += "<PARENTBOARDID>" + pParentBoardID + "</PARENTBOARDID>";
	                strXML += "<INHERIT>" + inherit_OK.checked + "</INHERIT>";
	                strXML += "<ADMIN>" + admin_OK.checked + "</ADMIN>";
	                strXML += "<ACCESSLEVEL>" + "<c:out value='${pAccessLevel}'/>" + "</ACCESSLEVEL>";
	                strXML += "<ACCESS>" + access_OK.checked + "</ACCESS>";
	                strXML += "<LIST>" + list_OK.checked + "</LIST>";
	                strXML += "<READ>" + read_OK.checked + "</READ>";
	                strXML += "<WRITE>" + write_OK.checked + "</WRITE>";
	                strXML += "<REPLY>" + reply_OK.checked + "</REPLY>";
	                strXML += "<DELETE>" + delete_OK.checked + "</DELETE>";
	                strXML += "<POSTNOTICE>" + PostNotice.checked + "</POSTNOTICE>";
	                strXML += "<ISALLGROUPBOARD>${isAllGroupBoard}</ISALLGROUPBOARD>";
	                /* 2019-09-19 홍승비 - 개인, 직위직책, 부서, 그룹권한 여부 파라미터 추가 */
	                strXML += "<TYPE>" + MakeXMLString(getNodeText(xmldom2.getElementsByTagName("DEPT")[i])) + "</TYPE>";
	                strXML += "</NODE>";
	                strXML += "</NODES>";
	                xmldom = loadXMLString(strXML);
	
	                xmlhttp.open("POST", "/admin/ezBoard/saveACL.do", false);
	                xmlhttp.send(xmldom);
	            }
	            if (xmlhttp.responseText.indexOf("OK") > -1) {
	                alert("<spring:message code='ezBoard.t79'/>");
	            } else {
	                alert("<spring:message code='ezBoard.t80'/>");
	            }
	            xmldom = null;
	            xmlhttp = null;
	            window.location.reload();
	        }
	        function DeleteACL(type) {
	            var listview = new ListView();
	            listview.LoadFromID("AccessListView");
	            var selnode = listview.GetSelectedRows();
	            if (type == "one")
	                selnode = listview.GetSelectedRows();
	            else
	                selnode = listview.GetDataRows();
	            if (selnode.length == 0 && type == "one") {
	                alert("<spring:message code='ezBoard.t601'/>");
	                return;
	            }
	            var xmlhttp = createXMLHttpRequest();
	            var xmlpara = createXmlDom();
	            var objRoot, objRow, objNode;
	
	            objRoot = createNodeInsert(xmlpara, objRoot, "DATA");
	            for (var i = 0 ; i < selnode.length; i++) {
	                objRow = createNodeAndAppandNode(xmlpara, objRoot, objRow, "ROW");
	                objNode = createNodeAndAppandNodeText(xmlpara, objRow, objNode, "BOARDID", pBoardID);
	                objNode = createNodeAndAppandNodeText(xmlpara, objRow, objNode, "TARGETID", GetAttribute(selnode[i], "data1"));
	            }
	            
	            var alertContent = "";
	            
	            if (type === "one" ) {
	            	//alertContent = "<spring:message code='ezBoard.t197'/>";
	            	alertContent = "<spring:message code='ezBoard.pjg04'/>";
	            } else if (type === "type" ) {
	            	alertContent = "<spring:message code='ezBoard.pjg05'/>";
	            }
				
	            if(confirm(alertContent)) {
		            
		            xmlhttp.open("POST", "/admin/ezBoard/deleteACL.do", false);
		            xmlhttp.send(xmlpara);
		
		            if (xmlhttp.status == 200 && xmlhttp.responseText == "OK") {
		                alert("<spring:message code='ezBoard.t54'/>");
		            }
		              window.location.reload();
		              
	            }
	         }
	        
/* 	// 기존 권한설정 기능 주석처리
	        var selecttarget_dialogArguments = new Array();
	        function SelectTarget() {
	            var receiverData = new Array();
	            receiverData["window"] = this;
	            receiverData["selectTargetListXML"] = selectTargetListXML;
	            selecttarget_dialogArguments[0] = receiverData;
	            selecttarget_dialogArguments[1] = SelectTarget_Complete;
	            selecttarget_dialogArguments[2] = "${isAllGroupBoard}";
	            var SelectTarget = window.open("/admin/ezBoard/selectTarget.do", "SelectTarget", GetOpenWindowfeature(1144, 590));
	            try { SelectTarget.focus(); } catch (e) {
	            }
	        }
	
	        function SelectTarget_Complete(ret) {
	            _type = false;
	            if (typeof (ret) != "undefined") {
	                selectTargetListXML = ret;
	                if (admin_OK.checked == false && admin_NO.checked == false) {
	                    CheckBoxInit2();
	                }
	            }
	
	            if (selectTargetListXML == "" || selectTargetListXML == "<DATA></DATA>") {
	                CheckBoxInit();
	            }
	        }
	 */
	 
	        /* 2018-09-03 홍승비 - 관리자 권한 체크 시 모든 동작 '허용'으로 고정 */
	        function checkbox_onclick(e) {
	            if (CrossYN()) {
	                srcElementID = e.target.id;
	            } else {
	                srcElementID = window.event.srcElement.id;
	            }
	            toggle(srcElementID);
	            if (admin_OK.checked == true) {
	                access_OK.checked = true;
	                list_OK.checked = true;
	                read_OK.checked = true;
	                write_OK.checked = true;
	                reply_OK.checked = true;
	                delete_OK.checked = true;
	                PostSpan.style.display = "";
	                
		            if (pBoardID == "{MMMMMMMM-MMMM-MMMM-MMMM-MMMMMMMMMMMM}") {
		            	PostSpan.style.display = "none";
		            }
	
	                access_NO.checked = false;
	                list_NO.checked = false;
	                read_NO.checked = false;
	                write_NO.checked = false;
	                reply_NO.checked = false;
	                delete_NO.checked = false;
	                
	                access_NO.disabled = true;
	                list_NO.disabled = true;
	                read_NO.disabled = true;
	                write_NO.disabled = true;
	                reply_NO.disabled = true;
	                delete_NO.disabled = true;
	            }
	            else if (admin_NO.checked == true) {
	            	access_NO.disabled = false;
                    list_NO.disabled = false;
                    read_NO.disabled = false;
                    write_NO.disabled = false;
                    reply_NO.disabled = false;
                    delete_NO.disabled = false;
                    PostNotice.checked = false;
                    PostSpan.style.display = "none";
	            }
	            
	         // 게시판 그룹의 경우, 오직 '관리자'와 '접근' 권한만 설정 가능.
                if (pParentBoardID == "top") {
					list_OK.checked = false;
                    list_NO.checked = true;
                    read_OK.checked = false
                    read_NO.checked = true;
                    write_OK.checked = false;
                    write_NO.checked = true;
                    reply_OK.checked = false;
                    reply_NO.checked = true;
                    delete_OK.checked = false;
                    delete_NO.checked = true;
                    PostNotice.checked = false;
                    
					list_OK.disabled = true;
                    list_NO.disabled = true;
                    read_OK.disabled = true
                    read_NO.disabled = true;
                    write_OK.disabled = true;
                    write_NO.disabled = true;
                    reply_OK.disabled = true;
                    reply_NO.disabled = true;
                    delete_OK.disabled = true;
                    delete_NO.disabled = true;
	                PostNotice.disabled = true;
                }	            
	        }
	        
	        function toggle(pSrcElementID) {
	            if (pSrcElementID == "inherit_OK" && inherit_OK.checked) inherit_NO.checked = false;
	            if (pSrcElementID == "inherit_OK" && inherit_OK.checked == false) inherit_NO.checked = true;
	            if (pSrcElementID == "admin_OK" && admin_OK.checked) admin_NO.checked = false;
	            if (pSrcElementID == "admin_OK" && admin_OK.checked == false) admin_NO.checked = true;
	            if (pSrcElementID == "access_OK" && access_OK.checked) access_NO.checked = false;
	            if (pSrcElementID == "access_OK" && access_OK.checked == false) access_NO.checked = true;
	            if (pSrcElementID == "list_OK" && list_OK.checked) list_NO.checked = false;
	            if (pSrcElementID == "list_OK" && list_OK.checked == false) list_NO.checked = true;
	            if (pSrcElementID == "read_OK" && read_OK.checked) read_NO.checked = false;
	            if (pSrcElementID == "read_OK" && read_OK.checked == false) read_NO.checked = true;
	            if (pSrcElementID == "write_OK" && write_OK.checked) write_NO.checked = false;
	            if (pSrcElementID == "write_OK" && write_OK.checked == false) write_NO.checked = true;
	            if (pSrcElementID == "reply_OK" && reply_OK.checked) reply_NO.checked = false;
	            if (pSrcElementID == "reply_OK" && reply_OK.checked == false) reply_NO.checked = true;
	            if (pSrcElementID == "delete_OK" && delete_OK.checked) delete_NO.checked = false;
	            if (pSrcElementID == "delete_OK" && delete_OK.checked == false) delete_NO.checked = true;
	
	            if (pSrcElementID == "inherit_NO" && inherit_NO.checked) inherit_OK.checked = false;
	            if (pSrcElementID == "inherit_NO" && inherit_NO.checked == false) inherit_OK.checked = true;
	            if (pSrcElementID == "admin_NO" && admin_NO.checked) {
	                admin_OK.checked = false;
	                PostSpan.style.display = "none";
	                PostNotice.checked = false;
	            }
	            if (pSrcElementID == "admin_NO" && admin_NO.checked == false) {
	                admin_OK.checked = true;
	                PostSpan.style.display = "";
	                
		            if (pBoardID == "{MMMMMMMM-MMMM-MMMM-MMMM-MMMMMMMMMMMM}") {
		            	PostSpan.style.display = "none";
		            }
		            
	                PostNotice.checked = false;
	            }
	            if (pSrcElementID == "access_NO" && access_NO.checked) access_OK.checked = false;
	            if (pSrcElementID == "access_NO" && access_NO.checked == false) access_OK.checked = true;
	            if (pSrcElementID == "list_NO" && list_NO.checked) list_OK.checked = false;
	            if (pSrcElementID == "list_NO" && list_NO.checked == false) list_OK.checked = true;
	            if (pSrcElementID == "read_NO" && read_NO.checked) read_OK.checked = false;
	            if (pSrcElementID == "read_NO" && read_NO.checked == false) read_OK.checked = true;
	            if (pSrcElementID == "write_NO" && write_NO.checked) write_OK.checked = false;
	            if (pSrcElementID == "write_NO" && write_NO.checked == false) write_OK.checked = true;
	            if (pSrcElementID == "reply_NO" && reply_NO.checked) reply_OK.checked = false;
	            if (pSrcElementID == "reply_NO" && reply_NO.checked == false) reply_OK.checked = true;
	            if (pSrcElementID == "delete_NO" && delete_NO.checked) delete_OK.checked = false;
	            if (pSrcElementID == "delete_NO" && delete_NO.checked == false) delete_OK.checked = true;
	            
	            if (access_NO.checked) {
	                read_OK.checked = false;
	                list_OK.checked = false;
	                access_OK.checked = false;
	                reply_OK.checked = false;
	                write_OK.checked = false;
	                delete_OK.checked = false;
	
	                read_NO.checked = true;
	                list_NO.checked = true;
	                access_NO.checked = true;
	                reply_NO.checked = true;
	                write_NO.checked = true;
	                delete_NO.checked = true;
	            }
	
	            if (reply_OK.checked) {
	                read_OK.checked = true;
	                list_OK.checked = true;
	                access_OK.checked = true;
	                read_NO.checked = false;
	                list_NO.checked = false;
	                access_NO.checked = false;
	            }
	
	            if (read_OK.checked) {
	                list_OK.checked = true;
	                access_OK.checked = true;
	                list_NO.checked = false;
	                access_NO.checked = false;
	            }
	
	            if (write_OK.checked) {
	                list_OK.checked = true;
	                access_OK.checked = true;
	                list_NO.checked = false;
	                access_NO.checked = false;
	            }
	        }
	        var _type;
	        function AccessList_onDblclick(para) {
	            var listview = new ListView();
	            listview.LoadFromID("AccessListView");
	
	            var selnode = listview.GetSelectedRows();
	            _type = true;
	            if (selnode != null) {
	                selectTargetListXML = "<DATA>";
	
	                if (selnode.length == 1) {
	                    setNodeText(selectedTarget, getNodeText(selnode[0].cells[2]));
	                    selectedTargetID = GetAttribute(selnode[0], "data1")
	                    selectedTargetName = GetAttribute(selnode[0],"data")
	                    selectedTargetName2 = GetAttribute(selnode[0],"data2")
	                    selectedTargetGroup = GetAttribute(selnode[0],"data3")
	                    if (para != "false")
	                        FillACLTable();
	
	                    selectTargetListXML += "<CN>" + selectedTargetID + "</CN>";
	                    selectTargetListXML += "<NAME><![CDATA[" + selectedTargetName + "]]></NAME>";
	                    selectTargetListXML += "<NAME2><![CDATA[" + selectedTargetName2 + "]]></NAME2>";
	                    selectTargetListXML += "<GROUP><![CDATA[" + selectedTargetGroup + "]]></GROUP>";
	                    
	                    /* 2019-09-19 홍승비 - 권한 타입 체크 추가 (PERSON, DEPT, JIKWI, JIKCHEK, GROUP) */
	                    if (GetAttribute(selnode[0],"type") != null &&  GetAttribute(selnode[0],"type") != "") { // TYPE값이 있는 경우
							selectTargetListXML += "<DEPT><![CDATA[" + GetAttribute(selnode[0],"type") + "]]></DEPT>";
	                    } else { // TYPE값이 없는 경우(기존에 등록된 권한들)
		                    if (selnode[0].cells[0].innerHTML == "" || selnode[0].cells[0].innerHTML == null) {
		                        selectTargetListXML += "<DEPT><![CDATA[DEPT]]></DEPT>";
		                    } else {
		                        selectTargetListXML += "<DEPT><![CDATA[PERSON]]></DEPT>";
		                    }
	                    }
	                } else {
	                    setNodeText(selectedTarget, "");
	
	                    for (var i = 0; i < selnode.length; i++) {
	                        if (i == 0) setNodeText(selectedTarget, getNodeText(selectedTarget) + getNodeText(selnode[i].cells[2]));
	                        else setNodeText(selectedTarget, getNodeText(selectedTarget) + ", " + getNodeText(selnode[i].cells[2]));
	
	                        selectedTargetID = GetAttribute(selnode[i],"data1")
	                        selectedTargetName = GetAttribute(selnode[i],"data")
	                        selectedTargetName2 = GetAttribute(selnode[i],"data2")
	                        selectedTargetGroup = GetAttribute(selnode[i],"data3")
	
	                        selectTargetListXML += "<CN>" + selectedTargetID + "</CN>";
	                        selectTargetListXML += "<NAME><![CDATA[" + selectedTargetName + "]]></NAME>";
	                        selectTargetListXML += "<NAME2><![CDATA[" + selectedTargetName2 + "]]></NAME2>";
	                        selectTargetListXML += "<GROUP><![CDATA[" + selectedTargetGroup + "]]></GROUP>";
	                        
		                    /* 2019-09-19 홍승비 - 권한 타입 체크 추가 (PERSON, DEPT, GROUP...) */
		                    if (GetAttribute(selnode[i],"type") != null &&  GetAttribute(selnode[i],"type") != "") { // TYPE값이 있는 경우
								selectTargetListXML += "<DEPT><![CDATA[" + GetAttribute(selnode[i],"type") + "]]></DEPT>";
		                    } else { // TYPE값이 없는 경우(기존에 등록된 권한들)
			                    if (selnode[i].cells[0].innerHTML == "" || selnode[i].cells[0].innerHTML == null) {
			                        selectTargetListXML += "<DEPT><![CDATA[DEPT]]></DEPT>";
			                    } else {
			                        selectTargetListXML += "<DEPT><![CDATA[PERSON]]></DEPT>";
			                    }
		                    }
	                    }
	                }
	                selectTargetListXML += "</DATA>";
	            }
	        }
	        
	        function CheckBoxInit() {
	            admin_OK.checked = false;
	            access_OK.checked = false;
	            list_OK.checked = false;
	            read_OK.checked = false;
	            write_OK.checked = false;
	            reply_OK.checked = false;
	            delete_OK.checked = false;
	            inherit_OK.checked = false;
	            PostSpan.style.display = "none";
	            PostNotice.checked = false;
	            
	            admin_NO.checked = false;
	            access_NO.checked = false;
	            list_NO.checked = false;
	            read_NO.checked = false;
	            write_NO.checked = false;
	            reply_NO.checked = false;
	            delete_NO.checked = false;
	            inherit_NO.checked = false;
	            
	            access_NO.disabled = false;
                list_NO.disabled = false;
                read_NO.disabled = false;
                write_NO.disabled = false;
                reply_NO.disabled = false;
                delete_NO.disabled = false;
	        }
	        
	        function CheckBoxInit2() {
	            admin_OK.checked = false;
	            access_OK.checked = false;
	            list_OK.checked = false;
	            read_OK.checked = false;
	            write_OK.checked = false;
	            reply_OK.checked = false;
	            delete_OK.checked = false;
	            inherit_OK.checked = false;
	            PostSpan.style.display = "none";
	            PostNotice.checked = false;
	
	            admin_NO.checked = true;
	            access_NO.checked = true;
	            list_NO.checked = true;
	            read_NO.checked = true;
	            write_NO.checked = true;
	            reply_NO.checked = true;
	            delete_NO.checked = true;
	            inherit_NO.checked = true;
	            
	            access_NO.disabled = false;
                list_NO.disabled = false;
                read_NO.disabled = false;
                write_NO.disabled = false;
                reply_NO.disabled = false;
                delete_NO.disabled = false;
	        }
	        
	        function FillACLTable() {
	            CheckBoxInit();
	
	            var xmlhttp = createXMLHttpRequest();
	            xmlhttp.open("POST", "/admin/ezBoard/getACL.do?boardID=" + encodeURIComponent(pBoardID) + "&accessID=" + selectedTargetID, false);
	            xmlhttp.send();
	
	            var xmldom = createXmlDom();
	            xmldom.async = false;
	            xmldom.preserveWhiteSpace = true;
	
	            xmldom = loadXMLString(xmlhttp.responseText);
	
	            xmlhttp = null;
	
	            if (getNodeText(SelectNodes(xmldom, "NODES/NODE/ACCESS")[0]) == "1") {
	                access_OK.checked = true;
	            } else {
	                access_NO.checked = true;
	            }
	            if (getNodeText(SelectNodes(xmldom, "NODES/NODE/BOARDADMIN")[0]) == "true") {
	                admin_OK.checked = true;
	                PostSpan.style.display = "";
	                
		            if (pBoardID == "{MMMMMMMM-MMMM-MMMM-MMMM-MMMMMMMMMMMM}") {
		            	PostSpan.style.display = "none";
		            }
		            
	                PostNotice.checked = false;
	            } else {
	                admin_NO.checked = true;
	                PostSpan.style.display = "none";
	                PostNotice.checked = false;
	            }
	            if (getNodeText(SelectNodes(xmldom, "NODES/NODE/LIST")[0]) == "true") {
	                list_OK.checked = true;
	            } else {
	                list_NO.checked = true;
	            }
	            if (getNodeText(SelectNodes(xmldom, "NODES/NODE/READ")[0]) == "true") {
	                read_OK.checked = true;
	            } else {
	                read_NO.checked = true;
	            }
	            if (getNodeText(SelectNodes(xmldom, "NODES/NODE/WRITE")[0]) == "true") {
	                write_OK.checked = true;
	            } else {
	                write_NO.checked = true;
	            }
	            if (getNodeText(SelectNodes(xmldom, "NODES/NODE/REPLY")[0]) == "true") {
	                reply_OK.checked = true;
	            } else {
	                reply_NO.checked = true;
	            }
	            if (getNodeText(SelectNodes(xmldom, "NODES/NODE/DELETE")[0]) == "true") {
	                delete_OK.checked = true;
	            } else {
	                delete_NO.checked = true;
	            }
	            if (getNodeText(SelectNodes(xmldom, "NODES/NODE/INHERIT")[0]) == "true") {
	                inherit_OK.checked = true;
	            } else {
	                inherit_NO.checked = true;
	            }
	            if (getNodeText(SelectNodes(xmldom, "NODES/NODE/POSTNOTICE")[0]) == "true") {
	                PostNotice.checked = true;
	            } else {
	                PostNotice.checked = false;
	            }
	
	            xmldom = null;
	            
	            /* 2018-09-03 홍승비 - 관리자 권한을 가진 경우 모든 권한 '허용'에 고정 */
	            if (admin_OK.checked == true) {
					access_OK.checked = true;
	                list_OK.checked = true;
	                read_OK.checked = true;
	                write_OK.checked = true;
	                reply_OK.checked = true;
	                delete_OK.checked = true;
	
	                access_NO.checked = false;
	                list_NO.checked = false;
	                read_NO.checked = false;
	                write_NO.checked = false;
	                reply_NO.checked = false;
	                delete_NO.checked = false;
	                
	                access_NO.disabled = true;
	                list_NO.disabled = true;
	                read_NO.disabled = true;
	                write_NO.disabled = true;
	                reply_NO.disabled = true;
	                delete_NO.disabled = true;
	            }
	
	            // 게시판 그룹의 경우, 오직 '관리자'와 '접근' 권한만 설정 가능.
	            if (pParentBoardID == "top") {
	                list_OK.checked = false;
	                list_NO.checked = true;
	                read_OK.checked = false
	                read_NO.checked = true;
	                write_OK.checked = false;
	                write_NO.checked = true;
	                reply_OK.checked = false;
	                reply_NO.checked = true;
	                delete_OK.checked = false;
	                delete_NO.checked = true;
	                PostNotice.checked = false;
	                
	                list_OK.disabled = true;
                    list_NO.disabled = true;
                    read_OK.disabled = true
                    read_NO.disabled = true;
                    write_OK.disabled = true;
                    write_NO.disabled = true;
                    reply_OK.disabled = true;
                    reply_NO.disabled = true;
                    delete_OK.disabled = true;
                    delete_NO.disabled = true;
	                PostNotice.disabled = true;
	            }
	        }
	
	        function ReplaceText(orgStr, findStr, replaceStr) {
	            var re = new RegExp(findStr, "gi");
	            return (orgStr.replace(re, replaceStr));
	        }
	
	        function MakeXMLString(str) {
	            str = ReplaceText(str, "&", "&amp;");
	            str = ReplaceText(str, "<", "&lt;");
	            str = ReplaceText(str, ">", "&gt;");
	            return str;
	        }
	        function goBoardList() {
	            if (pType == "3") {
	                if(pParentNeed == "Y")
	                    location.href = "/ezBoard/boardItemListPhoto.do?boardID=" + encodeURIComponent(pBoardID) + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=" + pType;
	                else
	                    location.href = "/ezBoard/boardItemListPhoto.do?adminType=y&boardID=" + encodeURIComponent(pBoardID) + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=" + pType;
	            }
	            else if (pType == "4") {
	                if (pParentNeed == "Y")
	                    location.href = "/ezBoard/boardItemListThumbnail.do?boardID=" + encodeURIComponent(pBoardID) + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=" + pType;
	                else
	                    location.href = "/ezBoard/boardItemListThumbnail.do?adminType=y&boardID=" + encodeURIComponent(pBoardID) + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=" + pType;
	            } else if (pType == "7") {
	            	 if (pParentNeed == "Y")
						location.href = "/ezBoard/boardItemListMovie.do?boardID=" + encodeURIComponent(pBoardID) + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=" + pType;
	                else
	                    location.href = "/ezBoard/boardItemListMovie.do?adminType=y&boardID=" + encodeURIComponent(pBoardID) + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=" + pType;
	            }
	            else {
	                if(pParentNeed == "Y")
	                    location.href = "/ezBoard/boardItemList.do?boardID=" + encodeURIComponent(pBoardID) + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=" + pType;
	                else
	                    location.href = "/ezBoard/boardItemList.do?adminType=y&boardID=" + encodeURIComponent(pBoardID) + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=" + pType;
	            }
	        }
	        
	        /* 2018-09-03 홍승비 - 권한복사팝업 열리는 위치 수정 */
	        function AclCopy() {
	            var listview = new ListView();
	            listview.LoadFromID("AccessListView");
	            var selnode = listview.GetSelectedRows();
	            if (selnode.length == 0) {
	                alert('<spring:message code="ezBoard.t600"/>');
	                return;
	            }
	            var pheigth = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            pheigth = parseInt(pheigth) / 2;
	            pwidth = parseInt(pwidth) / 2;
	            pheigth = pheigth - 330;
	            pwidth = pwidth - 350;
	            window.open("/admin/ezBoard/boardAclList.do?boardID=" + encodeURIComponent(pBoardID) + "&parentBoardID=" + encodeURIComponent(pParentBoardID), "", "height=660,width=700px, status = no, toolbar=no, menubar=no, location=no, resizable=1, top=" + pheigth + ",left = " + pwidth, "");
	        }
	        
	        /* 2019-01-28 홍승비 - 권한전파 시 그룹사게시판 파라미터 전달, 사용하지 않는 부모게시판 파라미터 제거 */
	        function UnderBoardCopy() {
	            var pheigth = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            pheigth = parseInt(pheigth) / 2;
	            pwidth = parseInt(pwidth) / 2;
	            pheigth = pheigth - 192;
	            pwidth = pwidth - 260;
	            window.open("/admin/ezBoard/boardUnderGroupCopy.do?boardID=" + encodeURIComponent(pBoardID) + "&isAllGroupBoard=${isAllGroupBoard}", "", "height=170,width=510px, status = no, toolbar=no, menubar=no, location=no, resizable=1, top=" + pheigth + ",left = " + pwidth, "");
	        }
	        
	        /* 2019-09-19 홍승비 - 권한그룹이 추가된 새로운 권한설정 기능 추가 */
			var selecttargetNew_dialogArguments = new Array();
	        function SelectTargetNew() {
	            var receiverData = new Array();
	            receiverData["window"] = this;
	            receiverData["selectTargetListXML"] = selectTargetListXML;
	            selecttargetNew_dialogArguments[0] = receiverData;
	            selecttargetNew_dialogArguments[1] = SelectTargetNew_Complete;
	            //selecttargetNew_dialogArguments[2] = "${isAllGroupBoard}"; // 그룹사게시판인 경우, 조직도에 전체 회사 + 전체 권한그룹 표출 필요
	            var SelectTarget = window.open("/admin/ezBoard/selectTargetGroup.do?isAllGroupBoard=${isAllGroupBoard}" , "SelectTargetNew", GetOpenWindowfeature(970, 645));
	            try { SelectTarget.focus(); } catch (e) {
	            }
	        }
	        
	        function SelectTargetNew_Complete(ret) {
	            _type = false;
	            if (typeof (ret) != "undefined") {
	                selectTargetListXML = ret;
	                
	                if (admin_OK.checked == false && admin_NO.checked == false) {
	                    CheckBoxInit2();
	                }
	            }
	            
	            if (selectTargetListXML == "" || selectTargetListXML == "<DATA></DATA>") {
	                CheckBoxInit();
	            }
	        }
	        
	    </script>
		</head>
		<c:if test="${pParentNeed == 'Y'}">
			<body class="mainbody">
		</c:if>
		<c:if test="${pParentNeed != 'Y'}">
			<body class="tabbody" style="overflow-y:auto;">
		</c:if>
		<xml id="listviewheader" style="display: none">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <TYPE>NONE</TYPE>
		        <NAME><spring:message code='ezBoard.t39'/></NAME>
		        <WIDTH>35</WIDTH>
		        <SORTABLE>TRUE</SORTABLE>
		        <RESIZIBLE>TRUE</RESIZIBLE>
		        <MINSIZE>10</MINSIZE>
		        <MAXSIZE>353</MAXSIZE>
		        <NOWRAP>TRUE</NOWRAP>
		        <STYLE>border-top:0px;</STYLE>
		      </HEADER>
		      <HEADER>
		        <TYPE>NONE</TYPE>
		        <NAME><spring:message code='ezBoard.t9'/></NAME>
		        <WIDTH>35</WIDTH>
		        <SORTABLE>TRUE</SORTABLE>
		        <RESIZIBLE>TRUE</RESIZIBLE>
		        <MINSIZE>10</MINSIZE>
		        <MAXSIZE>353</MAXSIZE>
		        <NOWRAP>TRUE</NOWRAP>
		        <STYLE>border-top:0px;</STYLE>
		      </HEADER>
		      <HEADER>
		        <TYPE>NONE</TYPE>
		        <NAME><spring:message code='ezBoard.t11'/></NAME>
		        <WIDTH>35</WIDTH>
		        <SORTABLE>TRUE</SORTABLE>
		        <RESIZIBLE>TRUE</RESIZIBLE>
		        <MINSIZE>10</MINSIZE>
		        <MAXSIZE>353</MAXSIZE>
		        <NOWRAP>TRUE</NOWRAP>
		        <STYLE>border-top:0px;</STYLE>
		      </HEADER>
		      <HEADER>
		        <TYPE>NONE</TYPE>
		        <NAME><spring:message code='ezBoard.t37'/></NAME>
		        <WIDTH>35</WIDTH>
		        <SORTABLE>TRUE</SORTABLE>
		        <RESIZIBLE>TRUE</RESIZIBLE>
		        <MINSIZE>10</MINSIZE>
		        <MAXSIZE>353</MAXSIZE>
		        <NOWRAP>TRUE</NOWRAP>
		        <STYLE>border-top:0px;</STYLE>
		      </HEADER>
		      <HEADER>
		        <TYPE>NONE</TYPE>
		        <NAME><spring:message code='ezBoard.t84'/></NAME>
		        <WIDTH>20</WIDTH>
		        <STYLE>text-align:center;border-top:0px;</STYLE>
		        <SORTABLE>TRUE</SORTABLE>
		        <RESIZIBLE>TRUE</RESIZIBLE>
		        <MINSIZE>10</MINSIZE>
		        <MAXSIZE>190</MAXSIZE>
		        <NOWRAP>TRUE</NOWRAP>
		      </HEADER>
		      <HEADER>
		        <TYPE>NONE</TYPE>
		        <NAME><spring:message code='ezBoard.t83'/></NAME>
		        <WIDTH>20</WIDTH>
		        <STYLE>text-align:center;border-top:0px;</STYLE>
		        <SORTABLE>TRUE</SORTABLE>
		        <RESIZIBLE>TRUE</RESIZIBLE>
		        <MINSIZE>10</MINSIZE>
		        <MAXSIZE>190</MAXSIZE>
		        <NOWRAP>TRUE</NOWRAP>
		      </HEADER>
		      <HEADER>
		        <TYPE>NONE</TYPE>
		        <NAME><spring:message code='ezBoard.t102'/></NAME>
		        <WIDTH>20</WIDTH>
		        <STYLE>text-align:center;border-top:0px;</STYLE>
		        <SORTABLE>TRUE</SORTABLE>
		        <RESIZIBLE>TRUE</RESIZIBLE>
		        <MINSIZE>10</MINSIZE>
		        <MAXSIZE>190</MAXSIZE>
		        <NOWRAP>TRUE</NOWRAP>
		      </HEADER>
		      <HEADER>
		        <TYPE>NONE</TYPE>
		        <NAME><spring:message code='ezBoard.t86'/></NAME>
		        <WIDTH>20</WIDTH>
		        <STYLE>text-align:center;border-top:0px;</STYLE>
		        <SORTABLE>TRUE</SORTABLE>
		        <RESIZIBLE>TRUE</RESIZIBLE>
		        <MINSIZE>10</MINSIZE>
		        <MAXSIZE>190</MAXSIZE>
		        <NOWRAP>TRUE</NOWRAP>
		      </HEADER>
		      <HEADER>
		        <TYPE>NONE</TYPE>
		        <NAME><spring:message code='ezBoard.t87'/></NAME>
		        <WIDTH>20</WIDTH>
		        <STYLE>text-align:center;border-top:0px;</STYLE>
		        <SORTABLE>TRUE</SORTABLE>
		        <RESIZIBLE>TRUE</RESIZIBLE>
		        <MINSIZE>10</MINSIZE>
		        <MAXSIZE>190</MAXSIZE>
		        <NOWRAP>TRUE</NOWRAP>
		      </HEADER>
		      <HEADER>
		        <TYPE>NONE</TYPE>
		        <NAME><spring:message code='ezBoard.t88'/></NAME>
		        <WIDTH>20</WIDTH>
		        <STYLE>text-align:center;border-top:0px;</STYLE>
		        <SORTABLE>TRUE</SORTABLE>
		        <RESIZIBLE>TRUE</RESIZIBLE>
		        <MINSIZE>10</MINSIZE>
		        <MAXSIZE>190</MAXSIZE>
		        <NOWRAP>TRUE</NOWRAP>
		      </HEADER>
		      <HEADER>
		        <TYPE>NONE</TYPE>
		        <NAME><spring:message code='ezBoard.t00051'/></NAME>
		        <WIDTH>20</WIDTH>
		        <STYLE>text-align:center;border-top:0px;</STYLE>
		        <SORTABLE>TRUE</SORTABLE>
		        <RESIZIBLE>TRUE</RESIZIBLE>
		        <MINSIZE>10</MINSIZE>
		        <MAXSIZE>190</MAXSIZE>
		        <NOWRAP>TRUE</NOWRAP>
		      </HEADER>
		      <HEADER>
		        <TYPE>NONE</TYPE>
		        <NAME><spring:message code='ezBoard.t00052'/></NAME>
		        <WIDTH>20</WIDTH>
		        <STYLE>text-align:center;border-top:0px;</STYLE>
		        <SORTABLE>TRUE</SORTABLE>
		        <RESIZIBLE>TRUE</RESIZIBLE>
		        <MINSIZE>10</MINSIZE>
		        <MAXSIZE>190</MAXSIZE>
		        <NOWRAP>TRUE</NOWRAP>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
        <c:if test="${pParentNeed == 'Y'}">	
	        <h1><spring:message code='ezBoard.t63'/></h1>
		</c:if>
		<c:if test="${pParentNeed != 'Y'}">
			<br />
		</c:if>
		<div id="mainmenu">
            <ul>
				<c:if test="${adminType == 'y'}">
	                <li><span onclick="goBoardList()"><spring:message code='ezBoard.t72'/></span></li>
	                <!-- <li style="background:none; padding-right:2px; cursor:default;" class="off"><img src="/images/i_bar.gif" alt=""></li> -->
				</c:if>
				<%-- 2019-09-19 홍승비 - 권한그룹 추가된 새로운 권한설정팝업 UI 추가, 기존권한 추가버튼 주석처리 --%>
            	<li class="important"><span onclick="SelectTargetNew()"><spring:message code='ezBoard.t602'/></span></li>
            	<%--<li class="important"><span onclick="SelectTarget()"><spring:message code='ezBoard.t602'/></span></li>--%>
            	<li><span onclick="SaveACL()"><spring:message code='ezBoard.t98'/></span></li>
                <!-- <li style="background:none; padding-right:2px; cursor:default;" class="off"><img src="/images/i_bar.gif" alt=""></li> -->
            <%-- 2019-01-22 홍승비 - 그룹사게시판 -> 권한설정기능 표출, 권한복사 숨김 --%>
			<c:if test="${isAllGroupBoard != 'Y'}">
			<c:if test="${isBoardAdmin == 'YES'}">
            	<li><span onclick="AclCopy()"><spring:message code='ezBoard.t604'/></span></li>
			</c:if>
			</c:if>
			<c:if test="${isBoardAdmin == 'YES'}">
            	<li><span onclick="UnderBoardCopy()"><spring:message code='ezBoard.t605'/></span></li>
			</c:if>
            	<li><span onclick="DeleteACL('type')"><spring:message code='ezBoard.t603'/></span></li>
            	<li><span onclick="DeleteACL('one')"><spring:message code='ezBoard.t89'/></span></li>
            	<!-- <li style="background:none; padding-right:2px; cursor:default;" class="off"><img src="/images/i_bar.gif" alt=""></li> -->
            </ul>
        </div>
        <script type="text/javascript">
	        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	    </script>
        <script type="text/javascript">
            try{
                parent.document.getElementsByTagName("h1")[0].innerHTML = "<spring:message code='ezBoard.t63'/>";
            }
            catch (e){
                document.getElementsByTagName("h1")[0].innerHTML = "<spring:message code='ezBoard.t63'/>";
            }
        </script>
        <table class="content">
            <tr>
                <th><spring:message code='ezBoard.t92'/></th>
                <td class="point"><c:out value='${boardName}' /></td>
            </tr>
        </table>
        <br>
        <div class="listview">
            <div id="AccessList" style="BORDER: 0; HEIGHT: 250px; WIDTH: 100%; overflow:auto;"></div>
        </div>
        <%-- 2018-05-15 천성준 - 프레임 상단으로 버튼 위치변경
        <a class="imgbtn" style="margin-top:5px;margin-bottom:5px;"><span onclick="SelectTarget()"><spring:message code='ezBoard.t602'/></span></a>
		<a class="imgbtn" style="margin-top:5px;margin-bottom:5px;"><span onclick="SaveACL()"><spring:message code='ezBoard.t98'/></span></a>
		<a class="imgbtn" style="margin-top:5px;margin-bottom:5px;"><span onclick="DeleteACL('one')"><spring:message code='ezBoard.t89'/></span></a>
		<a class="imgbtn" style="margin-top:5px;margin-bottom:5px;"><span onclick="DeleteACL('type')"><spring:message code='ezBoard.t603'/></span></a>
		<a class="imgbtn" style="margin-top:5px;margin-bottom:5px;"><span onclick="AclCopy()"><spring:message code='ezBoard.t604'/></span></a>
		<a class="imgbtn" style="margin-top:5px;margin-bottom:5px;"><span onclick="UnderBoardCopy()"><spring:message code='ezBoard.t605'/></span></a>
        --%>
        <br> 
        <table class="content" style="width:100%;">
            <tr style="display: none">
                <th><spring:message code='ezBoard.t93'/><br>
                    (<spring:message code='ezBoard.t94'/></th>
                <td>
                	<div class="custom_checkbox">
	                    <input type="checkbox" id="inherit_OK" onclick="checkbox_onclick(event)">
                	</div>
                    <spring:message code='ezBoard.t95'/>
                	<div class="custom_checkbox">
	                    <input type="checkbox" id="inherit_NO" onclick="checkbox_onclick(event)">
                	</div>
                    <spring:message code='ezBoard.t96'/></td>
            </tr>
            <tr>
                <th style="">
                    <spring:message code='ezBoard.t606'/>
                </th>
                <td style="vertical-align: middle;">
                    <span id="selectedTarget" style="vertical-align: middle;"></span>&nbsp;
                </td>
            </tr>
            <tr>
                <th><spring:message code='ezBoard.t84'/></th>
                <td>
                	<div class="custom_checkbox">
	                    <input type="checkbox" id="admin_OK" onclick="checkbox_onclick(event)">
                	</div>
                    &nbsp;<spring:message code='ezBoard.t99'/>
                	<div class="custom_checkbox">
	                    <input type="checkbox" id="admin_NO" onclick="checkbox_onclick(event)">
                	</div>
                    &nbsp;<spring:message code='ezBoard.t100'/><span id="PostSpan">
	                	<div class="custom_checkbox">
	                        <input type="checkbox" id="PostNotice" onclick="checkbox_onclick(event)">
	                	</div>
                        &nbsp;<spring:message code='ezNotification.hth36'/></span></td>
            </tr>
            <tr>
                <th><spring:message code='ezBoard.t83'/></th>
                <td>
                	<div class="custom_checkbox">
	                    <input type="checkbox" id="access_OK" onclick="checkbox_onclick(event)">
                	</div>
                    &nbsp;<spring:message code='ezBoard.t99'/>
                	<div class="custom_checkbox">
	                    <input type="checkbox" id="access_NO" onclick="checkbox_onclick(event)">
                	</div>
                    &nbsp;<spring:message code='ezBoard.t96'/></td>
            </tr>
            <tr>
                <th><spring:message code='ezBoard.t102'/></th>
                <td>
                	<div class="custom_checkbox">
	                    <input type="checkbox" id="list_OK" onclick="checkbox_onclick(event)">
                	</div>
                    &nbsp;<spring:message code='ezBoard.t99'/>
                	<div class="custom_checkbox">
	                    <input type="checkbox" id="list_NO" onclick="checkbox_onclick(event)">
                	</div>
                    &nbsp;<spring:message code='ezBoard.t96'/></td>
            </tr>
            <tr>
                <th><spring:message code='ezBoard.t86'/></th>
                <td>
                	<div class="custom_checkbox">
	                    <input type="checkbox" id="read_OK" onclick="checkbox_onclick(event)">
                	</div>
                    &nbsp;<spring:message code='ezBoard.t99'/>
                	<div class="custom_checkbox">
	                    <input type="checkbox" id="read_NO" onclick="checkbox_onclick(event)">
                	</div>
                    &nbsp;<spring:message code='ezBoard.t96'/></td>
            </tr>
            <tr>
                <th><spring:message code='ezBoard.t87'/></th>
                <td>
                	<div class="custom_checkbox">
	                    <input type="checkbox" id="write_OK" onclick="checkbox_onclick(event)">
                	</div>
                    &nbsp;<spring:message code='ezBoard.t99'/>
                	<div class="custom_checkbox">
	                    <input type="checkbox" id="write_NO" onclick="checkbox_onclick(event)">
                	</div>
                    &nbsp;<spring:message code='ezBoard.t96'/></td>
            </tr>
            <tr id="replyTR">
                <th><spring:message code='ezBoard.t88'/></th>
                <td>
                	<div class="custom_checkbox">
	                    <input type="checkbox" id="reply_OK" onclick="checkbox_onclick(event)">
                	</div>
                    &nbsp;<spring:message code='ezBoard.t99'/>
                	<div class="custom_checkbox">
	                    <input type="checkbox" id="reply_NO" onclick="checkbox_onclick(event)">
                	</div>
                    &nbsp;<spring:message code='ezBoard.t96'/></td>
            </tr>
            <tr>
                <th><spring:message code='ezBoard.t103'/></th>
                <td>
                	<div class="custom_checkbox">
	                    <input type="checkbox" id="delete_OK" onclick="checkbox_onclick(event)">
                	</div>
                    &nbsp;<spring:message code='ezBoard.t99'/>
                	<div class="custom_checkbox">
	                    <input type="checkbox" id="delete_NO" onclick="checkbox_onclick(event)">
                	</div>
                    &nbsp;<spring:message code='ezBoard.t96'/></td>
            </tr>
        </table>
        <br>
    </body>
</html>