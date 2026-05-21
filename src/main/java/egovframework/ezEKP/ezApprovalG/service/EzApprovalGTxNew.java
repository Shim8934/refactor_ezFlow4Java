package egovframework.ezEKP.ezApprovalG.service;

import egovframework.ezEKP.ezApprovalG.dao.EzApprovalGDAO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.BadSqlGrammarException;
import org.springframework.stereotype.Service;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

/**
 * 트랜잭션(Tx) REQUIRES_NEW 정책을 위한 클래스
 * 기존 트랜잭션의 경우 Exception 이 발생하면 일괄적으로 rollback 처리 됨.
 * 로직 중에 오류 데이터를 남기는 증의 별개의 트랜잭션이 필요하면 사용.
 * 주의
 * - REQUIRES_NEW 정책은 이전 트랜잭션을 잠시 정지 -> 매소드 이름의 새 트랜잭션 생성 -> 매소드 종료시 커밋 -> 이전 트랜잭션 재게
 *  의 과정을 거치므로 고려하여 사용 할 것.
 */
@Service
public class EzApprovalGTxNew {
    private static final Logger logger = LoggerFactory.getLogger(EzApprovalGTxNew.class);

    @Autowired
    EzApprovalGDAO ezApprovalGDAO;

    @Autowired
    private EzCommonService ezCommonService;
    /**
     * 결재문서 완료 시, 다른 과정이 끝나고(완료문서 완성, DB insert 등) 기록물삽입에서 갑자기 중복될 경우
     * 결재가 중복이 아닌데 기록물이 중복일 경우 동시성 문제일때 일어남.
     * 이후에 롤백 해야할 번호가 남아서 계속 결재하지 못함.
     * 그래서 기록물 insert 시에 key 중복 예외가 발생할 경우 채번 롤백을 하지 않기 위한 테이블 insert는 무조건 동작하고 다른 로직은 롤백 처리.
     */
    public void insertRegErrorNoRollbackRecord(String type1, String type2, String type3, int regYear, String sysDate, int regSN, String companyID, int tenantID) {
        logger.info("insertRegErrorNoRollbackRecord : type1 = " + type1 + ", type2 = " + type2 + ", type3 = " + type3
                + ", regYear = " + regYear + ", sysDate = " + sysDate + ", regSN = " + regSN + ", companyID = " + companyID + ", tenantID = " + tenantID);

        Map<String, Object> map = new HashMap<>();
        map.put("v_TYPE1", type1);
        map.put("v_TYPE2", type2);
        map.put("v_TYPE3", type3);
        map.put("v_TIMESEP", regYear);
        map.put("v_SYSDATE", sysDate);
        map.put("v_REGSERIALNO", regSN);
        map.put("v_COMPANYID", companyID);
        map.put("v_TENANTID", tenantID);

        try {
            ezApprovalGDAO.insertRegErrorNoRollbackRecord(map);
        } catch (Exception e) { // TBL_SERIAL_NOROLLBACK 테이블 레코드 중복삽입 시 그냥 로그만 찍고 무시
            logger.error(e.getMessage(), e);
        }
        logger.info("insertRegErrorNoRollbackRecord ended");
    }

    public void insertErrorLog(Exception ex) {
        try {
            Map<String, Object> map = new HashMap<>();
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            String errorClass = ezCommonService.getTenantConfig("errorClass", 0);
            if(errorClass.contains("ALL"))
                ex.printStackTrace(pw);
            else if(!errorClass.isEmpty()){
                Pattern pattern = Pattern.compile(errorClass);

                // 2. Stream을 이용한 필터링 및 출력
                Arrays.stream(ex.getStackTrace())
                        .map(StackTraceElement::toString)
                        .filter(line -> pattern.matcher(line).find())
                        .forEach(pw::println);
            }
            String error = sw.toString();
            if(error.isEmpty())
                return;
            
            map.put("message",ex.getMessage() == null ? ex.toString() : ex.getMessage());
            map.put("error",error);

            ezCommonService.insertErrorLog(map);
        } catch (BadSqlGrammarException e) {
            try {
                ezCommonService.createTblErrorLog();
            } catch (Exception exc) {
                logger.error("createTblErrorLog fail.");
            }
        } catch (Exception e) {
            logger.error("insertErrorLog fail.");
        }
    }
}
