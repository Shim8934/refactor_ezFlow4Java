package egovframework.ezEKP.ezCar.service.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;

import egovframework.ezEKP.ezCar.dao.EzCarAdminDAO;
import egovframework.ezEKP.ezCar.service.EzCarAdminService;
import egovframework.ezEKP.ezCar.service.EzCarService;
import egovframework.ezEKP.ezCar.vo.CarBrdListVO;
import egovframework.ezEKP.ezCar.vo.CarGetClsAclListVO;
import egovframework.ezEKP.ezCar.vo.CarGetSubClsListVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("EzCarAdminService")
public class EzCarAdminServiceImpl extends EgovAbstractServiceImpl implements EzCarAdminService {

	private static final Logger logger = LoggerFactory.getLogger(EzCarAdminServiceImpl.class);

	@Resource(name = "EzCarAdminDAO")
	private EzCarAdminDAO ezCarAdminDAO;

	@Resource(name = "EzCarService")
	private EzCarService ezCarService;

	@Autowired
	private EzOrganAdminService ezOrganAdminService;

	@Autowired
	private EzOrganService ezOrganService;

	@Autowired
	private CommonUtil commonUtil;

	public boolean addClsData(String xmlStr, int tenantID) throws Exception {
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);

		String classGB = xmlRes.getElementsByTagName("DATA").item(0).getTextContent().trim();
		String deptID = xmlRes.getElementsByTagName("DATA").item(1).getTextContent().trim();
		String deptNm = xmlRes.getElementsByTagName("DATA").item(2).getTextContent().trim();
		String ownerID = xmlRes.getElementsByTagName("DATA").item(3).getTextContent().trim();
		String ownerNm = xmlRes.getElementsByTagName("DATA").item(4).getTextContent().trim();
		String ownerPos = xmlRes.getElementsByTagName("DATA").item(5).getTextContent().trim();
		String ownerCall = xmlRes.getElementsByTagName("DATA").item(6).getTextContent().trim();
		String brdNm = xmlRes.getElementsByTagName("DATA").item(7).getTextContent().trim();
		/*
		 * String brdExplain =
		 * xmlRes.getElementsByTagName("DATA").item(8).getTextContent().trim();
		 */
		String accessNoty = xmlRes.getElementsByTagName("DATA").item(8).getTextContent().trim();
		String companyID = xmlRes.getElementsByTagName("DATA").item(9).getTextContent().trim(); // accessNoty(9)

		String brdNm2 = xmlRes.getElementsByTagName("DATA").item(10).getTextContent().trim();

		String isCompany = "";

		if (xmlRes.getElementsByTagName("ISCOMPANY").getLength() > 0) {
			isCompany = xmlRes.getElementsByTagName("ISCOMPANY").item(0).getTextContent();
		}

		addClsData(classGB, deptID, deptNm, ownerID, ownerNm, ownerPos, ownerCall, brdNm, companyID, brdNm2, isCompany,
				tenantID);
		return true;
	}

	@Override
	public void addClsData(String classGB, String deptID, String deptNm, String ownerID, String ownerNm,
			String ownerPos, String ownerCall, String brdNm, String companyID, String brdNm2, String isCompany,
			int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_ClassGB", classGB);
		map.put("v_P_ODeptID", deptID);
		map.put("v_P_ODeptNm", deptNm);
		map.put("v_P_OwnerID", ownerID);
		map.put("v_P_OwnerNm", ownerNm);
		map.put("v_P_OwnerPos", ownerPos);
		map.put("v_P_OwnerCall", ownerCall);
		map.put("v_P_Brd_NM", brdNm);
		map.put("v_P_CompanyID", companyID);
		map.put("v_P_Brd_NM2", brdNm2);
		map.put("v_P_IS_COMPANY", isCompany);
		map.put("tenantID", tenantID);

		int carID = 0;

		if (isCompany.equals("Y")) {
			carID = 1;
		} else {
			carID = ezCarAdminDAO.addClsData_S1(map);
		}

		int brdLevel = ezCarAdminDAO.addClsData_S2(map);
		int brdStep = ezCarAdminDAO.addClsData_S3(map);

		map.put("v_Brd_ID", carID);
		map.put("v_Brd_Level", brdLevel);
		map.put("v_Brd_Step", brdStep);
		ezCarAdminDAO.addClsData_I1(map);
		ezCarAdminDAO.addClsData_I2(map);
		ezCarAdminDAO.addClsData_I3(map);
		// ezResourceAdminDAO.addClsData(map);
	}

	@Override
	public CarGetSubClsListVO getBrdInfo(int brdID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBRDID", brdID);
		map.put("v_PCOMPANYID", companyID);
		map.put("tenantID", tenantID);
		return ezCarAdminDAO.getBrdInfo(map);
	}

	public boolean modifyClsData(String xmlStr, int tenantID) throws Exception {
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);

		String classGB = xmlRes.getElementsByTagName("DATA").item(0).getTextContent().trim();
		String deptID = xmlRes.getElementsByTagName("DATA").item(1).getTextContent().trim();
		String deptNm = xmlRes.getElementsByTagName("DATA").item(2).getTextContent().trim();
		String ownerID = xmlRes.getElementsByTagName("DATA").item(3).getTextContent().trim();
		String ownerNm = xmlRes.getElementsByTagName("DATA").item(4).getTextContent().trim();
		String ownerPos = xmlRes.getElementsByTagName("DATA").item(5).getTextContent().trim();
		String ownerCall = xmlRes.getElementsByTagName("DATA").item(6).getTextContent().trim();
		String brdNm = xmlRes.getElementsByTagName("DATA").item(7).getTextContent();
		/*
		 * String brdExplain =
		 * xmlRes.getElementsByTagName("DATA").item(8).getTextContent().trim();
		 */
		String accessNoty = xmlRes.getElementsByTagName("DATA").item(8).getTextContent().trim();
		String companyID = xmlRes.getElementsByTagName("DATA").item(9).getTextContent().trim();
		String brdNm2 = xmlRes.getElementsByTagName("DATA").item(10).getTextContent().trim();

		modifyClsData(classGB, deptID, deptNm, ownerID, ownerNm, ownerPos, ownerCall, brdNm, accessNoty,
				companyID, brdNm2, tenantID);
		return true;
	}

	@Override
	public void modifyClsData(String brdID, String deptID, String deptNm, String ownerID, String ownerNm,
			String ownerPos, String ownerCall, String brdNm, String accessNoty, String companyID,
			String brdNm2, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_Brd_ID", brdID);
		map.put("v_P_ODeptID", deptID);
		map.put("v_P_ODeptNm", deptNm);
		map.put("v_P_OwnerID", ownerID);
		map.put("v_P_OwnerNm", ownerNm);
		map.put("v_P_OwnerPos", ownerPos);
		map.put("v_P_OwnerCall", ownerCall);
		map.put("v_P_Brd_NM", brdNm);
		/* map.put("v_P_Brd_Explain", brdExplain); */
		map.put("v_P_AccessNoty", accessNoty);
		map.put("v_P_CompanyID", companyID);
		map.put("v_P_Brd_NM2", brdNm2);
		map.put("tenantID", tenantID);
		ezCarAdminDAO.modifyClsData(map);
	}

	@Override
	public List<CarGetClsAclListVO> getClsAclList(String brdID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_Brd_ID", brdID);
		map.put("v_P_CompanyID", companyID);
		map.put("tenantID", tenantID);
		return ezCarAdminDAO.getClsAclList(map);
	}

	public String getClsACLList(String xmlStr, int tenantID) throws Exception {
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		String strBrdID = "";
		String strCompanyID = "";

		strBrdID = xmlRes.getElementsByTagName("PARA_DATA").item(0).getChildNodes().item(0).getTextContent().trim();
		strCompanyID = xmlRes.getElementsByTagName("PARA_DATA").item(0).getChildNodes().item(1).getTextContent().trim();

		List<CarGetClsAclListVO> clsACLList = getClsAclList(strBrdID, strCompanyID, tenantID);

		StringBuilder returnXMLBld = new StringBuilder();
		returnXMLBld.append("<RTN_DATA>");
		for (int i = 0; i < clsACLList.size(); i++) {
			returnXMLBld.append("<NODE>");
			returnXMLBld.append("<ATTRIBUTE>" + clsACLList.get(i).getDeptYn() + "</ATTRIBUTE>");
			returnXMLBld.append("<ATTRIBUTE>" + clsACLList.get(i).getSdaYn() + "</ATTRIBUTE>");
			returnXMLBld
					.append("<ATTRIBUTE>" + commonUtil.cleanValue(clsACLList.get(i).getMemberNam()) + "</ATTRIBUTE>");
			returnXMLBld.append("<ATTRIBUTE>" + clsACLList.get(i).getMemberID() + "</ATTRIBUTE>");
			returnXMLBld.append("<ATTRIBUTE>" + clsACLList.get(i).getAccessLvl() + "</ATTRIBUTE>");
			returnXMLBld.append("</NODE>");
		}

		returnXMLBld.append("</RTN_DATA>");
		return returnXMLBld.toString();
	}

	public boolean userResPermissionCheck(String xmlStr, int tenantID) throws Exception {
		logger.debug("userResPermissionCheck start");

		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);

		String resID = xmlRes.getElementsByTagName("ROW_DATA").item(0).getAttributes().getNamedItem("ResID")
				.getTextContent();
		String companyID = xmlRes.getElementsByTagName("ROW_DATA").item(0).getAttributes().getNamedItem("CompanyID")
				.getTextContent();

		int brdCnt = ezCarService.getBrdCnt(Integer.parseInt(resID), companyID, tenantID);

		// 하위 자원이 없으면 삭제 가능
		if (brdCnt == 0) {
			logger.debug("There is no child resources");
			return true;
		}

		List<CarBrdListVO> brdList = ezCarService.getBrdList(brdCnt, Integer.parseInt(resID), companyID, "OwnDeptNm",
				"OwnerNm", "OwnerPosition", "Brd_NM", tenantID);

		for (int j = 0; j < brdList.size(); j++) {
			String[] ownerList = brdList.get(j).getOwnerID().split(",");
			for (int k = 0; k < ownerList.length; k++) {
				boolean flag = false;
				logger.debug("current resource manager : " + ownerList[k]);
				for (int i = 0; i < xmlRes.getElementsByTagName("ROW_DATA").getLength(); i++) {
					String memberID = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes()
							.getNamedItem("Member_ID").getTextContent();
					String deptYN = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes()
							.getNamedItem("Dept_YN").getTextContent();

					// 권한 중 everyone이 있는 경우 true로 리턴
					if (memberID.equals("everyone")) {
						logger.debug("This Resource Group has everyone privilege");
						return true;
					}

					if (deptYN.equals("Y")) {
						if (memberID.equals(ownerList[k])) {
							logger.debug("user id : " + memberID + ", This user has access privilege");
							flag = true;
						}
					} else {
						// 부서 권한 체크
						String deptSDA = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes()
								.getNamedItem("SDA_YN").getTextContent();
						String deptID = ezOrganService.getUserOrgDeptId(ownerList[k], tenantID, companyID);

						if (memberID.equals(deptID)) { // 현재 부서
							logger.debug("dept id : " + memberID + ", This dept has access privilege");
							flag = true;
						} else { // 상위 부서
							String deptPath = ezOrganService.getDeptPath(deptID, tenantID);

							List<String> deptIds = new ArrayList<String>();
							Collections.addAll(deptIds, deptPath.split(","));
							// deptIds.remove(0); // companyID 삭제
							if (deptIds.size() > 0) {
								Collections.reverse(deptIds);
								deptIds.remove(0); // 부서 ID 삭제

								for (int l = 0; l < deptIds.size(); l++) {
									if (memberID.equals(deptIds.get(l)) && deptSDA.equals("Y")) { // 현재 부서
										logger.debug("dept(2) id : " + memberID + ", This dept has access privilege");
										flag = true;
									}
								}
							}

							// 사내 겸직 권한 체크
							List<OrganUserVO> userAddJobList = ezOrganAdminService.getUserAddJobList(ownerList[k], "1",
									tenantID);

							for (int m = 0; m < userAddJobList.size(); m++) {
								if (userAddJobList.get(m).getDepartment().equals(memberID)) {
									logger.debug("add job dept id : " + memberID + ", This dept has access privilege");
									flag = true;
								}

								String addJobDeptPath = ezOrganService
										.getDeptPath(userAddJobList.get(m).getDepartment(), tenantID);

								List<String> addJobDeptIds = new ArrayList<String>();
								Collections.addAll(addJobDeptIds, addJobDeptPath.split(","));
								// addJobDeptIds.remove(0); // companyID 삭제
								if (addJobDeptIds.size() > 0) {
									Collections.reverse(addJobDeptIds);
									addJobDeptIds.remove(0); // 부서 ID 삭제

									for (int l = 0; l < addJobDeptIds.size(); l++) {
										if (memberID.equals(addJobDeptIds.get(l)) && deptSDA.equals("Y")) { // 현재 부서
											logger.debug("add job dept(2) id : " + memberID
													+ ", This dept has access privilege");
											flag = true;
										}
									}
								}
							}
						}
					}
				}
				if (!flag) {
					logger.debug("This user has no access privilege. save fail");
					return false;
				}
			}
		}

		logger.debug("userResPermissionCheck end");
		return true;
	}

	public boolean saveACLLst(String xmlStr, int tenantID) throws Exception {
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		boolean bDelete = false;

		String resID = "";
		String deptYN = "";
		String SDAYN = "";
		String memberNam = "";
		String memberID = "";
		String accessLvl = "";
		String companyID = "";

		for (int i = 0; i < xmlRes.getElementsByTagName("ROW_DATA").getLength(); i++) {
			resID = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes().getNamedItem("ResID")
					.getTextContent();
			deptYN = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes().getNamedItem("Dept_YN")
					.getTextContent();
			SDAYN = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes().getNamedItem("SDA_YN")
					.getTextContent();
			memberNam = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes().getNamedItem("Member_nam")
					.getTextContent();
			memberID = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes().getNamedItem("Member_ID")
					.getTextContent();
			accessLvl = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes().getNamedItem("Access_lvl")
					.getTextContent();
			companyID = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes().getNamedItem("CompanyID")
					.getTextContent();

			if (bDelete == false) {
				delResAcll(resID, companyID, tenantID);
				bDelete = true;
			}
			saveACL(resID, deptYN, SDAYN, memberNam, memberID, accessLvl, companyID, tenantID);
		}
		return true;
	}

	@Override
	public void delResAcll(String resID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_RESID", resID);
		map.put("v_P_COMPANYID", companyID);
		map.put("tenantID", tenantID);
		ezCarAdminDAO.delResAcll(map);
	}

	@Override
	public void saveACL(String resID, String deptYn, String sdaYn, String memberNam, String memberID, String accessLvl,
			String companyID, int tenantID) throws Exception {
		logger.debug("saveACL Start");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_ResID", resID);
		map.put("v_P_Dept_YN", deptYn);
		map.put("v_P_SDA_YN", sdaYn);
		map.put("v_P_Member_nam", memberNam);
		map.put("v_P_Member_ID", memberID);
		map.put("v_P_Access_lvl", accessLvl);
		map.put("v_P_CompanyID", companyID);
		map.put("tenantID", tenantID);

		int result = ezCarAdminDAO.saveACL_U(map);
		logger.debug("result=" + result);
		if (result == 0) {
			ezCarAdminDAO.saveACL(map);
		}
		logger.debug("saveACL End");
		// ezResourceAdminDAO.saveACL(map);
	}

	@Override
	public int getSubResCnt(String resID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("resID", resID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		return ezCarAdminDAO.getSubResCnt(map);
	}

	@Override
	public int getSubClsCnt(String resID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("resID", resID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		return ezCarAdminDAO.getSubClsCnt(map);
	}

	public String getSubCntOfCls(String xmlStr, int tenantID) throws Exception {
		String resID = "";
		String companyID = "";
		int resCnt = 0;
		int clsCnt = 0;
		StringBuilder returnXML = new StringBuilder();
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);

		resID = xmlRes.getElementsByTagName("PARA_DATA").item(0).getChildNodes().item(0).getTextContent().trim();
		companyID = xmlRes.getElementsByTagName("PARA_DATA").item(0).getChildNodes().item(1).getTextContent().trim();

		resCnt = getSubResCnt(resID, companyID, tenantID);
		clsCnt = getSubClsCnt(resID, companyID, tenantID);

		returnXML.append("<RTN_DATA>");
		returnXML.append("<ERRCHK>True</ERRCHK>");
		returnXML.append("<ERRDESC></ERRDESC>");
		returnXML.append("<SUBRESCNT>" + resCnt + "</SUBRESCNT>");
		returnXML.append("<SUBCLSCNT>" + clsCnt + "</SUBCLSCNT>");
		returnXML.append("</RTN_DATA>");

		return returnXML.toString();
	}

	@Override
	public void delClsData(String carID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("carID", carID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);

		 ezCarAdminDAO.deleteClass(map);
		
		 //ezCarAdminDAO.delClsData_U1(map); 
		 ezCarAdminDAO.delClsData_D5(map);
		 
		//ezCarAdminDAO.delClsData(map); 
	}

	public boolean delClsData(String xmlStr, int tenantID) throws Exception {
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		String carID = "";
		String strCompanyID = "";

		carID = xmlRes.getElementsByTagName("DATA").item(0).getTextContent();
		strCompanyID = xmlRes.getElementsByTagName("DATA").item(1).getTextContent();

		delClsData(carID, strCompanyID, tenantID);
		return true;

	}


}
