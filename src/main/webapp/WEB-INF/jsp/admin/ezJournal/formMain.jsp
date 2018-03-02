<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezJournal.t3' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript">		    
		    var companyId = "";
		    var typeId = "";
		    var formId = "";
		    var selFormId = "";
		    var pEditor = "<c:out value = '${useEditor}'/>";
	    
			$(document).ready(function() {
				companyId = $("#SCompID").val();
			   	var firstType = $("#formType").find("td:first");
				getFormList(firstType);
				
			});
	
			// 양식리스트 중 하나가 선택되었을 때 스타일 지정 및 선택된 양식 아이디 저장
			function listClick(val) {
		    	selFormId = $(val).attr("formid");
		    	
				$(".formList tr").removeClass("active");
				$(val).addClass("active");
		    	
		    }
			
			// 선택된 일지양식함의 양식리스트 가져오기
			function getFormList(val) {	
				typeId = $(val).attr("value");
				$(".bold").css("font-weight", "normal");
				$(val).find("span").css("font-weight", "bold");
				
			    $.ajax({
		    		type : "POST",
		    		dataType : "html",
		    		async : false,
		    		url : "/admin/ezJournal/getFormList.do",
		    		data : {"companyId"  : companyId,
    						"typeId"	  : typeId},
		    		success: function(result) {
		    			$("#formList").html(result);
		    			/*
		    			var $formList = $("#formList");
		    			var listhtml = "";
		    			$formList.html("");
		    			if (result.length > 0) {
			    			$.each(result, function(index, item) {
				    			listhtml += "<tr formId=" + item.formId + " onclick='listClick(this)'>";
				    			listhtml += "<td>" + (index + 1) + "</td>";
				    			listhtml += "<td>" + item.formName + "</td>";
				    			if (item.depts.length > 1) {
					    			listhtml += "<td>" + item.depts[0].deptName + " <spring:message code='ezJournal.t124'/> " + (item.depts.length - 1) + "</td>";
				    			} else {
					    			listhtml += "<td>" + item.depts[0].deptName + "</td>";
				    			}
				    			listhtml += "<td>" + item.formInfo + "</td>";
				    			listhtml += "<td>" + item.formDate.slice(0, 10) + "</td>";
				    			listhtml += "</tr>";
			    			});
		    			} else {
		    				listhtml += "<tr><td colspan='5' style='text-align: center;'><spring:message code='ezJournal.t125'/></td></tr>";
		    			}
		    			$formList.html(listhtml);
		    			*/
		    		},
		    		error : function(request, status, error) {
		    			alert("code : " + request.status + "\nerror : " + error);
		    		}
		    		
		        });
			    
			}			
		    
			// 회사선택시 각 회사에서 사용하는 양식함 로드
		    function selectCompanyList(val) {
				var url = "/admin/ezJournal/form.do";
				parent.frames["right"].location.href = url+ "?companyId=" + val;
		    }
		    
			// 양식추가버튼
		    function btnInsForm() {
		    //	console.log(typeId + " " + companyId + " " + pEditor);
		    	var url = "";
		    	var parameter = "?companyId=" + encodeURIComponent(companyId) + "&typeId=" + encodeURIComponent(typeId);
		    	
		    	if (pEditor == "CK" || pEditor == "DEXT" || pEditor == "NAMO" || pEditor == "TAGFREE" || pEditor == "KUKUDOCS") {
		    		url = "/admin/ezJournal/insertFormOther.do"	
		    	} else {
			    	url = "/admin/ezJournal/insertForm.do";
		    	}
		    	
		    	GetOpenWindow(url + parameter, "FormMain", 830, 950, "no");
		    }
		    
			// 양식수정버튼
		    function btnModForm() {
		    	var url = "";
		    	var parameter = "?companyId=" + encodeURIComponent(companyId) + "&typeId=" + encodeURIComponent(typeId)
		    			+ "&formId=" + encodeURIComponent(selFormId);
		    	
		    	if (pEditor == "CK" || pEditor == "DEXT" || pEditor == "NAMO" || pEditor == "TAGFREE" || pEditor == "KUKUDOCS") {
		    		url = "/admin/ezJournal/insertFormOther.do"	
		    	} else {
			    	url = "/admin/ezJournal/insertForm.do";
		    	}
		    	
		    	GetOpenWindow(url + parameter, "FormMain", 830, 950, "no");
		    }
		    
			// 양식삭제버튼
		    function btnDelForm() {
		    	
		    	if (selFormId != null) {
		    		if (confirm("<spring:message code = 'ezApprovalG.t999933' />") == true) {
		    			
		    			$.ajax({
		    				type : "POST",
		    				url : "/admin/ezJournal/deleteForm.do",
		    				asnyc : false,
		    				data : {"formId"	 : selFormId,
		    						"companyId"  : companyId,
		    						"typeId" 	 : typeId},
		    				success : function (result) {
		    					alert("<spring:message code='ezJournal.t129'/>");
		    					parent.frames["right"].location.reload();
		    				},
		    				error : function(request, status, error) {
		    					alert("code : " + request.status + "\nerror : " + error);
		    				}
		    			});
		    		}
		    	}
		    	
		    }
		    
		</script>
		<style>
			ul.formType {
				list-style: none;
				padding: 0px;
				margin: 0px;
				
				max-width: 200px;
				width: 100%;
			}
			
			ul.formType li {
				border-bottom: 1px solid #efefef;
				font-size: 12px;
				height: 30px;
				vertical-align: middle;
				text-align : center;
			}
			
			ul.formType li span {display: inline-block; vertical-align: middle;  }
			
			.content td {
				text-align: center;
			}
			
			table td {
				height: 25px;
				font-size: 15px;
			}
			
			#formType td {
				text-align: center;
				font-style: inherit;
				
			}
			
			#formType tr:hover,  #formList tr:hover {background:#eee; color:#fff; cursor: pointer;}
			.active {background: rgb(233, 241, 255);}
			
		</style>
	</head>
	<body class="mainbody"> 
		<h1><spring:message code='ezJournal.t3' /></h1>
		<div id="mainmenu">
			<span><b><spring:message code = 'ezJournal.t11' /></b>
	            <select id="SCompID" name="SCompID" onchange="selectCompanyList(this.value)">
	            	<c:forEach var="company" items="${companyList}">
	            		<option value="<c:out value='${company.companyId}'/>"
	            		<c:if test="${company.selected eq 'selected'}">
		            		 selected
	            		</c:if>
		            		 ><c:out value='${company.companyName}'/></option>
	            	</c:forEach>
	            </select><br/><br/>
            </span>
            <ul>
            	<li id="btnInsertForm"><span onclick="return btnInsForm()"><spring:message code='ezJournal.t17' /></span></li>
            	<li id="btnModForm"><span onclick="return btnModForm()"><spring:message code='ezJournal.t18' /></span></li>
            	<li id="btnDeleteForm"><span onclick="return btnDelForm()"><spring:message code='ezJournal.t19' /></span></li>
            </ul>
		</div>
		
		<table style="margin-top:5px;width:1005px;height:500px">
			<tr>
		    	<td style="width:200px; vertical-align:top">
		    		<div class="listview">
						<div style="vertical-align:top; height:500px; border: none; width:100%; overflow-x:auto;overflow-y:auto;/* BORDER:#b6b6b6 1px solid; */ BACKGROUND-COLOR:#ffffff" >
							<table id="formType" class="mainlist" style="width: 100%; border-width: 0px 0px 1px 0px;">
								<tr>
									<th style="text-align: center;"><spring:message code='ezJournal.t12'/></th>
								</tr>
								<c:forEach items="${typeList}" var="type">
									<tr>
										<td value="${type.journaltypeId }" onclick="getFormList(this)"><span class="bold"><spring:message code='${type.journaltypeId}'/></span></td>
									</tr>
								</c:forEach>
							</table>
						</div>
					</div>
				</td>
		    	<td style="width:800px; padding-left:5px; padding-right:5px;vertical-align:top">
		    		<div class="listview">
			        	<div id="divlvtForm" style="WIDTH: 100%; HEIGHT: 500px;overflow-x:auto;overflow-y:auto; padding:0px; /* border:1px solid #bdbdbd; */"  >
			        		<table class="mainlist" style="width: 100%;">
			        			<thead>
			        				<tr>
			        					<th style="width: 7%; text-align: center;"><spring:message code='ezJournal.t21'/></th>
			        					<th style="width: 20%"><spring:message code='ezJournal.t22'/></th>
			        					<th style="width: 20%"><spring:message code='ezJournal.t23'/></th>
			        					<th style="width: 35%"><spring:message code='ezJournal.t24'/></th>
			        					<th style="width: 13%"><spring:message code='ezJournal.t25'/></th>
			        				</tr>
			        			</thead>
			        			<tbody id="formList" class="formList" style="margin: 0; padding: 0;" ondblclick="btnModForm()">
			        			</tbody>
			        		</table>
			        	</div>
			        </div>
				</td>    
		  	</tr>
		</table>
	</body>
</html>

