//******************************************************
// 현재 결재상태에 대한 Convert함수
//******************************************************
function ConvertAprLineState(pAprLineSate, pConvertType)
{
    var vflag = "";
    var result = "";
    
    if (pConvertType.toLowerCase() == "code") {
    	vflag = "NAME";
    } else {
    	vflag = "CODE";
    }
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getCodeData.do",
		data : {
			code1 : "A04",
			code2 : pAprLineSate,
			flag  : vflag
		},
		success: function(xml){
			result = xml;
		}        			
	});
  
  	var dataNodes = GetChildNodes(loadXMLString(result)); 
    var ret = getNodeText(dataNodes[0]);
    return ret; 	
}


//******************************************************
// 현재 결재상태에 대한 Convert함수
//******************************************************
function ConvertAprLineType(pAprLineType , pConvertType)
{
  
	var vflag = "";
    var result = "";
    
    if (pConvertType.toLowerCase() == "code") {
    	vflag = "NAME";
    } else {
    	vflag = "CODE";
    }
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getCodeData.do",
		data : {
			code1 : "A03",
			code2 : pAprLineType,
			flag  : vflag
		},
		success: function(xml){
			result = xml;
		}        			
	});
   	
   	var dataNodes = GetChildNodes(loadXMLString(result)); 
    var ret = getNodeText(dataNodes[0]);
    return ret;
}
