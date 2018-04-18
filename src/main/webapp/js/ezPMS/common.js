/**
 * 
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
					'animation' : 0
				},
				'plugins' : [ 'sort' ],
				'sort' : function(a, b) {
					var a1 = this.get_node(a);
					var b1 = this.get_node(b);
					if (a1.icon == b1.icon) {
						return (a1.original.sort > b1.original.sort) ? 1 : -1;
					} else {
						return (a1.icon > b1.icon) ? 1 : -1;
					}
				}
			});
		},
		error : function(request, status, error) {
			alert("code : " + request.status + "\nerror : " + error);
		}
	});
}