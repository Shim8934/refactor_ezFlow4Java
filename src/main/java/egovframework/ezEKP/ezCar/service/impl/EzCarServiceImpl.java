package egovframework.ezEKP.ezCar.service.impl;


import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCar.dao.EzCarDAO;
import egovframework.ezEKP.ezCar.service.EzCarService;
import egovframework.ezEKP.ezCar.vo.CarBrdListVO;
import egovframework.ezEKP.ezCar.vo.CarBrdVO;
import egovframework.ezEKP.ezCar.vo.CarFormListVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezCar.vo.CarGetAdmSubClsTreeVO;
import egovframework.ezEKP.ezResource.vo.ResGetAdminFlagVO;
import egovframework.ezEKP.ezResource.vo.ResGetClsAclListVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("EzCarService")
public class EzCarServiceImpl extends EgovAbstractServiceImpl implements EzCarService{
	
	private static final Logger logger = LoggerFactory.getLogger(EzCarServiceImpl.class);
	
	@Resource(name="EzCarDAO")
	private EzCarDAO ezCarDAO;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Autowired
	private EzOrganService ezOrganService;

	@Override
	public String getSubClsTree(String xmlStr, String langStr, String pComID, String pDeptID, String pUserID, int tenantID) throws Exception {
        String strUserID = "";
        String userAdminFlag = "";
        String strAdminType = "";
   
        Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
        String strParentID = xmlRes.getElementsByTagName("PARENT_ID").item(0).getTextContent().trim();
        String strCompanyID = xmlRes.getElementsByTagName("COMPANY_ID").item(0).getTextContent().trim();
         String strAccessFlag = xmlRes.getElementsByTagName("ACCESS_FLAG").item(0).getTextContent().trim();
        String strFirstNode = xmlRes.getElementsByTagName("FIRST_NODE").item(0).getTextContent().trim();
        String strTreeType = xmlRes.getElementsByTagName("TREE_TYPE").item(0).getTextContent().trim();
        if(strTreeType.equals("0")) {
        	strAdminType = xmlRes.getElementsByTagName("ADMIN_CHECK").item(0).getTextContent().trim();
        }

        if(xmlRes.getElementsByTagName("BRDLIST").getLength() > 5) {
        	strUserID = xmlRes.getElementById("BRDLIST").getChildNodes().item(5).getTextContent().trim();
        }
        
        if(strAdminType.equals("Y")) {
        	userAdminFlag = getAdminFlag(pComID, strParentID, pUserID, tenantID, pDeptID);
        	//userAdminFlag = "Y";
        }
        
        List<CarGetAdmSubClsTreeVO> carGetAdmSubClsTree = new ArrayList<CarGetAdmSubClsTreeVO>();
          if(strAccessFlag.equals("0")) {
         	carGetAdmSubClsTree = getAdmSubClsTree(strParentID, strCompanyID, strTreeType, tenantID, userAdminFlag);
         } else {
         	carGetAdmSubClsTree = getSubClsTree(strParentID, strCompanyID, strTreeType, strUserID, pComID, pDeptID, pUserID, tenantID);
         }
        
        
        StringBuilder strTreeStyle = new StringBuilder();
        if(strFirstNode.equals("Y")) {
        	strTreeStyle.append("<TREEVIEWDATA>");
        	strTreeStyle.append("<TEXTCOLOR>");
        	strTreeStyle.append("<NAME>ENTUMTEXTCOLOR</NAME>");
        	strTreeStyle.append("<DEFAULT></DEFAULT>");
        	strTreeStyle.append("<DEFAULTTEXTCOLOR>black</DEFAULTTEXTCOLOR>");					
        	strTreeStyle.append("<DEFAULTBGCOLOR>ffffff</DEFAULTBGCOLOR>");
        	strTreeStyle.append("<SELECTEDTEXTCOLOR>164AAD</SELECTEDTEXTCOLOR>");
        	strTreeStyle.append("<SELECTEDBGCOLOR>ffffff</SELECTEDBGCOLOR>");
        	strTreeStyle.append("<HOTTRACKINGTEXTCOLOR>164AAD</HOTTRACKINGTEXTCOLOR>");
        	strTreeStyle.append("<HOTTRACKINGBGCOLOR>ffffff</HOTTRACKINGBGCOLOR>");
        	strTreeStyle.append("</TEXTCOLOR>");
        	strTreeStyle.append("<NODEICONIMAGE>");
        	strTreeStyle.append("<NAME>RESCLASS</NAME>");
        	strTreeStyle.append("<DEFAULT></DEFAULT>");
        	strTreeStyle.append("<LEAFDEFAULTICON>/images/left/tree_01.gif</LEAFDEFAULTICON>");
        	strTreeStyle.append("<LEAFSELECTEDICON>/images/left/tree_01.gif</LEAFSELECTEDICON>");
        	strTreeStyle.append("<BRANCHDEFAULTICON>/images/left/tree_01.gif</BRANCHDEFAULTICON>");
        	strTreeStyle.append("<BRANCHSELECTEDICON>/images/left/tree_01.gif</BRANCHSELECTEDICON>");
        	strTreeStyle.append("</NODEICONIMAGE>");
        	strTreeStyle.append("<NODEICONIMAGE>");
        	strTreeStyle.append("<NAME>RESOURCE</NAME>");
        	strTreeStyle.append("<DEFAULT></DEFAULT>");
        	strTreeStyle.append("<LEAFDEFAULTICON>/images/left/tree_02.gif</LEAFDEFAULTICON>");
        	strTreeStyle.append("<LEAFSELECTEDICON>/images/left/tree_02.gif</LEAFSELECTEDICON>");
        	
        	strTreeStyle.append("<BRANCHDEFAULTICON>/images/left/tree_02.gif</BRANCHDEFAULTICON>");
        	strTreeStyle.append("<BRANCHSELECTEDICON>/images/left/tree_02.gif</BRANCHSELECTEDICON>");
        	strTreeStyle.append("</NODEICONIMAGE>");
        	strTreeStyle.append("<HERITAGEICONIMAGE>");
        	strTreeStyle.append("<DEFAULT></DEFAULT>");
        	strTreeStyle.append("<BLANKICON>/images/left/blank.gif</BLANKICON>");
        	strTreeStyle.append("<VERTICALLINEICON>/images/left/vline.gif</VERTICALLINEICON>");
        	strTreeStyle.append("<NODEICON>/images/left/02.gif</NODEICON>");
        	strTreeStyle.append("<MNODEICON>/images/left/02_minus.gif</MNODEICON>");
        	strTreeStyle.append("<PNODEICON>/images/left/02_plus.gif</PNODEICON>");
        	strTreeStyle.append("<ROOTNODEICON>/images/left/03.gif</ROOTNODEICON>");
        	strTreeStyle.append("<MROOTNODEICON>/images/left/03_minus.gif</MROOTNODEICON>");
        	strTreeStyle.append("<PROOTNODEICON>/images/left/03_plus.gif</PROOTNODEICON>");
        	strTreeStyle.append("<LASTNODEICON>/images/left/03.gif</LASTNODEICON>");
        	strTreeStyle.append("<MLASTNODEICON>/images/left/03_minus.gif</MLASTNODEICON>");
        	strTreeStyle.append("<FIRSTROOTNODEICON>/images/left/02.gif</FIRSTROOTNODEICON>");
        	strTreeStyle.append("<MFIRSTROOTNODEICON>/images/left/02_minus.gif</MFIRSTROOTNODEICON>");
        	strTreeStyle.append("<PFIRSTROOTNODEICON>/images/left/02_plus.gif</PFIRSTROOTNODEICON>");
        	strTreeStyle.append("</HERITAGEICONIMAGE>");
        }
        else {
        	strTreeStyle.append("<NODES>");
        }
        if(strFirstNode.equals("Y")) {
        	for(int i = 0; i < carGetAdmSubClsTree.size(); i++) {
        		if(i == 0) {
        			strTreeStyle.append(makeNodesFromADOFlds(commonUtil.getQueryResult(carGetAdmSubClsTree.get(i)), true, langStr));
        		} else {
        			/*if(carGetAdmSubClsTree.get(i).getApproveFlag().equals("2")) {*/
            			if(userAdminFlag.equals("Y")) {
            				strTreeStyle.append(makeNodesFromADOFlds(commonUtil.getQueryResult(carGetAdmSubClsTree.get(i)), false, langStr));
            			}
            		/*} */
        			else {
        				strTreeStyle.append(makeNodesFromADOFlds(commonUtil.getQueryResult(carGetAdmSubClsTree.get(i)), false, langStr));
        			}
        		}
        	}
        	strTreeStyle.append("</TREEVIEWDATA>");
        } else {
        	for(int i=0; i<carGetAdmSubClsTree.size(); i++) {
        		// approveflag = 2이면서 관리자 아니면 값 빼기
        		/*if(carGetAdmSubClsTree.get(i).getApproveFlag().equals("2")) {
        			if(userAdminFlag.equals("Y")) {
        				strTreeStyle.append(makeNodesFromADOFlds(commonUtil.getQueryResult(carGetAdmSubClsTree.get(i)), false, langStr));
        			}
        		} else {*/
        		strTreeStyle.append(makeNodesFromADOFlds(commonUtil.getQueryResult(carGetAdmSubClsTree.get(i)), false, langStr));
        	}
        	strTreeStyle.append("</NODES>");
        }
		return strTreeStyle.toString();
	}
	
	
	@Override
	public String getSubClsTreeUser(String xmlStr, String langStr, String pComID, String pDeptID, String pUserID, int tenantID) throws Exception {
		String strUserID = "";
		String userAdminFlag = "";
		String strAdminType = "";
		
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		String strParentID = xmlRes.getElementsByTagName("PARENT_ID").item(0).getTextContent().trim();
		String strCompanyID = xmlRes.getElementsByTagName("COMPANY_ID").item(0).getTextContent().trim();
		String strAccessFlag = xmlRes.getElementsByTagName("ACCESS_FLAG").item(0).getTextContent().trim();
		String strFirstNode = xmlRes.getElementsByTagName("FIRST_NODE").item(0).getTextContent().trim();
		String strTreeType = xmlRes.getElementsByTagName("TREE_TYPE").item(0).getTextContent().trim();
		if(strTreeType.equals("0")) {
			strAdminType = xmlRes.getElementsByTagName("ADMIN_CHECK").item(0).getTextContent().trim();
		}
		
		if(xmlRes.getElementsByTagName("BRDLIST").getLength() > 5) {
			strUserID = xmlRes.getElementById("BRDLIST").getChildNodes().item(5).getTextContent().trim();
		}
		
		if(strAdminType.equals("Y")) {
			userAdminFlag = getAdminFlag(pComID, strParentID, pUserID, tenantID, pDeptID);
			//userAdminFlag = "Y";
		}
		
		List<CarGetAdmSubClsTreeVO> carGetAdmSubClsTree = new ArrayList<CarGetAdmSubClsTreeVO>();
		if(strAccessFlag.equals("0")) {
			String jobs = getAddJob(pUserID, tenantID);
			String jobss = "";

			if(StringUtils.isNotEmpty(jobs)){ //겸직정보가있으면 
				if("".equals(jobs)) {
					jobss = "'"+pUserID+"','"+pDeptID+"','everyone'";
				}
				else{String jobArr[] = jobs.split(";"); //겸직부서 정보를 배열로 담는다 ex);sfctest01:사원:사원  [,sfctest01:tk]
				for(int i=0; i<jobArr.length; i++){
					if(jobArr[i].equals("")||jobArr[i]==null)
						continue;
					
					int idx = jobArr[i].indexOf(":"); 
					jobss += "'"+jobArr[i].substring(0,idx)+"',";//:앞에서 잘라서 부서명만 가져온뒤 , 쉼표를 붙이면서 합친다.
				}
				jobss = jobss.substring(0, jobss.length()-1);//마지막 쉼표 자르기
				jobss = jobss+",'"+pUserID+"','"+pDeptID+"','everyone'";
				}
			}else{ //겸직정보없으면
				jobss = "'"+pUserID+"','"+pDeptID+"','everyone'";
			}
			carGetAdmSubClsTree = getAdmSubClsTreeUser(strParentID, strCompanyID, strTreeType, tenantID, userAdminFlag, pUserID, pDeptID, jobss);

		} else {
			carGetAdmSubClsTree = getSubClsTree(strParentID, strCompanyID, strTreeType, strUserID, pComID, pDeptID, pUserID, tenantID);
		}
		
		
		StringBuilder strTreeStyle = new StringBuilder();
		if(strFirstNode.equals("Y")) {
			strTreeStyle.append("<TREEVIEWDATA>");
			strTreeStyle.append("<TEXTCOLOR>");
			strTreeStyle.append("<NAME>ENTUMTEXTCOLOR</NAME>");
			strTreeStyle.append("<DEFAULT></DEFAULT>");
			strTreeStyle.append("<DEFAULTTEXTCOLOR>black</DEFAULTTEXTCOLOR>");					
			strTreeStyle.append("<DEFAULTBGCOLOR>ffffff</DEFAULTBGCOLOR>");
			strTreeStyle.append("<SELECTEDTEXTCOLOR>164AAD</SELECTEDTEXTCOLOR>");
			strTreeStyle.append("<SELECTEDBGCOLOR>ffffff</SELECTEDBGCOLOR>");
			strTreeStyle.append("<HOTTRACKINGTEXTCOLOR>164AAD</HOTTRACKINGTEXTCOLOR>");
			strTreeStyle.append("<HOTTRACKINGBGCOLOR>ffffff</HOTTRACKINGBGCOLOR>");
			strTreeStyle.append("</TEXTCOLOR>");
			strTreeStyle.append("<NODEICONIMAGE>");
			strTreeStyle.append("<NAME>RESCLASS</NAME>");
			strTreeStyle.append("<DEFAULT></DEFAULT>");
			strTreeStyle.append("<LEAFDEFAULTICON>/images/left/tree_01.gif</LEAFDEFAULTICON>");
			strTreeStyle.append("<LEAFSELECTEDICON>/images/left/tree_01.gif</LEAFSELECTEDICON>");
			strTreeStyle.append("<BRANCHDEFAULTICON>/images/left/tree_01.gif</BRANCHDEFAULTICON>");
			strTreeStyle.append("<BRANCHSELECTEDICON>/images/left/tree_01.gif</BRANCHSELECTEDICON>");
			strTreeStyle.append("</NODEICONIMAGE>");
			strTreeStyle.append("<NODEICONIMAGE>");
			strTreeStyle.append("<NAME>RESOURCE</NAME>");
			strTreeStyle.append("<DEFAULT></DEFAULT>");
			strTreeStyle.append("<LEAFDEFAULTICON>/images/left/tree_02.gif</LEAFDEFAULTICON>");
			strTreeStyle.append("<LEAFSELECTEDICON>/images/left/tree_02.gif</LEAFSELECTEDICON>");
			
			strTreeStyle.append("<BRANCHDEFAULTICON>/images/left/tree_02.gif</BRANCHDEFAULTICON>");
			strTreeStyle.append("<BRANCHSELECTEDICON>/images/left/tree_02.gif</BRANCHSELECTEDICON>");
			strTreeStyle.append("</NODEICONIMAGE>");
			strTreeStyle.append("<HERITAGEICONIMAGE>");
			strTreeStyle.append("<DEFAULT></DEFAULT>");
			strTreeStyle.append("<BLANKICON>/images/left/blank.gif</BLANKICON>");
			strTreeStyle.append("<VERTICALLINEICON>/images/left/vline.gif</VERTICALLINEICON>");
			strTreeStyle.append("<NODEICON>/images/left/02.gif</NODEICON>");
			strTreeStyle.append("<MNODEICON>/images/left/02_minus.gif</MNODEICON>");
			strTreeStyle.append("<PNODEICON>/images/left/02_plus.gif</PNODEICON>");
			strTreeStyle.append("<ROOTNODEICON>/images/left/03.gif</ROOTNODEICON>");
			strTreeStyle.append("<MROOTNODEICON>/images/left/03_minus.gif</MROOTNODEICON>");
			strTreeStyle.append("<PROOTNODEICON>/images/left/03_plus.gif</PROOTNODEICON>");
			strTreeStyle.append("<LASTNODEICON>/images/left/03.gif</LASTNODEICON>");
			strTreeStyle.append("<MLASTNODEICON>/images/left/03_minus.gif</MLASTNODEICON>");
			strTreeStyle.append("<FIRSTROOTNODEICON>/images/left/02.gif</FIRSTROOTNODEICON>");
			strTreeStyle.append("<MFIRSTROOTNODEICON>/images/left/02_minus.gif</MFIRSTROOTNODEICON>");
			strTreeStyle.append("<PFIRSTROOTNODEICON>/images/left/02_plus.gif</PFIRSTROOTNODEICON>");
			strTreeStyle.append("</HERITAGEICONIMAGE>");
		}
		else {
			strTreeStyle.append("<NODES>");
		}
		if(strFirstNode.equals("Y")) {
			for(int i = 0; i < carGetAdmSubClsTree.size(); i++) {
				if(i == 0) {
					strTreeStyle.append(makeNodesFromADOFlds(commonUtil.getQueryResult(carGetAdmSubClsTree.get(i)), true, langStr));
				} else {
					/*if(carGetAdmSubClsTree.get(i).getApproveFlag().equals("2")) {*/
					if(userAdminFlag.equals("Y")) {
						strTreeStyle.append(makeNodesFromADOFlds(commonUtil.getQueryResult(carGetAdmSubClsTree.get(i)), false, langStr));
					}
					/*} */
					else {
						strTreeStyle.append(makeNodesFromADOFlds(commonUtil.getQueryResult(carGetAdmSubClsTree.get(i)), false, langStr));
					}
				}
			}
			strTreeStyle.append("</TREEVIEWDATA>");
		} else {
			for(int i=0; i<carGetAdmSubClsTree.size(); i++) {
				// approveflag = 2이면서 관리자 아니면 값 빼기
				/*if(carGetAdmSubClsTree.get(i).getApproveFlag().equals("2")) {
        			if(userAdminFlag.equals("Y")) {
        				strTreeStyle.append(makeNodesFromADOFlds(commonUtil.getQueryResult(carGetAdmSubClsTree.get(i)), false, langStr));
        			}
        		} else {*/
				strTreeStyle.append(makeNodesFromADOFlds(commonUtil.getQueryResult(carGetAdmSubClsTree.get(i)), false, langStr));
			}
			strTreeStyle.append("</NODES>");
		}
		return strTreeStyle.toString();
	}
	
	
	
/*	public ResGetAdminFlagVO getAdmFlag(String companyID, String resID,String memberID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("resID", resID);
		map.put("memberID", memberID);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getAdmFlag(map);
	}
	*/
	
	
	/*@Override
	public String getAdminFlag(String companyID, String brdID, String userID, int tenantID, String deptID) throws Exception {
		String accessLvl = "";
		

		 2018-07-13 홍승비 - everyone을 관리자로 설정한 경우 우선적으로 해당 관리자 플래그 받아오도록 수정 
		ResGetAdminFlagVO resGetAdminFlag = getAdmFlag(companyID, brdID, userID, tenantID);
		
		if (resGetAdminFlag != null && resGetAdminFlag.getAccessLvl() != null && !resGetAdminFlag.getAccessLvl().equals("")) {
			String strXML = "<DATA>"+commonUtil.getQueryResult(resGetAdminFlag)+"</DATA>";
			Document xmlDom = commonUtil.convertStringToDocument(strXML);
			
			if(xmlDom.getElementsByTagName("ROW") != null) {
				for(int i=0; i<xmlDom.getElementsByTagName("ROW").getLength(); i++) {
					accessLvl = xmlDom.getElementsByTagName("ACCESSLVL").item(i).getTextContent().trim();
				}
			}
			
			logger.debug("everyone or user accessLvl : " + accessLvl);
		}
			if(accessLvl.equals("1")) {			// everyone 혹은 user 권한이 관리자 이면 Y 리턴, 그 외 U + 부서권한 체크
				return "Y";
			} else {
				//해안
				String vTenantID = String.valueOf(tenantID);
				Map<String,Object> deptAccessLvlMap = new HashMap<String, Object>();
				deptAccessLvlMap.put("IN_DEPT_CN", deptID);
				deptAccessLvlMap.put("IN_TENANT_ID", vTenantID);
				deptAccessLvlMap.put("IN_BRD_ID", brdID);
				logger.debug("deptID : " + deptID + " tenant_id : " + vTenantID + " brd_ID : " + brdID);
				
				ezResourceDAO.getDeptAccessLvl(deptAccessLvlMap);
				
				String AccessDeptLvl = deptAccessLvlMap.get("OUT_RESULT_ACL").toString();
				logger.debug("AccessDeptLvl : " + AccessDeptLvl);
				
				if (AccessDeptLvl != null && !AccessDeptLvl.equals("") && AccessDeptLvl.equals("1")) {
					accessLvl = AccessDeptLvl;
				}
			} 
			else {		// 아이디 혹은 everyone에서 관리자 권한 있을 때
				return "Y";
			}
		else {	//부서의 관리자 권한 확인
			Map<String,Object> map = new HashMap<String, Object>();
			map.put("v_PCOMPANYID", companyID);
			map.put("v_BRD_UPPER", brdID);
			map.put("tenantID", tenantID);
			
			String deptPath = ezOrganService.getDeptPath(deptID, tenantID);
			List<String> deptIds = new ArrayList<String>();
			Collections.addAll(deptIds, deptPath.split(","));
			//deptIds.remove(0);				// companyID 삭제
			if(deptIds.size() > 0) {
				Collections.reverse(deptIds);
				
				map.put("v_PUSERID", deptIds.get(0));
				String deptAccLvl = ezResourceDAO.getAclTblBrd_S3(map);
					
				if(deptAccLvl != null && deptAccLvl.trim().equals("1")) {
					logger.debug("user dept accessLvl = admin");
					return "Y";
				}
				else {
					if (deptAccLvl != null && deptAccLvl.trim().equals("2")) {
						logger.debug("user dept accessLvl = user");
						accessLvl = "2";
					}
					// 부서 상위 권한 체크
					deptIds.remove(0);				// 현재 부서ID 삭제
					if(deptIds.size() > 0) {
						String newDeptPath = "'" + String.join(",", deptIds).trim().replace(",", "', '") + "'";
						
						map.put("v_PUSERID", newDeptPath);
						List<ResGetClsAclListVO> deptAclList = ezResourceDAO.getDeptAcl(map);
		
						if(deptAclList != null) {
							for(int i=0; i<deptAclList.size(); i++) {
								if(deptAclList.get(i).getAccessLvl().equals("1")) {
									logger.debug("user upper dept accessLvl = admin");
									return "Y";
								}
								else {
									logger.debug("user upper dept accessLvl = user");
									accessLvl = "2";
								}
							}
						}
					}
				}
			}
			
			// 사내 겸직 권한 체크
			List<OrganUserVO> userAddJobList = ezOrganAdminService.getUserAddJobList(userID, "1", tenantID);

			if(userAddJobList.size() > 0) {
				for(int i=0; i<userAddJobList.size(); i++) {
					String addJobDeptPath = ezOrganService.getDeptPath(userAddJobList.get(i).getDepartment(), tenantID);
					List<String> addJobDeptIds = new ArrayList<String>();
					Collections.addAll(addJobDeptIds, addJobDeptPath.split(","));
					//addJobDeptIds.remove(0);				// companyID 삭제
					if(addJobDeptIds.size() > 0) {
						Collections.reverse(addJobDeptIds);
						
						map.put("v_PUSERID", addJobDeptIds.get(0));
						String addJobAccLvl = ezResourceDAO.getAclTblBrd_S3(map);
							
						if(addJobAccLvl != null && addJobAccLvl.trim().equals("1")) {
							logger.debug("user addjob dept accessLvl = admin");
							return "Y";
						}
						else {
							if (addJobAccLvl != null && addJobAccLvl.trim().equals("2")) {
								logger.debug("user addjob dept accessLvl = user");
								accessLvl = "2";
							} 
							// 부서 상위 권한 체크
							addJobDeptIds.remove(0);				// 현재 부서ID 삭제
							if(addJobDeptIds.size() > 0) {
								String newDeptPath = "'" + String.join(",", addJobDeptIds).trim().replace(",", "', '") + "'";
								
								map.put("v_PUSERID", newDeptPath);
								List<ResGetClsAclListVO> deptAclList = ezResourceDAO.getDeptAcl(map);
								
								if(deptAclList != null) {
									for(int j=0; j<deptAclList.size(); j++) {
										if(deptAclList.get(j).getAccessLvl().equals("1")) {
											logger.debug("user addjob upper dept accessLvl = admin");
											return "Y";
										}
										else {
											logger.debug("user addjob upper dept accessLvl = user");
											accessLvl = "2";
										}
									}
								}
							}
						}
					}
				}
			}
			
			 //해안
 			String vTenantID = String.valueOf(tenantID);
			Map<String,Object> deptAccessLvlMap = new HashMap<String, Object>();
			deptAccessLvlMap.put("IN_DEPT_CN", deptID);
			deptAccessLvlMap.put("IN_TENANT_ID", vTenantID);
			deptAccessLvlMap.put("IN_BRD_ID", brdID);
			logger.debug("deptID : " + deptID + " tenant_id : " + vTenantID + " brd_ID : " + brdID);
			
			ezResourceDAO.getDeptAccessLvl(deptAccessLvlMap);
			
			String AccessDeptLvl = deptAccessLvlMap.get("OUT_RESULT_ACL").toString();
			logger.debug("AccessDeptLvl : " + AccessDeptLvl);
			
			if (AccessDeptLvl != null && !AccessDeptLvl.equals("")) {
				accessLvl = AccessDeptLvl;
			} 
		}
		
		if(accessLvl.trim().equals("1")) {
			return "Y";
		} else if(accessLvl.trim().equals("2")) {
			return "U";
		} else {
			return "";
		}
	
	}*/
	
	
	/*public ResGetAdminFlagVO getAdmFlag(String companyID, String resID,String memberID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("resID", resID);
		map.put("memberID", memberID);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getAdmFlag(map);
	}*/
	public String getAddJob(String pUserID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
	    map.put("userID", pUserID);
	    map.put("tenantID", tenantID);
		return ezCarDAO.getAddJob(map);
	}
	
	public List<CarGetAdmSubClsTreeVO> getSubClsTree(String parentID, String companyID, String treeType, String pUserID, String comID, String deptID, String userID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_ParentID", parentID);
		map.put("v_P_CompanyID", companyID);
		map.put("v_P_TreeType", treeType);
		map.put("v_P_USERID", pUserID);
		map.put("v_PCOMID", comID);
		map.put("v_PDEPTID", deptID);
		map.put("v_PUSERID", userID);
		map.put("tenantID", tenantID);
		return ezCarDAO.getSubClsTree(map);
	}
	
	
	public List<CarGetAdmSubClsTreeVO> getAdmSubClsTree(String parentID,String companyID, String treeType, int tenantID, String adminType) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_ParentID", parentID);
		map.put("v_P_CompanyID", companyID);
		map.put("v_P_TreeType", treeType);
		map.put("tenantID", tenantID);
		if(adminType.equals("Y")) {
			map.put("adminType", adminType);
		}
		return ezCarDAO.getAdmSubClsTree(map);
	}
	
	public List<CarGetAdmSubClsTreeVO> getAdmSubClsTreeUser(String parentID,String companyID, String treeType, int tenantID, String adminType, String pUserID, String pDeptID, String jobss) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_ParentID", parentID);
		map.put("v_P_CompanyID", companyID);
		map.put("v_P_TreeType", treeType);
		map.put("tenantID", tenantID);
		if(adminType.equals("Y")) {
			map.put("adminType", adminType);
		}
		map.put("userID", pUserID);
		map.put("deptID", pDeptID);
		
		/* 2024-07-01 홍승비 - SQL Injection 수정 > $ 기호 제거, 배열로 전달 */
		map.put("jobss", jobss.replace("'", "").replace(" ", "").split(","));
		
		return ezCarDAO.getAdmSubClsTreeUser(map);
	}
	
	public String makeNodesFromADOFlds(String xmlStr, boolean blnFirstNode, String langStr) throws Exception{
		String returnXML = "";
        String strData2 = "";
        int intSubCnt = 0;
        String strIsLeaf = "";
        String strSetNodeIconByName = "";
        
        Document xmlRes = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
        xmlRes = commonUtil.convertStringToDocument(xmlStr);
        String strData1 = xmlRes.getElementsByTagName("CARID").item(0).getTextContent();
        
        if(langStr.equals("1")) {
        	strData2 = xmlRes.getElementsByTagName("CARNAME").item(0).getTextContent();
        } else {
        	strData2 = commonUtil.cleanValue(xmlRes.getElementsByTagName("CARNAME"+langStr).item(0).getTextContent());
        }
        String strData3 = xmlRes.getElementsByTagName("CARLEVEL").item(0).getTextContent();
        String strData4 = xmlRes.getElementsByTagName("CARSTEP").item(0).getTextContent();
        /*String strData5 = xmlRes.getElementsByTagName("CARPOSTTERM").item(0).getTextContent();*/
        String strData6 = xmlRes.getElementsByTagName("CARUPPER").item(0).getTextContent();
        String strData7 = xmlRes.getElementsByTagName("CARGB").item(0).getTextContent();
        String strData8 = xmlRes.getElementsByTagName("CARURL").item(0).getTextContent();
        String strData9 = xmlRes.getElementsByTagName("CAREXPLAIN").item(0).getTextContent();
        String strData10 = xmlRes.getElementsByTagName("CARACCESS").item(0).getTextContent();
       /* String strData11 = xmlRes.getElementsByTagName("ATTACHSIZE").item(0).getTextContent();*/
        String strData12 = xmlRes.getElementsByTagName("SUBCLSCNT").item(0).getTextContent();
        String strData13 = xmlRes.getElementsByTagName("SUBRESCNT").item(0).getTextContent();
        String strData14 = xmlRes.getElementsByTagName("ACCESSLVL").item(0).getTextContent();
       /* String strData15 = xmlRes.getElementsByTagName("APPROVEFLAG").item(0).getTextContent();*/
  
        intSubCnt = Integer.parseInt(strData12.trim()) + Integer.parseInt(strData13.trim());
        
        String strValue = strData2;
        String strStyle = "font-weight:normal;height:10px;";
        
        returnXML += "<NODE>";
        returnXML += makeXMLElement(strValue, "VALUE", false);
        returnXML += makeXMLElement(strStyle, "STYLE", false);
        returnXML += makeXMLElement(strData1, "DATA1", false);
        returnXML += makeXMLElement(strData2, "DATA2", false);
        returnXML += makeXMLElement(strData3, "DATA3", false);
        returnXML += makeXMLElement(strData4, "DATA4", false);
        /*returnXML += makeXMLElement(strData5, "DATA5", false);*/
        returnXML += makeXMLElement(strData6, "DATA6", false);
        returnXML += makeXMLElement(strData7, "DATA7", false);
        returnXML += makeXMLElement(strData8, "DATA8", false);
        returnXML += makeXMLElement(strData9, "DATA9", true);
        returnXML += makeXMLElement(strData10, "DATA10", false);
        /*returnXML += makeXMLElement(strData11, "DATA11", false);*/
        returnXML += makeXMLElement(strData12, "DATA12", false);
        returnXML += makeXMLElement(strData13, "DATA13", false);
        returnXML += makeXMLElement(strData14, "DATA14", false);
        /*returnXML += makeXMLElement(strData15, "DATA15", false);*/
        
        if(intSubCnt == 0) {
        	strIsLeaf = "TRUE";
        } else {
        	strIsLeaf = "FALSE";
        }
        
        if(strData7.equals("1")) {
        	strSetNodeIconByName = "RESCLASS";
        } else {
        	strSetNodeIconByName = "RESOURCE";
        }
        
        returnXML += makeXMLElement(strIsLeaf, "ISLEAF", false);
        returnXML += makeXMLElement(strSetNodeIconByName, "SETNODEICONBYNAME", false);
        returnXML += makeXMLElement("FALSE", "EXPANDED", false);
        
        if(blnFirstNode == true) {
        	returnXML += makeXMLElement("", "SELECT", true);
        }
        returnXML += "</NODE>";
		return returnXML;
	}
	
	public String makeXMLElement(String strElementText, String strElementName, boolean blnCData) {
		if(blnCData == true) {
			return "<"+strElementName+"><![CDATA["+strElementText+"]]></"+strElementName+">";
		} else {
			return "<"+strElementName+">"+strElementText+"</"+strElementName+">";
		}
	}



	@Override
	public int getTotalCnt(String carID, String companyID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("carID", carID);
		map.put("companyID", companyID);
		return ezCarDAO.getTotalCnt(map);
	}
	
	
	@Override
	public List<CarBrdListVO> getCarList(int carID, String companyID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("carID", carID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		return ezCarDAO.getCarList(map);
	}
	
	@Override
	public void deleteCar(String carID, int tenantId, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("carID", carID);		
		map.put("tenantId", tenantId);
		map.put("companyID", companyID);
		
		ezCarDAO.deleteCar(map);

	}
	
	@Override
	public boolean addCarData(HttpServletRequest request, String xmlStr, int tenantID,Locale locale) throws Exception {
		String strClassGB = "";
		String strODeptID = "";
		String strODeptNm = "";
		String strOwnerID = "";
		String strOwnerNm = "";
		String strOwnerPos = "";
	    String strOwnerCall = "";
	    String strBrdNm = "";
	    String strResLocation = "";
	    String strBrdExplain = "";
	    String strCompanyID = "";
	    String strApprove = "";
	    String strBrdNm2 = "";
	    String strODeptNm2 = "";
	    String strOwnerNm2 = "";
	    String strOwnerPos2 = "";
	    String strBreAccess = "";
	    String realPath = "";
	    String strAttachList1 = "";
	    String strAttachList2 = "";
	    String strReturn = "";
	    String car_nm = "";
	    
	   	Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		strClassGB = xmlRes.getElementsByTagName("DATA").item(0).getTextContent().trim();
		strODeptID = xmlRes.getElementsByTagName("DATA").item(1).getTextContent().trim();
		strODeptNm = xmlRes.getElementsByTagName("DATA").item(2).getTextContent().trim();
		strOwnerID = xmlRes.getElementsByTagName("DATA").item(3).getTextContent().trim();
		strOwnerNm = xmlRes.getElementsByTagName("DATA").item(4).getTextContent().trim();
		strOwnerPos = xmlRes.getElementsByTagName("DATA").item(5).getTextContent().trim();
		strOwnerCall = xmlRes.getElementsByTagName("DATA").item(6).getTextContent().trim();
		strOwnerCall = strOwnerCall.replace(",", ", ");
		strBrdNm = xmlRes.getElementsByTagName("DATA").item(7).getTextContent().trim();
		strCompanyID = xmlRes.getElementsByTagName("DATA").item(8).getTextContent().trim();
		car_nm = xmlRes.getElementsByTagName("DATA").item(9).getTextContent().trim();
		strBrdNm2 = xmlRes.getElementsByTagName("DATA").item(10).getTextContent().trim();
		
		realPath = xmlRes.getElementsByTagName("DATA").item(16).getTextContent().trim();
		strAttachList1 = xmlRes.getElementsByTagName("DATA").item(11).getTextContent().trim();
		strBreAccess = egovMessageSource.getMessage("ezResource.t58", locale);
		addCarData(strClassGB, strODeptID, strODeptNm, strOwnerID, strOwnerNm, strOwnerPos, strOwnerCall, strBrdNm, strResLocation, strBrdExplain, strCompanyID, strApprove, strBrdNm2, strODeptNm2, strOwnerNm2, strOwnerPos2, strBreAccess, tenantID, realPath, strAttachList1, strAttachList2, strReturn, car_nm);

		return true;
	}
	
	
	public void addCarData(String classGB, String deptID, String deptNm, String ownerID, String ownerNm, String ownerPos, String ownerCall, String brdNm, String resLocation,
			String brdExplain, String companyID, String approve, String brdNm2, String deptNm2, String ownerNm2, String ownerPos2,String strBreAccess, int tenantID, String realPath, String strAttachList1, String strAttachList2, String strReturn, String car_nm) throws Exception {
				logger.debug("addResData Start");
				
				Map<String,Object> map = new HashMap<String, Object>();
				map.put("tenantID", tenantID);
				
				int carID = ezCarDAO.addCarData_S1(map);
				
				map.put("v_P_ClassGB", classGB);
				map.put("v_P_ODeptID", deptID);
				map.put("v_P_ODeptNm", deptNm);
				map.put("v_P_OwnerID", ownerID);
				map.put("v_P_OwnerNm", ownerNm);
				map.put("v_P_OwnerPos", ownerPos);
				map.put("v_P_OwnerCall", ownerCall);
				map.put("v_P_Brd_NM", brdNm);
				map.put("v_P_ResLocation", resLocation);
				map.put("v_P_Brd_Explain", brdExplain);
				map.put("v_P_CompanyID", companyID);
				map.put("v_P_Approve", approve);
				map.put("v_P_Brd_NM2", brdNm2);
				map.put("v_P_ODeptNm2", deptNm2);
				map.put("v_P_OwnerNm2", ownerNm2);
				map.put("v_P_OwnerPos2", ownerPos2);
				map.put("v_Brd_GB", "2");
				map.put("carID", carID);
				map.put("v_Brd_Access", strBreAccess);
				map.put("v_P_Return", strReturn);
				map.put("car_nm", car_nm);
				
				Map<String,Object> map2 = new HashMap<String, Object>();
				logger.debug("classGB="+classGB);
				logger.debug("companyID="+companyID);
				logger.debug("tenantID="+tenantID);
				map2.put("v_P_ClassGB", classGB);
				map2.put("v_P_CompanyID", companyID);
				map2.put("tenantID", tenantID);
				
				int v_Brd_Level = 0;
				v_Brd_Level = ezCarDAO.addCarData_S2(map2);
				
				int v_Brd_Step = ezCarDAO.addCarData_S3(map2);
				map.put("v_Brd_Level", v_Brd_Level);
				map.put("v_Brd_Step", v_Brd_Step);
				ezCarDAO.addCarData(map);
				
				// 첨부파일 등록 실행
				Map<String, Object> attachMap = new HashMap<String, Object>();
				attachMap.put("companyID", companyID);
				attachMap.put("tenantID", tenantID);
				attachMap.put("carID", carID);
				
				String pDirPath = realPath + commonUtil.getUploadPath("upload_car.ROOT", tenantID);
				
				File file = new File(pDirPath + "uploadFile" + commonUtil.separator + carID + "_uploadFile");
				
				if (!file.exists()) {
					file.mkdirs();
				}
				
				if(!strAttachList1.equals("") && strAttachList1 != null) {
					String uploadFilePath = commonUtil.separator + carID + "_uploadFile" + commonUtil.separator + strAttachList1;
					String beforeFilePath = pDirPath + commonUtil.separator + "tempUploadFile" + commonUtil.separator + strAttachList1;
					String afterFilePath = pDirPath + commonUtil.separator + "uploadFile" + commonUtil.separator + carID + "_uploadFile" + commonUtil.separator + strAttachList1;

					File beforeFile = new File(beforeFilePath);
					long fileSize = beforeFile.length();
					
					File afterFile = new File(afterFilePath);
					
					if (!afterFile.exists()) {
						FileUtils.moveFile(beforeFile, afterFile);
					}
					
					attachMap.put("fileName", strAttachList1);
					attachMap.put("fileSize", fileSize);
					attachMap.put("filePath", uploadFilePath);
					
					logger.debug("file1 upload End");
					ezCarDAO.addAttachFile(attachMap);		// 첨부파일 추가
				}
				
				if(!strAttachList2.equals("") && strAttachList2 != null) {
					String uploadFilePath = commonUtil.separator + carID + "_uploadFile" + commonUtil.separator + strAttachList2;
					String beforeFilePath = pDirPath + commonUtil.separator + "tempUploadFile" + commonUtil.separator + strAttachList2;
					String afterFilePath = pDirPath + commonUtil.separator + "uploadFile" + commonUtil.separator + carID + "_uploadFile" + commonUtil.separator + strAttachList2;

					File beforeFile = new File(beforeFilePath);
					long fileSize = beforeFile.length();
					
					File afterFile = new File(afterFilePath);
					
					if (!afterFile.exists()) {
						FileUtils.moveFile(beforeFile, afterFile);
					}
					
					attachMap.put("fileName", strAttachList2);
					attachMap.put("fileSize", fileSize);
					attachMap.put("filePath", uploadFilePath);
					
					logger.debug("file2 upload End");
					ezCarDAO.addAttachFile(attachMap);
				}
				
				logger.debug("addResData End");
			}
	
	
	@Override
	public CarBrdVO getBrd(int carID, String companyID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("carID", carID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		return ezCarDAO.getBrd(map);
	}
	
	@Override
	public List<String> getAttachList(String carID, String companyID, int tenantID) throws Exception {
		logger.debug("getAttachList start");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("carID", carID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		logger.debug("getAttachList start");
		return ezCarDAO.getAttachList(map);
		
	}



	@Override
	public List<CarFormListVO> getCarFormList(int carID, String companyID, int tenantID, String currentDate) throws Exception {
		logger.debug("getCarFormList start");
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("carID", carID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("currentDate", currentDate);
		int currentEndDate = 0;
		if(currentDate.substring(currentDate.length()-2, currentDate.length()).equals("12")){
			 currentEndDate = Integer.parseInt(currentDate)+89;
		}else{
			 currentEndDate = Integer.parseInt(currentDate)+1;
		}
		map.put("currentEndDate", currentEndDate);
		
		return ezCarDAO.getCarFormList(map);
	}
	
	@Override
	public boolean modifyCarData(String xmlStr, int tenantID) throws Exception {
		String strBrdID = "";
		String strODeptID = "";
		String strODeptNm = "";
		String strOwnerID = "";
		String strOwnerNm = "";
		String strOwnerPos = "";
	    String strOwnerCall = "";
	    String strBrdNm = "";
	    String strResLocation = "";
	    String strBrdExplain = "";
	    String strCompanyID = "";
	    String strApprove = "";
	    String strBrdNm2 = "";
	    String strODeptNm2 = "";
	    String strOwnerNm2 = "";
	    String strOwnerPos2 = "";
	    String realPath = "";
	    String strAttachList1 = "";
	    String strAttachList2 = "";
	    String strReturn = "";
	    String car_nm = "";
	    
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		strBrdID = xmlRes.getElementsByTagName("DATA").item(0).getTextContent().trim();
		strODeptID = xmlRes.getElementsByTagName("DATA").item(1).getTextContent().trim();
		strODeptNm = xmlRes.getElementsByTagName("DATA").item(2).getTextContent().trim();
		strOwnerID = xmlRes.getElementsByTagName("DATA").item(3).getTextContent().trim();
		strOwnerNm = xmlRes.getElementsByTagName("DATA").item(4).getTextContent().trim();
		car_nm = xmlRes.getElementsByTagName("DATA").item(6).getTextContent().trim();
		strBrdNm = xmlRes.getElementsByTagName("DATA").item(7).getTextContent().trim();
		strCompanyID = xmlRes.getElementsByTagName("DATA").item(8).getTextContent().trim();
		strBrdNm2 = xmlRes.getElementsByTagName("DATA").item(9).getTextContent().trim();
		//strODeptNm2 = xmlRes.getElementsByTagName("DATA").item(16).getTextContent().trim();
		//strOwnerNm2 = xmlRes.getElementsByTagName("DATA").item(17).getTextContent().trim();
			
		realPath = xmlRes.getElementsByTagName("DATA").item(15).getTextContent().trim();
		strOwnerCall = xmlRes.getElementsByTagName("DATA").item(11).getTextContent().trim();
		strAttachList1 = xmlRes.getElementsByTagName("DATA").item(10).getTextContent().trim();
		strOwnerCall = strOwnerCall.replace(",", ", ");
		modifyCarData(strBrdID, strODeptID, strODeptNm, strOwnerID, strOwnerNm, strOwnerCall, strBrdNm, strCompanyID, strBrdNm2, tenantID, realPath, strAttachList1, car_nm);

		return true;
	}
	
	
	public void modifyCarData(String carID, String deptID, String deptNm, String ownerID, String ownerNm, String ownerCall, String brdNm,
			String companyID, String brdNm2, int tenantID, String realPath, String strAttachList1, String car_nm) throws Exception {
				Map<String,Object> map = new HashMap<String, Object>();
				map.put("v_P_Brd_ID", carID);
				map.put("v_P_ODeptID", deptID);
				map.put("v_P_ODeptNm", deptNm);
				map.put("v_P_OwnerID", ownerID);
				map.put("v_P_OwnerNm", ownerNm);
				map.put("v_P_OwnerCall", ownerCall);
				map.put("v_P_Brd_NM", brdNm);
				map.put("v_P_CompanyID", companyID);
				map.put("v_P_Brd_NM2", brdNm2);
				map.put("tenantID", tenantID);
				map.put("car_nm", car_nm);
				ezCarDAO.modifyCarData(map);
				
				// 첨부파일 등록 실행
				//deleteAttachFiles(brdID, realPath, companyID, tenantID);
				Map<String, Object> attachMap = new HashMap<String, Object>();
				attachMap.put("companyID", companyID);
				attachMap.put("tenantID", tenantID);
				attachMap.put("carID", carID);
				
				String pDirPath = realPath + commonUtil.getUploadPath("upload_car.ROOT", tenantID);
				
				File file = new File(pDirPath + commonUtil.separator + "uploadFile" + commonUtil.separator + carID + "_uploadFile");
				
				if (!file.exists()) {
					file.mkdirs();
				}
				
				ezCarDAO.delAttachFile(attachMap);
				
				// 기존 존재하는 파일인 경우
				if(strAttachList1.indexOf("/") != -1) {
					String beforeFilePath = pDirPath + commonUtil.separator + "uploadFile" + commonUtil.separator + strAttachList1;
					
					strAttachList1 = strAttachList1.substring(strAttachList1.lastIndexOf("/")+1);
					
					String afterFilePath = pDirPath + commonUtil.separator + "tempUploadFile" + commonUtil.separator + strAttachList1;
					
					File beforeFile = new File(beforeFilePath);
					File afterFile = new File(afterFilePath);
					
					FileUtils.moveFile(beforeFile, afterFile);
				}
				
				
				if(file.exists()) {
					File[] files = file.listFiles();
					
					for(File f: files){
						f.delete();
					}
				}
				
				if(!strAttachList1.equals("") && strAttachList1 != null) {
					String uploadFilePath = "";
					long fileSize = 0;

					uploadFilePath = commonUtil.separator + carID + "_uploadFile" + commonUtil.separator + strAttachList1;
					String beforeFilePath = pDirPath + commonUtil.separator + "tempUploadFile" + commonUtil.separator + strAttachList1;
					String afterFilePath = pDirPath + commonUtil.separator + "uploadFile" + commonUtil.separator + carID + "_uploadFile" + commonUtil.separator + strAttachList1;

					File beforeFile = new File(beforeFilePath);
					fileSize = beforeFile.length();
					
					File afterFile = new File(afterFilePath);
					
					if (!afterFile.exists()) {
						FileUtils.moveFile(beforeFile, afterFile);
					}
					
					attachMap.put("fileName", strAttachList1);
					attachMap.put("fileSize", fileSize);
					attachMap.put("filePath", uploadFilePath);
					
					logger.debug("file1 upload End");
					ezCarDAO.addAttachFile(attachMap);		// 첨부파일 추가
				}
				
				
			}



	@Override
	public int getBrdCnt(int brdID, String companyID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PBRDID", brdID);
		map.put("v_PCOMPANYID", companyID);
		map.put("tenantID", tenantID);
		return ezCarDAO.getBrdCnt(map);
	}



	@Override
	public List<CarBrdListVO> getBrdList(int topCnt, int brdID, String CompanyID, String ownDeptNm, String ownerNm, String ownerPosition, String brdNm, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PTOPCNT", topCnt);
		map.put("v_PBRDID", brdID);
		map.put("v_PCOMPANYID", CompanyID);
		map.put("v_POWNDEPTNM", ownDeptNm);
		map.put("v_POWNERNM", ownerNm);
		map.put("v_POWNERPOSITION", ownerPosition);
		map.put("v_PBRDNM", brdNm);
		map.put("tenantID", tenantID);
		return ezCarDAO.getBrdList(map);
	}
	
	@Override
	public int getMaxCarFormId(String carID, int tenantID, String CompanyID) throws Exception{
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("carID", carID);
		map.put("tenantID", tenantID);
		map.put("companyID",CompanyID);
		return ezCarDAO.getMaxCarFormId(map);
	}
	
	
	@Override
	public boolean addCarForm(String companyID, String id, int tenantID, String currentDate ,String carID, int car_form_id, String rev_date,
			String rev_time, String rev_time2, String driverdeptname, String dirvername, String s2timepicker, String bdistance, String drivepurpose, 
			String drivepoint, String s3timepicker, String adistance, String adistanceauto, String adistancecommute, String adistancework, String adistanceetc, int car_register_no, String control) throws Exception {
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("register_id", id);
		map.put("tenant_id", tenantID);
		map.put("register_date", currentDate);
		map.put("carID", carID);
		map.put("car_form_id", car_form_id);
		map.put("rev_date", rev_date);
		map.put("rev_time", rev_time);
		map.put("rev_time2", rev_time2);
		map.put("driver_deptname", driverdeptname);
		map.put("driver_name", dirvername);
		map.put("b_depart_time", s2timepicker);
		map.put("b_distance", bdistance);
		map.put("drive_purpose", drivepurpose);
		map.put("drive_point", drivepoint);
		map.put("a_arrive_time", s3timepicker);
		map.put("a_distance", adistance);
		map.put("a_distance_auto", adistanceauto);
		map.put("a_distance_commute", adistancecommute);
		map.put("a_distance_work", adistancework);
		map.put("a_distance_etc", adistanceetc);
		map.put("car_register_no", car_register_no);
		map.put("control", control);
		
		ezCarDAO.addCarForm(map);
		return true;
	}



	@Override
	public List<CarFormListVO> getCarForm(String carID, int car_form_id, String companyID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("carID", carID);
		map.put("car_form_id", car_form_id);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		return ezCarDAO.getCarForm(map);
	}



	@Override
	public void modifyCarForm(int car_form_id, int car_form_id2, String carID, String companyID, int tenantID, String currentDate) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("car_form_id2", car_form_id2);
		map.put("car_form_id", car_form_id);
		map.put("carID", carID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("currentDate", currentDate);
		ezCarDAO.modifyCarForm(map);
	}
	
	@Override
	public void deleteCarForm(String car_form_id, String carID, int tenantId, String companyID)  throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("car_form_id", car_form_id);
		map.put("carID", carID);		
		map.put("tenantId", tenantId);
		map.put("companyID", companyID);
		
		ezCarDAO.deleteCarForm(map);
		
	}



	@Override
	public List<CarFormListVO> getCarFormList2(int carID, String companyID, int tenantID, String yearMonth) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("carID", carID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("yearMonth", yearMonth);
		int yearMonthEnd = 0;
		
		if(yearMonth.substring(yearMonth.length()-2, yearMonth.length()).equals("12")){
			yearMonthEnd = Integer.parseInt(yearMonth)+89;
		}else{
			yearMonthEnd = Integer.parseInt(yearMonth)+1;
		}
		
		map.put("yearMonthEnd", yearMonthEnd);
		
		return ezCarDAO.getCarForm2(map);
	}
	
	
	@Override
	public String getAdminFlag(String companyID, String brdID, String userID, int tenantID, String deptID) throws Exception {
		String accessLvl = "";
		

		/* 2018-07-13 홍승비 - everyone을 관리자로 설정한 경우 우선적으로 해당 관리자 플래그 받아오도록 수정 */
		ResGetAdminFlagVO resGetAdminFlag = getAdmFlag(companyID, brdID, userID, tenantID);
		
		if (resGetAdminFlag != null && resGetAdminFlag.getAccessLvl() != null && !resGetAdminFlag.getAccessLvl().equals("")) {
			String strXML = "<DATA>"+commonUtil.getQueryResult(resGetAdminFlag)+"</DATA>";
			Document xmlDom = commonUtil.convertStringToDocument(strXML);
			
			if(xmlDom.getElementsByTagName("ROW") != null) {
				for(int i=0; i<xmlDom.getElementsByTagName("ROW").getLength(); i++) {
					accessLvl = xmlDom.getElementsByTagName("ACCESSLVL").item(i).getTextContent().trim();
				}
			}
			
			logger.debug("everyone or user accessLvl : " + accessLvl);
		}
			if(accessLvl.equals("1")) {			// everyone 혹은 user 권한이 관리자 이면 Y 리턴, 그 외 U + 부서권한 체크
				return "Y";
			}else {	//부서의 관리자 권한 확인
			Map<String,Object> map = new HashMap<String, Object>();
			map.put("v_PCOMPANYID", companyID);
			map.put("v_BRD_UPPER", brdID);
			map.put("tenantID", tenantID);
			
			String deptPath = ezOrganService.getDeptPath(deptID, tenantID);
			List<String> deptIds = new ArrayList<String>();
			Collections.addAll(deptIds, deptPath.split(","));
			//deptIds.remove(0);				// companyID 삭제
			if(deptIds.size() > 0) {
				Collections.reverse(deptIds);
				
				map.put("v_PUSERID", deptIds.get(0));
				String deptAccLvl = ezCarDAO.getAclTblBrd_S3(map);
					
				if(deptAccLvl != null && deptAccLvl.trim().equals("1")) {
					logger.debug("user dept accessLvl = admin");
					return "Y";
				}
				else {
					if (deptAccLvl != null && deptAccLvl.trim().equals("2")) {
						logger.debug("user dept accessLvl = user");
						accessLvl = "2";
					}
					// 부서 상위 권한 체크
					deptIds.remove(0);				// 현재 부서ID 삭제
					if(deptIds.size() > 0) {
						String newDeptPath = "'" + String.join(",", deptIds).trim().replace(",", "', '") + "'";
						
						/* 2024-07-01 홍승비 - SQL Injection 수정 > $ 기호 제거, 배열로 전달 */
						map.put("v_PUSERID", newDeptPath.replace("'", "").replace(" ", "").split(","));
						
						List<ResGetClsAclListVO> deptAclList = ezCarDAO.getDeptAcl(map);
		
						if(deptAclList != null) {
							for(int i=0; i<deptAclList.size(); i++) {
								if(deptAclList.get(i).getAccessLvl().equals("1")) {
									logger.debug("user upper dept accessLvl = admin");
									return "Y";
								}
								else {
									logger.debug("user upper dept accessLvl = user");
									accessLvl = "2";
								}
							}
						}
					}
				}
			}
			
			// 사내 겸직 권한 체크
			List<OrganUserVO> userAddJobList = ezOrganAdminService.getUserAddJobList(userID, "1", tenantID);
			if(userAddJobList.size() > 0) {
				for(int i=0; i<userAddJobList.size(); i++) {
					String addJobDeptPath = ezOrganService.getDeptPath(userAddJobList.get(i).getDepartment(), tenantID);
					List<String> addJobDeptIds = new ArrayList<String>();
					Collections.addAll(addJobDeptIds, addJobDeptPath.split(","));
					//addJobDeptIds.remove(0);				// companyID 삭제
					if(addJobDeptIds.size() > 0) {
						Collections.reverse(addJobDeptIds);
						
						map.put("v_PUSERID", addJobDeptIds.get(0));
						String addJobAccLvl = ezCarDAO.getAclTblBrd_S3(map);
							
						if(addJobAccLvl != null && addJobAccLvl.trim().equals("1")) {
							logger.debug("user addjob dept accessLvl = admin");
							return "Y";
						}
						else {
							if (addJobAccLvl != null && addJobAccLvl.trim().equals("2")) {
								logger.debug("user addjob dept accessLvl = user");
								accessLvl = "2";
							} 
							// 부서 상위 권한 체크
							addJobDeptIds.remove(0);				// 현재 부서ID 삭제
							if(addJobDeptIds.size() > 0) {
								String newDeptPath = "'" + String.join(",", addJobDeptIds).trim().replace(",", "', '") + "'";
								
								map.put("v_PUSERID", newDeptPath);
								List<ResGetClsAclListVO> deptAclList = ezCarDAO.getDeptAcl(map);
								
								if(deptAclList != null) {
									for(int j=0; j<deptAclList.size(); j++) {
										if(deptAclList.get(j).getAccessLvl().equals("1")) {
											logger.debug("user addjob upper dept accessLvl = admin");
											return "Y";
										}
										else {
											logger.debug("user addjob upper dept accessLvl = user");
											accessLvl = "2";
										}
									}
								}
							}
						}
					}
				}
			}
			
		}
		
		if(accessLvl.trim().equals("1")) {
			return "Y";
		} else if(accessLvl.trim().equals("2")) {
			return "U";
		} else {
			return "";
		}
	
	}
	
	@Override
	public String getAdminFlagForm(String companyID, String brdID, String userID, int tenantID, String deptID) throws Exception {
		String accessLvl = "";
		
		//carUpper구하기
		Map<String,Object> map4 = new HashMap<String, Object>();
		map4.put("companyID", companyID);
		map4.put("carID", brdID);
		map4.put("tenantID", tenantID);
		String carUpper = ezCarDAO.getCarUpper(map4);
		brdID = carUpper;
		
		/* 2018-07-13 홍승비 - everyone을 관리자로 설정한 경우 우선적으로 해당 관리자 플래그 받아오도록 수정 */
		ResGetAdminFlagVO resGetAdminFlag = getAdmFlag(companyID, brdID, userID, tenantID);
		
		if (resGetAdminFlag != null && resGetAdminFlag.getAccessLvl() != null && !resGetAdminFlag.getAccessLvl().equals("")) {
			String strXML = "<DATA>"+commonUtil.getQueryResult(resGetAdminFlag)+"</DATA>";
			Document xmlDom = commonUtil.convertStringToDocument(strXML);
			
			if(xmlDom.getElementsByTagName("ROW") != null) {
				for(int i=0; i<xmlDom.getElementsByTagName("ROW").getLength(); i++) {
					accessLvl = xmlDom.getElementsByTagName("ACCESSLVL").item(i).getTextContent().trim();
				}
			}
			
			logger.debug("everyone or user accessLvl : " + accessLvl);
		}
		if(accessLvl.equals("1")) {			// everyone 혹은 user 권한이 관리자 이면 Y 리턴, 그 외 U + 부서권한 체크
			return "Y";
		}else {	//부서의 관리자 권한 확인
			Map<String,Object> map = new HashMap<String, Object>();
			map.put("v_PCOMPANYID", companyID);
			map.put("v_BRD_UPPER", brdID);
			map.put("tenantID", tenantID);
			
			String deptPath = ezOrganService.getDeptPath(deptID, tenantID);
			List<String> deptIds = new ArrayList<String>();
			Collections.addAll(deptIds, deptPath.split(","));
			//deptIds.remove(0);				// companyID 삭제
			if(deptIds.size() > 0) {
				Collections.reverse(deptIds);
				
				map.put("v_PUSERID", deptIds.get(0));
				String deptAccLvl = ezCarDAO.getAclTblBrd_S3(map);
				
				if(deptAccLvl != null && deptAccLvl.trim().equals("1")) {
					logger.debug("user dept accessLvl = admin");
					return "Y";
				}
				else {
					if (deptAccLvl != null && deptAccLvl.trim().equals("2")) {
						logger.debug("user dept accessLvl = user");
						accessLvl = "2";
					}
					// 부서 상위 권한 체크
					deptIds.remove(0);				// 현재 부서ID 삭제
					if(deptIds.size() > 0) {
						String newDeptPath = "'" + String.join(",", deptIds).trim().replace(",", "', '") + "'";
						
						map.put("v_PUSERID", newDeptPath);
						List<ResGetClsAclListVO> deptAclList = ezCarDAO.getDeptAcl(map);
						
						if(deptAclList != null) {
							for(int i=0; i<deptAclList.size(); i++) {
								if(deptAclList.get(i).getAccessLvl().equals("1")) {
									logger.debug("user upper dept accessLvl = admin");
									return "Y";
								}
								else {
									logger.debug("user upper dept accessLvl = user");
									accessLvl = "2";
								}
							}
						}
					}
				}
			}
			
			// 사내 겸직 권한 체크
			List<OrganUserVO> userAddJobList = ezOrganAdminService.getUserAddJobList(userID, "1", tenantID);
			if(userAddJobList.size() > 0) {
				for(int i=0; i<userAddJobList.size(); i++) {
					String addJobDeptPath = ezOrganService.getDeptPath(userAddJobList.get(i).getDepartment(), tenantID);
					List<String> addJobDeptIds = new ArrayList<String>();
					Collections.addAll(addJobDeptIds, addJobDeptPath.split(","));
					//addJobDeptIds.remove(0);				// companyID 삭제
					if(addJobDeptIds.size() > 0) {
						Collections.reverse(addJobDeptIds);
						
						map.put("v_PUSERID", addJobDeptIds.get(0));
						String addJobAccLvl = ezCarDAO.getAclTblBrd_S3(map);
						
						if(addJobAccLvl != null && addJobAccLvl.trim().equals("1")) {
							logger.debug("user addjob dept accessLvl = admin");
							return "Y";
						}
						else {
							if (addJobAccLvl != null && addJobAccLvl.trim().equals("2")) {
								logger.debug("user addjob dept accessLvl = user");
								accessLvl = "2";
							} 
							// 부서 상위 권한 체크
							addJobDeptIds.remove(0);				// 현재 부서ID 삭제
							if(addJobDeptIds.size() > 0) {
								String newDeptPath = "'" + String.join(",", addJobDeptIds).trim().replace(",", "', '") + "'";
								
								map.put("v_PUSERID", newDeptPath);
								List<ResGetClsAclListVO> deptAclList = ezCarDAO.getDeptAcl(map);
								
								if(deptAclList != null) {
									for(int j=0; j<deptAclList.size(); j++) {
										if(deptAclList.get(j).getAccessLvl().equals("1")) {
											logger.debug("user addjob upper dept accessLvl = admin");
											return "Y";
										}
										else {
											logger.debug("user addjob upper dept accessLvl = user");
											accessLvl = "2";
										}
									}
								}
							}
						}
					}
				}
			}
			
		}
		
		if(accessLvl.trim().equals("1")) {
			return "Y";
		} else if(accessLvl.trim().equals("2")) {
			return "U";
		} else {
			return "";
		}
		
	}
	
	
	public ResGetAdminFlagVO getAdmFlag(String companyID, String resID,String memberID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("resID", resID);
		map.put("memberID", memberID);
		map.put("tenantID", tenantID);
		return ezCarDAO.getAdmFlag(map);
	}


	@Override
	public List<CarFormListVO> getCarFormList3(int carID, String companyID, int tenantID, String yearMonth, String carFormID) throws Exception {
			Map<String,Object> map = new HashMap<String, Object>();
			map.put("carID", carID);
			map.put("companyID", companyID);
			map.put("tenantID", tenantID);
			map.put("yearMonth", yearMonth);
			map.put("carFormID", carFormID);
			
			int yearMonthEnd = 0;
			
			if(yearMonth.substring(yearMonth.length()-2, yearMonth.length()).equals("12")){
				yearMonthEnd = Integer.parseInt(yearMonth)+89;
			}else{
				yearMonthEnd = Integer.parseInt(yearMonth)+1;
			}
			
			map.put("yearMonthEnd", yearMonthEnd);
			
			return ezCarDAO.getCarForm3(map);
	}
	
}
