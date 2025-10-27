<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:95%;">
	<head>
		<title><spring:message code="ezResource.t142"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezResource.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezResource/functionLib_cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
			var strBrd_ID = "${strBrdID}";
			var strCompanyID = "${companyID}";
			var userID = "${userID}";
			var userName = "${userName}";
			var deptID = "${deptID}";
			var deptName = "${deptName}";
			var res_owner = { "flag" : new Array(), "ownerId": new Array(), "ownerDept" : new Array(), "ownerName" : new Array(), "ownerName1" : new Array(), "ownerDeptName" : new Array(), "brdID" : new Array() };
			var ownerList = JSON.parse('${ownerList}');
			var strRes_ID = "${strResID}";
			var attachFileNameMaxLength = Number("${attachFileNameMaxLength}");
			window.onload = function (){
				
				for(var i=0; i<ownerList.length; i++) {
					res_owner["ownerId"][i] = ownerList[i]["ownerId"];
					res_owner["ownerDept"][i] = ownerList[i]["ownerDept"];
					res_owner["ownerName"][i] = ownerList[i]["ownerName"];
					res_owner["ownerName1"][i] = ownerList[i]["ownerName1"];
					res_owner["ownerDeptName"][i] = ownerList[i]["ownerDeptName"];
				}
				document.getElementById("Owner").innerHTML = "";
				var length = res_owner.ownerName.length;
				for(var i=0; i<length; i++) {
					if(length-1 != i) {
						document.getElementById("Owner").innerHTML += res_owner["ownerName"][i] + ", ";
					}
					else {
						document.getElementById("Owner").innerHTML += res_owner["ownerName"][i];
					}
				}
				
				$("body").on("dragenter dragover drop", function(e) {
					e.preventDefault();
				});
				
				imgAttach();
			}
			
			window.onbeforeunload = function () {
				btnClose_Click();
	    	} 
			
			function imgAttach() {
				var attach1 = "${attachList1}";
				var attach2 = "${attachList2}";
				
				if(attach1 != "") {
					document.getElementById("preview1").src = "/ezResource/getResourceThumbnailInfo.do?fileName=" + encodeURIComponent(attach1);
				}
				if(attach2 != "") {
					document.getElementById("preview2").src = "/ezResource/getResourceThumbnailInfo.do?fileName=" + encodeURIComponent(attach2);
				}
			}

			function btnSave_Click() {
				/* 2018-05-02 서주연 #12554 */
				var re = /[\\/:*?\"<>&|]/gi;
				if( re.test(document.getElementById("Brd_NM").value) || re.test(document.getElementById("Brd_NM2").value)){
					alert("<spring:message code='ezResource.kms1' />");
					return;
				}
				
				if (document.getElementById("Brd_NM").value.trim() == "") {
					alert("<spring:message code="ezResource.t145"/>");
					document.getElementById("Brd_NM").focus();
					return;
				}
				
				var ownerList2 = res_owner["ownerId"][0];
				for(var i=1; i<res_owner.ownerId.length; i++) {
					ownerList2 += "," + res_owner["ownerId"][i];
				}
				
				// 2024-09-13 유길상 - 정원 미입력 확인
				if (document.getElementById("ResMaxUserCnt").value.trim() == "") {
					alert(strLangMaxYGS04);
					document.getElementById("ResMaxUserCnt").focus();
					return;
				}
				
				/* 2018-05-02 서주연 #12558 */
				// 2018-07-10 김민성 - 자원관리 글자수 체크 maxlength로 수정
				/* var brdNmTag = document.getElementById("Brd_NM");
				var brdNm2Tag = document.getElementById("Brd_NM2");
				var resLocTag = document.getElementById("ResLocation");
				
				if(CheckLenthForRes(brdNmTag, 50)){
					return;	
				};
				
				if(CheckLenthForRes(brdNm2Tag, 50)){
					return;
				};
				
				if(CheckLenthForRes(resLocTag , 50)){
					return;
				};	 */

				var xmlPara = createXmlDom();
				var xmlHttp = createXMLHttpRequest();

				var objNode;
				createNodeInsert(xmlPara, objNode, "PARADATA");
				createNodeAndInsertText(xmlPara, objNode, "DATA", strBrd_ID);
				
				createNodeAndInsertText(xmlPara, objNode, "DATA", res_owner["ownerDept"][0]);	// deptID
				createNodeAndInsertText(xmlPara, objNode, "DATA", res_owner["ownerDeptName"][0]);	// deptName
				
				createNodeAndInsertText(xmlPara, objNode, "DATA", ownerList2);	// userID
				createNodeAndInsertText(xmlPara, objNode, "DATA", res_owner["ownerName"][0]);	// userName
				
				/* if (document.getElementById("OwnDept").getAttribute("idVal", "0") == "") {
				    createNodeAndInsertText(xmlPara, objNode, "DATA", deptID);
				} else {
					createNodeAndInsertText(xmlPara, objNode, "DATA", document.getElementById("OwnDept").getAttribute("idVal", "0"));
			    }
			            
				if (document.getElementById("OwnDept").value == "") {
					createNodeAndInsertText(xmlPara, objNode, "DATA", deptName);
				} else {
			        createNodeAndInsertText(xmlPara, objNode, "DATA", document.getElementById("OwnDept").value);
				}

				if (document.getElementById("Owner").getAttribute("idVal", "0") == "") {
			       	createNodeAndInsertText(xmlPara, objNode, "DATA", userID);
				} else {
					createNodeAndInsertText(xmlPara, objNode, "DATA", document.getElementById("Owner").getAttribute("idVal", "0"));
				}

				if (document.getElementById("Owner").getAttribute("NmVal", "0") == "") {
					createNodeAndInsertText(xmlPara, objNode, "DATA", userName);
				} else {
					createNodeAndInsertText(xmlPara, objNode, "DATA", document.getElementById("Owner").getAttribute("NmVal", "0"));
				} */
				//createNodeAndInsertText(xmlPara, objNode, "DATA", document.getElementById("Owner").getAttribute("position", "0"));
				createNodeAndInsertText(xmlPara, objNode, "DATA", "0");
				createNodeAndInsertText(xmlPara, objNode, "DATA", document.getElementById("OwnerCall").value);
				createNodeAndInsertText(xmlPara, objNode, "DATA", document.getElementById("Brd_NM").value);
				createNodeAndInsertText(xmlPara, objNode, "DATA", document.getElementById("ResLocation").value);
				createNodeAndInsertText(xmlPara, objNode, "DATA", document.getElementById("Brd_Explain").value);
				createNodeAndInsertText(xmlPara, objNode, "DATA", strCompanyID);

				if (document.getElementById("approve1").checked == true) {
					createNodeAndInsertText(xmlPara, objNode, "DATA", "1");
				} else if (document.getElementById("approve0").checked == true) {
					createNodeAndInsertText(xmlPara, objNode, "DATA", "0");
				} else {
					createNodeAndInsertText(xmlPara, objNode, "DATA", "2");
				}
				

				if (document.getElementById("Brd_NM2").value.trim() == "") {
					document.getElementById("Brd_NM2").value = document.getElementById("Brd_NM").value;
				}
				
				createNodeAndInsertText(xmlPara, objNode, "DATA", document.getElementById("Brd_NM2").value);

				// 이미지 정보 추가
				createNodeAndInsertText(xmlPara, objNode, "DATA", document.getElementById("hdnfileNM1").value);
				createNodeAndInsertText(xmlPara, objNode, "DATA", document.getElementById("hdnfileNM2").value);
				
				// 반납절차 flag 넘기기
				if (document.getElementById("return1").checked == true) {
					createNodeAndInsertText(xmlPara, objNode, "DATA", "0");
				} else {
					createNodeAndInsertText(xmlPara, objNode, "DATA", "1");
				}

				// 반복예약허용 flag 넘기기
				if (document.getElementById("repeat1").checked == true) {
					createNodeAndInsertText(xmlPara, objNode, "DATA", "1");
				} else {
					createNodeAndInsertText(xmlPara, objNode, "DATA", "0");
				}
				
				// 2024-08-26 유길상 - 정원, 최대 예약 가능 기간 요청 xml 추가
				createNodeAndInsertText(xmlPara, objNode, "RESMAXUSERCNT", document.getElementById("ResMaxUserCnt").value);
				
				var paramResMaxDate = document.getElementById("ResMaxDate").value;
				if (!document.getElementById("ResMaxDate").value || isNaN(paramResMaxDate)) {
					paramResMaxDate = "0";
				}
				createNodeAndInsertText(xmlPara, objNode, "RESMAXDATE", paramResMaxDate);
				
				xmlHttp.open("Post", "/ezResource/callModClsItem.do", false);
				xmlHttp.send(xmlPara)
				
				if (xmlHttp.status != 200) {
					alert("<spring:message code="ezResource.t42"/>");
					return;
				}

				var rtnXML = xmlHttp.responseXML;
				var dataNodes = GetChildNodes(xmlHttp.responseXML);
				var strRtnVal = getNodeText(dataNodes[0]);

				if (strRtnVal == "False") {
					alert("<spring:message code="ezResource.t42"/>");
				} else {
					alert("<spring:message code="ezResource.t56"/>");
					
					/* 2023-09-08 홍승비 - 자원수정 시 부모창을 이동하는 경우, 저장 완료 이후 동작하지 않는 오류 수정 */
					try {
						if (typeof(window.opener.RefreshPageDoc) != "undefined") {
							window.opener.RefreshPageDoc();
						} else {
							if (window.opener.parent.left.location.href.indexOf("/ezResource/leftResource.do") > -1) {
								window.opener.parent.left.location.href = "/ezResource/leftResource.do?flag=SELECT_NO";
							}
							window.opener.location.reload(false);
						}
					} catch (e) {
						console.log(e);
					}
					
					window.close();
				}
			}

			function btnCancel_Click(){
				window.close();
			}

			function btnClose_Click(){
				btnfiledel(1);
				btnfiledel(2);
				window.close();
			}

			var select_person_cross_dialogArguments = new Array();
			
			function btnTakeOwner_Click(val) {
				res_owner["flag"][0] = val;
				res_owner["brdID"][0] = strRes_ID;
				
				select_person_cross_dialogArguments[0] = res_owner;
				select_person_cross_dialogArguments[1] = btnTakeOwner_Click_Complete;
				var OpenWin = window.open("/ezResource/selectPerson.do", "selectPerson", GetOpenWindowfeature(1000, 550));
				try { 
					OpenWin.focus(); 
				} catch (e) {
					
				}
			}
			
			function btnTakeOwner_Click_Complete(retVal) {
				if (typeof (retVal) != "undefined") {
					retVal = JSON.parse(retVal);
					//document.getElementById("Owner").innerHTML = retVal["ownerName"][0] + "(" + retVal["ownerName1"][0] + ")";
					//document.getElementById("subOwner").innerHTML = "";
					document.getElementById("Owner").innerHTML = "";
					var length = retVal.ownerName.length;
					for(var i=0; i<length; i++) {
						if(length-1 != i) {
							document.getElementById("Owner").innerHTML += retVal["ownerName"][i] + ", ";
						}
						else {
							document.getElementById("Owner").innerHTML += retVal["ownerName"][i];
						}
					}
					res_owner = retVal;
					/* var strOwner = retVal;
					var arrOwner;

					arrOwner = strOwner.split(";");
					document.getElementById("Owner").value = arrOwner[0] + "(" + arrOwner[2] + ")";
					document.getElementById("Owner").setAttribute("NmVal", arrOwner[0]);
					document.getElementById("Owner").setAttribute("idVal", arrOwner[1]);
					document.getElementById("Owner").setAttribute("position", arrOwner[2]);
					document.getElementById("OwnDept").value = arrOwner[3];
					document.getElementById("OwnDept").setAttribute("idVal", arrOwner[4]);
					document.getElementById("OwnerCall").value = arrOwner[5]; */
				}
			}
			
			function btnfileup() {
		        document.getElementById("file1").click();
		    }
			
			function btnfileup2() {
		        document.getElementById("file2").click();
		    }
			
			var xhr = new XMLHttpRequest();
			function btn_AttachAdd_onclick() {
				var extension = document.getElementById("file1").value;
	            extension = extension.substring(extension.lastIndexOf(".") + 1, extension.length);
				var check = false;
		        check = compareExtension(check, extension);
		        
		        // 첨부파일 확장자 체크(이미지만 가능)
		        if (!check) {
		        	document.getElementById("file1").files[0] = "";
		        	alert("<spring:message code='ezCommunity.lhj03'/>");
		        	return;
		        }
		        
		        /* 2021-12-09 홍승비 - 자원 이미지 업로드 시 서버단에서도 이미지 확장자 체크 진행 (실제 파일 업로드 이전에 ajax로 체크) */
				if (checkImgExtension(extension) == "UPLOAD_EXT_ERROR") {
					document.getElementById("file1").files[0] = "";
					alert("<spring:message code ='ezAttitude.t260' />"); // 허용하지 않는 확장자입니다.
					return;
				}
		        
		        var filelist = document.getElementById("file1").files;
		        
		    	// 이미지 크기 2MB 제한 체크
		        var filesize = parseInt(filelist[0].size);
	            if (filesize / 1024 / 1024 > 2) {	
	                alert(strLang167);
	                return;
	            } 
		       
	            var fd = new FormData();
	            
	            // 파일명 100자 이내 체크
	            var fnl = filelist[0].name.length;
	            if (fnl > attachFileNameMaxLength) {
	            	alert("<spring:message code='main.jjh08' />" + attachFileNameMaxLength + "<spring:message code='main.lhm03' />");
	        		isfileup = false;
	        		document.getElementById("file1").value = "";
	        		
	        		return;
	            }
	            
	         // 기존 temp 파일 삭제
				if(document.getElementById("hdnfileNM1").value != "") {
					btnfiledel(1);
				}
		        
	            fd.append("fileToUpload", filelist[0]);

	            xhr.addEventListener("load", uploadComplete, false);
	            xhr.open("POST", "/ezResource/uploadItemAttach.do");
	            xhr.send(fd); 
			}
			
			var xhr2 = new XMLHttpRequest();
			function btn_AttachAdd_onclick2() {
				var extension = document.getElementById("file2").value;
	            extension = extension.substring(extension.lastIndexOf(".") + 1, extension.length);
				var check = false;
		        check = compareExtension(check, extension);
		        
		        // 첨부파일 확장자 체크(이미지만 가능)
		        if (!check) {
		        	document.getElementById("file2").files[0] = "";
		        	alert("<spring:message code='ezCommunity.lhj03'/>");
		        	return;
		        }
		        
		        /* 2021-12-09 홍승비 - 자원 이미지 업로드 시 서버단에서도 이미지 확장자 체크 진행 (실제 파일 업로드 이전에 ajax로 체크) */
				if (checkImgExtension(extension) == "UPLOAD_EXT_ERROR") {
					document.getElementById("file2").files[0] = "";
					alert("<spring:message code ='ezAttitude.t260' />"); // 허용하지 않는 확장자입니다.
					return;
				}
		        
		        var filelist = document.getElementById("file2").files;
		        
		    	// 이미지 크기 2MB 제한 체크
		        var filesize = parseInt(filelist[0].size);
	            if (filesize / 1024 / 1024 > 2) {	
	                alert(strLang167);
	                return;
	            } 
		       
	            var fd = new FormData();
	            
	            // 파일명 100자 이내 체크
	            var fnl = filelist[0].name.length;
	            if (fnl > attachFileNameMaxLength) {
	            	alert("<spring:message code='main.jjh08' />" + attachFileNameMaxLength + "<spring:message code='main.lhm03' />");
	        		isfileup = false;
	        		document.getElementById("file2").value = "";
	        		
	        		return;
	            }
	            
	            if(document.getElementById("hdnfileNM2").value != "") {
					btnfiledel(2);
				}
		        
	            fd.append("fileToUpload", filelist[0]);

	            xhr2.addEventListener("load", uploadComplete2, false);
	            xhr2.open("POST", "/ezResource/uploadItemAttach.do");
	            xhr2.send(fd); 
			}
			
			function uploadComplete() {
	           /*  if (CrossYN()) {
	                document.getElementById("file1").value = "";
	            }
	            else { */
	                document.getElementById("file1").type = "text";
	                document.getElementById("file1").type = "file";
	            //}
	            var xml = loadXMLString(xhr.responseText);

	            preview1.value = getNodeText(SelectNodes(xml, "ROOT/NODES/DATA2")[0]);
	            preview1.src = "/ezResource/getResourceThumbnailInfo.do?mode=temp&fileName="
	            		+encodeURIComponent(getNodeText(SelectNodes(xml, "ROOT/NODES/DATA")[0]))
	            		+encodeURIComponent(getNodeText(SelectNodes(xml, "ROOT/NODES/DATA2")[0]));

	            document.getElementById("hdnfileNM1").value = getNodeText(SelectNodes(xml, "ROOT/NODES/DATA")[0]) + getNodeText(SelectNodes(xml, "ROOT/NODES/DATA2")[0]);
			}
			
			function uploadComplete2() {
	           /*  if (CrossYN()) {
	                document.getElementById("file2").value = "";
	            }
	            else { */
	                document.getElementById("file2").type = "text";
	                document.getElementById("file2").type = "file";
	            //}
	            var xml = loadXMLString(xhr2.responseText);

	            preview2.value = getNodeText(SelectNodes(xml, "ROOT/NODES/DATA2")[0]);
	            preview2.src = "/ezResource/getResourceThumbnailInfo.do?mode=temp&fileName="
            		+encodeURIComponent(getNodeText(SelectNodes(xml, "ROOT/NODES/DATA")[0]))
            		+encodeURIComponent(getNodeText(SelectNodes(xml, "ROOT/NODES/DATA2")[0]));

	            document.getElementById("hdnfileNM2").value = getNodeText(SelectNodes(xml, "ROOT/NODES/DATA")[0]) + getNodeText(SelectNodes(xml, "ROOT/NODES/DATA2")[0]);
			}
			
			function btnfiledel(mode) {
				var file = document.getElementById("hdnfileNM" + mode).value;
				
				if(file != null) {
					if(file.indexOf("/") != -1) {
						document.getElementById("preview" + mode).src = "/images/default_pic.jpg";
	                	document.getElementById("hdnfileNM" + mode).value = "";
					}
					else{
						$.ajax({
							async : false,
							url : '/ezResource/tempUploadFileDelete.do',
			                type : 'POST',
			                dataType : 'text',
			                data : {
								fileName : file
			                },
			                success: function() {
			                	document.getElementById("preview" + mode).src = "/images/default_pic.jpg";
			                	document.getElementById("hdnfileNM" + mode).value = "";
			                }
						});
					}
				}
			}
			// 2024-08-26 유길상 - 최대 예약 가능 기간 value 검증
			function numberCheck(el) {
				var curValue = el.value;
				
				if (isNaN(curValue.charAt(curValue.length - 1))) {
					curValue = curValue.slice(0, -1);
				}
				if (curValue.length > 3) {
                    curValue = curValue.slice(0, -1);
                }

				el.value = curValue;
			}
		</script>
	</head>
	<body class="popup"  style="height:100%">
		<table class="layout">
  			<tr>
				<td style="height:20px">
    				<div id="menu">
        				<ul>
          					<li><span onClick="btnSave_Click()"><spring:message code="ezResource.t114"/></span></li>
        				</ul>
      				</div>
      				<div id="close">
        				<ul>
          					<li><span onClick="btnClose_Click()"></span></li>
        				</ul>
      				</div>
      				<script type="text/javascript">
						selToggleList(document.getElementById("menu"), "ul", "li", "0");
					</script>
      				<table class="content">
        				<tr>
        					<th> <spring:message code="ezResource.t153"/></th>
          					<td colspan="2" style="border-right: 0px;">
            						<div id="Owner" style="overflow-y:auto; line-height:25px; height:25px;"></div>
	            			</td>
	            			<td style="border-left:0px">
            						<a class="imgbtn imgbck" style="float:right">
            							<span onClick="btnTakeOwner_Click('ListViewOwner');"><spring:message code="ezResource.t154"/></span>
            						</a>
            				</td>
          					<%-- <th> <spring:message code="ezResource.t153"/></th>
          					<td colspan="3">	
	          					<div id="Owner" style="overflow-y:auto; line-height:25px; display:inline" ><c:out value='${ownerNm}' />(<c:out value='${ownerPosition}' />)</div>
	          					<a class="imgbtn imgbck" style="float:right"><span onClick="btnTakeOwner_Click('ListViewOwner');"><spring:message code="ezResource.t154"/></span></a>
	          						<input type="text" name="Owner" id="Owner" idval="${ownerID}" nmval="${ownerNm}" position="${ownerPosition}"
									value="${ownerNm}(${ownerPosition})" style="width: 200px" readonly>
							</td> 
          					<th> <spring:message code="ezResource.t152"/></th>
          					<td id="MakeDate" nowrap style="width:120px;padding-right:15px"> ${makeDate} </td> --%>
        				</tr>
        				<tr>
          					<th> <spring:message code="ezResource.t155"/></th>
          					<td colspan="3" style="white-space:nowrap">
          						<input type="text" name="OwnerCall" id="OwnerCall" value="${ownerCall}" style="width: 100%" maxLength="20">
          					</td>
          					<%-- <th> <spring:message code="ezResource.rkms01"/></th>
          					<td colspan="3">
          						<table style="width:100%;">
        							<tr>
										<th style="border:0px; padding:0px; padding-right:2px;"><a class="imgbtn imgbck"><span onClick="btnTakeOwner_Click('ListViewsubOwner');"><spring:message code="ezResource.t154"/></span></a>
            						</th>
										<td><div id="subOwner" style="overflow-y:auto; line-height:25px; height:25px;"></div></td>
        							</tr>
    							</table>
          					<a class="imgbtn imgbck"><span onClick="btnTakeOwner_Click('ListViewsubOwner');"><spring:message code="ezResource.t154"/></span></a>
          					<div id="subOwner" style="overflow-y:auto; line-height:25px; height:25px;">
							</div>
          						<input type="text" name="Owner" id="Owner" idval="${ownerID}" nmval="${ownerNm}" position="${ownerPosition}"
								value="${ownerNm}(${ownerPosition})" style="width: 200px" readonly> 
          						<input type="text" name="OwnDept" id="OwnDept" idval="${ownDeptID}" value="${ownDeptNm}" style="width: 100%"> 
          					</td> --%>
        				</tr>
        				<tr>
          					<th> <spring:message code="ezResource.t39"/></th>
          					<td colspan="3" style="padding:0">
          						<table style="width:100%">
              						<tr class="primary">
                						<th>${langPrimary}</th>
                						<td><input type="text" name="Brd_NM" id="Brd_NM" idval="${strBrdID}" value="<c:out value='${strBrdNm}' />" style="width: 100%" maxlength="500"></td>
              						</tr>
              						<tr class="secondary">
                						<th>${langSecondary}</th>
                						<td><input type="text" name="Brd_NM2" id="Brd_NM2" idval="${strBrdID}" value="<c:out value='${strBrdNm2}' />" style="width: 100%" maxlength="500"></td>
									</tr>
								</table>          
							</td>
        				</tr>
        				<tr>
       						<th><spring:message code="ezResource.max.ygs02"/></th>
       						<td colspan="3"><input type="number" min="0" max="999" step="1" onInput="numberCheck(this);" name="ResMaxUserCnt" id="ResMaxUserCnt" value="${resMaxUserCnt}" style="width: 100%;" maxlength="100"></td>
       					</tr>
        				<tr>
          					<th> <spring:message code="ezResource.t148"/></th>
          					<td colspan="3"><input type="text" name="ResLocation" id="ResLocation" value="<c:out value='${resLocation}'/>" style="width: 100%" maxlength="100"></td>
        				</tr>
        				<tr>
       						<th><spring:message code="ezResource.max.ygs01"/></th>
       						<td colspan="3"><input type="text" name="ResMaxDate" onInput="numberCheck(this);" id="ResMaxDate" value="<c:if test="${!(empty resMaxDate || resMaxDate == '0' || resMaxDate == '-')}">${resMaxDate}</c:if>" style="width: 100%;" maxlength="100"></td>
       					</tr>
						<tr>
							<th> <spring:message code="ezResource.lyj01"/></th>
							<td colspan="3" style="width:100%"><div class="custom_radio"><input type="radio" name="repeat" id="repeat1" value="1" <c:if test="${repeatFlag eq 1}"> checked </c:if>></div>
								<spring:message code="ezResource.lyj02"/>
								<div class="custom_radio"><input type="radio" name="repeat" id="repeat2" value="0" <c:if test="${repeatFlag eq 0}"> checked </c:if>></div>
								<spring:message code="ezResource.lyj03"/>
							</td>
						</tr>
        				<tr>
							<th> <spring:message code="ezResource.t149"/></th>
							<td colspan="3">
									<div class="custom_radio">
										<input type="radio" name="approve" id="approve1" value="1"  <c:if test="${approveFlag eq 1}"> checked </c:if> />
									</div>
									<spring:message code="ezResource.t156"/>
									<div class="custom_radio">
										<input type="radio" name="approve" id="approve0" value="0" <c:if test="${approveFlag eq 0}"> checked </c:if> />
									</div>
									<spring:message code="ezResource.t157"/>
									<div class="custom_radio">
										<input type="radio" name="approve" id="approve2" value="2" <c:if test="${approveFlag eq 2}"> checked </c:if>>
									</div>
            						<spring:message code="ezSchedule.t404"/>
							</td>
						</tr>
						<tr>
        					<th><spring:message code="ezResource.kmsr11"/></th>
        					<td colspan="3" style="width:100%"><div class="custom_radio"><input type="radio" name="return" id="return1" value="0" <c:if test="${returnFlag eq 0}"> checked </c:if>></div>
          					<spring:message code="ezResource.kmsr12"/>&nbsp;
          					<div class="custom_radio"><input type="radio" name="return" id="return2" value="1" <c:if test="${returnFlag eq 1}"> checked </c:if>></div>
          					<spring:message code="ezResource.kmsr13"/>
          					</td>
      					</tr>
						<tr>
        					<th><spring:message code="ezPortal.t202"/>1</th>
          					<td colspan="3" >
	          					<img id="preview1" name="preview" src="/images/default_pic.jpg" width="119" height="128" alt="" border="0">
           						<a class="imgbtn imgbck" style="float:right; margin-top:5px; margin-right:5px">
           							<span onClick="btnfiledel('1')"><spring:message code="ezPortal.t990008"/></span>
           						</a>
           						<a class="imgbtn imgbck" style="float:right; margin-top:5px; margin-right:10px">
           							<span onClick="btnfileup()"><spring:message code="ezPersonal.t20003"/></span>
           						</a>
            				</td>
            			</tr>
            			<tr>
        					<th><spring:message code="ezPortal.t202"/>2</th>
          					<td colspan="3" >
          						<img id="preview2" name="preview" src="/images/default_pic.jpg" width="119" height="128" alt="" border="0">
           						<a class="imgbtn imgbck" style="float:right; margin-top:5px; margin-right:5px">
           							<span onClick="btnfiledel('2')"><spring:message code="ezPortal.t990008"/></span>
           						</a>
           						<a class="imgbtn imgbck" style="float:right; margin-top:5px; margin-right:10px">
           							<span onClick="btnfileup2()"><spring:message code="ezPersonal.t20003"/></span>
           						</a>
            				</td>
            			</tr>
      				</table>
      				<form method="post" id="form" name="form" enctype="multipart/form-data" action="/ezResource/uploadItemAttach.do" style="display:none">
						<input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="display:none" accept="image/*"/>
      					<input type="file" name="file2" id="file2" onchange="btn_AttachAdd_onclick2()" style="display:none" accept="image/*"/>
      				</form>
      					<input type="hidden" id="hdnfileNM1" name="hdnfileNM1" value="<c:if test='${!empty attachList1}'>${attachList1}</c:if>">
						<input type="hidden" id="hdnfileNM2" name="hdnfileNM2" value="<c:if test='${!empty attachList2}'>${attachList2}</c:if>">
      				<br>
					<h2 style="font-size:12px;margin-bottom:8px;"><spring:message code="ezResource.t158"/></h2>
				</td>
  			</tr>
  			<tr>
    			<td style="padding-bottom:1px; height:100%; padding-right:12px;">
        			<textarea name="Brd_Explain" id="Brd_Explain" style="width: 100%; height: 50px;resize:none" maxlength="2000"><c:out value='${brdExplain}' /></textarea>
    			</td>
  			</tr>
		</table>
	</body>
</html>