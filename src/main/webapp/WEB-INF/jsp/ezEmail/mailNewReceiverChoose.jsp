<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezEmail.t572' /></title>
	    <meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
	    <style>
	    	.mainlist tr td:first-child {
	    		padding-left:15px;	    		
	    	}
	    	
	    	.mainlist_free tr th, .mainlist_free tr td {
			    height: 0px;
			    padding-left:15px;
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

			.multiple-sortable-selected td{
				color: #0684f9 !important;
			}
			
			.checkDept {
				height: 16px !important;
			}
			
			.popup h2{padding-top:4px !important;}
			.receiver_tltype01{line-height:28px;}

			.mainlist tr td[style*="display: none"]:first-child.none + td{padding-left:15px;}

	    </style>
	    <script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/js/ezEmail/Controls/ezSearchDatePicker.htc')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/ezAddress/address_tree_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/treeview_namespace.htc.js')}"></script>
	    <link rel="stylesheet" href="${util.addVer('main.lhm01', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezPersonal/controls/TreeView.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/ListView_list.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery.multipleSortable.js')}"></script>
	    <script type="text/javascript">
	        var m_tabDialogState = { "org": "select", "contact": "normal", "dl": "normal", "sharedMailbox": "normal", 
	        		"orgJobMst1": "normal", "orgJobMst2": "normal" };
	        var m_receiverTitleList;
	        var m_receiverWindowList;
	        var m_titleNoneSelectedColor = "white";
	        var m_titleSelectedColor = "#f4faff";
	        var m_selectedWindow = null;
	        var m_selectedTree = null;
	        var g_fnaddReceiver;
	        var g_xmlHTTP = null;
	        var bSearch = false;
	        var addrsearh = false;
	        var page = 1;
	        var CurPage = "1";
	        var pagecount;
	        var agoNodeIdx = "";
	        var agoNodeBool = false;
	        var searchgubun = "N";
	        var userid = "${userInfo.id}";
	        var deptid = "${userInfo.deptID}";
	        var companyid = "${userInfo.companyID}";
	        var susinTo = 0;
	        var AddressTreeView = null;
	        var UserAgentState = navigator.userAgent.toLowerCase();
	        var browserIE = (!CrossYN()) ? true : false;
	        var type = '<c:out value="${type}"/>';
	        var rulekind = '<c:out value="${ruleKind}"/>';
	        var pListType = "TXT";
	        var pListXML_Info = null;
	        var strLang_2 = "<spring:message code='ezEmail.t655' />";
	        var strSearch = "";
	        var ua = navigator.userAgent;
	        var selTab = "";
	        var selSpan = "";
	        var divListArry = [];
	        var receiverCount = 0;
	        var groupAddressCountMap = {};
	        var mailMaxReceiverCount = parseInt("${mailMaxReceiverCount}");
	        var useUserDefinedDL = "${useUserDefinedDL}";
	        var useShowAllCompanies = "${useShowAllCompanies}";
	        var useOrgListCheckBox = JSON.parse("${useOrgListCheckBox}");
	        var receiverListId = "";
	        var maxTotalLength = 45;
	        
	        document.onselectstart = function () {
	            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	                return false;
	            else
	                return true;
	        };
	        if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
	            window.onblur = function () {
	                window.focus();
	            }
	        }
	        document.onkeydown = function (evt) {
	            if (!MACSAFARIYN()) {
	                var e = evt;
	                if (e == null) e = window.event;
	                if (new RegExp(/Safari/).test(navigator.userAgent) && navigator.userAgent.indexOf("Chrome") == -1){
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
	        }
	        var RetValue;
	        var ReturnFunction;
	        window.onload = function () {
	            try {
	                RetValue = parent.mail_newreceiverchoose_dialogArguments[0];
	                ReturnFunction = parent.mail_newreceiverchoose_dialogArguments[1];
	            } catch (e) {
	                try {
	                    RetValue = opener.mail_newreceiverchoose_dialogArguments[0];
	                    ReturnFunction = opener.mail_newreceiverchoose_dialogArguments[1];
	                } catch (e) {console.log(e);}
	            }
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }
	            
	            useOrgListCheckBox = (!useOrgListCheckBox || type == "auto") ? false : true; // 도착한 메일전달 페이지에서는 체크박스 표시 안함
	            if (useOrgListCheckBox) { // table header에 체크박스 td 추가
	            	// ####### 조직도
	            	var addTD = document.createElement("TD");
					addTD.style.cssText = "width: 15px; color:#333;background-color: #f1f3f5; padding:5px; ";
					addTD.innerHTML = "<input type='checkbox' class='checkAll'>";  
					
					$("#txtlist_table tr:first-child").prepend(addTD.cloneNode(true));
					$("#Search_txtlist_table tr:first-child").prepend(addTD.cloneNode(true));
					
					// ####### 주소록, 공용배포그룹, 공유사서함
					var addHeader = document.createElement("HEADER");
					var addHeaderInnerHtml = "<NAME></NAME><WIDTH>20</WIDTH><STYLE>padding:5px;</STYLE><ISCHECKBOX>TRUE</ISCHECKBOX>";
					addHeader.innerHTML = addHeaderInnerHtml;
					
					var listViewHeaderXML = [listviewheader3,listviewheader4,listviewheader5];
					$.each(listViewHeaderXML, function(i,e) {
						var listViewHeader_Header = e.getElementsByTagName("headers")[0];
						
						var addHeaderClone = addHeader.cloneNode(true);
						if (e.id == "listviewheader4") {
							addHeaderClone.getElementsByTagName("WIDTH")[0].textContent = "10";
						}
						
						listViewHeader_Header.insertBefore(addHeaderClone, listViewHeader_Header.firstChild);
					});
	            }
	            
	            m_receiverTitleList = new Array(ToTitle, CCTitle, BCCTitle);
	            m_receiverWindowList = new Array(ListViewMsgTo, ListViewMsgCC, ListViewMsgBCC);
	            recevieListview("MsgToList", "ListViewMsgTo");
	            recevieListview("MsgCCList", "ListViewMsgCC");
	            recevieListview("MsgBCCList", "ListViewMsgBCC");
	            AddressTreeView = new window['treeview.htc'].TreeView('AddressTreeView', 'AddressTreeView');
	            AddressTreeView.attachEvent('requestdata', address_requestdata);
	            AddressTreeView.attachEvent('nodeselect', function () { address_selectnode("node") });
	            AddressTreeView.attachEvent('nodedblclick', function () { AddressTreeView.toggle(AddressTreeView.selectedIndex()) });
	            if (type != "rule" && type != "auto")
	                applyCurrentData();
	            orgTabButton_onClick();
	            ListTypeChangeIcon();
	
	            if (ReturnFunction == null)
	            	if (CrossYN()) {
                        g_fnaddReceiver = opener.addReceiver;
	            	} else {
		                g_fnaddReceiver = window.dialogArguments["addReceiver"];
	            	}
	            
	            //orgTreeViewListSet();
	            
	            if ("${useSharedMailbox}" == "YES") {
	            	document.getElementById("sharedMailboxTabButton").style.display = "";
	            }
	            
	            if (type == "config") {
	                if (CrossYN())
	                    document.getElementById("h1Title").textContent = strLang314 + "<spring:message code='ezEmail.t832' />";
	                else
	                    document.getElementById("h1Title").innerText = strLang314 + "<spring:message code='ezEmail.t832' />";
	                document.title = strLang314 + "<spring:message code='ezEmail.t832' />";
	                document.getElementById("ToTitleStr").innerHTML = strLang314;
	                document.getElementById("inputTabButton").style.display = "";
	                document.getElementById("ListMsgTo").setAttribute("rowspan", "3");
	                document.getElementById("ListMsgCC").style.display = "none";
	                document.getElementById("ListMsgBCC").style.display = "none";
	                document.getElementById("ListViewMsgTo").style.height = "477px";
	                SelectReceiverWindow(ToTitle, ListViewMsgTo);
	            }
	            else if (type == "rule") {
	                if (rulekind == "SENDER") {
	                    document.getElementById("ToTitleStr").innerHTML = strLang315;
	                    if (CrossYN())
	                        document.getElementById("h1Title").textContent = strLang315 + " <spring:message code='ezEmail.t552' />";
	                    else
	                        document.getElementById("h1Title").innerText = strLang315 + " <spring:message code='ezEmail.t552' />";
	                    document.title = strLang315 + "<spring:message code='ezEmail.t552' />";
	                }
	                else if (rulekind == "RECEIVER") {
	                    document.getElementById("ToTitleStr").innerHTML = strLang316;
	                    if (CrossYN())
	                        document.getElementById("h1Title").textContent = strLang316 + " <spring:message code='ezEmail.t552' />";
	                    else
	                        document.getElementById("h1Title").innerText = strLang316 + " <spring:message code='ezEmail.t552' />";
	                    document.title = strLang316 + "<spring:message code='ezEmail.t552' />";
	                }
	                document.getElementById("inputTabButton").style.display = "none";
	                document.getElementById("ListMsgTo").setAttribute("rowspan", "3");
	                document.getElementById("ListMsgCC").style.display = "none";
	                document.getElementById("ListMsgBCC").style.display = "none";
	                document.getElementById("ListViewMsgTo").style.height = "508px";
	                SelectReceiverWindow(ToTitle, ListViewMsgTo);
	            }
	            else if (type == "auto") {
	                if (CrossYN())
	                    document.getElementById("h1Title").textContent = " <spring:message code='ezEmail.t99000080' />";
	                else
	                    document.getElementById("h1Title").innerText = " <spring:message code='ezEmail.t99000080' />";
	
	                document.title = " <spring:message code='ezEmail.t99000080' />";
	                document.getElementById("ToTitleStr").innerHTML = strLang314;
	                document.getElementById("inputTabButton").style.display = "none";
	                //document.getElementById("dlTabButton").style.display = "none";
	                document.getElementById("ListMsgTo").style.display = "none";
	                document.getElementById("ListMsgTo").setAttribute("rowspan", "3");
	                document.getElementById("ListMsgCC").style.display = "none";
	                document.getElementById("ListMsgBCC").style.display = "none";
	                document.getElementById("ListViewMsgTo").style.height = "508px";
	                SelectReceiverWindow(ToTitle, ListViewMsgTo);
					remove_key_event();
	
	                document.getElementById("dept_select").style.display = "none";
 	            }
	            else {
	                document.getElementById("h1Title").style.marginBottom = "0px";
	                document.getElementById("mailReceiverInfoTxt").style.display = "block";
	                
	                // 2024.07.25 한슬기 : 새로고침시 화면 사이즈가 계속 늘어나는 문제가 있어 변경
	                window.resizeTo(window.outerWidth, window.outerHeight);
	                //window.resizeTo(window.outerWidth, window.outerHeight+18);

	                SelectReceiverWindow(document.getElementById('<c:out value="${defaultWin}"/>' + "Title"), document.getElementById("ListViewMsg" + '<c:out value="${defaultWin}"/>'));
	            }
	            
	            // (수신자 설정 시 drag, drop으로 순서 조정)
	            $("#ListViewMsgTo, #ListViewMsgCC, #ListViewMsgBCC").multipleSortable({
                  connectWith: "#ListViewMsgTo, #ListViewMsgCC, #ListViewMsgBCC",
                  items : "tr",
                  opacity: 0.3,
                  start : function(event, elem) { 
                      $(".receiver_borderbox tr").removeClass("multiple-sortable-selected");
                      $(".receiver_borderbox tr").removeClass("ui-sortable-helper");
                  },
                  click : function(event) {
                	  
                	  var selectList = $("#" + event.currentTarget.offsetParent.id + " tr[selected=true]");
                      
                      $(".receiver_borderbox tr").removeClass("multiple-sortable-selected");
                      $(".receiver_borderbox tr").removeClass("ui-sortable-helper");
                      
                      for (var i = 0; i <selectList.length; i++) {
                     	 divListArry[i] = selectList[i];
                     	 $("#" + divListArry[i].id).addClass("multiple-sortable-selected");
                      }
                  },
                  stop : function(event, elem) {
                	  
                	  //드랍되었을때 selected랑 색 변경해주기
                	  var noSelectedList = divListArry; //$("#" + event.target.id + " tbody tr");
                	  
                	  for (var i = 0; i < noSelectedList.length; i++) {
                		  noSelectedList[i].style.backgroundColor = m_strColorDefault;
                		  noSelectedList[i].setAttribute("selected", "false");
                	  }
                	  
                	  // thead에 들어가는 현상 수정 
                	  var elemParent = elem.item[0].parentNode;
                	  var elemTalbeId = elemParent.parentElement.id;
                	  
                	  if (elemParent.tagName == 'THEAD'){
                		  
                		  var thName = '';
                    	  if (elemParent.id == 'MsgToList_THEAD') {
                    		  thName = 'MsgToList_TH';
                    	  } else if (elemParent.id == 'MsgCCList_THEAD') {
                    		  thName = 'MsgCCList_TH';
                    	  } else if (elemParent.id == 'MsgBCCList_THEAD') {
                    		  thName = 'MsgBCCList_TH';
                    	  }
                    	  
                    	  var childArry = $("#" + elemParent.id + " tr[id!=" + thName + "]");
                		  
                    	  document.getElementById(elemTalbeId).className = "receiver_list";
                    	  
                		  for (var i = 0;i < childArry.length; i++) {
                			  elemParent.nextSibling.appendChild(childArry[i]); // tbody에 추가
                		  }
                	  }
                	  
                	  divListArry = [];
                	  changeCheckBox();
                  }
               });
	            
	            ChangeListView_onClick(getOrganListType());
	            
	            //메일창에서 수신자설정창을 열고 메일창을 먼저 닫았을 경우, 수신사설정창도 닫히도록 처리 2019-07-31 홍대표
	            checkMailWriteWindow();
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
		    function event_getDeptFullTree() {
		        if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
		            if (g_xmlHTTP.status == 200) {
		                if (!bSearch) {
		                    try {
		                        if (CrossYN())
		                            opener.opener.top.organview = loadXMLString(g_xmlHTTP.responseText);
		                        else
		                            window.dialogArguments["window"].opener.top.organview = loadXMLString(g_xmlHTTP.responseText);
		                    } catch (e) {console.log(e);}
		                }
		
		                var treeXML = loadXMLFile("/xml/common/organtree_config2.xml");
		                document.getElementById('TreeView').innerHTML = "";
		
		                var treeView = new TreeView();
		                treeView.SetConfig(treeXML);
		                treeView.SetID("FromTreeView");
		                treeView.SetUseAgency(true);
		                treeView.SetUseCheckBox(useOrgListCheckBox);
		                treeView.SetRequestData("RequestData");
		                treeView.SetNodeClick("TreeViewNodeClick");
		                treeView.DataSource(loadXMLString(g_xmlHTTP.responseText));
		                treeView.DataBind("TreeView");
		            }
		            else {
		                alert("<spring:message code='ezEmail.t17' />" + g_xmlHTTP.status)
		                g_xmlHTTP = null;
		            }
		        }
		    }
		    function applyCurrentData() {
		        if (type == "config") {
		            var XmlText = getOrganinfo();
		            var XmlDom = XmlText;
		            var count = XmlDom.getElementsByTagName("Table").length;
		            if (!CrossYN()) {
		                if (XmlDom.getElementsByTagName("NAME")[0] == null || XmlDom.getElementsByTagName("NAME")[0].text == "") {
		                    return;
		                }
		            }
		            else if (CrossYN()) {
		                if (XmlDom.getElementsByTagName("NAME")[0] == undefined) {
		                    return;
		                }
		            }
		            var pparsingXML = "";
		            var pparsingXML2 = "";
		            var strName = "";
		            var strEmail = "";
		            pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
		            for (var i = 0; i < count; i++) {
		                if (!CrossYN()) {
		                    strName = XmlDom.getElementsByTagName("NAME")[i].text;
		                    strEmail = XmlDom.getElementsByTagName("EMAIL")[i].text;
		                }
		                else if (CrossYN()) {
		                    strName = XmlDom.getElementsByTagName("NAME")[i].textContent;
		                    strEmail = XmlDom.getElementsByTagName("EMAIL")[i].textContent;
		                }
		                pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strName) + "</DATA1>";
		                pparsingXML = pparsingXML + "<DATA2>" + strEmail + "</DATA2>";

                        var strNameXml = MakeXMLString(strName);
                        var maxNameLength = maxTotalLength - strEmail.length;

                        if (maxNameLength > 0) {
                            strNameXml = strNameXml.substring(0, maxNameLength);
                        }

		                pparsingXML = pparsingXML + "<VALUE>" + strNameXml + " &lt;" + strEmail + "&gt;" + "</VALUE></CELL></ROW>";
		            }
		            pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
		            var Resultxml = loadXMLString(pparsingXML2);
		            var listview = new ListView();
		            listview.SetID("MsgToList");
		            listview.SetHeightFree(true);
		            listview.SetSelectFlag(false);
		            listview.SetMulSelectable(false);
		            listview.SetRowOnDblClick("DeleteReceiver");
		            listview.DataSource(Resultxml);
		            listview.RowDataBind();
		
		            document.getElementById("MsgToList").className = "receiver_list";
		            var _tdlength = document.getElementById("MsgToList").getElementsByTagName("TD").length;
		            for (var y = 0; y < _tdlength; y++) {
		                document.getElementById("MsgToList").getElementsByTagName("TD")[y].style.textOverflow = "";
		                document.getElementById("MsgToList").getElementsByTagName("TD")[y].style.overflow = "";
		            }
		        }
		        else {
		            var oldReceiverData;
		            if (ReturnFunction!=null)
		                oldReceiverData = RetValue;
		            else
		                oldReceiverData = window.dialogArguments;
		
		            addReceiverToList(oldReceiverData["to"], "ListViewMsgTo");
		            addReceiverToList(oldReceiverData["cc"], "ListViewMsgCC");
		            addReceiverToList(oldReceiverData["bcc"], "ListViewMsgBCC");
		            receiverCount = oldReceiverData["receiverCount"];
		            groupAddressCountMap = oldReceiverData["groupAddressCountMap"];
		        }
		    }
		    function addReceiverToList(receiverData, receiverList) {
		        try {
		            if (receiverData["name"][0] == null) {
		                return;
		            }
		            var pparsingXML = "";
		            var pparsingXML2 = "";
		            var strName = "";
		            var strEmail = "";
		            var strhref = "";
		            var strType = "";
		            pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
		            for (var count = 0; count < receiverData["name"].length; count++) {
		                strName = receiverData["name"][count];
		                strEmail = receiverData["email"][count];
		                strhref = receiverData["href"][count];
		                strType = receiverData["type"][count];

		                var strNameXml = MakeXMLString(strName);
                        var maxNameLength = maxTotalLength - strEmail.length;

                        if (maxNameLength > 0) {
                            strNameXml = strNameXml.substring(0, maxNameLength);
                        }

		                if (strType == "mailgroup") {
		                    pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strName) + "</DATA1>";
		                    pparsingXML = pparsingXML + "<DATA2>" + strType + "</DATA2>";
		                    pparsingXML = pparsingXML + "<DATA3>" + strEmail + "</DATA3>";
		                    pparsingXML = pparsingXML + "<DATA4>" + strhref + "</DATA4>";
		                    pparsingXML = pparsingXML + "<VALUE>" + strNameXml + " &lt;" + strEmail + "&gt;" + "</VALUE></CELL></ROW>";
		                }
		                else {
		                    pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strName) + "</DATA1>";
		                    pparsingXML = pparsingXML + "<DATA2>" + strEmail + "</DATA2>";
		                    pparsingXML = pparsingXML + "<DATA3>" + strType + "</DATA3>";
		                    pparsingXML = pparsingXML + "<DATA4>" + strhref + "</DATA4>";
		                    pparsingXML = pparsingXML + "<VALUE>" + strNameXml + " &lt;" + strEmail + "&gt;" + "</VALUE></CELL></ROW>";
		                }
		
		            }
		            pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
		            var Resultxml = loadXMLString(pparsingXML2);
		            if (receiverList == "ListViewMsgTo") {
		                listid = "MsgToList";
		                var listview = new ListView();
		                listview.SetID("MsgToList");
		                listview.SetHeightFree(true);
		                listview.SetSelectFlag(false);
		                listview.SetMulSelectable(false);
		                listview.SetRowOnDblClick("DeleteReceiver");
		                listview.DataSource(loadXMLString(document.getElementById("listviewheader").innerHTML.toUpperCase()));
		                listview.DataSource(Resultxml);
		                listview.RowDataBind();
		
		                document.getElementById(listid).className = "receiver_list";
		                var _tdlength = document.getElementById("MsgToList").getElementsByTagName("TD").length;
		                for (var y = 0; y < _tdlength; y++) {
		                    document.getElementById("MsgToList").getElementsByTagName("TD")[y].style.textOverflow = "";
		                    document.getElementById("MsgToList").getElementsByTagName("TD")[y].style.overflow = "";
		                }
		            }
		            else if (receiverList == "ListViewMsgCC") {
		                listid = "MsgCCList";
		                var listview = new ListView();
		                listview.SetID("MsgCCList");
		                listview.SetHeightFree(true);
		                listview.SetSelectFlag(false);
		                listview.SetMulSelectable(false);
		                listview.SetRowOnDblClick("DeleteReceiver");
		                listview.DataSource(Resultxml);
		                listview.RowDataBind();
		
		                document.getElementById(listid).className = "receiver_list";
		                var _tdlength = document.getElementById("MsgCCList").getElementsByTagName("TD").length;
		                for (var y = 0; y < _tdlength; y++) {
		                    document.getElementById("MsgCCList").getElementsByTagName("TD")[y].style.textOverflow = "";
		                    document.getElementById("MsgCCList").getElementsByTagName("TD")[y].style.overflow = "";
		                }
		            }
		            else if (receiverList == "ListViewMsgBCC") {
		                listid = "MsgBCCList";
		                var listview = new ListView();
		                listview.SetID("MsgBCCList");
		                listview.SetHeightFree(true);
		                listview.SetSelectFlag(false);
		                listview.SetMulSelectable(false);
		                listview.SetRowOnDblClick("DeleteReceiver");
		                listview.DataSource(Resultxml);
		                listview.RowDataBind();
		
		                document.getElementById(listid).className = "receiver_list";
		                var _tdlength = document.getElementById("MsgBCCList").getElementsByTagName("TD").length;
		                for (var y = 0; y < _tdlength; y++) {
		                    document.getElementById("MsgBCCList").getElementsByTagName("TD")[y].style.textOverflow = "";
		                    document.getElementById("MsgBCCList").getElementsByTagName("TD")[y].style.overflow = "";
		                }
		            }
		        } catch (e) { alert(e.description); }
		    }
		    function orgTabButton_onClick() {
		    	methodForTabAction(1);
		        selTab = "orglistView";
		        selSpan = "orgSpan";
		        
		        $.each(m_tabDialogState, function(i,d) {
        			var setVal = "org" == i ? "select" : "normal";
        			m_tabDialogState[i] = setVal; 
        		});
		        clearOrgTab("org");
		        TreeViewTD.style.display = "block";
		        ListViewTD.style.display = "none";
		        ListViewDLTD.style.display = "none";
		        ListViewSharedMailboxTD.style.display = "none";
		        ListViewINPUT.style.display = "none";
		        dlmember.style.display = "none";
		        sharedMailboxMember.style.display = "none";
		        m_selectedTree = orglistView;
		        AddrSearch.style.display = "none";
		        
		        orgTreeViewListSet();
		    }
		    
		    function orgTreeViewListSet() {
		    	try {
		    		var topIdData = useShowAllCompanies == "YES" ? "Top/organ" : "Top";
		    		
	                var xmlpara = createXmlDom();
	                var xmlTree = createXmlDom();
	                var xmlHTTP = createXMLHttpRequest();
	                var objNode;
	                createNodeInsert(xmlpara, objNode, "DATA");
	                createNodeAndInsertText(xmlpara, objNode, "DEPTID", "${userInfo.deptID}");
	                createNodeAndInsertText(xmlpara, objNode, "TOPID", topIdData);
	                createNodeAndInsertText(xmlpara, objNode, "PROP", "mail");
	                xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
	                xmlHTTP.send(xmlpara);
	                xmlTree = loadXMLString(xmlHTTP.responseText);
	                var treeXML = loadXMLFile("/xml/common/organtree_config3.xml");
	                document.getElementById('TreeView').innerHTML = "";
	                var treeView = new TreeView();
	                treeView.SetConfig(treeXML);
	                treeView.SetID("FromTreeView");
	                treeView.SetUseAgency(true);
	                treeView.SetUseCheckBox(useOrgListCheckBox);
	                treeView.SetRequestData("RequestData");
	                treeView.SetNodeClick("TreeViewNodeClick");
	                treeView.DataSource(xmlTree);
	                treeView.DataBind("TreeView");
	
	                if (strSearch != "") {
	                    document.getElementById('keyword').value = strSearch;
	                    search_click();
	                }
	            }
	            catch (ErrMsg) {
	                alert(" TreeViewinitialize : " + ErrMsg.description);
	            }
		    }
		    
		    var g_bContactLoaded = false;
		    function contactTabButton_onClick() {
		    	methodForTabAction(2);
		        selTab = "AddressListView";
		        selSpan = "contactSpan";
		        if (g_bContactLoaded == false) {
		            g_bContactLoaded = true;
		            LoadAddressTree();
		        }
		        
		        $.each(m_tabDialogState, function(i,d) {
        			var setVal = "contact" == i ? "select" : "normal";
        			m_tabDialogState[i] = setVal; 
        		});
		        TreeViewTD.style.display = "none";
		        ListViewTD.style.display = "block";
		        ListViewDLTD.style.display = "none";
		        ListViewSharedMailboxTD.style.display = "none";
		        ListViewINPUT.style.display = "none";
		        dlmember.style.display = "none";
		        sharedMailboxMember.style.display = "none";
		        m_selectedTree = AddressListView;
		        AddrSearch.style.display = "block";
		        
		        $(".checkAll").prop("checked", false);
		    }
		    function dlTabButton_onClick() {
		    	methodForTabAction(3);
		    	selTab = "DistributionList";
		    	selSpan = "dlSpan";
		    	
	    	 	$.each(m_tabDialogState, function(i,d) {
        			var setVal = "dl" == i ? "select" : "normal";
        			m_tabDialogState[i] = setVal; 
        		});
		    	
		        TreeViewTD.style.display = "none";
		        ListViewTD.style.display = "none";
		        ListViewDLTD.style.display = "block";
		        ListViewSharedMailboxTD.style.display = "none";
		        ListViewINPUT.style.display = "none";
		        dlmember.style.display = "block";
		        sharedMailboxMember.style.display = "none";
		        AddrSearch.style.display = "none";
		        m_selectedTree = ListViewDL;
		       
		        if (useUserDefinedDL == "YES") {
		        	changeUserDlType();
		        } else {
			        distributionListSet();
		        }
		        
	        }
		    function sharedMailboxTabButton_onClick() {
		    	methodForTabAction(5);
		    	selTab = "sharedMailboxList";
		    	selSpan = "sharedMailboxSpan";
		    	
		    	$.each(m_tabDialogState, function(i,d) {
        			var setVal = "sharedMailbox" == i ? "select" : "normal";
        			m_tabDialogState[i] = setVal; 
        		});
		        TreeViewTD.style.display = "none";
		        ListViewTD.style.display = "none";
		        ListViewDLTD.style.display = "none";
		        ListViewSharedMailboxTD.style.display = "block";
		        ListViewINPUT.style.display = "none";
		        dlmember.style.display = "none";
		        sharedMailboxMember.style.display = "block";
		        AddrSearch.style.display = "none";
		        m_selectedTree = ListViewSharedMailbox;
		        
		        try {
		            var xmlHTTP = createXMLHttpRequest();
		            xmlHTTP.open("POST", "/ezEmail/getSharedMailboxList.do", false);
		            xmlHTTP.send("");
		            
		            if (xmlHTTP.status != 200) {
			            alert("<spring:message code='ezEmail.sharedMailbox07' />" + xmlHTTP.status);
		            } else {
		            	document.getElementById("ListViewSharedMailbox").innerHTML = "";
			            var pListViewSharedMailbox = new ListView();
			            pListViewSharedMailbox.SetID("pListViewSharedMailbox");
			            pListViewSharedMailbox.SetSelectFlag(false);
			            pListViewSharedMailbox.SetMulSelectable(true);
			            pListViewSharedMailbox.SetUseCheckBox(useOrgListCheckBox);
			            pListViewSharedMailbox.SetRowOnDblClick("ListViewNodeDblClick");
			            pListViewSharedMailbox.DataSource(loadXMLString(document.getElementById("listviewheader5").innerHTML.toUpperCase()));
			            pListViewSharedMailbox.DataBind("ListViewSharedMailbox");
			            pListViewSharedMailbox.DataSource(loadXMLString(xmlHTTP.responseText));
			            pListViewSharedMailbox.RowDataBind();
			
			            var dataRows = pListViewSharedMailbox.GetDataRows();
			            var dataRowCount = pListViewSharedMailbox.GetRowCount();
			            
			            for (var i = 0; i < dataRowCount; i++) {
			                dataRows[i].draggable = true;
			                if (CrossYN())
			                    dataRows[i].ondragstart = function (event) { event_listdragstart(this); event.dataTransfer.setData('text/plain', 'dragged'); };
			                else
			                    dataRows[i].ondragstart = function (event) { event_listdragstart(this); };

							// 2024-07-05 김대현 #140902 사파리만 event_listdragend 넣어 중복으로 InsertReceiver()를 실행하여 생기는 현상으로 지워도 동작하기 때문에 해당 함수 주석처리 
			                // if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
			                //     dataRows[i].ondragend = function (event) { event_listdragend(event); };
			                // }
			            }
			            
			            changeCheckBox();
		            }
		            
		            xmlHTTP = null;
		        } catch (e) {
		            alert("<spring:message code='ezEmail.sharedMailbox07' />" + e.description);
		            xmlHTTP = null;
		            return;
		        }
	        }
	        var g_binputLoaded = false;
	        function inputTabButton_onClick() {
	        	methodForTabAction(4);
	            gubunpage = "direct";
	            selSpan = "inputSpan";
	            if (g_binputLoaded == false) {
	                g_binputLoaded = true;
	            }
	            m_tabDialogState["org"] = "normal";
	            m_tabDialogState["contact"] = "normal";
	            m_tabDialogState["dl"] = "normal";
	            m_tabDialogState["sharedMailbox"] = "normal";
	            m_tabDialogState["input"] = "select";
	            TreeViewTD.style.display = "none";
	            ListViewTD.style.display = "none";
	            ListViewDLTD.style.display = "none";
	            ListViewSharedMailboxTD.style.display = "none";
	            ListViewINPUT.style.display = "";
	            dlmember.style.display = "none";
	            sharedMailboxMember.style.display = "none";
	            AddrSearch.style.display = "none";
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
	                }
	                else {
	                    xmlRtn.selectNodes("NODES/NODE")[0].appendChild(xmlRtn.selectNodes("NODES/NODE/VALUE")[0]);
	                }
	            }
	            var treeView = new TreeView();
	            treeView.LoadFromID("FromTreeView");
                treeView.SetUseCheckBox(useOrgListCheckBox);
	            treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
	        }
	        function confirm_onClick() {
	            if (type == "config") {
	                confirm_onClick_config();
	                return;
	            }
	            else if (type == "rule") {
	                confirm_onClick_rule();
	                return;
	            }
	            else if (type == "auto") {
	                confirm_onClick_auto();
	                return;
	            }
	
	            if (ReturnFunction != null)
	                ReturnFunction(ListViewMsgTo, ListViewMsgCC, ListViewMsgBCC);
	            else {
	                g_fnaddReceiver(ListViewMsgTo, ListViewMsgCC, ListViewMsgBCC);
	            }
	            window.close();
	        }
	        function confirm_onClick_auto() {
	            if (selTab == "orglistView" || selTab.indexOf("orgJobMstListView") > -1) { // 조직도, 조직도(직위, 직책)
	                if (listContentArry != "") {
	                    var strEmail = document.getElementById(listContentArry[0]).getAttribute("_data3");
	                }
	                else {
	                    alert(strLangPYY01);
	                    return;
	                }
	            }
	            else if (selTab == "AddressListView") {
	                var pListViewDL = new ListView();
	                pListViewDL.LoadFromID("Address");
	                var arrRows = pListViewDL.GetSelectedRows();
	                if (arrRows.length > 0) {
	                    var strEmail = GetAttribute(arrRows[0], "DATA3");
	                    if (GetAttribute(arrRows[0], "DATA2") == "mailgroup") {
	                        alert("<spring:message code='ezEmail.t99000076' />");
	                        return;
	                    }
	                }
	                else {
	                    alert(strLangPYY01);
	                    return;
	                }
	            } else if (selTab == "DistributionList") {
	            	var pListViewDL = new ListView();
	                pListViewDL.LoadFromID("pListViewDL");
	                var arrRows = pListViewDL.GetSelectedRows();
	                if (arrRows.length > 0) {
	                    var strEmail = GetAttribute(arrRows[0], "DATA2");
	                }
	                else {
	                    alert(strLangPYY01);
	                    return;
	                }
	            } else if (selTab == "sharedMailboxList") {
	            	var pListViewSharedMailbox = new ListView();
	            	pListViewSharedMailbox.LoadFromID("pListViewSharedMailbox");
	                var arrRows = pListViewSharedMailbox.GetSelectedRows();
	                if (arrRows.length > 0) {
	                    var strEmail = GetAttribute(arrRows[0], "DATA2");
	                }
	                else {
	                    alert(strLangPYY01);
	                    return;
	                }
	            }
	            
	            if (ReturnFunction != null)
	                ReturnFunction(strEmail);
	            
	            window.close();
	        }

	        function confirm_onClick_rule() {
	            var list = new ListView();
	            list.LoadFromID("MsgToList");
	            var listconfirm = GetListViewXMLDATA("MsgToList");
	            if (ReturnFunction != null)
	                ReturnFunction(listconfirm);
	            else
	                g_fnaddReceiver(listconfirm);
	
	            window.close();
	        }
	        function GetListViewXMLDATA(pListView) {
	            var returnData = "";
	            var objListView = new ListView();
	            objListView.LoadFromID(pListView);
	            var arrRows = objListView.GetDataRows();
	            returnData = "<DATA>";
	            for (var i = 0; i < arrRows.length; i++) {
	                var strName = arrRows[i].getAttribute("DATA1");
	                var strEmail = arrRows[i].getAttribute("DATA2");
	                returnData += "<ROW><NAME><![CDATA[111111" + strName + "]]></NAME><EMAIL><![CDATA[" + strEmail + "]]></EMAIL></ROW>";
	            }
	            returnData += "</DATA>";
	            return returnData;
	        }
	        function confirm_onClick_config() {
	            var xmlHTTP = createXMLHttpRequest();
	            
	            var aa = document.getElementById("ListViewMsgTo").children.item(0).childNodes.length;
	            var bb = 0;
	            var saveLength = 0;
	            
	            var strXML = "<DATA>";
	            strXML += "<OWNERID><![CDATA[" + MakeXMLString(userid) + "]]></OWNERID>";
	            strXML += "<ADDRLIST>";
	            
	            for (var z = 1; z < aa; z++) {
	                saveLength = saveLength + document.getElementById("ListViewMsgTo").children.item(0).children.item(z).childNodes.length;
	                
	                if (saveLength > 100) {
	                    alert(strLang194);
	                    saveLength = 100;
	                    return;
	                }
	                
	                for (var i = 0; i < saveLength; i++) {
	                	strXML += "<ROW>";
	                	strXML += "<NAME><![CDATA[" + document.getElementById("ListViewMsgTo").children.item(0).children.item(z).children.item(i).getAttribute("data1") + "]]></NAME>";
	                	strXML += "<MAIL><![CDATA[" + document.getElementById("ListViewMsgTo").children.item(0).children.item(z).children.item(i).getAttribute("data2") + "]]></MAIL>";
	                	strXML += "</ROW>";
	                }
	            }
	            
	            strXML += "</ADDRLIST>";
	            strXML += "</DATA>";
	            
	            xmlHTTP.open("POST", "/ezEmail/mailSetAddress.do", false);
	            xmlHTTP.send(strXML);
	            if (xmlHTTP.status != 200) {
	                alert(strLang195);
	            }
	            else {
	                if (ReturnFunction != null)
	                    ReturnFunction();
	                
	                window.close();
	            }
	        }
	        function getOrganinfo() {
	            var xmlhttp = createXMLHttpRequest();
	            xmlhttp.open("Post", "/ezEmail/mailGetAddress.do", false);
	            xmlhttp.send("");
	
	            return loadXMLString(xmlhttp.responseText);
	        }
	        function InsertDeptReceiver() {
	            if (m_selectedWindow != null) {
	                if (TreeView.selectedNode) {
	                    var row = m_selectedWindow.rows.add();
	
	                    row.cells[0].innerText = TreeView.selectedNode.Value;
	                    row.cells[1].innerText = TreeView.selectedNode.DATA4;
	
	                    row.cells[0].name = TreeView.selectedNode.Value;
	                    row.cells[0].email = TreeView.selectedNode.DATA4;
	                    row.cells[0].type = "email";
	                    row.cells[0].href = "";
	
	                    row.cells[0].parentElement.style.backgroundColor = m_titleSelectedColor;
	                }
	            }
	        }
	        
	        function InsertReceiver(pListView) {
	            try {
	                if (inputTabButton.children[0].getAttribute("class") == "tabon") {
	                    inputAddress();
	                    return;
	                }
	            } catch (e) {console.log(e);}
				var al_Include = 0;
	            
	            if (m_selectedTree == AddressListView) {
	                var pListViewDL = new ListView();
	                pListViewDL.LoadFromID("Address");
	                var arrRows = pListViewDL.GetSelectedRows();
	                var _tdlength = 0;
	                if (arrRows.length > 0) {
	                    var pparsingXML = "";
	                    var pparsingXML2 = "";
	                    for (var i = 0; i < arrRows.length; i++) {
	                        var pAddressID = GetAttribute(arrRows[i], "DATA1");
	                        var pAddressType = GetAttribute(arrRows[i], "DATA2");
	                        var pAddressFolderType = GetAttribute(arrRows[i], "DATA4");
	                        var strNameIndex = useOrgListCheckBox?1:0;
	                        var strName = arrRows[i].cells[strNameIndex].innerText;
	                        var strEmail = GetAttribute(arrRows[i], "DATA3");
	                        pAddressID = pAddressID + "|!|" + pAddressFolderType;
	                        if (strEmail.trim() == "") {
	                            alert(strName + " " + strLang301)
	                            continue;
	                        }
	                        if (strName.trim() == "")
	                            strName = strEmail;
	
	                        if (strEmail.trim() == "mail") {
	                            continue;
	                        }
	                        var listid = "";
	                        if (pListView.id == "ListViewMsgTo" || pListView == "MsgToList") {
	                            listid = "MsgToList";
	                        }
	                        else if (pListView.id == "ListViewMsgCC" || pListView == "MsgCCList") {
	                            listid = "MsgCCList";
	                        }
	                        else if (pListView.id == "ListViewMsgBCC" || pListView == "MsgBCCList") {
	                            listid = "MsgBCCList";
	                        }
	                        var targetList = new ListView();
	                        targetList.LoadFromID(listid);
	                        var IsInsert;
	                        if (pAddressType == "mailgroup") {
	                            if (type == "config") {
	                                alert(strLang322);
	                                return;
	                            }
	                            else
	                                IsInsert = CheckMailReceiver(pAddressID, "3");
	                        }
	                        else
	                            IsInsert = CheckMailReceiver(strEmail, "3");
	
	                        if (!IsInsert) {
	                        	if (type == "") {
	                        		if (!increaseReceiverCount(pAddressType, pAddressID)) {
						        		return;
						        	}
	                        	}
                                var strNameXml = MakeXMLString(strName);
                                var maxNameLength = maxTotalLength - strEmail.length;

                                if (maxNameLength > 0) {
                                    strNameXml = strNameXml.substring(0, maxNameLength);
                                }
	                        	
	                            pparsingXML2 = "";
	                            pparsingXML = "";
	                            pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	                            pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strName) + "</DATA1>";
	                            if (pAddressType == "mailgroup")
	                                pparsingXML = pparsingXML + "<DATA2>" + pAddressType + "</DATA2>";
	                            else
	                                pparsingXML = pparsingXML + "<DATA2>" + strEmail + "</DATA2>";
	                            pparsingXML = pparsingXML + "<DATA3><![CDATA[" + MakeXMLString(strEmail) + "]]></DATA3>";
	                            pparsingXML = pparsingXML + "<DATA4><![CDATA[" + MakeXMLString(pAddressID) + "]]></DATA4>";
	                            pparsingXML = pparsingXML + "<DATA-TYPE>add</DATA-TYPE>";
	                            pparsingXML = pparsingXML + "<VALUE>" + strNameXml + " &lt;" + strEmail + "&gt;" + "</VALUE></CELL></ROW>";
	                            pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
	                            Resultxml = loadXMLString(pparsingXML2);
	
	                            var listview = new ListView();
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
	                            SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxCntNum).substring(0, listview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + (MaxID + 1));
	                            listview.AddDataRow(objTr, Resultxml);
	
	                            document.getElementById(listid).className = "receiver_list";
	                            _tdlength = document.getElementById(listid).getElementsByTagName("TD").length;
	                            for (var y = 0; y < _tdlength; y++) {
	                                document.getElementById(listid).getElementsByTagName("TD")[y].style.textOverflow = "";
	                                document.getElementById(listid).getElementsByTagName("TD")[y].style.overflow = "";
	                            }

			                    InsertReceiver_CheckBox(listid, arrRows[i]);
	                        } else {
	                        	al_Include++;
	                        }
	                    }
	                }
	                
		            for (var i = 0; i < arrRows.length; i++) {
		            	for (var j = 0; j < 3; j++) {
		            		arrRows[i].style.backgroundColor = m_strColorDefault;
		            		arrRows[i].setAttribute("selected", "false");
		            	}
		            }
		            
	            }
	            else if (m_selectedTree == ListViewDL) {
	                var pListViewDL = new ListView();
	                var _tdlength = 0;
	                pListViewDL.LoadFromID("pListViewDL");
	                var arrRows = pListViewDL.GetSelectedRows();
	                if (arrRows.length > 0) {
	                    var pparsingXML = "";
	                    var pparsingXML2 = "";
	                    for (var i = 0; i < arrRows.length; i++) {
	
	                        var strName = arrRows[i].innerText;
	                        var strEmail = GetAttribute(arrRows[i], "DATA2");
	                        if (strEmail.trim() == "")
	                            return;
	
	                        if (strName.trim() == "")
	                            strName = strEmail;
	                        var listid = "";
	
	                        if (pListView.id == "ListViewMsgTo" || pListView == "MsgToList") {
	                            listid = "MsgToList";
	                        }
	                        else if (pListView.id == "ListViewMsgCC" || pListView == "MsgCCList") {
	                            listid = "MsgCCList";
	                        }
	                        else if (pListView.id == "ListViewMsgBCC" || pListView == "MsgBCCList") {
	                            listid = "MsgBCCList";
	                        }
	
	                        var targetList = new ListView();
	                        targetList.LoadFromID(listid);
	                        var IsInsert = CheckMailReceiver(strEmail, "3");
	
	                        if (!IsInsert) {
	                        	if (type == "") {
	                        		if (!increaseReceiverCount()) {
						        		return;
						        	}
	                        	}

                                var strNameXml = MakeXMLString(strName);
                                var maxNameLength = maxTotalLength - strEmail.length;
        
                                if (maxNameLength > 0) {
                                    strNameXml = strNameXml.substring(0, maxNameLength);
                                }
	                        	
	                            pparsingXML2 = "";
	                            pparsingXML = "";
	                            pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	                            pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strName) + "</DATA1>";
	                            pparsingXML = pparsingXML + "<DATA2>" + strEmail + "</DATA2>";
	                            pparsingXML = pparsingXML + "<DATA3><![CDATA[" + MakeXMLString(strDeptNM) + "]]></DATA3>";
	                            pparsingXML = pparsingXML + "<DATA-TYPE>dist</DATA-TYPE>";
	                            pparsingXML = pparsingXML + "<VALUE>" + strNameXml + " &lt;" + strEmail + "&gt;" + "</VALUE></CELL></ROW>";
	                            pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
	                            Resultxml = loadXMLString(pparsingXML2);
	
	                            var listview = new ListView();
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
	                            SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxCntNum).substring(0, listview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + (MaxID + 1));
	                            listview.AddDataRow(objTr, Resultxml);
	
	                            document.getElementById(listid).className = "receiver_list";
	                            _tdlength = document.getElementById(listid).getElementsByTagName("TD").length;
	                            for (var y = 0; y < _tdlength; y++) {
	                                document.getElementById(listid).getElementsByTagName("TD")[y].style.textOverflow = "";
	                                document.getElementById(listid).getElementsByTagName("TD")[y].style.overflow = "";
	                            }
	                            
			                    InsertReceiver_CheckBox(listid, arrRows[i]);
	                        } else {
	                        	al_Include++;
	                        }
	                    }
	                }
	                
		            for (var i = 0; i < arrRows.length; i++) {
	            		arrRows[i].style.backgroundColor = m_strColorDefault;
	            		arrRows[i].setAttribute("selected", "false");
		            }
	                
	            }
	            else if (m_selectedTree == ListViewSharedMailbox) {
	                var pListViewSharedMailbox = new ListView();
	                var _tdlength = 0;
	                pListViewSharedMailbox.LoadFromID("pListViewSharedMailbox");
	                var arrRows = pListViewSharedMailbox.GetSelectedRows();
	                if (arrRows.length > 0) {
	                    var pparsingXML = "";
	                    var pparsingXML2 = "";
	                    for (var i = 0; i < arrRows.length; i++) {
	
	                        var strName = arrRows[i].innerText;
	                        var strEmail = GetAttribute(arrRows[i], "DATA2");
	                        if (strEmail.trim() == "")
	                            return;
	
	                        if (strName.trim() == "")
	                            strName = strEmail;
	                        var listid = "";
	
	                        if (pListView.id == "ListViewMsgTo" || pListView == "MsgToList") {
	                            listid = "MsgToList";
	                        }
	                        else if (pListView.id == "ListViewMsgCC" || pListView == "MsgCCList") {
	                            listid = "MsgCCList";
	                        }
	                        else if (pListView.id == "ListViewMsgBCC" || pListView == "MsgBCCList") {
	                            listid = "MsgBCCList";
	                        }
	
	                        var targetList = new ListView();
	                        targetList.LoadFromID(listid);
	                        var IsInsert = CheckMailReceiver(strEmail, "3");
	
	                        if (!IsInsert) {
	                        	if (type == "") {
	                        		if (!increaseReceiverCount()) {
						        		return;
						        	}
	                        	}

                                var strNameXml = MakeXMLString(strName);
                                var maxNameLength = maxTotalLength - strEmail.length;
        
                                if (maxNameLength > 0) {
                                    strNameXml = strNameXml.substring(0, maxNameLength);
                                }
	                        	
	                            pparsingXML2 = "";
	                            pparsingXML = "";
	                            pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	                            pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strName) + "</DATA1>";
	                            pparsingXML = pparsingXML + "<DATA2>" + strEmail + "</DATA2>";
	                            pparsingXML = pparsingXML + "<DATA3><![CDATA[" + MakeXMLString(strDeptNM) + "]]></DATA3>";
	                            pparsingXML = pparsingXML + "<DATA-TYPE>shared</DATA-TYPE>";
	                            pparsingXML = pparsingXML + "<VALUE>" + strNameXml + " &lt;" + strEmail + "&gt;" + "</VALUE></CELL></ROW>";
	                            pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
	                            Resultxml = loadXMLString(pparsingXML2);
	
	                            var listview = new ListView();
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
	                            SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxCntNum).substring(0, listview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + (MaxID + 1));
	                            listview.AddDataRow(objTr, Resultxml);
	
	                            document.getElementById(listid).className = "receiver_list";
	                            _tdlength = document.getElementById(listid).getElementsByTagName("TD").length;
	                            for (var y = 0; y < _tdlength; y++) {
	                                document.getElementById(listid).getElementsByTagName("TD")[y].style.textOverflow = "";
	                                document.getElementById(listid).getElementsByTagName("TD")[y].style.overflow = "";
	                            }
	                            
	                            InsertReceiver_CheckBox(listid, arrRows[i]);
	                        } else {
	                        	al_Include++;
	                        }
	                    }
	                }
	                
		            for (var i = 0; i < arrRows.length; i++) {
	            		arrRows[i].style.backgroundColor = m_strColorDefault;
	            		arrRows[i].setAttribute("selected", "false");
		            }
	                
	            }
	            else if (m_selectedTree == orglistView) {
	                var pparsingXML = "";
	                var pparsingXML2 = "";
	                var pAddFlag = false;
	                var _tdlength = 0;
	                if (p_ListOrderObject == null || p_ListOrderObject == "") {
	                    var organTree = new TreeView();
	                    organTree.LoadFromID("FromTreeView");
	                    var nodeIdx = organTree.GetSelectNode();
	                    var listid = "";
	                    var strSIP = "";
	                    if (pListView.id == "ListViewMsgTo") {
	                        listid = "MsgToList";
	                    }
	                    else if (pListView.id == "ListViewMsgCC") {
	                        listid = "MsgCCList";
	                    }
	                    else if (pListView.id == "ListViewMsgBCC") {
	                        listid = "MsgBCCList";
	                    }
	
	                    var listview = new ListView();
	                    listview.LoadFromID(listid);
	
	                    var strDeptNM = nodeIdx.NodeName;
	                    var strEmail = nodeIdx.GetNodeData("MAIL");
	
	                    var pparsingXML = "";
	
	                    var getlistview = new ListView();
	                    getlistview.LoadFromID(listid);
	                    var IsInsert = CheckMailReceiver(strEmail, "3");
	
	                    if (!IsInsert) {
	                    	if (type == "") {
	                    		if (!increaseReceiverCount()) {
					        		return;
					        	}
	                    	}
	                    	
	                        pparsingXML = "";
	                        pparsingXML = "<LISTVIEWDATA2><ROWS>";
	                        pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strDeptNM) + "</DATA1>";
	                        pparsingXML = pparsingXML + "<DATA2>" + strEmail + "</DATA2>";
	                        pparsingXML = pparsingXML + "<DATA3><![CDATA[" + MakeXMLString(strDeptNM) + "]]></DATA3>";
	                        pparsingXML = pparsingXML + "<DATA4>" + strSIP + "</DATA4>";
                            pparsingXML = pparsingXML + "<DATA-TYPE>org</DATA-TYPE>";
	                        pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(strDeptNM) + " &lt;" + strEmail + "&gt;" + "</VALUE></CELL></ROW>";
	                        pparsingXML = pparsingXML + "</ROWS></LISTVIEWDATA2>";
	
	                        Resultxml = loadXMLString(pparsingXML);
	
	                        var listview = new ListView();
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
	                        SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxCntNum).substring(0, listview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + (MaxID + 1));
	                        listview.AddDataRow(objTr, Resultxml);
	
	                        document.getElementById(listid).className = "receiver_list";
	                        _tdlength = document.getElementById(listid).getElementsByTagName("TD").length;
	                        for (var y = 0; y < _tdlength; y++) {
	                            document.getElementById(listid).getElementsByTagName("TD")[y].style.textOverflow = "";
	                            document.getElementById(listid).getElementsByTagName("TD")[y].style.overflow = "";
	                        }
	                        
	                        var currentContent = document.getElementById(nodeIdx.NodeID);
	                        InsertReceiver_CheckBox(listid, currentContent);
	                    } else {
                        	al_Include++;
                        }
	                }
	                else {
	                    if (listContentArry != "") {
                            var listid = "";

                            if (pListView.id == "ListViewMsgTo" || pListView == "MsgToList") {
                                listid = "MsgToList";
                            }
                            else if (pListView.id == "ListViewMsgCC" || pListView == "MsgCCList") {
                                listid = "MsgCCList";
                            }
                            else if (pListView.id == "ListViewMsgBCC" || pListView == "MsgBCCList") {
                                listid = "MsgBCCList";
                            }
                            var getlistview = new ListView();
                            getlistview.LoadFromID(listid);
                            
                            var listview = new ListView();
                            listview.LoadFromID(listid);
                            
                            var MaxID = 0;
                            var MaxCntNum = 0;
                            var InitTr = listview.GetDataRows();
                            var trSize = InitTr.length;
                            for (var j = 0  ; j < trSize; j++) {
                                var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
                                if (MaxID < curnum) {
                                    MaxID = curnum;
                                    MaxCntNum = j;
                                }
                            }
                            
                            if (MaxCntNum != 0)
                                MaxCntNum = MaxCntNum + 1;
                            
	                        for (var i = 0; i < listContentArry.length; i++) {
	                        	var currentContent = document.getElementById(listContentArry[i]);
	                            var strName = currentContent.getAttribute("_data4");
	                            var strDeptNM = currentContent.getAttribute("_data5");
	                            var strEmail = currentContent.getAttribute("_data3");
	
	                            var IsInsert = CheckMailReceiver(strEmail, "3");
	
	                            if (!IsInsert) {
	                            	if (type == "") {
	                            		if (!increaseReceiverCount()) {
							        		return;
							        	}
	                            	}
	                            	
	                            	var strNameXml = MakeXMLString(strName);
                                    var maxNameLength = maxTotalLength - strEmail.length;
            
                                    if (maxNameLength > 0) {
                                        strNameXml = strNameXml.substring(0, maxNameLength);
                                    }
	                            	
	                                pparsingXML2 = "";
	                                pparsingXML = "";
	                                pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	                                pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strName) + "</DATA1>";
	                                pparsingXML = pparsingXML + "<DATA2>" + strEmail + "</DATA2>";
	                                pparsingXML = pparsingXML + "<DATA3><![CDATA[" + MakeXMLString(strDeptNM) + "]]></DATA3>";
	                                pparsingXML = pparsingXML + "<DATA4>" + strSIP + "</DATA4>";
	                                pparsingXML = pparsingXML + "<DATA-TYPE>org</DATA-TYPE>";
	                                pparsingXML = pparsingXML + "<VALUE>" + strNameXml + " &lt;" + strEmail + "&gt;" + "</VALUE></CELL></ROW>";
	                                pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
	                                Resultxml = loadXMLString(pparsingXML2);
	
	                                var objTr = listview.AddRow(trSize);
	                                SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxCntNum).substring(0, listview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + (MaxID + 1));
	                                listview.AddDataRow(objTr, Resultxml);
	
	                                document.getElementById(listid).className = "receiver_list";
	                                _tdlength = document.getElementById(listid).getElementsByTagName("TD").length;
	                                for (var y = 0; y < _tdlength; y++) {
	                                    document.getElementById(listid).getElementsByTagName("TD")[y].style.textOverflow = "";
	                                    document.getElementById(listid).getElementsByTagName("TD")[y].style.overflow = "";
	                                }
	                                
	                                MaxID++;
	                                MaxCntNum++;
	                                trSize++

	                                InsertReceiver_CheckBox(listid, currentContent);
	                            } else {
		                        	al_Include++;
		                        }
	                        }
	
	                    }
	                    else {
	                        var strName = p_ListOrderObject.getAttribute("_data4");
	                        var strDeptNM = p_ListOrderObject.getAttribute("_data5");
	                        var strEmail = p_ListOrderObject.getAttribute("_data3");
	
	
	                        var listid = "";
	
	                        if (pListView.id == "ListViewMsgTo" || pListView == "MsgToList") {
	                            listid = "MsgToList";
	                        }
	                        else if (pListView.id == "ListViewMsgCC" || pListView == "MsgCCList") {
	                            listid = "MsgCCList";
	                        }
	                        else if (pListView.id == "ListViewMsgBCC" || pListView == "MsgBCCList") {
	                            listid = "MsgBCCList";
	                        }
	                        
	                        var getlistview = new ListView();
                            getlistview.LoadFromID(listid);
                            var IsInsert = CheckMailReceiver(strEmail, "3");
	
	                        if (!IsInsert) {
	                        	if (type == "") {
	                        		if (!increaseReceiverCount()) {
						        		return;
						        	}
	                        	}
	                        	
	                        	var strNameXml = MakeXMLString(strName);
                                var maxNameLength = maxTotalLength - strEmail.length;
        
                                if (maxNameLength > 0) {
                                    strNameXml = strNameXml.substring(0, maxNameLength);
                                }
	                        	
	                            pparsingXML2 = "";
	                            pparsingXML = "";
	                            pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	                            pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strName) + "</DATA1>";
	                            pparsingXML = pparsingXML + "<DATA2>" + strEmail + "</DATA2>";
	                            pparsingXML = pparsingXML + "<DATA3><![CDATA[" + MakeXMLString(strDeptNM) + "]]></DATA3>";
	                            pparsingXML = pparsingXML + "<DATA4>" + strSIP + "</DATA4>";
	                            pparsingXML = pparsingXML + "<DATA-TYPE>org</DATA-TYPE>";
	                            pparsingXML = pparsingXML + "<VALUE>" + strNameXml + " &lt;" + strEmail + "&gt;" + "</VALUE></CELL></ROW>";
	                            pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
	                            Resultxml = loadXMLString(pparsingXML2);
	
	                            var listview = new ListView();
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
	                            SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxCntNum).substring(0, listview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + (MaxID + 1));
	                            listview.AddDataRow(objTr, Resultxml);
	
	                            document.getElementById(listid).className = "receiver_list";
	                            _tdlength = document.getElementById(listid).getElementsByTagName("TD").length;
	                            for (var y = 0; y < _tdlength; y++) {
	                                document.getElementById(listid).getElementsByTagName("TD")[y].style.textOverflow = "";
	                                document.getElementById(listid).getElementsByTagName("TD")[y].style.overflow = "";
	                            }
	                            
	                            InsertReceiver_CheckBox(listid, p_ListOrderObject);
	                        } else {
	                        	al_Include++;
	                        }
	                    }
	
	                }
	
	            }
	            
	            var _td = document.getElementById("txtlist_table").childNodes[1].childNodes[0].childNodes;
	            _tdlength = document.getElementById("txtlist_table").childNodes[1].childNodes[0].children.length;
	            
	            for (var i = 0; i < listContentArry.length; i++) {
					Array.prototype.slice.call(document.getElementById(listContentArry[i]).querySelectorAll("td")).forEach(function(it) {
						it.style.backgroundColor = m_strColorDefault;
					});
	            }
	            listContentArry = [];
	            
	            if (al_Include > 0) {
	            	alert("<spring:message code='ezOrgan.ksaOrganList03' />");
	            }
	            
	            var listid = "";
	            if (pListView.id == "ListViewMsgTo" || pListView == "MsgToList") {
	                listid = "MsgToList";
	            }
	            else if (pListView.id == "ListViewMsgCC" || pListView == "MsgCCList") {
	                listid = "MsgCCList";
	            }
	            else if (pListView.id == "ListViewMsgBCC" || pListView == "MsgBCCList") {
	                listid = "MsgBCCList";
	            }
	        }
	        
	        function checkTest(chkEmail, listClass) {
				if (useOrgListCheckBox) {
	            	var test = $("." + listClass + " tr[_data3='"+chkEmail+"']");
	            	console.log(test);
	            }
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
	                if (email == arrRows[count2].getAttribute("data2") && arrRows[count2].getAttribute("data2") != "mailgroup")
	                    return true;
	                else if (arrRows[count2].getAttribute("data2") == "mailgroup") {
	                    if (email.split("|!|")[0] == arrRows[count2].getAttribute("data4").split("|!|")[0])
	                        return true;
	                }
	            }
	            _listview.LoadFromID("MsgCCList");
	            var arrRows = _listview.GetDataRows();
	
	            for (count2 = 0; count2 < arrRows.length; count2++) {
	                if (email == arrRows[count2].getAttribute("data2") && arrRows[count2].getAttribute("data2") != "mailgroup")
	                    return true;
	                else if (arrRows[count2].getAttribute("data2") == "mailgroup") {
	                    if (email.split("|!|")[0] == arrRows[count2].getAttribute("data4").split("|!|")[0])
	                        return true;
	                }
	            }
	            _listview.LoadFromID("MsgBCCList");
	            var arrRows = _listview.GetDataRows();
	
	            for (count2 = 0; count2 < arrRows.length; count2++) {
	                if (email == arrRows[count2].getAttribute("data2") && arrRows[count2].getAttribute("data2") != "mailgroup")
	                    return true;
	                else if (arrRows[count2].getAttribute("data2") == "mailgroup") {
	                    if (email.split("|!|")[0] == arrRows[count2].getAttribute("data4").split("|!|")[0])
	                        return true;
	                }
	            }
	            return rtnValue;
	        }
	
	        function DeleteReceiver(pListView) {
	            var listid = "";
	            var listid = "";
	            if (pListView.id == "ListViewMsgTo") {
	                listid = "MsgToList";
	            }
	            else if (pListView.id == "ListViewMsgCC") {
	                listid = "MsgCCList";
	            }
	            else if (pListView.id == "ListViewMsgBCC") {
	                listid = "MsgBCCList";
	            }
	            var selList = new ListView();
	            selList.LoadFromID(listid);
	            var arrRows = selList.GetSelectedRows();
	            var strName = "";
	            for (var i = 0; i < arrRows.length; i++) {
	            	if (type == "") {
	            		decreaseReceiverCount(arrRows[i].getAttribute("data2"), arrRows[i].getAttribute("data4"));
	            	}
	                
	                selList.DeleteRow(arrRows[i].id);
	                
	                DeleteReceiver_CheckBox(listid, arrRows[i]);
	            }
	        }
	        
	        function SelectReceiverWindow(Title, selectedWindow) {
	            for (var count = 0; count < m_receiverTitleList.length; count++) {
	                m_receiverTitleList[count].style.fontWeight = "normal";
	                m_receiverWindowList[count].style.backgroundColor = m_titleNoneSelectedColor;
	                m_receiverWindowList[count].normalColor = m_titleNoneSelectedColor;
	                m_receiverTitleList[count].setAttribute("class", "receiver_tltype02");
	            }
	            Title.style.fontWeight = "bold";
	            Title.setAttribute("class", "receiver_tltype01");
	            if (type == "")
	                selectedWindow.style.backgroundColor = m_titleSelectedColor;
	            else
	                selectedWindow.style.backgroundColor = "white";
	
	            selectedWindow.normalColor = m_titleSelectedColor;
	            
	            if (m_selectedWindow != selectedWindow) {
	            	m_selectedWindow = selectedWindow;
	            	receiverListId = m_selectedWindow.getElementsByTagName("table")[0].id;
	            	
	            	changeCheckBox();
	            }
	        }
	        
	        var rgParams = new Array();
	        var checkname2_cross_dialogArguments = new Array();
	        function deptsearch_click() {
	
	            if (keyword.value == "") {
	                alert("<spring:message code='ezEmail.t61' />");
	                keyword.focus();
	                return;
	            }
	            
	            var xmlDom = createXmlDom();
	            
	            $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/ezOrgan/getSearchList.do",
		        	async : false,
		        	data : {search : "displayname::" + keyword.value, 
		        	    cell : "extensionAttribute3;displayName;extensionAttribute9", 
		        	    prop : "", 		        	    
		        	    <c:if test="${useShowAllCompanies eq 'YES'}">
		        	    company : "", 
		        	    </c:if>		        	    
		        	    type : "group"},
		        	success : function(result){	
		        		xmlDom = loadXMLString(result);
		                adCount = xmlDom.getElementsByTagName("ROW").length;
		        	},
		        	error : function(error){
		        		alert("<spring:message code='ezEmail.t11' />" + error);
		        		xmlDom = null;
		        	}
		        });
	            
	            if (adCount == 0) {
	                alert("<spring:message code='ezEmail.t12' />");
	                return;
	            }
	            else if (adCount == 1) {
	                bSearch = true;
	                g_xmlHTTP = createXMLHttpRequest();
	
	                var strQuery;
	                
	                if (CrossYN()) {
		                <c:choose>
		                <c:when test="${useShowAllCompanies eq 'YES'}">
		                strQuery = "<DATA><DEPTID>" + xmlDom.getElementsByTagName("DATA2").item(0).textContent + "</DEPTID><TOPID>Top/organ</TOPID><PROP>mail</PROP></DATA>";
		                </c:when>
		                <c:otherwise>
		                strQuery = "<DATA><DEPTID>" + xmlDom.getElementsByTagName("DATA2").item(0).textContent + "</DEPTID><TOPID>Top</TOPID><PROP>mail</PROP></DATA>";
		                </c:otherwise>
		                </c:choose>	                    	                    
	                } else {
	                    strQuery = "<DATA><DEPTID>" + xmlDom.getElementsByTagName("DATA2").item(0).text + "</DEPTID><TOPID>Top</TOPID><PROP>mail</PROP></DATA>";
	                }
	
	                g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
	                g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
	                g_xmlHTTP.send(strQuery);
	            }
	            else {
	                rgParams["addrBook"] = xmlDom;
	                rgParams["deptid"] = "";
	                
	                checkname2_cross_dialogArguments[0] = rgParams;
	                checkname2_cross_dialogArguments[1] = deptsearch_click_Complete;		                
	                var OpenWin = window.open("/admin/ezOrgan/checkName2.do", "checkName2_Cross", GetOpenWindowfeature(598, 340));
	                try { OpenWin.focus(); } catch (e) { }
	            }
	        }
	        
	        function deptsearch_click_Complete() {
		        if (rgParams["deptid"] != "") {
		            bSearch = true;
		            g_xmlHTTP = createXMLHttpRequest();
		            
	                <c:choose>
	                <c:when test="${useShowAllCompanies eq 'YES'}">
	                var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>Top/organ</TOPID><PROP>mail</PROP></DATA>";
	                </c:when>
	                <c:otherwise>
	                var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>Top</TOPID><PROP>mail</PROP></DATA>";
	                </c:otherwise>
	                </c:choose>
		            
		            g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		            g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
		            g_xmlHTTP.send(strQuery);
		        }
		    }
	        
	        var nodeIdx;
	        function TreeViewNodeClick() {
	            issearch = false;
	            CurPage = "1";
	            listContentArry = new Array();
	            p_ListOrderObject = "";
	            var treeView = new TreeView();
	            treeView.LoadFromID("FromTreeView");
	            treeView.SetUseCheckBox(useOrgListCheckBox);
	            var nodeIdx = treeView.GetSelectNode();
	            document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"padding-right:3px; \" >"
	            	+ "<span id='spn_deptName' title='" + nodeIdx.GetNodeData("VALUE") + "'>" + nodeIdx.GetNodeData("VALUE") + "</span>"
	            	+ "<span id='countInfo'></span>";
	            SelectDeptNM.setAttribute("countinfo", "")
	            displayUserList(nodeIdx.GetNodeData("CN"));
	        }
	        var tempDeptID = "";
	        function displayUserList(DeptID) {
	            if (DeptID != undefined)
	                tempDeptID = DeptID;
	            listContentArry = new Array();
	            
	            $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/ezOrgan/getDeptMemberList.do",
		        	data : {
		        		deptID : tempDeptID, 
		        		cell : "company;description;displayName;title;telephoneNumber",
			        	prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2;department;userType",
			        	page: CurPage, 
			        	type : "user"},
		        	success : function(result){
		                pListXML_Info = loadXMLString(result);
		        		
		                pSeach = false;
		                DisplayUserImageList();
		                makePageSelPage2();
		        	},
		        	error : function(error){
		        		alert("<spring:message code='ezEmail.t60' />" + error);
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
	        
		    var m_strColorSelect = "#f1f8ff";
		    var m_strColorOver = "#f4f5f5";
		    var m_strColorDefault = "#ffffff";
		    var p_ListOrderObject = null;
		    function event_listMover(obj) {
		        for (var i = 0; i < listContentArry.length; i++) {
		            if (document.getElementById(listContentArry[i]) == obj) {
		                return;
		            }
		        }
		        if (p_ListOrderObject != obj) {
		            for (var RowCnt = 0; RowCnt < obj.childNodes.length; RowCnt++) {
		                obj.childNodes.item(RowCnt).style.backgroundColor = m_strColorOver;
		            }
		        }
		    }
		    function event_listMout(obj) {
		
		        for (var i = 0; i < listContentArry.length; i++) {
		            if (document.getElementById(listContentArry[i]) == obj) {
		                return;
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
		    	if (type == "auto") {
		    		return;
		    	}
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
		    	if (type == "auto") {
		    		return;
		    	}
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            if (!event) event = window.event;
		        }
		        switch (event.keyCode) {
		            case 16: PressShiftKey = true; break;
		            case 17: PressCtrlKey = true; break;
		        }
		    }

		    var listContentArry = new Array();
		    var listSubContentArry = new Array();
		    var listEventCheckbox = false;
		    var listSubEventCheckbox = false;
		    function event_listclick(obj) {
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
		                if (p_ListOrderObject == null)
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
		                if (PrePoint < CurPoint) {
		
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
		                                p_ListOrderObject = "";
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
		        if (m_selectedWindow != null) {
		            var pListView = "";
		            if (m_selectedWindow.id == "ListViewMsgTo") {
		                pListView = "MsgToList";
		            }
		            else if (m_selectedWindow.id == "ListViewMsgCC") {
		                pListView = "MsgCCList";
		            }
		            else if (m_selectedWindow.id == "ListViewMsgBCC") {
		                pListView = "MsgBCCList";
		            }
		            InsertReceiver(pListView);
		        }
		    }
		    
		    var pSeach = false;
		    function DisplayUserImageList() {
		        p_ListOrderObject = "";
		        var xmlRtn = pListXML_Info;
		        document.getElementById("DeptUserImgList").innerHTML = "";
		        document.getElementById("txtlist_Layer").scrollTop = "0";
		        document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes;
		        totalPage2 = Math.ceil(new Number(getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) / 50));
		        
		        var tbody = document.getElementById("txtlist_table").getElementsByTagName("TBODY");
		        
		        while (tbody.item(0).childNodes.length > 1) {
		        	tbody.item(0).removeChild(tbody.item(0).childNodes.item(1));
		        }
		        
		        var searchTbody = document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY");
		        while (searchTbody.item(0).childNodes.length > 1) {
		        	searchTbody.item(0).removeChild(searchTbody.item(0).childNodes.item(1));
		        }
		        
		        var UserListHTML = "";
		        /* if (SelectDeptNM.getAttribute("countinfo") != "1" && getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) != null && getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0])!= "") {
		            if (getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) ==  getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT2")[0])) {
	        			SelectDeptNM.innerHTML += "-[<span class='txt_color'>" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) + strLang300 + "</span>]";
	        		} else {
	        			SelectDeptNM.innerHTML += "-[<span class='txt_color'>" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) + "/" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT2")[0]) + strLang300 + "</span>]";
	        		}
		            
		            SelectDeptNM.setAttribute("countinfo", "1")
		        } */
		        if (pListType == "IMG") {
		            document.getElementById("DeptUserImgList").style.display = "";
		            document.getElementById("txtlist_Layer").style.display = "none";
		            //document.getElementById("tblPageRayer2").style.display = "none";
		            document.getElementById("txtlist_table").style.display = "none";
		            document.getElementById("Search_txtlist_table").style.display = "none";
		            
		            if (typeof pSeach !== "undefined") {
			            if (pSeach) {
			                document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;padding-right:3px;\" >" + strLang_2 + "" + "&nbsp;&nbsp;<span class='txt_color'>" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) + "</span>";
			                SelectDeptNM.setAttribute("countinfo", "1")
			            }
		            }
		        }
		        else {
		            document.getElementById("DeptUserImgList").style.display = "none";
		            document.getElementById("txtlist_Layer").style.display = "";
		            document.getElementById("tblPageRayer2").style.display = "";
		            
		            if (typeof pSeach !== "undefined") {
			            if (!pSeach) {
			                document.getElementById("txtlist_table").style.display = "";
			                document.getElementById("Search_txtlist_table").style.display = "none";
			            }
			            else {
			                document.getElementById("Search_txtlist_table").style.display = "";
			                document.getElementById("txtlist_table").style.display = "none";
			                document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;padding-right:3px;\" >" + strLang_2 + "" + "&nbsp;&nbsp;<span class='txt_color'>" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) + "</span>";
			                SelectDeptNM.setAttribute("countinfo", "1")
							<c:if test="${useShowAllCompanies eq 'YES'}">
								resizeWindowWidth();
							</c:if>
			            }
		            }
		        }
		        
		        var row = SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW");
		        
		        for (var i = 0; i < row.length; i++) {
		            if (pListType == "IMG") {
		                var MainTable = document.createElement("TABLE");
		                MainTable.setAttribute("class", pListType == "IMG" ? "organwrap" : "organwrap_list");
		                MainTable.setAttribute("cellspacing", "0");
		                MainTable.setAttribute("cellpadding", "0");
						MainTable.setAttribute("style", "width:98%");
		                if (pListType == "IMG")
		                    MainTable.style.marginTop = "5px";
		
		                MainTable.style.marginLeft = "auto";
		                MainTable.style.marginRight = "auto";
		                var M_TR = document.createElement("TR");
		                M_TR.setAttribute("id", "MailUserlist_" + i);
						if ("${cursorType}" === "p" ) {
							M_TR.style.cursor = "pointer"; // 메일 환경설정 > 도착한메일 전달 > 메일계정설정 커서 설정(image)
						} else {
							M_TR.style.cursor = "move"; // [수신자 설정] 사원명함보기란 DeptUserImgList
						}
		                M_TR.onmouseover = function () { event_listMover(this); };
		                M_TR.onmouseout = function () { event_listMout(this); };
		                M_TR.onclick = function () { event_listclick(this); };
		                if(type != 'auto'){
		                    M_TR.ondblclick = function () { event_listDBclick(this); };
		                }
		                M_TR.onselectstart = function () { return false; };
		                M_TR.setAttribute("draggable", true);
		                if (CrossYN())
		                    M_TR.ondragstart = function (event) { event_listdragstart(this); event.dataTransfer.setData('text/plain', 'dragged'); };
		                else
		                    M_TR.ondragstart = function (event) { event_listdragstart(this); };
						
						// 2024-07-05 김대현 #140902 사파리만 event_listdragend 넣어 중복으로 InsertReceiver()를 실행하여 생기는 현상으로 지워도 동작하기 때문에 해당 함수 주석처리 
		                // if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		                //     M_TR.ondragend = function (event) { event_listdragend(event); };
		                // }
		                if (CrossYN()) {
		                    for (var NodeCount = 0; NodeCount < row.item(i).childNodes.item(0).childNodes.length; NodeCount++) {
		                        if (row.item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName != "#text") {
		                            M_TR.setAttribute("_" + row.item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
		                                              trim_Cross(row.item(i).childNodes.item(0).childNodes.item(NodeCount).textContent));
		                        }
		                    }
		                }
		                else {
		                    for (var NodeCount = 0; NodeCount < row.item(i).childNodes.item(0).childNodes.length; NodeCount++) {
		                        M_TR.setAttribute("_" + row.item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
		                        		row.item(i).childNodes.item(0).childNodes.item(NodeCount).text);
		                    }
		                }
		
		                var M_TR_TD = document.createElement("TD");
		                M_TR_TD.setAttribute("class", "pictd");
						M_TR_TD.setAttribute("width", "98.5px");
		                var M_TR_DIV = document.createElement("DIV");
		                M_TR_DIV.setAttribute("class", "pic");
		                if (M_TR.getAttribute("_DATA9") != "") {
		                    var M_TR_IMG = document.createElement("IMG");
		                    M_TR_IMG.setAttribute("SRC", "/admin/ezOrgan/getPersonalInfo.do?fileName=" + M_TR.getAttribute("_DATA9"));
		                    M_TR_IMG.setAttribute('onerror', "this.style.display='none'");
		                    M_TR_IMG.setAttribute("width", "90px");
		                    M_TR_IMG.setAttribute("height", "90px");
		                    M_TR_DIV.appendChild(M_TR_IMG);
		                }
		                M_TR_TD.appendChild(M_TR_DIV);
		                M_TR.appendChild(M_TR_TD);
		
		                var M_TR_TD2 = document.createElement("TD");
		                M_TR_TD2.style.width = "100%";
		
		                var M_TR_TDS_Table = document.createElement("TABLE");
		                M_TR_TDS_Table.setAttribute("class", "organinfo");
		                M_TR_TD2.appendChild(M_TR_TDS_Table);
		
		                var Sub_TR1 = document.createElement("TR");
		                var Sub_TD1 = document.createElement("TD");
		                Sub_TD1.style.textAlign = "left";
		                Sub_TD1.setAttribute("class", "name");
		                var pDisplayName = "";
		                if ("${useOcs}" == "YES") {
		                    pDisplayName += "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + M_TR.getAttribute("_DATA3") + "\",this);'/></span>";
		                }
		                
		                if( !pSeach && $(M_TR).attr("_DATA11" ) == "addJob"){
		                	pDisplayName += "<spring:message code='ezOrgan.psb03'/> ";
		                } else if( pSeach && $(M_TR).attr("_DATA10") == "addJob" ){
		                	pDisplayName += "<spring:message code='ezOrgan.psb03'/> ";
		                }
		                
		                pDisplayName += M_TR.getAttribute("_DATA4") == "" ? "" : M_TR.getAttribute("_DATA4");
		                pDisplayName += M_TR.getAttribute("_DATA6") == "" ? "" : "[" + M_TR.getAttribute("_DATA6") + "]";
		                Sub_TD1.innerHTML = pDisplayName;
		                Sub_TD1.title = pDisplayName;
		                Sub_TR1.appendChild(Sub_TD1);
		
		                var Sub_TR2 = document.createElement("TR");
		                var Sub_TD2 = document.createElement("TD");
						var descriptionValue = MakeXMLString(M_TR.getAttribute("_DATA5"));
						<c:if test="${useShowAllCompanies eq 'YES'}">
							if (pSeach) {
								descriptionValue += " (<spring:message code='ezPersonal.t67'/>: " + MakeXMLString(M_TR.getAttribute("_DATA7")) + ")";
							}
						</c:if>
		                Sub_TD2.style.textAlign = "left";
		                Sub_TD2.innerHTML = descriptionValue;
		                Sub_TD2.title = descriptionValue;
		                Sub_TR2.appendChild(Sub_TD2);
		
		                var Sub_TR3 = document.createElement("TR");
		                var Sub_TD3 = document.createElement("TD");
		                Sub_TD3.style.textAlign = "left";
		                var Sub_TD3_Img = document.createElement("IMG");
		                Sub_TD3_Img.setAttribute("class", "icon");
		                Sub_TD3_Img.setAttribute("src", "/images/OrganTree/icon_hp.gif");
		                Sub_TD3.appendChild(Sub_TD3_Img);
		                Sub_TD3.innerHTML += M_TR.getAttribute("_DATA8") == "" ? " - " : M_TR.getAttribute("_DATA8");
		                Sub_TD3.title = M_TR.getAttribute("_DATA8") == "" ? " - " : M_TR.getAttribute("_DATA8");
		                Sub_TR3.appendChild(Sub_TD3);
		
		                var Sub_TR4 = document.createElement("TR");
		                var Sub_TD4 = document.createElement("TD");
		                Sub_TD4.style.textAlign = "left";
		                var Sub_TD4_Img = document.createElement("IMG");
		                Sub_TD4_Img.setAttribute("class", "icon");
		                Sub_TD4_Img.setAttribute("src", "/images/OrganTree/icon_mail.gif");
		                Sub_TD4.appendChild(Sub_TD4_Img);
		                Sub_TD4.innerHTML += M_TR.getAttribute("_DATA3")
		                Sub_TD4.title = M_TR.getAttribute("_DATA3")
		                Sub_TR4.appendChild(Sub_TD4);
		
		                M_TR_TDS_Table.appendChild(Sub_TR1);
		                M_TR_TDS_Table.appendChild(Sub_TR2);
		                M_TR_TDS_Table.appendChild(Sub_TR3);
		                M_TR_TDS_Table.appendChild(Sub_TR4);
		
		                M_TR.appendChild(M_TR_TD2);
		                MainTable.appendChild(M_TR);
		                document.getElementById("DeptUserImgList").appendChild(MainTable);
		            }
		            else {
		                var M_TR = document.createElement("TR");
		                M_TR.setAttribute("id", "MailUserlist_" + i);
						if ("${cursorType}" === "p" ) {
							M_TR.style.cursor = "pointer"; // 메일 환경설정 > 도착한메일 전달 > 메일계정설정 커서 설정(text)
						} else {
							M_TR.style.cursor = "move"; // [수신자 설정] 사원리스트란 orglistView (text)
						}
		                M_TR.onmouseover = function () { event_listMover(this); };
		                M_TR.onmouseout = function () { event_listMout(this); };
		                M_TR.onclick = function () { event_listclick(this); };
		                if(type != 'auto'){
		                    M_TR.ondblclick = function () { event_listDBclick(this); };
		                }
		                M_TR.onselectstart = function () { return false; };
		                M_TR.setAttribute("draggable", true);
		                if (CrossYN())
		                    M_TR.ondragstart = function (event) { event_listdragstart(this); event.dataTransfer.setData('text/plain', 'dragged'); };
		                else
		                    M_TR.ondragstart = function (event) { event_listdragstart(this); };

						// 2024-07-05 김대현 #140902 사파리만 event_listdragend 넣어 중복으로 InsertReceiver()를 실행하여 생기는 현상으로 지워도 동작하기 때문에 해당 함수 주석처리 
						// if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
						//     M_TR.ondragend = function (event) { event_listdragend(event); };
						// }
		                
		                if (CrossYN()) {
		                    for (var NodeCount = 0; NodeCount < row.item(i).childNodes.item(0).childNodes.length; NodeCount++) {
		                        if (row.item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName != "#text") {
		                            M_TR.setAttribute("_" + row.item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
		                                              trim_Cross(row.item(i).childNodes.item(0).childNodes.item(NodeCount).textContent));
		                        }
		                    }
		                }
		                else {
		                    for (var NodeCount = 0; NodeCount < row.item(i).childNodes.item(0).childNodes.length; NodeCount++) {
		                        M_TR.setAttribute("_" + row.item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
		                                          row.item(i).childNodes.item(0).childNodes.item(NodeCount).text);
		                    }
		                }
		
		                if (pSeach) {
		                    var M_TR_TD1 = document.createElement("TD");
		                    M_TR_TD1.style.overflow = "hidden";
		                    M_TR_TD1.style.textOverflow = "ellipsis";
		                    M_TR_TD1.style.whiteSpace = "nowrap";
		                    M_TR_TD1.style.width = "110px";
		                    M_TR_TD1.innerHTML = M_TR.getAttribute("_DATA5");
		                    M_TR_TD1.title = M_TR.getAttribute("_DATA5");
		
		                    var M_TR_TD2 = document.createElement("TD");
		                    M_TR_TD2.style.overflow = "hidden";
		                    M_TR_TD2.style.textOverflow = "ellipsis";
		                    M_TR_TD2.style.whiteSpace = "nowrap";
		                    M_TR_TD2.style.width = "90px";
							M_TR_TD2.title = M_TR.getAttribute("_DATA4");
		                    if ("${useOcs}" == "YES")
		                        M_TR_TD2.innerHTML = "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + M_TR.getAttribute("_DATA3") + "\",this);'/></span>" + M_TR.getAttribute("_DATA4");
		                    else
		                        M_TR_TD2.innerHTML = M_TR.getAttribute("_DATA4");
		
		                    var M_TR_TD3 = document.createElement("TD");
		                    
		                    var jobName = "";
		                    if($(M_TR).attr("_DATA11") == "addJob"){
		                    	jobName += "<spring:message code='ezOrgan.psb03'/> ";
		                    }	      
		                    
		                    jobName += M_TR.getAttribute("_DATA6") == "" ? "" : M_TR.getAttribute("_DATA6");
		                    M_TR_TD3.innerHTML = jobName;
		                    M_TR_TD3.title = jobName;
	                        M_TR_TD3.style.overflow = "hidden";
	                        M_TR_TD3.style.textOverflow = "ellipsis";
	                        M_TR_TD3.style.whiteSpace = "nowrap";
		                    
		                    M_TR_TD3.style.width = "70px";
		
		                    var M_TR_TD4 = document.createElement("TD");
		                    M_TR_TD4.innerHTML = M_TR.getAttribute("_DATA8") == "" ? "" : M_TR.getAttribute("_DATA8");
		                    M_TR_TD4.title = M_TR.getAttribute("_DATA8") == "" ? "" : M_TR.getAttribute("_DATA8");
	                        M_TR_TD4.style.overflow = "hidden";
	                        M_TR_TD4.style.textOverflow = "ellipsis";
	                        M_TR_TD4.style.whiteSpace = "nowrap";

	                        if (useOrgListCheckBox) {
			                    var M_TR_TD_Chk = document.createElement("TD");
			                    M_TR_TD_Chk.style.padding = "5px";
			                    M_TR_TD_Chk.innerHTML = "<input type='checkbox' class='checkUser'/>";
			                    M_TR.appendChild(M_TR_TD_Chk);
		                    }

							<c:if test="${useShowAllCompanies eq 'YES'}">
								var companyTd = document.createElement("TD");
								companyTd.style.overflow = "hidden";
								companyTd.style.textOverflow = "ellipsis";
								companyTd.style.whiteSpace = "nowrap";
								companyTd.style.width = "110px";
								companyTd.innerHTML = M_TR.getAttribute("_DATA7");
								companyTd.title = M_TR.getAttribute("_DATA7");
								M_TR.appendChild(companyTd);
							</c:if>

		                    M_TR.appendChild(M_TR_TD1);
		                    M_TR.appendChild(M_TR_TD2);
		                    M_TR.appendChild(M_TR_TD3);
		                    M_TR.appendChild(M_TR_TD4);
		                    
		                    document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).appendChild(M_TR);
		                }
		                else {
		                    var M_TR_TD1 = document.createElement("TD");
		                    M_TR_TD1.style.overflow = "hidden";
		                    M_TR_TD1.style.textOverflow = "ellipsis";
		                    M_TR_TD1.style.whiteSpace = "nowrap";
		                    M_TR_TD1.style.width = "150px";
							M_TR_TD1.title = M_TR.getAttribute("_DATA4");
		                    if ("${useOcs}" == "YES")
		                        M_TR_TD1.innerHTML = "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + M_TR.getAttribute("_DATA3") + "\",this);'/></span>" + M_TR.getAttribute("_DATA4");
		                    else
		                        M_TR_TD1.innerHTML = M_TR.getAttribute("_DATA4");
		
		                    var M_TR_TD2 = document.createElement("TD");
		                    M_TR_TD2.style.width = "80px";
		                    
		                    var jobName = "";
		                    if($(M_TR).attr("_DATA11") == "addJob"){
		                    	jobName += "<spring:message code='ezOrgan.psb03'/> ";
		                    }	      
		                    
		                    jobName += M_TR.getAttribute("_DATA6") == "" ? "" : M_TR.getAttribute("_DATA6");
		                    M_TR_TD2.innerHTML = jobName;
		                    M_TR_TD2.title = jobName;
	                        M_TR_TD2.style.overflow = "hidden";
	                        M_TR_TD2.style.textOverflow = "ellipsis";
	                        M_TR_TD2.style.whiteSpace = "nowrap";
		
		                    var M_TR_TD3 = document.createElement("TD");
		                    M_TR_TD3.innerHTML = M_TR.getAttribute("_DATA8") == "" ? "" : M_TR.getAttribute("_DATA8");
		                    M_TR_TD3.title = M_TR.getAttribute("_DATA8") == "" ? "" : M_TR.getAttribute("_DATA8");
	                        M_TR_TD3.style.overflow = "hidden";
	                        M_TR_TD3.style.textOverflow = "ellipsis";
	                        M_TR_TD3.style.whiteSpace = "nowrap";
							
		                    if (useOrgListCheckBox) {
			                    var M_TR_TD_Chk = document.createElement("TD");
			                    M_TR_TD_Chk.style.padding = "5px";
			                    M_TR_TD_Chk.innerHTML = "<input type='checkbox' class='checkUser'/>";
			                    M_TR.appendChild(M_TR_TD_Chk);
		                    }
		                    
		                    if (selTab.indexOf("orgJobMstListView") > -1) {
			                    var M_TR_DEPT_TD = document.createElement("TD");
			                    M_TR_DEPT_TD.style.overflow = "hidden";
			                    M_TR_DEPT_TD.style.textOverflow = "ellipsis";
			                    M_TR_DEPT_TD.style.whiteSpace = "nowrap";
			                    M_TR_DEPT_TD.style.width = "110px";
			                    M_TR_DEPT_TD.innerHTML = M_TR.getAttribute("_DATA5");
			                    M_TR_DEPT_TD.title = M_TR.getAttribute("_DATA5");
			                    
			                    M_TR.appendChild(M_TR_DEPT_TD);
		                    }
		                    
		                    M_TR.appendChild(M_TR_TD1);
		                    M_TR.appendChild(M_TR_TD2);
		                    M_TR.appendChild(M_TR_TD3);
		                    document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).appendChild(M_TR);
		                }
		                
		                changeCheckBox();
		            }
		
		        }
		        
		        if (selTab == "orglistView" && $(".txtlist_DeptTD").length > 0) {
		        	$(".none").css("display", "none");
		        }
		    }
	        function show_member() {
	            var listview = new ListView();
	            listview.LoadFromID("Organ");
	            var length = listview.GetRowCount()
	            var selectdata = listview.GetSelectedRows();
	            if (length > 0) {
	                var id = GetAttribute(selectdata[0], "DATA2");
	                var dept = GetAttribute(selectdata[0], "DATA10");
	                window.open("/ezCommon/showPersonInfo.do?id=" + id + "&dept=" + dept, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
	            }
	        }
	        function ListViewNodeDblClick() {
	            if (m_selectedWindow != null) {
	                var pListView = "";
	                if (m_selectedWindow.id == "ListViewMsgTo") {
	                    pListView = "MsgToList";
	                }
	                else if (m_selectedWindow.id == "ListViewMsgCC") {
	                    pListView = "MsgCCList";
	                }
	                else if (m_selectedWindow.id == "ListViewMsgBCC") {
	                    pListView = "MsgBCCList";
	                }
	                InsertReceiver(pListView);
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
	            if ($.trim(keyword.value) == "") {
	                alert("<spring:message code='ezEmail.t10' />");
	                keyword.focus();
	                return;
	            }
	            if (type == "search") {
	                CurPage = "1";
	                issearch = true;
	            }
	            if (document.getElementById("search_type").value == "description") {
	                deptsearch_click();
	                return;
	            }
	            
	            $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/ezOrgan/getSearchList.do",
		        	async : true,
		        	data : {
		        			search : document.getElementById("search_type").value + "::" + keyword.value, 
		        			cell : "company;description;displayName;title;telephoneNumber;"+ document.getElementById("search_type").value, 
		        			prop : "mail;displayName;description;title;company;telephonenumber;extensionAttribute2;department;userType", 
		        			page : CurPage, 		        			
			                <c:if test="${useShowAllCompanies eq 'YES'}">
		        			company : "",
			                </c:if>		        			
		        			type : "user"},
		        	success : function(result){	
		        		pListXML_Info = loadXMLString(result);
		        		if (pListXML_Info.getElementsByTagName("ROW").length == 0) {
		        		    issearch = false;
	                        alert(strLang155);	                        
		        		} else {
	                        listContentArry = new Array();
	                        pSeach = true;
	                        DisplayUserImageList();
	                        makePageSelPage2();
	                    }
		        	},
		        	error : function(error){
		        		alert("<spring:message code='ezEmail.t578' />" + error);
		        	}
		        });
	            
	            var usedefault;
	            if (browserIE) {
	                usedefault = document.getElementById("search_type").options[document.getElementById("search_type").selectedIndex].usedefault;
	            }
	            else {
	                usedefault = GetAttribute(document.getElementById("search_type").options[document.getElementById("search_type").selectedIndex], "usedefault");
	            }
	            // 2020-11-03 김은실 - [가천대길병원 voc(#66552)] 메일 수신자 설정시 선택 오류 : 검색 시 PressShiftKey = true 되는 현상 발생.
	            PressShiftKey = false;
	            
	        }

	        function cnsearch_press() {
	            if (window.event.keyCode == "13")
	                cnsearch_click();
	        }
	        function cnsearch_click() {
	            if (document.getElementById("cnkeyword").value == "") {
	                alert("<spring:message code='ezEmail.t576' />");
	                document.getElementById("cnkeyword").focus();
	                return;
	            }
	            
	            $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/ezOrgan/getSearchList.do",
		        	async : true,
		        	data : {search : "displayname::" + document.getElementById("cnkeyword").value, 
		        	    cell : "displayName;description;title;telephoneNumber", 
		        	    prop : "mail", 		        	    
		        	    <c:if test="${useShowAllCompanies eq 'YES'}">
		        	    company : "", 
		        	    </c:if>		        	    
		        	    type : "user"},
		        	success : function(result){	
		        		pListXML_Info = loadXMLString(result);
		        		if (pListXML_Info.getElementsByTagName("ROW").length == 0) {
		        		    issearch = false;
	                        alert(strLang155);
		        		} else {
	                        listContentArry = new Array();
	                        pSeach = true;
	                        DisplayUserImageList();
	                        makePageSelPage2();
	                    }
		        	},
		        	error : function(error){
		        		alert("<spring:message code='ezEmail.t578' />" + error);
		        	}
		        });
	            
	        }
	        function AddrSearch_press() {
	            if (window.event.keyCode == "13")
	                AddrSearch_click();
	        }
	        function AddrSearch_click() {
	            page = "1";
	            AddrSearch_event();
	        }
	        function AddrSearch_event() {
	            var objSel = "SNAME";
	            var objText = document.getElementById("search_text");
	            if (objText.value == "") {
	                alert("<spring:message code='ezEmail.t576' />");
	                objText.focus();
	                return;
	            }
	
	            var nodeIdx = AddressTreeView.selectedIndex();
	            var parentFolderId = AddressTreeView.getvalue(nodeIdx, "folderid");
	            var ownerid = AddressTreeView.getvalue(nodeIdx, "ownerid");
	            var foldertype = AddressTreeView.getvalue(nodeIdx, "type");
	
	            var curpage = "1";
	            if (addrsearh) {
	                curpage = page;
	            }
	            var strXML = "<DATA>"
	                         + "<FOLDERID>" + parentFolderId + "</FOLDERID>"
	                         + "<FOLDERTYPE>" + foldertype + "</FOLDERTYPE>"
	                         + "<OWNERID>" + ownerid + "</OWNERID>"
	                         + "<CASE>" + document.getElementById("search_case").value + "</CASE>"
	                         + "<FILTER>" + MakeXMLString(document.getElementById("search_text").value) + "</FILTER>"
	                         + "<PAGE>" + curpage + "</PAGE>"
	                         + "<PAGESIZE>25</PAGESIZE>"
	                         + "</DATA>";
	
	            addrsearh = true;
	            var xmlHTTP = createXMLHttpRequest();
                xmlHTTP.open("POST", "/ezAddress/addressGetListMailSearchCall.do", false);
	            xmlHTTP.send(strXML);
	            if (xmlHTTP.status != 200 || xmlHTTP.responseText == "ERROR") {
	                alert("<spring:message code='ezEmail.t585' />");
	                objText.focus();
	                return;
	            }
	            var xmlDom
	            if (CrossYN())
	                xmlDom = xmlHTTP.responseXML;
	            else
	                xmlDom = loadXMLString(xmlHTTP.responseText);
	
	            var arrRows = GetElementsByTagName(xmlDom, "ROW");
	            if (arrRows.length > 0) {
	                document.getElementById("totalcount").innerHTML = arrRows.length;
	            }
	            else {
	                document.getElementById("totalcount").innerHTML = "0";
	            }
	            var addressList = new ListView();
	            addressList.SetID("Address");
	            addressList.SetSelectFlag(false);
	            addressList.SetHeightFree(true);
	            addressList.SetMulSelectable(true);
	            addressList.SetRowOnDblClick("ListViewNodeDblClick");
	            addressList.SetUseCheckBox(useOrgListCheckBox);
	            addressList.DataBind("AddressListView");
	            addressList.DataSource(get_xmldom_addresslistview(xmlDom));
	            addressList.RowDataBind();
	            for (var i = 0; i < addressList.GetRowCount() ; i++) {
	                addressList.GetDataRows()[i].draggable = true;
	                if (CrossYN())
	                    addressList.GetDataRows()[i].ondragstart = function (event) { event_listdragstart(this); event.dataTransfer.setData('text/plain', 'dragged'); };
	                else
	                    addressList.GetDataRows()[i].ondragstart = function (event) { event_listdragstart(this); };

					// 2024-07-05 김대현 #140902 사파리만 event_listdragend 넣어 중복으로 InsertReceiver()를 실행하여 생기는 현상으로 지워도 동작하기 때문에 해당 함수 주석처리 
	                // if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
	                //     addressList.GetDataRows()[i].ondragend = function (event) { event_listdragend(event); };
	                // }
	            }
	            addressList = null;
	            document.getElementById('totalcount').textContent = xmlDom.getElementsByTagName("PAGECOUNT").item(0).firstChild.nodeValue;
	            if (CrossYN())
	                document.getElementById('addressFolderCnt').textContent = xmlDom.getElementsByTagName("TOTALCN").item(0).firstChild.nodeValue;
	            else
	                document.getElementById('addressFolderCnt').innerText = xmlDom.getElementsByTagName("TOTALCN").item(0).firstChild.nodeValue;
	            document.getElementById('txt_PageInputNum').value = "1";
	            //page = document.getElementById('txt_PageInputNum').value;
	            totalPage = Math.ceil(xmlDom.getElementsByTagName("TOTALCN").item(0).firstChild.nodeValue / 25);
	            pageNum = page;
	
	            makePageSelPage();
	            changeCheckBox();
	        }
	        function make_searchstring(orgStr) {
	            return ReplaceText(ReplaceText(ReplaceText(ReplaceText(orgStr, "'", "''"), "\\[", "[[]"), "%", "[%]"), "_", "[_]");
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
	            listContentArry = new Array();
	            pListType = Div;
	            ListTypeChangeIcon();
	            DisplayUserImageList();
	            setOrganListType(pListType);
	        }
	        function keyword_Clear() {
	            document.getElementsByName('keyword').value = "";
	        }
	        function onkey_down(e) {
	            if (window.event) {
	                if (window.event.keyCode == 13) {
	                    deptsearch_click();
	                }
	            }
	            else {
	                if (e.which == 13) {
	                    deptsearch_click();
	                }
	            }
	        }

	        function infoview_click() {
	            if (p_ListOrderObject == null || p_ListOrderObject == "") {
	                alert("<spring:message code='ezEmail.t579' />");
	                return;
	            }
	            var id = p_ListOrderObject.getAttribute("_DATA2");
	            //var dept = p_ListOrderObject.getAttribute("_DATA13");
	            var dept = p_ListOrderObject.getAttribute("_DATA10");
	            var rtn
	            var width = 420, height = 450;
	            var leftPosition, topPosition;
	            leftPosition = (window.screen.width / 2) - ((width / 2) + 10);
	            topPosition = (window.screen.height / 2) - ((height / 2) + 50);
	
	            window.open("/ezCommon/showPersonInfo.do?id=" + id + "&dept=" + dept, "", "height=" + height + ",width=" + width + ", left=" + leftPosition + ",top=" + topPosition + ",screenX=" + leftPosition + ",screenY=" + topPosition + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
	        }
	        function open_userinfo(cn) {
	            window.showModalDialog("/ezCommon/showPersonInfo.do?id=" + cn, "", "dialogHeight=450px;dialogWidth=420px;status:no;scroll:auto; help:no; edge:sunken");
	        }
	        var mail_select_dlmember_cross_dialogArguments = new Array();
	        function dlmember_click() {
	            var DlList = new ListView();
	            DlList.LoadFromID("pListViewDL");
	            var arrRows = DlList.GetSelectedRows();
	            if (arrRows.length < 1) {
	                alert("<spring:message code='ezEmail.t580' />");
	                return;
	            }
	            if (ReturnFunction != null) {
	                var rtnValue = { "name": new Array(), "email": new Array() };
	                mail_select_dlmember_cross_dialogArguments[0] = rtnValue;
	                mail_select_dlmember_cross_dialogArguments[1] = dlmember_click_Complete;
	                mail_select_dlmember_cross_dialogArguments[2] = DivPopUpHidden;
	                DivPopUpShow(601, 470, "/ezEmail/mailSelectDLMember.do?cn=" + GetAttribute(arrRows[0], "DATA1"));
	            }
	            else {
	                var rtnValue = { "name": new Array(), "email": new Array() };
	                var count = window.showModalDialog("/ezEmail/mailSelectDLMember.do?cn=" + GetAttribute(arrRows[0], "DATA1"), rtnValue, "dialogHeight:470px; dialogWidth:601px; status:no;scroll:auto; help:no; edge:sunken");
	                var listid = "";
	
	                if (m_selectedWindow.id == "ListViewMsgTo") {
	                    var listviewTo = new ListView();
	                    listviewTo.LoadFromID("MsgToList");
	                    var InitTrTo = listviewTo.GetDataRows();
	                    var pparsingXML = "";
	                    var pparsingXML2 = "";
	                    pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	                    var aa = 0;
	                    for (var i = 0; i < count; i++) {
	                        var IsInsert = CheckMailReceiver(rtnValue["email"][i], "3");
	                        if (!IsInsert) {
	                            pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(rtnValue["name"][i]) + "</DATA1>";
	                            pparsingXML = pparsingXML + "<DATA2>" + rtnValue["email"][i] + "</DATA2>";
	                            pparsingXML = pparsingXML + "<DATA3></DATA3>";
	                            pparsingXML = pparsingXML + "<DATA4></DATA4>";
	                            pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(rtnValue["name"][i]) + " &lt;" + rtnValue["email"][i] + "&gt;" + "</VALUE></CELL></ROW>";
	                        }
	                    }
	                    pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
	
	                    var Resultxml = loadXMLString(pparsingXML2);
	
	                    var listview = new ListView();
	                    listview.SetID("MsgToList");
	                    listview.SetHeightFree(true);
	                    listview.SetSelectFlag(false);
	                    listview.SetMulSelectable(false);
	                    listview.SetRowOnDblClick("DeleteReceiver");
	                    listview.DataSource(Resultxml);
	                    listview.RowDataBind2();
	                }
	                else if (m_selectedWindow.id == "ListViewMsgCC") {
	                    var listviewCC = new ListView();
	                    listviewCC.LoadFromID("MsgCCList");
	                    var InitTrTo = listviewCC.GetDataRows();
	                    var pparsingXML = "";
	                    var pparsingXML2 = "";
	                    pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	                    var aa = 0;
	                    for (var i = 0; i < count; i++) {
	                        var IsInsert = CheckMailReceiver(rtnValue["email"][i], "3");
	                        if (!IsInsert) {
	                            pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(rtnValue["name"][i]) + "</DATA1>";
	                            pparsingXML = pparsingXML + "<DATA2>" + rtnValue["email"][i] + "</DATA2>";
	                            pparsingXML = pparsingXML + "<DATA3></DATA3>";
	                            pparsingXML = pparsingXML + "<DATA4></DATA4>";
	                            pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(rtnValue["name"][i]) + " &lt;" + rtnValue["email"][i] + "&gt;" + "</VALUE></CELL></ROW>";
	                        }
	                    }
	                    pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
	                    var Resultxml = loadXMLString(pparsingXML2);
	                    var listview = new ListView();
	                    listview.SetID("MsgCCList");
	                    listview.SetHeightFree(true);
	                    listview.SetSelectFlag(false);
	                    listview.SetMulSelectable(false);
	                    listview.SetRowOnDblClick("DeleteReceiver");
	                    listview.DataSource(Resultxml);
	                    listview.RowDataBind2();
	                }
	                else if (m_selectedWindow.id == "ListViewMsgBCC") {
	                    var listviewBCC = new ListView();
	                    listviewBCC.LoadFromID("MsgBCCList");
	                    var InitTrTo = listviewBCC.GetDataRows();
	                    var pparsingXML = "";
	                    var pparsingXML2 = "";
	                    pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	                    var aa = 0;
	                    for (var i = 0; i < count; i++) {
	                        var IsInsert = CheckMailReceiver(rtnValue["email"][i], "3");
	                        if (!IsInsert) {
	                            pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(rtnValue["name"][i]) + "</DATA1>";
	                            pparsingXML = pparsingXML + "<DATA2>" + rtnValue["email"][i] + "</DATA2>";
	                            pparsingXML = pparsingXML + "<DATA3></DATA3>";
	                            pparsingXML = pparsingXML + "<DATA4></DATA4>";
	                            pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(rtnValue["name"][i]) + " &lt;" + rtnValue["email"][i] + "&gt;" + "</VALUE></CELL></ROW>";
	                        }
	                    }
	                    pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
	                    var Resultxml = loadXMLString(pparsingXML2);
	                    var listview = new ListView();
	                    listview.SetID("MsgBCCList");
	                    listview.SetHeightFree(true);
	                    listview.SetSelectFlag(false);
	                    listview.SetMulSelectable(false);
	                    listview.SetRowOnDblClick("DeleteReceiver");
	                    listview.DataSource(Resultxml);
	                    listview.RowDataBind2();
	                }
	            }
	        }
	        
	        // 재은 수정 ('구성원 보기 및 선택' 시 드래그 온 드랍 되도록 수정 )
	        function dlmember_click_Complete(count) {
	            DivPopUpHidden();
	            try {
					const LoadIDMap = {ListViewMsgTo: "MsgToList", ListViewMsgCC: "MsgCCList", ListViewMsgBCC: "MsgBCCList"};
					const LoadID = LoadIDMap[m_selectedWindow.id];
					if (!LoadID) return;

					var listviewTo = new ListView();
					listviewTo.LoadFromID(LoadID);
					var InitTrTo = listviewTo.GetDataRows();

					var listview = new ListView();
					listview.LoadFromID(LoadID);
					let MaxID = listview.GetSelectedRowIDMaxNum();
					document.getElementById(LoadID).className = "receiver_list";

					for (var i = 0; i < count; i++) {
						if (CheckMailReceiver(mail_select_dlmember_cross_dialogArguments[0]["email"][i], "3")) continue;
						if (type == "" && !increaseReceiverCount()) return;

						const pparsingXML = "<LISTVIEWDATA2><ROWS>"
						+ "<ROW><CELL><DATA1>" + MakeXMLString(mail_select_dlmember_cross_dialogArguments[0]["name"][i]) + "</DATA1>"
						+ "<DATA2>" + mail_select_dlmember_cross_dialogArguments[0]["email"][i] + "</DATA2>"
						+ "<DATA3></DATA3>"
						+ "<DATA4></DATA4>"
						+ "<VALUE>" + MakeXMLString(mail_select_dlmember_cross_dialogArguments[0]["name"][i]) + " &lt;" + mail_select_dlmember_cross_dialogArguments[0]["email"][i] + "&gt;" + "</VALUE></CELL></ROW>"
						+ "</ROWS></LISTVIEWDATA2>";
						var Resultxml = loadXMLString(pparsingXML);

						var objTr = listview.AddRow(listview.GetRowCount());
						SetAttribute(objTr, "id", LoadID + "_TR_" + ++MaxID);
						listview.AddDataRow(objTr, Resultxml);
					}
	            } catch (e) { }
	        }
	        
	        var mail_select_sharedMailboxMember_cross_dialogArguments = new Array();
	        function sharedMailboxMember_click() {
	            var sharedMailboxList = new ListView();
	            sharedMailboxList.LoadFromID("pListViewSharedMailbox");
	            var arrRows = sharedMailboxList.GetSelectedRows();
	            
	            if (arrRows.length < 1) {
	                alert("<spring:message code='ezEmail.sharedMailbox20' />");
	                return;
	            }
	            
	            if (ReturnFunction != null) {
	                var rtnValue = { "name": new Array(), "email": new Array() };
	                mail_select_sharedMailboxMember_cross_dialogArguments[0] = rtnValue;
	                mail_select_sharedMailboxMember_cross_dialogArguments[1] = DivPopUpHidden;
	                DivPopUpShow(601, 470, "/ezEmail/getSharedMailboxMember.do?shareId=" + GetAttribute(arrRows[0], "DATA1"));
	            }
	        }
	        
	        var address_select_groupemaillist_dialogArguments = new Array();
	        function groupmember_click() {
	            var AdddressList = new ListView();
	            AdddressList.LoadFromID("Address");
	            var listview = AdddressList.GetSelectedRows();
	            if (listview.length < 1) {
	                alert("<spring:message code='ezEmail.t581' />");
	                return;
	            }
	            var type = GetAttribute(listview[0], "DATA2");
	            if (type != "mailgroup") {
	                alert("<spring:message code='ezEmail.t581' />");
	                return;
	            }
	            var FolderType = GetAttribute(listview[0], "DATA4");
	            var ID = GetAttribute(listview[0], "DATA1");
	            var Url = "";
	            /* if(FolderType =="P")
	                Url = "../ezAddress/RemoteEWS/address_select_groupemaillist.aspx?id=" + encodeURIComponent(ID) + "&foldertype=" + encodeURIComponent(FolderType);
	            else
	                Url = "../ezAddress/Remote/address_select_groupemaillist.aspx?id=" + encodeURIComponent(ID) + "&foldertype=" + encodeURIComponent(FolderType); */
	            Url = "/ezAddress/addressSelectGroupMailList.do?id=" + encodeURIComponent(ID) + "&foldertype=" + encodeURIComponent(FolderType);
	            
	            if (ReturnFunction != null)
	            {
	                var rtnValue = { "name": new Array(), "email": new Array() };
	                address_select_groupemaillist_dialogArguments[0] = rtnValue;
	                address_select_groupemaillist_dialogArguments[1] = groupmember_click_Complete;
	                address_select_groupemaillist_dialogArguments[2] = DivPopUpHidden;
	                DivPopUpShow(601, 470, Url);
	            }
	            else
	            {
	                var rtnValue = { "name": new Array(), "email": new Array() };
	                var count = window.showModalDialog(Url, rtnValue, "dialogHeight:470px; dialogWidth:601px; status:no;scroll:auto; help:no; edge:sunken");
	                for (var i = 0; i < count; i++) {
	                    var targetList = new ListView();
	                    targetList.LoadFromID("MsgToList");
	                    var bFlag = targetList.ExistRow("DATA2", rtnValue["email"][i]);
	                    targetList = null;
	                    if (!bFlag) {
	                        var targetList = new ListView();
	                        targetList.LoadFromID("MsgCCList");
	                        bFlag = targetList.ExistRow("DATA2", rtnValue["email"][i]);
	                        targetList = null;
	                    }
	                    if (!bFlag) {
	                        var targetList = new ListView();
	                        targetList.LoadFromID("MsgBCCList");
	                        bFlag = targetList.ExistRow("DATA2", rtnValue["email"][i]);
	                        targetList = null;
	                    }
	                    if (!bFlag) {
	                    	if (type == "") {
	                    		if (!increaseReceiverCount()) {
					        		return;
					        	}
                        	}
	                    	
	                        var listid = "";
	                        if (m_selectedWindow.id == "ListViewMsgTo") {
	                            listid = "MsgToList";
	                        }
	                        else if (m_selectedWindow.id == "ListViewMsgCC") {
	                            listid = "MsgCCList";
	                        }
	                        else if (m_selectedWindow.id == "ListViewMsgBCC") {
	                            listid = "MsgBCCList";
	                        }
	                        pparsingXML2 = "";
	                        pparsingXML = "";
	                        pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	                        pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(rtnValue["name"][i]) + "</DATA1>";
	                        pparsingXML = pparsingXML + "<DATA2>" + rtnValue["email"][i] + "</DATA2>";
	                        pparsingXML = pparsingXML + "<DATA3></DATA3>";
	                        pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(rtnValue["name"][i]) + " &lt;" + rtnValue["email"][i] + "&gt;" + "</VALUE></CELL></ROW>";
	                        pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
	                        Resultxml = loadXMLString(pparsingXML2);
	                        var listview = new ListView();
	                        listview.LoadFromID(listid);
	                        var MaxID = 0;
	                        var InitTr = listview.GetDataRows();
	                        for (var j = 0  ; j < InitTr.length  ; j++) {
	                            var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
	                            if (MaxID < curnum)
	                                MaxID = curnum;
	                        }
	                        var objTr = listview.AddRow(InitTr.length);
	                        SetAttribute(objTr, "id", listview.GetSelectedRowID(InitTr.length).substring(0, listview.GetSelectedRowID(InitTr.length).lastIndexOf('_') + 1) + (MaxID + 1));
	                        listview.AddDataRow(objTr, Resultxml);
	
	                        document.getElementById(listid).className = "receiver_list";
	                        var _tdlength = document.getElementById(listid).getElementsByTagName("TD").length;
	                        for (var y = 0; y < _tdlength; y++) {
	                            document.getElementById(listid).getElementsByTagName("TD")[y].style.textOverflow = "";
	                            document.getElementById(listid).getElementsByTagName("TD")[y].style.overflow = "";
	                        }
	                    }
	                }
	            }
	        }
	        function groupmember_click_Complete(count) {
	            DivPopUpHidden();
	            try {
	                for (var i = 0; i < count; i++) {
	                    var targetList = new ListView();
	                    targetList.LoadFromID("MsgToList");
	                    var bFlag = targetList.ExistRow("DATA2", address_select_groupemaillist_dialogArguments[0]["email"][i]);
	                    targetList = null;
	                    if (!bFlag) {
	                        var targetList = new ListView();
	                        targetList.LoadFromID("MsgCCList");
	                        bFlag = targetList.ExistRow("DATA2", address_select_groupemaillist_dialogArguments[0]["email"][i]);
	                        targetList = null;
	                    }
	                    if (!bFlag) {
	                        var targetList = new ListView();
	                        targetList.LoadFromID("MsgBCCList");
	                        bFlag = targetList.ExistRow("DATA2", address_select_groupemaillist_dialogArguments[0]["email"][i]);
	                        targetList = null;
	                    }
	                    if (!bFlag) {
	                    	if (type == "") {
	                    		if (!increaseReceiverCount()) {
					        		return;
					        	}
                        	}
	                    	
	                        var listid = "";
	                        if (m_selectedWindow.id == "ListViewMsgTo") {
	                            listid = "MsgToList";
	                        }
	                        else if (m_selectedWindow.id == "ListViewMsgCC") {
	                            listid = "MsgCCList";
	                        }
	                        else if (m_selectedWindow.id == "ListViewMsgBCC") {
	                            listid = "MsgBCCList";
	                        }
	                        pparsingXML2 = "";
	                        pparsingXML = "";
	                        pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	                        pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(address_select_groupemaillist_dialogArguments[0]["name"][i]) + "</DATA1>";
	                        pparsingXML = pparsingXML + "<DATA2>" + address_select_groupemaillist_dialogArguments[0]["email"][i] + "</DATA2>";
	                        pparsingXML = pparsingXML + "<DATA3></DATA3>";
	                        pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(address_select_groupemaillist_dialogArguments[0]["name"][i]) + " &lt;" + address_select_groupemaillist_dialogArguments[0]["email"][i] + "&gt;" + "</VALUE></CELL></ROW>";
	                        pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
	                        Resultxml = loadXMLString(pparsingXML2);
	                        var listview = new ListView();
	                        listview.LoadFromID(listid);
	                        var MaxID = 0;
	                        var InitTr = listview.GetDataRows();
	                        for (var j = 0  ; j < InitTr.length  ; j++) {
	                            var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
	                            if (MaxID < curnum)
	                                MaxID = curnum;
	                        }
	                        var objTr = listview.AddRow(InitTr.length);
	                        SetAttribute(objTr, "id", listview.GetSelectedRowID(InitTr.length).substring(0, listview.GetSelectedRowID(InitTr.length).lastIndexOf('_') + 1) + (MaxID + 1));
	                        listview.AddDataRow(objTr, Resultxml);
	
	                        document.getElementById(listid).className = "receiver_list";
	                        var _tdlength = document.getElementById(listid).getElementsByTagName("TD").length;
	                        for (var y = 0; y < _tdlength; y++) {
	                            document.getElementById(listid).getElementsByTagName("TD")[y].style.textOverflow = "";
	                            document.getElementById(listid).getElementsByTagName("TD")[y].style.overflow = "";
	                        }
	                    }
	                }
	            } catch (e) {
	            	console.error(" groupmember_click_Complete : " + e.description);
	            }
	        }
	        function dept_select(obj) {
	        	var organTree = new TreeView();
	            organTree.LoadFromID("FromTreeView");
	
	            var nodeIdx = organTree.GetSelectNode();
	            var checkBoxNodeIdx = "";
	            if (typeof obj != "undefined") {
	            	var selNodeID = obj.id;
	                var selNode = new TreeNode();
	                if (selNode.LoadFromID(selNodeID)) {
	                	checkBoxNodeIdx = selNode;
	                	nodeIdx = checkBoxNodeIdx;
	                }
	            }
	
	            if (nodeIdx != -1) {
	                var IsInsert = CheckMailReceiver(nodeIdx.GetNodeData("MAIL"), "3");
	
	                if (!IsInsert) {
	                    var organTree = new TreeView();
	                    organTree.LoadFromID("FromTreeView");
	
	                    var nodeIdx = (typeof obj == "undefined") ? organTree.GetSelectNode() : checkBoxNodeIdx;
	
	                    var listid = "";
	                    var strSIP = "";
	
	                    if (m_selectedWindow.id == "ListViewMsgTo") {
	                        listid = "MsgToList";
	                    }
	                    else if (m_selectedWindow.id == "ListViewMsgCC") {
	                        listid = "MsgCCList";
	                    }
	                    else if (m_selectedWindow.id == "ListViewMsgBCC") {
	                        listid = "MsgBCCList";
	                    }
	
	                    var listview = new ListView();
	                    listview.LoadFromID(listid);
	
	                    var strDeptNM = nodeIdx.NodeName;
	                    var strEmail = nodeIdx.GetNodeData("MAIL");
	
	                    var pparsingXML = "";
	
	                    var getlistview = new ListView();
	                    getlistview.LoadFromID(listid);
	                    var bFlag = getlistview.ExistRow("DATA3", strEmail);
	
	                    if (bFlag) {
	                        return;
	                    }
	                    
	                    if (type == "") {
	                    	if (!increaseReceiverCount()) {
				        		return;
				        	}
                    	}
	                    
                        pparsingXML = "<LISTVIEWDATA2><ROWS>";
                        pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strDeptNM) + "</DATA1>";
                        pparsingXML = pparsingXML + "<DATA2>" + strEmail + "</DATA2>";
                        pparsingXML = pparsingXML + "<DATA3><![CDATA[" + MakeXMLString(strDeptNM) + "]]></DATA3>";
                        pparsingXML = pparsingXML + "<DATA4>" + strSIP + "</DATA4>";
                        pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(strDeptNM) + " &lt;" + strEmail + "&gt;" + "</VALUE></CELL></ROW>";
                        pparsingXML = pparsingXML + "</ROWS></LISTVIEWDATA2>";
	
	                    Resultxml = loadXMLString(pparsingXML);
	
	                    var listview = new ListView();
	                    listview.LoadFromID(listid);
	
	                    var MaxID = 0;
	                    var InitTr = listview.GetDataRows();
	
	                    for (var j = 0  ; j < InitTr.length  ; j++) {
	                        var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
	                        if (MaxID < curnum)
	                            MaxID = curnum;
	                    }
	
	                    var objTr = listview.AddRow(InitTr.length);
	                    SetAttribute(objTr, "id", listview.GetSelectedRowID(InitTr.length).substring(0, listview.GetSelectedRowID(InitTr.length).lastIndexOf('_') + 1) + (MaxID + 1));
	                    listview.AddDataRow(objTr, Resultxml);
	
	                    document.getElementById(listid).className = "receiver_list";
	                    var _tdlength = document.getElementById(listid).getElementsByTagName("TD").length;
	                    for (var y = 0; y < _tdlength; y++) {
	                        document.getElementById(listid).getElementsByTagName("TD")[y].style.textOverflow = "";
	                        document.getElementById(listid).getElementsByTagName("TD")[y].style.overflow = "";
	                    }

	                    var currentContent = document.getElementById(nodeIdx.NodeID);
                        InsertReceiver_CheckBox(listid, currentContent);
	                }
	            }
	        }
	        function MakeXMLString(pOrgString) {
	            if (pOrgString == undefined) return;
	            return ReplaceText(ReplaceText(ReplaceText(pOrgString, "&", "&amp;"), "<", "&lt;"), ">", "&gt;");
	        }
	        var xmlHTTP = null;
	        function get_Address_FullTree() {
	            xmlHTTP = createXMLHttpRequest();
	            xmlHTTP.open("POST", "/ezAddress/addressGetFullTree.do", true);
	            xmlHTTP.onreadystatechange = event_get_Address_FullTree;
	            xmlHTTP.send();
	        }

	        function event_get_Address_FullTree() {
	            if (xmlHTTP.readyState == 4 && xmlHTTP != null) {
	                if (xmlHTTP.status == 200) {
	                    var treexmldom = loadXMLString(xmlHTTP.responseText);
	                    var IDNodes = treexmldom.getElementsByTagName("FOLDERID");
	                    var ChangeKeyNodes = treexmldom.getElementsByTagName("CHANGEKEY");
	                    var OwnerNodes = treexmldom.getElementsByTagName("OWNERID");
	                    var TypeNodes = treexmldom.getElementsByTagName("FOLDERTYPE");
	                    var NameNodes = treexmldom.getElementsByTagName("FOLDERNAME");
	                    var ChildNodes = treexmldom.getElementsByTagName("CHILDCOUNT");
	                    xmlHTTP = null;
	
	                    var childXML = "<tree><nodes>";
	
	                    for (var i = 0; i < NameNodes.length; i++) {
	                        var strFolderName = NameNodes[i].firstChild.nodeValue;
	
	                        childXML += "<node imgidx='1' caption=\"";
	                        childXML += (strFolderName + "\" ");
	
	                        childXML += ("ownerid=\"" + MakeRightField(OwnerNodes[i].firstChild.nodeValue) + "\" ");
	                        childXML += ("type=\"" + MakeRightField(TypeNodes[i].firstChild.nodeValue) + "\" ");
	                        childXML += ("folderid=\"" + MakeRightField(IDNodes[i].firstChild.nodeValue) + "\" ");
	                        childXML += ("changekey=\"" + MakeRightField(ChangeKeyNodes[i].firstChild.nodeValue) + "\" ");
	
	                        if (ChildNodes[i].firstChild.nodeValue != "0")
	                            childXML += "hassub='1' ";
	
	                        childXML += "/>";
	                    }
	                    childXML += "</nodes></tree>";
	
	                    AddressTreeView.source(childXML);
	                    AddressTreeView.update();
	                    //AddressTreeView.toggle(1);address Loading turing
	                    AddressTreeView.select(1);
	                }
	                else {
	                    xmlHTTP = null;
	                }
	            }
	        }
	        function LoadAddressTree() {
	            var treeXML = loadXMLFile("/xml/common/organtree_config2.xml");
	            AddressTreeView.config(treeXML);
	            get_Address_FullTree();
	        }
	        var tempfolderid = "";
	        function address_selectnode(pGubun) {
	            var nodeIdx = AddressTreeView.selectedIndex();
	            var folderid = AddressTreeView.getvalue(nodeIdx, "folderid");
	            var ownerid = AddressTreeView.getvalue(nodeIdx, "ownerid");
	            var foldertype = AddressTreeView.getvalue(nodeIdx, "type");
	            if (CrossYN())
	                document.getElementById("addressFolderName").textContent = AddressTreeView.selectedNode().textContent;
	            else
	                document.getElementById("addressFolderName").innerText = AddressTreeView.selectedNode().innerText;
	
	            var xmlDom = null;
	            if (tempfolderid != folderid)
	                page = "1";
	            xmlDom = call_page_address_get_list_mailCall(folderid, ownerid, foldertype,
	                "ADDRESSID,STYPE,SNAME,SCOMPANY,SCOMPANYPHONE,SEMAIL", "NOT SEMAIL=''", page, "25", searchgubun, "<spring:message code='ezEmail.t585' />");
	            tempfolderid = folderid;
	
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.getElementById('totalcount').textContent = xmlDom.getElementsByTagName("TOTALCN").item(0).firstChild.nodeValue;
	                document.getElementById('addressFolderCnt').textContent = xmlDom.getElementsByTagName("TOTALCN").item(0).firstChild.nodeValue;
	                document.getElementById('txt_PageInputNum').value = pGubun == "page" ? xmlDom.getElementsByTagName("CURRENTPAGE").item(0).firstChild.nodeValue : "1";
	                page = document.getElementById('txt_PageInputNum').value;
	
	                totalPage = Math.ceil(xmlDom.getElementsByTagName("TOTALCN").item(0).firstChild.nodeValue / 25);
	                pageNum = page;
	            }
	            else if (CrossYN()) {
	                document.getElementById('totalcount').textContent = xmlDom.getElementsByTagName("TOTALCN").item(0).firstChild.nodeValue;
	                document.getElementById('addressFolderCnt').textContent = xmlDom.getElementsByTagName("TOTALCN").item(0).firstChild.nodeValue;
	                document.getElementById('txt_PageInputNum').value = pGubun == "page" ? xmlDom.getElementsByTagName("CURRENTPAGE").item(0).firstChild.nodeValue : "1";
	                page = document.getElementById('txt_PageInputNum').value;
	
	                totalPage = Math.ceil(xmlDom.getElementsByTagName("TOTALCN").item(0).firstChild.nodeValue / 25);
	                pageNum = page;
	            }
	            else {
	                document.getElementById('totalcount').innerText = xmlDom.getElementsByTagName("TOTALCN").item(0).text;
	                document.getElementById('addressFolderCnt').innerText = xmlDom.getElementsByTagName("TOTALCN").item(0).text;
	                document.getElementById('txt_PageInputNum').value = pGubun == "page" ? xmlDom.getElementsByTagName("CURRENTPAGE").item(0).text : "1";
	                page = document.getElementById('txt_PageInputNum').value;
	
	                totalPage = Math.ceil(xmlDom.getElementsByTagName("TOTALCN").item(0).text / 25);
	                pageNum = page;
	            }
	            document.getElementById("AddressListView").innerHTML = "";
	            var addressList = new ListView();
	            addressList.SetID("Address");
	            addressList.SetSelectFlag(false);
	            addressList.SetHeightFree(true);
	            addressList.SetMulSelectable(true);
	            addressList.SetUseCheckBox(useOrgListCheckBox);
	            addressList.SetRowOnDblClick("ListViewNodeDblClick");
	            addressList.DataSource(loadXMLString(document.getElementById("listviewheader4").innerHTML.toUpperCase()));
	            addressList.DataBind("AddressListView");
	            addressList.DataSource(get_xmldom_addresslistview(xmlDom));
	            addressList.RowDataBind();
	            for (var i = 0; i < addressList.GetRowCount() ; i++) {
	                addressList.GetDataRows()[i].draggable = true;
	                if (CrossYN())
	                    addressList.GetDataRows()[i].ondragstart = function (event) { event_listdragstart(this); event.dataTransfer.setData('text/plain', 'dragged'); };
	                else
	                    addressList.GetDataRows()[i].ondragstart = function (event) { event_listdragstart(this); };

					// 2024-07-05 김대현 #140902 사파리만 event_listdragend 넣어 중복으로 InsertReceiver()를 실행하여 생기는 현상으로 지워도 동작하기 때문에 해당 함수 주석처리 
	                // if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
	                //     addressList.GetDataRows()[i].ondragend = function (event) { event_listdragend(event); };
	                // }
	            }
	            addressList = null;
	            addrsearh = false;
	            makePageSelPage();
	            changeCheckBox();
	        }
            var totalPage = "";
            var pageNum = "";
            function goToPageByNum(Value) {
                page = Value;
                makePageSelPage();
                movePage(page);
            }
            function selbeforeBlock() {
                var pageNum = parseInt(page);
                pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
                goToPageByNum(pageNum);
            }
            function selbeforeBlock_one() {
                var pageNum = parseInt(page);
                if (parseInt(pageNum - 1) > 0)
                    goToPageByNum(parseInt(pageNum - 1));
                else
                    return;
            }
            function selafterBlock() {
                var pageNum = parseInt(page);
                pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
                goToPageByNum(pageNum);
            }
            function selafterBlock_one() {
                var pageNum = parseInt(page);
                if (parseInt(pageNum + 1) <= totalPage)
                    goToPageByNum(parseInt(pageNum + 1));
                else
                    return;
            }
            function movePage(newPage) {
                if (parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
                    page = newPage;
                    if (addrsearh)
                        AddrSearch_event();
                    else
                        address_selectnode("page");
                }
            }
            function prevPage_onclick() {
                newPage = parseInt(page) - 1;
                if (newPage > 0) {
                    page = newPage;
                    address_selectnode("page");
                }
            }
            function nextPage_onclick() {
                newPage = parseInt(page) + 1;
                if (newPage <= parseInt(totalPage)) {
                    page = newPage;
                    address_selectnode("page");
                }
            }
            function td_Create1(strtext) {
                document.getElementById("tblPageRayer").innerHTML = strtext;
            }
            var BlockSize = "5";
            function makePageSelPage() {
                var strtext;
                var PagingHTML = "";
                document.getElementById("tblPageRayer").innerHTML = "";
                strtext = "<div class=\"pagenavi\">";
                PagingHTML += strtext;
                if (totalPage > 1 && pageNum != 1) {
                    PagingHTML += "<span class=\"btnimg first\" onclick= 'return goToPageByNum(1)'></span>";
                }
                else {
                    PagingHTML += "<span class=\"btnimg first disabled\"></span>";
                }
                if (totalPage > BlockSize) {
                    if (parseInt(pageNum) > parseInt(BlockSize)) {
                        PagingHTML += "<span class=\"btnimg prev\" onclick= 'return selbeforeBlock()'></span>";
                    }
                    else {
                        PagingHTML += "<span class=\"btnimg prev disabled\" ></span>";
                    }
                }
                else {
                    PagingHTML += "<span class=\"btnimg prev disabled\" ></span>";
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
                        PagingHTML += "<span class=\"on\">" + i + "</span>";
                    }
                    else {
                        PagingHTML += "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
                    }
                }
                if (MaxNum == 0) {
                	PagingHTML += "<span class=\"on\">" + 1 + "</span>";
                }
                if (totalPage > BlockSize) {
                    if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
                        PagingHTML += "<span class=\"btnimg next\" onclick='return selafterBlock()'></span>";
                    }
                    else {
                        PagingHTML += "<span class=\"btnimg next disabled\"></span>";
                    }
                }
                else {
                    PagingHTML += "<span class=\"btnimg next disabled\"></span>";
                }
                if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
                    PagingHTML += "<span class=\"btnimg last\" onclick='return goToPageByNum(" + totalPage + ")'></span>";
                }
                else {
                    PagingHTML += "<span class=\"btnimg last disabled\"></span>";
                }
                PagingHTML += "</div>";
                td_Create1(PagingHTML);
            }
            function call_page_address_get_list_mailCall(folderid, ownerid, foldertype, field, filter, page, pagesize, searchgubun, errormesg) {
                var xmlhttp = createXMLHttpRequest();
                var xmlpara = createXmlDom();
                var objNode;
                createNodeInsert(xmlpara, objNode, "DATA");
                createNodeAndInsertText(xmlpara, objNode, "FOLDERID", folderid);
                createNodeAndInsertText(xmlpara, objNode, "OWNERID", ownerid);
                createNodeAndInsertText(xmlpara, objNode, "FOLDERTYPE", foldertype);
                createNodeAndInsertText(xmlpara, objNode, "FIELD", field);
                createNodeAndInsertText(xmlpara, objNode, "FILTER", filter);
                createNodeAndInsertText(xmlpara, objNode, "PAGE", page);
                createNodeAndInsertText(xmlpara, objNode, "PAGESIZE", pagesize);
                createNodeAndInsertText(xmlpara, objNode, "SEARCHGUBUN", searchgubun);
                
                /* if(foldertype =="P")
                    xmlhttp.open("POST", "/myoffice/ezAddress/remoteEWS/address_get_list_mailCall.aspx", false);
                else
                    xmlhttp.open("POST", "/myoffice/ezAddress/remote/address_get_list_mailCall.aspx", false); */
                xmlhttp.open("POST", "/ezAddress/addressGetListMailCall.do", false);
                
                xmlhttp.send(xmlpara);
                if(CrossYN())
                    return xmlhttp.responseXML;
                else
                    return loadXMLString(xmlhttp.responseText);
            }
            function get_xmldom_addresslistview(xmlDom) {
                var XmlRows = SelectNodes(xmlDom, "RTNDATA/DATA/ROW");
                var xmlpara = createXmlDom();
                var objRoot, objNode, objHeader, HEADERS, HEADER, ROWS, ROW, CELL, CELLVALUE;
                objRoot = createNodeInsert(xmlpara, objRoot, "LISTVIEWDATA");
                ROWS = createNodeAndAppandNode(xmlpara, objRoot, ROWS, "ROWS");
                for (var count = 0; count < XmlRows.length; count++) {
                    ROW = createNodeAndAppandNode(xmlpara, ROWS, ROW, "ROW");
                    CELL = createNodeAndAppandNode(xmlpara, ROW, CELL, "CELL");
                    createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "VALUE", SelectSingleNodeValue(XmlRows[count], "SNAME"));
                    if (SelectSingleNodeValue(XmlRows[count], "STYPE") == "G") {
                        createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "DATA1", SelectSingleNodeValue(XmlRows[count], "ADDRESSID"));
                        createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "DATA2", "mailgroup");
                    }
                    else {
                        createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "DATA1", "");
                        createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "DATA2", "email");
                    }
                    createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "DATA3", SelectSingleNodeValue(XmlRows[count], "SEMAIL"));
                    createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "DATA4", SelectSingleNodeValue(XmlRows[count], "FOLDERTYPE"));
                    CELL = createNodeAndAppandNode(xmlpara, ROW, CELL, "CELL");
                    createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "VALUE", SelectSingleNodeValue(XmlRows[count], "SCOMPANY"));
                    CELL = createNodeAndAppandNode(xmlpara, ROW, CELL, "CELL");
                    createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "VALUE", SelectSingleNodeValue(XmlRows[count], "SEMAIL"));
                }
                return xmlpara;
            }
            function trim(str) {
                var re = /^\s+|\s+$/g;
                return str.replace(re, '');
            }
            function address_requestdata(event) {
                if (!event) {
                    event = window.event;
                }

                var nodeIdx = event.nodeIdx;

                if (typeof nodeIdx == 'undefined' && arguments.length > 0) {
                    nodeIdx = arguments[0].nodeIdx;
                }

                var childxml = get_Address_childXML(AddressTreeView.getvalue(nodeIdx, "folderid"), AddressTreeView.getvalue(nodeIdx, "ownerid"), AddressTreeView.getvalue(nodeIdx, "type"))
                AddressTreeView.putchildxml(nodeIdx, childxml);
            }
            function address_requestdata_(pNodeID, pTreeID) {
                var nodeIdx = window.event.nodeIdx;
                var childxml = get_Address_childXML(AddressTreeView.getvalue(nodeIdx, "folderid"), AddressTreeView.getvalue(nodeIdx, "ownerid"), AddressTreeView.getvalue(nodeIdx, "type"));
                AddressTreeView.putchildxml(nodeIdx, childxml);
            }
            function pagemove(direction) {
                if (direction == 0) {
                    if (event.keyCode == 13) {
                        page = txt_PageInputNum.value;

                        if (page != 0) {
                            if (page > 0 && page <= parseInt(td_pageCount.innerText)) {
                                address_selectnode("page");
                            }
                        }
                    }
                }
                else {
                    page = parseInt(page) + parseInt(direction);

                    if (page != 0) {
                        if (page > 0 && page <= parseInt(td_pageCount.innerText)) {
                            address_selectnode("page");
                        }
                    }
                }

                return false;
            }
            function OnlyNumber() {
                if ((event.keyCode < 48) || (event.keyCode > 57)) {
                    event.returnValue = false;
                }
            }
            function check_presence() {
            }
            function on_keydown() {
                if (window.event.keyCode == "13")
                    inputAddress();
            }
            function inputAddress() {
            	var strName = document.getElementById("emailname").value;
                var strEmail = document.getElementById("emailaddr").value.trim();
            	
                if (strName == "") {
                    document.getElementById("emailname").focus();
                    alert(strLang196);
                    return;
                } else if (strEmail == "") {
                    document.getElementById("emailaddr").focus();
                    alert(strLang197);
                    return;
                }
                
                if (strName.indexOf("&") > -1 || strName.indexOf("<") > -1 || strName.indexOf(">") > -1 
		        		 || strName.indexOf('\"') > -1 || strName.indexOf("'") > -1 || strName.indexOf(";") > -1) {
	           		alert("<spring:message code='ezEmail.psb17' /> [ & < > \" ' ; ]");
               		document.getElementById("emailname").focus();
		            return;
		        }
                
                var emailMatch = /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9_-]+\.[a-zA-Z0-9_.-]+$/;
                if (!emailMatch.test(strEmail)) {
                    alert(strLang198);
                    document.getElementById("emailaddr").focus();
                    return;
                }

                var strNameXml = MakeXMLString(strName);
                var maxNameLength = maxTotalLength - strEmail.length;

                if (maxNameLength > 0) {
                    strNameXml = strNameXml.substring(0, maxNameLength);
                }

                var pparsingXML = "";
                var pparsingXML2 = "";
                var listid = "MsgToList";
                pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
                pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strName) + "</DATA1>";
                pparsingXML = pparsingXML + "<DATA2>" + strEmail + "</DATA2>";
                pparsingXML = pparsingXML + "<DATA3></DATA3>";
                pparsingXML = pparsingXML + "<VALUE>" + strNameXml + " &lt;" + strEmail + "&gt;" + "</VALUE></CELL></ROW>";
                pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
                Resultxml = loadXMLString(pparsingXML2);
                var listview = new ListView();
                listview.LoadFromID(listid);
                var MaxID = 0;
                var InitTr = listview.GetDataRows();
                for (var z = 0; z < InitTr.length; z++) {
                    if (InitTr[z].getAttribute("data2") == strEmail) {
                        alert("<spring:message code='ezEmail.lhm15' />");
                        return;
                    }
                }
				
                if (type == "") {
                	if (!increaseReceiverCount()) {
		        		return;
		        	}
            	}
                
                for (var j = 0  ; j < InitTr.length  ; j++) {
                    var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
                    if (MaxID < curnum)
                        MaxID = curnum;
                }
                var objTr = listview.AddRow(InitTr.length);
                SetAttribute(objTr, "id", listview.GetSelectedRowID(InitTr.length).substring(0, listview.GetSelectedRowID(InitTr.length).lastIndexOf('_') + 1) + (MaxID + 1));
                listview.AddDataRow(objTr, Resultxml);

                document.getElementById(listid).className = "receiver_list";
                var _tdlength = document.getElementById(listid).getElementsByTagName("TD").length;
                for (var y = 0; y < _tdlength; y++) {
                    document.getElementById(listid).getElementsByTagName("TD")[y].style.textOverflow = "";
                    document.getElementById(listid).getElementsByTagName("TD")[y].style.overflow = "";
                }
                
                document.getElementById("emailname").value = "";
                document.getElementById("emailaddr").value = "";
            }
            var dropelement = "";
            function onDragEnter(evt, obj) {
                evt.stopPropagation();
                evt.preventDefault();
                evt.dataTransfer.dropEffect = "copy";
                evt.dataTransfer.effectAllowed = "copy";
                dropelement = obj.id;
            }
            function onDrop(evt, element) {
                evt.stopPropagation();
                evt.preventDefault();
                InsertReceiver(element);
            }

            function event_listdragend(evt) {
                evt.stopPropagation();
                evt.preventDefault();
                if (dropelement != "")
                    InsertReceiver(document.getElementById(dropelement));
            }
            
            function event_listdragstart(obj) {
                dropelement = "";
                var islist = false;
                if (m_selectedTree == AddressListView) {
                    var pListViewDL = new ListView();
                    pListViewDL.LoadFromID("Address");
                    for (var i = 0; i < pListViewDL.GetSelectedRows().length; i++) {
                        if (pListViewDL.GetSelectedRows()[i].id == obj.id) {
                            islist = true;
                            break;
                        }
                    }
                    if (!islist)
                        obj.onclick();
                }
                else if (m_selectedTree == ListViewDL) {
                    var pListViewDL = new ListView();
                    pListViewDL.LoadFromID("pListViewDL");
                    for (var i = 0; i < pListViewDL.GetSelectedRows().length; i++) {
                        if (pListViewDL.GetSelectedRows()[i].id == obj.id) {
                            islist = true;
                            break;
                        }
                    }
                    if (!islist)
                        obj.onclick();
                }
                else if (m_selectedTree == orglistView) {
                    for (var i = 0; i < listContentArry.length; i++) {
                        if (listContentArry[i] == obj.getAttribute("id")) {
                            islist = true;
                            break;
                        }
                    }
                    if (!islist)
                        event_listclick(obj);
                }
                else if (m_selectedTree == ListViewSharedMailbox) {
                    var pListViewSharedMailbox = new ListView();
                    pListViewSharedMailbox.LoadFromID("pListViewSharedMailbox");
                    for (var i = 0; i < pListViewSharedMailbox.GetSelectedRows().length; i++) {
                        if (pListViewSharedMailbox.GetSelectedRows()[i].id == obj.id) {
                            islist = true;
                            break;
                        }
                    }
                    if (!islist)
                        obj.onclick();
                }
            }
            
            window.ondragover = function () {
                dropelement = "";
            }
            
            var BlockSize2 = 5;
            function td_Create2(strtext) {
                document.getElementById("tblPageRayer2").innerHTML = strtext;
            }
            function makePageSelPage2() {
                var strtext2;
                var PagingHTML2 = "";
                document.getElementById("tblPageRayer2").innerHTML = "";
                strtext2 = "<div class='pagenavi'>";
                PagingHTML2 += strtext2;
                var pageNum2 = CurPage;
                if (totalPage2 > 1 && pageNum2 != 1) {
                    strtext2 = "<span class='btnimg first' onclick= 'return goToPageByNum2(1)'></span>";
                    PagingHTML2 += strtext2;
                }
                else {
                    strtext2 = "<span class='btnimg first disabled'></span>";
                    PagingHTML2 += strtext2;
                }
                if (totalPage2 > BlockSize2) {
                    if (pageNum2 > BlockSize2) {
                        strtext2 = "<span class='btnimg prev' onclick= 'return selbeforeBlock2()'></span>";
                        PagingHTML2 += strtext2;
                    }
                    else {
                        strtext2 = "<span class='btnimg prev disabled'></span>";
                        PagingHTML2 += strtext2;
                    }
                }
                else {
                    strtext2 = "<span class='btnimg prev disabled'></span>";
                    PagingHTML2 += strtext2;
                }
                var MaxNum2;
                var i;
                var startNum2 = (parseInt((pageNum2 - 1) / BlockSize2) * BlockSize2) + 1;
                if (totalPage2 >= (startNum2 + parseInt(BlockSize2))) {
                    MaxNum2 = (startNum2 + parseInt(BlockSize2)) - 1;
                }
                else {
                    MaxNum2 = totalPage2;
                }
                for (i = startNum2; i <= MaxNum2; i++) {
                    if (i == pageNum2) {
                        strtext2 = "<span class='on'>" + i + "</span>";
                        PagingHTML2 += strtext2;
                    }
                    else {
                        strtext2 = "<span onclick='goToPageByNum2(" + i + ")'>" + i + "</span>";
                        PagingHTML2 += strtext2;
                    }
                }
                if (MaxNum2 == 0) {
                	PagingHTML2 += "<span class=\"on\">" + 1 + "</span>";
                }
                if (totalPage2 > BlockSize2) {
                    if (totalPage2 >= parseInt(((parseInt((pageNum2 - 1) / BlockSize2) + 1) * BlockSize2) + 1)) {
                        strtext2 = "";
                        strtext2 = strtext2 + "<span class='btnimg next' onclick='return selafterBlock2()'></span>";
                        PagingHTML2 += strtext2;
                    }
                    else {
                        strtext2 = "";
                        strtext2 = strtext2 + "<span class='btnimg next disabled'></span>";
                        PagingHTML2 += strtext2;
                    }
                }
                else {
                    strtext2 = "";
                    strtext2 = strtext2 + "<span class='btnimg next disabled'></span>";
                    PagingHTML2 += strtext2;
                }
                if (totalPage2 > 1 && totalPage2 != 1 && (totalPage2 != pageNum2)) {
                    strtext2 = "<span class='btnimg last' onclick='return goToPageByNum2(" + totalPage2 + ")'></span>";
                    PagingHTML2 += strtext2;
                }
                else {
                    strtext2 = "<span class='btnimg last disabled'></span>";
                    PagingHTML2 += strtext2;
                }
                PagingHTML2 += "</div>";
                td_Create2(PagingHTML2);
            }
            function goToPageByNum2(Value) {
                CurPage = Value;
                makePageSelPage2();
                movePage2(CurPage);
            }
            function selbeforeBlock2() {
                var pageNum = parseInt(CurPage);
                pageNum = ((parseInt(pageNum / BlockSize2) - 1) * BlockSize2) + 1;
                goToPageByNum2(pageNum);
            }
            function selbeforeBlock_one2() {
                var pageNum = parseInt(CurPage);
                if (parseInt(pageNum - 1) > 0)
                    goToPageByNum2(parseInt(pageNum - 1));
                else
                    return;
            }
            function selafterBlock2() {
                var pageNum = parseInt(CurPage);
                pageNum = ((parseInt((pageNum - 1) / BlockSize2) + 1) * BlockSize2) + 1;
                goToPageByNum2(pageNum);
            }
            function selafterBlock_one2() {
                var pageNum = parseInt(CurPage);
                if (parseInt(pageNum + 1) <= totalPage2)
                    goToPageByNum2(parseInt(pageNum + 1));
                else
                    return;
            }
            function movePage2(newPage2) {
                if (parseInt(newPage2) > 0 && parseInt(newPage2) <= parseInt(totalPage2)) {
                    CurPage = newPage2;
                    if (issearch){
                        search_click();
                    }else {
                        if (selTab.indexOf("orgJobMstListView") > -1) {
                        	orgJobMstUserList();
                        } else {
	                    	displayUserList();
                        }
                    }
                }
            }
            function prevPage_onclick2() {
                newPage2 = parseInt(CurPage) - 1;
                if (newPage2 > 0) {
                    CurPage = newPage2;
                    if (issearch)
                        search_click();
                    else
                        displayUserList();
                }
            }
            function nextPage_onclick2() {
                newPage2 = parseInt(CurPage) + 1;
                if (newPage2 <= parseInt(totalPage)) {
                    CurPage = newPage2;
                    if (issearch)
                        search_click();
                    else
                        displayUserList();
                }
            }
            function methodForTabAction(target) {
            	var tabIds = ["orgTabButton", "contactTabButton", "dlTabButton", "inputTabButton", "sharedMailboxTabButton",
            	              "orgJobMasterTabButton1", "orgJobMasterTabButton2"]
            	var targetTab = tabIds[target-1];
            	
            	$.each(tabIds, function(i,d) {
        			var setVal = targetTab == d ? "tabon" : "";
        			document.getElementById(d).children[0].className = setVal;
        		})
            }
            
	        function setOrganListType(pListType) {
	        	$.ajax({
	        		type : "POST",
	        		dataType : "text",
	        		url : "/ezOrgan/setListType.do",
	        		async : false,
	        		data : {
	        			listType : pListType
	        		},
	        		success : function(result) {
	        			
	        		}
	        		
	        	})
	        }
	        
	        function getOrganListType() {
	        	var organListType = "TXT";
	        	$.ajax({
	        		type : "POST",
	        		dataType : "text",
	        		url : "/ezOrgan/getListType.do",
	        		async : false,
	        		success : function(result) {
	        			organListType = result;
	        		}
	        	})
	        	return organListType;
	        }
	        
	        //2018-08-01 김보미 - 부서명 [사원수] 길이가 길면 조정하는 함수
	        function deptNameLong(containLow, strIsLeaf) {
	        	var deptNameWidth = "";
	        	var sum = $("#spn_deptName").width() + $("#countInfo").width();
	        	
	          	if (containLow == "YES" && strIsLeaf != "TRUE") { //하위가 있고, 표기방식이 [1명/ 전체10명]일 경우
	          		if (sum > 365) {
	          			deptNameWidth = 366 - $("#countInfo").width();
	          		}
	          	} else {
	          		if (sum > 363) {
	          			deptNameWidth = 364 - $("#countInfo").width();
	          		}
	          	}
	        	
	        	$("#spn_deptName").css("width", deptNameWidth);
	        }
	        
	        /* 2018-09-04 홍승비 - 탭메뉴 마우스오버 시 하이라이트 설정 */
	        function tabover(tabObj) {
	        	tabObj.setAttribute("class", "tabon");
	        }
	        function tabout(tabObj) {
	        	if (tabObj.id != selSpan) {
	        		tabObj.setAttribute("class", "");
	        	}
	        }
	        
	        function getGroupAddressMemberCount(addressId) {
	        	var count = $.ajax({
	            	type : "GET",
	            	dataType : "text",
	            	url : "/ezAddress/getGroupAddressMemberCount.do",
	            	data : {id : addressId},
	            	async : false
	            }).responseText;
	        	
	        	return parseInt(count);
	        }
	        
	        function increaseReceiverCount(pType, pHref) {
	        	if (typeof pType !== 'undefined' && typeof pHref !== 'undefined') {
	        		if (pType == "mailgroup") {
	        			var addressId = pHref.split("|!|")[0];
	        			var count = getGroupAddressMemberCount(addressId);
	        			
	        			if (mailMaxReceiverCount < receiverCount + count) {
	        				alert(strLangReceiverCount01 + mailMaxReceiverCount + strLangReceiverCount02);
	        	            return false;
	        			}
	        			
	        			groupAddressCountMap[addressId] = count;
	        			receiverCount += count;
	        		} else {
	        			if (mailMaxReceiverCount < receiverCount + 1) {
	        				alert(strLangReceiverCount01 + mailMaxReceiverCount + strLangReceiverCount02);
	        	            return false;
	        			}
	        			
	        			receiverCount += 1;
	        		}
	        	} else {
	        		if (mailMaxReceiverCount < receiverCount + 1) {
	        			alert(strLangReceiverCount01 + mailMaxReceiverCount + strLangReceiverCount02);
	                    return false;
	        		}
	        		
	        		receiverCount += 1;
	        	}
	        	
	        	return true;
	        }

	        function decreaseReceiverCount(pType, pHref) {
	        	if (typeof pType !== 'undefined' && typeof pHref !== 'undefined') {
	        		if (pType == "mailgroup") {
	        	    	var addressId = pHref.split("|!|")[0];
	        	    	receiverCount -= groupAddressCountMap[addressId];
	        	    	delete groupAddressCountMap[addressId];
	        	    } else {
	        	    	receiverCount -= 1;
	        	    }
	        	} else {
	        		receiverCount -= 1;
	        	}
	        }
	        
	        function checkMailWriteWindow(){
	        	setInterval(function(){ 
	        		if (isIE()) {
		        		if(window.opener.closed) {
		        			window.close();
		        		} 
	        		} else {
	        			if(!window.opener) {
	        				window.close();
	        			}
	        		}
	        	}, 500);
	        }
	        
	        function distributionListSet(url) {
	            // useShowAllCompanies config가 YES일 경우 그룹사 전체 조직도를 대상으로 검색하기 위해 company 패러메터를 빈 값으로 추가함.
	        	var dlList_URL = "/ezEmail/mailGetDistribution.do?company=";
	        	if (typeof url != "undefined" && url.trim() != "") {
	        		dlList_URL = url;
	        	}
	        	
	        	try {
					var xmlHTTP = createXMLHttpRequest();
		            xmlHTTP.open("POST", dlList_URL, false);
		            xmlHTTP.send("");
		            
		            if (xmlHTTP.status != 200) {
			            alert("<spring:message code='ezEmail.t574' />" + xmlHTTP.status);
		            } else {
		            	document.getElementById("ListViewDL").innerHTML = "";
			            var pListViewDL = new ListView();
			            pListViewDL.SetID("pListViewDL");
			            pListViewDL.SetSelectFlag(false);
			            pListViewDL.SetMulSelectable(true);
			            pListViewDL.SetUseCheckBox(useOrgListCheckBox);
			            pListViewDL.SetRowOnDblClick("ListViewNodeDblClick");
			            pListViewDL.DataSource(loadXMLString(document.getElementById("listviewheader3").innerHTML.toUpperCase()));
			            pListViewDL.DataBind("ListViewDL");
			            pListViewDL.DataSource(loadXMLString(xmlHTTP.responseText));
			            pListViewDL.RowDataBind();
			
			            var dataRows = pListViewDL.GetDataRows();
			            var dataRowCount = pListViewDL.GetRowCount();
			            
			            for (var i = 0; i < dataRowCount; i++) {
			                dataRows[i].draggable = true;
			                if (CrossYN())
			                    dataRows[i].ondragstart = function (event) { event_listdragstart(this); event.dataTransfer.setData('text/plain', 'dragged'); };
			                else
			                    dataRows[i].ondragstart = function (event) { event_listdragstart(this); };

							// 2024-07-05 김대현 #140902 사파리만 event_listdragend 넣어 중복으로 InsertReceiver()를 실행하여 생기는 현상으로 지워도 동작하기 때문에 해당 함수 주석처리 
				            //     if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
			                //     dataRows[i].ondragend = function (event) { event_listdragend(event); };
			                // }
			            }
			            
			            changeCheckBox();
		            }
		            
		            xmlHTTP = null;
		        } catch (e) {
		            alert("<spring:message code='ezEmail.t574' />" + e.description);
		            xmlHTTP = null;
		            return;
		        }
	        }
	        
	        function changeUserDlType() {
	        	var dlList_URL = "/ezEmail/searchUserDistribution.do?searchValue=&listType=mailUser";
				var userDlType = document.querySelector("#dlSearch_case").value;  
	        	document.querySelector("#dlSearch_text").value = "";
	        	
	        	if (userDlType == "include") {
	        		dlList_URL = "/ezEmail/mailGetUserDistribution.do?type=include&listType=mailUser";
	        	} else if (userDlType == "owner") {
	        		dlList_URL = "/ezEmail/mailGetUserDistribution.do?type=owner&listType=mailUser";
	        	} else {
	        		var pListViewDL = new ListView();
		            pListViewDL.SetID("pListViewDL");
		            pListViewDL.SetSelectFlag(false);
		            pListViewDL.SetMulSelectable(true);
		            pListViewDL.SetRowOnDblClick("ListViewNodeDblClick");
		            pListViewDL.DataBind("ListViewDL");
		            pListViewDL.DataSource("");
		            pListViewDL.RowDataBind();
		            
		            return;
	        	}
	        	
	        	distributionListSet(dlList_URL);
	        }
	        
	        function dlSearch_press(e) {
	        	if (window.event) {
	                if (window.event.keyCode == 13) {
	                	dlSearch_click("search");
	                }
	            }
	            else {
	                if (e.which == 13)
	                	dlSearch_click("search");
	            }
	        }
	        
	        function dlSearch_click() {
	        	var userDlType = document.querySelector("#dlSearch_case").value;  
	        	var searchValue = document.querySelector("#dlSearch_text").value;
	        	var dlList_URL = "/ezEmail/searchUserDistribution.do";
	        	var param = "?searchValue=" + encodeURIComponent(searchValue) + "&searchRange=" + userDlType + "&listType=mailUser";
				
	        	if (userDlType == "search") {
	        		dlList_URL = "/ezEmail/mailGetUserDistributionSearchAll.do"; // 전체 검색
	        	}
	        	
	        	if (searchValue.trim() == "") {
	        		alert("<spring:message code='ezEmail.t10' />");
	                keyword.focus();
	                changeUserDlType();
	                return;
	        	}

	        	distributionListSet(dlList_URL + param);
	        }

			<c:if test="${useShowAllCompanies eq 'YES'}">
				var companySearchWidth = 1115;

				function resizeWindowWidth() {
					if (pListType == "TXT" && issearch && window.innerWidth <= companySearchWidth) {
						window.resizeTo(window.outerWidth - window.innerWidth + companySearchWidth, window.outerHeight);
					}
				}
			</c:if>
	        
	        function orgJobMasterTabButton_onClick(tabType) { // 조직도(직위, 직책)
	        	var tabNum = tabType == 1 ? 6 : 7; // 1=직위, 2=직책
	        	methodForTabAction(tabNum);
	        	
	        	selTab = "orgJobMstListView" + tabType;
		        selSpan = "orgJobMstSpan" + tabType;
		        
		        $.each(m_tabDialogState, function(i,d) {
        			var setVal = ("orgJobMst"+tabType) == i ? "select" : "normal";
        			m_tabDialogState[i] = setVal;
        		});
		        clearOrgTab("orgJobMst");
		        TreeViewTD.style.display = "block";
		        ListViewTD.style.display = "none";
		        ListViewDLTD.style.display = "none";
		        ListViewSharedMailboxTD.style.display = "none";
		        ListViewINPUT.style.display = "none";
		        dlmember.style.display = "none";
		        sharedMailboxMember.style.display = "none";
		        AddrSearch.style.display = "none";
		        m_selectedTree = orglistView;

		        $(".txtlist_DeptTD").css("display", "table-cell");
		        
		        orgJobMasterListSet(tabType);
	        }
	        
	        function orgJobMasterListSet(type) {
	        	try {
	        		var pType = type == 1 ? "POS" : "TIT";
	        		
	                var xmlpara = createXmlDom();
	                var xmlTree = createXmlDom();
	                var xmlHTTP = createXMLHttpRequest();
	                var objNode;
	                var topID = useShowAllCompanies == "YES" ? "Top/organ" : "Top";
	                
	                createNodeInsert(xmlpara, objNode, "DATA");
	                createNodeAndInsertText(xmlpara, objNode, "COMID", "");
	                createNodeAndInsertText(xmlpara, objNode, "TOPID", topID);
	                createNodeAndInsertText(xmlpara, objNode, "PROP", "mail");
	                createNodeAndInsertText(xmlpara, objNode, "TYPE", pType);
	                
	                xmlHTTP.open("POST", "/ezOrgan/getCompanyJobTreeInfo.do", false);
	                xmlHTTP.send(xmlpara);
	                xmlTree = loadXMLString(xmlHTTP.responseText);
	                var treeXML = loadXMLFile("/xml/common/organtree_config3.xml");
	               

	                var treeView = new TreeView();
	                treeView.SetConfig(treeXML);
	                treeView.SetID("FromTreeView");
	                treeView.SetUseAgency(true);
	                treeView.SetUseCheckBox(useOrgListCheckBox);
	                treeView.SetRequestData("orgJobMstCompanyClick"); 
	                treeView.SetNodeClick("orgJobMstClick");
	                treeView.DataSource(xmlTree);
	                treeView.DataBind("TreeView");
	
	                if (strSearch != "") {
	                    document.getElementById('keyword').value = strSearch;
	                    search_click();
	                }
	                
	                changeCheckBox();
	            }
	            catch (ErrMsg) {
	                alert("TreeViewinitialize : " + ErrMsg.description);
	            }
	        }
	        
	        function orgJobMstClick(i) {
	        	CurPage = "1";
	        	var thisNode = document.getElementById(i);
	        	var thisNode_jobChk = thisNode.getAttribute("isjob");
	        	listContentArry = new Array();
	        
	        	if (thisNode_jobChk != null && thisNode_jobChk) {
	        		orgJobMstUserList();
	        	} else { // company
		        	document.getElementById("SelectDeptNM").innerHTML = "";
	                pListXML_Info = "";
	                DisplayUserImageList();
	        	}
	        }
	        
	        function orgJobMstUserList() {
	        	var treeView = new TreeView();
	            treeView.LoadFromID("FromTreeView");
	            var treeViewSelectNode = treeView.GetSelectNode();
	            
        		var jobId = treeViewSelectNode.GetNodeData("cn");
        		var comId = treeViewSelectNode.GetNodeData("comid");
        		var jobType = treeViewSelectNode.GetNodeData("jobtype");
        		var jobName = treeViewSelectNode.GetNodeData("value");
        		
				$.ajax({
					type : "POST",
					url : "/ezOrgan/getJobMasterMemberList.do",
					dataType : "text",
					data : {
						type : jobType,
						jobID : jobId,
						pageNum : CurPage,
						cell : "company;description;displayName;title;telephoneNumber", 
						prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2;department;userType",
						searchType : "",
						searchValue : "",
						comID : comId
					}, success : function(result) {
						pListXML_Info = loadXMLString(result);
		        		var totalCnt = pListXML_Info.getElementsByTagName("TOTALCOUNT")[0].textContent;
		        		
						document.getElementById("SelectDeptNM").innerHTML 
							= "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"padding-right:3px; \" >"
			            	+ "<span id='spn_deptName' title='" + jobName + "'>" + jobName + "</span>"
			            	+ "<span id='countInfo'>&nbsp;<span class='txt_color'> " + totalCnt + "</span></span>";
						
		                pSeach = false;
		                DisplayUserImageList();
		                makePageSelPage2();
					}, error : function (error) {
						alert("error : " + error);
					}
				});
	        }
	       
	        function orgJobMstCompanyClick(pNodeID, pTreeID) {
				var TreeIdx = pNodeID;
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(TreeIdx);
	            var deptID = treeNode.GetNodeData("CN");
	            GetCompanySubTreeInfo(deptID, TreeIdx);
	        }
	        
	        function GetCompanySubTreeInfo(comID, TreeIdx) {
	        	var jobMstType = selTab == "orgJobMstListView1" ? "POS" : "TIT";
	        	
	            var xmlHTTP = createXMLHttpRequest();
	            var xmlRtn = createXmlDom();
	            var xmlpara = createXmlDom();
	            var objNode;
	            createNodeInsert(xmlpara, objNode, "DATA");
	            createNodeAndInsertText(xmlpara, objNode, "COMID", comID);
	            createNodeAndInsertText(xmlpara, objNode, "TYPE", jobMstType);
	            xmlHTTP.open("POST", "/ezOrgan/getJobMasterTreeInfo.do", false);
	            xmlHTTP.send(xmlpara);
	            xmlRtn = loadXMLString(xmlHTTP.responseText);
	            if (SelectNodes(xmlRtn, "NODES/NODE/VALUE").length > 0) {
	                if (CrossYN()) {
	                    xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
	                }
	                else {
	                    xmlRtn.selectNodes("NODES/NODE")[0].appendChild(xmlRtn.selectNodes("NODES/NODE/VALUE")[0]);
	                }
	            }
	            var treeView = new TreeView();
	            treeView.LoadFromID("FromTreeView");
                treeView.SetUseCheckBox(useOrgListCheckBox);
	            treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
	            
	            changeCheckBox();
	        }
	        
	        function clearOrgTab(type) { // org or orgJobMst
	        	document.getElementById('TreeView').innerHTML = "";
	        	document.getElementById("SelectDeptNM").innerHTML = "";
                
                var searchSelectObj = document.getElementById('search_type');
                searchSelectObj.setAttribute("data-type", type);
				
                document.getElementById("keyword").value = "";
                issearch = false;
                
                var hide_orgJobMstSearchOpt = [
                	{"name":"extensionAttribute10", "usedefault":"1", "msg":"<spring:message code='ezEmail.t281' />"},
                	{"name":"title", "usedefault":"1", "msg":"<spring:message code='ezEmail.t28' />"},
                	{"name":"description", "usedefault":"1", "msg":"<spring:message code='ezEmail.t26' />"},
                ];
                
                // 부서선택 버튼명 변경
                var deptSelectBtnNm = selTab == "orglistView" ? "<spring:message code='ezEmail.t596' />" : selTab == "orgJobMstListView1" 
                		? "<spring:message code='ezOrgan.ksaOrganList04' />" : "<spring:message code='ezOrgan.ksaOrganList05' />";
                $("#dept_select > span").text(deptSelectBtnNm);
                
                $.each(hide_orgJobMstSearchOpt, function(i,e) {
                	var searchOpt = $("#search_type option[value='"+e.name+"']");
               		if (type == "org" && searchOpt.length < 1) {
                   		var tempOpt = "<option value="+e.name+" usedefault="+e.usedefault+">"+e.msg+"</option>";
                   		$(tempOpt).insertAfter("#search_type option[value='displayname']");
                   	} else if (type == "orgJobMst") {
                   		searchOpt.remove();
                   	}
                });
	        }
	        
			var emailAttrArr = {
	    		"orglistView":"_data3",
	    		"AddressListView":"data3",
	    		"ListViewDL":"data2",
	    		"ListViewSharedMailbox":"data2"
	    	};
			
			// 전체 선택
			$(document).on("click", ".checkAll", function(obj) {
				event.stopImmediatePropagation();
				
				var Is_checked = this.checked;
				var selectTreeId = m_selectedTree.id;
				var selectTR;
				
				if (Is_checked) {
					selectTR = $("#"+selectTreeId+" tr["+emailAttrArr[selectTreeId]+"!=''] input:not('.checkAll')");
				} else {
					selectTR = $("#"+selectTreeId+" input:checked");
				}
				
				$.each(selectTR, function (i, e) {
					var thisParent = $(this).parents("tr")[0];
					var thisParentEmail = getObjEmail(thisParent, "checkUser");
					var IsInsert = CheckMailReceiver(thisParentEmail, "3");
					
					if ((Is_checked && !IsInsert) || (!Is_checked && IsInsert)) {
						$(this).click();
					}
				});
			});
			
			$(document).on("click", ".checkUser, .checkDept", function() {
				event.stopImmediatePropagation();

				var Is_checked = this.checked;
				var thisClassName = this.className;

				var thisParentTag = thisClassName == "checkUser" ? "tr" : "div";
				var thisParent = $(this).parents(thisParentTag)[0];
				var thisParentEmail = getObjEmail(thisParent, thisClassName);
				var IsInsert = CheckMailReceiver(thisParentEmail, "3");
				
				var insertFunction = function() { thisClassName == "checkUser" ? ListViewNodeDblClick() : dept_select(thisParent) };
				
				if (Is_checked) {
					if (!IsInsert) {
						insertFunction();
						
						IsInsert = CheckMailReceiver(thisParentEmail, "3");
						if (!IsInsert) {$(this).prop("checked", false);  }
					} else {
						$(this).prop("checked", false);
		            	alert("<spring:message code='ezOrgan.ksaOrganList03' />");
					}
				} else {
					if (IsInsert) { 
						receiverList_Delete(thisParentEmail, thisClassName);
					}
				}
			});

			function getObjEmail(obj, type) {
		    	var selectTreeId = m_selectedTree.id;
				var emailAttr = type == "checkUser" ? emailAttrArr[selectTreeId] : "mail";
				var emailStr = obj.getAttribute(emailAttr);
				
				var Is_addressGroupMail = (selectTreeId == "AddressListView" && obj.getAttribute("data2") == "mailgroup");
				if (Is_addressGroupMail) { // 그룹 주소
					var addressID = obj.getAttribute("data1");
					var addressFolderType = obj.getAttribute("data4");
					
					emailStr = addressID + "|!|" + addressFolderType;
				} 
				
				return emailStr;
			}

			function receiverList_Delete(objEmail, type) {
				if (objEmail.indexOf("@") > -1) {
					$("#"+receiverListId+" tr[data2='"+objEmail+"']").click();
				} {
					$("#"+receiverListId+" tr[data4='"+objEmail+"']").click(); // 그룹메일
				}

				DeleteReceiver(m_selectedWindow);
			}
			
			function InsertReceiver_CheckBox(listid, ele) {
		    	if (!useOrgListCheckBox) {return; }
		    	
				if (receiverListId == listid) { 
					$("#"+ele.id+ " > .checkUser:input").prop("checked", true);
					$("#"+ele.id+ " > .checkDept:input").prop("checked", true);

					var selectTreeId = m_selectedTree.id;
					if (selectTreeId == "orglistView") { // 조직도, 직위, 직책 사용자 리스트에 겸직이 있을 경우. 겸직도 체크
	                 	var n_email = ele.getAttribute("_data3");
                 		$("#"+selectTreeId+" tr[_data3='"+n_email+"'] input").prop("checked", true);		    		
    		    	}
                }
			}

			function DeleteReceiver_CheckBox(listid, ele) {
		    	if (!useOrgListCheckBox) {return; }
				
				 if (receiverListId == listid) { 
					var selectTreeId = m_selectedTree.id;
			    	var emailAttr = emailAttrArr[selectTreeId];
                 	var n_email = ele.getAttribute("data2");
                 	
                 	if (n_email == "mailgroup") {//주소록 그룹메일
                 		var addrGroupMail_ID = ele.getAttribute("data4").split("|")[0];
	                 	$("#" + selectTreeId + " tr[data1='"+addrGroupMail_ID+"'] input").prop("checked", false);
                 	} else {
	                 	$("#" + selectTreeId + " tr["+emailAttr+"='"+n_email+"'] input").prop("checked", false);
                 	}
                 	
                 	if (selectTreeId == "orglistView") {
                 		$("#FromTreeView div[mail='"+n_email+"'] > input").prop("checked", false);		    		
    		    	}
                 }
			}
			
			// 수신자설정,탭 변경 시
		    function changeCheckBox() {
		    	if (!useOrgListCheckBox) {return; }
		    	
		    	var selectTreeId = m_selectedTree.id;
		    	var emailAttr = emailAttrArr[selectTreeId];
		    	
		    	var receiverList = $("#" + receiverListId + " tbody tr");
		    	
		    	$("#" + selectTreeId + " input[type='checkbox']").prop("checked", false);
		    	if (selectTreeId == "orglistView") {
			    	$("#FromTreeView input[type='checkbox']").prop("checked", false);		    		
		    	}
		    	$.each(receiverList, function (i,e) {
		    		var n_email = e.getAttribute("data2");
		    		
		    		if (n_email == "mailgroup") {//주소록 그룹메일
                 		var addrGroupMail_ID = e.getAttribute("data4").split("|")[0];
	                 	$("#" + selectTreeId + " tr[data1='"+addrGroupMail_ID+"'] input").prop("checked", true);
                 	} else {
	                 	$("#" + selectTreeId + " tr["+emailAttr+"='"+n_email+"'] input").prop("checked", true);
                 	}
		    		
		    		if (selectTreeId == "orglistView") {
				    	$("#FromTreeView div[mail='"+n_email+"'] > input").prop("checked", true);		    		
			    	}
		    	});
		    }

		</script>
	</head>
	<body class="popup" onkeydown="event_listOnkeyDown(event);" onkeyup="event_listOnkeyUp(event);" style="overflow:hidden">
		<xml id="listviewheader" style="display: none;">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <NAME><spring:message code='ezEmail.t586' /></NAME>
		        <WIDTH>40</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME>EMAIL</NAME>
		        <WIDTH>100</WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
		<xml id="listviewheader2" style="display: none;">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>	
		        <NAME><spring:message code='ezEmail.t31' /></NAME>
		        <WIDTH>60</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME></NAME>
		        <WIDTH>70</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezEmail.t28' /></NAME>
		        <WIDTH>50</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezEmail.t29' /></NAME>
		        <WIDTH>70</WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
		<xml id="listviewheader3" style="display: none;">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <NAME><spring:message code='ezEmail.t57' /></NAME>
		        <WIDTH></WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
		<xml id="listviewheader4" style="display: none;">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <NAME><spring:message code='ezEmail.t31' /></NAME>
		        <WIDTH>60</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezEmail.t712' /></NAME>
		        <WIDTH>65</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME>Email</NAME>
		        <WIDTH></WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
		<xml id="listviewheader5" style="display: none;">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <NAME><spring:message code='ezEmail.sharedMailbox02' /></NAME>
		        <WIDTH></WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
	    <h1 id="h1Title"><spring:message code='ezEmail.t572' /></h1>
	    <div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
        <div id="mailReceiverInfoTxt" style="margin-bottom: 7px; display:none; ">
			<span>※ <spring:message code='ezEmail.ksa15' /></span>
		</div>
		<div class="portlet_tabpart01" style="margin:0px;">
			<div class="portlet_tabpart01_top" id="tab1" style="margin-bottom:3px;">
				<p id="orgTabButton">
					<span id="orgSpan" onclick="orgTabButton_onClick()" onmouseover="tabover(this)" onmouseout="tabout(this)"><spring:message code='ezEmail.t591' /></span>
				</p>
				<p id="orgJobMasterTabButton1">
					<span id="orgJobMstSpan1" onclick="orgJobMasterTabButton_onClick(1)" onmouseover="tabover(this)" onmouseout="tabout(this)"><spring:message code='ezOrgan.ksaOrganList01' /></span>
				</p>
				<p id="orgJobMasterTabButton2">
					<span id="orgJobMstSpan2" onclick="orgJobMasterTabButton_onClick(2)" onmouseover="tabover(this)" onmouseout="tabout(this)"><spring:message code='ezOrgan.ksaOrganList02' /></span>
				</p>
				<p id="contactTabButton">
					<span id="contactSpan" onclick="contactTabButton_onClick()" onmouseover="tabover(this)" onmouseout="tabout(this)"><spring:message code='ezEmail.t592' /></span>
				</p>
				<p id="dlTabButton">
					<span id="dlSpan" onclick="dlTabButton_onClick()" onmouseover="tabover(this)" onmouseout="tabout(this)"><spring:message code='ezEmail.t593' /></span>
				</p>
				<p id="sharedMailboxTabButton" style="display: none;">
					<span id="sharedMailboxSpan" onclick="sharedMailboxTabButton_onClick()" onmouseover="tabover(this)" onmouseout="tabout(this)"><spring:message code='ezEmail.sharedMailbox02' /></span>
				</p>
				<p id="inputTabButton" style="display: none;">
					<span id="inputSpan" onclick="inputTabButton_onClick()" onmouseover="tabover(this)" onmouseout="tabout(this)"><spring:message code='ezEmail.t244' /></span>
				</p>
			</div>
		</div>
	    <table style="width:100%;">
	        <tr>
	            <td style="vertical-align: top;">
	                <%-- <div id="tabnav" style="float: left; width: 100%;">
	                    <ul>
	                        <li id="orgTabButton"><span onclick="orgTabButton_onClick()">
	                            <spring:message code='ezEmail.t591' /></span></li>
	                        <li id="contactTabButton"><span onclick="contactTabButton_onClick()">
	                            <spring:message code='ezEmail.t592' /></span></li>
	                        <li id="dlTabButton"><span onclick="dlTabButton_onClick()">
	                            <spring:message code='ezEmail.t593' /></span></li>
	                        <li id="inputTabButton" style="display: none;"><span onclick="inputTabButton_onClick()"><spring:message code='ezEmail.t244' /></span></li>
	                    </ul>
	                </div>
	                <script type="text/javascript">
	                    selToggleList(document.getElementById("tabnav"), "ul", "li", "1");
	                </script> --%>
	                <table id="TreeViewTD">
	                    <tr>
	                        <td>
	                            <div class="portlet_tabpart03" style="background-color: #f1f3f5; margin: 0px; padding: 0px; border: 1px solid #eaeaea;">
	                                <div class="portlet_tabpart03_top" id="tab1" style="border-bottom: 0px; height:26px;">
	                                    <table style="margin-top: 2px; width: 100%;">
	                                        <tr>
	                                            <td>
	                                                <div style="margin-left: 5px;">
	                                                    <select id="search_type" data-type="org">
	                                                        <option selected value="displayname" usedefault="1"><spring:message code='ezEmail.t31' /></option>
	                                                        <option value="description" usedefault="1"><spring:message code='ezEmail.t26' /></option>
	                                                        <option value="title" usedefault="1"><spring:message code='ezEmail.t28' /></option>
                                      		                <option value="extensionAttribute10" usedefault="1"><spring:message code='ezEmail.t281' /></option>
	                                                        <option value="telephonenumber" usedefault="1"><spring:message code='ezEmail.t99000045' /></option>
	                                                        <option value="mobile" usedefault="0"><spring:message code='ezEmail.t99000046' /></option>
	                                                        <option value="HomePhone" usedefault="0"><spring:message code='ezEmail.t29' /></option>
	                                                        <option value="facsimileTelephoneNumber" usedefault="0"><spring:message code='ezEmail.t99000047' /></option>
	                                                        <option value="mail" usedefault="0"><spring:message code='ezEmail.t99000048' /></option>
	                                                        <c:if test="${primaryLang eq '3' }">
	                                                        <option value="extensionPhone" usedefault="0"><spring:message code='main.ksa02' /></option>
	                                                        <option value="officeMobile" usedefault="0"><spring:message code='main.ksa03' /></option>
	                                                        </c:if>
	                                                        <option value="streetAddress" usedefault="0" style="display:none"><spring:message code='ezEmail.t99000049' /></option>
	                                                    </select>
	                                                    <input id="keyword" value="" onkeypress="search_press(event)" onmousedown="keyword_Clear();" style="width: 130px; margin: 0px; height:21px">
	                                                    <a class="imgbtn"><span onclick="search_click('search')"><spring:message code='ezEmail.t37' /></span></a>
	
	                                                </div>
	                                            </td>
	                                            <td>
	                                                <div style="float: right; margin-right: 5px; position: relative;">
	                                                    <a class="imgbtn" id="dept_select"><span onclick="dept_select()" style="z-index:10"><spring:message code='ezEmail.t596' /></span></a>
	                                                    <a class="imgbtn"><span onclick="infoview_click()"><spring:message code='ezEmail.t597' /></span></a>
	                                                </div>
	                                            </td>
	                                        </tr>
	                                    </table>
	                                </div>
	                            </div>
	                            <table style="margin-top: 3px;">
	                                <tr>
	                                    <td class="box" style="border-right:0px">
	                                        <div id="TreeView" style="width: 220px; height: 474px; overflow-x: auto; overflow-y: auto;" ></div>
	                                    </td>
	                                    <td></td>
	                                    <td class="listview" style="min-width: 66.5%" id="orglistView">
	                                        <table style="width: 100%; margin-top: -1px;" class="popup_mainlist">
	                                            <tr style="height:35px">
	                                                <th style="white-space:normal;background-color: white;border-top:1px solid #ddd;border-bottom:1px solid #eaeaea">
														<span id="SelectDeptNM" style="font-weight: normal; width: 385px; height: 18px; white-space: nowrap; overflow: hidden; display: inline-block; vertical-align: top;"></span>
	                                                    <span style="float:right; position: relative;">
	                                                        <span onclick="ChangeListView_onClick('TXT');">
	                                                            <img src="/images/kr/cm/btn_list.gif" class="icon_btn" id="txtlist"></span>
	                                                        <span onclick="ChangeListView_onClick('IMG');">
	                                                            <img src="/images/kr/cm/btn_imglist.gif" class="icon_btn" id="imglist"></span>
	                                                    </span>
	                                                </th>
	                                            </tr>
	                                        </table>
	                                        <div id="txtlist_Layer" style="vertical-align: top; width: 100%; height: 395px; overflow: auto;" >
	                                            <table style="width: 100%; border: 1px solid #ddd; display: none;" id="txtlist_table" class="mainlist">
	                                                <tr>
	                                                    <td style="width: 100px;color:#333;background-color: #f1f3f5;"  class="txtlist_DeptTD none"><spring:message code='ezEmail.t26' /></td>
	                                                    <td style="width: 120px;color:#333;background-color: #f1f3f5"><spring:message code='ezEmail.t31' /></td>
	                                                    <td style="color:#333;background-color: #f1f3f5"><spring:message code='ezEmail.t28' /></td>
	                                                    <td style="width: 100px;color:#333;background-color: #f1f3f5"><spring:message code='ezEmail.t99000045' /></td>
	                                                </tr>
	                                            </table>
	                                            <table style="width: 100%; border: 1px solid #ddd; display: none;" id="Search_txtlist_table" class="mainlist">
	                                                <tr>
														<c:if test="${useShowAllCompanies eq 'YES'}">
															<td style="width: 110px; color:#333;background-color: #f1f3f5" class="td_gray"><spring:message code='ezPersonal.t67' /></td>
														</c:if>
	                                                    <td style="width: 110px; color:#333;background-color: #f1f3f5" class="td_gray"><spring:message code='ezEmail.t26' /></td>
	                                                    <td style="width: 90px; color:#333;background-color: #f1f3f5" class="td_gray"><spring:message code='ezEmail.t31' /></td>
	                                                    <td style="color:#333;background-color: #f1f3f5" class="td_gray"><spring:message code='ezEmail.t28' /></td>
	                                                    <td class="td_gray" style="width: 100px;color:#333;background-color: #f1f3f5"><spring:message code='ezEmail.t99000045' /></td>
	                                                </tr>
	                                            </table>
	                                        </div>
	                                        <div style="vertical-align: top; text-align: center; height: 395px; overflow: auto; display: none; width: 100%;" id="DeptUserImgList"></div>
	                                        <div id="tblPageRayer2"  style="text-align:center;"></div>
	                                	</td>
	                                </tr>
	                            </table>
	                        </td>
	                    </tr>
	                </table>
	                <table id="ListViewTD" style="display: none">
	                    <tr>
	                        <td colspan="3">
	                            <table style="width: 100%;">
	                                <tr>
	                                    <td id="AddrSearch">
	                                        <div class="portlet_tabpart03" style="background-color: #f1f3f5; margin: 0px; padding: 0px; border: 1px solid #eaeaea;">
	                                            <div class="portlet_tabpart03_top" id="Div1" style="border-bottom: 0px; height:26px;">
	                                                <table style="margin-top: 4px; width: 100%;">
	                                                    <tr>
	                                                        <td>
	                                                            <div style="margin-left: 5px;">
	                                                                <select name="search_case" id="search_case" style="padding-right:28px;">
	                                                                    <option value="S_NAME">
	                                                                        <spring:message code='ezEmail.t31' /></option>
	                                                                    <option value="S_COMPANY">
	                                                                        <spring:message code='ezEmail.t712' /></option>
	                                                                    <option value="S_EMAIL">
	                                                                        <spring:message code='ezEmail.t713' /></option>
	                                                                </select>
	                                                                <input id="search_text" value="" onkeyup="AddrSearch_press()" style="width: 130px; margin: 0px; height:21px" name="Input">
	                                                                <a class="imgbtn">
	                                                                    <span onclick="AddrSearch_click()"><spring:message code='ezEmail.t37' /></span>
	                                                                </a>
	
	                                                            </div>
	                                                        </td>
	                                                        <td>
	                                                            <div style="float: right; margin-right: 5px;">
	                                                                <a class="imgbtn"><span onclick="groupmember_click()"><spring:message code='ezEmail.t598' /></span></a>
	                                                            </div>
	                                                        </td>
	                                                    </tr>
	                                                </table>
	                                            </div>
	                                        </div>
	                                    </td>
	                                </tr>
	                            </table>
	                        </td>
	                    </tr>
	                    <tr>
	                        <td>
	                            <div id="AddressTreeView" style="overflow-x: auto; overflow-y: auto; width: 221px; height: 472px;  border: 1px solid #ddd; background-color: #FFFFFF; padding-top:5px;border-right:0px;"></div>
	                        </td>
	                        <td></td>
	                        <td style="vertical-align: top; width: 100%;">
	                            <div style="vertical-align: middle; border: 1px solid #ddd; border-bottom: 0px; height: 23px; padding-top: 7px; padding-left: 5px;">
	                                <img src="" align="absmiddle" hspace="2" style="cursor: pointer; margin-right:0px;" />
	                                <span id="addressFolderName" style="font-weight: normal;"></span>
	                                &nbsp;<span id="addressFolderCnt" class='txt_color'></span>
	                            </div>
	                            <div id="AddressListView" class="border_gray" style="height: 399px; overflow: auto; background-color: #ffffff; border-bottom:0px; border-top: 1px solid #eaeaea">
	                            </div>
	                            <div id="tblPageRayer" style="left: 446px; vertical-align: middle; border: 1px solid #ddd; border-top: 0px; width:auto !important"></div>
	                            <div id="tblpage" style="display: none; padding-top: 2px; text-align: center; vertical-align: middle; left: 446px; border: 1px solid #ddd; border-top: 0px; height: 27px;">
	                                <spring:message code='ezEmail.t588' /><span class='txt_color' style="font-weight: bold;" id="totalcount"></span>
	                                <spring:message code='ezEmail.t589' /><span id="td_Previous" onclick="pagemove(-1)"><img src="/images/kr/cm/btn_prev.gif"
	                                    width="15" height="15" align="absmiddle" hspace="2" style="cursor: pointer"></span><spring:message code='ezEmail.t590' /><span
	                                        id="td_pageCount"></span>
	                                <spring:message code='ezEmail.t97' />
	                                <input type="text" id="txt_PageInputNum" name="txt_PageInputNum" onkeyup="pagemove('0')"
	                                    size="4" onselectstart="event.cancelBubble=true;event.returnValue=true" onkeypress="OnlyNumber()"
	                                    style="ime-mode: disabled">
	                                <span id="td_Next" onclick="pagemove('1')">
	                                    <img src="/images/kr/cm/btn_next.gif" width="15" height="15" align="absmiddle" hspace="2"
	                                        style="cursor: pointer" /></span>
	                            </div>
	                        </td>
	                    </tr>
	                </table>
	                <table id="ListViewDLTD" style="display: none">
	                    <tr>
	                        <td style="width: 100vw;">
	                            <div class="portlet_tabpart03" style="background-color: white; margin: 0px; padding: 0px; border: 1px solid #eaeaea;">
	                                <div class="portlet_tabpart03_top" id="Div2" style="border-bottom: 0px; height:26px;">
	                                    <table style="margin-top: 4px; width: 100%;">
	                                        <tr>
	                                        	<c:if test="${useUserDefinedDL eq 'YES' }" >
	                                         	<td>
                                                    <div style="margin-left: 5px;">
                                                        <select name="dlSearch_case" id="dlSearch_case" style="padding-right:28px;" onChange="changeUserDlType()">
                                                            <option value="include">
                                                                <spring:message code='ezEmail.userDL17' /></option>
                                                            <option value="owner">
                                                                <spring:message code='ezEmail.userDL16' /></option>
                                                            <option value="search">
                                                                <spring:message code='ezEmail.userDL40' /></option>
                                                        </select>
                                                        <input id="dlSearch_text" value="" onkeyup="dlSearch_press()" style="width: 130px; margin: 0px; height:21px" name="Input">
                                                        <a class="imgbtn">
                                                            <span onclick="dlSearch_click()"><spring:message code='ezEmail.t37' /></span>
                                                        </a>

                                                    </div>
                                                </td>
                                                </c:if>
	                                            <td id="dlmember" style="display: none">
	                                                <a class="imgbtn" style="float: right; margin-right: 5px;"><span onclick="dlmember_click()">
	                                                    <spring:message code='ezEmail.t598' /></span></a>
	                                            </td>
	                                        </tr>
	                                    </table>
	                                </div>
	                            </div>
	                            <div style="width: 100%; height: 474px; overflow: auto; background-color: #ffffff; margin-top: 3px;" id="ListViewDL" class="border_gray" data-type="dist">
	                            </div>
	                        </td>
	                    </tr>
	                </table>
	                <table id="ListViewSharedMailboxTD" style="display: none">
	                    <tr>
	                        <td style="width: 100vw;">
	                            <div class="portlet_tabpart03" style="background-color: white; margin: 0px; padding: 0px; border: 1px solid #eaeaea;">
	                                <div class="portlet_tabpart03_top" id="Div2" style="border-bottom: 0px; height:26px;">
	                                    <table style="margin-top: 4px; width: 100%;">
	                                        <tr>
	                                            <td id="sharedMailboxMember" style="display: none">
	                                                <a class="imgbtn" style="float: right; margin-right: 5px;"><span onclick="sharedMailboxMember_click()">
	                                                    <spring:message code='ezEmail.sharedMailbox21' /></span></a>
	                                            </td>
	                                        </tr>
	                                    </table>
	                                </div>
	                            </div>
	                            <div style="width: 100%; height: 474px; overflow: auto; background-color: #ffffff; margin-top: 3px;" id="ListViewSharedMailbox" class="border_gray" data-type="shared">
	                            </div>
	                        </td>
	                    </tr>
	                </table>
	                <table id="ListViewINPUT" style="width: 100%; display: none">
	                    <tr>
	                        <td>
	                            <div id="ManualView" style="HEIGHT: 507px;" class="box">
	                                <table class="content" style="margin:5px">
	                                    <tr>
	                                        <th><spring:message code='ezEmail.t31' /></th>
	                                        <td>
	                                            <input type="text" id="emailname" style="WIDTH: 100%; ime-mode: active; box-sizing: border-box; -moz-box-sizing: border-box;">
	                                        </td>
	                                    </tr>
	                                    <tr>
	                                        <th><spring:message code='ezEmail.t35' /></th>
	                                        <td>
	                                            <input type="text" id="emailaddr" style="WIDTH: 100%; ime-mode: inactive; box-sizing: border-box; -moz-box-sizing: border-box;" onkeyup="return on_keydown()">
	                                        </td>
	                                    </tr>
	                                </table>
	                               <%-- <div style="padding-top: 10px; text-align: center;"><a class="imgbtn"><span onclick="inputAddress()"><%=RM.GetString("t308")%></span></a></div>--%>
	                            </div>
	                        </td>
	                    </tr>
	                </table>
	            </td>
	             <td style="vertical-align: top;width: 280px;<c:if test="${type eq 'auto'}">display:none;</c:if>">
	                <table id="listType1" style="margin-top:1px;">
	                    <tr id="ListMsgTo">
	                        <td style="width: 30px; text-align: center;">
	                            <img src="/images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0"
	                                style="cursor: pointer;margin-top:22px" onclick="InsertReceiver(ListViewMsgTo)"><br>
	                            <img src="/images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0"
	                                style="cursor: pointer;" onclick="DeleteReceiver(ListViewMsgTo)">
	                        </td>
	                        <td style="vertical-align: top;">
	                            <h2 id="ToTitle" class="receiver_tltype01" onclick="SelectReceiverWindow(ToTitle,ListViewMsgTo)" style="cursor: pointer;">
	                                <span style="min-width: 45px;" id="ToTitleStr"><spring:message code='ezEmail.t66' /></span>
	                            </h2>
	                            <div class="receiver_borderbox">
	                                <div id="ListViewMsgTo" ondragover ="onDragEnter(event, this)" ondrop ="onDrop(event, this)" style="width: 250px; Height: 134px; overflow-x: auto; overflow-y: auto;" onclick="SelectReceiverWindow(ToTitle,this)" ondblclick="DeleteReceiver(ListViewMsgTo)"></div>
	                            </div>
	                        </td>
	                    </tr>
	                    <tr id="ListMsgCC">
	                        <td style="width: 30px; text-align: center;">
	                            <br />
	                            <img src="/images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0"
	                                style="cursor: pointer;margin-top:22px" onclick="InsertReceiver(ListViewMsgCC)"><br>
	                            <img src="/images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0"
	                                style="cursor: pointer;" onclick="DeleteReceiver(ListViewMsgCC)">
	                        </td>
	                        <td style="vertical-align: top;">
	                            <h2 id="CCTitle" class="receiver_tltype02" onclick="SelectReceiverWindow(CCTitle,ListViewMsgCC)" style="cursor: pointer;">
	                                <span style="min-width: 45px;"><spring:message code='ezEmail.t594' /></span>
	                            </h2>
	                            <div class="receiver_borderbox">
	                                <div id="ListViewMsgCC" ondragover ="onDragEnter(event, this)" ondrop ="onDrop(event, this)" style="width: 250px; Height: 134px; overflow-x: auto; overflow-y: auto;" onclick="SelectReceiverWindow(CCTitle,this)" ondblclick="DeleteReceiver(ListViewMsgCC)"></div>
	                            </div>
	                        </td>
	                    </tr>
	                    <tr id="ListMsgBCC">
	                        <td style="width: 30px; text-align: center;">
	                            <br />
	                            <img src="/images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0"
	                                style="cursor: pointer;margin-top:22px" onclick="InsertReceiver(ListViewMsgBCC)"><br>
	                            <img src="/images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0"
	                                style="cursor: pointer;" onclick="DeleteReceiver(ListViewMsgBCC)">
	                        </td>
	                        <td style="vertical-align: top;">
	                            <h2 id="BCCTitle" class="receiver_tltype02" onclick="SelectReceiverWindow(BCCTitle,ListViewMsgBCC)" style="cursor: pointer;">
	                                <span style="min-width: 45px;"><spring:message code='ezEmail.t562' /></span>
	                            </h2>
	                            <div class="receiver_borderbox">
	                                <div id="ListViewMsgBCC" ondragover ="onDragEnter(event, this)" ondrop ="onDrop(event, this)" style="width: 250px; Height: 141px; overflow-x: auto; overflow-y: auto;" onclick="SelectReceiverWindow(BCCTitle,this)" ondblclick="DeleteReceiver(ListViewMsgBCC)"></div>
	                            </div>
	                        </td>
	                    </tr>
	                 </table> 
	             </td> 
	        </tr>
	    </table>
	    <table style="width: 100%; text-align: center;">
	        <tr>
	            <td class="btnposition btnpositionNew" style="text-align: center;">
	                <a class="imgbtn" onclick="confirm_onClick()" id="cmd_ok"><span><spring:message code='ezEmail.t599' /></span></a>
	            </td>
	        </tr>
	    </table>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>
