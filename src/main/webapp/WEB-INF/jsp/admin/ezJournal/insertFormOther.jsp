<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezJournal.t17' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="/css/Tab.css" type="text/css">
		<link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />
		<link rel="stylesheet" href="/css/jstree/style.css" type="text/css" />
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/jstree/jstree.js"></script>
		<script type="text/javascript" src="/js/ezJournal/FormMain_Cross.js"></script>
	    <script type="text/javascript">		    
	    	var companyId = "<c:out value='${companyId}'/>";
		    var typeId = "<c:out value='${typeId}'/>";
		    var useEditor = "<c:out value='${useEditor}'/>";
		    var formId = "<c:out value='${formId}'/>";
		    var isFree = false;
		    var selDeptId = "";
		    var useDeptList = [];
		    var isDeptChanged = "N";
		    var useDepts = "<c:out value='${useDepts}'/>";		    	
        	var selFormContent = "<c:out value='${formContent}'/>";
		    
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
		    
		    $(document).ready(function() {
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
	
		        setDeptList();
		        checkUseDept();
			    $("#selDeptUseP").click(function() {
			    	$("#setUseDeptList").show();
			    });

			    if (formId != null && formId != "") {
		        	document.title = "<spring:message code='ezJournal.t18' />";
		        	
		        	useDepts = JSON.parse(useDepts.replace(/&#034;/g, "\""));
		        	console.log("useDepts : " + useDepts);
		        	
		        	if (useDepts != null) {
		        		useDeptList = useDepts.slice();
		        		console.log("useDeptList : " + useDeptList)
		        		$("#setUseDeptList").show();
		        		drawUseDeptList();
		        	}
		        }
			    
		    });
		    
		    // 수정시 양식내용을 에디터에 넣어주는 작업 
		    $(window).load(function() {
			    if (formId != null && formId != "") {
			    	selFormContent = selFormContent.replace(/&#034;/g, "\"");
			    	selFormContent = selFormContent.slice(1, -1);
		        	message.SetEditorContent(selFormContent);
			    }
		    });
		    
		    function checkUseDept() {
			    if ($("selDeptUseA:checked")) {
			        $("#setUseDeptList").hide();
			       
			    } else {
			        $("#setUseDeptList").show();
			    }
		    }
		    
		    function selectTypeList(val) {
		    	typeId = val;
		    }
		    
		    function clickFormInfo(val) {
		    	var info = $(val).attr("value");
		    	alert(info);
		    	if (useEditor == "HWP") {
		    		message.SetAttribute(info);
		    	} else {
		    		if (isFree) {
		    			message.SetAttribute("LOCK", "", "");
		    		} else {
		    			message.SetAttribute("INIS", info, "FIELD");
		    		}
		    	}
		    }
		    
		    function setDeptList() {
		    	var treeContent = ${deptList};
		    	$("#deptTreeView").on('changed.jstree', function (e, data) {
					var i, j, r = [];
				    for(i = 0, j = data.selected.length; i < j; i++) {
				      r.push(data.instance.get_node(data.selected[i]).id);
				    }
				    selDeptId = r.join(', ');
				})
				.on("dblclick.jstree", function(event, data) {
				    insertDept();
		    	})				
				.jstree({
		    		'core'		: {"data" : treeContent},
		    		'plugins'	: ["wholerow"],
		    		'themes'	: {"responsive" : true}
		    	});
		    }
		    
		    function insertDept() {
		    	var deptId = selDeptId;
		    	var nodeText = $("#deptTreeView").jstree().get_node(deptId).text;
		    	var deptName = nodeText.replace(/<(\/)?([a-zA-Z]*)(\s[a-zA-Z]*=[^>]*)?(\s)*(\/)?>/ig, "");
		    //	var deptName = nodeText.slice(5, -6);
		    	var chkFlag = true;
		    	isDeptChanged = "Y";
		    	for(var j = 0; j < useDeptList.length; j++) {
		    		if (useDeptList[j].deptId == selDeptId) {
			    		chkFlag = false;
		    		}
		    	} 
		    	
		    	if (chkFlag) {
			    	useDeptList.push({"deptName" : deptName, "deptId" : deptId});
		    	} else {
		    		alert("<spring:message code='ezJournal.t127'/>");
		    	}
		    	drawUseDeptList();
		    } 
		    
		    function deleteDept() {
		    	isDeptChanged = "Y";
		     	for(var j = 0; j < useDeptList.length; j++) {
		    		if (useDeptList[j].deptId === selDeptId) {
		    			useDeptList.splice(j, 1);
		    		}
		    	} 
		    	drawUseDeptList();
		    }
		    
		    function drawUseDeptList() {
		    	console.log(useDeptList);
		    	
		    	var $useFormDept = $("#useFormDept");
		    	var useListHtml = "";     
		    	for (var i = 0; i < useDeptList.length; i++) {
		    		useListHtml += "<tr deptId=" + useDeptList[i].deptId + " onclick='listClick(this)' ondblclick='deleteDept()'>";
		    		useListHtml += "<td>";
		    		useListHtml += useDeptList[i].deptName;
		    		useListHtml += "</td>";
		    		useListHtml += "</tr>";
		    	}
		    	$useFormDept.html(useListHtml);
		    }
		    
		    function listClick(val) {
		    	var $this = $(val);
		    	selDeptId = $this.closest("tr").attr("deptId");
		    }
		    
		    function btnSave() {
		    	var formName = $("#tbFormName").val();
		    	var formDescript = $("#tbDescript").val();
		    	var formContent = message.GetEditorContent();
		    	
		    	if (formName == "") {
		    		alert("양식명을 입력해주세요.");
		    		return false;
		    	}
		    	
		    	//if ($("#selDeptUseP").is("checked")) {
		    	if ($(":input:radio[name=setUseDept]:checked").val() == "P") {
		    		alert("부서체크인지")
		    		var useDept = JSON.stringify(useDeptList);	
		    	} else if (($(":input:radio[name=setUseDept]:checked").val() == "A") && formId != null) {
		    		isDeptChanged = "Y";
		    	}
		    	console.log("formId : " + formId);
		    	console.log("isDeptChanged : " + isDeptChanged)
		    	$.ajax({
		    		type : "POST",
		    		dataType : "json",
		    		async : false,
		    		url : "/admin/ezJournal/formSave.do",
		    		data : {"companyId"		: companyId,
    						"typeId"		: typeId,
    						"formName" 		: formName,
    						"formDescript" 	: formDescript,
    						"useDept" 		: useDept,
    						"formContent" 	: formContent,
    						"formId"		: formId,
    						"isDeptChanged"	: isDeptChanged},
    				success : function(result) {
    					alert("<spring:message code='ezJournal.t128'/>");
    					opener.location.reload();
						window.close();    					
    				},
    				error : function(request, status, error) {
		    			alert("code : " + request.status + "\nmessage: " + request.responseText + "\nerror : " + error);
		    		}
		    	}); 
		    }
		    
		    function btnClose() {
		    	window.close();
		    }
		    
		</script>
		<style>
			#infoTD th { height: 25px;}
			#infoTD td {
				border: 1px solid #b6b6b6;
				height: 26px;
				padding-left: 5px;
				cursor: pointer;
			}
			
			@media screen and (-webkit-min-device-pixel-ratio:0)
			  and (min-resolution:.001dpcm) {
				xmp{
					position:relative;
					top:-38px;
					left:20px;
				}
			}
		</style>
	</head>
	<body class="popup">
        <div id="menu">
            <ul>
                <li><span id="btnSave" onClick="return btnSave()"><spring:message code='ezJournal.t26'/></span></li>
            </ul>
        </div>
        <div id="close">
            <ul>
                <li><span id="btnClose" onClick="return btnClose()"><spring:message code='ezJournal.t27'/></span></li>
            </ul>
        </div>
        <div class="portlet_tabpart01">
	        <div class="portlet_tabpart01_top" id="tab1">
                <p id = "ApvForm_sub1"><span divname="ApvForm_div1" id="1tab1"><spring:message code='ezJournal.t28'/></span></p>
                <p id = "ApvForm_sub2"><span divname="ApvForm_div2" id="1tab2"><spring:message code='ezJournal.t29'/></span></p>
	        </div>
        </div>
        
        <div id="ApvForm_content1" style="width:100%;height:90%; padding-top:10px; display:none">
			
			<table class="content" style="width:100%;">
				<tr>                
					<th style="width:100px; text-align:center"><spring:message code='ezJournal.t22'/></th>
                    <td style="width:50%;">
                        <input type="text" id="tbFormName" name="tbFormName" value="${formName}" maxlength="50" style="width:100%">
                        <input type="text" id="tbFormID" name="tbFormID" style="display: none" readonly>
                    </td>
                    <th style="width:100px; text-align:center"><spring:message code='ezJournal.t12'/></th>
                    <td style="width:30%;">
                    	<select id="selType" name="selType" onchange="selectTypeList(this.value)" style="width: 100%;">
                    		<c:forEach var="type" items="${typeList }">
                    			<option value="<c:out value='${type.journaltypeId}'/>"
				            		<c:if test="${type.journaltypeId eq typeId}">
					            		 selected
				            		</c:if>
			            		 ><spring:message code='${type.journaltypeId }'/></option>
                    		</c:forEach>
                    	</select>
                    </td>
                </tr>
                <tr>
                    <th style="width:100px; text-align:center"><spring:message code='ezJournal.t24'/></th>
                    <td style="width:40%;" colspan="3">
                        <input type="text" id="tbDescript" name="tbDescript" value="${formInfo}" style="WIDTH: 100%" maxlength="50">
                    </td>
                </tr>
                <tr>
                    <th style="width:100px; text-align:center"><spring:message code='ezJournal.t23'/></th>
					<td colspan="3" style="width:10%; text-align: left;">
						<c:choose>
							<c:when test="${useDepts eq 'null' || useDepts eq null}">
								<input type="radio" id="selDeptUseA" name="setUseDept" value="A" checked onclick="checkUseDept()"/><label for="selDeptUseA"><spring:message code = 'ezJournal.t30' /></label>
								<input type="radio" id="selDeptUseP" name="setUseDept" value="P" onclick="checkUseDept()"/><label for="selDeptUseP"><spring:message code = 'ezJournal.t31' /></label>
							</c:when>
							<c:otherwise>
								<input type="radio" id="selDeptUseA" name="setUseDept" value="A" onclick="checkUseDept()"/><label for="selDeptUseA"><spring:message code = 'ezJournal.t30' /></label>
								<input type="radio" id="selDeptUseP" name="setUseDept" value="P" checked onclick="checkUseDept()"/><label for="selDeptUseP"><spring:message code = 'ezJournal.t31' /></label>
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
			</table>
            <br />
            <br />
            
            <table style="width:60%; margin: auto;" >
				<tr id="setUseDeptList">
					<td style="width: 48%;">
						<div class="box"> 
						<div style="width: 100%; height: 450px; overflow-x: auto; overflow-y: auto;" id="deptTreeView"></div>
						</div>
					</td>
					<td style="width: 30px; text-align: center;">                            
                        <img src="/images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="insertDept()"><br>
                        <img src="/images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="deleteDept()">
                    </td>
                    <td style="width: 48%; vertical-align: top;">
                       	<div class="listview">
                           	<div ondragover ="onDragEnter(event)" ondrop ="onDrop(event, this)" style="width: 100%; Height: 450px; overflow-x: auto; overflow-y: auto;" >
                           		<table id="useFormDept" style="width: 100%; border: 0; padding: 0;" class="mainlist"></table>
                           	</div>
                       	</div>
                   </td>
                </tr>
            </table>
        </div>
        
        <div id="ApvForm_content2" style="width:100%;display:none; padding-top:10px;">
			<div id="editor_content" style="padding-top:5px;">
				<%-- <div id="mainmenu">
					<ul>
                    	<li id="property"><span onclick="return idSetField_onclick()"><spring:message code='ezApproval.t641'/></span></li>
                    </ul>
                </div> --%>
                <script type="text/javascript">
                    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
                </script>
				<table id="TForm" style="height:770px; width:1000px;">
					<tr>
                        <td style="height:770px; vertical-align:top">
                        	<c:choose>
                        		<c:when test="${useEditor == 'HWP'}">
	                                <iframe id="message" class="viewbox" src="/admin/ezApprovalG/HWPEditor.do?type=ADMIN" name="message" frameborder="0" style="padding: 0; height: 99%; width: 1030px; overflow: auto;"></iframe>
                        		</c:when>
                        		<c:otherwise>
	                                <iframe id="message" class="viewbox" src="/admin/ezEditor/selectEditor.do?type=ADMIN&height=770&formID=${formId}" name="message" frameborder="0" style="padding: 0; height: 99%; width: 800px; overflow: auto;"></iframe>
                        		</c:otherwise>
                        	</c:choose>
                        </td>
                        <td id="infoTD" name="infoTD" style="width:100%; vertical-align:top; padding-left:10px;">
                        	<table width="100%" cellpadding="0" cellspacing="0">
                        		<tbody>
                        			<tr><th><spring:message code='ezJournal.t32'/></th></tr>
                        			<tr><td><span value="deptId" onclick="clickFormInfo(this)"><spring:message code='ezJournal.t33'/></span></td></tr>
                        			<tr><td><span value="writer" onclick="clickFormInfo(this)"><spring:message code='ezJournal.t34'/></span></td></tr>
                        			<tr><td><span value="writeDate" onclick="clickFormInfo(this)"><spring:message code='ezJournal.t35'/></span></td></tr>
                        		</tbody>
                        	</table>
                        </td>
                    </tr>
                </table>  
			</div>
		</div>
        <script type="text/javascript">
            Tab1_NewTabIni("tab1");
        </script>
	</body>
</html>

