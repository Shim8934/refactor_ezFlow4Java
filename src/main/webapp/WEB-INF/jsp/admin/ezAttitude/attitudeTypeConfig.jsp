<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code = 'ezAttitude.t3' /></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezAttitude/ListView_list.js')}"></script>
	    <script type="text/javascript">
	    	var adminCompany = "${adminCompany}";
	    	var selectTypeId = "";
	    	var isAdd = "";
	    
	        $(document).ready(function() {
		        if (document.getElementById("ListCompany").length == 0) {
		            alert("<spring:message code = 'ezAttitude.t32' />");
		        } else {
		    		if (adminCompany != null) {
		    			$('#ListCompany').val(adminCompany);
		    			if (document.getElementById("ListCompany").selectedIndex < 0) {
				            document.getElementById("ListCompany").selectedIndex = 0;
		    			}
		    		} else {
			            document.getElementById("ListCompany").selectedIndex = 0;
		    		}
		            company_change();
		        }
	        });
	        
	        function company_change() {
	            selectTypeId = "";
	            $.ajax({
	            	type : "GET",
	            	url : "/admin/ezAttitude/attitudeTypeConfigInfo.do",
	            	dataType : "json",
	            	data : {companyId : encodeURIComponent($("#ListCompany").val())},
	            	success : function(result) {
	            		//리스트 셋팅
	            		listSet(result);
	            		//radio 체크
	            		useSelect(result);
	            	},
	            	error : function() {
	            		alert("<spring:message code='ezAttitude.t175' />");
	            	}
	            });
	        }
	        
	        function listSet(result) {
                var html = "";
                if (result.length != null && result.length != 0) {
	                for (var i = 0; i < result.length; i++) {
	                    var gubun = "";
	                    
	                    if (result[i].isAdd == "0") {
	                    	gubun = "<spring:message code='ezAttitude.t179' />";
	                    } else {
	                    	gubun = "<spring:message code='ezAttitude.t180' />";
	                    }
	                    
	                    html += "<tr id='" + result[i].typeId + "' onclick='listClick(this);' ondblclick='dbclick(this);' style='cursor:pointer;' isAdd='" + result[i].isAdd + "'>";
	                    html += "<td style='width:110px;color:gray;border-left:1px solid #e2e2e1;padding-left:15px;text-overflow:ellipsis;white-space:nowrap;overflow:hidden;' title='" + result[i].typeName + "'>" + result[i].typeName + "</td>";
	                    html += "<td style='width:110px;color:gray;text-align:center;border-left:1px solid rgb(239, 239, 239);'>" + gubun + "</td>";
	                    html += "<td style='width:90px;color:gray;text-align:center;border-left:1px solid rgb(239, 239, 239);'><input type='radio' name='useRadio"+ i +"' value='1' /></td>";
	                    html += "<td style='color:gray;text-align:center;border-left:1px solid rgb(239, 239, 239); border-right:1px solid #e2e2e1;'><input type='radio' name='useRadio"+ i +"' value='0' /></td>";
	                    html += "</tr>";
	                }
                } else {
    	    		html = "<tr><td colspan='4' style='text-align:center'><spring:message code='ezAttitude.t130' /></td></tr>";	
                }
                
                $("table.mainlist tbody").html(html);
	        }
	        
	        function useSelect(result) {
	        	for (var i = 0; i < result.length; i++) {
	        		$('table input[name=useRadio'+ i +']:input[value=' + result[i].isuse + ']').prop('checked', true);
 	        	}
	        }
	        
	        //유형 사용여부 일괄저장
	        function save_config() {
	        	var length = $('table input[name^=useRadio]').length / 2;
	        	var list = [];
	        	
	        	for (var i = 0; i < length; i++) {
	        		var typeId = $('table input[name=useRadio' + i + ']').closest('tr').attr('id');
	        		var isuse = $('table input[name=useRadio' + i + ']:checked').val();
	        		var obj = typeId + ',' + isuse + ";";
	        		
	        		if (i == (length-1)) {
	        			obj.slice(0, -1);
	        		}
	        		
	        		list.push(obj);
	        	}
	        	
	        	var typestr = list.join('');
	        	
	            $.ajax({
	            	type : "POST",
	            	url : "/admin/ezAttitude/saveAttitudeTypeConfig.do",
	            	dataType : "text",
	            	data : {
	            		"typeList" : typestr,
	            		"companyId" : encodeURIComponent($("#ListCompany").val())
	            	},
	            	success : function(resultStatus) {
	            		if (resultStatus == "success") {
		            		alert("<spring:message code='ezAttitude.t155' />");
	            		} else {
	            			alert("<spring:message code='ezAttitude.t175' />");
	            		}
	            	},
	            	error : function() {
	            		alert("<spring:message code='ezAttitude.t175' />");
	            	}
	            });
	        }
	        
	        var saveType_dialogArguments = new Array();
	        //유형 추가
	        function add_type() {
	        	if ($("#contentlist .mainlist tbody tr").length < 15) {
	        		var url = "/admin/ezAttitude/addAttitudeType.do?companyId=" + encodeURIComponent($("#ListCompany").val());
					
					window.open(url, "saveAttitudeType", GetOpenWindowfeature(525, 170));
	        	} else {
	        		alert("<spring:message code='ezAttitude.t223'/>");
	        	}
	        }
	        //유형 삭제
	        function del_type() {
	        	if (selectTypeId == null || selectTypeId == "") {
	        		alert("<spring:message code='ezAttitude.t181' />");
	        		return;
	        	}
	        	
	        	if (isAdd == 0) {
	        		alert("<spring:message code='ezAttitude.t182' />");
	        		return;
	        	}
	        	
	        	if (confirm("<spring:message code='ezAttitude.t183' />")) {
					$.ajax({
						type : "POST",
						url : "/admin/ezAttitude/deleteAttitudeType.do",
						dataType : "text",
						data : {
							typeId : selectTypeId,
							companyId : encodeURIComponent($("#ListCompany").val())
						},
						success : function(result) {
							if (result == "false") {
								alert("<spring:message code='ezAttitude.t184' />");
							} else {
								company_change();
							}
						},
						error : function() {
							alert("<spring:message code='ezAttitude.t175' />");
						}
					});
	        	}
	        }
	        
	        //수정버튼
	        function mod_type() {
	        	if (selectTypeId == null || selectTypeId == "") {
	        		alert("<spring:message code='ezAttitude.t181' />");
	        		return;
	        	}

	        	var url = "/admin/ezAttitude/showAttitudeType.do?companyId=" + encodeURIComponent($("#ListCompany").val()) + "&typeId=" + selectTypeId;
				
				window.open(url, "showAttitudeType", GetOpenWindowfeature(525, 170));
	        }
	        
	        function listClick(elem) {
	        	selectTypeId = $(elem).attr('id');
	        	isAdd = $(elem).attr('isAdd'); 
	        }
	        
	        //유형 상세보기(수정창)
	        function dbclick(elem) {
	        	var url = "/admin/ezAttitude/showAttitudeType.do?companyId=" + encodeURIComponent($("#ListCompany").val()) + "&typeId=" + elem.id;
	        	
				window.open(url, "showAttitudeType", GetOpenWindowfeature(525, 170));
	        }
		    
	    </script>
	</head>
	<body class="mainbody">
	    <h1>
	    	<spring:message code='ezAttitude.t3' />
		    <span class="title_bar"><img src="/images/name_bar.gif"></span>
	    	<select class="companySelect" name="ListCompany" id="ListCompany" onchange="company_change()" style="margin-bottom:10px">
				<c:forEach var="item" items="${list}">
					<option value="<c:out value='${item.cn}'/>"><c:out value='${item.displayName}'/></option>
				</c:forEach>
      		</select>
	    </h1>
		<div id="mainmenu">
	      	<ul>
	      		<%-- <li class="important"><span onclick="add_type()"><spring:message code='ezAttitude.t176' /></span></li> --%>
	      		<li><span onclick="mod_type()"><spring:message code='ezAttitude.t177' /></span></li>
	      		<!-- <li><span class="icon16 icon16_delete" onclick="del_type()"></span></li> -->
	      	</ul>
	  	</div>
		<table class="mainlist" style="width: 450px; max-height:500px;">
			<thead>
			<tr>
				<th style="width: 110px;padding-left:15px;border-left:1px solid #e2e2e1;"><span><spring:message code='ezAttitude.t35' /></span></th>
				<th style="width: 110px;text-align: center;"><span><spring:message code='ezAttitude.t185' /></span></th>
				<th style="width: 90px;text-align: center;"><span><spring:message code='ezAttitude.t36' /></span></th>
				<th style="text-align: center;border-right:1px solid #e2e2e1;"><span><spring:message code='ezAttitude.t37' /></span></th>
		 	</tr>
			</thead>
			<tbody id="contentlist">
		 		<tr>
					<td style="text-align: center;"><img src="/images/email/progress_img.gif"/></td>
				</tr>
			</tbody>
		</table>
		<table style="border: 0; border-collapse: collapse; border-spacing: 0; padding: 0px; width: 450px;">
	        <tbody>
	        	<tr>
		            <td>
		            	<div class="btnpositionJsp">
		                	<a class="imgbtn"><span onclick="save_config()"><spring:message code='ezAttitude.t16' /></span></a>
		                	<a class="imgbtn"><span onclick="company_change()"><spring:message code='ezAttitude.t34' /></span></a>
		                </div>	
		            </td>
		        </tr>
	    	</tbody>
	    </table>
		<script type="text/javascript">
		    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
	</body>
</html>
