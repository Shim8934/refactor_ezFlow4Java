package egovframework.ezEKP.ezOrgan.vo;

import org.apache.commons.lang3.StringUtils;

import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Optional;
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
            if (StringUtils.isBlank(s) || !"=1".equals(StringUtils.right(s, 2))) {
                continue;
            }

            s = StringUtils.remove(s, "=1");
            Optional<AdminAuth> optionalAuth = AdminAuth.getAdminAuthByCode(s);
            if (optionalAuth.isPresent()) {
                AdminAuth auth = optionalAuth.get();
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
        }
        return this;
    }

    public boolean isAuth(AdminAuth auth, String id) {
        if (auth == null) {
            return false;
        }
        
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

    /**
     * 겸직을 포함에서 부서, 회사 등 스코프에 상관없이 권한이 존재하는지 체크
     */
    public boolean isAuth(AdminAuth auth) {
        if (auth == null) {
            return false;
        }
        
        switch (auth.scope) {
            case ALL:
                return allSet.contains(auth);
            case DEPT:
                for (Set<AdminAuth> set : deptSet.values()) {
                    if (set.contains(auth)) {
                        return true;
                    }
                }
            case COMPANY:
                for (Set<AdminAuth> set : compSet.values()) {
                    if (set.contains(auth)) {
                        return true;
                    }
                }
        }
        return false;
    }

    public boolean isAuth(String authCode, String id) {
        Optional<AdminAuth> auth = AdminAuth.getAdminAuthByCode(authCode);
        return auth.filter(adminAuth -> isAuth(adminAuth, id)).isPresent();
    }


    public enum AdminAuth {
        /**
         * 전체관리자 "c", ALL
         */
        ADMIN_MASTER("c", ALL),
        /**
         * 회사관리자 "k", COMPANY
         */
        COMPANY_MANAGER("k", COMPANY),
        /**
         * 부서관리자 "g", DEPT
         */
        DEPT_MANAGER("g", DEPT),
        /**
         * 수발신담당자 "a", DEPT
         */
        RECEPTION_MANAGER("a", DEPT),
        /**
         * 심사자 "i", COMPANY
         */
        INSPECTION_MANAGER("i", COMPANY),
        /**
         * 게시판관리자 "n", COMPANY
         */
        BOARD_MANAGER("n", COMPANY),
        /**
         * 설문관리자 "l", COMPANY
         */
        SURVEY_MANAGER("l", COMPANY),
        /**
         * 업무관리자 "w", COMPANY
         */
        TASK_MANAGER("w", COMPANY),
        /**
         * 기록물관리책임자 "w", COMPANY
         */
        ARCHIVE_MANAGER("m", COMPANY),
        /**
         * 웹폴더관리자 "f", COMPANY
         */
        WEB_FOLDER_MANAGER("f", COMPANY),
        /**
         * 결재조회 관리자 "q", COMPANY
         */
        APR_QUERY_MANAGER("q", COMPANY),
        /**
         * 근태관리자 "e", COMPANY
         */
        ATTENDANCE_MANAGER("e", COMPANY),
        /**
         * 일정관리자 "v", COMPANY
         */
        SCHEDULE_MANAGER("v", COMPANY)
        ;

        private final String code;
        private final Scope scope;

        AdminAuth(String code, Scope scope) {
            this.code = code;
            this.scope = scope;
        }

        public String getCode() {
            return code;
        }

        public static Optional<AdminAuth> getAdminAuthByCode(String code) {
            return Arrays.stream(AdminAuth.values()).filter(auth -> auth.getCode().equals(code)).findFirst();
        }

        private Scope getScope() {
            return scope;
        }
    }

    enum Scope {
        ALL, COMPANY, DEPT
    }
}

