package egovframework.ezMobile.ezBoard.service.impl;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;

import org.json.simple.JSONObject;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezMobile.ezBoard.dao.MBoardDAO;
import egovframework.ezMobile.ezBoard.service.MBoardService;
import egovframework.ezMobile.ezBoard.vo.MBoardAttachVO;
import egovframework.ezMobile.ezBoard.vo.MBoardFavoriteVO;
import egovframework.ezMobile.ezBoard.vo.MBoardInfoVO;
import egovframework.ezMobile.ezBoard.vo.MBoardItemVO;
import egovframework.ezMobile.ezBoard.vo.MBoardListHeaderVO;
import egovframework.ezMobile.ezBoard.vo.MBoardNewListVO;
import egovframework.ezMobile.ezBoard.vo.MBoardTreeVO;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;

@Service("MBoardService")
public class MBoardServiceImpl implements MBoardService {
	private static final Logger logger = LoggerFactory.getLogger(MBoardServiceImpl.class);
	
	final public int mobileListSize = 20;
	final public String newBoardID = "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}";
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name = "MBoardDAO")
	private MBoardDAO mBoardDAO;
	
	@Resource(name = "EzBoardAdminService")
	private EzBoardAdminService ezBoardAdminService;
	
	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Override
	public List<MBoardListHeaderVO> getListHeader(MBoardInfoVO mBoardInfoVO, String lang, int tenantID) throws Exception {
		logger.debug("getListHeader started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", mBoardInfoVO.getBoardID());
		map.put("listType", mBoardInfoVO.getBoardType());
		map.put("lang", lang);
		map.put("tenantID", tenantID);
		
		//모바일은 확장컬럼미사용으로 개발
		List<MBoardListHeaderVO> list = mBoardDAO.getListHeader(map);
		
		logger.debug("getListHeader ended.");
		
		return list;
	}
	
//	public String getBoardListItem(BoardVO boardVO, LoginVO userInfo, String type) throws Exception{
//        String orderOption1 = "";
//        String orderOption2 = "";
//        String strMultiData = commonUtil.getMultiData(boardVO.getLang(), userInfo.getTenantId());
//        String primaryData = commonUtil.getPrimaryData(boardVO.getLang(), userInfo.getTenantId());
//
//        List<BoardListHeaderVO> headerList = ezBoardService.getListHeaderBoardID(boardVO);
//
//        // 헤더 정보를 세팅한다.
//        int i = 0;
//        int hlength = headerList.size(); 
//        int writeDateSN = 0;    //작성일 순번
//        int titleSN = 0;            //제목 순번
//
//        for (i = 0; i < hlength; i++) {
//            if (!boardVO.getOrderCell().equals("") && boardVO.getOrderCell().equals(headerList.get(i).getName())) {
//                if (boardVO.getOrderOption().equals("")) {
//                    orderOption1 = headerList.get(i).getColName() + " ";
//                    orderOption2 = headerList.get(i).getColName() + " DESC ";
//                } else {
//                    orderOption1 = headerList.get(i).getColName() + " DESC ";
//                    orderOption2 = headerList.get(i).getColName() + " ";
//                }
//            }
//            if (headerList.get(i).getColName().toUpperCase().equals("WRITEDATE")) {
//                writeDateSN = i;
//            }
//            if (headerList.get(i).getColName().toUpperCase().equals("TITLE")) {
//                titleSN = i;
//            }
//        }
//        int noticeCount = 0;
//        
//        if (type.equals("1")) {
//        	boardVO.setNowDate(commonUtil.getTodayUTCTime(""));
//        	noticeCount = ezBoardService.getNoticePostItemCount(boardVO);
//        }
//        
//        BoardMyFavoriteVO boardMyFavoriteVO = new BoardMyFavoriteVO();
//        boardMyFavoriteVO.setBoardId(boardVO.getBoardId());
//        boardMyFavoriteVO.setUserId(userInfo.getId());
//        boardMyFavoriteVO.setType(type);
//        boardMyFavoriteVO.setTenantID(userInfo.getTenantId());
//        boardMyFavoriteVO.setNowDate(commonUtil.getTodayUTCTime(""));
//        
//        int boardCount = ezBoardService.getBrdTotalItemCount(boardMyFavoriteVO);
//   
//        int startRow = 1;
//        int endRow = 0;
//
//        BoardConfigVO boardConfigVO = ezBoardService.getPersonalCount(userInfo);
//        
//        int personalCount = boardConfigVO.getListCount();
//        String previewtype = boardConfigVO.getPreview();
//        String fieldName = "";
//        String fieldValue = "";
//        StringBuffer resultXML = new StringBuffer();
//        
//        resultXML.append("<DOCLIST>");
//
//        if (noticeCount > 0 && type.equals("1")) {
//            endRow = (personalCount * boardVO.getPageNum()) - noticeCount;
//            
//            if (endRow < 0) {
//            	endRow = 0;
//            }
//            
//            List<HashMap<String, Object>> noticeList = ezBoardService.getNoticePostItem(boardVO, personalCount);
//
//            int k = 0;
//            int nlength = noticeList.size();
//            
//            resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
//            resultXML.append("<PAGECNT>" + ((int)noticeCount + (int)boardCount) + "</PAGECNT>");
//            resultXML.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>");
//            resultXML.append("<PREVIEWTYPE>" + previewtype + "</PREVIEWTYPE>");
//            resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
//            resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
//            resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
//            resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
//            resultXML.append("<WRITEDATENUM>" + writeDateSN + "</WRITEDATENUM>");
//            resultXML.append("<TITLENUM>" + titleSN + "</TITLENUM>");
//            resultXML.append("<LISTVIEWDATA>");
//            resultXML.append("<HEADERS>");
//            
//            for (BoardListHeaderVO vo:headerList) {
//            	resultXML.append("<HEADER>");
//        		resultXML.append("<NAME>"+vo.getName()+"</NAME>");
//            	resultXML.append("<WIDTH>"+vo.getWidth()+"</WIDTH>");
//            	resultXML.append("<COLNAME>"+vo.getColName()+"</COLNAME>");
//            	resultXML.append("</HEADER>");
//            }
//            resultXML.append("</HEADERS>");
//            resultXML.append("<ROWS>");
//            
//            for (k=0; k < nlength; k++) {
//            	resultXML.append("<ROW>");
//                for (i = 0; i < hlength; i++) {
//                	resultXML.append("<CELL>");
//                    fieldName = headerList.get(i).getColName().toUpperCase();
//                    
//                    if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME")) {
//                        fieldName = fieldName + strMultiData;
//                    }
//                    if (fieldName.equals("WRITEDATE")) {
//                    	fieldValue = commonUtil.getDateStringInUTC((String) noticeList.get(k).get(fieldName), userInfo.getOffset(), false);
//                    	fieldValue = fieldValue.substring(0, fieldValue.length()-3);
//                    } else {
//                    	fieldValue = commonUtil.cleanValue(String.valueOf(noticeList.get(k).get(fieldName)));
//                    }
//                    
//                    if (fieldValue == null || fieldValue.equals(null) || fieldValue.equals("null")) {
//                    	fieldValue = "";
//    				}
//                    
//                    resultXML.append("<VALUE>" + fieldValue + "</VALUE>");
//                    
//                    if (i == 0) {
//                    	resultXML.append("<DATA1>" + noticeList.get(k).get("BOARDID") + "</DATA1>");
//                    	resultXML.append("<DATA2>" + noticeList.get(k).get("ITEMID") + "</DATA2>");
//            			resultXML.append("<DATA3>" + noticeList.get(k).get("WRITERID") + "</DATA3>");
//    					resultXML.append("<DATA4>" + noticeList.get(k).get("IMPORTANCE") + "</DATA4>");
//    					resultXML.append("<DATA5>" + noticeList.get(k).get("READFLAG") + "</DATA5>");
//    					resultXML.append("<DATA6>" + commonUtil.cleanValue((String)noticeList.get(k).get("ABSTRACT")) + "</DATA6>");
//    					String nowDate = commonUtil.getTodayUTCTime("");
//    				    nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
//    				    
//    					if (noticeList.get(k).get("WRITEDATE").toString().compareTo(nowDate) > 0) {
//    						resultXML.append("<DATA7>Y</DATA7>");
//    					} else {
//    						resultXML.append("<DATA7>N</DATA7>");
//    					}
//    					resultXML.append("<DATA8>" + noticeList.get(k).get("ITEMLEVEL") + "</DATA8>");
//    					resultXML.append("<DATA9>" + noticeList.get(k).get("NOTICE") + "</DATA9>");
//    					resultXML.append("<DATA10></DATA10>");
//    					resultXML.append("<DATA11>" + noticeList.get(k).get("ONELINECNT") + "</DATA11>");
//    					resultXML.append("<DATA12>" + commonUtil.cleanValue((String)noticeList.get(k).get("MAINCONTENT")) + "</DATA12>");
//    					resultXML.append("<TITLE>" +  commonUtil.cleanValue((String)noticeList.get(k).get("TITLE"))  + "</TITLE>");
//    					
//    					if (primaryData.equals("1")) {
//    						resultXML.append("<WRITERNAME>" + noticeList.get(k).get("WRITERNAME") + "</WRITERNAME>");
//    						resultXML.append("<WRITERDEPTNAME>" + noticeList.get(k).get("WRITERDEPTNAME") + "</WRITERDEPTNAME>");
//    					} else {
//    						resultXML.append("<WRITERNAME>" + noticeList.get(k).get("WRITERNAME2") + "</WRITERNAME>");
//    						resultXML.append("<WRITERDEPTNAME>" + noticeList.get(k).get("WRITERDEPTNAME2") + "</WRITERDEPTNAME>");
//    					}
//    					resultXML.append("<WRITEDATE>" + commonUtil.getDateStringInUTC((String)noticeList.get(k).get("WRITEDATE"), userInfo.getOffset(), false) + "</WRITEDATE>");
//    					resultXML.append("<ATTACHMENTS>" + noticeList.get(k).get("ATTACHMENTS") + "</ATTACHMENTS>");
//    					resultXML.append("<GUBUN>" + noticeList.get(k).get("GUBUN") + "</GUBUN>");
//                    }
//                    resultXML.append("</CELL>");
//                }
//                resultXML.append("</ROW>");
//            }
//        } else {
//            startRow = ((personalCount * (boardVO.getPageNum() - 1))) + 1;
//            endRow = (personalCount * boardVO.getPageNum());
//
//            resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
//            resultXML.append("<PAGECNT>" + boardCount + "</PAGECNT>");
//            resultXML.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>");
//            resultXML.append("<PREVIEWTYPE>" + previewtype + "</PREVIEWTYPE>");
//            resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
//            resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
//            resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
//            resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
//            resultXML.append("<WRITEDATENUM>" + writeDateSN + "</WRITEDATENUM>");
//            resultXML.append("<TITLENUM>" + titleSN + "</TITLENUM>");
//            resultXML.append("<LISTVIEWDATA>");
//            resultXML.append("<HEADERS>");
//            
//            for (BoardListHeaderVO vo:headerList) {
//            	resultXML.append("<HEADER>");
//        		resultXML.append("<NAME>" + vo.getName() + "</NAME>");
//            	resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
//            	resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
//            	resultXML.append("</HEADER>");
//            }
//            resultXML.append("</HEADERS>");
//            resultXML.append("<ROWS>");
//            
//        }
//        if (boardVO.getPageNum() != 1) {
//            startRow = ((personalCount * (boardVO.getPageNum() - 1)) - noticeCount) + 1;
//            endRow = (personalCount * boardVO.getPageNum()) - noticeCount;
//            
//            if (startRow <= 0) {
//            	startRow = 1;
//            }
//        }
//        
//        List<HashMap<String, Object>> boardListItem = ezBoardService.getBoardListItem(boardVO.getBoardId(), userInfo.getId(), startRow, endRow, boardCount, orderOption1, orderOption2, type, userInfo.getTenantId());
//
//        int dlength = boardListItem.size();
//        
//        for (int j = 0; j < dlength; j++) {
//        	resultXML.append("<ROW>");
//            for (i = 0; i < hlength; i++) {
//            	resultXML.append("<CELL>");
//                fieldName = headerList.get(i).getColName().toUpperCase();
//
//                if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME")) {
//                    fieldName = fieldName + strMultiData;
//                }
//
//                if (fieldName.equals("WRITEDATE")) {
//                	fieldValue = commonUtil.getDateStringInUTC((String) boardListItem.get(j).get(fieldName), userInfo.getOffset(), false);
//                	fieldValue = fieldValue.substring(0, fieldValue.length()-3);
//                } else {
//                    fieldValue = commonUtil.cleanValue(String.valueOf(boardListItem.get(j).get(fieldName)));
//                }
//
//                if (fieldValue == null || fieldValue.equals(null) || fieldValue.equals("null")) {
//                	fieldValue = "";
//				}
//                
//                resultXML.append("<VALUE>" + fieldValue + "</VALUE>");
//                
//                if (i == 0) {
//                	resultXML.append("<DATA1>" + boardListItem.get(j).get("BOARDID") + "</DATA1>");
//                	resultXML.append("<DATA2>" + boardListItem.get(j).get("ITEMID") + "</DATA2>");
//        			resultXML.append("<DATA3>" + boardListItem.get(j).get("WRITERID") + "</DATA3>");
//					resultXML.append("<DATA4>" + boardListItem.get(j).get("IMPORTANCE") + "</DATA4>");
//					resultXML.append("<DATA5>" + boardListItem.get(j).get("READFLAG") + "</DATA5>");
//					resultXML.append("<DATA6>" + commonUtil.cleanValue((String)boardListItem.get(j).get("ABSTRACT")) + "</DATA6>");
//					String nowDate = commonUtil.getTodayUTCTime("");
//				    nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
//				    
//					if (boardListItem.get(j).get("WRITEDATE").toString().compareTo(nowDate) > 0) {
//						resultXML.append("<DATA7>Y</DATA7>");
//					} else {
//						resultXML.append("<DATA7>N</DATA7>");
//					}
//					resultXML.append("<DATA8>" + boardListItem.get(j).get("ITEMLEVEL") + "</DATA8>");
//					resultXML.append("<DATA9>" + boardListItem.get(j).get("NOTICE") + "</DATA9>");
//					resultXML.append("<DATA10></DATA10>");
//					resultXML.append("<DATA11>" + boardListItem.get(j).get("ONELINECNT") + "</DATA11>");
//					resultXML.append("<DATA12>" + commonUtil.cleanValue((String)boardListItem.get(j).get("MAINCONTENT")) + "</DATA12>");
//					resultXML.append("<TITLE>" + commonUtil.cleanValue((String)boardListItem.get(j).get("TITLE")) + "</TITLE>");
//					resultXML.append("<WRITERNAME>" + boardListItem.get(j).get("WRITERNAME") + "</WRITERNAME>");
//					resultXML.append("<WRITERNAME2>" + boardListItem.get(j).get("WRITERNAME2") + "</WRITERNAME2>");
//					resultXML.append("<WRITERDEPTNAME>" + boardListItem.get(j).get("WRITERDEPTNAME") + "</WRITERDEPTNAME>");
//					resultXML.append("<WRITERDEPTNAME2>" + boardListItem.get(j).get("WRITERDEPTNAME2") + "</WRITERDEPTNAME2>");
//					resultXML.append("<WRITEDATE>" + commonUtil.getDateStringInUTC((String)boardListItem.get(j).get("WRITEDATE"), userInfo.getOffset(), false) + "</WRITEDATE>");
//					resultXML.append("<ATTACHMENTS>" + boardListItem.get(j).get("ATTACHMENTS") + "</ATTACHMENTS>");
//					resultXML.append("<GUBUN>" + boardListItem.get(j).get("GUBUN") + "</GUBUN>");
//                }
//                resultXML.append("</CELL>");
//            }
//            resultXML.append("</ROW>");
//        }
//        resultXML.append("</ROWS>");
//        resultXML.append("</LISTVIEWDATA>");
//        resultXML.append("</DOCLIST>");
//        
//        return resultXML.toString();
//    }
	
	@Override
	public List<MBoardItemVO> getBoardItemList(MBoardInfoVO mBoardInfoVO, MCommonVO info, String lastDate,String userID,String add) throws Exception {
		logger.debug("getBoardItemList started.");
		
		String boardID = mBoardInfoVO.getBoardID();
		String gubun = mBoardInfoVO.getGuBun();
		int page = mBoardInfoVO.getPage() != 0 ? mBoardInfoVO.getPage() : 1; 
		
		String offset = info.getOffSet();
		int tenantID = info.getTenantId();
		
		List<MBoardItemVO> mBoardNoticeItemList = getNoticePostItemList(boardID, userID, gubun, page, tenantID, offset);
		
		//임시로 10으로 지정
		int listSize = 10;
        
		int boardCount = getBoardItemListCount(boardID, userID, gubun, tenantID);
		List<MBoardItemVO> mBoardItemList = getBoardItemList(boardID, userID, gubun, listSize, boardCount, lastDate,tenantID, offset);
		
		//게시물 writeDate와 현재시간을 비교해서 게시한지 하루 이전의 게시물은 newItemFlag Y로 set
		String nowDate = commonUtil.getTodayUTCTime("");
	    nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
		for (MBoardItemVO vo : mBoardItemList) {
			if (vo.getWriteDate().toString().compareTo(nowDate) > 0) {
				vo.setNewItemFlag("Y");
			} else {
				vo.setNewItemFlag("N");
			}
		}
		
		//스크롤 페이징할 때 공지사항 추가 안되게 add를 받아옴
		if (add == null || add.equals("")) {
			for (MBoardItemVO vo : mBoardNoticeItemList) {
				mBoardItemList.add(0, vo);
			}
		}
		
		logger.debug("getBoardItemList ended.");
		
		return mBoardItemList;
	}


	@Override
	public List<MBoardNewListVO> getNewBoarditemList(MBoardInfoVO mBoardInfoVO, MCommonVO info, String userID) throws Exception {
		String boardID = mBoardInfoVO.getBoardID();
		String gubun = mBoardInfoVO.getGuBun();
		int page = mBoardInfoVO.getPage() != 0 ? mBoardInfoVO.getPage() : 1; 
		
		String offset = info.getOffSet();
		int tenantID = info.getTenantId();
		
		/** 공지사항 카운트 및 리스트 */
		Integer noticeCount = 0;
		if (((gubun == null || !gubun.equals("2") || !gubun.equals("3")) ? "1" : gubun).equals("1")) {
			noticeCount = getNoticePostItemListCount(boardID, userID, gubun, tenantID);
		}
		
		/** 전체 리스트 카운트 및 리스트 */
		int startRow = ((mobileListSize * (page - 1)) - noticeCount) + 1;
        int endRow = (mobileListSize * page) - noticeCount;
		
        int boardCount = getBoardItemListCount(boardID, userID, gubun, tenantID);
        
        List<MBoardNewListVO> mBoardItemList = getNewBoardItemList(boardID, userID, gubun, startRow, endRow, boardCount, tenantID, offset);
        
		return mBoardItemList;
	}

	//게시판 정보조회 -> MBoardInfoVO.parentBoardID 불필요시 추후 삭제
	@Override
	public MBoardInfoVO getBoardInfo(MBoardInfoVO mBoardInfoVO, String rollInfo, String deptPathCode, MCommonVO info) throws Exception {
		mBoardInfoVO.setSs_board_maxRows(mobileListSize);
		mBoardInfoVO.setSs_searchBoard_maxRows(mobileListSize);
		
		String deptPath = deptPathCode;
	    String deptPathOrgan="";
	    
	    for (int ch=0; ch<deptPath.split(",").length; ch++) {
	        if (ch == 0) {
	        	deptPathOrgan+=deptPath.split(",")[ch].trim();
	        } else {
	        	deptPathOrgan+=","+deptPath.split(",")[deptPath.split(",").length-(ch)].trim();
	        }
	    }
	    
	    String userDeptPath = deptPathOrgan+",everyone";
	    
		for (String userDept : userDeptPath.split(",")) {
			MBoardInfoVO aclVO = getACL(mBoardInfoVO, userDept.trim(), info.getTenantId());
			
			if (aclVO == null) {
				break;
			} else {
				mBoardInfoVO.setBoardID(aclVO.getBoardID());
				mBoardInfoVO.setAccessID(aclVO.getAccessID());
				mBoardInfoVO.setAccessLevel(aclVO.getAccessLevel());
				mBoardInfoVO.setAccess_(aclVO.getAccess_());
				mBoardInfoVO.setParentBoardID(aclVO.getParentBoardID());
				mBoardInfoVO.setBoardAdmin_FG(aclVO.getBoardAdmin_FG());
				mBoardInfoVO.setListView_FG(aclVO.getListView_FG());
				mBoardInfoVO.setRead_FG(aclVO.getRead_FG());
				mBoardInfoVO.setWrite_FG(aclVO.getWrite_FG());
				mBoardInfoVO.setReply_FG(aclVO.getReply_FG());
				mBoardInfoVO.setDelete_FG(aclVO.getDelete_FG());
				mBoardInfoVO.setInherit_FG(aclVO.getInherit_FG());
				mBoardInfoVO.setPostNotice(aclVO.getPostNotice());
				mBoardInfoVO.setBoardGroupACL(aclVO.getBoardGroupACL());
			}
		}
		
		String boardGroupAdmin_FG = ezBoardAdminService.checkIfBoardGroupAdmin(mBoardInfoVO.getBoardID(), info.getUserId(), info.getDeptId(), info.getCompanyId(), info.getTenantId());
		mBoardInfoVO.setBoardGroupAdmin_FG(boardGroupAdmin_FG);
		
	    if (mBoardInfoVO.getBoardID().equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) {
	    	mBoardInfoVO.setAccess_FG("1");
	    	mBoardInfoVO.setBoardAdmin_FG("false");
	    	mBoardInfoVO.setListView_FG("true");
	    	mBoardInfoVO.setRead_FG("true");
	    	mBoardInfoVO.setWrite_FG("true");
	    	mBoardInfoVO.setReply_FG("true");
	    	mBoardInfoVO.setDelete_FG("true");
		} else if (rollInfo != null && (rollInfo.toLowerCase().indexOf("c=1") > -1 || rollInfo.toLowerCase().indexOf("k=1") > -1 || rollInfo.toLowerCase().indexOf("n=1") > -1)) {
			mBoardInfoVO.setAccess_FG("1");
			mBoardInfoVO.setBoardAdmin_FG("true");
			mBoardInfoVO.setListView_FG("true");
			mBoardInfoVO.setRead_FG("true");
			mBoardInfoVO.setWrite_FG("true");
			mBoardInfoVO.setReply_FG("true");
			mBoardInfoVO.setDelete_FG("true");
		} else if (mBoardInfoVO.getBoardGroupAdmin_FG() != null && mBoardInfoVO.getBoardGroupAdmin_FG().equals("OK")) {
			mBoardInfoVO.setAccess_FG("1");
			mBoardInfoVO.setBoardAdmin_FG("true");
			mBoardInfoVO.setListView_FG("true");
			mBoardInfoVO.setRead_FG("true");
			mBoardInfoVO.setWrite_FG("true");
			mBoardInfoVO.setReply_FG("true");
			mBoardInfoVO.setDelete_FG("true");
		} else if (mBoardInfoVO.getBoardAdmin_FG() == null || mBoardInfoVO.getBoardAdmin_FG().equals("")) {
			mBoardInfoVO.setAccess_FG("1");
			mBoardInfoVO.setBoardAdmin_FG("false");
			mBoardInfoVO.setListView_FG("false");
			mBoardInfoVO.setRead_FG("false");
			mBoardInfoVO.setWrite_FG("false");
			mBoardInfoVO.setReply_FG("false");
			mBoardInfoVO.setDelete_FG("false");
		}
		
		return mBoardInfoVO;
	}

	@Override
	public MBoardInfoVO getBoardProperty(String boardID, String primary, int tenantID) throws Exception {
		logger.debug("getBoardProperty started.");
		logger.debug("boardID = " + boardID + " || primary = " + primary + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", boardID);
		map.put("primary", primary);
		map.put("tenantID", tenantID);
		
		MBoardInfoVO vo = mBoardDAO.getBoardProperty(map);
		
		if (vo.getBoardID().equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) {
			vo.setType("newBoardItemList");
		} else {
			vo.setType("boardItemList");
		}
		
		if (vo.getGuBun().equals("4")) {
			vo.setType("photoBoardItem");
		}
		
		logger.debug("getBoardProperty ended.");
		
		return vo;
	}

	private MBoardInfoVO getACL(MBoardInfoVO vo, String userDeptPath, int tenantID) throws Exception {
		logger.debug("getACL started.");
		logger.debug("boardID = " + vo.getBoardID() + " || userDeptPath = " + userDeptPath + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", vo.getBoardID());
		map.put("userDeptPath", userDeptPath);
		map.put("tenantID", tenantID);
		
		vo = mBoardDAO.getACL(map);
		
		logger.debug("getACL ended.");
		
		return vo;
	}
	
	private List<MBoardItemVO> getBoardItemList(String boardID, String userID, String gubun, int listSize, int boardItemListCount, String lastDate, int tenantID, String offset) throws Exception {
		logger.debug("getBoarditemList started.");
		logger.debug("boardID = " + boardID + " || userID = " + userID + " || gubun = " + gubun + " || boardItemListCount = " + boardItemListCount + " || tenantID = " + tenantID + " || lastDate = " + lastDate);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", boardID);
		map.put("userID", userID);
		map.put("gubun", (gubun == null || !gubun.equals("2") || !gubun.equals("3")) ? "1" : gubun);
		map.put("listSize", listSize);
		map.put("lastDate", lastDate);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantID", tenantID);
		
		List<MBoardItemVO> list = mBoardDAO.getBoardItemList(map);
		
		logger.debug("getBoarditemList ended.");
		
		return list;
	}
	
	private List<MBoardItemVO> getNoticePostItemList(String boardID, String userID, String gubun, int pageNum, int tenantID, String offset) throws Exception {
		logger.debug("getNoticePostItemList started");
		logger.debug("boardID = " + boardID + " || userID = " + userID + " || gubun = " + gubun + " pageNum = " + pageNum + " || tenantID = " + tenantID);
		
		int startRow = ((pageNum - 1) * mobileListSize) + 1;
	 	int endRow = (pageNum * mobileListSize); 
				
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", boardID);
		map.put("userID", userID);
		//Oracle
		map.put("startRow", startRow);
		map.put("endRow", endRow);
		//Maria
		map.put("rowCount", endRow - (startRow - 1));
		map.put("limit", startRow - 1);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantID", tenantID);
		
    	String apprFlag = mBoardDAO.getBoardApprFlag(map);
		
		if (apprFlag != null && apprFlag.equals("Y")) {
			map.put("apprFlag", apprFlag);
		}
		
		List<MBoardItemVO> list = mBoardDAO.getNoticePostItemList(map);
		
		logger.debug("getNoticePostItemList ended.");
		
		return list;
	}
	
	private List<MBoardNewListVO> getNewBoardItemList(String boardID, String userID, String gubun, int startRow, int endRow, int boardItemListCount, int tenantID, String offset) throws Exception {
		logger.debug("getNewBoardItemList started.");
		logger.debug("boardID = " + boardID + " || userID = " + userID + " || gubun = " + gubun + " || startRow = " + startRow + " || endRow = " + endRow + " || boardItemListCount = " + boardItemListCount + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", boardID);
		map.put("userID", userID);
		map.put("gubun", (gubun == null || !gubun.equals("2") || !gubun.equals("3")) ? "1" : gubun);
		//Oracle
		map.put("startRow", startRow);
		map.put("endRow", endRow);
		//Maria
		map.put("rowCount", endRow - (startRow - 1));
		map.put("limit", startRow - 1);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantID", tenantID);
		
		List<MBoardNewListVO> list = mBoardDAO.getNewItemList(map);
		
		logger.debug("getNewBoardItemList ended.");
		
		return list;
	}
	
	@Override
	public int getBoardItemListCount(String boardID, String userID, String gubun, int tenantID) throws Exception {
		logger.debug("getBoardItemListCount started.");
		logger.debug("boardID = " + boardID + " || userID = " + userID + " || gubun = " + gubun + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", boardID);
		map.put("userID", userID);
		map.put("gubun", (gubun == null || !gubun.equals("2") || !gubun.equals("3")) ? "1" : gubun);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantID);
		
		String apprFlag = mBoardDAO.getBoardApprFlag(map);
		
		if (apprFlag != null && apprFlag.equals("Y")) {
			map.put("apprFlag", apprFlag);
		}
		
		int result = mBoardDAO.getBoardItemListCount(map);
		
		logger.debug("getBoardItemListCount ended. result = " + result);
		
		return result;
	}
	
	private int getNoticePostItemListCount(String boardID, String userID, String gubun, int tenantID) throws Exception {
		logger.debug("getNoticePostItemListCount started.");
		logger.debug("boardID = " + boardID + " || userID = " + userID + " || gubun = " + gubun + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", boardID);
		map.put("userID", userID);
		map.put("gubun", (gubun == null || !gubun.equals("2") || !gubun.equals("3")) ? "1" : gubun);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantID);
		
		String apprFlag = mBoardDAO.getBoardApprFlag(map);
		
		if (apprFlag != null && apprFlag.equals("Y")) {
			map.put("apprFlag", apprFlag);
		}
		
		int result = mBoardDAO.getNoticePostItemListCount(map);
		
		logger.debug("getNoticePostItemListCount ended. result = " + result);
		
		return result;
	}

	@Override
	public List<MBoardFavoriteVO> getFavoriteList(String userID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("tenantID", tenantID);
		return mBoardDAO.getFavoriteList(map);
	}

	@Override
	public MBoardItemVO getBrdItemInfo(String itemID, String lang, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("itemID", itemID);
		map.put("tenantID", tenantID);
		map.put("lang", lang);
		return mBoardDAO.getBrdItemInfo(map);
	}

	@Override
	public void insertBrdItem(JSONObject boardListVO, MCommonVO info, String realPath, String mhtData) throws Exception {
		int tenantID = info.getTenantId();
		String offset = info.getOffSet();
		boolean saveMHTResult = false;
		String filePath = commonUtil.getUploadPath("upload_board.ROOT", info.getTenantId());
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("itemID", boardListVO.get("itemID"));
		map.put("boardID", boardListVO.get("boardID"));
		map.put("writerID", boardListVO.get("userID"));
		map.put("writerName", info.getUserName());
		map.put("writerName2", info.getUserName2());
		map.put("writerDeptID", info.getDeptId());
		map.put("writerDeptName", info.getDeptName());
		map.put("writerDeptName2", info.getDeptName2());
		map.put("writerCompanyID", info.getCompanyId());
		map.put("writerCompanyName", info.getCompanyName());
		map.put("writerCompanyName2", info.getCompanyName2());
		map.put("writeDate", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", info.getTenantId());
		map.put("importance", boardListVO.get("importance"));
		map.put("title", boardListVO.get("title"));
		map.put("contentLocation", commonUtil.getUploadPath("upload_board.ROOT", tenantID) + commonUtil.separator + boardListVO.get("boardID") + commonUtil.separator + "doc" + commonUtil.separator + boardListVO.get("itemID") + ".mht");
		
		if (boardListVO.get("startDate") != null && !boardListVO.get("startDate").equals("")) {
			map.put("startDate", commonUtil.getDateStringInUTC(String.valueOf(boardListVO.get("startDate")), offset, true));
			map.put("writeDate", commonUtil.getTodayUTCTime(""));
		} else {
			map.put("startDate", commonUtil.getTodayUTCTime(""));
		}
		
		//모바일에서는 영구게시만 지원
		map.put("endDate", "9999-12-30 14:59:59");
		map.put("abstract", boardListVO.get("abstract"));
		map.put("hasAttach", boardListVO.get("hasAttach"));
		
		map.put("upperItemIDTree", boardListVO.get("upperItemIDTree"));
		//새로 작성할때는 1로 fix
		map.put("itemLevel", "1");
		//리플이나 수정일때는 값받아와야함.
		map.put("parentWriteDate", "docNO");
		map.put("extensionAttribute1", "0");
		//공지사항 여부
		map.put("extensionAttribute2", boardListVO.get("notice"));
		map.put("extensionAttribute3", boardListVO.get("extensionAttribute3"));
		map.put("extensionAttribute32", boardListVO.get("extensionAttribute32"));
		map.put("extensionAttribute4", boardListVO.get("extensionAttribute4"));
		map.put("extensionAttribute5", boardListVO.get("extensionAttribute5"));
		map.put("docPassword", boardListVO.get("docPassword"));
		map.put("topWriterID", boardListVO.get("topWriterID"));
		map.put("extensionAttribute6", boardListVO.get("extensionAttribute6"));
		map.put("extensionAttribute7", boardListVO.get("extensionAttribute7"));
		map.put("extensionAttribute8", boardListVO.get("extensionAttribute8"));
		map.put("extensionAttribute9", boardListVO.get("extensionAttribute9"));
		map.put("extensionAttribute10", boardListVO.get("extensionAttribute10"));
		
		//mht파일저장
		saveMHTResult = saveMHT(mhtData, boardListVO.get("itemID").toString(), boardListVO.get("boardID").toString(), filePath, "BOARD", realPath);

		mBoardDAO.insertBrdItem(map);
	}
	
	@Override
	public void updateItem(JSONObject boardListVO, MCommonVO info, String realPath, String mhtData) throws Exception {
		boolean saveMHTResult = false;
		String filePath = commonUtil.getUploadPath("upload_board.ROOT", info.getTenantId());
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("writeDate", commonUtil.getTodayUTCTime(""));
		map.put("importance", boardListVO.get("importance"));
		map.put("title", boardListVO.get("title"));
		//map.put("startDate", boardListVO.get("startDate"));
		//map.put("endDate", boardListVO.get("endDate"));
		map.put("abstract", boardListVO.get("abstract"));
		map.put("hasAttach", boardListVO.get("hasAttach"));
		map.put("writerName", boardListVO.get("writerName"));
		map.put("writerName2", boardListVO.get("writerName2"));
		map.put("extensionAttribute2", boardListVO.get("notice"));
		map.put("extensionAttribute5", boardListVO.get("extensionAttribute5"));
		map.put("docPassword", boardListVO.get("docPassword"));
		map.put("extensionAttribute6", boardListVO.get("extensionAttribute6"));
		map.put("extensionAttribute7", boardListVO.get("extensionAttribute7"));
		map.put("extensionAttribute8", boardListVO.get("extensionAttribute8"));
		map.put("extensionAttribute9", boardListVO.get("extensionAttribute9"));
		map.put("extensionAttribute10", boardListVO.get("extensionAttribute10"));
		map.put("tenantID", info.getTenantId());
		map.put("itemID", boardListVO.get("itemID"));
		
		//mht파일저장
		saveMHTResult = saveMHT(mhtData, boardListVO.get("itemID").toString(), boardListVO.get("boardID").toString(), filePath, "BOARD", realPath);
		
		mBoardDAO.updateItem(map);
	}
	
	/**
	 * 게시판 mht저장 실행 Method
	 */
	public boolean saveMHT(String strHTML, String strMHTFilename, String strBoardID, String strFilePath, String strType, String realPath) throws Exception{
System.out.println("saveMHT start");
System.out.println("strHTML:"+strHTML);
System.out.println("strFilePath:"+strFilePath);
		String docPath = "";
		String mhtFilePath = "";
		boolean ret = true;
		
        if (strType.equals("BOARD")) {
            strHTML = strHTML.replace("'", "''");
        }
        
		docPath = strFilePath + commonUtil.separator + strBoardID;
		mhtFilePath = strMHTFilename + ".mht";
		
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
		
		InputStream stream = null;
		OutputStream bos = null;
		
		try {
			stream = new ByteArrayInputStream(strHTML.getBytes("UTF-8"));
			bos = new FileOutputStream(realPath + stordFilePathReal + commonUtil.separator + mhtFilePath);
			
			int bytesRead = 0;
			byte[] buffer = new byte[2048];
			
			while ((bytesRead = stream.read(buffer, 0, 2048)) != -1) {
				bos.write(buffer, 0, bytesRead);
			}
			
			ret = true;
		} catch (Exception e) {
			ret = false;
		} finally {
			if(bos != null){
				bos.close();
			}
			if(stream != null){
				stream.close();
			}
		}
		
		return ret;
	}
	
	@Override
	public void insertBrdItem2(JSONObject boardListVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("itemID", boardListVO.get("itemID"));
		map.put("boardID", boardListVO.get("boardID"));
		map.put("writerID", boardListVO.get("writerID"));
		map.put("writerName", boardListVO.get("writerName"));
		map.put("writerName2", boardListVO.get("writerName2"));
		map.put("writerDeptID", boardListVO.get("writerDeptID"));
		map.put("writerDeptName", boardListVO.get("writerDeptName"));
		map.put("writerDeptName2", boardListVO.get("writerDeptName2"));
		map.put("writerCompanyID", boardListVO.get("writerCompanyID"));
		map.put("writerCompanyName", boardListVO.get("writerCompanyName"));
		map.put("writerCompanyName2", boardListVO.get("writerCompanyName2"));
		map.put("writeDate", commonUtil.getTodayUTCTime(""));
		map.put("parentWriteDate", boardListVO.get("parentWriteDate"));
		map.put("tenantID", boardListVO.get("tenantID"));
		map.put("importance", boardListVO.get("importance"));
		map.put("title", boardListVO.get("title"));
		map.put("contentLocation", boardListVO.get("contentLocation"));
		map.put("startDate", boardListVO.get("startDate"));
		map.put("endDate", boardListVO.get("endDate"));
		map.put("abstract", boardListVO.get("abstract"));
		map.put("hasAttach", boardListVO.get("hasAttach"));
		map.put("upperItemIDTree", boardListVO.get("upperItemIDTree"));
		map.put("itemLevel", boardListVO.get("itemLevel"));
		map.put("extensionAttribute1", boardListVO.get("extensionAttribute1"));
		map.put("extensionAttribute2", boardListVO.get("extensionAttribute2"));
		map.put("extensionAttribute3", boardListVO.get("extensionAttribute3"));
		map.put("extensionAttribute32", boardListVO.get("extensionAttribute32"));
		map.put("extensionAttribute4", boardListVO.get("extensionAttribute4"));
		map.put("extensionAttribute5", boardListVO.get("extensionAttribute5"));
		map.put("docPassword", boardListVO.get("docPassword"));
		map.put("topWriterID", boardListVO.get("topWriterID"));
		map.put("extensionAttribute6", boardListVO.get("extensionAttribute6"));
		map.put("extensionAttribute7", boardListVO.get("extensionAttribute7"));
		map.put("extensionAttribute8", boardListVO.get("extensionAttribute8"));
		map.put("extensionAttribute9", boardListVO.get("extensionAttribute9"));
		map.put("extensionAttribute10", boardListVO.get("extensionAttribute10"));
		mBoardDAO.insertBrdItem2(map);
	}

	@Override
	public void deleteItem(String itemID, String boardID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("itemID", itemID);
		map.put("boardID", boardID);
		map.put("tenantID", tenantID);
		
		mBoardDAO.deleteBoardItem(map);
		mBoardDAO.deleteBoardReply(map);
		mBoardDAO.deleteBoardItemRead2(map);
		
		mBoardDAO.insertDeleteReservedItem(map);
	}

	@Override
	public List<MBoardTreeVO> brdBoardTree(String rootBoardID, String accessID, int mode, int selectBy, String excludeBoardID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("rootBoardID", rootBoardID);
		map.put("userID", accessID);
		map.put("deptID", "");
		map.put("companyID","");
		map.put("mode", mode);
		map.put("selectBy", selectBy);
		map.put("excludeBoardID", excludeBoardID);
		map.put("tenantID", tenantID);
		
		return mBoardDAO.brdBoardTree(map);
	}

	@Override
	public String checkIfBoardGroupAdmin(String rootBoardID, String userID, String deptID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", rootBoardID);
		map.put("userID", userID);
		map.put("deptID", deptID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		return mBoardDAO.checkIfBoardGroupAdmin(map);
	}

	@Override
	public List<MBoardNewListVO> getNewBoardList(String userID, String lastDate, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		//mainList 임시 10까지
		map.put("listSize", 10);
		map.put("lastDate", lastDate);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantID);
		return mBoardDAO.getNewItemList(map);
	}

	@Override
	public List<MBoardNewListVO> getBoardMainList(String userID, String listCnt, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("listSize", listCnt);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantID);
		return mBoardDAO.getNewItemList(map);
	}

	@Override
	public List<MBoardTreeVO> getBoardTree(String rootBoardID, int mode, int subFlag, int selectBy, String excludeBoardID, MCommonVO info) throws Exception {
		String rollInfo = info.getRollInfo();
		int tenantID = info.getTenantId();
		String strForbiddenBoardIDList = "";
		String boardGroupAdminFg = checkIfBoardGroupAdmin(rootBoardID, info.getUserId(), info.getDeptId(), info.getCompanyId(), info.getTenantId());
		
	    if (rollInfo != null && (boardGroupAdminFg.equals("OK") || rollInfo.toLowerCase().indexOf("c=1") > -1 || rollInfo.toLowerCase().indexOf("k=1") > -1 || rollInfo.toLowerCase().indexOf("n=1") > -1)) {
	    	mode = 0;
	    } else {
	    	mode = 1;
	    }
	    
	    String accessID = info.getUserId() + "," + ezOrganService.getDeptFullPath(info.getDeptId(), tenantID) + ",everyone";
	    String strLang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
		
	    
	    //String pAccessID = userId + "," + ezOrganService.getDeptFullPath(pDeptID, tenantID) + ",everyone";
        //String strRollInfo = ezOrganService.getPropertyValue(pUserID, "extensionattribute1", tenantID);
	    
		//List<MBoardTreeVO> list = brdBoardTree(rootBoardID, userId, mode, selectBy, excludeBoardID, info.getTenantId());
	    
	    List<MBoardTreeVO> brdBoardTreeList = new ArrayList<MBoardTreeVO>();
	    for (int i = 0; i < accessID.split(",").length; i++) {
            String boardID = "";
            
            if (mode == 0) {
            	brdBoardTreeList = brdBoardTree(rootBoardID, "everyone", mode, selectBy, excludeBoardID, tenantID);            
            } else {
            	List<MBoardTreeVO> tempBrdBoardTreeList = brdBoardTree(rootBoardID, accessID.split(",")[i].trim(), mode, selectBy, excludeBoardID, tenantID);
            	
            	if (tempBrdBoardTreeList != null && tempBrdBoardTreeList.size() > 0) {
            		for (MBoardTreeVO k : tempBrdBoardTreeList) {
            			if (brdBoardTreeList.size() > 0) {
            				int tempCnt = 0;
            				
            				for (MBoardTreeVO h : brdBoardTreeList) {
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
            }
            
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("accessID", accessID.split(",")[i].trim());
            map.put("rootBoardID", rootBoardID);
            map.put("tenantID", tenantID);
            List<MBoardInfoVO> boardTreeList = mBoardDAO.getBoardTreeGet2(map);
            
            if (boardTreeList.size() > 0) {
                for (int r = 0; r < boardTreeList.size(); r++) {
            		boardID = boardTreeList.get(r).getBoardID().split(",")[0];
        			strForbiddenBoardIDList += boardID.trim();
                }
            }
        }
	    
	    //오름차순 정렬
	    Collections.sort(brdBoardTreeList, new Comparator<MBoardTreeVO>() {
			@Override
			public int compare(MBoardTreeVO o1, MBoardTreeVO o2) {
				return Integer.parseInt(o1.getTreeViewOrder()) > Integer.parseInt(o2.getTreeViewOrder()) ? 1 : 0;
			}
		});
	    
	    

		return brdBoardTreeList;
	}

	@Override
	public Integer getNewBoardListCount(String userID, String startDate,int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("tenantID", tenantID);
		map.put("startDate", startDate);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		return mBoardDAO.getNewBoardListCount(map);
	}

	@Override
	public void insertFavorite(String userID, String boardID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("tenantID", tenantID);
		map.put("boardID", boardID);
		mBoardDAO.insertFavorite(map);
	}

	@Override
	public void deleteFavorite(String userID, String boardID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("tenantID", tenantID);
		map.put("boardID", boardID);
		mBoardDAO.deleteFavorite(map);
	}

	@Override
	public List<MBoardAttachVO> getAttachList(String itemID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("itemID", itemID);
		map.put("tenantID", tenantID);
		return mBoardDAO.getAttachList(map);
	}

	@Override
	public String getDeptPathCode(String departmentID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("departmentID", departmentID);
		map.put("tenantID", tenantID);
		return mBoardDAO.getDeptPathCode(map);
	}

	@Override
	public String getMhtContent(String realPath, String domain, MCommonVO userInfo, String url,Locale locale) throws Exception {
		String filePath = "";
		String uploadModule = commonUtil.getUploadPath("upload_common.MHTIMAGE", userInfo.getTenantId()) + commonUtil.separator;
		
		filePath = realPath + uploadModule;
		
	    File file = new File(filePath);
	        
	    if (!file.exists()) {
	    	file.mkdir();
	    }
	    
	    String m_strMHT = "";
        
        try {
    		m_strMHT = ezCommonService.loadMHTFile(realPath + url);
		} catch (Exception e) {
			m_strMHT= "";
		}
	    
        String strHTML = ezCommonService.startMHT2HTML(filePath, m_strMHT, filePath, realPath, locale, domain);
        logger.debug("strHTML : " + strHTML);
        
        Document doc = Jsoup.parse(strHTML);
        
        String bodyHTML = doc.getElementsByTag("BODY").html();
        
		return bodyHTML;
	}

	@Override
	public List<MBoardAttachVO> photoViewDB(String itemID, String boardID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("itemID", itemID);
		map.put("boardID", boardID);
		map.put("tenantID", tenantID);
		return mBoardDAO.photoViewDB(map);
	}

	@Override
	public Integer photoViewDBCount(String itemID, String boardID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("itemID", itemID);
		map.put("boardID", boardID);
		map.put("tenantID", tenantID);
		return mBoardDAO.photoViewDBCount(map);
	}
	
	
	
}
