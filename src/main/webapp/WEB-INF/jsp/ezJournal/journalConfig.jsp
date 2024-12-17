<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	<title><spring:message code='ezJournal.t53'/></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css" />
    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
    <link rel="stylesheet" href="${util.addVer('/css/jstree/style.css')}" type="text/css" />
	<script type="text/javascript" src="${util.addVer('/js/jstree/jstree.js')}"></script>
	
	<style type="text/css">
		tr.hover:hover{
			background:#eee; color:#fff;
		}
			
		.selectTR{
			background-color: #f1f8ff;
		}
	</style>
	
    <script type="text/javascript">
    	var treeContent = ${deptList};
    	var lpDeptId;
    	var lpDeptName;
    	var myDepts=[];
    	//레이어팝업의 오른쪽의 부서정보
   		var lpDepts=[];
   		var lpDeptNames=[];
   		var saveDepts=[];
   		var saveDeptNames=[];
    	
   		function addDeptInLP(){
   			var flag = true;
   			for (var i = 0; i < lpDepts.length ; i++) {
				if(lpDepts[i] == lpDeptId){
	   				alert("<spring:message code='ezJournal.t127'/>");
					flag=false;
				}
			}
   			if(flag){
   				if (myDepts.indexOf(lpDeptId) == -1) {
		   			$("#selectedDepts .mainlist_free").append("<tr targetId="+lpDeptId+" targetName="+lpDeptName+" style='cursor: pointer;' class='hover'><td align='left' style='width:250px;'>"+lpDeptName+"</td></tr>");
		   			lpDepts.push(lpDeptId);
		   			lpDeptNames.push(lpDeptName);
				} else {
	   				alert("<spring:message code='ezJournal.t178'/>");
				}
			} 
   		}
    
    	//레이어팝업의 오른쪽에 선택된 부서를 삭제
   		function delTargetDept(){
   			var targetDeptId = $(".selectTR").attr("targetId");
   			if(targetDeptId){
	   			var targetDeptName = $(".selectTR").attr("targetName");
   				lpDepts.splice(lpDepts.indexOf(targetDeptId),1);
   				lpDeptNames.splice(lpDeptNames.indexOf(targetDeptName),1);
   				$(".selectTR").remove();
   			} else {
   				alert("<spring:message code='ezJournal.t168'/>");
   			}
   		}
    	
    	function saveAuthEnv(){
    		if(lpDepts.length!=0){
				$.ajax({
	   				type:"POST",
	   				dataType:"text",
	   				url:"/ezJournal/saveChiefAuthDept.do",
	   				data:{
	   					depts:JSON.stringify(lpDepts)
	   				},
	   				success: function(result) {
	   					if (result == "ok") {
		   					saveDepts.length=0;
		   					saveDeptNames.length=0;
		   					for (var i = 0; i < lpDepts.length; i++) {
			   			   		saveDepts.push(lpDepts[i]);
			   			   		saveDeptNames.push(lpDeptNames[i]);
							}
		   					alert("<spring:message code='ezJournal.t137'/>");
	   					}
	   				}
	   			});
    		} else {
					alert("<spring:message code='ezJournal.t168'/>");
    		}
    	}
    	
    	function authCancel(){
    		lpDepts.length=0;
    		lpDeptNames.length=0;
			for (var i = 0; i < saveDepts.length; i++) {
				lpDepts.push(saveDepts[i]);
				lpDeptNames.push(saveDeptNames[i]);
			}
       		$("#selectedDepts .mainlist_free tr").remove();
       		for (var i = 0; i < lpDepts.length; i++) {
	       		$("#selectedDepts .mainlist_free").append("<tr targetId="+lpDepts[i]+" targetName="+lpDeptNames[i]+" style='cursor: pointer;' class='hover'><td align='left' style='width:250px;'>"+lpDeptNames[i]+"</td></tr>");
			}
    	}
    	
    	$(document).ready(function() {
    		$('#treeview').on('changed.jstree', function (e, data) {
    			lpDeptId = data.instance.get_node(data.selected).id;
				lpDeptName = data.instance.get_node(data.selected).text;
			  }).jstree({ 
				'core'   : {'data' : treeContent, 'multiple' : false},
				'plugins': ["wholerow"],
				'themes' : {'responsive' : true}
			}).on('dblclick.jstree', function (e, data) {
				addDeptInLP();
			}).on('ready.jstree', function(e, data) {
		    });
    		
    		$(function () {
	   			$(document).on({
	   				"dblclick":function(){delTargetDept();},
	   				"click":function(){
		   				$("*").removeClass("selectTR");
			   			$(this).addClass("selectTR");
	   				}
   				},"#selectedDepts tr");
   			});
    	//	$("#HContent").val("<c:out value="${journalEnv.previewHcontent}"/>").attr("selected", "selected");
    	//	$("#WContent").val("<c:out value="${journalEnv.previewWcontent}"/>").attr("selected", "selected");
    	});
    
    	document.onselectstart = function () { return false; };
        window.onload = function () {
            if (navigator.userAgent.indexOf('Firefox') != -1) {
                document.body.style.MozUserSelect = 'none';
                document.body.style.WebkitUserSelect = 'none';
                document.body.style.khtmlUserSelect = 'none';
                document.body.style.oUserSelect = 'none';
                document.body.style.UserSelect = 'none';
            }
            document.getElementById("1tab1").setAttribute("class", "tabon");
            Tab1_SelectID = "1tab1";
            ChangeTab(document.getElementById("1tab1"));
        }
        
        function ChangeTab(obj) {
            var pSelectTab = obj.getAttribute("divname");
            switch (pSelectTab) {
                case "JournalEnv_div1":
                	if (document.getElementById("JournalEnv_content1").style.display == "none") {
                		document.getElementById("JournalEnv_content1").style.display = "";
                		<c:if test="${fn:length(deptList) ne 0}">
                		document.getElementById("JournalEnv_content3").style.display = "none";
                		</c:if>
                	}
                    break;
                case "JournalEnv_div3":
                	if (document.getElementById("JournalEnv_content3").style.display == "none") {
                		document.getElementById("JournalEnv_content3").style.display = "";
                		document.getElementById("JournalEnv_content1").style.display = "none";
                	}
                    break;
            }
        }
        var Tab1_SelectID = "";
        function Tab1_MouserOver(obj) {
            obj.className = "tabover";
        }
        function Tab1_MouserOut(obj) {
            if (Tab1_SelectID != obj.id)
                obj.className = "";
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
        function Tab1_NewTabIni(pTabNodeID) {
            for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
                if (document.getElementById(pTabNodeID).childNodes.item(i).nodeName == "P") {
                    if (document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).nodeName == "SPAN") {
                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseover = function () { Tab1_MouserOver(this); };;
                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseout = function () { Tab1_MouserOut(this); };;
                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onclick = function () { Tab1_MouseClick(this); };;

                        if (i == 0) {
                            document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).className = "tabon";
                            Tab1_SelectID = document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).id;
                        }
                    }
                }
            }
        }
        
        var previewHcontent = "<c:out value="${journalEnv.previewHcontent}"/>";
		var previewWcontent = "<c:out value="${journalEnv.previewWcontent}"/>";
        function PreviewOption(val) {       
        	console.log(val);
        	if (val == "NONE") {
            	$("#PreviewWDiv").css("display", "none");                	
            	$("#PreviewHDiv").css("display", "none");                	
        	} else if (val == "H") {                	
            	$("#PreviewWDiv").css("display", "none");                	
            	$("#PreviewHDiv").css("display", "");                	
	        	$("#HContent").val(previewHcontent).attr("selected", "selected");
	        	$("#HList").val(100-$("#HContent").val()).attr("selected", "selected");
        	} else {
            	$("#PreviewWDiv").css("display", "");                	
            	$("#PreviewHDiv").css("display", "none");                	
	    		$("#WContent").val(previewWcontent).attr("selected", "selected");
	    		$("#WList").val(100-$("#WContent").val()).attr("selected", "selected");
        	}
    	}
        
    	var viewenv = "${journalEnv.viewenv}";
        // 리스트옵션 화면에서 취소클릭시 원래의 설정으로변경
        function Cancel_Click() {
        	document.getElementById("listcount").value = listCount;
    		document.getElementById("PreviewMode").value = viewenv;
			PreviewOption(viewenv);    		
    	}
        
        var listCount = ${journalEnv.listCnt };
        // 리스트옵션 저장
    	function saveListEnv() {
    		listCount = document.getElementById("listcount").value;
 			var preview = document.getElementById("PreviewMode").value;
 			previewHcontent = document.getElementById("HContent").value;
 			previewWcontent = document.getElementById("WContent").value;
 			
 			$.ajax({
 				url : "/ezJournal/saveJournalEnv.do",
 				method : "POST",
 				dataType : "text",
 				data : {
     				listCnt : listCount ,
	 				viewenv : preview,
	 				previewHcontent : previewHcontent,
	 				previewWcontent : previewWcontent
 				},
     			success : function() {
     				viewenv = preview;
     				alert("<spring:message code='ezJournal.t137'/>");
 				}
 			});       
    	}
    	
        function changePreviewVal(elem){
        	var elemId = $(elem).attr("id");
        	var targetId = elemId.substring(0,1);
        	if(elemId.substring(1)=='Content'){
        		targetId+='List';
        	} else {
        		targetId+='Content';
        	}
        	$("#"+targetId).val(100-$(elem).val());
        }
    </script>
</head>
<body class="mainbody">
    <h1><spring:message code="ezJournal.t150" /></h1>
    <div class="portlet_tabpart01">
        <div class="portlet_tabpart01_top" id="tab1">
            <p id="JournalEnv_sub1"><span divname="JournalEnv_div1" id="1tab1"><spring:message code="ezJournal.t115" /></span></p>
            <c:if test="${fn:length(deptList) ne 0}">
            	<p id="JournalEnv_sub3"><span divname="JournalEnv_div3" id="1tab3"><spring:message code="ezJournal.t174" /></span></p>
            </c:if>
        </div>
    </div>
    <div id="JournalEnv_content1" style="margin-left:10px; width:100%;height:90%; padding-top:10px; display:none">
    	<br/>	
   		<%-- <h2><spring:message code="ezJournal.t115" /></h2> --%>
   		<span class="txt"><spring:message code="ezJournal.t117" /></span>
       	<br />    
       	<table class="content" style="width: 480px;margin-top:5px">
           	<tr>
               	<th><spring:message code="ezJournal.t68" /></th>
              		<td>               
                  		<select id="listcount" name="pListCount" style="WIDTH: 100px">
               				<option value='10' ${journalEnv.listCnt == '10' ? 'selected' : ''}>10</option>
							<option value='20' ${journalEnv.listCnt == '20' ? 'selected' : ''}>20</option>
                   			<option value='30' ${journalEnv.listCnt == '30' ? 'selected' : ''}>30</option>
                   			<option value='40' ${journalEnv.listCnt == '40' ? 'selected' : ''}>40</option>
                   			<option value='50' ${journalEnv.listCnt == '50' ? 'selected' : ''}>50</option>                        
                  		</select>
                   	<spring:message code="ezJournal.t55" />
                   </td>
           	</tr>
           	<tr>
               	<th><spring:message code="ezJournal.t69" /></th>
           		<td>
               		<select id="PreviewMode" name="pPreview" style="WIDTH: 100px" onchange="PreviewOption(this.value);">
               			<option value='NONE' ${journalEnv.viewenv == 'NONE' ? 'selected' : ''}><spring:message code="ezJournal.t118" /></option>
               			<option value='H' ${journalEnv.viewenv == 'H' ? 'selected' : ''}><spring:message code="ezJournal.t119" /></option>
               			<option value='W' ${journalEnv.viewenv == 'W' ? 'selected' : ''}><spring:message code="ezJournal.t120" /></option>             					                     
               		</select>
               		<span id="PreviewWDiv" style="${journalEnv.viewenv ne 'W' ? 'display: none;' : ''}">                   			
               			&nbsp;<spring:message code="ezJournal.t179" /> :
						<select id="WList" name="pPreviewWList" style="width: 50px;" onchange="changePreviewVal(this);">
							<c:forEach var="item" begin="25" end="65">
	   							<option value='${item}' ${item == 100-journalEnv.previewWcontent ? 'selected' : '' }>${item}</option>
							</c:forEach>
						</select>
      					&nbsp;<spring:message code="ezJournal.t180" /> :
						<select id="WContent" name="pPreviewWContent" style="width: 50px;" onchange="changePreviewVal(this);">
							<c:forEach var="item" begin="35" end="75">
	  							<option value='${item}' ${item == journalEnv.previewWcontent ? 'selected' : '' }>${item}</option>
							</c:forEach>
						</select>		
					</span>
               		<span id="PreviewHDiv" style="${journalEnv.viewenv ne 'H' ? 'display: none;' : ''}">                   			
	       				&nbsp;<spring:message code="ezJournal.t179" /> :
						<select id="HList" name="pPreviewHList" style="width: 50px;" onchange="changePreviewVal(this);">
							<c:forEach var="item" begin="39" end="64">
	   							<option value='${item}' ${item == 100-journalEnv.previewHcontent ? 'selected' : '' }>${item}</option>
							</c:forEach>
						</select>
	       				&nbsp;<spring:message code="ezJournal.t180" /> :
						<select id="HContent" name="pPreviewHContent" style="width: 50px;" onchange="changePreviewVal(this);">
							<c:forEach var="item" begin="36" end="61">
	   							<option value='${item}' ${item == journalEnv.previewHcontent ? 'selected' : '' }>${item}</option>
							</c:forEach>
						</select>
					</span>		
           		</td>
           	</tr>
       	</table>
   		<div style="width:466px;" class="btnpositionJsp">      
       		<a class="imgbtn" onclick="saveListEnv()"><span><spring:message code="ezJournal.t26" /></span></a>
       		<a class="imgbtn" onclick="Cancel_Click()"><span><spring:message code="ezJournal.t16" /></span></a>
   		</div>
	</div>

	<c:if test="${fn:length(deptList) ne 0}">
	    <div id="JournalEnv_content3" style="margin-left:10px; width:100%;height:90%; padding-top:10px; display:none">
		    <br/>
			<h2><spring:message code="ezJournal.t174" /></h2>
			<span class="txt"><spring:message code="ezJournal.t175" /></span>
			<br />
			<table class="" style="width: 650px;margin-top:5px; border: none;">
				<tr>
					<td class="box" style="min-width: 350px;">
						<div id="treeview" style="height: 350px; width: 100%; overflow: auto;">
						</div>
					</td>
					<td style="min-width: 60px; border-top: none; border-bottom: none;">
						<div style="text-align: center;"><img src="/images/arr_right.gif" width="16" height="16" vspace="3" onclick="addDeptInLP();" style="cursor:pointer"></div>
						<div style="text-align: center;"><img src="/images/arr_left.gif"  width="16" height="16" vspace="3" onclick="delTargetDept();" style="cursor:pointer"></div>
					</td>
					<td class="listview" style="min-width: 240px; padding: 0px;">
						<div id="selectedDepts" style="width: 100%; height: 350px; overflow: auto;">
							<table class="mainlist_free">
								<c:forEach var="dept" items="${deptList }">
									<c:if test="${dept.isComp eq 'Y' }">
										<tr targetId="${dept.id }" targetName="${dept.text }" style='cursor: pointer;' class='hover'>
											<td align='left' style='width:250px;'>
												${dept.text }
											</td>
										</tr>
										<script>
											lpDepts.push("${dept.id }");
								   			lpDeptNames.push("${dept.text }");
								   			saveDepts.push("${dept.id }");
								   	   		saveDeptNames.push("${dept.text }");
										</script>
									</c:if>
									<c:if test="${dept.myDept eq 'yes' or dept.myDept eq 'add'}">
										<script>
											myDepts.push("${dept.id }");
										</script>
									</c:if>
								</c:forEach>
							</table>
						</div>
					</td>
				</tr>
			</table>		 	
			<div style="width:650px;" class="btnpositionJsp">      
				<a class="imgbtn" onclick="saveAuthEnv();"><span><spring:message code="ezJournal.t26" /></span></a>
	       		<a class="imgbtn" onclick="authCancel();"><span><spring:message code="ezJournal.t16" /></span></a>
			</div>
		</div>		
	</c:if>	
</body>
<script type="text/javascript">
    Tab1_NewTabIni("tab1");
</script>
</html>