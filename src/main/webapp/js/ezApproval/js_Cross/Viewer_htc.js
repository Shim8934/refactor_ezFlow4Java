function getViewer()
{
    var viewer = document.all["oApprLineViewer"];
    return viewer;
}

function addTask(AprLineRow,pType, pLineSN, pLineUserNM)
{
    var viewer = getViewer();
    
    if (pType == "A03001")
    {
        viewer.AddTask(pLineSN-1, "결재", pLineUserNM, 0);
        viewer.SetTaskBackColor(pLineSN-1, 0xF1b8F1);
    }
    else
    {
        for(i = AprLineRow.listlength() - 1; i >= 0;i--)
 	    {
 		     
 		    if(AprLineRow.getvalue3(i,0,"DATA11") == "A03008")
 		    {
 			    afterAprflag = true;		
 		    }
     		
 		    if(afterAprflag)
 		    {
 			    afterApr = afterApr + 1;
 		    }	
 	    }
 	
        viewer.AddTask(0, "협의", pLineUserNM, 1);
    }
   
    
    viewer.Redraw();
}


function ChangeTask(AprLineRow,pType, pLineSN, pLineUserNM)
{
    var viewer = getViewer();
    
    if (pType == "A03001")
    {
       var pAprhySN = 100;
      
        for(i = AprLineRow.listlength() - 1; i >= 0;i--)
 	    {
 		    if (AprLineRow.getvalue3(i,0,"VALUE") == pLineSN) break;
 		    
 		    if(AprLineRow.getvalue3(i,0,"DATA11") == "A03001")
 		    {
 			    pArpSN = AprLineRow.getvalue3(i,0,"VALUE");
 		    }
 		    else if ( pArpSN < AprLineRow.getvalue3(i,0,"VALUE")  && AprLineRow.getvalue3(i,0,"DATA11") == "A03008")
 		    {
 		        pAprhySN = pAprhySN + 1;
 		    }
 		   
 	    }
 		    
        viewer.RemoveTask(pAprhySN);
     
        viewer.AddTask(pLineSN-1, "결재", pLineUserNM, 0);
        viewer.Redraw();
    }
    else
    {
        var pFirst = true;
        var pAprhySN;
        var pCurAprSN=0;
        
        var pAprhyPreType = pType;
        
        for(i = AprLineRow.listlength() - 1; i >= 0;i--)
 	    {
 			if (pFirst) pAprhySN = 100;

 		    if (AprLineRow.getvalue3(i,0,"VALUE") == pLineSN) break;

 		    if(AprLineRow.getvalue3(i,0,"DATA11") == "A03001")
 		    {
 				if (pAprhyPreType == "A03008") pAprhySN = pAprhySN + 1;
 				
 			    pArpSN = AprLineRow.getvalue3(i,0,"VALUE"); 
 			    pAprhyPreType = AprLineRow.getvalue3(i,0,"DATA11");

 			    pCurAprSN = pCurAprSN+1;
 		    }
 		    else if (pAprhyPreType != "A03008" && AprLineRow.getvalue3(i,0,"DATA11") == "A03008")
 		    {
 		        pAprhyPreType = AprLineRow.getvalue3(i,0,"DATA11");
 		        
 		        pFirst = false;
 		    } 		   
 	    }
 	   
        viewer.RemoveTask(pCurAprSN);
      		
		viewer.AddTask(pAprhySN, "협의", pLineUserNM, pArpSN);
		viewer.Redraw();     
    }
}

function SetAprTypeColor(pviewer,parpsn,paprtype)
{
	if (paprtype == "A04003")             
        	pviewer.SetTaskBackColor(parpsn, 0xDFF6BA);
	else if (paprtype == "A04002")        
	    	pviewer.SetTaskBackColor(parpsn, 0xCCE3FF);
	else if (paprtype == "A04001")        
	    	pviewer.SetTaskBackColor(parpsn, 0xF1b8F1);
}

	
function setAprImg(paprtype)
{
	var imgnum = 0;
	if (paprtype == "A03002" || paprtype == "A03007")             
		imgnum = 18;
    	else if (paprtype == "A03001")        
		imgnum = 11;
	else if (paprtype == "drafter")        
	  	imgnum = 14;
  	else if (paprtype == "A03011" || paprtype == "A03012")        
	  	imgnum = 12;

	return imgnum;  	
}
 				    
function SetTask(AprLineRow,pStatus)
{
    var pArpSN;
    var pAprhySN = 100;
    var pUserNM = "";
   
    var pAprhyPreType ="";
    var pAprhyType ="";
    var pFirst = true;
    var pdepthyFirst = true;
    var pdraftflag = true;
    
    try {
		var viewer = getViewer();
		if(viewer.LaneCount > 1)
            	{
              		viewer.LaneWidth = 1;
               	 	viewer.SetLaneText(0, "");
                	viewer.SetLaneText(1, " ");
            	}	
         
		viewer.ClearTask();
		for(i = AprLineRow.listlength() - 1; i >= 0;i--)
 		{
 			var paprlinetype = AprLineRow.getvalue3(i,0,"DATA11");

			var paprnm = "";
 			 
 			if(paprlinetype == "A03001")
 			{
 				pArpSN =  AprLineRow.getvalue3(i,0,"VALUE");
 				
 				if (pStatus != "")
	 			    pUserNM =  AprLineRow.getvalue3(i,1,"VALUE");
	 			else
	 			    pUserNM =  AprLineRow.getvalue3(i,1,"VALUE");
		    
		    		paprnm = "결재";
		    		if (pFirst) 
		    		{
 					pAprhySN = 100;
 					paprnm = "기안";
 					paprlinetype = "drafter";
 				}else
 					pAprhySN = pAprhySN + 1;
 					
		    	viewer.AddTask(pArpSN, paprnm, pUserNM, setAprImg(paprlinetype));	
		    	
 				SetAprTypeColor(viewer, pArpSN, AprLineRow.getvalue3(i,0,"DATA12"));
 				
 				viewer.Redraw();

 				pAprhyPreType = AprLineRow.getvalue3(i,0,"DATA11");
 			}
     		else if (paprlinetype == "A03008" || paprlinetype == "A03009")
     		{
     			pAprhyType = AprLineRow.getvalue3(i,0,"DATA11");
     			
     			if (pStatus != "")
	 			    pUserNM = AprLineRow.getvalue3(i,2,"VALUE");
	 			else
	 			    pUserNM = AprLineRow.getvalue3(i,1,"VALUE");

     			viewer.AddTask(pArpSN, "개인합의", pUserNM, setAprImg(paprlinetype));
     			
     			SetAprTypeColor(viewer, pArpSN, AprLineRow.getvalue3(i,0,"DATA12"));
     			
			    viewer.Redraw();	
				
			    pAprhySN = pAprhySN + 1;
			    pAprhyPreType = AprLineRow.getvalue3(i,0,"DATA11");
     		}
			else if (paprlinetype == "A03002" || paprlinetype == "A03007" || paprlinetype == "A03004" || paprlinetype == "A03003" || paprlinetype == "A03015" || paprlinetype == "A03017" || paprlinetype == "A03031" || paprlinetype == "A03040" )
	     	{
	     		pArpSN =  AprLineRow.getvalue3(i,0,"VALUE");
				
				if (pStatus != "")
	 			    pUserNM = AprLineRow.getvalue3(i,2,"VALUE");
	 			else
	 			    pUserNM = AprLineRow.getvalue3(i,1,"VALUE");
		    	
	    		switch(paprlinetype)
	    		{
	    			case "A03002": 
	    				paprnm = "확인";
	    				break;
	    			case "A03007": 
	    				paprnm = "참조";
	    				break;
	    			case "A03004": 
	    				paprnm = "전결";
	    				break;
	    			case "A03003": 
	    				paprnm = "결재안함";
	    				break;
	    			case "A03015": 
	    				paprnm = "사후공람";
	    				break;
	    			case "A03017": 
	    				paprnm = "회람";
	    				break;
	    			case "A03031": 
	    				paprnm = "통제";
	    				break;
	    			case "A03040": 
	    				paprnm = "후결";
	    				break;
	    		}
		    		
		    	viewer.AddTask(pArpSN, paprnm, pUserNM, setAprImg(paprlinetype));
		    	
				SetAprTypeColor(viewer, pArpSN, AprLineRow.getvalue3(i,0,"DATA12"));
				
				viewer.Redraw();
				
				pAprhySN = pAprhySN + 1;
				
				pAprhyPreType = AprLineRow.getvalue3(i,0,"DATA11");
	    	}
			else if (paprlinetype == "A03011" || paprlinetype == "A03012")
     		{
     			pArpSN =  AprLineRow.getvalue3(i,0,"VALUE");
			
			if (pStatus != "")
 			    pArpSN =  AprLineRow.getvalue3(i,4,"VALUE");
 			else
 			    pArpSN =  AprLineRow.getvalue3(i,3,"VALUE");
	    
	    		if(pAprhyPreType == "A03011" || pAprhyPreType == "A03012" )
	    			pAprhySN = pAprhySN - 1 ;
	    		else
	    		{
	    			if(pdepthyFirst == false)
	    				pAprhySN = pAprhySN - 1;
	    		}
	    			
	   		viewer.AddTask(pAprhySN, "부서합의", pUserNM, setAprImg(paprlinetype));	
			viewer.Redraw();
			
			pAprhySN = pAprhySN + 1;
			
			pAprhyPreType = AprLineRow.getvalue3(i,0,"DATA11");
			
			pdepthyFirst = false;
     		}
	     		
     		pFirst = false;
 		}
 	}
	catch(e)
    {
        
    } 	
}

function DelTask(AprLineRow,pType, pLineSN, pLineUserNM, pStatus)
{
    var viewer = getViewer();
    
    if (pType == "A03001")
    {
        var pFirst = true;
        
		for(i = AprLineRow.listlength() - 1; i >= 0;i--)
 	    {
 		    if (AprLineRow.getvalue3(i,0,"VALUE") == pLineSN) 
 		    {   
 		        break;
 		    }
 		    else
 		    {
 		       if (pFirst)
 		       {
                    pAprSN = 0;
                    pFirst = false;
 		       }
 		       else
 		       {
 		            pAprSN = pAprSN + 1;
 		       }
 		    }
 	    }
 		    
        viewer.RemoveTask(pAprSN);
       
    }
    else  if (pType == "A03008")
    { 
        var pFirst = true;
        var pAprhySN;
        var pCurAprSN=0;
        
        var pAprhyPreType = pType;
        
        for(i = AprLineRow.listlength() - 1; i >= 0;i--)
 	    {
 			if (pFirst) pCurAprSN = 100; 		       
            
 		    if (AprLineRow.getvalue3(i,0,"VALUE") == pLineSN) break;
 		    
 		    if(AprLineRow.getvalue3(i,0,"DATA11") == "A03001")
 		    {
 				if (pAprhyPreType == "A03008") pAprhySN = pAprhySN + 1;
 				
                pArpSN = AprLineRow.getvalue3(i,0,"VALUE");
 			    pAprhyPreType = AprLineRow.getvalue3(i,0,"DATA11");

 			    pCurAprSN = pCurAprSN+1;
 		    }
 		    else if (pAprhyPreType != "A03008" && AprLineRow.getvalue3(i,0,"DATA11") == "A03008")
 		    {
 		        pAprhyPreType = AprLineRow.getvalue3(i,0,"DATA11");
 		        
 		        pFirst = false;
 		    } 		   
 	    }
 	   
        viewer.RemoveTask(pCurAprSN);
    }
}

function runEmbedApprLineViewer()
{
    if (!CrossYN() && pNoneActiveX != "YES") {
        document.writeln("<OBJECT id='oApprLineViewer' name='oApprLineViewer' height='100%' width='100%' border='1' classid='clsid:DD0B9FBA-C0EB-4B8F-AA4A-14D5758F2E65' VIEWASTEXT>");
        document.writeln("</OBJECT>");
    }
}


