package egovframework.ezEKP.ezBoard.service.impl;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringJoiner;

import javax.annotation.Resource;

import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganAuth;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.w3c.dom.Document;

import com.ibm.icu.text.SimpleDateFormat;
import com.ibm.icu.util.Calendar;

import egovframework.ezEKP.ezBoard.dao.EzBoardAdminDAO;
import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.vo.BoardAttributeVO;
import egovframework.ezEKP.ezBoard.vo.BoardBackgroundVO;
import egovframework.ezEKP.ezBoard.vo.BoardListHeaderVO;
import egovframework.ezEKP.ezBoard.vo.BoardMyFavoriteVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezBoard.vo.BoardTreeVO;
import egovframework.ezEKP.ezBoard.vo.BoardVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

import static egovframework.ezEKP.ezOrgan.vo.OrganAuth.*;

@Service("EzBoardAdminService")
public class EzBoardAdminServiceImpl extends EgovAbstractServiceImpl implements EzBoardAdminService {	
	
	@Resource(name="EzBoardAdminDAO")
	private EzBoardAdminDAO ezBoardAdminDAO;
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private EzOrganAdminService ezOrganAdminService;

	private static final Logger logger = LoggerFactory.getLogger(EzBoardAdminServiceImpl.class);

	@Override
	public String checkIfBoardGroupAdmin(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int tenantID) throws Exception {
		logger.debug("checkIfBoardGroupAdmin started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pBoardID", pRootBoardID);
		map.put("v_pUserID", pUserID);
		map.put("v_pDeptID", pDeptID);
		map.put("v_pCompanyID", pCompanyID);
		map.put("v_TENANTID", tenantID);

		logger.debug("checkIfBoardGroupAdmin ended");
		return ezBoardAdminDAO.checkIfBoardGroupAdmin(map);
	}
	
	/* 2018-10-18 홍승비 - 그룹사게시판 즐겨찾기 분기 isAllGroupBoard 플래그 추가, companyID브랜치용 임시 메서드 제거 */
	/* 2018-06-27 홍승비 - 즐겨찾기에 게시판 추가 시 companyID 삽입 */
	@Override
	public String addMyBoards(String userID, String boardID, String isAllGroupBoard, String companyID, int tenantID) throws Exception {
		logger.debug("addMyBoards started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", userID);
		map.put("v_PBOARDID", boardID);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantID);
		map.put("v_PQUERY", userID);
		map.put("v_isAllGroupBoard", isAllGroupBoard);
		
		/* 2018-07-12 홍승비 - PRI 제약을 가지는 CompanyID 칼럼의 데이터 삽입 판단용 분기 추가 */
		try {
			ezBoardAdminDAO.addMyBoards(map);
			ezBoardAdminDAO.getBoardTree_Set_D(map);
			
			logger.debug("addMyBoards ended");
			return "OK";
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			return "NO";
		}
	}

	// 마이게시판 폴더(트리) 추가
	@Override
	public String setMyBoardTreeConfig(BoardMyFavoriteVO boardMyFavoriteVO) throws Exception {
		logger.debug("setMyBoardTreeConfig started");

		String rtnValue = "";
		
		// 마이게시판 트리 설정 시 COMPANYid 추가 필요
		try {
			if (boardMyFavoriteVO.getMode().equals("NEW")) {
				// 새 분류추가, 하위추가, 마이게시판 추가 시 companyID 삽입
				ezBoardAdminDAO.setMyBoardTreeConfig_N(boardMyFavoriteVO);
				
				rtnValue = "OK";
			} else if (boardMyFavoriteVO.getMode().equals("MOD")) {
				// 기존 트리 정보 수정 시 companyID 불필요(고유한 treeID로 조건 걸어 업데이트)
				ezBoardAdminDAO.setMyBoardTreeConfig_M(boardMyFavoriteVO);
				
				rtnValue = "OK";
			} else if (boardMyFavoriteVO.getMode().equals("DEL")) {
				/* 2019-08-05 홍승비 - 마이게시판 관리 > 분류 삭제 시 삭제된 하위게시판은 무시하도록 수정 */
				String treeUpper = ezBoardAdminDAO.getMyBoardTreeUpper(boardMyFavoriteVO);
				
				if (treeUpper.equals("0")) {
					// 선택한 게시판(또는 분류)삭제 시 companyID 불필요(고유한 treeID로 조건 걸어 삭제)
					ezBoardAdminDAO.setMyBoardTreeConfig_D(boardMyFavoriteVO);	
					
					rtnValue = "OK";
				} else {
					rtnValue = "EXIST";
				}
			}
		} catch (Exception e) {
			rtnValue = "ERROR"; 
		}

		logger.debug("setMyBoardTreeConfig ended");
		return rtnValue;
	}

	@Override
	public String setMyBoardTreeMoveCopy(BoardMyFavoriteVO boardMyFavoriteVO) throws Exception {
		logger.debug("setMyBoardTreeMoveCopy started");

		try {
			ezBoardAdminDAO.setMyBoardTreeMoveCopy(boardMyFavoriteVO);
			
			logger.debug("setMyBoardTreeMoveCopy ended");
			return "OK";
		} catch (Exception e) {
			return "ERROR"; 
		}
	}

	@Override
	public String saveMHT(String boardID, String formContent, String realPath, int tenantID) throws Exception {
		logger.debug("saveMHT started");

		InputStream stream = null;
		OutputStream bos = null;
		String mhtFilePath = "";
		String dbPath = "";
		
		try {			
			String docPath = commonUtil.getUploadPath("upload_board.FORM", tenantID) + commonUtil.separator;
			String fullPath = realPath + commonUtil.detectPathTraversal(docPath);
			File doc = new File(fullPath);
			
			/* 2020-01-09 홍승비 - 파일경로 폴더 생성 방식 수정 (존재하지 않는 상위폴더를 전부 생성하도록 수정) */
			if (!doc.exists() || !doc.isDirectory()) {
				doc.mkdirs();
			}
			
			dbPath = docPath + boardID + ".mht";
			mhtFilePath = realPath + commonUtil.detectPathTraversal(dbPath);
			File mht = new File(mhtFilePath);
			
			if (mht.exists()) {
				mht.delete();
			}
			
			stream = new ByteArrayInputStream(formContent.getBytes("UTF-8"));
			bos = new FileOutputStream(mhtFilePath);
			
			int bytesRead = 0;
			int buffer_size = 1024;
			byte[] buffer = new byte[buffer_size];
			
			while ((bytesRead = stream.read(buffer, 0, buffer_size)) != -1) {
				bos.write(buffer, 0, bytesRead);
			}
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
			if(bos != null){
				bos.close();
			}
			
			if(stream != null){
				stream.close();
			}
		}

		logger.debug("saveMHT ended");
		return dbPath;
	}

	/* 2018-06-27 홍승비 - 게시물 승인권한 확인 companyID 조건 추가 */
	@Override
	public List<BoardVO> checkApplyUser(String companyID, int tenantID) throws Exception {
		logger.debug("checkApplyUser started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		
		logger.debug("checkApplyUser ended");
		return ezBoardAdminDAO.checkApplyUser(map);
	}

	@Override
	public String getBoardTree_Get1(String pStrLang, String pQuery, int tenantID) throws Exception {
		logger.debug("getBoardTree_Get1 started");
		
		if (pStrLang.equals("1")) {
			pStrLang = "";
		}

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_STRLANG", pStrLang); // "", 2, 3, 4
		map.put("v_PQUERY", pQuery);
		map.put("v_TENANTID", tenantID);

		logger.debug("getBoardTree_Get1 ended");
		return ezBoardAdminDAO.getBoardTree_Get1(map);
	}

	@Override
	public List<BoardVO> getBoardTree_Get2(String pAccessID, String pRootBoardID, int tenantID, boolean isNormalAdmin, int isDept, int isEqualDept) throws Exception {
		logger.debug("getBoardTree_Get2 started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PACCESSID", pAccessID);
		map.put("v_PROOTBOARDID", pRootBoardID);
		map.put("v_TENANTID", tenantID);
		/* 2019-06-05 홍승비 - 게시판 접근불가 id리스트 가져올때도 하위부서 허용여부 체크하도록 수정 */
		map.put("v_isNormalAdmin", isNormalAdmin);
		map.put("v_ISDEPT", isDept);
		map.put("v_ISEQUALDEPT", isEqualDept);
		
		//logger.debug("map in getBoardTree_Get2    ::   " + map.toString());
		logger.debug("getBoardTree_Get2 ended");
		return ezBoardAdminDAO.getBoardTree_Get2(map);
	}

	/* 2018-10-16 홍승비 - 그룹사게시판 표출을 제어하는 showAllGroupBoard 플래그 추가  */
	/* 2018-06-25 홍승비 - 게시판 트리캐시 생성 시  companyID로 제한 걸어주기 */
	@Override
	public List<BoardTreeVO> brdBoardTree(String pRootBoardID, String pAccessID, int pMode, int pSelectBy, String pExcludeBoardID, String companyID, int tenantID, int isDept, int isEqualDept, String showAllGroupBoard, boolean isCompanyAdmin, String boardGroupAdmin_FG) throws Exception {
		logger.debug("brdBoardTree started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pRootBoardID", pRootBoardID);
		map.put("v_pUserID", pAccessID);
		map.put("v_pDeptID", "");
		map.put("v_pCompanyID","");
		map.put("v_pMode", pMode);
		map.put("v_pSelectBy", pSelectBy);
		map.put("v_pExcludeBoardID", pExcludeBoardID);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantID);
		map.put("v_ISDEPT", isDept);
		map.put("v_ISEQUALDEPT", isEqualDept);
		map.put("v_showAllGroupBoard", showAllGroupBoard);
		map.put("v_isCompanyAdmin", isCompanyAdmin);
		/* 2019-06-04 홍승비 - 게시판그룹에 관리자권한 존재하는 경우, 해당 게시판그룹의 하위게시판 전부 가져오도록 수정 */
		map.put("v_boardGroupAdmin_FG", boardGroupAdmin_FG);
		
		//logger.debug("brdBoardTree map   ::  " + map.toString());
		logger.debug("brdBoardTree ended");
		return ezBoardAdminDAO.brdBoardTree(map);
	}

	@Override
	public void getBoardTree_Set(String pStrLang, String query, String result, int tenantID) throws Exception {
		logger.debug("getBoardTree_Set started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_STRLANG", pStrLang);
		map.put("v_PQUERY", query);
		map.put("v_RESULT", result);
		map.put("v_TENANTID", tenantID);
		
		ezBoardAdminDAO.getBoardTree_Set(map);		
		logger.debug("getBoardTree_Set ended");
	}
	
	@Override
	public void getBoardTree_Set_D(String pStrLang, String query, int tenantID) throws Exception {
		logger.debug("getBoardTree_Set_D started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_STRLANG", pStrLang);
		map.put("v_PQUERY", query);
		map.put("v_TENANTID", tenantID);
		
		ezBoardAdminDAO.getBoardTree_Set_D(map);
		logger.debug("getBoardTree_Set_D ended");
	}

	@Override
	public int checkIfLeafBoard(String pBoardID, int tenantID) throws Exception {
		logger.debug("checkIfLeafBoard started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDID", pBoardID);
		map.put("v_TENANTID", tenantID);

		logger.debug("checkIfLeafBoard ended");
		return ezBoardAdminDAO.checkIfLeafBoard(map);
	}

	@Override
	public int checkForm(String boardID, String mode, int tenantID) throws Exception {
		logger.debug("checkForm started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDID", boardID);
		map.put("v_PMODE", mode);
		map.put("v_TENANTID", tenantID);

		logger.debug("checkForm ended");
		return ezBoardAdminDAO.checkForm(map);
	}

	/* 2019-08-05 홍승비 - 삭제된 게시판은 마이게시판 트리에 표출되지 않도록 수정 */
	/* 2018-06-26 홍승비 - 마이게시판 트리 가져올때 companyID 조건 추가 */
	@Override
	public List<BoardMyFavoriteVO> getMyBoardTree_get3(String userID, String pRootTreeID, String companyID, int tenantID) throws Exception {
		logger.debug("getMyBoardTree_get3 started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", userID);
		map.put("v_PTREEUPPER", pRootTreeID);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantID);
		
		logger.debug("getMyBoardTree_get3 ended");
		return ezBoardAdminDAO.getMyBoardTree_get3(map);
	}

	/* 2018-10-15 홍승비 - 그룹사게시판 표출용 전체관리자 확인 플래그 isCompanyAdmin 추가 */
	@Override
	public List<BoardTreeVO> get_Admin_TopBoardList(String parentBoardID, String lang, String companyID, int tenantID, boolean isCompanyAdmin) throws Exception {
		logger.debug("get_Admin_TopBoardList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("parentBoardID", parentBoardID);
		map.put("lang", lang); // "", 2, 3, 4
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("isCompanyAdmin", isCompanyAdmin);

		logger.debug("get_Admin_TopBoardList ended");
		return ezBoardAdminDAO.get_Admin_TopBoardList(map);
		
	}
	
	/* 2018-10-17 홍승비 - 그룹사게시판이라면 companyID 조건을 무시하도록 수정 */
	@Override
	public List<BoardBackgroundVO> getBackGroundImage(BoardBackgroundVO boardBackgroundVO) throws Exception {
		return ezBoardAdminDAO.getBackGroundImage(boardBackgroundVO);
		
	}
	
	@Override
	public List<BoardAttributeVO> getBoardHeader(String gubun, String boardID, int tenantID) throws Exception {
		logger.debug("getBoardHeader started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDTYPE", gubun);
		map.put("v_PBOARDID", boardID);
		map.put("v_TENANTID", tenantID);
		
		String tempString = ezBoardAdminDAO.getBoardItemListOptionBoard(map);
		
		if (tempString != null && !tempString.equals("")) {
			logger.debug("getBoardHeader ended");
			return ezBoardAdminDAO.getBoardHeader_B(map);
		} else {
			logger.debug("getBoardHeader ended");
			return ezBoardAdminDAO.getBoardHeader(map);
		}
	}	

	@Override
	public List<BoardPropertyVO> getBoardAccessList(String boardID, String isAllGroupBoard, String companyID, int tenantID) throws Exception {
		logger.debug("getBoardAccessList started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDID", boardID);
		map.put("v_TENANTID", tenantID);
		map.put("v_COMPANYID", companyID);
		map.put("isAllGroupBoard", isAllGroupBoard);

		logger.debug("getBoardAccessList ended");
		return ezBoardAdminDAO.getBoardAccessList(map);
	}	

	@Override
	public List<BoardPropertyVO> getUnderBoardID(String boardID, String type, int tenantID) throws Exception {
		logger.debug("getUnderBoardID started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDID", boardID);
		map.put("v_PTYPE", type);
		map.put("v_TENANTID", tenantID);

		logger.debug("getUnderBoardID ended");
		return ezBoardAdminDAO.getUnderBoardID(map);
	}

	@Override
	public BoardPropertyVO getACL(String pBoardID, String userDeptPath, int tenantID) throws Exception {
		logger.debug("getACL started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("pBoardID", pBoardID);
		map.put("userDeptPath", userDeptPath);
		map.put("tenantID", tenantID);
		
		logger.debug("getACL ended");
		return ezBoardAdminDAO.getACL(map);
	}

	/* 2018-06-25 홍승비 - 게시판 그룹 생성 시 companyID 부여 */
	@Override
	public void createBoardGroup(BoardPropertyVO boardPropertyVO) throws Exception {
		logger.debug("createBoardGroup started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_BOARDGROUPID", boardPropertyVO.getBoardGroupID());
		map.put("v_BOARDGROUPNAME", boardPropertyVO.getBoardGroupName());
		map.put("v_BOARDGROUPNAME2", boardPropertyVO.getBoardGroupName2());
		map.put("v_BOARDGROUPNAME3", boardPropertyVO.getBoardGroupName3());
		map.put("v_BOARDGROUPNAME4", boardPropertyVO.getBoardGroupName4());
		map.put("v_ACCESSID", boardPropertyVO.getAccessID());
		map.put("v_ACCESSNAME", boardPropertyVO.getAccessName());
		map.put("v_ACCESSNAME2", boardPropertyVO.getAccessName2());
		map.put("v_PARENTBOARDID", "top");
		map.put("v_COMPANYID", boardPropertyVO.getCompanyID());
		map.put("v_TENANTID", boardPropertyVO.getTenantID());
		map.put("v_LANG", boardPropertyVO.getLoginVO().getLang());
		
		/* 2018-10-15 홍승비 - 그룹사게시판(그룹) 생성 시 구분값 부여 */
		if (boardPropertyVO.getGuBun().equals("99")) {
			map.put("isAllGroupBoard", "Y");
		}
		
		ezBoardAdminDAO.createBoardGroup(map);
		
		/* 2019-01-22 홍승비 - 그룹사게시판(그룹) 생성 시, 최상위 회사(Top)에만 '접근'권한을 부여한다. */
		ezBoardAdminDAO.createBoardGroup2(map);
		
		trunkBoard(boardPropertyVO.getTenantID());

		logger.debug("createBoardGroup ended");
	}

	@Override
	public void createBoard(BoardPropertyVO boardPropertyVO) throws Exception {
		logger.debug("createBoard started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_BOARDID", boardPropertyVO.getBoardID());
		map.put("v_BOARDNAME", boardPropertyVO.getBoardName());
		map.put("v_BOARDNAME2", boardPropertyVO.getBoardName2());
		map.put("v_BOARDNAME3", boardPropertyVO.getBoardName3());
		map.put("v_BOARDNAME4", boardPropertyVO.getBoardName4());
		map.put("v_PARENTBOARDID", boardPropertyVO.getParentBoardID());
		map.put("v_BOARDGROUPID", boardPropertyVO.getBoardGroupID());
		map.put("v_ACCESSID", boardPropertyVO.getAccessID());
		map.put("v_ACCESSNAME", boardPropertyVO.getAccessName());
		map.put("v_ACCESSNAME2", boardPropertyVO.getAccessName2());
		map.put("v_COMPANYID", boardPropertyVO.getCompanyID());
		map.put("v_TENANTID", boardPropertyVO.getTenantID());
		
		/* 2018-10-15 홍승비 - 게시판그룹의 그룹사게시판 여부를 체크하여 하위게시판 등록하도록 수정 */
		map.put("isAllGroupBoard", boardPropertyVO.getIsAllGroupBoard());
		
		ezBoardAdminDAO.createBoard_I(map);
		
		/* 2019-01-22 홍승비 - 그룹사게시판의 하위게시판 생성 시, 최상위 회사(Top)에만 '접근'권한을 부여한다. */
		ezBoardAdminDAO.createBoard_I2(map);
		
		String boardTreePath = getBoardTreePath(boardPropertyVO.getBoardID(), boardPropertyVO.getTenantID());
		map.put("boardTreePath", boardTreePath);
		
		ezBoardAdminDAO.createBoard_U(map);
		
		trunkBoard(boardPropertyVO.getTenantID());

		logger.debug("createBoard ended");
	}

	public String getBoardTreePath(String boardID, int tenantID) throws Exception {
		logger.debug("getBoardTreePath started");
		StringBuilder tempStr = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("boardID", boardID);
		map.put("tenantID", tenantID);
		
		String parentBoardID = ezBoardAdminDAO.getParentBoardID(map);
		
		if (parentBoardID != null && !parentBoardID.equals("None")) {
			while (!parentBoardID.equals("top")) {
				map.put("parentBoardID", parentBoardID);
				
				String tempBoardID = ezBoardAdminDAO.getBoardID(map);
				tempStr.append(tempBoardID);
				
				map.put("boardID", tempBoardID);
				
				parentBoardID = ezBoardAdminDAO.getParentBoardID(map);
				
				if (!parentBoardID.equals("top")) {
					tempStr.append(",");
				}
			}
		}

		logger.debug("getBoardTreePath ended");
		return tempStr.toString();
	}

	@Override
	public void saveBoardOrder(String pBoardIDList, int tenantID) throws Exception {
		logger.debug("saveBoardOrder started");

		String[] tempBoardID = pBoardIDList.split(";");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_tenantID", tenantID);
		
		for (int k = 0; k < tempBoardID.length; k++) {
			map.put("v_boardID", tempBoardID[k]);
			map.put("v_count", k + 1);
			
			ezBoardAdminDAO.saveBoardOrder(map);
		}
		
		trunkBoard(tenantID);

		logger.debug("saveBoardOrder ended");
	}

	@Override
	public void deleteBoard(String boardID, int tenantID) throws Exception {
		logger.debug("deleteBoard started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pBoardID", boardID);
		map.put("v_TENANTID", tenantID);
		
		// 해당 게시판에 대한 권한 정보 전부 삭제
		ezBoardAdminDAO.deleteBoardManage(map);
		// 해당 게시판의 정보 전부 삭제
		ezBoardAdminDAO.deleteBoardInfo(map);
		// 해당 게시판의 정보 즐겨찾기에서 전부 삭제
		ezBoardAdminDAO.deleteBoardMyBoard(map);
		// 2021-01-04 박기범 : 탭게시판포틀릿 정보에서 전부 삭제
		ezBoardAdminDAO.deleteAllTabBoard(map);
		// 삭제 예정 테이블에 해당 게시판 삽입 -> 게시판 스케줄러가 이후 해당 테이블의 레코드를 삭제함
		ezBoardAdminDAO.insertDeleteReservedBoard(map);
		
		// 게시판이 삭제되어 게시판 트리도 변경되어야 하므로, 해당 테넌트의 트리캐시를 삭제한다.
		trunkBoard(tenantID);

		logger.debug("deleteBoard ended");
	}

	@Override
	public void statusChangeBackGroundImage(BoardBackgroundVO boardBackgroundVO) throws Exception {
		logger.debug("statusChangeBackGroundImage started");

		ezBoardAdminDAO.statusChangeBackGroundImage(boardBackgroundVO);

		logger.debug("statusChangeBackGroundImage ended");
	}

	/* 2018-06-26 홍승비 - 배경이미지 저장 시  companyID 삽입 */
	@Override
	public void saveBackGroundImage(BoardBackgroundVO boardBackgroundVO) throws Exception {
		logger.debug("saveBackGroundImage started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String now = sdf.format(cal.getTime());
		String fName = boardBackgroundVO.getOrgFileName();
		
		if (fName == null) {
			map.put("v_ORGFILENAME","");
			map.put("v_SAVEFILENAME","");
		} else {
			map.put("v_ORGFILENAME",boardBackgroundVO.getOrgFileName());
			map.put("v_SAVEFILENAME",boardBackgroundVO.getSaveFileName());
		}
		
		map.put("v_BACKGROUNDID",boardBackgroundVO.getBackgroundID());
		map.put("v_REGUSERID",boardBackgroundVO.getRegUserID());
		map.put("v_REGDATE",now);
		map.put("v_WIDTH",boardBackgroundVO.getWidth());
		map.put("v_HEIGHT",boardBackgroundVO.getHeight());
		map.put("v_MODE",boardBackgroundVO.getType());
		map.put("v_COMPANYID",boardBackgroundVO.getCompanyID());
		map.put("v_TENANTID",boardBackgroundVO.getTenantID());
		
		if (boardBackgroundVO.getType().equals("NEW")) {
			ezBoardAdminDAO.saveBackGroundImage_I(map);
		} else { // 업데이트 시 고유한 배경이미지ID를 조건으로 사용하므로, companyID 조건 필요없음
			ezBoardAdminDAO.saveBackGroundImage_U(map);
		}

		logger.debug("saveBackGroundImage ended");
	}
	
	@Override
	public void deleteBackGroundImage(BoardBackgroundVO boardBackgroundVO) throws Exception {
		logger.debug("deleteBackGroundImage started");

		ezBoardAdminDAO.deleteBackGroundImage(boardBackgroundVO);

		logger.debug("deleteBackGroundImage ended");
	}

	@Override
	public void moveBoard(String orgBoardID, String newParentBoardID, String newBoardGroupID, int tenantID) throws Exception {
		logger.debug("moveBoard started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pOrgBoardID", orgBoardID);
		map.put("v_pNewParentBoardID", newParentBoardID);
		map.put("v_pNewBoardGroupID", newBoardGroupID);
		map.put("v_TENANTID", tenantID);
		
		ezBoardAdminDAO.moveBoard(map);
		ezBoardAdminDAO.moveBoard2(map);
		
		trunkBoard(tenantID);

		logger.debug("moveBoard ended");
	}
	
	@Override
	public void saveBoardProperty(BoardPropertyVO boardPropertyVO) throws Exception {
		logger.debug("saveBoardProperty started");

		String boardID = boardPropertyVO.getBoardID();
		String isBoardGroup = "";
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDID", boardPropertyVO.getBoardID());
		map.put("v_PATTACHMAX", boardPropertyVO.getAttachSizeLimit());
		map.put("v_PDESCRIPTION", boardPropertyVO.getBoardDescription());
		map.put("v_PEXPIRES", boardPropertyVO.getItemExpires());
		map.put("v_PURL", boardPropertyVO.getUrl());
		map.put("v_PREPLYNOTIFY", boardPropertyVO.getReplyNotify());
		map.put("v_PGUBUN", boardPropertyVO.getGuBun());
		map.put("v_PBOARDNAME", boardPropertyVO.getBoardName());
		map.put("v_PDELETEAFTER", boardPropertyVO.getDeleteAfter());
		map.put("v_PBOARDCOLOR", boardPropertyVO.getBoardColor());
		map.put("v_PBOARDNAME2", boardPropertyVO.getBoardName2());
		map.put("v_PBOARDNAME3", boardPropertyVO.getBoardName3());
		map.put("v_PBOARDNAME4", boardPropertyVO.getBoardName4());		
		map.put("v_PPORTLET", boardPropertyVO.getPortlet());
		map.put("v_PONELINEREPLY", boardPropertyVO.getOneLineReply());
		map.put("v_PBACKGROUND", boardPropertyVO.getBackGround());
		map.put("v_PFORM", boardPropertyVO.getFormFlag());
		map.put("v_PAPPRFLAG", boardPropertyVO.getApprFlag());
		map.put("v_PAPPRMAILFLAG", boardPropertyVO.getApprMailFlag());
		map.put("v_LIKEFLAG", boardPropertyVO.getLikeFlag());
		map.put("v_DISLIKEFLAG", boardPropertyVO.getDisLikeFlag());
		map.put("v_MAILFG_POST", boardPropertyVO.getMailFG_Post());
		map.put("v_MAILFG_MOD", boardPropertyVO.getMailFG_Mod());
		map.put("v_MAILFG_COMMENT", boardPropertyVO.getMailFG_Comment());
		map.put("v_TENANTID", boardPropertyVO.getTenantID());
		map.put("v_REACTFLAG", boardPropertyVO.getReactFlag());
		map.put("v_USEKEYWORD", boardPropertyVO.getUseKeyword());
		map.put("v_ATTACHMENTFLAG", boardPropertyVO.getAttachmentFlag());

		/* 2018-10-18 홍승비 - 게시판'그룹' 이름변경 시 하위게시판처럼 데이터가 업데이트되는 부분 수정 */
		if (boardPropertyVO.getParentBoardID().equals("top")) {
			isBoardGroup = "Y";
		}
		map.put("v_isBoardGroup", isBoardGroup);
		
		/* 2018-09-18 홍승비 - 게시판 이름변경 시 마이게시판에 등록된 게시판명도 변경되도록 수정 */
		ezBoardAdminDAO.saveBoardProperty(map);
		ezBoardAdminDAO.saveBoardProperty2(map);
		ezBoardAdminDAO.saveBoardProperty3(map);
		
		if (boardPropertyVO.getPortlet() != null) {
			if (boardPropertyVO.getPortlet().equals("Y")) {
				trunkBoard(boardPropertyVO.getTenantID());
			}
		}
		
		if (boardPropertyVO.getApprFlag() != null) {
			if (boardPropertyVO.getApprFlag().equals("Y")) {
				String[] flag = boardPropertyVO.getApprUserList().split(";");				
				
				for (int i=0; i < flag.length; i++) {
					String apprUserID = flag[i];
					String pMode = "DEL";
					
					if (i != 0) {
						pMode = "";
					}
					
					saveBoardProperty_appr(boardID, apprUserID, pMode, boardPropertyVO.getTenantID());
				}
				
				if (boardPropertyVO.getOrgApprFlag() != null) {
					if (!boardPropertyVO.getApprFlag().equals(boardPropertyVO.getOrgApprFlag())) {
						apprProperty_info(boardID, "Y", boardPropertyVO.getTenantID());
					}
				}
			} else {
				String pMode = "DEL";				
				saveBoardProperty_appr(boardID, "", pMode, boardPropertyVO.getTenantID());
				
				if (boardPropertyVO.getOrgApprFlag() != null) {
					if (!boardPropertyVO.getApprFlag().equals(boardPropertyVO.getOrgApprFlag())) {
						apprProperty_info(boardID, "N", boardPropertyVO.getTenantID());
					}
				}
			}
		}
		
		trunkBoard(boardPropertyVO.getTenantID());

		logger.debug("saveBoardProperty ended");
	}

	@Override
	public List<BoardAttributeVO> getBoardAttribute(String boardID, int tenantID) throws Exception {
		logger.debug("getBoardAttribute started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_BOARDID", boardID);
		map.put("v_TENANTID", tenantID);

		logger.debug("getBoardAttribute ended");
		return ezBoardAdminDAO.getBoardAttribute(map);
	}
	
	@Override
	public void deleteAttribute(String boardID, int tenantID) throws Exception {
		logger.debug("deleteAttribute started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_BOARDID", boardID);
		map.put("v_TENANTID", tenantID);
		
		ezBoardAdminDAO.deleteAttribute(map);

		logger.debug("deleteAttribute ended");
	}
	
	@Override
	public String saveAttribute(Document doc, LoginVO userInfo, BoardAttributeVO boardAttributeVO) throws Exception {
		logger.debug("saveAttribute started");

		String rtnValue = "";
		
		try {
			String boardID = doc.getElementsByTagName("BOARDID").item(0).getTextContent();
			deleteAttribute(boardID, userInfo.getTenantId());
			
			int colSize = doc.getElementsByTagName("COLNAME1").getLength();
			String attributeYN = "N";
			boardAttributeVO.setBoardID(boardID);
			boardAttributeVO.setTenantID(userInfo.getTenantId());
			
			for (int i = 0; i < colSize; i++) {
				boardAttributeVO.setTableCol(doc.getElementsByTagName("TABLECOL").item(i).getTextContent());
				boardAttributeVO.setSn(i + "");
				boardAttributeVO.setColName1(doc.getElementsByTagName("COLNAME1").item(i).getTextContent());
				boardAttributeVO.setColName2(doc.getElementsByTagName("COLNAME2").item(i).getTextContent());
				boardAttributeVO.setValue(doc.getElementsByTagName("VALUE").item(i).getTextContent());
				boardAttributeVO.setColType(doc.getElementsByTagName("COLTYPE").item(i).getTextContent());
				boardAttributeVO.setMust(doc.getElementsByTagName("MUST").item(i).getTextContent());
				
				ezBoardAdminDAO.saveAttribute(boardAttributeVO);
			}
			
			if (colSize > 0) {
				attributeYN = "Y";
			}
			
			boardAttributeVO.setValue(attributeYN);
			
			updateAttribute(boardAttributeVO);
			
			rtnValue = "OK";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			rtnValue = "ERROR";
			logger.error("EzBoardAdmin :: saveAttribute");
		}

		logger.debug("saveAttribute ended");
		return rtnValue;
	}
	
	@Override
	public void updateAttribute(BoardAttributeVO boardAttributeVO) throws Exception {	
		logger.debug("updateAttribute started");

		ezBoardAdminDAO.updateAttribute(boardAttributeVO);

		logger.debug("updateAttribute ended");
	}

	@Override
	public void deleteHeader(String boardID, int tenantID) throws Exception {
		logger.debug("deleteHeader started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_BOARDID", boardID);
		map.put("v_TENANTID", tenantID);
		
		ezBoardAdminDAO.deleteHeader(map);

		logger.debug("deleteHeader ended");
	}

	@Override
	public String saveHeader(Document doc, LoginVO userInfo, BoardListHeaderVO boardListHeaderVO) throws Exception {
		logger.debug("saveHeader started");

		String rtnValue = "";
		
		try {
			String boardID = doc.getElementsByTagName("BOARDID").item(0).getTextContent();
			deleteHeader(boardID, userInfo.getTenantId());
			
			int colSize = doc.getElementsByTagName("NAME1").getLength();
			boardListHeaderVO.setBoardID(boardID);
			boardListHeaderVO.setTenantID(userInfo.getTenantId());
			
			for (int i = 0; i < colSize; i++) {
				boardListHeaderVO.setSn(i + "");
				boardListHeaderVO.setName1(doc.getElementsByTagName("NAME1").item(i).getTextContent());
				boardListHeaderVO.setName2(doc.getElementsByTagName("NAME2").item(i).getTextContent());
				
				if (userInfo.getLang().equals("3")) {
					boardListHeaderVO.setName3(doc.getElementsByTagName("NAME1").item(i).getTextContent());
				} else {
					boardListHeaderVO.setName3(doc.getElementsByTagName("NAME2").item(i).getTextContent());
				}
				
				if (userInfo.getLang().equals("4")) {
					boardListHeaderVO.setName4(doc.getElementsByTagName("NAME1").item(i).getTextContent());
				} else {
					boardListHeaderVO.setName4(doc.getElementsByTagName("NAME2").item(i).getTextContent());
				}
				boardListHeaderVO.setColName(doc.getElementsByTagName("COLNAME").item(i).getTextContent());
				boardListHeaderVO.setWidth(doc.getElementsByTagName("WIDTH").item(i).getTextContent());
				boardListHeaderVO.setName("Y");
				
				/* 2018-07-25 홍승비 - 기본헤더 저장 시 다국어 저장을 위한 분기 추가 */
				if (boardListHeaderVO.getColName().equals("ATTACHMENTS") || boardListHeaderVO.getColName().equals("TITLE") || boardListHeaderVO.getColName().equals("WRITERDEPTNAME")
						|| boardListHeaderVO.getColName().equals("WRITERNAME") || boardListHeaderVO.getColName().equals("WRITEDATE") || boardListHeaderVO.getColName().equals("READCOUNT")) {
					boardListHeaderVO.setIsInitHeader("YES");
				}
				else {
					boardListHeaderVO.setIsInitHeader("NO");
				}
				
				ezBoardAdminDAO.saveHeader(boardListHeaderVO);
			}
			
			rtnValue = "OK";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			rtnValue = "ERROR";
			logger.error("EzBoardAdmin :: saveHeader :: " + e.getMessage());
		}

		logger.debug("saveHeader ended");
		return rtnValue;
	}
	
	public String getBoardTreePath(Map<String, Object> map) throws Exception {
		return ezBoardAdminDAO.getBoardTreePath(map);
	}

	@Override
	public void saveACL(Map<String, Object> map) throws Exception {
		logger.debug("saveACL started");

		int tempCount = ezBoardAdminDAO.getBoardManage(map);
		
		/* 2018-06-25 홍승비 - 게시판 권한설정 시 companyID 부여 */
		if (tempCount > 0) {
			ezBoardAdminDAO.saveACL_U(map);
		} else {
			ezBoardAdminDAO.saveACL_I(map);
		}
		
		// 접근 불가 : 하위게시판에 영향
		// 접근 허용 : 상위게시판에 영향
		String access = map.get("v_pAccess").toString();
		map.put("type", "access");
		if(access.equalsIgnoreCase("0")) {
			// 하위 게시판에 권한이 변경되어야한다.
			ezBoardAdminDAO.saveACLIncludeLowerBoard(map);			
		} else {
			// 상위 게시판 찾아서 map에 넣어두기.
			String upperBoardList = getBoardTreePath(map);
			// 상위 게시판이 존재할 경우.
			if(upperBoardList != null) {
				/* 이유정 - [웹취약점] EzBoardAdminDAO.saveACLIncludeUppderBoard 관련 파라미터 수정 */
				map.put("v_upperBoadList", upperBoardList.split(","));
				// 상위 게시판에 접근 권한만 주기.
				ezBoardAdminDAO.saveACLIncludeUppderBoard(map);
			}
		}
		
		// 하위부서 허용-불가 여부도 고려해야함.
		// ACCESSID의 BOARDGROUPACL이 N 인 경우, 하위도 N
		// ACCESSID의 BOARDGROUPACL이 Y 인 경우, 상위도 Y
		map.put("type", "boardACL");
		String boardGroupACL = map.get("v_pBoardGroupACL").toString();
		if(boardGroupACL.equalsIgnoreCase("N")) {
			// 하위 게시판에 권한이 변경되어야한다.
			ezBoardAdminDAO.saveACLIncludeLowerBoard(map);	
		} else if (boardGroupACL.equalsIgnoreCase("Y")) {
			// 상위 게시판 찾아서 map에 넣어두기.
			String upperBoardList = getBoardTreePath(map);
			// 상위 게시판이 존재할 경우.
			if(upperBoardList != null) {
				map.put("v_upperBoadList", upperBoardList.split(","));
				// 상위 게시판에 접근 권한만 주기.
				ezBoardAdminDAO.saveACLIncludeUppderBoard(map);
			}			
		}

		trunkBoard((int) map.get("v_TENANTID"));

		logger.debug("saveACL ended");
	}

	@Override
	public void deleteACL(Document doc, String companyID, int tenantID) throws Exception {
		logger.debug("deleteACL started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantID);
		
		/* 게시판 권한 삭제 시 companyID 조건 부여 */
		for (int i = 0; i < doc.getElementsByTagName("ROW").getLength(); i++) {
			map.put("v_pBoardID", doc.getElementsByTagName("BOARDID").item(i).getTextContent());
			map.put("v_pAccessID", doc.getElementsByTagName("TARGETID").item(i).getTextContent());
			
			//ezBoardAdminDAO.deleteACL(map);
			ezBoardAdminDAO.deleteACLUnderBoard(map); // 하위부서 권한까지 삭제로 변경.
		}
		
		trunkBoard(tenantID);

		logger.debug("deleteACL ended");
	}

	@Override
	public void trunkBoard(int tenantID) throws Exception {
		logger.debug("trunkBoard started");

		ezBoardAdminDAO.trunkBoard(tenantID);

		logger.debug("trunkBoard ended");
	}	

	@Override
	public void setUnderBoardIDAcl(BoardPropertyVO vo) throws Exception {	
		logger.debug("setUnderBoardIDAcl started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pBoardID", vo.getBoardID());
		map.put("v_pAccessID", vo.getAccessID());
		map.put("v_PACCESSNAME", vo.getAccessName());
		map.put("v_PACCESSNAME2", vo.getAccessName2());
		
		if (vo.getAccessLevel() != null && !vo.getAccessLevel().trim().equals("")) {
			map.put("v_PACCESSLEVEL", Integer.parseInt(vo.getAccessLevel()));
		} else {
			map.put("v_PACCESSLEVEL", -1);
		}
		
		map.put("v_PACCESS", vo.getAccess_());
		map.put("v_PPARENTBOARDID", vo.getParentBoardID());
		map.put("v_PBOARDADMIN_FG", vo.getBoardAdmin_FG());
		map.put("v_PLISTVIEW_FG", vo.getListView_FG());
		map.put("v_PREAD_FG", vo.getRead_FG());
		map.put("v_PWRITE_FG", vo.getWrite_FG());
		map.put("v_PREPLY_FG", vo.getReply_FG());
		map.put("v_PDELETE_FG", vo.getDelete_FG());
		map.put("v_PINHERIT_FG", vo.getInherit_FG());
		map.put("v_PPOSTNOTICE", vo.getPostNotice());
		map.put("v_PBOARDGROUPACL", vo.getBoardGroupACL());
		map.put("v_COMPANYID", vo.getCompanyID());
		map.put("v_TENANTID", vo.getTenantID());
		map.put("isAllGroupBoard", vo.getIsAllGroupBoard());
		/* 2019-09-19 홍승비 - 권한의 TYPE값 추가 */
		map.put("v_TYPE", vo.getType());
		
		// 해당 userID가 여러 회사의 레코드를 가지고 있을 수 있으므로, companyID 조건이 필요하다.
		int tempCount = ezBoardAdminDAO.getBoardManage(map);
		
		/* 2018-06-26 홍승비 - 게시판 권한전파 시 companyID 조건+삽입 추가 */
		if (tempCount > 0) {
			ezBoardAdminDAO.setUnderBoardIDAcl_U(map);
		} else {
			ezBoardAdminDAO.setUnderBoardIDAcl_I(map);
		}
		
		logger.debug("setUnderBoardIDAcl ended");
	}

	/* 2018-06-26 홍승비 - 권한전파 시 companyID 조건 추가 */
	@Override
	public void setUnderBoardIDAcl2(String defaultBoardID, String boardID, String parentBoardID, String isAllGroupBoard, String companyID, int tenantID) throws Exception {
		logger.debug("setUnderBoardIDAcl2 started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PDEFAULTBOARDID", defaultBoardID);
		map.put("v_pBoardID", boardID);
		map.put("v_PPARENTBOARDID", parentBoardID);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantID);
		map.put("isAllGroupBoard", isAllGroupBoard);
		
		// 기존 게시판 권한을 삭제하고, 하위게시판에 권한을 전파한다. (기존 게시판권한 삭제 시 companyID 불필요)
		ezBoardAdminDAO.deleteBoardManage(map);
		// 권한삽입 시 companyID 필드 추가함
		ezBoardAdminDAO.setUnderBoardIDAcl2(map);
		
		logger.debug("setUnderBoardIDAcl2 ended");
	}

	/* 2018-06-26 홍승비 - 권한복사 시 companyID 추가 */
	@Override
	public String copyBoardAcl(Document doc, String companyID, int tenantID) throws Exception {
		logger.debug("copyBoardAcl started");
		
		String rtnValue = "";
		
		try {
			String copyList = doc.getElementsByTagName("COPYLIST").item(0).getTextContent();
			String[] copyListArray = copyList.split(",");
			int copyListSize = copyListArray.length;
			
			Map<String, Object> map = new HashMap<String, Object>();
			
			map.put("v_COMPANYID", companyID);
			map.put("v_TENANTID", tenantID);
			
			for (int i = 0; i < doc.getElementsByTagName("BOARDID").getLength(); i++) {
				String boardID = doc.getElementsByTagName("BOARDID").item(i).getTextContent(); // 복사한 권한을 부여할 게시판들 (목표점)
				String defaultBoardID = doc.getElementsByTagName("DEFAULTBOARDID").item(0).getTextContent(); // 복사할 권한이 들어있는 기존의 게시판 (시작점)
				String parentBoardID = doc.getElementsByTagName("PARENTBOARDID").item(i).getTextContent(); // 복사한 권한을 부여할 게시판들의 부모 게시판ID

				if (boardID.equals(defaultBoardID)) { // 시작점과 목표점이 동일하다면, 넘어간다.
					continue;
				}
				
				map.put("v_pBoardID", boardID);
				map.put("v_PDEFAULTBOARDID", defaultBoardID);
				map.put("v_PPARENTBOARDID", parentBoardID);
				/* 이유정 - [웹취약점] EzBoardAdminDAO.copyBoardAcl 관련 파라미터 수정 */
				map.put("copyListArray", copyListArray);
				
				// 기존 TBL_Board_BoardManage 테이블에 존재하는 권한 레코드(테넌트+게시판ID 조건)를 삭제한다.
				ezBoardAdminDAO.deleteBoardManage(map);
				// 새로운 권한 부여 시 companyID를 삽입한다.
				ezBoardAdminDAO.copyBoardAcl(map);
				
				/* 2019-11-13 홍승비 - 권한을 복사할 목표 게시판이 하위게시판인 경우, 해당 게시판의 상위게시판에도 접근권한을 부여 */
				String parentBoardIDs = getAllUpperBoardID(boardID, tenantID);
				String parentBoardIDList[] = parentBoardIDs.split(",");
				int parentBoardIDListSize = parentBoardIDList.length;
				
				for (int u = 0; u < parentBoardIDListSize - 1; u++) {
					for (int a = 0; a < copyListSize; a++) {
						Map<String, Object> mapU = new HashMap<String, Object>();
						BoardPropertyVO boardManageProp = getACL(defaultBoardID, copyListArray[a], tenantID);
						
						// 접근권한이 '허용'인 경우에만 상위로 접근권한을 전파
						if (boardManageProp != null && boardManageProp.getAccess_() != null && boardManageProp.getAccess_().equals("1")) {
							mapU.put("v_ORGBOARDID", defaultBoardID); // 권한을 복사할 기존 게시판ID
							mapU.put("v_BOARDID", parentBoardIDList[u]); // 권한의 복사 목표점이 되는 게시판ID
							mapU.put("v_PARENTBOARDID", parentBoardIDList[u + 1]); // 권한의 복사 목표점이 되는 게시판의 부모게시판ID
							mapU.put("v_BOARDGROUPACL", boardManageProp.getBoardGroupACL());
							mapU.put("v_ACCESSID", copyListArray[a]);
							mapU.put("v_TENANTID", tenantID);
							
							ezBoardAdminDAO.saveACLIncludeUppderBoard2(mapU); // copyBoardAcl과 유사하나, 권한 중에서는 접근권한만을 복사한다.
						}
					}
				}
			}
			
			/* 2018-10-10 홍승비 - 권한복사 시 기존 트리캐시 제거하도록 수정 */
			trunkBoard(tenantID);
			rtnValue = "OK";
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			rtnValue = "ERROR";
		}

		logger.debug("copyBoardAcl ended");
		return rtnValue;
	}

	@Override
	public void saveBoardProperty_appr(String boardID, String apprUserID, String pMode, int tenantID) throws Exception {
		logger.debug("saveBoardProperty_appr started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pBoardID", boardID);
		map.put("v_pAPPRUSERID", apprUserID);
		map.put("v_pMODE", pMode);
		map.put("v_TENANTID", tenantID);
		
		// 해당 게시판의 기존의 모든 승인자 제거
		if (pMode.equals("DEL")) {
			ezBoardAdminDAO.saveBoardProperty_appr_D(map);
		}
		// 승인자 리스트에 존재하는대로 승인자 추가
		if (apprUserID != null && !apprUserID.equals("")) {
			ezBoardAdminDAO.saveBoardProperty_appr_I(map);
		}

		logger.debug("saveBoardProperty_appr ended");
	}

	@Override
	public void apprProperty_info(String boardID, String mode, int tenantID) throws Exception {
		logger.debug("apprProperty_info started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDID", boardID);
		map.put("v_PMODE", mode);
		map.put("v_TENANTID", tenantID);
		
		ezBoardAdminDAO.apprProperty_info(map);

		logger.debug("apprProperty_info ended");
	}

	@Override
	public void setBoardForm(String boardID, String formLocation, int tenantID) throws Exception {
		logger.debug("setBoardForm started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDID", boardID);
		map.put("v_PFORMLOCATION", formLocation);
		map.put("v_TENANTID", tenantID);
		
		ezBoardAdminDAO.setBoardForm(map);

		logger.debug("setBoardForm ended");
	}
	
	/* 2019-05-29 홍승비 - 하위부서 허용/불가여부 체크하여 권한 가져오는 쿼리 추가 (파라미터 오버로딩) */
	@Override
	public BoardPropertyVO getACL(String pBoardID, String userDeptPath, int tenantID, int isDept, int isEqualDept) throws Exception {
		logger.debug("getACL started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("pBoardID", pBoardID);
		map.put("userDeptPath", userDeptPath);
		map.put("tenantID", tenantID);
		map.put("v_ISDEPT", isDept);
		map.put("v_ISEQUALDEPT", isEqualDept);
		
		//logger.debug("map in getACL  ::  " + map.toString());
		logger.debug("getACL ended");
		return ezBoardAdminDAO.getACL(map);
	}
	
	/* 2019-05-29 홍승비 - 하위부서 허용/불가여부 체크하여 게시판그룹의 관리자 권한 가져오는 쿼리 추가 */
	public String checkIfBoardGroupAdmin2(String pRootBoardID, String accessID, int tenantID, int isDept, int isEqualDept, boolean isBoardGroup) throws Exception {
		logger.debug("checkIfBoardGroupAdmin2 started");
		
		if (pRootBoardID.equalsIgnoreCase("top") || pRootBoardID.equalsIgnoreCase("all")) {
			//logger.debug("checkIfBoardGroupAdmin2 : pRootBoardID is '" + pRootBoardID + "', return empty String");
			return "";
		}

		Map<String, Object> map = new HashMap<String, Object>();
		String result = "";
		
		map.put("v_pBoardID", pRootBoardID);
		map.put("v_pAccessID", accessID);
		map.put("v_TENANTID", tenantID);
		map.put("v_ISDEPT", isDept);
		map.put("v_ISEQUALDEPT", isEqualDept);
		map.put("isBoardGroup", isBoardGroup);

		//logger.debug("map in checkIfBoardGroupAdmin2  ::  " + map.toString());
		result = ezBoardAdminDAO.checkIfBoardGroupAdmin2(map);
		
		if (result == null) {
			result = "";
		}
		
		logger.debug("checkIfBoardGroupAdmin2 ended");
		return result;
	}
	
	/* 2019-11-08 홍승비 - 전달된 값으로 BOARDTREEPATH를 업데이트하는 메서드 */
	@Override
	public void updateBoardTreePath(String boardID, String newBoardTreePath, int tenantID) throws Exception {
		logger.debug("updateBoardTreePath started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_BOARDID", boardID);
		map.put("v_BOARDTREEPATH", newBoardTreePath);
		map.put("v_TENANTID", tenantID);
		
		ezBoardAdminDAO.updateBoardTreePath(map);
		logger.debug("updateBoardTreePath ended");
	}
	
	/* 2019-11-13 홍승비 - 주어진 게시판ID에 대하여 자신을 포함한 모든 상위게시판들을 문자열로 이어붙여 가져오는 메서드 */
	@Override
	public String getAllUpperBoardID(String boardID, int tenantID) throws Exception {
		logger.debug("getAllUpperBoardProperty started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		StringJoiner parentBoardIDs = new StringJoiner(",");
		parentBoardIDs.add(boardID);
		String tempBoardID = boardID;
		
		boolean isParentBoardExist = true;
		while (isParentBoardExist == true) {
			map.put("boardID", tempBoardID);
			map.put("tenantID", tenantID);
			
			String tempParentBoardID = ezBoardAdminDAO.getParentBoardID(map);
			if (tempParentBoardID != null) {
				parentBoardIDs.add(tempParentBoardID);
				tempBoardID = tempParentBoardID;
			} else {
				isParentBoardExist = false;
			}
			map.clear();
		}

		logger.debug("getAllUpperBoardProperty ended");
		return parentBoardIDs.toString();
	}
	
	/* 2020-01-16 홍승비 - 전달된 값으로 BOARDGROUPID를 업데이트하는 메서드 */
	@Override
	public void updateBoardGroupID(String boardID, String newBoardGroupID, int tenantID) throws Exception {
		logger.debug("updateBoardGroupID started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_BOARDID", boardID);
		map.put("v_NEWBOARDGROUPID", newBoardGroupID);
		map.put("v_TENANTID", tenantID);
		
		ezBoardAdminDAO.updateBoardGroupID(map);
		logger.debug("updateBoardGroupID ended");
	}
	
	/* 2019-10-11 홍승비 - 공지사항 게시판 레코드 삭제 */
	@Override
	public void deleteNoticeBoard(int tenantId, String companyID) throws Exception {
		logger.debug("deleteNoticeBoard started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);
		
		ezBoardAdminDAO.deleteNoticeBoard(map);
		
		logger.debug("deleteNoticeBoard ended");
	}

	/* 2019-10-11 홍승비 - 공지사항 게시판 레코드 갱신 */
	@Override
	public void updateNoticeBoard(String boardID, int tenantId, String companyID) throws Exception {
		logger.debug("updateNoticeBoard started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDID", boardID);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);
		
		ezBoardAdminDAO.deleteNoticeBoard(map); // 기존 공지사항 게시판 삭제 후 새로운 레코드 삽입
		ezBoardAdminDAO.insertNoticeBoard(map);
		
		logger.debug("updateNoticeBoard ended");
	}
	
	/* 2020-12-03 박기범 - 탭게시판 레코드 삭제 */
	@Override
	public void deleteTabBoard(int tabId, int tenantId, String companyID) throws Exception {
		logger.debug("deleteTabBoard started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TABID", tabId);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);
		
		ezBoardAdminDAO.deleteTabBoard(map);
		
		logger.debug("deleteTabBoard ended");
	}

	/* 2020-12-03 박기범 - 탭게시판 레코드 갱신 */
	@Override
	public void updateTabBoard(int tabId, String boardID, int tenantId, String companyID, String boardName, String boardName2) throws Exception {
		logger.debug("updateTabBoard started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TABID", tabId);
		map.put("v_PBOARDID", boardID);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);
		map.put("v_BOARDNAME", boardName);
		map.put("v_BOARDNAME2", boardName2);

		// 그룹사 게시판일 경우 일괄 삭제
		// 2023-05-25 이사라 : 시큐어코딩 문자열 비교 오류 수정
		if ( " ".equals(companyID)) {
			ezBoardAdminDAO.deleteAllComTabBoard(map);
		}
		
		ezBoardAdminDAO.deleteTabBoard(map); // 기존 탭게시판 삭제 후 새로운 레코드 삽입
		ezBoardAdminDAO.insertTabBoard(map);
		
		logger.debug("updateTabBoard ended");
	}

	@Override
	public String getUseFormFlag(String boardID, int tenantID) throws Exception {
		return ezBoardAdminDAO.getUseFormFlag(boardID, tenantID);
	}

	/**
	 * 게시판 내의 관리용 회사 목록을 가져 옴.
	 * @return OrganDeptVO 객체들의 목록. 에러 발생 시 빈 목록 반환
	 * 사용자가 ADMIN_MASTER 권한을 가지고 있지 않다면,
	 * 사용자가 COMPANY_MANAGER 또는 BOARD_MANAGER의 권한을 가지고 있지 않은 회사를 목록에서 제거합니다.
	 * 에러 발생 시 빈 목록을 반환합니다.
	 **/
	@Override
	public List<OrganDeptVO> getListCompanyInBoard(String userID, String primary, int tenantID) {
		try {
			List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(primary, tenantID);

			/*OrganAuth organAuth = commonUtil.makeOrganAuth(userID, tenantID);

			if (!organAuth.isAuth(AdminAuth.ADMIN_MASTER, "")) {
				list.removeIf(vo
						-> !organAuth.isAuth(AdminAuth.COMPANY_MANAGER, vo.getCn())
						&& !organAuth.isAuth(AdminAuth.BOARD_MANAGER, vo.getCn()));
			}*/

			return list;
		} catch (Exception e) {
			return Collections.emptyList();
		}
	}
	
	@Override
	public void deleteMyBoardData(String type, String boardID, int tenantID) throws Exception {
	    logger.debug("deleteMyBoardData started");

	    Map<String, Object> map = new HashMap<String, Object>();
	    map.put("boardID", boardID);
	    map.put("tenantID", tenantID);

	    if ("MyBoards".equals(type)) {
	        ezBoardAdminDAO.deleteMyBoardsOnCategoryChange(map);
	    } else if ("MyBoardTree".equals(type)) {
	        ezBoardAdminDAO.deleteMyBoardTreeOnCategoryChange(map);
	    }

	    logger.debug("deleteMyBoardData ended");
	}

	@Override
	public int getBoardItemCnt(String boardID, int tenantId) throws Exception {
	    logger.debug("getBoardItemCnt started");

	    Map<String, Object> map = new HashMap<String, Object>();
	    map.put("boardID", boardID);
	    map.put("tenantID", tenantId);

	    int result = ezBoardAdminDAO.getBoardItemCnt(map);
	    
	    logger.debug("getBoardItemCnt ended");
	    return result;
	}
}
