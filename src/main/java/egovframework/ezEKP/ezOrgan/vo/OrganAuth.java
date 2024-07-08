package egovframework.ezEKP.ezOrgan.vo;

import org.apache.commons.lang3.StringUtils;

import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import static egovframework.ezEKP.ezOrgan.vo.OrganAuth.Scope.ALL;
import static egovframework.ezEKP.ezOrgan.vo.OrganAuth.Scope.COMPANY;
import static egovframework.ezEKP.ezOrgan.vo.OrganAuth.Scope.DEPT;

public class OrganAuth {
    private final Set<AdminAuth> allSet;
    private final Map<String, Set<AdminAuth>> compSet;
    private final Map<String, Set<AdminAuth>> deptSet;

    public OrganAuth() {
        this.allSet = new HashSet<>();
        this.compSet = new HashMap<>();
        this.deptSet = new HashMap<>();
    }

    public OrganAuth addAuth(String info, String deptId, String companyId) {
        info = ";" + info;
        String[] split = info.split(";", -1);
        for (String s : split) {
            // 비어있거나, 추출된 권한이 "=1"로 끝나지 않으면 continue
            if (StringUtils.isEmpty(s) || !"=1".equals(StringUtils.right(s, 2))) {
                continue;
            }

            s = StringUtils.remove(s, "=1");
            AdminAuth auth = AdminAuth.getAdminAuthByCode(s);
            switch (auth.scope) {
                case ALL:
                    allSet.add(auth);
                    break;
                case DEPT:
                    deptSet.computeIfAbsent(deptId, k -> new HashSet<>()).add(auth);
                    break;
                case COMPANY:
                    compSet.computeIfAbsent(companyId, k -> new HashSet<>()).add(auth);
                    break;
            }
        }
        return this;
    }

    public boolean isAuth(AdminAuth auth, String id) {
        switch (auth.scope) {
            case ALL:
                return allSet.contains(auth);
            case DEPT:
                return deptSet.get(id) != null && deptSet.get(id).contains(auth);
            case COMPANY:
                return compSet.get(id) != null && compSet.get(id).contains(auth);
        }
        return false;
    }

    public boolean isAuth(String authCode, String id) {
        return isAuth(AdminAuth.getAdminAuthByCode(authCode), id);
    }


    public enum AdminAuth {
        /**
         * 전체관리자
         */
        ADMIN_MASTER("c", ALL),
        /**
         * 회사관리자
         */
        COMPANY_MANAGER("k", COMPANY),
        /**
         * 부서관리자
         */
        DEPT_MANAGER("g", DEPT),
        /**
         * 수발신담당자
         */
        RECEPTION_MANAGER("a", DEPT),
        /**
         * 심사자
         */
        INSPECTION_MANAGER("i", COMPANY),
        /**
         * 게시판관리자
         */
        BOARD_MANAGER("n", COMPANY),
        /**
         * 설문관리자
         */
        SURVEY_MANAGER("l", COMPANY),
        /**
         * 업무관리자
         */
        TASK_MANAGER("w", COMPANY),
        /**
         * 기록물관리책임자
         */
        ARCHIVE_MANAGER("m", COMPANY),
        /**
         * 웹폴더관리자
         */
        WEB_FOLDER_MANAGER("f", COMPANY),
        /**
         * 근태관리자
         */
        ATTENDANCE_MANAGER("e", COMPANY);

        private final String code;
        private final Scope scope;

        AdminAuth(String code, Scope scope) {
            this.code = code;
            this.scope = scope;
        }

        public String getCode() {
            return code;
        }

        public static AdminAuth getAdminAuthByCode(String code) {
            return Arrays.stream(AdminAuth.values()).filter(auth -> auth.getCode().equals(code)).findFirst().orElse(null);
        }

        private Scope getScope() {
            return scope;
        }
    }

    enum Scope {
        ALL, COMPANY, DEPT
    }
}

