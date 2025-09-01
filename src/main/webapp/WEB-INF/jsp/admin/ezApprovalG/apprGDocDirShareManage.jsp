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
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<style>
			ul.ownerList {
				list-style: none;
				padding: 0px;
				margin: 0px;
				
				max-width: 200px;
				width: 100%;
			}
			
			ul.ownerList li {
				border-bottom: 1px solid #efefef;
				font-size: 12px;
				height: 30px;
				vertical-align: middle;
				text-align : center;
			}
			
			ul.ownerList li span {display: inline-block; vertical-align: middle;  }
			
			.content td {
				text-align: center;
			}
			
			table td {
				height: 25px;
				font-size: 15px;
			}
			
			#ownerList td {
				text-align: center;
				font-style: inherit;
				
			}
			
			#ownerList tr:hover,  #shareList tr.shareRow:hover {background:#eee; color:#fff; cursor: pointer;}
			.active {background: #f1f8ff;}
			
		</style>
	</head>
	<body class="mainbody"> 
		<h1>
			<spring:message code='main.t45'/>
		</h1>
		<div id="mainmenu" style="padding-left: 5px;">
            <ul>
            	<li class="important" id="btnInsertForm"><span onclick="insertShare('I');"><spring:message code='ezApprovalG.t268'/></span></li>
            	<li id="btnModForm"><span onclick="insertShare('M')"><spring:message code='ezApprovalG.t269'/></span></li>
            	<li id="btnDeleteForm"><span class="icon16 icon16_delete" onclick="return deleteOwner();"></span></li>
            </ul>
		</div>
		<script type="text/javascript">
		    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		<table style="margin-top:5px;width:100%;height:500px;">
			<tr>
		    	<td style="width:50%; vertical-align:top; padding-left: 5px;">
		    		<div class="listview">
						<div style="vertical-align:top; height:600px; border: none; width:100%; overflow-x:auto;overflow-y:auto;/* BORDER:#b6b6b6 1px solid; */ BACKGROUND-COLOR:#ffffff" >
							<table id="ownerList" class="mainlist ownerList" style="width: 100%; border-width: 0px 0px 1px 0px;">
								<tr>
									<th style="text-align: center; border-top:none;"><spring:message code='ezApprovalG.share02'/></th>
									<th style="text-align: center; border-top:none;"><spring:message code='ezApprovalG.share03'/></th>
								</tr>
								<c:forEach items="${ownerList}" var="owner">
								    <c:choose>
								        <c:when test="${lang eq 1}">
								            <tr onclick="viewShareList(this)" ondblclick="insertShare('M');" ownerId="${owner.ownerId }" ownerName="${owner.ownerName }" ownerType="${owner.ownerType}" ownerCompanyId="${owner.ownerCompanyId}" >
								        </c:when>
								        <c:otherwise>
								            <tr onclick="viewShareList(this)" ondblclick="insertShare('M');" ownerId="${owner.ownerId }" ownerName="${owner.ownerName2 }" ownerType="${owner.ownerType}" ownerCompanyId="${owner.ownerCompanyId}" >
										</c:otherwise>
									</c:choose>

										<td>
										    <c:choose>
										        <c:when test="${lang eq '1'}">
                                                    <c:out value="${owner.ownerName}"></c:out>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:out value="${owner.ownerName2}"></c:out>
                                                </c:otherwise>
                                            </c:choose>
										</td>
										<td>
											<c:if test="${owner.ownerType eq 'U' }">
												<spring:message code='ezApprovalG.share04'/>
											</c:if>
											<c:if test="${owner.ownerType eq 'D' }">
												<spring:message code='ezApprovalG.share05'/>
											</c:if>
										</td>
									</tr>
								</c:forEach>
							</table>
						</div>
					</div>
				</td>
		    	<td style="width:50%; padding-left:5px; padding-right:5px;vertical-align:top">
		    		<div class="listview">
			        	<div id="divlvtForm" style="WIDTH: 100%; HEIGHT: 600px;overflow-x:auto;overflow-y:auto; padding:0px;" >
			        		<table class="mainlist" style="width: 100%;">
			        			<thead>
			        				<tr>
										<th style="text-align: center; border-top:none;"><spring:message code='ezApprovalG.share06'/></th>
										<th style="text-align: center; border-top:none;"><spring:message code='ezApprovalG.share03'/></th>
									</tr>
			        			</thead>
			        			<tbody id="shareList" style="margin: 0; padding: 0;">
			        				<tr>
			        					<td colspan="2" style="border-bottom:none;">
					        				<div id="preview_nodata" class="preview_nodata" style="margin-top: 70px;">
								                  <dl class="nodata_sIcon">
									              <dt><img src="/images/kr/main/noData_sIcon.png"></dt>
									              <dd id="nodata_title" style="font-family: malgun gothic"><spring:message code='ezApprovalG.share07'/></dd>
								                  </dl>
							                 </div>
			        					</td>
			        				</tr>
			        			</tbody>
			        		</table>
			        	</div>
			        </div>
				</td>    
		  	</tr>
		</table>
		<script type="text/javascript">		    
		    var ownerId = "";
		    var ownerName = "";
		    var ownerType = "";
			var ownerCompanyId = "";
		    // 팝업창 호출위한 변수
		    var pheight = window.screen.availHeight;
	        var pwidth = window.screen.availWidth;
	        var pTop = (pheight - 720) / 2;
	        var pLeft = (pwidth - 790) / 2;
    
			$(document).ready(function() {
			});
	
			function viewShareList(elem) {
				ownerId = $(elem).attr("ownerId");
				ownerName = $(elem).attr("ownerName");
				ownerType = $(elem).attr("ownerType");
				ownerCompanyId = $(elem).attr("ownerCompanyId");
				$(".ownerList tr").removeClass("active");
				$(elem).addClass("active");
		    	
				$.ajax({
		    		type : "POST",
		    		url : "/admin/ezApprovalG/getDocDirShareList.do",
		    		data : {"ownerId"  : ownerId}, 
		    		success: function(result) {
		    			$("#shareList").html(result);
		    		},
		    		error : function(request, status, error) {
		    			alert("code : " + request.status + "\nerror : " + error);
		    		}
	    		});
		    }
		    
		    function insertShare(flag) {
		    	if (flag == 'M' && $("tr[class='active']").length <= 0) {
		    		alert(strLang960);
		    		return;
		    	}

				var url = "/admin/ezApprovalG/docDirOwnerInsert.do";
				if(flag == 'M'){
					url += "?ownerId=" + ownerId + "&ownerName=" + encodeURIComponent(ownerName) + "&ownerType=" + encodeURIComponent(ownerType) + "&ownerCompanyId=" + encodeURIComponent(ownerCompanyId);
				}
		    	window.open(url, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=660,width=980,top=" + pTop + ",left=" + pLeft, "");
			}
		    
		    function deleteOwner() {
		    	
		    	/* 2020-09-11 홍승비 - 선택된 공유자 없는 경우 알러트 메세지 추가 (다국어 미적용) */
		    	if ($("tr[class='active']").length <= 0) {
		    		alert(strLang961);
		    		return;
		    	}
		    	
		    	if (!confirm(strLang962)) {
		    		return;
		    	}
		    	
		    	$.ajax({
		    		type : "POST",
		    		url : "/admin/ezApprovalG/deleteDocDirOwner.do",
		    		data : {"ownerId"  : ownerId}, 
		    		success: function(result) {
		    			if(result == "YES"){
		    				alert(strLang963);
		    				location.reload();
		    			} else {
		    				alret(strLang964);
		    			}
		    		},
		    		error : function(request, status, error) {
		    			alert("code : " + request.status + "\nerror : " + error);
		    		}
	    		});
		    }
		</script>
	</body>
</html>

