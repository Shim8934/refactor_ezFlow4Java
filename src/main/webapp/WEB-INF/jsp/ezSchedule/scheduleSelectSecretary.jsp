<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.F0054' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css" />	    
	    <script type="text/javascript" src="${util.addVer('ezOrgan.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/ezOrgan/TreeView.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezOrgan/ListView_list.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>		
		<script type="text/javascript">
			var g_xmlHTTP;
		    var ReturnFunction;
		    var companyID = opener.companyID;
	
		    window.onload = function () {
		        try {
		            ReturnFunction = opener.schedule_select_secretary_cross_dialogArguments[1];
		        } catch (e) {}
		        
		        getDeptFullTree('${companyID}');
		    }
	
		    function Tree_setconfig() {
		        var xmlHTTP = createXMLHttpRequest();
		        xmlHTTP.open("GET", "/xml/common/organtree_config3.xml", false);
		        xmlHTTP.send();
		        
		        if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
		            var treeView = new TreeView();
		            treeView.SetConfig(xmlHTTP.responseXML);
		        }
		    }
	
		    function getDeptFullTree(text) {
				var companyId = text;
		        g_xmlHTTP = createXMLHttpRequest();
		        var strQuery = "<DATA><DEPTID></DEPTID><TOPID>"+companyId+"/other</TOPID><PROP></PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
	
		        g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		        g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
		        g_xmlHTTP.send(strQuery);
		    }
	
		    function event_getDeptFullTree() {        
		        if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
		            if (g_xmlHTTP.status == 200) {
		                Tree_setconfig();	
		                document.getElementById("TreeView").innerHTML = "";
	
		                var treeView = new TreeView();
		                treeView.SetID("FromTreeView");
		                treeView.SetUseAgency(true);
		                treeView.SetRequestData("TreeViewRequestData");
		                treeView.SetNodeClick("TreeViewNodeClick");
		                treeView.DataSource(g_xmlHTTP.responseXML);
		                treeView.DataBind("TreeView");
		            }
		            else {
		                alert("<spring:message code='ezSchedule.t1' />" + g_xmlHTTP.statusText);
		                g_xmlHTTP = null;
		            }
		        }
		    }
	
		    function TreeViewRequestData(pNodeID, pTreeID) {
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
		        createNodeAndInsertText(xmlpara, objNode, "PROP", "");
	
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
		        treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
		    }
	
		    function TreeViewNodeClick() {
		        var nodeIdx = 1;
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        var selnode = treeView.GetSelectNode();
		        DeptID = selnode.GetNodeData("CN");
		        displayUserList(DeptID);
		    }
	
		    function TreeViewNodeDbClick() {
		        return;
		    }
	    
		    function displayUserList(DeptID) {
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
  						prop : "department",  						
  						type : "user"
  					} ,
      				success : function(xml) { 		                		                
 		            	event_displayUserList(xml);
  					},
  					error : function(jqXHR, textStatus, errorThrown) {
  						alert("<spring:message code='ezSchedule.t2' />"+ textStatus);
  					}
	  			});   
	        	 
	    	}
		    
		    function event_displayUserList(xml) {
            	var xmlString = loadXMLString(xml);
            	
                var headerData = createXmlDom();                
                headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());
                
                if (!CrossYN()) {	
                    var xmlRtn = xmlString.documentElement.getElementsByTagName("ROWS")[0];                             
                    var Node = headerData.importNode(xmlRtn, true);
                    headerData.documentElement.appendChild(Node);
                } else {
                    var xmlRtn = xmlString.documentElement.getElementsByTagName("ROWS")[0];
                    headerData.documentElement.appendChild(xmlRtn);
                }
                document.getElementById("OrganListView").innerHTML = "";
                
                var pUserList = new ListView();
                pUserList.SetID("lvUserList");
                pUserList.SetRowOnDblClick("select_member");
                pUserList.SetSelectFlag(false);
                pUserList.SetHeightFree(true);
                pUserList.DataSource(headerData);
                pUserList.DataBind("OrganListView");		       
		    }
		    
		    function search_press() {
		        if (window.event.keyCode == "13")
		            search_click();
		    }
	
		    function deptsearch_press() {
		        if (window.event.keyCode == "13")
		            deptsearch_click();
		    }
		    
		    function search_click() {
		    	if (specialChk(keyword.value)) {
		    		alert("<spring:message code='ezResource.special' />");
		    		return;
		    	}
		    	
		        if (keyword.value == "") {
		            alert("<spring:message code='ezSchedule.t8' />");
		            keyword.focus();
		            return;
		        }
			
		        $.ajax({
					url : '/ezOrgan/getSearchList.do',
					method : 'POST',
					dataType : "text",
					data : {
						search : search_type.value + "::" + keyword.value,
						cell : "company;description;displayName;title;telephoneNumber",
						prop : "department",						
						type : "user",
						company : companyID
					} ,
   					success : function(xml) {
   						event_displayUserList(xml);
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alert("<spring:message code='ezSchedule.t2' />"+ textStatus);
					}
				});		
		    }
	
		    var checkname2_cross_dialogArguments = new Array();
		    function deptsearch_click() {		    	
		    	if (specialChk(deptkeyword.value)) {
		    		alert("<spring:message code='ezResource.special' />");
		    		return;
		    	}
		    	
		        if (deptkeyword.value == "") {
		            alert("<spring:message code='ezSchedule.t8' />");
		            deptkeyword.focus();
		            return;
		        }
		        
		        var xmlDOM = createXmlDom();
		        
		        $.ajax({
					url : '/ezOrgan/getSearchList.do',
					method : 'POST',
					dataType : "text",
					async : false,
					data : {						
						search : "displayname::" + document.all("deptkeyword").value,
						cell : "extensionAttribute3;displayName;extensionAttribute9",
						prop : "",						
						type : "group",
						company : companyID
					} ,
   					success : function(xml) {   						
   						xmlDOM = loadXMLString(xml);
		                adCount = xmlDOM.getElementsByTagName("ROW").length;
					},
					error : function(jqXHR, textStatus, errorThrown) {						
						alert("<spring:message code='ezSchedule.t62' />" + textStatus);
						xmlDOM = null;
					}
				});
	
		        if (adCount == 0) {
		            alert("<spring:message code='ezSchedule.t10' />");
		            return;
		        } else if (adCount == 1) {
		            g_xmlHTTP = createXMLHttpRequest();
		            var strQuery = "<DATA><DEPTID>" + getNodeText(xmlDOM.getElementsByTagName("DATA2").item(0)) + "</DEPTID><TOPID>"+companyID+"</TOPID><PROP></PROP><orgCompanyID>"+companyID+"</orgCompanyID><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
		            g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		            g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
		            g_xmlHTTP.send(strQuery);
		        } else {
		            var rgParams = new Array();		            
		            rgParams["addrBook"] = xmlDOM;
		            rgParams["deptid"] = "";
	            	var feature = "dialogHeight:320px; dialogWidth:600px; status:no;scroll:no; help:no; edge:sunken";
	            	feature = feature + GetShowModalPosition(600, 320);
	            	
	            	if (CrossYN()) {
		                checkname2_cross_dialogArguments[0] = rgParams;
	                	checkname2_cross_dialogArguments[1] = deptsearch_click_Complete;
	                	var OpenWin = window.open("/admin/ezOrgan/checkName2.do", "checkName2_cross", GetOpenWindowfeature(600, 320));
	             	    OpenWin.focus();
	            	} else {
	                	window.showModalDialog("/admin/ezOrgan/checkName2.do", rgParams, feature);

	                	if (rgParams["deptid"] != "") {
		                    bSearch = true;
	                    	g_xmlHTTP = createXMLHttpRequest();
	                    	var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>Top</TOPID><PROP>mail</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
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
		            var strQuery = "<DATA><DEPTID>" + retVal["deptid"] + "</DEPTID><TOPID>Top</TOPID><PROP>mail</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";		            
		            g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		            g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
		            g_xmlHTTP.send(strQuery);
		        }
		        DivPopUpHidden();
		    }
	
		    function select_member() {
		        var listview = new ListView();
		        listview.LoadFromID("lvUserList");
	
		        var length = listview.GetSelectedRows().length;
	
		        if (length == 0) {
		            alert(strLang93);
		            return;
		        }
	
		        /* if (length > 1) {
		            alert(strLang92);
		            return;
		        } */
	
		        var selRow = listview.GetSelectedIndexes();
		        if (ReturnFunction != null)
		            ReturnFunction(listview.GetSelectedRows()[0].getAttribute("DATA2") + ":" + getNodeText(listview.GetSelectedRows()[0].getElementsByTagName('td')[2]) + ":" + listview.GetSelectedRows()[0].getAttribute("DATA3"));
		        else
		            window.returnValue = listview.GetSelectedRows()[0].getAttribute("DATA2") + ":" + listview.GetSelectedRows()[0].getElementsByTagName('td')[2].innerText + ":" + listview.GetSelectedRows()[0].getAttribute("DATA3");
		        window.close();
		    }
		</script>
	</head>
	<body class="popup">
		<xml id="listviewheader" style="display:none">
	    	<LISTVIEWDATA>
	        	<HEADERS>
	          		<HEADER>
	            		<NAME><spring:message code='ezSchedule.t11' /></NAME>
	            		<WIDTH>66</WIDTH>
	          		</HEADER>
	          		<HEADER>
	            		<NAME><spring:message code='ezSchedule.t12' /></NAME>
	            		<WIDTH>100</WIDTH>
	          		</HEADER>
	          		<HEADER>
	            		<NAME><spring:message code='ezSchedule.t13' /></NAME>
	            		<WIDTH>52</WIDTH>
	          		</HEADER>
	          		<HEADER>
	            		<NAME><spring:message code='ezSchedule.t14' /></NAME>
	            		<WIDTH>52</WIDTH>
	          		</HEADER>
	          		<HEADER>
	            		<NAME><spring:message code='ezSchedule.t15' /></NAME>
	            		<WIDTH>85</WIDTH>
	          		</HEADER>
	        	</HEADERS>
			</LISTVIEWDATA>
	    </xml>
	    
	    <h1><spring:message code='ezApprovalG.t424' /></h1>
	    <div id="close"> 
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	    <table>
	    	<tr>
	        	<td style="padding-right:4px">
	        		<div class="box" style="margin-bottom:4px; background-color: #f8f8fa; border: 1px solid #eaeaea; height:26px; display:flex; gap:1px; align-items:center;" >
		                <input id="deptkeyword" onkeypress="deptsearch_press()" style="width:120px; height:22px; margin-left:4px; margin-top :2px;" />
	                	<a class="imgbtn"><span onclick="deptsearch_click()"><spring:message code='ezSchedule.t17' /></span></a>
	            	</div>
	            	<div style="border: 1px solid #ddd; padding-top:2px;height: 444px; width: 280px; overflow-x: auto; overflow-y: auto; background-color: #FFFFFF" id="TreeView"></div>	            	
	        	</td>
	        	<td valign="top">
	        		<div class="box" style="margin-bottom:4px; background-color: #f8f8fa; border: 1px solid #eaeaea; height:26px;" >
		            	<select id="search_type" style="height:22px; margin-bottom:2px; margin-left:4px; margin-top:2px;">
		                	<option selected value="displayname"><spring:message code='ezSchedule.t18' /></option> 
		                  	<option value="description"><spring:message code='ezSchedule.t12' /></option> 
		                  	<option value="title"><spring:message code='ezSchedule.t14' /></option> 
		                  	<option value="telephonenumber"><spring:message code='ezSchedule.t15' /></option> 
		                  	<option value="mobile"><spring:message code='ezSchedule.t19' /></option> 
		                  	<option value="HomePhone"><spring:message code='ezSchedule.t20' /></option> 
		                  	<option value="facsimileTelephoneNumber"><spring:message code='ezSchedule.t21' /></option> 
		                  	<option value="mail"><spring:message code='ezSchedule.t22' /></option> 
		                  	<option value="streetAddress" style="display:none"><spring:message code='ezSchedule.t23' /></option> 
		                </select>
		                <input id="keyword" onkeypress="search_press()" style="width:130px; height:22px; margin-bottom:2px;" />
		                <a class="imgbtn" style="margin-top :2px;"><span onclick="search_click()"><spring:message code='ezSchedule.t24' /></span></a>
		            </div>
	            	<div class="listview" style="border-top:0px;">
	                	<div id="OrganListView" style="border: 0px solid #ddd; Width: 100%; min-width:687px; Height: 446px; overflow: hidden; BACKGROUND-COLOR: white; overflow-x: auto; overflow-y: auto;"></div>
	            	</div>		            
	        	</td>
	      	</tr>
	    </table>	    
	    <div class="btnpositionNew">
	        <a class="imgbtn" name="Dbutton" ><span onClick="select_member()"><spring:message code='ezSchedule.t4' /></span></a>
	    </div>
	</body>
</HTML>
