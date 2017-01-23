<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezSchedule.t1004' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />
	    <link rel="stylesheet" href="/css/organ_tree.css" type="text/css" />	    
	    <script type="text/javascript" src="<spring:message code='ezOrgan.e1' />"></script>
        <script type="text/javascript" src="/js/mouseeffect.js"></script>
        <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
        <script type="text/javascript" src="/js/ezOrgan/TreeView.js"></script>
	    <script type="text/javascript" src="/js/ezOrgan/ListView_list.js"></script>
        <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>		
		<script type="text/javascript">
			var g_xmlHTTP;
		    var ReturnFunction;
	
		    window.onload = function () {
		        try {
		            ReturnFunction = opener.schedule_select_secretary_cross_dialogArguments[1];
		        } catch (e) {}
		        
		        getDeptFullTree('${deptID}');
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
	
		    function getDeptFullTree(deptid) {
		        g_xmlHTTP = createXMLHttpRequest();
		        var strQuery = "<DATA><DEPTID>" + deptid + "</DEPTID><TOPID>Top</TOPID><PROP></PROP></DATA>";
	
		        g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		        g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
		        g_xmlHTTP.send(strQuery);
		    }
	
		    function event_getDeptFullTree() {        
		        if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
		            if (g_xmlHTTP.statusText == "OK") {
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
	
		    var checkname2_cross_dialogArguments = new Array();
		    function deptsearch_click() {
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
						type : "group"
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
		            var strQuery = "<DATA><DEPTID>" + getNodeText(xmlDOM.getElementsByTagName("DATA2").item(0)) + "</DEPTID><TOPID>Top</TOPID><PROP></PROP></DATA>";
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
	
		    function select_member() {
		        var listview = new ListView();
		        listview.LoadFromID("lvUserList");
	
		        var length = listview.GetSelectedRows().length;
	
		        if (length == 0) {
		            alert(strLang91);
		            return;
		        }
	
		        if (length > 1) {
		            alert(strLang92);
		            return;
		        }
	
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
	    
	    <h1><spring:message code='ezSchedule.t1004' /></h1>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	    <table>
	    	<tr>
	        	<td style="padding-right:5px">
	        		<div class="box" style="margin-bottom:7px" >
		                <input id="deptkeyword" onkeypress="deptsearch_press()" style="WIDTH:115px;margin-bottom:2px" />
	                	<a href="#" class="imgbtn"><span onclick="deptsearch_click()"><spring:message code='ezSchedule.t17' /></span></a>
	            	</div>
	            	<div style="border: 1px solid #b6b6b6; padding-top:2px;height: 414px; width: 280px; overflow-x: auto; overflow-y: auto; background-color: #FFFFFF" id="TreeView"></div>	            	
	        	</td>
	        	<td valign="top" style="padding-left:5px">
	        		<div class="box" style="margin-bottom:7px" >
		            	<select id="search_type" style="margin-bottom:2px">
		                	<option selected value="displayname"><spring:message code='ezSchedule.t18' /></option> 
		                  	<option value="description"><spring:message code='ezSchedule.t12' /></option> 
		                  	<option value="title"><spring:message code='ezSchedule.t14' /></option> 
		                  	<option value="telephonenumber"><spring:message code='ezSchedule.t15' /></option> 
		                  	<option value="mobile"><spring:message code='ezSchedule.t19' /></option> 
		                  	<option value="HomePhone"><spring:message code='ezSchedule.t20' /></option> 
		                  	<option value="facsimileTelephoneNumber"><spring:message code='ezSchedule.t21' /></option> 
		                  	<option value="mail"><spring:message code='ezSchedule.t22' /></option> 
		                  	<option value="streetAddress"><spring:message code='ezSchedule.t23' /></option> 
		                </select>
		                <input id="keyword" onkeypress="search_press()" style="WIDTH:130px; margin-bottom:2px" />
		                <a href="#" class="imgbtn"><span onclick="search_click()"><spring:message code='ezSchedule.t24' /></span></a>
		            </div>
	            	<div class="listview" style="border-top:0px">
	                	<div id="OrganListView" style="border: 0px solid #B6B6B6; Width: 416px; Height: 416px; overflow: hidden; BACKGROUND-COLOR: white; overflow-x: auto; overflow-y: auto;"></div>
	            	</div>		            
	        	</td>
	      	</tr>
	    </table>	    
	    <div class="btnposition">
	        <a class="imgbtn" name="Dbutton" ><span onClick="select_member()"><spring:message code='ezSchedule.t4' /></span></a>
	        <a class="imgbtn" name="Rbutton"><span onClick="window.close()"><spring:message code='ezSchedule.t5' /></span></a>    
	    </div>
	</body>
</HTML>
