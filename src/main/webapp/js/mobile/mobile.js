$(document).on('pageshow', '#login', function(){				
	$("#uid").val("");
	$("#upw").val("");
			
	fnInit();
});

$(document).on('pageshow', '#main', function(){
	$(".animateMe .ui-collapsible-heading-toggle").on("click", function (e) { 
	    var current = $(this).closest(".ui-collapsible");             
	    if (current.hasClass("ui-collapsible-collapsed")) {
	        //collapse all others and then expand this one
	        $(".ui-collapsible").not(".ui-collapsible-collapsed").find(".ui-collapsible-heading-toggle").click();
	        $(".ui-collapsible-content", current).slideDown(250);
	    } else {
	        $(".ui-collapsible-content", current).slideUp(250);
	    }
	});
});

$(document).on('pageshow', '#sampleList', function(){
    $("#editBtn").click(function() {	
    	if ($("#editDisplay").css("display") == "none") {    		
    		$("#editDisplay").slideDown(250);
    	} else {
    		$("#editDisplay").slideUp(250);
    	} 
    });
});

function actionLogin() {
	var frm = document.loginForm;
    if (frm.id.value =="") {
    	$("#popupContent").html(frm.idCheck.value);
    	$("#popupAlert").popup("open");		    	
    	
    	return;
    } else if (frm.password.value =="") {
    	$("#popupContent").html(frm.passCheck.value);
    	$("#popupAlert").popup("open");
    			    	
        return;
    } else {			    	
    	var rsa = new RSAKey();
		rsa.setPublic(frm.publicModulus.value, frm.publicExponent.value);
		
		saveid(frm);

		$.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		data : {
    			encryptID : rsa.encrypt(frm.id.value),
    			encryptPass : rsa.encrypt(frm.password.value)
    		},
    		url : "/mobile/user/login/actionLogin.do",
    		success: function(text){
    			if (text == "ok") {			    				
    				$('#loginForm').attr("action", "/mobile/ezPortal/portalMain.do");
    				$('#loginForm').submit();
    			} else {
    				if (text == "isFirstLogin") {			    			
	    				$("#popupContent").html("first login!");
				    	$("#popupAlert").popup("open");
	    			} else if (text == "isExpireDate") {
	    				$("#popupContent").html("password expired!");
				    	$("#popupAlert").popup("open");
	    			} else {
	    				$("#popupContent").html(frm.failLogin.value);
				    	$("#popupAlert").popup("open");
	    			}
    				frm.id.value = getCookie("saveid");
    				$("#upw").val("");
    			}
    		},
    		error: function(err){
    			$("#popupContent").html($("#failLogin").val());
		    	$("#popupAlert").popup("open");
		    	frm.id.value = getCookie("saveid");
				$("#upw").val("");
    		}
        });					
    }
}

function setCookie (name, value, expires) {
    document.cookie = name + "=" + escape (value) + "; path=/; expires=" + expires.toGMTString();
}

function getCookie(Name) {
    var search = Name + "="
    if (document.cookie.length > 0) { // 쿠키가 설정되어 있다면    	
	        offset = document.cookie.indexOf(search)
   
	        if (offset != -1) { // 쿠키가 존재하면
            offset += search.length
            // set index of beginning of value
            end = document.cookie.indexOf(";", offset);			            
            //document.getElementById("upw").focus();
            // 쿠키 값의 마지막 위치 인덱스 번호 설정
            if (end == -1)
                end = document.cookie.length
            return unescape(document.cookie.substring(offset, end))            
        }
    } else {			    	
		//document.getElementById("uid").focus();
    }    
}

function saveid(form) {
    var expdate = new Date();			    
    // 기본적으로 30일동안 기억하게 함. 일수를 조절하려면 * 30에서 숫자를 조절하면 됨
    if (form.checkId.checked)
        expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 30); // 30일
    else
        expdate.setTime(expdate.getTime() - 1); // 쿠키 삭제조건
    setCookie("saveid", form.id.value, expdate);
}

function getid() {
	var a = getCookie("saveid");
	$("#uid").val(a);
	
    if($("#uid").val() != "") {
    	if(!$("#checkId").is(":checked")){
    		$("#checkId").click();
    	}
    }
}

function fnInit() {
    // 로그인 페이지가 로드된 프레임이 Top 프레임이 아니면 Top 프레임으로 로드시킨다.
    if (top != self) {
        top.location.href = self.location.href;
    }
    getid();
}

function goHome() {
	$.mobile.changePage("/mobile/ezPortal/portalMain.do", {
		type: "post",
		transition: "pop",
		changeHash: true
	});
}

function goMail() {
	$.mobile.changePage("/mobile/sample/sampleList.do?type=mailReceive", {
		type: "post",
		transition: "pop",
		changeHash: true
	});
}

function goSendMail() {
	$.mobile.changePage("/mobile/sample/sampleList.do?type=mailSend", {
		type: "post",
		transition: "pop",
		changeHash: true
	});
}

function logout() {
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,		    		
		url : "/mobile/user/login/actionLogout.do",
		success: function(text){
			if(text == "ok") {				
				$.mobile.changePage( "/mobile/user/login/login.do", {
					type: "post",
					transition: "pop",
					changeHash: true
				});
			}
		}
	});
}
var checkBoxStatus = 0;
function checkAll() {
	if(checkBoxStatus == 0) {
		$("input[name=checkbox]:checkbox").prop("checked", true).checkboxradio("refresh");
		checkBoxStatus++;
	} else {
		$("input[name=checkbox]:checkbox").prop("checked", false).checkboxradio("refresh");
		checkBoxStatus = 0;
	}
}

function moveMail() {
	var status = 0;
	$("input[name=checkbox]:checkbox").each(function() {
		if($(this).is(":checked")){
			status = 1;
		} 
	});

	if (status == 0) {
		$("#popupContent").html("메일을 선택해 주세요");
		$("#popupAlert").popup("open");
	} else {	
		$("#popupMailMove").popup("open");
	}
}

function searchMail() {
	$("#popupMailSearch").popup("open");
}