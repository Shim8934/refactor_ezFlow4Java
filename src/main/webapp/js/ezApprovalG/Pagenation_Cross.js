//##########################################################
// 페이지네이션 처리 - 페이지 선택시 문서리스트 출력 함수
//##########################################################

//한페이지 리스트 갯수
var sPage = 10;

function paging(p_page,p_nowblock)
{
    if(CrossYN())
        document.getElementById('lvSDoc').innerHTML = "";       
           
    else
        document.getElementById('lvSDoc').innerText = ""; 
        
    listview.LoadFromID("lvSDocForm");  
    	
    var h,j, x_NAME,x_WIDTH,x_HEADER,x_CELL2,x_VALUE2,count;
    count = NodeList[0].childNodes.length;
    
    var s_page = sPage*p_page - (sPage-1);				
    var e_page = sPage*p_page;						
    
    if (totalPage == p_page)
    {
        if(NodeListLen % sPage != 0)
        {
            e_page = s_page + (NodeListLen % sPage)-1;
        }
    }
    
    if ( nowblock > 0 )
    {
		s_page = s_page - (nowblock*PageSize) ;
		e_page = e_page - (nowblock*PageSize);
    }
     
    var xmlpara = createXmlDom();
    
    var objNode, objRoot, subNode, CellNode, RowsHeader, RowHeader, headerNode;
	objNode = createNodeInsert(xmlpara, objRoot, "LISTVIEWDATA"); 	
	var headersNode = createNodeAndAppandNode(xmlpara, objNode, subNode, "HEADERS");
	

    
	for (h = 0; h <= Headers.length - 1; h++)
	{
	    headerNode = createNodeAndAppandNode(xmlpara, headersNode, subNode, "HEADER");
	    
	    createNodeAndAppandNodeText(xmlpara, headerNode, subNode, "NAME", SelectSingleNodeValue(Headers[h], "NAME"));//Haders[h].childNodes[0].childNodes[0].nodeValue);
	    createNodeAndAppandNodeText(xmlpara, headerNode, subNode, "WIDTH", SelectSingleNodeValue(Headers[h], "WIDTH"));// Haders[h].childNodes[1].childNodes[0].nodeValue);
	}
    
    RowsHeader = createNodeAndAppandNode(xmlpara, objNode, subNode, "ROWS");	
    for( i=s_page; i<=e_page; i++)
    { 
        RowHeader = createNodeAndAppandNode(xmlpara, RowsHeader, subNode, "ROW");
        CellNode = createNodeAndAppandNode(xmlpara, RowHeader, subNode, "CELL");	
        createNodeAndAppandNodeText(xmlpara, CellNode, subNode, "VALUE", SelectSingleNodeValue(SelectSingleNode(NodeList[i-1], "CELL"), "VALUE"));//NodeList[i-1].childNodes[0].childNodes[0].childNodes[0].nodeValue);
        createNodeAndAppandNodeText(xmlpara, CellNode, subNode, "DATA1", SelectSingleNodeValue(SelectSingleNode(NodeList[i-1], "CELL"), "DATA1"));//NodeList[i-1].childNodes[0].childNodes[1].childNodes[0].nodeValue);
        createNodeAndAppandNodeText(xmlpara, CellNode, subNode, "DATA2", SelectSingleNodeValue(SelectSingleNode(NodeList[i-1], "CELL"), "DATA2"));//NodeList[i-1].childNodes[0].childNodes[2].childNodes[0].nodeValue);
        
        if(CrossYN())
        {
            var count=3;
            for (k=7; k< NodeList[i-1].childNodes[1].childNodes.length; k++)
            {                
                if(NodeList[i-1].childNodes[1].childNodes[k].childNodes.length > 0)
                    createNodeAndAppandNodeText(xmlpara, CellNode, subNode, "DATA" + count, NodeList[i-1].childNodes[1].childNodes[k].childNodes[0].nodeValue);//NodeList[i-1].childNodes[0].childNodes[k].childNodes[0].nodeValue);
   
                else
                    createNodeAndAppandNodeText(xmlpara, CellNode, subNode, "DATA" + count, "");//NodeList[i-1].childNodes[0].childNodes[k].childNodes[0].nodeValue);
                    
                k++;
                count++;
            }    
        }
        else
        {
            for (k=3; k< NodeList[i-1].childNodes[0].childNodes.length; k++)
            {
                if(NodeList[i-1].childNodes[0].childNodes[k].childNodes.length > 0)
                    createNodeAndAppandNodeText(xmlpara, CellNode, subNode, "DATA" + k, NodeList[i-1].childNodes[0].childNodes[k].childNodes[0].nodeValue);//NodeList[i-1].childNodes[0].childNodes[k].childNodes[0].nodeValue);
       
                else
                    createNodeAndAppandNodeText(xmlpara, CellNode, subNode, "DATA" + k, "");//NodeList[i-1].childNodes[0].childNodes[k].childNodes[0].nodeValue);
            }
        }      
        
        var CellNodeSub = new Array();
                
        if(CrossYN())
        {
            for (k=3; k< NodeList[i-1].childNodes.length; k++)
            {
                if(NodeList[i-1].childNodes[k].childNodes[1].childNodes.length > 0)
                {
                            
                    CellNodeSub[k] = createNodeAndAppandNode(xmlpara, RowHeader, subNode, "CELL");
                    var a = SelectSingleNode(NodeList[i-1], "CELL");                    
                    createNodeAndAppandNodeText(xmlpara, CellNodeSub[k], subNode, "VALUE", NodeList[i-1].childNodes[k].childNodes[1].childNodes[0].nodeValue);
                }
                else
                {
                    CellNodeSub[k] = createNodeAndAppandNode(xmlpara, RowHeader, subNode, "CELL");
                    createNodeAndAppandNodeText(xmlpara, CellNodeSub[k], subNode, "VALUE", "");
                }
                k++;
            }        
        }
        else
        {
            for (k=1; k< NodeList[i-1].childNodes.length; k++)
            {
                if(NodeList[i-1].childNodes[k].childNodes[0].childNodes.length > 0)
                {                    
                    CellNodeSub[k] = createNodeAndAppandNode(xmlpara, RowHeader, subNode, "CELL");		           
                    var a = SelectSingleNode(NodeList[i-1], "CELL");
                    createNodeAndAppandNodeText(xmlpara, CellNodeSub[k], subNode, "VALUE", NodeList[i-1].childNodes[k].childNodes[0].childNodes[0].nodeValue);
                }
                else
                {
                    CellNodeSub[k] = createNodeAndAppandNode(xmlpara, RowHeader, subNode, "CELL");
                    createNodeAndAppandNodeText(xmlpara, CellNodeSub[k], subNode, "VALUE", "");
                }
            }    
        }         
	    
   } 
   lvSDocResize();   
   listview.DataSource(xmlpara);
   listview.DataBind("lvSDoc");
   pagingCount(p_page, p_nowblock);
   
   pChackYN = "FALSE"
}


//####################################################
// 페이지네이션 처리  - 페이지네이션 디스플레이 함수
//####################################################

function pagingCount(p_page,p_nowblock)
{
    var td;
    //페이네이션 TR  초기화
    if(CrossYN())
        document.getElementById("PageNum").innerHTML="";
    else
        document.getElementById("PageNum").innerText="";
    //페이지당 몇개의 페이지를 출력할 것인지 결정
    curpage = p_page;
	nowblock = p_nowblock;
            
    var Gopage;
    var comNoPerPage = sPage;
	  
	var nextPage,mychoice,prevPage,total_block ;
	totalPage =  parseInt(NodeListLen / comNoPerPage);
	var  strtext = "";
	
	//총 페이지 수를 계산.
	if (((totalPage * comNoPerPage) != NodeListLen) && ((NodeListLen % comNoPerPage) != 0) )
	{   
		totalPage = totalPage + 1;
	}
   
    if ( curpage < totalPage )
		nextPage = parseInt(curpage) + 1;
	else
		nextPage = totalPage;
	  
	if ( curpage > 1)
		prevPage = parseInt(curpage) - 1;
	else 
		prevPage = 1;
	mychoice = 10;
	  
	total_block = parseInt(totalPage / mychoice);
	if ( totalPage % mychoice == 0 )
		total_block=total_block-1;
		    
	if (totalPage > 1) 
	{
		// 이전 블럭으로 이동
		if (nowblock > 0)
	    { 
 			strtext = "<div onclick= 'return Block_Check("+((nowblock-1)*mychoice+1) +","+ (nowblock-1) +")' style='cursor:pointer'>" ;
 			strtext =  strtext + "<img src='/images/page_pprevious.gif' width='15' height='15'  border='0'></div>";
 			td_Create(strtext);
 		}	  
 		 
 		// 이전 페이지 이동 
		if (curpage != 1 && NodeListLen != 0 )
 		{
 			if ( ((curpage - 1) % mychoice) == 0 )
 			{
 				block = nowblock-1;
 				strtext =  "<div onclick= 'return Block_Check("+prevPage +"," + block +")' style='cursor:pointer'>"; 
 			}
 			else
 			{
 				block = nowblock;
 				strtext =  "<div onclick= 'return Page_Click("+prevPage +"," + block +")' style='cursor:pointer'>"; 
			} 		        
			strtext = strtext + "<img src='/images/page_previous.gif' width='15' height='15'  border='0'></div>";
			td_Create(strtext);
		}
        
        // 페이지들
		if (total_block != nowblock)
        {            
			for(Gopage = 1; Gopage <= mychoice; Gopage++)
            {   
     			if ( curpage != nowblock*mychoice + Gopage )
     		    {
     				strtext = "<div onclick='return Page_Click("+((nowblock*mychoice) + Gopage ) +"," +nowblock +")' style='cursor:pointer' >";  
     				strtext = strtext + "[" + ((nowblock*mychoice) + Gopage) + "]</div>";
     				td_Create(strtext);
     		    }
     		    else  
     		    {
     				strtext =  "<font color='blue'> [" + ((nowblock*mychoice) + Gopage) + "] </font>";
     				td_Create(strtext);
     			}
            }
		}
		else 
        { 	
			for (Gopage = 1; Gopage <=  totalPage - mychoice*nowblock; Gopage++)
     		{   
     			if ( curpage != nowblock*mychoice + Gopage) 
     			{     				
     				strtext = "<div onclick='return Page_Click("+((nowblock*mychoice) + Gopage ) +"," +nowblock +")' style='cursor:pointer' >";  
     				strtext = strtext + "[" + ((nowblock*mychoice) + Gopage ) + "]</div>";
     				td_Create(strtext);
     			}
     			else 
     			{
     				strtext  =  "<font color='blue'> ["+( (nowblock*mychoice) + Gopage) + "] </font>";
     				td_Create(strtext);
     			}
            }
        }
        
		//다음 페이지 이동
		if((curpage != totalPage) && (NodeListLen != 0 ))
		{
			if ((curpage % mychoice) == 0) 
            {
                block=(nowblock+1);
                strtext = "<div onclick='return Block_Check(" + nextPage +","+block+")' style='cursor:pointer' >";  
            }
            else
            {
                block=nowblock;
                strtext = "<div onclick='return Page_Click(" + nextPage +","+block+")' style='cursor:pointer' >";  
            }
     		strtext = strtext + "<img src='/images/page_next.gif' width='15' height='15' border='0'></div>";
     		td_Create(strtext);
     		  	
		}
    	//다음 블럭 이동	
		if ((total_block > 0) && (nowblock < total_block))
		{
    		strtext =  "<div onclick='return Block_Check(" +((nowblock+1)*mychoice+1)+","+(nowblock+1)+ ")' style='cursor:pointer'>";  
    		strtext = strtext + "<img src='/images/page_nnext.gif' width='15' height='15' border='0'></div>";
    		td_Create(strtext);
		}   
    }    
}


//*********************************************
//   TD를 생성  함수 (페이지네이션에서 사용)
//*********************************************
function td_Create(strtext)
{
	td =  document.getElementById("PageNum").insertCell(-1);
    td.width = "17px";
    td.height = "17px";
 	td.align = "center";
 	td.valign = "center";
 	td.innerHTML = strtext;
}

function Page_Click(PageNum,block)
{	
	curpage = PageNum ;
	nowblock = block;
	pChackYN = "TRUE";
	paging(curpage,nowblock);
}

function Block_Check(PageNum,BlockNum)
{
	curpage = PageNum;
	nowblock = BlockNum;
	pChackYN = "TRUE";
	getDocList();
}

function lvSDocResize()
{
}

function lvTDocResize()
{	
}