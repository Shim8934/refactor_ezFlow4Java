package egovframework.ezEKP.ezBoard.service.impl;

import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.FileVisitResult;
import java.nio.file.FileVisitor;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.nio.file.attribute.BasicFileAttributes;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.Properties;
import java.util.StringJoiner;
import java.util.UUID;
import java.util.stream.Collectors;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import egovframework.ezEKP.ezBoard.vo.BoardKeywordVO;
import egovframework.ezEKP.ezBoard.vo.BoardReplyAttachVO;
import egovframework.let.utl.fcc.service.EgovStringUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.apache.logging.log4j.util.Strings;
import org.jasypt.commons.CommonUtils;
import org.jsoup.select.Elements;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.util.FileCopyUtils;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGKlibService;
import egovframework.ezEKP.ezBoard.dao.EzBoardDAO;
import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezBoard.vo.BoardAccessVO;
import egovframework.ezEKP.ezBoard.vo.BoardAttachVO;
import egovframework.ezEKP.ezBoard.vo.BoardConfigVO;
import egovframework.ezEKP.ezBoard.vo.BoardDeleteItemVO;
import egovframework.ezEKP.ezBoard.vo.BoardDisLikeListVO;
import egovframework.ezEKP.ezBoard.vo.BoardItemVO;
import egovframework.ezEKP.ezBoard.vo.BoardLikeListVO;
import egovframework.ezEKP.ezBoard.vo.BoardLineReplyVO;
import egovframework.ezEKP.ezBoard.vo.BoardListHeaderVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezBoard.vo.BoardMyFavoriteVO;
import egovframework.ezEKP.ezBoard.vo.BoardPollConfigVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezBoard.vo.BoardReadVO;
import egovframework.ezEKP.ezBoard.vo.BoardScrapListVO;
import egovframework.ezEKP.ezBoard.vo.BoardThumbnailVO;
import egovframework.ezEKP.ezBoard.vo.BoardTreeVO;
import egovframework.ezEKP.ezBoard.vo.BoardUserScrapContListVO;
import egovframework.ezEKP.ezBoard.vo.BoardUserScrapContVO;
import egovframework.ezEKP.ezBoard.vo.BoardVO;
import egovframework.ezEKP.ezBoard.vo.MealDataVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.dao.EzOrganDAO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.fcc.service.KlibUtil;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.json.simple.JSONObject;
import org.w3c.dom.NodeList;

@Service("EzBoardService")
public class EzBoardServiceImpl extends EgovAbstractServiceImpl implements EzBoardService {

	@Resource(name="EzBoardDAO")
	private EzBoardDAO ezBoardDAO;
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties globals;
	
	@Resource(name = "EzBoardAdminService")
	private EzBoardAdminService ezBoardAdminService;

	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name = "EzOrganAdminService")
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;

	@Value("#{globals['Globals.DbType']}")
	private String dbType;
	
	@Autowired
	private KlibUtil klibUtil;
	
	@Resource(name = "EzOrganDAO")
	private EzOrganDAO ezOrganDAO;

	private static final Logger logger = LoggerFactory.getLogger(EzBoardServiceImpl.class);

	@Override
	public List<BoardVO> getLeft_BoardSTD(String redirectBoardID, int tenantID) throws Exception {
		logger.debug("getLeft_BoardSTD started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_REDIRECTBOARDID", redirectBoardID);
		map.put("v_TENANTID", tenantID);

		logger.debug("getLeft_BoardSTD ended");
		return ezBoardDAO.getLeft_BoardSTD(map);
	}	

	@Override
	public List<BoardVO> get_apprUserList(String boardID, int tenantID) throws Exception {
		logger.debug("get_apprUserList started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDID", boardID);
		map.put("v_TENANTID", tenantID);

		logger.debug("get_apprUserList ended");
		return ezBoardDAO.get_apprUserList(map);
	}

	/* 2018-06-27 홍승비 - 즐겨찾기 탭 표출 시 companyID 조건 추가 */
	@Override
	public List<BoardMyFavoriteVO> get_favoriteList(String userID, String pMode, String companyID, int tenantID, String lang) throws Exception {
		logger.debug("get_favoriteList started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_USERID", userID);
		map.put("v_MODE", pMode);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantID);
		map.put("v_LANG", lang);
		
		BoardMyFavoriteVO boardMyFavoriteVO = ezBoardDAO.getBoardNewBoardOrder(map);
		
		/* 2019-01-07 홍승비 - boardMyFavoriteVO에 대한 !equals("") 비교조건 제거 */
		if (boardMyFavoriteVO != null && boardMyFavoriteVO.getBoardId() != null) {
			ezBoardDAO.updateMyBoard(boardMyFavoriteVO);
		} else {
			ezBoardDAO.insertBoardNewBoardOrder(map);
			
			BoardMyFavoriteVO boardMyFavoriteVO2 = new BoardMyFavoriteVO();
			
			boardMyFavoriteVO2.setTabUsed("Y");
			boardMyFavoriteVO2.setViewOrder("0");
			
			ezBoardDAO.updateMyBoard(boardMyFavoriteVO2);
		}
		
		logger.debug("get_favoriteList ended");
		/* 2018-06-28 홍승비 - 각 회사의 초기 즐겨찾기로 '새게시물'이 아닌 게시판도 각 회사마다 다르게 표시 가능하도록 쿼리 수정 */
		return ezBoardDAO.get_favoriteList(map);
	}

	@Override
	public String get_parentBoardName(String boardIdList, int boardIdListCount, String lang, int tenantID, Locale locale) throws Exception {
		logger.debug("get_parentBoardName started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_LANG", lang);
		map.put("v_TENANTID", tenantID);
		
		String[] boardIDs      = boardIdList.split(";");
		StringBuilder rtnValue = new StringBuilder();
		
		for (int k = 0; k < boardIdListCount; k++) {
			map.put("v_BOARDID", boardIDs[k]);
			
			String boardGroupID = ezBoardDAO.getBoardGroupID(map);
			
			if (boardGroupID != null && !boardGroupID.equals("")) {
				map.put("v_BOARDGROUPID", boardGroupID);
				rtnValue.append(ezBoardDAO.getBoardName(map) + ";");
			} else {
				rtnValue.append(egovMessageSource.getMessage("ezBoard.hyj01", locale));
			}
		}

		logger.debug("get_parentBoardName ended");
		return rtnValue.toString();
	}

	@Override
	public String getBoardProperty(String pBoardID, BoardPropertyVO boardInfo, LoginVO userInfo) throws Exception {
		logger.debug("getBoardProperty started");

		BoardPropertyVO strProp = getBoardProperty(pBoardID, userInfo.getTenantId());
		
		StringBuilder sb = new StringBuilder();
		
		sb.append("<NODES>");
		sb.append("<NODE>");
		sb.append("<ITEMEXPIRES>" + strProp.getItemExpires() + "</ITEMEXPIRES>");
		sb.append("<ATTACHLIMIT>" + strProp.getAttachSizeLimit() + "</ATTACHLIMIT>");
		sb.append("<DESCRIPTION><![CDATA[" + strProp.getBoardDescription() + "]]></DESCRIPTION>");
		sb.append("<BOARDNAME><![CDATA[" + strProp.getBoardName() + "]]></BOARDNAME>");
		sb.append("<BOARDNAME2><![CDATA[" + strProp.getBoardName2() + "]]></BOARDNAME2>");
		sb.append("<BOARDNAME3><![CDATA[" + strProp.getBoardName3() + "]]></BOARDNAME3>");
		sb.append("<BOARDNAME4><![CDATA[" + strProp.getBoardName4() + "]]></BOARDNAME4>");
		sb.append("<ALERTPOSTITEM><![CDATA[" + strProp.getAlertPostItem() + "]]></ALERTPOSTITEM>");
		sb.append("<REPLYNOTIFY><![CDATA[" + strProp.getReplyNotify() + "]]></REPLYNOTIFY>");
		sb.append("<URL><![CDATA[" + strProp.getUrl() + "]]></URL>");
		sb.append("<GUBUN><![CDATA[" + strProp.getGuBun() + "]]></GUBUN>");
		sb.append("<DELETEAFTER><![CDATA[" + strProp.getDeleteAfter() + "]]></DELETEAFTER>");
		sb.append("<BOARDCOLOR><![CDATA[" + strProp.getBoardColor() + "]]></BOARDCOLOR>");
		sb.append("<BOARDNO><![CDATA[" + strProp.getBoardNo() + "]]></BOARDNO>");
		sb.append("<PORTLET><![CDATA[" + strProp.getPortlet() + "]]></PORTLET>");
		sb.append("<ONELINEREPLY>" + strProp.getOneLineReply() + "</ONELINEREPLY>");
		sb.append("<BACKGROUND>" + strProp.getBackGround() + "</BACKGROUND>");
		sb.append("<FORMFLAG>" + strProp.getFormFlag() + "</FORMFLAG>");
		sb.append("<APPRFLAG>" + strProp.getApprFlag() + "</APPRFLAG>");
		sb.append("<APPRMAILFLAG>" + strProp.getApprMailFlag() + "</APPRMAILFLAG>");
		sb.append("</NODE>");
		sb.append("</NODES>");

		logger.debug("getBoardProperty ended");
        return sb.toString();
	}
	
	@Override
	public BoardPropertyVO getBoardProperty(String pBoardID, int tenantID) throws Exception {
		logger.debug("getBoardProperty started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_BOARDID", pBoardID);
		map.put("v_TENANTID", tenantID);

		logger.debug("getBoardProperty ended");
		return ezBoardDAO.getBoardProperty(map);
	}
	
	@Override
	public BoardConfigVO getBoardList_Config(String userId, int tenantID) throws Exception {
		logger.debug("getBoardList_Config started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_USERID", userId);
		map.put("v_TENANTID", tenantID);

		logger.debug("getBoardList_Config ended");
		return ezBoardDAO.getBoardList_Config(map);
	}

	/* 2018-10-29 홍승비 - 그룹사게시판의 게시물리스트 헤더에 반드시 회사ID 포함하도록 수정 (익명게시판 제외) */
	@Override
	public List<BoardListHeaderVO> getListHeader(LoginVO userInfo, BoardVO ezBoardVO) throws Exception {
		logger.debug("getListHeader started");

		List<BoardListHeaderVO> listHeaderListVO;
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_LISTCODE", ezBoardVO.getBoardType());
		map.put("v_PSTRLANG", ezBoardVO.getLang());
		map.put("v_TENANTID", ezBoardVO.getTenantID());
		
		// 나의게시물, 임시보관함, 게시물 승인의 경우 게시판 ID가 없음
		if (!ezBoardVO.getBoardType().equals("2") && ezBoardVO.getBoardId() != null) {
			BoardPropertyVO boardProp = getBoardProperty(ezBoardVO.getBoardId(), ezBoardVO.getTenantID());
			
			if (boardProp.getBoardGroupID() != null) {
				BoardPropertyVO boardGroupProp = getBoardProperty(boardProp.getBoardGroupID(), ezBoardVO.getTenantID());
				
				if (boardGroupProp.getGuBun() != null && boardGroupProp.getGuBun().equals("99")) {
					map.put("v_isAllGroupBoard", "Y");
				}
			}
		}

		if(ezBoardVO.getMode() != null && ezBoardVO.getMode().equals("scrap")){
			map.put("v_LISTCODE", "S");
		}
		
		listHeaderListVO = ezBoardDAO.getListHeader(map);
		
		/* 2019-04-04 홍승비 - 좋아요 사용 게시판의 경우 임의로 헤더 조정 */
		if (ezBoardVO.getLikeFlag() != null && ezBoardVO.getLikeFlag().equals("Y")) {
			BoardListHeaderVO likeAddListHeaderVO = new BoardListHeaderVO();
			likeAddListHeaderVO.setColName("LIKECOUNT");
			likeAddListHeaderVO.setName(egovMessageSource.getMessage("ezBoard.hsb10", userInfo.getLocale()));
			likeAddListHeaderVO.setWidth("50");
			listHeaderListVO.add(likeAddListHeaderVO);
		}
		
		/* 2023-04-06 기민혁 - 싫어요 사용 게시판의 경우 임의로 헤더 조정 */
		if (ezBoardVO.getDisLikeFlag() != null && ezBoardVO.getDisLikeFlag().equals("Y")) {
			BoardListHeaderVO disLikeAddListHeaderVO = new BoardListHeaderVO();
			disLikeAddListHeaderVO.setColName("DISLIKECOUNT");
			disLikeAddListHeaderVO.setName(egovMessageSource.getMessage("ezBoard.kmh07", userInfo.getLocale()));
			disLikeAddListHeaderVO.setWidth("50");
			listHeaderListVO.add(disLikeAddListHeaderVO);
		}

		logger.debug("getListHeader ended");
		return listHeaderListVO;
	}

	@Override
	public void setListOrder(LoginVO userInfo, String pBoardList, String pDelBoardList) throws Exception {
		logger.debug("setListOrder started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyID());
		map.put("userID", userInfo.getId());
		
		String[] boardIDs = pBoardList.split(";");
		String[] delBoardIDs = pDelBoardList.split(";");
		
		for (int k = 0; k < boardIDs.length; k++) {
			map.put("boardID", boardIDs[k]);
			map.put("count", k + 1);
			
			ezBoardDAO.setListOrder_U(map);
		}
		ezBoardDAO.setListOrder(map);
		
		for (int k = 0; k < delBoardIDs.length; k++) {
			map.put("boardID", delBoardIDs[k]);
			
			ezBoardDAO.setListOrder_D(map);
		}

		logger.debug("setListOrder ended");
	}

	/* 2018-06-27 홍승비 - 새게시물 카운트 시 companyID 조건 추가 */
	@Override
	public int getNewItemListCount(LoginVO userInfo)  throws Exception {
		logger.debug("getNewItemListCount started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pUserID", userInfo.getId());
		map.put("v_COMPANYID", userInfo.getCompanyID());
		map.put("v_TENANTID", userInfo.getTenantId());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));

		logger.debug("getNewItemListCount ended");
		return ezBoardDAO.getNewItemListCount(map);
	}

	@Override
	public BoardConfigVO getPersonalCount(LoginVO userInfo) throws Exception {
		logger.debug("getPersonalCount started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_USERID", userInfo.getId());
		map.put("v_TENANTID", userInfo.getTenantId());
		
		BoardConfigVO boardConfigVO = new BoardConfigVO();
		
		String tempString = ezBoardDAO.getBoardConfig(map);
		
		if (tempString != null && !tempString.equals("")) {
			boardConfigVO = ezBoardDAO.getPersonalCount(userInfo);
		} else {
			boardConfigVO.setListCount(20);
			boardConfigVO.setPreview("OFF");
			boardConfigVO.setPreviewWList(50);
			boardConfigVO.setPreviewWContent(50);
			boardConfigVO.setPreviewHList(50);
			boardConfigVO.setPreviewHContent(50);
		}

		logger.debug("getPersonalCount ended");
		return boardConfigVO;
	}

	/* 2018-06-27 홍승비 - 새게시물 리스트 표출 시 companyID 조건 추가 */
	@Override
	public List<HashMap<String, Object>> getNewItemList(BoardListVO boardListVO, Map<String, String> orderByMap) throws Exception {
		logger.debug("getNewItemList started");
		
		if (orderByMap.get("orderByCol") == null || "".equals(orderByMap.get("orderByCol"))) {
			orderByMap.put("orderByCol", "WRITEDATE");
			orderByMap.put("orderByColDesc", "Y");
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", boardListVO.getUserID());
		map.put("v_COMPANYID", boardListVO.getWriterCompanyID());
		map.put("v_TENANTID", boardListVO.getTenantID());
		map.put("v_PSTARTROW", boardListVO.getStartRow());
		map.put("v_PENDROW", boardListVO.getEndRow());
		
		if (orderByMap.get("orderByCol") != null) {
			map.put("iv_PORDERBYCOL1", orderByMap.get("orderByCol"));
			if (orderByMap.get("orderByColDesc") != null) {
				map.put("iv_PORDERBYCOL1DESC", orderByMap.get("orderByColDesc"));
			}
		}
		
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("rowCount", boardListVO.getEndRow() - (boardListVO.getStartRow() - 1));
		map.put("limit", boardListVO.getStartRow() - 1);
		
		logger.debug("getNewItemList ended");
		return ezBoardDAO.getNewItemList(map);
	}

	@Override
	public void setBoardList_Config(BoardConfigVO boardConfigVO) throws Exception {
		logger.debug("setBoardList_Config started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_USERID", boardConfigVO.getUserId());
		map.put("v_TENANTID", boardConfigVO.getTenantID());
		
		String configFlag = ezBoardDAO.getBoardConfig(map);
		
		if (configFlag != null && !configFlag.equals("")) {
			ezBoardDAO.setBoardList_Config_U(boardConfigVO); 
		} else {
			ezBoardDAO.setBoardList_Config_I(boardConfigVO); 
		}

		logger.debug("setBoardList_Config ended");
	}

	@Override
	public int getBrdNewItemCount(String userID, int tenantID) throws Exception {
		logger.debug("getBrdNewItemCount started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pUserID", userID);
		map.put("v_TENANTID", tenantID);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));

		logger.debug("getBrdNewItemCount ended");
		return ezBoardDAO.getBrdNewItemCount(map);
	}

	@Override
	public int getThumbNailCount(BoardMyFavoriteVO myFavoriteVO) throws Exception {
		logger.debug("getThumbNailCount started");

		String tempString = ezBoardDAO.getBoardApprList(myFavoriteVO);
		int rtnCount = 0;
		
		if (tempString != null && !tempString.equals("")) {
			rtnCount = ezBoardDAO.getThumbNailCount(myFavoriteVO);
		} else {
			rtnCount = ezBoardDAO.getThumbNailCount2(myFavoriteVO);
		}

		logger.debug("getThumbNailCount ended");
		return rtnCount;
	}

	@Override
	public int getBrdTotalItemCount(BoardMyFavoriteVO myFavoriteVO) throws Exception {
		logger.debug("getBrdTotalItemCount started");

		String tempString = ezBoardDAO.getBoardApprJoinItem(myFavoriteVO);
		int rtnCount = 0;
		
		 /* 2018-09-14 홍승비 - 포틀릿에 표출되는 게시판에서 공지사항 리스트 제거 */
		if (myFavoriteVO.getType().equals("portletBoard")) {
			myFavoriteVO.setType("1");
		}
		
		if (tempString != null && !tempString.equals("")) {
			rtnCount = ezBoardDAO.getBrdTotalItemCount(myFavoriteVO);
		} else {
			rtnCount = ezBoardDAO.getBrdTotalItemCount2(myFavoriteVO);
		}

		logger.debug("getBrdTotalItemCount ended");
		return rtnCount;
	}

	@Override
	public int getQNABrdTotalItemCount(BoardMyFavoriteVO myFavoriteVO) throws Exception {
		logger.debug("getQNABrdTotalItemCount started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDID", myFavoriteVO.getBoardId());
		map.put("v_PUSERID", myFavoriteVO.getUserId());
		map.put("v_PTYPE", myFavoriteVO.getType());
		map.put("v_PADMINTYPE", myFavoriteVO.getBoardAdmin_FG());
		map.put("v_TENANTID", myFavoriteVO.getTenantID());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));

		logger.debug("getQNABrdTotalItemCount ended");
		return ezBoardDAO.getQNABrdTotalItemCount(map);
	}

	/* 2018-06-27 홍승비 - 즐겨찾기 탭 회사별로 구분 */
	@Override
	public void setTabUsed(String pUserID, String pBoardList, String tabUsed, String companyID, int tenantID) throws Exception {
		logger.debug("setTabUsed started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_BOARDID", pBoardList);
		map.put("v_TABUSED", tabUsed);
		map.put("v_USERID", pUserID);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantID);
		
		if (pBoardList != null && pBoardList.equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) {
			ezBoardDAO.setTabUsed(map);
			ezBoardDAO.setTabUsed2(map);
		} else {
			ezBoardDAO.setTabUsed2(map);
		}

		logger.debug("setTabUsed ended");
	}
	
	@Override
	public void setMainImageID(String mainImageID, String itemID, int tenantID) throws Exception {
		logger.debug("setMainImageID started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_IMAGEID", mainImageID);
		map.put("v_ITEMID", itemID);
		map.put("v_TENANTID", tenantID);
		
		ezBoardDAO.setMainImageID(map);
		logger.debug("setMainImageID ended");
	}

	@Override
	public String setNotiOrder(String itemID, int tenantID) throws Exception {
		logger.debug("setNotiOrder started");

		String rtnValue = "";
		
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			
			map.put("tenantID", tenantID);
			
			for (int k = 0; k < itemID.split(";").length; k++) {
				map.put("itemID", itemID.split(";")[k]);
				map.put("sn", k + 1);
				
				ezBoardDAO.setNotiOrder(map);
			}
			
			rtnValue = "OK";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			rtnValue = "ERROR";
		}

		logger.debug("setNotiOrder ended");
		return rtnValue;
	}

	@Override
	public void photoListUpdate(String imageID, String boardID, String content, String file_Path, String itemID, String mainFg, String oFileName, int tenantID) throws Exception {
		logger.debug("photoListUpdate started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_ImageID", imageID);
		map.put("v_BoardID", boardID);
		map.put("v_FilePath", file_Path);
		map.put("v_FileContent", content);
		map.put("v_OFileName", oFileName);
		map.put("v_TENANTID", tenantID);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		ezBoardDAO.photoListUpdate(map);
		
		if (mainFg.equals("Y")) {
			setMainImageID(imageID, itemID, tenantID);
		}

		logger.debug("photoListUpdate ended");
	}

	@Override
	public void updateCopyItem(String destItemID, String orgItemID, String destBoardID, String orgBoardID, int tenantID) throws Exception {
		logger.debug("updateCopyItem started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("orgItemID", orgItemID); // 복사 전의 게시물ID
		map.put("destItemID", destItemID); // 복사 후의 게시물ID
		map.put("orgBoardID", orgBoardID); // 복사 전의 게시판ID
		map.put("destBoardID", destBoardID); // 복사 후의 게시판ID
		map.put("tenantID", tenantID);
		
		ezBoardDAO.updateCopyItem(map);
		
		/* 2019-12-17 홍승비 - 게시물 복사 시 테넌트 컨피그에 따라 조회자정보 유지 */
		String isReadCountCopyUsed = ezCommonService.getTenantConfig("copyReadCountBoardItem", tenantID);
		if (StringUtils.isNotBlank(isReadCountCopyUsed) && ("COPY".equals(isReadCountCopyUsed) || "ALL".equals(isReadCountCopyUsed))) {
			ezBoardDAO.insertBoardItemReadForCopy(map);
		}

		logger.debug("updateCopyItem ended");
	}

	@Override
	public void updateMoveItem(String destItemID, String orgItemID, String destBoardID, String orgBoardID, int tenantID) throws Exception {
		logger.debug("updateMoveItem started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("itemID", orgItemID); // 이동 전의 게시물ID
		map.put("destItemID", destItemID); // 이동 후의 게시물ID
		map.put("orgBoardID", orgBoardID); // 이동 전의 게시판ID
		map.put("destBoardID", destBoardID); // 이동 후의 게시판ID
		map.put("tenantID", tenantID);
		
		ezBoardDAO.updateMoveItem(map);
		ezBoardDAO.deleteBoardItem(map);
		
		/* 2019-12-17 홍승비 - 게시물 이동 시, 테넌트 컨피그에 따라 기존의 조회자정보를 유지함 */
		String isReadCountCopyUsed = ezCommonService.getTenantConfig("copyReadCountBoardItem", tenantID);
		if (StringUtils.isNotBlank(isReadCountCopyUsed) && ("MOVE".equals(isReadCountCopyUsed) || "ALL".equals(isReadCountCopyUsed))) {
			ezBoardDAO.updateBoardItemRead(map);
		} else {
			ezBoardDAO.deleteBoardItemRead2(map);
		}
		
		ezBoardDAO.deleteBoardReply(map);

		logger.debug("updateMoveItem ended");
	}

	@Override
	public void setBoardList_Config2(String userID, String listCount, String previewMode, String list, String content, int tenantID) throws Exception {
		logger.debug("setBoardList_Config2 started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_USERID", userID);
		map.put("v_LISTCNT", listCount);
		map.put("v_PREVIEWMODE", previewMode);
		map.put("v_LIST", list);
		map.put("v_CONTENT", content);
		map.put("v_TENANTID", tenantID);
		
		String tempString = ezBoardDAO.getBoardConfig(map);
		
		if (tempString != null && !tempString.equals("")) {
			ezBoardDAO.setBoardList_Config2_U(map);
		} else {
			ezBoardDAO.setBoardList_Config2_I(map);
		}

		logger.debug("setBoardList_Config2 ended");
	}

	@Override
	public void photoListAlbumEdit(String boardID, String itemID, String title, String content, int tenantID) throws Exception {
		logger.debug("photoListAlbumEdit started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_BOARDID", boardID);
		map.put("v_ITEMID", itemID);
		map.put("v_TITLE", title);
		map.put("v_CONTENT", content);
		map.put("v_TENANTID", tenantID);
		
		ezBoardDAO.photoListAlbumEdit(map);

		logger.debug("photoListAlbumEdit ended");
	}

	@Override
	public void photoListAlbumEditTemp(String boardID, String itemID, String title, String content, int tenantID) throws Exception {
		logger.debug("photoListAlbumEditTemp started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_BOARDID", boardID);
		map.put("v_ITEMID", itemID);
		map.put("v_TITLE", title);
		map.put("v_CONTENT", content);
		map.put("v_TENANTID", tenantID);
		
		ezBoardDAO.photoListAlbumEditTemp(map);

		logger.debug("photoListAlbumEditTemp ended");
	}

	@Override
	public void deleteItem(String mode, String itemID, String boardID, String realPath, int tenantID) throws Exception {
		logger.debug("deleteItem started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("itemID", itemID);
		map.put("boardID", boardID);
		map.put("tenantID", tenantID);
		
		ezBoardDAO.deleteBoardItem(map);
		ezBoardDAO.deleteBoardReply(map);
		ezBoardDAO.deleteBoardItemRead2(map);
		
		if (mode != null && (mode.equals("PHOTO") || mode.equals("MOVIE"))) {
			BoardListVO boardListVO = new BoardListVO();
			boardListVO.setItemID(itemID);
			boardListVO.setTenantID(tenantID);
			
			ezBoardDAO.deleteImageItem(boardListVO);
		}
		
		ezBoardDAO.insertDeleteReservedItem(map);

		logger.debug("deleteItem ended");
	}

	public void deleteTempItem(String itemID, String boardID, String realPath, int tenantID) throws Exception {
		logger.debug("deleteTempItem started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("itemID", itemID);
		map.put("boardID", boardID);
		map.put("tenantID", tenantID);
		
		ezBoardDAO.deleteBoardItemTemp(map);
		ezBoardDAO.deleteBoardReply(map);
		ezBoardDAO.deleteBoardItemRead2(map);
		
		ezBoardDAO.insertDeleteReservedItem(map);
		
		logger.debug("deleteTempItem ended");
	}

	@Override
	public void photoListDel(String boardID, String imageID, int tenantID) throws Exception {
		logger.debug("photoListDel started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_BoardID", boardID);
		map.put("v_ImageID", imageID);
		map.put("v_TENANTID", tenantID);
		
		ezBoardDAO.photoListDel(map);

		logger.debug("photoListDel ended");
	}

	/* 2018-10-29 홍승비 - 그룹사게시판의 게시물리스트 헤더에 반드시 회사ID 포함하도록 수정 (익명게시판 제외) */
	@Override
	public List<BoardListHeaderVO> getListHeaderBoardID(LoginVO userInfo, BoardVO ezBoardVO) throws Exception {
		logger.debug("getListHeaderBoardID started");
		
		List<BoardListHeaderVO> listHeaderListVO;
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDID", ezBoardVO.getBoardId());
		map.put("v_PSTRLANG", ezBoardVO.getLang());
		map.put("v_LISTCODE", ezBoardVO.getBoardType());
		map.put("v_TENANTID", ezBoardVO.getTenantID());
		
		// 게시판검색 기능의 경우 게시판 ID가 'all'로 들어감
		if (!ezBoardVO.getBoardType().equals("2") && ezBoardVO.getBoardId() != null && !ezBoardVO.getBoardId().equalsIgnoreCase("all")) {
			BoardPropertyVO boardProp = getBoardProperty(ezBoardVO.getBoardId(), ezBoardVO.getTenantID());
			
			if (boardProp != null && boardProp.getBoardGroupID() != null) {
				BoardPropertyVO boardGroupProp = getBoardProperty(boardProp.getBoardGroupID(), ezBoardVO.getTenantID());
				
				if (boardGroupProp.getGuBun() != null && boardGroupProp.getGuBun().equals("99")) {
					map.put("v_isAllGroupBoard", "Y");
				}
			}
		}
		
		/* 2021-12-31 홍승비 - 홈페이지 게시판의 경우, 일반 게시판과 리스트 헤더를 동일하게 사용 */
		if (ezBoardVO.getBoardType().equals("8")) {
			ezBoardVO.setBoardType("1");
			map.put("v_LISTCODE", "1");
		}
		
		String tempString = ezBoardDAO.getListOptionBoardID(map);
		
		if (tempString != null && !tempString.equals("")) {
			logger.debug("getListHeaderBoardID ended");
			listHeaderListVO = ezBoardDAO.getListHeaderBoardID(map);
		} else {
			logger.debug("getListHeaderBoardID ended");
			listHeaderListVO = ezBoardDAO.getListHeader(map);
		}
		
		/* 2019-04-04 홍승비 - 좋아요 사용 게시판의 경우 임의로 헤더 조정 */
		if (ezBoardVO.getLikeFlag() != null && ezBoardVO.getLikeFlag().equals("Y")) {
			BoardListHeaderVO likeAddListHeaderVO = new BoardListHeaderVO();
			likeAddListHeaderVO.setColName("LIKECOUNT");
			likeAddListHeaderVO.setName(egovMessageSource.getMessage("ezBoard.hsb10", userInfo.getLocale()));
			likeAddListHeaderVO.setWidth("50");
			listHeaderListVO.add(likeAddListHeaderVO);
		}
		
		/* 2023-04-06 기민혁 - 싫어요 사용 게시판의 경우 임의로 헤더 조정 */
		if (ezBoardVO.getDisLikeFlag() != null && ezBoardVO.getDisLikeFlag().equals("Y")) {
			BoardListHeaderVO disLikeAddListHeaderVO = new BoardListHeaderVO();
			disLikeAddListHeaderVO.setColName("DISLIKECOUNT");
			disLikeAddListHeaderVO.setName(egovMessageSource.getMessage("ezBoard.kmh07", userInfo.getLocale()));
			disLikeAddListHeaderVO.setWidth("50");
			listHeaderListVO.add(disLikeAddListHeaderVO);
		}
		
		return listHeaderListVO;
	}

	@Override
	public List<BoardAttachVO> brdGetItemAttachmentInfo(String pItemID, int tenantID) throws Exception {
		logger.debug("brdGetItemAttachmentInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("itemID", pItemID);
		map.put("tenantID", tenantID);

		logger.debug("brdGetItemAttachmentInfo ended");
		return ezBoardDAO.brdGetItemAttachmentInfo(map);
	}
	
	@Override
	public List<BoardAttachVO> brdGetPhotoItemAttachmentInfo(String pItemID, int tenantID) throws Exception {
		logger.debug("brdGetPhotoItemAttachmentInfo started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("itemID", pItemID);
		map.put("tenantID", tenantID);
		
		// 2024-10-24 조수빈 - DB에 저장되어있는 filepath는 s_로 시작하는 썸네일용 파일 경로이므로 해당 문자열을 삭제하여 원본파일 경로를 반환하도록 한다.
		List<BoardAttachVO> resList = ezBoardDAO.brdGetPhotoItemAttachmentInfo(map);
		
		for (BoardAttachVO vo : resList) {
			vo.setFilePath(vo.getFilePath().replace("/s_", "/"));
		}
		
		logger.debug("brdGetPhotoItemAttachmentInfo ended");
		
		return resList;
	}
	
	/* 2018-11-22 홍승비 - 그룹사게시판에서는 조회자의 deptID를 가져오지 않도록 수정 */
	@Override
	public StringBuffer getReaderList(String boardID, String itemID, String userID, String lang, String companyID, int tenantID, int pageNum, int perCount, String offset) throws Exception {
		logger.debug("getReaderList started");
		
		/* 2018-02-06 김보미 - 페이징 */
    	if (pageNum == 0) {
    		pageNum = 1;
    	}
    	
    	int startRowNum = ((pageNum - 1) * perCount);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("boardID", boardID);
		map.put("itemID", itemID);
		map.put("userID", userID);
		map.put("lang", lang);
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		map.put("start", startRowNum);
		map.put("perCount", perCount);
		
		BoardPropertyVO boardProp = getBoardProperty(boardID, tenantID);
		
		if (boardProp.getBoardGroupID() != null) {
			BoardPropertyVO boardGroupProp = getBoardProperty(boardProp.getBoardGroupID(), tenantID);
			
			if (boardGroupProp.getGuBun() != null && boardGroupProp.getGuBun().equals("99")) {
				map.put("v_isAllGroupBoard", "Y");
			}
		}
		
		List<BoardReadVO> readerList = ezBoardDAO.getReaderList(map);
		
		StringBuffer resultXML = new StringBuffer();
		
		resultXML.append("<DOCLIST>");
		
		int totalCount = getReaderListCount(boardID, itemID, userID, lang, tenantID);
		int totalPage = (int) ((float)totalCount / perCount);
		if (totalCount % 10 != 0) {
			totalPage = totalPage + 1;
		}
		
		resultXML.append("<TOTALCNT>" + totalCount + "</TOTALCNT>");
		resultXML.append("<PAGECNT>" + totalPage + "</PAGECNT>");
		resultXML.append("<PERSONALCNT>" + perCount + "</PERSONALCNT>");
    	resultXML.append("<LISTVIEWDATA>");
    	
		resultXML.append("<ROWS>");
		for (BoardReadVO vo : readerList) {
			String userTitle = "";
			String userDeptName = "";
			if (vo.getUserTitle() != null) {
				userTitle = vo.getUserTitle();
			}
			if (vo.getUserDeptName() != null) {
				userDeptName =  vo.getUserDeptName();
			}
			resultXML.append("<ROW>");
			resultXML.append("<CELL><USERID><![CDATA[" + vo.getUserID() + "]]></USERID><DEPTID><![CDATA[" + vo.getDeptID() + "]]></DEPTID><VALUE><![CDATA[" + vo.getUserName() + "]]></VALUE></CELL>");
			resultXML.append("<CELL><VALUE><![CDATA[" + userDeptName + "]]></VALUE></CELL>");
			resultXML.append("<CELL><VALUE><![CDATA[" + userTitle + "]]></VALUE></CELL>");
			resultXML.append("<CELL><VALUE><![CDATA[" + commonUtil.getDateStringInUTC(vo.getReadDate(), offset, false) + "]]></VALUE></CELL>");			
			resultXML.append("</ROW>");
		}
		
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		resultXML.append("</DOCLIST>");
		
		logger.debug("getReaderList ended");
		return resultXML;
	}

	@Override
	public int getNoticePostItemCount(BoardVO boardVO) throws Exception {
		return ezBoardDAO.getNoticePostItemCount(boardVO);
	}

	@Override
	public List<HashMap<String, Object>> getNoticePostItem(BoardVO ezBoardVO, int personalCount) throws Exception {
		logger.debug("getNoticePostItem started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		int start = 0;
		int end = 0;
		start = ((ezBoardVO.getPageNum() - 1) * personalCount) + 1;
		end = (ezBoardVO.getPageNum() * personalCount);
		
		BoardMyFavoriteVO boardMyFavoriteVO = new BoardMyFavoriteVO();
		boardMyFavoriteVO.setBoardId(ezBoardVO.getBoardId());
		boardMyFavoriteVO.setTenantID(ezBoardVO.getTenantID());
		
		String tempString = ezBoardDAO.getBoardApprJoinItem(boardMyFavoriteVO);
		
		if (tempString != null && ! tempString.equals("")) {
			map.put("v_TEMP", "1");
		} else {
			map.put("v_TEMP", "");
		}
		
		map.put("v_PBOARDID", ezBoardVO.getBoardId());
		map.put("v_START", start);
		map.put("v_END", end);
		map.put("v_TENANTID", ezBoardVO.getTenantID());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("rowCount", end - (start - 1));
		map.put("limit", start - 1);
		map.put("bType", ezBoardVO.getBoardType());

		logger.debug("getNoticePostItem ended");
		return ezBoardDAO.getNoticePostItem(map);
	}

	@Override
	public List<HashMap<String, Object>> getBoardListItem(String boardID, String userID, int startRow, int endRow, int boardCount, String orderOption1, String orderOption2, Map<String, String> orderByMap, String type, int tenantID) throws Exception {
		logger.debug("getBoardListItem started");
		String pType = type;
		
		String orderByCol2 = "";
		String orderByCol2Desc = "N";
		if (orderByMap.get("orderByCol") == null || "".equals(orderByMap.get("orderByCol"))) {
			orderByMap.put("orderByCol", "PARENTWRITEDATE");
			orderByMap.put("orderByColDesc", "Y");
			orderByCol2 = "UPPERITEMIDTREE";
		}
		
		BoardMyFavoriteVO boardMyFavoriteVO = new BoardMyFavoriteVO();
		boardMyFavoriteVO.setBoardId(boardID);
		boardMyFavoriteVO.setTenantID(tenantID);
		
		String tempString = ezBoardDAO.getBoardApprJoinItem(boardMyFavoriteVO);
		
		/* 2018-09-14 홍승비 - 포틀릿에 표출되는 게시판에서 공지사항 리스트 제거 */
		if (pType.equals("portletBoard")) {
			pType = "1";		
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", userID);
		map.put("v_PBOARDID", boardID);
		map.put("v_TENANTID", tenantID);
		map.put("type", pType);
		map.put("startRow", startRow);
		map.put("endRow", endRow);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("tempString", tempString);
		
		if (orderByMap.get("orderByCol") != null) {
			map.put("iv_PORDERBYCOL1", orderByMap.get("orderByCol"));
			if (orderByMap.get("orderByColDesc") != null) {
				map.put("iv_PORDERBYCOL1DESC", orderByMap.get("orderByColDesc"));
			}
		}
		
		map.put("iv_PORDERBYCOL2", orderByCol2);
		map.put("iv_PORDERBYCOL2DESC", orderByCol2Desc);
		map.put("rowCount", endRow - (startRow - 1));
		map.put("limit", startRow - 1);
		
		logger.debug("getBoardListItem ended");
		return ezBoardDAO.getBoardListItem(map);
	}

	@Override
	public List<HashMap<String, Object>> getQnABoardListItem(String boardId, String userID, int startRow, int endRow, int boardCount, String orderOption1, String orderOption2, Map<String, String> orderByMap, String type, String adminType, int tenantID) throws Exception {
		logger.debug("getQnABoardListItem started");

		String orderByCol2 = "";
		String orderByCol2Desc = "N";
		if (orderByMap.get("orderByCol") == null || "".equals(orderByMap.get("orderByCol"))) {
			orderByMap.put("orderByCol", "PARENTWRITEDATE");
			orderByMap.put("orderByColDesc", "Y");
			orderByCol2 = "UPPERITEMIDTREE";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", userID);
		map.put("v_PBOARDID", boardId);
		map.put("adminType", adminType);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("startRow", startRow);
		map.put("endRow", endRow);
		map.put("type", type);
		
		if (orderByMap.get("orderByCol") != null) {
			map.put("iv_PORDERBYCOL1", orderByMap.get("orderByCol"));
			if (orderByMap.get("orderByColDesc") != null) {
				map.put("iv_PORDERBYCOL1DESC", orderByMap.get("orderByColDesc"));
			}
		}
		
		map.put("iv_PORDERBYCOL2", orderByCol2);
		map.put("iv_PORDERBYCOL2DESC", orderByCol2Desc);
		map.put("v_TENANTID", tenantID);
		map.put("rowCount", endRow - (startRow - 1));
		map.put("limit", startRow - 1);

		logger.debug("getQnABoardListItem ended");
		return ezBoardDAO.getQnABoardListItem(map);
	}

	@Override
	public List<HashMap<String, Object>> getSearchBoardItemList(BoardListVO boardListVO, BoardVO boardVO, Map<String, String> searchMap, Map<String, String> orderByMap) throws Exception {
		logger.debug("getSearchBoardItemList started");

		String orderByCol2 = "";
		String orderByCol2Desc = "N";
		if (orderByMap.get("orderByCol") == null || "".equals(orderByMap.get("orderByCol"))) {
			orderByMap.put("orderByCol", "PARENTWRITEDATE");
			orderByMap.put("orderByColDesc", "Y");
			orderByCol2 = "UPPERITEMIDTREE";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", boardListVO.getUserID());
		map.put("v_PBOARDID", boardVO.getBoardId());
		map.put("v_PSTARTROW", boardListVO.getStartRow());
		map.put("v_PENDROW", boardListVO.getEndRow());
		map.put("v_PTOTALCOUNT", boardListVO.getTotalCount());
		
		if (orderByMap.get("orderByCol") != null) {
			map.put("iv_PORDERBYCOL1", orderByMap.get("orderByCol"));
			if (orderByMap.get("orderByColDesc") != null) {
				map.put("iv_PORDERBYCOL1DESC", orderByMap.get("orderByColDesc"));
			}
		}
		
		map.put("iv_PORDERBYCOL2", orderByCol2);
		map.put("iv_PORDERBYCOL2DESC", orderByCol2Desc);
		map.put("v_PSUBFLAG", boardVO.getSubFlag());
		map.put("v_TITLE", boardVO.getTitle());
		map.put("v_WRITERNAME", boardVO.getWriterName());
		map.put("v_ABSTRACT", boardVO.getABSTRACT());
		map.put("v_TENANTID", boardVO.getTenantID());
		map.put("lang", boardVO.getLang());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("rowCount", boardListVO.getEndRow() - (boardListVO.getStartRow() - 1));
		map.put("limit", boardListVO.getStartRow() - 1);
		map.put("v_KEYWORD", boardVO.getKeyword());
		map.put("v_useKeywordFlag", boardVO.getUseKeyword());
		
		// 20240216 : 김진홍 : CSAP 인증 처리 : searchQuery 를 파라미터로 변경
		for (String key : searchMap.keySet()) {
			map.put(key, searchMap.get(key));
		}
		
		BoardMyFavoriteVO myFavoriteVO = new BoardMyFavoriteVO();
		
		myFavoriteVO.setBoardId(boardVO.getBoardId());
		myFavoriteVO.setTenantID(boardVO.getTenantID());
		
		logger.debug("getSearchBoardItemList ended");
		return ezBoardDAO.getSearchBoardItemList(map);
	}

	@Override
	public List<HashMap<String, Object>> getThumbnailList(BoardListVO boardListVO, BoardVO boardVO, Map<String, String> orderByMap) throws Exception {
		logger.debug("getThumbnailList started");

		String orderByCol2 = "";
		String orderByCol2Desc = "N";
		if (orderByMap.get("orderByCol") == null || "".equals(orderByMap.get("orderByCol"))) {
			orderByMap.put("orderByCol", "PARENTWRITEDATE");
			orderByMap.put("orderByColDesc", "Y");
			orderByCol2 = "UPPERITEMIDTREE";
		}
		
		BoardMyFavoriteVO boardMyFavoriteVO = new BoardMyFavoriteVO();
		
		boardMyFavoriteVO.setBoardId(boardVO.getBoardId());
		boardMyFavoriteVO.setTenantID(boardVO.getTenantID());
		
		String tempString = ezBoardDAO.getBoardApprJoinItem(boardMyFavoriteVO);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", boardListVO.getUserID());
		map.put("v_TENANTID", boardVO.getTenantID());
		map.put("tempString", tempString);
		map.put("type", boardVO.getType());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("startRow", boardListVO.getStartRow());
		map.put("endRow", boardListVO.getEndRow());
		map.put("v_PBOARDID", boardVO.getBoardId());
		
		if (orderByMap.get("orderByCol") != null) {
			map.put("iv_PORDERBYCOL1", orderByMap.get("orderByCol"));
			if (orderByMap.get("orderByColDesc") != null) {
				map.put("iv_PORDERBYCOL1DESC", orderByMap.get("orderByColDesc"));
			}
		}
		
		map.put("iv_PORDERBYCOL2", orderByCol2);
		map.put("iv_PORDERBYCOL2DESC", orderByCol2Desc);
		map.put("rowCount", boardListVO.getEndRow() - (boardListVO.getStartRow() - 1));
		map.put("limit", boardListVO.getStartRow() - 1);

		logger.debug("getThumbnailList ended");
		return ezBoardDAO.getThumbnailList(map);
	}

	@Override
	public List<HashMap<String, Object>> getSearchThumbnailList(BoardListVO boardListVO, BoardVO boardVO, Map<String, String> searchMap, Map<String, String> orderByMap) throws Exception {
		logger.debug("getSearchThumbnailList started");

		String orderByCol2 = "";
		String orderByCol2Desc = "N";
		if (orderByMap.get("orderByCol") == null || "".equals(orderByMap.get("orderByCol"))) {
			orderByMap.put("orderByCol", "PARENTWRITEDATE");
			orderByMap.put("orderByColDesc", "Y");
			orderByCol2 = "UPPERITEMIDTREE";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", boardListVO.getUserID());
		map.put("v_PBOARDID", boardVO.getBoardId());
		map.put("v_PSTARTROW", boardListVO.getStartRow());
		map.put("v_PENDROW", boardListVO.getEndRow());
		map.put("v_PTOTALCOUNT", boardListVO.getTotalCount());
		
		if (orderByMap.get("orderByCol") != null) {
			map.put("iv_PORDERBYCOL1", orderByMap.get("orderByCol"));
			if (orderByMap.get("orderByColDesc") != null) {
				map.put("iv_PORDERBYCOL1DESC", orderByMap.get("orderByColDesc"));
			}
		}
		
		map.put("iv_PORDERBYCOL2", orderByCol2);
		map.put("iv_PORDERBYCOL2DESC", orderByCol2Desc);
		map.put("v_PSUBFLAG", boardVO.getSubFlag());
		map.put("v_TITLE", boardVO.getTitle());
		map.put("v_WRITERNAME", boardVO.getWriterName());
		map.put("v_ABSTRACT", boardVO.getABSTRACT());
		map.put("v_TENANTID", boardVO.getTenantID());
		map.put("v_TEMP", "");
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("rowCount", boardListVO.getEndRow() - (boardListVO.getStartRow() - 1));
		map.put("limit", boardListVO.getStartRow() - 1);
		map.put("v_useKeywordFlag", boardVO.getUseKeyword());
		map.put("v_KEYWORD", boardVO.getKeyword());
		
		for (String key : searchMap.keySet()) {
			map.put(key, searchMap.get(key));
		}
		
		BoardMyFavoriteVO myFavoriteVO = new BoardMyFavoriteVO();
		
		myFavoriteVO.setBoardId(boardVO.getBoardId());
		myFavoriteVO.setTenantID(boardVO.getTenantID());
		
		String tempString = ezBoardDAO.getBoardApprList(myFavoriteVO);
		
		if (tempString != null && !tempString.equals("")) {
			map.put("v_APPRFLAG", "Y");
		}

		logger.debug("getSearchThumbnailList ended");
		return ezBoardDAO.getSearchThumbnailList(map);
	}

	@Override
	public List<HashMap<String, Object>> getMyNoticePostItem(LoginVO userInfo, String type, int start, int end) throws Exception {
		logger.debug("getMyNoticePostItem started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", userInfo.getId());
		map.put("v_TENANTID", userInfo.getTenantId());
		map.put("v_COMPANYID", userInfo.getCompanyID());
		map.put("lang", userInfo.getLang()); // 게시판명 다국어 처리로 lang값(1 ~ 4)을 그대로 전달하도록 수정
		map.put("v_TYPE", type);
		map.put("v_START", start);
		map.put("v_END", end);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("rowCount", end - (start - 1));
		map.put("limit", start - 1);

		logger.debug("getMyNoticePostItem ended");
		return ezBoardDAO.getMyNoticePostItem(map);
	}
	
	@Override
	public List<HashMap<String, Object>> getMyBoardListItem(LoginVO userInfo, int startRow, int endRow, int boardCount, String orderOption1, String orderOption2, Map<String, String> orderByMap) throws Exception {
		logger.debug("getMyBoardListItem started");

		if (orderByMap.get("orderByCol") == null || "".equals(orderByMap.get("orderByCol"))) {
			orderByMap.put("orderByCol", "WRITEDATE");
			orderByMap.put("orderByColDesc", "Y");
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", userInfo.getId());
		map.put("v_COMPANYID", userInfo.getCompanyID());
		map.put("v_TENANTID", userInfo.getTenantId());
		map.put("lang", userInfo.getLang());
		map.put("v_PSTARTROW", startRow);
		map.put("v_PENDROW", endRow);
		
		if (orderByMap.get("orderByCol") != null) {
			map.put("iv_PORDERBYCOL1", orderByMap.get("orderByCol"));
			if (orderByMap.get("orderByColDesc") != null) {
				map.put("iv_PORDERBYCOL1DESC", orderByMap.get("orderByColDesc"));
			}
		}
		
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("rowCount", endRow - (startRow - 1));
		map.put("limit", startRow - 1);

		logger.debug("getMyBoardListItem ended");
		return ezBoardDAO.getMyBoardListItem(map);
	}

	/* 2018-06-26 홍승비 - 마이게시판 > 임시보관함 게시물 표출 시 companyID 조건 추가 */
	@Override
	public List<HashMap<String, Object>> getMyBoardListItemTemp(LoginVO userInfo, int startRow, int endRow, int boardCount, String orderOption1, String orderOption2, Map<String, String> orderByMap) throws Exception {
		logger.debug("getMyBoardListItemTemp started");

		if (orderByMap.get("orderByCol") == null || "".equals(orderByMap.get("orderByCol"))) {
			orderByMap.put("orderByCol", "WRITEDATE");
			orderByMap.put("orderByColDesc", "Y");
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", userInfo.getId());
		map.put("v_COMPANYID", userInfo.getCompanyID());
		map.put("v_TENANTID", userInfo.getTenantId());
		map.put("lang", userInfo.getLang());
		map.put("v_PSTARTROW", startRow);
		map.put("v_PENDROW", endRow);
		
		if (orderByMap.get("orderByCol") != null) {
			map.put("iv_PORDERBYCOL1", orderByMap.get("orderByCol"));
			if (orderByMap.get("orderByColDesc") != null) {
				map.put("iv_PORDERBYCOL1DESC", orderByMap.get("orderByColDesc"));
			}
		}
		
		map.put("rowCount", endRow - (startRow - 1));
		map.put("limit", startRow - 1);

		logger.debug("getMyBoardListItemTemp ended");
		return ezBoardDAO.getMyBoardListItemTemp(map);
	}

	/* 2018-06-26 홍승비 - 승인게시물 셀렉트 시 companyID 조건 추가 */
	@Override
	public List<HashMap<String, Object>> getApprBoardListItem(LoginVO userInfo, int startRow, int endRow, int boardCount, String orderOption1, String orderOption2, Map<String, String> orderByMap) throws Exception {
		logger.debug("getApprBoardListItem started");

		if (orderByMap.get("orderByCol") == null || "".equals(orderByMap.get("orderByCol"))) {
			orderByMap.put("orderByCol", "WRITEDATE");
			orderByMap.put("orderByColDesc", "Y");
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", userInfo.getId());
		map.put("v_COMPANYID", userInfo.getCompanyID());
		map.put("v_TENANTID", userInfo.getTenantId());
		map.put("lang", userInfo.getLang());
		map.put("v_PSTARTROW", startRow);
		map.put("v_PENDROW", endRow);
		
		if (orderByMap.get("orderByCol") != null) {
			map.put("iv_PORDERBYCOL1", orderByMap.get("orderByCol"));
			if (orderByMap.get("orderByColDesc") != null) {
				map.put("iv_PORDERBYCOL1DESC", orderByMap.get("orderByColDesc"));
			}
		}
		
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("rowCount", endRow - (startRow - 1));
		map.put("limit", startRow - 1);

		logger.debug("getApprBoardListItem ended");
		return ezBoardDAO.getApprBoardListItem(map);
	}

	@Override
	public List<HashMap<String, Object>> getSearchMyBoardItemList(BoardListVO boardListVO, BoardVO boardVO, Map<String, String> searchMap, Map<String, String> orderByMap) throws Exception {
		logger.debug("getSearchMyBoardItemList started");

		// 20240215 : 김진홍 : CSAP 인증 처리
		if (orderByMap.get("orderByCol") == null || "".equals(orderByMap.get("orderByCol"))) {
			orderByMap.put("orderByCol", "WRITEDATE");
			orderByMap.put("orderByColDesc", "Y");
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("lang", boardVO.getLang());
		map.put("v_PUSERID", boardListVO.getUserID());
		map.put("v_PSTARTROW", boardListVO.getStartRow());
		map.put("v_PENDROW", boardListVO.getEndRow());
		map.put("v_PTOTALCOUNT", boardListVO.getTotalCount());
		
		if (orderByMap.get("orderByCol") != null) {
			map.put("iv_PORDERBYCOL1", orderByMap.get("orderByCol"));
			if (orderByMap.get("orderByColDesc") != null) {
				map.put("iv_PORDERBYCOL1DESC", orderByMap.get("orderByColDesc"));
			}
		}
		
		map.put("v_PORDERBYMAIN", boardListVO.getOrderByMain());
		map.put("v_PSUBFLAG", boardVO.getSubFlag());
		map.put("v_TENANTID", boardVO.getTenantID());
		map.put("v_COMPANYID", boardListVO.getWriterCompanyID());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("rowCount", boardListVO.getEndRow() - (boardListVO.getStartRow() - 1));
		map.put("limit", boardListVO.getStartRow() - 1);
		map.put("v_KEYWORD", boardVO.getKeyword());
		
		for (String key : searchMap.keySet()) {
			map.put(key, searchMap.get(key));
		}
		
		logger.debug("getSearchMyBoardItemList ended");
		return ezBoardDAO.getSearchMyBoardItemList(map);
	}

	@Override
	public List<HashMap<String, Object>> getSearchMyBoardItemListTemp(BoardListVO boardListVO, BoardVO boardVO, Map<String, String> searchMap, Map<String, String> orderByMap) throws Exception {
		logger.debug("getSearchMyBoardItemListTemp started");

		// 20240215 : 김진홍 : CSAP 인증 처리
		if (orderByMap.get("orderByCol") == null || "".equals(orderByMap.get("orderByCol"))) {
			orderByMap.put("orderByCol", "WRITEDATE");
			orderByMap.put("orderByColDesc", "Y");
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("lang", boardVO.getLang());
		map.put("v_PUSERID", boardListVO.getUserID());
		map.put("v_PSTARTROW", boardListVO.getStartRow());
		map.put("v_PENDROW", boardListVO.getEndRow());
		map.put("v_PTOTALCOUNT", boardListVO.getTotalCount());
		
		if (orderByMap.get("orderByCol") != null) {
			map.put("iv_PORDERBYCOL1", orderByMap.get("orderByCol"));
			if (orderByMap.get("orderByColDesc") != null) {
				map.put("iv_PORDERBYCOL1DESC", orderByMap.get("orderByColDesc"));
			}
		}
		
		map.put("v_PORDERBYMAIN", boardListVO.getOrderByMain());
		map.put("v_PSUBFLAG", boardVO.getSubFlag());
		map.put("v_TENANTID", boardVO.getTenantID());
		map.put("v_COMPANYID", boardListVO.getWriterCompanyID());
		map.put("rowCount", boardListVO.getEndRow() - (boardListVO.getStartRow() - 1));
		map.put("limit", boardListVO.getStartRow() - 1);
		map.put("v_KEYWORD", boardVO.getKeyword());
		
		for (String key : searchMap.keySet()) {
			map.put(key, searchMap.get(key));
		}
		
		logger.debug("getSearchMyBoardItemListTemp ended");
		return ezBoardDAO.getSearchMyBoardItemListTemp(map);
	}

	@Override
	public int getCheckItemID(String itemID, String boardType, String userDeptPath, int tenantID, int isDept, int isEqualDept) throws Exception {
		logger.debug("getCheckItemID started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_ITEMID", itemID);
		map.put("v_BOARDTYPE", boardType);
		map.put("v_ACCESSID", userDeptPath);
		map.put("v_TENANTID", tenantID);
		map.put("v_ISDEPT", isDept);
		map.put("v_ISEQUALDEPT", isEqualDept);

		logger.debug("getCheckItemID ended");
		return ezBoardDAO.getCheckItemID(map);
	}

	/* 2018-06-29 홍승비 - 해당 게시물을 작성한 사람의 WriterDeptID(겸직상태로 저장됨)도 함께 가져오도록 함 */
	@Override
	public BoardListVO getBrdGetItemInfo(String boardID, String itemID, String multiLang, int tenantID) throws Exception {
		logger.debug("getBrdGetItemInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pItemID", itemID);
		map.put("lang", multiLang);
		map.put("v_TENANTID", tenantID);
		
		logger.debug("getBrdGetItemInfo ended");
		return ezBoardDAO.getBrdGetItemInfo(map);
	}

	/* 2018-06-29 홍승비 - 해당 게시물을 작성한 사람의 WriterDeptID(겸직상태로 저장됨)도 함께 가져오도록 함 */
	@Override
	public BoardListVO getBrdGetItemInfoTemp(String boardID, String itemID, String multiLang, int tenantID) throws Exception {
		logger.debug("getBrdGetItemInfoTemp started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pBoardID", boardID);
		map.put("v_pItemID", itemID);
		map.put("lang", multiLang);
		map.put("v_TENANTID", tenantID);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		logger.debug("getBrdGetItemInfoTemp ended");
		return ezBoardDAO.getBrdGetItemInfoTemp(map);
	}

	@Override
	public BoardListVO getItemInfo(String mode, String itemID, String lang, int tenantID) throws Exception {
		logger.debug("getItemInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("itemID", itemID);
		map.put("mode", mode);
		map.put("lang", commonUtil.getMultiData(lang, tenantID));
		map.put("tenantID", tenantID);
		
		String tempString = ezBoardDAO.getBoardItem(map);
		
		if (tempString != null && !tempString.equals("")) {
			map.put("tempString", tempString);
		} else {
			map.put("tempString", "");
		}
		
		logger.debug("getItemInfo ended");
		return ezBoardDAO.getItemInfo(map);
	}

	@Override
	public BoardListVO getCopyItem(String orgItemID, int tenantID) throws Exception {
		logger.debug("getCopyItem started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PORGITEMID", orgItemID);
		map.put("v_TENANTID", tenantID);

		logger.debug("getCopyItem ended");
		return ezBoardDAO.getCopyItem(map);
	}

	@Override
	public List<BoardListVO> getAdjacentItems1(String boardID, String parentWriteDate, String upperItemIDTree, int tenantID) throws Exception {
		logger.debug("getAdjacentItems1 started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDID", boardID);
		map.put("v_PPARENTWRITEDATE", parentWriteDate);
		map.put("v_PUPPERITEMIDTREE", upperItemIDTree);
		map.put("v_TENANTID", tenantID);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));

		logger.debug("getAdjacentItems1 ended");
		return ezBoardDAO.getAdjacentItems1(map);
	}

	@Override
	public List<BoardListVO> getAdjacentItems2(String boardID, String parentWriteDate, int tenantID) throws Exception {
		logger.debug("getAdjacentItems2 started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDID", boardID);
		map.put("v_PPARENTWRITEDATE", parentWriteDate);
		map.put("v_TENANTID", tenantID);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));

		logger.debug("getAdjacentItems2 ended");
		return ezBoardDAO.getAdjacentItems2(map);
	}

	@Override
	public List<BoardListVO> getAdjacentItems3(String boardID, String parentWriteDate, String itemID, String upperItemIDTree, String previousItemID, int tenantID) throws Exception {
		logger.debug("getAdjacentItems3 started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDID", boardID);
		map.put("v_PPARENTWRITEDATE", parentWriteDate);
		map.put("v_PITEMID", itemID);
		map.put("v_PUPPERITEMIDTREE", upperItemIDTree);
		map.put("v_PREVIOUSITEMID", previousItemID);
		map.put("v_TENANTID", tenantID);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));

		logger.debug("getAdjacentItems3 ended");
		return ezBoardDAO.getAdjacentItems3(map);
	}

	@Override
	public List<BoardListVO> getAdjacentItems2Photo(String boardID, String parentWriteDate, int tenantID) throws Exception {
		logger.debug("getAdjacentItems2Photo started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDID", boardID);
		map.put("v_PPARENTWRITEDATE", parentWriteDate);
		map.put("v_TENANTID", tenantID);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));

		logger.debug("getAdjacentItems2Photo ended");
		return ezBoardDAO.getAdjacentItems2Photo(map);
	}

	@Override
	public List<BoardListVO> getAdjacentItems3Photo(String boardID, String parentWriteDate, int tenantID) throws Exception {
		logger.debug("getAdjacentItems3Photo started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDID", boardID);
		map.put("v_PPARENTWRITEDATE", parentWriteDate);
		map.put("v_TENANTID", tenantID);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));

		logger.debug("getAdjacentItems3Photo ended");
		return ezBoardDAO.getAdjacentItems3Photo(map);
	}

	@Override
	public List<BoardAttachVO> photoViewDB(String itemID, String boardID, int pStartRow, int pEndRow, int tenantID) throws Exception {
		logger.debug("photoViewDB started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		/* 2021-08-12 홍승비 - 임시보관함에서 접근한 경우의 분기 추가 (페이지 제한 없이 이미지 가져오도록) */
		if (pStartRow < 0 && pEndRow == 0) {
			map.put("v_ISTEMPITEM", "Y");
		} else {
			map.put("v_ISTEMPITEM", "N");
		}
		
		map.put("v_pItemID", itemID);
		map.put("v_pBoardID", boardID);
		map.put("v_pStartRow", pStartRow);
		map.put("v_pEndRow", pEndRow);
		map.put("v_TENANTID", tenantID);
		map.put("rowCount", pEndRow - (pStartRow - 1));
		map.put("limit", pStartRow - 1);

		logger.debug("photoViewDB ended");
		return ezBoardDAO.photoViewDB(map);
	}

	@Override
	public int photoViewDBCount(String itemID, String boardID, int tenantID) throws Exception {
		logger.debug("photoViewDBCount started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pItemID", itemID);
		map.put("v_pBoardID", boardID);
		map.put("v_TENANTID", tenantID);

		logger.debug("photoViewDBCount ended");
		return ezBoardDAO.photoViewDBCount(map);
	}

	@Override
	public List<BoardAttachVO> photoViewDBAll(String itemID, String boardID, int tenantID) throws Exception {
		logger.debug("photoViewDBAll started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pItemID", itemID);
		map.put("v_pBoardID", boardID);
		map.put("v_TENANTID", tenantID);

		logger.debug("photoViewDBAll ended");
		return ezBoardDAO.photoViewDBAll(map);
	}

	@Override
	public List<String> getCopyItemAttach(String orgItemID, int tenantID) throws Exception {
		logger.debug("getCopyItemAttach started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("itemID", orgItemID);
		map.put("tenantID", tenantID);

		logger.debug("getCopyItemAttach ended");
		return ezBoardDAO.getCopyItemAttach(map);
	}

	/* 게시물 조회자 정보에 companyID도 추가 */
	@Override
	public void setAsRead(LoginVO userInfo, String boardID, String itemID) throws Exception {
		logger.debug("setAsRead started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pBoardID", boardID);
		map.put("v_pItemID", itemID);
		map.put("v_pUserID", userInfo.getId());
		map.put("v_pUserName", userInfo.getDisplayName1());
		map.put("v_pUserDeptName", userInfo.getDeptName1());
		map.put("v_pUserCompanyName", userInfo.getCompanyName1());
		map.put("v_pUserTitle", userInfo.getTitle1());
		map.put("v_pUserName2", userInfo.getDisplayName2());
		map.put("v_pUserDeptName2", userInfo.getDeptName2());
		map.put("v_pUserCompanyName2", userInfo.getCompanyName2());
		map.put("v_pUserTitle2", userInfo.getTitle2());
		map.put("v_COMPANYID", userInfo.getCompanyID());
		map.put("v_TENANTID", userInfo.getTenantId());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		// 조회자 정보 가져올때는 companyID 신경안씀(이미 게시판ID로 회사를 걸렀으므로)
		String tempString = ezBoardDAO.getBoardItemRead(map);
		
		if (tempString != null && !tempString.equals("")) {
			ezBoardDAO.setAsRead(map);
			
			String tempWriterID = ezBoardDAO.getWriterID(map);
			
			if (tempWriterID == null || !tempWriterID.equals(userInfo.getId())) {
				ezBoardDAO.setAsRead2(map);
			}
		}

		logger.debug("setAsRead ended");
	}
	//조회수를 증가시키지 않는 새게시물 읽음표시 처리
	public void setAsReadNew(LoginVO userInfo, String boardID, String itemID) throws Exception {
		logger.debug("setAsReadNew started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pBoardID", boardID);
		map.put("v_pItemID", itemID);
		map.put("v_pUserID", userInfo.getId());
		map.put("v_pUserName", userInfo.getDisplayName1());
		map.put("v_pUserDeptName", userInfo.getDeptName1());
		map.put("v_pUserCompanyName", userInfo.getCompanyName1());
		map.put("v_pUserTitle", userInfo.getTitle1());
		map.put("v_pUserName2", userInfo.getDisplayName2());
		map.put("v_pUserDeptName2", userInfo.getDeptName2());
		map.put("v_pUserCompanyName2", userInfo.getCompanyName2());
		map.put("v_pUserTitle2", userInfo.getTitle2());
		map.put("v_TENANTID", userInfo.getTenantId());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		String tempString = ezBoardDAO.getBoardItemRead(map);
		
		if (tempString != null && !tempString.equals("")) {
			ezBoardDAO.setAsRead(map);
		}

		logger.debug("setAsReadNew ended");
	}

	@Override
	public int getCheckApprUserList(String userID, String itemID, int tenantID) throws Exception {
		logger.debug("getCheckApprUserList started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", userID);
		map.put("v_PITEMID", itemID);
		map.put("v_TENANTID", tenantID);

		logger.debug("getCheckApprUserList ended");
		return ezBoardDAO.getCheckApprUserList(map);
	}

	@Override
	public int getSearchBoardItemCount(BoardVO boardVO, Map<String, String> searchMap) throws Exception {
		logger.debug("getSearchBoardItemCount started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDID", boardVO.getBoardId());
		map.put("v_PSUBFLAG", boardVO.getSubFlag());
		map.put("v_TENANTID", boardVO.getTenantID());
		map.put("v_useKeywordFlag", boardVO.getUseKeyword());
		map.put("v_KEYWORD", boardVO.getKeyword());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		for (String key : searchMap.keySet()) {
			map.put(key, searchMap.get(key));
		}
		
		logger.debug("getSearchBoardItemCount ended");
		return ezBoardDAO.getSearchBoardItemCount(map); 
	}

	@Override
	public int checkApprUserList(String userID, String itemID, int tenantID) throws Exception {
		logger.debug("checkApprUserList started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", userID);
		map.put("v_PITEMID", itemID);
		map.put("v_TENANTID", tenantID);

		logger.debug("checkApprUserList ended");
		return ezBoardDAO.checkApprUserList(map);
	}

	/* 마이게시판 > 나의게시물 카운트 companyID 조건 추가 */
	@Override
	public int getMyBoardTotalItemCount(LoginVO userInfo) throws Exception {
		logger.debug("getMyBoardTotalItemCount started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", userInfo.getId());
		map.put("v_COMPANYID", userInfo.getCompanyID());
		map.put("v_TENANTID", userInfo.getTenantId());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));

		logger.debug("getMyBoardTotalItemCount ended");
		return ezBoardDAO.getMyBoardTotalItemCount(map);
	}

	/* 마이게시판 > 임시보관함 카운트 companyID 조건 추가 */
	@Override
	public int getMyBoardTotalItemCountTemp(LoginVO userInfo) throws Exception {
		logger.debug("getMyBoardTotalItemCountTemp started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", userInfo.getId());
		map.put("v_COMPANYID", userInfo.getCompanyID());
		map.put("v_TENANTID", userInfo.getTenantId());

		logger.debug("getMyBoardTotalItemCountTemp ended");
		return ezBoardDAO.getMyBoardTotalItemCountTemp(map);
	}

	@Override
	public int getMyNoticePostItemCount(LoginVO userInfo) throws Exception {
		logger.debug("getMyNoticePostItemCount started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", userInfo.getId());
		map.put("v_TENANTID", userInfo.getTenantId());
		map.put("v_COMPANYID", userInfo.getCompanyID());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));

		logger.debug("getMyNoticePostItemCount ended");
		return ezBoardDAO.getMyNoticePostItemCount(map);
	}

	@Override
	public int getSearchMyBoardItemCount(LoginVO userInfo, BoardVO boardVO, Map<String, String> searchMap) throws Exception {
		logger.debug("getSearchMyBoardItemCount started");

		if (boardVO.getSearchQuery().length() > 0) {
			boardVO.setSearchQuery(" AND " + boardVO.getSearchQuery());
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", userInfo.getId());
		map.put("v_PSUBFLAG", boardVO.getSubFlag());
		map.put("v_TENANTID", boardVO.getTenantID());
		map.put("v_COMPANYID", userInfo.getCompanyID());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("v_KEYWORD", boardVO.getKeyword());
		
		for (String key : searchMap.keySet()) {
			map.put(key, searchMap.get(key));
		}
		
		logger.debug("getSearchMyBoardItemCount ended");
		return ezBoardDAO.getSearchMyBoardItemCount(map);
	}

	@Override
	public int getSearchMyBoardItemCountTemp(LoginVO userInfo, BoardVO boardVO, Map<String, String> searchMap) throws Exception {
		logger.debug("getSearchMyBoardItemCountTemp started");

		if (boardVO.getSearchQuery().length() > 0) {
			boardVO.setSearchQuery(" AND " + boardVO.getSearchQuery());
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", userInfo.getId());
		map.put("v_PSUBFLAG", boardVO.getSubFlag());
		map.put("v_TENANTID", boardVO.getTenantID());
		map.put("v_COMPANYID", userInfo.getCompanyID());
		map.put("v_KEYWORD", boardVO.getKeyword());
		
		for (String key : searchMap.keySet()) {
			map.put(key, searchMap.get(key));
		}
		
		logger.debug("getSearchMyBoardItemCountTemp ended");
		return ezBoardDAO.getSearchMyBoardItemCountTemp(map);
	}

	/* 2018-06-26 홍승비 - 게시물 승인 카운트 표시 시 companyID 조건 추가 */
	@Override
	public int getApprBoardTotalItemCount(LoginVO userInfo) throws Exception {
		logger.debug("getApprBoardTotalItemCount started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("id", userInfo.getId());
		map.put("companyID", userInfo.getCompanyID());
		map.put("tenantID", userInfo.getTenantId());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));

		logger.debug("getApprBoardTotalItemCount ended");
		return ezBoardDAO.getApprBoardTotalItemCount(map);
	}

	@Override
	public String checkForm(String boardID, String mode, int tenantID) throws Exception {
		logger.debug("checkForm started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDID", boardID);
		map.put("v_PMODE", mode);
		map.put("v_TENANTID", tenantID);
		
		String checkForm = "";
		int checkCnt = ezBoardDAO.checkForm(map);
		
		if (checkCnt > 0) {
			checkForm = "TRUE";
		} else {
			checkForm = "FALSE";
		}

		logger.debug("checkForm ended");
		return checkForm;
	}

	@Override
	public String checkBackGroundImage(String boardID, int tenantID) throws Exception {
		logger.debug("checkBackGroundImage started");

		String check = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("boardID", boardID);
		map.put("tenantID", tenantID);
		
		int checkCnt = ezBoardDAO.checkBackGroundImage(map);
		
		if (checkCnt > 0) {
			check = "TRUE";
		} else {
			check = "FALSE";
		}

		logger.debug("checkBackGroundImage ended");
		return check;
	}

	@Override
	public String brdCheckIfHasReply(String itemID, int tenantID) throws Exception {
		logger.debug("brdCheckIfHasReply started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pItemID", itemID);
		map.put("v_TENANTID", tenantID);
		
		String check = "";
		int checkCnt = ezBoardDAO.brdCheckIfHasReply(map);
		
		if (checkCnt > 0) {
			check = "TRUE";
		} else {
			check = "FALSE";
		}

		logger.debug("brdCheckIfHasReply ended");
		return check;
	}

	@Override
	public String getNoticePostItemAll(String boardID, int tenantID) throws Exception {
		logger.debug("getNoticePostItemAll started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("boardID", boardID);
		map.put("tenantID", tenantID);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		List<BoardListVO> resultList = ezBoardDAO.getNoticePostItemAll(map);
		
		StringBuilder sb = new StringBuilder();
		sb.append("<DATA>");
		
		for (int i = 0; i < resultList.size(); i++) {
			sb.append(commonUtil.getQueryResult(resultList.get(i)));
		}
		
		sb.append("</DATA>");

		logger.debug("getNoticePostItemAll ended");
		return sb.toString();
	}

	@Override
	public String getParentBoardID(String boardID, int tenantID) throws Exception {
		logger.debug("getParentBoardID started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("boardID", boardID);
		map.put("tenantID", tenantID);

		logger.debug("getParentBoardID ended");
		return ezBoardDAO.getParentBoardID(map);
	}

	@Override
	public String getDocPassWord(String itemID, int tenantID) throws Exception {
		logger.debug("getDocPassWord started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("itemID", itemID);
		map.put("tenantID", tenantID);	

		logger.debug("getDocPassWord ended");
		return ezBoardDAO.getDocPassWord(map);
	}

	@Override
	public String getOneLinePassWord(String replyID, String itemID, int tenantID) throws Exception {
		logger.debug("getOneLinePassWord started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("replyID", replyID);
		map.put("itemID", itemID);
		map.put("tenantID", tenantID);	

		logger.debug("getOneLinePassWord ended");
		return ezBoardDAO.getOneLinePassWord(map);
	}

	@Override
	public String deleteTempItem1(String mode, String strItemID, int tenantID) throws Exception {
		logger.debug("deleteTempItem1 started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("itemID", strItemID);
		map.put("tenantID", tenantID);
		
		try {
			ezBoardDAO.deleteBoardItemTemp(map);
			ezBoardDAO.deleteBoardItemRead2(map);
			ezBoardDAO.deleteBoardReply(map);
			
			if (mode != null && mode.equals("PHOTO")) {
				BoardListVO boardListVO = new BoardListVO();
				
				boardListVO.setItemID(strItemID);
				boardListVO.setTenantID(tenantID);
				
				ezBoardDAO.deleteImageItem(boardListVO);
			}
			
			logger.debug("deleteTempItem1 ended");
			return "OK";
		} catch (Exception e) {
			logger.error("EzBoard :: deleteTempItem");
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			return "NO";
		}
	}

	/* 2018-06-29 홍승비 - 게시물 미리보기 > 게시자 사원정보 확인 시 겸직부서인 상태로 정보 보여주도록 수정 */
	@Override
	public String getItemXML(String boardID, String itemID, String lang, String offset, int tenantID) throws Exception {
		logger.debug("getItemXML started");

		StringBuilder sb = new StringBuilder();
		String userImg = "";
		
		if (boardID != null) {
			Map<String, Object> map = new HashMap<String, Object>();
			
			map.put("v_pBoardID", boardID);
			map.put("lang", commonUtil.getMultiData(lang, tenantID));
			map.put("v_pItemID", itemID);
			map.put("v_TENANTID", tenantID);
			
			BoardListVO itemInfo = ezBoardDAO.getBrdGetItemInfo(map);
			
			sb.append("<NODES>");
			sb.append("<NODE>");
			sb.append("<ItemID>" + itemInfo.getItemID() + "</ItemID>");
			sb.append("<WriterID>" + itemInfo.getWriterID() + "</WriterID>");
			sb.append("<WriterName>" + commonUtil.cleanValue(itemInfo.getWriterName()) + "</WriterName>");
			sb.append("<WriterDeptID>" + commonUtil.cleanValue(itemInfo.getWriterDeptID()) + "</WriterDeptID>");
			sb.append("<WriterDeptName>" + commonUtil.cleanValue(itemInfo.getWriterDeptName()) + "</WriterDeptName>");
			sb.append("<WriterCompanyName>" + commonUtil.cleanValue(itemInfo.getWriterCompanyName()) + "</WriterCompanyName>");
			sb.append("<WriteDate>" + commonUtil.getDateStringInUTC(itemInfo.getWriteDate(), offset, false) + "</WriteDate>");
			sb.append("<ParentWriteDate>" + itemInfo.getParentWriteDate() + "</ParentWriteDate>");
			sb.append("<Importance>" + itemInfo.getImportance() + "</Importance>");
			sb.append("<Title>" + commonUtil.cleanValue(itemInfo.getTitle()) + "</Title>");
			sb.append("<ContentLocation>" + itemInfo.getContentLocation() + "</ContentLocation>");
			sb.append("<StartDate>" + commonUtil.getDateStringInUTC(itemInfo.getStartDate(), offset, false) + "</StartDate>");
			sb.append("<EndDate>" + commonUtil.getDateStringInUTC(itemInfo.getEndDate(), offset, false) + "</EndDate>");
			sb.append("<Abstract>" + commonUtil.cleanValue(itemInfo.getABSTRACT()) + "</Abstract>");
			sb.append("<Attachments>" + commonUtil.cleanValue(itemInfo.getAttachments()) + "</Attachments>");
			sb.append("<UpperItemIDTree>" + itemInfo.getUpperItemIDTree() + "</UpperItemIDTree>");
			sb.append("<ItemLevel>" + itemInfo.getItemLevel() + "</ItemLevel>");
			sb.append("<copiedItem>" + itemInfo.getCopiedItem() + "</copiedItem>");
			sb.append("<ExtensionAttribute1>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute1()) + "</ExtensionAttribute1>");
			sb.append("<ExtensionAttribute2>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute2()) + "</ExtensionAttribute2>");
			sb.append("<ExtensionAttribute3>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute3()) + "</ExtensionAttribute3>");
			sb.append("<ExtensionAttribute4>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute4()) + "</ExtensionAttribute4>");
			sb.append("<ExtensionAttribute5>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute5()) + "</ExtensionAttribute5>");
			sb.append("<MainContent>" + commonUtil.cleanValue(itemInfo.getMainContent()) + "</MainContent>");   
			sb.append("<APPRFLAG>" + commonUtil.cleanValue(itemInfo.getApprFlag()) + "</APPRFLAG>");
			sb.append("<GUBUN>" + commonUtil.cleanValue(itemInfo.getGuBun()) + "</GUBUN>");
			//확장값 추가
			sb.append("<ExtensionAttribute6>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute6()) + "</ExtensionAttribute6>");
			sb.append("<ExtensionAttribute7>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute7()) + "</ExtensionAttribute7>");
			sb.append("<ExtensionAttribute8>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute8()) + "</ExtensionAttribute8>");
			sb.append("<ExtensionAttribute9>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute9()) + "</ExtensionAttribute9>");
			sb.append("<ExtensionAttribute10>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute10()) + "</ExtensionAttribute10>");
			sb.append("<BoardID>" + commonUtil.cleanValue(itemInfo.getBoardID()) + "</BoardID>");
			sb.append("<LikeCount>" + itemInfo.getLikeCount() + "</LikeCount>");
			sb.append("<DisLikeCount>" + itemInfo.getDisLikeCount() + "</DisLikeCount>");
			
			/* 2018-12-03 홍승비 - 게시물 정보에 사원이미지 추가 */
			if (itemInfo.getUserImageFile() != null && !itemInfo.getUserImageFile().equals("")) {
				userImg = "/admin/ezOrgan/getPersonalInfo.do?fileName=" + itemInfo.getUserImageFile();
			} else {
				userImg = "/images/kr/main/bestEmployee_pic_none.png";
			}			
			sb.append("<UserIMG>" + commonUtil.cleanValue(userImg) + "</UserIMG>");
			
			/* 2019-11-06 홍승비 - 게시물 미리보기 시 댓글옵션 정보 추가 */
			sb.append("<ONELINEREPLY>" + commonUtil.cleanValue(itemInfo.getOneLineReply()) + "</ONELINEREPLY>");
			sb.append("</NODE>");
			sb.append("</NODES>");
		} else {
			sb.append("<NODES>");
			sb.append("</NODES>");
		}

		logger.debug("getItemXML ended");
		return sb.toString();
	}

	/* 2018-06-29 홍승비 - 임시게시물 미리보기 > 게시자 사원정보 확인 시 겸직부서인 상태로 정보 보여주도록 수정 */
	@Override
	public String getItemTempXML(String boardID, String itemID, String lang, String offset, int tenantID) throws Exception {
		logger.debug("getItemTempXML started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pBoardID", boardID);
		map.put("lang", commonUtil.getMultiData(lang, tenantID));
		map.put("v_pItemID", itemID);
		map.put("v_TENANTID", tenantID);
		
		BoardListVO itemInfo = ezBoardDAO.getBrdGetItemInfoTemp(map);
		
		StringBuilder sb = new StringBuilder();
		String userImg = "";
		
		sb.append("<NODES>");
		sb.append("<NODE>");
		sb.append("<ItemID>" + itemInfo.getItemID() + "</ItemID>");
		sb.append("<WriterID>" + itemInfo.getWriterID() + "</WriterID>");
		sb.append("<WriterName>" + commonUtil.cleanValue(itemInfo.getWriterName()) + "</WriterName>");
		sb.append("<WriterDeptID>" + commonUtil.cleanValue(itemInfo.getWriterDeptID()) + "</WriterDeptID>");
		sb.append("<WriterDeptName>" + commonUtil.cleanValue(itemInfo.getWriterDeptName()) + "</WriterDeptName>");
		sb.append("<WriterCompanyName>" + commonUtil.cleanValue(itemInfo.getWriterCompanyName()) + "</WriterCompanyName>");
		sb.append("<WriteDate>" + commonUtil.getDateStringInUTC(itemInfo.getWriteDate(), offset, false) + "</WriteDate>");
		sb.append("<ParentWriteDate>" + itemInfo.getParentWriteDate() + "</ParentWriteDate>");
		sb.append("<Importance>" + itemInfo.getImportance() + "</Importance>");
		sb.append("<Title>" + commonUtil.cleanValue(itemInfo.getTitle()) + "</Title>");
		sb.append("<ContentLocation>" + itemInfo.getContentLocation() + "</ContentLocation>");
		sb.append("<StartDate>" + commonUtil.getDateStringInUTC(itemInfo.getStartDate(), offset, false) + "</StartDate>");
		sb.append("<EndDate>" + commonUtil.getDateStringInUTC(itemInfo.getEndDate(), offset, false) + "</EndDate>");
		sb.append("<Abstract>" + commonUtil.cleanValue(itemInfo.getABSTRACT()) + "</Abstract>");
		sb.append("<Attachments>" + commonUtil.cleanValue(itemInfo.getAttachments()) + "</Attachments>");
		sb.append("<UpperItemIDTree>" + itemInfo.getUpperItemIDTree() + "</UpperItemIDTree>");
		sb.append("<ItemLevel>" + itemInfo.getItemLevel() + "</ItemLevel>");
		sb.append("<copiedItem>" + itemInfo.getCopiedItem() + "</copiedItem>");
		sb.append("<ExtensionAttribute1>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute1()) + "</ExtensionAttribute1>");
		sb.append("<ExtensionAttribute2>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute2()) + "</ExtensionAttribute2>");
		sb.append("<ExtensionAttribute3>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute3()) + "</ExtensionAttribute3>");
		sb.append("<ExtensionAttribute4>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute4()) + "</ExtensionAttribute4>");
		sb.append("<ExtensionAttribute5>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute5()) + "</ExtensionAttribute5>");
		sb.append("<MainContent>" + commonUtil.cleanValue(itemInfo.getMainContent()) + "</MainContent>");   
		sb.append("<GUBUN>" + commonUtil.cleanValue(itemInfo.getGuBun()) + "</GUBUN>");
		//확장값 추가
		sb.append("<ExtensionAttribute6>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute6()) + "</ExtensionAttribute6>");
		sb.append("<ExtensionAttribute7>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute7()) + "</ExtensionAttribute7>");
		sb.append("<ExtensionAttribute8>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute8()) + "</ExtensionAttribute8>");
		sb.append("<ExtensionAttribute9>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute9()) + "</ExtensionAttribute9>");
		sb.append("<ExtensionAttribute10>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute10()) + "</ExtensionAttribute10>");
		sb.append("<BoardID>" + commonUtil.cleanValue(itemInfo.getBoardID()) + "</BoardID>");
		
		/* 2018-12-03 홍승비 - 게시물 정보에 사원이미지 추가 */
		if (itemInfo.getUserImageFile() != null && !itemInfo.getUserImageFile().equals("")) {
			userImg = "/admin/ezOrgan/getPersonalInfo.do?fileName=" + itemInfo.getUserImageFile();
		} else {
			userImg = "/images/kr/main/bestEmployee_pic_none.png";
		}			
		sb.append("<UserIMG>" + commonUtil.cleanValue(userImg) + "</UserIMG>");
		
		sb.append("</NODE>");
		sb.append("</NODES>");

		logger.debug("getItemTempXML ended");
		return sb.toString();
	}

	@Override
	public String setBoardConfig(String userID, int listCount, String preView, int tenantID) throws Exception {
		logger.debug("setBoardConfig started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_USERID", userID);
		map.put("v_LISTCOUNT", listCount);
		map.put("v_PREVIEW", preView);
		map.put("v_TENANTID", tenantID);
		
		try {
			String tempString = ezBoardDAO.getBoardConfig(map);
			
			if (tempString != null && !tempString.equals("")) {
				ezBoardDAO.setBoardConfig(map);
			} else {
				ezBoardDAO.setBoardConfig2(map);
			}
			
			logger.debug("setBoardConfig ended");
			return "OK";
		} catch (Exception e) {
			logger.debug(e.getMessage());
			return "NO";
		}
	}

	@Override
	public String apprItem(String userID, String item, String pMod, String companyID, int tenantID) throws Exception {
		logger.debug("apprItem started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_ITEMID", item);
		map.put("v_MODE", pMod);
		map.put("v_USERID", userID);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantID);
		
		try {
			// 해당 게시물에 대한 승인자 셀렉트(각 회사에 대해 고유한 boardID로 조건을 주므로, companyID 필요없음)
			String tempString = ezBoardDAO.getBoardApprListUser(map);
			
			// 승인게시물 업데이트(itemID 사용하므로 companyID 필요없음)
			if (tempString != null && !tempString.equals("")) {
				ezBoardDAO.apprItem(map);
			}
			
			logger.debug("apprItem ended");
			return "OK";
		} catch (Exception e) {
			logger.error("EzBoard :: apprItem");
			return "ERROR" + e.getMessage();
		}
	}

	@Override
	public String deleteOneLineReply(String userID, String replyID, String itemID, String guBun, int tenantID) throws Exception {
		logger.debug("deleteOneLineReply started");

		String rtnValue = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_USERINFO_USERID", userID);
		map.put("v_REPLYID", replyID);
		map.put("v_GUBUN", guBun);
		map.put("v_TENANTID", tenantID);
		map.put("v_ITEMID", itemID);
		
		try {
			int totalCount = 0;

			// null로 update했던 부모 댓글을 delete하는 경우 userID값이 공백이므로 댓글을 찾을 수 없음 (부모댓글이 삭제된 뒤 자식댓글이 모두 삭제되는 경우)
			if (!"".equals(userID)) {
				totalCount = ezBoardDAO.getBoardOneLineReply(map);
			}

			if (totalCount > 0 || "".equals(userID)) {
				ezBoardDAO.deleteOneLineReply(map);
				ezBoardDAO.deleteCommentAttach(map);
				rtnValue = "OK_DELETED";
			} else {
				rtnValue = "FAIL";
			}
		} catch (Exception e) {
			logger.error("EzBoard :: deleteOneLineReply");
			logger.error(e.getMessage(), e);
			rtnValue = "FAIL";
		}
		
		logger.debug("deleteOneLineReply ended");
		return rtnValue;
	}

	@Override
	public String checkOneLineOwner(String replyID, String userID, int tenantID) throws Exception {
		logger.debug("checkOneLineOwner started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_ReplyID", replyID);
		map.put("v_UserID", userID);
		map.put("v_TENANTID", tenantID);
		
		String resultMessage = "";
		int result = ezBoardDAO.checkOneLineOwner(map);
		
		if(result > 0) {
			resultMessage = "OK_MINE";
		} else {
			resultMessage = "FAIL";
		}

		logger.debug("checkOneLineOwner ended");
		return resultMessage;
	}

	/* 예약게시물 표출 시 companyID 조건 추가 */
	@Override
	public List<BoardListVO> getReservedItemList(String userID, int startRow, int endRow, String sortBy, String lang, String offset, String companyID, int tenantID) throws Exception {
		logger.debug("getReservedItemList started");

		if (!(endRow > 0)) {
			endRow = 0;
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		/* 2019-01-07 홍승비 - 예약게시물 페이징 파라미터 누락 수정*/
		map.put("v_PSTARTROW", startRow);
		map.put("v_PENDROW", endRow);
		map.put("v_PUSERID", userID);
		map.put("lang", lang);
		map.put("v_PSORTBY", sortBy);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantID);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("rowCount", endRow - (startRow - 1));
		map.put("limit", startRow - 1);

		/* 2024-04-02 양지혜 - SQL injection 처리 */
		String orderCol = "";
		String orderSort = "";
		if (sortBy.contains("desc")) {
			String[] tempAry = sortBy.split(" ");
			orderCol = tempAry[0];
			orderSort = tempAry[1];
		} else {
			orderCol = sortBy;
		}
		
		map.put("v_ORDERCOL", orderCol);
		map.put("v_ORDERSORT", orderSort);
		
		List<BoardListVO> boardListVOs = ezBoardDAO.getReservedItemList(map);
		
		for (int k = 0; k < boardListVOs.size(); k++) {
			boardListVOs.get(k).setStartDate(commonUtil.getDateStringInUTC(boardListVOs.get(k).getStartDate(), offset, false));
			boardListVOs.get(k).setEndDate(commonUtil.getDateStringInUTC(boardListVOs.get(k).getEndDate(), offset, false));
			boardListVOs.get(k).setTitle(commonUtil.cleanValue(boardListVOs.get(k).getTitle()));
			boardListVOs.get(k).setABSTRACT(commonUtil.cleanValue(boardListVOs.get(k).getABSTRACT()));
		}

		logger.debug("getReservedItemList ended");
		return boardListVOs;
	}

	/* 2018-11-22 홍승비 - 그룹사게시판에서는 댓글 작성자의 deptID를 가져오지 않도록 수정 */
	@Override
	public List<BoardLineReplyVO> readOneLineReply(String boardID, String itemID, String lang, String gubun, String companyID, int tenantID, String sort) throws Exception {
		logger.debug("readOneLineReply started");

		List<BoardLineReplyVO> rtnVal = new ArrayList<>();
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_BoardID", boardID);
		map.put("v_ItemID", itemID);
		map.put("lang", lang);
		map.put("v_GUBUN", gubun);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantID);
		map.put("v_SORT", sort);
		
		BoardPropertyVO boardProp = getBoardProperty(boardID, tenantID);
		
		if (boardProp.getBoardGroupID() != null) {
			BoardPropertyVO boardGroupProp = getBoardProperty(boardProp.getBoardGroupID(), tenantID);
			
			if (boardGroupProp.getGuBun() != null && boardGroupProp.getGuBun().equals("99")) {
				map.put("v_isAllGroupBoard", "Y");
			}
		}
		
		List<BoardLineReplyVO> tmpCmtList = ezBoardDAO.readOneLineReply(map);
		rtnVal = mappingCommentListForAttach(tmpCmtList);
		
		logger.debug("readOneLineReply ended");
		return rtnVal;
	}

	/* 예약게시물 카운트 표출 시 companyID 조건 추가 */
	@Override
	public int getReservedItemListCount(String userID, String companyID, int tenantID) throws Exception {
		logger.debug("getReservedItemListCount started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("userID", userID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));

		logger.debug("getReservedItemListCount ended");
		return ezBoardDAO.getReservedItemListCount(map);
	}

	@Override
	public void brdNewItem(BoardListVO boardListVO) throws Exception {
		logger.debug("brdNewItem started");

		String tempString = ezBoardDAO.getApprFlag(boardListVO);
		
		if (tempString != null && tempString.equals("Y")) {
			ezBoardDAO.brdNewItem(boardListVO);
		} else {
			ezBoardDAO.brdNewItem2(boardListVO);
		}
		
		ezBoardDAO.newItem(boardListVO);

		logger.debug("brdNewItem ended");
	}

	@Override
	public void brdNewItemPhoto(BoardListVO boardListVO) throws Exception {
		logger.debug("brdNewItemPhoto started");

		String tempString = ezBoardDAO.getApprFlag(boardListVO);
		
		if (tempString != null && tempString.equals("Y")) {
			ezBoardDAO.brdNewItemPhoto(boardListVO);
		} else {
			ezBoardDAO.brdNewItemPhoto2(boardListVO);
		}
		
		photoSaveDB(boardListVO);
		ezBoardDAO.newItem(boardListVO);

		logger.debug("brdNewItemPhoto ended");
	}

	@Override
	public void brdNewItemTemp(BoardListVO boardListVO) throws Exception {
		logger.debug("brdNewItemTemp started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pIMAGEID", boardListVO.getImageID());
		map.put("v_TENANTID", boardListVO.getTenantID());
		
		ezBoardDAO.deletePhotoImageItem(map);
		ezBoardDAO.brdNewItemTemp(boardListVO);
		ezBoardDAO.newItem(boardListVO);

		logger.debug("brdNewItemTemp ended");
	}

	@Override
	public void brdNewItemTempPhoto(BoardListVO boardListVO) throws Exception {
		logger.debug("brdNewItemTempPhoto started");

		ezBoardDAO.deleteItemTempPhoto(boardListVO);
		ezBoardDAO.deleteImageItem(boardListVO);
		ezBoardDAO.brdNewItemTempPhoto(boardListVO);
		photoSaveDB(boardListVO);
		ezBoardDAO.newItem(boardListVO);

		logger.debug("brdNewItemTempPhoto ended");
	}

	@Override
	public void photoListInsert(BoardListVO boardListVO) throws Exception {
		logger.debug("photoListInsert started");

		ezBoardDAO.photoListInsert(boardListVO);

		logger.debug("photoListInsert ended");
	}

	@Override
	public void brdUpdateItem(BoardListVO boardListVO, String mode) throws Exception {
		logger.debug("brdUpdateItem started");
		
		ezBoardDAO.brdUpdateItem(boardListVO);
		
		if (boardListVO.getReadFlag().equals("Y")) {
			ezBoardDAO.setInitReadCount(boardListVO);
			ezBoardDAO.deleteBoardItemRead(boardListVO);
		}
		
		ezBoardDAO.setApprFlag(boardListVO);

		if (mode.equals("PHOTO")) {
			photoSaveDB(boardListVO);
		}
		
		ezBoardDAO.newItem(boardListVO);

		logger.debug("brdUpdateItem ended");
	}

	public void photoSaveDB(BoardListVO boardListVO) throws Exception {
		logger.debug("photoSaveDB started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		String strFilePath = "";

		// 포토게시판, 썸네일게시판
		if (!boardListVO.getGuBun().equals("7")) {
			for (int i = 0; i < boardListVO.getImageCount(); i++) {
				strFilePath = commonUtil.detectPathTraversal(boardListVO.getExtensionAttribute5().split("\\|")[i]);
				File file = new File(boardListVO.getRealPath() + boardListVO.getFilePath() + commonUtil.separator + strFilePath);
				strFilePath = commonUtil.getUploadPath("upload_board.ROOT", boardListVO.getTenantID()) + commonUtil.separator + boardListVO.getBoardID() + commonUtil.separator + "uploadFile" + boardListVO.getExtensionAttribute5().split("\\|")[i].replace("tempUploadFile", "");
				File mvFile = new File(boardListVO.getRealPath() + commonUtil.separator + commonUtil.detectPathTraversal(strFilePath));
				
				if(!mvFile.exists()){
					FileUtils.copyFile(file, mvFile);
				}
				
				map.put("v_pIMAGEID", boardListVO.getImagePath().split(";")[i].trim());
				map.put("v_pItemID", boardListVO.getItemID());
				map.put("v_pBoardID", boardListVO.getBoardID());
				map.put("v_pWriterID", boardListVO.getWriterID());
				map.put("v_pWriterName", boardListVO.getWriterName());
				map.put("v_pWriterDeptID", boardListVO.getWriterDeptID());
				map.put("v_pFilePath", strFilePath);
				map.put("v_pWriteDate", boardListVO.getWriteDate());
				map.put("v_TENANTID", boardListVO.getTenantID());
				map.put("mainImageID", boardListVO.getMainImageID());
				
				try {
					map.put("v_pFileContent", boardListVO.getImageContent().split(";:;")[i]);
				} catch (Exception e) {
					map.put("v_pFileContent", "");
				}
				map.put("v_pImageName", boardListVO.getImageNames().split("\\|")[i]);
				
				ezBoardDAO.deletePhotoImageItem(map);
				ezBoardDAO.photoSaveDB(map);
			}
		} // 동영상게시판
		else {
			String tempFilePath = "";
			strFilePath = boardListVO.getExtensionAttribute5();
			tempFilePath = strFilePath.substring(0, strFilePath.lastIndexOf("{")) + "s_";
			tempFilePath += strFilePath.substring(strFilePath.lastIndexOf("{"), strFilePath.length());
			tempFilePath = tempFilePath.substring(0, tempFilePath.lastIndexOf(".") + 1) + boardListVO.getThumbnailExt();
			
			File file = new File(commonUtil.detectPathTraversal(boardListVO.getRealPath() + boardListVO.getFilePath() + commonUtil.separator + strFilePath));
			File s_file = new File(commonUtil.detectPathTraversal(boardListVO.getRealPath() + boardListVO.getFilePath() + commonUtil.separator + tempFilePath));
			
			// 썸네일파일의 고유 ID는 동영상 파일과 같고, 파일명에 's_'가 추가된 .png 파일
			strFilePath = commonUtil.getUploadPath("upload_board.ROOT", boardListVO.getTenantID()) + commonUtil.separator + boardListVO.getBoardID() + commonUtil.separator + "uploadFile" + boardListVO.getExtensionAttribute5().replace("tempUploadFile", "");
			tempFilePath = strFilePath.substring(0, strFilePath.lastIndexOf("{")) + "s_";
			tempFilePath += strFilePath.substring(strFilePath.lastIndexOf("{"), strFilePath.length());
			tempFilePath = tempFilePath.substring(0, tempFilePath.lastIndexOf(".") + 1) + boardListVO.getThumbnailExt();
			
			File mvFile = new File(commonUtil.detectPathTraversal(boardListVO.getRealPath() + commonUtil.separator + strFilePath));
			File s_mvfile = new File(commonUtil.detectPathTraversal(boardListVO.getRealPath() + commonUtil.separator + tempFilePath));
			
			if(!mvFile.exists()){
				FileUtils.copyFile(file, mvFile);
			}
			if(!s_mvfile.exists()) { // 동영상의 썸네일 이미지 파일
				FileUtils.copyFile(s_file, s_mvfile);
			}
			
			map.put("v_pIMAGEID", boardListVO.getImagePath().trim());
			map.put("v_pItemID", boardListVO.getItemID());
			map.put("v_pBoardID", boardListVO.getBoardID());
			map.put("v_pWriterID", boardListVO.getWriterID());
			map.put("v_pWriterName", boardListVO.getWriterName());
			map.put("v_pWriterDeptID", boardListVO.getWriterDeptID());
			map.put("v_pFilePath", strFilePath);
			map.put("v_pWriteDate", boardListVO.getWriteDate());
			map.put("v_TENANTID", boardListVO.getTenantID());
			map.put("mainImageID", boardListVO.getMainImageID());
			map.put("v_addThumbnail", boardListVO.getAddThumbnail());
			map.put("v_thumbnailExt", boardListVO.getThumbnailExt());
			
			try {
				map.put("v_pFileContent", boardListVO.getImageContent());
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
				map.put("v_pFileContent", "");
			}
			map.put("v_pImageName", boardListVO.getImageNames());
			
			ezBoardDAO.deletePhotoImageItem(map);
			ezBoardDAO.photoSaveDB(map);
		}

		logger.debug("photoSaveDB ended");
	}

	public void saveAttachInfo(String strItemID, int seqNum, String filePath, long fileSize, String fileName, int tenantID) throws Exception {
		logger.debug("saveAttachInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_STRITEMID", strItemID);
		map.put("seqNum", seqNum);
		map.put("v_STRATTACHMENTS", filePath);
		map.put("v_FILESIZE", fileSize);
		map.put("v_FILENAME", fileName);
		map.put("v_TENANTID", tenantID);
		
		ezBoardDAO.saveAttachInfo(map);

		logger.debug("saveAttachInfo ended");
	}
	
	/* 댓글 저장 시 회사ID 삽입하도록 수정 */
	@Override
	public void saveOneLineReply(String itemID, String replyID, String boardID, LoginVO userInfo, String content, String password, int replyLevel, String imageContent) throws Exception {
		logger.debug("saveOneLineReply started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("PITEMID", itemID);
		map.put("PREPLYID", replyID);
		map.put("PBOARDID", boardID);
		map.put("USERID", userInfo.getId());
		map.put("USERNAME", userInfo.getDisplayName1());
		map.put("USERNAME2", userInfo.getDisplayName2());
		map.put("PCONTENT", content);
		map.put("PPASSWORD", password);
		map.put("REPLYLEVEL", replyLevel);
		map.put("TENANTID", userInfo.getTenantId());
		map.put("COMPANYID", userInfo.getCompanyID());
		map.put("nowDate", commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss"));
		map.put("v_EMOTICON", imageContent);
		
		ezBoardDAO.saveOneLineReply(map);

		logger.debug("saveOneLineReply ended");
	}
	
	public String getThumbListXML(LoginVO userInfo, String pBoardType, String pBoardID, int pPageNum, String sortHeader, String sortOption) throws Exception {
		logger.debug("getThumbListXML started");

		BoardListVO boardListVO = new BoardListVO();
		BoardVO ezBoardVO = new BoardVO();
		ezBoardVO.setBoardType(pBoardType);
		ezBoardVO.setLang(userInfo.getLang());
		
		BoardMyFavoriteVO myFavoriteVO = new BoardMyFavoriteVO();
		myFavoriteVO.setBoardId(pBoardID);
		myFavoriteVO.setUserId(userInfo.getId());
		myFavoriteVO.setType(pBoardType);
		myFavoriteVO.setNowDate(commonUtil.getTodayUTCTime(""));
		myFavoriteVO.setTenantID(userInfo.getTenantId());
		
		StringBuilder sb = new StringBuilder();
		String orderOption1 = "";
		String orderOption2 = "";
		
		String strMultiData = commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId());
		
		List<BoardListHeaderVO> list = getListHeader(userInfo, ezBoardVO);
		
		int i = 0;
		int hLength = list.size();
		
		//int boardCount = getThumbNailCount(myFavoriteVO);
		int boardCount = ezBoardDAO.getPhotoCount(myFavoriteVO);
		//BoardConfigVO boardConfigVO = getPersonalCount(userInfo);
		//int personalCount = boardConfigVO.getListCount();
		/* 2018-06-04 홍승비 - 포토게시판 포틀릿 표출 썸네일 4개로 수정 */
		int personalCount = 4;
		
		sb.append("<DOCLIST>");
		sb.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
		sb.append("<PAGECNT>" + boardCount + "</PAGECNT>");
		sb.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>");
		sb.append("<LISTVIEWDATA>");
		sb.append("<ROWS>");
		
		int startRow = 1;
		int endRow = 0;
		String fieldName = "";
		String fieldValue = "";
		
		startRow = (personalCount * (pPageNum - 1)) + 1;
		endRow = personalCount * pPageNum;
		
		BoardVO boardVO = new BoardVO();
		
		boardListVO.setUserID(userInfo.getId());
		boardListVO.setBoardID(pBoardID);
		boardListVO.setStartRow(startRow);
		boardListVO.setEndRow(endRow);
		boardListVO.setTotalCount(boardCount);
		boardListVO.setOrderBySub(orderOption1.trim());
		boardListVO.setOrderByMain(orderOption2.trim());
		boardVO.setType("1");
		boardVO.setBoardId(pBoardID);
		boardVO.setTenantID(userInfo.getTenantId());
		
		List<HashMap<String, Object>> boardList = getThumbnailList(boardListVO, boardVO, new HashMap<String, String>());
		
		int dLength = boardList.size();
		
		for (int j=0; j<dLength; j++) {
			sb.append("<ROW>");
			for (i =0; i < hLength; i++) {
				sb.append("<CELL>");
				fieldName = list.get(i).getColName().toUpperCase();
				
				if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME")) {
					fieldName = fieldName + strMultiData;
				}
				
				if (fieldName.equals("WRITEDATE")) {
					fieldValue =(String)boardList.get(j).get(fieldName);
					fieldValue = fieldValue.substring(0, fieldValue.length()-3);
					fieldValue = commonUtil.getDateStringInUTC(fieldValue, userInfo.getOffset(), false);
				} else {
					fieldValue = commonUtil.cleanValue(String.valueOf(boardList.get(j).get(fieldName)));
				}
				
				sb.append("<VALUE>" + fieldValue + "</VALUE>");
				
				if (i == 0) {
					sb.append("<DATA1>" + boardList.get(j).get("BOARDID") + "</DATA1>");
					sb.append("<DATA2>" + boardList.get(j).get("ITEMID") + "</DATA2>");
					sb.append("<DATA3>" + boardList.get(j).get("WRITERID") + "</DATA3>");
					String nowDate = commonUtil.getTodayUTCTime("");
					nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
					
					if (boardList.get(j).get("WRITEDATE").toString().compareTo(nowDate) > 0) {
						sb.append("<DATA4>Y</DATA4>");
					} else {
						sb.append("<DATA4>N</DATA4>");
					}
					
					sb.append("<DATA5>" + commonUtil.cleanValue((String)boardList.get(j).get("FILEPATH")) + "</DATA5>");
					sb.append("<DATA6>" + commonUtil.cleanValue((String)boardList.get(j).get("MAINCONTENT")) + "</DATA6>");
				}
				
				sb.append("</CELL>");
			}
			
			sb.append("</ROW>");
		}
		
		sb.append("</ROWS>");
		sb.append("</LISTVIEWDATA>");
		sb.append("</DOCLIST>");

		logger.debug("getThumbListXML ended");
		return sb.toString();
	}

	@Override
	public String portalPageItemEdit(String boardID, int tenantID) throws Exception {
		logger.debug("portalPageItemEdit started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("boardID", boardID);
		map.put("tenantID", tenantID);

		logger.debug("portalPageItemEdit ended");
		return ezBoardDAO.portalPageItemEdit(map);
	}

	/**
	 * 게시판 트리 표출 Method
	 */
	@SuppressWarnings("unchecked")
	@Override
	public String getBoardTree(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int pMode, int pSubFlag, int pSelectBy, String pExcludeBoardID, String pStrLang, String isAdminLeft, boolean isCompanyAdmin, String boardGroupAdmin_FG, String rollInfo, int tenantID) throws Exception {
		logger.debug("getBoardTree started");
		int count = 0;
		String showAllGroupBoard = "";
		boolean isNormalAdmin = false; // 전체관리자가 아닌 관리자 플래그 (게시관리자, 회사관리자)
		String retValue = ezBoardAdminService.getBoardTree_Get1(pStrLang, pRootBoardID + "," + pUserID + "," + pDeptID + "," + pCompanyID + "," + pMode + "," + pSubFlag + "," + pSelectBy + "," + pExcludeBoardID + "," + isAdminLeft, tenantID);
		
		if (retValue != null && retValue.length() > 30) {
			return retValue;
		}
		
		StringJoiner pAccessID = new StringJoiner(",");
		pAccessID.add(pUserID);
		
		/* 2019-09-18 홍승비 - 개인ID 이후, 부서ID 이전 위치에 직위+직책ID (사내겸직 직위 포함) 추가 */
		String userJJID = getUserJJID(pUserID, pCompanyID, tenantID);
		pAccessID.add(userJJID);
		
		String[] reverseDeptPath = ezOrganService.getDeptFullPath(pDeptID, tenantID).split(",");
		List<String> addJobDeptList = new ArrayList<String>();
		
		for (int i = reverseDeptPath.length -1; i >= 0 ; i--) {
			pAccessID.add(reverseDeptPath[i]);
		}
		
		String pAccessIDStr = pAccessID.toString();
		addJobDeptList.add(pAccessIDStr);
		
		/* 2019-05-28 홍승비 - 현재 소속 회사의 사내겸직이 존재하면 사내겸직부서ID와 그 상위부서ID까지 권한체크에 포함하도록 수정 */
		List<String> addJobList = getPDOAddJobDeptID(pUserID, pCompanyID, tenantID);
		StringJoiner addJobStr = new StringJoiner(",");
		addJobStr.add(pDeptID);
		if (addJobList != null && addJobList.size() > 0) {
			for (int i = 0; i < addJobList.size(); i++) {
				addJobStr.add(addJobList.get(i));
				String upperDept = getUpperDeptID(addJobList.get(i), tenantID);
				
				if (upperDept != null && !upperDept.equals("")) {
					boolean loopContinue = true;
					StringJoiner upperDeptStr = new StringJoiner(",");
					upperDeptStr.add(upperDept);
					
					while (loopContinue) {
						String upperDeptLoop = getUpperDeptID(upperDept, tenantID);
						if (upperDeptLoop != null && !upperDeptLoop.equals("")) {
							upperDeptStr.add(upperDeptLoop);
							upperDept = upperDeptLoop;
						} else {
							loopContinue = false;
						}
					}
					addJobDeptList.add(addJobList.get(i) + "," + upperDeptStr.toString());
				}
			}
		}
		
		/* 2019-06-05 홍승비 - 사간겸직으로 회사변경 시 변경된 관리자 권한 반영되도록 수정 */
		// 전체관리자가 아닌 회사관리자/게시판관리자 플래그 추가
		if (commonUtil.isAdmin(pUserID, tenantID, rollInfo, "k;n")) {
			isNormalAdmin = true;
		}
		
		/* 2018-10-16 홍승비 - 그룹사게시판 표출을 제어하는 showAllGroupBoard 플래그 설정 */
		if (!isAdminLeft.equals("Y") || (isAdminLeft.equals("Y") && isCompanyAdmin == true)) {
			showAllGroupBoard = "Y";
		} else {
			showAllGroupBoard = "N";
		}
		
		/* 2019-09-24 홍승비 - 게시판 접근 허용/불가 판정을 위해 직위, 직책 Set 추가 */
		List<BoardTreeVO> brdBoardTreeList = new ArrayList<BoardTreeVO>();
		List<HashSet<String>> strBanBoardIDListSetDept = new ArrayList<HashSet<String>>();
		HashSet<String> strBanBoardIDListSetUser = new HashSet<String>();
		HashSet<String> strBanBoardIDListSetJJ = new HashSet<String>();
		HashSet<String> userJJIDSet = new HashSet<String>(Arrays.asList(userJJID.split(",")));
		String tempDeptList = addJobStr.toString();
		
		/* 2019-06-03 홍승비 - 전체관리자와 해당 게시판/게시판그룹 관리자(해당 pRootBoardID에 대하여 관리자권한 설정됨)의 게시판 트리 생성 분기를 for 바깥으로 분리 (그룹사게시판을 포함하여 모든 게시판 접근 가능) */
		if ((pMode == 0 && isCompanyAdmin == true) || boardGroupAdmin_FG.equals("OK")) {
			brdBoardTreeList = ezBoardAdminService.brdBoardTree(pRootBoardID, "everyone", pMode, pSelectBy, pExcludeBoardID, pCompanyID, tenantID, 0, 0, showAllGroupBoard, isCompanyAdmin, boardGroupAdmin_FG);
		} else {
			
			/* 2019-06-05 홍승비 - 게시판 트리 생성 시 사내겸직 부서경로 각각에 대해 게시판 가져오고, 접근불가 게시판 제거하도록 수정 */
			int addJobDeptListSize = addJobDeptList.size();
			for (int jl = 0; jl < addJobDeptListSize; jl++) {
				// 부서권한은 우선순위가 하위부서 > 상위부서이므로, 하위부서에서 이미 동일한 게시판ID에 대해 권한 레코드가 존재한다면
				// 상위부서에서 해당 게시판ID에 권한 레코드가 있더라도 스킵한다. (strBanBoardIDListSetTemp에 저장)
				HashSet<String> strBanBoardIDListSetTemp = new HashSet<String>();
				int addJobDeptListPathSize = addJobDeptList.get(jl).split(",").length;
				for (int i = 0; i < addJobDeptListPathSize; i++) {
					String boardID = "";
					// 게시판 권한 추가시 하위부서 권한 상관없이 리스트가 보여지던 현상 수정
					/* 2019-05-30 홍승비 - 현재 소속 회사의 사내겸직도 isEqaulDept값을 체크하도록 수정 */
					int isEqaulDept = 0;
					for (int j = 0; j < tempDeptList.split(",").length; j++) {
						// 사원ID, 부서ID, 회사ID에 대하여 해당부서 직속여부 판단
						if(addJobDeptList.get(jl).split(",")[i].trim().equalsIgnoreCase(tempDeptList.split(",")[j])) {
							isEqaulDept = 1;
							break;
						} else {
							isEqaulDept = 0;
						}
					}
					
					int isDept = isDeptChk(addJobDeptList.get(jl).split(",")[i].trim(), tenantID);
					List<BoardTreeVO> tempBrdBoardTreeList = ezBoardAdminService.brdBoardTree(pRootBoardID, addJobDeptList.get(jl).split(",")[i].trim(), pMode, pSelectBy, pExcludeBoardID, pCompanyID, tenantID, isDept, isEqaulDept, showAllGroupBoard, isCompanyAdmin, boardGroupAdmin_FG);
					
					if (tempBrdBoardTreeList != null && tempBrdBoardTreeList.size() > 0) {
						for (BoardTreeVO k : tempBrdBoardTreeList) {
							if (brdBoardTreeList.size() > 0) {
								int tempCnt = 0;
								
								for (BoardTreeVO h : brdBoardTreeList) {
									if (h.equals(k)) {
										tempCnt++;
									}
								}
								
								if (tempCnt == 0) {
									brdBoardTreeList.add(k);
								}
							} else {
								brdBoardTreeList.add(k);
							}
						}
					}
					
					/* 2019-06-04 홍승비 - 전체관리자가 아닌 관리자라면(isNormalAdmin), 그룹사게시판의 경우에만 불가/허용여부 판단용 게시판ID와 accessID를 가져오도록 수정 */
					List<BoardVO> boardTreeList = ezBoardAdminService.getBoardTree_Get2(addJobDeptList.get(jl).split(",")[i].trim(), pRootBoardID, tenantID, isNormalAdmin, isDept, isEqaulDept);
					if (boardTreeList.size() > 0) {
						for (int r = 0; r < boardTreeList.size(); r++) {
							boardID = boardTreeList.get(r).getBoardId();
							
							/* 2019-09-20 그룹권한 적용으로 그룹에 속한 개인권한 다수 저장 가능 */
							if (addJobDeptList.get(jl).split(",")[i].equals(pUserID)) { // 개인권한은 따로 저장
								strBanBoardIDListSetUser.add(boardID);
							}
							else if (userJJIDSet.contains(addJobDeptList.get(jl).split(",")[i].trim())) { // 직위/직책권한 저장
								strBanBoardIDListSetJJ.add(boardID);
							}
							else { // 부서권한 저장
								// 하위부서와 상위부서가 동일한 게시판에 대해 권한을 가져서 충돌하는 경우, *하위부서를 우선*으로 적용한다.
								// 즉, contains로 strBanBoardIDListSetTemp의 게시판ID 존재 여부를 체크하여 동일한 게시판ID가 이미 존재한다면 스킵한다.
								if (strBanBoardIDListSetTemp.contains(boardID.substring(0, boardID.indexOf("|")) + "|0;") || 
										strBanBoardIDListSetTemp.contains(boardID.substring(0, boardID.indexOf("|")) + "|1;")) {
									continue;
								} else {
									strBanBoardIDListSetTemp.add(boardID);
								}
							}
						}
					}
				}
				
				if (!strBanBoardIDListSetTemp.isEmpty()) {
					strBanBoardIDListSetDept.add((HashSet<String>)strBanBoardIDListSetTemp.clone());
				}
				
				strBanBoardIDListSetTemp.clear();
			}
		}
		
		HashSet<String> strBanBoardIDListSetDept2 = new HashSet<String>();
		for (int i = 0; i < strBanBoardIDListSetDept.size(); i++) {
			strBanBoardIDListSetDept2.addAll(strBanBoardIDListSetDept.get(i));
		}
		
		StringBuilder result = new StringBuilder();
		
/*		if (pSubFlag == 1) {
			result.append("<NODES>");
		} else {
			result.append("<TREEVIEWDATA>");
		}*/
		/* 2020-06-25 홍승비 - 트리캐시 중복 생성 방지 */
		result.append("<NODES>");
		
		/* 2018-07-13 홍승비 - o1=o2(0), o1>o2(1), o1<o2(-1) 분기 추가 */
		Collections.sort(brdBoardTreeList, new Comparator<BoardTreeVO>() {
			@Override
			public int compare(BoardTreeVO o1, BoardTreeVO o2) {
				return Integer.parseInt(o1.getTreeViewOrder()) < Integer.parseInt(o2.getTreeViewOrder()) ? -1 : Integer.parseInt(o1.getTreeViewOrder()) > Integer.parseInt(o2.getTreeViewOrder()) ? 1 : 0;
			}
		});
		
		/* 2019-06-04 홍승비 - 접근 불가한 게시판 체크 시 전체관리자가 아닌 관리자도 해당 분기 타도록 수정 */
		for (int i = 0; i < brdBoardTreeList.size(); i++) {
			if (!isCompanyAdmin) {
				/* 2019-09-20 홍승비 - 그룹권한에 포함된 개인/직위,직책권한도 고려하도록 수정 (동일한 우선순위 권한 간의 불가/허용 충돌 시 '허용' 기준으로 판정) */
				// 개인권한 최우선 확인 (strBanBoardIDListSetUser 직접 사용, '허용' 기준으로 판정)
				if (strBanBoardIDListSetUser.contains(brdBoardTreeList.get(i).getBoardId() + "|0;") && !strBanBoardIDListSetUser.contains(brdBoardTreeList.get(i).getBoardId() + "|1;")) {
					continue;
				}
				// 개인권한에 대해 '허용'권한과 '불가'권한이 모두 존재하지 않음 => 직위, 직책을 체크
				// 개인권한 미존재
				else if (!strBanBoardIDListSetUser.contains(brdBoardTreeList.get(i).getBoardId() + "|0;") && !strBanBoardIDListSetUser.contains(brdBoardTreeList.get(i).getBoardId() + "|1;")) {
					// 직위,직책권한 중 '불가'만 존재
					if  (strBanBoardIDListSetJJ.contains(brdBoardTreeList.get(i).getBoardId() + "|0;") && !strBanBoardIDListSetJJ.contains(brdBoardTreeList.get(i).getBoardId() + "|1;")) {
						continue;
					}
					// 개인권한에 대해 '허용'권한과 '불가'권한이 모두 존재하지 않음 + 직위, 직책에 대해 '허용'권한과 '불가'권한이 모두 존재하지 않음 => 부서권한을 체크
					// 직위,직책권한 미존재
					else if (!strBanBoardIDListSetJJ.contains(brdBoardTreeList.get(i).getBoardId() + "|0;") && !strBanBoardIDListSetJJ.contains(brdBoardTreeList.get(i).getBoardId() + "|1;")) {
						 // 부서권한 중 '불가'만 존재
						if (strBanBoardIDListSetDept2.contains(brdBoardTreeList.get(i).getBoardId() + "|0;") && !strBanBoardIDListSetDept2.contains(brdBoardTreeList.get(i).getBoardId() + "|1;")) {
							continue;	
						}
					}
				}
			}
			
			result.append("<NODE>");
			
			if (pStrLang.equals("")) {
				result.append("<VALUE>" + commonUtil.cleanValue(brdBoardTreeList.get(i).getBoardName()) + "</VALUE>");
			} else if (pStrLang.equals("2")) {
				result.append("<VALUE>" + commonUtil.cleanValue(brdBoardTreeList.get(i).getBoardName2()) + "</VALUE>");
			} else if (pStrLang.equals("3")) {
				result.append("<VALUE>" + commonUtil.cleanValue(brdBoardTreeList.get(i).getBoardName3()) + "</VALUE>");
			} else if (pStrLang.equals("4")) {
				result.append("<VALUE>" + commonUtil.cleanValue(brdBoardTreeList.get(i).getBoardName4()) + "</VALUE>");
			}
			
			result.append("<STYLE><![CDATA[]]></STYLE>");
			result.append("<DATA1>" + brdBoardTreeList.get(i).getBoardId() + "</DATA1>");
			
			if (pStrLang.equals("")) {
				result.append("<DATA2>" + commonUtil.cleanValue(brdBoardTreeList.get(i).getBoardName()) + "</DATA2>");
			} else if (pStrLang.equals("2")) {
				result.append("<DATA2>" + commonUtil.cleanValue(brdBoardTreeList.get(i).getBoardName2()) + "</DATA2>");
			} else if (pStrLang.equals("3")) {
				result.append("<DATA2>" + commonUtil.cleanValue(brdBoardTreeList.get(i).getBoardName3()) + "</DATA2>");
			} else if (pStrLang.equals("4")) {
				result.append("<DATA2>" + commonUtil.cleanValue(brdBoardTreeList.get(i).getBoardName4()) + "</DATA2>");
			}
			
			result.append("<DATA3>" + pRootBoardID + "</DATA3>");
			result.append("<DATA4>" + brdBoardTreeList.get(i).getBoardColor() + "</DATA4>");
			result.append("<DATA5>" + brdBoardTreeList.get(i).getGuBun() + "</DATA5>"); //20070228 포토게시판관련으로 추가함
			result.append("<DATA6>" + brdBoardTreeList.get(i).getUrl() + "</DATA6>"); //2018-08-13 강민수92 url 게시판인지 체크하기 위해 추가
			result.append("<EXPANDED>FALSE</EXPANDED>");
			result.append("<ISLEAF>" + checkIfLeafBoard(brdBoardTreeList.get(i).getBoardId(), tenantID) + "</ISLEAF>");
			
			// 첫번째로 표출되는 게시판그룹을 자동 확장시키기 위한 코드 (현재 쓰이는 곳은 없으며, pSubFlag가 0으로 전달되어야 함)
			if (count == 0 && pSubFlag != 1) {
				result.append("<SELECT>TRUE</SELECT>");
			}
			
			result.append("</NODE>");
			
			count++;
		}
		
/*		if (pSubFlag == 1) {
			result.append("</NODES>");
		} else {
			result.append("</TREEVIEWDATA>");
		}*/
		/* 2020-06-25 홍승비 - 트리캐시 중복 생성 방지 */
		result.append("</NODES>");
		
		// 관리자단과 사용자단의 게시판 표출용 트리캐시를 다르게 생성한다. (isAdminLeft 플래그 추가)
		ezBoardAdminService.getBoardTree_Set_D(pStrLang, pRootBoardID + "," + pUserID + "," + pDeptID + "," + pCompanyID + "," + pMode + "," + pSubFlag + "," + pSelectBy + "," + pExcludeBoardID + "," + isAdminLeft, tenantID);
		ezBoardAdminService.getBoardTree_Set(pStrLang, pRootBoardID + "," + pUserID + "," + pDeptID + "," + pCompanyID + "," + pMode + "," + pSubFlag + "," + pSelectBy + "," + pExcludeBoardID + "," + isAdminLeft, result.toString(), tenantID);

		logger.debug("getBoardTree ended");
        return result.toString();
	}

	/**
	 * 게시판 트리하위여부 표출 Method
	 */
	public String checkIfLeafBoard(String pBoardID, int tenantID) {
		logger.debug("checkIfLeafBoard started");

		try {
			int ret = ezBoardAdminService.checkIfLeafBoard(pBoardID, tenantID);
			
			if (ret > 0) {
				logger.debug("checkIfLeafBoard ended");
				return "FALSE";
			} else {
				logger.debug("checkIfLeafBoard ended");
				return "TRUE";
			}
		} catch(Exception ex) {
			return "FALSE";
		}
	}

	@Override
	public String getItemAttachmentXMLRetrans(BoardItemVO boardItemVO) throws Exception {
		logger.debug("getItemAttachmentXMLRetrans started");
		
		StringBuilder resultXML = new StringBuilder();

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("itemID", boardItemVO.getItemID());
		map.put("tenantID", boardItemVO.getTenantID());
		
		List<BoardAttachVO> boardAttachVOs = ezBoardDAO.brdGetItemAttachmentInfo(map);
		
		resultXML.append("<NODES>");
		
		if (boardItemVO.getMode().equals("boardAttach")) {
			File file = new File(boardItemVO.getFilePath() + commonUtil.detectPathTraversal(boardItemVO.getConLocation()));
			
			String fileExtension = boardItemVO.getConLocation().substring(boardItemVO.getConLocation().lastIndexOf("."));
			//tempUploadFile을 저장할 때 게시판의 제목으로 저장합니다. 이때 파일명으로 사용할 수 없는 특수문자(8개)가 게시판 제목으로 있을 경우 file을 저장할 수 없어 오류가 발생 
			String boardItemTitle = boardItemVO.getTitle().replaceAll("[/*?\"<>|:]","_");
			String newFilePath = commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", boardItemVO.getTenantID()) + 
					commonUtil.separator + "{" + UUID.randomUUID().toString() + "}_" + commonUtil.detectPathTraversal(boardItemTitle + fileExtension);
			long mhtSize = file.length();
			
			FileUtils.copyFile(file, new File(commonUtil.detectPathTraversal(boardItemVO.getFilePath()) + newFilePath));
			
			resultXML.append("<NODE>");
			resultXML.append("<ItemID>" + boardItemVO.getItemID() + "</ItemID>");
			resultXML.append("<FileName><![CDATA[" + commonUtil.cleanValue(boardItemTitle + fileExtension) + "]]></FileName>");
			resultXML.append("<FilePath>" + commonUtil.cleanValue(newFilePath) + "</FilePath>");
			resultXML.append("<FileSize>" + getProperSizeDisplay(mhtSize) + "</FileSize>");
			resultXML.append("<FileSize2>" + mhtSize + "</FileSize2>");
			resultXML.append("</NODE>");
		}
		
		for (int k = 0; k < boardAttachVOs.size(); k++) {
			String filePath = boardAttachVOs.get(k).getFilePath();
			String fileExtension = boardAttachVOs.get(k).getFilePath().substring(boardAttachVOs.get(k).getFilePath().lastIndexOf("."));
			String newFilePath = commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", boardItemVO.getTenantID()) + commonUtil.separator + "{" + UUID.randomUUID().toString() + "}" + fileExtension;
			
			newFilePath = commonUtil.detectPathTraversal(newFilePath);
			FileUtils.copyFile(new File(commonUtil.detectPathTraversal(boardItemVO.getFilePath()) + filePath), new File(boardItemVO.getFilePath() + newFilePath));
			
			resultXML.append("<NODE>");
			resultXML.append("<ItemID>" + boardAttachVOs.get(k).getItemID() + "</ItemID>");
			resultXML.append("<FilePath>" + commonUtil.cleanValue(newFilePath) + "</FilePath>");
			resultXML.append("<FileSize>" + getProperSizeDisplay(Long.parseLong(boardAttachVOs.get(k).getFileSize())) + "</FileSize>");
			resultXML.append("<FileSize2>" + boardAttachVOs.get(k).getFileSize() + "</FileSize2>");
			resultXML.append("<FileName><![CDATA[" + boardAttachVOs.get(k).getFileName() + "]]></FileName>");
			resultXML.append("</NODE>");
		}
		
		resultXML.append("</NODES>");

		logger.debug("getItemAttachmentXMLRetrans ended");
		return resultXML.toString();
	}

	private String getProperSizeDisplay(long mhtSize) {
		logger.debug("getProperSizeDisplay started");
		
		String resultSize = "";

		if (mhtSize > 1048576) {
			resultSize = String.valueOf((double)mhtSize / 1024 / 102.4 / 10) + " MB";
		} else if (mhtSize > 1024) {
			resultSize = String.valueOf(mhtSize / 102.4 / 10) + " KB";
		} else {
			resultSize = String.valueOf(mhtSize) + " Byte";
		}

		logger.debug("getProperSizeDisplay ended");
		return resultSize;
	}

	@Override
	public String getItemAttachmentXML(BoardItemVO boardItemVO) throws Exception {
		logger.debug("getItemAttachmentXML started");

		StringBuilder resultXML = new StringBuilder();

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("itemID", boardItemVO.getItemID());
		map.put("tenantID", boardItemVO.getTenantID());
		
		List<BoardAttachVO> boardAttachVOs = ezBoardDAO.brdGetItemAttachmentInfo(map);
		String useEditor = ezCommonService.getTenantConfig("MODULEEDITOR", boardItemVO.getTenantID());
		String conLocation = boardItemVO.getConLocation();
		String ext = conLocation.substring(conLocation.length() - 3, conLocation.length());
		
		resultXML.append("<NODES>");
		
		if (useEditor.equals("HWP") && ext.toUpperCase().equals("HWP")) {
			map.put("tempString", boardItemVO.getItemID());
			BoardListVO boardContent = ezBoardDAO.getItemInfo(map);
			File file = new File(boardItemVO.getFilePath() + commonUtil.detectPathTraversal(boardContent.getContentLocation()));
			long fileSize = file.length();
			resultXML.append("<NODE>");
			resultXML.append("<ItemID>" + boardContent.getItemID() + "</ItemID>");
			resultXML.append("<GUID>0</GUID>");
			resultXML.append("<FilePath>" + commonUtil.cleanValue(boardContent.getContentLocation()) + "</FilePath>");
			resultXML.append("<FileSize>" + getProperSizeDisplay(fileSize) + "</FileSize>");
			resultXML.append("<FileSize2>" + fileSize + "</FileSize2>");
			resultXML.append("<FileName><![CDATA[" + boardContent.getTitle() + "]]></FileName>");
			resultXML.append("</NODE>");
		}
		
		for (int k = 0; k < boardAttachVOs.size(); k++) {
			resultXML.append("<NODE>");
			resultXML.append("<ItemID>" + boardAttachVOs.get(k).getItemID() + "</ItemID>");
			resultXML.append("<GUID>" + boardAttachVOs.get(k).getGuid() + "</GUID>");
			resultXML.append("<FilePath>" + commonUtil.cleanValue(boardAttachVOs.get(k).getFilePath()) + "</FilePath>");
			resultXML.append("<FileSize>" + getProperSizeDisplay(Long.parseLong(boardAttachVOs.get(k).getFileSize())) + "</FileSize>");
			resultXML.append("<FileSize2>" + boardAttachVOs.get(k).getFileSize() + "</FileSize2>");
			resultXML.append("<FileName><![CDATA[" + boardAttachVOs.get(k).getFileName() + "]]></FileName>");
			resultXML.append("</NODE>");
		}
		
		resultXML.append("</NODES>");

		logger.debug("getItemAttachmentXML ended");
		return resultXML.toString();
	}

	@Override
	public List<BoardAccessVO> getPostNotiMailUserList(String boardID, String primary, int tenantID) throws Exception {
		logger.debug("getPostNotiMailUserList started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("boardID", boardID);
		map.put("primary", primary);
		map.put("tenantID", tenantID);

		logger.debug("getPostNotiMailUserList ended");
		return ezBoardDAO.getPostNotiMailUserList(map);
	}

	@Override
	public int getItemViewNew(String boardID, String itemID, int tenantID) throws Exception {
		logger.debug("getItemViewNew started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("boardID", boardID);
		map.put("itemID", itemID);
		map.put("tenantID", tenantID);

		logger.debug("getItemViewNew ended");
		return ezBoardDAO.getItemViewNew(map);
	}

	@Override
	public List<BoardListVO> getReplyNoticeMail(String boardID, String itemTreeID, String lang, int tenantID) throws Exception {
		logger.debug("getReplyNoticeMail started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("boardID", boardID);
		map.put("itemTreeID", itemTreeID.substring(0, 38));
		map.put("lang", commonUtil.getMultiData(lang, tenantID));
		map.put("tenantID", tenantID);
		
		logger.debug("getReplyNoticeMail ended");
		return ezBoardDAO.getReplyNoticeMail(map);
	}

	@Override
	public List<LoginVO> getSendApprMailList(String boardID, String lang, int tenantID) throws Exception {
		logger.debug("getSendApprMailList started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("boardID", boardID);
		map.put("lang", commonUtil.getMultiData(lang, tenantID));
		map.put("tenantID", tenantID);

		logger.debug("getSendApprMailList ended");
		return ezBoardDAO.getSendApprMailList(map);
	}

	@Override
	public String saveImageItem(String requestXML, String realPath, LoginSimpleVO userInfo) throws Exception {
		logger.debug("saveImageItem started");
		
		String resultValue = "";

		try {
			Document doc = commonUtil.convertStringToDocument(requestXML);
			BoardListVO boardListVO = new BoardListVO();
			
			boardListVO.setBoardID(doc.getElementsByTagName("BOARDID").item(0).getTextContent());
			boardListVO.setItemID(doc.getElementsByTagName("ITEMID").item(0).getTextContent());
			boardListVO.setImageID(doc.getElementsByTagName("IMAGE_ID").item(0).getTextContent());
			boardListVO.setFilePath(doc.getElementsByTagName("FILEPATH").item(0).getTextContent());
			boardListVO.setFileContent(doc.getElementsByTagName("CONTENT2").item(0).getTextContent());
			boardListVO.setImageNames(doc.getElementsByTagName("IMAGE_FILENAME").item(0).getTextContent());
			boardListVO.setWriteDate(commonUtil.getDateStringInUTC(doc.getElementsByTagName("STARTDATE").item(0).getTextContent(), userInfo.getOffset(), true));
			boardListVO.setWriterDeptID(doc.getElementsByTagName("DEPTID").item(0).getTextContent());
			boardListVO.setWriterID(doc.getElementsByTagName("WRITERID").item(0).getTextContent());
			boardListVO.setWriterName(doc.getElementsByTagName("WRITERNAME").item(0).getTextContent());
			boardListVO.setTenantID(userInfo.getTenantId());
			
			int savecount = 0;
			String[] imageIDs = boardListVO.getImageID().split(";");
			String[] filePaths = boardListVO.getFilePath().split("\\|");
			String[] fileContents = boardListVO.getFileContent().split(";:;");
			String[] imageName = boardListVO.getImageNames().split("\\|");
			
			savecount = boardListVO.getImageID().split(";").length;
			boardListVO.setWriteDate(commonUtil.getTodayUTCTime(""));
			
			for (int k = 0; k < savecount; k++) {
				String uploadFilePath = realPath + commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId());
				String tempFilePath = "";
				String checkFilePath = commonUtil.detectPathTraversal(filePaths[k]);
				
				if (checkFilePath.indexOf("s_") == -1) {
					File file = new File(uploadFilePath + commonUtil.separator + checkFilePath);
					if (file.exists()) {
						tempFilePath = uploadFilePath + commonUtil.separator + boardListVO.getBoardID() + commonUtil.separator + "uploadFile" + checkFilePath.replace("tempUploadFile", "");
						FileUtils.copyFile(file, new File(tempFilePath));
						FileUtils.deleteQuietly(file);
					}
				} else {
					File file2 = new File(uploadFilePath + commonUtil.separator + checkFilePath.replace("s_", ""));
					if (file2.exists()) {
						tempFilePath = uploadFilePath + commonUtil.separator + boardListVO.getBoardID() + commonUtil.separator + "uploadFile" + checkFilePath.replace("s_", "").replace("tempUploadFile", "");
						FileUtils.copyFile(file2, new File(tempFilePath));
						FileUtils.deleteQuietly(file2);
					}
				}
				
				boardListVO.setImageID(imageIDs[k].trim());
				boardListVO.setFilePath(tempFilePath.replace(realPath, ""));
				
				if (fileContents.length == 0) {
					boardListVO.setFileContent("");
				} else {
					boardListVO.setFileContent(fileContents[k]);
				}
				
				boardListVO.setImageNames(imageName[k].trim());
				
				photoListInsert(boardListVO);
			}
			
			resultValue = "OK";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			logger.error(e.getMessage(), e);
			resultValue = "ERROR";
		}

		logger.debug("saveImageItem ended");
		return resultValue;
	}
	
	@Override
	public List<BoardListVO> getUnreadItems(String pUserID, String pBoardID, int pMaxCount, int tenantID) throws Exception {
		logger.debug("getUnreadItems started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PMAXCOUNT", pMaxCount);
		map.put("v_PUSERID", pUserID);
		map.put("v_PBOARDID", pBoardID);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantID);

		logger.debug("getUnreadItems ended");
		return ezBoardDAO.getUnreadItems(map);
	}
	
	@Override
	public int getUnreadItemsCount(String userID, String boardID, int tenantID) throws Exception {
		logger.debug("getUnreadItemsCount started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", userID);
		map.put("v_PBOARDID", boardID);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantID);

		logger.debug("getUnreadItemsCount ended");
		return ezBoardDAO.getUnreadItemsCount(map);
	}

	public String newItemPhoto(Document doc, String mode, String realPath, LoginVO userInfo, String mainImageID) throws Exception {
		logger.debug("newItemPhoto started");
		
		String result = "";
		
		try {
			BoardListVO boardListVO = new BoardListVO();

			boolean saveMHTResult = false;
			
			boardListVO.setFilePath(doc.getElementsByTagName("FILEPATH").item(0).getTextContent());
			boardListVO.setItemID(doc.getElementsByTagName("ITEMID").item(0).getTextContent());
			boardListVO.setBoardID(doc.getElementsByTagName("BOARDID").item(0).getTextContent());
			boardListVO.setWriterID(doc.getElementsByTagName("WRITERID").item(0).getTextContent());
			boardListVO.setWriterName(doc.getElementsByTagName("WRITERNAME").item(0).getTextContent());
			boardListVO.setWriterName2(doc.getElementsByTagName("WRITERNAME2").item(0).getTextContent());
			boardListVO.setWriterDeptID(doc.getElementsByTagName("DEPTID").item(0).getTextContent());
			boardListVO.setWriterDeptName(doc.getElementsByTagName("DEPTNAME").item(0).getTextContent());
			boardListVO.setWriterDeptName2(doc.getElementsByTagName("DEPTNAME2").item(0).getTextContent());
			boardListVO.setWriterCompanyID(doc.getElementsByTagName("COMPANYID").item(0).getTextContent());
			boardListVO.setWriterCompanyName(doc.getElementsByTagName("COMPANYNAME").item(0).getTextContent());
			boardListVO.setWriterCompanyName2(doc.getElementsByTagName("COMPANYNAME2").item(0).getTextContent());
			boardListVO.setWriteDate(commonUtil.getTodayUTCTime(""));
			boardListVO.setImportance(doc.getElementsByTagName("IMPORTANCE").item(0).getTextContent());
			boardListVO.setTitle(doc.getElementsByTagName("TITLE").item(0).getTextContent());
			boardListVO.setMainContent(doc.getElementsByTagName("CONTENT").item(0).getTextContent());
			boardListVO.setMainImageID(mainImageID);
			boardListVO.setRealPath(realPath);
			boardListVO.setTenantID(userInfo.getTenantId());
			
			if (mode.equals("copy")) {
				boardListVO.setContentLocation(doc.getElementsByTagName("CONTENTLOCATION").item(0).getTextContent());
			} else {
				boardListVO.setContentLocation(commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId()) + commonUtil.separator + boardListVO.getBoardID() + commonUtil.separator + "doc" + commonUtil.separator + boardListVO.getItemID() + ".mht");
			}
			
			boardListVO.setStartDate(commonUtil.getDateStringInUTC(doc.getElementsByTagName("STARTDATE").item(0).getTextContent(), userInfo.getOffset(), true));
			
			if (boardListVO.getStartDate() != null && boardListVO.getStartDate().equals("")) {
				boardListVO.setStartDate(boardListVO.getWriteDate());
			}
			
			boardListVO.setEndDate(commonUtil.getDateStringInUTC(doc.getElementsByTagName("ENDDATE").item(0).getTextContent(), userInfo.getOffset(), true));
			boardListVO.setABSTRACT(doc.getElementsByTagName("ABSTRACT").item(0).getTextContent());
			boardListVO.setAttachments(doc.getElementsByTagName("ATTACHMENTS").item(0).getTextContent());
			boardListVO.setUpperItemIDTree(doc.getElementsByTagName("UPPERITEMIDTREE").item(0).getTextContent());
			
			if (mode.equals("reply")) {
				boardListVO.setUpperItemIDTree(boardListVO.getUpperItemIDTree() + getReverseDateNow() + boardListVO.getItemID());
			}
			
			boardListVO.setItemLevel(doc.getElementsByTagName("ITEMLEVEL").item(0).getTextContent());
			
			if (doc.getElementsByTagName("EXTENSIONATTRIBUTE1").item(0).getTextContent() == null || doc.getElementsByTagName("EXTENSIONATTRIBUTE1").item(0).getTextContent().equals("")) {
				boardListVO.setExtensionAttribute1("0");
			} else {
				boardListVO.setExtensionAttribute1(doc.getElementsByTagName("EXTENSIONATTRIBUTE1").item(0).getTextContent());
			}
			
			if (doc.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent() == null || doc.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent().equals("")) {
				boardListVO.setExtensionAttribute2("0");
			} else {
				boardListVO.setExtensionAttribute2(doc.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent());
			}
			
			boardListVO.setExtensionAttribute3(doc.getElementsByTagName("EXTENSIONATTRIBUTE3").item(0).getTextContent());
			boardListVO.setExtensionAttribute32(doc.getElementsByTagName("EXTENSIONATTRIBUTE32").item(0).getTextContent());
			boardListVO.setExtensionAttribute4(doc.getElementsByTagName("EXTENSIONATTRIBUTE4").item(0).getTextContent());
			boardListVO.setExtensionAttribute5(doc.getElementsByTagName("EXTENSIONATTRIBUTE5").item(0).getTextContent());
			boardListVO.setDocPassword(doc.getElementsByTagName("DOCPASSWORD").item(0).getTextContent());
			
			if (!mode.equals("copy")) {
				saveMHTResult = saveMHT(boardListVO.getMainContent(), boardListVO.getItemID(), boardListVO.getBoardID(), boardListVO.getFilePath(), "PHOTO", realPath);
				if (saveMHTResult == false) {
					return egovMessageSource.getMessage("ezCommunity.lhj04", userInfo.getLocale());
				}
			}
			
			if (boardListVO.getAttachments() != null && !boardListVO.getAttachments().equals("")) {
				boardListVO.setHasAttach("1");
			} else {
				boardListVO.setHasAttach("0");
			}
			
			if (boardListVO.getItemLevel() == null || boardListVO.getItemLevel().equals("")) {
				boardListVO.setItemLevel("0");
			}
			
			boardListVO.setImageCount(Integer.parseInt(doc.getElementsByTagName("IMAGE_COUNT").item(0).getTextContent()));
			boardListVO.setImagePath(doc.getElementsByTagName("IMAGE_ID").item(0).getTextContent());
			boardListVO.setImageContent(doc.getElementsByTagName("CONTENT2").item(0).getTextContent());
			boardListVO.setImageNames(doc.getElementsByTagName("IMAGE_FILENAME").item(0).getTextContent());
			if (doc.getElementsByTagName("THUMBNAILEXT").item(0) != null) {
				boardListVO.setThumbnailExt(doc.getElementsByTagName("THUMBNAILEXT").item(0).getTextContent());
			}
			if (doc.getElementsByTagName("ADDTHUMBNAIL").item(0) != null) {
				boardListVO.setAddThumbnail(doc.getElementsByTagName("ADDTHUMBNAIL").item(0).getTextContent());
			}
			
			/* 2018-11-06 홍승비 - 포토/썸네일/동영상게시판 구분용 설정 추가 */
			if (doc.getElementsByTagName("GUBUN").item(0).getTextContent() != null) {
				boardListVO.setGuBun(doc.getElementsByTagName("GUBUN").item(0).getTextContent());
			} else {
				boardListVO.setGuBun("");
			}

			if (null != doc.getElementsByTagName("WRITERNAMETYPE").item(0) && null != doc.getElementsByTagName("WRITERNAMETYPE").item(0).getTextContent()) {
				boardListVO.setWriterNameType(doc.getElementsByTagName("WRITERNAMETYPE").item(0).getTextContent());
			} else {
				boardListVO.setWriterNameType("");
			}
			
			if (mode.equals("modify")) {
				brdUpdateItem(boardListVO, "PHOTO");
			} else if (mode.equals("temp")) {
				brdNewItemTempPhoto(boardListVO);
			} else {
				brdNewItemPhoto(boardListVO);
			}
			
			if (boardListVO.getAttachments() != null && !boardListVO.getAttachments().equals("")) {
				if (!saveAttachmentsInfo(boardListVO.getAttachments(), boardListVO.getItemID(), boardListVO.getBoardID(), boardListVO.getFilePath(), "PHOTO", realPath, userInfo.getTenantId(), boardListVO.getImageNames())) {
					return egovMessageSource.getMessage("ezCommunity.lhj05", userInfo.getLocale());
				}
				
				boardListVO.setHasAttach("1");
			} else {
				boardListVO.setHasAttach("0");
			}

			// 키워드 저장
			List<String> keywords = new ArrayList<>();
			NodeList keywordNodeList = doc.getElementsByTagName("KEYWORD");
			if (keywordNodeList != null && keywordNodeList.getLength() > 0) {
				for (int i = 0; i < keywordNodeList.getLength(); i++) {
					keywords.add(keywordNodeList.item(i).getTextContent());
				}
				
				if (keywords.size() > 0) {
					saveKeyword(keywords, boardListVO.getBoardID(), boardListVO.getItemID(), userInfo.getTenantId());
				}
			}

			result = "OK";
		} catch (Exception e) {
			logger.debug(e.getMessage());
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			result = "ERROR";
		}		
		
		logger.debug("newItemPhoto ended");
		return result;
	}

	/**
	 * 게시판 게시물 첨부파일저장 실행 Method
	 */
	public boolean saveAttachmentsInfo(String strAttachments, String strItemID, String strBoardID, String strFilePath, String strType, String realPath, int tenantID, String realFileNames) throws Exception {
		logger.debug("saveAttachmentsInfo started");

		long fileSize = 0;
		boolean rtnValue = false;
		String filePath = "";
		String filePath2 = "";
		String fileName = "";
		
		try {
			if (!strAttachments.substring(strAttachments.length() - 1).equals("|")) {
				strAttachments += "|";
			}
			
			if (!realFileNames.equals("") && !realFileNames.substring(realFileNames.length() - 1).equals("|")) {
				realFileNames += "|";
			}
			
			for (int i = 0; i < strAttachments.split("\\|").length; i++) {
				String tempAttachmentPath = commonUtil.detectPathTraversal(strAttachments.split("\\|")[i]);
				boolean isKlibEncrypted = tempAttachmentPath.endsWith("." + EzApprovalGKlibService.ENCRYPTED_FILE_EXT);
				String uploadAttachmentPath;
				
				if (isKlibEncrypted) {
					uploadAttachmentPath = tempAttachmentPath.substring(0, tempAttachmentPath.lastIndexOf('.'));
				} else {
					uploadAttachmentPath = tempAttachmentPath;
				}
				
				if (strType.equals("BOARD")) {
					if (tempAttachmentPath.indexOf("upload_board") > -1) {
						filePath = tempAttachmentPath;
					} else {
						filePath = strFilePath + commonUtil.separator + tempAttachmentPath;
					}
					
					File file = new File(realPath + commonUtil.detectPathTraversal(filePath));
					fileSize = file.length();
					
					if (tempAttachmentPath.indexOf("tempUploadFile") > -1) {
						filePath2 = strFilePath + commonUtil.separator + strBoardID + commonUtil.separator + "uploadFile" + uploadAttachmentPath.replace("tempUploadFile", "");
						
						File fileinfo = new File(realPath + commonUtil.detectPathTraversal(filePath2));
						
						if (!fileinfo.exists()) {
							if (isKlibEncrypted) {
								byte[] fileBytes = FileUtils.readFileToByteArray(file);
								fileBytes = klibUtil.decrypt(fileBytes);
								FileUtils.writeByteArrayToFile(fileinfo, fileBytes);
							} else {
								FileUtils.moveFile(file, fileinfo);
							}
						}
					} else if (tempAttachmentPath.indexOf("upload_board") > -1) {
						filePath2 = tempAttachmentPath;
					} else {
						filePath2 = strFilePath + commonUtil.separator + tempAttachmentPath;
					}
					
					file = null;
					if(realFileNames == null || realFileNames.isEmpty()){
						fileName = filePath2.replace(strFilePath + commonUtil.separator + strBoardID + commonUtil.separator + "uploadFile", "").substring(40);
					}
				} else { // strType : PHOTO
					File file = new File(realPath + commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", tenantID)  + commonUtil.separator + tempAttachmentPath.split("/")[2]);
					fileSize = file.length();
					
					filePath2 = strFilePath + commonUtil.separator + strBoardID + commonUtil.separator + "uploadFile" + commonUtil.separator + uploadAttachmentPath.split("/")[2];
					
					File fileinfo = new File(realPath + filePath2);
					
					if (!fileinfo.exists()) {
						if (isKlibEncrypted) {
							byte[] fileBytes = FileUtils.readFileToByteArray(file);
							fileBytes = klibUtil.decrypt(fileBytes);
							FileUtils.writeByteArrayToFile(fileinfo, fileBytes);
						} else {
							FileUtils.moveFile(file, fileinfo);
						}
						
						file.delete();
					}
				}

				if(realFileNames != null && !realFileNames.isEmpty()){
					fileName = commonUtil.detectPathTraversal(realFileNames.split("\\|")[i]);
				}
//				// 2018.07.05 - KLIB - ezd 확장자 없애기
//				if (fileName.endsWith("." + EzApprovalGKlibService.ENCRYPTED_FILE_EXT)) {
//					fileName = fileName.substring(0, fileName.lastIndexOf("."));
//				}
				
				saveAttachInfo(strItemID, i, filePath2, fileSize, fileName, tenantID);
			}
			
			rtnValue = true;
		} catch (Exception e) {
			logger.debug(e.getMessage());
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			rtnValue = false;
		}

		logger.debug("saveAttachmentsInfo ended");
        return rtnValue;
	}
	
	/**
	 * 게시판 mht저장 실행 Method
	 */
	public boolean saveMHT(String strHTML, String strMHTFilename, String strBoardID, String strFilePath, String strType, String realPath) throws Exception {
		logger.debug("saveMHT started");
		//logger.debug("strHTML length : " + strHTML.length());

		String docPath = "";
		String mhtFilePath = "";
		boolean ret = true;
		
		if (strType.equals("BOARD")) {
			strHTML = strHTML.replace("'", "''");
		}
		
		docPath = commonUtil.detectPathTraversal(strFilePath + commonUtil.separator + strBoardID);
		mhtFilePath = commonUtil.detectPathTraversal(strMHTFilename + ".mht");
		
		String stordFilePathReal = docPath + commonUtil.separator + "doc";
		
		File file = new File(realPath + stordFilePathReal);
		
		if (!file.exists()) {
			boolean _flag = file.mkdirs();
			file = new File(realPath + docPath + commonUtil.separator + "uploadFile");
			file.mkdirs();
			
			if (!_flag) {
				throw new IOException("Directory creation Failed ");
			}
		}
		
		try (
			InputStream stream = new ByteArrayInputStream(strHTML.getBytes("UTF-8"));
			OutputStream bos = new FileOutputStream(realPath + stordFilePathReal + commonUtil.separator + mhtFilePath)
			) {
			
			int bytesRead = 0;
			byte[] buffer = new byte[2048];
			
			while ((bytesRead = stream.read(buffer, 0, 2048)) != -1) {
				bos.write(buffer, 0, bytesRead);
			}
		}
		catch (RuntimeException e) {
			throw e;
		}
		catch (Exception e) {
			ret = false;
		}
		
		logger.debug("saveMHT ended");
		return ret;
	}
	
	/**
	 * 게시판 9999년도부터 뒤로 날짜계산 표출 Method
	 */
	public String getReverseDateNow() {
		logger.debug("getReverseDateNow started");

		StringBuilder reverseDate = new StringBuilder();
		Calendar cal = Calendar.getInstance();
		
		reverseDate.append(9999 - cal.get(Calendar.YEAR));
		reverseDate.append(21 - cal.get(Calendar.MONTH));
		reverseDate.append(41 - cal.get(Calendar.DATE));
		reverseDate.append(33 - cal.get(Calendar.HOUR));
		reverseDate.append(69 - cal.get(Calendar.MINUTE));
		reverseDate.append(69 - cal.get(Calendar.SECOND));

		logger.debug("getReverseDateNow ended");
		return reverseDate.toString();
	}

	@Override
	public String getContentInfo(String type, String docID, int tenantID) throws Exception {
		logger.debug("getContentInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("type", type);
		map.put("docID", docID);
		map.put("tenantID", tenantID);

		logger.debug("getContentInfo ended");
		return ezBoardDAO.getContentInfo(map);
	}

	@Override
	public BoardAttachVO getAttachInfo(String itemID, String attID, int tenantID) throws Exception {
		logger.debug("getAttachInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("itemID", itemID);
		map.put("attID", attID);
		map.put("tenantID", tenantID);

		logger.debug("getAttachInfo ended");
		return ezBoardDAO.getAttachInfo(map);
	}

	@Override
	public String deleteItem(String itemList, String mode, String boardID, String realPath, LoginVO userInfo, BoardPropertyVO boardInfo) throws Exception {
		logger.debug("deleteItem started");
		
		try {
			String[] itemListArray = itemList.split(";");
			
			if (boardID != null && !boardID.equals("")) {
				if (!boardInfo.getDelete_FG().equals("true")) {
					if (!boardInfo.getBoardAdmin_FG().equals("true")) {
						if (!boardInfo.getBoardGroupAdmin_FG().equals("OK")) {
							return "NO";
						}
					} else {
						if (!boardInfo.getBoardGroupAdmin_FG().equals("OK")) {
							return "NO";
						}
					}
				}
			} else {
				BoardListVO boardListVO = getItemInfo(mode, itemList.split(";")[0].split(",")[0], userInfo.getLang(), userInfo.getTenantId());
				boardID = boardListVO.getBoardID();

				if (!boardInfo.getDelete_FG().equals("true")) {
					if (!boardInfo.getBoardAdmin_FG().equals("true")) {
						if (!boardInfo.getBoardGroupAdmin_FG().equals("OK")) {
							return "NO";
						}
					} else {
						if (!boardInfo.getBoardGroupAdmin_FG().equals("OK")) {
							return "NO";
						}
					}
				}
			}
			
			for (int i = 0; i < itemListArray.length; i++) {
				//중복제거 구문
				itemListArray = new HashSet<String>(Arrays.asList(itemListArray)).toArray(new String[0]);
				
				String tempItem = itemListArray[i].split(",")[0];
				
				BoardListVO boardListTempVO = getItemInfo(mode, tempItem, userInfo.getLang(), userInfo.getTenantId());
				if (boardListTempVO != null) {
					logger.debug("deleteItem itemID = " + boardListTempVO.getItemID() + " / title = " + boardListTempVO.getTitle());
				}

				// 2024-08-27 전인하 - 게시물 삭제할 때 키워드도 함께 삭제함
				saveKeyword(null, boardID, tempItem, userInfo.getTenantId());
				
				if (mode != null && mode.equals("temp")) {
					deleteTempItem(tempItem, boardID, realPath, userInfo.getTenantId());
				} else {
					deleteItem(mode, tempItem, boardID, realPath, userInfo.getTenantId());
                    deleteStarRating(tempItem, userInfo.getTenantId());
					deleteStarRatingSummary(tempItem, userInfo.getTenantId());
				}
			}
			
			logger.debug("deleteItem ended");
			return "OK";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			logger.debug("deleteItem error!");
			logger.error(e.getMessage(), e);
			return "ERROR";
		}
	}

	public List<BoardDeleteItemVO> getExpiredItems() throws Exception {
		logger.debug("getExpiredItems started");

		List<BoardDeleteItemVO> expiredItemList = ezBoardDAO.getExpiredItems();

		logger.debug("getExpiredItems ended");
		return expiredItemList;
	}

	@Override
	public void deleteExpiredItems(String realPath) throws Exception {
		logger.debug("deleteExpiredItems started");

		List<BoardDeleteItemVO> expiredItemList = getExpiredItems();
		
		for (BoardDeleteItemVO k : expiredItemList) {
			deleteItem("", k.getItemID(), k.getBoardID(), realPath, k.getTenantID());
		}

		logger.debug("deleteExpiredItems ended");
	}

	@Override
	public void deleteReservedBoard(String realPath) throws Exception {
		logger.debug("deleteReservedBoard started");
		
		int deleteCnt = 0;
		List<BoardDeleteItemVO> boardInfoList = ezBoardDAO.getDeleteReservedBoard();
		
		for (BoardDeleteItemVO k : boardInfoList) {
			//logger.debug("deleteBoardPath :  " + realPath + commonUtil.getUploadPath("upload_board.ROOT", k.getTenantID()) + commonUtil.separator + k.getBoardID());
			Path docPath = Paths.get(realPath + commonUtil.getUploadPath("upload_board.ROOT", k.getTenantID()) + commonUtil.separator + commonUtil.detectPathTraversal(k.getBoardID()));
			
			//게시판 디렉토리 하위 이미지, 게시물 관련 파일 모두 지우기
			try {
				Files.walkFileTree(docPath, new FileVisitor<Path>() {
					@Override
					public FileVisitResult preVisitDirectory(Path dir, BasicFileAttributes attrs) throws IOException {
						//logger.debug("delete preVisitDirectory :: " + docPath);
						return FileVisitResult.CONTINUE;
					}

					@Override
					public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {
						Files.deleteIfExists(file);
						//logger.debug("delete File :: " + docPath);
						return FileVisitResult.CONTINUE;
					}

					@Override
					public FileVisitResult visitFileFailed(Path file, IOException exc) throws IOException {
						//logger.debug("delete visitFileFailed :: " + docPath);
						return FileVisitResult.CONTINUE;
					}

					@Override
					public FileVisitResult postVisitDirectory(Path dir, IOException exc) throws IOException {
						if (exc == null) {
							Files.deleteIfExists(dir);
							//logger.debug("delete Directory :: " + docPath);
							return FileVisitResult.CONTINUE;
						} else {
							throw exc;
						}
					}
				});
				
				deleteCnt++;
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
			
			ezBoardDAO.deleteReservedBoard(k);
			//logger.debug("delete boardID : " + k.getBoardID() + " is Done");
		}
		
		//logger.debug("deleteReservedBoard:::deleteBoardCount = " + deleteCnt);
		logger.debug("deleteReservedBoard ended");
	}

	@Override
	public void deleteReservedBoardItem(String realPath) throws Exception {
		logger.debug("deleteReservedBoardItem started");

		List<BoardDeleteItemVO> boardItemList = ezBoardDAO.getDeleteReservedBoardItem();
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		for (BoardDeleteItemVO k : boardItemList) {
			Path docPath = Paths.get(realPath + commonUtil.getUploadPath("upload_board.ROOT", k.getTenantID()) + commonUtil.separator + commonUtil.detectPathTraversal(k.getBoardID())
					+ commonUtil.separator + "doc" + commonUtil.separator + commonUtil.detectPathTraversal(k.getItemID()) + ".mht");
			
			Files.deleteIfExists(docPath);
			
			map.put("itemID", k.getItemID());
			map.put("boardID", k.getBoardID());
			map.put("tenantID", k.getTenantID());
			
			List<String> filePathList = ezBoardDAO.getCopyItemAttach(map);
			
			for (String h : filePathList) {
				Path filePath = Paths.get(realPath + commonUtil.detectPathTraversal(h));
				
				Files.deleteIfExists(filePath);
			}
			
			ezBoardDAO.deleteBoardItemAttach(map);
			ezBoardDAO.deleteReservedBoardItem(k);
			//logger.debug("delete itemID : " + k.getItemID() + " is Done");
		}

		logger.debug("deleteReservedBoardItem ended");
	}

	/* 2023-05-03 기민혁 - 나의 스크랩 삭제 스케줄러 */
	@Override
	public void deleteItemsScrap() throws Exception {
		logger.debug("deleteItemsScrap started");

		List<BoardDeleteItemVO> scrapItemList = ezBoardDAO.deleteItemsScrapList();

		Map<String, Object> map = new HashMap<String, Object>();

		for (BoardDeleteItemVO s : scrapItemList) {

			map.put("itemID", s.getItemID());
			map.put("boardID", s.getBoardID());
			map.put("tenantID", s.getTenantID());

			ezBoardDAO.deleteItemsScrap(s);
		}

		logger.debug("deleteItemsScrap ended");
	}

	/* 2023-05-22 기민혁 - 스크랩함 삭제 스케줄러 */
	@Override
	public void deleteItemsScrapCont() throws Exception {
		logger.debug("deleteItemsScrapCont started");

		List<BoardDeleteItemVO> scrapItemList = ezBoardDAO.deleteItemsScrapContList();

		Map<String, Object> map = new HashMap<String, Object>();

		for (BoardDeleteItemVO s : scrapItemList) {

			map.put("itemID", s.getItemID());
			map.put("boardID", s.getBoardID());
			map.put("tenantID", s.getTenantID());

			ezBoardDAO.deleteItemsScrapCont(s);
		}

		logger.debug("deleteItemsScrapCont ended");
	}

	@Override
	public String moveItem(String orgItemIDList, String orgBoardIDList, String destBoardID, LoginVO userInfo, String uploadFilePath, String realPath) throws Exception {
		logger.debug("moveItem started");

		String result = "";
		String destItemID = "";
		String orgBoardID = "";
		String[] itemIDArray = orgItemIDList.split(";");
		String useAppr = "N";
		StringBuilder destItemIDStr = new StringBuilder();
		StringBuilder resultStr = new StringBuilder();
		List<String> deleteMHTStr = new ArrayList<String>(); // DB 데이터 변경작업 이후 한꺼번에 삭제할 MHT파일 경로
		List<String> deleteAttachStr = new ArrayList<String>(); // DB 데이터 변경작업 이후 한꺼번에 삭제할 첨부파일 경로
		
		// 목표 게시판이 승인을 사용하는지 체크
		BoardPropertyVO destBoardProp = getBoardProperty(destBoardID, userInfo.getTenantId());
		if (destBoardProp != null && destBoardProp.getApprFlag() != null) {
			useAppr = destBoardProp.getApprFlag();
		}
		
		itemIDArray = new LinkedHashSet<String>(Arrays.asList(itemIDArray)).toArray(new String[0]);
		
		for (int i = 0; i < itemIDArray.length; i++) {
			String orgItemID = itemIDArray[i];
			
			destItemID = "{" + UUID.randomUUID() + "}";
			
			BoardListVO boardListVO = getCopyItem(orgItemID, userInfo.getTenantId());
			//게시판아이디는 itemID로 가져오자
			orgBoardID = boardListVO.getBoardID();
			
			boolean hwpFile = false;
			if (boardListVO.getContentLocation().indexOf(".hwp") > -1) {
				hwpFile = true;
			}
			
			//MHT 파일위치 변경
			boardListVO.setContentLocation(boardListVO.getContentLocation().replace(orgBoardID, destBoardID).replace(orgItemID, destItemID));
			boardListVO.setStartDate("");
			boardListVO.setItemLevel("1");
			
			if (boardListVO.getExtensionAttribute1() == null) {
				boardListVO.setExtensionAttribute1("0");
			}
			
			if (boardListVO.getExtensionAttribute2() == null) {
				boardListVO.setExtensionAttribute2("0");
			}
			
			if (boardListVO.getExtensionAttribute3() == null) {
				boardListVO.setExtensionAttribute3("0");
			}
			
			if (boardListVO.getExtensionAttribute32() == null) {
				boardListVO.setExtensionAttribute32("0");
			}
			
			if (boardListVO.getExtensionAttribute4() == null) {
				boardListVO.setExtensionAttribute4("0");
			}
			
			if (boardListVO.getExtensionAttribute5() == null) {
				boardListVO.setExtensionAttribute5("0");
			}
			
			if (boardListVO.getDocPassword() == null) { // 익명게시물 이동 시 비밀번호
				boardListVO.setDocPassword("");
			}
			
			/* 2021-06-02 홍승비 - 파일 이동 시 move가 아닌 copy로 변경, 모든 DB 데이터 변경작업이 정상적으로 끝난 이후 한꺼번에 기존 위치의 MHT파일을 삭제하도록 수정 */
			copyFiles(orgItemID, orgBoardID, destItemID, destBoardID, realPath + uploadFilePath, "copy", hwpFile);
			if (hwpFile) {
				deleteMHTStr.add(realPath + uploadFilePath + commonUtil.separator + orgBoardID + commonUtil.separator + "doc" + commonUtil.separator + orgItemID + ".hwp");
			} else {
				deleteMHTStr.add(realPath + uploadFilePath + commonUtil.separator + orgBoardID + commonUtil.separator + "doc" + commonUtil.separator + orgItemID + ".mht");
			}
			
			List<String> attachmentList = getCopyItemAttach(orgItemID, userInfo.getTenantId());
			
			String attachments = "";
			String realFileNames = "";
			/* 2021-06-02 홍승비 - 파일 이동 시 move가 아닌 copy로 변경, 모든 DB 데이터 변경작업이 정상적으로 끝난 이후 한꺼번에 기존 위치의 첨부파일을 삭제하도록 수정 */
			if (attachmentList != null) {
				attachments = copyAttachments(orgBoardID, destItemID, destBoardID, attachmentList, realPath + uploadFilePath, "copy", userInfo.getTenantId());
				Map<String, Object> realFileNameMap = new HashMap<String, Object>();
					realFileNameMap.put("itemID", orgItemID);
					realFileNameMap.put("tenant_id", userInfo.getTenantId());
				realFileNames = ezBoardDAO.getRealFileNames(realFileNameMap);

				deleteAttachStr.addAll(attachmentList);
			}
			
			//2018-05-09 강민수92 댓글도 이동
			moveOneLineReply(orgBoardID, orgItemID, destBoardID, destItemID); 
			
			List<BoardKeywordVO> keywordList = selectBoardKeywordByBoardItem(orgItemID, orgBoardID, userInfo.getTenantId());
			
			StringBuilder sb = new StringBuilder();

	        sb.append("<NODES>");
	        sb.append("<NODE>");
	        sb.append("<FILEPATH>" + uploadFilePath + "</FILEPATH>");
	        sb.append("<ITEMID>" + destItemID + "</ITEMID>");
	        sb.append("<BOARDID>" + destBoardID + "</BOARDID>");
	        sb.append("<TOPWRITERID>" + boardListVO.getTopWriterID() + "</TOPWRITERID>");
	        sb.append("<WRITERID>" + boardListVO.getWriterID() + "</WRITERID>");
	        sb.append("<WRITERNAME>" + commonUtil.cleanValue(boardListVO.getWriterName()) + "</WRITERNAME>");
	        sb.append("<WRITERNAME2>" + commonUtil.cleanValue(boardListVO.getWriterName2()) + "</WRITERNAME2>");
	        sb.append("<DEPTID>" + boardListVO.getWriterDeptID() + "</DEPTID>");
	        sb.append("<DEPTNAME>" + commonUtil.cleanValue(boardListVO.getWriterDeptName()) + "</DEPTNAME>");	
	        sb.append("<DEPTNAME2>" + commonUtil.cleanValue(boardListVO.getWriterDeptName2()) + "</DEPTNAME2>");
	        sb.append("<COMPANYID>" + boardListVO.getWriterCompanyID() + "</COMPANYID>");
	        sb.append("<COMPANYNAME>" + commonUtil.cleanValue(boardListVO.getWriterCompanyName()) + "</COMPANYNAME>");	
	        sb.append("<COMPANYNAME2>" + commonUtil.cleanValue(boardListVO.getWriterCompanyName2()) + "</COMPANYNAME2>");
	        sb.append("<IMPORTANCE>" + boardListVO.getImportance() + "</IMPORTANCE>");
	        sb.append("<TITLE>" + commonUtil.cleanValue(boardListVO.getTitle()) + "</TITLE>");
	        sb.append("<CONTENTLOCATION>" + boardListVO.getContentLocation() + "</CONTENTLOCATION>");
	        sb.append("<STARTDATE>" + commonUtil.getDateStringInUTC(boardListVO.getStartDate(), userInfo.getOffset(), false) + "</STARTDATE>");
	        sb.append("<ENDDATE>" + commonUtil.getDateStringInUTC(boardListVO.getEndDate(), userInfo.getOffset(), false) + "</ENDDATE>");
	        sb.append("<ABSTRACT>" + commonUtil.cleanValue(boardListVO.getABSTRACT()) + "</ABSTRACT>");
	        sb.append("<ATTACHMENTS>" + commonUtil.cleanValue(attachments) + "</ATTACHMENTS>");
	        sb.append("<UPPERITEMIDTREE>" + destItemID + "</UPPERITEMIDTREE>");
	        sb.append("<ITEMLEVEL>1</ITEMLEVEL>");
	        sb.append("<EXTENSIONATTRIBUTE1>" + commonUtil.cleanValue(boardListVO.getExtensionAttribute1()) + "</EXTENSIONATTRIBUTE1>");
	        sb.append("<EXTENSIONATTRIBUTE2>" + commonUtil.cleanValue(boardListVO.getExtensionAttribute2()) + "</EXTENSIONATTRIBUTE2>");
	        sb.append("<EXTENSIONATTRIBUTE3>" + commonUtil.cleanValue(boardListVO.getExtensionAttribute3()) + "</EXTENSIONATTRIBUTE3>");
	        sb.append("<EXTENSIONATTRIBUTE32>" + commonUtil.cleanValue(boardListVO.getExtensionAttribute32()) + "</EXTENSIONATTRIBUTE32>");
	        sb.append("<EXTENSIONATTRIBUTE4>" + commonUtil.cleanValue(boardListVO.getExtensionAttribute4()) + "</EXTENSIONATTRIBUTE4>");
	        sb.append("<EXTENSIONATTRIBUTE5>" + commonUtil.cleanValue(boardListVO.getExtensionAttribute5()) + "</EXTENSIONATTRIBUTE5>");
	        /* 2020-02-11 홍승비 - 게시물 이동 시 비밀번호값도 이동하도록 수정 */
	        sb.append("<DOCPASSWORD>" + boardListVO.getDocPassword() + "</DOCPASSWORD>");
	        sb.append("<READCOUNTFLAG>N</READCOUNTFLAG>");
	        sb.append("<GUBUN>M</GUBUN>");
	        sb.append("<DOCCONTENT>" + commonUtil.cleanValue(boardListVO.getContent()) + "</DOCCONTENT>");
	        
	        if (useAppr.equals("Y")) {
	        	sb.append("<APPRFLAG>N</APPRFLAG>");
	        }
	        /* 2019-12-13 홍승비 - 게시물 이동 시 조회수, 조회자정보 유지 */
	        sb.append("<READCOUNT>" + boardListVO.getReadCount() + "</READCOUNT>");
			
			/* 2024-02-19 민지수 - 게시물 이동 시 공지사항 등록기간 유지 */
			sb.append("<NTSTARTDATE>" + boardListVO.getNotiStart() + "</NTSTARTDATE>");
			sb.append("<NTENDDATE>" + boardListVO.getNotiEnd() + "</NTENDDATE>");

			/* 2024-09-03 전인하 - 게시판 > 이동 > 키워드 정보 함께 이동 */
			if (keywordList != null && keywordList.size() > 0 && destBoardProp.getUseKeyword() != null && destBoardProp.getUseKeyword().equals("Y")) {
				sb.append("<KEYWORDS>");
				for (BoardKeywordVO keyword : keywordList) {
					sb.append("<KEYWORD>" + keyword.getKeywordName() + "</KEYWORD>");
				}
				sb.append("</KEYWORDS>");
			}

			sb.append("<REALFILENAMES>" + commonUtil.cleanValue(realFileNames) + "</REALFILENAMES>");
	        sb.append("</NODE>");
	        sb.append("</NODES>");

	        result = insertNewItem(commonUtil.convertStringToDocument(sb.toString()), "move", realPath, userInfo);
	        
	        if (result.equals("OK")) {
	        	updateMoveItem(destItemID, orgItemID, destBoardID, orgBoardID, userInfo.getTenantId());
				updateMovedItemCommentAttach(orgItemID, destItemID, userInfo.getTenantId());
	        	destItemIDStr.append(destItemID).append(";");
	        	resultStr.append(result).append("|");
	        }
		}
		
		if (result.equals("OK")) {
			// 기존의 MHT파일 삭제
			for (String deleteStr : deleteMHTStr) { // 실제 파일경로를 그대로 사용, 치환 없이 접근 가능
				FileUtils.deleteQuietly(new File(deleteStr));
			}
			// 기존의 첨부파일 삭제
			for (String deleteAttachStrlog : deleteAttachStr) { // realPath + uploadFilePath + commonUtil.separator 치환 진행
				FileUtils.deleteQuietly(new File((realPath + uploadFilePath).replace(commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId()), "") + deleteAttachStrlog));
			}
		}

		logger.debug("moveItem ended");
		return destItemIDStr.toString() + resultStr.toString();
	}

	public String copyAttachments(String orgBoardID, String destItemID, String destBoardID, List<String> attachmentList, String path, String mode, int tenantID) throws Exception {
		logger.debug("copyAttachments started");

		String orgFilePath = "";
		String destFilePath = "";
		String returnString = "";
		
		for (int i = 0; i < attachmentList.size(); i++) {
			orgFilePath = attachmentList.get(i);
			orgFilePath = path.replace(commonUtil.getUploadPath("upload_board.ROOT", tenantID), "") + orgFilePath;

			// 확장자 추출 
			int lastDotIndex = orgFilePath.lastIndexOf('.');
			String fileExt = orgFilePath.substring(lastDotIndex);
			String fileName = UUID.randomUUID() + fileExt;
			
			destFilePath = path + commonUtil.separator + destBoardID + commonUtil.separator + "uploadFile" + commonUtil.separator + fileName;
			
			if (returnString.equals("")) {
				returnString += destBoardID + commonUtil.separator + "uploadFile" + commonUtil.separator + fileName;
			} else {
				returnString = returnString + "|" + destBoardID + commonUtil.separator + "uploadFile" + commonUtil.separator + fileName;
			}
			//move 이면 지우고 옮기기
			if (mode.equals("copy")) {
				FileUtils.copyFile(new File(commonUtil.detectPathTraversal(orgFilePath)), new File(commonUtil.detectPathTraversal(destFilePath)));
			} else {
				FileUtils.moveFile(new File(commonUtil.detectPathTraversal(orgFilePath)), new File(commonUtil.detectPathTraversal(destFilePath)));
			}
		}

		logger.debug("copyAttachments ended");
        return returnString;
	}
	
	public String insertNewItem(Document doc, String pMode, String realPath, LoginVO userInfo) throws Exception {
		logger.debug("insertNewItem started");
		//logger.debug("pMode : " + pMode);

		BoardListVO boardListVO = new BoardListVO();
		
		String editor = ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId());
		
		boolean saveResult = false;
		boardListVO.setFilePath(commonUtil.detectPathTraversal(doc.getElementsByTagName("FILEPATH").item(0).getTextContent()));
		boardListVO.setItemID(commonUtil.detectPathTraversal(doc.getElementsByTagName("ITEMID").item(0).getTextContent()));
		boardListVO.setBoardID(doc.getElementsByTagName("BOARDID").item(0).getTextContent());
		boardListVO.setWriterID(doc.getElementsByTagName("WRITERID").item(0).getTextContent());
		boardListVO.setTopWriterID(doc.getElementsByTagName("TOPWRITERID").item(0).getTextContent());
		boardListVO.setWriterName(doc.getElementsByTagName("WRITERNAME").item(0).getTextContent());
		boardListVO.setWriterName2(doc.getElementsByTagName("WRITERNAME2").item(0).getTextContent());
		boardListVO.setWriterDeptID(doc.getElementsByTagName("DEPTID").item(0).getTextContent());
		boardListVO.setWriterDeptName(doc.getElementsByTagName("DEPTNAME").item(0).getTextContent());
		boardListVO.setWriterDeptName2(doc.getElementsByTagName("DEPTNAME2").item(0).getTextContent());
		boardListVO.setWriterCompanyID(doc.getElementsByTagName("COMPANYID").item(0).getTextContent());
		boardListVO.setWriterCompanyName(doc.getElementsByTagName("COMPANYNAME").item(0).getTextContent());
		boardListVO.setWriterCompanyName2(doc.getElementsByTagName("COMPANYNAME2").item(0).getTextContent());
		
		if (null != doc.getElementsByTagName("WRITERNAMETYPE").item(0) && null != doc.getElementsByTagName("WRITERNAMETYPE").item(0).getTextContent()) {
			boardListVO.setWriterNameType(doc.getElementsByTagName("WRITERNAMETYPE").item(0).getTextContent());
		} else {
			boardListVO.setWriterNameType("");
		}
		
		boardListVO.setWriteDate(commonUtil.getTodayUTCTime(""));
		boardListVO.setImportance(doc.getElementsByTagName("IMPORTANCE").item(0).getTextContent());
		boardListVO.setTitle(doc.getElementsByTagName("TITLE").item(0).getTextContent());
		if (doc.getElementsByTagName("PUBLICFLAG").getLength() > 0 ) {
			boardListVO.setPublicFlag(doc.getElementsByTagName("PUBLICFLAG").item(0).getTextContent());
		}
		boardListVO.setRealPath(realPath);
		boardListVO.setTenantID(userInfo.getTenantId());
		
		if (doc.getElementsByTagName("DOCCONTENT").item(0) != null) {
			boardListVO.setContent(commonUtil.htmlUnescape(doc.getElementsByTagName("DOCCONTENT").item(0).getTextContent()));
		}

		if (!editor.equals("HWP")) {
			if (pMode.equals("copy") || pMode.equals("move")) {
				boardListVO.setContentLocation(doc.getElementsByTagName("CONTENTLOCATION").item(0).getTextContent());
			} else {
				boardListVO.setContentLocation(commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId()) + commonUtil.separator + boardListVO.getBoardID() + commonUtil.separator + "doc" + commonUtil.separator + boardListVO.getItemID() + ".mht");
			}
		} else {
			if (pMode.equals("copy") || pMode.equals("move")) {
				boardListVO.setContentLocation(doc.getElementsByTagName("CONTENTLOCATION").item(0).getTextContent());
			} else {
				boardListVO.setContentLocation(commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId()) + commonUtil.separator + boardListVO.getBoardID() + commonUtil.separator + "doc" + commonUtil.separator + boardListVO.getItemID() + ".hwp");
			}
		}
		
		/* 2020-03-19 홍승비 - 예약게시물 수정 시 WRITEDATE, STARTDATE 업데이트 추가 */
		if (doc.getElementsByTagName("STARTDATE").item(0).getTextContent() != null && !doc.getElementsByTagName("STARTDATE").item(0).getTextContent().equals("")) {
			boardListVO.setStartDate(commonUtil.getDateStringInUTC(doc.getElementsByTagName("STARTDATE").item(0).getTextContent(), userInfo.getOffset(), true));
			boardListVO.setWriteDate(commonUtil.getDateStringInUTC(doc.getElementsByTagName("STARTDATE").item(0).getTextContent(), userInfo.getOffset(), true));
			boardListVO.setIsReserved("true");
		} else {
			boardListVO.setStartDate(commonUtil.getTodayUTCTime(""));
			boardListVO.setIsReserved("false");
		}
		
		// 기존의 예약게시물 > 수정 > 예약게시를 아예 취소한 경우
		if (doc.getElementsByTagName("RSVCANCEL").item(0) != null && doc.getElementsByTagName("RSVCANCEL").item(0).getTextContent().equals("true")) {
			boardListVO.setStartDate(commonUtil.getTodayUTCTime(""));
			boardListVO.setWriteDate(commonUtil.getTodayUTCTime(""));
			boardListVO.setIsReserved("true"); // STARTDATE를 업데이트 하기 위한 처리
		}
		
		boardListVO.setEndDate(commonUtil.getDateStringInUTC(doc.getElementsByTagName("ENDDATE").item(0).getTextContent(), userInfo.getOffset(), true));
		boardListVO.setABSTRACT(doc.getElementsByTagName("ABSTRACT").item(0).getTextContent());
		boardListVO.setAttachments(doc.getElementsByTagName("ATTACHMENTS").item(0).getTextContent());
		boardListVO.setUpperItemIDTree(doc.getElementsByTagName("UPPERITEMIDTREE").item(0).getTextContent());
		
		//답변의 경우 최근에 답변 달은 것이 최상위로 와야함(by design)
		if (pMode.equals("reply")) {
			boardListVO.setUpperItemIDTree(boardListVO.getUpperItemIDTree() + getReverseDateNow() + boardListVO.getItemID());
		}
		
		boardListVO.setItemLevel(doc.getElementsByTagName("ITEMLEVEL").item(0).getTextContent());
		
		if (!pMode.equals("copy") && !pMode.equals("move")) {
			boardListVO.setMainContent(commonUtil.stripScriptTags(doc.getElementsByTagName("CONTENT").item(0).getTextContent().replace("@r!n@", "\r\n")));

			if (pMode.equals("reply") || pMode.equals("modify")) {
				boardListVO.setParentWriteDate(doc.getElementsByTagName("PARENTWRITEDATE").item(0).getTextContent());
			} else {
				boardListVO.setParentWriteDate("docNO");
			}
		} else {
			boardListVO.setParentWriteDate("docNO");
		}
		
		if (doc.getElementsByTagName("EXTENSIONATTRIBUTE1").item(0).getTextContent() == null || doc.getElementsByTagName("EXTENSIONATTRIBUTE1").item(0).getTextContent().equals("")) {
			boardListVO.setExtensionAttribute1("0");
		} else {
			boardListVO.setExtensionAttribute1(doc.getElementsByTagName("EXTENSIONATTRIBUTE1").item(0).getTextContent());
		}
		
		if (doc.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent() == null || doc.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent().equals("")) {
			boardListVO.setExtensionAttribute2("0");
		} else {
			boardListVO.setExtensionAttribute2(doc.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent());
		}
		
		boardListVO.setExtensionAttribute3(doc.getElementsByTagName("EXTENSIONATTRIBUTE3").item(0).getTextContent());
		boardListVO.setExtensionAttribute32(doc.getElementsByTagName("EXTENSIONATTRIBUTE32").item(0).getTextContent());
		boardListVO.setExtensionAttribute4(doc.getElementsByTagName("EXTENSIONATTRIBUTE4").item(0).getTextContent());
		boardListVO.setExtensionAttribute5(doc.getElementsByTagName("EXTENSIONATTRIBUTE5").item(0).getTextContent());
		boardListVO.setDocPassword(doc.getElementsByTagName("DOCPASSWORD").item(0).getTextContent());
		boardListVO.setReadFlag(doc.getElementsByTagName("READCOUNTFLAG").item(0).getTextContent());
		
		if (doc.getElementsByTagName("EXTENSIONATTRIBUTE6").item(0) != null) {
			boardListVO.setExtensionAttribute6(commonUtil.stripScriptTags(commonUtil.htmlUnescape(doc.getElementsByTagName("EXTENSIONATTRIBUTE6").item(0).getTextContent())));
		} else {
			boardListVO.setExtensionAttribute6("");
		}
		
		if (doc.getElementsByTagName("EXTENSIONATTRIBUTE7").item(0) != null) {
			boardListVO.setExtensionAttribute7(commonUtil.stripScriptTags(commonUtil.htmlUnescape(doc.getElementsByTagName("EXTENSIONATTRIBUTE7").item(0).getTextContent())));
		} else {
			boardListVO.setExtensionAttribute7("");
		}
		
		if (doc.getElementsByTagName("EXTENSIONATTRIBUTE8").item(0) != null) {
			boardListVO.setExtensionAttribute8(commonUtil.stripScriptTags(commonUtil.htmlUnescape(doc.getElementsByTagName("EXTENSIONATTRIBUTE8").item(0).getTextContent())));
		} else {
			boardListVO.setExtensionAttribute8("");
		}
		
		if (doc.getElementsByTagName("EXTENSIONATTRIBUTE9").item(0) != null) {
			boardListVO.setExtensionAttribute9(commonUtil.stripScriptTags(commonUtil.htmlUnescape(doc.getElementsByTagName("EXTENSIONATTRIBUTE9").item(0).getTextContent())));
		} else {
			boardListVO.setExtensionAttribute9("");
		}
		
		if (doc.getElementsByTagName("EXTENSIONATTRIBUTE10").item(0) != null) {
			boardListVO.setExtensionAttribute10(commonUtil.stripScriptTags(commonUtil.htmlUnescape(doc.getElementsByTagName("EXTENSIONATTRIBUTE10").item(0).getTextContent())));
		} else {
			boardListVO.setExtensionAttribute10("");
		}
		
		if (!editor.equals("HWP")) {
			if (!pMode.equals("copy") && !pMode.equals("move")) {
				saveResult = saveMHT(boardListVO.getMainContent(), boardListVO.getItemID(), boardListVO.getBoardID(), boardListVO.getFilePath(), "BOARD", realPath);
				if (saveResult == false) {
					return egovMessageSource.getMessage("ezCommunity.lhj04", userInfo.getLocale());
				}
			}
		} else {
			if (!pMode.equals("copy") && !pMode.equals("move")) {
				saveResult = saveHWP(boardListVO.getMainContent(), boardListVO.getItemID(), boardListVO.getBoardID(), boardListVO.getFilePath(), "BOARD", realPath);
				if (saveResult == false) {
					return egovMessageSource.getMessage("ezBoard.kwc01", userInfo.getLocale());
				}
			}
		}
		
		if (boardListVO.getAttachments() != null && !boardListVO.getAttachments().equals("")) {
			boardListVO.setHasAttach("1");
		} else {
			boardListVO.setHasAttach("0");
		}
		
		if (boardListVO.getItemLevel() == null || boardListVO.getItemLevel().equals("")) {
			boardListVO.setItemLevel("0");
		}
		//구분 추가
		boardListVO.setGuBun(doc.getElementsByTagName("GUBUN").item(0).getTextContent());
		
		/* 2019-12-17 홍승비 - 게시물 복사/이동 시 테넌트 컨피그에 따라 조회수 유지 */
		String isReadCountCopyUsed = ezCommonService.getTenantConfig("copyReadCountBoardItem", userInfo.getTenantId());
		if ((pMode.equals("copy") && StringUtils.isNotBlank(isReadCountCopyUsed) && ("COPY".equals(isReadCountCopyUsed) || "ALL".equals(isReadCountCopyUsed))) ||
				(pMode.equals("move") && StringUtils.isNotBlank(isReadCountCopyUsed) && ("MOVE".equals(isReadCountCopyUsed) || "ALL".equals(isReadCountCopyUsed)))) {
			boardListVO.setReadCount(Integer.valueOf(doc.getElementsByTagName("READCOUNT").item(0).getTextContent()));
		} else { // READCOUNT값은 기본적으로 0으로 삽입된다.
			boardListVO.setReadCount(0);
		}

		/* 2023-11-16 홍승비 - 게시물 복사 및 이동 시 공지사항 기간설정값을 가져오지 않는 오류 null 체크 부분 수정 (쿼리단 미수정, 차후 수정 필요) */
		/* 2023-09-25 민지수 - 게시판 > 공지사항 > 공지 시작, 종료일 추가 */
		if (doc.getElementsByTagName("NTSTARTDATE").item(0) != null && doc.getElementsByTagName("NTSTARTDATE").item(0).getTextContent() != null && !doc.getElementsByTagName("NTSTARTDATE").item(0).getTextContent().equals("")) {
			if (pMode.equals("copy") || pMode.equals("move")) {
				boardListVO.setNotiStart(doc.getElementsByTagName("NTSTARTDATE").item(0).getTextContent());
			} else {
				boardListVO.setNotiStart(commonUtil.getDateStringInUTC(doc.getElementsByTagName("NTSTARTDATE").item(0).getTextContent(), userInfo.getOffset(), true));
			}
		}

		if (doc.getElementsByTagName("NTENDDATE").item(0) != null && doc.getElementsByTagName("NTENDDATE").item(0).getTextContent() != null && !doc.getElementsByTagName("NTENDDATE").item(0).getTextContent().equals("")) {
			if (pMode.equals("copy") || pMode.equals("move")) {
				boardListVO.setNotiEnd(doc.getElementsByTagName("NTENDDATE").item(0).getTextContent());
			} else {
				boardListVO.setNotiEnd(commonUtil.getDateStringInUTC(doc.getElementsByTagName("NTENDDATE").item(0).getTextContent(), userInfo.getOffset(), true));
			}
		}
		
		if (pMode.equals("modify")) {
			if (boardListVO.getGuBun().equals("2")) {
				boardListVO.setupdaterID(null);
			} else {
				boardListVO.setupdaterID(userInfo.getId());
			}
			brdUpdateItem(boardListVO, "BOARD");
		} else if (pMode.equals("temp")) {
			brdNewItemTemp(boardListVO);
		} else {
			brdNewItem(boardListVO);
		}
		
		if (boardListVO.getAttachments() != null && !boardListVO.getAttachments().equals("")) {
			String realFileNames = commonUtil.detectPathTraversal(doc.getElementsByTagName("REALFILENAMES").item(0).getTextContent());
			if (!saveAttachmentsInfo(boardListVO.getAttachments(), boardListVO.getItemID(), boardListVO.getBoardID(), boardListVO.getFilePath(), "BOARD", realPath, userInfo.getTenantId(), realFileNames)) {
				return egovMessageSource.getMessage("ezCommunity.lhj05", userInfo.getLocale());
			}
			
			boardListVO.setHasAttach("1");
		} else {
			boardListVO.setHasAttach("0");
		}

		// 키워드 저장
		List<String> keywords = new ArrayList<>();
		NodeList keywordNodeList = doc.getElementsByTagName("KEYWORD");
		if (keywordNodeList != null && keywordNodeList.getLength() > 0) {
			for (int i = 0; i < keywordNodeList.getLength(); i++) {
				keywords.add(keywordNodeList.item(i).getTextContent());
			}
		}
		
		if (keywords.size() > 0) {
			saveKeyword(keywords, boardListVO.getBoardID(), boardListVO.getItemID(), userInfo.getTenantId());
		}
		
		logger.debug("insertNewItem ended");
		return "OK";
	}
	
	public void copyFiles(String orgItemID, String orgBoardID, String destItemID, String destBoardID, String path, String mode, boolean hwpFile) throws Exception {
		logger.debug("copyFiles started");

		String orgFilePath = "";
		String destFilePath = "";
		
		if (hwpFile) {
			orgFilePath = path + commonUtil.separator + commonUtil.detectPathTraversal(orgBoardID) + commonUtil.separator + "doc" + commonUtil.separator + commonUtil.detectPathTraversal(orgItemID) + ".hwp";
			destFilePath = path + commonUtil.separator + commonUtil.detectPathTraversal(destBoardID) + commonUtil.separator + "doc" + commonUtil.separator + commonUtil.detectPathTraversal(destItemID) + ".hwp";
		} else {
			orgFilePath = path + commonUtil.separator + commonUtil.detectPathTraversal(orgBoardID) + commonUtil.separator + "doc" + commonUtil.separator + commonUtil.detectPathTraversal(orgItemID) + ".mht";
			destFilePath = path + commonUtil.separator + commonUtil.detectPathTraversal(destBoardID) + commonUtil.separator + "doc" + commonUtil.separator + commonUtil.detectPathTraversal(destItemID) + ".mht";
		}
		
		File file = new File(path + commonUtil.separator + commonUtil.detectPathTraversal(destBoardID));
		
		if (!file.exists()) {
			file.mkdirs();
			new File(path + commonUtil.separator + commonUtil.detectPathTraversal(destBoardID) + commonUtil.separator + "doc").mkdirs();
			new File(path + commonUtil.separator + commonUtil.detectPathTraversal(destBoardID) + commonUtil.separator + "uploadFile").mkdirs();
		}
		
		//move 이면 지우고 옮기기
		if (mode.equals("copy")) {
			FileUtils.copyFile(new File(orgFilePath), new File(destFilePath));
		} else {
			FileUtils.moveFile(new File(orgFilePath), new File(destFilePath));
		}

		logger.debug("copyFiles ended");
	}

	/* 2019-07-02 홍승비 - 게시물 복사 후 복사한 게시물의 ItemID를 문자열로 리턴하도록 수정 */
	@Override
	public String copyItem(String orgItemIDList, String orgBoardIDList, String destBoardID, String uploadFilePath, String realPath, LoginVO userInfo) throws Exception {
		logger.debug("copyItem started");

		String result = "";
		String destItemID = "";
		String orgBoardID = "";
		String[] itemIDArray = orgItemIDList.split(";");
		String useAppr = "N";
		StringBuilder destItemIDStr = new StringBuilder();
		StringBuilder resultStr = new StringBuilder();
		
		// 목표 게시판이 승인을 사용하는지 체크
		BoardPropertyVO destBoardProp = getBoardProperty(destBoardID, userInfo.getTenantId());
		if (destBoardProp != null && destBoardProp.getApprFlag() != null) {
			useAppr = destBoardProp.getApprFlag();
		}
		
		itemIDArray = new LinkedHashSet<String>(Arrays.asList(itemIDArray)).toArray(new String[0]);

		for (int i = 0; i < itemIDArray.length; i++) {
			String orgItemID = itemIDArray[i];
			
			destItemID = "{" + UUID.randomUUID() + "}";

			BoardListVO boardLisitVO = getCopyItem(orgItemID, userInfo.getTenantId());
			
			orgBoardID = boardLisitVO.getBoardID();
			
			boolean hwpFile = false;
			if (boardLisitVO.getContentLocation().indexOf(".hwp") > -1) {
				hwpFile = true;
			}
			
			//MHT 파일위치 변경
			boardLisitVO.setContentLocation(boardLisitVO.getContentLocation().replace(orgBoardID, destBoardID).replace(orgItemID, destItemID));
			boardLisitVO.setStartDate("");
			boardLisitVO.setItemLevel("1");
			
			if (boardLisitVO.getExtensionAttribute1() == null) {
				boardLisitVO.setExtensionAttribute1("0");
			}
			
			if (boardLisitVO.getExtensionAttribute2() == null) {
				boardLisitVO.setExtensionAttribute2("0");
			}
			
			if (boardLisitVO.getExtensionAttribute3() == null) {
				boardLisitVO.setExtensionAttribute3("0");
			}
			
			if (boardLisitVO.getExtensionAttribute32() == null) {
				boardLisitVO.setExtensionAttribute32("0");
			}
			
			if (boardLisitVO.getExtensionAttribute4() == null) {
				boardLisitVO.setExtensionAttribute4("0");
			}
			
			if (boardLisitVO.getExtensionAttribute5() == null) {
				boardLisitVO.setExtensionAttribute5("0");
			}
			
			if (boardLisitVO.getDocPassword() == null) { // 익명게시물 복사 시 비밀번호
				boardLisitVO.setDocPassword("");
			}
			
			copyFiles(orgItemID, orgBoardID, destItemID, destBoardID, realPath + uploadFilePath, "copy", hwpFile);
			
			List<String> attachmentList = getCopyItemAttach(orgItemID, userInfo.getTenantId());
			String attachments = "";
			String realFileNames = "";
			if (attachmentList != null) {
				attachments = copyAttachments(orgBoardID, destItemID, destBoardID, attachmentList, realPath + uploadFilePath, "copy", userInfo.getTenantId());
				Map<String, Object> realFileNameMap = new HashMap<String, Object>();
					realFileNameMap.put("itemID", orgItemID);
					realFileNameMap.put("tenant_id", userInfo.getTenantId());
				realFileNames = ezBoardDAO.getRealFileNames(realFileNameMap);
			}
			
			List<BoardKeywordVO> keywordList = selectBoardKeywordByBoardItem(orgItemID, orgBoardID, userInfo.getTenantId());
			
			StringBuilder sb = new StringBuilder();

	        sb.append("<NODES>");
	        sb.append("<NODE>");
	        sb.append("<FILEPATH>" + uploadFilePath + "</FILEPATH>");
	        sb.append("<ITEMID>" + destItemID + "</ITEMID>");
	        sb.append("<BOARDID>" + destBoardID + "</BOARDID>");
	        sb.append("<TOPWRITERID>" + boardLisitVO.getTopWriterID() + "</TOPWRITERID>");
	        sb.append("<WRITERID>" + boardLisitVO.getWriterID() + "</WRITERID>");
	        sb.append("<WRITERNAME>" + commonUtil.cleanValue(boardLisitVO.getWriterName()) + "</WRITERNAME>");
	        sb.append("<WRITERNAME2>" + commonUtil.cleanValue(boardLisitVO.getWriterName2()) + "</WRITERNAME2>");
	        sb.append("<DEPTID>" + boardLisitVO.getWriterDeptID() + "</DEPTID>");
	        sb.append("<DEPTNAME>" + commonUtil.cleanValue(boardLisitVO.getWriterDeptName()) + "</DEPTNAME>");	
	        sb.append("<DEPTNAME2>" + commonUtil.cleanValue(boardLisitVO.getWriterDeptName2()) + "</DEPTNAME2>");
	        sb.append("<COMPANYID>" + boardLisitVO.getWriterCompanyID() + "</COMPANYID>");
	        sb.append("<COMPANYNAME>" + commonUtil.cleanValue(boardLisitVO.getWriterCompanyName()) + "</COMPANYNAME>");
	        sb.append("<COMPANYNAME2>" + commonUtil.cleanValue(boardLisitVO.getWriterCompanyName2()) + "</COMPANYNAME2>");
	        sb.append("<IMPORTANCE>" + boardLisitVO.getImportance() + "</IMPORTANCE>");
	        sb.append("<TITLE>" + commonUtil.cleanValue(boardLisitVO.getTitle()) + "</TITLE>");
	        sb.append("<CONTENTLOCATION>" + boardLisitVO.getContentLocation() + "</CONTENTLOCATION>");
	        sb.append("<STARTDATE>" + commonUtil.getDateStringInUTC(boardLisitVO.getStartDate(), userInfo.getOffset(), false) + "</STARTDATE>");
	        sb.append("<ENDDATE>" + commonUtil.getDateStringInUTC(boardLisitVO.getEndDate(), userInfo.getOffset(), false) + "</ENDDATE>");
	        sb.append("<ABSTRACT>" + commonUtil.cleanValue(boardLisitVO.getABSTRACT()) + "</ABSTRACT>");
	        sb.append("<ATTACHMENTS>" + commonUtil.cleanValue(attachments) + "</ATTACHMENTS>");
	        sb.append("<UPPERITEMIDTREE>" + destItemID + "</UPPERITEMIDTREE>");
	        sb.append("<ITEMLEVEL>1</ITEMLEVEL>");
	        sb.append("<EXTENSIONATTRIBUTE1>" + commonUtil.cleanValue(boardLisitVO.getExtensionAttribute1()) + "</EXTENSIONATTRIBUTE1>");
	        sb.append("<EXTENSIONATTRIBUTE2>" + commonUtil.cleanValue(boardLisitVO.getExtensionAttribute2()) + "</EXTENSIONATTRIBUTE2>");
	        sb.append("<EXTENSIONATTRIBUTE3>" + commonUtil.cleanValue(boardLisitVO.getExtensionAttribute3()) + "</EXTENSIONATTRIBUTE3>");
	        sb.append("<EXTENSIONATTRIBUTE32>" + commonUtil.cleanValue(boardLisitVO.getExtensionAttribute32()) + "</EXTENSIONATTRIBUTE32>");
	        sb.append("<EXTENSIONATTRIBUTE4>" + commonUtil.cleanValue(boardLisitVO.getExtensionAttribute4()) + "</EXTENSIONATTRIBUTE4>");
	        sb.append("<EXTENSIONATTRIBUTE5>" + commonUtil.cleanValue(boardLisitVO.getExtensionAttribute5()) + "</EXTENSIONATTRIBUTE5>");
	        sb.append("<DOCCONTENT>" + commonUtil.cleanValue(boardLisitVO.getContent()) + "</DOCCONTENT>");
	        /* 2020-02-11 홍승비 - 게시물 복사 시 비밀번호값도 복사하도록 수정 */
	        sb.append("<DOCPASSWORD>" + boardLisitVO.getDocPassword() + "</DOCPASSWORD>");
	        sb.append("<READCOUNTFLAG>N</READCOUNTFLAG>");
	        sb.append("<GUBUN>C</GUBUN>");
	        
	        if (useAppr.equals("Y")) {
	        	sb.append("<APPRFLAG>N</APPRFLAG>");
	        }
	        
	        /* 2019-12-16 홍승비 - 게시물 복사 시 테넌트 컨피그에 따라  조회수, 조회자정보 유지 */
	        sb.append("<READCOUNT>" + boardLisitVO.getReadCount() + "</READCOUNT>");
			/* 2024-02-19 민지수 - 게시물 복사 시 공지사항 등록기간 유지 */
			sb.append("<NTSTARTDATE>" + boardLisitVO.getNotiStart() + "</NTSTARTDATE>");
			sb.append("<NTENDDATE>" + boardLisitVO.getNotiEnd() + "</NTENDDATE>");

			/* 2024-09-03 전인하 - 게시판 > 복사 > 키워드 정보 함께 복사 */
			if (keywordList != null && keywordList.size() > 0 && destBoardProp.getUseKeyword() != null && destBoardProp.getUseKeyword().equals("Y")) {
				sb.append("<KEYWORDS>");
				for (BoardKeywordVO keyword : keywordList) {
					sb.append("<KEYWORD>" + keyword.getKeywordName() + "</KEYWORD>");
				}
				sb.append("</KEYWORDS>");
			}

			sb.append("<REALFILENAMES>" + commonUtil.cleanValue(realFileNames) + "</REALFILENAMES>");
	        sb.append("</NODE>");
	        sb.append("</NODES>");

	        result = insertNewItem(commonUtil.convertStringToDocument(sb.toString()), "copy", realPath, userInfo);
	        
	        if (result.equals("OK")) {
	        	/* 2019-12-16 홍승비 - 조회자정보 저장을 위한 파라미터 추가 */
	        	updateCopyItem(destItemID, orgItemID, destBoardID, orgBoardID, userInfo.getTenantId());
	        	destItemIDStr.append(destItemID).append(";");
	        	resultStr.append(result).append("|");
	        }
		}
		
		logger.debug("copyItem ended");
		return destItemIDStr.toString() + resultStr.toString();
	}

	//baonk added
	@Override
	public BoardPollConfigVO getPollConfig(String pUserID, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("user_id", pUserID);		
		map.put("tenant_id", tenantId);
		
		return ezBoardDAO.getPollConfig(map);
	}	

	@Override
	public void saveBoardPollConfig(BoardPollConfigVO boardPollConfigVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("user_id", boardPollConfigVO.getUserId());		
		map.put("start_time", boardPollConfigVO.getDefaultStartTime());	
		map.put("end_time", boardPollConfigVO.getDefaultEndTime());	
		map.put("target_depts", boardPollConfigVO.getTargetDepts());	
		map.put("target_users", boardPollConfigVO.getTargetUsers());	
		map.put("tenant_id", boardPollConfigVO.getTenantId());
		
		ezBoardDAO.saveBoardPollConfig(map);		
	}	
	//end
	
	//2017.12.29 강민수92
	@Override
	public String getOneLineReplyCount(String boardID, String itemID, int tenantID) throws Exception {
		logger.debug("getOneLineReplyCount started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("boardID", boardID);
		map.put("itemID", itemID);
		map.put("tenantID", tenantID);

		logger.debug("getOneLineReplyCount ended");
		return ezBoardDAO.getOneLineReplyCount(map);
	}

	//2018.02.05 김보미
	@Override
	public int getReaderListCount(String boardID, String itemID, String userID, String lang, int tenantID) throws Exception {
		logger.debug("getReaderListCount started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("boardID", boardID);
		map.put("itemID", itemID);
		map.put("userID", userID);
		map.put("lang", lang);
		map.put("tenantID", tenantID);
		
		logger.debug("getReaderListCount ended");
		return ezBoardDAO.getReaderListCount(map);
	}

	@Override
	public void moveOneLineReply(String orgBoardID, String orgItemID, String destBoardID, String destItemID) throws Exception {
		logger.debug("moveOneLineReply started");
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("orgBoardID", orgBoardID);
		map.put("orgItemID", orgItemID);
		map.put("destBoardID", destBoardID);
		map.put("destItemID", destItemID);
		
		ezBoardDAO.updateMoveOneLineReply(map);
		
		logger.debug("moveOneLineReply ended");
	}

	@Override
	public List<HashMap<String, Object>> getSearchAllBoardItemList(LoginVO userInfo, BoardListVO boardListVO, BoardVO boardVO, ArrayList<String> listviewTrueList, ArrayList<String> qnaItemList, int pMode, Map<String, String> searchMap, Map<String, String> orderByMap, String keywordClick) throws Exception{
		logger.debug("getSearchAllBoardItemList started");

		String orderByCol2 = "";
		String orderByCol2Desc = "N";
		if (orderByMap.get("orderByCol") == null || "".equals(orderByMap.get("orderByCol"))) {
			orderByMap.put("orderByCol", "PARENTWRITEDATE");
			orderByMap.put("orderByColDesc", "Y");
			orderByCol2 = "UPPERITEMIDTREE";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		/* 2018-07-26 홍승비 - 게시판검색 시 게시판명 조건에 lang 추가 */
		map.put("lang", boardVO.getLang());
		map.put("v_PUSERID", boardListVO.getUserID());
		map.put("v_PBOARDID", boardVO.getBoardId());
		map.put("v_PSTARTROW", boardListVO.getStartRow());
		map.put("v_PENDROW", boardListVO.getEndRow());
		map.put("v_PTOTALCOUNT", boardListVO.getTotalCount());
		
		if (orderByMap.get("orderByCol") != null) {
			map.put("iv_PORDERBYCOL1", orderByMap.get("orderByCol"));
			if (orderByMap.get("orderByColDesc") != null) {
				map.put("iv_PORDERBYCOL1DESC", orderByMap.get("orderByColDesc"));
			}
		}
		
		map.put("iv_PORDERBYCOL2", orderByCol2);
		map.put("iv_PORDERBYCOL2DESC", orderByCol2Desc);
		map.put("v_PSUBFLAG", boardVO.getSubFlag());
		map.put("v_TITLE", boardVO.getTitle());
		map.put("v_WRITERNAME", boardVO.getWriterName());
		map.put("v_ABSTRACT", boardVO.getABSTRACT());
		map.put("v_TENANTID", boardVO.getTenantID());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("rowCount", boardListVO.getEndRow() - (boardListVO.getStartRow() - 1));
		map.put("limit", boardListVO.getStartRow() - 1);
		map.put("v_pDeptID", userInfo.getDeptID());
		map.put("v_pCompanyID", userInfo.getCompanyID());
		map.put("v_MODE", pMode); 
		map.put("v_listviewList", listviewTrueList);
		map.put("v_qnaItemList", qnaItemList);
		map.put("v_KEYWORD", boardVO.getKeyword());
		map.put("v_KEYWORDCLICK", keywordClick);
		
		for (String key : searchMap.keySet()) {
			map.put(key, searchMap.get(key));
		}
		
		logger.debug("getSearchAllBoardItemList ended");
		return ezBoardDAO.getSearchAllBoardItemList(map);
	}

	/* 2018-06-11 홍승비 - 포토/썸네일 이미지 리스트 중에서 가장 큰 IMAGEID 가져오기 */
	@Override
	public String getLastImageID(String boardID, String itemID, int tenantID) throws Exception {
		logger.debug("getLastImageID started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pBoardID", boardID);
		map.put("v_pItemID", itemID);
		map.put("v_TENANTID", tenantID);
		
		logger.debug("getLastImageID ended");
		return ezBoardDAO.getLastImageID(map);

	}
	
	/* 2018-07-06 홍승비 - 게시물 전체검색 시 comapanyID 조건 추가 */
	@Override
	public int getSearchAllBoardItemCount(LoginVO userInfo, BoardVO boardVO, ArrayList<String> listviewTrueList, ArrayList<String> qnaItemList, int pMode, Map<String, String> searchMap, String keywordClick) throws Exception {
		logger.debug("getSearchAllBoardItemCount started");

		if (boardVO.getSearchQuery().length() > 0) {
			boardVO.setSearchQuery(" AND " + boardVO.getSearchQuery());
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDID", boardVO.getBoardId());
		map.put("v_PSUBFLAG", boardVO.getSubFlag());
		map.put("v_TENANTID", boardVO.getTenantID());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("v_PUSERID", userInfo.getId());
		map.put("v_pDeptID", userInfo.getDeptID());
		map.put("v_pCompanyID", userInfo.getCompanyID());
		map.put("v_MODE", pMode); 
		map.put("v_listviewList", listviewTrueList);
		map.put("v_qnaItemList", qnaItemList);
		map.put("v_KEYWORD", boardVO.getKeyword());
		map.put("v_KEYWORDCLICK", keywordClick);
		
		// 20240216 : 김진홍 : CSAP 인증 처리 : searchQuery 를 파라미터로 변경
		for (String key : searchMap.keySet()) {
			map.put(key, searchMap.get(key));
		}
		
		logger.debug("getSearchAllBoardItemCount ended");
		return ezBoardDAO.getSearchAllBoardItemCount(map);
	}
	
	/* 2018-06-28 홍승비 - 승인게시물 검색 카운트 추가 */
	@Override
	public int getSearchApprBoardItemCount(LoginVO userInfo, BoardVO boardVO, Map<String, String> searchMap) throws Exception {
		logger.debug("getSearchApprBoardItemCount started");

		if (boardVO.getSearchQuery().length() > 0) {
			boardVO.setSearchQuery(" AND " + boardVO.getSearchQuery());
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", userInfo.getId());
		map.put("v_TENANTID", boardVO.getTenantID());
		map.put("v_COMPANYID", userInfo.getCompanyID());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("v_KEYWORD", boardVO.getKeyword());

		for (String key : searchMap.keySet()) {
			map.put(key, searchMap.get(key));
		}
		logger.debug("getSearchApprBoardItemCount ended");
		return ezBoardDAO.getSearchApprBoardItemCount(map);
	}
	
	/* 2018-06-28 홍승비 - 승인게시물 검색 리스트 추가 */
	@Override
	public List<HashMap<String, Object>> getSearchApprBoardItemList(BoardListVO boardListVO, BoardVO boardVO, Map<String, String> searchMap, Map<String, String> orderByMap) throws Exception {
		logger.debug("getSearchApprBoardItemList started");
		
		// 20240215 : 김진홍 : CSAP 인증 처리 Mapper 수정
		if (orderByMap.get("orderByCol") == null || "".equals(orderByMap.get("orderByCol"))) {
			orderByMap.put("orderByCol", "WRITEDATE");
			orderByMap.put("orderByColDesc", "Y");
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("lang", boardVO.getLang());
		map.put("v_PUSERID", boardListVO.getUserID());
		
		if (orderByMap.get("orderByCol") != null) {
			map.put("iv_PORDERBYCOL1", orderByMap.get("orderByCol"));
			if (orderByMap.get("orderByColDesc") != null) {
				map.put("iv_PORDERBYCOL1DESC", orderByMap.get("orderByColDesc"));
			}
		}
		
		map.put("v_PSTARTROW", boardListVO.getStartRow());
		map.put("v_PENDROW", boardListVO.getEndRow());
		map.put("v_TENANTID", boardVO.getTenantID());
		map.put("v_COMPANYID", boardListVO.getWriterCompanyID());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("rowCount", boardListVO.getEndRow() - (boardListVO.getStartRow() - 1));
		map.put("limit", boardListVO.getStartRow() - 1);
		map.put("v_KEYWORD", boardVO.getKeyword());

		for (String key : searchMap.keySet()) {
			map.put(key, searchMap.get(key));
		}
		
		logger.debug("getSearchApprBoardItemList ended");
		return ezBoardDAO.getSearchApprBoardItemList(map);
	}

	@Override
	public String getEzTalkGateNoticeBoardId(String companyID, int tenantID) throws Exception {
		logger.debug("getEzTalkGateNoticeBoardId started.");
		
		Map<String, Object> map = new HashMap<>();
		
		ezBoardDAO.getEzTalkGateNoticeBoardId(map);
		map.put("v_companyID", companyID);
		map.put("v_tenantID", tenantID);
		
		String resultBoradID = ezBoardDAO.getEzTalkGateNoticeBoardId(map);
		
		logger.debug("getEzTalkGateNoticeBoardId ended.");
		return resultBoradID;
	}
	
	/* 2019-01-15 홍승비 - 게시물의 수정일(updateDate)만을 업데이트하는 메서드 */
	@Override
	public void modUpdateDate(String updateDate, String itemID, String userID, int tenantID) throws Exception {
		logger.debug("modUpdateDate started.");
		
		Map<String, Object> map = new HashMap<>();
		
		map.put("updateDate", updateDate);
		map.put("itemID", itemID);
		map.put("tenantID", tenantID);
		map.put("updaterID", userID);
		
		ezBoardDAO.modUpdateDate(map);
		
		logger.debug("modUpdateDate ended.");
	}
	
	/* 2019-04-05 홍승비 - 좋아요 삽입 */
	@Override
	public void likeInsert(String userID, String itemID, int tenantID) throws Exception {
		logger.debug("likeInsert started.");
		
		Map<String, Object> map = new HashMap<>();
		
		map.put("v_userID", userID);
		map.put("v_itemID", itemID);
		map.put("v_tenantID", tenantID);
		map.put("v_likeDate", commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss"));
		
		ezBoardDAO.likeInsert(map);	
		logger.debug("likeInsert ended.");
	}
	
	/* 2019-04-05 홍승비 - 좋아요 삭제 */
	@Override
	public void likeDelete(String userID, String itemID, int tenantID) throws Exception {
		logger.debug("likeDelete started.");
		
		Map<String, Object> map = new HashMap<>();
		
		map.put("v_userID", userID);
		map.put("v_itemID", itemID);
		map.put("v_tenantID", tenantID);
		
		ezBoardDAO.likeDelete(map);	
		logger.debug("likeDelete ended.");
	}
	
	/* 2019-04-05 홍승비 - 좋아요 여부 체크 */
	@Override
	public String likeCheck(String userID, String itemID, int tenantID) throws Exception {
		logger.debug("likeCheck started.");
		
		String isLikeChecked = "";
		Map<String, Object> map = new HashMap<>();
		
		map.put("v_userID", userID);
		map.put("v_itemID", itemID);
		map.put("v_tenantID", tenantID);
		
		isLikeChecked = ezBoardDAO.likeCheck(map);
		
		if (isLikeChecked != null && !isLikeChecked.equals("")) {
			isLikeChecked = "Y";
		} else {
			isLikeChecked = "N";
		}
		
		logger.debug("likeCheck ended.");
		return isLikeChecked;
	}
	
	/* 2019-04-05 홍승비 - 좋아요 갯수 가져오기 */
	@Override
	public int getLikeCount(String itemID, int tenantID) throws Exception{
		logger.debug("getLikeCount started.");
		
		Map<String, Object> map = new HashMap<>();
		
		map.put("v_itemID", itemID);
		map.put("v_tenantID", tenantID);
			
		logger.debug("getLikeCount ended.");
		return ezBoardDAO.getlikeCount(map);
	}
	
	/* 2019-04-10 홍승비 - 사용자가 원회사이고 사내겸직이 존재하면 사내겸직부서ID를 리턴 */
	@Override
	public List<String> getPDOAddJobDeptID(String userID, String companyID, int tenantID) throws Exception {
		//logger.debug("getPDOAddJobDeptID started.");
		
		Map<String, Object> map = new HashMap<>();
		
		map.put("v_pUserID", userID);
		map.put("v_pCompanyID", companyID);
		map.put("v_TENANTID", tenantID);
		
		//logger.debug("getPDOAddJobDeptID ended.");
		return ezBoardDAO.getPDOAddJobDeptID(map);
	}
	
	/* 2019-05-15 홍승비 - 해당 부서ID로 상위부서ID(회사포함) 가져오기*/
	@Override
	public String getUpperDeptID(String deptID, int tenantID) throws Exception {
		//logger.debug("getUpperDeptID started.");
		
		Map<String, Object> map = new HashMap<>();
		
		map.put("v_DEPTID", deptID);
		map.put("v_TENANTID", tenantID);
		
		//logger.debug("getUpperDeptID ended.");
		return ezBoardDAO.getUpperDeptID(map);
	}
	
	/* 2019-05-29 홍승비 - 해당 ID가 부서(회사)ID인지 확인하는 기능 서비스로 분리 */
	@Override
	public int isDeptChk(String id, int tenantID) throws Exception {
		//logger.debug("isDeptChk started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("id", id);
		map.put("tenantID", tenantID);
		
		//logger.debug("isDeptChk ended.");
		return ezBoardDAO.isDeptChk(map);
	}
	
	/* 2019-09-18 홍승비 - 사용자의 직위와 직책 ID를 전부 문자열로 이어붙여 리턴하는 메서드 (사내겸직 포함) */
	@Override
	public String getUserJJID(String userID, String companyID, int tenantID) throws Exception {
		//logger.debug("getUserJJID started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		StringJoiner result = new StringJoiner(",");
		
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantID);
		map.put("v_COMPANYID", companyID);
		
		List<String> userJJID = ezBoardDAO.getUserJJID(map);
		
		int userJJSize = userJJID.size();
		if (userJJID != null && userJJSize > 0) {
			for (int i = 0; i < userJJSize; i ++) {
				result.add(userJJID.get(i));
			}
		}
		
		//logger.debug("result in getUserJJID    ::   " + result);
		//logger.debug("getUserJJID ended.");
		return result.toString();
	}
	
	/* 2019-09-18 홍승비 - 그룹권한을 포함하여 ACCESSID에 대한 권한정보를 리스트로 리턴하는 메서드 */
	@Override
	public List<BoardPropertyVO> getACLListNew(String pBoardID, String accessID, int tenantID, int isDept, int isEqualDept) throws Exception {
		//logger.debug("getACLListNew started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("pBoardID", pBoardID);
		map.put("accessID", accessID);
		map.put("tenantID", tenantID);
		map.put("v_ISDEPT", isDept);
		map.put("v_ISEQUALDEPT", isEqualDept);
		
		//logger.debug("map in getACLListNew  ::  " + map.toString());
		//logger.debug("getACLListNew ended");
		return ezBoardDAO.getACLListNew(map);
	}
	
	/* 2019-09-18 홍승비 - 그룹권한을 포함하여 ACCESSID에 대한 게시판 그룹의 관리자 권한을 리스트로 리턴하는 메서드 */
	public List<String> checkIfBoardGroupAdminNew(String pRootBoardID, String accessID, int tenantID, int isDept, int isEqualDept, boolean isBoardGroup) throws Exception {
		//logger.debug("checkIfBoardGroupAdminNew started");
		
		List<String> result = new ArrayList<String>();
		
		if (pRootBoardID.equalsIgnoreCase("top") || pRootBoardID.equalsIgnoreCase("all")) {
			//logger.debug("checkIfBoardGroupAdminNew : pRootBoardID is '" + pRootBoardID + "', return empty String");
			return result;
		}

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pBoardID", pRootBoardID);
		map.put("v_pAccessID", accessID);
		map.put("v_TENANTID", tenantID);
		map.put("v_ISDEPT", isDept);
		map.put("v_ISEQUALDEPT", isEqualDept);
		map.put("isBoardGroup", isBoardGroup);

		//logger.debug("map in checkIfBoardGroupAdminNew  ::  " + map.toString());
		result = ezBoardDAO.checkIfBoardGroupAdminNew(map);
		
		//logger.debug("result in checkIfBoardGroupAdminNew   ::   " + result);
		//logger.debug("checkIfBoardGroupAdminNew ended");
		return result;
	}
	
	/* 2019-09-24 홍승비 - 그룹권한을 포함하여 ACCESSID에 대한 게시판 읽기권한을 리스트로 리턴하는 메서드 */
	@Override
	public List<String> getCheckItemIDNew(String itemID, String boardType, String userDeptPath, int tenantID, int isDept, int isEqualDept) throws Exception {
		logger.debug("getCheckItemIDNew started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_ITEMID", itemID);
		map.put("v_BOARDTYPE", boardType);
		map.put("v_ACCESSID", userDeptPath);
		map.put("v_TENANTID", tenantID);
		map.put("v_ISDEPT", isDept);
		map.put("v_ISEQUALDEPT", isEqualDept);

		logger.debug("getCheckItemIDNew ended");
		return ezBoardDAO.getCheckItemIDNew(map);
	}
	
	/* 2019-11-08 홍승비 - 해당 게시판을 포함하여 하위에 속한 모든 게시판들을 가져오는 메서드 */
	@Override
	public List<BoardPropertyVO> getAllSubBoardProperty(String boardID, int tenantID) throws Exception {
		logger.debug("getAllSubBoardProperty started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_BOARDID", boardID);
		map.put("v_TENANTID", tenantID);

		logger.debug("getAllSubBoardProperty ended");
		return ezBoardDAO.getAllSubBoardProperty(map);
	}
	
	/* 2019-11-08 홍승비 - 주어진 게시판ID에 대하여, 새로운 BOARDTREEPATH를 생성해 리턴하는 메서드 */
	@Override
	public String getNewBoardTreePath(String boardID, int tenantID) throws Exception {
		logger.debug("getNewBoardTreePath started");
		
		StringJoiner addJobStr = new StringJoiner(",");
		String tempParentBoardID = boardID;
		
		boolean isBoardPropertyExist = true;
		while (isBoardPropertyExist == true) {
			BoardPropertyVO boardProperty = getBoardProperty(tempParentBoardID, tenantID);
			if (boardProperty != null && !boardProperty.getParentBoardID().equals("top")) {
				addJobStr.add(boardProperty.getParentBoardID());
				tempParentBoardID = boardProperty.getParentBoardID();
			} else {
				isBoardPropertyExist = false;
			}
		}
		
		logger.debug("getNewBoardTreePath ended");
		return addJobStr.toString();
	}
	
	/* 2020-06-15 홍승비 - 주어진 게시판ID에 대하여 즐겨찾기 여부를 판단하는 메서드 */
	@Override
	public int getIsMyBoardExist(String boardID, String userID, int tenantID, String companyID) throws Exception {
		logger.debug("getIsMyBoardExist started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_BOARDID", boardID);
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantID);
		map.put("v_COMPANYID", companyID);
		
		logger.debug("getIsMyBoardExist ended");
		return ezBoardDAO.getIsMyBoardExist(map);
	}
	
	/* 2020-06-15 홍승비 - 즐겨찾기 게시판 단일 삭제 메서드 */
	@Override
	public void deleteMyBoards(String boardID, String userID, int tenantID, String companyID) throws Exception {
		logger.debug("deleteMyBoards started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("boardID", boardID);
		map.put("userID", userID);
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		
		logger.debug("deleteMyBoards ended");
		ezBoardDAO.setListOrder_D(map);
	}
	
	/* 2019-10-11 홍승비 - 회사별 공지사항 게시판ID를 리턴하는 메서드 */
	@Override
	public String getCompanyNoticeBoardID(String companyID, int tenantID) throws Exception {
		logger.debug("getCompanyNoticeBoardID started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantID);

		logger.debug("getCompanyNoticeBoardID ended");
		return ezBoardDAO.getCompanyNoticeBoardID(map);
	}

	/* 2020-07-14 홍승비 - 선택한 마이게시판 분류 하위에 해당 게시판이 존재하는지 리턴 */
	@Override
	public String isMyBoardExist(String treeID, String boardID, String userID, int tenantID, String companyID) throws Exception {
		logger.debug("isMyBoardExist started");

		Map<String, Object> map = new HashMap<String, Object>();
		String result = "";
		
		map.put("v_BOARDID", boardID);
		map.put("v_TREEID", treeID);
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantID);
		map.put("v_COMPANYID", companyID);
		
		int myBoardCnt = ezBoardDAO.getMyBoardCount(map);
		if (myBoardCnt > 0) {
			result = "Y";
		} else {
			result = "N";
		}
		
		logger.debug("isMyBoardExist ended");
		return result;
	}
	
	// 2020-12-03 박기범 - 회사별 탭게시판에 존재하는 ID와 boardname를 리턴하는 메서드
	@Override
	public List<HashMap<String, Object>> getCompanyTabBoardIDList(String companyID, int tenantID) throws Exception {
		logger.debug("getCompanyTabBoardIDList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TENANTID", tenantID);
		map.put("v_COMPANYID", companyID);
		
		logger.debug("getCompanyTabBoardIDList ended");
		return  ezBoardDAO.getCompanyTabBoardIDList(map);
	}
	
	@Override
	public int getOneLineCNT(String itemID, int tenantID) throws Exception {
		logger.debug("getOneLineCNT started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_itemID", itemID);
		map.put("v_TENANTID", tenantID);
		
		logger.debug("getOneLineCNT ended.");
		return ezBoardDAO.getOneLineCNT(map);
	}
	
	/* 2021-01-06 홍승비 - 게시물의 읽음여부 판별 시, 현재 사용자가 읽은 게시물을 셀렉트하도록 수정 */
	@Override
	public int getReaderListCount2(String boardID, String itemID, String userID, int tenantID) throws Exception {
		logger.debug("getReaderListCount2 started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDID", boardID);
		map.put("v_ITEMID", itemID);
		map.put("v_PUSERID", userID);
		map.put("v_TENANTID", tenantID);
		
		logger.debug("getReaderListCount2 ended");
		return ezBoardDAO.getReaderListCount2(map);
	}
	
	/* 2019-09-24 홍승비 - 그룹권한을 포함하여 ACCESSID에 대한 게시판 접근 + 리스트보기 권한을 리스트로 리턴하는 메서드 (QNA게시판은 관리자권한 체크) */
	@Override
	public List<String> getBoardAccessListViewFG(String boardID, String gubun, String userDeptPath, int tenantID, int isDept, int isEqualDept) throws Exception {
		//logger.debug("getBoardAccessListViewFG started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_BOARDID", boardID);
		map.put("v_GUBUN", gubun);
		map.put("v_ACCESSID", userDeptPath);
		map.put("v_TENANTID", tenantID);
		map.put("v_ISDEPT", isDept);
		map.put("v_ISEQUALDEPT", isEqualDept);

		//logger.debug("getBoardAccessListViewFG ended");
		return ezBoardDAO.getBoardAccessListViewFG(map);
	}
	
	/* 2021-06-23 홍승비 - 게시, 수정알림 메일 발송을 위한 사용자 정보를 map으로 리턴하는 메서드 */
	@Override
	public List<HashMap<String, String>> getBoardUserInfoForMailSend(String isAllGroupBoard, String primary, String companyID, int tenantID) throws Exception {
		logger.debug("getBoardUserInfoForMailSend started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_isAllGroupBoard", isAllGroupBoard);
		map.put("v_PRIMARY", primary);
		map.put("v_TENANTID", tenantID);
		map.put("v_COMPANYID", companyID);

		logger.debug("getBoardUserInfoForMailSend ended");
		return ezBoardDAO.getBoardUserInfoForMailSend(map);
	}
	
	/* 2021-06-23 홍승비 - 댓글알림 메일 발송을 위한 사용자 정보를 map으로 리턴하는 메서드 */
	@Override
	public List<HashMap<String, String>> getCommentNoticeMail(String boardID, String itemID, String lang, int tenantID) throws Exception {
		logger.debug("getCommentNoticeMail started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("lang", commonUtil.getMultiData(lang, tenantID));
		map.put("v_ITEMID", itemID);
		map.put("v_BOARDID", boardID);
		map.put("v_TENANTID", tenantID);

		logger.debug("getCommentNoticeMail ended");
		return ezBoardDAO.getCommentNoticeMail(map);
	}

	/* 2023-03-07 이가은 - userID를 조건으로 댓글 반응 여부(좋아요 : Y / 싫어요 : N / 미선택 : 공백 또는 null) 리턴하는 메서드 */
	@Override
	public String checkReactUser(String itemID, String replyID, String userID, int tenantID) throws Exception {
		logger.debug("checkReactUser started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ITEMID", itemID);
		map.put("v_REPLYID", replyID);
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantID);

		logger.debug("checkReactUser ended");
		return ezBoardDAO.checkReactUser(map);
	}

	/* 2023-03-07 이가은 - 댓글 반응 추가하는 메서드 */
	@Override
	public void inserBoardReact(String itemID, String replyID, String userID, String reactFlag, int tenantID, String companyID, String reactDate) throws Exception {
		logger.debug("inserBoardReact started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ITEMID", itemID);
		map.put("v_REPLYID", replyID);
		map.put("v_USERID", userID);
		map.put("v_REACTFLAG", reactFlag);
		map.put("v_TENANTID", tenantID);
		map.put("v_COMPANYID", companyID);
		map.put("v_REACTDATE", reactDate);

		logger.debug("inserBoardReact ended");
		ezBoardDAO.inserBoardReact(map);
	}

	/* 2023-03-07 이가은 - 댓글 반응 삭제하는 메서드  */
	@Override
	public void deleteBoardReact(String itemID, String replyID, String userID, int tenantID) throws Exception {
		logger.debug("deleteBoardReact started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ITEMID", itemID);
		map.put("v_REPLYID", replyID);
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantID);

		logger.debug("deleteBoardReact ended");
		ezBoardDAO.deleteBoardReact(map);
	}

	/* 2023-03-07 이가은 - 댓글 삭제되었을 경우 반응 모두 삭제하는 메서드 */
	@Override
	public void allReactDelete(String itemID, String delReplyID, int tenantID) throws Exception {
		logger.debug("allReactDelete started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ITEMID", itemID);
		map.put("v_DELREPLYID", delReplyID);
		map.put("v_TENANTID", tenantID);

		logger.debug("allReactDelete ended");
		ezBoardDAO.allReactDelete(map);
	}

	/* 2023-03-08 이가은 - 게시물에 대한 사용자의 댓글 반응 HashMap List로 리턴하는 메서드 */
	@Override
	public List<HashMap<String, String>> getUserReplyReact(String itemID, String userID, int tenantID) throws Exception {
		logger.debug("getUserReplyReact started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ITEMID", itemID);
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantID);

		logger.debug("getUserReplyReact ended");
		return ezBoardDAO.getUserReplyReact(map);
	}

	/* 2023-03-08 이가은 - 댓글 존재여부 리턴하는 메서드 */
	@Override
	public int checkReplyID(String itemID, String replyID, int tenantID) throws Exception {
		logger.debug("checkReplyID started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ITEMID", itemID);
		map.put("v_REPLYID", replyID);
		map.put("v_TENANTID", tenantID);

		logger.debug("checkReplyID started");
		return ezBoardDAO.checkReplyID(map);
	}


	/**
	 * 해당 게시판의 관리권한 여부를 리턴하는 메서드
	 * @param rollInfo : 사용자의 롤정보 - userInfo.getRollInfo()
     */
	public boolean isBoardAdmin(String boardId, String userId, String deptId, String companyId, int tenantId, String rollInfo){
		boolean result = false;
		try {
			String boardGroupAdmin_FG = ezBoardAdminService.checkIfBoardGroupAdmin(boardId, userId, deptId, companyId, tenantId);
			result = rollInfo != null
					&& (boardGroupAdmin_FG.equals("OK")
					|| rollInfo.toLowerCase().contains("c=1;")
					|| rollInfo.toLowerCase().contains("k=1;")
					|| rollInfo.toLowerCase().contains("n=1;"));
		} catch(Exception e){
			logger.error("isBoardAdmin error : " + e.getMessage(), e);
        }
		return result;
	}

	@Override
	public void downloadBackgroundItemFile(HttpServletRequest request, HttpServletResponse response, String realPath, String filePath, String fileName) throws Exception {
		logger.info("downloadBackgroundItemFile started");

		ZipOutputStream zos = null;
		FileInputStream fis = null;

		String saveZipPath = "";

		saveZipPath = createZipFile(zos, fis, realPath, filePath, fileName);
		downloadFile(request, response, zos, fis, saveZipPath, fileName);

		logger.info("downloadBackgroundItemFile ended");
	}

	private String createZipFile(ZipOutputStream zos, FileInputStream fis, String realPath, String filePath, String fileName) throws Exception {
		logger.info("createZipFile started");

		String saveZipPath = "";
		String ext = ".zip";

		byte buffer[] = new byte[4096];
		int length = 0;

		try {
			try {
				saveZipPath = filePath.substring(0, filePath.lastIndexOf("/")) + commonUtil.separator + fileName.substring(0, fileName.lastIndexOf(".")) + ext;

				zos = new ZipOutputStream(
					new FileOutputStream(realPath + saveZipPath),
					StandardCharsets.UTF_8
				);
				fis = new FileInputStream(realPath + filePath);

				zos.putNextEntry(new ZipEntry(fileName));

				while ((length = fis.read(buffer)) > 0) {
					zos.write(buffer, 0, length);
				}

				zos.flush();
				zos.close();
				fis.close();
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
		} catch (Exception e) {

		}

		logger.info("createZipFile ended");

		return saveZipPath;
	}

	private void downloadFile(HttpServletRequest request, HttpServletResponse response, ZipOutputStream zos, FileInputStream fis, String filePath, String fileName) throws Exception {
		logger.info("downloadFile started");

		fileName = fileName.substring(0, fileName.lastIndexOf(".")) + ".zip";
		int buffer = 2048;

		String downFileName = EgovStringUtil.isNullToString(commonUtil.getRealPath(request) + filePath);
		String orgFileName = EgovStringUtil.isNullToString(fileName);

		orgFileName = CommonUtil.getEncodedFileNameForDownload(request.getHeader("User-Agent"), orgFileName);

		File file = new File(commonUtil.detectPathTraversal(downFileName));

		if (!file.exists()) {
			throw new FileNotFoundException(downFileName);
		}

		if (!file.isFile()) {
			throw new FileNotFoundException(downFileName);
		}

		long fSize = file.length();
		if (fSize > 0) {
			BufferedInputStream in = null;

			try {
				in = new BufferedInputStream(new FileInputStream(file));

				String mimetype = "application/octet-stream"; //"application/x-msdownload"

				String nfcFilename = commonUtil.normalizeFileName(orgFileName);

				response.setBufferSize(buffer);
				response.setContentType(mimetype);
				response.setHeader("Content-Disposition", "attachment; filename=\"" + nfcFilename + "\"");
				response.setHeader("Content-Length", Long.toString(fSize));

				FileCopyUtils.copy(in, response.getOutputStream());
			} finally {
				if (in != null) {
					try {
						in.close();
					} catch (Exception ignore) {
						logger.debug("IGNORED: {}", ignore.getMessage());
					}
				}
			}
			response.getOutputStream().flush();
			response.getOutputStream().close();
		}

		logger.info("downloadFile ended");
	}

	/**
	 * 이미지 파일명을 조사하여 첫번째 포함 파일 객체를 리턴
	 * @param itemID 조사할 게시판 id
	 * @param fileName 포함될 단어
	 * @param tenantID tenant ID
	 * @return	해당하는 첨부 이미지 객체
	 * @throws Exception 해당 게시판 조회 쿼리(when itemID, tenantID) 가 예외 발생
	 */
	public Optional<BoardAttachVO> getBoardAttachByName(String itemID, String fileName, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("itemID", itemID);
		map.put("tenantID", tenantID);

		// 파일이름이 없을경우 empty 리턴
		if (StringUtils.isBlank(fileName)) return Optional.empty();

		List<BoardAttachVO> voList = ezBoardDAO.brdGetItemAttachmentInfo(map);
		for (BoardAttachVO vo : voList) {
			// 파일이름이 비어있거나 이미지 파일의 확장자가 아닌경우 스킵
			if (StringUtils.isBlank(vo.getFileName()) || !commonUtil.checkImgExtension(FilenameUtils.getExtension(vo.getFileName()))) {
				continue;
			}

			// 파일이름에 주어진 단어가 포함된 경우 vo 바로 리턴
			if (FilenameUtils.getBaseName(vo.getFileName()).contains(fileName)) {
				return Optional.of(vo);
			}
		}

		return Optional.empty();
	}
	
	@Override
	/* 2024-04-01 한태훈 - 게시판 즐겨찾기 추가 구성원 리스트 가져오는 메소드 */
	public List<OrganUserVO> getFavoriteBoardUserList(String boardId, String companyId, int tenantId) throws Exception {
		logger.debug("getFavoriteBoardUserList starts");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardId", boardId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		logger.debug("getFavoriteBoardUserList ends");
		return ezBoardDAO.getFavoriteBoardUserList(map);
	}

	@Override
	public boolean confirmBoardItemDeletion(String boardID, String itemID, int tenantId) throws Exception {
		logger.debug("confirmBoardItemDeletion starts");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", boardID);
		map.put("tenantID", tenantId);
		map.put("itemID", itemID);

		logger.debug("confirmBoardItemDeletion ends");
		return ezBoardDAO.confirmBoardItemDeletion(map);
	}
	
	@Override
	public List<HashMap<String, Object>> getNoticePostItemList(String boardID, String userID, int startRow, int endRow, int boardCount, String orderOption1, String orderOption2, String type, int tenantID) throws Exception {
		logger.debug("getNoticePostItem2 started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		int start = 0;
		int end = 0;
		start = startRow;
		end = endRow;
		
		BoardMyFavoriteVO boardMyFavoriteVO = new BoardMyFavoriteVO();
		boardMyFavoriteVO.setBoardId(boardID);
		boardMyFavoriteVO.setTenantID(tenantID);
		
		String tempString = ezBoardDAO.getBoardApprJoinItem(boardMyFavoriteVO);
		
		if (tempString != null && ! tempString.equals("")) {
			map.put("v_TEMP", "1");
		} else {
			map.put("v_TEMP", "");
		}
		
		map.put("v_PBOARDID", boardID);
		map.put("v_START", start);
		map.put("v_END", end);
		map.put("v_TENANTID", tenantID);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("rowCount", end - (start - 1));
		map.put("limit", start - 1);

		logger.debug("getNoticePostItem2 ended");
		return ezBoardDAO.getNoticePostItem(map);
	}

	/* 2023-03-30 이가은 - 게시물 댓글의 답글 작성/수정기능 추가 > 댓글에 대한 답글 저장하는 메서드 */
	@Override
	public void saveOneLineChildReply(String itemID, String replyID, String boardID, LoginVO userInfo, String content, String password, String parentReplyID, int replyLevel, String parentWriterName, String imageContent) throws Exception {
		logger.debug("saveOneLineChildReply started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ITEMID", itemID);
		map.put("v_REPLYID", replyID);
		map.put("v_BOARDID", boardID);
		map.put("v_USERID", userInfo.getId());
		map.put("v_USERNAME", userInfo.getDisplayName1());
		map.put("v_USERNAME2", userInfo.getDisplayName2());
		map.put("v_CONTENT", content);
		map.put("v_PASSWORD", password);
		map.put("v_PARENTREPLYID", parentReplyID);
		map.put("v_REPLYLEVEL", replyLevel);
		map.put("v_PARENTWRITERNAME", parentWriterName);
		map.put("v_TENANTID", userInfo.getTenantId());
		map.put("v_COMPANYID", userInfo.getCompanyID());
		map.put("v_NOWDATE", commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss"));
		map.put("v_EMOTICON", imageContent);

		logger.debug("saveOneLineChildReply ended");
		ezBoardDAO.saveOneLineChildReply(map);
	}

	/* 2023-03-30 이가은 - 게시물 댓글의 답글 작성/수정기능 추가 > 댓글 또는 답글 수정되었을 경우 업데이트하는 메서드 */
	@Override
	public void updateOneLineReply(String itemID, String boardID, String replyID, String content, String updateDate, int tenantID, String imageContent) throws Exception {
		logger.debug("updateOneLineReply started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ITEMID", itemID);
		map.put("v_BOARDID", boardID);
		map.put("v_REPLYID", replyID);
		map.put("v_CONTENT", content);
		map.put("v_UPDATEDATE", updateDate);
		map.put("v_TENANTID", tenantID);
		map.put("v_EMOTICON", imageContent);

		logger.debug("updateOneLineReply ended");
		ezBoardDAO.updateOneLineReply(map);
	}

	/* 2023-04-12 이가은 - 게시물 댓글의 답글 작성/수정기능 추가 > 댓글 삭제 시 자식 댓글 개수 리턴하는 메서드 */
	@Override
	public int getChildReplyCnt(String itemID, String boardID, String replyID, int tenantID) throws Exception {
		logger.debug("getChildReplyCnt started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ITEMID", itemID);
		map.put("v_BOARDID", boardID);
		map.put("v_REPLYID", replyID);
		map.put("v_TENANTID", tenantID);

		logger.debug("getChildReplyCnt ended");
		return ezBoardDAO.getChildReplyCnt(map);
	}

	/* 2023-04-12 이가은 - 게시물 댓글의 답글 작성/수정기능 추가 > 자식이 존재하는 부모댓글 삭제할 경우 해당 댓글 정보를 NULL로 변경해주는 메서드 */
	@Override
	public void updateDelParentReply(String replyID, String itemID, String boardID, int tenantID) throws Exception {
		logger.debug("updateDelParentReply started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_REPLYID", replyID);
		map.put("v_ITEMID", itemID);
		map.put("v_BOARDID", boardID);
		map.put("v_TENANTID", tenantID);

		logger.debug("updateDelParentReply ended");
		ezBoardDAO.updateDelParentReply(map);
		ezBoardDAO.deleteCommentAttach(map);
	}

	@Override
	public List<MealDataVO> getMealPlanList(Map<String, Object> map) throws Exception {
		List<MealDataVO> resList = ezBoardDAO.getMealPlanList(map);
		
		if (null == resList || resList.size() < 1) {
			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
			LocalDate sDate = LocalDate.parse((String) map.get("startDate"), formatter);
			
			for (int i  = 0; i < 5; i++) {
				LocalDate currentDate = sDate.plusDays(i);
				MealDataVO vo = new MealDataVO();
				vo.setMealDate(currentDate.toString());
				vo.setaCourse("");
				vo.setbCourse("");
				vo.setSaladBar("");
				vo.setDessert("");
				vo.setTotalCal(0);
				
				resList.add(vo);
			}
		}
		return resList;
	}

	@Override
	public String saveMealPlan(List<MealDataVO> mealInputList) throws Exception {
		try {
			
			for (MealDataVO vo : mealInputList) {
				ezBoardDAO.saveMealplan(vo);
			}
			
			return "true";
		} catch (Exception e) {
			logger.debug(e.getMessage());
			return "false";
		}
	}
	
	/* 2023-04-06 기민혁 - 싫어요 버튼 클릭시 정보 insert 메서드 */
	@Override
	public void disLikeInsert(String userID, String itemID, int tenantID) throws Exception {
		logger.debug("disLikeInsert started.");

		Map<String, Object> map = new HashMap<>();

		map.put("v_userID", userID);
		map.put("v_itemID", itemID);
		map.put("v_tenantID", tenantID);
		map.put("v_disLikeDate",commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss"));

		ezBoardDAO.disLikeInsert(map);
		logger.debug("disLikeInsert ended.");

	}

	/* 2023-04-06 기민혁 - 싫어요 버튼 클릭시 정보 delete 메서드 */
	@Override
	public void disLikeDelete(String userID, String itemID, int tenantID) throws Exception {
		logger.debug("disLikeDelete started.");

		Map<String, Object> map = new HashMap<>();

		map.put("v_userID", userID);
		map.put("v_itemID", itemID);
		map.put("v_tenantID", tenantID);

		ezBoardDAO.disLikeDelete(map);
		logger.debug("disLikeDelete ended.");

	}

	/* 2023-04-06 기민혁 - 싫어요 버튼을 클릭했는데 체크 메소드 */
	@Override
	public String disLikeCheck(String userID, String itemID, int tenantID) throws Exception {
		logger.debug("dislikeCheck started.");

		String isDisLikeChecked = "";
		Map<String, Object> map = new HashMap<>();

		map.put("v_userID", userID);
		map.put("v_itemID", itemID);
		map.put("v_tenantID", tenantID);

		isDisLikeChecked = ezBoardDAO.disLikeCheck(map);

		if (isDisLikeChecked != null && !isDisLikeChecked.equals("")) {
			isDisLikeChecked = "Y";
		} else {
			isDisLikeChecked = "N";
		}

		logger.debug("dislikeCheck ended.");
		return isDisLikeChecked;
	}

	/* 2023-04-06 기민혁 - 싫어요를 누른 사용자 count 메서드 */
	@Override
	public int getDisLikeCount(String itemID, int tenantID) throws Exception {
		logger.debug("getDisLikeCount started.");

		Map<String, Object> map = new HashMap<>();

		map.put("v_itemID", itemID);
		map.put("v_tenantID", tenantID);

		logger.debug("getDisLikeCount ended.");
		return ezBoardDAO.getDisLikeCount(map);
	}
	
	/* 2023-04-06 기민혁 - 좋아요/싫어요 를 누른 명단 list 호출 메서드 */
	@Override
	public String boardLikeAndDisLikeList(LoginVO userInfo, String pBoardID, String[] itemIDs) throws Exception {
		logger.debug("boardLikeAndDisLikeList started.");

		StringBuffer sb = new StringBuffer();
		sb.append("<DATA>");
		for (String itemID : itemIDs) {
			Map<String, String> map = new HashMap<>();
			map.put("itemID", itemID);
			sb.append("<ROW>");
			sb.append("<ITEMINFO>");

			List<BoardItemVO> itemInfo = ezBoardDAO.getItemInfoList(map);// 해당 boardItem 정보

			for (BoardItemVO itemInfoList : itemInfo) {
				sb.append("<ITEMID>" + itemInfoList.getItemID() + "</ITEMID>");
				sb.append("<TITLE>" + commonUtil.cleanValue(itemInfoList.getTitle()) + "</TITLE>");
				sb.append("<TENANTID>" + itemInfoList.getTenantID() + "</TENANTID>");
				sb.append("<BOARDID>" + itemInfoList.getBoardID() + "</BOARDID>");
			}

			sb.append("</ITEMINFO>");
			sb.append("<LIKELIST>");

			List<BoardLikeListVO> likeListData = ezBoardDAO.getLikeList(map); // 선택한 리스트의 좋아요 체크한 정보

			for (BoardLikeListVO BoardLikeList : likeListData) {
				sb.append("<ITEMID>" + BoardLikeList.getItemID() + "</ITEMID>");
				sb.append("<USERID>" + BoardLikeList.getUserID() + "</USERID>");
				sb.append("<LIKEDATE>" + commonUtil.getDateStringInUTC(BoardLikeList.getLikeDate(), userInfo.getOffset(), false) + "</LIKEDATE>");
				sb.append("<TENANTID>" + BoardLikeList.getTenantID() + "</TENANTID>");
				if(userInfo.getLang().equals("1")){
					sb.append("<DISPLAYNAME>" + commonUtil.cleanValue(BoardLikeList.getDisplayName()) + "</DISPLAYNAME>");
				}else{
					sb.append("<DISPLAYNAME>" + commonUtil.cleanValue(BoardLikeList.getDisplayName2()) + "</DISPLAYNAME>");
				}
				sb.append("<WRITER>" + BoardLikeList.getWriterID() + "</WRITER>");
				sb.append("<TITLE>" + commonUtil.cleanValue(BoardLikeList.getTitle()) + "</TITLE>");
				sb.append("<LIKELISTCOUNT>" + BoardLikeList.getLikeListCount() + "</LIKELISTCOUNT>");

			}
			sb.append("</LIKELIST>");
			sb.append("<DISLIKELIST>");

			List<BoardDisLikeListVO> disLikeListData = ezBoardDAO.getDisLikeList(map);// 선택한 리스트의 싫어요 체크한 정보

			for (BoardDisLikeListVO BoardDisLikeList : disLikeListData) {
				sb.append("<D_ITEMID>" + BoardDisLikeList.getItemID() + "</D_ITEMID>");
				sb.append("<D_USERID>" + BoardDisLikeList.getUserID() + "</D_USERID>");
				sb.append("<D_DISLIKEDATE>" + commonUtil.getDateStringInUTC(BoardDisLikeList.getDisLikeDate(), userInfo.getOffset(), false) + "</D_DISLIKEDATE>");
				sb.append("<D_TENANTID>" + BoardDisLikeList.getTenantID() + "</D_TENANTID>");
				if(userInfo.getLang().equals("1")){
					sb.append("<D_DISPLAYNAME>" + commonUtil.cleanValue(BoardDisLikeList.getDisplayName()) + "</D_DISPLAYNAME>");
				}else{
					sb.append("<D_DISPLAYNAME>" + commonUtil.cleanValue(BoardDisLikeList.getDisplayName2()) + "</D_DISPLAYNAME>");
				}
				sb.append("<D_WRITER>" + BoardDisLikeList.getWriterID() + "</D_WRITER>");
				sb.append("<D_TITLE>" + commonUtil.cleanValue(BoardDisLikeList.getTitle()) + "</D_TITLE>");
				sb.append("<DISLIKELISTCOUNT>" + BoardDisLikeList.getDisLikeListCount() + "</DISLIKELISTCOUNT>");
			}
			sb.append("</DISLIKELIST>");
			sb.append("</ROW>");
		}

		sb.append("</DATA>");

		logger.debug("boardLikeAndDisLikeList ended.");

		return sb.toString();
	}

	/* 2024-08-23 전인하 - 게시판 > 게시글 작성 > 키워드 저장 메소드 */	
	@Override
	public void saveKeyword(List<String> keywords, String boardID, String itemID, int tenantID) throws Exception {
		logger.debug("saveKeyword started.");

		HashMap<String, Object> map = new HashMap<>();
		map.put("v_keywords", keywords);
		map.put("v_boardID", boardID);
		map.put("v_itemID", itemID);
		map.put("v_tenantID", tenantID);

		if (keywords != null && keywords.size() > 0) {
			if (dbType.equalsIgnoreCase("oracle") || dbType.equalsIgnoreCase("tibero")) {
				for (int i=0; i<keywords.size(); i++) {
					map.put("v_keyword", keywords.get(i));
					ezBoardDAO.insertKeyword(map);
				}
			} else if (dbType.equalsIgnoreCase("mysql")) {
				ezBoardDAO.insertKeyword(map);
			}
		}
		ezBoardDAO.deleteBoardItemKeyword(map);
		
		if (keywords != null && keywords.size() > 0) {
			List<BoardKeywordVO> tempKeywordsObj = ezBoardDAO.selectBoardKeywordByKeywordName(map);
			List<BoardKeywordVO> newKeywordsObj = new ArrayList<>();
			for (int i = 0; i < keywords.size(); i++) {
				int sn = i;
				BoardKeywordVO key = tempKeywordsObj.stream()
						.filter(o -> o.getKeywordName().equals(keywords.get(sn)))
						.map(o -> new BoardKeywordVO(o.getKeywordId(), o.getKeywordName(), boardID, itemID, tenantID, sn))
						.findAny().orElse(null);
				if (key != null) {
					newKeywordsObj.add(key);
				}
			}
			ezBoardDAO.insertBoardItemKeyword(newKeywordsObj);
		}
		
		logger.debug("saveKeyword ended.");
	}

	/* 2024-08-23 전인하 - 게시판 > 게시물ID로 해당 게시물에 속한 키워드 반환 메소드 */
	@Override
	public List<BoardKeywordVO> selectBoardKeywordByBoardItem(String itemID, String boardID, int tenantId) throws Exception {
		logger.debug("saveKeyword started.");
		
		HashMap<String, Object> map = new HashMap<>();
		map.put("v_boardID", boardID);
		map.put("v_itemID", itemID);
		map.put("v_tenantID", tenantId);
		List<BoardKeywordVO> keywordList = ezBoardDAO.selectBoardKeywordByBoardItem(map);

		logger.debug("saveKeyword ended.");
		return keywordList;
	}

    @Override
    public boolean chkPasswordAnonymous(String itemID, String password, int tenantID) {
        try {
            String correctPassword = getDocPassWord(itemID, tenantID).trim();

            if (StringUtils.isBlank(password)) {
                return false;
            }

            String encryptPassword = EgovFileScrty.encryptPassword(password, "unknown");
            return encryptPassword.equals(correctPassword);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            return false;
        }
    }

	@Override
	public int getAllBoardItemListCount(LoginVO userInfo) throws Exception {
		logger.debug("getAllBoardItemListCount started");

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_pUserID", userInfo.getId());
		map.put("v_COMPANYID", userInfo.getCompanyID());
		map.put("v_TENANTID", userInfo.getTenantId());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));

		logger.debug("getAllBoardItemListCount ended");
		return ezBoardDAO.getAllBoardItemListCount(map);
	}

	@Override
	public List<HashMap<String, Object>> getAllBoardItemList(BoardListVO boardListVO, Map<String, String> orderByMap) throws Exception {
		logger.debug("getAllBoardItemList started");

		if (orderByMap.get("orderByCol") == null || "".equals(orderByMap.get("orderByCol"))) {
			orderByMap.put("orderByCol", "WRITEDATE");
			orderByMap.put("orderByColDesc", "Y");
		}

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_PUSERID", boardListVO.getUserID());
		map.put("v_COMPANYID", boardListVO.getWriterCompanyID());
		map.put("v_TENANTID", boardListVO.getTenantID());
		map.put("v_PSTARTROW", boardListVO.getStartRow());
		map.put("v_PENDROW", boardListVO.getEndRow());

		if (orderByMap.get("orderByCol") != null) {
			map.put("iv_PORDERBYCOL1", orderByMap.get("orderByCol"));
			if (orderByMap.get("orderByColDesc") != null) {
				map.put("iv_PORDERBYCOL1DESC", orderByMap.get("orderByColDesc"));
			}
		}
		
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("rowCount", boardListVO.getEndRow() - (boardListVO.getStartRow() - 1));
		map.put("limit", boardListVO.getStartRow() - 1);
		
		logger.debug("getAllBoardItemList ended");
		return ezBoardDAO.getAllBoardItemList(map);
	}
	
	public boolean saveHWP(String strHTML, String strFilename, String strBoardID, String strFilePath, String strType, String realPath) throws Exception {
		logger.debug("saveHWP started");

		String docPath = "";
		String FilePath = "";
		boolean ret = true;
		InputStream stream = null;
		OutputStream bos = null;
		
		docPath = commonUtil.detectPathTraversal(strFilePath + commonUtil.separator + strBoardID);
		FilePath = commonUtil.detectPathTraversal(strFilename + ".hwp");
		
		String stordFilePathReal = docPath + commonUtil.separator + "doc";
		
		File file = new File(realPath + stordFilePathReal);
		
		if (!file.exists()) {
			boolean _flag = file.mkdirs();
			file = new File(realPath + docPath + commonUtil.separator + "uploadFile");
			file.mkdirs();
			
			if (!_flag) {
				throw new IOException("Directory creation Failed ");
			}
		}
		
		String finalFilePath = realPath + stordFilePathReal + commonUtil.separator + FilePath;
		
		try {
			stream = new ByteArrayInputStream(Base64.decodeBase64(strHTML));
			bos = new FileOutputStream(finalFilePath);
			
			int bytesRead = 0;
			byte[] buffer = new byte[2048];
			
			while ((bytesRead = stream.read(buffer, 0, 2048)) != -1) {
				bos.write(buffer, 0, bytesRead);
			}
		}
		catch (RuntimeException e) {
			throw e;
		}
		catch (Exception e) {
			ret = false;
		} finally {
			if (bos != null) {
				try {
					bos.close();
				} catch (Exception ignore) {
						logger.debug("IGNORED: {}", ignore.getMessage());
				}
			}
			
			if (stream != null) {
				try {
					stream.close();
				} catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
				}
			}
		}
		
		logger.debug("saveHWP ended");
		return ret;
	}
	
	@Override
	public String getContentlocation(String boardID, String itemID, int tenantId) throws Exception {
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", boardID);
		map.put("tenantID", tenantId);
		map.put("itemID", itemID);
		
		return ezBoardDAO.getContentlocation(map);
	}
	
	/* 2023-05-03 기민혁 - 나의 스크랩 데이터 등록 */
	@Override
	public String setScrapItem(String userID, String itemID, String boardID, String companyID, int tenantID) throws Exception {
		logger.debug("setScrapItem started");

		Map<String, Object> map = new HashMap<String, Object>();
		String result = "true";

		map.put("v_userID", userID);
		map.put("v_itemID", itemID);
		map.put("v_boardID", boardID);
		map.put("v_companyID", companyID);
		map.put("v_tenantID", tenantID);
		map.put("v_nowDate", commonUtil.getTodayUTCTime(""));

		try {
			ezBoardDAO.setScrapItem(map);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			return "error";
		}

		logger.debug("setScrapItem ended");
		return result;
	}
	
	/* 2023-05-03 기민혁 - 나의 스크랩 등록 확인 */
	@Override
	public String getScrapItemCount(String userID, String itemID, String boardID, String companyID, int tenantID) throws Exception {
		logger.debug("getScrapItemCount started");

		Map<String, Object> map = new HashMap<String, Object>();
		String result;

		map.put("v_userID", userID);
		map.put("v_itemID", itemID);
		map.put("v_boardID", boardID);
		map.put("v_companyID", companyID);
		map.put("v_tenantID", tenantID);

		try {
			int listCount = ezBoardDAO.getScrapItemCount(map); // 해당 정보들에 맞는 데이터가 이미 있는지 확인

			if (listCount != 0) {
				result = "false";
			} else {
				result = "true";
			}
		} catch (Exception e) {
			logger.debug(e.getMessage());
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			return "error";
		}

		logger.debug("getScrapItemCount ended");

		return result;
	}

	/* 2023-05-03 기민혁 - 나의 스크랩 목록 다중 해제 메서드 */
	@Override
	public String deleteScrapItem(String userID, String itemList, String companyID, int tenantID) throws Exception {
		logger.debug("deleteScrapItem started");

		BoardScrapListVO scrapList = new BoardScrapListVO();

		scrapList.setUserID(userID);
		scrapList.setCompanyID(companyID);
		scrapList.setTenant_ID(tenantID);

		String[] itemListArray = itemList.split(";");
		String result = "true";

		try {
			for (int i = 0; i < itemListArray.length; i++) {
				String scrapItem = itemListArray[i].split(",")[0];
				scrapList.setItemID(scrapItem);
				ezBoardDAO.deleteScrapItem(scrapList);
			}
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			return "error";
		}

		logger.debug("deleteScrapItem ended");
		return result;
	}
	
	/* 2023-05-03 기민혁 - 나의 스크랩 해제 메서드 */
	@Override
	public String delScrapItem(String userID, String itemID, String boardID, String companyID, int tenantID) throws Exception {
		logger.debug("delScrapItem started");

		Map<String, Object> map = new HashMap<String, Object>();

		String result = "true";

		map.put("v_userID", userID);
		map.put("v_itemID", itemID);
		map.put("v_boardID", boardID);
		map.put("v_companyID", companyID);
		map.put("v_tenantID", tenantID);

		try {
			ezBoardDAO.delScrapItem(map);
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			return "error";
		}

		logger.debug("delScrapItem ended");
		return result;
	}
	
	/* 2023-05-03 기민혁 - 나의 스크랩 등록 item 리스트 호출 */
	@Override
	public List<HashMap<String, Object>> getMyBoardListItemScrap(LoginVO userInfo, int startRow, int endRow, int boardCount, String orderOption1, String orderOption2, ArrayList<String> scrapBoardListView_FG, Map<String, String> orderByMap) throws Exception {
		logger.debug("getMyBoardListItemScrap started");

		if (orderByMap.get("orderByCol") == null || "".equals(orderByMap.get("orderByCol"))) {
			orderByMap.put("orderByCol", "SCRAPDATE");
			orderByMap.put("orderByColDesc", "Y");
		}

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_PUSERID", userInfo.getId());
		map.put("v_COMPANYID", userInfo.getCompanyID());
		map.put("v_TENANTID", userInfo.getTenantId());
		map.put("lang", userInfo.getLang());
		map.put("v_PSTARTROW", startRow);
		map.put("v_PENDROW", endRow);
		map.put("iv_PORDERBYSUB", orderOption1);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("rowCount", endRow - (startRow - 1));
		map.put("limit", startRow - 1);
		map.put("scrapBoardListView_FG", scrapBoardListView_FG);

		if (orderByMap.get("orderByCol") != null) {
			map.put("iv_PORDERBYCOL1", orderByMap.get("orderByCol"));
			if (orderByMap.get("orderByColDesc") != null) {
				map.put("iv_PORDERBYCOL1DESC", orderByMap.get("orderByColDesc"));
			}
		}

		logger.debug("getMyBoardListItemScrap ended");
		return ezBoardDAO.getMyBoardListItemScrap(map);
	}
	
	/* 2023-05-03 기민혁 - 나의 스크랩 item totalcount */
	@Override
	public int getMyBoardTotalItemCountScrap(LoginVO userInfo, ArrayList<String> scrapBoardListView_FG) throws Exception {
		logger.debug("getMyBoardTotalItemCountScrap started");

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_userID", userInfo.getId());
		map.put("v_companyID", userInfo.getCompanyID());
		map.put("v_tenantID", userInfo.getTenantId());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("scrapBoardListView_FG", scrapBoardListView_FG);

		logger.debug("getMyBoardTotalItemCountScrap ended");
		return ezBoardDAO.getMyBoardTotalItemCountScrap(map);
	}
	
	/* 2023-05-03 기민혁 - 나의 스크랩 검색 item totalcount */
	@Override
	public int getSearchMyBoardItemCountScrap(LoginVO userInfo, BoardVO boardVO, ArrayList<String> scrapBoardListView_FG, Map<String, String> searchMap) throws Exception {
		logger.debug("getSearchMyBoardItemCountScrap started");

		if (boardVO.getSearchQuery().length() > 0) {
			boardVO.setSearchQuery(" AND " + boardVO.getSearchQuery());
		}

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_PUSERID", userInfo.getId());
		map.put("v_PSUBFLAG", boardVO.getSubFlag());
		map.put("v_PSUBQUERY", boardVO.getSearchQuery());
		map.put("v_TENANTID", boardVO.getTenantID());
		map.put("v_COMPANYID", userInfo.getCompanyID());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("scrapBoardListView_FG", scrapBoardListView_FG);
		
		for (String key : searchMap.keySet()) {
			map.put(key, searchMap.get(key));
		}
		
		logger.debug("getSearchMyBoardItemCountScrap ended");
		return ezBoardDAO.getSearchMyBoardItemCountScrap(map);
	}

	/* 2023-05-03 기민혁 - 나의 스크랩 검색 item 리스트 호출 */
	@Override
	public List<HashMap<String, Object>> getSearchMyBoardItemListScrap(BoardListVO boardListVO, BoardVO boardVO, ArrayList<String> scrapBoardListView_FG, Map<String, String> searchMap, Map<String, String> orderByMap) throws Exception {
		logger.debug("getSearchMyBoardItemListScrap started");
		
		if (orderByMap.get("orderByCol") == null || "".equals(orderByMap.get("orderByCol"))) {
			orderByMap.put("orderByCol", "SCRAPDATE");
			orderByMap.put("orderByColDesc", "Y");
		}

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("lang", boardVO.getLang());
		map.put("v_PUSERID", boardListVO.getUserID());
		map.put("v_PSTARTROW", boardListVO.getStartRow());
		map.put("v_PENDROW", boardListVO.getEndRow());
		map.put("v_PTOTALCOUNT", boardListVO.getTotalCount());
		map.put("iv_PORDERBYSUB", boardListVO.getOrderBySub());
		map.put("v_PORDERBYMAIN", boardListVO.getOrderByMain());
		map.put("v_PSUBFLAG", boardVO.getSubFlag());
		map.put("v_PSUBQUERY", boardVO.getSearchQuery());
		map.put("v_TENANTID", boardVO.getTenantID());
		map.put("v_COMPANYID", boardListVO.getWriterCompanyID());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("rowCount", boardListVO.getEndRow() - (boardListVO.getStartRow() - 1));
		map.put("limit", boardListVO.getStartRow() - 1);
		map.put("scrapBoardListView_FG", scrapBoardListView_FG);

		if (orderByMap.get("orderByCol") != null) {
			map.put("iv_PORDERBYCOL1", orderByMap.get("orderByCol"));
			if (orderByMap.get("orderByColDesc") != null) {
				map.put("iv_PORDERBYCOL1DESC", orderByMap.get("orderByColDesc"));
			}
		}
		
		for (String key : searchMap.keySet()) {
			map.put(key, searchMap.get(key));
		}
		
		logger.debug("getSearchMyBoardItemListScrap ended");
		return ezBoardDAO.getSearchMyBoardItemListScrap(map);
	}

	/* 2023-05-03 기민혁 - 게시물 삭제시 scrap 목록 삭제 */
	@Override
	public void deleteBoardScrapItem(String itemList, String companyID, int tenantID) throws Exception {
		logger.debug("deleteBoardScrapItem started");

		int isScrap;
		BoardScrapListVO scrapList = new BoardScrapListVO();

		scrapList.setCompanyID(companyID);
		scrapList.setTenant_ID(tenantID);

		String[] itemListArray = itemList.split(";");

		for (int i = 0; i < itemListArray.length; i++) {
			String scrapItem = itemListArray[i].split(",")[0];
			scrapList.setItemID(scrapItem);
			
			isScrap = ezBoardDAO.isScrapitemCount(scrapList);
			
			if(isScrap != 0){
				ezBoardDAO.deleteBoardScrapItem(scrapList);	
			}
		}

		logger.debug("deleteBoardScrapItem ended");
	}
	
	/* 2023-05-22 기민혁 - 스크랩함 폴더 data 표출 */
	@Override
	public String getUserScrapContTree(String OwnUserID, String ParentScrapContID, String companyID, String lang, int tenantID, Locale locale) throws Exception {
		logger.debug("getUserScrapContTree start");
		StringBuilder rtnXML = new StringBuilder("");

		String strLangDeptDocFolder = egovMessageSource.getMessage("ezBoard.kmh12", locale); 

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LANGTYPE", lang);
		map.put("v_TENANTID", tenantID);
		map.put("v_COMPANYID", companyID);
		map.put("v_USERID", OwnUserID);
		map.put("v_ParentScrapContID", ParentScrapContID);

		List<BoardUserScrapContVO> userScrapContlist = ezBoardDAO.getUserScrapContTree(map);
		StringBuffer sb = new StringBuffer();
		sb.append("<DATA>");

		for (int i = 0; i < userScrapContlist.size(); i++) {
			sb.append(commonUtil.getQueryResult(userScrapContlist.get(i)));
		}

		sb.append("</DATA>");

		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		if (ParentScrapContID.toUpperCase().equals("ROOT")) {
			rtnXML.append("<TREEVIEWDATA>");
		} else {
			rtnXML.append("<NODES>");
		}

		if (dlength > 0) {
			if (ParentScrapContID.toUpperCase().equals("ROOT")) {
				rtnXML.append("<NODE>");
				rtnXML.append("<VALUE>" + commonUtil.cleanValue(docXML.getElementsByTagName("USERSCRAPCONTNAME").item(0).getTextContent()).replace("\\", "&#92;") + "</VALUE>");
				rtnXML.append("<DATA1>" + docXML.getElementsByTagName("USERSCRAPCONTID").item(0).getTextContent()+ "</DATA1>");
				rtnXML.append("<DATA2>" + ParentScrapContID + "</DATA2>");
				rtnXML.append("<DATA3>" + commonUtil.cleanValue(docXML.getElementsByTagName("DESCRIPTION").item(0).getTextContent()) + "</DATA3>");
				rtnXML.append("<DATA4>" + OwnUserID + "</DATA4><ISLEAF>" + getUserScrapContTreeLeaf(docXML.getElementsByTagName("USERSCRAPCONTID").item(0).getTextContent(), companyID, tenantID) + "</ISLEAF><EXPANDED>FALSE</EXPANDED>");
				// 표준모듈 (2007.05.07) : 다국어
				rtnXML.append(getUserScrapContTree(OwnUserID, docXML.getElementsByTagName("USERSCRAPCONTID").item(0).getTextContent(), companyID, lang, tenantID, locale));
				rtnXML.append("</NODE>");
			} else {
				for (int j = 0; j < dlength; j++) {
					rtnXML.append("<NODE>");
					rtnXML.append("<VALUE>" + commonUtil.cleanValue(docXML.getElementsByTagName("USERSCRAPCONTNAME").item(j).getTextContent()).replace("\\", "&#92;") + "</VALUE>");
					rtnXML.append("<DATA1>" + docXML.getElementsByTagName("USERSCRAPCONTID").item(j).getTextContent() + "</DATA1>");
					rtnXML.append("<DATA2>" + ParentScrapContID + "</DATA2>");
					rtnXML.append("<DATA3>" + commonUtil.cleanValue(docXML.getElementsByTagName("DESCRIPTION").item(j).getTextContent()) + "</DATA3>");
					rtnXML.append("<DATA4>" + OwnUserID + "</DATA4><ISLEAF>" + getUserScrapContTreeLeaf(docXML.getElementsByTagName("USERSCRAPCONTID").item(j).getTextContent(), companyID, tenantID) + "</ISLEAF><EXPANDED>FALSE</EXPANDED></NODE>");
				}
			}
		} else {
			if (ParentScrapContID.toUpperCase().equals("ROOT")) {
				// 표준모듈 (2007.05.07) : 다국어
				String NewScrapContID = createUserScrapCont(egovMessageSource.getMessage("ezBoard.kmh12", locale), ParentScrapContID, strLangDeptDocFolder, OwnUserID, companyID, lang, tenantID);

				if (!NewScrapContID.trim().equals("")) {
					rtnXML.append("<NODE>");
					rtnXML.append("<VALUE>" + egovMessageSource.getMessage("ezBoard.kmh12", locale) + "</VALUE>");
					rtnXML.append("<DATA1>" + NewScrapContID + "</DATA1>");
					rtnXML.append("<DATA2>" + ParentScrapContID + "</DATA2>");
					rtnXML.append("<DATA3>" + strLangDeptDocFolder + "</DATA3>");
					rtnXML.append("<DATA4>" + OwnUserID + "</DATA4><ISLEAF>" + getUserScrapContTreeLeaf(NewScrapContID, companyID, tenantID) + "</ISLEAF><EXPANDED>FALSE</EXPANDED></NODE>");
				}
			}
		}

		if (ParentScrapContID.toUpperCase().equals("ROOT")) {
			rtnXML.append("</TREEVIEWDATA>");
		} else {
			rtnXML.append("</NODES>");
		}

		logger.debug("getUserScrapContTree ended");
		return rtnXML.toString();
	}
	
	/* 2023-05-22 기민혁 - 스크랩함 폴더 생성 */
	@Override
	public String insUserScrapCont(String ownUserID, String parentScrapContID, String UserScrapContName, String description, String companyID, String lang, int tenantID) throws Exception {
		logger.debug("insUserScrapCont started");
		String scrapContID = createUserScrapCont(UserScrapContName, parentScrapContID, description, ownUserID, companyID, lang, tenantID);

		if (scrapContID.trim().equals(""))
			return "<RESULT>FALSE</RESULT>";
		else
			return "<RESULT>TRUE</RESULT>";
	}
	
	/* 2023-05-22 기민혁 - 스크랩함 폴더 변경 */
	@Override
	public String updateUserScrapCont(String scrapContID, String ownUserID, String parentScrapContID, String userScrapContName, String description, String companyID, String lang, int tenantID) throws Exception {
		logger.debug("updateUserScrapCont started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_POWNUSERID", ownUserID);
		map.put("v_PUSERSCRAPCONTNAME", userScrapContName);
		map.put("v_PSCRAPCONTID", scrapContID);
		map.put("v_PDESCRIPTION", description);
		map.put("v_PPARENTSCRAPCONTID", parentScrapContID);
		map.put("v_TENANTID", tenantID);
		map.put("companyID", companyID);

		ezBoardDAO.updateUserScrapCont(map);
		
		logger.debug("updateUserScrapCont ended.");
		return "<RESULT>TRUE</RESULT>";
	}
	
	/* 2023-05-22 기민혁 - 스크랩함 폴더 삭제 */
	@Override
	public String deleteUserScrapCont(String scrapContID, String mode, String companyID, String lang, int tenantID) throws Exception {
		logger.debug("deleteUserScrapCont started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PSCRAPCONTID", scrapContID);
		map.put("v_TENANTID", tenantID);
		map.put("companyID", companyID);

		int hasSubCont = ezBoardDAO.getUserScrapContSubCount(map);

		if (hasSubCont > 0) {
			return "<RESULT>HASSUBCONT</RESULT>";
		}

		int ItemCount = 0;
		if (mode.toLowerCase().equals("check")) {
			ItemCount = ezBoardDAO.delUserScrapContItemCnt(map);
		}

		if (ItemCount <= 0) {
			ezBoardDAO.delUserScrapContList(map);
			ezBoardDAO.delUserScrapCont(map);
		} else {
			return "<RESULT>" + ItemCount + "</RESULT>";
		}
		logger.debug("deleteUserScrapCont ended");
		return "<RESULT>TRUE</RESULT>";
	}
	
	/* 2023-05-22 기민혁 - 스크랩함 중복 스크랩 목록 확인 */
	@Override
	public int getOverlapItemCount(String id, String itemListID, String boardID, String userScrapContID, String companyID, int tenantID) throws Exception {
		logger.debug("getOverlapItemCount start");

		int overlapCount = 0;
		BoardUserScrapContListVO boardUserScrapContListVO = new BoardUserScrapContListVO();

		boardUserScrapContListVO.setUserID(id);
		boardUserScrapContListVO.setBoardID(boardID);
		boardUserScrapContListVO.setCompanyID(companyID);
		boardUserScrapContListVO.setTenantID(tenantID);
		boardUserScrapContListVO.setUserScrapContID(userScrapContID);

		String[] itemListArray = itemListID.split(";");

		for (int i = 0; i < itemListArray.length; i++) {
			String itemID = itemListArray[i];
			boardUserScrapContListVO.setItemID(itemID);

			overlapCount += ezBoardDAO.getOverlapItemCount(boardUserScrapContListVO);
		}
		logger.debug("getOverlapItemCount ended");
		return overlapCount;
	}
	
	/* 2023-05-22 기민혁 - 스크랩함에 게시물 데이터 insert */
	@Override
	public String setUserScrapContItem(String id, String itemListID, String boardID, String userScrapContID, String companyID, int tenantId) throws Exception {
		logger.debug("setUserScrapContItem start.");

		BoardUserScrapContListVO boardUserScrapContListVO = new BoardUserScrapContListVO();
		String result = "true";

		boardUserScrapContListVO.setBoardID(boardID);
		boardUserScrapContListVO.setUserID(id);
		boardUserScrapContListVO.setUserScrapContID(userScrapContID);
		boardUserScrapContListVO.setCompanyID(companyID);
		boardUserScrapContListVO.setTenantID(tenantId);
		boardUserScrapContListVO.setScrapDate(commonUtil.getTodayUTCTime(""));

		try {

			String[] itemListArray = itemListID.split(";");
			for (int i = 0; i < itemListArray.length; i++) {
				String itemID = itemListArray[i];
				boardUserScrapContListVO.setItemID(itemID);
				boardUserScrapContListVO.setDescription(Integer.toString(i));
				ezBoardDAO.setUserScrapContItem(boardUserScrapContListVO);

			}

		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			result = "error";
			return result;
		}

		logger.debug("setUserScrapContItem ended.");
		return result;
	}
	
	/* 2023-05-22 기민혁 - 스크랩함 게시물 스크랩 해제 */
	@Override
	public String deleteScrapContItemList(String userID, String itemList, String companyID, int tenantID, String scrapContID) throws Exception {
		logger.debug("deleteScrapContItemList started");

		BoardScrapListVO scrapList = new BoardScrapListVO();

		scrapList.setUserID(userID);
		scrapList.setCompanyID(companyID);
		scrapList.setTenant_ID(tenantID);
		scrapList.setScrapContID(scrapContID);
		String[] itemListArray = itemList.split(";");

		try {
			for (int i = 0; i < itemListArray.length; i++) {
				String scrapItem = itemListArray[i].split(",")[0];
				scrapList.setItemID(scrapItem);
				ezBoardDAO.deleteScrapContItemList(scrapList);
			}
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			return "error";
		}

		logger.debug("deleteScrapContItemList ended");
		return "true";
	}
	
	/* 2023-05-22 기민혁 - 스크랩함 스크랩 item totalcount */
	@Override
	public int getUserScrapContlistCount(LoginVO userInfo, String scrapContID, ArrayList<String> scrapContBoardListView_FG) throws Exception {
		logger.debug("getUserScrapContlistCount started");

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_userID", userInfo.getId());
		map.put("v_companyID", userInfo.getCompanyID());
		map.put("v_tenantID", userInfo.getTenantId());
		map.put("v_scrapContID", scrapContID);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("scrapContBoardListView_FG", scrapContBoardListView_FG);
		
		logger.debug("getUserScrapContlistCount ended");
		return ezBoardDAO.getUserScrapContlistCount(map);
	}
	
	/* 2023-05-22 기민혁 - 스크랩함 리스트 표출 */
	@Override
	public List<HashMap<String, Object>> getScrapContItemList(LoginVO userInfo, int startRow, int endRow, int boardCount, String orderOption1, String orderOption2, String scrapContID, ArrayList<String> scrapContBoardListView_FG, Map<String, String> orderByMap) throws Exception {
		logger.debug("getScrapContItemList started");
		
		if (orderByMap.get("orderByCol") == null || "".equals(orderByMap.get("orderByCol"))) {
			orderByMap.put("orderByCol", "SCRAPDATE");
			orderByMap.put("orderByColDesc", "Y");
		}

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_PUSERID", userInfo.getId());
		map.put("v_COMPANYID", userInfo.getCompanyID());
		map.put("v_TENANTID", userInfo.getTenantId());
		map.put("lang", userInfo.getLang());
		map.put("v_PSTARTROW", startRow);
		map.put("v_PENDROW", endRow);
		map.put("iv_PORDERBYSUB", orderOption1);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("rowCount", endRow - (startRow - 1));
		map.put("limit", startRow - 1);
		map.put("scrapContID", scrapContID);
		map.put("scrapContBoardListView_FG", scrapContBoardListView_FG);

		if (orderByMap.get("orderByCol") != null) {
			map.put("iv_PORDERBYCOL1", orderByMap.get("orderByCol"));
			if (orderByMap.get("orderByColDesc") != null) {
				map.put("iv_PORDERBYCOL1DESC", orderByMap.get("orderByColDesc"));
			}
		}
		
		logger.debug("getScrapContItemList ended");
		return ezBoardDAO.getScrapContItemList(map);
	}

	/* 2023-05-22 기민혁 - 스크랩함 검색결과 스크랩 item totalcount */
	@Override
	public int getSearchScrapContItemListCount(LoginVO userInfo, BoardVO boardVO, ArrayList<String> scrapContBoardListView_FG, Map<String, String> searchMap) throws Exception {
		logger.debug("getSearchScrapContItemListCount started");

		if (boardVO.getSearchQuery().length() > 0) {
			boardVO.setSearchQuery(" AND " + boardVO.getSearchQuery());
		}

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_userID", userInfo.getId());
		map.put("v_companyID", userInfo.getCompanyID());
		map.put("v_tenantID", userInfo.getTenantId());
		map.put("v_scrapContID", boardVO.getScrapContID());
		map.put("v_PSUBQUERY", boardVO.getSearchQuery());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("scrapContBoardListView_FG", scrapContBoardListView_FG);

		for (String key : searchMap.keySet()) {
			map.put(key, searchMap.get(key));
		}
		
		logger.debug("getSearchScrapContItemListCount ended");
		return ezBoardDAO.getSearchScrapContItemListCount(map);
	}
	
	/* 2023-05-22 기민혁 - 나의 스크랩함 검색리스트 표출 */
	@Override
	public List<HashMap<String, Object>> getSearchScrapContItemList(BoardListVO boardListVO, BoardVO boardVO, ArrayList<String> scrapContBoardListView_FG, Map<String, String> searchMap, Map<String, String> orderByMap) throws Exception {
		logger.debug("getSearchScrapContItemList started");

		if (orderByMap.get("orderByCol") == null || "".equals(orderByMap.get("orderByCol"))) {
			orderByMap.put("orderByCol", "SCRAPDATE");
			orderByMap.put("orderByColDesc", "Y");
		}

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("lang", boardVO.getLang());
		map.put("v_PUSERID", boardListVO.getUserID());
		map.put("v_PSTARTROW", boardListVO.getStartRow());
		map.put("v_PENDROW", boardListVO.getEndRow());
		map.put("v_PTOTALCOUNT", boardListVO.getTotalCount());
		map.put("iv_PORDERBYSUB", boardListVO.getOrderBySub());
		map.put("v_PORDERBYMAIN", boardListVO.getOrderByMain());
		map.put("v_PSUBFLAG", boardVO.getSubFlag());
		map.put("v_PSUBQUERY", boardVO.getSearchQuery());
		map.put("v_TENANTID", boardVO.getTenantID());
		map.put("v_COMPANYID", boardListVO.getWriterCompanyID());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("rowCount", boardListVO.getEndRow() - (boardListVO.getStartRow() - 1));
		map.put("limit", boardListVO.getStartRow() - 1);
		map.put("v_PSUBQUERY", boardVO.getSearchQuery());
		map.put("v_SCRAPCONTID", boardVO.getScrapContID());
		map.put("scrapContBoardListView_FG", scrapContBoardListView_FG);

		if (orderByMap.get("orderByCol") != null) {
			map.put("iv_PORDERBYCOL1", orderByMap.get("orderByCol"));
			if (orderByMap.get("orderByColDesc") != null) {
				map.put("iv_PORDERBYCOL1DESC", orderByMap.get("orderByColDesc"));
			}
		}

		for (String key : searchMap.keySet()) {
			map.put(key, searchMap.get(key));
		}
		
		logger.debug("getSearchScrapContItemList ended");
		return ezBoardDAO.getSearchScrapContItemList(map);
	}
	
	/* 2023-05-22 기민혁 - 나의 스크랩함 폴더 생성 */
	private String createUserScrapCont(String tempOwnUserName, String parentScrapContID, String description, String ownUserID, String companyID, String lang, int tenantID) throws Exception {
		logger.debug("createUserScrapCont started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERSCRAPCONTNAME", tempOwnUserName);
		map.put("v_PARENTSCRAPCONTID", parentScrapContID);
		map.put("v_DESCRIPTION", description);
		map.put("v_USERID", ownUserID);
		map.put("v_LANGTYPE", lang);
		map.put("v_TENANTID", tenantID);
		map.put("companyID", companyID);

		String maxScrapContID = ezBoardDAO.getUserScrapContMaxID(map);
		map.put("v_PMAXSCRAPCONTAINERID", maxScrapContID);

		ezBoardDAO.insertUserScrapCont(map);

		if (maxScrapContID == null) {
			maxScrapContID = "";
		}
		
		logger.debug("createUserScrapCont ended");
		return maxScrapContID;
	}
	
	/* 2023-05-22 기민혁 - 게시물함  자식 폴더 표출 */
	private String getUserScrapContTreeLeaf(String UserScrapContID, String companyID, int tenantID) throws Exception {
		logger.debug("getUserScrapContTreeLeaf started");

		String isLeaf = "FALSE";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERSCRAPCONTID", UserScrapContID);
		map.put("v_TENANTID", tenantID);
		map.put("companyID", companyID);

		List<BoardUserScrapContVO> userScrapContTreelist = ezBoardDAO.getUserScrapContTreeLeaf(map);

		StringBuffer sb = new StringBuffer();
		sb.append("<DATA>");

		for (int i = 0; i < userScrapContTreelist.size(); i++) {
			sb.append(commonUtil.getQueryResult(userScrapContTreelist.get(i)));
		}
		sb.append("</DATA>");

		Document docXML = commonUtil.convertStringToDocument(sb.toString());

		if (docXML.getElementsByTagName("ROW").getLength() > 0) {
			isLeaf = "FALSE";
		} else {
			isLeaf = "TRUE";
		}

		logger.debug("getUserScrapContTreeLeaf ended");
		return isLeaf;
	}
	
	/* 2023-05-22 기민혁 - 게시물 삭제시 scrapcont 목록 삭제 */
	@Override
	public void deleteBoardScrapContItem(String itemList, String companyID, int tenantID) throws Exception {
		logger.debug("deleteBoardScrapContItem started");

		int isScrap;
		BoardUserScrapContListVO scrapList = new BoardUserScrapContListVO();

		scrapList.setCompanyID(companyID);
		scrapList.setTenantID(tenantID);

		String[] itemListArray = itemList.split(";");

		for (int i = 0; i < itemListArray.length; i++) {
			String scrapItem = itemListArray[i].split(",")[0];
			scrapList.setItemID(scrapItem);
			
			isScrap = ezBoardDAO.isScrapContItemCount(scrapList);
			
			if(isScrap != 0){
			ezBoardDAO.deleteBoardScrapContItem(scrapList);
			}
		}

		logger.debug("deleteBoardScrapContItem ended");
	}

	@Override
	public List<HashMap<String, Object>> getUserScrapBoardList(String userID, int tenantID) throws Exception {
		logger.debug("getUserScrapBoardList started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userID);
		map.put("v_TENANTID", tenantID);

		logger.debug("getUserScrapBoardList ended");
		return ezBoardDAO.getUserScrapBoardList(map);
	}

	@Override
	public List<HashMap<String, Object>> getUserScrapContBoardList(LoginVO userInfo, String scrapContID) throws Exception {
		logger.debug("getUserScrapContBoardList started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userInfo.getId());
		map.put("v_TENANTID", userInfo.getTenantId());
		map.put("v_CONTID", scrapContID);

		logger.debug("getUserScrapContBoardList ended");
		return ezBoardDAO.getUserScrapContBoardList(map);
	}

	/**
	 * 게시판 게시물 첨부파일저장 실행 Method
	 */
	@Override
	public boolean saveCommentAttachment(String strAttachments, String replyID, String strItemID, String strBoardID, String realPath, int tenantID) throws Exception {
		logger.debug("saveCommentAttachInfo started");

		long fileSize = 0;
		boolean rtnValue = false;
		String filePathRoot = commonUtil.getUploadPath("upload_board.ROOT", tenantID);
		String filePath = "";
		String fileName = "";
		String tempAttachmentPath = "";
		String uploadAttachmentPath = "";

		
		try {
			// 수정 대신 삭제 후 재삽입을 함
			Map<String, Object> map = new HashMap<>();
			map.put("v_REPLYID", replyID);
			map.put("v_ITEMID", strItemID);
			map.put("v_TENANTID", tenantID);
			ezBoardDAO.deleteCommentAttach(map);
			
			if (!StringUtils.isBlank(strAttachments)) {
				for (int i = 0; i < strAttachments.split("\\|").length; i++) {
					String[] tempArr = commonUtil.detectPathTraversal(strAttachments.split("\\|")[i]).split(":");
					fileName = tempArr[0];
					tempAttachmentPath = tempArr[1];

					boolean isKlibEncrypted = tempAttachmentPath.endsWith("." + EzApprovalGKlibService.ENCRYPTED_FILE_EXT);

					if (isKlibEncrypted) {
						uploadAttachmentPath = tempAttachmentPath.substring(0, tempAttachmentPath.lastIndexOf('.'));
					} else {
						uploadAttachmentPath = tempAttachmentPath;
					}

					File file = new File(realPath + commonUtil.detectPathTraversal(tempAttachmentPath));
					fileSize = file.length();

					if (tempAttachmentPath.indexOf("tempUploadFile") > -1) {
						filePath = filePathRoot + commonUtil.separator + strBoardID + commonUtil.separator + "uploadCommentlFile" + commonUtil.separator + replyID + commonUtil.separator + uploadAttachmentPath.split("tempUploadFile" + commonUtil.separator)[1];

						File fileinfo = new File(realPath + commonUtil.detectPathTraversal(filePath));

						if (!fileinfo.exists()) {
							if (isKlibEncrypted) {
								byte[] fileBytes = FileUtils.readFileToByteArray(file);
								fileBytes = klibUtil.decrypt(fileBytes);
								FileUtils.writeByteArrayToFile(fileinfo, fileBytes);
							} else {
								FileUtils.moveFile(file, fileinfo);
							}
						}
					} else {
						filePath = tempAttachmentPath;
					}

					file = null;

					saveCommentAttach(strItemID, replyID, i, filePath, fileSize, fileName, tenantID);
				}
			}
			rtnValue = true;
		} catch (Exception e) {
			logger.debug(e.getMessage());
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			rtnValue = false;
		}

		logger.debug("saveCommentAttachInfo ended");
        return rtnValue;
	}

	public void saveCommentAttach(String itemID, String replyID, int seqNum, String filePath, long fileSize, String fileName, int tenantID) throws Exception {
		logger.debug("saveAttachCommentInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_ITEMID", itemID);
		map.put("v_REPLYID", replyID);
		map.put("seqNum", seqNum);
		map.put("v_STRATTACHMENTS", filePath);
		map.put("v_FILESIZE", fileSize);
		map.put("v_FILENAME", fileName);
		map.put("v_TENANTID", tenantID);
		
		ezBoardDAO.saveCommentAttach(map);

		logger.debug("saveCommentAttach ended");
	}
	
	// 2024-10-30 전인하 - 댓글 첨부파일 맵핑 함수
	private List<BoardLineReplyVO> mappingCommentListForAttach(List<BoardLineReplyVO> tmpCmtList) {
		List<BoardLineReplyVO> rtnVal = new ArrayList<BoardLineReplyVO>();
		Map<String, BoardLineReplyVO> commentIdList = new HashMap<>();
		List<BoardReplyAttachVO> tmpAttachList = new ArrayList<>();

		for (BoardLineReplyVO comment : tmpCmtList) {
			// 이미 존재하는 댓글인지 확인
            BoardLineReplyVO commentVO = commentIdList.get(comment.getReplyID());
			
			 if (commentVO == null) {
                // 처음 본 댓글이면 새로운 댓글 객체 생성
                commentVO = comment;

                // 댓글을 리스트와 맵에 추가
				commentIdList.put(comment.getReplyID(), commentVO);
                rtnVal.add(commentVO);
				tmpAttachList = new ArrayList<>();
            }
			 
			 if (commentVO.getFileSN() != null) {
				 BoardReplyAttachVO att = new BoardReplyAttachVO();
				 att.setFileName(commonUtil.cleanValueUnescape(comment.getFileName()));
				 att.setFilePath(comment.getFilePath());
				 att.setFileSize(comment.getFileSize());
				 att.setSn(comment.getFileSN());
				 tmpAttachList.add(att);
				 commentVO.setReplyAttach(tmpAttachList);
			 }
		}
		return rtnVal;
  	}
	  
	public void updateMovedItemCommentAttach(String orgItemID, String destItemID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("orgItemID", orgItemID);
		map.put("destItemID", destItemID);
		map.put("tenantID", tenantID);
		
		ezBoardDAO.updateMovedItemCommentAttach(map);
	}
	
	@Override
	public List<BoardThumbnailVO> thumbnailViewDB(String itemID, String boardID, int pStartRow, int pEndRow, int tenantID) throws Exception {
		logger.debug("thumbnailViewDB started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		/* 2021-08-12 홍승비 - 임시보관함에서 접근한 경우의 분기 추가 (페이지 제한 없이 이미지 가져오도록) */
		if (pStartRow < 0 && pEndRow == 0) {
			map.put("v_ISTEMPITEM", "Y");
		} else {
			map.put("v_ISTEMPITEM", "N");
		}
		
		map.put("v_pItemID", itemID);
		map.put("v_pBoardID", boardID);
		map.put("v_pStartRow", pStartRow);
		map.put("v_pEndRow", pEndRow);
		map.put("v_TENANTID", tenantID);
		map.put("rowCount", pEndRow - (pStartRow - 1));
		map.put("limit", pStartRow - 1);

		logger.debug("thumbnailViewDB ended");
		return ezBoardDAO.thumbnailViewDB(map);
	}
	
	@Override
	public void thumbnailUpdate(String imageID, String boardID, int tenantID, String ext, String oFileName, String addThumbnail) throws Exception {
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pImageID", imageID);
		map.put("v_pBoardID", boardID);
		map.put("v_TENANTID", tenantID);
		map.put("v_pExt", ext);
		map.put("v_pOFileName", oFileName);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("v_AddThumbnail", addThumbnail);
		
		ezBoardDAO.thumbnailUpdate(map);
	}

	/* 2024-09-05 이유정 - 게시판 > 최근게시물 리스트 카운트 메서드 */
	@Override
	public int getAllNewItemListCount(LoginVO userInfo)  throws Exception {
		logger.debug("getAllNewItemListCount started");

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_pUserID", userInfo.getId());
		map.put("v_COMPANYID", userInfo.getCompanyID());
		map.put("v_TENANTID", userInfo.getTenantId());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));

		logger.debug("getAllNewItemListCount ended");
		return ezBoardDAO.getAllNewItemListCount(map);
	}

	/* 2024-09-05 이유정 - 게시판 > 최근게시물 리스트 메서드 */
	@Override
	public List<HashMap<String, Object>> getAllNewItemList(BoardListVO boardListVO, Map<String, String> orderByMap) throws Exception {
		logger.debug("getAllNewItemList started");

		if (orderByMap.get("orderByCol") == null || "".equals(orderByMap.get("orderByCol"))) {
			orderByMap.put("orderByCol", "WRITEDATE");
			orderByMap.put("orderByColDesc", "Y");
		}

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_PUSERID", boardListVO.getUserID());
		map.put("v_COMPANYID", boardListVO.getWriterCompanyID());
		map.put("v_TENANTID", boardListVO.getTenantID());
		map.put("v_PSTARTROW", boardListVO.getStartRow());
		map.put("v_PENDROW", boardListVO.getEndRow());

		if (orderByMap.get("orderByCol") != null) {
			map.put("iv_PORDERBYCOL1", orderByMap.get("orderByCol"));
			if (orderByMap.get("orderByColDesc") != null) {
				map.put("iv_PORDERBYCOL1DESC", orderByMap.get("orderByColDesc"));
			}
		}
		
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("rowCount", boardListVO.getEndRow() - (boardListVO.getStartRow() - 1));
		map.put("limit", boardListVO.getStartRow() - 1);
		
		logger.debug("getAllNewItemList ended");
		return ezBoardDAO.getAllNewItemList(map);
	}

	@Override
	public Map<String, Object> getWriterOption(LoginVO userInfo) throws Exception {
		logger.debug("getWriterOption started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TENANT_ID", userInfo.getTenantId());
		map.put("v_CN", userInfo.getId());

		logger.debug("getWriterOption ended");
		return ezOrganDAO.getUserInfoMap(map);
	}

	@Override
	public List<HashMap<String, Object>> getPhotoBoardListItem(String boardID, String userID, int startRow, int endRow, int boardCount, String orderOption1, String orderOption2, Map<String, String> orderByMap, String type, int tenantID, String boardType) throws Exception {
		logger.debug("getPhotoBoardListItem started");
		String pType = type;

		String orderByCol2 = "";
		String orderByCol2Desc = "N";
		
		if (orderByMap.get("orderByCol") == null || "".equals(orderByMap.get("orderByCol"))) {
			orderByMap.put("orderByCol", "PARENTWRITEDATE");
			orderByMap.put("orderByColDesc", "Y");
			orderByCol2 = "UPPERITEMIDTREE";
		}
		
		BoardMyFavoriteVO boardMyFavoriteVO = new BoardMyFavoriteVO();
		boardMyFavoriteVO.setBoardId(boardID);
		boardMyFavoriteVO.setTenantID(tenantID);
		
		String tempString = ezBoardDAO.getBoardApprJoinItem(boardMyFavoriteVO);
		
		/* 2018-09-14 홍승비 - 포틀릿에 표출되는 게시판에서 공지사항 리스트 제거 */
		if (pType.equals("portletBoard")) {
			pType = "1";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		if (orderByMap.get("orderByCol") != null) {
			map.put("iv_PORDERBYCOL1", orderByMap.get("orderByCol"));
			if (orderByMap.get("orderByColDesc") != null) {
				map.put("iv_PORDERBYCOL1DESC", orderByMap.get("orderByColDesc"));
			}
		}
		
		map.put("v_PUSERID", userID);
		map.put("v_PBOARDID", boardID);
		map.put("v_TENANTID", tenantID);
		map.put("type", pType);
		map.put("startRow", startRow);
		map.put("endRow", endRow);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("tempString", tempString);
		map.put("iv_PORDERBYCOL2", orderByCol2);
		map.put("iv_PORDERBYCOL2DESC", orderByCol2Desc);
		map.put("rowCount", endRow - (startRow - 1));
		map.put("limit", startRow - 1);
		map.put("bType", boardType);
		
		logger.debug("getPhotoBoardListItem ended");
		
		return ezBoardDAO.getBoardListItem(map);
	}

	@SuppressWarnings("unchecked")
	@Override
	public JSONObject getMenuSchedule(Map<String, Object> map, JSONObject returnJson) throws Exception {

		SimpleDateFormat orgDateFormat = new SimpleDateFormat("yyyy.MM.dd");
		SimpleDateFormat newDateFormat = new SimpleDateFormat("yyyy-MM-dd");
		String orgStartDate = (String) map.get("date");

		if (orgStartDate == null || "".equals(orgStartDate)) { // 값이 없으면 오늘 날짜 지정
			orgStartDate = orgDateFormat.format(new Date());
		}

		orgStartDate = newDateFormat.format(orgDateFormat.parse(orgStartDate));
		map.put("startDate", orgStartDate);
		
		MealDataVO lunch = ezBoardDAO.getTodayLunch(map);

		if (lunch != null) {
			if ((null != lunch.getaCourse() && !"".equals(lunch.getaCourse()))
				|| (null != lunch.getbCourse() && !"".equals(lunch.getbCourse()))
				|| (null != lunch.getSaladBar() && !"".equals(lunch.getSaladBar()))
				|| (null != lunch.getDessert() && !"".equals(lunch.getDessert()))
			) {
				returnJson.put("RTNVALUE", "OK");
				returnJson.put("lunch", lunch);
			} else {
				returnJson.put("RTNVALUE", "NO_MENU");
			}
		} else {
			returnJson.put("RTNVALUE", "NO_MENU");
		}

		return returnJson;

	}

	@Override
	public void insertItemStarRating(String itemID, String userID, String rating, int tenantID, String companyID, String ratingDate) throws Exception {
		logger.debug("insertItemStarRating started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ITEMID", itemID);
		map.put("v_USERID", userID);
		map.put("v_RATING", rating);
		map.put("v_RATINGDATE", ratingDate);
		map.put("v_TENANTID", tenantID);
		map.put("v_COMPANYID", companyID);

		logger.debug("insertItemStarRating ended");
		ezBoardDAO.insertItemStarRating(map);
	}

	@Override
	public void insertItemStarRatingSummary(String itemID, String totalRaters, String totalScore, String averageScore, int tenantID, String companyID) throws Exception {
		logger.debug("insertItemStarRatingSummary started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ITEMID", itemID);
		map.put("v_TOTALRATERS", totalRaters);
		map.put("v_TOTALSCORE", totalScore);
		map.put("v_AVERAGESCORE", averageScore);
		map.put("v_TENANTID", tenantID);
		map.put("v_COMPANYID", companyID);

		logger.debug("insertItemStarRatingSummary ended");
		ezBoardDAO.insertItemStarRatingSummary(map);
	}

	@Override
	public void updateItemStarRating(String itemID, String userID, String rating, int tenantID, String companyID, String ratingDate) throws Exception {
		logger.debug("updateItemStarRating started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ITEMID", itemID);
		map.put("v_USERID", userID);
		map.put("v_RATING", rating);
		map.put("v_TENANTID", tenantID);
		map.put("v_COMPANYID", companyID);
		map.put("v_RATINGDATE", ratingDate);

		logger.debug("updateItemStarRating ended");
		ezBoardDAO.updateItemStarRating(map);
	}

	@Override
	public void updateItemStarRatingSummary(String itemID, String totalRaters, String totalScore, String averageScore, int tenantID, String companyID) throws Exception {
		logger.debug("updateItemStarRatingSummary started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ITEMID", itemID);
		map.put("v_TOTALRATERS", totalRaters);
		map.put("v_TOTALSCORE", totalScore);
		map.put("v_AVERAGESCORE", averageScore);
		map.put("v_TENANTID", tenantID);
		map.put("v_COMPANYID", companyID);

		logger.debug("updateItemStarRatingSummary ended");
		ezBoardDAO.updateItemStarRatingSummary(map);
	}
	@Override
	public void deleteStarRating(String itemID, int tenantID) throws Exception {
		logger.debug("deleteStarRating started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ITEMID", itemID);
		map.put("v_TENANTID", tenantID);

		logger.debug("deleteStarRating ended");
		ezBoardDAO.deleteStarRating(map);
	}


	@Override
	public void deleteStarRatingSummary(String itemID, int tenantID) throws Exception {
		logger.debug("deleteStarRatingSummary started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ITEMID", itemID);
		map.put("v_TENANTID", tenantID);

		logger.debug("deleteStarRatingSummary ended");
		ezBoardDAO.deleteStarRatingSummary(map);
	}

	@Override
	public Map<String, Object> getItemStarRating(String itemID, String userID, int tenantID) throws Exception {
		logger.debug("getItemStarRating started");
	
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ITEMID", itemID);
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantID);

		Map<String, Object> map2 = ezBoardDAO.getItemStarRating(map);
		int rating = 0;
		int totalScore = 0;
		String averageScore = "0";
		int totalRaters = 0;

		Map<String, Object> resultMap = new HashMap<String, Object>();
		try {
			if (map2 != null) {
				rating = map2.get("RATING") == null ? 0 : Integer.parseInt((String) map2.get("RATING"));
				totalScore = map2.get("TOTALSCORE") == null ? 0 : Integer.parseInt((String) map2.get("TOTALSCORE"));
				averageScore = map2.get("AVERAGESCORE") == null ? "0" : (String) map2.get("AVERAGESCORE");
				totalRaters = map2.get("TOTALRATERS") == null ? 0 : Integer.parseInt((String) map2.get("TOTALRATERS"));
			}
			
			resultMap.put("rating", rating);
			resultMap.put("totalScore", totalScore);
			resultMap.put("averageScore", averageScore);
			resultMap.put("totalRaters", totalRaters);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		logger.debug("getItemStarRating ended");
		return resultMap;
	}
	
	// 게시판 > 별점 평가하기 > 별점 저장 로직
	@Override
	public Map<String, Object> saveItemStarRating(String itemID, String isReRated, int updateRating, LoginVO userInfo) throws Exception {
		
		String userID = userInfo.getId();
		String companyID = userInfo.getCompanyID();
		int tenantID = userInfo.getTenantId();
		String ratingDate = commonUtil.getTodayUTCTime("");
		
		Map<String, Object> map = getItemStarRating(itemID, userID, tenantID);
		int totalScore = (int) map.get("totalScore");
		int totalRaters = (int) map.get("totalRaters");

		int updateTotalScore = 0;
		String updateAverageScore = "";
		double average = 0;

		//처음 평가하는 사용자 : N / 재평가하는 사용자 : Y
		if (isReRated.equals("N")) {
			//총점 : 현재 총점 + 사용자의 점수
			//평가자 수 : 현재 평가자 수 + 사용자(1명)
			//평균 : 총점 / 평가자 수
			updateTotalScore = totalScore + updateRating;
			totalRaters = totalRaters + 1;
			average = (double) updateTotalScore / totalRaters;
			updateAverageScore = (average % 1 == 0) ? String.valueOf((int) average) : String.format("%.1f", average);

			String updateRatingStr = String.valueOf(updateRating);
			String totalRatersStr = String.valueOf(totalRaters);
			String updateTotalScoreStr = String.valueOf(updateTotalScore);

			insertItemStarRating(itemID, userID, updateRatingStr, tenantID, companyID, ratingDate);

			if (totalScore == 0) {
				insertItemStarRatingSummary(itemID, totalRatersStr, updateTotalScoreStr, updateAverageScore, tenantID, companyID);
			} else {
				updateItemStarRatingSummary(itemID, totalRatersStr, updateTotalScoreStr, updateAverageScore, tenantID, companyID);
			}

		} else if (isReRated.equals("Y")) {
			//총점 : 현재 총점 - 기존 점수 + 사용자의 점수
			//평가자 수 : 재평가라서 변화없음
			//평균 : 새 총점 / 평가자 수
			int currentRating = (int) map.get("rating");

			updateTotalScore = totalScore - currentRating + updateRating;
			average = (double) updateTotalScore / totalRaters;
			updateAverageScore = (average % 1 == 0) ? String.valueOf((int) average) : String.format("%.1f", average);

			String updateRatingStr = String.valueOf(updateRating);
			String totalRatersStr = String.valueOf(totalRaters);
			String updateTotalScoreStr = String.valueOf(updateTotalScore);

			updateItemStarRating(itemID, userID, updateRatingStr, tenantID, companyID, ratingDate);
			updateItemStarRatingSummary(itemID, totalRatersStr, updateTotalScoreStr, updateAverageScore, tenantID, companyID);
		}
		
		Map<String, Object> result = new HashMap<>();
		result.put("status", "success");
		result.put("totalRaters", totalRaters);
		result.put("averageScore", updateAverageScore);
		
		return result;
	}

	@Override
	public String getBoardNameLocalizing(String userLang, BoardPropertyVO boardProperty) throws Exception {
		String boardName = boardProperty.getBoardName();
		
		if ("2".equals(userLang) && boardProperty.getBoardName2() != null && !boardProperty.getBoardName2().isEmpty()) {
			boardName = boardProperty.getBoardName2();
		} else if ("3".equals(userLang) && boardProperty.getBoardName3() != null && !boardProperty.getBoardName3().isEmpty()) {
			boardName = boardProperty.getBoardName3();
		} else if ("4".equals(userLang) && boardProperty.getBoardName4() != null && !boardProperty.getBoardName4().isEmpty()) {
			boardName = boardProperty.getBoardName4();
		}
		
		return boardName;
	}
}
