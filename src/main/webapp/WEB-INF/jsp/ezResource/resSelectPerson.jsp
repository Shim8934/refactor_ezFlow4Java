<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezResource.t128"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezResource.e2', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.lhm01', 'msg')}" type="text/css" />
		<style>
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
	    	.countColor {
	    		color:#017BEC;
	    	}
	    </style>		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezResource/control/TreeView.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezResource/control/TreeViewCtrl.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezResource/control/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezResource.e1', 'msg')}"></script>
		<script type="text/javascript">
			var pListType = "TXT";
		    var UserAgentState = navigator.userAgent.toLowerCase();
		    var browserIE = (CrossYN()) ? true : false;
		    var userlang = "${userLang}";
		    var CurPage = "1";
		    var pListXML_Info = null;
		    var ReturnFunction;
			
		window.onload = window_onload;
		function window_onload() {
		    try {
		        ReturnFunction = opener.select_person_cross_dialogArguments[1];
		    }
		    catch (e) {
		    }

		    window.resizeTo(780, 630);
		    var xmlHTTP = createXMLHttpRequest();
		    xmlHTTP.open("GET", "/xml/organtree_config.xml", false);
		    xmlHTTP.send();

		    if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
		        var treeView = new TreeView();
		        treeView.SetConfig(xmlHTTP.responseXML);
		    }
			
		    var strQuery = "<DATA><DEPTID>${deptID}</DEPTID><TOPID>Top</TOPID><PROP></PROP></DATA>";
		    var xmlHTTP = createXMLHttpRequest();
		    xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
		    xmlHTTP.send(strQuery);

		    TreeViewinitialize("${deptID}", "Top" , "", "${serverName}");
		    ListTypeChangeIcon();
		    
		    ChangeListView_onClick(getOrganListType());
		}

		    function KeEventControl(obj) {
		        useragt = navigator.userAgent.toUpperCase();
		        if (useragt.indexOf("SAFARI") > 0 && useragt.indexOf("CHROME") < 0) //사파리 브라우저일 경우
		        {
		            useragt = useragt.substring(useragt.indexOf("VERSION/") + 8, useragt.indexOf("VERSION/") + 9);
		            if (parseInt(useragt) > 5) {
		                return;
		            }
		        }
		        obj.onkeydown = function () 
		        { 
		            if ( parseInt(window.event.keyCode) >= 48 && parseInt(window.event.keyCode) <= 126)
		                return false;
		            if ( parseInt(window.event.keyCode) == 189 || parseInt(window.event.keyCode) == 187 ||
		                    parseInt(window.event.keyCode) == 220 || parseInt(window.event.keyCode) == 219 ||
		                    parseInt(window.event.keyCode) == 221 || parseInt(window.event.keyCode) == 222 ||
		                    parseInt(window.event.keyCode) == 186 || parseInt(window.event.keyCode) == 188 ||
		                    parseInt(window.event.keyCode) == 190 || parseInt(window.event.keyCode) == 191 || parseInt(window.event.keyCode) == 32)
		                return false;
		        };
		    }

		    function TreeViewNodeClick() {
		        var nodeIdx = 1;
		        issearch = false;
		        CurPage = "1";
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		    
		        var selnode = treeView.GetSelectNode(); 
		    
		        DeptID = selnode.GetNodeData("CN");
		        document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:top;padding-right:3px;\" >" 
	        		+ "<span id='spn_deptName' title='" + selnode.GetNodeData("VALUE") + "'>" + selnode.GetNodeData("VALUE") + "</span>"
	        		+ "<span id='countInfo'></span>";
		        SelectDeptNM.setAttribute("countinfo","")
		        displayUserList(DeptID);
		    }

		    function displayUserList(DeptID) {
	 	        if (DeptID != undefined)
		            tempDeptID = DeptID;

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
      				success : function(data, textStatus, jqXHR) {
      					pListXML_Info = loadXMLString(data);
						pSeach = false;
 		                DisplayUserImageList();
 		                makePageSelPage();
  					},
  					error : function(jqXHR, textStatus, errorThrown) {
  						alert("<spring:message code="ezResource.t2"/>" + textStatus);
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
			        			document.getElementById("countInfo").innerHTML += "-[<span class='countColor'>" + result.totalCount + strLang400 + "</span>/<spring:message code='ezAddress.t362' /> <span class='countColor'>" + result.totalCount2 + strLang400 + "</span>]";
							} else {
								document.getElementById("countInfo").innerHTML += "-[<span class='countColor'>" + result.totalCount + strLang400 + "</span>]";
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

		    function event_displayUserList() {
		        if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
		            if (g_xmlHTTP.statusText == "OK") {
		                pListXML_Info = g_xmlHTTP.responseXML;
		                g_xmlHTTP = null;
		                pSeach = false;
		                DisplayUserImageList();
		                makePageSelPage();
		            }
		            else
		                alert("<spring:message code="ezResource.t2"/>" + g_xmlHTTP.statusText);
		            g_xmlHTTP = null;
		        }
		    }

		    function search_press(e) {
		        if(window.event){
		            if(e.keyCode == 13) {
		            	search_click("search");
		            }
		        } else {
		            if(e.which == 13) {
		            	search_click("search");
		            }
		        }
		    }

		    function deptsearch_press(e) {
		        if(window.event){
		            if(e.keyCode == 13) {
		            	deptsearch_click();
		            }
		        } else {
		            if(e.which == 13) {
		            	deptsearch_click();
		            }
		        }     
		    }
		    var issearch = false;
		    function search_click(type) {
		    	
		    	var keywordLen = document.getElementById("keyword").value.trim().length;
		    	
		        if (keywordLen == 0) {
		            alert("<spring:message code="ezResource.t129"/>");
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
   				success : function(data, textStatus, jqXHR) {
   					pListXML_Info = loadXMLString(data);
					pSeach = true;
		            DisplayUserImageList();
		            makePageSelPage();
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alert("<spring:message code="ezResource.t2"/>" + textStatus);
					}
				}); 
		    }

		    function event_displayUserList2() {
		        if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
		            if (g_xmlHTTP.statusText == "OK") {
		                if (g_xmlHTTP.responseXML.getElementsByTagName("ROW").length == 0) {
		                	alert("<spring:message code="ezResource.t5"/>");
		                } else {
		                    pListXML_Info = g_xmlHTTP.responseXML;
		                    pSeach = true;
		                    DisplayUserImageList();
		                    makePageSelPage();
		                }
		            } else {
		            	alert("<spring:message code="ezResource.t4"/>" + g_xmlHTTP.statusText)
		            }
		            g_xmlHTTP = null;
		        }
		    }
			
		    var checkdeptname_cross_dialogArguments = new Array();
		    function deptsearch_click() {
		    	
		    	var deptKeyworLen = document.getElementById("deptkeyword").value.trim().length;
		    	
		        if (deptKeyworLen == 0) {
		            alert("<spring:message code="ezResource.t129"/>");
		            document.getElementById("deptkeyword").focus();
		            return;
		        }
		        
		        var xmlDOM = createXmlDom();
		        
		        $.ajax({
					url : '/ezOrgan/getSearchList.do',
					method : 'POST',
					dataType : "xml",
					async : false,
					data : {search : "displayname::" + document.all("deptkeyword").value, cell : "extensionAttribute3;displayname;extensionAttribute9;", prop : "", type : 'group'}, 
   					success : function(result) {
   						xmlDOM = result
   						var row = SelectNodes(xmlDOM, "LISTVIEWDATA/ROWS/ROW");
	                	adCount = row.length;
						},
					error : function(jqXHR, textStatus, errorThrown) {
						alert("<spring:message code="ezResource.t2"/>" + textStatus);
						xmlDOM = null;
					}
				}); 
		       
		        if (adCount == 0) {
		            alert("<spring:message code="ezResource.t130"/>");
		            return;
		            
		        } else if (adCount == 1) {
		            g_xmlHTTP = createXMLHttpRequest();
		            var Node = SelectNodes(xmlDOM, "LISTVIEWDATA/ROWS/ROW/CELL/DATA2");
		            var strQuery = "<DATA><DEPTID>" + getNodeText(Node[0]) + 
		                    "</DEPTID><TOPID>Top</TOPID><PROP></PROP></DATA>";
		            g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		            g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
		            g_xmlHTTP.send(strQuery);
		        } else  {
		            var rgParams = new Array();
		            rgParams["addrBook"] = xmlDOM;
		            rgParams["deptid"] = "";
		            
		            /* 2018-08-08 김민성 - 자원등록 > 관리자 선택시 부서검색 수정  */
		            checkdeptname_cross_dialogArguments[0] = rgParams;
	            	checkdeptname_cross_dialogArguments[1] = deptsearch_click_Complete;
		            
		            if (CrossYN()) {
		                //DivPopUpShow(609, 352, "/ezResource/checkDeptName.do");
		            	 var OpenWin = window.open("/ezResource/checkDeptName.do", "", GetOpenWindowfeature(600, 320));
		             	 OpenWin.focus(); 
		            } else {
		                var feature =  GetShowModalPosition(600, 320);
		                var result = window.showModalDialog("/ezResource/checkDeptName.do", rgParams, "dialogHeight:320px; dialogWidth:600px; status:no;scroll:no; help:no; edge:sunken;"+feature);
						
		                if (rgParams["deptid"] != "") {
		                    g_xmlHTTP = createXMLHttpRequest();
		                    var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>Top</TOPID><PROP>mail</PROP></DATA>";
		                    g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		                    g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
		                    g_xmlHTTP.send(strQuery);
		                }
		            }
		        }
		    }
		    function deptsearch_click_Complete(retVal) {
		        if (retVal["deptid"] != "") {
		            g_xmlHTTP = createXMLHttpRequest();
		            var strQuery = "<DATA><DEPTID>" + retVal["deptid"] + "</DEPTID><TOPID>Top</TOPID><PROP>mail</PROP></DATA>";
		            g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		            g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
		            g_xmlHTTP.send(strQuery);
		        }
		        DivPopUpHidden();
		    }
			
		    function event_getDeptFullTree() {
		        if(g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
		            if (g_xmlHTTP.statusText == "OK") {
		                var xmlDom = createXmlDom();
		                xmlDom.async = false;
		                xmlDom = loadXMLFile("/xml/organtree_config.xml");
		                document.getElementById('TreeView').innerHTML = "";
		                var treeView = new TreeView();
		                treeView.SetID("FromTreeView");
		                treeView.SetUseAgency(true);
		                treeView.SetRequestData("TreeViewRequestData");
		                treeView.SetNodeClick("TreeViewNodeClick");
		                treeView.SetNodeDblClick("TreeViewNodeDbClick");
		                treeView.DataSource(loadXMLString(g_xmlHTTP.responseText));
		                treeView.DataBind("TreeView");
		            } else {
		                alert("<spring:message code="ezResource.t6"/>" + g_xmlHTTP.statusText)
		                g_xmlHTTP = null;
		            }
		        }
		    }

		    function select_member() {
		        if(p_ListOrderObject == null) {
		        	return;
		        }
		            
		        if(p_ListOrderObject.getAttribute("_DATA1").toLowerCase() == "user") {
		            var UserNm;
		            var UserID;
		            var UDeptNm;
		            if (userlang == "" || userlang == "1") {
		                UserNm	 = p_ListOrderObject.getAttribute("_DATA10");
		                UserPos  = p_ListOrderObject.getAttribute("_DATA14");
		                UDeptNm	 = p_ListOrderObject.getAttribute("_DATA12");
		            } else {
		                UserNm	 = p_ListOrderObject.getAttribute("_DATA11");
		                UserPos  = p_ListOrderObject.getAttribute("_DATA15");
		                UDeptNm	 = p_ListOrderObject.getAttribute("_DATA13");
		            }
		            var UserID	 = p_ListOrderObject.getAttribute("_DATA2");
		            var UDeptID	 = DeptID;
		            var UserCall = p_ListOrderObject.getAttribute("_DATA8");
		            var strRtnVal= UserNm + ";" + UserID + ";" + UserPos + ";" + UDeptNm + ";" + UDeptID + ";" + UserCall;
				
		            if (ReturnFunction != null) {
		                ReturnFunction(strRtnVal);
		            } else {
		                window.returnValue = strRtnVal;
		            }
		            window.close();
		        }
		    }

		    function ChangeListView_onClick(Div) {
		        pListType = Div;
		        ListTypeChangeIcon();
		        DisplayUserImageList();
		        setOrganListType(pListType);
		    }

		    function ListTypeChangeIcon() {
		        if (pListType == "IMG") {
		            document.getElementById("imglist").setAttribute("src", "/images/kr/cm/btn_onimglist.gif");
		            document.getElementById("txtlist").setAttribute("src", "/images/kr/cm/btn_list.gif");
		        } else {
		            document.getElementById("imglist").setAttribute("src", "/images/kr/cm/btn_imglist.gif");
		            document.getElementById("txtlist").setAttribute("src", "/images/kr/cm/btn_onlist.gif");
		        }
		    }

		    var pSeach = false;
		    function DisplayUserImageList() {
		        var xmlRtn = pListXML_Info;

		        document.getElementById("DeptUserImgList").innerHTML = "";
		        document.getElementById("txtlist_Layer").scrollTop = "0";
		        totalPage = 1;
		        /* 2018-04-30 서주연 #12557 */
		        totalPage = Math.ceil(new Number(getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) / 50));

		        document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes
		        while (document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.length > 1) {
		            document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).removeChild(document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.item(1));
		        }
		        while (document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.length > 1) {
		            document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).removeChild(document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.item(1));
		        }
		        var UserListHTML = "";
		        /* if (SelectDeptNM.getAttribute("countinfo") != "1" && getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) != null && getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0])!= "") {
		        	if (getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) ==  getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT2")[0])) {
	        			SelectDeptNM.innerHTML += "-[<span style='color:#017BEC;'>" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) + strLang400 + "</span>]";
	        		} else {
	        			SelectDeptNM.innerHTML += "-[<span style='color:#017BEC;'>" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) + "/" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT2")[0]) + strLang400 + "</span>]";
	        		}
		        	
		            SelectDeptNM.setAttribute("countinfo","1")
		        } */
		        
		        if (pListType == "IMG") {
		            document.getElementById("DeptUserImgList").style.display = "";
		            document.getElementById("txtlist_Layer").style.display = "none";
		            document.getElementById("txtlist_table").style.display = "none";
		            document.getElementById("Search_txtlist_table").style.display = "none";
		            if (pSeach) {
		                document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;\" >" + strLang401 + "" + "-[<span style='color:#017BEC;'>" + SelectSingleNodeValueNew(xmlRtn,"LISTVIEWDATA/TOTALCOUNT") + strLang400 + "</span>]";
		                SelectDeptNM.setAttribute("countinfo", "1")
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
		                document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;\" >" + strLang401 + "" + "-[<span style='color:#017BEC;'>" + SelectSingleNodeValueNew(xmlRtn,"LISTVIEWDATA/TOTALCOUNT") + strLang400 + "</span>]";
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
		                M_TR.style.cursor = "pointer";
		                M_TR.onmouseover = function () { event_listMover(this); };
		                M_TR.onmouseout = function () { event_listMout(this); };
		                M_TR.onclick = function () { event_listclick(this); };
		                M_TR.ondblclick = function () { select_member(); };
		                
		                if (CrossYN()) {
		                    for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.length; NodeCount++) {
		                        if (SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName != "#text") {
		                            M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
		                                              trim_Cross(SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).textContent));
		                        }
		                    }
	                    }  else {
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
		                if ("${useOCS}" == "YES") {
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
		                M_TR.style.cursor = "pointer";
		                M_TR.onmouseover = function () { event_listMover(this); };
		                M_TR.onmouseout = function () { event_listMout(this); };
		                M_TR.onclick = function () { event_listclick(this); };
		                M_TR.ondblclick = function () { select_member(); };
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
		                    if ("${useOCS}" == "YES") {
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
		                    
		                    if ("${useOCS}" == "YES") {		                    	
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
		    var m_strColorSelect = "#e4e8ec";
		    var m_strColorOver = "#f4f5f5";
		    var m_strColorDefault = "#ffffff";
		    var p_ListOrderObject = null;
		    function event_listMover(obj) {
		        if (p_ListOrderObject != obj ) {
		            for (var RowCnt = 0; RowCnt < obj.childNodes.length; RowCnt++) {
		                obj.childNodes.item(RowCnt).style.backgroundColor = m_strColorOver;
		            }
		        }
		    }
		    function event_listMout(obj) {
		        if (p_ListOrderObject != obj ) {
		            for (var RowCnt = 0; RowCnt < obj.childNodes.length; RowCnt++) {
		                obj.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
		            }
		        }
		    }
		    function event_listclick(obj) {
		        if (p_ListOrderObject != obj && p_ListOrderObject != null) {
		            for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
		                p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
		            }
		        }
		        p_ListOrderObject = obj;
		        for (var RowCnt = 0; RowCnt < obj.childNodes.length; RowCnt++) {
		            obj.childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
		        }
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
		            strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' ></span>";
		            PagingHTML += strtext;
		        } else {
		            strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' ></span>";
		            PagingHTML += strtext;
		        }
		        if (totalPage > BlockSize) {
		            if (pageNum > BlockSize) {
		                strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif' ></span>";
		                PagingHTML += strtext;
		            } else {
		                strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' ></span>";
		                PagingHTML += strtext;
		            }
		        } else {
		            strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' ></span>";
		            PagingHTML += strtext;
		        }
		        var MaxNum;
		        var i;
		        var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;
		        if (totalPage >= (startNum + parseInt(BlockSize))) {
		            MaxNum = (startNum + parseInt(BlockSize)) - 1;
		        } else {
		            MaxNum = totalPage;
		        }
		        for (i = startNum; i <= MaxNum; i++) {
		            if (i == pageNum) {
		                strtext = "<span class='on'>" + i + "</span>";
		                PagingHTML += strtext;
		            } else {
		                strtext = "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
		                PagingHTML += strtext;
		            }
		        }
		        if (totalPage > BlockSize) {
		            if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
		                strtext = "";
		                strtext = strtext + "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/sub/btn_next.gif' ></span>";
		                PagingHTML += strtext;
		            } else {
		                strtext = "";
		                strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' ></span>";
		                PagingHTML += strtext;
		            }
		        } else {
		            strtext = "";
		            strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' ></span>";
		            PagingHTML += strtext;
		        }
		        if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
		            strtext = "<span class='btnimg' onclick='return goToPageByNum(" + totalPage + ")'><img src='/images/sub/btn_n_next.gif' ></span>";
		            PagingHTML += strtext;
		        } else {
		            strtext = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif' ></span>";
		            PagingHTML += strtext;
		        }
		        PagingHTML += "</div>";
		        td_Create1(PagingHTML);
		    }
		    function goToPageByNum(Value) {
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
		        if (parseInt(pageNum - 1) > 0) {
		        	MainTable.style.marginTop = "5px";
		        } else {
		        	return;
		        }
		    }
		    function selafterBlock() {
		        var pageNum = parseInt(CurPage);
		        pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
		        goToPageByNum(pageNum);
		    }
		    function selafterBlock_one() {
		        var pageNum = parseInt(CurPage);
		        if (parseInt(pageNum + 1) <= totalPage) {
		        	goToPageByNum(parseInt(pageNum + 1));
		        } else {
		        	return;
		        }
		    }
		    function movePage(newPage) {
		        if (parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
		            CurPage = newPage;
		            if (issearch) {
		            	search_click();
		            } else {
		            	displayUserList();
		            }
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
					if (sum > 339) {
						deptNameWidth = 340 - $("#countInfo").width();
					}
				} else {
					if (sum > 337) {
						deptNameWidth = 338 - $("#countInfo").width();
					}
				}
				
				$("#spn_deptName").css("width", deptNameWidth);
			}
		</script>
	</head>
	<xml id="listviewheader" style="display:none">
  		<LISTVIEWDATA>
    		<HEADERS>
      			<HEADER>
        			<NAME><spring:message code="ezResource.t132"/></NAME>
        			<WIDTH>70</WIDTH>
      			</HEADER>
      			<HEADER>
        			<NAME><spring:message code="ezResource.t9"/></NAME>
        			<WIDTH>50</WIDTH>
      			</HEADER>
      			<HEADER>
        			<NAME><spring:message code="ezResource.t10"/></NAME>
        			<WIDTH>50</WIDTH>
      			</HEADER>      
      			<HEADER>
        			<NAME><spring:message code="ezResource.t11"/></NAME>
        			<WIDTH>70</WIDTH>
      			</HEADER>
    		</HEADERS>
  		</LISTVIEWDATA>
	</xml>
	<body class="popup" >
		<h1><spring:message code="ezResource.t128"/></h1>
		<div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
		<!-- 2018-04-30 서주연 #12556 -->
		<table id="TreeViewTD">
			<tr>
				<td>
    	<%-- <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div> --%>
			    	<div class="portlet_tabpart03" style="background-color: #f8f8f8; margin-top: 4px;">
			        	<div class="portlet_tabpart03_top" id="tab1" style="border:1px solid #d3d2d2;">
				            <table style="margin-top:3px;width:100%;">
			    	          <tr>
			        	        <td>
			            	        <div style="margin-left:5px;">
			                		    <input id="deptkeyword" value="" onkeyup="deptsearch_press(event)" style="width: 130px;height:21px">
			                    		<a class="imgbtn" name="button" onClick="deptsearch_click()"><span><spring:message code="ezResource.t134"/></span></a>
			                    	</div>
			                	</td>
			                	<td>
			                    	<div style="float:right;margin-right:5px;">
			                    		<select id="search_type">
			                    			<option selected value="displayname"><spring:message code="ezResource.t135"/></option>
			                    			<option value="description"><spring:message code="ezResource.t132"/></option>
			                    			<option value="title"><spring:message code="ezResource.t10"/></option>
			                    			<option value="telephonenumber"><spring:message code="ezResource.t11"/></option>
			                    			<option value="mobile"><spring:message code="ezResource.t136"/></option>
			                    			<!-- 2018.02.20 김기하 #11640 -->
			                    			<%-- <option value="HomePhone"><spring:message code="ezResource.t137"/></option> --%>
			                    			<option value="facsimileTelephoneNumber"><spring:message code="ezResource.t138"/></option>
			                    			<option value="mail"><spring:message code="ezResource.t139"/></option>
			                    			<option value="streetAddress"><spring:message code="ezResource.t140"/></option>
			                    		</select>
			                    		<input id="keyword" value="" onkeyup="search_press(event)" style="width: 130px;height:21px">
			                    		<a class="imgbtn" onClick="search_click('search')"><span><spring:message code="ezResource.t141"/></span></a>
			                    	</div>
			                	</td>
			              	</tr>
			            </table>
			        </div>
			    </div>
			    <table style="margin-top: 3px;">
			        <tr>
			            <td class="box">
			            	<div id="TreeView" style="height: 400px; width: 300px; overflow-x: hidden; overflow-y: auto;"></div></td>
			            <td style="width: 5px;">&nbsp;</td>
			            <td class="listview" style="width: 425px;" id="orglistView">
			                <!-- <div id="OrganListView" style="border:0;width: 415px; height: 400px; overflow-x: hidden; overflow-y: auto;"></div> -->
			               	<table style="width: 100%; margin-top: -1px;" class="popup_mainlist">
			                   	<tr>
			                       	<th style="white-space:normal;background-color: white">
			                           	<span id="SelectDeptNM" style="font-weight: normal; width: 359px; white-space: nowrap; overflow: hidden; display: inline-block; vertical-align: bottom;padding-top: 3px;padding-left: 3px;"></span>
			                           	<span style="float: right;">
			                               	<span onclick="ChangeListView_onClick('TXT');">
			                                   	<img src="/images/kr/cm/btn_list.gif" class="icon_btn" id="txtlist">
			                               	</span>
			                               	<span onclick="ChangeListView_onClick('IMG');">
			                                   	<img src="/images/kr/cm/btn_imglist.gif" class="icon_btn" id="imglist">
			                               	</span>
			                           	</span>
			                       	</th>
			                   	</tr>
			               	</table>
			          		<div style="vertical-align:top;height:340px;overflow:auto;width:425px;" id="txtlist_Layer">
			          			<table style="width:100%;border:1px solid #ddd;display:none;" id="txtlist_table" class="mainlist" > 
			              			<tr>
			                  			<td style="width:170px;font-weight:bold;font-weight: normal" class="td_gray"><spring:message code="ezResource.t9"/></td>
			                  			<td style="width:150px;font-weight:bold;font-weight: normal" class="td_gray"><spring:message code="ezResource.t10"/></td>
			                  			<td class="td_gray" style="font-weight:bold;font-weight: normal"><spring:message code="ezResource.t11"/></td>
			              			</tr>
			          			</table>
			          			<table style="width:100%;border:1px solid #ddd;display:none;" id="Search_txtlist_table" class="mainlist" > 
			              			<tr>
			                  			<td style="width:130px;font-weight:bold;" class="td_gray"><spring:message code="ezResource.t132"/></td>
			                  			<td style="width:90px;font-weight:bold;" class="td_gray"><spring:message code="ezResource.t9"/></td>
			                  			<td style="width:90px;font-weight:bold;" class="td_gray"><spring:message code="ezResource.t10"/></td>
			                  			<td class="td_gray" style="font-weight:bold;"><spring:message code="ezResource.t11"/></td>
			              			</tr>
			          			</table>
			          		</div>
					  		<div style="vertical-align:top;text-align:center;height:340px;overflow:auto;display:none;width:425px;" id="DeptUserImgList"></div>
			                <div id="tblPageRayer" style="text-align:center;"></div>
			            	</td>
			        	</tr>
			    	</table>
			    </td>
		    </tr>
		</table>
		<div class="btnpositionNew">
    		<a class="imgbtn" name="Dbutton" onClick="select_member()"><span><spring:message code="ezResource.t15"/></span></a>
		</div>
	</body>
</html>