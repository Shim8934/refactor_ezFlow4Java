/**
 * 프로젝트 업무트리 가져오기
 */
function getProjectTaskTree(containerId, projectId) {
	$.ajax({
		type : "post",
		dataType : "json",
		url : "/ezPMS/projectTaskTree.do",
		data : {
			"projectId" : projectId
		},
		success : function(data) {
			$("#"+containerId).jstree({
				'core' : {
					'data' : data.data,
					'multiple' : false,
					'animation' : 0,
					'themes' : {
						'responsive' : false,
						//'variant' : 'small',
						'stripes' : false
					}
				},
				'plugins' : [ 'sort' ],
				'sort' : function(a, b) {
					var a1 = this.get_node(a);
					var b1 = this.get_node(b);
					return (a1.original.sort > b1.original.sort) ? 1 : -1;
				}
			})
			.bind("loaded.jstree", function (event, data) {
		        $(this).jstree("open_all");
		    })
		},
		error : function(request, status, error) {
			alert("code : " + request.status + "\nerror : " + error);
		}
	});
}


function convertString(str) {
	str = ReplaceText(str, "&", "&amp;");
	str = ReplaceText(str, "<", "&lt;");
	str = ReplaceText(str, ">", "&gt;");
	str = str.replace(/(?:\r\n|\r|\n)/g, '<br/>');
	return str;
}
 
function ReplaceText(orgStr, findStr, replaceStr) {
     var re = new RegExp(findStr, "gi");
     return (orgStr.replace(re, replaceStr));
}
 
function replaceString(p_str) {
     p_str = ReplaceText(p_str, "&amp;", "&");
     p_str = ReplaceText(p_str, "&lt;", "<");
     p_str = ReplaceText(p_str, "&gt;", ">");
     return p_str;
}

function popupClose() {
	parent.DivPopUpHidden();
}