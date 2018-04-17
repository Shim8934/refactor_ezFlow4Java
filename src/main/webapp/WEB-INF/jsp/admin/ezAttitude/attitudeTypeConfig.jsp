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
	    <script type="text/javascript">
	    	var adminCompany = "${adminCompany}";
	    
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
	            		 //휴가유형이 없습니다 는 멘트를 출력시키자.****************************************
	            	}
	            });
	        }
	        
	        function listSet(result) {
                var html = "";
                for (var i = 0; i < result.length; i++) {
                    html += "<tr id='" + result[i].typeId + "' ondblclick='dbclick(this);' style='cursor: pointer;'>";
                    html += "<td style='width:35%;color:gray;'>" + result[i].typeName + "</td>";
                    html += "<td style='width:45%;color:gray;'><input type='radio' name='useRadio"+ i +"' value='1' /> 사용 <input type='radio' name='useRadio"+ i +"' value='0' />사용안함</td>";
                    html += "<td style='width:20%;color:gray;'><img id='icon' src='"+ result[i].imgPath +"' width='16px;' height='16px;' alt='' border='0'></td>";
                    html += "</tr>";
                }
                $("#contentlist table.mainlist").html(html);
	        }
	        
	        function useSelect(result) {
	        	for (var i = 0; i < result.length; i++) {
	        		$('table.mainlist input[name=useRadio'+ i +']:input[value=' + result[i].isuse + ']').prop('checked', true);
 	        	}
	        }
	        
	        function save_config() {
	        	var length = $('table.mainlist input[name^=useRadio]').length / 2;
	        	var list = [];
	        	for (var i = 0; i < length; i++) {
	        		var typeId = $('table.mainlist input[name=useRadio' + i + ']').closest('tr').attr('id');
	        		var isuse = $('table.mainlist input[name=useRadio' + i + ']:checked').val();
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
// 	            	saveType_dialogArguments[1] = save_type_Complete;
                    var OpenWin = window.open("/admin/ezAttitude/addAttitudeType.do?companyId=" + $("#ListCompany").val(), "SaveAttitudeType", 'width=540px, height=185px', GetOpenWindowfeature(800, 520));
                    
                    try { OpenWin.focus(); } catch (e) { }
	            } else {
                	rtnValue = window.showModalDialog("/admin/ezAttitude/addAttitudeType.do", $("#ListCompany").val(),
                        "dialogHeight:185px;dialogwidth:540px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(800, 520));
	                
	                if (typeof (rtnValue) != "undefined") {
	                    company_change();
	                }
	            }
	        }
	        //유형 상세보기
	        function dbclick(obj) {
	        	saveType_dialogArguments[0] = $("#ListCompany").val();
//             	saveType_dialogArguments[1] = save_type_Complete;
            	var typeId = obj.id;
	        	var OpenWin = window.open("/admin/ezAttitude/showAttitudeType.do?typeId=" + typeId + "&companyId=" + $("#ListCompany").val(), "SaveAttitudeType", GetOpenWindowfeature(800, 520));
	        	
	        	try { OpenWin.focus(); } catch (e) { }
	        }
		    
	    </script>
	</head>
	<body class="mainbody">
	    <h1><spring:message code='ezAttitude.t12' /></h1>
		<div id="mainmenu">
			<span style="border: none;"><b><spring:message code='ezAttitude.t15' /></b></span>
			<select name="ListCompany" id="ListCompany" onchange="company_change()" style="margin-bottom:10px">
				<c:forEach var="item" items="${list}">
				<option value="<c:out value='${item.cn}'/>"><c:out value='${item.displayName}'/></option>
				</c:forEach>
	      	</select>
	      	<ul>
	      		<li><span onclick="add_type()"><spring:message code='ezAttitude.t33' /></span></li>
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
                                <th style="width: 35%;"><span><spring:message code='ezAttitude.t35' /></span></th>
                                <th style="width: 45%;"><span><spring:message code='ezAttitude.t36' /></span></th>
                                <th style="width: 20%;"><span><spring:message code='ezAttitude.t37' /></span></th>
                            </tr>
                        </table>
                        <div id="contentlist" name="contentlist" style="height: 400px; overflow-y: auto;">
                            <table class="mainlist" style="width: 100%;">
<!--                                 <tr> -->
<!--                                     <td style="text-align: center;"> -->
<!--                                         <img src="/images/email/progress_img.gif" /> -->
<!--                                     </td> -->
<!--                                 </tr> -->
                            </table>
                        </div>
                    </div>
                </td>
            </tr>
        </table>
		<script type="text/javascript">
		    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
<!--****************************************************페이징자리******************************************************************** -->
	</body>
</html>
