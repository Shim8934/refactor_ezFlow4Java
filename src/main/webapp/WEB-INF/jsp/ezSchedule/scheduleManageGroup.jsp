<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSchedule/controls/ListView_Group.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/NameControl.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript">
		    var strListInfo = "";
		    var use_ocs = "<c:out value='${use_ocs}' />";
		    
		    window.onload = function () {
		    	
		        getGroupList();		      
		    }
		    
				    
		    function getGroupList() {
		    	$.ajax({
		    		type : "GET",
		    		dataType : "xml",
		    		async : true,
		    		cache : false,
		    		url : "/ezSchedule/scheduleGroupList.do",		    		
		    		success: function(text){
		    			var listNode = SelectSingleNodeNew(text, "LISTVIEWDATA");
				        if (listNode == null) return;
				
				        var xmlDoc;
				        if (CrossYN()) {
				            var xmlLIST = createXmlDom();
				            var nodeToImport = xmlLIST.importNode(listNode, true);
				            xmlLIST.appendChild(nodeToImport);				
				            xmlDoc = loadXMLString(GetSerializeXml(xmlLIST));
				        }
				        else {
				            xmlDoc = createXmlDom();
				            xmlDoc.appendChild(listNode);
				        }
				        strListInfo = "";
				        document.getElementById("GroupList").innerHTML = "";
				        var xmldom = text;
				        var listview = new ListView();
				        listview.SetID("GroupListView");
				        listview.SetSelectFlag(false);
				        listview.SetMulSelectable(true);
				        listview.SetRowOnClick("View_Detail");
				        listview.SetRowOnDblClick("show_groupinfo2");
				        listview.DataSource(xmlDoc);
				        listview.DataBind("GroupList");				        
				        xmldom = null;
		    		}
		    	});		        
		    }
		
		    function View_Detail(obj) {
		        document.getElementById("Group_View").innerHTML = "";
		        
		        var listview = new ListView();
		        listview.LoadFromID("GroupListView");
		        var Selected = listview.GetSelectedRows();
		        var DIV_Description = document.createElement("DIV");		       
		        var Span = document.createElement("SPAN");
		        Span.setAttribute("style", "color: #000; font-weight: bold;");
		        
		        if (CrossYN())
		            Span.textContent = "▒ " +strLang264;
		        else
		            Span.innerText = "▒ " +strLang264;		
		        
		        DIV_Description.appendChild(Span);
		        var P = document.createElement("P");
		        DIV_Description.appendChild(P);
		        var DIV = document.createElement("DIV");
		        DIV.style.width = "90%";
		        DIV.style.marginTop = "10px";
		        DIV.style.marginLeft = "5px";
		        DIV.style.wordBreak = "break-all";
		
		        if (CrossYN())
		            DIV.textContent = obj.getAttribute('data2');
		        else
		            DIV.innerText = obj.getAttribute('data2');
		
		        DIV_Description.appendChild(DIV);
		        DIV_Description.appendChild(P);
		
		        document.getElementById("Group_View").appendChild(DIV_Description);
		        
		        $.ajax({
		    		type : "GET",
		    		dataType : "xml",
		    		async : false,
		    		data : {
		    			groupID : obj.getAttribute('data1')
		    		},
		    		url : "/ezSchedule/getGroupDetail.do",		    		
		    		success: function(text){
		    			var P = document.createElement("P");
		                document.getElementById("Group_View").appendChild(P);
		
		                var DIV_GroupMember = document.createElement("DIV");
		                var Span = document.createElement("SPAN");
		                var BR = document.createElement("BR");
		                Span.setAttribute("style", "color: #000; font-weight: bold;");
		                
		                if (CrossYN())
		                    Span.textContent = "▒ " +strLang265;
		                else
		                    Span.innerText = "▒ " +strLang265;
		                
		                DIV_GroupMember.appendChild(Span);
		                var P = document.createElement("P");
		                DIV_GroupMember.appendChild(P);
		                
		                for (var i = 0; i < SelectNodes(text, "MEMBERID").length; i++)
		                {
		                    var DIV = document.createElement("DIV");
		                    DIV.style.marginLeft = "5px";
		                    DIV.style.marginTop = "5px";
		                    DIV.style.cursor = "hand";
		                    DIV.style.color = "#000";
		                    DIV.style.display = "inline-block";
		                    
		                    if (CrossYN()) {
		                        //if (use_ocs == "YES") {
		                            //DIV.innerHTML = "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + SelectNodes(text, "MAIL").item(i).textContent + "\",this);'/></span><span style='margin-top:50px; cursor:pointer' id=" + SelectNodes(text, "MEMBERID").item(i).textContent + " onclick='show_member(this)'>" + SelectNodes(text, "INFO").item(i).textContent + "</span>";
		                            DIV.innerHTML = "<span style='margin-top:50px; cursor:pointer' id=" + SelectNodes(text, "MEMBERID").item(i).textContent + " data-dept="+SelectNodes(text, "DEPARTMENT").item(i).textContent +" onclick='show_member(this)'>" + SelectNodes(text, "INFO").item(i).textContent + "</span>";
		                        /* } else {
		                            DIV.innerHTML = SelectNodes(text, "INFO").item(i).textContent;
		                        } */
		                    } else {
		                        //if (use_ocs == "YES") {
		                            //DIV.innerHTML = "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + SelectNodes(text, "MAIL").item(i).text + "\",this);'/></span><span style='margin-top:50px; ; cursor:pointer' id=" + SelectNodes(text, "MEMBERID").item(i).text + " onclick='show_member(this)'>" + SelectNodes(text, "INFO").item(i).text + "</span>";
		                            DIV.innerHTML = "<span style='margin-top:50px; ; cursor:pointer' id=" + SelectNodes(text, "MEMBERID").item(i).text + "data-dept="+SelectNodes(text, "DEPARTMENT").item(i).text +" onclick='show_member(this)'>" + SelectNodes(text, "INFO").item(i).text + "</span>";
		                        /* } else {
		                            DIV.innerHTML = SelectNodes(text, "INFO").item(i).text;
		                        } */
		                    }
		
		                    DIV_GroupMember.appendChild(DIV);
		                    var BR = document.createElement("BR");
		                    DIV_GroupMember.appendChild(BR);
		                }                    
		                document.getElementById("Group_View").appendChild(DIV_GroupMember);
		    		}
		        });		        
		    }
				    		
		    function show_member(obj) {
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 450) / 2;
		        var pLeft = (pwidth - 420) / 2;
		        window.open("/ezCommon/showPersonInfo.do?id=" + obj.id + "&dept="+$(obj).data("dept"), "", "height=450px,width=420px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
		    }
		
		    function ReplaceText(orgStr, findStr, replaceStr) {
		        var re = new RegExp(findStr, "gi");
		        return (orgStr.replace(re, replaceStr));
		    }
		
		    var schedule_group_write_dialogArguments = new Array();
		    function add_group() {	    	
		        if (CrossYN()) {		        	
		            schedule_group_write_dialogArguments[0] = "";
		            schedule_group_write_dialogArguments[1] = add_group_Complete;
		            var OpenWin = window.open("/ezSchedule/scheduleGroupWrite.do?type=group", "schedule_group_write", GetOpenWindowfeature(980, 685));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else {
		            var feature = GetShowModalPosition(950, 685);
		            var rtn = window.showModalDialog("scheduleGroupWrite.do?type=group", "", "dialogHeight:670px; dialogWidth:980px; status:no; scroll:no; help:no; edge:sunken" + feature);
		            if (typeof (rtn) != "undefined")
		                getGroupList();
		        }
		    }
		
		    function add_group_Complete(rtn) {
		        if (typeof (rtn) != "undefined")
		            getGroupList();
		        	//2018-11-01 김보미 - 일정그룹 추가시 left바에 그룹 바로 보이도록
		        	parent.frames["left"].groupRefresh();
		    }
					
		    function del_group() {
		    	var strListInfo = "";
		    	var checkId = $("input[name=chk_group]:checked");
		    	
		    	if(checkId.length == 0){
		    		 alert("<spring:message code='ezSchedule.t253' />");
			         return;
		    	}
		    	
		    	for(var i=0; i<$("input[name=chk_group]:checked").length; i++){
		    		strListInfo += $("input[name=chk_group]:checked")[i].id;
		    	}
		    	console.log('strListInfo : ' + strListInfo);
		    	 var count = strListInfo.split(';').length - 1;
		    	
		      /*   if (strListInfo == "") {
		            alert("<spring:message code='ezSchedule.t253' />");
		            return;
		        }
		
		        var count = strListInfo.split(';').length - 1;
		        */
		        if (!confirm(count + " <spring:message code='ezSchedule.t254' />"))
		            return; 

		        $.ajax({
		    		type : "POST",
		    		dataType : "html",
		    		async : false,
		    		data : {
		    			groupID : strListInfo
		    		},
		    		url : "/ezSchedule/scheduleDelGroup.do",
		    		success: function(text){
		    			alert(count + " <spring:message code='ezSchedule.t256' />");
			            window.location.reload(false);
		    		},
		    		error: function(err){
		    			alert("<spring:message code='ezSchedule.t255' />");
		    		}
		        });
		        
		        parent.frames["left"].groupRefresh();
		    }
					
		    function show_groupinfo() {
		    	console.log('Selected : ' + Selected);
		        var listview = new ListView();
		        listview.LoadFromID("GroupListView");
		        
		        if(document.getElementById("HeaderAllCheckBox").checked) {
			        document.getElementById("HeaderAllCheckBox").checked = false;
			        event_HeaderCheckBoxClick(document.getElementById("HeaderAllCheckBox"));
			        listview.GetDataRows()[0].onclick();
		        } else {
		        	
			        if (listview.GetSelectedRows() == "") {
			            alert(strLang266);
			            return;
			        }
			        
			        /* listview.GetSelectedRows()[0].onclick(); */ 
		        }
      		            
		        var Selected = listview.GetSelectedRows();
		        console.log('Selected : ' + Selected);
		        
		        var feature = GetOpenPosition(430, 370);
		        //window.open("/myoffice/ezSchedule/schedule_group_member.aspx?id=" + GetAttribute(Selected[0], "data1"), "", "height = 370px, width = 430px, status = no, toolbar=no, menubar=no,location=no, resizable=0" + feature);
		        
		        console.log('GetAttribute(Selected[0], "data1") : ' + GetAttribute(Selected[0], "data1"));
		        window.open("/ezSchedule/scheduleGroupMember.do?groupID=" + GetAttribute(Selected[0], "data1"), "", "height = 370px, width = 460px, status = no, toolbar=no, menubar=no,location=no, resizable=0" + feature);
		        
		        //getGroupList();		
		    }
			  
		</script>
	</head>
	<body class="mainbody">		
		<br/>
	    <div class="txt">▒ <spring:message code='ezSchedule.t00005' /></div>
	    <div class="txt" style="margin-top:3px">▒ <spring:message code='ezSchedule.t00006' /></div>
	    <div class="txt" style="margin-top:3px">▒ <spring:message code='ezSchedule.t00007' /></div>
	    <div class="txt" style="margin-top:3px">▒ <spring:message code='ezSchedule.t00008' /></div>
	    <div id="mainmenu" style="margin-top:20px">
	        <ul>
	            <li class="important"><span onClick="add_group()"><spring:message code='ezSchedule.shb07' /></span></li>
	            <li><span onClick="show_groupinfo2('show')"><spring:message code='ezSchedule.shb06' /></span></li>
	            <li><span class="icon16 icon16_delete" onclick='del_group();'></span></li>
	        </ul>
	    </div>
	    <table class="mainlist" style="width:70%;">
	        <tr>
	            <td style="vertical-align:top; border-bottom:none">
	                <div id="GroupList" style ="BORDER:0;WIDTH:100%; height:400px; overflow-y: auto; border-top-color: #dbdbda; border-right-color: #dbdbda; border-bottom-color: #dbdbda; border-left-color: #dbdbda; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-bottom-style: solid; border-left-style: solid;"></div>
	            </td>
	            <td style="vertical-align:top; border-bottom:none">
	                <div id="Group_View" style="padding:15px; width: 100%; height: 369px; margin-right: 5px; margin-bottom: 5px; margin-left: 5px; border-top-color: #dbdbda; border-right-color: #dbdbda; border-bottom-color: #dbdbda; border-left-color: #dbdbda; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-bottom-style: solid; border-left-style: solid; overflow-y: auto;">
	                </div>
	            </td>
	        </tr>
	    </table>
		<script type="text/javascript">
		    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
	</body>
</html>

