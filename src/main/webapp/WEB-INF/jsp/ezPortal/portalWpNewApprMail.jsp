<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>		
		<%-- <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		
		<section  class="body_bg1">
			<article id="appr_article" class="appr_mail">
				<div class="tab">
    				<ul>
						<li><img src="/images/<spring:message code='main.t00025' />/main/tab_appro.gif" onclick="change_article('appr')" width="50" height="115"></li>
  						<li><img src="/images/<spring:message code='main.t00025' />/main/tab_mail.gif" onclick="change_article('mail')" width="50" height="115"></li>		
    				</ul>
    			</div>
    			<!-- graph -->
    			<section class="apprgraph">
    				<div class="apprgraph_area">
    					<dl>
    						<dt><spring:message code='main.t00006' /></dt>
    							<dd>
    								<div class="nomal_count">
        								<span id="SIXHGAP">0</span>
        							</div>
     							</dd>
    					</dl>
    					<dl>
    						<dt><spring:message code='main.t00007' /></dt>
    						<dd>
    							<div class="nomal_count">
        							<span id="ONEDGAP">0</span>
        						</div>
        					</dd>
    					</dl>
    					<dl>
    						<dt><spring:message code='main.t00008' /></dt>
    						<dd>
    							<div class="nomal_count">
        							<span id="SEVENDGAP">0</span>
        						</div>
        					</dd>
    					</dl>
    					<dl>
    						<dt><spring:message code='main.t00009' /></dt>
    						<dd>
    							<div class="nomal_count">
        							<span id="ONEMGAP">0</span>
        						</div>
        					</dd>
    					</dl>
    					<dl>
    						<c:choose>
    							<c:when test="${userLang != '3'}">
    								<dt><spring:message code='main.t00010' /></dt>
    							</c:when>
    							<c:otherwise>
    								<dt><spring:message code='main.t00010' /></dt>
    							</c:otherwise>
    						</c:choose>
    						
    						<dd>
    							<div class="point_count">
        							<span id="OTHER" >0</span>
        						</div>
        					</dd>
    					</dl>
    				</div>
    			</section>
     			<!-- /graph -->
    			<!-- list -->
  				<section class="portletbox appr_mailbox"  style="">
          			<div class="title">
          				<span class="tr"></span>
            			<!-- tab -->
            			<dl class="portlet_tab">
              				<dt id="doingTab" onclick="apprChangeTab(this)"  class="on" onmouseover="tabover(this)" onmouseout="tabout(this)"><span><spring:message code='main.t00003' /><span id="doingCNT" class="tab_num">(0)</span></span></dt>
              				<dt id="rejectTab" onclick="apprChangeTab(this)" onmouseover="tabover(this)" onmouseout="tabout(this)"><span><spring:message code='main.t00004' /><span id="rejectCNT" class="tab_num">(0)</span></span></dt>
              				<dt id="draftTab" onclick="apprChangeTab(this)" onmouseover="tabover(this)" onmouseout="tabout(this)"><span><spring:message code='main.t00005' /><span id="draftCNT" class="tab_num">(0)</span></span></dt>
            			</dl>
            			<!-- /tab -->
           				<span class="btn_more"><img onclick="Appmore_btnClick()" src="/images/<spring:message code='main.t00025' />/main/btn_more02.gif" width="35" height="20" alt="<spring:message code='main.t1008' />"></span>
            		</div>
          			<div id ="ApprList" class="appr_mailcont">            
              			<ul class="listtype_txt">
            			</ul>
          			</div>
        		</section>
 				<!-- list -->
 				<div class="guide"><span class="lb"></span><span class="rb"></span></div>
			</article>

    		<article id="mail_article" style="display:none;" class="appr_mail">
				<div class="tab">
    				<ul>
						<li><img src="/images/<spring:message code='main.t00025' />/main/tab_appr.gif" onclick="change_article('appr')" width="50" height="115"></li>
  						<li><img src="/images/<spring:message code='main.t00025' />/main/tab_mailo.gif" onclick="change_article('mail')" width="50" height="115"></li>		
    				</ul>
    			</div>
    			<!-- graph -->
    			<section class="apprgraph">
    				<div class="mailgraph_area">
    					2018-05-25 홍승비 - 메일 용량 표시 변경
    					<div id="mailquatersize" style="width:168px; height:134px;margin-top:-20px;margin-left:-9px;margin-bottom:10px;"></div>
    					<ul>
    						<li><spring:message code='main.t00012' /><strong id="UseMailBox" class="rtxt"></strong></li>
    						<li><spring:message code='main.t00013' /><strong id="MailBoxSize"></strong></li>
    					</ul>
  					</div>
    			</section>
     			<!-- /graph -->
    			<!-- list -->
  				<section class="portletbox appr_mailbox"  style="">
          			<div class="title">
          				<span class="tr"></span>
            				<!-- tab -->
            				<dl class="portlet_tab">
              					<dt  class="on"><span><spring:message code='main.t00014' /><span id="InBoxCNT" class="tab_num">(0)</span></span></dt>
				            </dl>
            				<!-- /tab -->
            				<span class="btn_more"><img onclick="Mailmore_btnClick()" src="/images/<spring:message code='main.t00025' />/main/btn_more02.gif" width="35" height="20" alt="more"></span>
            		</div>
          			<div id="MailList" class="appr_mailcont"></div>
        		</section>
 				<!-- list -->
 				<div class="guide"><span class="lb"></span><span class="rb"></span></div>
			</article>
		</section>
		 --%>
		<link href="${util.addVer('main.e6', 'msg')}" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
		<script src="${util.addVer('/js/jquery/raphael.2.1.0.min.js')}"></script>
		<script src="${util.addVer('/js/jquery/justgage.1.0.1.min.js')}"></script>
		<style type="text/css">
			.apprBox {
			  border: 1px solid #e0e3e4;
			  width: 450px;
			  font-size: 13px;
			  margin-left: 15px;
			}
			.upperBox {
			  width: 100%;
			  height: 20px;
			  background: #e0e3e4
			}
			.upperBox #title {
			  font-weight: bold;
			  text-align: left;
			  width: 70%;
			  float: left
			}
			.upperBox #info {
			  text-align: right;
			  width: 30%;
			  float: left;
			}
			.lowerBox {
			  height: 100px;
			}
			.aprmemInfo {
			  border: 1px solid #e0e3e4;
			  margin-top: 20px;
			  margin-left: 15px;
			  width: 103px;
			  height: 70px;
			  float: left;
			}
			.aprmemInfo .userImg {
			  float: left;
			  width: 60px;
			}
			.aprmemInfo .userStatus {
			  float: right;
			  margin-top: 15px;
			  width: 40px;
			}
			.userStatus #aprstate {
			  width: 35px;
			  margin-top: 3px;
			  padding: 2px;
			  border-radius: 5px;
			  background: #0470e4;
			  text-align: center;
			  color: white;
			}
			.lowerBox .arrowImg {
			  /* border: 1px solid black; */
			  margin-top: 20px;
			  margin-left: 10px;
			  width: 25px;
			  height: 70px;
			  float: left;
			  display: flex;
			  align-items: center;
			}
		</style>
		<script type="text/javascript">
		    var arr_userinfo = new Array();
		    
		    arr_userinfo[0] = "user";
		    arr_userinfo[1] = "${userInfo.id}";
		    arr_userinfo[2] = "${userInfo.displayName1}";
		    arr_userinfo[3] = "${userInfo.title1}";
		    arr_userinfo[4] = "${userInfo.deptID}";
		    arr_userinfo[5] = "${userInfo.deptName1}";
		    //2018-09-18 구해안 부재자정보 추가
		    arr_userinfo[7] = "${buJaeInfo}";
		    arr_userinfo[6] = "${userInfo.jikChek}";
		    arr_userinfo[8] = "${userInfo.email}";  
		    
		    var pUserID = arr_userinfo[1];
		    var companyID = "${userInfo.companyID}";
		    var pListTypeValue = "1";
		    var strLang1_NewApprMail = "<spring:message code='main.t00026' />";
		    var pUse_Editor = "${useEditor}";
		    var pNoneActiveX = "${noneActiveX}";
		    var MailQuater;
		    var selTab = "";
		    
		    document.onselectstart = function () { return false; };
		    
		    window.onload = function() {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }

  		        if ("${type}" == "appr") {
		        	getApprGraph("${type}"); 
		        } else if("${type}" == "mail") {		        		        
		        	getMailGraph();
		        } else if("${type}" == "favo") {
		        	getApprFavo();
		        }
		       /*  getApprGraph();
		        selTab = "doingTab"; */
		        
		        try { top.onresize() } catch (e) { }
		    }
	
		    /**
		    	기존 포탈에서 결재/메일 선택하는 탭
		    */
		    function change_article(flag) {
		        if (flag == "appr") {
		            document.getElementById("appr_article").style.display = "";
		            document.getElementById("mail_article").style.display = "none";
		            getApprGraph();
		        } else {
		            document.getElementById("appr_article").style.display = "none";
		            document.getElementById("mail_article").style.display = "";
		            getMailGraph();
		        }
		    }
	
		    var xmlhttp_getApprGraph_NewApprMail = createXMLHttpRequest();
		    
		    function getApprFavo() {
		    	$.ajax({
		    		type: "post",
		    		dataType: "JSON",
		    		contentType: "application/json",
		    		async: false,
		    		url: "/ezApprovalG/getPortletApprGapTime.do",
		    		data: JSON.stringify({
			 	        pUserID: pUserID, 
			 	        companyID: companyID		    			
		    		}),
		    		success: function(res) {

		    			// 0붙이는게 맞으면 empty삭제하기
		    			$("#SIXHGAP").empty();
		    			$("#ONEDGAP").empty();
		    			$("#SEVENDGAP").empty();
		    			$("#ONEMGAP").empty();
		    			$("#OTHER").empty();
		    			
		    			$("#SIXHGAP").append(res.six > 99 ? '99' : res.six);
		    			$("#ONEDGAP").append(res.day > 99 ? '99' : res.day);
		    			$("#SEVENDGAP").append(res.week > 99 ? '99' : res.week);
		    			$("#ONEMGAP").append(res.month > 99 ? '99' : res.month);
		    			$("#OTHER").append(res.other > 99 ? '99' : res.other);
		    		}
		    	});
		    }
		    
	 	    function getApprGraph(type) {
	 	    	
	 	    	// type이 favo, appr 두가지
	 	    	if(type === "favo") {
			 	    		
	 	    	} else if(type === "appr") {
					$.ajax({
			 	    	type : "POST",
			 	        dataType : "JSON",
			 	        contentType: "application/json",
			 	        async: "false",
			 	        url : "/ezApprovalG/getPortletAprList.do",
			 	        data : JSON.stringify({
			 	        	pListTypeName: pListTypeValue, // 1. 결재할문서, 4. 반송문서, 2. 기안문서  
			 	        	pUserID: pUserID, 
			 	        	companyID: companyID
						}),
						success : function(res){
							$('#ApprList').empty();
							if(pListTypeValue === "1") {
								$(res.list).each(function(index, element) {
									index === 0 ? $('#ApprList').append(dataAssemblerApprLine(element, res.listDtl, res.imgPath)) : $('#ApprList').append(dataAssembler(element)); 
								});													
							} else {
								$(res.list).each(function(index, element) {
									$('#ApprList').append(dataAssembler(element));
								});								
							}
							
							// 데이터가 없는 경우
							if(res.list.length < 1) {
								$('#ApprList').append(noData());
							}
							
							$('#ApprList li').css("cursor", "pointer");
			 	        },
			 	        error : function(error){
			 	        	console.log("<spring:message code='ezBoard.t22'/>wpNewApprMail" + error);	
			 	        }
					});	 	    		
	 	    	}
		    } 		
		    
		    //결재할 문서 첫번째 결재라인 디테일 구성
		    function dataAssemblerApprLine(data, dtl, path) {
		    	var listSize = dtl.length > 3 ? 3 : dtl.length;
		    	var str = "";
		    	
		    	str += '<li class="first_approval" onclick=\'opendocview("'+ data.docID +'", "'+ data.href +'", "'+ data.aprMemberID +'", "'+ data.aprMemberName +'", "'+ data.aprMemberDeptID +'", "'+ data.docState +'", "'+ data.functionType +'", "${userInfo.companyID}")\'>';
		    	//str += '	<p class="approval_tit" onclick=\'opendocview("'+ data.docID +'", "'+ data.href +'", "'+ data.aprMemberID +'", "'+ data.aprMemberName +'", "'+ data.aprMemberDeptID +'", "'+ data.docState +'", "'+ data.functionType +'", "${userInfo.companyID}")\'>'
		    	str += '	<p class="approval_tit">'
		    	str += '	<span class="txt">'+ data.docTitle +'</span><span class="date">'+ data.startDate.substr(5, 11).replace(/-/gi, ".") +'</span><span class="name">'+ data.writerName +'</span></p>';
		    	str += '	<div class="approval_content">';
		    	
		    	for(var i=0; i<listSize; i++){
		    		
		    		console.log("img", dtl[i].ext2);
		    		var imgsrc = dtl[i].ext2 !== null && dtl[i].ext2 !== '' ? "/ezCommon/downloadAttach.do?filePath="+path+"thumbnail/"+dtl[i].ext2 : "/images/kr/main/bestEmployee_pic_none.png";
		    		var apprTextColor = "";
		    		
		    		// 승인 003, 진행 002, 대기, 001
		    		if(dtl[i].aprState === "003") {
		    			apprTextColor = "apprText_blue";
		    		} else if (dtl[i].aprState === "002") {
		    			apprTextColor = "apprText_green";
		    		} else if (dtl[i].aprState === "001") {
		    			apprTextColor = "apprText_orange";
		    		} else {
		    			apprTextColor = "apprText_blue";
		    		}
		    		
			    	str += '		<dl class="apprDL">';
			    	str += '			<dt class="apprPic"><img src="'+ imgsrc +'"></dt>';
			    	str += '			<dd class="apprName">'+ dtl[i].aprMemberName +'</dd>';
			    	
			    	if(i==0) {
			    		str += '			<dd class="'+ apprTextColor +'"><span><spring:message code="ezApprovalG.t30"/></span></dd>';
			    	} else {
			    		str += '			<dd class="'+ apprTextColor +'"><span>'+ dtl[i].ext1 +'</span></dd>';
			    	}
			    	str += '		</dl>';			
			    	
			    	if(i !== listSize-1) {
			    		str += '		<p class="appr_arrow"><img src="/images/kr/main/approval_arrow.png"></p>';	
			    	}			    	
			    	
		    	}
		    	
		    	str += '	</div>';
		    	str += '</li>';
		    		
		    	
/* 				str += '<div class="apprBox">';
				str += '  <div class="upperBox" onclick=\'opendocview("'+ data.docID +'", "'+ data.href +'", "'+ data.aprMemberID +'", "'+ data.aprMemberName +'", "'+ data.aprMemberDeptID +'", "'+ data.docState +'", "'+ data.functionType +'")\'">';
				str += '    <div id="title">'+ data.docTitle+'</div>';
				str += '    <div id="info">'+ data.writerName +'  '+ data.startDate.substr(5, 11).replace(/-/gi, ".") +'</div>';
				str += '  </div>';
				str += '  <div class="lowerBox">';
				
				for(var i=0; i<listSize; i++){
					
					var imgsrc = dtl[i].ext2 !== null ? "/ezCommon/downloadAttach.do?filePath="+path+"thumbnail/"+dtl[i].ext2 : "/images/kr/main/info_pic_none.png";
					console.log(imgsrc);
					
					str += '    <div class="aprmemInfo">';
					str += '      <div class="userImg">';
					//str += '        <img id="myimg" src="/ezCommon/downloadAttach.do?filePath='+path+'thumbnail/'+dtl[i].ext2+'" width="60" height="60">';
					str += '        <img id="myimg" src='+imgsrc+' width="60" height="60">';
					str += '      </div>';
					str += '      <div class="userStatus">';
					str += '        <span>'+ dtl[i].aprMemberName +'</span>';
					str += '        <span id="aprstate">'+ dtl[i].ext1 +'</span>';
					str += '      </div>';
					str += '    </div>';
					
					if(i !== listSize-1) {
						str += '    <div class="arrowImg"> --> </div>';
					}
				}

				str += '  </div>';
				str += '</div>';	 */	    	
		    	
		    	return str;
		    }

			// aprmemberID, aprmemberName, aprmemberDeptID 필요하면 넣기.
			function dataAssembler(data) {
				var str = "";
				
				str += '<li onclick=\'opendocview("'+ data.docID +'", "'+ data.href +'", "'+ data.aprMemberID +'", "'+ data.aprMemberName +'", "'+ data.aprMemberDeptID +'", "'+ data.docState +'", "'+ data.functionType +'", "${userInfo.companyID}")\'>';
				str += '	<span class="txt">'+ data.docTitle +'</span>';
				str += '	<span class="date">'+ data.startDate.substr(5, 11).replace(/-/gi,'.')+'</span>';				
				str += '	<span class="name">'+ data.writerName +'</span>';
				str += '</li>';
				
				return str;
			}
			
			function noData(){
				var str = "";
				
           	    str += "<dl class='nodata'>";
               	str += "<dt><img src='/images/kr/main/nodata.png'></dt>";
               	str += '<dd>"' + strLang1_NewApprMail + '"</dd>';
               	str += "</dl>";
               	
               	return str;
			}

	 	    // 이 함수 살리면 기존으로 돌아감.
/*    	 	    function getApprGraph() {
				$.ajax({
		 	    	type : "POST",
		 	        dataType : "text",
		 	        url : "/ezApprovalG/getPortletAprDocList.do",
		 	        data : {
		 	        	pListTypeName   : pListTypeValue, 
		 	        	pDocTypeName 	 : "A01000", 
		 	        	pUserID 	 : pUserID, 
		 	        	pUserDeptID 	 : arr_userinfo[4], 
		 	        	pPageSize : "1000",
		 	        	pPageNum : "1",
		 	        	companyID : companyID,
		 	        	orderCell : "",
		 	        	orderOption : "",
		 	        	searchQuery : "",
		 	        	subQuery : ""
					},
					success : function(xml){
						getDocList_after(loadXMLString(xml));
		 	        },
		 	        error : function(error){
		 	        	console.log("<spring:message code='ezBoard.t22'/>wpNewApprMail" + error);	
		 	        }
				});
		    }  */
	
		    function getDocList_after(xml) {
		        if (xml == null) return;
	
		        try {		          
		            var xmldom = createXmlDom();		            
		            xmldom = xml;
	
		            var listHTML = "";
		                
		                /* if (pListTypeValue == "1") { */
		                    /* document.getElementById("doingCNT").innerHTML = "(" + getNodeText(xmldom.getElementsByTagName("TOTALCNT1").item(0)) + ")";
		                    document.getElementById("draftCNT").innerHTML = "(" + getNodeText(xmldom.getElementsByTagName("TOTALCNT2").item(0)) + ")";
		                    document.getElementById("rejectCNT").innerHTML = "(" + getNodeText(xmldom.getElementsByTagName("TOTALCNT3").item(0)) + ")"; */
		                
					if ("${type}" == "favo") {	
						var sixhgap = getNodeText(xmldom.getElementsByTagName("SIXHGAP").item(0));
	                    document.getElementById("SIXHGAP").innerHTML = (sixhgap > 99 ? '99' : sixhgap);
	                    
	                    var onedgap = getNodeText(xmldom.getElementsByTagName("ONEDGAP").item(0));
	                    document.getElementById("ONEDGAP").innerHTML = (onedgap > 99 ? '99' : onedgap);
	                    
	                    var sevendgap = getNodeText(xmldom.getElementsByTagName("SEVENDGAP").item(0));
	                    document.getElementById("SEVENDGAP").innerHTML = (sevendgap > 99 ? '99' : sevendgap);
	                    
	                    var onemgap = getNodeText(xmldom.getElementsByTagName("ONEMGAP").item(0));
	                    document.getElementById("ONEMGAP").innerHTML = (onemgap > 99 ? '99' : onemgap);
	                    
	                    var other = getNodeText(xmldom.getElementsByTagName("OTHER").item(0));
	                    document.getElementById("OTHER").innerHTML = (other > 99 ? '99' : other);
					}
                    
	                /* } */
					
	                /**
	                	2018.09.11
	                	결재할 문서 텍스트 ver. 
	                */
  	                if ("${type}" == "appr") {
	                	document.getElementById("ApprList").innerHTML = "";
	                	
		                if (xmldom.getElementsByTagName("CELL").length > 0) {
		                    //listHTML = "<ul class=\"listtype_txt \">";
             
		                    for (var i = 0; i < xmldom.getElementsByTagName("CELL").length; i++) {
		                        var DOCTITLE = MakeXMLString(getNodeText(xmldom.getElementsByTagName("DOCTITLE").item(i)));
		                        var WRITERNAME = getNodeText(xmldom.getElementsByTagName("WRITERNAME").item(i));
		                        var STARTDATE = getNodeText(xmldom.getElementsByTagName("STARTDATE").item(i));
	
		                        var DOCID = getNodeText(xmldom.getElementsByTagName("DOCID").item(i));
		                        var HREF = getNodeText(xmldom.getElementsByTagName("HREF").item(i));
		                        var APRMEMBERID = getNodeText(xmldom.getElementsByTagName("APRMEMBERID").item(i));
		                        var APRMEMBERNAME = getNodeText(xmldom.getElementsByTagName("APRMEMBERNAME").item(i));
		                        var APRMEMBERDEPTID = getNodeText(xmldom.getElementsByTagName("APRMEMBERDEPTID").item(i));
		                        var DOCSTATE = getNodeText(xmldom.getElementsByTagName("DOCSTATE").item(i));
		                        var FUNCTIONTYPE = getNodeText(xmldom.getElementsByTagName("FUNCTIONTYPE").item(i));
		                        
		                        //2018-10-08 천성준 - 포틀릿 결재문서 companyID 처리
		                        var orgCompanyID = getNodeText(xmldom.getElementsByTagName("orgCompanyID").item(i));
		                        
		                        //2018-08-09 배현상, 긴급결재 시 color=red표시
		                        var URGENTAPPROVAL = getNodeText(xmldom.getElementsByTagName("URGENTAPPROVAL").item(i));
		                        if (URGENTAPPROVAL == 'Y') {
		                        	listHTML += "<li onclick=\"opendocview('" + DOCID + "','" + HREF + "','" + APRMEMBERID + "','" + APRMEMBERNAME + "','" + APRMEMBERDEPTID + "','" + DOCSTATE + "','" + FUNCTIONTYPE + "','" + orgCompanyID + "')\"><span class='txt'>" + DOCTITLE + "</span> <span class='date'>" + STARTDATE.substring(0, STARTDATE.length - 3).replace(/-/gi,'.') + "</span> <span class='name'>" + WRITERNAME + "</span></li>";
		                        } else {
			                        listHTML += "<li onclick=\"opendocview('" + DOCID + "','" + HREF + "','" + APRMEMBERID + "','" + APRMEMBERNAME + "','" + APRMEMBERDEPTID + "','" + DOCSTATE + "','" + FUNCTIONTYPE + "','" + orgCompanyID + "')\"><span class='txt'>" + DOCTITLE + "</span> <span class='date'>" + STARTDATE.substring(0, STARTDATE.length - 3).replace(/-/gi,'.') + "</span> <span class='name'>" + WRITERNAME + "</span></li>";
		                        }
		                     }
		                    //listHTML += "</ul>";
		                } else {
		                    //listHTML = "<div class='nodata_portlet '>";
		                    //listHTML += "<p><img width='92' height='84' src='/images/kr/main/nodata_plan.png' /></p>";
		                    //listHTML += "<p>" + strLang1_NewApprMail + "</p></div>";
		            	    listHTML += "<dl class='nodata'>";
		                	listHTML += "<dt><img src='/images/kr/main/nodata.png'></dt>";
		                	listHTML += '<dd>"' + strLang1_NewApprMail + '"</dd>';
		                	listHTML += "</dl>";
		                    
		                }
		                
		                document.getElementById("ApprList").innerHTML = listHTML;
	                }
		        } catch (e) {
		        }
		    }
	
		    function opendocview(pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType, orgCompanyID) {
		        var openLocation = "";
	
		        if ("${userApprovalG}" == "YES") {
		            if (pListTypeValue != "2") {
		                if (pFunctionType == "004" || pFunctionType == "006" || pFunctionType == "015") {
		                    if (pDocState == "012" || pDocState == "014" || pDocState == "018") {
		                        OpenReceiveDraftUI(pDocID, pHref, "REDRAFT");
		                    } else if (pFunctionType == "004" && companyID != orgCompanyID) {
	                    		var pAlertContent = "<spring:message code='ezApprovalG.csj01' />";
		                        alert(pAlertContent);
		                        return;
		                    } else {
		                        openApprDraftUI("REDRAFT", pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType, orgCompanyID);
		                    }
		                } else {
		                    openApprovUI(pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType, orgCompanyID);
		                }
		            } else {
		                openViewDocInfo(pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType, orgCompanyID);
		            }
		        } else {
		            if (pListTypeValue != "2") {
		                if (pFunctionType == strAprState4 || pFunctionType == strAprState6 || pFunctionType == strAprState15) {
		                    if (pDocState == strDocState12 || pDocState == strDocState14 || pDocState == strDocState18) {
		                        var pDraftFlag = "REDRAFT";
		                        if (pHref.substr(pHref.length - 3, pHref.length).toLowerCase() == "doc") {
		                            openLocation = "/myoffice/ezApproval/ezViewWord/ezDeptRecevUI_word.aspx?DocID=" + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag);
		                        }
		                        else if (pHref.substr(pHref.length - 3, pHref.length).toLowerCase() == "hwp") {
		                            openLocation = "/ezApprovalG/ezDeptRecevUI_HWP.do?docID=" + escape(pDocID) + "&draftFlag=" + escape(pDraftFlag);
		                        }
		                    } else if (pDocState == strDocState11) {
		                        if (arr_userinfo[4] != pAprMemberDeptID) {
		                            var pAlertContent = "<spring:message code='main.t2200' />";
		                            alert(pAlertContent);
		                            return;
		                        }
	
		                        var pDraftFlag = "REDRAFT";
		                        var openLocation = "";
	
		                        if (pHref.substr(pHref.length - 3, pHref.length).toLowerCase() == "doc") {
		                            openLocation = "/myoffice/ezApproval/ezViewWord/ezRecevUI_word.aspx?DocID=" + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag);
		                        }
		                        else if (pHref.substr(pHref.length - 3, pHref.length).toLowerCase() == "hwp") {
		                            openLocation = "/myoffice/ezApproval/ezViewHWP/ezRecevUI_HWP.aspx?DocID=" + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag);
		                        }
		                    } else {
		                        if (arr_userinfo[4] != pAprMemberDeptID) {
		                            var pAlertContent = "<spring:message code='main.t2200' />";
		                            alert(pAlertContent);
		                            return;
		                        }
	
		                        var pDraftFlag = "REDRAFT";
		                        var tempDocState = strDocState1;
		                        var SusinSn = "0";
		                        
		                        if (pDocState == strDocState11) {
		                            tempDocState = strDocState11;
		                            SusinSn = "1";
		                        }
	
		                        var AprState = strAprState4;
		                        
		                        if (pFunctionType == strAprState6) {
		                            AprState = strAprState6;
		                        }
		                    }
		                } else {
		                    if (arr_userinfo[4] != pAprMemberDeptID) {
		                        var pAlertContent = "<spring:message code='main.t2200' />";
		                        alert(pAlertContent);
		                        return;
		                    }
		                }
		            }
		            
		            openwindow(openLocation);
		        }
		    }
	
		    function openViewDocInfo(pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType, orgCompanyID) {
		        var pArgument = new Array();
		        var formURL = pHref;
		        var DocID = pDocID;
		        pArgument[0] = DocID;
		        pArgument[1] = formURL;
		        pArgument[2] = "";
		        pArgument[3] = pDocState;
		        pArgument[4] = "";
		        pArgument[5] = "";
		        pArgument[6] = "OPINION_SHOW";
		        pArgument[7] = "2";
		        pArgument[8] = orgCompanyID;
		        
		        var openLocation;
		        
                if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "doc") {
                    openLocation = "/myoffice/ezApprovalG/ezViewWord/ezViewApr_Word_Cross.aspx?DocID=" + escape(pArgument[0]) + "&DocHref=" + escape(pArgument[1]);
                    openLocation += "&OpinionFlag=" + escape(pArgument[2]) + "&docState=" + escape(pArgument[3]) + "&ListSusin=" + escape(pArgument[4]) + "&odoc=" + escape(pArgument[5]);
                    openLocation += "&isOpinion=" + escape(pArgument[6]);
                    openLocation += "&ListType=" + escape(pArgument[7]);
                }
                else if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "hwp") {
                	if (isIE()) {
	                    openLocation = "/ezApprovalG/ezviewAprHWP.do?docID=" + escape(pArgument[0]) + "&docHref=" + escape(pArgument[1]);
	                    openLocation += "&opinionFlag=" + escape(pArgument[2]) + "&docState=" + escape(pArgument[3]) + "&listSusin=" + escape(pArgument[4]) + "&odoc=" + escape(pArgument[5]);
	                    openLocation += "&isOpinion=" + escape(pArgument[6]);
	                    openLocation += "&listType=" + escape(pArgument[7]);
                	} else {
                		var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
                        alert(pAlertContent);
                        
                        return;
                	}
                } else {
                	openLocation = "/ezApprovalG/aprDocView.do?docID=";
                	openLocation += escape(pArgument[0]) + "&docHref=" + escape(pArgument[1]);
    	            openLocation += "&opinionFlag=" + escape(pArgument[2]) + "&docState=" + escape(pArgument[3]) + "&ListSusin=" + escape(pArgument[4]) + "&odoc=" + escape(pArgument[5]);
    	            openLocation += "&isOpinion=" + escape(pArgument[6]);
    	            openLocation += "&listType=" + escape(pArgument[7]);
    	            openLocation += "&orgCompanyID=" + escape(pArgument[8]);
                }

                openwindow(openLocation, "", 880, 570);
		    }
	
		    function openApprDraftUI(pDraftFlag, pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType, orgCompanyID) {
		        var pArgument = new Array();
		        var formURL = pHref;
		        
		        pArgument[0] = arr_userinfo[1];
		        pArgument[1] = pHref;
		        pArgument[2] = pDraftFlag;
		        pArgument[3] = "";
	
		        var openLocation = "";
		        var tempDocState = "001";
		        var SusinSn = "0";
		        
		        if (pDocState == "011") {
		            tempDocState = "011";
		            SusinSn = "1";
		        }
	
		        var AprState = "004";
		        
		        if (pFunctionType == "006")
		            AprState = "006";
		       
		        pArgument[4] = SusinSn;
		        pArgument[5] = tempDocState;
		        pArgument[6] = AprState;
		        pArgument[7] = "";
		        pArgument[8] = orgCompanyID;
	
		        if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "mht") {
		        	if (pDocState == "011" && pFunctionType == "004" && pDraftFlag == "REDRAFT") {
		            	openLocation = "/ezApprovalG/recevGSusin.do?docID=";
						openLocation = openLocation + pDocID + "&uOrgID=" + "&isReDraft=Y" + "&draftFlag=" + pDraftFlag;
		        	} else {
		            	openLocation = "/ezApprovalG/draftui.do?formURL=";
			            openLocation = openLocation + escape(pArgument[1]) + "&draftFlag=" + escape(pArgument[2]) + "&formDocType=" + escape(pArgument[3]);
			            openLocation = openLocation + "&susinSN=" + escape(pArgument[4]) + "&docState=" + escape(pArgument[5]) + "&listType=1&aprState=" + escape(pArgument[6]);
			            openLocation = openLocation + "&isTmpDoc=" + escape(pArgument[7]);
			            openLocation += "&orgCompanyID=" + escape(pArgument[8]);
		        	}
		        } else {
	                openLocation = "/ezApprovalG/draftuiHWP.do?formURL=" + escape(pArgument[1]) + "&draftFlag=" + escape(pArgument[2]) + "&formDocType=" + escape(pArgument[3]);
	                openLocation = openLocation + "&susinSN=" + escape(pArgument[4]) + "&docState=" + escape(pArgument[5]) + "&listType=1&aprState=" + escape(pArgument[6]);
	                openLocation = openLocation + "&isTmpDoc=" + escape(pArgument[7]);
		        }
	
		        openwindow(openLocation, "", 890, 560);
		    }
	
		    function OpenReceiveDraftUI(pDocID, pURL, pDraftFlag) {
		        var openLocation;
	
		        if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "doc") {
		            openLocation = "/ezApprovalG/recev.do?docID=" + escape(pDocID) + "&draftFlag=" + escape(pDraftFlag);
		        }
		        else if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "hwp") {
		            openLocation = "/ezApprovalG/ezDeptRecevUI_HWP.do?docID=" + escape(pDocID) + "&draftFlag=" + escape(pDraftFlag);
		        }
		        else {
		            if (CrossYN()) {
		                openLocation = "/ezApprovalG/recev.do?docID=";
		            } else {
		            	openLocation = "/ezApprovalG/recev.do?docID=";
		            }
	
		            openLocation = openLocation + escape(pDocID) + "&draftFlag=" + escape(pDraftFlag);
		        }
		        
		        openwindow(openLocation, "receive", 880, 550);
		    }
	
		    function openApprovUI(pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType, orgCompanyID) {
	            var pArgument = new Array();
	            
	            pArgument[0] = pDocID;
	            pArgument[1] = pAprMemberID;
	            pArgument[2] = pAprMemberName;
	            pArgument[3] = pAprMemberDeptID;
	            pArgument[4] = orgCompanyID;

	            var formURL = pHref;
	            
	            if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "doc") {
	                openLocation = "/myoffice/ezApprovalG/ezViewWord/ezAproveUI_word_Cross.aspx?DocID=" + escape(pArgument[0]);
	                openLocation = openLocation + "&uID=" + escape(pArgument[1]) + "&uName=" + escape(pArgument[2]);
	                openLocation = openLocation + "&uDeptID=" + escape(pArgument[3]) + "&AllFlag=0";
	            } else if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "hwp") {
	            	if (isIE()) {
		                openLocation = "/ezApprovalG/approvuiHWP.do?docID=" + escape(pArgument[0]);
		                openLocation = openLocation + "&id=" + escape(pArgument[1]) + "&name=" + escape(pArgument[2]);
		                openLocation = openLocation + "&deptID=" + escape(pArgument[3]) + "&allFlag=0" + "&docState=" + escape(pDocState);
	            	} else {
	            		var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
	                    alert(pAlertContent);
	                    
	                    return;
	            	}
	            } else {                
                    openLocation = "/ezApprovalG/approvui.do?docID=";
	                openLocation = openLocation + escape(pArgument[0]);
	                openLocation = openLocation + "&id=" + escape(pArgument[1]) + "&name=" + escape(pArgument[2]);
	                openLocation = openLocation + "&deptID=" + escape(pArgument[3]) + "&allFlag=0" + "&docState=" + escape(pDocState);
	                openLocation += "&orgCompanyID=" + escape(orgCompanyID);
	            }
	            openwindow(openLocation, "", 880, 550);       
		    }
	
		    function openwindow(wfileLocation) {
		        var height = window.screen.availHeight;
		        var width = window.screen.availWidth;
		        var left = 0;
		        var top = 0;
	
		        if (window.screen.width > 800) {
		            var pleftpos;
		            pleftpos = parseInt(width) - 1150;
		            height = parseInt(height) - 30;
		            
		            if (CrossYN())
		            	height = parseInt(height) - 25;
	
		            if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1)
		            	height = parseInt(height) - 40;
	
		            width = parseInt(width) - pleftpos;
		            
		            left = pleftpos / 2;
		        } else {
		        	height = parseInt(height) - 30;
		            
		            if (CrossYN())
		            	height = parseInt(height) - 25;
	
		            if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1)
		            	height = parseInt(height) - 40;
	
		            
		            width = parseInt(width) - 10;
		        }
		        window.open(wfileLocation, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + height + ",width=" + width + ",top=" + top + ",left = " + left);
		    }
	
		    function apprChangeTab(obj) {
		        switch (obj.id) {
		            case "doingTab":
		                pListTypeValue = "1";
		                selTab = "doingTab";
		                document.getElementById("doingTab").className = "on";
		                document.getElementById("rejectTab").className = "";
		                document.getElementById("draftTab").className = "";
		                break;
	
		            case "rejectTab":
		                pListTypeValue = "4";
		                selTab = "rejectTab";
		                document.getElementById("doingTab").className = "";
		                document.getElementById("rejectTab").className = "on";
		                document.getElementById("draftTab").className = "";
		                break;
	
		            case "draftTab":
		                pListTypeValue = "2";
		                selTab = "draftTab";
		                document.getElementById("doingTab").className = "";
		                document.getElementById("rejectTab").className = "";
		                document.getElementById("draftTab").className = "on";
		                break;
		        }
		        getApprGraph('appr');
		    }
	
		    function Appmore_btnClick() {
                var rightUrl = "";
		        if ("${userApprovalG}" == "YES") {
		            if (pListTypeValue != "2")
		                rightUrl = "/ezApprovalG/apprGMain.do?listType=1";
		            else
		                rightUrl = "/ezApprovalG/apprGMain.do?listType=2";
		        } else {
		            if (pListTypeValue != "2")
		                rightUrl = "/ezApprovalG/apprGMain.do?listType=1";
		            else
		                rightUrl = "/ezApprovalG/apprGMain.do?listType=2";
		        }
                parent.document.querySelector("iframe[name=main]").src = rightUrl;
            }
	
		    var xmlhttp_getMailGraph_NewApprMail = createXMLHttpRequest();
		    
		    function getMailGraph() {
		        var xmlpara = createXmlDom();
	
		        var objNode;
		        createNodeInsert(xmlpara, objNode, "PARAMETER");
		        createNodeAndInsertText(xmlpara, objNode, "pMailType", "1");       
	
		        //DisplayWaitStat();
	
		        xmlhttp_getMailGraph_NewApprMail = null;
		        xmlhttp_getMailGraph_NewApprMail = createXMLHttpRequest();
		        xmlhttp_getMailGraph_NewApprMail.open("POST", "/ezEmail/getPortletMailList.do", true);
		        xmlhttp_getMailGraph_NewApprMail.onreadystatechange = getMailList_after;
		        xmlhttp_getMailGraph_NewApprMail.send(xmlpara);
		    }
	
		    function getMailList_after() {
		        if (xmlhttp_getMailGraph_NewApprMail == null || xmlhttp_getMailGraph_NewApprMail.readyState != 4) return;
		        
		        /* 2018-05-25 홍승비 - 메일 용량 표시 변경 */
		        /* document.getElementById("mailquatersize").innerHTML = "";
		    	MailQuater = new JustGage({
		            id: "mailquatersize",
		            value: 0,
		            min: 0,
		            max: 100,
		            showInnerShadow: true,
		            levelColorsGradient : true,
		        }); */
	
		        try {          
		            document.getElementById("MailList").innerHTML = "";
	
		            var xmldom = createXmlDom();
		            xmldom = xmlhttp_getMailGraph_NewApprMail.responseXML;
		            
		            /* MailQuater.refresh(parseInt(getNodeText(xmldom.getElementsByTagName("MAILPERCENT").item(0)))); */
		            /* document.getElementById("InBoxCNT").innerHTML = "(" + getNodeText(xmldom.getElementsByTagName("TOTALCNT").item(0)) + ")"; */		            
                    /* document.getElementById("MailBoxSize").innerHTML = getNodeText(xmldom.getElementsByTagName("MAILBOXSIZE").item(0)); */
                    
                    document.getElementById("UseMailBox").innerHTML = getNodeText(xmldom.getElementsByTagName("MAILBOXDETAIL").item(0)) + "<span>/" + getNodeText(xmldom.getElementsByTagName("MAILBOXSIZE").item(0)) + "</span>";
                    $("#mGraphSpan").css("width", getNodeText(xmldom.getElementsByTagName("MAILPERCENT").item(0)) + "px");
                    
		            var listHTML = "";
		            if (xmldom.getElementsByTagName("NODE").length > 0) {
		                /* var listHTML = "<ul class=\"listtype_txt \">"; */		                
		                var mailCnt = 0;
		                
		                if (xmldom.getElementsByTagName("NODE").length > 5) {
		                	mailCnt = 5;	
		                } else {
		                	mailCnt = xmldom.getElementsByTagName("NODE").length;
		                }
		                
		                for (var i = 0; i < mailCnt; i++) {
		                	var _SubjectColumSpan = document.createElement("span");
		                	var SUBJECT = getNodeText(xmldom.getElementsByTagName("SUBJECT").item(i));
		                    var SENDER = getNodeText(xmldom.getElementsByTagName("SENDER").item(i));
		                    var DATE = getNodeText(xmldom.getElementsByTagName("DATE").item(i)).substring(5);
		                    var HREF = getNodeText(xmldom.getElementsByTagName("HREF").item(i));
		                    var READ = getNodeText(xmldom.getElementsByTagName("READ").item(i));

		                    _SubjectColumSpan.innerText = SUBJECT;
		                    SUBJECT = _SubjectColumSpan.innerHTML;		                    
		                    
		                    if (READ == 0) {
		                    	READ = "mail_close";
		                    } else {
		                    	READ = "mail_open";
		                    }
							
		                    listHTML += "<li class='" + READ + "' onclick=\"open_mail('" + HREF + "')\"> <span class='txt'>" + SUBJECT + "</span> <span class='date'>" + DATE + "</span> <span class='name'>" + SENDER + "</span></li>";
		                }
	
		                //listHTML += "</ul>";
		            } else {
		    		    listHTML += "<dl class='nodata'>";
	                	listHTML += "<dt><img src='/images/kr/main/nodata.png'></dt>";
	                	listHTML += '<dd>"' + strLang1_NewApprMail + '"</dd>';
	                	listHTML += "</dl>";
		            }
	
		            document.getElementById("MailList").innerHTML = listHTML;
	
		        }
		        catch (e) {
		        }
		    }
	
		    function open_mail(url) {
		        var pheight = window.screen.availHeight;
		        var conHeight = pheight * 0.8;
		        var pwidth = window.screen.availWidth;
		        var conWidth = pwidth * 0.8;
		        if (conWidth > 890)
		            conWidth = 890;
		        var pTop = (pheight - conHeight) / 2;
		        var pLeft = (pwidth - 890) / 2;
	
		        var newwin;
		        var pURI = "/ezEmail/mailRead.do?URL=" + encodeURIComponent(url) + "&PNFlag=N&CONTENTCLASS=";
	
		        newwin = window.open(pURI, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
		        newwin.focus();
		        getMailGraph();
		    }
	
		    function ReplaceText(orgStr, findStr, replaceStr) {
		        var re = new RegExp(findStr, "gi");
		        return (orgStr.replace(re, replaceStr));
		    }
	
		    function Mailmore_btnClick() {
                parent.document.querySelector("iframe[name=main]").src = "/ezEmail/mailMain.do";
		    }
		    
		    /*
		    	기존포탈 소스인가?? 주석처리
		    */
		    function refresh_onclick() {
		        // change_article('mail');
		    }
		    
		    function openergetDocInfo() { 
		    	/* 장진혁 - 지우면 스크립트 오류남 공통호출됨 */
		    }
		    
		    function checkBujaeOpenForm(){
		    	var BString = arr_userinfo[7];
		    	if (!checkBujaeInfo('form')) {
		    		return;
		    	} 
		    	
		    	/* if (!BString || BString == "") {
		    		openForm();
		    	} */
		    }
		    
		    function checkBujaeOpenDraftUI(formURL, formDocType) {
		    	var BString = arr_userinfo[7];
		    	if (!checkBujaeInfo('draft', formURL, formDocType)) {
		    		return;
		    	}
		    	
		    	/* if (!BString || BString == "") {
		    		openDraftUI(formURL, formDocType);
		    	} */
		    }
		    
		    function openDraftUI(formURL, formDocType) {
		    	
		        var pArgument = new Array();
		        pArgument[0] = arr_userinfo[1];
		        pArgument[1] = formURL;
		        pArgument[2] = 'DRAFT';
		        pArgument[3] = formDocType;
	            pArgument[4] = "0";
	            pArgument[5] = "";
	            pArgument[6] = "";
	            pArgument[7] = "";

		        var openLocation = "";
		      
		        if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "mht") {
		        	openLocation = "/ezApprovalG/draftui.do?formURL=";
		            openLocation = openLocation + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
		            openLocation = openLocation + "&susinSN=" + encodeURI(pArgument[4]) + "&docState=" + encodeURI(pArgument[5]) + "&listType=" + encodeURI(pListTypeValue) + "&aprState=" + encodeURI(pArgument[6]);
		            openLocation = openLocation + "&isTmpDoc=" + encodeURI(pArgument[7]);
		        }
		        else {
		        	if (!isIE()) {
		                alert(strLang1103);
		                return;
		            }
		            else {
		            	openLocation = "/ezApprovalG/draftuiHWP.do";
		            	
		                //openLocation = "/ezApprovalG/draftuiHWP.do?formURL=" + encodeURI(pArgument[1]) + "&DraftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
		                //openLocation = openLocation + "&susinSN=" + encodeURI(pArgument[4]) + "&DocState=" + encodeURI(pArgument[5]) + "&ListType=" + encodeURI(pListTypeValue) + "&AprState=" + encodeURI(pArgument[6]);
		                //openLocation = openLocation + "&isTmpDoc=" + encodeURI(pArgument[7])
		                
		            	openLocation = openLocation + "?formURL=" + escape(pArgument[1]) + "&draftFlag=" + escape(pArgument[2]) + "&formDocType=" + escape(pArgument[3]);
		                openLocation = openLocation + "&susinSN=" + escape(pArgument[4]) + "&docState=" + escape(pArgument[5]) + "&listType=1" + "&aprState=" + escape(pArgument[6]);
		                openLocation = openLocation + "&isTmpDoc=" + escape(pArgument[7]);
		            }
		        }

		        openwindow(openLocation, "", 890, 560);
		    }
		    
		    function checkBujaeInfo(type, formURL, formDocType) {
		        var BString = arr_userinfo[7];
		        if (BString != "") {
		            var BDim = new Array("");
		            BDim = BString.split(":");
		            var tmpStartDate = (BDim[3] + ":" + BDim[4]).substring(0, 16);
		            var tmpEndDate = (BDim[5] + ":" + BDim[6]).substring(0, 16);
		
		            tmpStartDate = tmpStartDate.replace("/", ":");
		            tmpEndDate = tmpEndDate.replace("/", ":");
		            if (tmpEndDate < "${nowDate}") {
		                setBujaeOff();
		                checkBujaeInfo_Complete(true, type, formURL, formDocType);
		                return true;

		            } else if (tmpStartDate > "${nowDate}") {
		            	checkBujaeInfo_Complete(true);
		                return true;
		            }
		            var pAlertContent = arr_userinfo[2] + "<spring:message code='ezApprovalG.t1721'/>" + "<br>" + tmpStartDate + "~" + tmpEndDate + "<br>"+"<spring:message code='ezApprovalG.t1723'/>" + "<br>"+ " <spring:message code='ezApprovalG.t1724'/>";

		            var Rtnval = OpenInformationUI(pAlertContent, checkBujaeInfo_Complete, "OPEN", type, formURL, formDocType);
		            return;
		            if (Rtnval) {
		                checkBujaeInfo_Complete(true, type, formURL, formDocType);
		                return;
		            }
		            else {
		                checkBujaeInfo_Complete(false, type, formURL, formDocType);
		                return;
		            }
		        } else {
		            checkBujaeInfo_Complete(true, type, formURL, formDocType);
		            return true;
		        }
		    }
		
		    function checkBujaeInfo_Complete(Rtnval, type, formURL, formDocType) {
	            if (Rtnval == true) {
	                setBujaeOff();
		            if (type == "form") {
		            	openForm();
		            } else {
		            	openDraftUI(formURL, formDocType);
		            }
	            } else {
	                return;
	            }
	            
	        }
		    
		        
		    function setBujaeOff() {
		    	var result = "";
		    	
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezPersonal/saveBujae.do",
		    		data : {
		    				buJae  : "",
		    				proxy  : ""
		    				},
		    		success: function(xml){
		    			result = xml;
		    		}        			
		    	});
		        
		        arr_userinfo[7] = "";
		    }
		    
		    var formURL = "";
		    var formDocType = "";
		    var getformcont_cross_dialogArguments = new Array();
		    var url = "";
		    var getformcont_Cross_OpenWin = "";
		    
		    function openForm() {		    	
		    	
		        var parameter = new Array();
		        parameter[0] = "${userInfo.deptID}";
		        parameter[1] = "A01000";

		        if ("${userApprovalG}" == ("YES")) {
		            url = "/ezApprovalG/getFormCont.do";
		        } else {
		            url = "/ezApproval/getFormCont.do";
		        }
		        
		        if (CrossYN()) {
		            getformcont_cross_dialogArguments[0] = parameter;
		            getformcont_cross_dialogArguments[1] = openForm_Complete;
		            getformcont_Cross_OpenWin = window.open(url, "/ezApproval/getFormCont.do", GetOpenWindowfeature(713, 570));
		            
		            try { getformcont_Cross_OpenWin.focus(); } catch (e) {}
		        } else {
		            var feature = "status:no;dialogWidth:713px;dialogHeight:570px;edge:sunken;scroll:no";
		            var ret = window.showModalDialog(url, parameter, feature);
		            formURL = ret[0];
		            formDocType = ret[1];
		            
		            if (formURL != "cancel") {
		                openDraftUI(formURL, formDocType);
		            }
		        }
		    }
		    
		    function openForm_Complete(ret) {
		        getformcont_Cross_OpenWin.close();
		        formURL = ret[0];
		        formDocType = ret[1];
		        if (formURL != "cancel") {
		            openDraftUI(formURL, formDocType);
		        }
		    }
		    
		    //2018-09-18 구해안 팝업창 가져오기 위해 OpenInformationUI 함수 복붙
		    var ezapropinion_cross_dialogArguments = new Array();
		    function OpenInformationUI(pInformationContent, CompleteFunction, type, type2, formURL, formDocType) {
			var parameter = pInformationContent;
		    var url = "/ezApprovalG/ezAprOpinion.do";
		    if (CrossYN() && (CompleteFunction != "")) { // 크롬에서 반송문서 대장등록 할수있게 하기위해  CompleteFunction != "" 추가 2018-08-07 강민수92
		        ezapropinion_cross_dialogArguments[0] = parameter;
		        if (type == undefined && CompleteFunction != undefined) {
		            ezapropinion_cross_dialogArguments[1] = CompleteFunction;
		            DivPopUpShow(330, 205, url);
		        }
		        else if (type == undefined && CompleteFunction == undefined) {
		            ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
		            DivPopUpShow(330, 205, url);
		        }
		        else if (type != undefined && CompleteFunction != "") {
		            ezapropinion_cross_dialogArguments[1] = CompleteFunction;
		            ezapropinion_cross_dialogArguments[2] = true;
		            var OpenWin = window.open(url + "?type="+type2+"&formURL="+formURL+"&formDocType="+formDocType, "ezAPROPINION_Cross", GetOpenWindowfeature(330, 205));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else if (type != undefined && CompleteFunction == "") {
		        	ezapropinion_cross_dialogArguments[2] = true;
		            var OpenWin = window.open(url + "?type="+type2+"&formURL="+formURL+"&formDocType="+formDocType, "ezAPROPINION_Cross", GetOpenWindowfeature(330, 205));
		            try { OpenWin.focus(); } catch (e) { }
		        }
			    } else {
			        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
			        feature = feature + GetShowModalPosition(330, 205);
			        var RtnVal = window.showModalDialog(url, parameter, feature);
			    }
			    return RtnVal;
			}
			
			function OpenInformationUI_Complete() {
			    DivPopUpHidden();
			}
			    
		    
		    /* 2018-09-04 홍승비 - 탭메뉴 마우스오버 시 하이라이트 설정 */
	        /* function tabover(tabObj) {
	        	tabObj.setAttribute("class", "on");
	        }
	        function tabout(tabObj) {
	        	if (tabObj.id != selTab) {
	        		tabObj.setAttribute("class", "");
	        	}
	        }
	
		    window_onload_NewApprMail(); */
		</script>
	</head>
	<body>
		<c:if test="${type == 'mail'}">
			<div class="layDIV">			
	            <dl class="portlet_title">
	                <dt class="portletText"><spring:message code='main.t00038' /></dt>
	                <dd class="portletPlus" onclick="Mailmore_btnClick()"><img src="/images/kr/main/portlet_Plus.png"></dd>
	                <dd class="mailGraph">
	                    <p class="mGraph"><span id="mGraphSpan"></span></p>
	                    <span class="mGraph_text" id="UseMailBox"></span>
	                </dd>
	            </dl>
	            <ul id="MailList" class="portlet_list"></ul>
	        </div>
        </c:if>
        <c:if test="${type == 'appr'}">
        	<div class="layDIV approval">
	            <dl class="portlet_tab">
	                <dt id="doingTab" class="on" onclick="apprChangeTab(this)"><span><spring:message code='main.t00003' /></span></dt>
	                <dt id="rejectTab" onclick="apprChangeTab(this)"><span><spring:message code='main.t00004' /></span></dt>
	                <dt id="draftTab" onclick="apprChangeTab(this)"><span><spring:message code='main.t00005' /></span></dt>
	                <dd class="portletPlus" onclick="Appmore_btnClick()"><img src="/images/kr/main/portlet_Plus.png"></dd>
	            </dl>
	            <ul id ="ApprList" class="portlet_list"></ul>
	        </div>
		</c:if>
		<c:if test="${type == 'favo'}">
	        <div class="layDIV">
	        	<dl class="portlet_title">
	                <dt class="portletText"><spring:message code='ezPortal.pjg09' /></dt>
	                <dd class="portletPlus" onclick="checkBujaeOpenForm()"><img src="/images/kr/main/portlet_Plus.png"></dd>
	            </dl>
	             <ul class="bookmark">
	             	<c:choose>
				        <c:when test = "${empty result}">
				        	<c:forEach begin="1" end="5">
			             		<li class="bookmarkLi_none"></li>
	             			</c:forEach>
				        </c:when>
				       
				        <c:otherwise>
			             	<c:forEach var="form" begin="0" end="4" items="${result}" varStatus="i">
			             		<li class="bookmarkLi" onclick="checkBujaeOpenDraftUI('${form.formFileLocation}','${form.formDocType}' )"><span>${form.formName}</span></li>
							</c:forEach>
		             		<c:if test="${fn:length(result) < 5 }">
		             			<c:forEach begin="0" end="${4 - fn:length(result)}">
		             				<li class="bookmarkLi_none"></li>
		             			</c:forEach>
		             		</c:if>
				        </c:otherwise>
				        
				     </c:choose>	          
				     <!-- <li class="bookmarkLi_none"></li>
				     <li class="bookmarkLi_none"></li>
				     <li class="bookmarkLi_none"></li>
				     <li class="bookmarkLi_none"></li>
				     <li class="bookmarkLi_none"></li>   --> 
	            </ul>
	            <div class="apprgraph">
	                <div class="apprgraph_area">
	                    <dl class="bookmarkG01">
	                        <dt><spring:message code='main.t00006' /></dt>
	                        <dd>(<span id="SIXHGAP">0</span>)</dd>
	                    </dl>
	                    <dl class="bookmarkG02">
	                        <dt><spring:message code='main.t00007' /></dt>
	                        <dd>(<span id="ONEDGAP">0</span>)</dd>
	                    </dl>
	                    <dl class="bookmarkG03">
	                        <dt><spring:message code='main.t00008' /></dt>
	                        <dd>(<span id="SEVENDGAP">0</span>)</dd>
	                    </dl>
	                    <dl class="bookmarkG04">
	                        <dt><spring:message code='main.t00009' /></dt>
	                        <dd>(<span id="ONEMGAP">0</span>)</dd>
	                    </dl>
	                    <dl class="bookmarkG05">
	                        <dt><spring:message code='main.t00010' /></dt>
	                        <dd>(<span id="OTHER">0</span>)</dd>
	                    </dl>
	                </div>
	            </div>
	        </div>
        </c:if>
		<!-- 2018-08-24 장진혁 - 새로운 포탈 -->
		<%-- <section  class="body_bg1">
			<article id="appr_article" class="appr_mail">
				<div class="tab">
    				<ul>
						<li><img src="/images/<spring:message code='main.t00025' />/main/tab_appro.gif" onclick="change_article('appr')" width="50" height="115"></li>
  						<li><img src="/images/<spring:message code='main.t00025' />/main/tab_mail.gif" onclick="change_article('mail')" width="50" height="115"></li>		
    				</ul>
    			</div>
    			<!-- graph -->
    			<section class="apprgraph">
    				<div class="apprgraph_area">
    					<dl>
    						<dt><spring:message code='main.t00006' /></dt>
    							<dd>
    								<div class="nomal_count">
        								<span id="SIXHGAP">0</span>
        							</div>
     							</dd>
    					</dl>
    					<dl>
    						<dt><spring:message code='main.t00007' /></dt>
    						<dd>
    							<div class="nomal_count">
        							<span id="ONEDGAP">0</span>
        						</div>
        					</dd>
    					</dl>
    					<dl>
    						<dt><spring:message code='main.t00008' /></dt>
    						<dd>
    							<div class="nomal_count">
        							<span id="SEVENDGAP">0</span>
        						</div>
        					</dd>
    					</dl>
    					<dl>
    						<dt><spring:message code='main.t00009' /></dt>
    						<dd>
    							<div class="nomal_count">
        							<span id="ONEMGAP">0</span>
        						</div>
        					</dd>
    					</dl>
    					<dl>
    						<c:choose>
    							<c:when test="${userLang != '3'}">
    								<dt><spring:message code='main.t00010' /></dt>
    							</c:when>
    							<c:otherwise>
    								<dt><spring:message code='main.t00010' /></dt>
    							</c:otherwise>
    						</c:choose>
    						
    						<dd>
    							<div class="point_count">
        							<span id="OTHER" >0</span>
        						</div>
        					</dd>
    					</dl>
    				</div>
    			</section>
     			<!-- /graph -->
    			<!-- list -->
  				<section class="portletbox appr_mailbox"  style="">
          			<div class="title">
          				<span class="tr"></span>
            			<!-- tab -->
            			<dl class="portlet_tab">
              				<dt id="doingTab" onclick="apprChangeTab(this)"  class="on"><span><spring:message code='main.t00003' /><span id="doingCNT" class="tab_num">(0)</span></span></dt>
              				<dt id="rejectTab" onclick="apprChangeTab(this)" ><span><spring:message code='main.t00004' /><span id="rejectCNT" class="tab_num">(0)</span></span></dt>
              				<dt id="draftTab" onclick="apprChangeTab(this)"><span><spring:message code='main.t00005' /><span id="draftCNT" class="tab_num">(0)</span></span></dt>
            			</dl>
            			<!-- /tab -->
           				<span class="btn_more"><img onclick="Appmore_btnClick()" src="/images/<spring:message code='main.t00025' />/main/btn_more02.gif" width="35" height="20" alt="<spring:message code='main.t1008' />"></span>
            		</div>
          			<div id ="ApprList" class="appr_mailcont">            
              			<ul class="listtype_txt">
            			</ul>
          			</div>
        		</section>
 				<!-- list -->
 				<div class="guide"><span class="lb"></span><span class="rb"></span></div>
			</article>

    		<article id="mail_article" style="display:none;" class="appr_mail">
				<div class="tab">
    				<ul>
						<li><img src="/images/<spring:message code='main.t00025' />/main/tab_appr.gif" onclick="change_article('appr')" width="50" height="115"></li>
  						<li><img src="/images/<spring:message code='main.t00025' />/main/tab_mailo.gif" onclick="change_article('mail')" width="50" height="115"></li>		
    				</ul>
    			</div>
    			<!-- graph -->
    			<section class="apprgraph">
    				<div class="mailgraph_area">
    					2018-05-25 홍승비 - 메일 용량 표시 변경
    					<div id="mailquatersize" style="width:168px; height:134px;margin-top:-20px;margin-left:-9px;margin-bottom:10px;"></div>
    					<ul>
    						<li><spring:message code='main.t00012' /><strong id="UseMailBox" class="rtxt"></strong></li>
    						<li><spring:message code='main.t00013' /><strong id="MailBoxSize"></strong></li>
    					</ul>
  					</div>
    			</section>
     			<!-- /graph -->
    			<!-- list -->
  				<section class="portletbox appr_mailbox"  style="">
          			<div class="title">
          				<span class="tr"></span>
            				<!-- tab -->
            				<dl class="portlet_tab">
              					<dt  class="on"><span><spring:message code='main.t00014' /><span id="InBoxCNT" class="tab_num">(0)</span></span></dt>
				            </dl>
            				<!-- /tab -->
            				<span class="btn_more"><img onclick="Mailmore_btnClick()" src="/images/<spring:message code='main.t00025' />/main/btn_more02.gif" width="35" height="20" alt="more"></span>
            		</div>
          			<div id="MailList" class="appr_mailcont"></div>
        		</section>
 				<!-- list -->
 				<div class="guide"><span class="lb"></span><span class="rb"></span></div>
			</article>
		</section> --%>
	</body>
</html>
