<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code="ezLadder.t071" /></title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('/css/ezLadder/ladder_CSS.css')}">
	    <style>
	    	.mainlist tr td:first-child {
	    		padding-left:15px;
	    	}
	    	.mainlist_free tr td{
	    		height:28px;
	    	}
	    	.mainlist_free tr td input{
	    		height:24px;
	    	}
	    	/* 조직도 #SelectDeptNM(부서명[사원수]) 부분 */
			#spn_deptName {
				text-overflow: ellipsis;
				white-space: nowrap;
				overflow: hidden;
				display: inline-block;
			}
			#countInfo {
				overflow: hidden;
				display: inline-block;
			}
			.imgbck.ladder {
				margin-top: -30px !important;
			}	    	
	    </style>
	    <script type="text/javascript" src="${util.addVer('ezLadder.e1', 'msg')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/ezLadder/TreeView.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezLadder/ListView_list.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>        
        <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
		
		<script type="text/javascript">
			var pStartTime = "<c:out value='${startTime}' />";
	        var pEndTime = "<c:out value='${endTime}' />";
	        var pGubun = "<c:out value='${gubun}' />";
	        var type = "<c:out value='${type}' />";
	        var bSearch = false;
	        var UserAgentState = navigator.userAgent.toLowerCase();
	        var browserIE = (UserAgentState.indexOf("msie") != -1) ? true : false;
	        var pListType = "TXT";
	        var pListXML_Info = null;
	        var CurPage = "1";
	        var strSearch = "<c:out value='${pSearchString}' />";
	        var RetValue;
	        var ReturnFunction;
	        var deptClickFlag;
	        var attendants;
	        var tabStatus;	// tab1 : circularOrgan.(조직도) tab2 : circularDept (즐겨찾기)
	        var rowId;		// 즐겨찾기 목록 번호
	        
	        document.onselectstart = function () { return false; };
	        if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
	            window.onblur = function () {
	                //window.focus();
	            }
	        }
	        document.onkeydown = function (evt) {
	            var e = evt;
	            if (e == null) e = window.event;
	            if (new RegExp(/Safari/).test(navigator.userAgent) && navigator.userAgent.indexOf("Chrome") == -1) {
	                if ((e.keyCode > 47) && (e.keyCode < 58)) {
	                    e.preventDefault();
	                }
	                else if ((e.keyCode > 95) && (e.keyCode < 106)) {
	                    e.preventDefault();
	                }
	                else if ((e.keyCode > 64) && (e.keyCode < 91)) {
	                    e.preventDefault();
	                }
	                else if ((e.keyCode == 106) ||
	                    (e.keyCode == 107) ||
	                    (e.keyCode == 109) ||
	                    (e.keyCode == 110) ||
	                    (e.keyCode == 111) ||
	                    (e.keyCode == 186) ||
	                    (e.keyCode == 187) ||
	                    (e.keyCode == 188) ||
	                    (e.keyCode == 189) ||
	                    (e.keyCode == 190) ||
	                    (e.keyCode == 191) ||
	                    (e.keyCode == 192) ||
	                    (e.keyCode == 219) ||
	                    (e.keyCode == 220) ||
	                    (e.keyCode == 221) ||
	                    (e.keyCode == 222)) {
	                    e.preventDefault();
	                }
	                else if ((e.keyCode == 229)) {
	                    e.returnValue = false;
	                }
	            }
	        }
	        window.onload = function () {
	        	tabStatus="circularOrgan";
	        	
	            try {
	                RetValue = parent.ladder_select_attendant_dialogArguments[0];
	                ReturnFunction = parent.ladder_select_attendant_dialogArguments[1];
	            } catch (e) {
	                try {
	                    RetValue = opener.ladder_select_attendant_dialogArguments[0];
	                    ReturnFunction = opener.ladder_select_attendant_dialogArguments[1];
	                } catch (e) {
	                    RetValue = window.dialogArguments;
	                }
	            }
	            
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }
	            if (pGubun == "") {
	//	                document.getElementById("btnAddUser").style.display = "";
	                if (CrossYN())
	                    document.getElementById("ToTitleStr").textContent = "<spring:message code='ezLadder.t013'/>";
	                else
	                    document.getElementById("ToTitleStr").innerText = "<spring:message code='ezLadder.t013'/>";
	            }
	
	            $("#1tab1").click();
	            ChangeTab(document.getElementById("1tab1"));
	            getLadderBmList();
	            ListTypeChangeIcon();
	            recevieListview("MsgToList", "ListViewMsgTo");
	            
	            try {
	            	var xmlpara = createXmlDom();
	            	var xmlTree = createXmlDom();
	            	var xmlHTTP = createXMLHttpRequest();
	            	var objNode;
	            	createNodeInsert(xmlpara, objNode, "DATA");
	            	createNodeAndInsertText(xmlpara, objNode, "DEPTID", "<c:out value='${deptID}' />");
	            	createNodeAndInsertText(xmlpara, objNode, "TOPID", "Top");
	            	createNodeAndInsertText(xmlpara, objNode, "PROP", "");
	            	xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
	            	xmlHTTP.send(xmlpara);
	            	xmlTree = loadXMLString(xmlHTTP.responseText);
	            	var treeXML = loadXMLFile("/xml/common/organtree_config3.xml");
	            	document.getElementById('TreeView').innerHTML = "";
	            	var treeView = new TreeView();
	            	treeView.SetConfig(treeXML);
	            	treeView.SetID("FromTreeView");
	            	treeView.SetUseAgency(true);
	            	treeView.SetRequestData("RequestData");
	            	treeView.SetNodeClick("TreeViewNodeClick");
	            	treeView.DataSource(xmlTree);
	            	treeView.DataBind("TreeView");
	            	
	                if (type == "group") {
	                    document.getElementById("ToTitleStr").textContent = "<spring:message code='ezLadder.t013'/>";	
	                }
	            }
	            catch (ErrMsg) {
	                alert(" TreeViewinitialize : " + ErrMsg.description);
	            }
	            
	            var listView = new ListView();
	            listView.LoadFromID("MsgToList");
	
	            var totalRows = listView.GetDataRows();
	            var totalLen = totalRows.length;
	
	            var stridlength = 0;
	            
	            attendants = RetValue["attend"];
	            if(!!attendants && !! attendants["id"]) {
	                stridlength = attendants["id"].length;
	            }
	
	            for (var i = 0; i < stridlength; i++) {
	                var pparsingXML = "";
	                var pparsingXML2 = "";
	
	                pparsingXML2 = "<LISTVIEWDATA2><ROWS>"
	                var strId;
	                var strName;
	                var strName2;
	                var strPic;
	                var item;
	                var description;
	                var description2;
	
	                strId = attendants["id"][i];
	                strName = attendants["name"][i];
	                strName2 = attendants["name2"][i];
	                strPic = attendants["pic"][i];
	                item = RetValue["item"][i];
	          	    description = attendants["description"][i];
	                description2 = attendants["description2"][i];
	
	                pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + strId + "</DATA1>";
	                pparsingXML = pparsingXML + "<DATA2><![CDATA[" + strName + "]]></DATA2>";
	                pparsingXML = pparsingXML + "<DATA3><![CDATA[" + strName2 + "]]></DATA3>";
	                pparsingXML = pparsingXML + "<DATA4><![CDATA[" + strPic + "]]></DATA4>";
	                pparsingXML = pparsingXML + "<DATA5><![CDATA[" + item + "]]></DATA5>";
	                pparsingXML = pparsingXML + "<DATA7><![CDATA[" + description + "]]></DATA7>";
	                pparsingXML = pparsingXML + "<DATA8><![CDATA[" + description2 + "]]></DATA8>";
	                pparsingXML = pparsingXML + "<VALUE><![CDATA[" + strName + "]]></VALUE></CELL></ROW>";
	                
	                pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
	                var Resultxml = loadXMLString(pparsingXML2);
	                
	                var listview = new ListView();
	                listview.LoadFromID("MsgToList");
	
	                var MaxID = 0;
	                var InitTr = listview.GetDataRows();
	
	                for (var j = 0  ; j < InitTr.length  ; j++) {
	                    var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
	                    if (MaxID < curnum)
	                        MaxID = curnum;
	                }
	
	                var objTr = listview.AddRow(InitTr.length);
	                SetAttribute(objTr, "id", listview.GetSelectedRowID(InitTr.length).substring(0, listview.GetSelectedRowID(InitTr.length).lastIndexOf('_') + 1) + eval(MaxID + 1));
	                
	                listview.AddDataRow(objTr, Resultxml);
	            }
	        }
	        
	        var schedule_add_user_cross_dialogArguments = new Array();
	        function Add_UserInfo_onclick() {
	            var listView = new ListView();
	            listView.LoadFromID("MsgToList");
	
	            var totalRows = listView.GetDataRows();
	            var totalLen = totalRows.length;
	
	            if (totalLen == 0) {
	                alert("<spring:message code='ezLadder.t030' />");
	                return;
	            }
	
	            var rtn = { "id": new Array(), "name": new Array(), "deptname": new Array() };
	
	            for (var i = 0; i < totalLen; i++) {
	                rtn["name"][i] = GetAttribute(totalRows[i], "DATA2");
	                rtn["id"][i] = GetAttribute(totalRows[i], "DATA1");
	                rtn["deptname"][i] = GetAttribute(totalRows[i], "DATA4");
	            }
	
	            var g_param = new Array();
	
	            g_param["startTime"] = pStartTime;
	            g_param["endTime"] = pEndTime;
	            g_param["entryList"] = rtn;
	
	            var cmd, org_num, org_ownerID;
	
	            var feature = GetShowModalPosition(695, 430);
	            if (CrossYN()) {
	                schedule_add_user_cross_dialogArguments[0] = g_param;
	                schedule_add_user_cross_dialogArguments[1] = Add_UserInfo_onclick_Complete;
	                var OpenWin = window.open("/ezSchedule/scheduleAddUser.do?cmd=" + cmd + "&num=" + org_num + "&ownerID=" + org_ownerID, "schedule_Add_User_Cross", GetOpenWindowfeature(695, 430));
	                try { OpenWin.focus(); } catch (e) { }
	            } else{
	                var reParam = window.showModalDialog("/ezSchedule/scheduleAddUser.do?cmd=" + cmd + "&num=" + org_num + "&ownerID=" + org_ownerID, g_param, "edge:sunken; dialogHeight:430px;scroll:no; dialogWidth:695px; status:no; help:no" + feature);
	                if (typeof (reParam) != "undefined" && reParam != null) {
	                    idDatepicker.vtLocalDate = reParam["startTime"];
	                    idDatepicker.vtLocalEndDate = reParam["endTime"];
	
	                    if (reParam["entryList"] != "") {
	                        xmpEntryEmailList.innerText = reParam["entryList"];
	
	                        DisplayEntryList();
	                    }
	                }
	            }
	        }
	
	        function Add_UserInfo_onclick_Complete(reParam) {
	            idDatepicker.vtLocalDate = reParam["startTime"];
	            idDatepicker.vtLocalEndDate = reParam["endTime"];
	
	            if (reParam["entryList"] != "") {
	                xmpEntryEmailList.innerText = reParam["entryList"];
	                DisplayEntryList();
	            }
	        }
	        function RequestData(pNodeID, pTreeID) {
		        var TreeIdx = pNodeID;
		        var treeNode = new TreeNode();
	    	    treeNode.LoadFromID(TreeIdx);
	        	var deptID = treeNode.GetNodeData("CN");
	        	GetDeptSubTreeInfo(deptID, TreeIdx);
	    	}
	    	function GetDeptSubTreeInfo(deptID, TreeIdx) {
		        var xmlHTTP = createXMLHttpRequest();
		        var xmlRtn = createXmlDom();
	    	    var xmlpara = createXmlDom();
		        var objNode;
	        	createNodeInsert(xmlpara, objNode, "DATA");
	        	createNodeAndInsertText(xmlpara, objNode, "DEPTID", deptID);
	        	createNodeAndInsertText(xmlpara, objNode, "PROP", "mail;displayName");
	        	xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
	        	xmlHTTP.send(xmlpara);
	        	xmlRtn = loadXMLString(xmlHTTP.responseText);
	        	if (SelectNodes(xmlRtn, "NODES/NODE/VALUE").length > 0) {
		            if (CrossYN()) {
		                xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
	    	        } else {
	                	xmlRtn.selectNodes("NODES/NODE")[0].appendChild(xmlRtn.selectNodes("NODES/NODE/VALUE")[0]);
	            	}
	        	}
	        	var treeView = new TreeView();
	        	treeView.LoadFromID("FromTreeView");
	        	treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
	    	}
	        function recevieListview(pID, pListView) {
	            var listview = new ListView();
	            listview.SetID(pID);
	            listview.SetHeightFree(true);
	            listview.SetSelectFlag(false);
	            listview.SetMulSelectable(true);
	            listview.SetRowOnDblClick("DeleteReceiver");
	            listview.DataSource(loadXMLString("<LISTVIEWDATA></LISTVIEWDATA>"));
	            listview.DataBind(pListView);
	            listview.RowDataBind();
	        }
	        
	        /*
	         *  [조직도 탭]  참여자 더블 클릭 || <- 화살표 버튼 클릭  
	         *  [즐겨찾기 탭] 참여자 더블 클릭
	         *   참여자 삭제
	         */
	        function DeleteReceiver(pListView) {
	        	var selList = new ListView();
	            selList.LoadFromID("MsgToList");
	            var arrRows = selList.GetSelectedRows();
	            
	        	for (var i = 0; i < arrRows.length; i++) {
		        	selList.DeleteRow(arrRows[i].id);
		        }	
	        }
	        
	        
	        /*  
	         *  [즐겨찾기 탭] <- 화살표 버튼 클릭
	         *   즐겨찾기 목록으로 인원 추가
	         */
	        function DeleteReceiver2(pListView) {
	        	if(tabStatus === "circularOrgan") { // 조직도 탭일 경우
	        		DeleteReceiver(pListView);
	        		return;
	        	}
	        	
	        	// 참여자 탭에서 가져오기
	        	var selList = new ListView();
	            selList.LoadFromID("MsgToList");
	            var arrRows = selList.GetSelectedRows();
	            
	            // 즐겨찾기 목록에서 가져오기
	            var tempListBody2 = $("#List_TBODY2");
	            var order = tempListBody2.children().size();
	            var companyName = $(".node_div").attr("value");
	            var domainName = "<c:out value='${domainName}' />";
	           
	            if(order == 0) {
	            	alert("<spring:message code='ezLadder.hyh03' />");
	            	return;
	            }
	          
	            // 즐겨찾기 목록 재정렬
	            var html = "";
	            for (var i = 0; i < arrRows.length; i++) {
		            html += "<tr id='nameList" + order + "' name='nameList" + order + "' style='cursor:pointer' onmouseover='event_Mover(this)' onmouseout='event_Mout(this)'  onclick='event_click(this)' ondblclick='event_DBclick(this)'>";
	    			html += "<td id='data1' style='width:5%'>" + (order + 1) + "</td>";
	    			if(arrRows[i].getAttribute("data1").substring(0, 14) !== "anonyAttendant") {
	    				html += "<td id='data2' style='width:18%'>" + companyName + "</td>"; 
	    				html += "<td id='data3' style='width:20%'>" + arrRows[i].getAttribute("data7") + "</td>";
	    				html += "<td id='data4' style='display:none;'>" + arrRows[i].getAttribute("data8") + "</td>";
	    			} else {
	    				html += "<td id='data2' style='width:18%'></td>"; 
	    				html += "<td id='data3' style='width:20%'></td>";
	    				html += "<td id='data4' style='display:none;'></td>";
	    			}
	    			html += "<td id='data5' style='width:16%'>" + arrRows[i].getAttribute("data2") + "</td>";
	    			if(arrRows[i].getAttribute("data1").substring(0, 14) === "anonyAttendant") {
	    				html += "<td id='data6' style='width:41%'></td>"
	    				html += "<td id='data7' style='display:none'>" + arrRows[i].getAttribute("data1") + "</td>";
	    			} else {
	    				html += "<td id='data6' style='width:41%'>" + arrRows[i].getAttribute("data1") + "@" + domainName +"</td>";
		    			html += "<td id='data7' style='display:none'>" + arrRows[i].getAttribute("data1") + "</td>";
	    			} 
	    			html += "<td id='data8' style='display:none'>" + arrRows[i].getAttribute("data3") + "</td>";
	    			html += "<td id='data9' style='display:none'>" + arrRows[i].getAttribute("data4") + "</td>";
	    			html += "</tr>";
    			
    				order++;
	            }
	            $('#List_TBODY2  tr:last').after(html); 
	        }
	        
	        var nodeIdx;
	        function TreeViewNodeClick() {
	            issearch = false;
	            CurPage = "1";
	            p_ListOrderObject = "";
	            var treeView = new TreeView();
	            treeView.LoadFromID("FromTreeView");
	            var nodeIdx = treeView.GetSelectNode();
	            document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"padding-right:3px; \" >"
	            	+ "<span id='spn_deptName' title='" + ReplaceText(nodeIdx.GetNodeData("VALUE"), "&", "&amp;") + "'>" + ReplaceText(nodeIdx.GetNodeData("VALUE"), "&", "&amp;") + "</span>"
	            	+ "<span id='countInfo'></span>";
	            SelectDeptNM.setAttribute("countinfo", "")
	            displayUserList(nodeIdx.GetNodeData("CN"));
	        }
	        var tempDeptID = "";
	        function displayUserList(DeptID) {
	        	// 부서 클릭하면 직원 보여지기
		        if (DeptID != undefined) {
	            	tempDeptID = DeptID;
		        }
	
	        	$.ajax({
					url : '/ezOrgan/getDeptMemberList.do',
					method : 'POST',
					dataType : "text",
					data : {
						deptID : tempDeptID ,
						cell : "company;description;displayName;title;telephoneNumber",
						prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2",
						page : CurPage ,
						type : "user"
					} ,
					success : function(xml) {
						event_displayUserList(loadXMLString(xml));
		                
						//2016-10-17 자바스크립트 실행순서때문에 자꾸 getDeptMemberList.do리스트가 나중에 나와서 window.onload 밑에있던부분 이쪽으로 위치 이동
						if (strSearch != "") {
							document.getElementById('keyword').value = strSearch;
							search_click("search"); 
							strSearch = "";
						}
						
						selectDeptAllUser();
						
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alert(error);
					}
	  			});
	        	
	        	$.ajax({
					url : "/ezOrgan/getDeptMemberListCount.do",
					method : "POST",
					dataType : "json",
					data : {
						deptID : tempDeptID
					},
					success : function(result) {
						if (SelectDeptNM.getAttribute("countinfo") != "1" && !pSeach ) {
							var id = $("span[class=node_selected]").eq(0).closest("div").attr("id");
							var strIsLeaf = $("div#" + id + "").attr("isleaf");
							
							if (result.containLow == "YES" && strIsLeaf != "TRUE") { //하위가 있고, 표기방식이 [1명/ 전체10명]일 경우
								document.getElementById("countInfo").innerHTML += "&nbsp;&nbsp;<span class='txt_color'>" + result.totalCount + "</span> / <span class='txt_color'>" + parseInt(result.totalCount + result.totalCount2) + "</span>";
							} else {
								document.getElementById("countInfo").innerHTML += "&nbsp;&nbsp;<span class='txt_color'>" + result.totalCount + "</span>";
							}
							//2018-08-01 김보미 - 부서명 [사원수] 가 넘치는지 확인하는 함수
							deptNameLong(result.containLow, strIsLeaf);
							
			            	SelectDeptNM.setAttribute("countinfo","1")
			        	}
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alert(error);
					}
				});
	    	}
	        
	        function selectDeptAllUser() {
	        	/** boh add : 부서 클릭하면 부서 전체 list 추가하기*/
				deptClickFlag = true;
				listContentArry = new Array();
				
				var tempListContent = $("#txtlist_table tr[id^='MailUserlist_']");
				var tempListLen = tempListContent.length;
				for(var i = 0; i < tempListLen; i++) {
					listContentArry[i] = tempListContent[i].getAttribute("id");
					if(i == tempListLen - 1) {
						p_ListOrderObject = document.getElementById("MailUserlist_" + (tempListLen - 1));
					}
				}
				/** boh end */
	        }
	        function event_displayUserList(xml) {
		        if (xml != null) {
		            pListXML_Info = xml;
		            xml = null;
	            	pSeach = false;
	            	DisplayUserImageList();
	            	makePageSelPage();
		        } 
		    }	    
	        
	        var m_strColorSelect = "#f1f8ff";
	        var m_strColorOver = "#f4f5f5";
	        var m_strColorDefault = "#ffffff";
	        var p_ListOrderObject = null;
	        function event_listMover(obj) {
	        	if(!deptClickFlag) {
		            for (var i = 0; i < listContentArry.length; i++) {
		                if (document.getElementById(listContentArry[i]) == obj) {
		                    return;
		                }
		            }
	        	}
	        	
	            if (p_ListOrderObject != obj) {
	                for (var RowCnt = 0; RowCnt < obj.childNodes.length; RowCnt++) {
	                    obj.childNodes.item(RowCnt).style.backgroundColor = m_strColorOver;
	                }
	            }
	        }
	        function event_listMout(obj) {
				if(!deptClickFlag) {
		            for (var i = 0; i < listContentArry.length; i++) {
		                if (document.getElementById(listContentArry[i]) == obj) {
		                    return;
		                }
		            }
				}
	            if (p_ListOrderObject != obj) {
	                for (var RowCnt = 0; RowCnt < obj.childNodes.length; RowCnt++) {
	                    obj.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
	                }
	            }
	        }
	        
	        var PressShiftKey = false;
	        var PressCtrlKey = false;
	        function event_listOnkeyUp(event) {
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                if (!event) event = window.event;
	            }
	            switch (event.keyCode) {
	                case 16: PressShiftKey = false; break;
	                case 17: PressCtrlKey = false; break;
	                case 46: deleteWork(false); break;
	            }
	
	        }
	        
	        function event_listOnkeyDown(event) {
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                if (!event) event = window.event;
	            }
	            switch (event.keyCode) {
	                case 16: PressShiftKey = true; break;
	                case 17: PressCtrlKey = true; break;
	            }
	        }
	        
	        function infoview_click() {
	            if (p_ListOrderObject == null || p_ListOrderObject == "") {
	                alert("<spring:message code='ezLadder.t031' />");
	                return;
	            }
	            var id = p_ListOrderObject.getAttribute("_DATA2");
	            var dept = $(".node_selected").parent().attr("cn");
	            var pheight = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            var pTop = (pheight - 450) / 2;
	            var pLeft = (pwidth - 420) / 2;
	            
	            window.open("/ezCommon/showPersonInfo.do?id=" + id + "&dept=" + dept, "", "height=450px,width=420px,  top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
	        }
	        
	        var listContentArry = new Array();
	        var listSubContentArry = new Array();
	        var listEventCheckbox = false;
	        var listSubEventCheckbox = false;
	        function event_listclick(obj) {
				deptClickFlag = false;
				PressShiftKey = event.shiftKey;
				PressCtrlKey = event.ctrlKey
            	
	            if (!listEventCheckbox) {
	                if (!PressShiftKey && !PressCtrlKey && listContentArry.length > 0) {
	                    for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
	                        p_ListOrderObject = document.getElementById(listContentArry[Cnt]);
	                        
	                        if (p_ListOrderObject != null) {
		                        for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
		                            p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
		                        }
	                        }	
	                    }
	                    listContentArry = new Array();
	                }
	                if (PressShiftKey) {
	                    var SelectedPreObj = null;
	                    for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
	                        p_ListOrderObject = document.getElementById(listContentArry[Cnt]);
	                        if (Cnt == 0)
	                            SelectedPreObj = p_ListOrderObject;
	
	                        for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
	                            p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
	                        }
	                    }
	                    listContentArry = new Array();
	                    if (p_ListOrderObject == null || p_ListOrderObject == "")
	                        return;
	
	                    var PrelistContent;
	                    if (SelectedPreObj == null)
	                        PrelistContent = p_ListOrderObject.getAttribute("id");
	                    else
	                        PrelistContent = SelectedPreObj.getAttribute("id");
	
	                    p_ListOrderObject = obj;
	
	
	                    var CurlistContent = obj.getAttribute("id");
	                    var PrePoint = parseInt(PrelistContent.replace("MailUserlist_", ""));
	                    var CurPoint = parseInt(CurlistContent.replace("MailUserlist_", ""));
	                    if (PrePoint <= CurPoint) {
	
	                        for (var Cnt = PrePoint; Cnt <= CurPoint; Cnt++) {
	                            p_ListOrderObject = document.getElementById("MailUserlist_" + Cnt);
	                            for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
	                                p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
	                            }
	                            listContentArry[listContentArry.length] = p_ListOrderObject.getAttribute("id");
	                        }
	
	                    }
	                    else if (PrePoint > CurPoint) {
	                        for (var Cnt = PrePoint; Cnt >= CurPoint; Cnt--) {
	                            p_ListOrderObject = document.getElementById("MailUserlist_" + Cnt);
	                            for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
	                                p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
	                            }
	                            listContentArry[listContentArry.length] = p_ListOrderObject.getAttribute("id");
	                        }
	                    }
	                    else
	                        return;
	
	                }
	                else {
	                    p_ListOrderObject = obj;
	                    var insertFlag = true;
	                    for (var i = 0; i < listContentArry.length; i++) {
	                        if (listContentArry[i] == p_ListOrderObject.getAttribute("id")) {
	                            insertFlag = false;
	                            if (PressCtrlKey) {
	                                listContentArry.splice(i, 1);
	                                for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
	                                    p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
	                                }
	                                if (listContentArry.length == 0)
	                                	selectDeptAllUser();
	                                	break;
	                            }
	                        }
	                    }
	                    if (insertFlag) {
	                        for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
	                            p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
	                        }
	
	                        listContentArry[listContentArry.length] = p_ListOrderObject.getAttribute("id");
	                    }
	                }
	            }
	            else
	                listEventCheckbox = false;
	        }
	        
		    function event_listDBclick(obj) {
				InsertReceiver("MsgToList");
		    }
	
		    var strId = "";
	        var strName = "";
	        var strDeptNM = "";
	        var strEmail = "";
	        var strName2 = "";
	        var strDeptNM2 = "";
	        var jickwe = "";
	        var phone = "";
            var pic = "";
		    function InsertReceiver(pListView) {
	            var pparsingXML = "";
	            var pparsingXML2 = "";
	            var strSIP = "";
	            var pAddFlag = false;
	            
	            var overlapAttendantXML = [];
	            var AttendantXML = [];
	            
	            var alluser = {"userId": [], "userName": [], "userName2": [], "pic": [], "temporder": [], "userdata": [], "email": [], "description": [], "description2": []}; 
				var overlapuser = {"userId": [], "userName": [], "userName2": [], "pic": [], "temporder": [], "userdata": [], "email": [], "description": [], "description2": []};
            	var trData;
            	
	            if (_RowObjectID != null) { 
	            	if (_RowObjectName.trim() == "deptList") {
		            	// 즐겨찾기에서 그룹으로 추가
		            	for (var i = 0; i < $("#List_TBODY2 tr").length; i++) {
		            		trData = $("#List_TBODY2 tr").eq(i);
		            		
							strId = trData.find("#data7").text();
		                    strName = trData.find("#data5").text();
		                    strName2 = trData.find("#data8").text();
		                    pic = trData.find("#data9").text();
		                    email = trData.find("#data6").text();
		                    description = trData.find("#data3").text();
		                    description2 = trData.find("#data3").text();
		                    
		                    var IsInsert = CheckMailReceiver(strId, "3");
		
		                    if(strId.substring(0, 14) === "anonyAttendant" || !IsInsert){
		                    	alluser["userId"][i] = strId;
		                    	alluser["userName"][i] = strName;
		                    	alluser["userName2"][i] = strName2;
		                    	alluser["pic"][i] = pic;
		                    	alluser["temporder"][i] = i;
		                    	alluser["email"][i] = email;
		                    	alluser["description"][i] = description;
		                    	alluser["description2"][i] = description2;
		                    	if(strId.substring(0, 14) === "anonyAttendant") {
		                    		alluser["userdata"][i] = "anony";
		                    	} else {
		                    		alluser["userdata"][i] = "real";
		                    	}
		                    } else {
		                    	overlapuser["userId"][i] = strId;
		                    	overlapuser["userName"][i] = strName;
		                    	overlapuser["userName2"][i] = strName2;
		                    	overlapuser["pic"][i] = pic;
		                    	overlapuser["temporder"][i] = i;
		                    	overlapuser["userdata"][i] = "";
		                    	overlapuser["email"][i] = email;
		                    	overlapuser["description"][i] = description;
		                    	overlapuser["description2"][i] = description2;
		                    }
		                }
	            	} else {
	            		// 즐겨찾기에서 유저로 추가
	            		trData = $("[name='" + _RowObjectName + "'");
	            		
	            		strId = trData.find("#data7").text();
	                    strName = trData.find("#data5").text();
	                    strName2 = trData.find("#data8").text();
	                    pic = trData.find("#data9").text();
	                    email = trData.find("#data6").text();
	                    description = trData.find("#data3").text();
	                    description2 = trData.find("#data3").text();
	                    
	                    var IsInsert = CheckMailReceiver(strId, "3");
	                    
	                    if(strId.substring(0, 14) === "anonyAttendant" || !IsInsert){
	                    	alluser["userId"][0] = strId;
	                    	alluser["userName"][0] = strName;
	                    	alluser["userName2"][0] = strName2;
	                    	alluser["pic"][0] = pic;
	                    	alluser["temporder"][0] = i;
	                    	alluser["email"][i] = email;
	                    	alluser["description"][0] = description;
	                    	alluser["description2"][0] = description2;
	                    	if(strId.substring(0, 14) === "anonyAttendant") {
	                    		alluser["userdata"][0] = "anony";
	                    	} else {
	                    		alluser["userdata"][0] = "real";
	                    	}
	                    } else {
	                    	overlapuser["userId"][0] = strId;
	                    	overlapuser["userName"][0] = strName;
	                    	overlapuser["userName2"][0] = strName2;
	                    	overlapuser["pic"][0] = pic;
	                    	overlapuser["temporder"][0] = i;
	                    	overlapuser["userdata"][0] = "";
	                    	overlapuser["email"][i] = email;
	                    	overlapuser["description"][0] = description;
	                    	overlapuser["description2"][0] = description2;
	                    }
	            	}
	            } else {
	            	// 조직도에서 바로 추가
		            if (listContentArry != "") {
		                for (var i = 0; i < listContentArry.length; i++) {
		                	trData = document.getElementById(listContentArry[i]);
		                	
		                	strId = trData.getAttribute("_data2");
		                    strName = trData.getAttribute("_data4");
		                    strName2 = trData.getAttribute("_data11");
		                    pic = trData.getAttribute("_data9");
		                    email = trData.getAttribute("_data3");
		                    description = trData.getAttribute("_data12");
		                    description2 = trData.getAttribute("_data13");
		
		                    var IsInsert = CheckMailReceiver(strId, "3"); 
		                    
							if(!IsInsert){
								alluser["userId"][i] = strId;
		                    	alluser["userName"][i] = strName;
		                    	alluser["userName2"][i] = strName2;
		                    	alluser["pic"][i] = pic;
		                    	alluser["temporder"][i] = i;
		                    	alluser["email"][i] = email;
		                    	alluser["description"][i] = description;
		                    	alluser["description2"][i] = description2;
		                    	if(strId.substring(0, 14) === "anonyAttendant") {
		                    		alluser["userdata"][i] = "anony";
		                    	} else {
		                    		alluser["userdata"][i] = "real";
		                    	}
		                    } else {
		                    	overlapuser["userId"][i] = strId;
		                    	overlapuser["userName"][i] = strName;
		                    	overlapuser["userName2"][i] = strName2;
		                    	overlapuser["pic"][i] = pic;
		                    	overlapuser["temporder"][i] = i;
		                    	overlapuser["userdata"][i] = "";
		                    	overlapuser["email"][i] = email;
		                    	overlapuser["description"][i] = description;
		                    	overlapuser["description2"][i] = description2;
		                    }
		                }
		            } else {
		                if (p_ListOrderObject == "") {
		                    alert("<spring:message code='ezLadder.t031' />");
		                    return;
		                }
		                
		                if (p_ListOrderObject != "") {
		                    strId = p_ListOrderObject.getAttribute("_data2");
		                    strName = p_ListOrderObject.getAttribute("_data4");
		                    strName2 = p_ListOrderObject.getAttribute("_data11");
		                    pic = p_ListOrderObject.getAttribute("_data9");
		                    
		                    var listid = "MsgToList";
		                
		                    var getlistview = new ListView();
		                    getlistview.LoadFromID(listid);
		                    var bFlag = getlistview.ExistRow("DATA2", strEmail);
		                    
		                    if(!bFlag){
								alluser["userId"][0] = strId;
		                    	alluser["userName"][0] = strName;
		                    	alluser["userName2"][0] = strName2;
		                    	alluser["temporder"][0] = i;
		                    	alluser["pic"][0] = pic;
		                    
		                    	if(strId.substring(0, 14) === "anonyAttendant") {
		                    		alluser["userdata"][0] = "anony";
		                    	} else {
		                    		alluser["userdata"][0] = "real";
		                    	}
		                    } else {
		                    	overlapuser["userId"][0] = strId;
		                    	overlapuser["userName"][0] = strName;
		                    	overlapuser["userName2"][0] = strName2;
		                    	overlapuser["pic"][0] = pic;
		                    	overlapuser["temporder"][0] = i;
		                    	overlapuser["userdata"][0] = "";
		                    }
		                }
		            }
	            }
	            
	            if(!!overlapuser["userId"].length) {
	            	retAttendantPopInfo[0] = true;
					retAttendantPopInfo[1] = bindAllUser;
					
					DivPopUpShow(360, 185, "/ezLadder/ladderPopup.do?popupType=overlap");
				} else {
					bindAllUser(false);
				}
	            
                function bindAllUser(value, type) {
					DivPopUpHidden();
					
					if(value == "cancle") {
						return;
					}
					
					if(value) {
						var overlapLen = overlapuser["userId"].length;
						for(var i = 0; i < overlapLen; i++) {
							if(!!overlapuser["userId"][i]) {
								alluser["userId"][i] = overlapuser["userId"][i];
								alluser["userName"][i] = overlapuser["userName"][i];
								alluser["userName2"][i] = overlapuser["userName2"][i];
								alluser["temporder"][i] = i;
								alluser["pic"][i] = overlapuser["pic"][i];
								alluser["userdata"][i] = type;
								alluser["email"][i] = overlapuser["email"][i];
								alluser["description"][i] = overlapuser["description"][i];
								alluser["description2"][i] = overlapuser["description2"][i];
							}
						}
					}
					parsingXMLUserList(alluser);
				}
		    }
		    
			function parsingXMLUserList(userlist) {
				var listid = "MsgToList"; // 추가된 유저목록 테이블 아이디
				var i = 0;
				var len = userlist["userId"].length;
				var pparsingXML = "";
				var totallen = 0;
				         
				var strId = "";
				var strName = "";
				var strName2 = "";
				var strpic = "";
				
				var listview = new ListView();
				listview.LoadFromID(listid);
				var totalRow = listview.GetDataRows().length;
				
				/* 사람 수 제한 */
				if(totalRow + userlist["userId"].length > RetValue["maxAttendant"]) {
					alert(RetValue["maxAttendant"] + "<spring:message code='ezLadder.t048' />");
					var spliceNum = RetValue["maxAttendant"] - totalRow;
					userlist["userId"].splice(spliceNum);
					userlist["userName"].splice(spliceNum);
					userlist["userName2"].splice(spliceNum);
					userlist["pic"].splice(spliceNum);
					userlist["temporder"].splice(spliceNum);
					userlist["userdata"].splice(spliceNum);
					userlist["email"].splice(spliceNum);
					userlist["description"].splice(spliceNum);
					userlist["description2"].splice(spliceNum);
					len = userlist["userId"].length;
				}
				
				for(; i < len; i++) {
					if(userlist["userdata"][i] === "anony") {
						strId = "anonyAttendant_" + (totalRow + i);
						strpic = "";
					} else {
						strId = userlist["userId"][i];
						strpic = userlist["pic"][i];
					}
					strName = userlist["userName"][i];
					strName2 = userlist["userName2"][i];
					email = userlist["email"][i];
					description = userlist["description"][i];
					description2 = userlist["description2"][i];

					pparsingXML = "<LISTVIEWDATA2><ROWS>";
					pparsingXML += "<ROW><CELL><DATA1>" + strId + "</DATA1>";
					pparsingXML += "<DATA2><![CDATA[" + strName + "]]></DATA2>";
					pparsingXML += "<DATA3><![CDATA[" + strName2 + "]]></DATA3>";
					pparsingXML += "<DATA4><![CDATA[" + strpic + "]]></DATA4>";
					pparsingXML += "<DATA6><![CDATA[" + email + "]]></DATA6>";
					pparsingXML += "<DATA7><![CDATA[" + description + "]]></DATA7>";
					pparsingXML += "<DATA8><![CDATA[" + description2 + "]]></DATA8>";
					pparsingXML += "<VALUE>"  + strName + "</VALUE></CELL></ROW>";
					pparsingXML += "</ROWS></LISTVIEWDATA2>";
				
					Resultxml = loadXMLString(pparsingXML);
					
					listview = new ListView();
					listview.LoadFromID(listid);
					
					var MaxID = 0;
					var InitTr = listview.GetDataRows();
					var MaxCntNum = 0;
					for (var j = 0  ; j < InitTr.length  ; j++) {
						var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
						if (MaxID < curnum) {
							MaxID = curnum;
							MaxCntNum = j;
						}
					}
				
					var objTr = listview.AddRow(InitTr.length);
					if (MaxCntNum != 0)
						MaxCntNum = MaxCntNum + 1;
					SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxCntNum).substring(0, listview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + eval(MaxID + 1));
					listview.AddDataRow(objTr, Resultxml);
				
					var _tdlength = document.getElementById(listid).getElementsByTagName("TD").length;
					for (var y = 0; y < _tdlength; y++) {
						document.getElementById(listid).getElementsByTagName("TD")[y].style.textOverflow = "";
						document.getElementById(listid).getElementsByTagName("TD")[y].style.overflow = "";
					}
				}
				/* var listid ="MsgToList";
				_RowObjectID = null; */
			}	
	    
		    function CheckMailReceiver(selRow, option) {
		        var rtnValue = false;
		        var email;
		        if (option == "1")
		            email = selRow.cells[0].DATA3;
		        else if (option == "2")
		            email = selRow.cells[0].DATA2;
		        else if (option == "3")
		            email = selRow;
		        
		        var _listview = new ListView();
		        _listview.LoadFromID("MsgToList");
		        var arrRows = _listview.GetDataRows();
	
		        for (count2 = 0; count2 < arrRows.length; count2++) {
		            if (email.trim() == $("tr[id*='MsgToList_TR']").eq(count2).attr("data1").trim()) {
		                rtnValue = true;
		                break ;
		            }
		        }
	
		        return rtnValue
		    }
		    
		    var pSeach = false;
		    function DisplayUserImageList() {
		        var xmlRtn = pListXML_Info;
		        document.getElementById("DeptUserImgList").innerHTML = "";
		        document.getElementById("txtlist_Layer").scrollTop = "0";
		        document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes;
		        totalPage = Math.ceil(new Number(getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) / 50));
		        
		        while (document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.length > 1) {
		            document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).removeChild(document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.item(1));
		        }
		        
		        while (document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.length > 1) {
		            document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).removeChild(document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.item(1));
		        }
		        
		        var UserListHTML = "";
		        /* if (SelectDeptNM.getAttribute("countinfo") != "1") {
		            if (getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) ==  getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT2")[0])) {
	        			SelectDeptNM.innerHTML += "-[<span class='txt_color'>" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) + "<spring:message code='ezLadder.t105' />" + "</span>]";
	        		} else {
	        			SelectDeptNM.innerHTML += "-[<span class='txt_color'>" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) + "/" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT2")[0]) + "<spring:message code='ezLadder.t105' />" + "</span>]";
	        		}
		            
		            SelectDeptNM.setAttribute("countinfo", "1")
		        } */
		        
		        if (pListType == "IMG") {
		            document.getElementById("DeptUserImgList").style.display = "";
		            document.getElementById("txtlist_Layer").style.display = "none";
		            document.getElementById("txtlist_table").style.display = "none";
		            document.getElementById("Search_txtlist_table").style.display = "none";
		            
		            if (pSeach) {
		                document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;padding-right:3px;\" >" + strLang20 + "" + "-[<span class='txt_color'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + "<spring:message code='ezLadder.t105' />" + "</span>]";
		                SelectDeptNM.setAttribute("countinfo", "1");
		            }
		        } else {
	                document.getElementById("DeptUserImgList").style.display = "none";
	                document.getElementById("txtlist_Layer").style.display = "";
	                
	                if (!pSeach) {
	                    document.getElementById("txtlist_table").style.display = "";
	                    document.getElementById("Search_txtlist_table").style.display = "none";
	                } else {
	                    document.getElementById("Search_txtlist_table").style.display = "";
	                    document.getElementById("txtlist_table").style.display = "none";
	                    document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;padding-right:3px;\" >" + strLang20 + "" + "-[<span class='txt_color'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + "<spring:message code='ezLadder.t105' />" + "</span>]";
	                    SelectDeptNM.setAttribute("countinfo", "1")
	                }
	            }
	
	            for (var i = 0; i < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length; i++) {
	                if (pListType == "IMG") {
	                    var MainTable = document.createElement("TABLE");
	                    MainTable.setAttribute("class", pListType == "IMG" ? "organwrap" : "organwrap_list");
	                    MainTable.setAttribute("cellspacing", "0");
	                    MainTable.setAttribute("cellpadding", "0");
	                    
	                    if (pListType == "IMG") {
	                        MainTable.style.marginTop = "5px";
	                    }
	                    MainTable.style.marginLeft = "auto";
	                    MainTable.style.marginRight = "auto";
	                    var M_TR = document.createElement("TR");
	                    M_TR.setAttribute("id", "MailUserlist_" + i);
	                    M_TR.style.cursor = "pointer";
	                    M_TR.onmouseover = function () { event_listMover(this); };
	                    M_TR.onmouseout = function () { event_listMout(this); };
	                    M_TR.onclick = function () { event_listclick(this); };
	                    M_TR.ondblclick = function () { event_listDBclick(this); };
	                    M_TR.setAttribute("draggable", true);
	                    M_TR.onselectstart = function () { return false; };
	                    
	                    if (CrossYN()) {
	                        for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.length; NodeCount++) {
	                            if (SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName != "#text") {
	                                M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
	                                                  trim_Cross(SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).textContent));
	                            }
	                        }
	                    } else {
	                        for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.length; NodeCount++) {
	                            M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
	                                              SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).text);
	                        }
	                    }
	
	                    var M_TR_TD = document.createElement("TD");
	                    M_TR_TD.setAttribute("class", "pictd");
	                    var M_TR_DIV = document.createElement("DIV");
	                    M_TR_DIV.setAttribute("class", "pic");
	                    
	                    if (M_TR.getAttribute("_DATA9") != "") {	                    	
	                        var M_TR_IMG = document.createElement("IMG");
	                        M_TR_IMG.setAttribute("SRC", "/admin/ezOrgan/getPersonalInfo.do?fileName=" + M_TR.getAttribute("_DATA9"));
	                        M_TR_IMG.setAttribute("width", "90px");
	                        M_TR_IMG.setAttribute("height", "90px");
	                        M_TR_DIV.appendChild(M_TR_IMG);
	                    }
	                    M_TR_TD.appendChild(M_TR_DIV);
	                    M_TR.appendChild(M_TR_TD);
	
	                    var M_TR_TD2 = document.createElement("TD");
	                    M_TR_TD2.style.width = "300px";
	
	                    var M_TR_TDS_Table = document.createElement("TABLE");
	                    M_TR_TDS_Table.setAttribute("class", "organinfo");
	                    M_TR_TD2.appendChild(M_TR_TDS_Table);
	
	                    var Sub_TR1 = document.createElement("TR");
	                    var Sub_TD1 = document.createElement("TD");
	                    Sub_TD1.style.textAlign = "left";
	                    Sub_TD1.setAttribute("class", "name");
	                    var pDisplayName = "";
	                    if ("<c:out value='${use_ocs}'/>" == "YES") {
	                        pDisplayName += "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + M_TR.getAttribute("_DATA3") + "\",this);'/></span>";
	                    }
	                    pDisplayName += M_TR.getAttribute("_DATA4") == "" ? "" : M_TR.getAttribute("_DATA4");
	                    pDisplayName += M_TR.getAttribute("_DATA6") == "" ? "" : "[" + M_TR.getAttribute("_DATA6") + "]";
	                    Sub_TD1.innerHTML = pDisplayName;
	                    Sub_TR1.appendChild(Sub_TD1);
	
	                    var Sub_TR2 = document.createElement("TR");
	                    var Sub_TD2 = document.createElement("TD");
	                    Sub_TD2.style.textAlign = "left";
	                    Sub_TD2.innerHTML = M_TR.getAttribute("_DATA5");
	                    Sub_TR2.appendChild(Sub_TD2);
	
	                    var Sub_TR3 = document.createElement("TR");
	                    var Sub_TD3 = document.createElement("TD");
	                    Sub_TD3.style.textAlign = "left";
	                    var Sub_TD3_Img = document.createElement("IMG");
	                    Sub_TD3_Img.setAttribute("class", "icon");
	                    Sub_TD3_Img.setAttribute("src", "/images/OrganTree/icon_hp.gif");
	                    Sub_TD3.appendChild(Sub_TD3_Img);
	                    Sub_TD3.innerHTML += M_TR.getAttribute("_DATA8") == "" ? " - " : M_TR.getAttribute("_DATA8");
	                    Sub_TR3.appendChild(Sub_TD3);
	
	                    var Sub_TR4 = document.createElement("TR");
	                    var Sub_TD4 = document.createElement("TD");
	                    Sub_TD4.style.textAlign = "left";
	                    var Sub_TD4_Img = document.createElement("IMG");
	                    Sub_TD4_Img.setAttribute("class", "icon");
	                    Sub_TD4_Img.setAttribute("src", "/images/OrganTree/icon_mail.gif");
	                    Sub_TD4.appendChild(Sub_TD4_Img);
	                    Sub_TD4.innerHTML += M_TR.getAttribute("_DATA3")
	                    Sub_TR4.appendChild(Sub_TD4);
	
	                    M_TR_TDS_Table.appendChild(Sub_TR1);
	                    M_TR_TDS_Table.appendChild(Sub_TR2);
	                    M_TR_TDS_Table.appendChild(Sub_TR3);
	                    M_TR_TDS_Table.appendChild(Sub_TR4);
	
	                    M_TR.appendChild(M_TR_TD2);
	                    MainTable.appendChild(M_TR);	                    
	                    
	                    document.getElementById("DeptUserImgList").appendChild(MainTable);
	                } else {
	                    var M_TR = document.createElement("TR");
	                    M_TR.setAttribute("id", "MailUserlist_" + i);
	                    M_TR.style.cursor = "pointer";
		                    M_TR.onmouseover = function () { event_listMover(this); };
	                    M_TR.onmouseout = function () { event_listMout(this); };
	                    M_TR.onclick = function () { event_listclick(this); };
	                    M_TR.ondblclick = function () { event_listDBclick(this); };
	                    M_TR.setAttribute("draggable", true);
	                    M_TR.onselectstart = function () { return false; };
	                    
	                    if (CrossYN()) {
	                        for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.length; NodeCount++) {
	                            if (SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName != "#text") {
	                                M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
	                                                  trim_Cross(SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).textContent));
	                            }
	                        }
	                    } else {
	                        for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.length; NodeCount++) {
	                            M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
	                                              SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).text);
	                        }
	                    }
	
	                    if (pSeach) {
	                        var M_TR_TD1 = document.createElement("TD");
	                        M_TR_TD1.style.overflow = "hidden";
	                        M_TR_TD1.style.textOverflow = "ellipsis";
	                        M_TR_TD1.style.whiteSpace = "nowrap";
	                        M_TR_TD1.style.width = "110px";
	                        M_TR_TD1.innerHTML = M_TR.getAttribute("_DATA5");
	
	                        var M_TR_TD2 = document.createElement("TD");
	                        M_TR_TD2.style.overflow = "hidden";
	                        M_TR_TD2.style.textOverflow = "ellipsis";
	                        M_TR_TD2.style.whiteSpace = "nowrap";
	                        M_TR_TD2.style.width = "90px";
	                        if ("<c:out value='${use_ocs}'/>" == "YES") {
	                            M_TR_TD2.innerHTML = "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + M_TR.getAttribute("_DATA3") + "\",this);'/></span>" + M_TR.getAttribute("_DATA4");
	                        } else {
	                            M_TR_TD2.innerHTML = M_TR.getAttribute("_DATA4");
	                        }
	                        var M_TR_TD3 = document.createElement("TD");
	                        M_TR_TD3.innerHTML = M_TR.getAttribute("_DATA6") == "" ? "" : M_TR.getAttribute("_DATA6");
	                        M_TR_TD3.style.width = "80px";
	
	                        var M_TR_TD4 = document.createElement("TD");
	                        M_TR_TD4.innerHTML = M_TR.getAttribute("_DATA8") == "" ? "" : M_TR.getAttribute("_DATA8");
	
	                        M_TR.appendChild(M_TR_TD1);
	                        M_TR.appendChild(M_TR_TD2);
	                        M_TR.appendChild(M_TR_TD3);
	                        M_TR.appendChild(M_TR_TD4);
	                        document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).appendChild(M_TR);
	                    } else {
	                        var M_TR_TD1 = document.createElement("TD");
	                        M_TR_TD1.style.overflow = "hidden";
	                        M_TR_TD1.style.textOverflow = "ellipsis";
	                        M_TR_TD1.style.whiteSpace = "nowrap";
	                        M_TR_TD1.style.width = "150px";
	                        
	                        if ("<c:out value='${use_ocs}'/>" == "YES") {
	                            M_TR_TD1.innerHTML = "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + M_TR.getAttribute("_DATA3") + "\",this);'/></span>" + M_TR.getAttribute("_DATA4");
	                        } else {
	                            M_TR_TD1.innerHTML = M_TR.getAttribute("_DATA4");
	                        }
	                        var M_TR_TD2 = document.createElement("TD");
	                        M_TR_TD2.style.width = "80px";
	                        M_TR_TD2.innerHTML = M_TR.getAttribute("_DATA6") == "" ? "" : M_TR.getAttribute("_DATA6");
	
	                        var M_TR_TD3 = document.createElement("TD");
	                        M_TR_TD3.innerHTML = M_TR.getAttribute("_DATA8") == "" ? "" : M_TR.getAttribute("_DATA8");
	
	                        M_TR.appendChild(M_TR_TD1);
	                        M_TR.appendChild(M_TR_TD2);
	                        M_TR.appendChild(M_TR_TD3);
	                        document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).appendChild(M_TR);
	                    }
	                }
	            }
	        }		
		    function search_press(e) {
		        if (window.event) {
		            if (window.event.keyCode == 13) {
		                search_click("search");
		            }
		        }
		        else {
		            if (e.which == 13)
		                search_click("search");
		        }
		
		    }
		    var issearch = false;
		    function search_click(type) {
		        listContentArry = new Array();
	
		        if ($.trim($("#keyword").val()) == "") {
		        	alert("<spring:message code='ezLadder.t085' />");
		            document.all("keyword").focus();
		            return;
		        }
	
		        if (specialChk(keyword.value)) {
		    		alert("<spring:message code='ezLadder.t032' />");
		    		return;
		    	}
		        
		        if (keyword.value == "") {
		            alert("<spring:message code='ezLadder.t033' />");
		            keyword.focus();
		            return;
		        }
		        if (type == "search") {
		            CurPage = "1";
		            issearch = true;
		        }
		
		        $.ajax({
					url : '/ezOrgan/getSearchList.do',
					method : 'POST',
					dataType : "text",
					data : {
						search : document.getElementById("search_type").value + "::" + keyword.value,
						cell : "company;description;displayName;title;telephoneNumber;" + document.getElementById("search_type").value,
						prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2",
						page : CurPage ,
						type : "user"
					} ,
						success : function(xml) {
							event_displayUserList2(loadXMLString(xml));
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alert("<spring:message code='ezLadder.t034'/>" + textStatus);
					}
				});
		
		        var usedefault;
		        if (browserIE) {
		            usedefault = document.getElementById("search_type").options[document.getElementById("search_type").selectedIndex].usedefault;
		        }
		        else {
		            usedefault = GetAttribute(document.getElementById("search_type").options[document.getElementById("search_type").selectedIndex], "usedefault");
		        }
		     	// 2021-04-09 김은실 - 검색 시 PressShiftKey = true 되는 현상(commit 6c23f8716 참조): 모든 search_click()에 적용. 
	            PressShiftKey = false;
		    }
		    function event_displayUserList2(xml) {
		        if (xml != null) {
	                if (SelectNodes(xml, "LISTVIEWDATA/ROWS/ROW").length == 0) {
	                	alert("<spring:message code='ezLadder.t035'/>");
	                } else {
	                    pListXML_Info = xml;
	                	pSeach = true;
	                	DisplayUserImageList();
	                	makePageSelPage();
	            	}
	    	    }
	    	}
		    function ReplaceText(orgStr, findStr, replaceStr) {
		        var re = new RegExp(findStr, "gi");
		
		        return (orgStr.replace(re, replaceStr));
		    }
		    function ListTypeChangeIcon() {
		        if (pListType == "IMG") {
		            document.getElementById("imglist").setAttribute("src", "/images/kr/cm/btn_onimglist.gif");
		            document.getElementById("txtlist").setAttribute("src", "/images/kr/cm/btn_list.gif");
		        }
		        else {
		            document.getElementById("imglist").setAttribute("src", "/images/kr/cm/btn_imglist.gif");
		            document.getElementById("txtlist").setAttribute("src", "/images/kr/cm/btn_onlist.gif");
		        }
		    }
		    function ChangeListView_onClick(Div) {
		        pListType = Div;
		        ListTypeChangeIcon();
		        DisplayUserImageList();
		    }
		    function keyword_Clear() {
		    	document.getElementById("keyword").value = "";
			}
		    
		    var retAttendantPopInfo = [];
		    /** 중복유저 팝업 관련 */
		    function setOverlapAttendant(attendantList) {
		    	retAttendantPopInfo[0] = attendantList;
		    	retAttendantPopInfo[1] = parsingXMLUserList;
		    	
		    	DivPopUpShow(360, 185, "/ezLadder/ladderPopup.do?popupType=overlap");
		    }
		    
		    /** 사다리 멤버 즐겨찾기 관련 */
		    function editBM(flag) {
				setBmGroup(flag, _RowObjectID);
			}
		    function setBmGroup(type, ladderBmId) {
		    	save_userlist();		// 즐겨찾기 추가,삭제
		    	if(type === "modify") { // 즐겨찾기 수정
		    		save_userlist_bm();
		    	} else if(type === "delete") {
		    		if(_RowObjectName !== "deptList") {
		    			alert("<spring:message code='ezLadder.hyh03' />");
			        	return;
			        }
		    	}
		    	
		    	if(type !== "delete" && !rtn.length){
		    		if(type === "add") {
			    		alert("<spring:message code='ezLadder.t058' />");
			    		return;
		    		} else {
		    			alert("<spring:message code='ezLadder.hyh03' />");
			        	return;
		    		}
		    	}
		    	
		    	retAttendantPopInfo[0] = type;
		    	retAttendantPopInfo[1] = setBmGroupComp;
		    	retAttendantPopInfo[2] = ladderBmId
		    	if(type === "modify") {
		    		retAttendantPopInfo[2] = rowId;
		    	}
		    	
		    	DivPopUpShow(360, 185, "/ezLadder/ladderPopup.do?popupType=" + type);
		    }
		    
		    function setBmGroupComp(bmName, type) {
		    	DivPopUpHidden();
		    	
		    	var ladderbmid = retAttendantPopInfo[2];
		    	
		    	var bmuserid;
		    	var bmusername;
		    	var bmusername2;
		    	var descriptions;
		    	var descriptions2;
		    	
				if(type !== "delete") {
					bmuserid = rtn.reduce(function(result, curr) {
						result.push(curr["userId"]);
						return result;
					}, []);
			    	bmusername = rtn.reduce(function(result, curr) {
						result.push(curr["userName"]);
						return result;
					}, []);
			    	bmusername2 = rtn.reduce(function(result, curr) {
						result.push(curr["userName2"]);
						return result;
					}, []);
			    	descriptions = rtn.reduce(function(result, curr) {
						result.push(curr["description"]);
						return result;
					}, []);
			    	descriptions2 = rtn.reduce(function(result, curr) {
						result.push(curr["description2"]);
						return result;
					}, []);
				}
		    	
		    	$.ajax({
					type: "POST",
					url: "/ezLadder/setLadderBM.do",
					traditional: true,
					dataType: "json",
					data: { 
						flag: type,
						ladderBmId: ladderbmid,
						bmName: bmName,
						userIds: bmuserid,
						userNames: bmusername,
						userName2s: bmusername2,
						descriptions: descriptions,
						descriptions2: descriptions2
					},
					success: function(result) {
						getLadderBmList();
					}
				});
		    }
		    
		    function getLadderBmList(ladderbmid) {
	    		var html = "";
			    var bm_list = [];
			    
		    	$.ajax({
					url : '/ezLadder/getLadderBM.do',
					type : 'GET',
					dataType : "json",
					data : {
						"ladderBmId": ladderbmid
					},
   					success : function(result) {
   						bm_list = result["bmList"];
   						
				    	if(typeof ladderbmid === "undefined") { // 즐겨찾기 그룹 부르기
							bm_list.forEach(function(group, index) {
								html += "<tr id='" + group.ladderBmId + "' name='deptList' style='cursor:pointer' onmouseover='event_Mover(this)' onmouseout='event_Mout(this)' onclick='event_click(this)' ondblclick='event_listDBclick(this)'>";
								html += "<td style='width:5%'>" + (index + 1) + "</td>";
								html += "<td style='width:39%'>" + group.bmName + "</td>";
								html += "<td style='width:31%'>" + group.regdate + "</td>";
								if(group.count === 0) {
									html += "<td style='width:24%'>" + group.userName + "</td>";
								} else {
									html += "<td style='width:24%'>" + group.userName + " <spring:message code='ezLadder.t070' /> " + group.count + " <spring:message code='ezLadder.t105' /></td>";
								}
					    		html += "</td></tr>";
							});
				    	
							$("#List_TBODY").html(html);
							$("#List_TBODY2").html("");
							_RowObjectID = null; 
			                _RowObjectName = null;
				    	} else {
				    		bm_list.forEach(function(user, index) {
				    			html += "<tr id='nameList" + index + "' name='nameList" + index + "' style='cursor:pointer' onmouseover='event_Mover(this)' onmouseout='event_Mout(this)'  onclick='event_click(this)' ondblclick='event_DBclick(this)'>";
				    			html += "<td id='data1' style='width:5%'>" + (index + 1) + "</td>";
				    			if(user.userId.substring(0, 14) == "anonyAttendant" && !user.mail) {
				    				html += "<td id='data2' style='width:18%'></td>";
				    				html += "<td id='data3' style='width:20%'></td>";
				    				html += "<td id='data4' style='display:none;'></td>";
				    			} else {
				    				html += "<td id='data2' style='width:18%'>" + user.company + "</td>";
				    				html += "<td id='data3' style='width:20%'>" + user.description + "</td>";
				    				html += "<td id='data4' style='display:none;'>" + user.description2 + "</td>";
				    			}
				    			//html += "<td id='data3' style='width:20%'>" + user.description + "</td>";
				    			//html += "<td id='data4' style='display:none;'>" + user.description2 + "</td>";
				    			html += "<td id='data5' style='width:16%'>" + user.userName + "</td>";
				    			html += "<td id='data6' style='width:41%'>" + user.mail + "</td>";
				    			if(user.userId.substring(0, 14) == "anonyAttendant" && !user.mail) {
				    				html += "<td id='data7' style='display:none'>anonyAttendant" + index + "</td>";
				    			} else {
					    			html += "<td id='data7' style='display:none'>" + user.userId + "</td>";
				    			}
				    			html += "<td id='data8' style='display:none'>" + user.userName2 + "</td>";
				    			html += "<td id='data9' style='display:none'>" + user.pic + "</td>";
				    			html += "</tr>";
	   						});
	   						
	   						$("#List_TBODY2").html(html);
				    	}
   					}
   				});
		    }
		    
		  
		    /* [즐겨찾기 탭] 즐겨찾기 인원 목록 더블 클릭 (인원 삭제)*/
		    function event_DBclick(obj){
		    	// List_TBODY2 tr 삭제
				var tr = $(obj);
				var tempListBody2 = $("#List_TBODY2");
		    	tr.remove(); 
		    	
				// List_TBODY2 재정렬
				if(tempListBody2.children().size()==0) {
					tempListBody2.html("");
				} else {
					var tableIndex = tr.attr("id").substring(8); 
		    			
					for(var index=tableIndex; index < tempListBody2.children().size(); index++) {
		    			index*=1;	
		    			$("#nameList"+(index+1)).children().first().text(index+1);
		    			$("#nameList"+(index+1)).attr("name", "nameList"+index);
		    			$("#nameList"+(index+1)).attr("id", "nameList"+index);
		    		}
				}
		    }
		    
		    /** msgtolist 의 유저 rtn에 추가 */
		    var rtn = [];
		    function save_userlist() {
		    	rtn = [];
		    	
		    	var listid = "MsgToList"; 
		    	var selList = new ListView();
		        selList.LoadFromID(listid);
		        
		        var totalRows = selList.GetDataRows();
		        var totalLen = totalRows.length;
		        
		        var userId;
		        var userName;
		        var userName2;
		        var pic;
		        var item;
		        var description;
		        var description2;
		        
		        for(var i = 0; i < totalLen; i++) {
		        	userId = GetAttribute(totalRows[i], "DATA1");
		        	if(userId.substring(0, 14) == "anonyAttendant") {
		        		userName = totalRows[i].getElementsByTagName("input")[0].value;
		        		userName2 = totalRows[i].getElementsByTagName("input")[0].value;
		        		description = "";
		        		description2 = "";
		        	} else {
		        		userName = GetAttribute(totalRows[i], "DATA2");
			        	userName2 = GetAttribute(totalRows[i], "DATA3");
			        	description = GetAttribute(totalRows[i], "DATA7") || "";
			        	description2 = GetAttribute(totalRows[i], "DATA8") || "";
		        	}
		        	pic = GetAttribute(totalRows[i], "DATA4") || "";
		        	item = GetAttribute(totalRows[i], "DATA5") || "";
		        	email = GetAttribute(totalRows[i], "DATA6") || "";
		        	rtn[i] = {"userId": userId, "userName": userName, "userName2": userName2, "pic": pic, "item": item, "email": email, "description": description, "description2": description2};
		        }
		    }
		    
		    /** [즐겨찾기 탭]
		     *  ladderBmId가 'rowId'인 즐겨찾기 유저 정보 저장
		     */
		    function save_userlist_bm() {
				rtn = [];
				var tempListBody2 = $("#List_TBODY2");
		   		var userId;
		        var userName;
		        var userName2;
		        var description;
		        var description2;
		        var index=0;
	        
		        if(tempListBody2.children().size()==0) {
		        	return;
		        }
		    
		    	$('#List_TBODY2 tr').each(function() {
		    	    userId = $(this).find("td").eq(6).html();
		        	userName = $(this).find("td").eq(4).html();
			        userName2 = $(this).find("td").eq(7).html();
		        	description = $(this).find("td").eq(2).html();
		        	description2 = $(this).find("td").eq(3).html();
		        	rtn[index++] = {"userId": userId, "userName": userName, "userName2": userName2, "description": description, "description2": description2};
		    	});
		    }
		    
		    function btnok_onclick() {
		    	save_userlist();
		        
		        if (!CrossYN()) {
		            window.returnValue = rtn;
		        }
		        
		        if (ReturnFunction != null) {
		            ReturnFunction(rtn);
		        } else {
		            window.returnValue = rtn;
		        } 
		        
		        window.close();
		    }
		
		    function onDragEnter(evt) {
		        evt.stopPropagation();
		        evt.preventDefault();
		        evt.dataTransfer.dropEffect = "copy";
		        evt.dataTransfer.effectAllowed = "copy";
		    }
		    function onDrop(evt, element) {
		        evt.stopPropagation();
		        evt.preventDefault();
		        InsertReceiver(element);
		    }
		    var BlockSize = 10;
		    function td_Create1(strtext) {
		        document.getElementById("tblPageRayer").innerHTML = strtext;
		    }
		    function makePageSelPage() {
		        var strtext;
		        var PagingHTML = "";
		        document.getElementById("tblPageRayer").innerHTML = "";
		        strtext = "<div class='pagenavi'>";
		        PagingHTML += strtext;
		        var pageNum = CurPage;
		        if (totalPage > 1 && pageNum != 1) {
		            strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'></span>"
		            PagingHTML += strtext;
		        }
		        else {
		            strtext = "<span class='btnimg first disabled'></span>"
		            PagingHTML += strtext;
		        }
		        if (totalPage > BlockSize) {
		            if (pageNum > BlockSize) {
		                strtext = "<span class='btnimg prev' onclick= 'return selbeforeBlock()'></span>";
		                PagingHTML += strtext;
		            }
		            else {
		                strtext = "<span class='btnimg prev disabled'></span>";
		                PagingHTML += strtext;
		            }
		        }
		        else {
		            strtext = "<span class='btnimg prev disabled'></span>";
		            PagingHTML += strtext;
		        }
		        var MaxNum;
		        var i;
		        var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;
		        if (totalPage >= (startNum + parseInt(BlockSize))) {
		            MaxNum = (startNum + parseInt(BlockSize)) - 1;
		        }
		        else {
		            MaxNum = totalPage;
		        }
		        for (i = startNum; i <= MaxNum; i++) {
		            if (i == pageNum) {
		                strtext = "<span class='on'>" + i + "</span>";
		                PagingHTML += strtext;
		            }
		            else {
		                strtext = "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
		                PagingHTML += strtext;
		            }
		        }
		        if (totalPage > BlockSize) {
		            if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
		                strtext = "";
		                strtext = strtext + "<span class='btnimg next' onclick='return selafterBlock()'></span>";
		                PagingHTML += strtext;
		            }
		            else {
		                strtext = "";
		                strtext = strtext + "<span class='btnimg next disabled'></span>";
		                PagingHTML += strtext;
		            }
		        }
		        else {
		            strtext = "";
		            strtext = strtext + "<span class='btnimg next disabled'></span>";
		            PagingHTML += strtext;
		        }
		        if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
		            strtext = "<span class='btnimg last' onclick='return goToPageByNum(" + totalPage + ")'></span>";
		            PagingHTML += strtext;
		        }
		        else {
		            strtext = "<span class='btnimg last disabled'></span>";
		            PagingHTML += strtext;
		        }
		        PagingHTML += "</div>";
		        td_Create1(PagingHTML);
		    }
		    function goToPageByNum(Value) {
		    	p_ListOrderObject = "";		    	
		    	listContentArry = new Array();
		    	
		        CurPage = Value;
		        makePageSelPage();
		        movePage(CurPage);
		    }
		    function selbeforeBlock() {
		        var pageNum = parseInt(CurPage);
		        pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
		        goToPageByNum(pageNum);
		    }
		    function selbeforeBlock_one() {
		        var pageNum = parseInt(CurPage);
		        if (parseInt(pageNum - 1) > 0)
		            goToPageByNum(parseInt(pageNum - 1));
		        else
		            return;
		    }
		    function selafterBlock() {
		        var pageNum = parseInt(CurPage);
		        pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
		        goToPageByNum(pageNum);
		    }
		    function selafterBlock_one() {
		        var pageNum = parseInt(CurPage);
		        if (parseInt(pageNum + 1) <= totalPage)
		            goToPageByNum(parseInt(pageNum + 1));
		        else
		            return;
		    }
		    function movePage(newPage) {
		        if (parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
		            CurPage = newPage;
		            if (issearch)
		                search_click();
		            else
		                displayUserList();
		        }
		    }
		    function prevPage_onclick() {
		        newPage = parseInt(CurPage) - 1;
		        if (newPage > 0) {
		            CurPage = newPage;
		            if (issearch)
		                search_click();
		            else
		                displayUserList();
		        }
		    }
		    function nextPage_onclick() {
		        newPage = parseInt(CurPage) + 1;
		        if (newPage <= parseInt(totalPage)) {
		            CurPage = newPage;
		            if (issearch)
		                search_click();
		            else
		                displayUserList();
		        }
		    }
		    function event_Mover(obj) {
		        if (obj != _RowObject) {
		        	obj.style.backgroundColor = "#EDEDED";
		        }
		    }
		    function event_Mout(obj) {
		        if (obj != _RowObject) {
		        	obj.style.backgroundColor = "#FFFFFF";
		        }
		    }
		    var _RowObject = null;
		    var _RowObjectID = null;
		    var _RowObjectName = null;
		    function event_click(obj) {
		    	if (_RowObject != null) {
		    		_RowObject.style.backgroundColor = "#ffffff";
		    	}

		        _RowObject = obj;
		        _RowObjectID = obj.id;
		        _RowObjectName = $(obj).attr("name");
		        if(_RowObjectName === "deptList") {
		        	rowId = _RowObjectID;
		        }

		        obj.style.backgroundColor = "#f1f8ff";
		        
		        if(_RowObjectID.substring(0, 8) !== "nameList") {
		        	getLadderBmList(_RowObjectID);
		        } 
		    }
		    
		    function event_click2(obj) {
		    	if (_RowObject != null) {
		    		_RowObject.style.backgroundColor = "#ffffff";
		    	}

		        _RowObject = obj;
		        _RowObjectID = obj.id;
		        _RowObjectName = $(obj).attr("name");
		        obj.style.backgroundColor = "#f1f8ff";
		    }
		    
		    var Tab1_SelectID = "1tab1";
		    function ChangeTab(obj) {
		    	var pSelectTab = GetAttribute(obj, "tdname");

		        switch (pSelectTab) {
		            case "circularOrgan":	// 조직도
		            	tabStatus="circularOrgan";
		            	rowId = null;
		                if (document.getElementById("circularOrgan_content").style.display == "none") {
		                    document.getElementById("circularOrgan_content").style.display = "";
		                    document.getElementById("circularDept_content").style.display = "none";
		                    $("#List_TBODY tr").css("backgroundColor", "#ffffff"); // 탭 바꾸면 즐겨찾기에 선택되어있던 것 해제
		                    $("div[id^='editBmGroup_']").hide();
		                    _RowObjectID = null; // 탭 바꾸면 기존에 가지고 있던 값 초기화
		                    _RowObjectName = null;
		                    selectDeptAllUser();
		                }
		                break;
		            case "circularDept":	// 즐겨찾기
		            	tabStatus="circularDept";
		            	
		                if (document.getElementById("circularDept_content").style.display == "none") {
		                    document.getElementById("circularOrgan_content").style.display = "none";
		                    document.getElementById("circularDept_content").style.display = "";
		                    $("#circularDept").scrollTop(0);
		                    $("#List_TBODY2").html("");
		                    $("[id^='MailUserlist'] td").css("background", "#FFF")
		                    listContentArry = new Array();
		                    p_ListOrderObject = "";
		                }
		                break;
		    	}
		    }
	        function Tab1_MouseClick(obj) {
	            obj.className = "tabon";
	            if (obj.id != Tab1_SelectID) {
	                if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null)
	                    document.getElementById(Tab1_SelectID).className = "";

	                obj.className = "tabon";
	                Tab1_SelectID = obj.id;
	                ChangeTab(obj);
	            }
	        }
	      
	        function window_close() {
	             window.returnValue = 0;
	             window.close();
	        } 
	        
		    //2018-08-01 김보미 - 부서명 [사원수] 길이가 길면 조정하는 함수
	        function deptNameLong(containLow, strIsLeaf) {
	        	var deptNameWidth = "";
	        	var sum = $("#spn_deptName").width() + $("#countInfo").width();
	        	
	          	if (containLow == "YES" && strIsLeaf != "TRUE") { //하위가 있고, 표기방식이 [1명/ 전체10명]일 경우
	          		if (sum > 359) {
	          			deptNameWidth = 360 - $("#countInfo").width();
	          		}
	          	} else {
	          		if (sum > 357) {
	          			deptNameWidth = 358 - $("#countInfo").width();
	          		}
	          	}
	        	
	        	$("#spn_deptName").css("width", deptNameWidth);
	        }
		    
	        /* 2018-09-04 홍승비 - 탭메뉴 마우스오버 시 하이라이트 설정 */
	        function tabover(tabObj) {
	        	tabObj.setAttribute("class", "tabon");
	        }
	        function tabout(tabObj) {
	        	if (tabObj.id != Tab1_SelectID) {
	        		tabObj.setAttribute("class", "");
	        	}
	        }
	        
		</script>
	</head>
	<body class="popup" style="overflow:hidden">
		<h1 id="h1Title" style="height: 20px;"><spring:message code="ezLadder.t071" /></h1>
		<div id="close">
		    <ul>
		    	<li><span onclick="window_close()"></span></li>
		    </ul>
	    </div>
		<table style="width:100%;margin-top:15px;">
			<tr>
				<td>
	        		<table id="TreeViewTD">
	                	<tr>
	                		<div class="portlet_tabpart01" style="width:664px;">
	        					<div class="portlet_tabpart01_top" id="tab1" style="width:664px;">
					            	<p><span id="1tab1" tdname="circularOrgan" style="min-width: 45px; cursor:pointer; text-align: center;" onclick="Tab1_MouseClick(this)" onmouseover="tabover(this)" onmouseout="tabout(this)"><spring:message code='ezLadder.t037' /></span></p>
									<p><span id="1tab2" tdname="circularDept" style="min-width: 45px; cursor:pointer;" onclick="Tab1_MouseClick(this)" onmouseover="tabover(this)" onmouseout="tabout(this)"><spring:message code='ezLadder.t038' /></span></p>
						        </div>
						    </div>
	                    	<td id="circularOrgan_content" style="display:none;">
	                            <div class="portlet_tabpart03" style="background-color: #f8f8fa; margin-top: 3px; padding:0px; border-top-color:white">
	                                <div class="portlet_tabpart03_top" id="tab1" style="border: 1px solid #ddd;">
	                                    <table style="margin-top: 3px; width: 100%;">
	                                        <tr>
	                                            <td>
	                                                <div style="margin-left: 5px;margin-top:1px">
	                                                    <select id="search_type" style="height: 22px;">
	                                                        <option selected value="displayname" usedefault="1"><spring:message code='ezLadder.t029' /></option>
	                                                        <option value="description" usedefault="1"><spring:message code='ezLadder.t028' /></option>
	                                                        <option value="title" usedefault="1"><spring:message code='ezLadder.t039' /></option>
	                                                        <option value="telephonenumber" usedefault="1"><spring:message code='ezLadder.t040' /></option>
	                                                        <option value="mobile" usedefault="0"><spring:message code='ezLadder.t041' /></option>
	                                                        <option value="HomePhone" usedefault="0"><spring:message code='ezLadder.t042' /></option>
	                                                        <option value="facsimileTelephoneNumber" usedefault="0"><spring:message code='ezLadder.t043' /></option>
	                                                        <c:if test="${primaryLang eq '3' }">
		                                                    <option value="extensionPhone" usedefault="0"><spring:message code='main.ksa02' /></option>
		                                                    <option value="officeMobile" usedefault="0"><spring:message code='main.ksa03' /></option>
		                                                    </c:if>
	                                                        <option value="mail" usedefault="0"><spring:message code='ezLadder.t044' /></option>
	                                                        <option value="streetAddress" usedefault="0" style="display:none"><spring:message code='ezLadder.t045' /></option>
	                                                    </select>
	                                                    <input id="keyword" value="" onkeyup="search_press(event)" onmousedown="keyword_Clear();" style="width: 130px; margin: 0px;height:22px">
	                                                    <a class="imgbtn"><span onclick="search_click('search')"><spring:message code='ezLadder.t046' /></span></a>
	                                                </div>
	                                            </td>
	                                            <td>
	                                                <div style="float: right; margin-right: 5px;">
	                                                    <a class="imgbtn"><span onclick="infoview_click()"><spring:message code='ezLadder.t047' /></span></a>
	                                                </div>
	                                            </td>
	                                        </tr>
	                                    </table>
	                                </div>
	                            </div>
	                            <table style="margin-top: 3px;">
	                                <tr>
	                                    <td class="box" style="border-right:0px">
	                                        <div style="width: 220px; height: 500px; overflow-x: auto; overflow-y: auto;" id="TreeView"></div>
	                                    </td>
	                                    <td></td>
	                                    <td class="listview" style="width: 426px" id="orglistView">
	                                        <table style="width: 100%; margin-top: -1px;" class="popup_mainlist">
	                                            <tr>
	                                                <th style="white-space:normal;background-color: white;border-top:0px;border-bottom:1px solid #eaeaea">
	                                                    <span id="SelectDeptNM" style="font-weight: normal; width: 380px; height: 18px; white-space: nowrap; overflow: hidden; display: inline-block; vertical-align: bottom;"></span>
	                                                    <span style="float:right;">
	                                                        <span onclick="ChangeListView_onClick('TXT');"><img src="/images/kr/cm/btn_list.gif" class="icon_btn" id="txtlist"></span>
	                                                        <span onclick="ChangeListView_onClick('IMG');"><img src="/images/kr/cm/btn_imglist.gif" class="icon_btn" id="imglist"></span>
	                                                    </span>
	                                                </th>
	                                            </tr>
	                                        </table>
	                                        <div style="vertical-align: top; height: 422px; overflow: auto; width: 440px;" id="txtlist_Layer">
	                                            <table style="width: 100%; border: 1px solid #B6B6B6; display: none;" id="txtlist_table" class="mainlist">
	                                                <tr>
	                                                    <td style="width: 170px; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezLadder.t029' /></td>
	                                                    <td style="width: 150px; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezLadder.t039' /></td>
	                                                    <td class="td_gray" style="color:#333;background-color: #f8f8fa"><spring:message code='ezLadder.t040' /></td>
	                                                </tr>
	                                            </table>
	                                            <table style="width: 100%; border: 1px solid #B6B6B6; display: none;" id="Search_txtlist_table" class="mainlist">
	                                                <tr>
	                                                    <td style="width: 130px; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezLadder.t028' /></td>
	                                                    <td style="width: 90px; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezLadder.t029' /></td>
	                                                    <td style="width: 90px; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezLadder.t039' /></td>
	                                                    <td class="td_gray" style="color:#333;background-color: #f8f8fa"><spring:message code='ezLadder.t040' /></td>
	                                                </tr>
	                                            </table>
	                                        </div>
	                                        <div style="vertical-align: top; text-align: center; height: 422px; overflow: auto; display: none; width: 440px;" id="DeptUserImgList"></div>
	                                        <div id="tblPageRayer" style="text-align:center;/* border-top:1px solid #B6B6B6; */height:32px;margin-bottom:15px"></div>
	                                    </td>
	                                </tr>
	                            </table>
	                        </td>
	                        <td id="circularDept_content" style="display:none; width:664px;">
	                        	<table style="width:100%">
	                                <tr>
	                                    <td style="background-color: #f3f3f3; padding: 4px 0 3px 0; background-color: #ffffff; height: 20px;">
	                                        <h2 class="h2_dot" style="padding-top: 2px; display: inline-block;"><spring:message code='ezLadder.t022' /></h2>
											<div style="float: right;height:28px;">
												<a class="imgbtn imgbck" onclick="editBM('modify');" style="display: inline-block; margin-top: 1px;"><span><spring:message code="ezLadder.t061" /> <spring:message code="ezLadder.t052" /></span></a>
												<a class="imgbtn imgbck" onclick="editBM('delete');" style="display: inline-block; margin-top: 1px;"><span><spring:message code="ezLadder.t061" /> <spring:message code="ezLadder.t053" /></span></a>
											</div>
											<div style="clear:both"></div>
	                                        <div class="border_gray">
	                                            <div id="circularDept" style="Width: 100%; Height: 182px; OVERFLOW: AUTO; padding-top: 0px;">
	                                            	<table class="mainlist" style="width: 100%;">
								                        <thead id="List_THEAD">
									                        <tr>
									                        	<th style="width: 5%;"><span><spring:message code='ezLadder.t023' /></span></th>
									                            <th style="width: 39%;"><span><spring:message code='ezLadder.t024' /></span></th>
									                            <th style="width: 31%;"><span><spring:message code='ezLadder.t025' /></span></th>
									                            <th style="width: 24%;"><span><spring:message code='ezLadder.t026' /></span></th>
									                        </tr>
								                        </thead>
								                        <tbody id="List_TBODY">					                        
								                        </tbody>
								                    </table>
	                                            </div>
	                                        </div>
	                                    </td>
	                                </tr>
	                                <tr>
	                                    <td style="vertical-align: top;">
	                                        <div class="border_gray">
	                                            <div id="circularTemp" style="Width: 100%; Height: 323px; OVERFLOW: AUTO; padding-top: 0px;">
	                                            	<table id="List" class="mainlist" style="width:100%">
														<thead id="List_THEAD2">
															<tr>
																<th id="TH_0" style="width:5%"><spring:message code='ezLadder.t023'/></th>
																<th id="TH_1" style="width:18%"><spring:message code='ezLadder.t027'/></th>
																<th id="TH_2" style="width:20%"><spring:message code='ezLadder.t028'/></th>
																<th id="TH_3" style="width:16%"><spring:message code='ezLadder.t029'/></th>
																<th id="TH_4" style="width:41%">EMAIL</th>
															</tr>
														</thead>
														<tbody id="List_TBODY2">
														</tbody>
													</table>
	                                            </div>
                                            </div>
	                                    </td>
	                                </tr>
	                            </table>
	                        </td>
	                        <td style="width: 30px; text-align: center;">                            
	                            <img src="/images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="InsertReceiver(ListViewMsgTo)"><br>
	                            <img src="/images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="DeleteReceiver2(ListViewMsgTo)">
	                        </td>
	                        <td style="vertical-align: top; position: relative;">
								<a class="imgbtn imgbck ladder" id="ladderBmBtn" onclick="setBmGroup('add', 0);" style="position:  absolute; top: 0; right:  0; margin-top: -30px;"><span><spring:message code="ezLadder.t061" /> <spring:message code="ezLadder.t021" /></span></a>
	                            <h2 id="ToTitle" class="receiver_tltype01" style="margin-top:-30px;">
	                                <span style="min-width: 45px;" id="ToTitleStr"><spring:message code='ezLadder.t013'/></span>
	                            </h2>
	                            <div class="receiver_borderbox" style="position: relative;">
	                                <div id="ListViewMsgTo" ondragover ="onDragEnter(event)" ondrop ="onDrop(event, this)" style="width: 250px; Height: 544px; overflow-x: auto; overflow-y: auto;"  ondblclick="DeleteReceiver(ListViewMsgTo)"></div>
	                            </div>
	                        </td>
	                    </tr>
	                </table>
	      		</td> 
	    	</tr> 
	 	</table>	    
		<div class="btnposition btnpositionNew">
	    	<a class="imgbtn" onClick="btnok_onclick()" ><span><spring:message code='ezLadder.t086' /></span></a>
		</div>
		
		<!-- popup start -->
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup" style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
	        <iframe src="<spring:message code='main.kms4' />" style="border: none;" id="iFrameLayer"></iframe>
	    </div>
	    <!-- end -->
	</body>
</html>