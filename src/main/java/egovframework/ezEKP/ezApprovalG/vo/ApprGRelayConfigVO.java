package egovframework.ezEKP.ezApprovalG.vo;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.utl.fcc.service.CommonUtil;

public class ApprGRelayConfigVO {

	 private static final Logger logger = LoggerFactory.getLogger(ApprGRelayConfigVO.class);
	
	 //문서유통 relay 폴더경로
	 private String strRelayFolderPath;
	 //전자결재 문서 경로
	 private String strAprDocPath;
	 //tenantID
	 private int tenantID;
	 //receiveerr 경로
	 private String receiveerrPath;
	 //senderr 경로
	 private String senderrPath;
	 //senderrTemp 경로
	 private String senderrtempPath;
	 //receivetemp 경로
	 private String receivetempPath;
	 //receiveComp 경로
     private String receiveCompPath;
     //receive 경로
   	 private String receivePath;
     //receivetemperr 경로
   	 private String receivetemperrPath;
   	 
     private List<List<String[]>> AdminMail;
     
     private List<String[]> receiveerrList;
     
     private List<String[]> senderrList;
     
     private List<String[]> xmlparsingerrList = new ArrayList<String[]>();
     
     private String configReceiveerrMove;
     
     private String configMailNoti;
     
     private String separator;
     
     private String strCompanyID;
     
     public ApprGRelayConfigVO(String configRelayRoot, String configUloadRelayRoot, String relayUploadPath, int tenantID, String separator) {
    	 
    	 this.AdminMail = new ArrayList<List<String[]>>();
    	 
    	 this.receiveerrList = new ArrayList<String[]>();
    	 
    	 this.senderrList = new ArrayList<String[]>();
    	 
    	 this.xmlparsingerrList = new ArrayList<String[]>();
    	 
    	 this.separator = separator;
    	 
    	 //문서유통폴더 경로 생성 및 할당 
		 this.strRelayFolderPath = configRelayRoot + separator + "fileroot" + separator + tenantID + separator + "files" + configUloadRelayRoot;
		 //문서경로 생성 및 할당
		 this.strAprDocPath = configRelayRoot + relayUploadPath; 
		       
		 logger.debug("relayFolderPath = " + strRelayFolderPath + "& aprDocPath = " + strAprDocPath);
  
		 //문서유통폴더 경로가 /로 끝나는지 확인하고 /로 끝나지 않는다면 /추가
		 if (!strRelayFolderPath.substring(strRelayFolderPath.length() - 1).equals(separator)) {
		   this.strRelayFolderPath = strRelayFolderPath + separator;
		 }
		       
		 //문서폴더 경로가 /로 끝나는지 확인하고 /로 끝나지 않는다면 /추가
		 if (!strAprDocPath.substring(strAprDocPath.length() - 1).equals(separator)) {
		    this.strAprDocPath = strAprDocPath + separator;
		 }
		       
		 logger.debug("relayFolderPath = " + strRelayFolderPath + "// aprDocPath = " + strAprDocPath);
		 
		 //receiveerr 경로
		 this.receiveerrPath = strRelayFolderPath + "data" + separator +"receiveerr";
		 //senderr 경로
		 this.senderrPath = strRelayFolderPath + "data" + separator +"senderr";
		 //senderrTemp 경로
		 this.senderrtempPath = strRelayFolderPath + "data" + separator +"senderrtemp";
		 //receivetemp 경로
		 this.receivetempPath = strRelayFolderPath + "data" + separator +"receivetemp";
		 //receiveComp 경로
	     this.receiveCompPath = strRelayFolderPath + "data" + separator +"receiveComp";
	     //receive 경로
	   	 this.receivePath = strRelayFolderPath + "data" + separator +"receive";
	     //receivetemperr 경로
	   	 this.receivetemperrPath = strRelayFolderPath + "data" + separator +"receivetemperr";

     }

	public String getStrRelayFolderPath() {
		return strRelayFolderPath;
	}


	public void setStrRelayFolderPath(String strRelayFolderPath) {
		this.strRelayFolderPath = strRelayFolderPath;
	}



	public String getStrAprDocPath() {
		return strAprDocPath;
	}



	public void setStrAprDocPath(String strAprDocPath) {
		this.strAprDocPath = strAprDocPath;
	}



	public int getTenantID() {
		return tenantID;
	}

	public List<List<String[]>> getAdminMail() {
		return AdminMail;
	}

	public void addAdminMail(List<String[]> errList) {
		this.AdminMail.add(errList);
	}

	public List<String[]> getReceiveerrList() {
		return receiveerrList;
	}

	public void addReceiveerrList(String[] errArray) {
		this.receiveerrList.add(errArray);
	}
	
	public List<String[]> getSenderrList() {
		return senderrList;
	}

	public void addSenderrList(String[] errArray) {
		this.senderrList.add(errArray);
	}

	public List<String[]> getXmlparsingerrList() {
		return xmlparsingerrList;
	}

	public void addXmlparsingerrList(String[] errArray) {
		this.xmlparsingerrList.add(errArray);
	}
	
	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}

	public String getConfigReceiveerrMove() {
		return configReceiveerrMove;
	}

	public String getConfigMailNoti() {
		return configMailNoti;
	}
	
	public void setConfigReceiveerrMove(String configReceiveerrMove) {
		this.configReceiveerrMove = configReceiveerrMove;
	}

	public void setConfigMailNoti(String configMailNoti) {
		this.configMailNoti = configMailNoti;
	}

	public String getReceiveerrPath() {
		return receiveerrPath;
	}

	public String getReceivetempPath() {
		return receivetempPath;
	}
	
	public String getReceivetemperrPath() {
		return receivetemperrPath;
	}

	public String getReceivePath() {
		return receivePath;
	}
	
	public String getReceiveCompPath() {
		return receiveCompPath;
	}

	public String getSenderrPath() {
		return senderrPath;
	}
	
	public String getSenderrtempPath() {
		return senderrtempPath;
	}
	
	public String getSeparator() {
		return separator;
	}

	public String getReceiveerrPath(String fileName) {
		
		String filePath = getReceiveerrPath() + separator + fileName;
		
		return filePath;
	}
	
	public String getReceivetempPath(String fileName) {
		
		String filePath = getReceivetempPath() + separator + fileName;

		return filePath;
	}
	
	public String getReceivetemperrPath(String fileName) {
		
		String filePath = getReceivetemperrPath() + separator + fileName;

		return filePath;
	}
	
	public String getReceivePath(String fileName) {
		
		String filePath = getReceivePath() + separator + fileName;
		
		return filePath;
	}
	
	public String getReceiveCompPath(String fileName) {
		
		String filePath = getReceiveCompPath() + separator + fileName;
		
		return filePath;
	}
	
	public String getSenderrPath(String fileName) {
		
		String filePath = getSenderrPath() + separator + fileName;
		
		return filePath;
	}
	
	public void setSeparator(String separator) {
		this.separator = separator;
	}

	public void setReceiveCompPath(String receiveCompPath) {
		this.receiveCompPath = receiveCompPath;
	}

	public String getSenderrtempPath(String fileName) {
		return getSenderrtempPath() + separator + fileName;
	}
	
	public String getStrCompanyID() {
		return strCompanyID;
	}

	public void setStrCompanyID(String strCompanyID) {
		this.strCompanyID = strCompanyID;
	}

	@Override
	public String toString() {
		return "ApprGRelayConfigVO [strRelayFolderPath=" + strRelayFolderPath + ", strAprDocPath=" + strAprDocPath
				+ ", tenantID=" + tenantID + ", receiveerrPath=" + receiveerrPath + ", senderrPath=" + senderrPath
				+ ", senderrtempPath=" + senderrtempPath + ", receivetempPath=" + receivetempPath + ", receiveCompPath="
				+ receiveCompPath + ", receivePath=" + receivePath + ", AdminMail=" + AdminMail.toString() + ", receiveerrList="
				+ receiveerrList.toString() + ", senderrList=" + senderrList.toString() + ", xmlparsingerrList=" + xmlparsingerrList.toString()
				+ ", configReceiveerrMove=" + configReceiveerrMove + ", configMailNoti=" + configMailNoti
				+ ", separator=" + separator + ", strCompanyID=" + strCompanyID + "]";
	}

}
