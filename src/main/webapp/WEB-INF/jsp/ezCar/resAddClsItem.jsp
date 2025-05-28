<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:0%;">
	<head>
		<title><spring:message code="ezCar.shb02"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezResource.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezResource/functionLib_cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
			var strBrd_ID = "${carID}";
			var strCompanyID = "${companyID}";
			var userID = "${userID}";
			var userName = "<c:out value='${userName}' />";
			var deptID = "${deptID}";
			var deptName = "<c:out value='${deptName}' />";
			var displayName = "<c:out value='${displayName}' />";
			var title = "<c:out value='${title}'/>";
			var res_owner = { "flag" : new Array(), "ownerId": new Array(), "ownerDept" : new Array(), "ownerName" : new Array(), "ownerName1" : new Array(), "ownerDeptName" : new Array(), "brdID" : new Array() };
			var attachFileNameMaxLength = Number("${attachFileNameMaxLength}");
			var car_nm = "${car_nm}";
			
		

			
			
			window.onload = function () {
				//document.getElementById("Brd_NM").focus();
				
				res_owner["ownerId"][0] = userID;
				res_owner["ownerDept"][0] = deptID;
				res_owner["ownerName"][0] = displayName;
				res_owner["ownerName1"][0] = title;
				res_owner["ownerDeptName"][0] = deptName;
				
				$("body").on("dragenter dragover drop", function(e) {
					e.preventDefault();
				});
			}
			
			window.onbeforeunload = function () {
				btnClose_Click();
	    	} 

			
			 

			
			function btnSave_Click() {
				
		
				var re = /[\\/:*?\"<>&|]/gi;
				if (re.test(document.getElementById("carName").value) || re.test(document.getElementById("carName2").value)){
					alert("<spring:message code='ezResource.kms1' />");
					return;
				}
				
				
				var checkSpace = document.getElementById("carName").value.trim();
				var checkSpace2 = document.getElementById("car_nm").value.trim();
				
				if (checkSpace.length == 0) {
					alert("<spring:message code='ezCar.shb78'/>");
					document.getElementById("carName").focus();
					return;
				}
				
				if (checkSpace2.length == 0 ) {
					alert("<spring:message code='ezCar.shb79'/>");
					document.getElementById("car_nm").focus();
					return;
				}
				
				
				
				var ownerList = res_owner["ownerId"][0];
				for(var i=1; i<res_owner.ownerId.length; i++) {
					ownerList += "," + res_owner["ownerId"][i];
				}
				
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
				
				var xmlpara = createXmlDom();
				var xmlHttp = createXMLHttpRequest();

				var objNode;
				createNodeInsert(xmlpara, objNode, "PARADATA");
				createNodeAndInsertText(xmlpara, objNode, "DATA", strBrd_ID);
				
				createNodeAndInsertText(xmlpara, objNode, "DATA", res_owner["ownerDept"][0]);	// deptID
				createNodeAndInsertText(xmlpara, objNode, "DATA", res_owner["ownerDeptName"][0]);	// deptName
				
				/* if (document.getElementById("OwnDept").getAttribute("idVal", "0") == "") {
					createNodeAndInsertText(xmlpara, objNode, "DATA", deptID);
				} else {
					createNodeAndInsertText(xmlpara, objNode, "DATA", document.getElementById("OwnDept").getAttribute("idVal", "0"));
				} 

				if (document.getElementById("OwnDept").value == "") {
					createNodeAndInsertText(xmlpara, objNode, "DATA", deptName);
				} else {
					createNodeAndInsertText(xmlpara, objNode, "DATA", document.getElementById("OwnDept").value);
				}*/

				createNodeAndInsertText(xmlpara, objNode, "DATA", ownerList);	// userID
				createNodeAndInsertText(xmlpara, objNode, "DATA", res_owner["ownerName"][0]);	// userName
				
				/* if (document.getElementById("Owner").getAttribute("idVal", "0") == "") {
					createNodeAndInsertText(xmlpara, objNode, "DATA", userID);
				} else {
					createNodeAndInsertText(xmlpara, objNode, "DATA", document.getElementById("Owner").getAttribute("idVal", "0"));
				}

				if (document.getElementById("Owner").getAttribute("NmVal", "0") == "") {
					createNodeAndInsertText(xmlpara, objNode, "DATA", userName);
				} else {
					createNodeAndInsertText(xmlpara, objNode, "DATA", document.getElementById("Owner").getAttribute("NmVal", "0"));
				} */

			    //createNodeAndInsertText(xmlpara, objNode, "DATA", document.getElementById("Owner").getAttribute("position", "0"));
				createNodeAndInsertText(xmlpara, objNode, "DATA", "0");
				createNodeAndInsertText(xmlpara, objNode, "DATA", document.getElementById("OwnerCall").value);
				createNodeAndInsertText(xmlpara, objNode, "DATA", document.getElementById("carName").value);
				createNodeAndInsertText(xmlpara, objNode, "DATA", strCompanyID);
				createNodeAndInsertText(xmlpara, objNode, "DATA", document.getElementById("car_nm").value);

				
				
				var checkSpace2 = document.getElementById("carName2").value.trim();
				
				if (checkSpace2 == 0) {
					document.getElementById("carName2").value = document.getElementById("carName").value;
				}
				
				
				createNodeAndInsertText(xmlpara, objNode, "DATA", document.getElementById("carName2").value);
				
				// 이미지 정보 추가
				createNodeAndInsertText(xmlpara, objNode, "DATA", document.getElementById("hdnfileNM1").value);
				createNodeAndInsertText(xmlpara, objNode, "DATA", document.getElementById("hdnfileNM2").value);

				
				
				//createNodeAndInsertText(xmlpara, objNode, "DATA", document.getElementById("subOwner1").value);
				xmlHttp.open("Post", "/ezCar/callAddClsItem.do", false);
				xmlHttp.send(xmlpara);

				if (xmlHttp.status != 200) {
					alert("1. <spring:message code="ezResource.t42"/>");
					return;
				}

				var rtnXML = xmlHttp.responseXML;
				var dataNodes = GetChildNodes(xmlHttp.responseXML);
				var strRtnVal = getNodeText(dataNodes[0]);

				if (strRtnVal == "False") {
					alert("3. <spring:message code="ezResource.t42"/>");
				} else {
					alert("<spring:message code="ezResource.t56"/>");
					window.opener.RefreshPageDoc();
					window.close();
				}
			}

			function btnCancel_Click() {
				window.close();
			}

			function btnClose_Click() {
				btnfiledel(1);
				btnfiledel(2);
				window.close();
			}

			var select_person_cross_dialogArguments = new Array();
			function btnTakeOwner_Click(val) {
				res_owner["flag"][0] = val;
				res_owner["brdID"][0] = strBrd_ID;
				
				select_person_cross_dialogArguments[0] = res_owner;
				select_person_cross_dialogArguments[1] = btnTakeOwner_Click_Complete;
				var OpenWin = window.open("/ezCar/selectPerson.do", "selectPerson", GetOpenWindowfeature(1050, 550));
				
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

			window.onresize = function () {
				return (navigator.userAgent.indexOf('Firefox') != -1) ?
						
				(function () {
					if (document.getElementsByName('Brd_Explain').length > 1) {
						if (document.getElementsByName('Brd_Explain').item(0).style.height != document.body.clientHeight - 20)
							if (document.body.clientHeight - 20 > 0)
								document.getElementsByName('Brd_Explain').item(0).style.height = document.body.clientHeight - 20;
			                } else {
			                    if (document.getElementById('Brd_Explain').style.height != document.body.clientHeight - 20)
			                        if (document.body.clientHeight - 20 > 0)
			                            document.getElementById('Brd_Explain').style.height = document.body.clientHeight - 20;
			                }
			            }).call(this) :
			            	
				(CrossYN()) ?
			            		
				(function () {
					if (document.getElementsByName('Brd_Explain').length > 1) {
						if (document.getElementsByName('Brd_Explain').item(0).style.height != document.body.clientHeight - 20)
							if (document.body.clientHeight - 20 > 0)
								document.getElementsByName('Brd_Explain').item(0).style.height = document.body.clientHeight - 20;
			                } else {
			                    if (document.getElementById('Brd_Explain').style.height != document.body.clientHeight - 20)
			                        if (document.body.clientHeight - 20 > 0)
			                            document.getElementById('Brd_Explain').style.height = document.body.clientHeight - 20;
			                }
			            }).call(this) :
			            	
				(function () {
						if (document.all.Brd_Explain.length > 1) {
							if (document.all.Brd_Explain(0).style.height != document.body.clientHeight - 20)
								if (document.body.clientHeight - 20 > 0)
									document.all.Brd_Explain(0).style.height = document.body.clientHeight - 20;
			                } else {
			                    if (document.all.Brd_Explain.style.height != document.body.clientHeight - 20)
			                        if (document.body.clientHeight - 20 > 0)
										document.all.Brd_Explain.style.height = document.body.clientHeight - 20;
			                }
			            }).call(this);
			}
			
			function btnfileup() {
				flag1 = true;
		        document.getElementById("file1").click();
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
		        
		        /* 2021-12-08 홍승비 - 차량등록 이미지 업로드 시 서버단에서도 이미지 확장자 체크 진행 (실제 파일 업로드 이전에 ajax로 체크) */
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
	            
	            if(document.getElementById("hdnfileNM1").value != "") {
					btnfiledel(1);
				}
		        
	            fd.append("fileToUpload", filelist[0]);

	            xhr.addEventListener("load", uploadComplete, false);
	            xhr.open("POST", "/ezCar/uploadItemAttach.do");
	            xhr.send(fd); 
			}
			
			var xhr2 = new XMLHttpRequest();
			
			function uploadComplete() {
	            /* if (CrossYN()) {
	                document.getElementById("file1").value = "";
	            }
	            else { */
	                document.getElementById("file1").type = "text";
	                document.getElementById("file1").type = "file";
	            //}
	            var xml = loadXMLString(xhr.responseText);

	            preview1.value = getNodeText(SelectNodes(xml, "ROOT/NODES/DATA2")[0]);
	            preview1.src = "/ezCar/getCarThumbnailInfo.do?mode=temp&fileName="
	            		+encodeURIComponent(getNodeText(SelectNodes(xml, "ROOT/NODES/DATA")[0]))
	            		+encodeURIComponent(getNodeText(SelectNodes(xml, "ROOT/NODES/DATA2")[0]));

	            document.getElementById("hdnfileNM1").value = getNodeText(SelectNodes(xml, "ROOT/NODES/DATA")[0]) + getNodeText(SelectNodes(xml, "ROOT/NODES/DATA2")[0]);
			}
			
		
			
			function btnfiledel(mode) {
				var file = document.getElementById("hdnfileNM" + mode).value;
				
				if(file !=  "") {
					$.ajax({
						async : false,
						url : '/ezCar/tempUploadFileDelete.do',
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
			
		</script>
	</head>
	<body class="popup" style="height:100%; overflow:hidden;">
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
            						<div id="Owner" style="overflow-y:auto; line-height:25px; height:25px;" >
            							<c:out value='${displayName}' />
	            					</div>
	            			</td>
	            			<td style="border-left:0px">
            						<a class="imgbtn imgbck" style="float:right">
            							<span onClick="btnTakeOwner_Click('ListViewOwner');"><spring:message code="ezResource.t154"/></span>
            						</a>
            				</td>
          						<%-- <input type="text" name="Owner" id="Owner" idval="${userID}" position="<c:out value='${title}' />" nmval="<c:out value='${displayName}' />" value="<c:out value='${displayName}' />(<c:out value='${title}' />)" style="width: 200px" readonly> --%>
          					<%-- <th> <spring:message code="ezResource.t151"/></th>
          					<td><input type="text" name="OwnDept" id="OwnDept" idval="${deptID}" value="<c:out value='${deptName}' />" style="width: 100%" readonly></td> --%>
        				</tr>
        				<tr>
          					<th> <spring:message code="ezResource.t155"/></th>
          					<td colspan="3"><input type="text" name="OwnerCall" id="OwnerCall" onKeyup="this.value=this.value.replace(/[^-0-9-,]/g,'');" ^value="${ownerCall}" style="width: 100%"  placeholder="관리자가 여러명일경우 연락처를 쉼표(,)로 구분하여 작성해주세요. (예: 010-1234-1234 , 010-1234-1235)"></td>
          					
          					<%-- <th> <spring:message code="ezResource.rkms01"/></th>
          					<td colspan="3" >
          						<table style="width:100%;">
        							<tr>
										<th style="border:0px; padding:0px; padding-right:2px;"><a class="imgbtn imgbck"><span onClick="btnTakeOwner_Click('ListViewsubOwner');"><spring:message code="ezResource.t154"/></span></a>
            						</th>
										<td><div id="subOwner" style="overflow-y:auto; line-height:25px; height:25px;"></div></td>
        							</tr>
    							</table>
            						<a class="imgbtn imgbck">
            							<span onClick="btnTakeOwner_Click('ListViewsubOwner');"><spring:message code="ezResource.t154"/></span>
            						</a>
            						<div id="subOwner" style="overflow-y:auto; line-height:25px; display:inline"></div>
          						<!-- <input type="text" name="subOwner" id="subOwner" style="width: 200px" readonly> -->
            				</td> --%>
        				</tr>
        				<tr>
        				<th> <spring:message code="ezCar.shb04"/></th>
        				<td colspan="3"><input type="text" name="car_nm" id="car_nm" style="width: 100%" maxlength="20"></td>
        				</tr>
        				<tr>
          					<th> <spring:message code="ezCar.shb03"/></th>
          					<td colspan="3" style="padding:0">
          						<table style="width:100%">
        							<tr class="primary">
										<th> ${langPrimary}</th>
										<td><input type="text" name="carName" id="carName" idval="" value="" tabindex="0" style="width: 100%;" maxlength="500"></td>
        							</tr>
        							<tr class="secondary">
										<th> ${langSecondary}</th>
										<td><input type="text" name="carName2" id="carName2" idval="" value="" style="width: 100%" maxlength="500"></td>
        							</tr>
    							</table>
          					</td>
        				</tr>
        				
        					
        					<tr>
        					<th><spring:message code="ezPortal.t202"/></th>
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
            			
					</table>
					<form method="post" id="form" name="form" enctype="multipart/form-data" action="/ezCar/uploadItemAttach.do" style="display:none">
						<input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="display:none" accept="image/*"/>
      				</form>
      				<input type="hidden" id="hdnfileNM1" name="hdnfileNM1" value="">
					<input type="hidden" id="hdnfileNM2" name="hdnfileNM2" value="">
				</td>
  			</tr>
  		
		</table>
	</body>
</html>