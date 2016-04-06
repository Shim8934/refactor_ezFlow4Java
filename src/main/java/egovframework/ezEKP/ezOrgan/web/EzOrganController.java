package egovframework.ezEKP.ezOrgan.web;

import java.util.Properties;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzOrganController {
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Autowired
	private EzOrganService ezOrganService;	

	@Autowired
	private EgovMessageSource messageSource;
	
	@RequestMapping(value = "/ezOrgan/getSIPUriList.do")
	public String getSIPUriList(@CookieValue("loginCookie") String loginCookie, LoginVO loginVO, HttpServletRequest request, Model model) throws Exception{
		loginVO = commonUtil.userInfo(loginCookie);
		String cnList = request.getParameter("cnList");
        String emailList = request.getParameter("emailList");
        String strRet = ezOrganService.getSIPUriList(cnList, emailList);
        
        model.addAttribute("strRet",strRet);
        
		return "json";
	}
	
	@RequestMapping(value = "/ezOrgan/getDeptTreeInfo.do", produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getDeptTreeInfo(@RequestBody String data, HttpServletRequest request, HttpServletResponse response) throws Exception{
		Document doc = commonUtil.convertStringToDocument(data);
		
		String userID = "";
		String deptID = doc.getElementsByTagName("DEPTID").item(0).getTextContent();
        String topID = doc.getElementsByTagName("TOPID").item(0).getTextContent();
        String propList = doc.getElementsByTagName("PROP").item(0).getTextContent();
        String lang = config.getProperty("config.primary");
        
        String deptInfo = ezOrganService.getDeptTreeInfo(userID, deptID, topID, propList, lang);        
		
		return deptInfo;
	}
	
	@RequestMapping(value = "/ezOrgan/getDeptSubTreeInfo.do", produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getDeptSubTreeInfo(@RequestBody String data, HttpServletRequest request, HttpServletResponse response) throws Exception{
		Document doc = commonUtil.convertStringToDocument(data);
				
		String deptID = doc.getElementsByTagName("DEPTID").item(0).getTextContent();        
        String propList = doc.getElementsByTagName("PROP").item(0).getTextContent();
        String lang = config.getProperty("config.primary");
        
        String deptInfo = ezOrganService.getDeptSubTreeInfo(deptID, propList, lang);
		
		return deptInfo;
	}
	
	@RequestMapping(value = "/ezOrgan/getDeptMemberList.do", produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getDeptMemberList(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String deptid = request.getParameter("deptID");
		String celllist = request.getParameter("cell");
		String proplist = request.getParameter("prop");
		String listtype = request.getParameter("type");		
		String lang = config.getProperty("config.primary");
		String page = request.getParameter("page");
		String infoXML = "";
		
		if(page == null){		
			infoXML = ezOrganService.getDeptMemberList(deptid, celllist, proplist, listtype, lang);
		}else{
			/* 2016-03-29 장진혁과장 pagination 작업 필요 */
			//infoXML = ezOrganService.getDeptMemberListPagination(deptid, celllist, proplist, listtype, lang, page);			 
		}
		
		Document doc = commonUtil.convertStringToDocument(infoXML);
		
		if (celllist.toUpperCase().indexOf("EXTENSIONATTRIBUTE5") > -1){
            String[] arryCell = celllist.toUpperCase().split(";");
            String tooltip = "";
            int idx = 0;
            
            for (int j = 0; j < arryCell.length; j++){
                if (arryCell[j].equals("EXTENSIONATTRIBUTE5")){
                    idx = j;
                }
            }
            
            for (int i = 0; i < doc.getElementsByTagName("ROW").getLength(); i++){
                Element Nodetip = doc.createElement("TOOLTIP");

                if (!doc.getElementsByTagName("ROW").item(i).getChildNodes().item(idx).getChildNodes().item(0).getTextContent().equals("")){
                    String[] arry = doc.getElementsByTagName("ROW").item(i).getChildNodes().item(idx).getChildNodes().item(0).getTextContent().split(":");
                    tooltip = arry[3].replace("/", ":") + " ~ " + arry[4].replace("/", ":");
                    
                    if (arry.length > 5){
                        tooltip += " " + messageSource.getMessage(arry[5]);
                    }
                    
                    /* 
                     * 2016-03-29 장진혁과장 날짜비교 작업 필요
                    // 2012.06.26 부재설정 미리해놓은 경우 현재 시간을 비교하여 표시되도록 추가함.
                    if ((Convert.ToDateTime(arry[3].replace("/", ":")) <= DateTime.Now) && (DateTime.Now <= Convert.ToDateTime(arry[4].replace("/", ":"))))
                    {
                        Nodetip.InnerText = tooltip;

                        xmldom.GetElementsByTagName("ROW").Item(i).ChildNodes.Item(idx).ChildNodes.Item(0).InnerText = "Y";
                        xmldom.GetElementsByTagName("ROW").Item(i).ChildNodes.Item(idx).AppendChild(Nodetip);
                    }
                    else
                    {
                        xmldom.GetElementsByTagName("ROW").Item(i).ChildNodes.Item(idx).ChildNodes.Item(0).InnerText = "";
                    }*/
                    //xmldom.GetElementsByTagName("ROW").Item(i).ChildNodes.Item(idx).ChildNodes.Item(0).InnerText = "";
                    doc.getElementsByTagName("ROW").item(i).getChildNodes().item(idx).getChildNodes().item(0).setTextContent("");
                }
            }
        }
		
		String result = commonUtil.convertDocumentToString(doc);
		result = result.replaceAll("null", "");
		
		return result;
	}
	
	@RequestMapping(value = "/ezOrgan/getSearchList.do", produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getSearchList(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String searchlist = request.getParameter("search");
		String celllist = request.getParameter("cell");
		String proplist = request.getParameter("prop");
		String listtype = request.getParameter("type");
		String lang = config.getProperty("config.primary");
		String page = request.getParameter("page");
		String infoXML = "";
		
		if(page == null){
			infoXML = ezOrganService.getSearchList(searchlist, celllist, proplist, listtype, 100, lang);
		}else{
			/* 2016-03-29 장진혁과장 pagination 작업 필요 */
			//infoXML = ezOrganService.getSearchListPagination(searchlist, celllist, proplist, listtype, 100, lang, page);
		}
		
		Document doc = commonUtil.convertStringToDocument(infoXML);
		
		if (celllist.toUpperCase().indexOf("EXTENSIONATTRIBUTE5") > -1){
            String[] arryCell = celllist.toUpperCase().split(";");
            String tooltip = "";
            int idx = 0;
            
            for (int j = 0; j < arryCell.length; j++){
                if (arryCell[j].equals("EXTENSIONATTRIBUTE5")){
                    idx = j;
                }
            }
            
            for (int i = 0; i < doc.getElementsByTagName("ROW").getLength(); i++){
                Element Nodetip = doc.createElement("TOOLTIP");

                if (!doc.getElementsByTagName("ROW").item(i).getChildNodes().item(idx).getChildNodes().item(0).getTextContent().equals("")){
                    String[] arry = doc.getElementsByTagName("ROW").item(i).getChildNodes().item(idx).getChildNodes().item(0).getTextContent().split(":");
                    tooltip = arry[3] + " ~ " + arry[4];
                    
                    if (arry.length > 5){
                        tooltip += " " + arry[5];
                    }
                    
                    Nodetip.setTextContent(tooltip);
                    
                    doc.getElementsByTagName("ROW").item(i).getChildNodes().item(idx).getChildNodes().item(0).setTextContent("Y");
                    doc.getElementsByTagName("ROW").item(i).getChildNodes().item(idx).appendChild(Nodetip);
                }
            }
        }
		
		String result = commonUtil.convertDocumentToString(doc);
		result = result.replaceAll("null", "");
		
		return result;
	}

}
