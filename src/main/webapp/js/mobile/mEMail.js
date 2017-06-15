function getMail(FolderId){
  $.ajax({
            type : 'post',
            url : '/mobile/ezEmail/mailGetList.do',
            data : {FOLDERID:FolderId,START:1,END:10},
            dataType : "json",
            contentType : "application/json; charset=UTF-8",
            error: function(xhr, status, error){
                alert(error);
            },
            success : function(json){
                alert(json)
            },
        });
}
