package egovframework.ezMobile.ezBoard.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezMobile.ezBoard.dao.MBoardDAO;
import egovframework.ezMobile.ezBoard.service.MBoardService;
import egovframework.ezMobile.ezBoard.vo.MBoardInfoVO;
import egovframework.ezMobile.ezBoard.vo.MBoardItemVO;
import egovframework.ezMobile.ezBoard.vo.MBoardListHeaderVO;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.user.login.vo.LoginVO;
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
	public List<MBoardItemVO> getBoardItemList(MBoardInfoVO mBoardInfoVO, MCommonVO info, String userID) throws Exception {
		logger.debug("getBoardItemList started.");
		
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
		
		List<MBoardItemVO> mBoardNoticeItemList = getNoticePostItemList(boardID, userID, gubun, page, tenantID, offset);
        
		/** 전체 리스트 카운트 및 리스트 */
		int startRow = ((mobileListSize * (page - 1)) - noticeCount) + 1;
        int endRow = (mobileListSize * page) - noticeCount;
        
        if (startRow <= 0) {
        	startRow = 1;
        }
        
		int boardCount = getBoardItemListCount(boardID, userID, gubun, tenantID);
		List<MBoardItemVO> mBoardItemList = getBoardItemList(boardID, userID, gubun, startRow, endRow, boardCount, tenantID, offset);
		
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
		
		for (MBoardItemVO vo : mBoardNoticeItemList) {
			mBoardItemList.add(0, vo);
		}
		
		logger.debug("getBoardItemList ended.");
		
		return mBoardItemList;
	}


	@Override
	public List<MBoardItemVO> getNewBoarditemList(MBoardInfoVO mBoardInfoVO, MCommonVO info, String userID) throws Exception {
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
        
        List<MBoardItemVO> mBoardItemList = getNewBoardItemList(boardID, userID, gubun, startRow, endRow, boardCount, tenantID, offset);
        
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
	
	private List<MBoardItemVO> getBoardItemList(String boardID, String userID, String gubun, int startRow, int endRow, int boardItemListCount, int tenantID, String offset) throws Exception {
		logger.debug("getBoarditemList started.");
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
	
	private List<MBoardItemVO> getNewBoardItemList(String boardID, String userID, String gubun, int startRow, int endRow, int boardItemListCount, int tenantID, String offset) throws Exception {
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
		
		List<MBoardItemVO> list = mBoardDAO.getNewItemList(map);
		
		logger.debug("getNewBoardItemList ended.");
		
		return list;
	}
	
	private int getBoardItemListCount(String boardID, String userID, String gubun, int tenantID) throws Exception {
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
}
