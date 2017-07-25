package egovframework.ezMobile.ezEmail.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.Folder;
import javax.mail.MessagingException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezMobile.ezEmail.vo.MEmailFolderVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@RestController
public class MEmailGWController extends EgovFileMngUtil {

private static final Logger logger = LoggerFactory.getLogger(MEmailGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	static final String SUPERPASSWORD = "!p1221612";	
	
	/**
	 * 모바일 G/W 이메일 [put] method sample
	 */
	/*
	 * @RequestMapping(value="/ezMAIL/{MAILid}/gw-testUpdate/{id}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public void testUpdate(@PathVariable String MAILid, @PathVariable String id, @RequestBody LoginVO loginVO) throws Exception {		
		logger.debug("gw-testUpdate started.");
		
		System.out.println(loginVO.getIp());
				
		LoginVO vo = new LoginVO();
		vo.setTenantId(0);
		vo.setId(id);
		vo.setIp(loginVO.getIp());
		
		loginService.updateUser(vo);
		
		logger.debug("gw-testUpdate ended.");		
	}
	*/
    ///////////////////////////////////////////////// sample end /////////////////////////////////////////////////////
	
	/**
	 * 모바일 G/W 이메일 [GET] 왼쪽 슬라이드 메뉴에 편지함 목록 조회, 메일 이동 시 편지함 목록 출력
	 */
	@RequestMapping(value="/ezemail/folders-list/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public void mMailFolderList() throws Exception {
		logger.debug("MOBILE G/W MAIL [GET /ezemail/folders-list/users/{userId}] started.");
		
		logger.debug("MOBILE G/W MAIL [GET /ezemail/folders-list/users/{userId}] ended.");		
	}
	
	/**
	 * 모바일 G/W 이메일 [GET] (받은, 보낸,임시,지운,개인,기타) 편지함 리스트
	 */
	@RequestMapping(value="/ezemail/folders/{folderId}/mails/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public void mMailFolderMailList() throws Exception {
		logger.debug("MOBILE G/W MAIL [GET /ezemail/folders/{folderId}/mails/users/{userId}] started.");
		
		logger.debug("MOBILE G/W MAIL [GET /ezemail/folders/{folderId}/mails/users/{userId}] ended.");		
	}
	
	/**
	 * 모바일 G/W 이메일 [POST] 메시지 복사 (전달을 선택한 메일정보 조회)
	 */
	@RequestMapping(value="/ezemail/folders/{folderId}/mails/{messageId}/copy/users/{userId}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public void mMailCopy() throws Exception {
		logger.debug("MOBILE G/W MAIL [POST /ezemail/folders/{folderId}/mails/{messageId}/copy/users/{userId}] started.");
		
		logger.debug("MOBILE G/W MAIL [POST /ezemail/folders/{folderId}/mails/{messageId}/copy/users/{userId}] ended.");		
	}
	
	/**
	 * 모바일 G/W 이메일 [GET] 메일 쓰기에 필요한 옵션 정보 조회
	 */
	@RequestMapping(value="/ezemail/mail-write/option", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public void mMailWriteOption() throws Exception {
		logger.debug("MOBILE G/W MAIL [GET /ezemail/mail-write/option] started.");
		
		logger.debug("MOBILE G/W MAIL [GET /ezemail/mail-write/option] ended.");		
	}
	
	/**
	 * 모바일 G/W 이메일 [GET] 서명 조회
	 */
	@RequestMapping(value="/ezemail/sign/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public void mMailSign() throws Exception {
		logger.debug("MOBILE G/W MAIL [GET /ezemail/sign/users/{userId}] started.");
		
		logger.debug("MOBILE G/W MAIL [GET /ezemail/sign/users/{userId}] ended.");		
	}
	
	/**
	 * 모바일 G/W 이메일 [POST] 첨부파일 업로드
	 */
	@RequestMapping(value="/ezemail/folders/{folderId}/mails/{messageId}/attachs/users/{userId}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public void mMailFileUpload() throws Exception {
		logger.debug("MOBILE G/W MAIL [POST /ezemail/folders/{folderId}/mails/{messageId}/attachs/users/{userId}] started.");
		
		logger.debug("MOBILE G/W MAIL [POST /ezemail/folders/{folderId}/mails/{messageId}/attachs/users/{userId}] ended.");		
	}
	
	/**
	 * 모바일 G/W 이메일 [POST] 임시저장
	 */
	@RequestMapping(value="/ezemail/mail-save/users/{userId}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public void mMailSave() throws Exception {
		logger.debug("MOBILE G/W MAIL [POST /ezemail/mail-save/users/{userId}] started.");
		
		logger.debug("MOBILE G/W MAIL [POST /ezemail/mail-save/users/{userId}] ended.");		
	}
	
	/**
	 * 모바일 G/W 이메일 [POST] 메일발송(send)
	 */
	@RequestMapping(value="/ezemail/mail-send/users/{userId}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public void mMailSend() throws Exception {
		logger.debug("MOBILE G/W MAIL [POST /ezemail/mail-send/users/{userId}] started.");
		
		logger.debug("MOBILE G/W MAIL [POST /ezemail/mail-send/users/{userId}] ended.");		
	}
	
	/**
	 * 모바일 G/W 이메일 [GET] 메일 읽기
	 */
	@RequestMapping(value="/ezemail/folders/{folderId}/mails/{messageId}/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public void mMailRead() throws Exception {
		logger.debug("MOBILE G/W MAIL [GET /ezemail/folders/{folderId}/mails/{messageId}/users/{userId}] started.");
		
		logger.debug("MOBILE G/W MAIL [GET /ezemail/folders/{folderId}/mails/{messageId}/users/{userId}] ended.");		
	}
	
	/**
	 * 모바일 G/W 이메일 [GET] 파일 다운로드
	 */
	@RequestMapping(value="/ezemail/folders/{folderId}/mails/{messageId}/attach/{index}/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public void mMailFileDown() throws Exception {
		logger.debug("MOBILE G/W MAIL [GET /ezemail/folders/{folderId}/mails/{messageId}/attach/{index}/users/{userId}] started.");
		
		logger.debug("MOBILE G/W MAIL [GET /ezemail/folders/{folderId}/mails/{messageId}/attach/{index}/users/{userId}] ended.");		
	}
	
	/**
	 * 모바일 G/W 이메일 [PUT] 메일 이동
	 */
	@RequestMapping(value="/ezemail/folders/{folderId}/mails/{messageId}/users/{userId}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public void mMailMove() throws Exception {
		logger.debug("MOBILE G/W MAIL [DELETE /ezemail/folders/{folderId}/mails/{messageId}/users/{userId}] started.");
		
		logger.debug("MOBILE G/W MAIL [DELETE /ezemail/folders/{folderId}/mails/{messageId}/users/{userId}] ended.");		
	}
	
	/**
	 * 모바일 G/W 이메일 [PUT] 읽은 상태 변경
	 */
	@RequestMapping(value="/ezemail/folders/{folderId}/mails/{messageId}/users/{userId}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public void mMailStatusChange() throws Exception {
		logger.debug("MOBILE G/W MAIL [DELETE /ezemail/folders/{folderId}/mails/{messageId}/users/{userId}] started.");
		
		logger.debug("MOBILE G/W MAIL [DELETE /ezemail/folders/{folderId}/mails/{messageId}/users/{userId}] ended.");		
	}
	
	/**
	 * 모바일 G/W 이메일 [DELETE] 메일 삭제
	 */
	@RequestMapping(value="/ezemail/folders/{folderId}/mails/{messageId}/users/{userId}", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public void mMailDelete() throws Exception {
		logger.debug("MOBILE G/W MAIL [DELETE /ezemail/folders/{folderId}/mails/{messageId}/users/{userId}] started.");
		
		logger.debug("MOBILE G/W MAIL [DELETE /ezemail/folders/{folderId}/mails/{messageId}/users/{userId}] ended.");		
	}
	
	/**
	 * 모바일 G/W 이메일 [put] method sample
	 */
//	@RequestMapping(value="/ezMAIL/{MAILid}/gw-testUpdate/{id}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
//	public void testUpdate(@PathVariable String MAILid, @PathVariable String id, @RequestBody LoginVO loginVO) throws Exception {		
//		logger.debug("gw-testUpdate started.");
//		
//		System.out.println(loginVO.getIp());
//				
//		LoginVO vo = new LoginVO();
//		vo.setTenantId(0);
//		vo.setId(id);
//		vo.setIp(loginVO.getIp());
//		
//		loginService.updateUser(vo);
//		
//		logger.debug("gw-testUpdate ended.");		
//	}
}