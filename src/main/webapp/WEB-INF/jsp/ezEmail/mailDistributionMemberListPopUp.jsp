<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
		<title><spring:message code='ezEmail.userDL14'/></title>
	    <script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls/ListView_list.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/treeview_namespace.htc.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<style>
			.txt_color {font-weight:bold; }
			.DL_title {
				box-sizing: border-box;
				height: 31px;
				padding: 5px 10px;
			}
			.DL_title > div{ display:inline-block; }
			.mainlist tr th {text-align: center; }
			
			.DL_Table { width: 100%; text-align: center; }
	    	.DL_Table thead tr, tbody tr{ height:30px; }
	    	.DL_Table tbody tr{
	    		height:30px;
			    border-bottom: 1px solid #d2d2d2;
	    	}
	    	.DL_Table tr>*:nth-child(1) { width: 25%; }
	    	.DL_Table tr>*:nth-child(2) { text-align: left; }
	    	.DL_Table tr>*:nth-child(3) { width: 25%; }
	    	.DL_Table tr>*:nth-child(4) { width: 20%; }
	    	
	    	#DL_Head th{ border: none; }
	    	.DL_Body_div {
		    	width: 100%;
			    overflow-y: auto;
		    }
	    </style>
	</head>
	<body class="popup" style="overflow:hidden;">
		<div id="normalScreen">
  			<div id="menu"></div>
  			<div id="close">
    			<ul>
      				<li><span onClick="window.close()"></span></li>
    			</ul>
  			</div>
  			<div style="border:1px solid #eaeaea; margin-top:20px;">
  				<div class="DL_title">
  					<div class="DL_title_sub">
  						<span data-id="${cn} ">${dlName}</span>
  						<span id="countInfo">&nbsp;&nbsp;<span class="txt_color">${memberListCnt}</span><spring:message code='main.t20000' /></span>
  					</div>
  					
  					<div class="DL_title_Btn" style="float:right;">
  						<c:choose>
  							<c:when test="${inCludedChk eq 0}">
		  						<a class="imgbtn"><span onclick="secessionUserDL()"><spring:message code='ezEmail.userDL09' /></span></a>						
  							</c:when>
  							<c:otherwise>
								<a class="imgbtn"><span onclick="joinUserDL()" id="applyBtn"></span></a>
  							</c:otherwise>
  						</c:choose>
  					</div>
  				</div>
  				
  				<div>   
       				<table id="DL_Head" class="mainlist DL_Table" style="width: 100%; border-bottom: 1px solid #eaeaea;"> 
           				<tbody>
	           				<tr>
								<th><spring:message code='main.t76' /></th>
								<th style="text-align: left; "><spring:message code='main.t78' /></th>
								<th><spring:message code='main.t75' /></th>
								<th><spring:message code='ezEmail.userDL15' /></th>
								<th width="4" id="forScroll"></th>
	           				</tr>
						</tbody>
					</table>
					<div class="DL_Body_div" style="height:430px; overflow:auto; ">
						<table id="DL_Body" class="DL_Table"></table>
					</div>
       			</div>
  			</div>
  			
		</div>
	</body>
	<script type="text/javascript">
		var dlCn = "${cn}";
		var dlName = "${dlName}";
		var dlCompanyId = "${dlCompanyId}";
		var dlPolicy = "${dlPolicy}";
		var memberList = "${memberListXML}";
		var memberListCnt = "${memberListCnt}";
		var ownerChk = ${ownerChk}; // boolean
		var inCludedChk = ${inCludedChk}; // 0 or -1
		var appliedChk = ${appliedChk}; // 0 or -1
		
		window.onload = window_onload;
		
		function window_onload() {
			var parser = new DOMParser();
			var xmlDoc = parser.parseFromString(memberList,"text/xml");
			
			if (inCludedChk != 0) {
				setJoin_Btn(appliedChk);
			}
			makeDlMemList(xmlDoc);
		}
		
		function makeDlMemList(data) {
			$("#DL_Body").html("");
			
			var listview = new ListView();
            listview.SetID("DL_Body");
            listview.SetRowOnClick("");
            listview.SetEventSetFlag(false);
            listview.SetSelectFlag(false);
            listview.SetMulSelectable(false);
            listview.SetAlignArr([1,1,1,1,1]);
            listview.DataSource(data);
            listview.RowDataBind();

            $("#DL_Body tr").css("cursor","default");
            isScroll();
		}
	
		function isScroll(){
			var forScroll = $("#DL_Head #forScroll"); 
		
			if ($(".DL_Body_div").height() < $(".DL_Body_div table").height()) {
				forScroll.css("display", "");
			} else {
				forScroll.css("display", "none");
			}
		}
		
		// 탈퇴
		function secessionUserDL() {
			if (ownerChk) {
				alert("<spring:message code='ezEmail.userDL33' />");
				return;
			}
			
			var ret = confirm("<spring:message code='ezEmail.userDL13' />");
        	if (ret) {
				$.ajax({
					type:"post",
					url:"/ezEmail/secessionDistribution.do",
					data:{cn:dlCn},
					success:function(e) {
						alert("<spring:message code='ezEmail.userDL26' />");
						opener.getDLList();
						window.close();
					}, error:function(er) {
						alert("<spring:message code='ezEmail.userDL27' /> ");
					}
				});
        	}
		}
		
		// 가입
		function joinUserDL() {
			var type = appliedChk == 0 ? "del" : "add";
			$.ajax({
				type:"post",
				url:"/ezEmail/mailUserDistributionApply.do",
				data:{
					cn:dlCn,
					type:type
					},
				success:function(e) {
					if (e == "ADD") {
						appliedChk = 0;
						alert("<spring:message code='ezEmail.userDL19' />");
					} else {
						appliedChk = -1;
						alert("<spring:message code='ezEmail.userDL35' />");
					}

					setJoin_Btn(appliedChk);
				}, error:function(er) {
					alert("error");
				}
			});
       	}
		
		function setJoin_Btn() {
			if (appliedChk == 0) {
				$("#applyBtn").text("<spring:message code='ezEmail.userDL34' />");
			} else {
				$("#applyBtn").text("<spring:message code='ezEmail.userDL10' />");
			}
		}
		
	</script>
</html>