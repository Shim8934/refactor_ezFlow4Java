/**
	@파일명 : adminPage.js
	@만든이 : nckim
	@파일내용 : xml 파일을 Parsing하여 동적생성하는 관리자페이지
*/
window["xmlJson"];
// 주석 내용 정의
var objRemark = {};
var userSettingObj = {};
var xfuColor;
var xfuColorID;

// 부모창에 있는 XFE로부터 서버언어 정보 가져오기
function _getServerSideLanguage(){
	
	// 테이블 Read
	_readTable($("#cmbOption").val());
	
	var xJsonObj = window["xmlJson"];
	for(var i = 0; i < xJsonObj.length; i++){
		
		if(xJsonObj[i].nodename === "ServerSide"){
			
			userSettingObj["serverType"] = window["xmlJson"][i].data;
		}		
	}
}

// 타이틀 정보 동적 생성
function _createTitleCol(product){
	$(".header-pnl").find("table").children().remove();	
	
	var strHtml = "";
	
	if(product === "xfuLanguage"){
		
		strHtml += "<colgroup>";
		strHtml += "<col width="+userSettingObj["title2"][0]["width"]+" id='col1Width'>";
		strHtml += "<col width="+userSettingObj["title2"][1]["width"]+" id='col2Width'>";
		strHtml += "<col width="+userSettingObj["title2"][2]["width"]+" id='col3Width'>";
		strHtml += "<col width="+userSettingObj["title2"][3]["width"]+" id='col4Width'>";
		strHtml += "<col width="+userSettingObj["title2"][4]["width"]+" id='col5Width'>";
		strHtml += "<col width="+userSettingObj["title2"][5]["width"]+" id='col6Width'>";
		strHtml += "<col width='15px'>";
		strHtml += "</colgroup>";
		strHtml += "<tr>";
		strHtml += "<th id='col1'>"+userSettingObj["title2"][0]["label"]+"</th>";
		strHtml += "<th id='col2'><input type='text' readonly='readonly' id='col2-input' class='langTitle' value='"+userSettingObj["title2"][1]["label"]+"'/><button type='button' xid='load'>Load</button><button type='button' xid='save'>Save</button></th>";
		strHtml += "<th id='col3'><input type='text' readonly='readonly' id='col3-input' class='langTitle' value='"+userSettingObj["title2"][2]["label"]+"'/><button type='button' xid='load'>Load</button><button type='button' xid='save'>Save</button></th>";
		strHtml += "<th id='col4'><input type='text' readonly='readonly' id='col4-input' class='langTitle' value='"+userSettingObj["title2"][3]["label"]+"'/><button type='button' xid='load'>Load</button><button type='button' xid='save'>Save</button></th>";
		strHtml += "<th id='col5'><input type='text' readonly='readonly' id='col5-input' class='langTitle' value='"+userSettingObj["title2"][4]["label"]+"'/><button type='button' xid='load'>Load</button><button type='button' xid='save'>Save</button></th>";
		strHtml += "<th id='col6'><input type='text' readonly='readonly' id='col6-input' class='langTitle' value='"+userSettingObj["title2"][5]["label"]+"'/><button type='button' xid='load'>Load</button><button type='button' xid='save'>Save</button></th>";
		strHtml += "<th>&nbsp;&nbsp;&nbsp;&nbsp;</th>";
		strHtml += "</tr>";
		
		$(".header-pnl").find("table").append(strHtml);
		
		// Load
		$(".header-pnl").find("table").find("[xid=load]").click(function(e){
			
			var titleID = $(this).parent().attr("id");
			_makeLangTableData($("#"+titleID).children("input").val());
		});
		
		// Save
		$(".header-pnl").find("table").find("[xid=save]").click(function(e){
			
			if(!confirm("입력한 데이터를 저장하시겠습니까?")) {
				
				return false;
			}
			
			var titleID = $(this).parent().attr("id");
			_readLangTableData($("#"+titleID).children("input").val());
		});
	}
	else{		
		strHtml += "<colgroup>";
		strHtml += "<col width="+userSettingObj["title"][0]["width"]+" id='col1Width'>";
		strHtml += "<col width="+userSettingObj["title"][1]["width"]+" id='col2Width'>";
		strHtml += "<col width="+userSettingObj["title"][2]["width"]+" id='col3Width'>";
		strHtml += "<col width="+userSettingObj["title"][3]["width"]+" id='col4Width'>";
		strHtml += "<col width='15px'>";
		strHtml += "</colgroup>";
		strHtml += "<tr>";
		strHtml += "<th id='col1'>"+userSettingObj["title"][0]["label"]+"</th>";
		strHtml += "<th id='col2'>"+userSettingObj["title"][1]["label"]+"</th>";
		strHtml += "<th id='col3'>"+userSettingObj["title"][2]["label"]+"</th>";
		strHtml += "<th id='col4'>"+userSettingObj["title"][3]["label"]+"</th>";
		strHtml += "<th>&nbsp;&nbsp;&nbsp;&nbsp;</th>";
		strHtml += "</tr>";
		
		$(".header-pnl").find("table").append(strHtml);
	}	
}

// 컬럼 합계 유효성 체크. 모든 컬럼의 합이 100이 되는지 체크
function _isColSumValid(){
	
	var isFlag = false;
	var _col1 = Number(userSettingObj["title"][0]["width"].replace("%", ""));
	var _col2 = Number(userSettingObj["title"][1]["width"].replace("%", ""));
	var _col3 = Number(userSettingObj["title"][2]["width"].replace("%", ""));
	var _col4 = Number(userSettingObj["title"][3]["width"].replace("%", ""));
	
	if(_col1 + _col2 + _col3 + _col4 === 100){
		
		isFlag = true;			
		$("#col1Width").attr("width", userSettingObj["title"][0]["width"]);
		$("#col2Width").attr("width", userSettingObj["title"][1]["width"]);
		$("#col3Width").attr("width", userSettingObj["title"][2]["width"]);
		$("#col4Width").attr("width", userSettingObj["title"][3]["width"]);
	}
	return isFlag;
}

//(미사용)
function _setBasePath(readUrl, writeUrl){
	var _objUrl = {
		"readUrl" : readUrl,
		"writeUrl" : writeUrl
	};
	
	var protocol = location.href;
	var hostName = location.hostname;
	var port = ":" + location.port;
	
	if(protocol.indexOf("https://") > -1) {
		
		protocol = "https://";	
	}
	else {
		
		protocol = "http://";	
	}
	
	if(typeof(_objUrl["readUrl"]) === "undefined"){
		
		_objUrl["readUrl"] = protocol + hostName + port + "/adminPage";			
	}
	
	if(typeof(_objUrl["writeUrl"]) === "undefined"){
		
		_objUrl["writeUrl"] = "/adminPage";			
	}
	
	return _objUrl;
}

// 제품 선택시 실행
function _setProduct(selectedProduct){
	
	// 테이블 생성
	$("#xmlArea").children().remove();
	$("#xmlArea").attr("style", "");
	$("#readXmlPath, #writeXmlPath").removeAttr("disabled");
	
	_createTitleCol(selectedProduct);
	
	// 미선택
	if (selectedProduct === "none") {
		
		alert("항목을 선택해주시기 바랍니다.");
		
		var areaHeight = $(window).height() - 280;
		
		$("#emptyArea").show().css({
			"height" : areaHeight,
			"line-height" : areaHeight/2+80+"px"
		});
		
		$("#readXmlPath, #writeXmlPath").attr("disabled", "disabled");			
		
		return false;
	}	
	
	_createBodyCol(selectedProduct);	
	_makeTable(window["xmlJson"], selectedProduct);	
}

// Table body영역의 col정보 세팅
function _createBodyCol(selectedProduct){
	
	var strXmlElement = "";
	
	if(selectedProduct === "xfuLanguage"){
		
		strXmlElement += "<table class=\"contents\" width=\"100%\">";
		strXmlElement += "<colgroup>";            
		strXmlElement += "<col width='" + userSettingObj["title2"][0]["width"] + "'>";
		strXmlElement += "<col width='" + userSettingObj["title2"][1]["width"] + "'>";
		strXmlElement += "<col width='" + userSettingObj["title2"][2]["width"] + "'>";
		strXmlElement += "<col width='" + userSettingObj["title2"][3]["width"] + "'>";
		strXmlElement += "<col width='" + userSettingObj["title2"][4]["width"] + "'>";
		strXmlElement += "<col width='" + userSettingObj["title2"][5]["width"] + "'>";
		strXmlElement += "</colgroup>";
		strXmlElement += "</table>";
	}
	
	else{
		
		strXmlElement += "<table class=\"contents\" width=\"100%\">";
		strXmlElement += "<colgroup>";            
		strXmlElement += "<col width='" + userSettingObj["title"][0]["width"] + "'>";
		strXmlElement += "<col width='" + userSettingObj["title"][1]["width"] + "'>";
		strXmlElement += "<col width='" + userSettingObj["title"][2]["width"] + "'>";
		strXmlElement += "<col width='" + userSettingObj["title"][3]["width"] + "'>";
		strXmlElement += "</colgroup>";
		strXmlElement += "</table>";
	}
	
	$("#xmlArea").append(strXmlElement);
}

function _setLoadProduct(selectedProduct){
	
	var tailMsg = " 파일을 불러옵니다.\n잠시만 기다려주시기 바랍니다.";		
	
	// 미선택
		if (selectedProduct === "none") {				
			
			$("#readXmlPath, #writeXmlPath").val("").attr("disabled", "disabled");
			$("#xmlArea").children().remove();
			$("#xmlArea").attr("style", "");
			
			return false;
		}
		
		// XFE
		else if (selectedProduct === "xfeEnv") {
			
			$("#readXmlPath").val(userSettingObj["readUrl"] + userSettingObj["loadXml"]["xfeEnv"]);
			$("#writeXmlPath").val(userSettingObj["writeUrl"] + userSettingObj["saveXml"]["xfeEnv"]);
			//alert("[알림]\n" + userSettingObj["readUrl"] + userSettingObj["loadXml"]["xfeEnv"] + tailMsg);
		}
		
		// AD
		else if (selectedProduct === "ad") {
			
			$("#readXmlPath").val(userSettingObj["readUrl"] + userSettingObj["loadXml"]["ad"]);
			$("#writeXmlPath").val(userSettingObj["writeUrl"] + userSettingObj["saveXml"]["ad"]);
			
			alert("작업 중 입니다.");
		}
		
		// XFU
		else if (selectedProduct === "xfuConfig") {
			
			$("#readXmlPath").val(userSettingObj["readUrl"] + userSettingObj["loadXml"]["xfuConfig"]);
			$("#writeXmlPath").val(userSettingObj["writeUrl"] + userSettingObj["saveXml"]["xfuConfig"]);
			
			//alert("[알림]\n" + userSettingObj["readUrl"] + userSettingObj["loadXml"]["xfuConfig"] + tailMsg);
		}
		
		else if (selectedProduct === "xfuLanguage") {
			
			$("#readXmlPath").val(userSettingObj["readUrl"] + userSettingObj["loadXml"]["xfuLanguage"]);
			$("#writeXmlPath").val(userSettingObj["writeUrl"] + userSettingObj["saveXml"]["xfuLanguage"]);
			
			//alert("[알림]\n" + userSettingObj["readUrl"] + userSettingObj["loadXml"]["xfuLanguage"] + tailMsg);
			$("#langControlArea").show();
		}
		_setProduct(selectedProduct);
}

// 이벤트 핸들러 등록
function _setEvtHandler(){
	
	$("#cmbOption").change(function(e){
		
		var areaHeight = $(window).height() - 280;
		$("#emptyArea").show().css({
			"height" : areaHeight,
			"line-height" : areaHeight/2+80+"px"
		});
		
		$("body").css("cursor", "progress");
		$("#langControlArea").hide();
					
		var selectedProduct = $(this).val();
		_setLoadProduct(selectedProduct);
	});
	
	// xml파일 읽기
	$("#btnReadXml").click(function(e){
		
		var areaHeight = $(window).height() - 280;
		$("#emptyArea").css({
			"height" : areaHeight,
			"line-height" : areaHeight/2+80+"px"
		});
		
		_setProduct($("#cmbOption").val());
		
	});
	
	// xml파일 쓰기
	$("#btnWriteXml").click(function(e){
		
		if ($("#cmbOption").val() === "none") {
			
			alert("항목을 선택해주시기 바랍니다.");
			$("#readXmlPath, #writeXmlPath").attr("disabled", "disabled");
			
			return false;
		}
		
		if(!confirm("수정한 내용을 저장하시겠습니까?")) {
			return false;	
		}
		
		_getServerSideLanguage();
		
		// makeXml파일 호출경로
		var strSvrUrl = "./svr/makeXml." + userSettingObj["serverType"];
		
		// 테이블 Read
		_readTable($("#cmbOption").val());
		
		var postData = (userSettingObj["serverType"] === "php")? encodeURIComponent(JSON.stringify(window["xmlJson"])) : JSON.stringify(window["xmlJson"]);
		
		$.ajax({
			url : strSvrUrl, 
			type:"post",
			dataType:"text",
			data : postData,
			success : function(result,status,xhr){
				
				// 저장된 데이터 내용이 올바르지 않는 경우 체크
				if(xhr.responseText.indexOf("xml version=") === -1){
					
					alert("저장에 실패했습니다. ServerSide 값을 다시한번 확인해주세요.");
					console.log(result);
					console.log(status);
					console.log(xhr);
					
					return false;
				} else {
					
					alert("저장되었습니다.");
					console.log(result);
					console.log(status);
					console.log(xhr);
				}				
			},
			error : function(xhr,status,error){
				
				alert("저장에 실패했습니다.");
				console.log(xhr);
				console.log(status);
				console.log(error);
			}
		});
	});
	
	// 행추가
	$("#btnAddRow").click(function(e){
		
		var idx = Number($("#xmlArea table tr:last").attr("id")) + 1;
		var strHtml = "";
		
		if($("#cmbOption").val() === "none"){
			
		}
		
		else if($("#cmbOption").val() === "xfeEnv"){
			
		}
		
		else if($("#cmbOption").val() === "xfuConfig"){
			
		}
		
		else if($("#cmbOption").val() === "xfuLanguage"){
			
			strHtml += "<tr id=" + idx + ">";
			strHtml += "<th><textarea cols=\"45\" rows=\"2\" id='" + idx + "-" + userSettingObj["title2"][0]["label"] + "' ></textarea></th>";			
			strHtml += "<td id='"+userSettingObj["title2"][1]["label"]+"-"+idx+"'><textarea cols=\"45\" rows=\"2\" id='" + idx + "-" + userSettingObj["title2"][1]["label"] + "' ></textarea></td>";
			strHtml += "<td id='"+userSettingObj["title2"][2]["label"]+"-"+idx+"'><textarea cols=\"45\" rows=\"2\" id='" + idx + "-" + userSettingObj["title2"][2]["label"] + "' ></textarea></td>";
			strHtml += "<td id='"+userSettingObj["title2"][3]["label"]+"-"+idx+"'><textarea cols=\"45\" rows=\"2\" id='" + idx + "-" + userSettingObj["title2"][3]["label"] + "' ></textarea></td>";
			strHtml += "<td id='"+userSettingObj["title2"][4]["label"]+"-"+idx+"'><textarea cols=\"45\" rows=\"2\" id='" + idx + "-" + userSettingObj["title2"][4]["label"] + "' ></textarea></td>";
			strHtml += "<td id='"+userSettingObj["title2"][5]["label"]+"-"+idx+"'><textarea cols=\"45\" rows=\"2\" id='" + idx + "-" + userSettingObj["title2"][5]["label"] + "' ></textarea></td>";
			strHtml += "</tr>";	
		}
		
		// 데이터 최종 출력
		$("#xmlArea table").append(strHtml);
		$("#xmlArea table").find("input[type=text],select,textarea").not(".np").css("width", "90%");		
		$("#xmlArea").scrollTop($("#xmlArea table").height());
	});
	
	// 열추가
	$("#btnAddCol").click(function(e){
		
	});
	
	// window resize
	$(window).resize(function(e){
		
		var areaHeight = $(window).height() - 221;
		
		if($("#emptyArea").css("display") === "block"){
			
			$("#emptyArea").css({
				"height" : areaHeight,
				"line-height" : areaHeight/221+"px"
			});
		}
		
		else{
			
			$("#emptyArea").attr("height", "");
			$("#xmlArea").css("height", areaHeight);
		}
	});

	// 상단 탭 클릭 이벤트 핸들러		
	$(".optSelection-pnl").find("li").click(function(e){
		
		var optVal = "xfeEnv";
		var productTitleText = $(this).text();
		
		if(productTitleText === "X-Free Editor") {
			optVal = "xfeEnv";	
		}
		
		else if(productTitleText === "X-Free Uploader") {
			
			optVal = "xfuConfig";
		} 
		
		else if(productTitleText === "X-Free Uploader Language") {
			
			optVal = "xfuLanguage";
		} 
		
		$("#cmbOption").val(optVal);
		_setLoadProduct(optVal);
		
		$(".optSelection-pnl").find("li").removeClass("active");
		$(this).addClass("active");
		
		// 행추가 숨김 예외처리
		if(optVal !== "xfuLanguage") {
			
			$("#langControlArea").hide();	
		}
	});

	// 초기화면 리로드 처리
	$("h1").click(function(e){
		
		var areaHeight = $(window).height() - 221;
		
		$("#emptyArea").show().css({
			"height" : areaHeight
			//"line-height" : areaHeight/2+80+"px"
		});
		
		$("body").css("cursor", "progress");
		$("#langControlArea").hide();
		
		//var optVal = "none";
		var optVal = "xfeEnv";
		$("#cmbOption").val(optVal);		
		_setLoadProduct(optVal);
		
		$(".optSelection-pnl").find("li").removeClass("active");			
	});
}

// 추가 설명 이미지 클릭했을 때, tooltip 띄우기
// aykim
function _mousedown(event) {
	
	var target = event.target ? event.target : event.srcElement;
	var tr = document.getElementById('0').parentElement.children;
	var imgBox = target.parentElement;
	var ex_btn = '';

	// 이미 열려있는 tooltip 을 찾는다.
	for(var i=0; i < tr.length; i++) {
		
		var btn = document.getElementById('moreInfoBtn_' + i);

		if(btn.style.backgroundColor === 'rgb(226, 225, 225)') {
			
			ex_btn = btn;
			break;
		}
	}
	
	// 열려있는 tooltip 이 없거나, 이미 열려있는 버튼을 눌렀을 때
	if(ex_btn === '' || ex_btn === imgBox) {
		
		for(var i=0; i < imgBox.childNodes.length; i++) {
			
			if(imgBox.childNodes[i].id === 'remark_plus') {

				var span = imgBox.childNodes[i];

				if(span.style.display === 'none') {
					
					span.style.display = '';
					imgBox.style.backgroundColor = '#cccccc';
				} 
				
				else if(span.style.display === '') {
					
					span.style.display = 'none';
					imgBox.style.backgroundColor = '#777777';
				}
			}
		}
	} 
	
	else if(ex_btn.nodeName === "SPAN") {
		
		// 열려있는 tooltip 을 닫고, 새로운 tooltip 을 열어준다.

		for(var i=0; i < ex_btn.childNodes.length; i++) {
			
			if(ex_btn.childNodes[i].id === 'remark_plus') {

				var ex_span = ex_btn.childNodes[i];

				if(ex_span.style.display === '') {
					
					ex_span.style.display = 'none';
					ex_btn.style.backgroundColor = '#777777';
				} 
				
				else if(ex_span.style.display === 'none') {
					
					ex_span.style.display = '';
					ex_btn.style.backgroundColor = '#cccccc';
				}
			}
		}

		for(var i=0; i < imgBox.childNodes.length; i++) {

			if(imgBox.childNodes[i].id === 'remark_plus') {

				var span = imgBox.childNodes[i];

				if(span.style.display === 'none') {
					
					span.style.display = '';
					imgBox.style.backgroundColor = '#e2e1e1';
				}
			}
		}
	}	
}


// 수정한 내용 재가공 처리
function _readTable(optFlag){
	
	var xJsonObj = window["xmlJson"];
	var $xmlArea = $("#xmlArea").find("table");
	// 유효성 검사
	
	console.log(xJsonObj);
	
	// 세팅
	//for(var i=0; i<$("#xmlArea table tr").length; i++){
	for(var i=0; i<xJsonObj.length; i++){
		
		xJsonObj[i] = {};
		
		xJsonObj[i]["solution"] = optFlag;
		xJsonObj[i]["savePath"] = $("#writeXmlPath").val();
		xJsonObj[i]["nodename"] = $xmlArea.find("#"+i).find("th").html();
		xJsonObj[i]["apply"] = $xmlArea.find("#"+i+"-1").val();		
		xJsonObj[i]["data"] = $xmlArea.find("#"+i+"-2").val();
		
		var strRemark = "";
		
		if(typeof(objRemark[optFlag][xJsonObj[i]["nodename"]]) === "undefined"){
			
			// remarkMsgObj.js 파일에 추가되지 않은 항목인 경우에 빈값으로 예외처리.
			strRemark = "";
		}
		else{			
			
			strRemark = objRemark[optFlag][xJsonObj[i]["nodename"]][1];
		}
		
		xJsonObj[i]["remark"] = strRemark;				// 직접적인 줄바꿈 처리를 위해서
		//xJsonObj[i]["remark"] = objRemark[optFlag][xJsonObj[i]["nodename"]][1];				// 직접적인 줄바꿈 처리를 위해서
		//xJsonObj[i]["remark"] = $(objRemark[optFlag][xJsonObj[i]["nodename"]][0]).text();  	// 텍스트만 보이게
		
		if(optFlag === "xfeEnv"){
			
			if(xJsonObj[i]["nodename"] === "ShowTab"){
				
				var arrStData = [];
				var $chkShowTab;
				
				for(var j=0; j<$xmlArea.find("[name="+i+"-2]").length; j++){
					
					$chkShowTab = $xmlArea.find("[name="+i+"-2]")[j];						
					
					if($($chkShowTab).is(":checked")){
						
						arrStData.push($($chkShowTab).val());
					}
				}
				
				xJsonObj[i]["data"] = arrStData.toString();
			}
			else if(xJsonObj[i]["nodename"] === "FontFamilyValue"){
				
				var ffvStr = "";
				
				for(var re=0; re<$("#ffvArea").find("tr").length; re++){
					
					var key = $("#ffvArea").find("tr:nth-child("+Number(re+1)+")").find("td:nth-child(2)").text();						
					
					if(re < $("#ffvArea").find("tr").length-1) {
						
						ffvStr += key + ",";	
					}
					else {
						
						ffvStr += key;	
					}
				}
				
				xJsonObj[i]["data"] = ffvStr;
				xJsonObj[i]["style"] = $xmlArea.find("#"+i+"-3").val();
				xJsonObj[i]["width"] = $xmlArea.find("#"+i+"-4").val();
			}
			else if(xJsonObj[i]["nodename"] === "FontSizeValue"){
				
				var fsvStr = "";
				
				for(var re=0; re<$("#fsvArea").find("tr").length; re++){
					
					var key = $("#fsvArea").find("tr:nth-child("+Number(re+1)+")").find("td:nth-child(2)").text();						
					
					if(re < $("#fsvArea").find("tr").length-1) {
						
						fsvStr += key + ",";
					}
					else {
						
						fsvStr += key;	
					}
				}
				
				xJsonObj[i]["data"] = fsvStr;
				xJsonObj[i]["style"] = $xmlArea.find("#"+i+"-3").val();
				xJsonObj[i]["width"] = $xmlArea.find("#"+i+"-4").val();
			}
			else if(xJsonObj[i]["nodename"] === "LineHeightValue"){
				
				var lhvStr = "";
				
				for(var re=0; re<$("#lhvArea").find("tr").length; re++){
					
					var key = $("#lhvArea").find("tr:nth-child("+Number(re+1)+")").find("td:nth-child(2)").text();
					
					if(re < $("#lhvArea").find("tr").length-1){
						
						lhvStr += key + ",";
					} 
					else {
						
						lhvStr += key;	
					}
				}
				
				xJsonObj[i]["data"] = lhvStr;
				xJsonObj[i]["style"] = $xmlArea.find("#"+i+"-3").val();
				xJsonObj[i]["width"] = $xmlArea.find("#"+i+"-4").val();
			}
			else if(xJsonObj[i]["nodename"] === "LetterSpacingValue"){
				
				var lsvStr = "";
				
				for(var re=0; re<$("#lsvArea").find("tr").length; re++){
					
					var key = $("#lsvArea").find("tr:nth-child("+Number(re+1)+")").find("td:nth-child(2)").text();						
					
					if(re < $("#lsvArea").find("tr").length-1) {
						
						lsvStr += key + ",";	
					}
					else {
						
						lsvStr += key;	
					}
				}
				
				xJsonObj[i]["data"] = lsvStr;
				xJsonObj[i]["style"] = $xmlArea.find("#"+i+"-3").val();
				xJsonObj[i]["width"] = $xmlArea.find("#"+i+"-4").val();
			}
			else if(xJsonObj[i]["nodename"] === "LimitImageSize"){
				
				xJsonObj[i]["width"] = $xmlArea.find("#"+i+"-3").val();
				xJsonObj[i]["height"] = $xmlArea.find("#"+i+"-4").val();
			}
			else if(xJsonObj[i]["nodename"] === "TableCellParagraph"){
				
				xJsonObj[i]["style"] = $xmlArea.find("#"+i+"-2").val();
			}
			else if(xJsonObj[i]["nodename"] === "ShowGrid"){
				
				xJsonObj[i]["color"] = $xmlArea.find("#"+i+"-3").val();
				xJsonObj[i]["size"] = $xmlArea.find("#"+i+"-4").val();
				xJsonObj[i]["type"] = $xmlArea.find("#"+i+"-5").val();
				xJsonObj[i]["repeat"] = $xmlArea.find("#"+i+"-6").val();
			}
			else if(xJsonObj[i]["nodename"] === "ShowVerticalLine"){
				
				xJsonObj[i]["left"] = $xmlArea.find("#"+i+"-3").val();
				xJsonObj[i]["color"] = $xmlArea.find("#"+i+"-4").val();
				xJsonObj[i]["style"] = $xmlArea.find("#"+i+"-5").val();
			}
			else if(xJsonObj[i]["nodename"] === "IndentSize"){
				
				xJsonObj[i]["type"] = $xmlArea.find("#"+i+"-3").val();
			}
			else if(xJsonObj[i]["nodename"] === "SetInitParagraphStyle"){
				
				xJsonObj[i]["action"] = $xmlArea.find("#"+i+"-2").val();
				xJsonObj[i]["style"] = $xmlArea.find("#"+i+"-3").val();
			}
			else if(xJsonObj[i]["nodename"] === "AutoSave"){
				
				xJsonObj[i]["time"] = $xmlArea.find("#"+i+"-3").val();
			}
			else if(xJsonObj[i]["nodename"] === "ShowRuler"){
				
				xJsonObj[i]["state"] = $xmlArea.find("#"+i+"-3").val();
			}
			else if(xJsonObj[i]["nodename"] === "ExceptionTagType"){
				
				var ettStr = "";
				
				for(var re=0; re<$("#ettArea").find("tr").length; re++){
					
					var key = $("#ettArea").find("tr:nth-child("+Number(re+1)+")").find("td:nth-child(2)").text();			
					
					if(re < $("#ettArea").find("tr").length-1) {
						
						ettStr += key + ",";	
					}
					else {
						
						ettStr += key;	
					}
				}
				
				xJsonObj[i]["data"] = ettStr;
			}
			else if(xJsonObj[i]["nodename"] === "ReplaceExpression"){
				
				var findExpression = {};
				
				for(var re=0; re<$("#re2DepthTable").find("tr").length; re++){
					
					var key = $("#re2DepthTable").find("tr:nth-child("+Number(re+1)+")").find("td:nth-child(2)").text();
					var value = $("#re2DepthTable").find("tr:nth-child("+Number(re+1)+")").find("input").val();
					findExpression[key] = value;
				}				
				
				xJsonObj[i]["objData"] = findExpression;
				xJsonObj[i]["data"] = "";
				xJsonObj[i]["a_lert"] = $xmlArea.find("#"+i+"-3").val();
			}				
		}
		else if(optFlag === "ad"){
			
		}
		else if(optFlag === "xfuConfig"){
			
			if(xJsonObj[i]["nodename"] === "fileExt"){
				
				var feStr = "";
				
				for(var re=0; re<$("#fileExtArea").find("tr").length; re++){
					
					var key = $("#fileExtArea").find("tr:nth-child("+Number(re+1)+")").find("td:nth-child(2)").text();						
					
					if(re < $("#fileExtArea").find("tr").length-1) {
						
						feStr += key + ",";	
					}
					else {
						
						feStr += key;	
					}
				}
				xJsonObj[i]["data"] = feStr;
			}
			else if(xJsonObj[i]["nodename"] === "blackListFileExt"){
				
				var bfeStr = "";
				
				for(var re=0; re<$("#blackFileExtArea").find("tr").length; re++){
					
					var key = $("#blackFileExtArea").find("tr:nth-child("+Number(re+1)+")").find("td:nth-child(2)").text();						
					
					if(re < $("#blackFileExtArea").find("tr").length-1) {
						
						bfeStr += key + ",";	
					}
					
					else {
						
						bfeStr += key;	
					}
				}
				
				xJsonObj[i]["data"] = bfeStr;
			}
		}
	}
	window["xmlJson"] = xJsonObj;
	
	console.log(window["xmlJson"]);
}

// 주석 내용 불러오기
function _reMarkMsg(){
	
	$.ajax({
		url : "./js/remarkMsgObj.js", 
		success : function(result,status,xhr){
			
			objRemark = eval(result);
		},
		error : function(xhr,status,error){
			
			alert("remarkMsgObj.js 파일을 불러올 수 없습니다.");
		}
	});
}

// 나머지 테이블 데이터 동적 생성
function _makeLangTableData(lang){
	
	var setUrl = $("#readXmlPath").val();
	setUrl += lang + ".xml";
	
	$.get(setUrl, function (configData) {
		
		$(configData).find("xFreeUploader").children().each(function (idx) {	
		
			var $entry = $(this);
			window["xmlJson"][idx][lang] = $entry.text();
			
			var strHtml = "<textarea cols=\"45\" rows=\"2\" id='" + idx + "-" + lang + "' >" + window["xmlJson"][idx][lang] + "</textarea>";
			$("#xmlArea table").find("#"+lang+"-"+idx).children().remove();
			$("#xmlArea table").find("#"+lang+"-"+idx).append(strHtml);
			
			$("#xmlArea table").find("input[type=text],select,textarea").not(".np").css("width", "90%");		
			$("#emptyArea").hide();
			$("body").css("cursor", "auto");	
		});			
	}).fail(function(jqXHR) {
		
		alert(jqXHR.statusText);
		
	});
}

// 수정된 데이터 읽어오기
function _readLangTableData(lang){
	
	var xmlSendData = [];
	var keyName = userSettingObj["title2"][0]["label"];
	
	for(var i=0; i<$("#xmlArea table tr").length; i++){
		
		xmlSendData[i] = {};
		
		xmlSendData[i]["solution"] = "xfuLanguage";
		xmlSendData[i]["savePath"] = $("#writeXmlPath").val() + lang + ".xml";
		xmlSendData[i]["key"] = $("#xmlArea table").find("#" + i + "-" + keyName).val();		
		xmlSendData[i]["data"] = $("#xmlArea table").find("#" + i + "-" + lang).val();
	}	
	
	_saveLangData(xmlSendData);
}

// 수정된 데이터 XML만들기
function _saveLangData(xmlSendData){
	
	_getServerSideLanguage();
	
	var strSvrUrl = "./svr/makeXml." + userSettingObj["serverType"];
	
	var postData = (userSettingObj["serverType"] === "php")? encodeURIComponent(JSON.stringify(xmlSendData)) : JSON.stringify(xmlSendData);
	
	$.ajax({
		url : strSvrUrl, 
		type:"post",
		dataType:"text",
		data : postData,
		success : function(result,status,xhr){
			
			alert("[정상] XML파일 생성 완료되었습니다");
			console.log(result);
			console.log(status);
			console.log(xhr);
		},
		error : function(xhr,status,error){
			
			alert("[서버에러] XML파일 생성 실패하었습니다");
			console.log(xhr);
			console.log(status);
			console.log(error);
		}
	});
}

// 테이블 데이터 최초 생성
function _makeLangTable(){
	
	window["xmlJson"] = [];
	
	var setUrl = $("#readXmlPath").val();
	setUrl += userSettingObj["title2"][1]["label"] + ".xml";		// ko.xml
	
	$.get(setUrl, function (configData) {
		
		$(configData).find("xFreeUploader").children().each(function (idx) {	
		
			var $entry = $(this);					
			var xmlObj = {};
			
			xmlObj["key"] = $entry[0].nodeName;
			xmlObj[userSettingObj["title2"][1]["label"]] = $entry.text();
			
			window["xmlJson"].push(xmlObj);
			
			var strHtml = "";
			strHtml += "<tr id=" + idx + ">";
			//strHtml += "<th>" + xmlObj["key"] + "</th>";
			strHtml += "<th><textarea cols=\"45\" rows=\"2\" id='" + idx + "-" + userSettingObj["title2"][0]["label"] + "' >" + xmlObj['key'] + "</textarea></th>";	
			/*			
			strHtml += "<td id='"+userSettingObj["title2"][1]["label"]+"-"+idx+"'><textarea cols=\"45\" rows=\"2\" id='" + idx + "-" + userSettingObj["title2"][1]["label"] + "' >" + xmlObj[userSettingObj["title2"][1]["label"]] + "</textarea></td>";
			strHtml += "<td id='"+userSettingObj["title2"][2]["label"]+"-"+idx+"'></td>";
			strHtml += "<td id='"+userSettingObj["title2"][3]["label"]+"-"+idx+"'></td>";
			strHtml += "<td id='"+userSettingObj["title2"][4]["label"]+"-"+idx+"'></td>";
			strHtml += "<td id='"+userSettingObj["title2"][5]["label"]+"-"+idx+"'></td>";
			*/
			strHtml += "<td id='"+$("#col2-input").val()+"-"+idx+"'><textarea cols=\"45\" rows=\"2\" id='" + idx + "-" + $("#col2-input").val() + "' >" + xmlObj[$("#col2-input").val()] + "</textarea></td>";
			strHtml += "<td id='"+$("#col3-input").val()+"-"+idx+"'></td>";
			strHtml += "<td id='"+$("#col4-input").val()+"-"+idx+"'></td>";
			strHtml += "<td id='"+$("#col5-input").val()+"-"+idx+"'></td>";
			strHtml += "<td id='"+$("#col6-input").val()+"-"+idx+"'></td>";
			strHtml += "</tr>";

			// 데이터 최종 출력
			$("#xmlArea table").append(strHtml);
		});
		
		$("#xmlArea table").find("input[type=text],select,textarea").not(".np").css("width", "90%");		
		$("#emptyArea").hide();
		$("body").css("cursor", "auto");
		
		// 나머지 데이터도 자동 조회
		
		var titleObj = userSettingObj["title2"];
		
		for(var i=2; i<titleObj.length; i++){
			
			_makeLangTableData(titleObj[i]["label"]);
		}
	});
}

// 기존의 XML파일을 읽어와 웹페이지에 동적으로 테이블을 생성하는 함수
function _makeTable(xmlJson, optFlag){
	
	var setUrl = $("#readXmlPath").val();
	$("#emptyArea, #perspective").hide();		
	
	// xml 데이터 가져오기
	// X-Free Editor			
	if (optFlag === "xfeEnv") {
		
		window["xmlJson"] = [];			
		
		$.ajax({
			url : setUrl, 
			type:"get",
			cache:false,
			success : function(configData,status,xhr){
				
				var ffvObj = {};
				var fsvObj = {};
				var lhvObj = {};
				var lsvObj = {};
				var ettObj = {};
				var feObj;				// ReplaceExpression 후속처리용 변수				
				
				$(configData).find("edit").children().each(function (idx) {		
					
					var $entry = $(this);					
					var xmlObj = {};
					xmlObj["nodeName"] = $entry[0].nodeName;		// key
					xmlObj["apply"] = $entry.attr("apply");				// apply
					//xmlObj["data"] = $entry[0].textContent;				// value
					xmlObj["data"] = $entry.text();				// value
							
					// ExceptionTagType 예외처리
					if (xmlObj["nodeName"] === "ExceptionTagType") {
						
						xmlObj["data"] = "";
						
						var $nodeNm = $($entry[0]).find("nodeName");
						
						for (var i = 0; i < $nodeNm.length; i++) {
							
							xmlObj["data"] += $($entry[0]).find("nodeName:nth-child(" + Number(i + 1) + ")").text();
							
							if (i + 1 != $nodeNm.length) {
								
								xmlObj["data"] += ",";	
							}
						}
					}
					
					// ReplaceExpression 예외처리
					if (xmlObj["nodeName"] === "ReplaceExpression") {
						
						xmlObj["data"] = {};
						
						var $findExp = $($entry[0]).find("findExpression");						
						
						for (var i = 0; i < $findExp.length; i++) {
							
							var replaceKeyName = $($entry[0]).find("findExpression:nth-child(" + Number(i + 1) + ")").attr("Replace");
							var replaceValue = $($entry[0]).find("findExpression:nth-child(" + Number(i + 1) + ")").text();
							xmlObj["data"][replaceKeyName] = replaceValue;	
						}
						
						xmlObj["alert"] = $entry.attr("alert");
					}

					window["xmlJson"].push(xmlObj);

					var strHtml = "";
					strHtml += "<tr id=" + idx + " class='test' style='border-bottom:1px solid #e2e1e1;'>";
					
					// (1) 옵션명 세팅
					strHtml += "<th title='" + userSettingObj["title"][0]["label"] + "' style='padding:20px 20px; border-right:1px solid #e2e1e1; width:196px;'>" + xmlObj["nodeName"] + "</th>";

					// (2) Apply값 초기세팅
					//strHtml += "<td><input type='input' size='5' id='" + idx + "-1' value=\"" + xmlObj["apply"] + "\"></td>";
					if (xmlObj["apply"] === "true") {
						
						strHtml += "<td title='"+userSettingObj["title"][1]["label"]+"' style='vertical-align:middle; text-align:center; border-right:1px solid #e2e1e1; width:190px;'><select id='" + idx + "-1' class='applyopt_sbx'><option value='true' selected>true</option><option value='false'>false</option></select></td>";
					}
					else {
						
						strHtml += "<td title='"+userSettingObj["title"][1]["label"]+"' style='padding:20px 5px; text-align:center; border-right:1px solid #e2e1e1;'><select id='" + idx + "-1' class='applyopt_sbx'><option value='true'>true</option><option value='false' selected>false</option></select></td>";	
					}

					// (3) 옵션 내용 세팅
					// ShowTab
					if (xmlObj["nodeName"] === "ShowTab") {
						
						var arrShowTabData = (xmlObj["data"])? xmlObj["data"].split(","):"";
						
						for(var i=0; i<arrShowTabData.length; i++){
							
							arrShowTabData[i] = arrShowTabData[i].trim();
						}
						
						var listShowTabData = ["source", "preview", "text", "page"];
						
						
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'>";
						
						// 가져온 데이터
						//strHtml += "<input type='input' size='45' id='" + idx + "-2' value=\"" + xmlObj["data"] + "\">";
						/*
						// multiple selectbox로도 구현(주석처리)
						strHtml += "<select id='"+ idx +"-2' multiple>";
						strHtml += "<option>design</option>";
						strHtml += "<option>source</option>";
						strHtml += "<option>preview</option>";
						strHtml += "<option>text</option>";
						strHtml += "</select>";
						*/
						
						strHtml += "<div>";
						
						var checked;
						/*
						for(var i=0; i<listShowTabData.length; i++){
							
							if(arrShowTabData.indexOf(listShowTabData[i]) > -1) {
								
								checked = " checked='checked' ";	
							}
							else {
								
								checked = "";	
							}
							
							if(listShowTabData[i] === "source") {
								
								strHtml += "<label style='padding:0px 10px;'><input type='checkbox' "+checked+" name='" + idx + "-2' value='" + listShowTabData[i] + "'>" + "&nbsp;" + listShowTabData[i] + "</label>";
							} 
							else if(listShowTabData[i] === "preview") {
								
								strHtml += "<label style='padding:0px 10px;'><input type='checkbox' "+checked+" name='" + idx + "-2' value='" + listShowTabData[i] + "'>" + "&nbsp;" + listShowTabData[i] + "</label>";
							} 
							else if(listShowTabData[i] === "text") {
								
								strHtml += "<label style='padding:0px 10px;'><input type='checkbox' "+checked+" name='" + idx + "-2' value='" + listShowTabData[i] + "'>" + "&nbsp;" + listShowTabData[i] + "</label>";
							}
							else if(listShowTabData[i] === "page") {
								
								strHtml += "<label style='padding:0px 10px;'><input type='checkbox' "+checked+" name='" + idx + "-2' value='" + listShowTabData[i] + "'>" + "&nbsp;" + listShowTabData[i] + "</label>";
							}

							//strHtml += "<label style='padding-right:30px;'><input type='checkbox' "+checked+" name='" + idx + "-2' value='" + listShowTabData[i] + "'>" + "&nbsp;" + listShowTabData[i] + "</label>";
						}
						*/
						for(var i=0; i<listShowTabData.length; i++){
							
							if(arrShowTabData.indexOf(listShowTabData[i]) > -1 ) {
								
								strHtml += "<label style='padding:0px 10px;'><input type='checkbox' checked='checked' name='" + idx + "-2' value='" + listShowTabData[i] + "'>" + "&nbsp;" + listShowTabData[i] + "</label>";
							} else {
								
								strHtml += "<label style='padding:0px 10px;'><input type='checkbox' name='" + idx + "-2' value='" + listShowTabData[i] + "'>" + "&nbsp;" + listShowTabData[i] + "</label>";
							}
						}
						
						
						strHtml += "</div>";
						strHtml += "</td>";
					}
					// ServerSide
					else if (xmlObj["nodeName"] === "ServerSide") {
						
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'><select id='" + idx + "-2' class='opt_select' style='width:207px;'>";

						if(xmlObj["data"] === "jsp") {
							
							strHtml += "<option value='jsp' selected>jsp</option><option value='asp'>asp</option><option value='php'>php</option><option value='aspx'>aspx</option></select></td>";
						} 
						else if(xmlObj["data"] === "asp") {
							
							strHtml += "<option value='jsp'>jsp</option><option value='asp' selected>asp</option><option value='php'>php</option><option value='aspx'>aspx</option></select></td>";
						} 
						else if(xmlObj["data"] === "php") {
							
							strHtml += "<option value='jsp'>jsp</option><option value='asp'>asp</option><option value='php' selected>php</option><option value='aspx'>aspx</option></select></td>";
						} 
						else if(xmlObj["data"] === "aspx")  {
							
							strHtml += "<option value='jsp'>jsp</option><option value='asp'>asp</option><option value='php'>php</option><option value='aspx' selected>aspx</option></select></td>";
						}
					}
					// Language
					else if (xmlObj["nodeName"] === "Language") {

						if(xmlObj["data"] === "korean") {
							
							strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"'style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'><select id='" + idx + "-2' style='width:207px;'><option value='korean' selected>korean</option><option value='english'>english</option><option value='chinese_s'>chinese_s</option><option value='chinese_t'>chinese_t</option><option value='japanese'>japanese</option></select></td>";	
						}
						else if(xmlObj["data"] === "english") {
							
							strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"'style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'><select id='" + idx + "-2' style='width:207px;'><option value='korean'>korean</option><option value='english' selected>english</option><option value='chinese_s'>chinese_s</option><option value='chinese_t'>chinese_t</option><option value='japanese'>japanese</option></select></td>";	
						}
						else if(xmlObj["data"] === "chinese_s") {
							
							strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"'style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'><select id='" + idx + "-2' style='width:207px;'><option value='korean'>korean</option><option value='english'>english</option><option value='chinese_s' selected>chinese_s</option><option value='chinese_t'>chinese_t</option><option value='japanese'>japanese</option></select></td>";	
						}
						else if(xmlObj["data"] === "chinese_t") {
							
							strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"'style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'><select id='" + idx + "-2' style='width:207px;'><option value='korean'>korean</option><option value='english'>english</option><option value='chinese_s'>chinese_s</option><option value='chinese_t' selected>chinese_t</option><option value='japanese'>japanese</option></select></td>";	
						}
						else if(xmlObj["data"] === "japanese") {
							
							strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"'style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'><select id='" + idx + "-2' style='width:207px;'><option value='korean'>korean</option><option value='english'>english</option><option value='chinese_s'>chinese_s</option><option value='chinese_t'>chinese_t</option><option value='japanese' selected>japanese</option></select></td>";
						}
					}
					// DefaultStyleCSS
					else if (xmlObj["nodeName"] === "DefaultStyleCSS") {
						
						var strCssCodeData = xmlObj["data"];
						strCssCodeData = strCssCodeData.replace(/(\s*)/g, "");				// 공백 처리
						strCssCodeData = strCssCodeData.replace(/\}/g, "}\r\n");			// 중괄호 이후 개행처리
						
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"'style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'><textarea cols='52' rows='5' id='" + idx + "-2' >" + strCssCodeData + "</textarea></td>";
					}
					// FontFamilyValue
					else if (xmlObj["nodeName"] === "FontFamilyValue") {
						
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'>";
						strHtml += "<div style='display:inline-block; text-align:center;'>";						
						strHtml += "<div class='opt_div'><label for='"+idx+"-3' style='margin-right:35px;'>style </label><input type='text' class='mini_np' size='10' id='"+idx+"-3' value='"+$entry.attr("style")+"' /></div>";
						strHtml += "<div class='opt_div'><label for='"+idx+"-4' style='margin-right:29px;'>width </label><input type='text' class='mini_np' size='10' id='"+idx+"-4' value='"+$entry.attr("width")+"'";
						strHtml += "style='width:165px; text-align:right; padding-right:5px;'/><span style='font-weight:bold;'> px</span></div>";
						strHtml += "<div class='opt_div'>";
						strHtml += "<label for='ffvKey' style='margin-right:9px;'>항목 추가 </label><input type='text' class='mini_np' size='10' id='ffvKey'>";
						strHtml += "<button type='button' id='addFfvContent' class='addRowBtn'>추가</button></div>";
						strHtml += "</div>";
						strHtml += "</td>";	
						
						// 마크업 생성 후처리 작업시 DOM생성을 위한 데이터 담기
						ffvObj["data"] = xmlObj["data"];
						ffvObj["xid"] = idx;
					}
					// FontSizeValue
					else if (xmlObj["nodeName"] === "FontSizeValue") {
						
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'>";
						strHtml += "<div style='display:inline-block; text-align:center;'>";
						strHtml += "<div class='opt_div'><label for='"+idx+"-3' style='margin-right:35px;'>style </label><input type='text' class='mini_np' size='10' id='"+idx+"-3' value='"+$entry.attr("style")+"'/></div>";
						strHtml += "<div class='opt_div'><label for='"+idx+"-4' style='margin-right:29px;'>width </label><input type='text' class='mini_np' size='10' id='"+idx+"-4' value='"+$entry.attr("width")+"'";
						strHtml += " style='width:165px; text-align:right; padding-right:5px;'/><span style='font-weight:bold;'> px</span></div>";
						strHtml += "<div class='opt_div'>";
						strHtml += "<label for='fsvKey' style='margin-right:9px;'>항목 추가 </label><input type='text' class='mini_np' size='10' id='fsvKey'>";
						strHtml += "<button type='button' id='addFsvContent' class='addRowBtn'>추가</button></div>";
						strHtml += "</div>";
						strHtml += "</td>";	
						
						// 마크업 생성 후처리 작업시 DOM생성을 위한 데이터 담기
						fsvObj["data"] = xmlObj["data"];
						fsvObj["xid"] = idx;				
					}
					// LineHeightValue
					else if (xmlObj["nodeName"] === "LineHeightValue") {		
					
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'>";
						strHtml += "<div style='display:inline-block; text-align:center;'>";
						strHtml += "<div class='opt_div'><label for='"+idx+"-3' style='margin-right:35px;'>style </label><input type='text' class='mini_np' size='10' id='"+idx+"-3' value='"+$entry.attr("style")+"'/></div>";
						strHtml += "<div class='opt_div'><label for='"+idx+"-4' style='margin-right:29px;'>width </label><input type='text' class='mini_np' size='10' id='"+idx+"-4' value='"+$entry.attr("width")+"'";
						strHtml += " style='width:165px; text-align:right; padding-right:5px;'/><span style='font-weight:bold;'> px</span></div>";
						strHtml += "<div class='opt_div'>";
						strHtml += "<label for='lhvKey' style='margin-right:9px;'>항목 추가 </label><input type='text' class='mini_np' size='10' id='lhvKey'>";
						strHtml += "<button type='button' id='addLhvContent' class='addRowBtn'>추가</button></div>";
						strHtml += "</div>";
						strHtml += "</td>";	
						
						// 마크업 생성 후처리 작업시 DOM생성을 위한 데이터 담기
						lhvObj["data"] = xmlObj["data"];
						lhvObj["xid"] = idx;			
					}
					// LetterSpacingValue
					else if (xmlObj["nodeName"] === "LetterSpacingValue") {				
					
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'>";
						strHtml += "<div style='display:inline-block; text-align:center;'>";
						strHtml += "<div class='opt_div'><label for='"+idx+"-3' style='margin-right:35px;'>style </label><input type='text' class='mini_np' size='10' id='"+idx+"-3' value='"+$entry.attr("style")+"'/></div>";
						strHtml += "<div class='opt_div'><label for='"+idx+"-4' style='margin-right:29px;'>width </label><input type='text' class='mini_np' size='10' id='"+idx+"-4' value='"+$entry.attr("width")+"'";
						strHtml += " style='width:165px; text-align:right; padding-right:5px;'/><span style='font-weight:bold;'> px</span></div>";
						strHtml += "<div class='opt_div'>";
						strHtml += "<label for='lsvKey' style='margin-right:9px;'>항목 추가 </label><input type='text' class='mini_np' size='10' id='lsvKey'>";
						strHtml += "<button type='button' id='addLsvContent' class='addRowBtn'>추가</button></div>";
						strHtml += "</div>";
						strHtml += "</td>";	
						
						// 마크업 생성 후처리 작업시 DOM생성을 위한 데이터 담기
						lsvObj["data"] = xmlObj["data"];
						lsvObj["xid"] = idx;
					}
					// ExceptionTagType
					else if (xmlObj["nodeName"] === "ExceptionTagType") {		
					
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'>";
						//strHtml += "<input type='text' size='45' id='" + idx + "-2' value=\"" + xmlObj["data"].replace(/(\s*)/g, "") + "\">";					
						strHtml += "<div style='display:inline-block; text-align:center;'>";
						strHtml += "<div class='opt_div'><label for='ettKey' style='margin-right:9px;'>항목 추가 </label><input type='text' class='mini_np' size='10' id='ettKey'>";
						strHtml += "<button type=\"button\" id=\"addEttContent\" class=\"addRowBtn\">추가</button></div>";					
						strHtml += "</div>";
						strHtml += "</td>";	
						
						// 마크업 생성 후처리 작업시 DOM생성을 위한 데이터 담기
						ettObj["data"] = xmlObj["data"];
						ettObj["xid"] = idx;
					}
					// LimitImageSize
					else if (xmlObj["nodeName"] === "LimitImageSize") {
						
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'>";
						strHtml += "<div class='opt_div' style='text-align:center;'><label for='"+idx+"-3' style='margin-right:15px;'>width </label><input type='text' class='np' size='10' id='"+idx+"-3' value='"+$entry.attr("width")+"'";
						strHtml += " style='width:120px; text-align:right; padding-right:5px;'/><span style='font-weight:bold;'> px</span></div>";
						strHtml += "<div class='opt_div' style='text-align:center;'><label for='"+idx+"-4' style='margin-right:10px;'>height </label><input type='text' class='np' size='10' id='"+idx+"-4' value='"+$entry.attr("height")+"'";
						strHtml += " style='width:120px; text-align:right; padding-right:5px;'/><span style='font-weight:bold;'> px</span></div>";
						strHtml += "</td>";
					}
					// UploadPastedImage
					else if (xmlObj["nodeName"] === "UploadPastedImage") {
						
						if(xmlObj["data"] === "on") {
							
							strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'><select id='" + idx + "-2' style='width:207px;'><option value='on' selected>on</option><option value='off'>off</option></select></td>";	
						}
						else {
							
							strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'><select id='" + idx + "-2' style='width:207px;'><option value='on'>on</option><option value='off' selected>off</option></select></td>";	
						}
					}
					// 비워야 할 컬럼 처리
					else if (xmlObj["nodeName"] === "TableBorderCollapse" || xmlObj["nodeName"] === "RemoveTableBorderCollapse" || 
					xmlObj["nodeName"] === "ActiveHyperLink" || xmlObj["nodeName"] === "SetInitFontStyle" || 
					xmlObj["nodeName"] === "HideMobileToolbar" || xmlObj["nodeName"] === "ShowZeroBorder" || 
					xmlObj["nodeName"] === "SubMenuBar" || xmlObj["nodeName"] === "SizeBar" || 
					xmlObj["nodeName"] === "PasteExcelAsImage" || xmlObj["nodeName"] === "SourceBreakLine" || 
					xmlObj["nodeName"] === "RemoveSpanWrapper" || xmlObj["nodeName"] === "RemoveWhiteSpaceStyle" || 
					xmlObj["nodeName"] === "InsertImageAsBase64" || xmlObj["nodeName"] === "SetInitFontStyleInDiv") {		
						
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='border-right:1px solid #e2e1e1; text-align:center; vertical-align:middle;'>세부 옵션 없음</td>";
					}
					// TableCellParagraph
					else if (xmlObj["nodeName"] === "TableCellParagraph") {
						
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'><label for='" + idx + "-2' style='vertical-align:top; margin-right:4px;'>style </label><textarea cols='34' rows=\"2\" id='" + idx + "-2' >" + $entry.attr("style").replace(/(\s*)/g, "") + "</textarea></td>";
					}
					// SetInitParagraphStyle
					else if (xmlObj["nodeName"] === "SetInitParagraphStyle") {
						
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'>";
						strHtml += "<div class='opt_div' style='text-align:center;'><label for='"+idx+"-2' style='margin-right:20px;'>action </label><select id='"+idx+"-2' style='width:150px;'>";
						
						var $SetInitParagraphStyle_action = $entry.attr("action").replace(/(\s*)/g, "");
						
						if($SetInitParagraphStyle_action === "out") {
							
							strHtml += "<option value='out' selected>out</option><option value='in'>in</option><option value='both'>both</option>";
						} 
						else if($SetInitParagraphStyle_action === "in") {
							
							strHtml += "<option value='out'>out</option><option value='in' selected>in</option><option value='both'>both</option>";
						} 
						else if($SetInitParagraphStyle_action === "both"){
							
							strHtml += "<option value='out'>out</option><option value='in'>in</option><option value='both' selected>both</option>";
						}
						
						strHtml += "</select></div>";
						
						strHtml += "<br/>";
						strHtml += "<label for='" + idx + "-3' style='vertical-align:top; margin-right:4px;'>style </label><textarea cols='34' rows=\"2\" id='" + idx + "-3' >" + $entry.attr("style").replace(/(\s*)/g, "") + "</textarea>";
						strHtml += "</td>";
					}
					// ShowGrid
					else if (xmlObj["nodeName"] === "ShowGrid") {
						
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'>";
						
						// color
						//strHtml += "<label>color : </label><input type='text' class='np' size='10' id='"+idx+"-3' value='"+$entry.attr("color")+"'/><br/>";
						
						var keyArrShowGrid = [];
						
						for (var i = 0; i < $entry.context.attributes.length; i++) {
							
							keyArrShowGrid.push($entry.context.attributes[i].name);
							/*
							if($entry.context.attributes[i].name === 'color') {							
								strHtml += "<div class='opt_div' style='text-align:center;'><label for='"+idx+"-3' style='margin-right:20px;'>color </label><select id='"+idx+"-3' style='width:150px;'>";
		
								if($entry.attr("color") == 'red') {
									strHtml += "<option value='red' selected>red</option><option value='blue'>blue</option><option value='green'>green</option><option value='orange'>orange</option><option value='lime'>lime</option>";
								} else if($entry.attr("color") == "blue") {
									strHtml += "<option value='red'>red</option><option value='blue' selected>blue</option><option value='green'>green</option><option value='orange'>orange</option><option value='lime'>lime</option>";
								} else if($entry.attr("color") == "green"){
									strHtml += "<option value='red'>red</option><option value='blue'>blue</option><option value='green' selected>green</option><option value='orange'>orange</option><option value='lime'>lime</option>";
								} else if($entry.attr("color") == "orange"){
									strHtml += "<option value='red'>red</option><option value='blue'>blue</option><option value='green'>green</option><option value='orange' selected>orange</option><option value='lime'>lime</option>";
								} else if($entry.attr("color") == "lime"){
									strHtml += "<option value='red'>red</option><option value='blue'>blue</option><option value='green'>green</option><option value='orange'>orange</option><option value='lime' selected>lime</option>";
								}
								strHtml += "</select></div>";
							}	
							// size
							//strHtml += "<label>size : </label><input type='text' class='np' size='10' id='"+idx+"-4' value='"+$entry.attr("size")+"' /><br/>";
		
							if($entry.context.attributes[i].name === 'size') { 
								strHtml += "<div class='opt_div' style='text-align:center;'><label for='"+idx+"-4' style='margin-right:28px;'>size </label><select id='"+idx+"-4' style='width:150px;'>";
		
								if($entry.attr("size") === "A3") {
									strHtml += "<option value='A3' selected>A3</option><option value='A4'>A4</option><option value='B4'>B4</option>";	
								} else if($entry.attr("size") == "A4"){
									strHtml += "<option value='A3'>A3</option><option value='A4' selected>A4</option><option value='B4'>B4</option>";
								} else if($entry.attr("size") == "B4"){
									strHtml += "<option value='A3'>A3</option><option value='A4'>A4</option><option value='B4' selected>B4</option>";
								}
								strHtml += "</select></div>";
							}
							
							// type
							if($entry.context.attributes[i].name === "type") {
								strHtml += "<div class='opt_div' style='text-align:center;'><label for='"+idx+"-5' style='margin-right:24px; position:relative; top:-3px;'>type </label><input type='text' class='np' size='10' id='"+idx+"-5' value='"+$entry.attr("type")+"' style='width:143px;' /></div>";
							}
							
							
							// repeat
							//strHtml += "<label>repeat </label><input type='text' class='np' size='10' id='"+idx+"-6' value='"+$entry.attr("repeat")+"' />";
							
							if($entry.context.attributes[i].name === 'repeat') {
								strHtml += "<div class='opt_div' style='text-align:center;'><label for='"+idx+"-6' style='margin-right:12px;'>repeat </label><select id='"+idx+"-6' style='width:150px;'>";
		
								if($entry.attr("repeat") === "repeat") {
									strHtml += "<option value='repeat' selected>repeat</option><option value='repeat-x'>repeat-x</option><option value='repeat-y'>repeat-y</option><option value='no-repeat'>no-repeat</option>";	
								} else if($entry.attr("repeat") == "repeat-x") {
									strHtml += "<option value='repeat'>repeat</option><option value='repeat-x' selected>repeat-x</option><option value='repeat-y'>repeat-y</option><option value='no-repeat'>no-repeat</option>";
								} else if($entry.attr("repeat") == "repeat-y") {
									strHtml += "<option value='repeat'>repeat</option><option value='repeat-x'>repeat-x</option><option value='repeat-y' selected>repeat-y</option><option value='no-repeat'>no-repeat</option>";
								} else if($entry.attr("repeat") == "no-repeat") {
									strHtml += "<option value='repeat'>repeat</option><option value='repeat-x'>repeat-x</option><option value='repeat-y'>repeat-y</option><option value='no-repeat' selected>no-repeat</option>";
								}						
								strHtml += "</select></div>";
							}
							*/
						}
						
						// 해당노드 attribute 순서 맞추기
						if(keyArrShowGrid.indexOf("color") > -1) {
							
							strHtml += "<div class='opt_div' style='text-align:center;'><label for='"+idx+"-3' style='margin-right:20px;'>color </label><select id='"+idx+"-3' style='width:150px;'>";

							if($entry.attr("color") === 'red') {
								
								strHtml += "<option value='red' selected>red</option><option value='blue'>blue</option><option value='green'>green</option><option value='orange'>orange</option><option value='lime'>lime</option>";
							} 
							else if($entry.attr("color") === "blue") {
								
								strHtml += "<option value='red'>red</option><option value='blue' selected>blue</option><option value='green'>green</option><option value='orange'>orange</option><option value='lime'>lime</option>";
							} 
							else if($entry.attr("color") === "green"){
								
								strHtml += "<option value='red'>red</option><option value='blue'>blue</option><option value='green' selected>green</option><option value='orange'>orange</option><option value='lime'>lime</option>";
							} 
							else if($entry.attr("color") === "orange"){
								
								strHtml += "<option value='red'>red</option><option value='blue'>blue</option><option value='green'>green</option><option value='orange' selected>orange</option><option value='lime'>lime</option>";
							} 
							else if($entry.attr("color") === "lime"){
								
								strHtml += "<option value='red'>red</option><option value='blue'>blue</option><option value='green'>green</option><option value='orange'>orange</option><option value='lime' selected>lime</option>";
							}
							
							strHtml += "</select></div>";
						}
						
						// size
						//strHtml += "<label>size : </label><input type='text' class='np' size='10' id='"+idx+"-4' value='"+$entry.attr("size")+"' /><br/>";

						if(keyArrShowGrid.indexOf("size") > -1) {
							
							strHtml += "<div class='opt_div' style='text-align:center;'><label for='"+idx+"-4' style='margin-right:28px;'>size </label><select id='"+idx+"-4' style='width:150px;'>";

							if($entry.attr("size") === "A3") {
								
								strHtml += "<option value='A3' selected>A3</option><option value='A4'>A4</option><option value='B4'>B4</option>";	
							} 
							else if($entry.attr("size") === "A4"){
								
								strHtml += "<option value='A3'>A3</option><option value='A4' selected>A4</option><option value='B4'>B4</option>";
							} 
							else if($entry.attr("size") === "B4"){
								
								strHtml += "<option value='A3'>A3</option><option value='A4'>A4</option><option value='B4' selected>B4</option>";
							}
							
							strHtml += "</select></div>";
						}
						
						// type
						if(keyArrShowGrid.indexOf("type") > -1) {
							
							strHtml += "<div class='opt_div' style='text-align:center;'><label for='"+idx+"-5' style='margin-right:24px; top:-3px;'>type </label><input type='text' class='np' size='10' id='"+idx+"-5' value='"+$entry.attr("type")+"' style='width:145px;' /></div>";
						}
												
						// repeat
						//strHtml += "<label>repeat </label><input type='text' class='np' size='10' id='"+idx+"-6' value='"+$entry.attr("repeat")+"' />";
						
						if(keyArrShowGrid.indexOf("repeat") > -1) {
							
							strHtml += "<div class='opt_div' style='text-align:center;'><label for='"+idx+"-6' style='margin-right:11px;'>repeat </label><select id='"+idx+"-6' style='width:150px;'>";

							if($entry.attr("repeat") === "repeat") {
								
								strHtml += "<option value='repeat' selected>repeat</option><option value='repeat-x'>repeat-x</option><option value='repeat-y'>repeat-y</option><option value='no-repeat'>no-repeat</option>";	
							} 
							else if($entry.attr("repeat") === "repeat-x") {
								
								strHtml += "<option value='repeat'>repeat</option><option value='repeat-x' selected>repeat-x</option><option value='repeat-y'>repeat-y</option><option value='no-repeat'>no-repeat</option>";
							} 
							else if($entry.attr("repeat") === "repeat-y") {
								
								strHtml += "<option value='repeat'>repeat</option><option value='repeat-x'>repeat-x</option><option value='repeat-y' selected>repeat-y</option><option value='no-repeat'>no-repeat</option>";
							} 
							else if($entry.attr("repeat") === "no-repeat") {
								
								strHtml += "<option value='repeat'>repeat</option><option value='repeat-x'>repeat-x</option><option value='repeat-y'>repeat-y</option><option value='no-repeat' selected>no-repeat</option>";
							}	
							
							strHtml += "</select></div>";
						}
						
						
						
						// default값 세팅(ShowGrid)
						if(keyArrShowGrid.indexOf("color") === -1){
							
							strHtml += "<div class='opt_div' style='text-align:center;'><label for='"+idx+"-3' style='margin-right:19px;'>color </label><select id='"+idx+"-3' style='width:150px;'>";	
							strHtml += "<option value='red' selected>red</option><option value='blue'>blue</option><option value='green'>green</option><option value='orange'>orange</option><option value='lime'>lime</option>";						
							strHtml += "</select></div>";
						}
						if(keyArrShowGrid.indexOf("size") === -1){
							
							strHtml += "<div class='opt_div' style='text-align:center;'><label for='"+idx+"-4' style='margin-right:28px;'>size </label><select id='"+idx+"-4' style='width:150px;'>";	
							strHtml += "<option value='A3' selected>A3</option><option value='A4'>A4</option><option value='B4'>B4</option>";
							strHtml += "</select></div>";
						}
						if(keyArrShowGrid.indexOf("type") === -1){
							
							strHtml += "<div class='opt_div' style='text-align:center;'><label for='"+idx+"-5' style='margin-right:24px; position:relative; top:-3px;'>type </label><input type='text' class='np' size='10' id='"+idx+"-5' value='' style='width:145px;' /></div>";
						}
						if(keyArrShowGrid.indexOf("repeat") === -1){
							
							strHtml += "<div class='opt_div' style='text-align:center;'><label for='"+idx+"-6' style='margin-right:11px;'>repeat </label><select id='"+idx+"-6' style='width:150px;'>";
							strHtml += "<option value='repeat' selected>repeat</option><option value='repeat-x'>repeat-x</option><option value='repeat-y'>repeat-y</option><option value='no-repeat'>no-repeat</option>";
							strHtml += "</select></div>";
						}
						
						strHtml += "</td>";
					}
					// ShowVerticalLine
					else if (xmlObj["nodeName"] === "ShowVerticalLine") {
						
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'>";
						
						// left
						var $ShowVerticalLine_left = $entry.attr("left").replace(/(\s*)/g, "");
						strHtml += "<div class='opt_div' style='text-align:center;'><label for='"+idx+"-3' style='margin-right:24px;'>left </label><input type='text' class='np' size='10' id='"+idx+"-3'  style='width:120px;' value='" + $ShowVerticalLine_left + "' /> <span style='font-weight:bold;'> px</span></div>";
						
						// color
						var $ShowVerticalLine_color = $entry.attr("color").replace(/(\s*)/g, "");
						strHtml += "<div class='opt_div' style='text-align:center;'><label for='"+idx+"-4' style='margin-right:20px;'>color </label><select id='"+idx+"-4' style='width:150px;'>";			
						
						if($ShowVerticalLine_color === 'red') {
							
							strHtml += "<option value='red' selected>red</option><option value='blue'>blue</option><option value='green'>green</option><option value='orange'>orange</option><option value='lime'>lime</option>";
						} 
						else if($ShowVerticalLine_color === "blue") {
							
							strHtml += "<option value='red'>red</option><option value='blue' selected>blue</option><option value='green'>green</option><option value='orange'>orange</option><option value='lime'>lime</option>";
						} 
						else if($ShowVerticalLine_color === "green"){
							
							strHtml += "<option value='red'>red</option><option value='blue'>blue</option><option value='green' selected>green</option><option value='orange'>orange</option><option value='lime'>lime</option>";
						} 
						else if($ShowVerticalLine_color === "orange"){
							
							strHtml += "<option value='red'>red</option><option value='blue'>blue</option><option value='green'>green</option><option value='orange' selected>orange</option><option value='lime'>lime</option>";
						} 
						else if($ShowVerticalLine_color === "lime"){
							
							strHtml += "<option value='red'>red</option><option value='blue'>blue</option><option value='green'>green</option><option value='orange'>orange</option><option value='lime' selected>lime</option>";
						}
						
						strHtml += "</select></div>";
						
						// style
						var $ShowVerticalLine_style = $entry.attr("style").replace(/(\s*)/g, "");
						strHtml += "<div class='opt_div' style='text-align:center;'><label for='"+idx+"-5' style='margin-right:21px;'>style </label><select id='"+idx+"-5' style='width:150px;'>";
						
						if($ShowVerticalLine_style === 'solid') {
							
							strHtml += "<option value='solid' selected>solid</option><option value='dotted'>dotted</option><option value='dashed'>dashed</option>";
						} 
						else if($ShowVerticalLine_style === "dotted") {
							
							strHtml += "<option value='solid'>solid</option><option value='dotted' selected>dotted</option><option value='dashed'>dashed</option>";
						} 
						else if($ShowVerticalLine_style === "dashed"){
							
							strHtml += "<option value='solid'>solid</option><option value='dotted'>dotted</option><option value='dashed' selected>dashed</option>";
						} 
						
						strHtml += "</select></div>";
						
						strHtml += "</td>";
					}
					
					// IndentSize
					else if (xmlObj["nodeName"] === "IndentSize") {
						
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'><div class='opt_div' style='text-align:center;'><label for='"+idx+"-3' style='margin-right:13px;'>type </label><select id='"+idx+"-3'";
						strHtml += "style='width:163px;' >"
						
						if($entry.attr("type") === "margin"){
							
							strHtml += "<option value='margin' selected>margin</option><option value='text'>text</option></select></div>";
						}
						else if($entry.attr("type") === "text"){
							
							strHtml += "<option value='margin'>margin</option><option value='text' selected>text</option></select></div>";
						}	
						
						strHtml += "<div class='opt_div' style='text-align:center;'><label for='"+idx+"-2' style='margin-right:12px;'>data </label><input type='text' class='np' size='10' id='"+idx+"-2' value=\"" + xmlObj["data"] + "\"";
						strHtml += "style='width:158px;' >"							
						strHtml += "</td>";
					}
					// HyperLinkTarget
					else if (xmlObj["nodeName"] === "HyperLinkTarget") {
						
						if(xmlObj["data"] === "_blank") {
							
							strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'><select id='" + idx + "-2' style='width:207px;'><option value='_blank' selected>_blank</option><option value='_parent'>_parent</option><option value='_self'>_self</option><option value='_top'>_top</option></select></td>";	
						}
						else if(xmlObj["data"] === "_parent") {
							
							strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'><select id='" + idx + "-2' style='width:207px;'><option value='_blank'>_blank</option><option value='_parent' selected>_parent</option><option value='_self'>_self</option><option value='_top'>_top</option></select></td>";	
						}
						else if(xmlObj["data"] === "_self") {
							
							strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'><select id='" + idx + "-2' style='width:207px;'><option value='_blank'>_blank</option><option value='_parent'>_parent</option><option value='_self' selected>_self</option><option value='_top'>_top</option></select></td>";	
						}
						else if(xmlObj["data"] === "_top") {
							
							strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'><select id='" + idx + "-2' style='width:207px;'><option value='_blank'>_blank</option><option value='_parent'>_parent</option><option value='_self'>_self</option><option value='_top' selected>_top</option></select></td>";	
						}
					}
					// HtmlSourceRange
					else if (xmlObj["nodeName"] === "HtmlSourceRange") {
						
						if(xmlObj["data"] === "html") {
							
							strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'><select id='" + idx + "-2' style='width:207px;'><option value='html' selected>html</option><option value='body'>body</option></select></td>";	
						}
						else if(xmlObj["data"] === "body") {
							
							strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'><select id='" + idx + "-2' style='width:207px;'><option value='html'>html</option><option value='body' selected>body</option></select></td>";	
						}
					}
					// MarkupLanguageFormat
					else if (xmlObj["nodeName"] === "MarkupLanguageFormat") {
						
						if(xmlObj["data"] === "html") {
							
							strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'><select id='" + idx + "-2' style='width:207px;'><option value='html' selected>html</option><option value='xhtml'>xhtml</option></select></td>";	
						}
						else if(xmlObj["data"] === "xhtml") {
							
							strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'><select id='" + idx + "-2' style='width:207px;'><option value='html'>html</option><option value='xhtml' selected>xhtml</option></select></td>";	
						}
					}
					// AutoSave
					else if (xmlObj["nodeName"] === "AutoSave") {
						
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'>";
						strHtml += "<label for='"+idx+"-3' style='margin-right:10px;'>time </label><input type='text' class='np' size='10' id='"+idx+"-3' value='"+$entry.attr("time")+"' style='width:158px; '/><br/>";					
						strHtml += "</td>";
					}
					// ShowRuler
					else if (xmlObj["nodeName"] === "ShowRuler") {
						
						//strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'>";
						//strHtml += "<label for='"+idx+"-3' style='margin-right:10px;'>state </label><input type='text' class='np' size='10' id='"+idx+"-3' value='"+$entry.attr("state")+"' style='width:158px; '/><br/>";											
						//strHtml += "</td>";
						
						if($entry.attr("state") === "on") {
							
							strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'><label for='"+idx+"-3' style='margin-right:10px;'>state </label><select id='" + idx + "-3' class='np' ><option value='on' selected>on</option><option value='off'>off</option></select></td>";	
						}
						else {
							
							strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'><label for='"+idx+"-3' style='margin-right:10px;'>state </label><select id='" + idx + "-3' class='np' ><option value='on'>on</option><option value='off' selected>off</option></select></td>";	
						}
					}
					// InvalidCheckLevel
					else if (xmlObj["nodeName"] === "InvalidCheckLevel") {
						
						if(xmlObj["data"] === "0") {
							
							strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'><select id='" + idx + "-2' style='width:207px;'><option value='0' selected>0</option><option value='1'>1</option><option value='2'>2</option></select></td>";	
						}
						else if(xmlObj["data"] === "1") {
							
							strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'><select id='" + idx + "-2' style='width:207px;'><option value='0'>0</option><option value='1' selected>1</option><option value='2'>2</option></select></td>";	
						}
						else if(xmlObj["data"] === "2") {
							
							strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'><select id='" + idx + "-2' style='width:207px;'><option value='0'>0</option><option value='1'>1</option><option value='2' selected>2</option></select></td>";	
						}
					}
					// ReplaceExpression 예외처리
					else if (xmlObj["nodeName"] === "ReplaceExpression") {
						
						// alert 속성을 attr로 활용할 수 없기에 임의로 처리
						var $strAlert = ($entry[0].attributes[1].nodeName === "alert")? $entry[0].attributes[1].nodeValue : "";
												
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'>";
						strHtml += "<div style='display:inline-block; text-align:center;'>";
						
						//strHtml += "<div class='opt_div'><label for='"+idx+"-3' style='margin-right:34px;'>alert </label><input type='text' class='mini_np' size='10' id='"+idx+"-3' value='"+$strAlert+"'/></div>";
						
						strHtml += "<div class='opt_div'>";
						
						if($strAlert === "on") {
							
							strHtml += "<label for='"+idx+"-3' style='margin-right:42px;'>alert </label><select id='" + idx + "-3' class='mini_np' size='10'><option value='on' selected>on</option><option value='off'>off</option></select>";	
						}
						else {
							
							strHtml += "<label for='"+idx+"-3' style='margin-right:42px;'>alert </label><select id='" + idx + "-3' class='mini_np' ><option value='on'>on</option><option value='off' selected>off</option></select>";	
						}
						
						strHtml += "</div>";
						
						strHtml += "<div class='opt_div'>";
						strHtml += "<label for='replaceKey' style='margin-right:5px;'> findExpression </label><input type=\"text\" class='mini_np' size='10' id='replaceKey' style='width:138px;'>";
						strHtml += "</div>";
						strHtml += "<div class='opt_div'>";
						strHtml += "<label for='replaceValue' style='margin-right:48px;'> Replace </label><input type=\"text\" class='mini_np' size='10' id='replaceValue' style='width:138px;'>";
						strHtml += "<button type=\"button\" id=\"addRe2DepthTable\" class=\"addRowBtn\">추가</button></div>";
						strHtml += "</div>";
						
						// 마크업 생성 후처리 작업시 DOM생성을 위한 데이터 담기
						feObj = xmlObj["data"];
						feObj["xid"] = idx;
					}
					
					//TableDefaultWidth 
					else if(xmlObj["nodeName"] === "TableDefaultWidth") {
						
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'><input type='text' size='45' class='np' id='" + idx + "-2' value=\"" + xmlObj["data"] + "\"";
						strHtml += " style='width:175px; text-align:right; padding-right:5px;'/><span style='font-weight:bold;'> px</span></div>";
					}

					//TableLeftMargin
					else if(xmlObj["nodeName"] === "TableLeftMargin") {
						
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'><input type='text' size='45' class='np' id='" + idx + "-2' value=\"" + xmlObj["data"] + "\"";
						strHtml += " style='width:175px; text-align:right; padding-right:5px;'/><span style='font-weight:bold;'> px</span></div>";
					}

					//ToolbarIconSize
					else if(xmlObj["nodeName"] === "ToolbarIconSize") {
						
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'><input type='text' size='45' class='np' id='" + idx + "-2' value=\"" + xmlObj["data"] + "\"";
						strHtml += " style='width:175px; text-align:right; padding-right:5px;'/><span style='font-weight:bold;'> px</span></div>";
					}

					// 나머지 옵션 내용 세팅     
					else {
						
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"' style='padding:20px 10px; border-right:1px solid #e2e1e1; text-align:center;'><input type='text' size='45' class='np' id='" + idx + "-2' value=\"" + xmlObj["data"] + "\"></td>";						
					}

					// (4) 주석 설명
					//strHtml += "<td title='"+userSettingObj["title"][3]["label"]+"' class=\"remark-pnl\">" + printRemark(xmlObj["nodeName"], "xfeEnv") + "</td>";
					strHtml += "<td title='"+userSettingObj["title"][3]["label"]+"' class='remark-pnl' style='padding:20px 5px 20px 20px;'>"; 
					
					// ayoung
					strHtml += "<span id='moreInfoBtn_" + idx + "' onmousedown='_mousedown(event)'"; 

					strHtml += "style='float:right; display:inline-block; text-align:center; cursor:pointer; background-color:#777777; width:16px; height:16px; float:right; margin: 0px 20px 1px 20px; position:relative;'>";
					strHtml += "<img src='./images/moreInfoBtn.png'>";
					
					strHtml += "<span id='remark_plus' style='position:absolute; right:30px; z-index:100; left:; width:360px; color:#353535; background-color:#fdfdfd; box-shadow: 5px 5px 5px #ccc; border:1px solid #adadad; padding:15px 10px; text-align:left; display:none;'>";
					strHtml += printRemarkPlus(xmlObj["nodeName"], "xfeEnv", idx);
					

					strHtml += "</span>";

					strHtml += "</span>";
					
					strHtml += printRemark(xmlObj["nodeName"], "xfeEnv");
					
					
					strHtml += "</td>";

					strHtml += "</tr>";

					// 데이터 최종 출력
					// aykim
					
					//$("#xmlArea table").append(strHtml).find("input[type=text],select,textarea").not(".np").css("width", "50%").css('height','20px').css('padding-left','5px');
					
					// 옵션 내용의 select 박스 css
					$("#xmlArea table").append(strHtml).find("select").not(".np, .applyopt_sbx").css("height", "22px").css('padding-left', '1px');				

					//$("#xmlArea table").append(strHtml);
					$("#emptyArea").hide();
					$("body").css("cursor", "auto");
					

					// 기본 "추가" 설명이 있는 옵션만
					// 버튼 보이도록.
					//aykim
					
					var imageDiv = document.getElementById('moreInfoBtn_' + idx);
					
					if(imageDiv.children[1].nodeName === 'SPAN') {
						
						if(imageDiv.children[1].innerText === 'undefined' || imageDiv.children[1].innerText === "") {
							
							imageDiv.style.display = 'none';
						}
					}
				});
				
				// 콜백 처리
				// FontFamilyValue 데이터 노드 추가



				var strFfv = "";

				strFfv += "<div style='margin-top:15px; width:90%; display:inline-block; text-align:center;'>";
				strFfv += "<table style='width:;'>";
				strFfv += "<colgroup>";
				strFfv += "<col width='100%'>";
				//strFfv += "<col width='20%'>";
				strFfv += "<col width='15px'>";
				strFfv += "</colgroup>";
				strFfv += "<tr style='border:none;'>";
				strFfv += "<th class='mini-table-th'>글씨체 목록</th>";
				//strFfv += "<th class='mini-table-th'>Delete</th>";
				strFfv += "<th class='mini-table-th'>&nbsp;&nbsp;&nbsp;&nbsp;</th>";
				strFfv += "</tr></table>";

				strFfv += "<div id='ffvArea' style='width:;height:107px;overflow-y:scroll; border-bottom:2px solid #888888;'>";
				strFfv += "<table style='width:100%;'>";
				strFfv += "<colgroup>";
				// strFfv += "<col width='90%'>";
				// strFfv += "<col width='10%'>";				
				strFfv += "</colroup>";
				
				var ffvArr = ffvObj["data"].replace(/(\s*)/g, "").split(",");				
				if(ffvObj["data"] === ""){
					
					ffvArr = [];
				}
				
				for(var i=0; i<ffvArr.length; i++){
					
					// 하위 DOM 생성 ayoung
					strFfv += "<tr class='mini-table-tr'>";
					strFfv += "<td style='padding-top:2px; text-align:center; width:24px;'>";
					//strFfv += "<button id='" + ffvObj["xid"] + "-ffv-" + i + "-btn'class='btnDelete'>X</button>";
					strFfv += "<span id='" + ffvObj["xid"] + "-ffv-" + i + "-btn'class='btnDelete'>";
					strFfv += '<img src="./images/delete.png" />';
					strFfv += '</span>';
					strFfv += "</td>";
					strFfv += "<td style='padding:5px; cursor:pointer; width:278px;'>" + ffvArr[i] + "</td>";
					strFfv += "</tr>";
				}

				strFfv += "</table></div>";
				strFfv += "<div style='margin-top:5px; text-align:right;'><span style='font-size:11px;'>(Drag & Drop 으로 순서 정렬이 가능합니다.)</span></div>";
				strFfv += "</div>";
				strFfv += "</td>";
				
				$("#xmlArea table").find("#"+ffvObj["xid"]).find("td:nth-child(3)").append(strFfv);

						
				// del 처리
				for(var i=0; i<ffvArr.length; i++){
					
					// xid는 continue 처리
					if(ffvArr[i] === "xid") {
						continue;	
					}
					
					$("#xmlArea table").find("#"+ffvObj["xid"] + "-ffv-" + i +"-btn").click(function(e){
						
						if(confirm("삭제하시겠습니까?")) {
							
							$(this).parent().parent().remove();	
						}
					});
				}
								
				// add 처리
				$("#xmlArea table").find("#addFfvContent").click(function(e){
					
					var replaceKey = $("#xmlArea table").find("#ffvKey").val();
					
					if(replaceKey === "") {
						
						alert("key 값을 입력하세요");
						return false;
					}
					
					var idx = 0;
					if($("#xmlArea table #ffvArea").find("tr").length === 0){
						
						idx = 0;
						
						if($("#xmlArea #ffvArea table tbody").length === 0){
							
							$("#xmlArea #ffvArea table").append('<tbody id="ffv_sortable" class="ui-sortable"></tbody>');
						}						
					} else {
						
						idx = Number($("#xmlArea table #ffvArea").find("tr:last").find("span").attr("id").split("-")[2])+1;						
					}
					
					//var idx = Number($("#xmlArea table #ffvArea").find("tr:last").find("span").attr("id").split("-")[2])+1;
					var strHTML = "<tr class='mini-table-tr ui-sortable-handle'>";
					strHTML += "<td style='padding-top:2px; text-align:center; width:24px;'>";
					strHTML += "<span id='" + ffvObj["xid"] + "-ffv-" + idx + "-btn'class='btnDelete''><img src='./images/delete.png'/></span>";					
					strHTML += "</td>";
					strHTML += "<td style='padding:5px; cursor:pointer; width:278px;'>" + replaceKey + "</td>";
					strHTML += "</tr>";
					
					$("#xmlArea #ffvArea table tbody").append(strHTML);					// 행추가
					$("#ffvArea").scrollTop($("#ffvArea table").height());			// 스크롤 하단 이동
					
					// add 된 행을 del 처리
					$("#xmlArea #ffvArea table tbody").find("#" + ffvObj["xid"] + "-ffv-" + idx + "-btn").click(function(e){
						
						if(confirm("삭제하시겠습니까?")) {
							
							$(this).parent().parent().remove();	
						}
					});
				});

				// mini-table 드래그로 순서 정렬
				// .aykim

				$("#ffvArea").find('tbody').attr('id', 'ffv_sortable');
				$("#ffv_sortable").sortable({
					axis: "y", 				// 세로로만 움직일 수 있음
					cursor: "move",			// 정렬하는 동안 표시되는 커서 설정
					cursorAt: { top:15 },	// 커서가 항상 같은 위치에서 끌리는 것처럼 보입니다.
					//grid: [0, 25],			// 정렬 요소 또는 도우미를 모눈 [x,y]
					opacity: 0.5,			// 정렬하는 동안 도우미의 불투명도
					revert: 70,				// 정렬 가능한 항목을 부드러운 애니메이션을 사용하여 새 위치로 되돌릴지 여부
					tolerance: "pointer",	// 이동중인 항목이 다른 항목 위로 마우스를 가져갈지 여부
					over: function(event, ui) {
						
						// drag 하면 이동중인 항목에 border 를 준다.
						if(event.handleObj.type === "mousedown") {
							
							if(event.srcElement.nodeName === 'TD') {
								
								event.srcElement.parentElement.id = 'sortable_this';
								$("#sortable_this").css('border', '1px solid #cccccc');
							}
						}
					},
					stop: function(event, ui) {
						
						// drop 하면 border 를 제거한다.
						if(event.handleObj.type === 'mouseup') {

							$('#sortable_this').css('border', 'none');
							$('#sortable_this').removeAttr('id');
						}
					}
				});
			
				
				// FontSizeValue 데이터 노드 추가
				var strFsv = "";
				strFsv += "<div style='margin-top:15px; width:90%; display:inline-block; text-align:center;'>";
				strFsv += "<table style='width:;'>";
				strFsv += "<colgroup>";
				strFsv += "<col width='100%'>";
				//strFsv += "<col width='20%'>";			
				strFsv += "<col width='15px'>";				
				strFsv += "</colgroup>";
				strFsv += "<tr>";
				strFsv += "<th class='mini-table-th'>글자크기 목록</th>";
				//strFsv += "<th class='mini-table-th'>Delete</th>";
				strFsv += "<th class='mini-table-th'>&nbsp;&nbsp;&nbsp;&nbsp;</th>";
				strFsv += "</tr></table>";
				strFsv += "<div id='fsvArea' style='width:;height:107px;overflow-y:scroll; border-bottom:2px solid #797979;'>";
				strFsv += "<table style='width:100%;'>";
				strFsv += "<colgroup>";
				// strFsv += "<col width='90%'>";
				// strFsv += "<col width='10%'>";				
				strFsv += "</colgroup>";
				
				var fsvArr = fsvObj["data"].replace(/(\s*)/g, "").split(",");
				if(fsvObj["data"] === ""){
					
					fsvArr = [];
				}
				
				for(var i=0; i<fsvArr.length; i++){
					
					// 하위 DOM 생성
					strFsv += "<tr>";
					strFsv += "<td style='padding-top:2px; text-align:center; width:24px;'>";
					//strFsv += "<button id='" + fsvObj["xid"] + "-fsv-" + i + "-btn'class='btnDelete'>X</button>";
					strFsv += "<span id='" + fsvObj["xid"] + "-fsv-" + i + "-btn'class='btnDelete'>";
					strFsv += "<img src='./images/delete.png' />";
					strFsv += "</span>";
					strFsv += "</td>";
					strFsv += "<td style='padding:5px; width:278px;'>" + fsvArr[i] + "</td>";
					strFsv += "</tr>";
				}
				strFsv += "</table></div>";
				strFsv += "<div style='margin-top:5px; text-align:right;'><span style='font-size:11px;'>(Drag & Drop 으로 순서 정렬이 가능합니다.)</span></div>";
				strFsv += "</div></td>";

				$("#xmlArea table").find("#"+fsvObj["xid"]).find("td:nth-child(3)").append(strFsv);
				
				// del 처리
				for(var i=0; i<fsvArr.length; i++){
					
					// xid는 continue 처리
					if(fsvArr[i] === "xid") {
						
						continue;	
					}
					
					$("#xmlArea table").find("#"+fsvObj["xid"] + "-fsv-" + i +"-btn").click(function(e){
						
						if(confirm("삭제하시겠습니까?")) {
							
							$(this).parent().parent().remove();	
						}
					});
				}
								
				// add 처리
				$("#xmlArea table").find("#addFsvContent").click(function(e){
					
					var replaceKey = $("#xmlArea table").find("#fsvKey").val();
					
					if(replaceKey === "") {
						
						alert("key 값을 입력하세요");
						return false;
					}
					
					var idx = 0;
					if($("#xmlArea table #fsvArea").find("tr").length === 0){
						
						idx = 0;
						
						if($("#xmlArea #fsvArea table tbody").length === 0){
							
							$("#xmlArea #fsvArea table").append('<tbody id="fsv_sortable" class="ui-sortable"></tbody>');
						}						
					} else {
						
						idx = Number($("#xmlArea table #fsvArea").find("tr:last").find("span").attr("id").split("-")[2])+1;						
					}
					
					//var idx = Number($("#xmlArea table #fsvArea").find("tr:last").find("span").attr("id").split("-")[2])+1;
					var strHTML = "<tr class='ui-sortable-handle'>";
					strHTML += "<td style='padding-top:2px; text-align:center; width:24px;'>";
					strHTML += "<span id='" + fsvObj["xid"] + "-fsv-" + idx + "-btn'class='btnDelete'><img src='./images/delete.png'/></span>";
					strHTML += "</td>";
					strHTML += "<td style='padding:5px; width:278px;'>" + replaceKey + "</td>";
					strHTML += "</tr>";
					
					$("#xmlArea #fsvArea table tbody").append(strHTML);					// 행추가
					$("#fsvArea").scrollTop($("#fsvArea table").height());			// 스크롤 하단 이동
					
					// add 된 행을 del 처리
					$("#xmlArea #fsvArea table tbody").find("#" + fsvObj["xid"] + "-fsv-" + idx + "-btn").click(function(e){
						
						if(confirm("삭제하시겠습니까?")) {
						
							$(this).parent().parent().remove();	
						}
					});
				});

				// mini-table 드래그로 순서 정렬
				// .aykim

				$("#fsvArea").find('tbody').attr('id', 'fsv_sortable');
				$("#fsv_sortable").sortable({
					axis: "y", 				// 세로로만 움직일 수 있음
					cursor: "move",			// 정렬하는 동안 표시되는 커서 설정
					cursorAt: { top:15 },	// 커서가 항상 같은 위치에서 끌리는 것처럼 보입니다.
					//grid: [0, 25],			// 정렬 요소 또는 도우미를 모눈 [x,y]
					opacity: 0.5,			// 정렬하는 동안 도우미의 불투명도
					revert: 70,				// 정렬 가능한 항목을 부드러운 애니메이션을 사용하여 새 위치로 되돌릴지 여부
					tolerance: "pointer",	// 이동중인 항목이 다른 항목 위로 마우스를 가져갈지 여부
					over: function(event, ui) {
						
						// drag 하면 이동중인 항목에 border 를 준다.
						if(event.handleObj.type === "mousedown") {
							
							if(event.srcElement.nodeName === 'TD') {
								
								event.srcElement.parentElement.id = 'sortable_this';
								$("#sortable_this").css('border', '1px solid #cccccc');
							}
						}
					},
					stop: function(event, ui) {
						
						// drop 하면 border 를 제거한다.
						if(event.handleObj.type === 'mouseup') {

							$('#sortable_this').css('border', 'none');
							$('#sortable_this').removeAttr('id');
						}
					}
				});

				
				// LineHeightValue 데이터 노드 추가
				var strLhv = "";
				strLhv += "<div style='margin-top:15px; width:90%; display:inline-block; text-align:center;'>";
				strLhv += "<table style='width:;'>";
				strLhv += "<colgroup>";
				strLhv += "<col width='100%'>";
				//strLhv += "<col width='20%'>";		
				strLhv += "<col width='15px'>";
				strLhv += "</colgroup>";
				strLhv += "<tr>";
				strLhv += "<th class='mini-table-th'>줄간격 목록</th>";
				//strLhv += "<th class='mini-table-th'>Delete</th>";
				strLhv += "<th class='mini-table-th'>&nbsp;&nbsp;&nbsp;&nbsp;</th>";
				strLhv += "</tr></table>";
				strLhv += "<div id='lhvArea' style='width:;height:107px;overflow-y:scroll; border-bottom:2px solid #797979;'>";
				strLhv += "<table style='width:100%;'>";
				strLhv += "<colgroup>";
				// strLhv += "<col width='90%'>";
				// strLhv += "<col width='10%'>";				
				strLhv += "</colgroup>";
				
				var lhvArr = lhvObj["data"].replace(/(\s*)/g, "").split(",");
				if(lhvObj["data"] === ""){
					
					lhvArr = [];
				}
				
				for(var i=0; i<lhvArr.length; i++){
					
					// 하위 DOM 생성
					strLhv += "<tr>";
					strLhv += "<td style='padding-top:2px; text-align:center; width:24px;'>";
					strLhv += "<span id='" + lhvObj["xid"] + "-lhv-" + i + "-btn'class='btnDelete'>";
					strLhv += "<img src='./images/delete.png' />";
					strLhv += "</span>";
					//strLhv += "<button id='" + lhvObj["xid"] + "-lhv-" + i + "-btn'class='btnDelete'>X</button>";
					strLhv += "</td>";
					strLhv += "<td style='padding:5px; width:278px;'>" + lhvArr[i] + "</td>";
					strLhv += "</tr>";
				}
				
				strLhv += "</table></div>";
				strLhv += "<div style='margin-top:5px; text-align:right;'><span style='font-size:11px;'>(Drag & Drop 으로 순서 정렬이 가능합니다.)</span></div>";
				strLhv += "</div></td>";
				
				$("#xmlArea table").find("#"+lhvObj["xid"]).find("td:nth-child(3)").append(strLhv);
				
				// del 처리
				for(var i=0; i<lhvArr.length; i++){
					
					// xid는 continue 처리
					if(lhvArr[i] === "xid") {
						
						continue;	
					}
					
					$("#xmlArea table").find("#"+lhvObj["xid"] + "-lhv-" + i +"-btn").click(function(e){
						
						if(confirm("삭제하시겠습니까?")) {
							
							$(this).parent().parent().remove();	
						}
					});
				}
								
				// add 처리
				$("#xmlArea table").find("#addLhvContent").click(function(e){
					
					var replaceKey = $("#xmlArea table").find("#lhvKey").val();
					
					if(replaceKey === "") {
						
						alert("key 값을 입력하세요");
						return false;
					}
					
					var idx = 0;
					if($("#xmlArea table #lhvArea").find("tr").length === 0){
						
						idx = 0;
						
						if($("#xmlArea #lhvArea table tbody").length === 0){
							
							$("#xmlArea #lhvArea table").append('<tbody id="lhv_sortable" class="ui-sortable"></tbody>');
						}						
					} else {
						
						idx = Number($("#xmlArea table #lhvArea").find("tr:last").find("span").attr("id").split("-")[2])+1;						
					}
					
					//var idx = Number($("#xmlArea table #lhvArea").find("tr:last").find("span").attr("id").split("-")[2])+1;
					var strHTML = "<tr class='ui-sortable-handle'>";					
					strHTML += "<td style='padding-top:2px; text-align:center; width:24px;'>";
					strHTML += "<span id='" + lhvObj["xid"] + "-lhv-" + idx + "-btn'class='btnDelete'><img src='./images/delete.png'/></span>";
					strHTML += "</td>";
					strHTML += "<td style='padding:5px; width:278px;'>" + replaceKey + "</td>";
					strHTML += "</tr>";
					
					$("#xmlArea #lhvArea table tbody").append(strHTML);					// 행추가
					$("#lhvArea").scrollTop($("#lhvArea table").height());			// 스크롤 하단 이동
					
					// add 된 행을 del 처리
					$("#xmlArea #lhvArea table tbody").find("#" + lhvObj["xid"] + "-lhv-" + idx + "-btn").click(function(e){
						
						if(confirm("삭제하시겠습니까?")) {
							
							$(this).parent().parent().remove();	
						}
					});
				});

				// mini-table 드래그로 순서 정렬
				// .aykim

				$("#lhvArea").find('tbody').attr('id', 'lhv_sortable');
				$("#lhv_sortable").sortable({
					axis: "y", 				// 세로로만 움직일 수 있음
					cursor: "move",			// 정렬하는 동안 표시되는 커서 설정
					cursorAt: { top:15 },	// 커서가 항상 같은 위치에서 끌리는 것처럼 보입니다.
					//grid: [0, 25],			// 정렬 요소 또는 도우미를 모눈 [x,y]
					opacity: 0.5,			// 정렬하는 동안 도우미의 불투명도
					revert: 70,				// 정렬 가능한 항목을 부드러운 애니메이션을 사용하여 새 위치로 되돌릴지 여부
					tolerance: "pointer",	// 이동중인 항목이 다른 항목 위로 마우스를 가져갈지 여부
					over: function(event, ui) {
						
						// drag 하면 이동중인 항목에 border 를 준다.
						if(event.handleObj.type === "mousedown") {
							
							if(event.srcElement.nodeName === 'TD') {
								
								event.srcElement.parentElement.id = 'sortable_this';
								$("#sortable_this").css('border', '1px solid #cccccc');
							}
						}
					},
					stop: function(event, ui) {
						
						// drop 하면 border 를 제거한다.
						if(event.handleObj.type === 'mouseup') {

							$('#sortable_this').css('border', 'none');
							$('#sortable_this').removeAttr('id');
						}
					}
				});
				
				// LetterSpacingValue 데이터 노드 추가
				var strLsv = "";
				strLsv += "<div style='margin-top:15px; width:90%; display:inline-block; text-align:center;'>";
				strLsv += "<table style='width:;'>";
				strLsv += "<colgroup>";
				strLsv += "<col width='100%'>";
				//strLsv += "<col width='20%'>";	
				strLsv += "<col width='15px'>";				
				strLsv += "</colgroup>";
				strLsv += "<tr>";
				strLsv += "<th class='mini-table-th'>글자간격 목록</th>";
				//strLsv += "<th class='mini-table-th'>Delete</th>";
				strLsv += "<th class='mini-table-th'>&nbsp;&nbsp;&nbsp;&nbsp;</th>";
				strLsv += "</tr></table>";
				strLsv += "<div id='lsvArea' style='width:;height:107px;overflow-y:scroll;border-bottom:2px solid #797979;'>";
				strLsv += "<table style='width:100%;'>";
				strLsv += "<colgroup>";
				// strLsv += "<col width='90%'>";
				// strLsv += "<col width='10%'>";				
				strLsv += "</colgroup>";
				
				var lsvArr = lsvObj["data"].replace(/(\s*)/g, "").split(",");
				if(lsvObj["data"] === ""){
					
					lsvArr = [];
				}
				
				for(var i=0; i<lsvArr.length; i++){
					
					// 하위 DOM 생성
					strLsv += "<tr>";
					strLsv += "<td style='padding-top:2px; text-align:center; width:24px;'>";
					strLsv += "<span id='" + lsvObj["xid"] + "-lsv-" + i + "-btn'class='btnDelete'>";
					strLsv += "<img src='./images/delete.png' />";
					strLsv += "</span>";
					//strLsv += "<button id='" + lsvObj["xid"] + "-lsv-" + i + "-btn'class='btnDelete'>X</button>";
					strLsv += "</td>";
					strLsv += "<td style='padding:5px; width:278px;'>" + lsvArr[i] + "</td>";
					strLsv += "</tr>";
				}
				
				strLsv += "</table></div>";
				strLsv += "<div style='margin-top:5px; text-align:right;'><span style='font-size:11px;'>(Drag & Drop 으로 순서 정렬이 가능합니다.)</span></div>";
				strLsv += "</div></td>";
				
				$("#xmlArea table").find("#"+lsvObj["xid"]).find("td:nth-child(3)").append(strLsv);
				
				// del 처리
				for(var i=0; i<lsvArr.length; i++){
					
					// xid는 continue 처리
					if(lsvArr[i] === "xid") {
						
						continue;	
					}
					
					$("#xmlArea table").find("#"+lsvObj["xid"] + "-lsv-" + i +"-btn").click(function(e){
						
						if(confirm("삭제하시겠습니까?")) {
							
							$(this).parent().parent().remove();	
						}
					});
				}
								
				// add 처리
				$("#xmlArea table").find("#addLsvContent").click(function(e){
					var replaceKey = $("#xmlArea table").find("#lsvKey").val();
					
					if(replaceKey === "") {
						
						alert("key 값을 입력하세요");
						return false;
					}
					
					var idx = 0;
					if($("#xmlArea table #lsvArea").find("tr").length === 0){
						
						idx = 0;
						
						if($("#xmlArea #lsvArea table tbody").length === 0){
							
							$("#xmlArea #lsvArea table").append('<tbody id="lsv_sortable" class="ui-sortable"></tbody>');
						}						
					} else {
						
						idx = Number($("#xmlArea table #lsvArea").find("tr:last").find("span").attr("id").split("-")[2])+1;						
					}
					
					//var idx = Number($("#xmlArea table #lsvArea").find("tr:last").find("span").attr("id").split("-")[2])+1;
					var strHTML = "<tr class='ui-sortable-handle'>";					
					strHTML += "<td style='padding-top:2px; text-align:center; width:24px;'>";
					strHTML += "<span id='" + lsvObj["xid"] + "-lsv-" + idx + "-btn'class='btnDelete'><img src='./images/delete.png'/></span>";
					strHTML += "</td>";
					strHTML += "<td style='padding:5px; width:278px;'>" + replaceKey + "</td>";
					strHTML += "</tr>";
					
					$("#xmlArea #lsvArea table tbody").append(strHTML);					// 행추가
					$("#lsvArea").scrollTop($("#lsvArea table").height());			// 스크롤 하단 이동
					
					// add 된 행을 del 처리
					$("#xmlArea #lsvArea table tbody").find("#" + lsvObj["xid"] + "-lsv-" + idx + "-btn").click(function(e){
						
						if(confirm("삭제하시겠습니까?")) {
							
							$(this).parent().parent().remove();	
						}
					});
				});

				// mini-table 드래그로 순서 정렬
				// .aykim

				$("#lsvArea").find('tbody').attr('id', 'lsv_sortable');
				$("#lsv_sortable").sortable({
					axis: "y", 				// 세로로만 움직일 수 있음
					cursor: "move",			// 정렬하는 동안 표시되는 커서 설정
					cursorAt: { top:15 },	// 커서가 항상 같은 위치에서 끌리는 것처럼 보입니다.
					//grid: [0, 25],			// 정렬 요소 또는 도우미를 모눈 [x,y]
					opacity: 0.5,			// 정렬하는 동안 도우미의 불투명도
					revert: 70,				// 정렬 가능한 항목을 부드러운 애니메이션을 사용하여 새 위치로 되돌릴지 여부
					tolerance: "pointer",	// 이동중인 항목이 다른 항목 위로 마우스를 가져갈지 여부
					over: function(event, ui) {
						
						// drag 하면 이동중인 항목에 border 를 준다.
						if(event.handleObj.type === "mousedown") {
							
							if(event.srcElement.nodeName === 'TD') {
								
								event.srcElement.parentElement.id = 'sortable_this';
								$("#sortable_this").css('border', '1px solid #cccccc');
							}
						}
					},
					stop: function(event, ui) {
						
						// drop 하면 border 를 제거한다.
						if(event.handleObj.type === 'mouseup') {

							$('#sortable_this').css('border', 'none');
							$('#sortable_this').removeAttr('id');
						}
					}
				});
				
				// ExceptionTagType 데이터 노드 추가
				var strEtt = "";
				strEtt += "<div style='margin-top:15px; width:90%; display:inline-block; text-align:center;'>";
				strEtt += "<table style='width:;'>";
				strEtt += "<colgroup>";
				strEtt += "<col width='100%'>";
				//strEtt += "<col width='20%'>";			
				strEtt += "<col width='15px'>";				
				strEtt += "</colgroup>";
				strEtt += "<tr>";
				strEtt += "<th class='mini-table-th'>nodeName</th>";
				//strEtt += "<th class='mini-table-th'>Delete</th>";
				strEtt += "<th class='mini-table-th'>&nbsp;&nbsp;&nbsp;&nbsp;</th>";
				strEtt += "</tr></table>";
				strEtt += "<div id='ettArea' style='width:;height:107px;overflow-y:scroll;border-bottom:2px solid #797979;'>";
				strEtt += "<table style='width:100%;'>";
				strEtt += "<colgroup>";
				// strEtt += "<col width='90%'>";
				// strEtt += "<col width='10%'>";				
				strEtt += "</colgroup>";
				
				var ettArr = ettObj["data"].replace(/(\s*)/g, "").split(",");
				if(ettObj["data"] === ""){
					
					ettArr = [];
				}
				
				for(var i=0; i<ettArr.length; i++){
					
					// 하위 DOM 생성
					strEtt += "<tr>";
					strEtt += "<td style='padding-top:2px; text-align:center; width:24px;'>";
					strEtt += "<span id='" + ettObj["xid"] + "-ett-" + i + "-btn'class='btnDelete'>";
					strEtt += "<img src='./images/delete.png' />";
					strEtt += "</span>";
					//strEtt += "<button id='" + ettObj["xid"] + "-ett-" + i + "-btn'class='btnDelete'>X</button>";
					strEtt += "</td>";
					strEtt += "<td style='padding:5px; width:278px;'>" + ettArr[i] + "</td>";
					strEtt += "</tr>";
				}
				strEtt += "</table></div></div></td>";
				
				$("#xmlArea table").find("#"+ettObj["xid"]).find("td:nth-child(3)").append(strEtt);
				
				// del 처리
				for(var i=0; i<ettArr.length; i++){
					
					// xid는 continue 처리
					if(ettArr[i] === "xid") {
						
						continue;	
					}
					
					$("#xmlArea table").find("#"+ettObj["xid"] + "-ett-" + i +"-btn").click(function(e){
						
						if(confirm("삭제하시겠습니까?")) {
							
							$(this).parent().parent().remove();	
						}
					});
				}
								
				// add 처리
				$("#xmlArea table").find("#addEttContent").click(function(e){
					
					var replaceKey = $("#xmlArea table").find("#ettKey").val();
					
					if(replaceKey === "") {
						
						alert("key 값을 입력하세요");
						return false;
					}
					
					var idx = 0;
					if($("#xmlArea table #ettArea").find("tr").length === 0){
						
						idx = 0;
						
						if($("#xmlArea #ettArea table tbody").length === 0){
							
							$("#xmlArea #ettArea table").append('<tbody id="ett_sortable" class="ui-sortable"></tbody>');
						}						
					} else {
						
						idx = Number($("#xmlArea table #ettArea").find("tr:last").find("span").attr("id").split("-")[2])+1;						
					}
					
					//var idx = Number($("#xmlArea table #ettArea").find("tr:last").find("span").attr("id").split("-")[2])+1;
					var strHTML = "<tr class='ui-sortable-handle'>";					
					strHTML += "<td style='padding-top:2px; text-align:center; width:24px;'>";
					strHTML += "<span id='" + ettObj["xid"] + "-ett-" + idx + "-btn'class='btnDelete'><img src='./images/delete.png'/></span>";
					strHTML += "</td>";
					strHTML += "<td style='padding:5px; width:278px;'>" + replaceKey + "</td>";
					strHTML += "</tr>";
					
					$("#xmlArea #ettArea table tbody").append(strHTML);					// 행추가
					$("#ettArea").scrollTop($("#ettArea table").height());			// 스크롤 하단 이동
					
					// add 된 행을 del 처리
					$("#xmlArea #ettArea table tbody").find("#" + ettObj["xid"] + "-ett-" + idx + "-btn").click(function(e){
						
						if(confirm("삭제하시겠습니까?")) {
							
							$(this).parent().parent().remove();	
						}
					});
				});
				
				// ReplaceExpression 데이터 노드 추가
				var strFE = "";
				strFE += "<div style='margin-top:15px; width:90%; display:inline-block; text-align:center;'>";
				strFE += "<table style='width:;'>";
				strFE += "<colgroup>";
				strFE += "<col width='45%'>";
				strFE += "<col width='55%'>";
				strFE += "<col width='10px'>";
				strFE += "</colgroup>";
				strFE += "<tr>";
				strFE += "<th class='mini-table-th'>findExpression</th>";
				strFE += "<th class='mini-table-th'>Replace</th>";
				strFE += "<th class='mini-table-th'>&nbsp;&nbsp;&nbsp;&nbsp;</th>";
				strFE += "</tr></table>";
				strFE += "<div id='re2DepthTable' style='width:;height:107px;overflow-y:scroll;border-bottom:2px solid #797979;'>";
				strFE += "<table style='width:100%;'>";

				
				strFE += "<colgroup>";
				strFE += "<col width='10%'>";
				strFE += "<col width='30%'>";
				strFE += "<col width='60%'>";
				strFE += "</colgroup>";
				
				var feKeyArr = Object.keys(feObj);
				if(feKeyArr.length === 0){
					
					feKeyArr = [];
				}
				
				for(var i=0; i<feKeyArr.length; i++){
					
					// xid는 continue 처리
					if(feKeyArr[i] === "xid") {
						
						continue;	
					}
					
					// 하위 DOM 생성
					strFE += "<tr>";
					strFE += "<td style='padding-top:2px; text-align:center;'>";
					strFE += "<span id='" + feObj["xid"] + "-fe-" + i + "-btn'class='btnDelete'>";
					strFE += "<img src='./images/delete.png' />";
					strFE += "</span>";
					//strFE += "<button id='" + feObj["xid"] + "-fe-" + i + "-btn'class='btnDelete'>X</button>
					strFE += "</td>";
					strFE += "<td style='padding:5px;'>" + feKeyArr[i] + "</td>";
					strFE += "<td style='padding-top:3px; text-align: center;'>";
					strFE += "<input type='input' size='18' id='" + feObj["xid"] + "-2-" + i + "' value=\"" + feObj[feKeyArr[i]] + "\">";
					strFE += "</td>";
					strFE += "</tr>";
				}
				strFE += "</table></div></div></td>";
				
				$("#xmlArea table").find("#"+feObj["xid"]).find("td:nth-child(3)").append(strFE);
				
				// del 처리
				for(var i=0; i<feKeyArr.length; i++){
					
					// xid는 continue 처리
					if(feKeyArr[i] === "xid") {
						
						continue;	
					}
					
					$("#xmlArea table").find("#"+feObj["xid"] + "-fe-" + i +"-btn").click(function(e){
						
						if(confirm("삭제하시겠습니까?")) {
							
							$(this).parent().parent().remove();	
						}
					});
				}
								
				// add 처리
				$("#xmlArea table").find("#addRe2DepthTable").click(function(e){
					
					var replaceKey = $("#xmlArea table").find("#replaceKey").val();
					var replaceValue = $("#xmlArea table").find("#replaceValue").val();
					
					if(replaceKey === "") {
						
						alert("key 값을 입력하세요");
						return false;
					}
					else if(replaceValue === "") {
						
						alert("value값을 입력하세요.");
						return false;
					}
					
					var idx = 0;
					if($("#xmlArea table #re2DepthTable").find("tr").length === 0){
						
						idx = 0;
						
						if($("#xmlArea #re2DepthTable table tbody").length === 0){
							
							$("#xmlArea #re2DepthTable table").append('<tbody></tbody>');
						}						
					} else {
						
						idx = Number($("#xmlArea table #re2DepthTable").find("tr:last").find("span").attr("id").split("-")[2])+1;						
					}
					
					// ayoung
					//var idx = $("#xmlArea table #re2DepthTable tr").length;
					//var idx = Number($("#xmlArea table #re2DepthTable").find("tr:last").find("span").attr("id").split("-")[2])+1;
					var strHTML = "<tr>";					
					strHTML += "<td style='padding-top:2px; text-align:center;'><span id='" + feObj["xid"] + "-fe-" + idx + "-btn'class='btnDelete'><img src='./images/delete.png'/></span></td>";
					strHTML += "<td style='padding:5px;'>" + replaceKey + "</td>";
					strHTML += "<td style='padding-top:3px; text-align:center;'>";
					strHTML += "<input type='input' size='18' id='"+ feObj["xid"] + "-fe-" + idx +"' value='"+replaceValue+"'/>";					
					strHTML += "</td>";					
					strHTML += "</tr>";
					
					$("#xmlArea #re2DepthTable table tbody").append(strHTML);					// 행추가
					$("#re2DepthTable").scrollTop($("#re2DepthTable table").height());			// 스크롤 하단 이동
					
					// add 된 행을 del 처리
					$("#xmlArea #re2DepthTable table tbody").find("#" + feObj["xid"] + "-fe-" + idx + "-btn").click(function(e){
						
						if(confirm("삭제하시겠습니까?")) {
							
							$(this).parent().parent().remove();	
						}
					});
				});

				//ayoung
			},
			error : function(xhr,status,error){
				
				alert("[서버에러] " + setUrl +" 파일 로드 실패하였습니다");
				
				console.log(xhr);
				console.log(status);
				console.log(error);
			}
		});
	}
	
	// X-Free Uploader
	else if (optFlag == "xfuConfig") {
		
		window["xmlJson"] = [];
		var fileExtObj = {};
		var blfeObj = {};
		
		$.get(setUrl, function (configData) {
			
			$(configData).find("xFreeUploaderConfig").children().each(function (idx) {
				
				var $entry = $(this);
				var xmlObj = {};
				
				xmlObj["nodeName"] = $entry[0].nodeName;		// key
				xmlObj["apply"] = $entry.attr("apply");				// apply
				//xmlObj["data"] = $entry[0].textContent;				// value
				xmlObj["data"] = $entry.text();				// value
	
				window["xmlJson"].push(xmlObj);
				
				var strHtml = "";
				strHtml += "<tr id=" + idx + ">";
				// (1) 옵션명 세팅
				strHtml += "<th title='" + userSettingObj["title"][0]["label"] + "'>" + $entry[0].nodeName + "</th>";

				// (2) Apply값 초기세팅
				//strHtml += "<td><input type='input' size='5' id='" + idx + "-1' value=\"" + $entry.attr("apply") + "\"></td>";
				if (xmlObj["apply"] === "true") {
					
					strHtml += "<td title='"+userSettingObj["title"][1]["label"]+"'><select id='" + idx + "-1'><option value='true' selected>true</option><option value='false'>false</option></select></td>";	
				}
				else {
				
					strHtml += "<td title='"+userSettingObj["title"][1]["label"]+"'><select id='" + idx + "-1'><option value='true'>true</option><option value='false' selected>false</option></select></td>";	
				}

				// (3) 옵션 내용 세팅  
				// selectMode
				if (xmlObj["nodeName"] === "selectMode"){
					
					if(xmlObj["data"] === "upload") {
					
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"'><select id='" + idx + "-2'><option value='upload' selected>upload</option><option value='download'>download</option><option value='hybrid'>hybrid</option></select></td>";	
					}
					else if(xmlObj["data"] === "download") {
						
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"'><select id='" + idx + "-2'><option value='upload'>upload</option><option value='download' selected>download</option><option value='hybrid'>hybrid</option></select></td>";	
					}
					else {
					
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"'><select id='" + idx + "-2'><option value='upload'>upload</option><option value='download'>download</option><option value='hybrid' selected>hybrid</option></select></td>";	
					}
				}
				
				// listStyle
				else if (xmlObj["nodeName"] === "listStyle"){
					
					if(xmlObj["data"] === "list") {
						
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"'><select id='" + idx + "-2'><option value='list' selected>list</option><option value='icon'>icon</option></select></td>";	
					}
					else {
						
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"'><select id='" + idx + "-2'><option value='list'>list</option><option value='icon' selected>icon</option></select></td>";	
					}
				}
				
				// thumbnail
				else if (xmlObj["nodeName"] === "thumbnail"){
					
					if(xmlObj["data"] === "true") {
					
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"'><select id='" + idx + "-2'><option value='true' selected>true</option><option value='false'>false</option></select></td>";	
					}
					else {
					
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"'><select id='" + idx + "-2'><option value='true'>true</option><option value='false' selected>false</option></select></td>";	
					}
				}
				
				// dropMsg / readyMsg / fileExt / blackListFileExt
				else if (xmlObj["nodeName"] === "dropMsg" || xmlObj["nodeName"] === "readyMsg") {
					
					strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"'><textarea cols=\"50\" rows=\"3\" id='" + idx + "-2' >" + xmlObj["data"] + "</textarea></td>";
				}
				
				// btnPos
				else if (xmlObj["nodeName"] === "btnPos") {
					
					if(xmlObj["data"] === "up") {
						
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"'><select id='" + idx + "-2'><option value='up' selected>up</option><option value='down'>down</option></select></td>";	
					}
					else {
						
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"'><select id='" + idx + "-2'><option value='up'>up</option><option value='down' selected>down</option></select></td>";	
					}
				}
				
				// serverType
				else if (xmlObj["nodeName"] === "serverType"){
					
					if(xmlObj["data"] === "jsp") {
						
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"'><select id='" + idx + "-2'><option value='jsp' selected>jsp</option><option value='php'>php</option><option value='aspx'>aspx</option></select></td>";	
					}
					else if(xmlObj["data"] === "php") {
						
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"'><select id='" + idx + "-2'><option value='jsp'>jsp</option><option value='php' selected>php</option><option value='aspx'>aspx</option></select></td>";	
					}
					else {
						
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"'><select id='" + idx + "-2'><option value='jsp'>jsp</option><option value='php'>php</option><option value='aspx' selected>aspx</option></select></td>";	
					}
				}
				
				// Language
				else if (xmlObj["nodeName"] === "Language"){
					
					if(xmlObj["data"] === "korean") {
						
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"'><select id='" + idx + "-2'><option value='korean' selected>korean</option><option value='english'>english</option><option value='chinese_s'>chinese_s</option><option value='chinese_t'>chinese_t</option><option value='japanese'>japanese</option></select></td>";	
					}
					
					else if(xmlObj["data"] === "english") {
						
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"'><select id='" + idx + "-2'><option value='korean'>korean</option><option value='english' selected>english</option><option value='chinese_s'>chinese_s</option><option value='chinese_t'>chinese_t</option><option value='japanese'>japanese</option></select></td>";	
					}
					
					else if(xmlObj["data"] === "chinese_s") {
						
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"'><select id='" + idx + "-2'><option value='korean'>korean</option><option value='english'>english</option><option value='chinese_s' selected>chinese_s</option><option value='chinese_t'>chinese_t</option><option value='japanese'>japanese</option></select></td>";	
					}
					
					else if(xmlObj["data"] === "chinese_t") {
						
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"'><select id='" + idx + "-2'><option value='korean'>korean</option><option value='english'>english</option><option value='chinese_s'>chinese_s</option><option value='chinese_t' selected>chinese_t</option><option value='japanese'>japanese</option></select></td>";	
					}
					
					else {
						
						strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"'><select id='" + idx + "-2'><option value='korean'>korean</option><option value='english'>english</option><option value='chinese_s'>chinese_s</option><option value='chinese_t'>chinese_t</option><option value='japanese' selected>japanese</option></select></td>";	
					}
				}
				else if (xmlObj["nodeName"] === "bgColor" || xmlObj["nodeName"] === "dropMsgColor" || 
				xmlObj["nodeName"] === "fontColor" || xmlObj["nodeName"] === "proBarColor" || 
				xmlObj["nodeName"] === "lineColor" || xmlObj["nodeName"] === "highlightColor"){
					
					strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"'><input type='input' style='width:90%' colorid='"+xmlObj["nodeName"]+"' id='" + idx + "-2' value=\"" + xmlObj["data"] + "\"></td>";
				}
				
				// fileExt
				else if (xmlObj["nodeName"] === "fileExt"){
					
					strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"'>";
					//strHtml += "<textarea cols=\"50\" rows=\"3\" id='" + idx + "-2' >" + xmlObj["data"] + "</textarea>";
					strHtml += "<div style=\"text-align:left\">";
					strHtml += "<label>항목 추가 </label><input type=\"text\" class='np' size='10' id=\"fileExtKey\">";
					strHtml += "<button type=\"button\" id=\"addfileExtContent\" class=\"addRowBtn\">추가</button></div>";
					strHtml += "</td>";	
					
					// 마크업 생성 후처리 작업시 DOM생성을 위한 데이터 담기
					fileExtObj["data"] = xmlObj["data"].replace(/(\s*)/g, "");
					fileExtObj["xid"] = idx;
				}
				
				// blackListFileExt
				else if (xmlObj["nodeName"] === "blackListFileExt"){					
				
					strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"'>";
					//strHtml += "<textarea cols=\"50\" rows=\"3\" id='" + idx + "-2' >" + xmlObj["data"] + "</textarea>";
					strHtml += "<div style=\"text-align:left\">";
					strHtml += "<label>항목 추가 </label><input type=\"text\" class='np' size='10' id=\"blfeKey\">";
					strHtml += "<button type=\"button\" id=\"addBlfeContent\" class=\"addRowBtn\">추가</button></div>";
					strHtml += "</td>";	
					
					// 마크업 생성 후처리 작업시 DOM생성을 위한 데이터 담기
					blfeObj["data"] = xmlObj["data"].replace(/(\s*)/g, "");
					blfeObj["xid"] = idx;
				}
				
				else{
					
					strHtml += "<td title='"+userSettingObj["title"][2]["label"]+"'><input type='input' style='width:90%' id='" + idx + "-2' value=\"" + xmlObj["data"] + "\"></td>";
				}
				
				// (4) 주석 설명
				strHtml += "<td title='"+userSettingObj["title"][3]["label"]+"' class=\"remark-pnl\">" + printRemark(xmlObj["nodeName"], "xfuConfig") + "</td>";

				strHtml += "</tr>";

				$("#xmlArea table").append(strHtml).find("input[type=text],select,textarea").not(".np").css("width", "90%");
				
				// 콜백처리
				// 색상 처리하는 부분 : bgColor / dropMsgColor / fontColor / proBarColor / lineColor / highlightColor
				if (xmlObj["nodeName"] === "bgColor" || xmlObj["nodeName"] === "dropMsgColor" || 
				xmlObj["nodeName"] === "fontColor" || xmlObj["nodeName"] === "proBarColor" || 
				xmlObj["nodeName"] === "lineColor" || xmlObj["nodeName"] === "highlightColor"){
					
					// 색상코드표 직접 입력시 배경색상 처리
					$("#xmlArea table").find("[colorid="+xmlObj["nodeName"]+"]").change(function(e){
						
						$(this).parent().css("background-color", $(this).val());
					});
					
					// XML로드시 색상코드표 정보에 따른 색상처리
					$("#xmlArea table").find("[colorid="+xmlObj["nodeName"]+"]").parent().css("background-color", $("#xmlArea table").find("[colorid="+xmlObj["nodeName"]+"]").val());
					
					// 포커스 발생시
					$("#xmlArea table").find("[colorid="+xmlObj["nodeName"]+"]").focus(function(e){
						
						xfuColorID = xmlObj["nodeName"];
						$("#perspective").find("#color").val($(this).val());
						
						$("#perspective").css({
							display : "block",
							position : "absolute",
							top : $(this).offset().top + 20,
							left : $(this).offset().left
						});
						
						xfuColor.setColor($(this).val());
					});
				}
				
				$("#emptyArea").hide();
				$("body").css("cursor", "auto");
			});
			
			// 콜백처리		
			// fileExt
			var strFE = "";
			strFE += "<table style='width:100%;'>";
			strFE += "<colgroup>";
			strFE += "<col width='70%'>";
			strFE += "<col width='30%'>";			
			strFE += "<col width='15px'>";				
			strFE += "</colgroup>";
			strFE += "<tr>";
			strFE += "<th class='mini-table-th'>확장자 목록</th>";
			strFE += "<th class='mini-table-th'>Delete</th>";
			strFE += "<th class='mini-table-th'>&nbsp;&nbsp;&nbsp;&nbsp;</th>";
			strFE += "</tr></table>";
			strFE += "<div id='fileExtArea' style='width:100%;height:150px;overflow-y:scroll;'>";
			strFE += "<table style='width:100%;'>";
			strFE += "<colgroup>";
			strFE += "<col width='70%'>";
			strFE += "<col width='30%'>";				
			strFE += "</colgroup>";
			
			var fileExtArr = fileExtObj["data"].replace(/(\s*)/g, "").split(",");
			if(fileExtObj["data"] === ""){
				
				fileExtArr = [];
			}
			
			for(var i=0; i<fileExtArr.length; i++){
				
				// 하위 DOM 생성
				strFE += "<tr>";
				strFE += "<th>" + fileExtArr[i] + "</th>";
				strFE += "<td>";
				strFE += "<button id='" + fileExtObj["xid"] + "-fileExt-" + i + "-btn'class='btnDelete'>X</button>";
				strFE += "</td>";
				strFE += "</tr>";
			}
			strFE += "</table></div></td>";
			
			$("#xmlArea table").find("#"+fileExtObj["xid"]).find("td:nth-child(3)").append(strFE);
			
			// del 처리
			for(var i=0; i<fileExtArr.length; i++){
				
				// xid는 continue 처리
				if(fileExtArr[i] === "xid") {
					
					continue;	
				}
				
				$("#xmlArea table").find("#"+fileExtObj["xid"] + "-fileExt-" + i +"-btn").click(function(e){
					
					if(confirm("삭제하시겠습니까?")) {
						
						$(this).parent().parent().remove();	
					}
				});
			}
							
			// add 처리
			$("#xmlArea table").find("#addfileExtContent").click(function(e){
				
				var replaceKey = $("#xmlArea table").find("#fileExtKey").val();
				
				if(replaceKey === "") {
					
					alert("key 값을 입력하세요");
					return false;
				}
				
				var idx = 0;
				if($("#xmlArea table #fileExtArea").find("tr").length === 0){
					
					idx = 0;
					
					if($("#xmlArea #fileExtArea table tbody").length === 0){
						
						$("#xmlArea #fileExtArea table").append('<tbody id="lhv_sortable" class="ui-sortable"></tbody>');
					}						
				} else {
					
					idx = Number($("#xmlArea table #fileExtArea").find("tr:last").find("span").attr("id").split("-")[2])+1;						
				}
				
				//var idx = Number($("#xmlArea table #fileExtArea").find("tr:last").find("button").attr("id").split("-")[2])+1;
				var strHTML = "<tr>";
				strHTML += "<th>" + replaceKey + "</th>";
				strHTML += "<td>";
				strHTML += "<button id='" + fileExtObj["xid"] + "-fileExt-" + idx + "-btn'class='btnDelete'>X</button>";
				strHTML += "</td>";
				strHTML += "</tr>";
				
				$("#xmlArea #fileExtArea table tbody").append(strHTML);					// 행추가
				$("#fileExtArea").scrollTop($("#fileExtArea table").height());			// 스크롤 하단 이동
				
				// add 된 행을 del 처리
				$("#xmlArea #fileExtArea table tbody").find("#" + fileExtObj["xid"] + "-fileExt-" + idx + "-btn").click(function(e){
					
					if(confirm("삭제하시겠습니까?")) {
						
						$(this).parent().parent().remove();	
					}
				});
			});		

			// blackListFileExt
			var strBlfe = "";
			strBlfe += "<table style='width:100%;'>";
			strBlfe += "<colgroup>";
			strBlfe += "<col width='70%'>";
			strBlfe += "<col width='30%'>";			
			strBlfe += "<col width='15px'>";				
			strBlfe += "</colgroup>";
			strBlfe += "<tr>";
			strBlfe += "<th class='mini-table-th'>확장자 목록</th>";
			strBlfe += "<th class='mini-table-th'>Delete</th>";
			strBlfe += "<th class='mini-table-th'>&nbsp;&nbsp;&nbsp;&nbsp;</th>";
			strBlfe += "</tr></table>";
			strBlfe += "<div id='blackFileExtArea' style='width:100%;height:150px;overflow-y:scroll;'>";
			strBlfe += "<table style='width:100%;'>";
			strBlfe += "<colgroup>";
			strBlfe += "<col width='70%'>";
			strBlfe += "<col width='30%'>";				
			strBlfe += "</colgroup>";
			
			var blackFileExtArr = blfeObj["data"].replace(/(\s*)/g, "").split(",");
			if(blfeObj["data"] === ""){
				
				blackFileExtArr = [];
			}
			
			for(var i=0; i<blackFileExtArr.length; i++){
				
				// 하위 DOM 생성
				strBlfe += "<tr>";
				strBlfe += "<th>" + blackFileExtArr[i] + "</th>";
				strBlfe += "<td>";
				strBlfe += "<button id='" + blfeObj["xid"] + "-blackFileExt-" + i + "-btn'class='btnDelete'>X</button>";
				strBlfe += "</td>";
				strBlfe += "</tr>";
			}
			strBlfe += "</table></div></td>";
			
			$("#xmlArea table").find("#"+blfeObj["xid"]).find("td:nth-child(3)").append(strBlfe);
			
			// del 처리
			for(var i=0; i<blackFileExtArr.length; i++){
				
				// xid는 continue 처리
				if(blackFileExtArr[i] === "xid") {
					
					continue;	
				}
				
				$("#xmlArea table").find("#"+blfeObj["xid"] + "-blackFileExt-" + i +"-btn").click(function(e){
					
					if(confirm("삭제하시겠습니까?")) {
					
						$(this).parent().parent().remove();	
					}
				});
			}
							
			// add 처리
			$("#xmlArea table").find("#addBlfeContent").click(function(e){
				
				var replaceKey = $("#xmlArea table").find("#blfeKey").val();
				
				if(replaceKey === "") {
					
					alert("key 값을 입력하세요");
					return false;
				}
				
				var idx = 0;
				if($("#xmlArea table #blackFileExtArea").find("tr").length === 0){
					
					idx = 0;
					
					if($("#xmlArea #blackFileExtArea table tbody").length === 0){
						
						$("#xmlArea #blackFileExtArea table").append('<tbody id="lhv_sortable" class="ui-sortable"></tbody>');
					}						
				} else {
					
					idx = Number($("#xmlArea table #blackFileExtArea").find("tr:last").find("span").attr("id").split("-")[2])+1;						
				}

				
				//var idx = Number($("#xmlArea table #blackFileExtArea").find("tr:last").find("button").attr("id").split("-")[2])+1;
				var strHTML = "<tr>";
				strHTML += "<th>" + replaceKey + "</th>";
				strHTML += "<td>";
				strHTML += "<button id='" + blfeObj["xid"] + "-blackFileExt-" + idx + "-btn'class='btnDelete'>X</button>";
				strHTML += "</td>";
				strHTML += "</tr>";
				
				$("#xmlArea #blackFileExtArea table tbody").append(strHTML);					// 행추가
				$("#blackFileExtArea").scrollTop($("#blackFileExtArea table").height());			// 스크롤 하단 이동
				
				// add 된 행을 del 처리
				$("#xmlArea #blackFileExtArea table tbody").find("#" + blfeObj["xid"] + "-blackFileExt-" + idx + "-btn").click(function(e){
					
					if(confirm("삭제하시겠습니까?")) {
						
						$(this).parent().parent().remove();	
					}
				});
			});
		});
		
		// 컬러 적용
		$("#btnColorSet").click(function(e){
		
			$("#xmlArea table").find("[colorid="+xfuColorID+"]").val($("#perspective").find("#color").val());			
			$("#xmlArea table").find("[colorid="+xfuColorID+"]").parent().css("background-color", $("#perspective").find("#color").val());
			$("#perspective").hide();
		});
		
		// 컬러 팝업창 닫기
		$("#closeColor").click(function(e){
			
			$("#perspective").hide();
		});
		
	}
	
	else if(optFlag == "xfuLanguage"){
		
		_makeLangTable();
	}
	
	// Active Designer
	else if (optFlag == "ad") {
		
		window["xmlJson"] = [];
		
		$.get(setUrl, function (configData) {
			
			$(configData).find("TWEditor").children().each(function (idx) {
				
				var $entry = $(this);
				var xmlObj = {};
				var strHtml = "";

				xmlObj["nodeName"] = $entry[0].nodeName;		// key
				//xmlObj["data"] = $entry[0].textContent;				// value
				xmlObj["data"] = $entry.text();				// value
				
				window["xmlJson"].push(xmlObj);


				if (xmlObj["nodeName"] === "Priority") {
					
					strHtml += "<tr id=" + idx + ">";
					
					// (1) 옵션명 세팅
					strHtml += "<th title='" + userSettingObj["title"][0]["label"] + "'>" + $entry[0].nodeName + "</th>";
					
					// (2) Apply값 초기세팅
					strHtml += "<td></td>";                        
					
					// (3) 옵션 내용 세팅  
					if (xmlObj["data"] === "true") {
						
						strHtml += "<td><select id='" + idx + "-2'><option value='true' selected>true</option><option value='false'>false</option></select></td>";	
					}
					else {
					
						strHtml += "<td><select id='" + idx + "-2'><option value='true'>true</option><option value='false' selected>false</option></select></td>";	
					}
					
					// (4) 주석 설명
					strHtml += "<td class=\"remark-pnl\">" + printRemark(xmlObj["nodeName"], "ad") + "</td>";
				}
				
				else if (xmlObj["nodeName"] === "Product") {
					
					var arr = [];
					arr.push($($entry[0]).find("HelpURL"));
					arr.push($($entry[0]).find("Destributor"));
					arr.push($($entry[0]).find("Name"));
					
					for (var j = 0; j < arr.length; j++) {
						
						strHtml += "<tr id=" + idx + "-" + j + ">";
						
						// (1) 옵션명 세팅
						strHtml += "<th>" + $entry[0].nodeName + " | " + arr[j][0].nodeName + "</th>";
						
						// (2) Apply값 초기세팅
						strHtml += "<td></td>";
						
						// (3) 옵션 내용 세팅  
						strHtml += "<td><input type='input' size='50' id='" + idx + "-2' value=\"" + arr[j][0].textContent + "\"></td>";
						
						// (4) 주석 설명
						strHtml += "<td class=\"remark-pnl\">" + printRemark(arr[j][0].nodeName, "ad") + "</td>";
					}                        
				}
				else if (xmlObj["nodeName"] === "UI") {

				}
				else if (xmlObj["nodeName"] === "Edit") {

				}
				else if (xmlObj["nodeName"] === "Mime") {

				}
				else if (xmlObj["nodeName"] === "System") {
					
					var arr = [];
					arr.push($($entry[0]).find("MarkupLanguage"));

					for (var j = 0; j < arr.length; j++) {
						
						strHtml += "<tr id=" + idx + "-" + j + ">";
						
						// (1) 옵션명 세팅
						strHtml += "<th>" + $entry[0].nodeName + " | " + arr[j][0].nodeName + "</th>";
						
						// (2) Apply값 초기세팅
						strHtml += "<td></td>";
						
						// (3) 옵션 내용 세팅  
						if (arr[j][0].textContent === "html") {
							
							strHtml += "<td><select id='" + idx + "-2'><option value='html' selected>html</option><option value='xml'>xml</option></select></td>";	
						}
						else if (arr[j][0].textContent === "xml") {
						
							strHtml += "<td><select id='" + idx + "-2'><option value='html'>html</option><option value='xml' selected>xml</option></select></td>";	
						}

						// (4) 주석 설명
						strHtml += "<td class=\"remark-pnl\">" + printRemark(arr[j][0].nodeName, "ad") + "</td>";
					}   
				}
				else {
					
					strHtml += "<td><input type='input' size='50' id='" + idx + "-2' value=\"" + $entry[0].textContent + "\"></td>";
				}
				
				strHtml += "</tr>";

				$("#xmlArea table").append(strHtml).find("input,select,textarea").css("width", "90%");
				
				$("#emptyArea").hide();
				$("body").css("cursor", "auto");
			});
		});
	}
	
	// 높이 자동계산
	var areaHeight = $(window).height() - 221;
	$("#xmlArea").css({
		"height" : areaHeight,
		"overflow-y" : "auto"
	});
}


// 주석내용 리턴
function printRemark(strNodeKey, name) {
	
	if (typeof (strNodeKey) === "undefined") {
		
		return "";	
	}
	
	if (typeof (objRemark[name][strNodeKey]) === "undefined") {
		
		return "";	
	}
	
	var strComment = objRemark[name][strNodeKey][0].split('@');

	var result = strComment[0];
	
	return result;
}

function printRemarkPlus(strNodeKey, name, idx) {
	
	if (typeof (strNodeKey) === "undefined") {
		
		return "";	
	}
	
	if (typeof (objRemark[name][strNodeKey]) === "undefined") {
	
		return "";	
	}
	
	var strComment = objRemark[name][strNodeKey][0].split('@');

	var result = strComment[1];
	
	return result;
}