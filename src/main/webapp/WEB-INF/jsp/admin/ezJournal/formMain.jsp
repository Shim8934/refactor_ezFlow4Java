<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezJournal.t3' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript">		    
		    var typeId = "";
		    var formId = "";
		    var selFormId = "";
		    var formStatus = "";
		    var pEditor = "<c:out value = '${useEditor}'/>";
		    // 팝업창 호출위한 변수
		    var pheight = window.screen.availHeight;
	        var pwidth = window.screen.availWidth;
	        var pTop = (pheight - 720) / 2;
	        var pLeft = (pwidth - 790) / 2;
    
			$(document).ready(function() {
			   	var firstType = $("#formType").find("td:first");
				getFormList(firstType);
			});
	
			// 양식리스트 중 하나가 선택되었을 때 스타일 지정 및 선택된 양식 아이디 저장
			function listClick(val) {
		    	selFormId = $(val).attr("formid");
		    	formStatus = $(val).attr("formstatus");
				$(".formList tr").removeClass("active");
				$(val).addClass("active");
		    	
		    }
			
			// 선택된 일지양식함의 양식리스트 가져오기
			function getFormList(val) {	
				typeId = $(val).attr("value");
				$(".bold").css("font-weight", "normal");
				$(val).find("span").css("font-weight", "bold");
				selFormId = "";
				formStatus = "";
				
			    $.ajax({
		    		type : "POST",
		    		dataType : "html",
		    		async : false,
		    		url : "/admin/ezJournal/getFormList.do",
		    		data : {"companyId"  : encodeURIComponent(companySelectID),
    						"typeId"	  : typeId},
		    		success: function(result) {
		    			$("#formList").html(result);
		    		},
		    		error : function(request, status, error) {
		    			alert("code : " + request.status + "\nerror : " + error);
		    		}
		        });
			    
			}			
		    
			// 회사선택시 각 회사에서 사용하는 양식함 로드
		    function changeCompany(val) {
				var url = "/admin/ezJournal/form.do";
				parent.document.querySelector("iframe[name=right]").src = url+ "?companyId=" + encodeURIComponent(val);
		    }
		    
			// 양식추가버튼
		    function btnInsForm() {
		    	var url = "/admin/ezJournal/insertForm.do";
		    	url += "?companyId=" + encodeURIComponent(companySelectID) + "&typeId=" + encodeURIComponent(typeId);
		    	
		    	window.open(url, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=820,width=790,top=" + pTop + ",left=" + pLeft, "");
		    //	GetOpenWindow(url + parameter, "FormMain", 830, 950, "yes");
		    }
		    
			// 양식수정버튼
		    function btnModForm() {
				
				if (formStatus == "basic") {
					alert("<spring:message code='ezJournal.t143'/>");
				} else {
					
					if (selFormId == null || selFormId == "") {
						alert("<spring:message code='ezJournal.t166'/>");
						return;
					}
					
			    	var url = "/admin/ezJournal/insertForm.do";
			    	url += "?companyId=" + encodeURIComponent(companySelectID) + "&typeId=" + encodeURIComponent(typeId)
			    			+ "&formId=" + encodeURIComponent(selFormId);
			    	
			    	window.open(url, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=820,width=790,top=" + pTop + ",left=" + pLeft, "");
			    //	GetOpenWindow(url + parameter, "FormMain", 830, 950, "yes");
				}
				
			}
		    
			// 양식삭제버튼
		    function btnDelForm() {
		    	
		    	if (formStatus == "basic") {
					alert("<spring:message code='ezJournal.t144'/>");
		    	} else {

					if (selFormId == null || selFormId == "") {
						alert("<spring:message code='ezJournal.t166'/>");
						return;
					} else {
		    		
		    		// if (selFormId != null) {
			    		if (confirm("<spring:message code = 'ezApprovalG.t999933' />") == true) {
			    			
			    			$.ajax({
			    				type : "POST",
			    				url : "/admin/ezJournal/deleteForm.do",
			    				data : {"formId"	 : selFormId,
			    						"companyId"  : encodeURIComponent(companySelectID),
			    						"typeId" 	 : typeId},
			    				success : function (result) {
			    					if (result === "ok") {
				    					alert("<spring:message code='ezJournal.t129'/>");
				    					parent.frames["right"].location.reload();
			    					}
			    				},
			    				error : function(request, status, error) {
			    					alert("code : " + request.status + "\nerror : " + error);
			    				}
			    			});
		    			}
		    		}
		    	}
		    	
		    }
		    
			// 2025-05-30 황인경 - 업무일지 기본양식 다국어 적용
			function journalListLangChange() {
				var selectedLang = $('#journalListLang option:selected').val();
				if (selectedLang == "none") {
					alert ("<spring:message code='ezJournal.journalList02'/>");
				} else {
					var langMap = { ko: 1, en: 2, jp: 3, zh: 4, vi:5, id: 6};
					selectedLang = !selectedLang ? 1 : langMap[selectedLang] || 1;
					
					$.ajax({
						type : "POST",
						url : "/admin/ezJournal/journulListLangChanege.do",
						data : {"companyId"  : encodeURIComponent(companySelectID),
							"form_lang"  : selectedLang},
						success : function (result) {
							if (result === "ok") {
								alert("<spring:message code='ezPortal.t119'/>");
							}
						},
						error : function(request, status, error) {
							// alert("code : " + request.status + "\nerror : " + error);
							alert("<spring:message code='ezJournal.t149'/>");
						}
					});
				}
			}
			
			window.addEventListener("DOMContentLoaded", function () {
				var savedValue = ${useFormLang}; 
				var langMap = {
				  "1": "ko",
				  "2": "en",
				  "3": "jp",
				  "4": "zh",
				  "5": "vi",
				  "6": "id"
				};
				
				if (langMap[savedValue]) {
				  savedValue = langMap[savedValue];
				}

				var select = document.getElementById('journalListLang');
				if (select) select.value = savedValue;
			});
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
			.active {background: #f1f8ff;}
			
		</style>
	</head>
	<body class="mainbody"> 
		<h1>
			<spring:message code='ezJournal.t3' />
			<jsp:include page="/WEB-INF/jsp/admin/companySelect.jsp">
				<jsp:param name="companySelectID" value="${selectedCompany}" />
			</jsp:include>
		</h1>
		<div id="mainmenu" style="padding-left: 5px;">
            <ul style="width: 998px;">
            	<li class="important" id="btnInsertForm"><span onclick="return btnInsForm()"><spring:message code='ezJournal.t17' /></span></li>
            	<li id="btnModForm"><span onclick="return btnModForm()"><spring:message code='ezJournal.t18' /></span></li>
            	<li id="btnDeleteForm"><span class="icon16 icon16_delete" onclick="return btnDelForm()"></span></li>
            	<li style="float: right"><span onclick="journalListLangChange()"><spring:message code='ezJournal.t135' /></span></li>
				<li style="float: right">
					<select id="journalListLang">
						<option value="none"><spring:message code='ezJournal.journalList01' /></option>
						<option value="ko"><spring:message code='ezPersonal.s81' /></option>
						<option value="en"><spring:message code='ezPersonal.s82' /></option>
						<c:if test="${useJp eq 'YES'}">
							<option value="jp"><spring:message code='ezPersonal.s84' /></option>
						</c:if>
						<c:if test="${useZh eq 'YES'}">
							<option value="zh"><spring:message code='ezPersonal.s85' /></option>
						</c:if>
						<c:if test="${useVi eq 'YES'}">
							<option value="vi"><spring:message code='ezPersonal.s86' /></option>
						</c:if>
						<c:if test="${useId eq 'YES'}">
							<option value="id"><spring:message code='ezPersonal.s87' /></option>
						</c:if>
					</select>
				</li>
            </ul>
		</div>
		<script type="text/javascript">
		    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		<table style="margin-top:5px;width:1005px;height:500px;">
			<tr>
		    	<td style="width:200px; vertical-align:top; padding-left: 5px;">
		    		<div class="listview">
						<div style="vertical-align:top; height:500px; border: none; width:100%; overflow-x:auto;overflow-y:auto;/* BORDER:#b6b6b6 1px solid; */ BACKGROUND-COLOR:#ffffff" >
							<table id="formType" class="mainlist" style="width: 100%; border-width: 0px 0px 1px 0px;">
								<tr>
									<th style="text-align: center; border-top:none;"><spring:message code='ezJournal.t12'/></th>
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
			        	<div id="divlvtForm" style="WIDTH: 100%; HEIGHT: 500px;overflow-x:auto;overflow-y:auto; padding:0px;" >
			        		<table class="mainlist" style="width: 100%;">
			        			<thead>
			        				<tr>
			        					<th style="width: 7%; text-align: center; border-top:none;"><spring:message code='ezJournal.t21'/></th>
			        					<th style="width: 20%; border-top:none;"><spring:message code='ezJournal.t22'/></th>
			        					<th style="width: 20%; border-top:none;"><spring:message code='ezJournal.t23'/></th>
			        					<th style="width: 35%; border-top:none;"><spring:message code='ezJournal.t24'/></th>
			        					<th style="width: 13%; border-top:none;"><spring:message code='ezJournal.t25'/></th>
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

