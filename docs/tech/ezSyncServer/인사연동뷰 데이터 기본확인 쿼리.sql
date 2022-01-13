-- 최초작성: 솔루션1팀 김은실(2021-01-26 15:00)
-- 최근수정: 솔루션1팀 김은실(2021-09-15 17:30)
-- (나중에 프로시저로 만들어서 돌려도 좋을듯 합니다. :DBMS_OUTPUT.PUT_LINE('~을 확인해주세요.'))

-- ※오라클 버전 알아보기
SELECT banner FROM  V$VERSION;

-- 뷰테이블 이름이 정확한지 (v_usermaster, v_deptmaster, v_addjobmaster)
-- 만약 코드에 뷰테이블 이름 수정 시: MIS.v_usermaster 와 같이 타 계정입력해도 잘 가져옴.
select * from v_usermaster;
select * from v_deptmaster;
select * from v_addjobmaster;
desc v_usermaster;
desc v_deptmaster;
desc v_addjobmaster;



-- 유효성검사---------------------------
-- v_usermaster
select count(*) from v_usermaster;      -- 라이센스에 넘치지 않는지 확인.
-- select count(*) from v_usermaster where Upper(use_yn) = 'Y';      -- 라이센스에 넘쳤다면: N을 제외하지 못한것은 아닌지 확인.
select * from v_usermaster where user_id is null;
select * from v_usermaster where user_id in (select user_id from v_usermaster group by user_id having count(*) > 1) order by user_id;   -- pk 중복 확인.
select * from v_usermaster where user_name is null;
select * from v_usermaster where dept_id is null;
select count(*) from v_usermaster group by dept_id having count(*) > 100 order by 1 desc;
-- (case 4) 한 부서에 너무 많은 사용자가 들어가는 경우 :
-- 12c부터는 MAX_STRING_SIZE를 EXTENDED로  하면 varchar2의 컬럼 크기를 32K까지 확장할 수 있으니까 필요한 경우 확장하면 될거야
-- (MAX_STRING_SIZE가 EXTENDED로 되어 있다면) james_recipient_rewrite 테이블의 target_address 컬럼 크기를 4000에서 30000으로 변경하도록 해.
-- 그리고 변경한 크기에 대해 제대로 동작하려면 오라클 JDBC 클라이언트가 ojdbc6.jar가 아닌 ojdbc7.jar여야 해. 
-- 아마 ezSyncServer와 jgw-server, jmocha-server에 이미 ojbc7.jar가 적용되어 있긴 하겠지만 확실하게 확인해봐
-- ezSyncServer와 jgw-server는 Tomcat이니까 ezSyncServer/lib 와 jgw-server/lib 폴더에 JDBC 드라이버가 있을 거고
-- jmocha-server는 jmocha-server/conf/lib 폴더에 있을거야
-- 참고로 ojdbc6.jar는 11g용 드라이버고 ojdbc7.jar는 12c R1용 드라이버야

select * from v_usermaster u where Upper(use_yn) = 'Y' and NOT EXISTS (select 1 from v_deptmaster where dept_id = u.dept_id);                      -- 부서테이블에 없는 부서를 가진 사용자
select * from v_usermaster u where Upper(use_yn) = 'Y' and EXISTS (select 1 from v_deptmaster where dept_id = u.dept_id and Upper(use_yn) = 'N');  -- 사용 중인 사용자가 폐지부서에 속한 경우 
-- select distinct dept_id from -- 부서 개수만 보기
select * from v_usermaster where email_address is null;
-- String accountEmailAddress = cn + "@" + domain;
-- ...
-- // 이메일 주소가 지정되지 않은 경우에는 계정 주소와 동일하게 취급한다.
-- if (emailAddress.isEmpty()) {
-- 		emailAddress = accountEmailAddress;
-- }
select * from v_usermaster where title is null;
-- 2020.04 직위 NN 주석.
-- source 유저증 직위가 한명이라도 존재하지 않을시에  에러를 내고 노티메일 발송
-- 
-- 전체 유저를 판단하고 전체 유저중 한명이라도 직위가 없으면 에러를 내고 노티메일을 발송한다.
-- 노티메일에는 cn과 displayname 정보를 담는다.

select * from v_usermaster where use_yn is null;
select user_name_en from v_usermaster;
select sort_order from v_usermaster;
select title from v_usermaster;
select role from v_usermaster;
select employee_number from v_usermaster;
select home_phone from v_usermaster;
select mobile from v_usermaster;
select office_phone from v_usermaster;
select fax from v_usermaster;
select updatedt from v_usermaster;
select profile_image from v_usermaster;
-- (BLOB으로 프로필을 받을 경우: ezFlow와 같이 fileroot 링크를 미리 걸어주어야 한다. 만약 못걸었다면 후에 걸고, upload_personal 폴더를 같은 위치에 옮기면 됨.)
select profile_image_url from v_usermaster;
select birthdate from v_usermaster;     -- (yyyy-mm-dd이 아닐경우: 생일자 인식이 제대로 안됨.)
-- desc v_usermaster;
select data_type, char_length from all_tab_columns where Lower(table_name) = 'v_usermaster' and Lower(column_name) = 'birthdate';   -- BirthDate의 형식이 date로 되어있진 않은지: varchar(20)
                                                                                                                                    -- mariaDB는 다른 듯..?
select birthtype from v_usermaster;     -- BirthType이 있는지 (커스터마이징 시, getUserListFromSourceSql 쿼리에 'Y'로 수정할 수도 있음)
select password from v_usermaster;
-- password is null 이라면 ezSyncServer > web.xml 에 있는 defaultPassword으로 등록됨.
--	<context-param>
--		<param-name>defaultPassword</param-name>
--		<param-value>asd123!@#$</param-value>
--	</context-param>
select use_yn from v_usermaster;
select * from v_usermaster where email_address not like '%@kangnam.ac.kr' and email_address is not null;  -- 외부메일주소
-- (case 2) 외부메일주소를 써야할 때:
-- 외부메일주소도 그대로 인사연동 수행하면 해당 사용자의 Primary 주소로 tbl_usermaster 테이블의 mail 컬럼에 등록이 될거야. 
-- 어차피 우리 메일 서버를 통해 메일 전송하는게 아니라 강남대 메일 서버를 통해 발송하는거니까 상관없을 것 같아. 
-- 인사연동 수행해서 조직도에 외부메일 주소가 잘 나타나는지를 확인해봐
-- 
-- 그런데 다만 우리가 강남대 메일 서버로 메일을 전송할 때 @kangnam.ac.kr 도메인에 속한 주소는 
-- 강남대 메일 서버가 자기 도메인이니까 그대로 받아들여 사용자에게 수신이 되겠지만
-- 네이버와 같은 외부메일 주소는 강남대 메일 서버 도메인이 아니니까 강남대 메일 서버를 경유해서 외부로 나가야 해
-- 이런 경우 강남대 메일 서버에서 우리 그룹우웨어 서버에서 오는 메일에 대해 Relay 허용을 해주어야해
-- 
-- 우리 그룹웨어 서버 IP 주소에 대해 강남대 메일 서버에서 Relay 허용 등록을 해주어야 한다고 요청하면 돼



-- v_deptmaster
select * from v_deptmaster where dept_id is null;
select * from v_deptmaster where dept_id in (select dept_id from v_deptmaster group by dept_id having count(*) > 1) order by dept_id;   -- pk 중복 확인.
select * from v_deptmaster where dept_name is null;
select * from v_deptmaster where use_yn is null;
select parent_dept_id from v_deptmaster;
select sort_order from v_deptmaster;
select * from v_deptmaster where parent_dept_id is null;    -- 최상위부서 확인(count(*)= 1)
-- [mariaDB]
-- select * from v_deptmaster where parent_dept_id is null or parent_dept_id = '';

select count(parent_dept_id) from v_deptmaster d where not exists (select 1 from v_deptmaster where dept_id = d.parent_dept_id) and parent_dept_id is not null;  -- 부서테이블에 없는 부서를 상위부서로 참조하진 않는지(= 0)

select count(*) from v_deptmaster;
select count(*) from v_deptmaster start with parent_dept_id is null connect by prior dept_id = parent_dept_id;  -- 연결이 끊기는 부서는 없는지(= select count(*) from v_deptmaster) 
                                                                                                                -- (ORA-01436) 루프도는 레코드는 없는지 확인
-- select LPAD(dept_id, 2*(level-1)+length(dept_id)) tree, d.* from v_deptmaster d start with parent_dept_id is null connect by prior dept_id = parent_dept_id;  -- 눈으로 쉽게 확인하기
-- [mariaDB] 계층형쿼리 :10.2.5 이상부터 Self 조인을 이용한 Recursive를 지원 (mariaDB 10.2.5 이하 방법 참고: https://bulkywebdeveloper.tistory.com/109)
-- select count(*) from v_deptmaster;
-- with recursive cte (dept_id, dept_name, parent_dept_id) 
-- as ( select     dept_id, dept_name, parent_dept_id from v_deptmaster where parent_dept_id is null or parent_dept_id = ''
-- 	 union all
-- 	 select     r.dept_id, r.dept_name, r.parent_dept_id from v_deptmaster r
-- 				inner join cte on r.parent_dept_id = cte.dept_id
-- )
-- select count(*) from cte;

-- [mariaDB] 눈으로 쉽게 확인하기
-- with recursive cte (dept_id, dept_name, parent_dept_id, level)
-- as ( select     dept_id, dept_name, parent_dept_id, 1 AS level from v_deptmaster where parent_dept_id is null or parent_dept_id = ''
-- 	 union all
-- 	 select     r.dept_id, r.dept_name, r.parent_dept_id, 1+level as level from v_deptmaster r
-- 				inner join cte on r.parent_dept_id = cte.dept_id
-- )
-- select LPAD(dept_id, 4*(level-1)+length(dept_id)) as dept_id, dept_name, parent_dept_id from cte;

select count(*) from v_deptmaster where Upper(use_yn) = 'Y' start with Upper(use_yn) = 'N' connect by prior dept_id = parent_dept_id;    -- 상위부서가 N 인데, 하위부서가 Y인 경우
-- select * from v_deptmaster where Upper(use_yn) = 'Y' start with Upper(use_yn) = 'N' connect by prior dept_id = parent_dept_id;    -- 리스트 확인하기
-- [mariaDB] 
-- with recursive cte (dept_id, dept_name, parent_dept_id, use_yn) 
-- as ( select     dept_id, dept_name, parent_dept_id, use_yn from v_deptmaster where Upper(use_yn) = 'N'
-- 	 union all
-- 	 select     r.dept_id, r.dept_name, r.parent_dept_id, r.use_yn from v_deptmaster r
-- 				inner join cte on r.parent_dept_id = cte.dept_id
-- )
-- select count(*) from cte where Upper(use_yn) = 'Y';

-- [mariaDB] 리스트 확인하기
-- with recursive cte (dept_id, dept_name, parent_dept_id, level, use_yn)
-- as ( select     dept_id, dept_name, parent_dept_id, 1 AS level, use_yn from v_deptmaster where Upper(use_yn) = 'N'
-- 	 union all
-- 	 select     r.dept_id, r.dept_name, r.parent_dept_id, 1+level as level, r.use_yn from v_deptmaster r
-- 				inner join cte on r.parent_dept_id = cte.dept_id
-- )
-- select LPAD(dept_id, 4*(level-1)+length(dept_id)) as dept_id, dept_name, parent_dept_id, use_yn from cte where Upper(use_yn) = 'Y';



-- v_addjobmaster
select * from v_addjobmaster where user_id is null;
select * from v_addjobmaster where dept_id is null;
-- select * from v_addjobmaster where use_yn is null;
-- select * from v_addjobmaster a where Upper(use_yn) = 'Y' and exists (select 1 from v_usermaster where user_id = a.user_id and Upper(use_yn) = 'N'); -- 퇴직자의 겸직정보가 N처리 되지 않은 경우
-- select * from v_addjobmaster a where Upper(use_yn) = 'Y' and exists (select 1 from v_deptmaster where dept_id = a.dept_id and Upper(use_yn) = 'N'); -- 폐지부서의 겸직정보가 N처리 되지 않은 경우
select title from v_addjobmaster;
select sort_order from v_addjobmaster;
select * from v_addjobmaster a where not exists (select 1 from v_usermaster where user_id = a.user_id and Upper(use_yn) = 'Y'); -- 사용자테이블에 없는/퇴직한 사용자
-- select * from v_addjobmaster a where not exists (select 1 from v_usermaster where user_id = a.user_id and Upper(use_yn) = 'Y') and Upper(a.use_yn) = 'Y';
select * from v_addjobmaster a where not exists (select 1 from v_deptmaster where dept_id = a.dept_id and Upper(use_yn) = 'Y'); -- 부서테이블에 없는/폐지 부서를 가진 사용자
-- select * from v_addjobmaster a where not exists (select 1 from v_deptmaster where dept_id = a.dept_id and Upper(use_yn) = 'Y') and Upper(a.use_yn) = 'Y'; -- 부서테이블에 없는/폐지 부서를 가진 사용자
-- select distinct dept_id from -- 부서 개수만 보기
select * from v_addjobmaster a join v_usermaster u on (a.user_id = u.user_id and a.dept_id = u.dept_id);    -- 원부서에 겸직하는 사용자 (허용함으로 변경.)
-- commit 804b469e0f47ee6674e9eaa3b9d33cb5f799fcb6
-- Author: Eunsil <hosea0301@kaoni.com>
-- Date:   Fri Oct 29 02:21:24 2021 +0900
-- 
--     (ezSync) 한 부서에 여러번 겸직하는 경우 처리
-- 
--     - 원부서겸직 로직 삭제
--     - (ezFlow) 82fc8c5..176ad6e
--        suasua <tndk19@kaoni.com> 20210215..20211027

select user_id, dept_id, count(*) from v_addjobmaster group by user_id, dept_id having count(*) > 1;        -- 한 부서에 두 번이상 겸직하는 사용자
-- (case 5) 한 부서에 두 번이상 겸직하는 사용자
-- 최초로 작업되었던 사이트는: 강남대학교
-- 최근에는: 가천대학교 (전자결재 + 조직도만 사용)
-- 
-- 조직도는 제가 수아씨가 만든거 체리픽해서 적용은했는데
-- 가천대 할때는 ezFlow에다가 커밋을 세개 정도 가져왔어요
-- 수아씨가 개발한걸 적용만 했더니 잘 되더라구여 그렇게 해결한거였어요
-- 
-- 전자결재는 누가 지원해줘야돼요
-- 표준에 적용되지 않아서 무조건 추가 개발을 해야되는건이라
-- 네네 팀장님이랑 한번 얘기해보세염

-- --------------------------------------

-- email_address + user_id + dept_id + 이미 있는 테이블 데이터 => unique한지
select * from v_usermaster u join v_deptmaster d on (u.user_id = d.dept_id);                                                                --  user_id != dept_id
select * from v_usermaster u join v_deptmaster d on (regexp_substr(u.email_address,'[^@]+') = d.dept_id);                               --  email_address != dept_id
select a.user_id AS user_id_1, a.user_name, a.email_address, a.dept_id, '||',
b.user_id AS user_id_2, b.user_name, b.email_address, b.dept_id
from v_usermaster a join v_usermaster b on (a.user_id = regexp_substr(b.email_address,'[^@]+') and a.user_id != b.user_id);    --  user_id != email_address
select * from v_usermaster u where exists (select 1 from v_usermaster where user_id = regexp_substr(u.email_address,'[^@]+')
    -- and email_address not like '%@kangnam.ac.kr'
	);                                                                              -- email_address is null의 이메일 생성시 != 기존 email_address
-- ( [mariaDB]도 REGEXP_SUBSTR(subject,pattern) :10.0.5 이상부터 지원 (옵션 사용가능한지는 잘 모르겠음.. 참고: https://mariadb.com/kb/en/regexp_substr/) )

-- (case 1) user_id == email_address 같은 것이 있을 때: 
-- 카이스트용 jgw-server 소스를 clone하고 site_kaist 브랜치에서 보면 다음과 같은 commit이 있을거야
-- commit 86fbfd0f45e25c6900465e1989e09a5a5d099187 (HEAD -> site_kaist, origin/site_kaist)
-- Author: Dongho Lee <dhlee@kaoni.com>
-- Date:   Sun Nov 15 21:22:32 2020 +0900
-- 
--     사용자 등록시 아이디가 다른 사용자의 이메일 아이디인지 체크하는 부분 제거
--     
--       - KAIST의 경우엔 다른 사용자가 이미 이메일 주소로 사용하고 있는 이메일 아이디와
--         동일한 사용자 아이디를 사용하는 경우가 있어 중복 체크 부분을 제거함
-- 카이스트 jgw-server 저장소를 별도의 remote로 등록한 다음 cherry-pick 하면 될거야

