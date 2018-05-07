<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title>attitudeTypeConfig</title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezAttitude.i1' />" type="text/css">
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/Common.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/ezAttitude/ListView_list.js"></script>
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
		    		} else {
			            document.getElementById("ListCompany").selectedIndex = 0;
		    		}
		            company_change();
		        }
	        });
	        
	        function company_change() {
	            $.ajax({
	            	type : "GET",
	            	url : "/admin/ezAttitude/attitudeTypeConfigInfo.do",
	            	dataType : "json",
	            	data : {companyId : encodeURI($("#ListCompany").val())},
	            	success : function(result) {
	            		listSet(result);
	            		useSelect(result);
	            	},
	            	error : function() {
	            		alert("리스트를 가져오는 도중 에러 발생");
	            	}
	            });
	        }
	        
	        function listSet(result) {
                var html = "";
                if (result.length != null && result.length != 0) {
	                for (var i = 0; i < result.length; i++) {
	                    var gubun = "";
	                    if (result[i].isAdd == "0") {
	                    	gubun = "기본";
	                    } else {
	                    	gubun = "추가";
	                    }
	                    html += "<tr id='" + result[i].typeId + "' onclick='listClick(this);' ondblclick='dbclick(this);' style='cursor: pointer;' isAdd='" + result[i].isAdd + "'>";
	                    html += "<td style='width:35%;color:gray;padding-left:15px;'>" + result[i].typeName + "</td>";
	                    html += "<td style='width:25%;color:gray;padding-left:15px;'>" + gubun + "</td>";
	                    html += "<td style='width:20%;color:gray;text-align: center;'><input type='radio' name='useRadio"+ i +"' value='1' /></td>";
	                    html += "<td style='width:20%;color:gray;text-align: center;'><input type='radio' name='useRadio"+ i +"' value='0' /></td>";
	                    html += "</tr>";
	                }
                } else {
    	    		html = "<tr><td colspan='3' style='text-align:center'>등록된 정보가 없습니다.</td></tr>";	
                }
                $("#contentlist table").html(html);
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
	        		var obj = '';
	        		obj += typeId + ',' + isuse + ";";
	        		if (i == (length-1)) {
	        			obj.slice(0, -1);
	        		}
	        		list.push(obj);
	        	}
	        	
	        	var typestr = list.join('');
	        	
	            $.ajax({
	            	type : "POST",
	            	url : "/admin/ezAttitude/saveAttitudeTypeConfig.do",
	            	data : {
	            		"typelist" : typestr,
	            		"companyId" : encodeURI($("#ListCompany").val())
	            	},
	            	success : function() {
	            		alert('저장되었습니다');
	            	},
	            	error : function() {
	            		alert('저장하는 중 오류 발생');
	            	}
	            });        	
	        }
	        
	        var saveType_dialogArguments = new Array();
	        //유형 추가
	        function add_type() {
	            if (CrossYN()) {
	            	saveType_dialogArguments[0] = $("#ListCompany").val();
                    var OpenWin = window.open("/admin/ezAttitude/addAttitudeType.do?companyId=" + $("#ListCompany").val(), "SaveAttitudeType", 'width=525px, height=170px', GetOpenWindowfeature(800, 520));
                    
                    try { OpenWin.focus(); } catch (e) { }
	            } else {
                	rtnValue = window.showModalDialog("/admin/ezAttitude/addAttitudeType.do", $("#ListCompany").val(),
                        "dialogHeight:155px;dialogwidth:540px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(800, 520));
	                
	                if (typeof (rtnValue) != "undefined") {
	                    company_change();
	                }
	            }
	        }
	        //유형 삭제
	        function del_type() {
	        	if (selectTypeId == null || selectTypeId == "") {
	        		alert("유형을 먼저 선택해 주세요");
	        		return;
	        	}
	        	
	        	if (isAdd == 0) {
	        		alert("기본유형은 삭제할 수 없습니다.");
	        		return;
	        	}
	        	
	        	if (confirm("정말로 삭제하시겠습니까?")) {
					$.ajax({
						type : "POST",
						url : "/admin/ezAttitude/deleteAttitudeType.do",
						dataType : "text",
						data : {
							typeId : selectTypeId,
							companyId : encodeURI($("#ListCompany").val())
						},
						success : function(result) {
							if (result == "false") {
								alert("현재 사용중인 유형입니다.");
							} else {
								alert("삭제되었습니다.");
								company_change();
							}
						},
						error : function() {
							alert("삭제하는 도중 오류 발생");
						}
					})
	        	}
	        }
	        
	        //수정버튼
	        function mod_type() {
	        	dbclick(selectTypeId);
	        }
	        
	        function listClick(elem) {
	        	selectTypeId = $(elem).attr('id');
	        	isAdd = $(elem).attr('isAdd'); 
	        }
	        
	        //유형 상세보기(수정창)
	        function dbclick(elem) {
	        	saveType_dialogArguments[0] = $("#ListCompany").val();
            	var typeId = elem.id;
	        	var OpenWin = window.open("/admin/ezAttitude/showAttitudeType.do?typeId=" + typeId + "&companyId=" + $("#ListCompany").val(), "SaveAttitudeType", 'width=525px, height=170px', GetOpenWindowfeature(800, 520));
	        	
	        	try { OpenWin.focus(); } catch (e) { }
	        }
		    
	    </script>
	</head>
	<body class="mainbody">
	    <h1><spring:message code='ezAttitude.t12' /></h1>
		<div id="mainmenu">
			<ul>
	        	<li style="background: none;">
				<span style="border: none;"><b><spring:message code='ezAttitude.t15' /></b></span>
				</li>
				<li>
				<select name="ListCompany" id="ListCompany" onchange="company_change()" style="margin-bottom:10px">
					<c:forEach var="item" items="${list}">
					<option value="<c:out value='${item.cn}'/>"><c:out value='${item.displayName}'/></option>
					</c:forEach>
	      		</select>
	      		</li>
	      	</ul>
	      	<ul>
<%-- 	      		<li><span onclick="add_type()"><spring:message code='ezAttitude.t33' /></span></li> --%>
	      		<li><span onclick="add_type()">추가</span></li>
	      		<li><span onclick="mod_type()">수정</span></li>
	      		<li><span onclick="del_type()">삭제</span></li>
	      		<li style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></li>
	      		<li><span onclick="save_config()"><spring:message code='ezAttitude.t16' /></span></li>
	      		<li><span onclick="company_change()"><spring:message code='ezAttitude.t34' /></span></li>
	      	</ul>
	  	</div>
	  	<table style="width: 450px; height: 380px;" >
            <tr>
                <td>
                    <div style="border: 1px solid #dbdbda;border-top:0px; width: 100%; height: 100%;">
                        <table class="mainlist" style="width: 100%;">
                            <tr>
                                <th style="width: 25%;padding-left:15px;"><span><spring:message code='ezAttitude.t35' /></span></th>
                                <th style="width: 35%;text-align: center;"><span>구분</span></th>
                                <th style="width: 20%;text-align: center;"><span><spring:message code='ezAttitude.t36' /></span></th>
                                <th style="width: 20%;text-align: center;"><span><spring:message code='ezAttitude.t37' /></span></th>
                            </tr>
                        </table>
                        <div id="contentlist" name="contentlist" style="height: 350px; overflow-y: auto;">
                        	<table class="mainlist" style="width: 100%;">
                                <tr>
                                    <td style="text-align: center;">
                                        <img src="/images/email/progress_img.gif"/>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </td>
            </tr>
        </table>
		<script type="text/javascript">
		    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
	</body>
</html>
