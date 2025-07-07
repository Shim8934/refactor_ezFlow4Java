<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezJournal.t17' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/jstree/style.css')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jstree/jstree.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezJournal/FormMain_Cross.js')}"></script>
	    <script type="text/javascript">		    
	    	var companyId = "<c:out value='${companyId}'/>";
		    var typeId = "<c:out value='${typeId}'/>";
		    var useEditor = "<c:out value='${useEditor}'/>";
		    var formId = "<c:out value='${formId}'/>";
		    var isFree = false;
		    // 선택된 부서 아이디
		    var selDeptId = "";		
		    // 선택된 부서 배열 (양식을 사용할 부서)
		    var useDeptList = [];
		    // 부서정보가 변했는지 확인하기 위한 flag
		    var isDeptChanged = "N";
		    // 수정시 해당 양식을 사용하는 부서정보와 양식내용을 받음
		    var useDepts = "<c:out value='${useDepts}'/>";		    	
        	var selFormContent = "<c:out value='${formContent}'/>";
        	var selDelDeptId = "";
		    
		    $(document).ready(function() {
		        
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
		        	
		        	if (useDepts != null && useDepts != "") {
			        	useDepts = JSON.parse(useDepts.replace(/&#034;/g, "\""));
		        		useDeptList = useDepts.slice();
		        	//	console.log("useDeptList : " + useDeptList)
		        		$("#setUseDeptList").show();
		        		drawUseDeptList();
		        	}
		        }
			    
		    });
		    
		    window.onload = function() {
// 	    		if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1) {
//                     self.resizeTo(760, 800);
//                 } else {
//                     self.resizeTo(785, 830);
//                 }
		    }
		    
		    // 수정시 양식내용을 에디터에 넣어주는 작업 
		    function Editor_Complete() {
		   
	            if (formId != "" && formId != null) {
	            	selFormContent = selFormContent.replace(/&#034;/g, "\"");
			    	selFormContent = selFormContent.slice(1, -1);
		        	message.SetEditorContent(selFormContent);
                }
		    }
		    
		    // 사용부서 라디오 선택유무에 따라 부서리스트 보여주는 부분
		    function checkUseDept() {
			    if ($("selDeptUseA:checked")) {
			        $("#setUseDeptList").hide();
			    } else {
			        $("#setUseDeptList").show();
			    }
		    }
		    
		    // 일지함 선택
		    function selectTypeList(val) {
		    	typeId = val;
		    }
		    
		    // 양식내용에 정보 넣는 부분(부서명, 작성자, 작성일)
		    function clickFormInfo(elem) {
		    	var info = $(elem).attr("value");
		    	
				if (useEditor == "HWP") {
		    		message.SetAttribute(info);
		    	} else {
		    		if (isFree) {
		    			message.SetAttribute("LOCK", "", "");
		    		} else {
		    			if (message.GetEditorContent().indexOf("@" + info) < 0) {
			    			message.SetAttribute("INIS", info, "FIELD");
		    			} else {
			    			if (confirm("<spring:message code='ezJournal.t169'/>") == true) {
				    			message.SetAttribute("INIS", info, "FIELD");
	                		}
		    			}
		    		}
		    	}
	    	}
		    
		    // 예약어 정보 취소
		    function btnCancel() {
		        message.SetAttribute("DEL", "", "");
		    }
		    	
		    // 부서리스트 그려주는 부분
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
		    		'core'		: {"data" : treeContent, "multiple" : false},
		    		'plugins'	: ["wholerow"],
		    		'themes'	: {"responsive" : true}
		    	});
		    }
		    
		    // 선택한 부서를 배열에 넣어주기
		    function insertDept() {
		    	if (selDeptId === "") {
		    		alert("<spring:message code='ezJournal.t168'/>");
		    		return;
		    	} else {
			    	var deptId = selDeptId;
			    	var deptName = $("#deptTreeView").jstree().get_node(deptId).text;
//			    	var deptName = nodeText.replace(/<(\/)?([a-zA-Z]*)(\s[a-zA-Z]*=[^>]*)?(\s)*(\/)?>/ig, "");
			    //	console.log(deptName);
			    	var chkFlag = true;
			    	isDeptChanged = "Y";
			    	for(var j = 0; j < useDeptList.length; j++) {
			    		if (useDeptList[j].deptId == deptId) {
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
		    } 
		    
		    // 선택된 부서배열에서 특정 부서 삭제
		    function deleteDept() {
		    	if (selDelDeptId === "") {
		    		alert("<spring:message code='ezJournal.t168'/>");
		    		return;
		    	} else {
			    	isDeptChanged = "Y";
			     	for(var j = 0; j < useDeptList.length; j++) {
			    		if (useDeptList[j].deptId === selDelDeptId) {
			    			useDeptList.splice(j, 1);
			    		}
			    	}
			    	drawUseDeptList();
			    	selDelDeptId = "";
		    	}
		    }
		    
		    // 선택된 부서 배열을 토대로 화면에 그리는 곳
		    function drawUseDeptList() {
		    	
		    	var useListHtml = "";     
		    	for (var i = 0; i < useDeptList.length; i++) {
		    		useListHtml += "<tr deptId=" + useDeptList[i].deptId + " onclick='listClick(this)' ondblclick='deleteDept()' style='cursor:pointer;'>";
		    		useListHtml += "<td>";
		    		useListHtml += useDeptList[i].deptName;
		    		useListHtml += "</td>";
		    		useListHtml += "</tr>";
		    	}
		    	$("#useFormDept").html(useListHtml);
		    }
		    
		    // 선택된 부서리스트에서 부서 선택시 스타일주기
		    function listClick(elem) {
		    	selDelDeptId = $(elem).attr("deptId");
		    	
		    	$(".mainlist tr").removeClass("active");
				$(elem).addClass("active");
		    }
		    
		    // 저장버튼
		    function btnSave() {
		    	var formName = $("#tbFormName").val();
		    	var formDescript = $("#tbDescript").val();
		    	var formContent = message.GetEditorContent();
		    	
		    	if (formName == "") {
		    		alert("<spring:message code='ezJournal.t130'/>");
		    		return false;
		    	} else if (formContent == "") {
		    		alert("<spring:message code='ezJournal.t145'/>");
		    		return false;
		    	}
		    	
		    	if ($(":input:radio[name=setUseDept]:checked").val() == "P") {
		    		var useDept = JSON.stringify(useDeptList);	
		    	} else if (($(":input:radio[name=setUseDept]:checked").val() == "A") && formId != null) {
		    		isDeptChanged = "Y";
		    	}
		    	
		    	$.ajax({
		    		type : "POST",
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
						if (result === "ok") {
	    					alert("<spring:message code='ezJournal.t128'/>");
	    					opener.location.reload();
							window.close();    					
						} 
    				},
    				error : function(request, status, error) {
		    			alert("code : " + request.status + "\nmessage: " + request.responseText + "\nerror : " + error);
		    		}
		    	}); 
		    }
		    
		    // 닫기버튼
		    function btnClose() {
		    	window.close();
		    }
		    
		</script>
		<style>
			#infoTbl th { height: 25px;}
			#infoTbl td {
				border: 1px solid #b6b6b6;
				height: 26px;
				padding-left: 5px;
			}
			#infoTbl {padding: 0px;}
			
			.active {background: #f1f8ff;}
			
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
                <li><span id="btnClose" onClick="return btnClose()"></span></li>
            </ul>
        </div>
        <div class="portlet_tabpart01">
	        <div class="portlet_tabpart01_top" id="tab1">
                <p><span divname="JournalForm_div1" id="1tab1"><spring:message code='ezJournal.t28'/></span></p>
                <p><span divname="JournalForm_div2" id="1tab2"><spring:message code='ezJournal.t29'/></span></p>
	        </div>
        </div>
        
        <div id="JournalForm_content1" style="width:100%;height:90%; padding-top:10px; display:none">			
			<table class="content" style="width:100%;">
				<tr>                
					<th style="width:100px; text-align:center"><spring:message code='ezJournal.t22'/></th>
                    <td style="width:50%;">
                        <input type="text" id="tbFormName" name="tbFormName" value="<c:out value='${formName}'/>" maxlength="50" style="width:100%">
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
                        <input type="text" id="tbDescript" name="tbDescript" value="<c:out value='${formInfo}'/>" style="WIDTH: 100%" maxlength="50">
                    </td>
                </tr>
                <tr>
                    <th style="width:100px; text-align:center"><spring:message code='ezJournal.t23'/></th>
					<td colspan="3" style="width:10%; text-align: left;">
						<c:choose>
							<c:when test="${useDepts eq 'null' || useDepts eq null}">
								<div class="custom_radio"><input type="radio" id="selDeptUseA" name="setUseDept" value="A" checked onclick="checkUseDept()"/></div><label for="selDeptUseA"><spring:message code = 'ezJournal.t30' /></label>
								<div class="custom_radio"><input type="radio" id="selDeptUseP" name="setUseDept" value="P" onclick="checkUseDept()"/></div><label for="selDeptUseP"><spring:message code = 'ezJournal.t31' /></label>
							</c:when>
							<c:otherwise>
								<div class="custom_radio"><input type="radio" id="selDeptUseA" name="setUseDept" value="A" onclick="checkUseDept()"/></div><label for="selDeptUseA"><spring:message code = 'ezJournal.t30' /></label>
								<div class="custom_radio"><input type="radio" id="selDeptUseP" name="setUseDept" value="P" checked onclick="checkUseDept()"/></div><label for="selDeptUseP"><spring:message code = 'ezJournal.t31' /></label>
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
			</table>
            <br />
            <br />
            
            <table style="width:100%; margin: auto;" >
				<tr id="setUseDeptList">
					<td style="width: 48%;">
						<div class="box"> 
						<div style="width: 100%; height: 520px; overflow-x: auto; overflow-y: auto;" id="deptTreeView"></div>
						</div>
					</td>
					<td style="width: 30px; text-align: center;">                            
                        <img src="/images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="insertDept()"><br>
                        <img src="/images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="deleteDept()">
                    </td>
                    <td style="width: 48%; vertical-align: top;">
                       	<div class="listview">
                           	<div ondragover ="onDragEnter(event)" ondrop ="onDrop(event, this)" style="width: 100%; Height: 523px; overflow-x: auto; overflow-y: auto;" >
                           		<table id="useFormDept" style="width: 100%; border: 0; padding: 0;" class="mainlist"></table>
                           	</div>
                       	</div>
                   </td>
                </tr>
            </table>
        </div>
        
        <div id="JournalForm_content2" style="width:100%;display:none; padding-top:10px;">
			<div id="editor_content">
				<div id="mainmenu">
                   	<table width="100%" cellpadding="0" cellspacing="0" id="infoTbl">
                   		<tbody>
                   			<tr>
                    			<th style="width: 12%;"><spring:message code='ezJournal.t32'/></th>
                    			<td style="vertical-align: middle; border-right: none;">
					            	<a class="imgbtn imgbck"><span id="info_0" value="journalWriterDept" onclick="clickFormInfo(this)"><spring:message code='ezJournal.t33' /></span></a>
					            	<a class="imgbtn imgbck"><span id="info_1" value="journalWriterName" onclick="clickFormInfo(this)"><spring:message code='ezJournal.t34' /></span></a>
					            	<a class="imgbtn imgbck"><span id="info_2" value="journalWriteDate" onclick="clickFormInfo(this)"><spring:message code='ezJournal.t35' /></span></a>
                    			</td>
                    			<td style="width: 8%; text-align: right; border-left: none; padding-right: 3px;" >
		            				<a class="imgbtn imgbck"><span onclick="btnCancel()"><spring:message code='ezJournal.t16' /></span></a>
                    			</td>
                   			</tr>
                   		</tbody>
                   	</table>
				</div>
				<table id="JournalForm" style="height:670px; width:100%;">
                   	<tr>
                        <td style="height:100%; vertical-align:top">
                        	<iframe id="message" class="viewbox" src="/admin/ezEditor/selectEditor.do?type=JOURNAL&height=670&formID=${formId}" name="message" frameborder="0" style="padding: 0; height: 99%; width: 100%; overflow: auto;"></iframe>
                        </td>
                    </tr>
                </table>  
			</div>
		</div>
        <script type="text/javascript">
        	selToggleList(document.getElementById("menu"), "ul", "li", "0");
            Tab1_NewTabIni("tab1");
        </script>
	</body>
</html>

