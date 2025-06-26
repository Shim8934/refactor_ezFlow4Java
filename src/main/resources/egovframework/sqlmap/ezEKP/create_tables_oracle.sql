--------------------------------------------------------
--  파일이 생성됨 - 금요일-3월-13-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View SVTASKCLASS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SVTASKCLASS" ("CATEGORYCODE", "CNAME", "CNAME2", "MCATEGORYCODE", "MCNAME", "MCNAME2", "SUBCATEGORYCODE", "SCNAME", "SCNAME2", "TASKCODE", "TASKNAME", "TASKNAME2", "KEEPINGPERIOD", "DISPLAYRECFLAG", "SPECIALCATALOGFLAG", "TEMPFLAG", "COMPANYID", "TENANT_ID", "PROCESSDEPTCODE", "PROCESSDEPTNAME", "PROCESSDEPTNAME2", "KEEPINGMETHOD", "KEEPINGPLACE", "DISPLAYRECTRASTIME", "ISPUBLIC", "ITEMSECURITY", "DELFLAG", "OLDFLAG_TOP", "OLDFLAG_MID", "OLDFLAG_SUB") AS 
  SELECT
        tbl_taskcategory.CATEGORYCODE AS CATEGORYCODE,
        tbl_taskcategory.NAME AS CNAME,
        tbl_taskcategory.NAME2 AS CNAME2,
        tbl_taskmiddlecategory.MCATEGORYCODE AS MCATEGORYCODE,
        tbl_taskmiddlecategory.NAME AS MCNAME,
        tbl_taskmiddlecategory.NAME2 AS MCNAME2,
        tbl_tasksubcategory.SUBCATEGORYCODE AS SUBCATEGORYCODE,
        tbl_tasksubcategory.NAME AS SCNAME,
        tbl_tasksubcategory.NAME2 AS SCNAME2,
        tbl_taskcode.TASKCODE AS TASKCODE,
        tbl_taskcode.TASKNAME AS TASKNAME,
        tbl_taskcode.TASKNAME2 AS TASKNAME2,
        tbl_taskcode.KEEPINGPERIOD AS KEEPINGPERIOD,
        tbl_taskcode.DISPLAYRECFLAG AS DISPLAYRECFLAG,
        tbl_taskcode.SPECIALCATALOGFLAG AS SPECIALCATALOGFLAG,
        tbl_taskcode.TEMPFLAG AS TEMPFLAG,
        tbl_taskcode.COMPANYID AS COMPANYID,
        tbl_taskcode.TENANT_ID AS TENANT_ID,
        tbl_task_deptinfo.PROCESSDEPTCODE AS PROCESSDEPTCODE,
        tbl_task_deptinfo.PROCESSDEPTNAME AS PROCESSDEPTNAME,
        tbl_task_deptinfo.PROCESSDEPTNAME2 AS PROCESSDEPTNAME2,
        tbl_taskcode.KEEPINGMETHOD AS KEEPINGMETHOD,
        tbl_taskcode.KEEPINGPLACE AS KEEPINGPLACE,
        tbl_taskcode.DISPLAYRECTRASTIME AS DISPLAYRECTRASTIME,
        tbl_taskcode.ISPUBLIC AS ISPUBLIC,
        tbl_taskcode.ITEMSECURITY AS ITEMSECURITY,
        tbl_task_deptinfo.DELFLAG AS DELFLAG,
		tbl_taskcategory.OLDFLAG AS OLDFLAG_TOP,
		tbl_taskmiddlecategory.OLDFLAG AS OLDFLAG_MID,
		tbl_tasksubcategory.OLDFLAG AS OLDFLAG_SUB
    FROM
        ((((tbl_taskcategory
        JOIN tbl_taskmiddlecategory ON (((tbl_taskcategory.CATEGORYCODE = tbl_taskmiddlecategory.CATEGORYCODE)
            AND (tbl_taskcategory.TENANT_ID = tbl_taskmiddlecategory.TENANT_ID)
            AND (tbl_taskcategory.COMPANYID = tbl_taskmiddlecategory.COMPANYID))))
        JOIN tbl_tasksubcategory ON (((tbl_taskmiddlecategory.MCATEGORYCODE = tbl_tasksubcategory.MCATEGORYCODE)
            AND (tbl_taskmiddlecategory.TENANT_ID = tbl_tasksubcategory.TENANT_ID)
            AND (tbl_taskmiddlecategory.COMPANYID = tbl_tasksubcategory.COMPANYID))))
        JOIN tbl_taskcode ON (((tbl_tasksubcategory.SUBCATEGORYCODE = tbl_taskcode.SUBCATEGORYCODE)
            AND (tbl_tasksubcategory.TENANT_ID = tbl_taskcode.TENANT_ID)
            AND (tbl_tasksubcategory.COMPANYID = tbl_taskcode.COMPANYID))))
        LEFT JOIN tbl_task_deptinfo ON (((tbl_taskcode.TASKCODE = tbl_task_deptinfo.TASKCODE)
            AND (tbl_taskcode.TENANT_ID = tbl_task_deptinfo.TENANT_ID)
            AND (tbl_taskcode.COMPANYID = tbl_task_deptinfo.COMPANYID))))
    WHERE
        tbl_task_deptinfo.DELFLAG = '0'
            OR tbl_task_deptinfo.DELFLAG is null
            OR tbl_task_deptinfo.DELFLAG = '2';
--------------------------------------------------------
--  DDL for View VAPRDOINGDOCLIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "VAPRDOINGDOCLIST" ("DOCID", "FORMID", "ORGDOCID", "DOCTYPE", "DOCSTATE", "FUNCTIONTYPE", "HREF", "DOCTITLE", "DOCNO", "HASATTACHYN", "HASOPINIONYN", "STARTDATE", "ENDDATE", "WRITERID", "WRITERNAME", "WRITERJOBTITLE", "WRITERDEPTID", "WRITERDEPTNAME", "ISPUBLIC", "WRITERNAME2", "WRITERJOBTITLE2", "WRITERDEPTNAME2", "TENANT_ID", "COMPANYID", "APRMEMBERSN", "APRTYPE", "APRSTATE", "APRMEMBERID", "APRMEMBERNAME", "APRMEMBERNAME2", "APRMEMBERJOBTITLE", "APRMEMBERJOBTITLE2", "APRMEMBERDEPTID", "APRMEMBERDEPTNAME", "APRMEMBERDEPTNAME2", "RECEIVEDDATE", "FORMNAME", "FORMNAME2", "URGENTAPPROVAL", "COMPANYNAME", "COMPANYNAME2") AS 
  SELECT tbl_aprdocinfo.docid,
       tbl_aprdocinfo.formid, 
       tbl_aprdocinfo.orgdocid, 
       tbl_aprdocinfo.doctype, 
       CASE 
              WHEN ( tbl_aprlineinfo.aprstate = '002' and tbl_aprlineinfo.aprtype = '007' )THEN '017' 
              ELSE tbl_aprdocinfo.docstate 
       END AS DOCSTATE, 
       CASE 
              WHEN ( tbl_aprlineinfo.aprstate = '000' 
              AND    tbl_aprdocinfo.functiontype <> '004' ) THEN '002' 
              ELSE tbl_aprdocinfo.functiontype 
       END AS FUNCTIONTYPE, 
       tbl_aprdocinfo.href, 
       tbl_aprdocinfo.doctitle, 
       tbl_aprdocinfo.docno, 
       tbl_aprdocinfo.hasattachyn, 
       tbl_aprdocinfo.hasopinionyn, 
       tbl_aprdocinfo.startdate, 
       tbl_aprdocinfo.enddate, 
       tbl_aprdocinfo.writerid, 
       tbl_aprdocinfo.writername, 
       tbl_aprdocinfo.writerjobtitle, 
       tbl_aprdocinfo.writerdeptid, 
       tbl_aprdocinfo.writerdeptname, 
       tbl_aprdocinfo.ispublic, 
       tbl_aprdocinfo.writername2, 
       tbl_aprdocinfo.writerjobtitle2, 
       tbl_aprdocinfo.writerdeptname2 , 
       tbl_aprdocinfo.tenant_id, 
       tbl_aprdocinfo.companyid, 
       tbl_aprlineinfo.aprmembersn        AprMemberSN , 
       tbl_aprlineinfo.aprtype            AprType , 
       tbl_aprlineinfo.aprstate           AprState , 
       tbl_aprlineinfo.aprmemberid        AprMemberID , 
       tbl_aprlineinfo.aprmembername      AprMemberName , 
       tbl_aprlineinfo.aprmembername2     AprMemberName2 , 
       tbl_aprlineinfo.aprmemberjobtitle  AprMemberJobTitle , 
       tbl_aprlineinfo.aprmemberjobtitle2 AprMemberJobTitle2 , 
       tbl_aprlineinfo.aprmemberdeptid    AprMemberDeptID , 
       tbl_aprlineinfo.aprmemberdeptname  AprMemberDeptName , 
       tbl_aprlineinfo.aprmemberdeptname2 AprMemberDeptName2 , 
       tbl_aprlineinfo.receiveddate       ReceivedDate , 
       tbl_expaprdocinfo.formname         FormName , 
       tbl_expaprdocinfo.formname2        FormName2 , 
       tbl_expaprdocinfo.urgentapproval   UrgentApproval,
       tbl_deptmaster.extensionattribute3 companyname,
       tbl_deptmaster.compnm2 companyname2
FROM   tbl_aprdocinfo 
JOIN   tbl_aprlineinfo 
ON     tbl_aprdocinfo.docid = tbl_aprlineinfo.docid 
AND    tbl_aprdocinfo.tenant_id = tbl_aprlineinfo.tenant_id 
AND    tbl_aprdocinfo.companyid = tbl_aprlineinfo.companyid 
JOIN   tbl_expaprdocinfo 
ON     tbl_aprdocinfo.docid = tbl_expaprdocinfo.docid 
AND    tbl_aprdocinfo.tenant_id = tbl_expaprdocinfo.tenant_id 
AND    tbl_aprdocinfo.companyid = tbl_expaprdocinfo.companyid 
JOIN   tbl_deptmaster
on     tbl_aprdocinfo.companyid = tbl_deptmaster.cn
and    tbl_aprdocinfo.tenant_id = tbl_deptmaster.tenant_id
WHERE  ((tbl_aprlineinfo.aprstate = '002' 
       OR     tbl_aprlineinfo.aprstate = '005')
       AND ( tbl_aprdocinfo.functiontype <> '004'
       OR   tbl_aprlineinfo.aprtype <> '007' )
       AND     tbl_aprdocinfo.startdate is not null);
--------------------------------------------------------
--  DDL for View VAPRWILLDOCLIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "VAPRWILLDOCLIST" ("DOCID", "FORMID", "ORGDOCID", "DOCTYPE", "DOCSTATE", "FUNCTIONTYPE", "HREF", "DOCTITLE", "DOCNO", "HASATTACHYN", "HASOPINIONYN", "STARTDATE", "ENDDATE", "WRITERID", "WRITERNAME", "WRITERJOBTITLE", "WRITERDEPTID", "WRITERDEPTNAME", "ISPUBLIC", "WRITERNAME2", "WRITERJOBTITLE2", "WRITERDEPTNAME2", "TENANT_ID", "COMPANYID", "APRMEMBERSN", "APRTYPE", "APRSTATE", "APRMEMBERID", "APRMEMBERNAME", "APRMEMBERNAME2", "APRMEMBERJOBTITLE", "APRMEMBERJOBTITLE2", "APRMEMBERDEPTID", "APRMEMBERDEPTNAME", "APRMEMBERDEPTNAME2", "FORMNAME", "FORMNAME2", "URGENTAPPROVAL", "COMPANYNAME", "COMPANYNAME2") AS 
  SELECT TBL_APRDOCINFO."DOCID",TBL_APRDOCINFO."FORMID",TBL_APRDOCINFO."ORGDOCID",TBL_APRDOCINFO."DOCTYPE",TBL_APRDOCINFO."DOCSTATE",TBL_APRDOCINFO."FUNCTIONTYPE",TBL_APRDOCINFO."HREF",TBL_APRDOCINFO."DOCTITLE",TBL_APRDOCINFO."DOCNO",TBL_APRDOCINFO."HASATTACHYN",TBL_APRDOCINFO."HASOPINIONYN",TBL_APRDOCINFO."STARTDATE",TBL_APRDOCINFO."ENDDATE",TBL_APRDOCINFO."WRITERID",TBL_APRDOCINFO."WRITERNAME",TBL_APRDOCINFO."WRITERJOBTITLE",TBL_APRDOCINFO."WRITERDEPTID",TBL_APRDOCINFO."WRITERDEPTNAME",TBL_APRDOCINFO."ISPUBLIC",TBL_APRDOCINFO."WRITERNAME2",TBL_APRDOCINFO."WRITERJOBTITLE2",TBL_APRDOCINFO."WRITERDEPTNAME2" ,TBL_APRDOCINFO."TENANT_ID",TBL_APRDOCINFO."COMPANYID",
          TBL_APRLINEINFO.AprMemberSN AprMemberSN  ,
          TBL_APRLINEINFO.AprType AprType  ,
          TBL_APRLINEINFO.AprState AprState  ,
          TBL_APRLINEINFO.AprMemberID AprMemberID  ,
          TBL_APRLINEINFO.AprMemberName AprMemberName  ,
          TBL_APRLINEINFO.AprMemberName2 AprMemberName2  ,
          TBL_APRLINEINFO.AprMemberJobTitle AprMemberJobTitle  ,
          TBL_APRLINEINFO.AprMemberJobTitle2 AprMemberJobTitle2  ,
          TBL_APRLINEINFO.AprMemberDeptID AprMemberDeptID  ,
          TBL_APRLINEINFO.AprMemberDeptName AprMemberDeptName  ,
          TBL_APRLINEINFO.AprMemberDeptName2 AprMemberDeptName2  ,
          TBL_EXPAPRDOCINFO.FormName FormName  ,
          TBL_EXPAPRDOCINFO.FormName2 FormName2  ,
          TBL_EXPAPRDOCINFO.UrgentApproval UrgentApproval  ,
          TBL_DEPTMASTER.EXTENSIONATTRIBUTE3 COMPANYNAME  ,
		  TBL_DEPTMASTER.COMPNM2 COMPANYNAME2
     FROM TBL_APRDOCINFO
            JOIN TBL_APRLINEINFO    ON TBL_APRDOCINFO.DocID = TBL_APRLINEINFO.DocID AND  TBL_APRDOCINFO.TENANT_ID = TBL_APRLINEINFO.TENANT_ID AND  TBL_APRDOCINFO.COMPANYID = TBL_APRLINEINFO.COMPANYID
            JOIN TBL_EXPAPRDOCINFO    ON TBL_APRDOCINFO.DocID = TBL_EXPAPRDOCINFO.DocID AND TBL_APRDOCINFO.TENANT_ID = TBL_EXPAPRDOCINFO.TENANT_ID AND TBL_APRDOCINFO.COMPANYID = TBL_EXPAPRDOCINFO.COMPANYID
			JOIN TBL_DEPTMASTER ON TBL_APRDOCINFO.COMPANYID = TBL_DEPTMASTER.CN AND TBL_APRDOCINFO.TENANT_ID = TBL_DEPTMASTER.TENANT_ID
    WHERE  ( TBL_APRDOCINFO.StartDate IS NOT NULL );
--------------------------------------------------------
--  DDL for View VENDCHAMJODOCINFO
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "VENDCHAMJODOCINFO" ("DOCID", "FORMID", "ORGDOCID", "DOCTYPE", "DOCSTATE", "FUNCTIONTYPE", "HREF", "DOCTITLE", "DOCNO", "HASATTACHYN", "HASOPINIONYN", "STARTDATE", "ENDDATE", "WRITERID", "WRITERNAME", "WRITERJOBTITLE", "WRITERDEPTID", "WRITERDEPTNAME", "ISPUBLIC", "WRITERNAME2", "WRITERJOBTITLE2", "WRITERDEPTNAME2", "TENANT_ID", "COMPANYID", "APRMEMBERSN", "APRTYPE", "APRSTATE", "APRMEMBERID", "APRMEMBERNAME", "APRMEMBERNAME2", "APRMEMBERJOBTITLE", "APRMEMBERJOBTITLE2", "APRMEMBERDEPTID", "APRMEMBERDEPTNAME", "APRMEMBERDEPTNAME2", "RECEIVEDDATE", "FORMNAME", "FORMNAME2", "URGENTAPPROVAL", "COMPANYNAME", "COMPANYNAME2") AS 
  SELECT
        tbl_endaprdocinfo.DOCID AS DOCID,
        tbl_endaprdocinfo.FORMID AS FORMID,
        tbl_endaprdocinfo.ORGDOCID AS ORGDOCID,
        tbl_endaprdocinfo.DOCTYPE AS DOCTYPE,
        '017' AS DOCSTATE,
        '002' AS FUNCTIONTYPE,
        tbl_endaprdocinfo.HREF AS HREF,
        tbl_endaprdocinfo.DOCTITLE AS DOCTITLE,
        tbl_endaprdocinfo.DOCNO AS DOCNO,
        tbl_endaprdocinfo.HASATTACHYN AS HASATTACHYN,
        tbl_endaprdocinfo.HASOPINIONYN AS HASOPINIONYN,
        tbl_endaprdocinfo.STARTDATE AS STARTDATE,
        tbl_endaprdocinfo.ENDDATE AS ENDDATE,
        tbl_endaprdocinfo.WRITERID AS WRITERID,
        tbl_endaprdocinfo.WRITERNAME AS WRITERNAME,
        tbl_endaprdocinfo.WRITERJOBTITLE AS WRITERJOBTITLE,
        tbl_endaprdocinfo.WRITERDEPTID AS WRITERDEPTID,
        tbl_endaprdocinfo.WRITERDEPTNAME AS WRITERDEPTNAME,
        tbl_endaprdocinfo.ISPUBLIC AS ISPUBLIC,
        tbl_endaprdocinfo.WRITERNAME2 AS WRITERNAME2,
        tbl_endaprdocinfo.WRITERJOBTITLE2 AS WRITERJOBTITLE2,
        tbl_endaprdocinfo.WRITERDEPTNAME2 AS WRITERDEPTNAME2,
        tbl_endaprdocinfo.TENANT_ID AS TENANT_ID,
        tbl_endaprdocinfo.COMPANYID AS COMPANYID,
        tbl_endaprlineinfo.APRMEMBERSN AS APRMEMBERSN,
        tbl_endaprlineinfo.APRTYPE AS APRTYPE,
        tbl_endaprlineinfo.APRSTATE AS APRSTATE,
        tbl_endaprlineinfo.APRMEMBERID AS APRMEMBERID,
        tbl_endaprlineinfo.APRMEMBERNAME AS APRMEMBERNAME,
        tbl_endaprlineinfo.APRMEMBERNAME2 AS APRMEMBERNAME2,
        tbl_endaprlineinfo.APRMEMBERJOBTITLE AS APRMEMBERJOBTITLE,
        tbl_endaprlineinfo.APRMEMBERJOBTITLE2 AS APRMEMBERJOBTITLE2,
        tbl_endaprlineinfo.APRMEMBERDEPTID AS APRMEMBERDEPTID,
        tbl_endaprlineinfo.APRMEMBERDEPTNAME AS APRMEMBERDEPTNAME,
        tbl_endaprlineinfo.APRMEMBERDEPTNAME2 AS APRMEMBERDEPTNAME2,
        tbl_endaprlineinfo.RECEIVEDDATE AS RECEIVEDDATE,
        tbl_expendaprdocinfo.FORMNAME AS FORMNAME,
        tbl_expendaprdocinfo.FORMNAME2 AS FORMNAME2,
        tbl_expendaprdocinfo.URGENTAPPROVAL AS URGENTAPPROVAL,
        tbl_deptmaster.extensionattribute3    AS COMPANYNAME,
        tbl_deptmaster.compnm2 AS COMPANYNAME2
    FROM
        ((tbl_endaprdocinfo
        JOIN tbl_endaprlineinfo ON (((tbl_endaprdocinfo.DOCID = tbl_endaprlineinfo.DOCID)
            AND (tbl_endaprdocinfo.TENANT_ID = tbl_endaprlineinfo.TENANT_ID)
            AND (tbl_endaprdocinfo.COMPANYID = tbl_endaprlineinfo.COMPANYID))))
        JOIN tbl_expendaprdocinfo ON (((tbl_endaprdocinfo.DOCID = tbl_expendaprdocinfo.DOCID)
            AND (tbl_endaprdocinfo.TENANT_ID = tbl_expendaprdocinfo.TENANT_ID)
            AND (tbl_endaprdocinfo.COMPANYID = tbl_expendaprdocinfo.COMPANYID)))
        JOIN tbl_deptmaster ON ( 
              tbl_endaprdocinfo.companyid = tbl_deptmaster.cn 
       AND    tbl_endaprdocinfo.tenant_id = tbl_deptmaster.tenant_id)) 
    WHERE
        ((tbl_endaprlineinfo.APRTYPE = '007')
            AND (tbl_endaprlineinfo.APRSTATE = '002')
            AND (tbl_endaprdocinfo.docstate <> '031'));
--------------------------------------------------------
--  DDL for View VGONGRAMAPRDOINGDOCLIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "VGONGRAMAPRDOINGDOCLIST" ("DOCID", "FORMID", "ORGDOCID", "DOCTYPE", "DOCSTATE", "FUNCTIONTYPE", "HREF", "DOCTITLE", "DOCNO", "HASATTACHYN", "HASOPINIONYN", "STARTDATE", "ENDDATE", "WRITERID", "WRITERNAME", "WRITERJOBTITLE", "WRITERDEPTID", "WRITERDEPTNAME", "ISPUBLIC", "WRITERNAME2", "WRITERJOBTITLE2", "WRITERDEPTNAME2", "TENANT_ID", "COMPANYID", "APRMEMBERSN", "APRTYPE", "APRSTATE", "APRMEMBERID", "APRMEMBERNAME", "APRMEMBERNAME2", "APRMEMBERJOBTITLE", "APRMEMBERJOBTITLE2", "APRMEMBERDEPTID", "APRMEMBERDEPTNAME", "APRMEMBERDEPTNAME2", "RECEIVEDDATE", "FORMNAME", "FORMNAME2", "URGENTAPPROVAL", "COMPANYNAME", "COMPANYNAME2") AS 
  SELECT tbl_aprdocinfo.docid,
       tbl_aprdocinfo.formid, 
       tbl_aprdocinfo.orgdocid, 
       tbl_aprdocinfo.doctype, 
       tbl_aprdocinfo.docstate, 
       tbl_aprdocinfo.functiontype,
       tbl_aprdocinfo.href, 
       tbl_aprdocinfo.doctitle, 
       tbl_aprdocinfo.docno, 
       tbl_aprdocinfo.hasattachyn, 
       tbl_aprdocinfo.hasopinionyn, 
       tbl_aprdocinfo.startdate, 
       tbl_aprdocinfo.enddate, 
       tbl_aprdocinfo.writerid, 
       tbl_aprdocinfo.writername, 
       tbl_aprdocinfo.writerjobtitle, 
       tbl_aprdocinfo.writerdeptid, 
       tbl_aprdocinfo.writerdeptname, 
       tbl_aprdocinfo.ispublic, 
       tbl_aprdocinfo.writername2, 
       tbl_aprdocinfo.writerjobtitle2, 
       tbl_aprdocinfo.writerdeptname2 , 
       tbl_aprdocinfo.tenant_id, 
       tbl_aprdocinfo.companyid, 
       tbl_aprlineinfo.aprmembersn        AprMemberSN , 
       tbl_aprlineinfo.aprtype            AprType , 
       tbl_aprlineinfo.aprstate           AprState , 
       tbl_aprlineinfo.aprmemberid        AprMemberID , 
       tbl_aprlineinfo.aprmembername      AprMemberName , 
       tbl_aprlineinfo.aprmembername2     AprMemberName2 , 
       tbl_aprlineinfo.aprmemberjobtitle  AprMemberJobTitle , 
       tbl_aprlineinfo.aprmemberjobtitle2 AprMemberJobTitle2 , 
       tbl_aprlineinfo.aprmemberdeptid    AprMemberDeptID , 
       tbl_aprlineinfo.aprmemberdeptname  AprMemberDeptName , 
       tbl_aprlineinfo.aprmemberdeptname2 AprMemberDeptName2 , 
       tbl_aprlineinfo.receiveddate       ReceivedDate , 
       tbl_expaprdocinfo.formname         FormName , 
       tbl_expaprdocinfo.formname2        FormName2 , 
       tbl_expaprdocinfo.urgentapproval   UrgentApproval,
       tbl_deptmaster.extensionattribute3 AS companyname, 
       tbl_deptmaster.compnm2             AS companyname2
FROM   tbl_aprdocinfo 
JOIN   tbl_aprlineinfo 
ON     tbl_aprdocinfo.docid = tbl_aprlineinfo.docid 
AND    tbl_aprdocinfo.tenant_id = tbl_aprlineinfo.tenant_id 
AND    tbl_aprdocinfo.companyid = tbl_aprlineinfo.companyid 
JOIN   tbl_expaprdocinfo 
ON     tbl_aprdocinfo.docid = tbl_expaprdocinfo.docid 
AND    tbl_aprdocinfo.tenant_id = tbl_expaprdocinfo.tenant_id 
AND    tbl_aprdocinfo.companyid = tbl_expaprdocinfo.companyid 
JOIN   tbl_deptmaster 
ON    ( tbl_aprdocinfo.companyid = tbl_deptmaster.cn 
AND    tbl_aprdocinfo.tenant_id = tbl_deptmaster.tenant_id)
WHERE  (( tbl_aprlineinfo.aprstate = '002') 
AND    ( tbl_aprdocinfo.docstate = '015') 
AND    ( tbl_aprdocinfo.startdate IS NOT NULL ));
--------------------------------------------------------
--  DDL for View VSEARCH_CLUBGUEST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "VSEARCH_CLUBGUEST" ("C_CLUBNO", "NO", "ID", "USERNAME", "COMPANYID", "TITLE", "CONTENT", "WRITEDAY", "C_CLUBNAME", "TENANT_ID") AS 
  SELECT TBL_C_CLUBGUEST.c_clubno ,
          TBL_C_CLUBGUEST.no ,
          TBL_C_CLUBGUEST.id ,
          TBL_C_CLUBGUEST.UserName ,
          TBL_C_CLUBGUEST.companyID ,
          TBL_C_CLUBGUEST.title ,
          TBL_C_CLUBGUEST.content ,
          TBL_C_CLUBGUEST.writeday ,
          TBL_C_CLUB.C_ClubName,
          TBL_C_CLUBGUEST.tenant_ID
     FROM TBL_C_CLUBGUEST
            JOIN TBL_C_CLUB    ON TBL_C_CLUBGUEST.c_clubno = TBL_C_CLUB.C_ClubNo
                                AND TBL_C_CLUBGUEST.tenant_ID = TBL_C_CLUB.tenant_ID;
--------------------------------------------------------
--  DDL for View VTASKCLASS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "VTASKCLASS" ("CATEGORYCODE", "CNAME", "CNAME2", "MCATEGORYCODE", "MCNAME", "MCNAME2", "SUBCATEGORYCODE", "SCNAME", "SCNAME2", "TASKCODE", "TASKNAME", "TASKNAME2", "KEEPINGPERIOD", "DISPLAYRECFLAG", "SPECIALCATALOGFLAG", "SC1", "SC2", "SC3", "TEMPFLAG", "COMPANYID", "TENANT_ID", "PROCESSDEPTCODE", "PROCESSDEPTNAME", "PROCESSDEPTNAME2", "KEEPINGMETHOD", "KEEPINGPLACE", "DISPLAYRECTRASTIME", "DELFLAG", "OLDFLAG_TOP", "OLDFLAG_MID", "OLDFLAG_SUB") AS 
  SELECT TBL_TASKCATEGORY.CategoryCode ,
          TBL_TASKCATEGORY.Name CName  ,
          TBL_TASKCATEGORY.Name2 CName2  ,
          TBL_TASKMIDDLECATEGORY.MCategoryCode ,
          TBL_TASKMIDDLECATEGORY.Name MCName  ,
          TBL_TASKMIDDLECATEGORY.Name2 MCName2  ,
          TBL_TASKSUBCATEGORY.SubCategoryCode ,
          TBL_TASKSUBCATEGORY.Name SCName  ,
          TBL_TASKSUBCATEGORY.Name2 SCName2  ,
          TBL_TASKCODE.TaskCode ,
          TBL_TASKCODE.TaskName ,
          TBL_TASKCODE.TaskName2 ,
          TBL_TASKCODE.KeepingPeriod ,
          TBL_TASKCODE.DisplayRecFlag ,
          TBL_TASKCODE.SpecialCatalogFlag ,
          TBL_TASKCODE.SC1 ,
          TBL_TASKCODE.SC2 ,
          TBL_TASKCODE.SC3 ,
          TBL_TASKCODE.TempFlag ,
          TBL_TASKCODE.COMPANYID,
          TBL_TASKCODE.TENANT_ID ,
          TBL_TASK_DEPTINFO.ProcessDeptCode ,
          TBL_TASK_DEPTINFO.ProcessDeptName ,
          TBL_TASK_DEPTINFO.ProcessDeptName2 ,
          TBL_TASKCODE.KeepingMethod ,
          TBL_TASKCODE.KeepingPlace ,
          TBL_TASKCODE.DisplayRecTrasTime ,
          TBL_TASK_DEPTINFO.DelFlag,
		  TBL_TASKCATEGORY.OLDFLAG AS OLDFLAG_TOP,
	      TBL_TASKMIDDLECATEGORY.OLDFLAG AS OLDFLAG_MID,
	      TBL_TASKSUBCATEGORY.OLDFLAG AS OLDFLAG_SUB
     FROM TBL_TASKCATEGORY
            JOIN TBL_TASKMIDDLECATEGORY    ON TBL_TASKCATEGORY.CategoryCode = TBL_TASKMIDDLECATEGORY.CategoryCode AND TBL_TASKCATEGORY.TENANT_ID = TBL_TASKMIDDLECATEGORY.TENANT_ID AND TBL_TASKCATEGORY.COMPANYID = TBL_TASKMIDDLECATEGORY.COMPANYID
            JOIN TBL_TASKSUBCATEGORY    ON TBL_TASKMIDDLECATEGORY.MCategoryCode = TBL_TASKSUBCATEGORY.MCategoryCode AND TBL_TASKMIDDLECATEGORY.TENANT_ID = TBL_TASKSUBCATEGORY.TENANT_ID AND TBL_TASKMIDDLECATEGORY.COMPANYID = TBL_TASKSUBCATEGORY.COMPANYID
            JOIN TBL_TASKCODE    ON TBL_TASKSUBCATEGORY.SubCategoryCode = TBL_TASKCODE.SubCategoryCode AND TBL_TASKSUBCATEGORY.TENANT_ID = TBL_TASKCODE.TENANT_ID AND TBL_TASKSUBCATEGORY.COMPANYID = TBL_TASKCODE.COMPANYID
            LEFT JOIN TBL_TASK_DEPTINFO    ON TBL_TASKCODE.TaskCode = TBL_TASK_DEPTINFO.TaskCode AND TBL_TASKCODE.TENANT_ID = TBL_TASK_DEPTINFO.TENANT_ID AND TBL_TASKCODE.COMPANYID = TBL_TASK_DEPTINFO.COMPANYID
    WHERE  ( TBL_TASK_DEPTINFO.DelFlag = '0' )
             OR ( TBL_TASK_DEPTINFO.DelFlag IS NULL )
             OR ( TBL_TASK_DEPTINFO.DelFlag = '2' );
--------------------------------------------------------
--  DDL for Table ACAPHOTO
--------------------------------------------------------

  CREATE TABLE "ACAPHOTO" 
   (	"FILE_IMAGE" LONG RAW, 
	"EMP_CD" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table APPROVCONN
--------------------------------------------------------

  CREATE TABLE "APPROVCONN" 
   (	"INDEX_ID" CHAR(26 CHAR), 
	"DOCID" CHAR(20 CHAR), 
	"WRITERID" VARCHAR2(100 CHAR), 
	"FORMID" CHAR(10 CHAR), 
	"DOCSTATE" CHAR(3 CHAR), 
	"DRAFTDATE" DATE, 
	"CONNHTML" CLOB, 
	"CONNTITLE" VARCHAR2(200 BYTE), 
	"DOCNO" VARCHAR2(200 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table APPROVCONNKAMCO
--------------------------------------------------------

  CREATE TABLE "APPROVCONNKAMCO" 
   (	"USERID" NVARCHAR2(40), 
	"DOCID" NVARCHAR2(100), 
	"DOCSTATE" CHAR(3 BYTE), 
	"ADMINSTATE" NUMBER(*,0) DEFAULT 0, 
	"TITLE" NVARCHAR2(510), 
	"OVERTIMEDATE" DATE, 
	"STARTTIME" NVARCHAR2(20), 
	"ENDTIME" NVARCHAR2(20), 
	"YEAROVERTIME" NUMBER, 
	"MONTHOVERTIME" NUMBER, 
	"WEEKOFYEAR" NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Table APPROVCONNKAMCO_USER
--------------------------------------------------------

  CREATE TABLE "APPROVCONNKAMCO_USER" 
   (	"USERID" NVARCHAR2(40), 
	"WEEKTIME" NUMBER DEFAULT 12
   ) ;
--------------------------------------------------------
--  DDL for Table JAMES_DOMAIN
--------------------------------------------------------

  CREATE TABLE "JAMES_DOMAIN" 
   (	"DOMAIN_NAME" VARCHAR2(100 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table JAMES_MAIL
--------------------------------------------------------

  CREATE TABLE "JAMES_MAIL" 
   (	"MAILBOX_ID" NUMBER, 
	"MAIL_UID" NUMBER, 
	"MAIL_IS_ANSWERED" NUMBER, 
	"MAIL_BODY_START_OCTET" NUMBER, 
	"MAIL_CONTENT_OCTETS_COUNT" NUMBER, 
	"MAIL_IS_DELETED" NUMBER, 
	"MAIL_IS_DRAFT" NUMBER, 
	"MAIL_IS_FLAGGED" NUMBER, 
	"MAIL_DATE" TIMESTAMP (6), 
	"MAIL_MIME_TYPE" VARCHAR2(200 BYTE), 
	"MAIL_MODSEQ" NUMBER, 
	"MAIL_IS_RECENT" NUMBER, 
	"MAIL_IS_SEEN" NUMBER, 
	"MAIL_MIME_SUBTYPE" VARCHAR2(200 BYTE), 
	"MAIL_TEXTUAL_LINE_COUNT" NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Table JAMES_MAILBOX
--------------------------------------------------------

  CREATE TABLE "JAMES_MAILBOX" 
   (	"MAILBOX_ID" NUMBER, 
	"MAILBOX_HIGHEST_MODSEQ" NUMBER, 
	"MAILBOX_LAST_UID" NUMBER, 
	"MAILBOX_NAME" VARCHAR2(200 CHAR), 
	"MAILBOX_NAMESPACE" VARCHAR2(200 CHAR), 
	"MAILBOX_UID_VALIDITY" NUMBER, 
	"USER_NAME" VARCHAR2(200 CHAR)
   ) ;
--------------------------------------------------------
--  DDL for Table JAMES_MAIL_BLOB
--------------------------------------------------------

  CREATE TABLE "JAMES_MAIL_BLOB" 
   (	"MAIL_BLOB_ID" NUMBER, 
	"MAIL_BODY_STRUCTURE" VARCHAR2(4000 BYTE), 
	"MAIL_BYTES" BLOB, 
	"HEADER_BYTES" BLOB, 
	"MAILBOX_ID" NUMBER, 
	"MAIL_UID" NUMBER,
	"DISK_ID" NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Table JAMES_MAIL_DELETED_ID
--------------------------------------------------------

  CREATE TABLE "JAMES_MAIL_DELETED_ID" 
   (	"MAILBOX_ID" NUMBER, 
	"MAIL_UID" NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Table JAMES_MAIL_PROPERTY
--------------------------------------------------------

  CREATE TABLE "JAMES_MAIL_PROPERTY" 
   (	"PROPERTY_ID" NUMBER, 
	"PROPERTY_LINE_NUMBER" NUMBER, 
	"PROPERTY_LOCAL_NAME" VARCHAR2(500 BYTE), 
	"PROPERTY_NAME_SPACE" VARCHAR2(500 BYTE), 
	"PROPERTY_VALUE" VARCHAR2(1024 BYTE), 
	"MAILBOX_ID" NUMBER, 
	"MAIL_UID" NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Table JAMES_MAIL_SEARCH
--------------------------------------------------------

  CREATE TABLE "JAMES_MAIL_SEARCH" 
   (	"MAIL_SEARCH_ID" NUMBER, 
	"ATTACHED_FILENAME" CLOB, 
	"CONTENT" CLOB, 
	"RECIPIENT" CLOB, 
	"SENDER" CLOB, 
	"SUBJECT" CLOB, 
	"MAILBOX_ID" NUMBER, 
	"MAIL_UID" NUMBER, 
	"IMPORTANCE" NUMBER DEFAULT 1, 
	"MESSAGE_ID" VARCHAR2(500 BYTE),
	"SECURE_FLAG" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table JAMES_MAIL_USERFLAG
--------------------------------------------------------

  CREATE TABLE "JAMES_MAIL_USERFLAG" 
   (	"USERFLAG_ID" NUMBER, 
	"USERFLAG_NAME" VARCHAR2(500 BYTE), 
	"MAILBOX_ID" NUMBER, 
	"MAIL_UID" NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Table JAMES_RECIPIENT_REWRITE
--------------------------------------------------------

  CREATE TABLE "JAMES_RECIPIENT_REWRITE" 
   (	"DOMAIN_NAME" NVARCHAR2(100), 
	"USER_NAME" NVARCHAR2(100), 
	"TARGET_ADDRESS" CLOB
   ) ;
--------------------------------------------------------
--  DDL for Table JAMES_SUBSCRIPTION
--------------------------------------------------------

  CREATE TABLE "JAMES_SUBSCRIPTION" 
   (	"SUBSCRIPTION_ID" NUMBER, 
	"MAILBOX_NAME" VARCHAR2(200 BYTE), 
	"USER_NAME" VARCHAR2(200 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table JAMES_USER
--------------------------------------------------------

  CREATE TABLE "JAMES_USER" 
   (	"USER_NAME" NVARCHAR2(100), 
	"PASSWORD_HASH_ALGORITHM" NVARCHAR2(100), 
	"PASSWORD" NVARCHAR2(128), 
	"VERSION" NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_ADDJOB_MASTER
--------------------------------------------------------

  CREATE TABLE "JMOCHA_ADDJOB_MASTER" 
   (	"TENANT_ID" NUMBER, 
	"CN" NVARCHAR2(40), 
	"DEPTID" NVARCHAR2(40), 
	"TITLE" NVARCHAR2(100), 
	"TITLE2" NVARCHAR2(100)
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_ADDRESS_FOLDER
--------------------------------------------------------

  CREATE TABLE "JMOCHA_ADDRESS_FOLDER" 
   (	"FOLDER_ID" NUMBER, 
	"PARENT_ID" NUMBER, 
	"OWNER_ID" NVARCHAR2(100), 
	"FOLDER_TYPE" CHAR(1 BYTE), 
	"FOLDER_NAME" NVARCHAR2(100)
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_ADDRESS_GENERAL
--------------------------------------------------------

  CREATE TABLE "JMOCHA_ADDRESS_GENERAL" 
   (	"USER_ID" NVARCHAR2(100), 
	"LIST_CNT" NUMBER(11,0), 
	"LIST_TYPE" CHAR(4 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_ADDRESS_INFO
--------------------------------------------------------

  CREATE TABLE "JMOCHA_ADDRESS_INFO" 
   (	"ADDRESS_ID" NUMBER(11,0), 
	"FOLDER_ID" NUMBER(11,0), 
	"OWNER_ID" NVARCHAR2(100), 
	"CREATOR_ID" NVARCHAR2(100), 
	"CREATOR_NAME" NVARCHAR2(100), 
	"CREATOR_NAME2" NVARCHAR2(100), 
	"CREATE_DATE" DATE, 
	"MODIFIER_ID" NVARCHAR2(100), 
	"MODIFIER_NAME" NVARCHAR2(100), 
	"MODIFIER_NAME2" NVARCHAR2(100), 
	"MODIFY_DATE" DATE, 
	"S_NAME" NVARCHAR2(100), 
	"S_EMAIL" NVARCHAR2(100), 
	"S_COMPANY" NVARCHAR2(50), 
	"S_DEPT" NVARCHAR2(50), 
	"S_TITLE" NVARCHAR2(50), 
	"S_COMPANY_PHONE" NVARCHAR2(20), 
	"S_FAX" NVARCHAR2(20), 
	"S_MOBILE" NVARCHAR2(20), 
	"S_HOMEPAGE" NVARCHAR2(200), 
	"S_COMPANY_ZIP" NVARCHAR2(10), 
	"S_COMPANY_ADDR" NVARCHAR2(200), 
	"S_HOME_ZIP" NVARCHAR2(10), 
	"S_HOME_ADDR" NVARCHAR2(200), 
	"S_MEMO" NCLOB, 
	"S_TYPE" CHAR(1 BYTE), 
	"S_FURIGANA" NVARCHAR2(120)
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_ADDRESS_SEARCH
--------------------------------------------------------

  CREATE TABLE "JMOCHA_ADDRESS_SEARCH" 
   (	"ID" VARCHAR2(25 CHAR), 
	"ZIP_CODE" VARCHAR2(5 CHAR), 
	"ADDRESS" VARCHAR2(1000 CHAR), 
	"OLD_ADDRESS" VARCHAR2(1000 CHAR)
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_ADDRESS_SIMPLE
--------------------------------------------------------

  CREATE TABLE "JMOCHA_ADDRESS_SIMPLE" 
   (	"SIMPLE_IDX" NUMBER(11,0), 
	"USER_ID" NVARCHAR2(100), 
	"SIMPLE_NAME" NVARCHAR2(100), 
	"SIMPLE_EMAIL" NVARCHAR2(100)
   ) ;
--------------------------------------------------------
--  DDL for Table jmocha_address_last_sent
-- Oracle 12c 이후부터 제공된 기능: AUTO_INCREMENT = IDENTITY (https://kimvampa.tistory.com/146)
-- 삽입, 삭제가 빈번한 테이블이라, UNIQUE KEY 사용하지 않음. (* UNIQUE: TENANT_ID, CN, email)
--------------------------------------------------------

  CREATE TABLE "jmocha_address_last_sent"
   (	"SEQUENCE" NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	"TENANT_ID" NUMBER(5,0) DEFAULT 0,
	"CN" NVARCHAR2(80),
	"NAME" NVARCHAR2(100),
	"EMAIL" NVARCHAR2(100),
	"SENT_DATE" DATE DEFAULT SYS_EXTRACT_UTC(SYSTIMESTAMP)  -- 기본값으로 현재 날짜와 시간 설정
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_ALIAS
--------------------------------------------------------

  CREATE TABLE "JMOCHA_ALIAS" 
   (	"TARGET_ADDRESS" NVARCHAR2(100), 
	"ALIAS_ADDRESS" NVARCHAR2(100)
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_ALIAS_RETIRE
--------------------------------------------------------

  CREATE TABLE "JMOCHA_ALIAS_RETIRE" 
   (	"TARGET_ADDRESS" NVARCHAR2(100), 
	"ALIAS_ADDRESS" NVARCHAR2(100)
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_BIGATTACH_DOWN_LIMIT
--------------------------------------------------------

  CREATE TABLE "JMOCHA_BIGATTACH_DOWN_LIMIT" 
   (	"FILE_ID" NVARCHAR2(100), 
	"DOWNLOAD_COUNT" NUMBER, 
	"LIMIT_COUNT" NUMBER, 
	"TENANT_ID" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_CONNECTION_INFO
--------------------------------------------------------

  CREATE TABLE "JMOCHA_CONNECTION_INFO" 
   (	"SEQUENCE" NUMBER(10,0), 
	"TENANT_ID" NUMBER(11,0), 
	"USERID" NVARCHAR2(50), 
	"CONNECTIP" NVARCHAR2(50), 
	"CONNECTTIME" DATE, 
	"CONNECTBROWSER" NVARCHAR2(10), 
	"CONNECTOS" NVARCHAR2(20), 
	"CONNECTAGENT" NVARCHAR2(500)
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_DEFAULT_QUOTA
--------------------------------------------------------

  CREATE TABLE "JMOCHA_DEFAULT_QUOTA" 
   (	"DOMAIN_NAME" NVARCHAR2(100), 
	"MAX_STORAGE" NUMBER(20,5) DEFAULT 0, 
	"WARN_STORAGE" NUMBER(20,5) DEFAULT 0
   ) ;

--------------------------------------------------------
--  DDL for Table JMOCHA_COMPANY_QUOTA
--------------------------------------------------------

CREATE TABLE "JMOCHA_COMPANY_QUOTA"
(	"DOMAIN_NAME" NVARCHAR2(100),
    "COMPANY_ID" NVARCHAR2(160),
    "MAX_STORAGE" NUMBER(20,5) DEFAULT 0,
    "WARN_STORAGE" NUMBER(20,5) DEFAULT 0
) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_DEPT_MASTER
--------------------------------------------------------

  CREATE TABLE "JMOCHA_DEPT_MASTER" 
   (	"TENANT_ID" NUMBER(11,0), 
	"CN" NVARCHAR2(80), 
	"DISPLAYNAME" NVARCHAR2(100), 
	"DISPLAYNAME2" NVARCHAR2(100), 
	"USEFLAG" NVARCHAR2(4), 
	"MAIL" NVARCHAR2(100), 
	"COMPNM2" NVARCHAR2(100), 
	"DEPTLEVEL" NVARCHAR2(12), 
	"DEPT_CD_PATH" NVARCHAR2(400), 
	"DEPT_NM_PATH" NVARCHAR2(400), 
	"EXTENSIONATTRIBUTE1" NVARCHAR2(400), 
	"EXTENSIONATTRIBUTE2" NVARCHAR2(400), 
	"EXTENSIONATTRIBUTE3" NVARCHAR2(400), 
	"EXTENSIONATTRIBUTE4" NVARCHAR2(400), 
	"EXTENSIONATTRIBUTE5" NVARCHAR2(400), 
	"EXTENSIONATTRIBUTE6" NVARCHAR2(400), 
	"EXTENSIONATTRIBUTE7" NVARCHAR2(400), 
	"EXTENSIONATTRIBUTE8" NVARCHAR2(400), 
	"EXTENSIONATTRIBUTE9" NVARCHAR2(400), 
	"EXTENSIONATTRIBUTE10" NVARCHAR2(400), 
	"EXTENSIONATTRIBUTE11" NVARCHAR2(400), 
	"EXTENSIONATTRIBUTE12" NVARCHAR2(400), 
	"EXTENSIONATTRIBUTE13" NVARCHAR2(400), 
	"EXTENSIONATTRIBUTE14" NVARCHAR2(400), 
	"EXTENSIONATTRIBUTE15" NVARCHAR2(400), 
	"ADFLAG" NVARCHAR2(4), 
	"ADSPATH" NVARCHAR2(400), 
	"UPDATEDT" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_DISTRIBUTION
--------------------------------------------------------

  CREATE TABLE "JMOCHA_DISTRIBUTION" 
   (	"DOMAIN_NAME" NVARCHAR2(100), 
	"USER_NAME" NVARCHAR2(100), 
	"COMPANY_ID" NVARCHAR2(100), 
	"GROUP_NAME" NVARCHAR2(100), 
	"MAIL" VARCHAR2(100 CHAR) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_DISTRIBUTION_SUB
--------------------------------------------------------

  CREATE TABLE "JMOCHA_DISTRIBUTION_SUB" 
   (	"DOMAIN_NAME" NVARCHAR2(100), 
	"USER_NAME" NVARCHAR2(100), 
	"COMPANY_ID" NVARCHAR2(100), 
	"SUB_MAIL" NVARCHAR2(100), 
	"SUB_NAME" NVARCHAR2(100)
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_INBOX_RULE
--------------------------------------------------------

  CREATE TABLE "JMOCHA_INBOX_RULE" 
   (	"RULE_ID" NUMBER(11,0), 
	"RULE_NAME" NVARCHAR2(100), 
	"USER_ID" NVARCHAR2(100), 
	"IS_USE" NVARCHAR2(1), 
	"PRIORITY" NUMBER(11,0)
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_INBOX_RULE_SUB
--------------------------------------------------------

  CREATE TABLE "JMOCHA_INBOX_RULE_SUB" 
   (	"ITEM_ID" NUMBER(11,0), 
	"RULE_ID" NUMBER(11,0), 
	"TYPE" NVARCHAR2(45), 
	"KIND" NVARCHAR2(45), 
	"VALUE" NCLOB
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_LETTER
--------------------------------------------------------

  CREATE TABLE "JMOCHA_LETTER" 
   (	"LETTER_NO" NUMBER(*,0), 
	"DISPLAYNAME" VARCHAR2(45 CHAR), 
	"DISPLAYNAME2" VARCHAR2(45 CHAR), 
	"LETTER_ORDER" NUMBER(*,0), 
	"LETTERBOX_NO" NUMBER(*,0), 
	"LETTER_ID" VARCHAR2(510 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_LETTERBOX
--------------------------------------------------------

  CREATE TABLE "JMOCHA_LETTERBOX" 
   (	"LETTERBOX_NO" NUMBER(*,0), 
	"PARENT_LETTERBOX_NO" NUMBER(*,0), 
	"DISPLAYNAME" VARCHAR2(45 CHAR), 
	"DISPLAYNAME2" VARCHAR2(45 CHAR), 
	"COMPANY_ID" VARCHAR2(32 BYTE), 
	"TENANT_ID" NUMBER(*,0)
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_MAIL_COLOR
--------------------------------------------------------

  CREATE TABLE "JMOCHA_MAIL_COLOR" 
   (	"IMPORTANCE_COLOR" NVARCHAR2(45), 
	"INMAIL_COLOR" NVARCHAR2(45), 
	"OUTMAIL_COLOR" NVARCHAR2(45), 
	"TENANT_ID" NUMBER(11,0)
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_MAIL_COPYRIGHT
--------------------------------------------------------

  CREATE TABLE "JMOCHA_MAIL_COPYRIGHT" 
   (	"TENANT_ID" NUMBER(*,0), 
	"COPYRIGHT_TEXT" VARCHAR2(1000 BYTE) DEFAULT NULL, 
	"COMPANY_ID" VARCHAR2(80 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_MAIL_COUNTRYIP
--------------------------------------------------------

  CREATE TABLE "JMOCHA_MAIL_COUNTRYIP" 
   (	"START_IP" VARCHAR2(45 BYTE), 
	"END_IP" VARCHAR2(45 BYTE), 
	"START_IP_NUMBER" NUMBER, 
	"END_IP_NUMBER" NUMBER, 
	"COUNTRY_CODE" VARCHAR2(45 BYTE), 
	"COUNTRY_NAME" VARCHAR2(45 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_MAIL_DELETE
--------------------------------------------------------

  CREATE TABLE "JMOCHA_MAIL_DELETE" 
   (	"USER_ID" NVARCHAR2(100), 
	"FOLDER_PATH" NVARCHAR2(200), 
	"EXPIRE_TIME" NUMBER(11,0), 
	"DELETE_UNREAD" CHAR(1 BYTE), 
	"FOLDER_NAME" NVARCHAR2(100)
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_MAIL_FORWARD
--------------------------------------------------------

  CREATE TABLE "JMOCHA_MAIL_FORWARD" 
   (	"USERID" NVARCHAR2(100), 
	"FORWARD_ADDRESS" NVARCHAR2(100)
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_MAIL_GENERAL
--------------------------------------------------------

  CREATE TABLE "JMOCHA_MAIL_GENERAL" 
   (	"USER_ID" NVARCHAR2(100), 
	"LIST_COUNT" NUMBER(11,0), 
	"REFRESH_INTERVAL" NUMBER(11,0), 
	"KEEP_DELETE_LENGTH" NUMBER(11,0), 
	"PREVIEW_MODE" CHAR(3 BYTE), 
	"PREVIEW_W_LIST" NUMBER(11,0), 
	"PREVIEW_W_CONTENT" NUMBER(11,0), 
	"PREVIEW_H_LIST" NUMBER(11,0), 
	"PREVIEW_H_CONTENT" NUMBER(11,0), 
	"MAIL_SENDER_NAME" NVARCHAR2(255), 
	"PREVIEW_SUBTREE" NVARCHAR2(10) DEFAULT 'N', 
	"PREVIEW_MAIL_IMAGE" VARCHAR2(10 BYTE) DEFAULT 'Y', 
	"PREVIEW_MAIL" VARCHAR2(10) DEFAULT 'N',
	"MAIL_SEND_RESULT" VARCHAR2(10) DEFAULT 'N',
	"TEXT_OPTION" VARCHAR2(10 BYTE),
	"EDITOR_FONT_FAMILY" VARCHAR2(50),
	"EDITOR_FONT_SIZE" VARCHAR2(10),
	"DEFAULT_SEPARATE_SEND" VARCHAR2(10) DEFAULT NULL,
	"DEFAULT_CURSOR_POSITION" VARCHAR2(50) DEFAULT NULL,
	"MAIL_SEARCH_PERIOD" VARCHAR2(10) DEFAULT NULL,
	"SELF_CC_OPTION" VARCHAR2(10) DEFAULT 'none'
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_MAIL_OUTOFOFFICE
--------------------------------------------------------

  CREATE TABLE "JMOCHA_MAIL_OUTOFOFFICE" 
   (	"USER_ID" NVARCHAR2(100), 
	"OOF_STATE" NVARCHAR2(45), 
	"START_DATE" DATE, 
	"END_DATE" DATE, 
	"INTERNAL" NCLOB, 
	"EXTERNAL" NCLOB, 
	"EXTERNAL_AUDIENCE" NVARCHAR2(45)
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_MAIL_OUTOFOFFICE_SENT
--------------------------------------------------------

  CREATE TABLE "JMOCHA_MAIL_OUTOFOFFICE_SENT" 
   (	"USER_ID" NVARCHAR2(100), 
	"RECIPIENT_ID" NVARCHAR2(100), 
	"SENT_TIME" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_MAIL_POP3
--------------------------------------------------------

  CREATE TABLE "JMOCHA_MAIL_POP3" 
   (	"POP3_IDX" NUMBER(11,0), 
	"USER_ID" NVARCHAR2(100), 
	"POP3_SERVER" NVARCHAR2(50), 
	"POP3_PORT" NUMBER(11,0), 
	"POP3_USER_ID" NVARCHAR2(300), 
	"POP3_PASSWORD" NVARCHAR2(300), 
	"SAVE_FOLDER_PATH" NVARCHAR2(100), 
	"SAVE_FOLDER_NAME" NVARCHAR2(100), 
	"DELETE_YN" CHAR(1 BYTE), 
	"SSL_YN" NUMBER(11,0)
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_MAIL_POP3_LIST
--------------------------------------------------------

  CREATE TABLE "JMOCHA_MAIL_POP3_LIST" 
   (	"POP3_IDX" NUMBER(11,0), 
	"MESSAGE_ID" NVARCHAR2(200)
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_MAIL_READ
--------------------------------------------------------

  CREATE TABLE "JMOCHA_MAIL_READ" 
   (	"USER_ID" NVARCHAR2(100), 
	"MESSAGE_ID" NVARCHAR2(200), 
	"READ_DATE" DATE DEFAULT NULL, 
	"READER_EMAIL" NVARCHAR2(100), 
	"READER_NAME" NVARCHAR2(50) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_MAIL_RECALL
--------------------------------------------------------

  CREATE TABLE "JMOCHA_MAIL_RECALL" 
   (	"RECALL_IDX" NUMBER(11,0), 
	"MESSAGE_ID" NVARCHAR2(200), 
	"SENDER_EMAIL" NVARCHAR2(100), 
	"SUBJECT" NVARCHAR2(200), 
	"RECALL_DATE" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_MAIL_RECALL_DETAIL
--------------------------------------------------------

  CREATE TABLE "JMOCHA_MAIL_RECALL_DETAIL" 
   (	"RECALL_IDX" NUMBER(11,0), 
	"RECEIVER_EMAIL" NVARCHAR2(100), 
	"STATUS" NUMBER(11,0), 
	"DEL_DATE" DATE, 
	"RECEIVER_NAME" NVARCHAR2(200),
	"RECEIVER_PRIMARY_EMAIL" NVARCHAR2(100)
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_MAIL_RESERVE
--------------------------------------------------------

  CREATE TABLE "JMOCHA_MAIL_RESERVE" 
   (	"MESSAGE_ID" NVARCHAR2(50), 
	"USER_ID" NVARCHAR2(100),  -- userAccount (mailId@domainName)
	"SENDER" NVARCHAR2(80),  -- userId
	"SUBJECT" NVARCHAR2(200),
	"SEND_DATE" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_MAIL_SECURE
--------------------------------------------------------

  CREATE TABLE "JMOCHA_MAIL_SECURE" 
   (	"SECURE_ID" NUMBER(11,0), 
	"MAILBOX_ID" NUMBER(20,0), 
	"MAIL_UID" NUMBER(20,0), 
	"USER_NAME" NVARCHAR2(100), 
	"PASSWORD" NVARCHAR2(128), 
	"MAX_READ_COUNT" NUMBER(11,0), 
	"MAX_READ_DATE" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_MAIL_SECURE_READ
--------------------------------------------------------

  CREATE TABLE "JMOCHA_MAIL_SECURE_READ" 
   (	"SECURE_ID" NUMBER(11,0), 
	"READER_ID" NVARCHAR2(100), 
	"READ_COUNT" NUMBER(11,0), 
	"READ_DATE" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_MAIL_SIGNATURE
--------------------------------------------------------

  CREATE TABLE "JMOCHA_MAIL_SIGNATURE" 
   (	"USER_ID" NVARCHAR2(100), 
	"USE_FLAG" CHAR(1 BYTE), 
	"CONTENT1" NCLOB, 
	"CONTENT2" NCLOB, 
	"CONTENT3" NCLOB
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_MAIL_SIGNATURE_TEMPLATE
--------------------------------------------------------

  CREATE TABLE "JMOCHA_MAIL_SIGNATURE_TEMPLATE" 
   (	"SIGN_NO" NUMBER, 
	"CONTENT" LONG, 
	"DISPLAYNAME" VARCHAR2(45 CHAR), 
	"DISPLAYNAME2" VARCHAR2(45 CHAR), 
	"TENANT_ID" NUMBER DEFAULT 0, 
	"COMPANY_ID" VARCHAR2(45 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_RETIRED_USER
--------------------------------------------------------

  CREATE TABLE "JMOCHA_RETIRED_USER" 
   (	"USER_NAME" NVARCHAR2(100), 
	"PASSWORD_HASH_ALGORITHM" NVARCHAR2(100), 
	"PASSWORD" NVARCHAR2(128), 
	"VERSION" NUMBER(11,0)
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_SCHEDULER_SERVER
--------------------------------------------------------

  CREATE TABLE "JMOCHA_SCHEDULER_SERVER" 
   (	"SCHEDULER" NVARCHAR2(45), 
	"SERVER" NVARCHAR2(45)
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_SHARED_MAILBOX
--------------------------------------------------------

  CREATE TABLE "JMOCHA_SHARED_MAILBOX" 
   (	"TENANT_ID" NUMBER DEFAULT 0, 
	"SHARE_ID" VARCHAR2(100 CHAR), 
	"USER_ID" VARCHAR2(100 CHAR), 
	"DELETE_PERMISSION" CHAR(1 BYTE), 
	"SEND_PERMISSION" CHAR(1 BYTE), 
	"ORDERBY" NUMBER, 
	"MANAGE_PERMISSION" CHAR(1 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_STAT_MAILBOXQTY_INFO
--------------------------------------------------------

  CREATE TABLE "JMOCHA_STAT_MAILBOXQTY_INFO" 
   (	"TENANT_ID" NUMBER(11,0), 
	"USERID" NVARCHAR2(20), 
	"DT_MM" NVARCHAR2(15), 
	"QTY" NUMBER(20,0) DEFAULT 0, 
	"ALLOT" NUMBER(20,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_STAT_MAIL_COMP_FLOW_DAY
--------------------------------------------------------

  CREATE TABLE "JMOCHA_STAT_MAIL_COMP_FLOW_DAY" 
   (	"TENANT_ID" NUMBER(11,0), 
	"DT_DD" NVARCHAR2(15), 
	"SORGID" NVARCHAR2(200), 
	"RORGID" NVARCHAR2(200), 
	"CNT" NUMBER(11,0) DEFAULT 0, 
	"MAILSIZE" NUMBER(20,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_STAT_MAIL_COMP_FLOW_MON
--------------------------------------------------------

  CREATE TABLE "JMOCHA_STAT_MAIL_COMP_FLOW_MON" 
   (	"TENANT_ID" NUMBER(11,0), 
	"DT_MM" NVARCHAR2(15), 
	"SORGID" NVARCHAR2(200), 
	"RORGID" NVARCHAR2(200), 
	"CNT" NUMBER(11,0) DEFAULT 0, 
	"MAILSIZE" NUMBER(20,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_STAT_MAIL_DEPT_DAY
--------------------------------------------------------

  CREATE TABLE "JMOCHA_STAT_MAIL_DEPT_DAY" 
   (	"TENANT_ID" NUMBER(11,0), 
	"DT_DD" NVARCHAR2(15), 
	"DEPTID" NVARCHAR2(200), 
	"ORGID" NVARCHAR2(200), 
	"RECEIVEINCNT" NUMBER(11,0) DEFAULT 0, 
	"RECEIVEINSIZE" NUMBER(20,0) DEFAULT 0, 
	"RECEIVEOUTCNT" NUMBER(11,0) DEFAULT 0, 
	"RECEIVEOUTSIZE" NUMBER(20,0) DEFAULT 0, 
	"SENDINCNT" NUMBER(11,0) DEFAULT 0, 
	"SENDINSIZE" NUMBER(20,0) DEFAULT 0, 
	"SENDOUTCNT" NUMBER(11,0) DEFAULT 0, 
	"SENDOUTSIZE" NUMBER(20,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_STAT_MAIL_DEPT_MONTH
--------------------------------------------------------

  CREATE TABLE "JMOCHA_STAT_MAIL_DEPT_MONTH" 
   (	"TENANT_ID" NUMBER(11,0), 
	"DT_MM" NVARCHAR2(15), 
	"DEPTID" NVARCHAR2(200), 
	"ORGID" NVARCHAR2(200), 
	"RECEIVEINCNT" NUMBER(11,0) DEFAULT 0, 
	"RECEIVEINSIZE" NUMBER(20,0) DEFAULT 0, 
	"RECEIVEOUTCNT" NUMBER(11,0) DEFAULT 0, 
	"RECEIVEOUTSIZE" NUMBER(20,0) DEFAULT 0, 
	"SENDINCNT" NUMBER(11,0) DEFAULT 0, 
	"SENDINSIZE" NUMBER(20,0) DEFAULT 0, 
	"SENDOUTCNT" NUMBER(11,0) DEFAULT 0, 
	"SENDOUTSIZE" NUMBER(20,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_STAT_MAIL_LOG
--------------------------------------------------------

  CREATE TABLE "JMOCHA_STAT_MAIL_LOG" 
   (	"IDX" NUMBER(10,0), 
	"TENANT_ID" NUMBER(11,0), 
	"LOG_DATE" DATE, 
	"EVENT_TYPE" NVARCHAR2(20), 
	"SENDER" NVARCHAR2(100), 
	"RECIPIENT" NVARCHAR2(100), 
	"TOTALBYTES" NUMBER(11,0), 
	"MESSAGEID" NVARCHAR2(500), 
	"MESSAGESUBJECT" NCLOB, 
	"SENDER_NAME" NVARCHAR2(500), 
	"RECIPIENT_NAME" NVARCHAR2(500), 
	"ATTACHED_FILENAME" NCLOB,
	"DEPT_NAME" NVARCHAR2(200),
	"DEPT_NAME2" NVARCHAR2(200),
	"SENDER_NAME2"  NVARCHAR2(120),
	"RECIPIENT_NAME2"  NVARCHAR2(120),
	"DEPT_ID" NVARCHAR2(80),
	"COMPANY_ID" NVARCHAR2(160)
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_STAT_MAIL_USER_DAY
--------------------------------------------------------

  CREATE TABLE "JMOCHA_STAT_MAIL_USER_DAY" 
   (	"TENANT_ID" NUMBER(11,0), 
	"DT_DD" NVARCHAR2(15), 
	"USERID" NVARCHAR2(20), 
	"DEPTID" NVARCHAR2(200), 
	"ORGID" NVARCHAR2(200), 
	"RECEIVEINCNT" NUMBER(11,0) DEFAULT 0, 
	"RECEIVEINSIZE" NUMBER(20,0) DEFAULT 0, 
	"RECEIVEOUTCNT" NUMBER(11,0) DEFAULT 0, 
	"RECEIVEOUTSIZE" NUMBER(20,0) DEFAULT 0, 
	"SENDINCNT" NUMBER(11,0) DEFAULT 0, 
	"SENDINSIZE" NUMBER(20,0) DEFAULT 0, 
	"SENDOUTCNT" NUMBER(11,0) DEFAULT 0, 
	"SENDOUTSIZE" NUMBER(20,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_STAT_MAIL_USER_MONTH
--------------------------------------------------------

  CREATE TABLE "JMOCHA_STAT_MAIL_USER_MONTH" 
   (	"TENANT_ID" NUMBER(11,0), 
	"DT_MM" NVARCHAR2(15), 
	"USERID" NVARCHAR2(20), 
	"DEPTID" NVARCHAR2(200), 
	"ORGID" NVARCHAR2(200), 
	"RECEIVEINCNT" NUMBER(11,0) DEFAULT 0, 
	"RECEIVEINSIZE" NUMBER(20,0) DEFAULT 0, 
	"RECEIVEOUTCNT" NUMBER(11,0) DEFAULT 0, 
	"RECEIVEOUTSIZE" NUMBER(20,0) DEFAULT 0, 
	"SENDINCNT" NUMBER(11,0) DEFAULT 0, 
	"SENDINSIZE" NUMBER(20,0) DEFAULT 0, 
	"SENDOUTCNT" NUMBER(11,0) DEFAULT 0, 
	"SENDOUTSIZE" NUMBER(20,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_STORAGE_WARNING_SENT
--------------------------------------------------------

  CREATE TABLE "JMOCHA_STORAGE_WARNING_SENT" 
   (	"USER_ID" NVARCHAR2(100), 
	"SENT_TIME" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_TENANT
--------------------------------------------------------

  CREATE TABLE "JMOCHA_TENANT" 
   (	"TENANT_ID" NUMBER(11,0), 
	"TENANT_NAME" NVARCHAR2(100), 
	"TENANT_NAME2" NVARCHAR2(100)
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_TENANT_CONFIG
--------------------------------------------------------

  CREATE TABLE "JMOCHA_TENANT_CONFIG" 
   (	"TENANT_ID" NUMBER(11,0), 
	"PROPERTY_NAME" NVARCHAR2(100), 
	"PROPERTY_VALUE" NVARCHAR2(1000)
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_TENANT_SERVERNAME
--------------------------------------------------------

  CREATE TABLE "JMOCHA_TENANT_SERVERNAME" 
   (	"SERVER_NAME" VARCHAR2(100 BYTE), 
	"TENANT_ID" NUMBER(11,0)
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_USER_DISTRIBUTION
--------------------------------------------------------

  CREATE TABLE "JMOCHA_USER_DISTRIBUTION" 
   (	"DOMAIN_NAME" NVARCHAR2(100), 
	"USER_NAME" NVARCHAR2(100), 
	"OWNER_ID" NVARCHAR2(100), 
	"DISCLOSURE_POLICY" NVARCHAR2(100), 
	"EXPLAINATION" NVARCHAR2(100) DEFAULT NULL, 
	"DL_END_DATE" DATE DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_USER_DISTRIBUTION_MEM
--------------------------------------------------------

  CREATE TABLE "JMOCHA_USER_DISTRIBUTION_MEM" 
   (	"DOMAIN_NAME" NVARCHAR2(100), 
	"USER_NAME" NVARCHAR2(100), 
	"MEMBER_ID" NVARCHAR2(100), 
	"REG_DATE" DATE DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_USER_DIST_APPLY
--------------------------------------------------------  

   CREATE TABLE "JMOCHA_USER_DIST_APPLY" 
   (	"DOMAIN_NAME" NVARCHAR2(100) NOT NULL ENABLE, 
	"USER_NAME" NVARCHAR2(100) NOT NULL ENABLE, 
	"APPLICANT_ID" NVARCHAR2(100) NOT NULL ENABLE, 
	"APPLICANT_DATE" DATE DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_USER_LOCAL_INFO
--------------------------------------------------------

  CREATE TABLE "JMOCHA_USER_LOCAL_INFO" 
   (	"TENANT_ID" NUMBER(11,0), 
	"USERID" NVARCHAR2(50), 
	"TIMEZONE" NVARCHAR2(10), 
	"LANG" NVARCHAR2(1)
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_USER_MASTER
--------------------------------------------------------

  CREATE TABLE "JMOCHA_USER_MASTER" 
   (	"TENANT_ID" NUMBER(11,0), 
	"CN" NVARCHAR2(80), 
	"DISPLAYNAME" NVARCHAR2(120), 
	"DISPLAYNAME2" NVARCHAR2(120), 
	"MAIL" NVARCHAR2(100), 
	"MAILNICKNAME" NVARCHAR2(100), 
	"UPNNAME" NVARCHAR2(400), 
	"DEPARTMENT" NVARCHAR2(80), 
	"DESCRIPTION" NVARCHAR2(200), 
	"DESCRIPTION2" NVARCHAR2(200), 
	"DESCRIPTION3" NVARCHAR2(200), 
	"PHYSICALDELIVERYOFFICENAME" NVARCHAR2(160), 
	"COMPANY" NVARCHAR2(200), 
	"COMPANY2" NVARCHAR2(200), 
	"TITLE" NVARCHAR2(200), 
	"TITLE2" NVARCHAR2(200), 
	"TELEPHONENUMBER" NVARCHAR2(100), 
	"HOMEPHONE" NVARCHAR2(100), 
	"FACSIMILETELEPHONENUMBER" NVARCHAR2(100), 
	"MOBILE" NVARCHAR2(100), 
	"POSTALCODE" NVARCHAR2(100), 
	"STREETADDRESS" NVARCHAR2(400), 
	"INFO" NVARCHAR2(2000), 
	"EXTENSIONATTRIBUTE1" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE2" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE3" NVARCHAR2(2000), 
	"EXTENSIONATTRIBUTE4" NVARCHAR2(2000), 
	"EXTENSIONATTRIBUTE5" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE6" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE7" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE8" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE9" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE10" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE102" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE11" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE12" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE13" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE14" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE15" NVARCHAR2(200), 
	"ADSPATH" NVARCHAR2(200), 
	"SIPURI" NVARCHAR2(100), 
	"UPDATEDT" DATE, 
	"MOBILE_ENABLE" NVARCHAR2(4), 
	"MOBILE_NOTUSE" NVARCHAR2(4) DEFAULT 'N', 
	"MOBILE_PIN" NVARCHAR2(4), 
	"POSITIONCD" NVARCHAR2(40), 
	"BIRTH" NVARCHAR2(20), 
	"BIRTHTYPE" NVARCHAR2(4), 
	"PASSWORD" NVARCHAR2(100), 
	"IPADDRESS" NVARCHAR2(15), 
	"LASTLOGIN" DATE, 
	"LOGINCNT" NUMBER(11,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_USER_MASTER_RETIRE
--------------------------------------------------------

  CREATE TABLE "JMOCHA_USER_MASTER_RETIRE" 
   (	"TENANT_ID" NUMBER(11,0), 
	"CN" NVARCHAR2(20), 
	"DISPLAYNAME" NVARCHAR2(60), 
	"DISPLAYNAME2" NVARCHAR2(60), 
	"MAIL" NVARCHAR2(50), 
	"MAILNICKNAME" NVARCHAR2(50), 
	"UPNNAME" NVARCHAR2(100), 
	"DEPARTMENT" NVARCHAR2(20), 
	"DESCRIPTION" NVARCHAR2(100), 
	"DESCRIPTION2" NVARCHAR2(100), 
	"DESCRIPTION3" NVARCHAR2(100), 
	"PHYSICALDELIVERYOFFICENAME" NVARCHAR2(40), 
	"COMPANY" NVARCHAR2(100), 
	"COMPANY2" NVARCHAR2(100), 
	"TITLE" NVARCHAR2(100), 
	"TITLE2" NVARCHAR2(100), 
	"TELEPHONENUMBER" NVARCHAR2(50), 
	"HOMEPHONE" NVARCHAR2(50), 
	"FACSIMILETELEPHONENUMBER" NVARCHAR2(50), 
	"MOBILE" NVARCHAR2(50), 
	"POSTALCODE" NVARCHAR2(50), 
	"STREETADDRESS" NVARCHAR2(200), 
	"INFO" NVARCHAR2(1000), 
	"EXTENSIONATTRIBUTE1" NVARCHAR2(100), 
	"EXTENSIONATTRIBUTE2" NVARCHAR2(100), 
	"EXTENSIONATTRIBUTE3" NVARCHAR2(1000), 
	"EXTENSIONATTRIBUTE4" NVARCHAR2(100), 
	"EXTENSIONATTRIBUTE5" NVARCHAR2(100), 
	"EXTENSIONATTRIBUTE6" NVARCHAR2(100), 
	"EXTENSIONATTRIBUTE7" NVARCHAR2(100), 
	"EXTENSIONATTRIBUTE8" NVARCHAR2(100), 
	"EXTENSIONATTRIBUTE9" NVARCHAR2(100), 
	"EXTENSIONATTRIBUTE10" NVARCHAR2(100), 
	"EXTENSIONATTRIBUTE102" NVARCHAR2(100), 
	"EXTENSIONATTRIBUTE11" NVARCHAR2(100), 
	"EXTENSIONATTRIBUTE12" NVARCHAR2(100), 
	"EXTENSIONATTRIBUTE13" NVARCHAR2(100), 
	"EXTENSIONATTRIBUTE14" NVARCHAR2(100), 
	"EXTENSIONATTRIBUTE15" NVARCHAR2(100), 
	"ADSPATH" NVARCHAR2(100), 
	"SIPURI" NVARCHAR2(50), 
	"UPDATEDT" DATE, 
	"MOBILE_ENABLE" NVARCHAR2(1), 
	"MOBILE_NOTUSE" NVARCHAR2(1), 
	"MOBILE_PIN" NVARCHAR2(1), 
	"POSITIONCD" NVARCHAR2(10), 
	"BIRTH" NVARCHAR2(10), 
	"BIRTHTYPE" NVARCHAR2(1), 
	"PASSWORD" NVARCHAR2(100)
   ) ;
--------------------------------------------------------
--  DDL for Table JMOCHA_USER_QUOTA
--------------------------------------------------------

  CREATE TABLE "JMOCHA_USER_QUOTA" 
   (	"USER_ID" NVARCHAR2(100), 
	"MAX_STORAGE" NUMBER(15,5) DEFAULT 0, 
	"WARN_STORAGE" NUMBER(15,5) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table OPENJPA_SEQUENCE_TABLE
--------------------------------------------------------

  CREATE TABLE "OPENJPA_SEQUENCE_TABLE" 
   (	"ID" NUMBER, 
	"SEQUENCE_VALUE" NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Table TALK_TBLADDJOB
--------------------------------------------------------

  CREATE TABLE "TALK_TBLADDJOB" 
   (	"USERID" NVARCHAR2(20), 
	"DEPTID" NVARCHAR2(50), 
	"POSITION" NVARCHAR2(80), 
	"POSITION2" NVARCHAR2(80), 
	"ORDERBY" NVARCHAR2(100), 
	"UPDATEDATE" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table TALK_TBLAUTHLOGINTOKEN
--------------------------------------------------------

  CREATE TABLE "TALK_TBLAUTHLOGINTOKEN" 
   (	"USERID" NVARCHAR2(32), 
	"LTOKEN" NVARCHAR2(128), 
	"REGDATA" DATE, 
	"COMPID" NVARCHAR2(32), 
	"TYPE" NVARCHAR2(1)
   ) ;
--------------------------------------------------------
--  DDL for Table TALK_TBLCOMPANY
--------------------------------------------------------

  CREATE TABLE "TALK_TBLCOMPANY" 
   (	"COMPID" NVARCHAR2(32), 
	"COMPNAME" NVARCHAR2(64), 
	"COMPNAME2" NVARCHAR2(64), 
	"COMPEMAIL" NVARCHAR2(64), 
	"CORDERBY" NVARCHAR2(200), 
	"UPDATEDATE" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table TALK_TBLDATELIMIT
--------------------------------------------------------

  CREATE TABLE "TALK_TBLDATELIMIT" 
   (	"TYPE" NVARCHAR2(50), 
	"VALUE" NUMBER(11,0), 
	"REGDATE" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table TALK_TBLDEPT
--------------------------------------------------------

  CREATE TABLE "TALK_TBLDEPT" 
   (	"DEPTID" NVARCHAR2(32), 
	"DEPTNAME" NVARCHAR2(200), 
	"DEPTNAME2" NVARCHAR2(200), 
	"DEPTEMAIL" NVARCHAR2(200), 
	"PARENTDEPTID" NVARCHAR2(200), 
	"COMPID" NVARCHAR2(200), 
	"DORDERBY" NVARCHAR2(200), 
	"UPDATEDATE" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table TALK_TBLDEVICE
--------------------------------------------------------

  CREATE TABLE "TALK_TBLDEVICE" 
   (	"USERID" NVARCHAR2(32), 
	"DEVICEID" NVARCHAR2(64), 
	"DEVICETYPE" NVARCHAR2(7), 
	"DEVICESUBTYPE" NVARCHAR2(64), 
	"DEVICETOKEN" NVARCHAR2(256), 
	"PUSHSTATE" CHAR(1 BYTE), 
	"REGDATE" DATE, 
	"COMPID" NVARCHAR2(32), 
	"NOTUSED" NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Table TALK_TBLGROUP
--------------------------------------------------------

  CREATE TABLE "TALK_TBLGROUP" 
   (	"USERID" NVARCHAR2(32), 
	"GROUPID" NVARCHAR2(32), 
	"TITLE" NVARCHAR2(256), 
	"COMPID" NVARCHAR2(32), 
	"UPDATEDATE" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table TALK_TBLMEMBER
--------------------------------------------------------

  CREATE TABLE "TALK_TBLMEMBER" 
   (	"OWNERID" NVARCHAR2(32), 
	"GROUPID" NVARCHAR2(32), 
	"USERID" NVARCHAR2(32), 
	"COMPID" NVARCHAR2(32), 
	"UPDATEDATE" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table TALK_TBLMEMBERRELATION
--------------------------------------------------------

  CREATE TABLE "TALK_TBLMEMBERRELATION" 
   (	"OWNERID" NVARCHAR2(32), 
	"USERID" NVARCHAR2(32), 
	"FLAG" NUMBER(11,0), 
	"COMPID" NVARCHAR2(32)
   ) ;
--------------------------------------------------------
--  DDL for Table TALK_TBLMESSAGE
--------------------------------------------------------

  CREATE TABLE "TALK_TBLMESSAGE" 
   (	"ROOMID" NVARCHAR2(36), 
	"MSEQ" NUMBER(11,0), 
	"USERID" NVARCHAR2(32), 
	"REGDATE" NVARCHAR2(14), 
	"MESSAGE" CLOB, 
	"FILEPATH" NVARCHAR2(300), 
	"THUMNAILPATH" NVARCHAR2(300), 
	"HEIGHT" NUMBER(11,0), 
	"WIDTH" NUMBER(11,0), 
	"SIZE" NUMBER(11,0), 
	"TYPE" NVARCHAR2(10), 
	"COMPID" NVARCHAR2(32), 
	"FILELIMIT" NVARCHAR2(14)
   ) ;
--------------------------------------------------------
--  DDL for Table TALK_TBLMESSAGE_BACKUP
--------------------------------------------------------

  CREATE TABLE "TALK_TBLMESSAGE_BACKUP" 
   (	"ROOMID" NVARCHAR2(36), 
	"MSEQ" NUMBER(11,0), 
	"USERID" NVARCHAR2(32), 
	"REGDATE" NVARCHAR2(14), 
	"MESSAGE" CLOB, 
	"FILEPATH" NVARCHAR2(300) DEFAULT NULL, 
	"THUMNAILPATH" NVARCHAR2(300) DEFAULT NULL, 
	"HEIGHT" NUMBER(11,0) DEFAULT NULL, 
	"WIDTH" NUMBER(11,0) DEFAULT NULL, 
	"Size" NUMBER(11,0) DEFAULT NULL, 
	"Type" NVARCHAR2(10) DEFAULT NULL, 
	"COMPID" NVARCHAR2(32), 
	"FILELIMIT" NVARCHAR2(14) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TALK_TBLNOTIFICATION
--------------------------------------------------------

  CREATE TABLE "TALK_TBLNOTIFICATION" 
   (	"ITEMSEQ" NUMBER(11,0), 
	"USERID" NVARCHAR2(100) DEFAULT NULL, 
	"POSTDATE" DATE DEFAULT NULL, 
	"SENDER" NVARCHAR2(100) DEFAULT NULL, 
	"SUBJECT" NVARCHAR2(250) DEFAULT NULL, 
	"Type" NUMBER(11,0) DEFAULT NULL, 
	"ETCDATA" NVARCHAR2(200) DEFAULT NULL, 
	"LINKURL" NVARCHAR2(512) DEFAULT NULL, 
	"SHOWMSG" NVARCHAR2(128) DEFAULT NULL,
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TALK_TBLORGANDELETEINFO
--------------------------------------------------------

  CREATE TABLE "TALK_TBLORGANDELETEINFO" 
   (	"ID" NVARCHAR2(32), 
	"TYPE" NVARCHAR2(10), 
	"COMPID" NVARCHAR2(32), 
	"REGDATE" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table TALK_TBLROOM
--------------------------------------------------------

  CREATE TABLE "TALK_TBLROOM" 
   (	"ROOMID" NVARCHAR2(36), 
	"USERID" NVARCHAR2(32), 
	"COMPID" NVARCHAR2(32), 
	"SVRID" NVARCHAR2(64), 
	"ROOMTYPE" NVARCHAR2(2), 
	"REGDATE" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table TALK_TBLROOMMEMBER
--------------------------------------------------------

  CREATE TABLE "TALK_TBLROOMMEMBER" 
   (	"ROOMID" NVARCHAR2(36), 
	"MEMBERID" NVARCHAR2(32), 
	"MSEQ" NUMBER(11,0), 
	"STARTMSEQ" NUMBER(11,0), 
	"COMPID" NVARCHAR2(32), 
	"REGDATE" DATE, 
	"DELFLAG" NVARCHAR2(1)
   ) ;
--------------------------------------------------------
--  DDL for Table TALK_TBLROOMMEMBERCONFIG
--------------------------------------------------------

  CREATE TABLE "TALK_TBLROOMMEMBERCONFIG" 
   (	"ROOMID" NVARCHAR2(36), 
	"MEMBERID" NVARCHAR2(32), 
	"COMPID" NVARCHAR2(32), 
	"TITLE" NVARCHAR2(128) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TALK_TBLROOMSEQ
--------------------------------------------------------

  CREATE TABLE "TALK_TBLROOMSEQ" 
   (	"ROOMID" NVARCHAR2(36), 
	"USERID" NVARCHAR2(32), 
	"MAXSEQ" NUMBER(11,0), 
	"COMPID" NVARCHAR2(32)
   ) ;
--------------------------------------------------------
--  DDL for Table TALK_TBLSERVERINFO
--------------------------------------------------------

  CREATE TABLE "TALK_TBLSERVERINFO" 
   (	"ID" NVARCHAR2(64), 
	"IP" NVARCHAR2(128), 
	"PORT" NUMBER(11,0), 
	"TYPE" NUMBER(11,0), 
	"MAXSUPPORT" NUMBER(11,0), 
	"NOWCONNECT" NUMBER(11,0), 
	"STATUS" NUMBER(11,0), 
	"RELAYSVRID" NVARCHAR2(64) DEFAULT NULL, 
	"PATH" VARCHAR2(1024 BYTE) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TALK_TBLUSER
--------------------------------------------------------

  CREATE TABLE "TALK_TBLUSER" 
   (	"USERID" NVARCHAR2(32), 
	"PWD" NVARCHAR2(32), 
	"NAME" NVARCHAR2(64), 
	"NAME2" NVARCHAR2(64), 
	"EMAIL" NVARCHAR2(100), 
	"DEPTID" NVARCHAR2(32), 
	"DEPTNAME" NVARCHAR2(64), 
	"DEPTNAME2" NVARCHAR2(64) DEFAULT NULL, 
	"COMPID" NVARCHAR2(32), 
	"COMPNAME" NVARCHAR2(64), 
	"COMPNAME2" NVARCHAR2(64) DEFAULT NULL, 
	"POSITION" NVARCHAR2(200) DEFAULT NULL, 
	"POSITION2" NVARCHAR2(200) DEFAULT NULL, 
	"TITLE" NVARCHAR2(200) DEFAULT NULL, 
	"TITLE2" NVARCHAR2(200) DEFAULT NULL, 
	"TEL" NVARCHAR2(200) DEFAULT NULL, 
	"MOBILE" NVARCHAR2(200) DEFAULT NULL, 
	"MAINDEPT" NUMBER(11,0) DEFAULT NULL, 
	"ORDERBY" NVARCHAR2(200) DEFAULT NULL, 
	"PROFILEIMAGE" NVARCHAR2(250) DEFAULT NULL, 
	"PROFILEIMAGE_S" NVARCHAR2(250) DEFAULT NULL, 
	"USEMOBILE" NVARCHAR2(1) DEFAULT NULL, 
	"UPDATEDATE" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table TALK_TBLUSERINFO
--------------------------------------------------------

  CREATE TABLE "TALK_TBLUSERINFO" 
   (	"USERID" NVARCHAR2(32), 
	"COMPID" NVARCHAR2(32), 
	"LOGNUMBEROKEN" NVARCHAR2(128) DEFAULT NULL, 
	"LANG" CHAR(1 BYTE) DEFAULT NULL, 
	"MESSAGE" NVARCHAR2(256) DEFAULT NULL, 
	"DEFAULTSVRID" NVARCHAR2(64) DEFAULT NULL, 
	"PCSVRID" NVARCHAR2(64) DEFAULT NULL, 
	"MOBLIESVRID" NVARCHAR2(64) DEFAULT NULL, 
	"STATUS" NUMBER(11,0) DEFAULT NULL, 
	"STATUSMOBILE" NUMBER(11,0) DEFAULT NULL, 
	"PCCONNECTTIME" DATE DEFAULT NULL, 
	"MOBILECONNECTTIME" DATE DEFAULT NULL, 
	"PCDISCONNECTTIME" DATE DEFAULT NULL, 
	"MOBILEDISCONNECTTIME" DATE DEFAULT NULL, 
	"UPDATEDATE" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table TALK_TBLVERSION
--------------------------------------------------------

  CREATE TABLE "TALK_TBLVERSION" 
   (	"TYPE" NVARCHAR2(50), 
	"VALUE" NVARCHAR2(100), 
	"REGDATE" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table TALK_TBL_ADM_DEFALUTSERVER
--------------------------------------------------------

  CREATE TABLE "TALK_TBL_ADM_DEFALUTSERVER" 
   (	"SERVERID" NVARCHAR2(64)
   ) ;
--------------------------------------------------------
--  DDL for Table TALK_TBL_API_ACCESSKEY
--------------------------------------------------------

  CREATE TABLE "TALK_TBL_API_ACCESSKEY" 
   (	"NAME" NVARCHAR2(50), 
	"API" NVARCHAR2(200), 
	"KEY" NVARCHAR2(100)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_ACCESS_COUNTRY
--------------------------------------------------------

  CREATE TABLE "TBL_ACCESS_COUNTRY" 
   (	"TENANT_ID" NUMBER(20,0), 
	"COUNTRY_CODE" NVARCHAR2(800)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_ACCESS_ID
--------------------------------------------------------

  CREATE TABLE "TBL_ACCESS_ID" 
   (	"ACCESSNO" NUMBER(5,0), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"CN" VARCHAR2(80 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_ACCESS_IP
--------------------------------------------------------

  CREATE TABLE "TBL_ACCESS_IP" 
   (	"IPNO" NUMBER(*,0), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"IPADDRESS" VARCHAR2(100 BYTE), 
	"ACCESS" VARCHAR2(10 BYTE), 
	"EXPLANATION" VARCHAR2(200 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_ADDJOBMASTER
--------------------------------------------------------

  CREATE TABLE "TBL_ADDJOBMASTER" 
   (	"CN" NVARCHAR2(40), 
	"DEPTID" NVARCHAR2(40), 
	"TITLE" NVARCHAR2(100), 
	"TITLE2" NVARCHAR2(100),
    "ROLE" NVARCHAR2(100),
    "ROLE2" NVARCHAR2(100),
	"POSITIONCD" NVARCHAR2(20), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"ORDERBY" NVARCHAR2(200) DEFAULT NULL, 
	"JOBID" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"ROLEID" VARCHAR2(100 BYTE) DEFAULT NULL,
	"PROXY" VARCHAR2(200 BYTE),
	"MANUAL_FLAG" NVARCHAR2(2) DEFAULT NULL,
	"ROLL_INFO" NVARCHAR2(200) DEFAULT 'c=0;k=0;g=0;a=0;i=0;n=0;l=0;w=0;m=0;'
   ) ;
-------------------------------------------------------- 
--  DDL for Table TBL_ADMIN_ACCESS_IP
--------------------------------------------------------

  CREATE TABLE "TBL_ADMIN_ACCESS_IP" 
   (	"IPNO" NUMBER(*,0), 
	"TENANT_ID" NUMBER(5,0), 
	"IPADDRESS" NVARCHAR2(100), 
	"ALLOW_ACCESS" NVARCHAR2(10) DEFAULT 'NO', 
	"EXPLANATION" NVARCHAR2(200) DEFAULT NULL
   );
--------------------------------------------------------
--  DDL for Table TBL_ADMINRECEIPTGROUP_MAIN
--------------------------------------------------------

  CREATE TABLE "TBL_ADMINRECEIPTGROUP_MAIN" 
   (	"MAINID" NUMBER(10,0), 
	"MAINNAME" NVARCHAR2(200), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" NVARCHAR2(20)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_ADMINRECEIPTGROUP_SUB
--------------------------------------------------------

  CREATE TABLE "TBL_ADMINRECEIPTGROUP_SUB" 
   (	"MAINID" NUMBER(10,0), 
	"SUBID" NUMBER(10,0), 
	"DEPTID" VARCHAR2(100 CHAR), 
	"DEPTNAME" NVARCHAR2(100), 
	"COMPANYID" VARCHAR2(10 CHAR), 
	"DEPTNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0,
    "EXTRECEPTYN" VARCHAR2(5) DEFAULT 'N'
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_APRATTACHINFO
--------------------------------------------------------

  CREATE TABLE "TBL_APRATTACHINFO" 
   (	"DOCID" CHAR(20 CHAR), 
	"ATTACHFILESN" NUMBER(10,0), 
	"VIEWORDER" NUMBER(10,0), 
	"ATTACHFILENAME" NVARCHAR2(510), 
	"ATTACHFILEHREF" NVARCHAR2(510), 
	"ATTACHFILESIZE" FLOAT(126), 
	"ATTACHUSERID" VARCHAR2(100 CHAR), 
	"ATTACHUSERNAME" NVARCHAR2(100), 
	"ATTACHUSERJOBTITLE" NVARCHAR2(20), 
	"ATTACHUSERDEPTID" VARCHAR2(100 CHAR), 
	"ATTACHUSERDEPTNAME" NVARCHAR2(100), 
	"PAGENUM" NUMBER(10,0), 
	"DISPLAYNAME" NVARCHAR2(300), 
	"BODYATTACH" CHAR(1 CHAR), 
	"ATTACHUSERNAME2" NVARCHAR2(100), 
	"ATTACHUSERJOBTITLE2" NVARCHAR2(100), 
	"ATTACHUSERDEPTNAME2" NVARCHAR2(200), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE),
	"ISBIGATTACH" CHAR(1 CHAR) DEFAULT 'N',
    "ISBIGATTACHDEL" CHAR(1 CHAR) DEFAULT 'N',
    "SAVEDATE" DATE DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_APRDOCATTACHINFO
--------------------------------------------------------

  CREATE TABLE "TBL_APRDOCATTACHINFO" 
   (	"DOCID" CHAR(20 CHAR), 
	"ATTACHSN" NUMBER(10,0), 
	"ATTACHDOCNAME" NVARCHAR2(510), 
	"ATTACHDOCURL" NVARCHAR2(510), 
	"SUBATTACHYN" CHAR(1 CHAR), 
	"ATTACHUSERID" VARCHAR2(100 CHAR), 
	"ATTACHUSERNAME" NVARCHAR2(100), 
	"ATTACHUSERDEPTID" VARCHAR2(100 CHAR), 
	"ATTACHUSERDEPTNAME" NVARCHAR2(100), 
	"ATTACHUSERJOBTITLE" NVARCHAR2(100), 
	"ATTACHUSERNAME2" NVARCHAR2(100), 
	"ATTACHUSERJOBTITLE2" NVARCHAR2(100), 
	"ATTACHUSERDEPTNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_APRDOCGROUPINFO
--------------------------------------------------------

  CREATE TABLE "TBL_APRDOCGROUPINFO" 
   (	"DOCID" NVARCHAR2(80), 
	"TABSN" NUMBER(10,0), 
	"GROUPDOCSN" NVARCHAR2(80), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" NVARCHAR2(20),
    "TYPE" CHAR(10 CHAR) NOT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_APRDOCINFO
--------------------------------------------------------

  CREATE TABLE "TBL_APRDOCINFO" 
   (	"DOCID" CHAR(20 CHAR), 
	"FORMID" CHAR(10 CHAR), 
	"ORGDOCID" CHAR(20 CHAR), 
	"DOCTYPE" CHAR(3 CHAR), 
	"DOCSTATE" CHAR(3 CHAR), 
	"FUNCTIONTYPE" CHAR(3 CHAR), 
	"HREF" NVARCHAR2(510), 
	"DOCTITLE" NVARCHAR2(510), 
	"DOCNO" NVARCHAR2(100), 
	"HASATTACHYN" CHAR(1 CHAR), 
	"HASOPINIONYN" CHAR(1 CHAR), 
	"STARTDATE" DATE, 
	"ENDDATE" DATE, 
	"WRITERID" VARCHAR2(100 CHAR), 
	"WRITERNAME" NVARCHAR2(100), 
	"WRITERJOBTITLE" NVARCHAR2(100), 
	"WRITERDEPTID" VARCHAR2(100 CHAR), 
	"WRITERDEPTNAME" NVARCHAR2(100), 
	"ISPUBLIC" CHAR(1 CHAR), 
	"WRITERNAME2" NVARCHAR2(100), 
	"WRITERJOBTITLE2" NVARCHAR2(100), 
	"WRITERDEPTNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_APRLINEINFO
--------------------------------------------------------

  CREATE TABLE "TBL_APRLINEINFO" 
   (	"DOCID" CHAR(20 CHAR), 
	"APRMEMBERSN" NUMBER(10,0), 
	"APRTYPE" CHAR(3 CHAR), 
	"APRSTATE" CHAR(3 CHAR), 
	"APRMEMBERID" VARCHAR2(100 CHAR), 
	"APRMEMBERISDEPTYN" CHAR(1 CHAR), 
	"APRMEMBERNAME" NVARCHAR2(100), 
	"APRMEMBERJOBTITLE" NVARCHAR2(100), 
	"APRMEMBERDEPTID" VARCHAR2(100 CHAR), 
	"APRMEMBERDEPTNAME" NVARCHAR2(100), 
	"APRMEMBERLDAPPATH" VARCHAR2(100 CHAR), 
	"RECEIVEDDATE" DATE, 
	"PROCESSDATE" DATE, 
	"REASONDONOTAPPROV" NVARCHAR2(510), 
	"ISPROPOSERYN" CHAR(1 CHAR), 
	"ISBRIEFUSERYN" CHAR(1 CHAR), 
	"APRMEMBERNAME2" NVARCHAR2(100), 
	"APRMEMBERJOBTITLE2" NVARCHAR2(100), 
	"APRMEMBERDEPTNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_APROPINIONINFO
--------------------------------------------------------

  CREATE TABLE "TBL_APROPINIONINFO" 
   (	"DOCID" CHAR(20 CHAR), 
	"USERID" VARCHAR2(100 CHAR), 
	"OPINIONGB" CHAR(3 CHAR), 
	"CONTENT" NCLOB, 
	"USERNAME" NVARCHAR2(100), 
	"USERJOBTITLE" NVARCHAR2(100), 
	"USERDEPTID" VARCHAR2(100 CHAR), 
	"USERDEPTNAME" NVARCHAR2(100), 
	"OPINIONSN" NUMBER(10,0), 
	"USERNAME2" NVARCHAR2(100), 
	"USERJOBTITLE2" NVARCHAR2(100), 
	"USERDEPTNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_APRRECEIPTPROCESSINFO
--------------------------------------------------------

  CREATE TABLE "TBL_APRRECEIPTPROCESSINFO" 
   (	"RECEIVESN" NUMBER(10,0), 
	"DOCID" CHAR(20 CHAR), 
	"SENTDEPTID" VARCHAR2(100 CHAR), 
	"SENTDEPTNAME" NVARCHAR2(100), 
	"RECEIVEDDEPTID" VARCHAR2(100 CHAR), 
	"RECEIVEDDEPTNAME" NVARCHAR2(100), 
	"DOCSTATE" CHAR(3 CHAR), 
	"APRSTATE" CHAR(3 CHAR), 
	"PROCESSDATE" DATE, 
	"PROCESSYN" CHAR(1 CHAR), 
	"PROCESSDOCID" CHAR(20 CHAR), 
	"PROCESSORID" VARCHAR2(100 CHAR), 
	"PROCESSORNAME" NVARCHAR2(100), 
	"PROCESSORJOBTITLE" NVARCHAR2(100), 
	"PARENTSDOCID" VARCHAR2(100 BYTE), 
	"SENTDEPTNAME2" NVARCHAR2(100), 
	"RECEIVEDDEPTNAME2" NVARCHAR2(100), 
	"PROCESSORNAME2" NVARCHAR2(100), 
	"PROCESSORJOBTITLE2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE),
	"ROOTDOCID" VARCHAR2(80)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_ATTENDANT
--------------------------------------------------------

  CREATE TABLE "TBL_ATTENDANT" 
   (	"SCHEDULEID" NUMBER(10,0), 
	"ATTENDANTID" NVARCHAR2(50), 
	"ATTENDANTNAME" NVARCHAR2(50), 
	"ATTENDANTNAME2" NVARCHAR2(50), 
	"ATTENDANTDEPTNAME" NVARCHAR2(50), 
	"ATTENDANTDEPTNAME2" NVARCHAR2(50), 
	"STATUS" NUMBER(5,0), 
	"RESPONSEDATE" DATE, 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(40 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_ATTITUDE
--------------------------------------------------------

  CREATE TABLE "TBL_ATTITUDE" 
   (	"ATTITUDE_ID" NUMBER(20,0), 
	"COMPANY_ID" NVARCHAR2(80), 
	"TENANT_ID" NUMBER(5,0), 
	"WRITER_ID" NVARCHAR2(80), 
	"DEPT_ID" NVARCHAR2(80), 
	"START_DATE" DATE, 
	"END_DATE" DATE, 
	"MODAPPL" CHAR(1 BYTE) DEFAULT 0, 
	"REGION" NVARCHAR2(200), 
	"MOBILE" NVARCHAR2(50), 
	"CONTENT" NVARCHAR2(2000), 
	"IP" NVARCHAR2(60), 
	"DATE_TYPE" CHAR(1 BYTE), 
	"TYPE_ID" NVARCHAR2(30), 
	"BIZSUB" NVARCHAR2(120),
	"ATTEND_TYPE" char(1) DEFAULT '0',
  	"LATITUDE" NUMBER(20,15) DEFAULT NULL,
  	"LONGITUDE" NUMBER(20,15) DEFAULT NULL,
  	"WORK_STATUS" CHAR(1) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_ATTITUDE_ANNUAL
--------------------------------------------------------

  CREATE TABLE "TBL_ATTITUDE_ANNUAL" 
   (	"USER_ID" VARCHAR2(80 BYTE), 
	"MONTHLY_HOLIDAY_CNT" NUMBER(4,2) DEFAULT 0.00, 
	"ANNUAL_HOLIDAY_CNT" NUMBER(4,2) DEFAULT 0.00, 
	"ADDITIONAL_HOLIDAY_CNT" NUMBER(4,2) DEFAULT 0.00, 
	"JOIN_DATE" TIMESTAMP (6), 
	"COMPANY_ID" VARCHAR2(200 BYTE), 
	"TENANT_ID" NUMBER(*,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_ATTITUDE_ANNUAL_CANAPPL
--------------------------------------------------------

  CREATE TABLE "TBL_ATTITUDE_ANNUAL_CANAPPL" 
   (	"ATTITUDE_ID" NUMBER(20,0), 
	"APPL_CNT" NUMBER(11,0), 
	"COMPANY_ID" NVARCHAR2(80), 
	"TENANT_ID" NUMBER(5,0), 
	"WRITER_ID" NVARCHAR2(80), 
	"WRITER_NAME" NVARCHAR2(100) DEFAULT NULL, 
	"WRITER_NAME2" NVARCHAR2(100) DEFAULT NULL, 
	"WRITER_TITLE" NVARCHAR2(200) DEFAULT NULL, 
	"WRITER_TITLE2" NVARCHAR2(200) DEFAULT NULL, 
	"WRITER_DEPT_ID" NVARCHAR2(80), 
	"WRITER_DEPT_NAME" NVARCHAR2(100) DEFAULT NULL, 
	"WRITER_DEPT_NAME2" NVARCHAR2(100) DEFAULT NULL, 
	"DELFLAG" CHAR(1 BYTE) DEFAULT '0', 
	"APPR_USER_ID" NVARCHAR2(80) DEFAULT NULL, 
	"APPR_DATE" DATE DEFAULT NULL, 
	"APPR_STATUS" CHAR(1 BYTE) DEFAULT '0', 
	"CONTENT" NVARCHAR2(2000) DEFAULT NULL, 
	"APPR_USER_NAME" NVARCHAR2(100) DEFAULT NULL, 
	"APPR_USER_NAME2" NVARCHAR2(100) DEFAULT NULL, 
	"APPL_DATE" DATE DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_ATTITUDE_ANNUAL_CONF
--------------------------------------------------------

  CREATE TABLE "TBL_ATTITUDE_ANNUAL_CONF" 
   (	"COMPANY_ID" NVARCHAR2(80), 
	"TENANT_ID" NUMBER(5,0), 
	"ANNUAL_CANCEL_RULE" CHAR(1 BYTE) DEFAULT '1', 
	"USE_ANNUAL_AUTO_GNRT" CHAR(1 BYTE) DEFAULT '1', 
	"ANNUAL_GNRT_STD" CHAR(1 BYTE) DEFAULT '1', 
	"INITIAL_DATE" DATE DEFAULT NULL, 
	"USE_MINUS_ANNUAL" CHAR(1 BYTE) DEFAULT '1', 
	"USE_ANNUAL_TMNT" CHAR(1 BYTE) DEFAULT '1', 
	"ROUND_OFF_RULE" CHAR(1 BYTE) DEFAULT '1', 
	"CONF_SET_DATE" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_ATTITUDE_ANNUAL_HISTORY
--------------------------------------------------------

  CREATE TABLE "TBL_ATTITUDE_ANNUAL_HISTORY" 
   (	"ANNUAL_HISTORY_ID" NUMBER(20,0), 
	"USER_ID" NVARCHAR2(80), 
	"ORIGIN_ANNUAL_CNT" NUMBER(4,2), 
	"CHANGE_ANNUAL_CNT" NUMBER(4,2), 
	"CHANGE_REASON" NVARCHAR2(2000), 
	"CHANGE_DATE" DATE, 
	"CHANGE_USER_ID" NVARCHAR2(80), 
	"COMPANY_ID" NVARCHAR2(200), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_ATTITUDE_APR_CONN
--------------------------------------------------------

  CREATE TABLE "TBL_ATTITUDE_APR_CONN" 
   (	"ATTITUDE_ID" NUMBER(20,0), 
	"USER_ID" NVARCHAR2(80) DEFAULT NULL, 
	"ANNUAL_DOC_ID" NVARCHAR2(80), 
	"CANCEL_DOC_ID" NVARCHAR2(80) DEFAULT NULL, 
	"ANNUAL_APPR_STATUS" CHAR(1 BYTE) DEFAULT NULL, 
	"CANCEL_APPR_STATUS" CHAR(1 BYTE) DEFAULT NULL, 
	"COMPANY_ID" NVARCHAR2(80), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_ATTITUDE_AUTH
--------------------------------------------------------

  CREATE TABLE "TBL_ATTITUDE_AUTH" 
   (	"USER_ID" NVARCHAR2(80), 
	"TENANT_ID" NUMBER(5,0), 
	"AUTH_DEPT_ID" NVARCHAR2(80), 
	"COMPANY_ID" NVARCHAR2(80), 
	"AUTH_TYPE" NVARCHAR2(10) DEFAULT 'R'
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_ATTITUDE_CONF
--------------------------------------------------------

  CREATE TABLE "TBL_ATTITUDE_CONF" 
   (	"COMPANY_ID" NVARCHAR2(80), 
	"TENANT_ID" NUMBER(5,0), 
	"WORK_STARTTIME" NVARCHAR2(40) DEFAULT '09:00', 
	"WORK_ENDTIME" NVARCHAR2(40) DEFAULT '18:00', 
	"CLOSED_DAY" NVARCHAR2(30) DEFAULT '1,0,0,0,0,0,1', 
	"ATTITUDE_MOD_APPL" CHAR(1 BYTE) DEFAULT '1', 
	"CLOSED_DATE_ATTITUDE" CHAR(1 BYTE) DEFAULT '1', 
	"CONF_SET_DATE" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_ATTITUDE_FORM
--------------------------------------------------------

  CREATE TABLE "TBL_ATTITUDE_FORM" 
   (	"FORM_ID" NUMBER(11,0), 
	"TENANT_ID" NUMBER(5,0), 
	"FORM_NAME" NVARCHAR2(80), 
	"FORM_NAME2" NVARCHAR2(80), 
	"FORM_HTML" NCLOB,
	"FORM_HTML2" NCLOB
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_ATTITUDE_MODAPPL
--------------------------------------------------------

  CREATE TABLE "TBL_ATTITUDE_MODAPPL" 
   (	"ATTITUDE_ID" NUMBER, 
	"APPL_CNT" NUMBER(11,0), 
	"COMPANY_ID" NVARCHAR2(80), 
	"TENANT_ID" NUMBER(5,0), 
	"WRITER_ID" NVARCHAR2(80), 
	"WRITER_NAME" NVARCHAR2(100), 
	"WRITER_NAME2" NVARCHAR2(100), 
	"WRITER_TITLE" NVARCHAR2(200), 
	"WRITER_TITLE2" NVARCHAR2(200), 
	"WRITER_DEPT_ID" NVARCHAR2(80), 
	"WRITER_DEPT_NAME" NVARCHAR2(100), 
	"WRITER_DEPT_NAME2" NVARCHAR2(100), 
	"ORIGIN_DATE" DATE, 
	"CHANGE_DATE" DATE, 
	"DELFLAG" CHAR(1 BYTE) DEFAULT '0', 
	"APPR_USER_ID" NVARCHAR2(80), 
	"APPR_DATE" DATE, 
	"APPR_STATUS" CHAR(1 BYTE) DEFAULT '0', 
	"CONTENT" NCLOB, 
	"APPR_USER_NAME" NVARCHAR2(100), 
	"APPR_USER_NAME2" NVARCHAR2(100), 
	"APPL_DATE" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_ATTITUDE_MODAPPL_HISTORY
--------------------------------------------------------

  CREATE TABLE "TBL_ATTITUDE_MODAPPL_HISTORY" 
   (	"ATTITUDE_ID" NUMBER, 
	"MOD_CNT" NUMBER(11,0), 
	"COMPANY_ID" NVARCHAR2(80), 
	"TENANT_ID" NUMBER(5,0), 
	"WRITER_ID" NVARCHAR2(80), 
	"WRITER_NAME" NVARCHAR2(100), 
	"WRITER_NAME2" NVARCHAR2(100), 
	"WRITER_TITLE" NVARCHAR2(200), 
	"WRITER_TITLE2" NVARCHAR2(200), 
	"WRITER_DEPT_ID" NVARCHAR2(80), 
	"WRITER_DEPT_NAME" NVARCHAR2(100), 
	"WRITER_DEPT_NAME2" NVARCHAR2(100), 
	"ORIGIN_STARTDATE" DATE, 
	"ORIGIN_ENDDATE" DATE, 
	"CHANGE_STARTDATE" DATE, 
	"CHANGE_ENDDATE" DATE, 
	"APPR_USER_ID" NVARCHAR2(80), 
	"APPR_USER_NAME" NVARCHAR2(100), 
	"APPR_USER_NAME2" NVARCHAR2(100), 
	"APPR_DATE" DATE, 
	"ORIGIN_CONTENT" NCLOB, 
	"CHANGE_CONTENT" NCLOB, 
	"ORIGIN_REGION" NVARCHAR2(200), 
	"ORIGIN_MOBILE" NVARCHAR2(50), 
	"ORIGIN_BIZSUB" NVARCHAR2(120), 
	"ORIGIN_IP" NVARCHAR2(60), 
	"ORIGIN_TYPE_ID" NVARCHAR2(30), 
	"CHANGE_REGION" NVARCHAR2(200), 
	"CHANGE_MOBILE" NVARCHAR2(50), 
	"CHANGE_BIZSUB" NVARCHAR2(120), 
	"CHANGE_IP" NVARCHAR2(60), 
	"CHANGE_TYPE_ID" NVARCHAR2(30), 
	"ORIGIN_TYPE_NAME" NVARCHAR2(120), 
	"ORIGIN_TYPE_NAME2" NVARCHAR2(120), 
	"CHANGE_TYPE_NAME" NVARCHAR2(120), 
	"CHANGE_TYPE_NAME2" NVARCHAR2(120), 
	"ORIGIN_DATE_TYPE" NVARCHAR2(45), 
	"CHANGE_DATE_TYPE" NVARCHAR2(45)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_ATTITUDE_TYPE
--------------------------------------------------------

  CREATE TABLE "TBL_ATTITUDE_TYPE" 
   (	"ORDER" NUMBER, 
	"TYPE_ID" NVARCHAR2(30), 
	"COMPANY_ID" NVARCHAR2(80), 
	"TENANT_ID" NUMBER(5,0), 
	"TYPE_NAME" NVARCHAR2(120), 
	"TYPE_NAME2" NVARCHAR2(120), 
	"ISUSE" CHAR(1 BYTE) DEFAULT '1', 
	"IMG_PATH" NVARCHAR2(400), 
	"PARENT_ID" NVARCHAR2(30), 
	"FORM_ID" NUMBER(11,0), 
	"ISADD" CHAR(1 BYTE) DEFAULT '0', 
	"ISDEL" CHAR(1 BYTE) DEFAULT '0'
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_ATTITUDE_USER_CONF
--------------------------------------------------------

  CREATE TABLE "TBL_ATTITUDE_USER_CONF" 
   (	"USER_ID" NVARCHAR2(80), 
	"TENANT_ID" NUMBER(5,0), 
	"WORK_STARTTIME" NVARCHAR2(40), 
	"WORK_ENDTIME" NVARCHAR2(40), 
	"COMPANY_ID" NVARCHAR2(80), 
	"DEPT_ID" NVARCHAR2(80)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_AUDIO_VISUALRECEXINFO
--------------------------------------------------------

  CREATE TABLE "TBL_AUDIO_VISUALRECEXINFO" 
   (	"RECORDID" VARCHAR2(68 BYTE), 
	"SEPERATEATTACHNO" CHAR(2 CHAR), 
	"SUMMARY" NVARCHAR2(1020), 
	"RECORDTYPE" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_AUDIO_VISUALRECEXINFO_TEMP
--------------------------------------------------------

  CREATE TABLE "TBL_AUDIO_VISUALRECEXINFO_TEMP" 
   (	"DOCID" CHAR(20 BYTE), 
	"RECORDID" VARCHAR2(200 BYTE), 
	"SEPERATEATTACHNO" CHAR(2 BYTE), 
	"SUMMARY" NVARCHAR2(1020), 
	"RECORDTYPE" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_AUTODOCNUM_ITEM
--------------------------------------------------------

  CREATE TABLE "TBL_AUTODOCNUM_ITEM" 
   (	"FORMID" CHAR(10 BYTE), 
	"KEEPPERIOD" NVARCHAR2(20) DEFAULT NULL, 
	"SECURITYLEVEL" VARCHAR2(4 BYTE), 
	"ISPUBLIC" VARCHAR2(4 BYTE), 
	"ITEMCODE" VARCHAR2(20 BYTE), 
	"ITEMNAME" VARCHAR2(100 BYTE), 
	"ITEMNAME2" VARCHAR2(100 BYTE), 
	"USEFLAG" VARCHAR2(1 BYTE), 
	"KEEPPERIODCODE" VARCHAR2(100 BYTE), 
	"COMPANYID" VARCHAR2(20 BYTE), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_BOARD_APPRLIST
--------------------------------------------------------

  CREATE TABLE "TBL_BOARD_APPRLIST" 
   (	"BOARDID" NCHAR(38), 
	"APPRUSERID" NVARCHAR2(20), 
	"TENANT_ID" NUMBER(5,0) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_BOARD_BOARDBACKGROUNDINFO
--------------------------------------------------------

  CREATE TABLE "TBL_BOARD_BOARDBACKGROUNDINFO" 
   (	"BACKGROUNDID" NVARCHAR2(255), 
	"ORGFILENAME" NVARCHAR2(255), 
	"SAVEFILENAME" NVARCHAR2(255), 
	"REGUSERID" NVARCHAR2(255), 
	"REGDATE" NVARCHAR2(255), 
	"ISUSE" NVARCHAR2(255), 
	"SN" NVARCHAR2(255), 
	"WIDTH" NVARCHAR2(255), 
	"HEIGHT" NVARCHAR2(255), 
	"TENANT_ID" NUMBER(5,0) DEFAULT NULL, 
	"COMPANYID" VARCHAR2(80 BYTE) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_BOARD_BOARDINFO
--------------------------------------------------------

  CREATE TABLE "TBL_BOARD_BOARDINFO" 
   (	"BOARDID" NCHAR(38), 
	"BOARDNAME" NVARCHAR2(255), 
	"BOARDNAME2" NVARCHAR2(255), 
	"BOARDNAME3" NVARCHAR2(255),
	"BOARDNAME4" NVARCHAR2(255),
	"TREEVIEWORDER" FLOAT(126),
	"BOARDLEVEL" FLOAT(126), 
	"PARENTBOARDID" NVARCHAR2(38), 
	"BOARDDESCRIPTION" NVARCHAR2(255), 
	"ITEMEXPIRES" FLOAT(126), 
	"ATTACHSIZELIMIT" NVARCHAR2(255), 
	"REPLYNOTIFY" FLOAT(126), 
	"BOARDGROUPID" NVARCHAR2(255), 
	"ALERTPOSTITEM" FLOAT(126), 
	"GUBUN" FLOAT(126), 
	"URL" NVARCHAR2(255), 
	"DELETEAFTER" FLOAT(126), 
	"BOARDCOLOR" NVARCHAR2(255), 
	"BOARDNO" FLOAT(126), 
	"PORTLET" NCHAR(1), 
	"ONELINEREPLY" NCHAR(1), 
	"BOARDTREEPATH" VARCHAR2(400 CHAR), 
	"BACKGROUND" CHAR(1 CHAR), 
	"FORMLOCATION" NVARCHAR2(200), 
	"FORMFLAG" CHAR(1 CHAR), 
	"APPRFLAG" CHAR(1 CHAR), 
	"APPRMAILFLAG" CHAR(1 CHAR), 
	"ATTRIBUTEYN" CHAR(1 CHAR), 
	"TENANT_ID" NUMBER(5,0) DEFAULT NULL, 
	"COMPANYID" VARCHAR2(80 BYTE) DEFAULT NULL, 
	"LIKEFLAG" NCHAR(1),
	"MAILFG_POST" CHAR(1 CHAR) DEFAULT NULL,
	"MAILFG_MOD" CHAR(1 CHAR) DEFAULT NULL,
	"MAILFG_COMMENT" CHAR(1 CHAR) DEFAULT NULL,
	"REACTFLAG" NCHAR(1) DEFAULT NULL,
	"ATTACHMENTFLAG" CHAR(1) DEFAULT 'Y',
    "PUBLICFLAG" NCHAR(1) DEFAULT 'N',
    "ALLNEWBOARDFLAG" CHAR(1) DEFAULT 'Y',
    "WRITERFLAG" NCHAR(1) DEFAULT 'N',
	"STARRATINGFLAG" NCHAR(1) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_BOARD_BOARDINFO_ATTRIBUTE
--------------------------------------------------------

  CREATE TABLE "TBL_BOARD_BOARDINFO_ATTRIBUTE" 
   (	"BOARDID" NCHAR(38), 
	"TABLECOL" NVARCHAR2(50), 
	"SN" NUMBER(3,0), 
	"COLNAME1" NVARCHAR2(50), 
	"COLNAME2" NVARCHAR2(100), 
	"VALUE" NVARCHAR2(255), 
	"COLTYPE" NVARCHAR2(50), 
	"MUST" CHAR(1 CHAR), 
	"TENANT_ID" NUMBER(5,0) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_BOARD_BOARDMANAGE
--------------------------------------------------------

  CREATE TABLE "TBL_BOARD_BOARDMANAGE" 
   (	"BOARDID" NCHAR(38), 
	"ACCESSID" NVARCHAR2(20), 
	"ACCESSNAME" NVARCHAR2(50), 
	"ACCESSNAME2" NVARCHAR2(500), 
	"ACCESSLEVEL" NUMBER(10,0), 
	"ACCESS_" NUMBER(10,0), 
	"PARENTBOARDID" NCHAR(38), 
	"BOARDADMIN_FG" NVARCHAR2(5), 
	"LISTVIEW_FG" NVARCHAR2(5), 
	"READ_FG" NVARCHAR2(5), 
	"WRITE_FG" NVARCHAR2(5), 
	"REPLY_FG" NVARCHAR2(5), 
	"DELETE_FG" NVARCHAR2(5), 
	"INHERIT_FG" NVARCHAR2(5), 
	"POSTNOTICE" NVARCHAR2(5), 
	"BOARDGROUPACL" NVARCHAR2(1) DEFAULT 'Y', 
	"TENANT_ID" NUMBER(5,0) DEFAULT NULL, 
	"COMPANYID" VARCHAR2(80 BYTE) DEFAULT NULL,
	"TYPE" VARCHAR2(10)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_BOARD_CONFIGURATION
--------------------------------------------------------

  CREATE TABLE "TBL_BOARD_CONFIGURATION" 
   (	"USERID" NVARCHAR2(50), 
	"LISTCOUNT" NUMBER(10,0), 
	"PREVIEW" NVARCHAR2(50), 
	"PREVIEWWLIST" NUMBER(10,0) DEFAULT (50), 
	"PREVIEWWCONTENT" NUMBER(10,0) DEFAULT (50), 
	"PREVIEWHLIST" NUMBER(10,0) DEFAULT (50), 
	"PREVIEWHCONTENT" NUMBER(10,0) DEFAULT (50),
    "ALLNEWBOARDLISTDATE" NUMBER(10,0) DEFAULT 5,
    "CONTENTSIZE" NUMBER(2,0) DEFAULT 0,
    "TENANT_ID" NUMBER(5,0) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_BOARD_DELETERESERVEDBOARD
--------------------------------------------------------

  CREATE TABLE "TBL_BOARD_DELETERESERVEDBOARD" 
   (	"BOARDID" NCHAR(38), 
	"TENANT_ID" NUMBER(5,0) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_BOARD_DELETERESERVEDITEM
--------------------------------------------------------

  CREATE TABLE "TBL_BOARD_DELETERESERVEDITEM" 
   (	"BOARDID" NCHAR(38), 
	"ITEMID" NCHAR(38), 
	"TENANT_ID" NUMBER(5,0) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_BOARD_ITEM
--------------------------------------------------------

  CREATE TABLE "TBL_BOARD_ITEM" 
   (	"ITEMID" NVARCHAR2(40), 
	"BOARDID" NVARCHAR2(40), 
	"WRITERID" NVARCHAR2(20), 
	"WRITERNAME" NVARCHAR2(60), 
	"WRITERNAME2" NVARCHAR2(60), 
	"WRITERDEPTID" NVARCHAR2(20), 
	"WRITERDEPTNAME" NVARCHAR2(50), 
	"WRITERDEPTNAME2" NVARCHAR2(50), 
	"WRITERCOMPANYID" NVARCHAR2(20), 
	"WRITERCOMPANYNAME" NVARCHAR2(50), 
	"WRITERCOMPANYNAME2" NVARCHAR2(50), 
	"WRITEDATE" NVARCHAR2(20), 
	"PARENTWRITEDATE" NVARCHAR2(20), 
	"UPDATEDATE" NVARCHAR2(20), 
	"IMPORTANCE" NUMBER(10,0), 
	"TITLE" NVARCHAR2(200), 
	"CONTENTLOCATION" NVARCHAR2(200), 
	"READCOUNT" NUMBER(10,0), 
	"STARTDATE" NVARCHAR2(20), 
	"ENDDATE" NVARCHAR2(20), 
	"ABSTRACT" NVARCHAR2(400), 
	"ATTACHMENTS" NCHAR(1), 
	"UPPERITEMIDTREE" NCLOB, 
	"ITEMLEVEL" NUMBER(10,0), 
	"COPIEDITEM" NUMBER(10,0), 
	"EXTENSIONATTRIBUTE1" NUMBER(10,0), 
	"EXTENSIONATTRIBUTE2" NUMBER(10,0), 
	"EXTENSIONATTRIBUTE3" NVARCHAR2(50), 
	"EXTENSIONATTRIBUTE32" NVARCHAR2(50), 
	"EXTENSIONATTRIBUTE4" NVARCHAR2(50), 
	"EXTENSIONATTRIBUTE5" NVARCHAR2(2000), 
	"DOCNO" NUMBER(19,0), 
	"DOCPASSWORD" CHAR(684 CHAR), 
	"MAINCONTENT" NCLOB, 
	"NOTINO" NUMBER(19,0), 
	"TOPWRITERID" NVARCHAR2(20), 
	"APPRFLAG" CHAR(1 CHAR), 
	"EXTENSIONATTRIBUTE6" NVARCHAR2(500), 
	"EXTENSIONATTRIBUTE7" NVARCHAR2(500), 
	"EXTENSIONATTRIBUTE8" NVARCHAR2(500), 
	"EXTENSIONATTRIBUTE9" NVARCHAR2(500), 
	"EXTENSIONATTRIBUTE10" NVARCHAR2(500), 
	"TENANT_ID" NUMBER(5,0) DEFAULT NULL, 
	"CONTENT" CLOB,
	"NTSTARTDATE" varchar(40) DEFAULT NULL,
    "NTENDDATE" varchar(40) DEFAULT NULL,
    "PUBLICFLAG" CHAR(1 CHAR) DEFAULT 'Y',
    "WRITERNAMETYPE" NCHAR(1) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_BOARD_ITEM_ATTACHMENTS
--------------------------------------------------------

  CREATE TABLE "TBL_BOARD_ITEM_ATTACHMENTS" 
   (	"ITEMID" NCHAR(38), 
	"GUID" NVARCHAR2(50), 
	"FILEPATH" NVARCHAR2(400), 
	"FILESIZE" NVARCHAR2(50), 
	"FILENAME" NVARCHAR2(400), 
	"TENANT_ID" NUMBER(5,0) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_BOARD_ITEM_LISTOPTION
--------------------------------------------------------

  CREATE TABLE "TBL_BOARD_ITEM_LISTOPTION" 
   (	"LISTTYPE" CHAR(1 CHAR), 
	"SN" NUMBER(10,0), 
	"NAME1" NVARCHAR2(100), 
	"NAME2" NVARCHAR2(100), 
	"NAME3" NVARCHAR2(100), 
	"NAME4" NVARCHAR2(100), 
	"COLNAME" NVARCHAR2(100), 
	"WIDTH" NUMBER(10,0), 
	"VIEW_FG" CHAR(1 CHAR), 
	"TENANT_ID" NUMBER(5,0) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_BOARD_ITEM_LISTOPTION_BOAR
--------------------------------------------------------

  CREATE TABLE "TBL_BOARD_ITEM_LISTOPTION_BOAR" 
   (	"BOARDID" NCHAR(38), 
	"SN" NUMBER(10,0), 
	"NAME1" NVARCHAR2(100), 
	"NAME2" NVARCHAR2(100), 
	"NAME3" NVARCHAR2(100), 
	"NAME4" NVARCHAR2(100), 
	"COLNAME" NVARCHAR2(100), 
	"WIDTH" NUMBER(10,0), 
	"VIEW_FG" CHAR(1 CHAR), 
	"TENANT_ID" NUMBER(5,0) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_BOARD_ITEM_READ
--------------------------------------------------------

  CREATE TABLE "TBL_BOARD_ITEM_READ" 
   (	"BOARDID" NCHAR(38), 
	"ITEMID" NCHAR(38), 
	"USERID" NVARCHAR2(50), 
	"USERNAME" NVARCHAR2(50), 
	"USERNAME2" NVARCHAR2(50), 
	"USERDEPTNAME" NVARCHAR2(50), 
	"USERDEPTNAME2" NVARCHAR2(50), 
	"USERCOMPANYNAME" NVARCHAR2(50), 
	"USERCOMPANYNAME2" NVARCHAR2(50), 
	"USERTITLE" NVARCHAR2(50), 
	"USERTITLE2" NVARCHAR2(50), 
	"READDATE" DATE, 
	"TENANT_ID" NUMBER(5,0) DEFAULT NULL, 
	"COMPANYID" VARCHAR2(80 BYTE) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_BOARD_ITEM_TEMP
--------------------------------------------------------

  CREATE TABLE "TBL_BOARD_ITEM_TEMP" 
   (	"ITEMID" NCHAR(38), 
	"BOARDID" NCHAR(38), 
	"WRITERID" NVARCHAR2(20), 
	"WRITERNAME" NVARCHAR2(20), 
	"WRITERNAME2" NVARCHAR2(20), 
	"WRITERDEPTID" NVARCHAR2(20), 
	"WRITERDEPTNAME" NVARCHAR2(50), 
	"WRITERDEPTNAME2" NVARCHAR2(50), 
	"WRITERCOMPANYID" NVARCHAR2(20), 
	"WRITERCOMPANYNAME" NVARCHAR2(50), 
	"WRITERCOMPANYNAME2" NVARCHAR2(50), 
	"WRITEDATE" NVARCHAR2(20), 
	"PARENTWRITEDATE" NVARCHAR2(20), 
	"UPDATEDATE" NVARCHAR2(20), 
	"IMPORTANCE" NUMBER(10,0), 
	"TITLE" NVARCHAR2(200), 
	"CONTENTLOCATION" NVARCHAR2(200), 
	"READCOUNT" NUMBER(10,0), 
	"STARTDATE" NVARCHAR2(20), 
	"ENDDATE" NVARCHAR2(20), 
	"ABSTRACT" NVARCHAR2(400), 
	"ATTACHMENTS" NCHAR(1), 
	"UPPERITEMIDTREE" NCLOB, 
	"ITEMLEVEL" NUMBER(10,0), 
	"COPIEDITEM" NUMBER(10,0), 
	"EXTENSIONATTRIBUTE1" NUMBER(10,0), 
	"EXTENSIONATTRIBUTE2" NUMBER(10,0), 
	"EXTENSIONATTRIBUTE3" NVARCHAR2(50), 
	"EXTENSIONATTRIBUTE32" NVARCHAR2(50), 
	"EXTENSIONATTRIBUTE4" NVARCHAR2(50), 
	"EXTENSIONATTRIBUTE5" NVARCHAR2(200), 
	"DOCNO" NUMBER(19,0), 
	"DOCPASSWORD" NVARCHAR2(50), 
	"MAINCONTENT" NCLOB, 
	"EXTENSIONATTRIBUTE6" NVARCHAR2(500), 
	"EXTENSIONATTRIBUTE7" NVARCHAR2(500), 
	"EXTENSIONATTRIBUTE8" NVARCHAR2(500), 
	"EXTENSIONATTRIBUTE9" NVARCHAR2(500), 
	"EXTENSIONATTRIBUTE10" NVARCHAR2(500), 
	"TENANT_ID" NUMBER(5,0) DEFAULT NULL,
    "PUBLICFLAG" CHAR(1 CHAR) DEFAULT 'Y'
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_BOARD_LIKE
--------------------------------------------------------

  CREATE TABLE "TBL_BOARD_LIKE" 
   (	"ITEMID" NVARCHAR2(40), 
	"USERID" NVARCHAR2(20), 
	"LIKEDATE" NVARCHAR2(20), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_BOARD_MYBOARDS
--------------------------------------------------------

  CREATE TABLE "TBL_BOARD_MYBOARDS" 
   (	"USERID" NVARCHAR2(50), 
	"BOARDID" NVARCHAR2(38), 
	"BOARDNAME" NVARCHAR2(50), 
	"BOARDNAME2" NVARCHAR2(50), 
	"BOARDNAME3" NVARCHAR2(50),
	"BOARDNAME4" NVARCHAR2(50),
	"TREEVIEWNUM" FLOAT(126),
	"TABUSED" CHAR(1 CHAR) DEFAULT 'Y', 
	"VIEWORDER" FLOAT(126), 
	"TENANT_ID" NUMBER(5,0) DEFAULT NULL, 
	"COMPANYID" VARCHAR2(80 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_BOARD_MYTREE
--------------------------------------------------------

  CREATE TABLE "TBL_BOARD_MYTREE" 
   (	"TREEID" NVARCHAR2(38), 
	"USERID" NVARCHAR2(20), 
	"TREENAME" NVARCHAR2(255), 
	"TREENAME2" NVARCHAR2(255), 
	"TREENAME3" NVARCHAR2(255),
	"TREENAME4" NVARCHAR2(255),
	"TREELEVEL" NUMBER(10,0),
	"TREESTEP" NUMBER(10,0), 
	"TREEUPPER" NVARCHAR2(38), 
	"TREEBOARDID" NVARCHAR2(38), 
	"TENANT_ID" NUMBER(5,0) DEFAULT NULL, 
	"COMPANYID" VARCHAR2(80 BYTE) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_BOARD_NEWBOARD_ORDERINFO
--------------------------------------------------------

  CREATE TABLE "TBL_BOARD_NEWBOARD_ORDERINFO" 
   (	"BOARDID" NVARCHAR2(38), 
	"USERID" NVARCHAR2(50), 
	"TABUSED" CHAR(1 CHAR), 
	"VIEWORDER" FLOAT(126), 
	"TENANT_ID" NUMBER(5,0) DEFAULT NULL, 
	"COMPANYID" VARCHAR2(80 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_BOARD_ONELINEREPLY
--------------------------------------------------------

  CREATE TABLE "TBL_BOARD_ONELINEREPLY" 
   (	"ITEMID" NCHAR(38), 
	"REPLYID" NCHAR(38), 
	"BOARDID" NCHAR(38), 
	"USERID" NVARCHAR2(50), 
	"USERNAME" NVARCHAR2(50), 
	"USERNAME2" NVARCHAR2(50), 
	"WRITEDATE" DATE, 
	"CONTENT" NVARCHAR2(600), 
	"PASSWORD" NVARCHAR2(684), 
	"TENANT_ID" NUMBER(5,0) DEFAULT NULL, 
	"COMPANYID" VARCHAR2(80 BYTE) DEFAULT NULL,
    "REPLYLEVEL" NUMBER(10,0),
    "PARENTREPLYID" NVARCHAR2(100),
    "PARENTWRITERNAME" NVARCHAR2(50),
    "UPDATEDATE" DATE,
    "IMAGECONTENT" NVARCHAR2(600) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_BOARD_TREECACHE
--------------------------------------------------------

  CREATE TABLE "TBL_BOARD_TREECACHE" 
   (	"QUERY" VARCHAR2(900 CHAR), 
	"RESULT" NCLOB, 
	"RESULT2" NCLOB, 
	"RESULT3" NCLOB,
	"RESULT4" NCLOB,
	"TENANT_ID" NUMBER(5,0) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CABINET
--------------------------------------------------------

  CREATE TABLE "TBL_CABINET" 
   (	"CABINETID" VARCHAR2(112 BYTE), 
	"CREATEDATE" DATE, 
	"CABINETCLASSNO" VARCHAR2(100 CHAR), 
	"DELETEDATE" DATE, 
	"VOLUMENO" CHAR(3 CHAR), 
	"DELFLAG" CHAR(1 CHAR) DEFAULT (0), 
	"TCABINETID" VARCHAR2(112 CHAR), 
	"TDEPTCODE" VARCHAR2(28 CHAR), 
	"TCABINETNAME" NVARCHAR2(100), 
	"TTASKCODE" CHAR(8 CHAR), 
	"TDEPTNAME" NVARCHAR2(100), 
	"TTASKNAME" NVARCHAR2(100), 
	"TPRODUCEYEAR" CHAR(4 CHAR), 
	"TREGSERIALNO" VARCHAR2(24 CHAR), 
	"TVOLUMENO" CHAR(3 CHAR), 
	"TRANSFERDATE" DATE, 
	"CABINETTRANSFERFLAG" CHAR(1 CHAR) DEFAULT (0), 
	"PRODREPORTFLAG" NUMBER(10,0) DEFAULT (0), 
	"TRANSFERFLAG" NUMBER(10,0) DEFAULT (0), 
	"CATALOGTRANSFERFLAG" CHAR(1 CHAR) DEFAULT (0), 
	"CATALOGTRANSFERYEAR" NUMBER(10,0), 
	"DOCTRANSFERFLAG" CHAR(1 CHAR) DEFAULT (0), 
	"DOCTRANSFERYEAR" NUMBER(10,0), 
	"TCABINETNAME2" NVARCHAR2(100), 
	"TDEPTNAME2" NVARCHAR2(100), 
	"TTASKNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CABINETCLASS
--------------------------------------------------------

  CREATE TABLE "TBL_CABINETCLASS" 
   (	"CABINETCLASSNO" VARCHAR2(100 CHAR), 
	"PRODUCTIONYEAR" CHAR(4 CHAR), 
	"TASKCODE" CHAR(8 CHAR), 
	"PROCESSDEPTNAME" NVARCHAR2(100), 
	"PROCESSDEPTCODE" CHAR(28 CHAR), 
	"REGSERIALNO" CHAR(24 CHAR), 
	"TASKNAME" NVARCHAR2(100), 
	"TITLE" NVARCHAR2(100), 
	"RECTYPECODE" CHAR(1 CHAR), 
	"EXPIRATIONYEAR" CHAR(4 CHAR), 
	"DELAYENDYFLAG" CHAR(1 CHAR) DEFAULT 'N', 
	"KEEPINGPERIOD" CHAR(2 CHAR), 
	"TERMINATEFLAG" CHAR(1 CHAR), 
	"OWNERNAME" NVARCHAR2(100), 
	"KEEPINGMETHOD" CHAR(1 CHAR), 
	"OWNERID" VARCHAR2(50 CHAR), 
	"DISPLAYRECFLAG" CHAR(1 CHAR), 
	"KEEPINGPLACE" CHAR(1 CHAR), 
	"MODIFYFLAG" CHAR(1 CHAR), 
	"DISPLAYENDDATE" CHAR(8 CHAR), 
	"NUMOFREC" CHAR(3 CHAR), 
	"PAGEOFREC" CHAR(6 CHAR), 
	"TRANSDELAYFLAG" CHAR(1 CHAR), 
	"EXTRANSYEAR" NUMBER(10,0), 
	"TRANSDELAYREASON" NVARCHAR2(200), 
	"DISPLAYREASON" NVARCHAR2(200), 
	"OLDCABINETFLAG" CHAR(1 CHAR), 
	"NUMOFELECTRONICDOC" CHAR(6 CHAR), 
	"SPECIALCATALOGFLAG" CHAR(1 CHAR), 
	"CONFIRMFLAG" CHAR(1 CHAR), 
	"CONFIRMYEAR" NUMBER(10,0), 
	"DELFLAG" CHAR(1 CHAR), 
	"CREATEDATE" DATE, 
	"DELETEDATE" DATE, 
	"OWNERDEPTID" VARCHAR2(28 BYTE), 
	"OWNERTASK" CHAR(8 CHAR), 
	"TITLE2" NVARCHAR2(200), 
	"PROCESSDEPTNAME2" NVARCHAR2(100), 
	"TASKNAME2" NVARCHAR2(100), 
	"OWNERNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CABINETCODELIST
--------------------------------------------------------

  CREATE TABLE "TBL_CABINETCODELIST" 
   (	"CODETYPE" NVARCHAR2(12), 
	"CODE" NVARCHAR2(20), 
	"NAME" NVARCHAR2(200), 
	"ISUSED" NUMBER(3,0), 
	"CODEDESCRIPTION" NVARCHAR2(400), 
	"TYPEDESCRIPTION" NVARCHAR2(400), 
	"NAME2" NVARCHAR2(200), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" NVARCHAR2(20)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CABINETHISTORY
--------------------------------------------------------

  CREATE TABLE "TBL_CABINETHISTORY" 
   (	"VERSION" NUMBER(10,0), 
	"CABINETCLASSNO" VARCHAR2(100 CHAR), 
	"TITLE" NVARCHAR2(200), 
	"RECTYPECODE" CHAR(1 CHAR), 
	"MODIFYDATE" CHAR(8 CHAR), 
	"KEEPINGPERIOD" CHAR(2 CHAR), 
	"DISPLAYENDDATE" CHAR(8 CHAR), 
	"DISPLAYREASON" NVARCHAR2(200), 
	"MODIFYREASON" NVARCHAR2(200), 
	"MODIFIERID" VARCHAR2(100 CHAR), 
	"MODIFIERNAME" NVARCHAR2(100), 
	"MODIFYFLAG" CHAR(1 CHAR), 
	"DELFLAG" CHAR(1 CHAR), 
	"MODIFIERNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CABINET_VIEWAUTH
--------------------------------------------------------

  CREATE TABLE "TBL_CABINET_VIEWAUTH" 
   (	"CABINETID" VARCHAR2(112 BYTE), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(20 BYTE), 
	"CN" NVARCHAR2(40), 
	"ACCESS_LV" VARCHAR2(1 BYTE) DEFAULT 'N', 
	"MNG_FG" VARCHAR2(1 BYTE) DEFAULT 'N'
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CABROLEINFO
--------------------------------------------------------

  CREATE TABLE "TBL_CABROLEINFO" 
   (	"USER_ID" VARCHAR2(100 CHAR), 
	"CABINETCLASSNO" VARCHAR2(100 CHAR), 
	"USERNAME" NVARCHAR2(100), 
	"USERNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CB_ADMIN_MODULE
--------------------------------------------------------

  CREATE TABLE "TBL_CB_ADMIN_MODULE" 
   (	"COMPANY_ID" VARCHAR2(50 BYTE), 
	"MODULE_TYPE" VARCHAR2(20 BYTE), 
	"ACTIVE_STATUS" NUMBER(3,0), 
	"TENANT_ID" NUMBER(10,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CB_ATTACH_FILE
--------------------------------------------------------

  CREATE TABLE "TBL_CB_ATTACH_FILE" 
   (	"ATTACH_ID" NUMBER(10,0), 
	"ITEM_ID" NUMBER(10,0), 
	"FILE_PATH" VARCHAR2(250 BYTE), 
	"FILE_NAME" VARCHAR2(150 BYTE), 
	"FILE_SIZE" NUMBER(19,0), 
	"FILE_DESCRIPTION" VARCHAR2(400 BYTE) DEFAULT NULL, 
	"COMPANY_ID" VARCHAR2(50 BYTE), 
	"TENANT_ID" NUMBER(10,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CB_CABINET
--------------------------------------------------------

  CREATE TABLE "TBL_CB_CABINET" 
   (	"CABINET_ID" NUMBER(10,0), 
	"CABINET_NAME1" VARCHAR2(150 BYTE), 
	"CABINET_NAME2" VARCHAR2(150 BYTE), 
	"CREATOR_ID" VARCHAR2(50 BYTE), 
	"CREATOR_NAME1" VARCHAR2(150 BYTE), 
	"CREATOR_NAME2" VARCHAR2(150 BYTE), 
	"DEPARTMENT_ID" VARCHAR2(50 BYTE), 
	"DEPARTMENT_NAME1" VARCHAR2(150 BYTE), 
	"DEPARTMENT_NAME2" VARCHAR2(150 BYTE) DEFAULT NULL, 
	"CABINET_TYPE" NUMBER(3,0), 
	"PARENT_ID" NUMBER(10,0), 
	"CABINET_PATH" VARCHAR2(500 BYTE), 
	"CABINET_ORDER" NUMBER(10,0), 
	"CABINET_LEVEL" NUMBER(10,0), 
	"CREATE_DATE" TIMESTAMP (0), 
	"UPDATE_DATE" TIMESTAMP (0), 
	"UPDATE_ID" VARCHAR2(50 BYTE), 
	"DELETE_ID" VARCHAR2(50 BYTE) DEFAULT NULL, 
	"USE_STATUS" NUMBER(3,0), 
	"COMPANY_ID" VARCHAR2(50 BYTE), 
	"TENANT_ID" NUMBER(10,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CB_COMPANY_CAPACITY
--------------------------------------------------------

  CREATE TABLE "TBL_CB_COMPANY_CAPACITY" 
   (	"COMPANY_ID" VARCHAR2(50 BYTE), 
	"CAPACITY_TYPE" NUMBER(3,0), 
	"CAPACITY_VALUE" NUMBER(10,0) DEFAULT NULL, 
	"TENANT_ID" NUMBER(10,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CB_CONFIG
--------------------------------------------------------

  CREATE TABLE "TBL_CB_CONFIG" 
   (	"USER_ID" VARCHAR2(50 BYTE), 
	"COMPANY_ID" VARCHAR2(50 BYTE), 
	"LIST_COUNT" NUMBER(10,0), 
	"PREVIEW_MODE" VARCHAR2(10 BYTE), 
	"CONTENT_WPERCENT" NUMBER(10,0), 
	"CONTENT_HPERCENT" NUMBER(10,0), 
	"TENANT_ID" NUMBER(10,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CB_ITEM
--------------------------------------------------------

  CREATE TABLE "TBL_CB_ITEM" 
   (	"ITEM_ID" NUMBER(10,0), 
	"CABINET_ID" NUMBER(10,0), 
	"ITEM_TYPE" NUMBER(3,0), 
	"TITLE" VARCHAR2(250 BYTE), 
	"SUMMARY" VARCHAR2(250 BYTE) DEFAULT NULL, 
	"CREATOR_ID" VARCHAR2(50 BYTE), 
	"CREATOR_NAME1" VARCHAR2(150 BYTE), 
	"CREATOR_NAME2" VARCHAR2(150 BYTE), 
	"DEPARTMENT_ID" VARCHAR2(50 BYTE), 
	"DEPARTMENT_NAME1" VARCHAR2(150 BYTE), 
	"DEPARTMENT_NAME2" VARCHAR2(150 BYTE) DEFAULT NULL, 
	"CONTENT_PATH" CLOB, 
	"CREATE_DATE" TIMESTAMP (0), 
	"UPDATE_DATE" TIMESTAMP (0), 
	"USE_STATUS" NUMBER(3,0), 
	"UPDATE_ID" VARCHAR2(50 BYTE), 
	"DELETE_ID" VARCHAR2(50 BYTE) DEFAULT NULL, 
	"COMPANY_ID" VARCHAR2(50 BYTE), 
	"TENANT_ID" NUMBER(10,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CB_REL
--------------------------------------------------------

  CREATE TABLE "TBL_CB_REL" 
   (	"REL_ID" VARCHAR2(50 BYTE), 
	"ITEM_ID" NUMBER(10,0), 
	"REL_NAME1" VARCHAR2(80 BYTE) DEFAULT NULL, 
	"REL_NAME2" VARCHAR2(80 BYTE) DEFAULT NULL, 
	"REL_VALUE" CLOB, 
	"COMPANY_ID" VARCHAR2(50 BYTE), 
	"TENANT_ID" NUMBER(10,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CB_RELATION
--------------------------------------------------------

  CREATE TABLE "TBL_CB_RELATION" 
   (	"RELATION_ID" NUMBER(10,0), 
	"ITEM_ID" NUMBER(10,0), 
	"RELATE_ITEM_ID" NUMBER(10,0), 
	"COMPANY_ID" VARCHAR2(50 BYTE), 
	"TENANT_ID" NUMBER(10,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CB_SHARE
--------------------------------------------------------

  CREATE TABLE "TBL_CB_SHARE" 
   (	"SHARE_ID" NUMBER(10,0), 
	"CABINET_ID" NUMBER(10,0), 
	"SHARER_ID" VARCHAR2(50 BYTE), 
	"SHARER_NAME1" VARCHAR2(150 BYTE), 
	"SHARER_NAME2" VARCHAR2(150 BYTE), 
	"SHARED_ID" VARCHAR2(50 BYTE), 
	"SHARED_TYPE" NUMBER(3,0), 
	"PERMISSION" NUMBER(3,0), 
	"SHARE_DATE" TIMESTAMP (0), 
	"CHILD_PERMISSION" NUMBER(3,0), 
	"USE_STATUS" NUMBER(3,0),
    "SAVEFLAG" NUMBER(3,0),
    "COMPANY_ID" VARCHAR2(50 BYTE),
	"TENANT_ID" NUMBER(10,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CB_USER_CAPACITY
--------------------------------------------------------

  CREATE TABLE "TBL_CB_USER_CAPACITY" 
   (	"USER_ID" VARCHAR2(50 BYTE), 
	"CAPACITY_TYPE" NUMBER(3,0), 
	"CAPACITY_VALUE" NUMBER(10,0) DEFAULT NULL, 
	"COMPANY_ID" VARCHAR2(50 BYTE), 
	"TENANT_ID" NUMBER(10,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CB_USER_MODULE
--------------------------------------------------------

  CREATE TABLE "TBL_CB_USER_MODULE" 
   (	"USER_ID" VARCHAR2(50 BYTE), 
	"COMPANY_ID" VARCHAR2(50 BYTE), 
	"MODULE_TYPE" VARCHAR2(20 BYTE), 
	"ACTIVE_STATUS" NUMBER(3,0), 
	"TENANT_ID" NUMBER(10,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CIRCULAR
--------------------------------------------------------

  CREATE TABLE "TBL_CIRCULAR" 
   (	"CIRCULARID" NUMBER(10,0), 
	"TITLE" NVARCHAR2(250) DEFAULT NULL, 
	"IMPORTANCE" NUMBER(5,0) DEFAULT NULL, 
	"option" NUMBER(5,0) DEFAULT NULL, 
	"content" CLOB, 
	"HASFILE" NUMBER(5,0) DEFAULT NULL, 
	"STATUS" NUMBER(5,0) DEFAULT NULL, 
	"MEMBERID" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"MEMBERNAME" NVARCHAR2(50) DEFAULT NULL, 
	"MEMBERNAME2" NVARCHAR2(50) DEFAULT NULL, 
	"REGDATE" NVARCHAR2(20) DEFAULT NULL, 
	"ENDDATE" NVARCHAR2(20) DEFAULT NULL, 
	"TENANTID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(80 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CIRCULAR_BM
--------------------------------------------------------

  CREATE TABLE "TBL_CIRCULAR_BM" 
   (	"CIRCULARBMID" NUMBER(10,0), 
	"TITLE" NVARCHAR2(250) DEFAULT NULL, 
	"MEMBERID" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"REGDATE" NVARCHAR2(20) DEFAULT NULL, 
	"TENANTID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(80 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CIRCULAR_BMUSER
--------------------------------------------------------

  CREATE TABLE "TBL_CIRCULAR_BMUSER" 
   (	"CIRCULARBMUSERID" NUMBER(10,0), 
	"CIRCULARBMID" NUMBER(10,0) DEFAULT NULL, 
	"MEMBERID" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"MEMBERNAME" NVARCHAR2(50) DEFAULT NULL, 
	"MEMBERNAME2" NVARCHAR2(50) DEFAULT NULL, 
	"TENANTID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CIRCULAR_COMMENT
--------------------------------------------------------

  CREATE TABLE "TBL_CIRCULAR_COMMENT" 
   (	"CIRCULARID" NUMBER(10,0), 
	"CIRCULARCOMMENTID" NUMBER(10,0), 
	"CIRCULARUSERID" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"CIRCULARCOMMENT" CLOB, 
	"MEMBERID" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"MEMBERNAME" NVARCHAR2(50) DEFAULT NULL, 
	"MEMBERNAME2" NVARCHAR2(50) DEFAULT NULL, 
	"REGDATE" NVARCHAR2(20) DEFAULT NULL, 
	"STATUS" NUMBER(5,0) DEFAULT NULL, 
	"TENANTID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CIRCULAR_COMMENTSTATE
--------------------------------------------------------

  CREATE TABLE "TBL_CIRCULAR_COMMENTSTATE" 
   (	"CIRCULARCOMMENTSTATEID" NUMBER(10,0), 
	"CIRCULARCOMMENTID" NUMBER(10,0) DEFAULT NULL, 
	"MEMBERID" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"STATUS" NUMBER(5,0) DEFAULT NULL, 
	"CONFIRMDATE" NVARCHAR2(20) DEFAULT NULL, 
	"UPDATEDATE" NVARCHAR2(20) DEFAULT NULL, 
	"TENANTID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CIRCULAR_FILE
--------------------------------------------------------

  CREATE TABLE "TBL_CIRCULAR_FILE" 
   (	"CIRCULARFILEID" NUMBER(10,0), 
	"CIRCULARID" NUMBER(10,0) DEFAULT NULL, 
	"FILENAME" NVARCHAR2(100) DEFAULT NULL, 
	"FILESIZE" NUMBER(10,0) DEFAULT NULL, 
	"FILEPATH" NVARCHAR2(250) DEFAULT NULL, 
	"TENANTID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CIRCULAR_FOLDER
--------------------------------------------------------

  CREATE TABLE "TBL_CIRCULAR_FOLDER" 
   (	"CIRCULARFOLDERID" NUMBER(10,0), 
	"CIRCULARFOLDERNAME" NVARCHAR2(50) DEFAULT NULL, 
	"MEMBERID" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"REGDATE" NVARCHAR2(20) DEFAULT NULL, 
	"TENANTID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(80 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CIRCULAR_LINK
--------------------------------------------------------

  CREATE TABLE "TBL_CIRCULAR_LINK" 
   (	"CIRCULARLINKID" NUMBER(10,0), 
	"CIRCULARFOLDERID" NUMBER(10,0) DEFAULT NULL, 
	"CIRCULARID" NUMBER(10,0) DEFAULT NULL, 
	"MEMBERID" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"TENANTID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CIRCULAR_LISTOPTION
--------------------------------------------------------

  CREATE TABLE "TBL_CIRCULAR_LISTOPTION" 
   (	"LISTTYPE" VARCHAR2(4 BYTE), 
	"SN" NUMBER(10,0), 
	"NAME1" NVARCHAR2(100) DEFAULT NULL, 
	"NAME2" NVARCHAR2(100) DEFAULT NULL, 
	"NAME3" NVARCHAR2(100) DEFAULT NULL, 
	"NAME4" NVARCHAR2(100) DEFAULT NULL, 
	"COLNAME" NVARCHAR2(100), 
	"WIDTH" NUMBER(10,0), 
	"TENANTID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CIRCULAR_OPTION
--------------------------------------------------------

  CREATE TABLE "TBL_CIRCULAR_OPTION" 
   (	"CIRCULAROPTIONID" NUMBER(10,0), 
	"MEMBERID" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"LISTCNT" NUMBER(5,0) DEFAULT NULL, 
	"ISPREVIEW" NUMBER(5,0) DEFAULT NULL, 
	"PREVIEWLISTVALUE" VARCHAR2(10 BYTE) DEFAULT NULL, 
	"PREVIEWCONTENTVALUE" VARCHAR2(10 BYTE) DEFAULT NULL, 
	"TENANTID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CIRCULAR_USER
--------------------------------------------------------

  CREATE TABLE "TBL_CIRCULAR_USER" 
   (	"CIRCULARUSERID" NUMBER(10,0), 
	"CIRCULARID" NUMBER(10,0) DEFAULT NULL, 
	"MEMBERID" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"MEMBERNAME" NVARCHAR2(50) DEFAULT NULL, 
	"MEMBERNAME2" NVARCHAR2(50) DEFAULT NULL, 
	"STATUS" NUMBER(5,0) DEFAULT '0', 
	"CONFIRMDATE" NVARCHAR2(20) DEFAULT NULL, 
	"UPDATESTATUS" NUMBER(5,0) DEFAULT NULL, 
	"UPDATEDATE" NVARCHAR2(20) DEFAULT NULL, 
	"COMMENTSTATUS" NUMBER(5,0) DEFAULT '0', 
	"SHARESTATUS" NUMBER(5,0) DEFAULT '0', 
	"DELETESTATUS" NUMBER(5,0) DEFAULT '0', 
	"TENANTID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(80 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CLUBID
--------------------------------------------------------

  CREATE TABLE "TBL_CLUBID" 
   (	"CLUBID" NCHAR(20), 
	"TENANT_ID" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CODELIST
--------------------------------------------------------

  CREATE TABLE "TBL_CODELIST" 
   (	"CODE1" VARCHAR2(5 BYTE), 
	"CODE2" CHAR(3 CHAR), 
	"NAME" NVARCHAR2(255), 
	"ISUSE" CHAR(1 CHAR), 
	"DESCRIPT" NVARCHAR2(510), 
	"NAME2" NVARCHAR2(255), 
	"NAME3" NVARCHAR2(255), 
	"NAME4" NVARCHAR2(255), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" NVARCHAR2(20)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_COMM_BOARDINFO
--------------------------------------------------------

  CREATE TABLE "TBL_COMM_BOARDINFO" 
   (	"C_CLUBNO" VARCHAR2(20 BYTE), 
	"BOARDID" NCHAR(38), 
	"BOARDNAME" NVARCHAR2(50), 
	"BOARDNAME2" NVARCHAR2(50), 
	"TREEVIEWORDER" NVARCHAR2(500), 
	"BOARDLEVEL" NUMBER(10,0), 
	"PARENTBOARDID" NCHAR(38), 
	"BOARDDESCRIPTION" NVARCHAR2(200), 
	"ITEMEXPIRES" NUMBER(10,0), 
	"ATTACHSIZELIMIT" NVARCHAR2(10), 
	"REPLYNOTIFY" NUMBER(10,0), 
	"BOARDGROUPID" NCHAR(38), 
	"ALERTPOSTITEM" NUMBER(10,0), 
	"GUBUN" NUMBER(10,0), 
	"URL" NVARCHAR2(200), 
	"DELETEAFTER" NUMBER(10,0), 
	"BOARDCOLOR" NVARCHAR2(50), 
	"BOARDNO" NUMBER(10,0), 
	"VERSIONUSE" NCHAR(1), 
	"CHECKUSE" NCHAR(1), 
	"SHOWPOSITION" NCHAR(1), 
	"SN" NUMBER(10,0), 
	"TENANT_ID" NUMBER DEFAULT 0,
    "MAILFG_POST" CHAR(1 CHAR) DEFAULT NULL,
    "MAILFG_MOD" CHAR(1 CHAR) DEFAULT NULL,
    "MAILFG_COMMENT" CHAR(1 CHAR) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_COMM_BOARDMANAGE
--------------------------------------------------------

  CREATE TABLE "TBL_COMM_BOARDMANAGE" 
   (	"BOARDID" NCHAR(38), 
	"ACCESSID" NVARCHAR2(20), 
	"ACCESSNAME" NVARCHAR2(100), 
	"ACCESSNAME2" NVARCHAR2(100), 
	"ACCESSLEVEL" NUMBER(10,0), 
	"ACCESS_" NUMBER(10,0), 
	"PARENTBOARDID" NCHAR(38), 
	"BOARDADMIN_FG" NVARCHAR2(50), 
	"LISTVIEW_FG" NVARCHAR2(5), 
	"READ_FG" NVARCHAR2(5), 
	"WRITE_FG" NVARCHAR2(5), 
	"REPLY_FG" NVARCHAR2(5), 
	"DELETE_FG" NVARCHAR2(5), 
	"INHERIT_FG" NVARCHAR2(5), 
	"POSTNOTICE" NVARCHAR2(5), 
	"TENANT_ID" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_COMM_DELETERESERVEDBOARD
--------------------------------------------------------

  CREATE TABLE "TBL_COMM_DELETERESERVEDBOARD" 
   (	"BOARDID" NCHAR(38), 
	"TENANT_ID" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_COMM_DELETERESERVEDITEM
--------------------------------------------------------

  CREATE TABLE "TBL_COMM_DELETERESERVEDITEM" 
   (	"BOARDID" NCHAR(38), 
	"ITEMID" NCHAR(38), 
	"TENANT_ID" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_COMM_ITEM
--------------------------------------------------------

  CREATE TABLE "TBL_COMM_ITEM" 
   (	"ITEMID" NCHAR(38), 
	"BOARDID" NCHAR(38), 
	"WRITERID" NVARCHAR2(20), 
	"WRITERNAME" NVARCHAR2(60), 
	"WRITERNAME2" NVARCHAR2(60), 
	"WRITERDEPTID" NVARCHAR2(20), 
	"WRITERDEPTNAME" NVARCHAR2(50), 
	"WRITERDEPTNAME2" NVARCHAR2(50), 
	"WRITERCOMPANYID" NVARCHAR2(20), 
	"WRITERCOMPANYNAME" NVARCHAR2(50), 
	"WRITERCOMPANYNAME2" NVARCHAR2(50), 
	"WRITEDATE" NVARCHAR2(20), 
	"PARENTWRITEDATE" NVARCHAR2(20), 
	"UPDATEDATE" NVARCHAR2(20), 
	"IMPORTANCE" NUMBER(10,0), 
	"TITLE" NVARCHAR2(200), 
	"CONTENTLOCATION" NVARCHAR2(200), 
	"READCOUNT" NUMBER(10,0), 
	"STARTDATE" NVARCHAR2(20), 
	"ENDDATE" NVARCHAR2(20), 
	"ABSTRACT" NVARCHAR2(400), 
	"ATTACHMENTS" NVARCHAR2(10), 
	"UPPERITEMIDTREE" NCLOB, 
	"ITEMLEVEL" NUMBER(10,0), 
	"COPIEDITEM" NUMBER(10,0), 
	"EXTENSIONATTRIBUTE1" NUMBER(10,0), 
	"EXTENSIONATTRIBUTE2" NUMBER(10,0), 
	"EXTENSIONATTRIBUTE3" NVARCHAR2(50), 
	"EXTENSIONATTRIBUTE32" NVARCHAR2(50), 
	"EXTENSIONATTRIBUTE4" NVARCHAR2(100), 
	"EXTENSIONATTRIBUTE5" NVARCHAR2(200), 
	"DOCNO" NUMBER(19,0), 
	"DOCPASSWORD" CHAR(684 CHAR), 
	"TENANT_ID" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_COMM_ITEM_ATTACHMENTS
--------------------------------------------------------

  CREATE TABLE "TBL_COMM_ITEM_ATTACHMENTS" 
   (	"ITEMID" NVARCHAR2(38), 
	"GUID" NVARCHAR2(38), 
	"FILEPATH" NVARCHAR2(400), 
	"FILESIZE" NVARCHAR2(10), 
	"FILENAME" NVARCHAR2(50), 
	"TENANT_ID" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_COMM_ITEM_READ
--------------------------------------------------------

  CREATE TABLE "TBL_COMM_ITEM_READ" 
   (	"BOARDID" NCHAR(38), 
	"ITEMID" NCHAR(38), 
	"USERID" NVARCHAR2(20), 
	"USERNAME" NVARCHAR2(50), 
	"USERNAME2" NVARCHAR2(50), 
	"USERDEPTNAME" NVARCHAR2(50), 
	"USERDEPTNAME2" NVARCHAR2(50), 
	"USERCOMPANYNAME" NVARCHAR2(50), 
	"USERCOMPANYNAME2" NVARCHAR2(50), 
	"USERTITLE" NVARCHAR2(50), 
	"USERTITLE2" NVARCHAR2(50), 
	"READDATE" DATE, 
	"TENANT_ID" NUMBER DEFAULT 0, 
	"COMPANYID" VARCHAR2(80 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_COMM_MYBOARDS
--------------------------------------------------------

  CREATE TABLE "TBL_COMM_MYBOARDS" 
   (	"USERID" NVARCHAR2(20), 
	"BOARDID" NCHAR(38), 
	"BOARDNAME" NVARCHAR2(20), 
	"TREEVIEWNUM" NUMBER(10,0), 
	"TENANT_ID" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_COMM_ONELINEREPLY
--------------------------------------------------------

  CREATE TABLE "TBL_COMM_ONELINEREPLY" 
   (	"ITEMID" NCHAR(38), 
	"REPLYID" NCHAR(38), 
	"BOARDID" NCHAR(38), 
	"USERID" NVARCHAR2(50), 
	"USERNAME" NVARCHAR2(50), 
	"USERNAME2" NVARCHAR2(50), 
	"WRITEDATE" DATE, 
	"CONTENT" NVARCHAR2(300), 
	"PASSWORD" CHAR(684 CHAR), 
	"TENANT_ID" NUMBER DEFAULT 0, 
	"COMPANYID" VARCHAR2(80 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_COMM_SCHEDULE
--------------------------------------------------------

  CREATE TABLE "TBL_COMM_SCHEDULE" 
   (	"SCHEDULEID" NUMBER(10,0), 
	"PARENTID" NUMBER(10,0), 
	"OWNERID" NVARCHAR2(50), 
	"OWNERNAME" NVARCHAR2(50), 
	"CREATORID" NVARCHAR2(50), 
	"CREATORNAME" NVARCHAR2(50), 
	"CREATEDATE" DATE, 
	"MODIFIERID" NVARCHAR2(50), 
	"MODIFIERNAME" NVARCHAR2(50), 
	"MODIFYDATE" DATE, 
	"SCHEDULETYPE" NUMBER(5,0), 
	"IMPORTANCE" NUMBER(5,0), 
	"HASATTENDANT" NCHAR(1), 
	"HASATTACH" NCHAR(1), 
	"HASCOMMENT" NCHAR(1), 
	"ISREADONLY" NCHAR(1), 
	"ISPUBLIC" NCHAR(1), 
	"DATETYPE" NUMBER(5,0), 
	"STARTDATE" DATE, 
	"ENDDATE" DATE, 
	"REPETITION" NVARCHAR2(50), 
	"REPETITIONDELETE" NVARCHAR2(250), 
	"TITLE" NVARCHAR2(250), 
	"LOCATION" NVARCHAR2(250), 
	"CONTENTPATH" NVARCHAR2(250), 
	"TENANT_ID" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_COMM_SCHEDULEATTACH
--------------------------------------------------------

  CREATE TABLE "TBL_COMM_SCHEDULEATTACH" 
   (	"ATTACHID" NUMBER(10,0), 
	"SCHEDULEID" NUMBER(10,0), 
	"FILESIZE" NUMBER(10,0), 
	"FILENAME" NVARCHAR2(250), 
	"FILEPATH" NVARCHAR2(250), 
	"TENANT_ID" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_COMM_SCHEDULECOMMENT
--------------------------------------------------------

  CREATE TABLE "TBL_COMM_SCHEDULECOMMENT" 
   (	"COMMENTID" NUMBER(10,0), 
	"SCHEDULEID" NUMBER(10,0), 
	"COMMENTORID" NVARCHAR2(50), 
	"COMMENTORNAME" NVARCHAR2(50), 
	"COMMENTDATE" DATE, 
	"COMMENT_" NCLOB, 
	"TENANT_ID" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_COMM_SCHEDULECONFIG
--------------------------------------------------------

  CREATE TABLE "TBL_COMM_SCHEDULECONFIG" 
   (	"USERID" NVARCHAR2(50), 
	"DEFAULTVIEW" NCHAR(1), 
	"STARTDAY" NCHAR(1), 
	"STARTTIME" NVARCHAR2(4), 
	"ENDTIME" NVARCHAR2(4), 
	"AUTODELETE" NUMBER(10,0), 
	"TENANT_ID" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_COMM_SCHEDULEGROUP
--------------------------------------------------------

  CREATE TABLE "TBL_COMM_SCHEDULEGROUP" 
   (	"GROUPID" NVARCHAR2(50), 
	"GROUPNAME" NVARCHAR2(50), 
	"CREATORID" NVARCHAR2(50), 
	"CREATORNAME" NVARCHAR2(50), 
	"DESCRIPTION" NVARCHAR2(250), 
	"TENANT_ID" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_COMM_SCHEDULEGROUPMEMBER
--------------------------------------------------------

  CREATE TABLE "TBL_COMM_SCHEDULEGROUPMEMBER" 
   (	"GROUPID" NVARCHAR2(50), 
	"MEMBERID" NVARCHAR2(50), 
	"MEMBERNAME" NVARCHAR2(50), 
	"STATUS" NUMBER(5,0), 
	"RESPONSEDATE" DATE, 
	"TENANT_ID" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_COMM_SCHEDULESHARE
--------------------------------------------------------

  CREATE TABLE "TBL_COMM_SCHEDULESHARE" 
   (	"OWNERID" NVARCHAR2(50), 
	"OWNERNAME" NVARCHAR2(50), 
	"SHARERID" NVARCHAR2(50), 
	"SHARERNAME" NVARCHAR2(50), 
	"SHARETYPE" NCHAR(1), 
	"SHAREPERMISSION" NCHAR(1), 
	"TENANT_ID" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_COMM_SECRETARY
--------------------------------------------------------

  CREATE TABLE "TBL_COMM_SECRETARY" 
   (	"USERID" NVARCHAR2(50), 
	"USERNAME" NVARCHAR2(50), 
	"SECRETARYID" NVARCHAR2(50), 
	"SECRETARYNAME" NVARCHAR2(50), 
	"TENANT_ID" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_COMM_TREECACHE
--------------------------------------------------------

  CREATE TABLE "TBL_COMM_TREECACHE" 
   (	"QUERY" NVARCHAR2(1800), 
	"RESULT" NCLOB, 
	"TENANT_ID" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_COMPANY_CONFIG
--------------------------------------------------------

  CREATE TABLE "TBL_COMPANY_CONFIG" 
   (	"TENANT_ID" NUMBER(5,0), 
	"COMPANY_ID" NVARCHAR2(80), 
	"PROPERTY_NAME" NVARCHAR2(100), 
	"PROPERTY_VALUE" NVARCHAR2(2000)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CONNDATA
--------------------------------------------------------

  CREATE TABLE "TBL_CONNDATA" 
   (	"KEYID" VARCHAR2(50 BYTE), 
	"FORMID" VARCHAR2(10 BYTE), 
	"USERID" VARCHAR2(100),
	"DEPTID" VARCHAR2(100),
	"TITLE" NVARCHAR2(510),
	"BODYHTML" CLOB, 
	"STATUS" CHAR(3 BYTE) DEFAULT 'INT', 
	"DOCID" CHAR(20 BYTE), 
	"UPDATEDATE" DATE DEFAULT SYSDATE
   ) ;

   COMMENT ON COLUMN "TBL_CONNDATA"."KEYID" IS '연동키값';
   COMMENT ON COLUMN "TBL_CONNDATA"."FORMID" IS '연동 양식ID';
   COMMENT ON COLUMN "TBL_CONNDATA"."USERID" IS '기안자 ID';
   COMMENT ON COLUMN "TBL_CONNDATA"."DEPTID" IS '기안자 부서ID';
   COMMENT ON COLUMN "TBL_CONNDATA"."TITLE" IS '문서제목';
   COMMENT ON COLUMN "TBL_CONNDATA"."BODYHTML" IS 'HTML 본문 데이터';
   COMMENT ON COLUMN "TBL_CONNDATA"."STATUS" IS '결재 상태';
   COMMENT ON COLUMN "TBL_CONNDATA"."DOCID" IS '문서ID';
   COMMENT ON COLUMN "TBL_CONNDATA"."UPDATEDATE" IS '업데이트 일자';
   COMMENT ON TABLE "TBL_CONNDATA"  IS '결재연동 테이블';

--------------------------------------------------------
--  DDL for Table TBL_SESSION
--------------------------------------------------------

  CREATE TABLE "TBL_SESSION"
   ("SESSION_ID" CHAR(36) NOT NULL,
	"LOGINCOOKIE" VARCHAR2(700) NOT NULL,
	"CREATION_TIME" DATE NOT NULL,
	"LAST_ACCESS_TIME" DATE NOT NULL,
	"MAX_INACTIVE_INTERVAL" NUMBER NOT NULL,
	"TYPE" VARCHAR2(5) DEFAULT NULL
   ) ;

--------------------------------------------------------
--  DDL for Table TBL_FIDO_SESSION
--------------------------------------------------------

  CREATE TABLE "TBL_FIDO_SESSION"
   ("FIDO_SESSION_ID" VARCHAR2(50) NOT NULL,
	"USER_ID" VARCHAR2(80) NOT NULL,
	"CREATE_TIME" DATE NOT NULL,
	"ACCESS_IP" VARCHAR2(100) NOT NULL,
	"STATUS" VARCHAR2(50) NOT NULL
   ) ;

--------------------------------------------------------
--  DDL for Table TBL_FIDO_SESSION
--------------------------------------------------------

CREATE TABLE "TBL_NOT_ACCESS_FIDO_IP"
("IPNO" NUMBER(10,0) NOT NULL,
 "TENANT_ID" NUMBER(5,0) DEFAULT 0 NOT NULL,
 "COMPANYID" VARCHAR2(200) DEFAULT NULL,
 "IPADDRESS" VARCHAR2(100) NOT NULL,
 "ALLOW_ACCESS" VARCHAR2(10) DEFAULT 'NO',
 "EXPLANATION" VARCHAR2(200) DEFAULT NULL
) ;

--------------------------------------------------------
--  DDL for Table TBL_CONNECTION_INFO
--------------------------------------------------------

  CREATE TABLE "TBL_CONNECTION_INFO" 
   (	"SEQUENCE" NUMBER(19,0), 
	"USERID" NVARCHAR2(50), 
	"USERNM" NVARCHAR2(100), 
	"USERNM2" NVARCHAR2(100), 
	"DEPTID" VARCHAR2(50 CHAR), 
	"DEPTNM" NVARCHAR2(100), 
	"DEPTNM2" NVARCHAR2(100), 
	"TITLE" NVARCHAR2(100), 
	"TITLE2" NVARCHAR2(100), 
	"COMPANYID" VARCHAR2(50 CHAR), 
	"COMPANYNM" NVARCHAR2(100), 
	"COMPANYNM2" NVARCHAR2(100), 
	"CONNECTIP" VARCHAR2(50 CHAR), 
	"CONNECTINFO" VARCHAR2(50 CHAR), 
	"CONNECTTIME" DATE, 
	"DISCONNECTTIME" DATE DEFAULT NULL,
	"CONNECTBROWSER" VARCHAR2(10 CHAR), 
	"CONNECTOS" VARCHAR2(20 CHAR), 
	"CONNECTAGENT" NVARCHAR2(500), 
	"STATUS" VARCHAR2(1) DEFAULT NULL,
	"SESSIONCODE" VARCHAR2(200) DEFAULT NULL,
	"TENANT_ID" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_ADMIN_ACCESS_INFO
--------------------------------------------------------

  CREATE TABLE "TBL_ADMIN_ACCESS_INFO" 
   (	"SEQUENCE" NUMBER(19,0), 
	"USERID" NVARCHAR2(50), 
	"USERNM" NVARCHAR2(100), 
	"USERNM2" NVARCHAR2(100), 
	"DEPTID" VARCHAR2(50 CHAR), 
	"DEPTNM" NVARCHAR2(100), 
	"DEPTNM2" NVARCHAR2(100), 
	"TITLE" NVARCHAR2(100), 
	"TITLE2" NVARCHAR2(100), 
	"COMPANYID" VARCHAR2(50 CHAR), 
	"COMPANYNM" NVARCHAR2(100), 
	"COMPANYNM2" NVARCHAR2(100), 
	"ACCESSIP" VARCHAR2(50 CHAR), 
	"ACCESSINFO" VARCHAR2(50 CHAR), 
	"ACCESSTIME" DATE, 
	"ACCESSBROWSER" VARCHAR2(10 CHAR), 
	"ACCESSOS" VARCHAR2(20 CHAR), 
	"ACCESSAGENT" NVARCHAR2(500),
	"ADMINTYPE" NVARCHAR2(200),
	"TENANT_ID" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_PERMISSION_CHANGE_INFO
--------------------------------------------------------

  CREATE TABLE "TBL_PERMISSION_CHANGE_INFO"
   (	"SEQUENCE" 		NUMBER(19,0),
	"USERID" 			NVARCHAR2(50),
	"USERNM" 			NVARCHAR2(100),
	"USERNM2" 			NVARCHAR2(100),
	"DEPTID" 			CHAR(50 CHAR),
	"DEPTNM" 			NVARCHAR2(100),
	"DEPTNM2" 			NVARCHAR2(100),
	"TITLE" 			NVARCHAR2(100),
	"TITLE2" 			NVARCHAR2(100),
	"COMPANYID" 		CHAR(50 CHAR),
	"COMPANYNM" 		NVARCHAR2(100),
	"COMPANYNM2" 		NVARCHAR2(100),
	"AUTHORIZEDTIME"	DATE,
	"ADMINTYPE" 		NVARCHAR2(200),
	"STATUS" 			NVARCHAR2(40),
	"AUTHORIZERID" 		NVARCHAR2(50),
	"AUTHORIZERNM" 		NVARCHAR2(100),
	"AUTHORIZERNM2" 	NVARCHAR2(100),
	"AUTHORIZERIP" 		VARCHAR2(50 CHAR),
	"TENANT_ID" 		NUMBER DEFAULT 0
   ) ;

--------------------------------------------------------
--  DDL for Table TBL_USER_CHANGE_INFO
--------------------------------------------------------
	
  CREATE table "TBL_USER_CHANGE_INFO" 
	("SEQ"		 		NUMBER(19,0),
	"USERID" 			NVARCHAR2(50),
	"USERNM" 			NVARCHAR2(100),
	"USERNM2" 			NVARCHAR2(100),
	"DEPTID" 			VARCHAR2(50 CHAR),
	"DEPTNM" 			NVARCHAR2(100),
	"DEPTNM2" 			NVARCHAR2(100),
	"COMPANYID" 		VARCHAR2(50 CHAR),
	"COMPANYNM" 		NVARCHAR2(100),
	"COMPANYNM2" 		NVARCHAR2(100),
	"UPDATEDT" 			DATE,
	"TARGET_DEPTID" 	VARCHAR2(50 CHAR),
	"TARGET_DEPTNM" 	NVARCHAR2(100),
	"TARGET_DEPTNM2" 	NVARCHAR2(100),
	"UPDATE_TYPE" 		NVARCHAR2(50),
	"EXECUTORID" 		NVARCHAR2(50),
	"EXECUTORNM" 		NVARCHAR2(100),
	"EXECUTORNM2" 		NVARCHAR2(100),
	"EXECUTORIP" 		VARCHAR2(50 CHAR),
	"TENANTID" 			NUMBER DEFAULT 0
	);

--------------------------------------------------------
--  DDL for Table TBL_DEPT_CHANGE_INFO
--------------------------------------------------------

	CREATE table "TBL_DEPT_CHANGE_INFO"
	("SEQ"		 		NUMBER(19,0),
	"DEPTID" 			NVARCHAR2(80),
	"DEPTNM" 			NVARCHAR2(100),
	"DEPTNM2" 			NVARCHAR2(100),
	"PARENT_DEPTID" 	NVARCHAR2(80),
	"PARENT_DEPTNM" 	NVARCHAR2(100),
	"PARENT_DEPTNM2" 	NVARCHAR2(100),
	"COMPANYID" 		NVARCHAR2(80),
	"COMPANYNM" 		NVARCHAR2(100),
	"COMPANYNM2" 		NVARCHAR2(100),
	"UPDATEDT" 			DATE,
	"TARGET_DEPTID" 	NVARCHAR2(80),
	"TARGET_DEPTNM" 	NVARCHAR2(100),
	"TARGET_DEPTNM2" 	NVARCHAR2(100),
	"UPDATE_TYPE" 		NVARCHAR2(50),
	"EXECUTORID" 		NVARCHAR2(50),
	"EXECUTORNM" 		NVARCHAR2(100),
	"EXECUTORNM2" 		NVARCHAR2(100),
	"EXECUTORIP" 		VARCHAR2(50 CHAR),
	"TENANTID" 			NUMBER DEFAULT 0
	);

--------------------------------------------------------
--  DDL for Table TBL_CONTAINER
--------------------------------------------------------

  CREATE TABLE "TBL_CONTAINER" 
   (	"CONTAINERID" CHAR(10 CHAR), 
	"CONTAINERTYPEID" VARCHAR2(40 CHAR), 
	"CONTAINEROWNDEPID" VARCHAR2(50 CHAR), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CONTAINERTODOCSTATE
--------------------------------------------------------

  CREATE TABLE "TBL_CONTAINERTODOCSTATE" 
   (	"CONTAINERTYPEID" VARCHAR2(40 CHAR), 
	"DOCUMENTSTATE" NVARCHAR2(12), 
	"TENANT_ID" NUMBER(5,0) DEFAULT NULL, 
	"COMPANYID" NVARCHAR2(20)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CONTAINERTYPE
--------------------------------------------------------

  CREATE TABLE "TBL_CONTAINERTYPE" 
   (	"CONTAINERTYPEID" VARCHAR2(40 CHAR), 
	"CONTAINERTYPENAME" NVARCHAR2(200), 
	"CONTAINERTYPENAME2" NVARCHAR2(200), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" NVARCHAR2(20)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_CONTAINERUSEDEP
--------------------------------------------------------

  CREATE TABLE "TBL_CONTAINERUSEDEP" 
   (	"CONTAINERID" CHAR(10 CHAR), 
	"USEDEPID" VARCHAR2(50 CHAR), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_C_BOARD
--------------------------------------------------------

  CREATE TABLE "TBL_C_BOARD" 
   (	"NO" NUMBER(19,0), 
	"ID" NCHAR(20), 
	"COMPANYID" NVARCHAR2(20), 
	"USERNAME" NVARCHAR2(50), 
	"USERNAME2" NVARCHAR2(50), 
	"TITLE" NVARCHAR2(200), 
	"CONTENT" NCLOB, 
	"CONTENTURL" NVARCHAR2(200), 
	"WRITEDAY" NVARCHAR2(50), 
	"REF" NUMBER(19,0), 
	"STEP" NUMBER(10,0), 
	"RE_LEVEL" NUMBER(10,0), 
	"READNUM" NUMBER(19,0), 
	"NUMM" NUMBER(19,0), 
	"FILENAME" NCHAR(20), 
	"C_CLUBNO" VARCHAR2(20 BYTE), 
	"C_NO" NUMBER(18,0), 
	"CHARFILENAME" NCLOB, 
	"TENANT_ID" NUMBER DEFAULT 0,
    "UPPERNO" NUMBER(19, 0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_C_CATEGORY
--------------------------------------------------------

  CREATE TABLE "TBL_C_CATEGORY" 
   (	"C_CODE" NVARCHAR2(255), 
	"C_CAT" NVARCHAR2(255), 
	"C_NAME" NVARCHAR2(255), 
	"C_ORDER" FLOAT(126), 
	"TENANT_ID" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_C_CLUB
--------------------------------------------------------

  CREATE TABLE "TBL_C_CLUB" 
   (	"C_CLUBNO" VARCHAR2(20 BYTE), 
	"C_REGDATE" DATE, 
	"C_CLUBNAME" NVARCHAR2(200), 
	"C_CLUBNAME2" NVARCHAR2(200), 
	"C_CATE_A" NCHAR(2) DEFAULT TO_NCHAR((0)), 
	"C_CATE_B" NCHAR(2) DEFAULT TO_NCHAR((0)), 
	"C_CATE_C" NCHAR(2) DEFAULT TO_NCHAR((0)), 
	"C_CLUBGUBUN" NVARCHAR2(50), 
	"C_CLUBCONFIRMTYPE" NVARCHAR2(50), 
	"C_ADMINCONFIRM" NCHAR(1), 
	"C_MAKER" NCHAR(20), 
	"C_SYSOPID" NCHAR(20), 
	"C_MEMBERCNT" NUMBER(10,0) DEFAULT (1), 
	"C_LOGO" NVARCHAR2(50), 
	"C_LOGO_THUMBNAIL" NVARCHAR2(50), 
	"C_BGIMAGE" NVARCHAR2(50), 
	"C_FONTCOLOR" NVARCHAR2(50), 
	"C_BGCOLOR" NVARCHAR2(50), 
	"C_TITLEFONTCOLOR" NVARCHAR2(50), 
	"C_CLUBDESC" NCLOB, 
	"C_CLUBBANNER" NVARCHAR2(50), 
	"C_OPENDATE" NVARCHAR2(50), 
	"C_CLUBNOTICETITLE" NVARCHAR2(100) DEFAULT '공지사항', 
	"C_NOTICETITLECOLOR" NCHAR(10), 
	"C_NOTICEFONTCOLOR" NCHAR(10), 
	"C_CLUBNOTICE_ORDERBY" NUMBER(10,0) DEFAULT (1), 
	"C_CLUBNOTICE_EXIST" NCHAR(1) DEFAULT TO_NCHAR((1)), 
	"C_CLUBBOARDTITLE" NVARCHAR2(100) DEFAULT '게시판', 
	"C_BOARDTITLECOLOR" NCHAR(10), 
	"C_BOARDFONTCOLOR" NCHAR(10), 
	"C_CLUBBOARD_ORDERBY" NUMBER(10,0) DEFAULT (2), 
	"C_CLUBBOARD_EXIST" NCHAR(1) DEFAULT TO_NCHAR((1)), 
	"C_CLUBPDSTITLE" NVARCHAR2(100) DEFAULT '자료실', 
	"C_PDSTITLECOLOR" NCHAR(10), 
	"C_PDSFONTCOLOR" NCHAR(10), 
	"C_CLUBPDS_ORDERBY" NUMBER(10,0) DEFAULT (3), 
	"C_CLUBPDS_EXIST" NCHAR(1) DEFAULT TO_NCHAR((1)), 
	"C_CLUBBOARD1TITLE" NVARCHAR2(100) DEFAULT '게시판1', 
	"C_BOARD1TITLECOLOR" NCHAR(10), 
	"C_BOARD1FONTCOLOR" NCHAR(10), 
	"C_CLUBBOARD1_EXIST" NCHAR(1) DEFAULT TO_NCHAR((0)), 
	"C_CLUBBOARD1_ORDERBY" NUMBER(10,0) DEFAULT (0), 
	"C_CLUBBOARD2TITLE" NVARCHAR2(100) DEFAULT '게시판2', 
	"C_BOARD2TITLECOLOR" NCHAR(10), 
	"C_BOARD2FONTCOLOR" NCHAR(10), 
	"C_CLUBBOARD2_EXIST" NCHAR(1) DEFAULT TO_NCHAR((0)), 
	"C_CLUBBOARD2_ORDERBY" NUMBER(10,0) DEFAULT (0), 
	"C_CLUBPDS1TITLE" NVARCHAR2(100) DEFAULT '자료실1', 
	"C_PDS1TITLECOLOR" NCHAR(10), 
	"C_PDS1FONTCOLOR" NCHAR(10), 
	"C_CLUBPDS1_EXIST" NCHAR(1) DEFAULT TO_NCHAR((0)), 
	"C_CLUBPDS1_ORDERBY" NUMBER(10,0) DEFAULT (0), 
	"SCORE" NUMBER(10,0), 
	"ISIN" NUMBER(10,0), 
	"COMPANYID" NVARCHAR2(20), 
	"USINGDISKSIZE" NUMBER(18,0) DEFAULT (0), 
	"SENDMAIL" NCHAR(1) DEFAULT TO_NCHAR((0)), 
	"SENDMAILCNT" NCHAR(1) DEFAULT TO_NCHAR((0)), 
	"ASSIGNDISKSIZE" NCHAR(10) DEFAULT TO_NCHAR((52428800)), 
	"C_TYPE" NVARCHAR2(10), 
	"TENANT_ID" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_C_CLUBGUEST
--------------------------------------------------------

  CREATE TABLE "TBL_C_CLUBGUEST" 
   (	"NO" NUMBER(19,0), 
	"ID" NCHAR(20), 
	"USERNAME" NVARCHAR2(50), 
	"USERNAME2" NVARCHAR2(50), 
	"COMPANYID" NVARCHAR2(20), 
	"TITLE" NVARCHAR2(200), 
	"CONTENT" NCLOB, 
	"CONTENTURL" NVARCHAR2(200), 
	"READNUM" NUMBER(19,0), 
	"WRITEDAY" DATE, 
	"C_NO" NUMBER(19,0), 
	"C_CLUBNO" VARCHAR2(20 BYTE), 
	"TENANT_ID" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_C_CLUBNOTICE
--------------------------------------------------------

  CREATE TABLE "TBL_C_CLUBNOTICE" 
   (	"NO" NUMBER(19,0), 
	"ID" NCHAR(20), 
	"USERNAME" NVARCHAR2(50), 
	"COMPANYID" NVARCHAR2(20), 
	"TITLE" NVARCHAR2(200), 
	"CONTENT" NCLOB, 
	"CONTENTURL" NVARCHAR2(200), 
	"READNUM" NUMBER(19,0), 
	"WRITEDAY" NVARCHAR2(50), 
	"C_NO" NUMBER(19,0), 
	"C_CLUBNO" VARCHAR2(20 BYTE), 
	"FILENAME" NCHAR(20), 
	"REF" NUMBER(18,0), 
	"STEP" NUMBER(10,0), 
	"RE_LEVEL" NUMBER(10,0), 
	"CHARFILENAME" NCLOB, 
	"TENANT_ID" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_C_CLUBUSER
--------------------------------------------------------

  CREATE TABLE "TBL_C_CLUBUSER" 
   (	"C_CLUBNO" VARCHAR2(20 BYTE), 
	"C_ID" NVARCHAR2(20), 
	"C_INDATE" NCHAR(30), 
	"C_LASTDATE" NCHAR(30), 
	"C_EMAIL" NUMBER(5,0) DEFAULT (0), 
	"C_HPHONE" NUMBER(5,0) DEFAULT (0), 
	"C_COMPANY" NUMBER(5,0) DEFAULT (0), 
	"C_HOUSE" NUMBER(5,0) DEFAULT (0), 
	"C_JOB" NUMBER(5,0) DEFAULT (0), 
	"C_BIRTH" NUMBER(5,0) DEFAULT (0), 
	"C_SEX" NUMBER(5,0) DEFAULT (0), 
	"C_VISITED" NUMBER(19,0) DEFAULT (0), 
	"C_INTRO" NCLOB, 
	"PERMIT" NCHAR(1) DEFAULT TO_NCHAR((0)), 
	"COMPANYID" NVARCHAR2(20), 
	"TENANT_ID" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_C_COMCLOSE
--------------------------------------------------------

  CREATE TABLE "TBL_C_COMCLOSE" 
   (	"C_CLUBNO" VARCHAR2(20 BYTE), 
	"C_CLUBNAME" NVARCHAR2(200), 
	"C_CLUBNAME2" NVARCHAR2(200), 
	"C_SYSOPID" NVARCHAR2(50), 
	"COMPANYNAME" NVARCHAR2(200), 
	"APPLICATIONDATE" NVARCHAR2(50), 
	"CLOSEREASON" NCLOB, 
	"CLOSESTATE" NVARCHAR2(50), 
	"CLOSESTATE2" NVARCHAR2(50), 
	"TENANT_ID" NUMBER DEFAULT 0, 
	"COMPANYID" NVARCHAR2(20) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_C_MEMBERINFO
--------------------------------------------------------

  CREATE TABLE "TBL_C_MEMBERINFO" 
   (	"COMPANYID" NVARCHAR2(20), 
	"USERID" NVARCHAR2(50), 
	"USERNAME" NVARCHAR2(50), 
	"USERNAME2" NVARCHAR2(50), 
	"COMPANYNAME" NVARCHAR2(50), 
	"COMPANYNAME2" NVARCHAR2(50), 
	"COMPANYZIP" NVARCHAR2(100), 
	"COMPANYADDRESS" NVARCHAR2(100), 
	"DEPTNAME" NVARCHAR2(50), 
	"DEPTNAME2" NVARCHAR2(50), 
	"COMPANYTEL" NVARCHAR2(50), 
	"COMPANYFAX" NVARCHAR2(50), 
	"HOMEZIP" NVARCHAR2(100), 
	"HOMEADDRESS" NVARCHAR2(100), 
	"HOMETEL" NVARCHAR2(50), 
	"HANDPHONE" NVARCHAR2(50), 
	"EMAIL" NVARCHAR2(50), 
	"BIRTHDAY" NVARCHAR2(50), 
	"GENDER" NCHAR(10), 
	"GENDER2" NCHAR(10), 
	"TENANT_ID" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_C_NOTICE
--------------------------------------------------------

  CREATE TABLE "TBL_C_NOTICE" 
   (	"NO" NUMBER(19,0), 
	"ID" NCHAR(20), 
	"USERNAME" NVARCHAR2(50), 
	"USERNAME2" NVARCHAR2(50), 
	"TITLE" NVARCHAR2(200), 
	"CONTENT" NCLOB, 
	"READNUM" NUMBER(19,0), 
	"WRITEDAY" NVARCHAR2(50), 
	"FILENAME" NCHAR(20), 
	"COMPANYID" NVARCHAR2(20), 
	"C_CLUBNO" VARCHAR2(20 BYTE), 
	"C_NO" NUMBER(18,0), 
	"REF" NUMBER(18,0), 
	"STEP" NUMBER(10,0), 
	"RE_LEVEL" NUMBER(10,0), 
	"CHARFILENAME" NCLOB, 
	"TENANT_ID" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_C_OUTAPPLICATION
--------------------------------------------------------

  CREATE TABLE "TBL_C_OUTAPPLICATION" 
   (	"C_CLUBNO" VARCHAR2(20 BYTE), 
	"USERID" NVARCHAR2(50), 
	"OUTDATE" NVARCHAR2(50), 
	"OUTREASON" NCLOB, 
	"TENANT_ID" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_C_POLLANSWER
--------------------------------------------------------

  CREATE TABLE "TBL_C_POLLANSWER" 
   (	"ANSWERID" NUMBER(10,0), 
	"POLLQUESTIONID" NUMBER(10,0), 
	"ANSWERNO" NUMBER(10,0) DEFAULT (0), 
	"ANSWERCONTENT" NVARCHAR2(200), 
	"TENANT_ID" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_C_POLLMANAGER
--------------------------------------------------------

  CREATE TABLE "TBL_C_POLLMANAGER" 
   (	"MANAGERID" NUMBER(10,0), 
	"C_CLUBNO" VARCHAR2(20 BYTE), 
	"POLLGROUPNO" NUMBER(10,0) DEFAULT (0), 
	"POLLSUBJECT" NVARCHAR2(200), 
	"QUESTIONCOUNT" NUMBER(10,0), 
	"POLLREGDATE" DATE, 
	"POLLSTARTDATE" DATE, 
	"POLLENDDATE" DATE, 
	"POLLREGUSER" NVARCHAR2(50), 
	"TENANT_ID" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_C_POLLQUESTION
--------------------------------------------------------

  CREATE TABLE "TBL_C_POLLQUESTION" 
   (	"QUESTIONID" NUMBER(10,0), 
	"POLLMANAGERID" NUMBER(10,0), 
	"QUESTIONNO" NUMBER(10,0), 
	"QUESTIONCONTENT" NVARCHAR2(200), 
	"ANSWERCOUNT" NUMBER(10,0), 
	"ANSWERTYPE" NUMBER(10,0), 
	"ANSWERVIEWTYPE" NUMBER(10,0) DEFAULT (0), 
	"TENANT_ID" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_C_POLLRESPONSE
--------------------------------------------------------

  CREATE TABLE "TBL_C_POLLRESPONSE" 
   (	"RESPONSEID" NUMBER(10,0), 
	"QUESTIONID" NUMBER(10,0), 
	"ANSWERID" NUMBER(10,0), 
	"ANSWERNO" NUMBER(10,0), 
	"ANSWERETC" NVARCHAR2(1000), 
	"USERID" NVARCHAR2(50), 
	"COMPANYID" NVARCHAR2(20), 
	"TENANT_ID" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_DAILYDOCCOUNTLOG
--------------------------------------------------------

  CREATE TABLE "TBL_DAILYDOCCOUNTLOG" 
   (	"REGDATE" VARCHAR2(10 CHAR), 
	"DEPTID" VARCHAR2(100 CHAR), 
	"DEPTNAME" NVARCHAR2(100), 
	"USERID" VARCHAR2(20 CHAR), 
	"USERNAME" NVARCHAR2(100), 
	"DRAFTINGCNT" NUMBER(10,0), 
	"DRAFTENDCNT" NUMBER(10,0), 
	"DRAFTTIME" FLOAT(126), 
	"SUSININGCNT" NUMBER(10,0), 
	"SUSINENDCNT" NUMBER(10,0), 
	"SUSINTIME" FLOAT(126), 
	"RETURNCNT" NUMBER(10,0), 
	"TENANT_ID" NUMBER(5,0),
	"COMPANYID" VARCHAR2(160)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_DAILYFORMCOUNTLOG
--------------------------------------------------------

  CREATE TABLE "TBL_DAILYFORMCOUNTLOG" 
   (	"REGDATE" VARCHAR2(10 CHAR), 
	"FORMID" CHAR(10 CHAR), 
	"FORMNAME" NVARCHAR2(100), 
	"FORMCONTID" CHAR(10 CHAR), 
	"FORMCONTNAME" NVARCHAR2(100), 
	"DRAFTINGCNT" NUMBER(10,0), 
	"DRAFTENDCNT" NUMBER(10,0), 
	"DRAFTTIME" FLOAT(126), 
	"SUSININGCNT" NUMBER(10,0), 
	"SUSINENDCNT" NUMBER(10,0), 
	"SUSINTIME" FLOAT(126), 
	"RETURNCNT" NUMBER(10,0), 
	"TENANT_ID" NUMBER(5,0),
	"COMPANYID" VARCHAR2(160)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_DELETECABINETINFO
--------------------------------------------------------

  CREATE TABLE "TBL_DELETECABINETINFO" 
   (	"CABINETID" VARCHAR2(112 BYTE), 
	"DELUSERID" VARCHAR2(50 BYTE), 
	"IPADDRESS" VARCHAR2(50 BYTE), 
	"COMPANYID" VARCHAR2(45 BYTE), 
	"TENANTID" VARCHAR2(6 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_DEPTCONT
--------------------------------------------------------

  CREATE TABLE "TBL_DEPTCONT" 
   (	"DEPTCONTID" CHAR(10 CHAR), 
	"DEPTCONTNAME" NVARCHAR2(510), 
	"PARENTCONTID" CHAR(10 CHAR), 
	"SN" NUMBER(10,0), 
	"DESCRIPTION" NVARCHAR2(510), 
	"OWNDEPTID" VARCHAR2(100 CHAR), 
	"MANAGEUSERID" VARCHAR2(100 CHAR), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_DEPTCONTLIST
--------------------------------------------------------

  CREATE TABLE "TBL_DEPTCONTLIST" 
   (	"DOCID" CHAR(20 CHAR), 
	"DEPTCONTID" CHAR(10 CHAR), 
	"LINKDATE" DATE, 
	"DESCRIPTION" NVARCHAR2(510), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_DEPTMASTER
--------------------------------------------------------

  CREATE TABLE "TBL_DEPTTEMPLET" 
   (	"USERID" VARCHAR2(100 CHAR), 
	"FORMID" VARCHAR2(40 BYTE), 
	"APRDEPTSN" NUMBER(10,0), 
	"APRDEPTTEMPLETNAME" NVARCHAR2(400), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_DEPTTEMPLET
--------------------------------------------------------

CREATE TABLE "TBL_DEPTMASTER"
(	"CN" NVARCHAR2(80),
     "DISPLAYNAME" NVARCHAR2(100),
     "DISPLAYNAME2" NVARCHAR2(100),
     "USEFLAG" NVARCHAR2(4),
     "MAIL" NVARCHAR2(100),
     "COMPNM2" NVARCHAR2(100),
     "DEPTLEVEL" NVARCHAR2(12),
     "DEPT_CD_PATH" NVARCHAR2(400),
     "DEPT_NM_PATH" NVARCHAR2(400),
     "EXTENSIONATTRIBUTE1" NVARCHAR2(400),
     "EXTENSIONATTRIBUTE2" NVARCHAR2(400),
     "EXTENSIONATTRIBUTE3" NVARCHAR2(400),
     "EXTENSIONATTRIBUTE4" NVARCHAR2(400),
     "EXTENSIONATTRIBUTE5" NVARCHAR2(400),
     "EXTENSIONATTRIBUTE6" NVARCHAR2(400),
     "EXTENSIONATTRIBUTE7" NVARCHAR2(400),
     "EXTENSIONATTRIBUTE8" NVARCHAR2(400),
     "EXTENSIONATTRIBUTE9" NVARCHAR2(400),
     "EXTENSIONATTRIBUTE10" NVARCHAR2(400),
     "EXTENSIONATTRIBUTE11" NVARCHAR2(400),
     "EXTENSIONATTRIBUTE12" NVARCHAR2(400),
     "EXTENSIONATTRIBUTE13" NVARCHAR2(400),
     "EXTENSIONATTRIBUTE14" NVARCHAR2(400),
     "EXTENSIONATTRIBUTE15" NVARCHAR2(400),
     "ADFLAG" NVARCHAR2(4),
     "ADSPATH" NVARCHAR2(400),
     "UPDATEDT" DATE,
     "CREATEDT" DATE,
     "TENANT_ID" NUMBER(5,0) DEFAULT 0,
     "MANUAL_FLAG" NVARCHAR2(10) DEFAULT NULL,
     "DEPTTREEFLAG" char(1) DEFAULT 'Y'
) ;
--------------------------------------------------------
--  DDL for Table TBL_DEPTTEMPLETDETAIL
--------------------------------------------------------

  CREATE TABLE "TBL_DEPTTEMPLETDETAIL" 
   (	"USERID" VARCHAR2(100 CHAR), 
	"FORMID" VARCHAR2(40 BYTE), 
	"APRDEPTSN" NUMBER(10,0), 
	"APRDEPTMEMBERSN" NUMBER(10,0), 
	"APRMEMBERDEPTID" VARCHAR2(100 CHAR), 
	"APRMEMBERDEPTNAME" NVARCHAR2(100), 
	"EXTRECEPTYN" CHAR(1 CHAR), 
	"PROCESSYN" CHAR(1 CHAR), 
	"CANEDITYN" CHAR(1 CHAR), 
	"EXTRECEPTEMAIL" VARCHAR2(100 CHAR), 
	"APRMEMBERID" VARCHAR2(100 CHAR), 
	"APRMEMBERNAME" NVARCHAR2(100), 
	"APRMEMBERJOBTITLE" NVARCHAR2(100), 
	"APRMEMBERDEPTNAME2" NVARCHAR2(100), 
	"APRMEMBERNAME2" NVARCHAR2(100), 
	"APRMEMBERJOBTITLE2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_DEV_MASTER
--------------------------------------------------------

  CREATE TABLE "TBL_DEV_MASTER" 
   (	"DEVSEQ" NUMBER, 
	"DEVID" VARCHAR2(64 BYTE), 
	"DEVTYPE" VARCHAR2(10 BYTE), 
	"SUBTYPE" VARCHAR2(64 BYTE), 
	"USERID" VARCHAR2(100 BYTE), 
	"TOKEN" VARCHAR2(256 BYTE), 
	"BADGE" NUMBER DEFAULT 1, 
	"TENANTID" NUMBER, 
	"STATE" VARCHAR2(4 BYTE), 
	"PUSHSTATE" VARCHAR2(4 BYTE), 
	"REGDATE" DATE, 
	"ISLOGIN" VARCHAR2(20 BYTE), 
	"STARTMENU" VARCHAR2(20 BYTE), 
	"LOGINTIME" VARCHAR2(20 BYTE), 
	"LOGINLOCK" VARCHAR2(4 BYTE), 
	"ISPASSWORDCHANGE" VARCHAR2(4 BYTE), 
	"EXTENSION1" VARCHAR2(64 BYTE), 
	"EXTENSION2" VARCHAR2(256 BYTE), 
	"PIN" VARCHAR2(100 BYTE),
	"PINSTATE" VARCHAR2(4 BYTE) DEFAULT 'N',
	"BIOMETRIC" VARCHAR2(4 BYTE) DEFAULT 'N',
	"NOTUSED" NUMBER DEFAULT 0,
	"APPVERSION" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_DOCDELETEHISTORY
--------------------------------------------------------

  CREATE TABLE "TBL_DOCDELETEHISTORY" 
   (	"DOCID" VARCHAR2(100 BYTE), 
	"DOCNO" VARCHAR2(45 BYTE) DEFAULT NULL, 
	"DOCTITLE" VARCHAR2(255 BYTE) DEFAULT NULL, 
	"DEPTNAME" VARCHAR2(50 BYTE) DEFAULT NULL, 
	"WRITERNAME" VARCHAR2(45 BYTE) DEFAULT NULL, 
	"DELETEUSERID" VARCHAR2(40 BYTE) DEFAULT NULL, 
	"DELETETIME" DATE DEFAULT NULL, 
	"TENANT_ID" VARCHAR2(45 BYTE), 
	"COMPANYID" VARCHAR2(45 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_DOCDELIVERY
--------------------------------------------------------

  CREATE TABLE "TBL_DOCDELIVERY" 
   (	"SN" NUMBER(10,0), 
	"DOCID" CHAR(20 CHAR), 
	"DEPTID" VARCHAR2(100 CHAR), 
	"HREF" VARCHAR2(255 CHAR), 
	"RECEIPTDATE" DATE, 
	"ORGANID" VARCHAR2(100 CHAR), 
	"ORGAN" NVARCHAR2(100), 
	"DOCNUMBER" NVARCHAR2(100), 
	"MANAGEDEPTID" VARCHAR2(100 CHAR), 
	"MANAGEDEPT" NVARCHAR2(100), 
	"CHARGEID" VARCHAR2(100 CHAR), 
	"CHARGENAME" NVARCHAR2(100), 
	"REMARK" NVARCHAR2(100), 
	"ORGDOCNUMCODE" NVARCHAR2(100), 
	"DOCTITLE" NVARCHAR2(510), 
	"MANAGEDEPT2" NVARCHAR2(100), 
	"ORGAN2" NVARCHAR2(100), 
	"CHARGENAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE), 
	"ORGANUSERNAME" VARCHAR2(100 BYTE),
	"EXTRECEPTYN" VARCHAR2(5) DEFAULT 'N'
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_ENDAPRDOCATTACHINFO
--------------------------------------------------------

  CREATE TABLE "TBL_ENDAPRDOCATTACHINFO" 
   (	"DOCID" CHAR(20 CHAR), 
	"ATTACHSN" NUMBER(10,0), 
	"ATTACHDOCNAME" NVARCHAR2(510), 
	"ATTACHDOCURL" NVARCHAR2(510), 
	"SUBATTACHYN" CHAR(1 CHAR), 
	"ATTACHUSERID" VARCHAR2(100 CHAR), 
	"ATTACHUSERNAME" NVARCHAR2(100), 
	"ATTACHUSERDEPTID" VARCHAR2(100 CHAR), 
	"ATTACHUSERDEPTNAME" NVARCHAR2(100), 
	"ATTACHUSERJOBTITLE" NVARCHAR2(100), 
	"ATTACHUSERNAME2" NVARCHAR2(100), 
	"ATTACHUSERJOBTITLE2" NVARCHAR2(100), 
	"ATTACHUSERDEPTNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_ENDAPRDOCINFO
--------------------------------------------------------

  CREATE TABLE "TBL_ENDAPRDOCINFO" 
   (	"DOCID" CHAR(20 CHAR), 
	"ORGDOCID" CHAR(20 CHAR), 
	"DOCTYPE" CHAR(3 CHAR), 
	"DOCSTATE" CHAR(3 CHAR), 
	"FUNCTIONTYPE" CHAR(3 CHAR), 
	"HREF" NVARCHAR2(510), 
	"DOCTITLE" NVARCHAR2(510), 
	"DOCNO" NVARCHAR2(100), 
	"HASATTACHYN" CHAR(1 CHAR), 
	"HASOPINIONYN" CHAR(1 CHAR), 
	"STARTDATE" DATE, 
	"ENDDATE" DATE, 
	"WRITERID" VARCHAR2(100 CHAR), 
	"WRITERNAME" NVARCHAR2(100), 
	"WRITERJOBTITLE" NVARCHAR2(100), 
	"WRITERDEPTID" VARCHAR2(100 CHAR), 
	"WRITERDEPTNAME" NVARCHAR2(100), 
	"FORMID" CHAR(10 CHAR), 
	"CONTAINERID" CHAR(10 CHAR), 
	"ISPUBLIC" CHAR(1 CHAR), 
	"WRITERNAME2" NVARCHAR2(100), 
	"WRITERJOBTITLE2" NVARCHAR2(100), 
	"WRITERDEPTNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_ENDAPRLINEINFO
--------------------------------------------------------

  CREATE TABLE "TBL_ENDAPRLINEINFO" 
   (	"DOCID" CHAR(20 CHAR), 
	"APRMEMBERSN" NUMBER(10,0), 
	"APRTYPE" CHAR(3 CHAR), 
	"APRSTATE" CHAR(3 CHAR), 
	"APRMEMBERID" VARCHAR2(100 CHAR), 
	"APRMEMBERISDEPTYN" CHAR(1 CHAR), 
	"APRMEMBERNAME" NVARCHAR2(100), 
	"APRMEMBERJOBTITLE" NVARCHAR2(100), 
	"APRMEMBERDEPTID" VARCHAR2(100 CHAR), 
	"APRMEMBERDEPTNAME" NVARCHAR2(100), 
	"APRMEMBERLDAPPATH" VARCHAR2(100 CHAR), 
	"RECEIVEDDATE" DATE, 
	"PROCESSDATE" DATE, 
	"ISPROPOSERYN" CHAR(1 CHAR), 
	"ISBRIEFUSERYN" CHAR(1 CHAR), 
	"REASONDONOTAPPROVAL" VARCHAR2(255 CHAR), 
	"APRMEMBERNAME2" NVARCHAR2(100), 
	"APRMEMBERJOBTITLE2" NVARCHAR2(100), 
	"APRMEMBERDEPTNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_ENDAPROPINIONINFO
--------------------------------------------------------

  CREATE TABLE "TBL_ENDAPROPINIONINFO" 
   (	"DOCID" CHAR(20 CHAR), 
	"USERID" VARCHAR2(100 CHAR), 
	"OPINIONGB" CHAR(3 CHAR), 
	"CONTENT" NCLOB, 
	"USERNAME" NVARCHAR2(100), 
	"USERJOBTITLE" NVARCHAR2(100), 
	"USERDEPTID" VARCHAR2(100 CHAR), 
	"USERDEPTNAME" NVARCHAR2(100), 
	"OPINIONSN" NUMBER(10,0), 
	"USERNAME2" NVARCHAR2(100), 
	"USERJOBTITLE2" NVARCHAR2(100), 
	"USERDEPTNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_ENDATTACHINFO
--------------------------------------------------------

  CREATE TABLE "TBL_ENDATTACHINFO" 
   (	"DOCID" CHAR(20 CHAR), 
	"ATTACHFILESN" NUMBER(10,0), 
	"VIEWORDER" NUMBER(10,0), 
	"ATTACHFILENAME" NVARCHAR2(510), 
	"ATTACHFILEHREF" NVARCHAR2(510), 
	"ATTACHFILESIZE" FLOAT(126), 
	"ATTACHUSERID" VARCHAR2(100 CHAR), 
	"ATTACHUSERNAME" NVARCHAR2(100), 
	"ATTACHUSERJOBTITLE" NVARCHAR2(100), 
	"ATTACHUSERDEPTID" VARCHAR2(100 CHAR), 
	"ATTACHUSERDEPTNAME" NVARCHAR2(100), 
	"PAGENUM" NUMBER(10,0), 
	"DISPLAYNAME" NVARCHAR2(300), 
	"BODYATTACH" CHAR(1 CHAR), 
	"ATTACHUSERNAME2" NVARCHAR2(100), 
	"ATTACHUSERJOBTITLE2" NVARCHAR2(100), 
	"ATTACHUSERDEPTNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE),
	"ISBIGATTACH" CHAR(1 CHAR) DEFAULT 'N',
	"ISBIGATTACHDEL" CHAR(1 CHAR) DEFAULT 'N',
    "SAVEDATE" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_ENDRECEIPTPOINTINFO
--------------------------------------------------------

  CREATE TABLE "TBL_ENDRECEIPTPOINTINFO" 
   (	"DOCID" CHAR(20 CHAR), 
	"RECEIPTPOINTID" VARCHAR2(100 CHAR), 
	"RECEIPTPOINTNAME" NVARCHAR2(100), 
	"EXTRECEPTYN" CHAR(1 CHAR), 
	"PROCESSYN" CHAR(1 CHAR), 
	"PROCESSSN" NUMBER(10,0), 
	"CANEDITYN" CHAR(1 CHAR), 
	"EXTRECEPTEMAIL" VARCHAR2(100 CHAR), 
	"RECEIPTMEMBERID" VARCHAR2(100 CHAR), 
	"RECEIPTMEMBERNAME" NVARCHAR2(100), 
	"PROCESSDATE" DATE, 
	"RECEIPTMEMBERJOBTITLE" NVARCHAR2(100), 
	"DEPTMEMBERSN" NUMBER(10,0), 
	"RECEIPTPOINTNAME2" NVARCHAR2(100), 
	"RECEIPTMEMBERNAME2" NVARCHAR2(100), 
	"RECEIPTMEMBERJOBTITLE2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_ENDRECEIPTPROCESSINFO
--------------------------------------------------------

  CREATE TABLE "TBL_ENDRECEIPTPROCESSINFO" 
   (	"RECEIVESN" NUMBER(10,0), 
	"DOCID" CHAR(20 CHAR), 
	"SENTDEPTID" VARCHAR2(100 CHAR), 
	"SENTDEPTNAME" NVARCHAR2(100), 
	"RECEIVEDDEPTID" VARCHAR2(100 CHAR), 
	"RECEIVEDDEPTNAME" NVARCHAR2(100), 
	"DOCSTATE" CHAR(3 CHAR), 
	"APRSTATE" CHAR(3 CHAR), 
	"PROCESSDATE" DATE, 
	"PROCESSYN" CHAR(1 CHAR), 
	"PROCESSDOCID" CHAR(20 CHAR), 
	"PROCESSORID" VARCHAR2(100 CHAR), 
	"PROCESSORNAME" NVARCHAR2(100), 
	"PROCESSORJOBTITLE" NVARCHAR2(100), 
	"PARENTSDOCID" CHAR(20 CHAR), 
	"SENTDEPTNAME2" NVARCHAR2(100), 
	"RECEIVEDDEPTNAME2" NVARCHAR2(100), 
	"PROCESSORNAME2" NVARCHAR2(100), 
	"PROCESSORJOBTITLE2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_EXPAPRDOCINFO
--------------------------------------------------------

  CREATE TABLE "TBL_EXPAPRDOCINFO" 
   (	"DOCID" CHAR(20 CHAR), 
	"SECURITYCODE" NUMBER(10,0), 
	"STORAGEPERIOD" VARCHAR2(40 CHAR), 
	"KEYWORD" NVARCHAR2(510), 
	"FORMNAME" NVARCHAR2(510), 
	"COMPANYID" VARCHAR2(20 BYTE), 
	"ITEMCODE" VARCHAR2(40 CHAR), 
	"ITEMNAME" NVARCHAR2(200), 
	"URGENTAPPROVAL" CHAR(1 CHAR), 
	"SECURITYAPPROVAL" CHAR(10 CHAR), 
	"TEMPATTRIBUTE" NVARCHAR2(100), 
	"STATUS" CHAR(1 CHAR), 
	"SPECIALRECORDCODE" CHAR(5 CHAR), 
	"PUBLICITYCODE" CHAR(9 CHAR), 
	"LIMITRANGE" VARCHAR2(100 CHAR), 
	"PAGENUM" NUMBER(10,0), 
	"CABINETID" VARCHAR2(120 BYTE), 
	"TASKCODE" CHAR(8 CHAR), 
	"DOCNUMCODE" NVARCHAR2(100), 
	"ORGDOCNUMCODE" NVARCHAR2(100), 
	"SEPERATEATTACHXML" NCLOB, 
	"SUMMARY" NCLOB, 
	"FORMNAME2" NVARCHAR2(510), 
	"ITEMNAME2" NVARCHAR2(200), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"PUBLICITYYN" CHAR(2 BYTE), 
	"FORMVERSION" NUMBER(10,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_EXPAPRLINE
--------------------------------------------------------

  CREATE TABLE "TBL_EXPAPRLINE" 
   (	"DOCID" CHAR(20 CHAR), 
	"APRMEMBERSN" NUMBER(10,0), 
	"ORGUSERID" VARCHAR2(100 CHAR), 
	"PROXYUSERID" VARCHAR2(100 CHAR), 
	"PROXYUSERNAME" NVARCHAR2(100), 
	"PROXYUSERJOBTITLE" NVARCHAR2(100), 
	"PROXYUSERDEPTID" VARCHAR2(100 CHAR), 
	"PROXYUSERDEPTNAME" NVARCHAR2(100), 
	"PROXYUSERNAME2" NVARCHAR2(100), 
	"PROXYUSERJOBTITLE2" NVARCHAR2(100), 
	"PROXYUSERDEPTNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_EXPENDAPRDOCINFO
--------------------------------------------------------

  CREATE TABLE "TBL_EXPENDAPRDOCINFO" 
   (	"DOCID" CHAR(20 CHAR), 
	"SECURITYCODE" NUMBER(10,0), 
	"STORAGEPERIOD" VARCHAR2(40 CHAR), 
	"KEYWORD" NVARCHAR2(510), 
	"ORGCONTID" CHAR(10 CHAR), 
	"DELFLAG" CHAR(1 CHAR), 
	"FORMNAME" NVARCHAR2(510), 
	"COMPANYID" NVARCHAR2(20), 
	"ITEMCODE" VARCHAR2(40 CHAR), 
	"ITEMNAME" NVARCHAR2(200), 
	"URGENTAPPROVAL" CHAR(1 CHAR), 
	"SECURITYAPPROVAL" CHAR(10 CHAR), 
	"TEMPATTRIBUTE" NVARCHAR2(100), 
	"STATUS" CHAR(1 CHAR), 
	"EDMSYN" CHAR(1 CHAR), 
	"SPECIALRECORDCODE" CHAR(5 CHAR), 
	"PUBLICITYCODE" CHAR(9 CHAR), 
	"LIMITRANGE" VARCHAR2(100 CHAR), 
	"PAGENUM" NUMBER(10,0), 
	"CABINETID" VARCHAR2(120 BYTE), 
	"TASKCODE" CHAR(8 CHAR), 
	"DOCNUMCODE" VARCHAR2(200 BYTE), 
	"ORGDOCNUMCODE" VARCHAR2(52 CHAR), 
	"SEPERATEATTACHXML" NCLOB, 
	"SUMMARY" NCLOB, 
	"FORMNAME2" NVARCHAR2(510), 
	"ITEMNAME2" NVARCHAR2(200), 
	"SIGNCHECK" CHAR(1 CHAR) DEFAULT 'N', 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"PUBLICITYYN" CHAR(2 BYTE), 
	"FORMVERSION" NUMBER(10,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_EXPENDAPRLINE
--------------------------------------------------------

  CREATE TABLE "TBL_EXPENDAPRLINE" 
   (	"DOCID" CHAR(20 CHAR), 
	"APRMEMBERSN" NUMBER(10,0), 
	"ORGUSERID" VARCHAR2(100 CHAR), 
	"PROXYUSERID" VARCHAR2(100 CHAR), 
	"PROXYUSERNAME" NVARCHAR2(100), 
	"PROXYUSERJOBTITLE" NVARCHAR2(100), 
	"PROXYUSERDEPTID" VARCHAR2(100 CHAR), 
	"PROXYUSERDEPTNAME" NVARCHAR2(200), 
	"PROXYUSERNAME2" NVARCHAR2(100), 
	"PROXYUSERJOBTITLE2" NVARCHAR2(100), 
	"PROXYUSERDEPTNAME2" NVARCHAR2(200), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_FORMCONNINFO
--------------------------------------------------------

  CREATE TABLE "TBL_FORMCONNINFO" 
   (	"SN" NUMBER(10,0), 
	"CONNNODE" VARCHAR2(40 BYTE), 
	"CONNINFO" VARCHAR2(40 BYTE), 
	"DESCRIPTION" VARCHAR2(100 BYTE), 
	"UPPERNODE" VARCHAR2(100 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_FORMCONTAINER
--------------------------------------------------------

  CREATE TABLE "TBL_FORMCONTAINER" 
   (	"FORMCONTID" NVARCHAR2(40), 
	"FORMCONTNAME" NVARCHAR2(200), 
	"FORMCONTOWNDEPID" NVARCHAR2(255), 
	"FORMCONTPARENTS" NVARCHAR2(200), 
	"FORMCONTDESCRIPTION" NVARCHAR2(1020), 
	"FORMCONTNAME2" NVARCHAR2(200), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" NVARCHAR2(20)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_FORMCONTUSERGROUP
--------------------------------------------------------

  CREATE TABLE "TBL_FORMCONTUSERGROUP" 
   (	"FORMCONTID" CHAR(10 CHAR), 
	"FORMCONTUSERDEPID" VARCHAR2(100 CHAR), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_FORMGROUP
--------------------------------------------------------

  CREATE TABLE "TBL_FORMGROUP" 
   (	"SN" NUMBER(10,0), 
	"FORMGROUPID" VARCHAR2(50 CHAR), 
	"FORMID" VARCHAR2(10 CHAR), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_FORMINFO
--------------------------------------------------------

  CREATE TABLE "TBL_FORMINFO" 
   (	"FORMCONTID" CHAR(10 CHAR), 
	"FORMID" CHAR(10 CHAR), 
	"FORMNAME" NVARCHAR2(510), 
	"FORMNAME2" NVARCHAR2(510), 
	"FORMDOCTYPE" VARCHAR2(6 CHAR), 
	"FORMDESCRIPTION" NVARCHAR2(510), 
	"FORMFILELOCATION" NVARCHAR2(100), 
	"FORMCONNFLAG" CHAR(1 CHAR) DEFAULT 'N', 
	"FORMORDER" NUMBER(10,0), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE), 
	"FORMDRAFTALLFLAG" CHAR(1 BYTE) DEFAULT 'N', 
	"REFORMFLAG" CHAR(1 BYTE) DEFAULT 'N', 
	"LASTSIGNPOSFLAG" CHAR(1 BYTE) DEFAULT 'F', 
	"FORMVERSION" NUMBER(10,0) DEFAULT 0, 
	"FORMXSLT" LONG, 
	"PASSAPRLINEFLAG" VARCHAR2(4 BYTE) DEFAULT 'N', 
	"FORMGUIDE" VARCHAR2(2000 CHAR), 
	"OPENGOVFLAG" NVARCHAR2(4) DEFAULT 'N',
	"APROPTION" NVARCHAR2(300),
	"SIHANGTYPE" VARCHAR2(10) DEFAULT ''
   ) ;

   COMMENT ON COLUMN "TBL_FORMINFO"."LASTSIGNPOSFLAG" IS 'F:마지막사인칸, O:순서대로';
--------------------------------------------------------
--  DDL for Table TBL_FORMPROPERTY
--------------------------------------------------------

  CREATE TABLE "TBL_FORMPROPERTY" 
   (	"SN" NUMBER, 
	"CODE" NVARCHAR2(36), 
	"ID" NVARCHAR2(100), 
	"NAME" NVARCHAR2(100), 
	"DESCRIPTION" NVARCHAR2(100), 
	"UPPERCODE" NVARCHAR2(36), 
	"TENANT_ID" NUMBER DEFAULT NULL, 
	"COMPANYID" NVARCHAR2(20)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_FORMRECV
--------------------------------------------------------

  CREATE TABLE "TBL_FORMRECV" 
   (	"FORMID" CHAR(10 CHAR), 
	"DEPTID" VARCHAR2(100 CHAR), 
	"DEPTSN" NUMBER(10,0), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE), 
	"DEPTNAME" VARCHAR2(100 BYTE), 
	"USERID" VARCHAR2(100 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_FORMUSERINFO
--------------------------------------------------------

  CREATE TABLE "TBL_FORMUSERINFO" 
   (	"FORMID" CHAR(10 CHAR), 
	"USERID" VARCHAR2(100 CHAR), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_FORM_AUTORULE
--------------------------------------------------------

  CREATE TABLE "TBL_FORM_AUTORULE" 
   (	"FORMID" VARCHAR2(40 BYTE), 
	"AUTORULESN" NUMBER(10,0), 
	"AUTORULEGUID" VARCHAR2(50 BYTE), 
	"CHECKFIELDTYPE" VARCHAR2(50 BYTE) DEFAULT NULL, 
	"CHECKFIELD" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"OPERATORTYPE" VARCHAR2(10 BYTE) DEFAULT NULL, 
	"OPERATOR" VARCHAR2(10 BYTE) DEFAULT NULL, 
	"CONDTYPE" VARCHAR2(10 BYTE) DEFAULT NULL, 
	"CONDVALUE" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"CONDVALUEDEPTID" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"RESULTAPRTYPE" VARCHAR2(6 BYTE) DEFAULT NULL, 
	"RESULTAPRMEMEBERID" VARCHAR2(50 BYTE) DEFAULT NULL, 
	"FIXFLAG" VARCHAR2(4 BYTE) DEFAULT NULL, 
	"DOCTYPE" VARCHAR2(10 BYTE) DEFAULT NULL, 
	"COMPANYID" VARCHAR2(20 BYTE), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_FORM_AUTORULELINE
--------------------------------------------------------

  CREATE TABLE "TBL_FORM_AUTORULELINE" 
   (	"FORMID" VARCHAR2(40 BYTE), 
	"AUTORULEGUID" VARCHAR2(50 BYTE), 
	"APRMEMBERSN" NUMBER(10,0), 
	"APRTYPE" VARCHAR2(24 BYTE) DEFAULT NULL, 
	"APRSTATE" VARCHAR2(24 BYTE) DEFAULT NULL, 
	"APRMEMBERID" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"APRMEMBERISDEPTYN" VARCHAR2(4 BYTE) DEFAULT NULL, 
	"APRMEMBERNAME" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"APRMEMBERNAME2" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"APRMEMBERJOBTITLE" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"APRMEMBERJOBTITLE2" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"APRMEMBERDEPTID" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"APRMEMBERDEPTNAME" VARCHAR2(200 BYTE) DEFAULT NULL, 
	"APRMEMBERDEPTNAME2" VARCHAR2(200 BYTE) DEFAULT NULL, 
	"APRMEMBERLDAPPATH" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"RECEIVEDDATE" DATE DEFAULT NULL, 
	"PROCESSDATE" DATE DEFAULT NULL, 
	"REASONDONOTAPPROV" VARCHAR2(255 BYTE) DEFAULT NULL, 
	"ISPROPOSERYN" VARCHAR2(4 BYTE) DEFAULT NULL, 
	"ISBRIEFUSERYN" VARCHAR2(4 BYTE) DEFAULT NULL, 
	"COMPANYID" VARCHAR2(20 BYTE), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_FORM_OFFICE
--------------------------------------------------------

  CREATE TABLE "TBL_FORM_OFFICE" 
   (	"FORMID" CHAR(10 CHAR), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_HISTORYATTACHINFO
--------------------------------------------------------

  CREATE TABLE "TBL_HISTORYATTACHINFO" 
   (	"DOCID" CHAR(20 CHAR), 
	"ATTACHFILESN" NUMBER(10,0), 
	"ATTACHFILENAME" NVARCHAR2(510), 
	"ATTACHFILEDISPLAYNAME" NVARCHAR2(510), 
	"ATTACHFILEHREF" NVARCHAR2(510), 
	"ATTACHFILESIZE" FLOAT(126), 
	"ATTACHUSERID" VARCHAR2(100 CHAR), 
	"ATTACHUSERNAME" NVARCHAR2(100), 
	"ATTACHUSERJOBTITLE" NVARCHAR2(100), 
	"ATTACHUSERDEPTID" VARCHAR2(100 CHAR), 
	"ATTACHUSERDEPTNAME" NVARCHAR2(100), 
	"MODIFYDATE" DATE, 
	"MODIFYSN" NUMBER(10,0), 
	"MODIFYFLAG" VARCHAR2(20 CHAR), 
	"PAGENUM" NUMBER(10,0), 
	"CHKFLAG" CHAR(1 CHAR), 
	"ATTACHUSERNAME2" NVARCHAR2(100), 
	"ATTACHUSERJOBTITLE2" NVARCHAR2(100), 
	"ATTACHUSERDEPTNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_HISTORYDOCINFO
--------------------------------------------------------

  CREATE TABLE "TBL_HISTORYDOCINFO" 
   (	"DOCID" CHAR(20 CHAR), 
	"CHANGESN" NUMBER(10,0), 
	"URL" VARCHAR2(255 CHAR), 
	"CHANGEUSERID" VARCHAR2(100 CHAR), 
	"CHANGEUSERNAME" NVARCHAR2(100), 
	"CHANGEUSERJOBTITLE" NVARCHAR2(100), 
	"CHANGEUSERDEPTID" VARCHAR2(100 CHAR), 
	"CHANGEUSERDEPTNAME" NVARCHAR2(100), 
	"CHANGEDATE" DATE, 
	"CHKFLAG" CHAR(1 CHAR), 
	"CHANGEUSERNAME2" NVARCHAR2(100), 
	"CHANGEUSERJOBTITLE2" NVARCHAR2(100), 
	"CHANGEUSERDEPTNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE), 
	"ISBEFOREDOC" CHAR(1 CHAR), 
	"BEFOREDOCURL" VARCHAR2(255 CHAR)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_HISTORYLINEINFO
--------------------------------------------------------

  CREATE TABLE "TBL_HISTORYLINEINFO" 
   (	"DOCID" CHAR(20 CHAR), 
	"APRMEMBERSN" NUMBER(10,0), 
	"APRTYPE" CHAR(3 CHAR), 
	"APRSTATE" CHAR(3 CHAR), 
	"APRMEMBERID" VARCHAR2(100 CHAR), 
	"APRMEMBERISDEPTYN" CHAR(1 CHAR), 
	"APRMEMBERNAME" NVARCHAR2(100), 
	"APRMEMBERJOBTITLE" NVARCHAR2(100), 
	"APRMEMBERDEPTID" VARCHAR2(100 CHAR), 
	"APRMEMBERDEPTNAME" NVARCHAR2(100), 
	"APRMEMBERLDAPPATH" VARCHAR2(100 CHAR), 
	"ISPROPOSERYN" CHAR(1 CHAR), 
	"ISBRIEFUSERYN" CHAR(1 CHAR), 
	"MODIFYDATE" DATE, 
	"MODIFYSN" NUMBER(10,0), 
	"MODIFYUSERID" VARCHAR2(100 CHAR), 
	"MODIFYUSERNAME" NVARCHAR2(100), 
	"MODIFYUSERJOBTITLE" NVARCHAR2(100), 
	"MODIFYUSERDEPTID" VARCHAR2(100 CHAR), 
	"MODIFYUSERDEPTNAME" NVARCHAR2(100), 
	"CHKFLAG" CHAR(1 CHAR), 
	"APRMEMBERNAME2" NVARCHAR2(100), 
	"APRMEMBERDEPTNAME2" NVARCHAR2(100), 
	"APRMEMBERJOBTITLE2" NVARCHAR2(100), 
	"MODIFYUSERNAME2" NVARCHAR2(100), 
	"MODIFYUSERJOBTITLE2" NVARCHAR2(100), 
	"MODIFYUSERDEPTNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_HISTORYRECEIPTINFO
--------------------------------------------------------

  CREATE TABLE "TBL_HISTORYRECEIPTINFO" 
   (	"DOCID" CHAR(20 CHAR), 
	"RECEIPTDEPTID" VARCHAR2(100 CHAR), 
	"RECEIPTDEPTNAME" NVARCHAR2(100), 
	"STATUS" CHAR(1 CHAR), 
	"STATUSDATE" DATE, 
	"RECEIPTDEPTNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_HOLIDAYLIST
--------------------------------------------------------

  CREATE TABLE "TBL_HOLIDAYLIST" 
   (	"HOLIDAYID" NUMBER(10,0), 
	"HOLIDAYNAME" NVARCHAR2(50), 
	"HOLIDAYNAME2" NVARCHAR2(50), 
	"HOLIDAYDATE" DATE, 
	"ISSOLAR" NUMBER(10,0), 
	"ISREPEAT" NUMBER(10,0), 
	"ISREST" NUMBER(10,0), 
	"ISUSE" NUMBER(10,0), 
	"USECOMPANY" VARCHAR2(20 CHAR), 
	"TENANT_ID" NUMBER(5,0), 
	"HOLIDAYFLAG" VARCHAR2(45 BYTE), 
	"HOLIDAYREPEAT" VARCHAR2(45 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_JOURNAL
--------------------------------------------------------

  CREATE TABLE "TBL_JOURNAL" 
   (	"JOURNAL_ID" NUMBER(10,0), 
	"TENANT_ID" NUMBER(5,0), 
	"JOURNAL_TITLE" NVARCHAR2(200), 
	"JOURNAL_CONTENT" CLOB, 
	"JOURNAL_DATE" DATE, 
	"JOURNAL_WRITER" NVARCHAR2(80), 
	"FORM_ID" NUMBER(10,0), 
	"DEPT_SHARE" NCHAR(1), 
	"JOURNAL_STATUS" NVARCHAR2(10), 
	"JOURNAL_DEPT" NVARCHAR2(80), 
	"JOURNAL_TEXT" CLOB, 
	"JOURNAL_SUM" NCHAR(1) DEFAULT 'N'
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_JOURNAL_AUTH
--------------------------------------------------------

  CREATE TABLE "TBL_JOURNAL_AUTH" 
   (	"USER_ID" NVARCHAR2(80), 
	"DEPT_ID" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_JOURNAL_ENV
--------------------------------------------------------

  CREATE TABLE "TBL_JOURNAL_ENV" 
   (	"USER_ID" NVARCHAR2(80), 
	"TENANT_ID" NUMBER(5,0), 
	"LIST_CNT" NUMBER(10,0) DEFAULT 20, 
	"VIEWENV" NVARCHAR2(10) DEFAULT 'NONE', 
	"PREVIEW_WCONTENT" NUMBER(10,0) DEFAULT 50, 
	"PREVIEW_HCONTENT" NUMBER(10,0) DEFAULT 50, 
	"REPLY_ALERT" NCHAR(1) DEFAULT 'Y', 
	"RECV_ALERT" NCHAR(1) DEFAULT 'Y'
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_JOURNAL_FILE
--------------------------------------------------------

  CREATE TABLE "TBL_JOURNAL_FILE" 
   (	"FILE_ID" NUMBER(10,0), 
	"TENANT_ID" NUMBER(5,0), 
	"FILE_PATH" NVARCHAR2(200), 
	"JOURNAL_ID" NUMBER(10,0), 
	"FILE_SIZE" NVARCHAR2(45), 
	"FILE_NAME" NVARCHAR2(200)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_JOURNAL_FORM
--------------------------------------------------------

  CREATE TABLE "TBL_JOURNAL_FORM" 
   (	"FORM_ID" NUMBER(10,0), 
	"TENANT_ID" NUMBER(5,0), 
	"FORM_NAME" NVARCHAR2(200), 
	"FORM_CONTENT" CLOB, 
	"TYPE_ID" NVARCHAR2(50), 
	"FORM_DATE" DATE, 
	"FORM_WRITER" NVARCHAR2(80), 
	"FORM_INFO" NVARCHAR2(2000), 
	"FORM_STATUS" NVARCHAR2(20), 
	"COMPANY_ID" NVARCHAR2(80), 
	"FORM_DEL_FLAG" VARCHAR2(10 BYTE) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_JOURNAL_FORM_TYPE
--------------------------------------------------------

  CREATE TABLE "TBL_JOURNAL_FORM_TYPE" 
   (	"TYPE_ID" NVARCHAR2(50), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANY_ID" NVARCHAR2(80), 
	"USED" NVARCHAR2(20) DEFAULT 'use'
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_JOURNAL_FORM_USE_DEPT
--------------------------------------------------------

  CREATE TABLE "TBL_JOURNAL_FORM_USE_DEPT" 
   (	"DEPT_ID" NVARCHAR2(80), 
	"FORM_ID" NUMBER(10,0), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_JOURNAL_ORDER
--------------------------------------------------------

  CREATE TABLE "TBL_JOURNAL_ORDER" 
   (	"USER_ID" VARCHAR2(80 BYTE), 
	"RELATED_USER_ID" VARCHAR2(80 BYTE), 
	"USER_ORDER" NUMBER(7,0) DEFAULT '1', 
	"TENANT_ID" NUMBER(7,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_JOURNAL_RECV
--------------------------------------------------------

  CREATE TABLE "TBL_JOURNAL_RECV" 
   (	"USER_ID" NVARCHAR2(80), 
	"TENANT_ID" NUMBER(5,0), 
	"JOURNAL_ID" NUMBER(10,0), 
	"RECIEVE_DATE" DATE, 
	"RECV_STATUS" NCHAR(1) DEFAULT 'Y'
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_JOURNAL_RECV_FAVORITE
--------------------------------------------------------

  CREATE TABLE "TBL_JOURNAL_RECV_FAVORITE" 
   (	"FAVORITE_ID" NUMBER(10,0), 
	"TENANT_ID" NUMBER(5,0), 
	"USER_ID" NVARCHAR2(80), 
	"FAVORITE_NAME" NVARCHAR2(200), 
	"FAVORITE_DATE" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_JOURNAL_RECV_FAVORITE_LIST
--------------------------------------------------------

  CREATE TABLE "TBL_JOURNAL_RECV_FAVORITE_LIST" 
   (	"FAVORITE_ID" NUMBER(10,0), 
	"USER_ID" NVARCHAR2(80), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_JOURNAL_REPLY
--------------------------------------------------------

  CREATE TABLE "TBL_JOURNAL_REPLY" 
   (	"REPLY_ID" NUMBER(10,0), 
	"TENANT_ID" NUMBER(5,0), 
	"REPLY_CONTENT" NVARCHAR2(2000), 
	"JOURNAL_ID" NUMBER(10,0), 
	"REPLY_DATE" DATE, 
	"REPLY_WRITER" NVARCHAR2(80)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_JOURNAL_SYMBOL
--------------------------------------------------------

  CREATE TABLE "TBL_JOURNAL_SYMBOL" 
   (	"SYMBOL_LEVEL" NUMBER(10,0) DEFAULT '1', 
	"SYMBOL_STR" VARCHAR2(50 BYTE), 
	"COMPANY_ID" VARCHAR2(50 BYTE), 
	"TENANT_ID" NUMBER(9,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_JOURNAL_VIEW
--------------------------------------------------------

  CREATE TABLE "TBL_JOURNAL_VIEW" 
   (	"USER_ID" NVARCHAR2(80), 
	"TENANT_ID" NUMBER(5,0), 
	"JOURNAL_ID" NUMBER(10,0), 
	"VIEW_DATE" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_LADDER
--------------------------------------------------------

  CREATE TABLE "TBL_LADDER" 
   (	"TENANT_ID" NUMBER(5,0), 
	"LADDERID" NUMBER(10,0), 
	"TITLE" NVARCHAR2(250), 
	"TYPE" NUMBER(1,0), 
	"STATUS" NUMBER(1,0) DEFAULT '0', 
	"SECRETFLAG" NUMBER(1,0) DEFAULT '0', 
	"WRITERID" VARCHAR2(80 BYTE), 
	"WRITERNAME" NVARCHAR2(60), 
	"WRITERNAME2" NVARCHAR2(60), 
	"DEPTNAME" NVARCHAR2(50), 
	"DEPTNAME2" NVARCHAR2(50), 
	"LINECNT" NUMBER(4,0), 
	"LINEARRAY" CLOB, 
	"DELETEFLAG" NUMBER(1,0) DEFAULT '0', 
	"WRITEDATE" VARCHAR2(40 BYTE), 
	"STARTDATE" VARCHAR2(40 BYTE), 
	"DELETEDATE" VARCHAR2(40 BYTE), 
	"COMPANYID" VARCHAR2(80 BYTE), 
	"DEPTID" VARCHAR2(80 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_LADDER_BM
--------------------------------------------------------

  CREATE TABLE "TBL_LADDER_BM" 
   (	"TENANT_ID" NUMBER(5,0), 
	"LADDERBMID" NUMBER(10,0), 
	"BMNAME" NVARCHAR2(50) DEFAULT NULL, 
	"USERID" VARCHAR2(80 BYTE), 
	"REGDATE" VARCHAR2(40 BYTE), 
	"COMPANYID" VARCHAR2(80 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_LADDER_BMUSER
--------------------------------------------------------

  CREATE TABLE "TBL_LADDER_BMUSER" 
   (	"TENANT_ID" NUMBER(5,0), 
	"ID" NUMBER(10,0), 
	"LADDERBMID" NUMBER(10,0), 
	"USERID" VARCHAR2(80 BYTE), 
	"USERNAME" NVARCHAR2(60), 
	"USERNAME2" NVARCHAR2(60), 
	"COMPANYID" VARCHAR2(20 BYTE), 
	"DESCRIPTION" NVARCHAR2(100), 
	"DESCRIPTION2" NVARCHAR2(100)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_LADDER_COMMENT
--------------------------------------------------------

  CREATE TABLE "TBL_LADDER_COMMENT" 
   (	"TENANT_ID" NUMBER(5,0), 
	"ID" NUMBER(10,0), 
	"LADDERID" NUMBER(10,0), 
	"COMMENT" CLOB, 
	"USERID" VARCHAR2(80 BYTE), 
	"USERNAME" NVARCHAR2(60), 
	"USERNAME2" NVARCHAR2(60), 
	"WRITEDATE" VARCHAR2(40 BYTE), 
	"DEPTID" VARCHAR2(80 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_LADDER_LINE
--------------------------------------------------------

  CREATE TABLE "TBL_LADDER_LINE" 
   (	"TENANT_ID" NUMBER(5,0), 
	"ID" NUMBER(10,0), 
	"LADDERID" NUMBER(10,0), 
	"USERID" VARCHAR2(80 BYTE), 
	"USERNAME" NVARCHAR2(60), 
	"USERNAME2" NVARCHAR2(60), 
	"ITEM" NVARCHAR2(50), 
	"LADDERORDER" NUMBER(4,0), 
	"RESULTUSERID" VARCHAR2(80 BYTE), 
	"RESULTUSERNAME" NVARCHAR2(60), 
	"RESULTUSERNAME2" NVARCHAR2(60), 
	"DESCRIPTION" NVARCHAR2(100), 
	"DESCRIPTION2" NVARCHAR2(100)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_LADDER_ORDER
--------------------------------------------------------

  CREATE TABLE "TBL_LADDER_ORDER" 
   (	"TENANT_ID" NUMBER(5,0), 
	"ID" NUMBER(10,0), 
	"LADDERID" NUMBER(10,0), 
	"CHANGELADDERID" NUMBER(10,0), 
	"USERID" VARCHAR2(80 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_LASTAPRLINE
--------------------------------------------------------

  CREATE TABLE "TBL_LASTAPRLINE" 
   (	"USERID" VARCHAR2(100 CHAR), 
	"FORMID" CHAR(10 CHAR), 
	"APRMEMBERSN" NUMBER(10,0), 
	"APRTYPE" CHAR(3 CHAR), 
	"APRSTATE" CHAR(3 CHAR), 
	"APRMEMBERID" VARCHAR2(100 CHAR), 
	"APRMEMBERISDEPTYN" CHAR(1 CHAR), 
	"APRMEMBERNAME" NVARCHAR2(100), 
	"APRMEMBERJOBTITLE" NVARCHAR2(100), 
	"APRMEMBERDEPTID" VARCHAR2(100 CHAR), 
	"APRMEMBERDEPTNAME" NVARCHAR2(100), 
	"APRMEMBERLDAPPATH" VARCHAR2(100 CHAR), 
	"RECEIVEDDATE" DATE, 
	"PROCESSDATE" DATE, 
	"REASONDONOTAPPROV" NVARCHAR2(510), 
	"ISPROPOSERYN" CHAR(1 CHAR), 
	"ISBRIEFUSERYN" CHAR(1 CHAR), 
	"APRMEMBERNAME2" NVARCHAR2(100), 
	"APRMEMBERJOBTITLE2" NVARCHAR2(100), 
	"APRMEMBERDEPTNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE),
	"DOCSTATE" NVARCHAR2(12) DEFAULT '011' NOT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_LASTDEPTLINE
--------------------------------------------------------

  CREATE TABLE "TBL_LASTDEPTLINE" 
   (	"USERID" VARCHAR2(100 CHAR), 
	"FORMID" CHAR(10 CHAR), 
	"RECEIPTPOINTID" VARCHAR2(100 CHAR), 
	"RECEIPTPOINTNAME" NVARCHAR2(100), 
	"EXTRECEPTYN" CHAR(1 CHAR), 
	"PROCESSYN" CHAR(1 CHAR), 
	"PROCESSSN" NUMBER(10,0), 
	"CANEDITYN" CHAR(1 CHAR), 
	"EXTRECEPTEMAIL" VARCHAR2(100 CHAR), 
	"RECEIPTMEMBERID" VARCHAR2(100 CHAR), 
	"RECEIPTMEMBERNAME" NVARCHAR2(100), 
	"PROCESSDATE" DATE, 
	"RECEIPTMEMBERJOBTITLE" NVARCHAR2(100), 
	"DEPTMEMBERSN" NUMBER(10,0), 
	"RECEIPTPOINTNAME2" NVARCHAR2(100), 
	"RECEIPTMEMBERNAME2" NVARCHAR2(100), 
	"RECEIPTMEMBERJOBTITLE2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE),
	"DOCSTATE" NVARCHAR2(12) DEFAULT '011' NOT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_LASTDOCID
--------------------------------------------------------

  CREATE TABLE "TBL_LASTDOCID" 
   (	"LASTDOCID" NVARCHAR2(40), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" NVARCHAR2(20)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_LINTEMPLET
--------------------------------------------------------

  CREATE TABLE "TBL_LINTEMPLET" 
   (	"USERID" VARCHAR2(100 CHAR), 
	"FORMID" CHAR(10 CHAR), 
	"APRLINESN" NUMBER(10,0), 
	"APRTEMPLETNAME" NVARCHAR2(400), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_LINTEMPLETDETAIL
--------------------------------------------------------

  CREATE TABLE "TBL_LINTEMPLETDETAIL" 
   (	"USERID" VARCHAR2(100 CHAR), 
	"FORMID" CHAR(10 CHAR), 
	"APRLINESN" NUMBER(10,0), 
	"APRMEMBERSN" NUMBER(10,0), 
	"APRTYPE" CHAR(3 CHAR), 
	"APRSTATE" CHAR(3 CHAR), 
	"APRMEMBERID" VARCHAR2(100 CHAR), 
	"APRMEMBERISDEPTYN" CHAR(1 CHAR), 
	"APRMEMBERNAME" NVARCHAR2(100), 
	"APRMEMBERJOBTITLE" NVARCHAR2(100), 
	"APRMEMBERDEPTID" VARCHAR2(100 CHAR), 
	"MEMBERDEPTNAME" NVARCHAR2(200), 
	"APRMEMBERNAME2" NVARCHAR2(100), 
	"APRMEMBERJOBTITLE2" NVARCHAR2(100), 
	"MEMBERDEPTNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_LISTINFO
--------------------------------------------------------

  CREATE TABLE "TBL_LISTINFO" 
   (	"LISTTYPE" NVARCHAR2(12), 
	"SN" NUMBER(10,0), 
	"NAME" NVARCHAR2(200), 
	"WIDTH" NUMBER(10,0), 
	"TABLENAME" NVARCHAR2(200), 
	"COLNAME" NVARCHAR2(2000), 
	"COLALIAS" NVARCHAR2(200), 
	"DTYPE" NVARCHAR2(200), 
	"TYPEDESC" NVARCHAR2(400), 
	"FIELDDESC" NVARCHAR2(400), 
	"NAME2" NVARCHAR2(200), 
	"NAME3" NVARCHAR2(200), 
	"NAME4" NVARCHAR2(200), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" NVARCHAR2(20)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_LISTOPTION
--------------------------------------------------------

  CREATE TABLE "TBL_LISTOPTION" 
   (	"LISTTYPE" NVARCHAR2(12), 
	"SN" NUMBER(10,0), 
	"NAME" NVARCHAR2(200), 
	"WIDTH" NUMBER(10,0), 
	"TABLENAME" NVARCHAR2(200), 
	"COLNAME" NVARCHAR2(400), 
	"COLALIAS" NVARCHAR2(200), 
	"DTYPE" NVARCHAR2(200), 
	"TYPEDESC" NVARCHAR2(400), 
	"FIELDDESC" NVARCHAR2(400), 
	"NAME2" NVARCHAR2(200), 
	"NAME3" NVARCHAR2(200), 
	"NAME4" NVARCHAR2(200), 
	"DELFLAG" VARCHAR2(20) DEFAULT NULL, 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" NVARCHAR2(20)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_LOGO_SIZE
--------------------------------------------------------

  CREATE TABLE "TBL_LOGO_SIZE" 
   (	"C_CLUBNO" NCHAR(20), 
	"LOGO_SIZE" FLOAT(126), 
	"BANNER_SIZE" FLOAT(126), 
	"TENANT_ID" NUMBER DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_LUNARUSE
--------------------------------------------------------

  CREATE TABLE "TBL_LUNARUSE" 
   (	"USECOMPANY" VARCHAR2(20 BYTE), 
	"LUNARUSE" NUMBER, 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_MEMO
--------------------------------------------------------

  CREATE TABLE "TBL_MEMO" 
   (	"MEMO_ID" NUMBER(10,0), 
	"CONTENTS" NCLOB, 
	"USER_ID" VARCHAR2(80 BYTE), 
	"DISPLAY_FLAG" NUMBER(4,0) DEFAULT '0', 
	"DELETE_FLAG" NUMBER(4,0) DEFAULT '0', 
	"WRITE_DATE" DATE DEFAULT NULL, 
	"DELETE_DATE" DATE DEFAULT NULL, 
	"ORDERS" NUMBER(10,0), 
	"FOLDER_ID" NUMBER(10,0) DEFAULT NULL, 
	"COLOR_ID" NUMBER(4,0) DEFAULT NULL, 
	"COMPANY_ID" VARCHAR2(80 BYTE), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_MEMO_CONFIG
--------------------------------------------------------

  CREATE TABLE "TBL_MEMO_CONFIG" 
   (	"USER_ID" VARCHAR2(80 BYTE), 
	"FONT_SIZE" NUMBER(4,0), 
	"USE_DATE" NUMBER(4,0) DEFAULT '1', 
	"USE_GADGET" NUMBER(4,0) DEFAULT '1', 
	"DEFAULT_COLOR" NUMBER(4,0) DEFAULT NULL, 
	"GADGET_RIGHT" NUMBER(6,0) DEFAULT NULL, 
	"GADGET_BOTTOM" NUMBER(6,0) DEFAULT NULL, 
	"LAYER_LEFT" NUMBER(6,0) DEFAULT NULL, 
	"LAYER_TOP" NUMBER(6,0) DEFAULT NULL, 
	"LAYER_WIDTH" NUMBER(6,0) DEFAULT NULL, 
	"LAYER_HEIGHT" NUMBER(6,0) DEFAULT NULL, 
	"COMPANY_ID" VARCHAR2(80 BYTE), 
	"TENANT_ID" NUMBER(5,0), 
	"FULL_MODE" NUMBER(4,0) DEFAULT '1', 
	"B_MEMO_LEFT" NUMBER(6,0) DEFAULT 0, 
	"B_MEMO_TOP" NUMBER(6,0) DEFAULT 0, 
	"B_MEMO_WIDTH" NUMBER(6,0) DEFAULT 0, 
	"B_MEMO_HEIGHT" NUMBER(6,0) DEFAULT 0, 
	"B_MEMO_STATUS" NUMBER(4,0) DEFAULT 0, 
	"MEMO_ID" NUMBER(10,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_MEMO_FOLDER
--------------------------------------------------------

  CREATE TABLE "TBL_MEMO_FOLDER" 
   (	"FOLDER_ID" NUMBER(10,0), 
	"FOLDER_NAME" VARCHAR2(100 BYTE), 
	"REG_DATE" DATE DEFAULT NULL, 
	"DELETE_DATE" DATE DEFAULT NULL, 
	"USER_ID" VARCHAR2(80 BYTE), 
	"ORDERS" NUMBER(10,0) DEFAULT NULL, 
	"COMPANY_ID" VARCHAR2(80 BYTE), 
	"TENANT_ID" NUMBER(5,0), 
	"DELETE_FLAG" NUMBER(4,0) DEFAULT '0'
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_MYTASKCODE
--------------------------------------------------------

  CREATE TABLE "TBL_MYTASKCODE" 
   (	"CN" NVARCHAR2(50), 
	"DEPTID" NVARCHAR2(50), 
	"CABINETID" NVARCHAR2(50), 
	"TASKCODE" NVARCHAR2(50), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_NOTIFICATION
--------------------------------------------------------

  CREATE TABLE "TBL_NOTIFICATION" 
   (	"ITEMSEQ" NUMBER(10,0), 
	"USERID" VARCHAR2(20 CHAR), 
	"POSTDATE" DATE, 
	"SENDER" NVARCHAR2(100), 
	"SUBJECT" NVARCHAR2(250), 
	"TYPE" NUMBER(5,0), 
	"ETCDATA" NVARCHAR2(200), 
	"LINKURL" VARCHAR2(1024 CHAR), 
	"SHOWMSG" NVARCHAR2(128) DEFAULT u'N', 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_OLDCABINETEXTRAINFO
--------------------------------------------------------

  CREATE TABLE "TBL_OLDCABINETEXTRAINFO" 
   (	"CABINETCLASSNO" VARCHAR2(100 CHAR), 
	"CREATEORGANNAME" NVARCHAR2(100), 
	"CLASSIFICATIONNO" CHAR(5 CHAR), 
	"CREATEORGANNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_OLDRECORDEXTRAINFO
--------------------------------------------------------

  CREATE TABLE "TBL_OLDRECORDEXTRAINFO" 
   (	"RECORDID" VARCHAR2(68 BYTE), 
	"CREATEORGANNAME" NVARCHAR2(100), 
	"RECORDNO" VARCHAR2(30 CHAR), 
	"KEEPINGPERIOD" CHAR(2 CHAR), 
	"CREATEORGANNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_OPENGOVDOCINFO
--------------------------------------------------------

  CREATE TABLE "TBL_OPENGOVDOCINFO" 
   (	"DOCID" NVARCHAR2(80), 
	"OPENFLAG" CHAR(1 BYTE) DEFAULT NULL, 
	"BASIS" NVARCHAR2(200) DEFAULT NULL, 
	"REASON" NVARCHAR2(1000) DEFAULT NULL, 
	"OPENLIMITDATE" DATE DEFAULT NULL, 
	"CREATEDATE" DATE DEFAULT NULL, 
	"UPDATEDATE" DATE DEFAULT NULL, 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" NVARCHAR2(20), 
	"LISTOPENFLAG" CHAR(1 BYTE) DEFAULT NULL,
	"DOCSIZE" NVARCHAR2(45) DEFAULT NULL,
	"SENDFLAG" CHAR(1 BYTE) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_OPENGOVFILEINFO
--------------------------------------------------------

  CREATE TABLE "TBL_OPENGOVFILEINFO" 
   (	"DOCID" NVARCHAR2(80), 
	"SN" NUMBER(10,0), 
	"FILEOPENFLAG" CHAR(1 BYTE) DEFAULT NULL, 
	"COMPANYID" NVARCHAR2(20), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
   
--------------------------------------------------------
--  DDL for Table TBL_OPENGOVMODIFYHISTORY
--------------------------------------------------------

  CREATE TABLE "TBL_OPENGOVMODIFYHISTORY" 
   (	"DOCID" NVARCHAR2(80), 
	"MODIFIERNAME" NVARCHAR2(400) DEFAULT NULL, 
	"SN" NUMBER(10,0), 
	"MODIFIERDEPTNAME" NVARCHAR2(400) DEFAULT NULL, 
	"MODIFYDATE" DATE DEFAULT NULL, 
	"MODIFYREASON" NCLOB DEFAULT NULL, 
	"TENANTID" NUMBER(5,0), 
	"COMPANYID" NVARCHAR2(20), 
	"MODIFIERID" NVARCHAR2(200) DEFAULT NULL, 
	"MODIFIERDEPTID" NVARCHAR2(200) DEFAULT NULL
   ) ;
   
--------------------------------------------------------
--  DDL for Table TBL_PASSWORD_POLICY
--------------------------------------------------------   
   CREATE TABLE "TBL_PASSWORD_POLICY" 
   (	"TENANT_ID" NUMBER NOT NULL, 
	"COMPANY_ID" NVARCHAR2(100) NOT NULL, 
	"ENG_CHAR_TYPE" NVARCHAR2(10) DEFAULT 'N', 
	"USE_ENG_CAPITAL_LETTER" NVARCHAR2(10) DEFAULT 'N', 
	"USE_ENG_SMALL_LETTER" NVARCHAR2(10) DEFAULT 'N', 
	"USE_NUMBER" NVARCHAR2(10) DEFAULT 'N', 
	"USE_SPECIAL_CHAR" NVARCHAR2(10) DEFAULT 'N'
   ) ;
   
--------------------------------------------------------
--  DDL for Table TBL_PASSWORD_POLICY_PATTERN
--------------------------------------------------------   
   CREATE TABLE "TBL_PASSWORD_POLICY_PATTERN" 
   (	"TENANT_ID" NUMBER NOT NULL, 
	"COMPANY_ID" NVARCHAR2(100) NOT NULL, 
	"USE_PATTERN_COUNT" NUMBER(*,0) NOT NULL, 
	"NUMBER_OF_CHAR" NUMBER(*,0) NOT NULL
  ) ;
   
 --------------------------------------------------------
--  DDL for Table TBL_GOVSENDDOCHISTORY
--------------------------------------------------------  
CREATE TABLE "TBL_GOVSENDDOCHISTORY" 
   (	"SN" NUMBER(11,0), 
	"SENDDATE" DATE, 
	"SENDFLAG" CHAR(2 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table TBL_PERMISSIONGROUPINFO
--------------------------------------------------------

  CREATE TABLE "TBL_PERMISSIONGROUPINFO" 
   (	"GROUP_ID" VARCHAR2(80 BYTE), 
	"MEMBER_ID" VARCHAR2(80 BYTE), 
	"MEMBER_TYPE" VARCHAR2(10 BYTE), 
	"MEMBER_COMPANYID" VARCHAR2(80 BYTE) DEFAULT NULL, 
	"ADDED_DATE" DATE, 
	"SUB_DEPT_YN" NVARCHAR2(10), 
	"COMPANY_ID" VARCHAR2(80 BYTE), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_PERMISSIONGROUPLIST
--------------------------------------------------------

  CREATE TABLE "TBL_PERMISSIONGROUPLIST" 
   (	"GROUP_ID" VARCHAR2(80 BYTE), 
	"GROUP_NAME" NVARCHAR2(100), 
	"CREATE_ID" VARCHAR2(80 BYTE), 
	"CREATE_DATE" DATE, 
	"UPDATE_ID" VARCHAR2(80 BYTE) DEFAULT NULL, 
	"UPDATE_DATE" DATE DEFAULT NULL, 
	"COMPANY_ID" VARCHAR2(80 BYTE), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_PHOTO_IMAGEITEM
--------------------------------------------------------

  CREATE TABLE "TBL_PHOTO_IMAGEITEM" 
   (	"IMAGEID" NCHAR(41), 
	"ITEMID" NCHAR(38), 
	"BOARDID" NCHAR(38), 
	"WRITERID" NVARCHAR2(20), 
	"WRITERNAME" NVARCHAR2(20), 
	"WRITERDEPTID" NVARCHAR2(20), 
	"FILEPATH" NVARCHAR2(200), 
	"WRITEDATE" NVARCHAR2(20), 
	"FILECONTENT" NCLOB, 
	"IMAGENAME" VARCHAR2(200 CHAR), 
	"MAIN_FLAG" CHAR(1 CHAR), 
	"TENANT_ID" NUMBER(5,0) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_POLL_ANSWER
--------------------------------------------------------

  CREATE TABLE "TBL_POLL_ANSWER" 
   (	"BRD_ID" NUMBER(10,0), 
	"ITEM_NO" NUMBER(10,0), 
	"QUESTION_NO" NUMBER(10,0), 
	"ANSWERNO" NUMBER(10,0), 
	"ANSWERCONTENT" NVARCHAR2(1000), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_POLL_ATTACH
--------------------------------------------------------

  CREATE TABLE "TBL_POLL_ATTACH" 
   (	"BRD_ID" NUMBER(10,0), 
	"ITEM_NO" NUMBER(10,0), 
	"QUESTION_NO" NUMBER(10,0), 
	"ANSWERNO" NUMBER(10,0), 
	"ATTACHNO" NUMBER(10,0), 
	"ATTACHNAME" NVARCHAR2(100), 
	"ATTACHURL" NVARCHAR2(500), 
	"ATTACHTYPE" NCHAR(1), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_POLL_ITEM
--------------------------------------------------------

  CREATE TABLE "TBL_POLL_ITEM" 
   (	"BRD_ID" NUMBER(10,0), 
	"ITEM_NO" NUMBER(10,0), 
	"USER_ID" NVARCHAR2(20), 
	"USER_NM" NVARCHAR2(100), 
	"USER_NM2" NVARCHAR2(100), 
	"USER_EMAIL" NVARCHAR2(255), 
	"USER_DEPTID" NVARCHAR2(20), 
	"USER_DEPTNM" NVARCHAR2(100), 
	"TITLE" NVARCHAR2(255), 
	"CONTENT" NVARCHAR2(255), 
	"POST_DATE" DATE, 
	"UPDATE_DATE" NCHAR(19), 
	"END_DATE" NCHAR(19), 
	"POST_TERM" NUMBER(10,0), 
	"ITEM_REF" NUMBER(10,0), 
	"ITEM_LEVEL" NUMBER(10,0), 
	"ITEM_STEP" NUMBER(10,0), 
	"ITEM_IMP" NCHAR(1) DEFAULT TO_NCHAR((2)), 
	"HASATTACH" NUMBER(1,0) DEFAULT (0), 
	"SRCUSER_ID" NVARCHAR2(20), 
	"SRCUSER_NM" NVARCHAR2(100), 
	"SRCUSER_EMAIL" NCHAR(255), 
	"ITEM_GB" NCHAR(1) DEFAULT TO_NCHAR((1)), 
	"READ_CNT" NUMBER(18,0) DEFAULT (0), 
	"POLL_STARTDATE" NVARCHAR2(19), 
	"POLL_ENDDATE" NVARCHAR2(19), 
	"RES_CNT" NUMBER(18,0) DEFAULT (0), 
	"COMPLETE_FLAG" NCHAR(1) DEFAULT TO_NCHAR('N'), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" NVARCHAR2(80)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_POLL_ITEMACL
--------------------------------------------------------

  CREATE TABLE "TBL_POLL_ITEMACL" 
   (	"BRD_ID" NUMBER(10,0), 
	"ITEM_NO" NUMBER(10,0), 
	"GUBUN" NCHAR(1), 
	"GUBUN_ID" NVARCHAR2(50), 
	"GUBUN_NM" NVARCHAR2(100), 
	"GUBUN_NM2" NVARCHAR2(100), 
	"CONDITION" NVARCHAR2(3), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_POLL_ITEMREAD
--------------------------------------------------------

  CREATE TABLE "TBL_POLL_ITEMREAD" 
   (	"BRD_ID" NUMBER(10,0), 
	"ITEM_NO" NUMBER(10,0), 
	"USER_ID" NVARCHAR2(20), 
	"READ_DATE" NCHAR(50), 
	"USER_NM" NVARCHAR2(255), 
	"USER_NM2" NVARCHAR2(255), 
	"USER_DEPTID" NVARCHAR2(50), 
	"USER_DEPTNM" NVARCHAR2(255), 
	"USER_DEPTNM2" NVARCHAR2(255), 
	"USER_POSNM" NVARCHAR2(255), 
	"USER_POSNM2" NVARCHAR2(255), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_POLL_PERMISSION
--------------------------------------------------------

  CREATE TABLE "TBL_POLL_PERMISSION" 
   (	"BRD_ID" NUMBER(10,0), 
	"ITEM_NO" NUMBER(10,0), 
	"PUBLIC_FLG" NCHAR(1), 
	"PUBLIC_RESULT_FLG" NCHAR(1), 
	"MULTI_RESPONSE_FLG" NCHAR(1), 
	"END_FLG" NCHAR(1) DEFAULT TO_NCHAR((0)), 
	"RESPONSE_RANGE" NCHAR(1) DEFAULT TO_NCHAR((0)), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_POLL_QUESTION
--------------------------------------------------------

  CREATE TABLE "TBL_POLL_QUESTION" 
   (	"BRD_ID" NUMBER(10,0), 
	"ITEM_NO" NUMBER(10,0), 
	"QUESTION_NO" NUMBER(10,0), 
	"QUESCONTENT" NVARCHAR2(1000), 
	"ANSWERTYPE" NUMBER(10,0) DEFAULT (1), 
	"ANSWERVIEWTYPE" NUMBER(10,0), 
	"MULTISELECT" NCHAR(1) DEFAULT TO_NCHAR((0)), 
	"QUES_SN" NUMBER(10,0), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_POLL_RESPONSE
--------------------------------------------------------

  CREATE TABLE "TBL_POLL_RESPONSE" 
   (	"BRD_ID" NUMBER(10,0), 
	"ITEM_NO" NUMBER(10,0), 
	"QUESTION_NO" NUMBER(10,0), 
	"RESPONSENO" NUMBER(10,0), 
	"ANSWER_OBJECTIVITY" NUMBER(10,0), 
	"ANSWER_SUBJECTIVITY" NCLOB, 
	"ANSWER_VIEWSELECT" NUMBER(10,0), 
	"RESPONSEUSER_ID" NVARCHAR2(20), 
	"RESPONSEUSER_NAME" NVARCHAR2(50), 
	"RESPONSEUSER_NAME2" NVARCHAR2(50), 
	"RESPONSEUSER_EMAIL" NVARCHAR2(100), 
	"RESPONSEUSER_DEPT_ID" NVARCHAR2(100), 
	"RESPONSEUSER_DEPT_NAME" NVARCHAR2(100), 
	"RESPONSEUSER_DEPT_NAME2" NVARCHAR2(100), 
	"RESPONSEUSER_POSITION" NVARCHAR2(100), 
	"RESPONSEUSER_POSITION2" NVARCHAR2(100), 
	"RESPONSEUSER_JIKGUB" NVARCHAR2(100), 
	"RESPONSEUSER_JIKGUB2" NVARCHAR2(100), 
	"RESPONSEUSER_GENDER" NCHAR(1), 
	"RESPONSEUSER_AGE" NUMBER(10,0), 
	"RESPONSE_DATE" DATE, 
	"RESPONSEUSER_IP" NCHAR(20), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_POLL_RESPONSEPERSON
--------------------------------------------------------

  CREATE TABLE "TBL_POLL_RESPONSEPERSON" 
   (	"BRD_ID" NUMBER(10,0), 
	"ITEM_NO" NUMBER(10,0), 
	"USER_ID" NVARCHAR2(20), 
	"RESPONSE_DATE" NVARCHAR2(19), 
	"USER_NM" NVARCHAR2(100), 
	"USER_NM2" NVARCHAR2(100), 
	"USER_EMAIL" NVARCHAR2(100), 
	"USER_DEPT_ID" NVARCHAR2(100), 
	"USER_DEPT_NM" NVARCHAR2(100), 
	"USER_DEPT_NM2" NVARCHAR2(100), 
	"USER_POS" NVARCHAR2(100), 
	"USER_POS2" NVARCHAR2(100), 
	"USER_JIKGUB" NVARCHAR2(100), 
	"USER_JIKGUB2" NVARCHAR2(100), 
	"USER_GENDER" NCHAR(1), 
	"USER_AGE" NUMBER(10,0), 
	"GROUPID" NCHAR(5), 
	"GROUPNAME" NVARCHAR2(40), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_POLL_TABLE_ANSWER
--------------------------------------------------------

  CREATE TABLE "TBL_POLL_TABLE_ANSWER" 
   (	"BRD_ID" NUMBER(10,0), 
	"ITEM_NO" NUMBER(10,0), 
	"QUESTION_NO" NUMBER(10,0), 
	"ANSWERNO" NUMBER(10,0), 
	"ANSWER_ANSWERCONTENT" NVARCHAR2(1000), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_PORTAL_FRAME
--------------------------------------------------------

  CREATE TABLE "TBL_PORTAL_FRAME" 
   (	"FRAME_ID" NUMBER(10,0), 
	"FRAME_NAME" VARCHAR2(100 BYTE), 
	"THEME_ID" NUMBER(10,0)
   ) ;

   COMMENT ON COLUMN "TBL_PORTAL_FRAME"."FRAME_ID" IS '프레임아이디';
   COMMENT ON COLUMN "TBL_PORTAL_FRAME"."FRAME_NAME" IS '프레임 이름';
   COMMENT ON COLUMN "TBL_PORTAL_FRAME"."THEME_ID" IS '프레임이 속한 테마 아이디';
   COMMENT ON TABLE "TBL_PORTAL_FRAME"  IS '프레임 정보 테이블';
--------------------------------------------------------
--  DDL for Table TBL_PORTAL_FRAME_COMP
--------------------------------------------------------

  CREATE TABLE "TBL_PORTAL_FRAME_COMP" 
   (	"COMPANY_ID" VARCHAR2(100 BYTE), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"THEME_ID" NUMBER(10,0) DEFAULT 0, 
	"FRAME_ID" NUMBER(10,0) DEFAULT 0, 
	"FRAME_USED" NUMBER(5,0) DEFAULT 0, 
	"FRAME_DEFAULT" NUMBER(5,0) DEFAULT 0
   ) ;

   COMMENT ON COLUMN "TBL_PORTAL_FRAME_COMP"."COMPANY_ID" IS '회사 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_FRAME_COMP"."TENANT_ID" IS '테넌트 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_FRAME_COMP"."THEME_ID" IS '테마 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_FRAME_COMP"."FRAME_ID" IS '프레임 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_FRAME_COMP"."FRAME_USED" IS '활성화(Y), 비활성화(N)';
   COMMENT ON COLUMN "TBL_PORTAL_FRAME_COMP"."FRAME_DEFAULT" IS '기본(Y), 기본아님(N)';
   COMMENT ON TABLE "TBL_PORTAL_FRAME_COMP"  IS '회사별 프레임 설정 테이블';
--------------------------------------------------------
--  DDL for Table TBL_PORTAL_LOGO
--------------------------------------------------------

  CREATE TABLE "TBL_PORTAL_LOGO" 
   (	"COMPANY_ID" VARCHAR2(100 BYTE), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"LOGO_TYPE" VARCHAR2(5 BYTE), 
	"LOGO_URL" VARCHAR2(200 BYTE)
   ) ;

   COMMENT ON COLUMN "TBL_PORTAL_LOGO"."COMPANY_ID" IS '회사 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_LOGO"."TENANT_ID" IS '테넌트 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_LOGO"."LOGO_TYPE" IS '대표이미지(R), 로그인(L), 포탈 내부(P)';
   COMMENT ON COLUMN "TBL_PORTAL_LOGO"."LOGO_URL" IS '로고 이미지 경로';
   COMMENT ON TABLE "TBL_PORTAL_LOGO"  IS '회사별 로고관리 테이블';
--------------------------------------------------------
--  DDL for Table TBL_PORTAL_MENU
--------------------------------------------------------

  CREATE TABLE "TBL_PORTAL_MENU" 
   (	"MENU_ID" NUMBER(10,0), 
	"MENU_URL" VARCHAR2(100 BYTE), 
	"MENU_TYPE" VARCHAR2(5 BYTE) DEFAULT 'G', 
	"ICON_URL" VARCHAR2(200 BYTE), 
	"DEFAULT_ORDER" NUMBER(5,0), 
	"MENUCODE" VARCHAR2(100 BYTE) DEFAULT NULL
   ) ;

   COMMENT ON COLUMN "TBL_PORTAL_MENU"."MENU_ID" IS '메뉴 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_MENU"."MENU_URL" IS '메뉴 연동 URL';
   COMMENT ON COLUMN "TBL_PORTAL_MENU"."MENU_TYPE" IS '기본(G), 추가(A)';
   COMMENT ON COLUMN "TBL_PORTAL_MENU"."ICON_URL" IS '메뉴 아이콘 이미지 경로';
   COMMENT ON COLUMN "TBL_PORTAL_MENU"."DEFAULT_ORDER" IS '제공된 메뉴의 기본 순서';
   COMMENT ON TABLE "TBL_PORTAL_MENU"  IS '메뉴 정보 테이블';
--------------------------------------------------------
--  DDL for Table TBL_PORTAL_MENU_AUTH
--------------------------------------------------------

  CREATE TABLE "TBL_PORTAL_MENU_AUTH" 
   (	"MENU_ID" NUMBER(10,0), 
	"COMPANY_ID" VARCHAR2(100 BYTE), 
	"TENANT_ID" NUMBER(5,0), 
	"USER_ID" VARCHAR2(100 BYTE), 
	"ACCESS_YN" NUMBER(5,0) DEFAULT 0, 
	"USER_TYPE" NUMBER(5,0), 
	"SN" NUMBER(*,0) DEFAULT 0,
	"SUBDEPT_PERMITTED" VARCHAR2(4 BYTE) DEFAULT 'Y'
   ) ;

   COMMENT ON COLUMN "TBL_PORTAL_MENU_AUTH"."MENU_ID" IS '메뉴 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_MENU_AUTH"."COMPANY_ID" IS '회사 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_MENU_AUTH"."TENANT_ID" IS '테넌트 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_MENU_AUTH"."USER_ID" IS '사용자/부서 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_MENU_AUTH"."ACCESS_YN" IS '접근 가능(Y), 접근 불가(N)';
   COMMENT ON COLUMN "TBL_PORTAL_MENU_AUTH"."USER_TYPE" IS '사용자(U), 부서(D)';
   COMMENT ON TABLE "TBL_PORTAL_MENU_AUTH"  IS '메뉴권한 설정 테이블';
--------------------------------------------------------
--  DDL for Table TBL_PORTAL_MENU_COMP
--------------------------------------------------------

  CREATE TABLE "TBL_PORTAL_MENU_COMP" 
   (	"COMPANY_ID" VARCHAR2(100 BYTE), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"MENU_ID" NUMBER(10,0) DEFAULT 0, 
	"MENU_USED" NUMBER(5,0) DEFAULT 0, 
	"COMPANY_LANG" VARCHAR2(50 BYTE), 
	"COMPANY_ORDER" NUMBER(5,0),
    "ICON_URL" VARCHAR2(200 BYTE)
  ) ;

   COMMENT ON COLUMN "TBL_PORTAL_MENU_COMP"."COMPANY_ID" IS '회사 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_MENU_COMP"."TENANT_ID" IS '테넌트 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_MENU_COMP"."MENU_ID" IS '메뉴 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_MENU_COMP"."MENU_USED" IS '활성화(Y), 비활성화(N)';
   COMMENT ON COLUMN "TBL_PORTAL_MENU_COMP"."ICON_URL" IS '회사별 기본 아이콘 변경';
   COMMENT ON TABLE "TBL_PORTAL_MENU_COMP"  IS '회사별 메뉴 설정 테이블';
--------------------------------------------------------
--  DDL for Table TBL_PORTAL_MENU_NAME
--------------------------------------------------------

  CREATE TABLE "TBL_PORTAL_MENU_NAME" 
   (	"MENU_ID" NUMBER(10,0) DEFAULT 0, 
	"MENU_LANG" VARCHAR2(45 BYTE), 
	"COMPANY_ID" VARCHAR2(100 BYTE), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"MENU_NAME" VARCHAR2(100 BYTE)
   ) ;

   COMMENT ON COLUMN "TBL_PORTAL_MENU_NAME"."MENU_ID" IS '메뉴 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_MENU_NAME"."MENU_LANG" IS '메뉴 이름의 언어';
   COMMENT ON COLUMN "TBL_PORTAL_MENU_NAME"."COMPANY_ID" IS '회사 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_MENU_NAME"."TENANT_ID" IS '테넌트 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_MENU_NAME"."MENU_NAME" IS '메뉴 이름(언어별)';
   COMMENT ON TABLE "TBL_PORTAL_MENU_NAME"  IS '메뉴 이름 테이블';
--------------------------------------------------------
--  DDL for Table TBL_PORTAL_MENU_USER
--------------------------------------------------------

  CREATE TABLE "TBL_PORTAL_MENU_USER" 
   (	"USER_ID" VARCHAR2(100 BYTE), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANY_ID" VARCHAR2(100 BYTE), 
	"MENU_ID" NUMBER(10,0), 
	"MENU_ORDER" NUMBER(5,0)
   ) ;

   COMMENT ON COLUMN "TBL_PORTAL_MENU_USER"."USER_ID" IS '사용자 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_MENU_USER"."TENANT_ID" IS '테넌트 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_MENU_USER"."COMPANY_ID" IS '회사 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_MENU_USER"."MENU_ID" IS '메뉴 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_MENU_USER"."MENU_ORDER" IS '메뉴 순서';
   COMMENT ON TABLE "TBL_PORTAL_MENU_USER"  IS '개인별 메뉴 순서 설정 테이블';
--------------------------------------------------------
--  DDL for Table TBL_PORTAL_PORTLET
--------------------------------------------------------

  CREATE TABLE "TBL_PORTAL_PORTLET" 
   (	"PORTLET_ID" NUMBER(10,0), 
	"MENU_ID" NUMBER(10,0), 
	"PORTLET_URL" VARCHAR2(200 BYTE), 
	"PORTLET_TYPE" VARCHAR2(5 BYTE) DEFAULT 'G', 
	"DEFAULT_ORDER" NUMBER(5,0), 
	"PORTLETCODE" VARCHAR2(100 BYTE) DEFAULT NULL
   ) ;

   COMMENT ON COLUMN "TBL_PORTAL_PORTLET"."PORTLET_ID" IS '포틀릿 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_PORTLET"."MENU_ID" IS '포틀릿에 연결된 메뉴 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_PORTLET"."PORTLET_URL" IS '포틀릿 연결 URL';
   COMMENT ON COLUMN "TBL_PORTAL_PORTLET"."PORTLET_TYPE" IS '기본(G), 추가(A)';
   COMMENT ON COLUMN "TBL_PORTAL_PORTLET"."DEFAULT_ORDER" IS '제공된 포틀릿 기본 순서';
   COMMENT ON TABLE "TBL_PORTAL_PORTLET"  IS '포틀릿 정보 테이블';
--------------------------------------------------------
--  DDL for Table TBL_PORTAL_PORTLET_AUTH
--------------------------------------------------------

  CREATE TABLE "TBL_PORTAL_PORTLET_AUTH" 
   (	"PORTLET_ID" NUMBER(10,0), 
	"COMPANY_ID" VARCHAR2(100 BYTE), 
	"TENANT_ID" NUMBER(5,0), 
	"USER_ID" VARCHAR2(100 BYTE), 
	"ACCESS_YN" NUMBER(5,0) DEFAULT 0, 
	"USER_TYPE" NUMBER(5,0), 
	"SN" NUMBER(*,0) DEFAULT 0,
    "SUBDEPT_PERMITTED" VARCHAR2(4 BYTE) DEFAULT 'Y'
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_PORTAL_PORTLET_COMP
--------------------------------------------------------

  CREATE TABLE "TBL_PORTAL_PORTLET_COMP" 
   (	"COMPANY_ID" VARCHAR2(100 BYTE), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"PORTLET_ID" NUMBER(10,0), 
	"MENU_ID" NUMBER(10,0), 
	"PORTLET_CATEGORY" VARCHAR2(5 BYTE), 
	"CONNECTION_URL" VARCHAR2(200 BYTE),
	"PORTLET_USED" NUMBER(5,0) DEFAULT 0, 
	"PORTLET_ORDER" NUMBER(5,0), 
	"BOARD_ID" VARCHAR2(200 BYTE)
   ) ;

   COMMENT ON COLUMN "TBL_PORTAL_PORTLET_COMP"."COMPANY_ID" IS '회사 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_PORTLET_COMP"."TENANT_ID" IS '테넌트 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_PORTLET_COMP"."PORTLET_ID" IS '포틀릿 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_PORTLET_COMP"."MENU_ID" IS '메뉴 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_PORTLET_COMP"."PORTLET_CATEGORY" IS '게시판(B), 메일(M), 결재(A), 외부링크(L)';
   COMMENT ON COLUMN "TBL_PORTAL_PORTLET_COMP"."CONNECTION_URL" IS '타입별 모듈 아이디 / URL';
   COMMENT ON COLUMN "TBL_PORTAL_PORTLET_COMP"."PORTLET_USED" IS '포틀릿 보임(Y)/숨김(N)';
   COMMENT ON COLUMN "TBL_PORTAL_PORTLET_COMP"."PORTLET_ORDER" IS '포틀릿 순서';
   COMMENT ON TABLE "TBL_PORTAL_PORTLET_COMP"  IS '회사별 포틀릿 설정 테이블';
--------------------------------------------------------
--  DDL for Table TBL_PORTAL_PORTLET_NAME
--------------------------------------------------------

  CREATE TABLE "TBL_PORTAL_PORTLET_NAME" 
   (	"PORTLET_ID" NUMBER(10,0) DEFAULT 0, 
	"MENU_ID" NUMBER(10,0) DEFAULT 0, 
	"PORTLET_LANG" VARCHAR2(100 BYTE), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANY_ID" VARCHAR2(100 BYTE), 
	"PORTLET_NAME" VARCHAR2(100 BYTE)
   ) ;

   COMMENT ON COLUMN "TBL_PORTAL_PORTLET_NAME"."PORTLET_ID" IS '포틀릿 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_PORTLET_NAME"."MENU_ID" IS '메뉴 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_PORTLET_NAME"."PORTLET_LANG" IS '이름의 언어';
   COMMENT ON COLUMN "TBL_PORTAL_PORTLET_NAME"."TENANT_ID" IS '테넌트 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_PORTLET_NAME"."COMPANY_ID" IS '회사 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_PORTLET_NAME"."PORTLET_NAME" IS '포틀릿 이름(언어별)';
   COMMENT ON TABLE "TBL_PORTAL_PORTLET_NAME"  IS '포틀릿 이름 테이블';
--------------------------------------------------------
--  DDL for Table TBL_PORTAL_PORTLET_USER
--------------------------------------------------------

  CREATE TABLE "TBL_PORTAL_PORTLET_USER" 
   (	"USER_ID" VARCHAR2(100 BYTE), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANY_ID" VARCHAR2(100 BYTE), 
	"PORTLET_ID" NUMBER(10,0), 
	"PORTLET_ORDER" NUMBER(5,0), 
	"MENU_ID" NUMBER(10,0), 
	"PORTLET_USED" NUMBER(5,0) DEFAULT 1, 
	"THEME_ID" NUMBER(10,0) DEFAULT 1
   ) ;

   COMMENT ON COLUMN "TBL_PORTAL_PORTLET_USER"."USER_ID" IS '사용자 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_PORTLET_USER"."TENANT_ID" IS '테넌트 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_PORTLET_USER"."COMPANY_ID" IS '회사 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_PORTLET_USER"."PORTLET_ID" IS '포틀릿 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_PORTLET_USER"."PORTLET_ORDER" IS '포틀릿 순서';
   COMMENT ON COLUMN "TBL_PORTAL_PORTLET_USER"."MENU_ID" IS '포틀릿과 연관된 메뉴 아이디';
   COMMENT ON TABLE "TBL_PORTAL_PORTLET_USER"  IS '사용자별 포틀릿 순서 설정 테이블';
--------------------------------------------------------
--  DDL for Table TBL_PORTAL_STARTPAGE
--------------------------------------------------------

  CREATE TABLE "TBL_PORTAL_STARTPAGE" 
   (	"USER_ID" VARCHAR2(100 BYTE), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANY_ID" VARCHAR2(100 BYTE), 
	"MENU_ID" NUMBER(10,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_PORTAL_THEME
--------------------------------------------------------

  CREATE TABLE "TBL_PORTAL_THEME" 
   (	"THEME_ID" NUMBER(10,0), 
	"THEME_NAME" VARCHAR2(100 BYTE), 
	"THEME_CONTENT" VARCHAR2(400 BYTE), 
	"THEME_CONTENT2" VARCHAR2(400 BYTE) DEFAULT 'theme content', 
	"THEME_CONTENT3" VARCHAR2(400 BYTE) DEFAULT 'theme content', 
	"THEME_CONTENT4" VARCHAR2(400 BYTE) DEFAULT 'theme content',
	"THEME_CONTENT5" VARCHAR2(400 BYTE) DEFAULT 'theme content',
	"THEME_CONTENT6" VARCHAR2(400 BYTE) DEFAULT 'theme content',
	"THEME_NAME2" VARCHAR2(100 BYTE) DEFAULT 'theme content',
	"THEME_NAME3" VARCHAR2(100 BYTE) DEFAULT 'theme3'
   ) ;

   COMMENT ON COLUMN "TBL_PORTAL_THEME"."THEME_ID" IS '테마아이디';
   COMMENT ON COLUMN "TBL_PORTAL_THEME"."THEME_NAME" IS '테마 이름';
   COMMENT ON COLUMN "TBL_PORTAL_THEME"."THEME_CONTENT" IS '테마 설명(내용)';
   COMMENT ON TABLE "TBL_PORTAL_THEME"  IS '테마 정보 테이블';
--------------------------------------------------------
--  DDL for Table TBL_PORTAL_THEME_AUTH
--------------------------------------------------------

  CREATE TABLE "TBL_PORTAL_THEME_AUTH" 
   (	"THEME_ID" NUMBER(10,0) DEFAULT 0, 
	"COMPANY_ID" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"USER_ID" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"ACCESS_YN" NUMBER(5,0) DEFAULT 0, 
	"USER_TYPE" NUMBER(5,0) DEFAULT 0, 
	"SN" NUMBER(*,0) DEFAULT 0,
    "SUBDEPT_PERMITTED" VARCHAR2(4 BYTE) DEFAULT 'Y'
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_PORTAL_THEME_COMP
--------------------------------------------------------

  CREATE TABLE "TBL_PORTAL_THEME_COMP" 
   (	"COMPANY_ID" VARCHAR2(100 BYTE), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"THEME_ID" NUMBER(10,0) DEFAULT 0, 
	"THEME_USED" NUMBER(5,0) DEFAULT 0, 
	"THEME_DEFAULT" NUMBER(5,0) DEFAULT 0
   ) ;

   COMMENT ON COLUMN "TBL_PORTAL_THEME_COMP"."COMPANY_ID" IS '회사 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_THEME_COMP"."TENANT_ID" IS '테넌트 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_THEME_COMP"."THEME_ID" IS '테마 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_THEME_COMP"."THEME_USED" IS '활성화(Y), 비활성화(N)';
   COMMENT ON COLUMN "TBL_PORTAL_THEME_COMP"."THEME_DEFAULT" IS '기본(Y), 기본아님(N)';
   COMMENT ON TABLE "TBL_PORTAL_THEME_COMP"  IS '회사별 테마 설정 테이블';
--------------------------------------------------------
--  DDL for Table TBL_PORTAL_THEME_PORTLET
--------------------------------------------------------

  CREATE TABLE "TBL_PORTAL_THEME_PORTLET" 
   (	"THEME_ID" NUMBER(11,0), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANY_ID" VARCHAR2(100 BYTE), 
	"PORTLET_ID" NUMBER(10,0), 
	"PORTLET_USED" NUMBER(5,0), 
	"PORTLET_ORDER" NUMBER(11,0), 
	"MENU_ID" NUMBER(10,0), 
	"IS_FIXED" NUMBER(5,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_PORTAL_THEME_USER
--------------------------------------------------------

  CREATE TABLE "TBL_PORTAL_THEME_USER" 
   (	"USER_ID" VARCHAR2(100 BYTE), 
	"COMPANY_ID" VARCHAR2(100 BYTE), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"USED_THEME" NUMBER(10,0), 
	"USED_FRAME" NUMBER(10,0), 
	"IS_DEFAULT" NUMBER(5,0) DEFAULT 0
   ) ;

   COMMENT ON COLUMN "TBL_PORTAL_THEME_USER"."USER_ID" IS '사용자 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_THEME_USER"."COMPANY_ID" IS '회사 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_THEME_USER"."TENANT_ID" IS '테넌트 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_THEME_USER"."USED_THEME" IS '사용자가 사용하는 테마 아이디';
   COMMENT ON COLUMN "TBL_PORTAL_THEME_USER"."USED_FRAME" IS '사용자가 사용하는 프레임 아이디';
--------------------------------------------------------
--  DDL for Table TBL_PREVIOSLYREGI
--------------------------------------------------------

  CREATE TABLE "TBL_PREVIOSLYREGI" 
   (	"USECOMPANY" VARCHAR2(20 BYTE), 
	"PREVIOSLYREGIUSE" NUMBER, 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_PROXYINFO
--------------------------------------------------------

  CREATE TABLE "TBL_PROXYINFO" 
   (	"USERID" NVARCHAR2(40), 
	"PROXYUSERID" NVARCHAR2(40), 
	"PROXYUSERNAME" NVARCHAR2(100), 
	"PROXYUSERDEPTID" NVARCHAR2(200), 
	"STARTDATE" DATE, 
	"ENDDATE" DATE, 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_PS_APPROVNOTIMAILCONF
--------------------------------------------------------

  CREATE TABLE "TBL_PS_APPROVNOTIMAILCONF" 
   (	"USERID" NVARCHAR2(20), 
	"ALERT" CHAR(1 CHAR), 
	"COMPLETE" CHAR(1 CHAR), 
	"BANSONG" CHAR(1 CHAR), 
	"CALLBACK" CHAR(1 CHAR), 
	"HESONG" CHAR(1 CHAR), 
	"SAVEMAILFLAG" CHAR(1 CHAR), 
	"TENANT_ID" NUMBER(5,0),
	"LINEPASS" NVARCHAR2(2) DEFAULT '0'
   ) ;

   COMMENT ON COLUMN "TBL_PS_APPROVNOTIMAILCONF"."ALERT" IS '결재 도착 알림 메일 사용여부';
   COMMENT ON COLUMN "TBL_PS_APPROVNOTIMAILCONF"."COMPLETE" IS '결재 완료 알림 메일 사용여부';
   COMMENT ON COLUMN "TBL_PS_APPROVNOTIMAILCONF"."BANSONG" IS '결재 반송 알림 메일 사용여부';
   COMMENT ON COLUMN "TBL_PS_APPROVNOTIMAILCONF"."CALLBACK" IS '결재 회수 알림 메일 사용여부';
   COMMENT ON COLUMN "TBL_PS_APPROVNOTIMAILCONF"."HESONG" IS '결재 회송 알림 메일 사용여부';
   COMMENT ON COLUMN "TBL_PS_APPROVNOTIMAILCONF"."SAVEMAILFLAG" IS '보낸편지함 저장 여부';
--------------------------------------------------------
--  DDL for Table TBL_PS_EMPMONTH
--------------------------------------------------------

  CREATE TABLE "TBL_PS_EMPMONTH" 
   (	"CN" VARCHAR2(20 CHAR), 
	"DISPLAYNAME" NVARCHAR2(60), 
	"DISPLAYNAME2" NVARCHAR2(60), 
	"DEPARTMENT" VARCHAR2(20 CHAR), 
	"DESCRIPTION" NVARCHAR2(100), 
	"DESCRIPTION2" NVARCHAR2(100), 
	"PHYSICALDELIVERYOFFICENAME" VARCHAR2(40 CHAR), 
	"COMPANY" NVARCHAR2(100), 
	"COMPANY2" NVARCHAR2(100), 
	"TITLE" NVARCHAR2(100), 
	"TITLE2" NVARCHAR2(100), 
	"FILEPATH" NVARCHAR2(500), 
	"TERM" NVARCHAR2(10), 
	"DATE_" DATE, 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_PS_LIGHTPOLL
--------------------------------------------------------

  CREATE TABLE "TBL_PS_LIGHTPOLL" 
   (	"ITEMSEQ" NUMBER(10,0), 
	"COMPANYID" NVARCHAR2(20), 
	"STARTDATE" DATE, 
	"ENDDATE" DATE, 
	"POLLSELECTIONCOUNT" NUMBER(10,0), 
	"POLLTITLE" NVARCHAR2(500), 
	"POLLTITLE2" NVARCHAR2(500), 
	"ANSWER1" NVARCHAR2(100), 
	"ANSWER2" NVARCHAR2(100), 
	"ANSWER3" NVARCHAR2(100), 
	"ANSWER4" NVARCHAR2(100), 
	"ANSWER5" NVARCHAR2(100), 
	"ANSWER6" NVARCHAR2(100), 
	"ANSWER7" NVARCHAR2(100), 
	"ANSWER8" NVARCHAR2(100), 
	"ANSWER9" NVARCHAR2(100), 
	"ANSWER10" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_PS_LIGHTPOLLRESULT
--------------------------------------------------------

  CREATE TABLE "TBL_PS_LIGHTPOLLRESULT" 
   (	"ITEMSEQ" NVARCHAR2(5), 
	"USERID" NVARCHAR2(50), 
	"RESULT" NUMBER(10,0), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_PS_LIGHTPOLL_OPTION
--------------------------------------------------------

  CREATE TABLE "TBL_PS_LIGHTPOLL_OPTION" 
   (	"LIGHTPOLLOPTIONID" NUMBER(10,0), 
	"USERID" VARCHAR2(100 BYTE), 
	"ISPREVIEW" NUMBER(5,0) DEFAULT 0, 
	"TENANTID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_PS_NOTICE
--------------------------------------------------------

  CREATE TABLE "TBL_PS_NOTICE" 
   (	"ITEMSEQ" NUMBER(10,0), 
	"COMPANYID" NVARCHAR2(20), 
	"POSTDATE" DATE, 
	"TITLE" NVARCHAR2(250), 
	"TITLE2" NVARCHAR2(250), 
	"CONTENT" NCLOB, 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_PS_POPUP
--------------------------------------------------------

  CREATE TABLE "TBL_PS_POPUP" 
   (	"COMPANYID" NVARCHAR2(10), 
	"ITEMSEQ" NUMBER(10,0), 
	"STARTDATE" DATE, 
	"ENDDATE" DATE, 
	"WIDTH" NUMBER(5,0), 
	"HEIGHT" NUMBER(5,0), 
	"TITLE" NVARCHAR2(250), 
	"TITLE2" NVARCHAR2(250), 
	"CONTENT" NCLOB, 
	"POSITION" NCHAR(10), 
	"TENANT_ID" NUMBER(5,0), 
	"INUSE" NUMBER(3,0) DEFAULT 1, 
	"SKINVALUE" NUMBER(3,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_PS_POPUP_OPTION
--------------------------------------------------------

  CREATE TABLE "TBL_PS_POPUP_OPTION" 
   (	"POPUPOPTIONID" NUMBER(10,0), 
	"USERID" VARCHAR2(100 BYTE), 
	"ISPREVIEW" NUMBER(5,0) DEFAULT 0, 
	"TENANTID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_PS_QUICKLINK
--------------------------------------------------------

  CREATE TABLE "TBL_PS_QUICKLINK" 
   (	"QUICKLINKID" NCHAR(38), 
	"QUICKLINKNAME" NVARCHAR2(50), 
	"QUICKLINKNAME2" NVARCHAR2(50), 
	"QUICKLINKNAME3" NVARCHAR2(50), 
	"QUICKLINKNAME4" NVARCHAR2(50), 
	"QUICKLINKNAME5" NVARCHAR2(50),
	"QUICKLINKNAME6" NVARCHAR2(50),
	"LINKTYPE" CHAR(1 CHAR),
	"LINKTYPEURL" NVARCHAR2(512), 
	"URL" NVARCHAR2(512), 
	"REGDATE" NVARCHAR2(100), 
	"MODIDATE" NVARCHAR2(100), 
	"REGUSERID" NVARCHAR2(20), 
	"SIZE_" NVARCHAR2(20), 
	"TENANT_ID" NUMBER(5,0), 
	"LINKORDER" NUMBER(11,0) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_PS_QUICKLINK_ACL
--------------------------------------------------------

  CREATE TABLE "TBL_PS_QUICKLINK_ACL" 
   (	"QUICKLINKID" NCHAR(38), 
	"ACCESSID" NVARCHAR2(50), 
	"ACCESSNAME" NVARCHAR2(50), 
	"ACCESSNAME2" NVARCHAR2(50), 
	"VIEW_FLAG" CHAR(1 CHAR), 
	"TENANT_ID" NUMBER(5,0),
	"USER_TYPE" NVARCHAR2(50) NOT NULL,
    "SUBDEPT_PERMITTED" CHAR(1 CHAR) DEFAULT 'N'
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_PS_SHAREAPPROVAL
--------------------------------------------------------

  CREATE TABLE "TBL_PS_SHAREAPPROVAL" 
   (	"OWNERID" NVARCHAR2(20), 
	"SHAREUSERID" NVARCHAR2(20), 
	"SHAREUSERNAME" NVARCHAR2(60), 
	"SHAREDATE" DATE, 
	"SHAREUSERTITLE" NVARCHAR2(100), 
	"SHAREUSERDEPTID" NVARCHAR2(40), 
	"SHAREUSERDEPTNAME" NVARCHAR2(100), 
	"TENANTID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_PS_SLIDERIMAGE
--------------------------------------------------------

  CREATE TABLE "TBL_PS_SLIDERIMAGE" 
   (	"SLIDERNAME" NVARCHAR2(50), 
	"SLIDERNAME2" NVARCHAR2(50), 
	"FILENAME" NCHAR(50), 
	"IMAGEPATH" NCHAR(512), 
	"REGUSERID" NVARCHAR2(20), 
	"REGDATE" NVARCHAR2(100), 
	"COMPANYID" NVARCHAR2(50), 
	"ISUSE" NUMBER(10,0), 
	"SN" NUMBER(10,0), 
	"TENANT_ID" NUMBER(5,0), 
	"URL" NVARCHAR2(1024), 
	"SLIDERID" NVARCHAR2(76)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_PS_USERWEBPART
--------------------------------------------------------

  CREATE TABLE "TBL_PS_USERWEBPART" 
   (	"USERID" NVARCHAR2(20), 
	"ITEMID" CHAR(36 CHAR), 
	"ITEMSEQ" NUMBER(10,0), 
	"ITEMPOSITION" NUMBER(10,0), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_PS_WEBPARTGROUP
--------------------------------------------------------

  CREATE TABLE "TBL_PS_WEBPARTGROUP" 
   (	"COMPANYID" NVARCHAR2(255), 
	"ID" NVARCHAR2(255), 
	"NAME" NVARCHAR2(255), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_PS_WEBPARTITEM
--------------------------------------------------------

  CREATE TABLE "TBL_PS_WEBPARTITEM" 
   (	"COMPANYID" NVARCHAR2(255), 
	"ID" NVARCHAR2(255), 
	"GROUPID" NVARCHAR2(255), 
	"NAME" NVARCHAR2(255), 
	"URL" NVARCHAR2(255), 
	"DEFAULTPRIORITY" FLOAT(126), 
	"DEFAULTPOSITION" FLOAT(126), 
	"DEFAULTUSE" FLOAT(126), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_PS_WEBPARTITEMACL
--------------------------------------------------------

  CREATE TABLE "TBL_PS_WEBPARTITEMACL" 
   (	"ITEMID" NVARCHAR2(255), 
	"ACCESSID" NVARCHAR2(255), 
	"ACCESSNAME" NVARCHAR2(255), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_PWDINFO
--------------------------------------------------------

  CREATE TABLE "TBL_PWDINFO" 
   (	"USERID" NVARCHAR2(50), 
	"FLAG" NCHAR(1), 
	"PWD" CHAR(684 CHAR), 
	"PWDTYPE" CHAR(1 CHAR), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_QS_BRDMNG
--------------------------------------------------------

  CREATE TABLE "TBL_QS_BRDMNG" 
   (	"BRD_ID" NUMBER(10,0), 
	"USER_ID" NVARCHAR2(20), 
	"MNG_GB" NCHAR(1), 
	"USER_NM" NVARCHAR2(255), 
	"ADMIN_FG" NUMBER(1,0), 
	"LST_FG" NCHAR(1), 
	"READ_FG" NUMBER(1,0), 
	"REPLY_FG" NUMBER(1,0), 
	"WRT_FG" NUMBER(1,0), 
	"VBL_FG" NUMBER(1,0), 
	"MNGER_FG" NUMBER(1,0), 
	"MNGER_MAIL_FG" NUMBER(1,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_QS_ITEMSEQ
--------------------------------------------------------

  CREATE TABLE "TBL_QS_ITEMSEQ" 
   (	"BRD_ID" NUMBER(10,0), 
	"ITEM_NO" NUMBER(10,0) DEFAULT (0), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_RECEIPTPOINTINFO
--------------------------------------------------------

  CREATE TABLE "TBL_RECEIPTPOINTINFO" 
   (	"DOCID" CHAR(20 CHAR), 
	"RECEIPTPOINTID" VARCHAR2(100 CHAR), 
	"RECEIPTPOINTNAME" NVARCHAR2(100), 
	"EXTRECEPTYN" CHAR(1 CHAR), 
	"PROCESSYN" CHAR(1 CHAR), 
	"PROCESSSN" NUMBER(10,0), 
	"CANEDITYN" CHAR(1 CHAR), 
	"EXTRECEPTEMAIL" VARCHAR2(100 CHAR), 
	"RECEIPTMEMBERID" VARCHAR2(100 CHAR), 
	"RECEIPTMEMBERNAME" NVARCHAR2(100), 
	"PROCESSDATE" DATE, 
	"RECEIPTMEMBERJOBTITLE" NVARCHAR2(100), 
	"DEPTMEMBERSN" NUMBER(10,0), 
	"RECEIPTPOINTNAME2" NVARCHAR2(100), 
	"RECEIPTMEMBERJOBTITLE2" NVARCHAR2(100), 
	"RECEIPTMEMBERNAME2" NVARCHAR2(100), 
	"ROUTEYN" CHAR(1 CHAR), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_RECEXCHINFO
--------------------------------------------------------

  CREATE TABLE "TBL_RECEXCHINFO" 
   (	"PACKDOCID" VARCHAR2(255 BYTE), 
	"ADMINISTRATIVE_NUM" VARCHAR2(255 BYTE), 
	"S_ID" VARCHAR2(30 BYTE), 
	"S_USERID" VARCHAR2(30 BYTE), 
	"S_ORGNAME" VARCHAR2(100 BYTE), 
	"S_SYSTEMNAME" VARCHAR2(100 BYTE), 
	"S_EMAIL" VARCHAR2(50 BYTE), 
	"R_ID" VARCHAR2(30 BYTE), 
	"R_USERID" VARCHAR2(30 BYTE), 
	"RECDATE" DATE, 
	"ATTACHXML" VARCHAR2(255 BYTE), 
	"ATTACHXSL" VARCHAR2(255 BYTE), 
	"XMLPATH" VARCHAR2(255 BYTE), 
	"SOURCEXMLPATH" VARCHAR2(255 BYTE), 
	"DOCID" VARCHAR2(50 BYTE), 
	"MODIFLAG" VARCHAR2(10 BYTE), 
	"MODIDATE" DATE, 
	"NOTIFICATION" VARCHAR2(10 BYTE), 
	"ADDENDA" CLOB, 
	"COMPANYID" VARCHAR2(20 BYTE), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_RECORD
--------------------------------------------------------

  CREATE TABLE "TBL_RECORD" 
   (	"RECORDID" VARCHAR2(200 BYTE), 
	"DOCID" CHAR(20 CHAR), 
	"PROCESSDEPTNAME" NVARCHAR2(200), 
	"PROCESSDEPTCODE" VARCHAR2(28 BYTE), 
	"REGISTERYEAR" CHAR(4 CHAR), 
	"REGISTERDATE" DATE, 
	"REGISTERNO" VARCHAR2(200 BYTE), 
	"APRMEMBERTITLE" NVARCHAR2(200), 
	"DRAFTERNAME" NVARCHAR2(200), 
	"EXECUTEDATE" DATE, 
	"RECEIPTMEMBERNAME" NVARCHAR2(200), 
	"SENDINGMEMBERNAME" NVARCHAR2(200), 
	"DELIVERYNO" CHAR(17 CHAR), 
	"PRODUCEDEPTREGNO" VARCHAR2(200 CHAR), 
	"ELECTRONICRECFLAG" CHAR(1 CHAR), 
	"SPECIALRECORDCODE" CHAR(5 CHAR), 
	"PUBLICITYCODE" CHAR(9 CHAR), 
	"LIMITRANGE" VARCHAR2(100 CHAR), 
	"OLDRECORDFLAG" CHAR(1 CHAR), 
	"DELETEDATE" DATE, 
	"DELFLAG" CHAR(1 CHAR), 
	"SPECIALCATALOGFLAG" CHAR(1 CHAR), 
	"ATTACHFLAG" CHAR(1 CHAR), 
	"CREATEDATE" DATE, 
	"REJECTFLAG" CHAR(1 CHAR), 
	"MANUALREGFLAG" CHAR(1 CHAR), 
	"DOCTYPE" CHAR(1 CHAR), 
	"PROCESSDEPTNAME2" NVARCHAR2(200), 
	"APRMEMBERTITLE2" NVARCHAR2(200), 
	"DRAFTERNAME2" NVARCHAR2(200), 
	"RECEIPTMEMBERNAME2" NVARCHAR2(200), 
	"SENDINGMEMBERNAME2" NVARCHAR2(200), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE), 
	"PUBLICITYYN" CHAR(2 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_RECORDHISTORY
--------------------------------------------------------

  CREATE TABLE "TBL_RECORDHISTORY" 
   (	"RECORDID" VARCHAR2(68 BYTE), 
	"SEPERATEATTACHNO" CHAR(2 CHAR), 
	"VERSION" NUMBER(10,0), 
	"REGISTERDATE" DATE, 
	"TITLE" VARCHAR2(100 CHAR), 
	"NUMOFPAGE" CHAR(3 CHAR), 
	"APRMEMBERTITLE" NVARCHAR2(100), 
	"DRAFTER" NVARCHAR2(100), 
	"EXECUTEDATE" DATE, 
	"RECEIPTMEMBERNAME" NVARCHAR2(100), 
	"SENDINGMEMBERNAME" NVARCHAR2(100), 
	"MODIFYDATE" NVARCHAR2(32), 
	"MODIFYREASON" NVARCHAR2(510), 
	"MODIFIERNAME" NVARCHAR2(100), 
	"MODIFIERID" VARCHAR2(100 CHAR), 
	"MODIFYFLAG" CHAR(1 CHAR), 
	"DRAFTER2" NVARCHAR2(100), 
	"APRMEMBERTITLE2" NVARCHAR2(100), 
	"RECEIPTMEMBERNAME2" NVARCHAR2(100), 
	"SENDINGMEMBERNAME2" NVARCHAR2(100), 
	"MODIFIERNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_RECORD_TEMP
--------------------------------------------------------

  CREATE TABLE "TBL_RECORD_TEMP" 
   (	"RECORDID" VARCHAR2(200 BYTE), 
	"DOCID" CHAR(20 BYTE), 
	"PROCESSDEPTNAME" NVARCHAR2(200), 
	"PROCESSDEPTCODE" VARCHAR2(28 BYTE), 
	"REGISTERYEAR" CHAR(4 BYTE), 
	"REGISTERDATE" DATE, 
	"REGISTERNO" VARCHAR2(200 BYTE), 
	"APRMEMBERTITLE" NVARCHAR2(200), 
	"DRAFTERNAME" NVARCHAR2(200), 
	"EXECUTEDATE" DATE, 
	"RECEIPTMEMBERNAME" NVARCHAR2(200), 
	"SENDINGMEMBERNAME" NVARCHAR2(200), 
	"DELIVERYNO" CHAR(17 BYTE), 
	"PRODUCEDEPTREGNO" VARCHAR2(200 BYTE), 
	"ELECTRONICRECFLAG" CHAR(1 BYTE), 
	"SPECIALRECORDCODE" CHAR(5 BYTE), 
	"PUBLICITYCODE" CHAR(9 BYTE), 
	"LIMITRANGE" VARCHAR2(100 BYTE), 
	"OLDRECORDFLAG" CHAR(1 BYTE), 
	"DELETEDATE" DATE, 
	"DELFLAG" CHAR(1 BYTE), 
	"SPECIALCATALOGFLAG" CHAR(1 BYTE), 
	"ATTACHFLAG" CHAR(1 BYTE), 
	"CREATEDATE" DATE, 
	"REJECTFLAG" CHAR(1 BYTE), 
	"MANUALREGFLAG" CHAR(1 BYTE), 
	"DOCTYPE" CHAR(1 BYTE), 
	"PROCESSDEPTNAME2" NVARCHAR2(200), 
	"APRMEMBERTITLE2" NVARCHAR2(200), 
	"DRAFTERNAME2" NVARCHAR2(200), 
	"RECEIPTMEMBERNAME2" NVARCHAR2(200), 
	"SENDINGMEMBERNAME2" NVARCHAR2(200), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_RECREADHISTORY
--------------------------------------------------------

  CREATE TABLE "TBL_RECREADHISTORY" 
   (	"SERIALNO" NUMBER(19,0), 
	"DOCID" CHAR(20 CHAR), 
	"USERID" VARCHAR2(100 CHAR), 
	"USERNAME" NVARCHAR2(100), 
	"USERTITLE" NVARCHAR2(100), 
	"DEPTCODE" VARCHAR2(28 BYTE), 
	"DEPTNAME" NVARCHAR2(100), 
	"READDATE" DATE, 
	"USERNAME2" NVARCHAR2(100), 
	"USERTITLE2" NVARCHAR2(100), 
	"DEPTNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_RECRELAYATTACHINFO
--------------------------------------------------------

  CREATE TABLE "TBL_RECRELAYATTACHINFO" 
   (	"XDOCID" VARCHAR2(255 BYTE), 
	"ATTACHNAME" VARCHAR2(255 BYTE), 
	"ATTACHURL" VARCHAR2(255 BYTE), 
	"ATTACHSN" NUMBER(11,0), 
	"ATTACHTYPE" VARCHAR2(1 BYTE), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(20 BYTE),
	"CREATEDATE" DATE DEFAULT SYSDATE
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_RECRELAYINFO
--------------------------------------------------------

  CREATE TABLE "TBL_RECRELAYINFO" 
   (	"DOCID" VARCHAR2(20 BYTE), 
	"XDOCID" VARCHAR2(255 BYTE), 
	"RECDATE" DATE, 
	"MFROM" VARCHAR2(255 BYTE), 
	"MTO" VARCHAR2(255 BYTE), 
	"SUBJECT" VARCHAR2(255 BYTE), 
	"XMAILTYPE" VARCHAR2(8 BYTE), 
	"XFROMCODE" VARCHAR2(255 BYTE), 
	"XTOCODE" VARCHAR2(255 BYTE), 
	"XGW" VARCHAR2(255 BYTE), 
	"XDOCTYPE" VARCHAR2(6 BYTE), 
	"XDTDVERSION" VARCHAR2(255 BYTE), 
	"XXSLVERSION" VARCHAR2(255 BYTE), 
	"CONTENTTYPE" VARCHAR2(255 BYTE), 
	"SEALURL" VARCHAR2(255 BYTE), 
	"XMLURL" VARCHAR2(255 BYTE), 
	"EMLURL" VARCHAR2(255 BYTE), 
	"RECEIVEDDATE" VARCHAR2(20 BYTE), 
	"ISPKI" VARCHAR2(1 BYTE), 
	"IDX" NUMBER(11,0), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_RECRELAYSIGNINFO
--------------------------------------------------------

  CREATE TABLE "TBL_RECRELAYSIGNINFO" 
   (	"XDOCID" VARCHAR2(255 BYTE), 
	"SIGNNAME" VARCHAR2(255 BYTE), 
	"REALSIGNNAME" VARCHAR2(255 BYTE), 
	"COMPANYID" VARCHAR2(45 BYTE), 
	"TENANT_ID" VARCHAR2(45 BYTE),
	"CREATEDATE" DATE DEFAULT SYSDATE
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_RECROLEINFO
--------------------------------------------------------

  CREATE TABLE "TBL_RECROLEINFO" 
   (	"RECORDID" VARCHAR2(200 BYTE), 
	"SEPERATEATTACHNO" CHAR(2 CHAR), 
	"USERID" VARCHAR2(400 CHAR), 
	"USERRIGHT" NUMBER(10,0), 
	"USERNAME" NVARCHAR2(200), 
	"USERTITLE" NVARCHAR2(200), 
	"DEPTCODE" VARCHAR2(28 BYTE), 
	"DEPTNAME" NVARCHAR2(200), 
	"USERNAME2" NVARCHAR2(200), 
	"USERTITLE2" NVARCHAR2(200), 
	"DEPTNAME2" NVARCHAR2(200), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_RECROLEINFO_TEMP
--------------------------------------------------------

  CREATE TABLE "TBL_RECROLEINFO_TEMP" 
   (	"DOCID" CHAR(20 BYTE), 
	"RECORDID" VARCHAR2(200 BYTE), 
	"SEPERATEATTACHNO" CHAR(2 BYTE), 
	"USERID" VARCHAR2(400 BYTE), 
	"USERRIGHT" NUMBER(10,0), 
	"USERNAME" NVARCHAR2(200), 
	"USERTITLE" NVARCHAR2(200), 
	"DEPTCODE" VARCHAR2(28 BYTE), 
	"DEPTNAME" NVARCHAR2(200), 
	"USERNAME2" NVARCHAR2(200), 
	"USERTITLE2" NVARCHAR2(200), 
	"DEPTNAME2" NVARCHAR2(200), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_RS_ATTACH
--------------------------------------------------------

  CREATE TABLE "TBL_RS_ATTACH" 
   (	"ATTACHID" NUMBER(10,0), 
	"RESID" NUMBER(10,0), 
	"FILESIZE" NUMBER(10,0), 
	"FILENAME" VARCHAR2(500 BYTE), 
	"FILEPATH" VARCHAR2(500 BYTE), 
	"COMPANYID" VARCHAR2(40 BYTE), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_RS_BRD
--------------------------------------------------------

  CREATE TABLE "TBL_RS_BRD" 
   (	"BRD_ID" NUMBER(*,0), 
	"BRD_COMPANY" NVARCHAR2(20), 
	"BRD_NM" NVARCHAR2(255), 
	"BRD_NM2" NVARCHAR2(255), 
	"BRD_GROUP" NCHAR(3), 
	"BRD_GB" NCHAR(1), 
	"BRD_REF" NUMBER(10,0) DEFAULT 0, 
	"BRD_LEVEL" NUMBER(10,0) DEFAULT 0, 
	"BRD_STEP" NUMBER(10,0), 
	"BRD_POSTTERM" NUMBER(10,0), 
	"BRD_EXPLAIN" NVARCHAR2(2000), 
	"BRD_ACCESS" NVARCHAR2(1000), 
	"BRD_UPPER" NUMBER(10,0), 
	"BRD_COUNT" NUMBER(10,0), 
	"BRD_URL" NVARCHAR2(255), 
	"ATTACH_SIZE" NUMBER(10,0), 
	"REPLY_MAIL_FG" NUMBER(1,0), 
	"OWNDEPTID" NVARCHAR2(50), 
	"OWNDEPTNM" NVARCHAR2(50), 
	"OWNDEPTNM2" NVARCHAR2(50), 
	"OWNERID" NVARCHAR2(1000), 
	"OWNERNM" NVARCHAR2(16), 
	"OWNERNM2" NVARCHAR2(16), 
	"OWNERPOSITION" NVARCHAR2(10), 
	"OWNERPOSITION2" NVARCHAR2(50), 
	"OWNERCALL" NVARCHAR2(20), 
	"MAKEDATE" NVARCHAR2(8), 
	"RESLOCATION" NVARCHAR2(50), 
	"BRD_UPPER2" NVARCHAR2(4), 
	"APPROVEFLAG" NCHAR(1) DEFAULT TO_NCHAR('0'), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"RETURNFLAG" NCHAR(1) DEFAULT TO_NCHAR('0'),
    "REPEATFLAG" NCHAR(1) DEFAULT TO_NCHAR('1')
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_RS_FAVORITE
--------------------------------------------------------

  CREATE TABLE "TBL_RS_FAVORITE" 
   (	"RESID" NVARCHAR2(40), 
	"RESCOMPANY" NVARCHAR2(40), 
	"USERID" NVARCHAR2(40), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_RS_PERSPORTLET
--------------------------------------------------------

  CREATE TABLE "TBL_RS_PERSPORTLET" 
   (	"CN" NVARCHAR2(80), 
	"BRD_ID" NUMBER(10,0), 
	"BRD_COMPANY" NVARCHAR2(80), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_RS_RESACL
--------------------------------------------------------

  CREATE TABLE "TBL_RS_RESACL" 
   (	"RESID" NVARCHAR2(20), 
	"DEPT_YN" NCHAR(1), 
	"SDA_YN" NCHAR(1), 
	"MEMBER_NAM" NVARCHAR2(100),
	"MEMBER_NAM2" NVARCHAR2(100),
	"MEMBER_ID" NVARCHAR2(40), 
	"ACCESS_LVL" NVARCHAR2(1), 
	"COMPANYID" NVARCHAR2(20), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_RS_SCHEDULE
--------------------------------------------------------

  CREATE TABLE "TBL_RS_SCHEDULE" 
   (	"OWNERID" NVARCHAR2(20), 
	"NUM" NUMBER(18,0), 
	"PNUM" NUMBER(18,0) DEFAULT 0, 
	"COMPANYID" NVARCHAR2(20), 
	"WRITERID" NVARCHAR2(20), 
	"DEPTNM" NVARCHAR2(50), 
	"OWNERNM" NVARCHAR2(20), 
	"TITLE" NVARCHAR2(100),
	"LOCATION" NVARCHAR2(50), 
	"TIMEDISPLAY" NCHAR(1), 
	"STARTDATE" DATE, 
	"ENDDATE" DATE, 
	"ALLDAY" NCHAR(1), 
	"ALERTTIME" NVARCHAR2(4), 
	"CONTENT" NCLOB, 
	"IMPORTANCE" NCHAR(1), 
	"REFLAG" NCHAR(1), 
	"GRESFLAG" NCHAR(1), 
	"WRITEDAY" DATE, 
	"ENTRYLIST" NVARCHAR2(200), 
	"CHARACTERID" NUMBER(10,0), 
	"ATTACHFLAG" NCHAR(1), 
	"PUBLICFLAG" NCHAR(1), 
	"APPROVEFLAG" NCHAR(1) DEFAULT TO_NCHAR('0'), 
	"SCHEDULEID" NVARCHAR2(500), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"RETURNFLAG" NCHAR(1) DEFAULT TO_NCHAR('0'),
	"DEPTID" NVARCHAR2(80)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_RS_SCHEDULEFORM
--------------------------------------------------------

  CREATE TABLE "TBL_RS_SCHEDULEFORM" 
   (	"RESID" NVARCHAR2(20), 
	"BRDNM" NVARCHAR2(100), 
	"FORMTEXT" NCLOB, 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_RS_SCHEDULEREPETITION
--------------------------------------------------------

  CREATE TABLE "TBL_RS_SCHEDULEREPETITION" 
   (	"OWNERID" NVARCHAR2(20), 
	"NUM" NUMBER(18,0), 
	"COMPANYID" NVARCHAR2(20), 
	"STARTDATETIME" DATE, 
	"ENDDATETIME" DATE, 
	"REWAY" NCHAR(2), 
	"RENUM" NVARCHAR2(5), 
	"REDAY" NVARCHAR2(2), 
	"REYOIL" NVARCHAR2(14), 
	"REMONTH" NVARCHAR2(2), 
	"REORD" NCHAR(2), 
	"ENDFLAG" NCHAR(1), 
	"RECOUNT" NVARCHAR2(5), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_SCHEDULE
--------------------------------------------------------

  CREATE TABLE "TBL_SCHEDULE" 
   (	"SCHEDULEID" NUMBER(10,0), 
	"PARENTID" NUMBER(10,0), 
	"OWNERID" NVARCHAR2(50), 
	"OWNERNAME" NVARCHAR2(50), 
	"OWNERNAME2" NVARCHAR2(50), 
	"CREATORID" NVARCHAR2(50), 
	"CREATORNAME" NVARCHAR2(50), 
	"CREATORNAME2" NVARCHAR2(50), 
	"CREATEDATE" DATE, 
	"MODIFIERID" NVARCHAR2(50), 
	"MODIFIERNAME" NVARCHAR2(50), 
	"MODIFIERNAME2" NVARCHAR2(50), 
	"MODIFYDATE" DATE, 
	"SCHEDULETYPE" NUMBER(5,0), 
	"IMPORTANCE" NUMBER(5,0), 
	"HASATTENDANT" NCHAR(1), 
	"HASATTACH" NCHAR(1), 
	"HASCOMMENT" NCHAR(1), 
	"ISREADONLY" NCHAR(1), 
	"ISPUBLIC" NCHAR(1), 
	"DATETYPE" NUMBER(5,0), 
	"STARTDATE" DATE, 
	"ENDDATE" DATE, 
	"REPETITION" NVARCHAR2(50), 
	"REPETITIONDELETE" NVARCHAR2(250), 
	"TITLE" NVARCHAR2(250), 
	"LOCATION" NVARCHAR2(250), 
	"CONTENTPATH" NVARCHAR2(250), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(40 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_SCHEDULEATTACH
--------------------------------------------------------

  CREATE TABLE "TBL_SCHEDULEATTACH" 
   (	"ATTACHID" NUMBER(10,0), 
	"SCHEDULEID" NUMBER(10,0), 
	"FILESIZE" NUMBER(10,0), 
	"FILENAME" NVARCHAR2(250), 
	"FILEPATH" NVARCHAR2(250), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_SCHEDULECONFIG
--------------------------------------------------------

  CREATE TABLE "TBL_SCHEDULECONFIG" 
   (	"USERID" NVARCHAR2(50), 
	"DEFAULTVIEW" NCHAR(1), 
	"STARTDAY" NCHAR(1), 
	"STARTTIME" NVARCHAR2(4), 
	"ENDTIME" NVARCHAR2(4), 
	"AUTODELETE" NUMBER(10,0), 
	"TENANT_ID" NUMBER(5,0), 
	"INVITATIONMAIL" VARCHAR2(4 BYTE) DEFAULT 'Y', 
	"CANCELLATIONMAIL" VARCHAR2(4 BYTE) DEFAULT 'Y', 
	"ATTENDANCEMAIL" VARCHAR2(4 BYTE) DEFAULT 'Y', 
	"REJECTEDMAIL" VARCHAR2(4 BYTE) DEFAULT 'Y',
	"REMINDERTIME" NVARCHAR2(4) DEFAULT '0'
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_SCHEDULEGROUP
--------------------------------------------------------

  CREATE TABLE "TBL_SCHEDULEGROUP" 
   (	"GROUPID" NVARCHAR2(50), 
	"GROUPNAME" NVARCHAR2(50), 
	"CREATORID" NVARCHAR2(50), 
	"CREATORNAME" NVARCHAR2(50), 
	"CREATORNAME2" NVARCHAR2(50), 
	"DESCRIPTION" NVARCHAR2(250), 
	"CREATEDATE" DATE, 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(40 BYTE),
	"MODIFYDATE" DATE,
	"PRECREATORID" NVARCHAR2(100),
	"PRECREATORNAME" NVARCHAR2(100),
	"PRECREATORNAME2" NVARCHAR2(100),
	"GROUPCOLOR" VARCHAR2(10 BYTE),
	"TRANSFERDATE" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_SCHEDULEGROUPMEMBER
--------------------------------------------------------

  CREATE TABLE "TBL_SCHEDULEGROUPMEMBER" 
   (	"GROUPID" NVARCHAR2(50), 
	"MEMBERID" NVARCHAR2(50), 
	"MEMBERNAME" NVARCHAR2(50), 
	"MEMBERNAME2" NVARCHAR2(50), 
	"MEMBERDEPTID" NVARCHAR2(50), 
	"STATUS" NUMBER(5,0), 
	"RESPONSEDATE" DATE, 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_SCHEDULEREPETITION_DEL
--------------------------------------------------------

  CREATE TABLE "TBL_SCHEDULEREPETITION_DEL" 
   (	"REPETITIONID" NUMBER(10,0), 
	"SCHEDULEID" NUMBER(10,0), 
	"STARTDATE" DATE, 
	"ENDDATE" DATE, 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(40 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_SCHEDULE_PUBLIC_DEPT
--------------------------------------------------------

  CREATE TABLE "TBL_SCHEDULE_PUBLIC_DEPT" 
   (	"IDX" NUMBER(10,0), 
	"USERCN" VARCHAR2(20 CHAR), 
	"USERNAME" NVARCHAR2(60), 
	"USERNAME2" NVARCHAR2(60), 
	"DEPARTMENTCN" VARCHAR2(20 CHAR), 
	"DEPARTMENTNAME" NVARCHAR2(60), 
	"DEPARTMENTNAME2" NVARCHAR2(60), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(40 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_SCHEDULE_OAUTHINFO
--------------------------------------------------------

   CREATE TABLE "TBL_SCHEDULE_OAUTHINFO"
   ( "USERID" VARCHAR2(40) NOT NULL,
	  "GOOGLEACCESSTOKEN" NCLOB DEFAULT NULL,
	  "GOOGLEREFRESHTOKEN" NCLOB DEFAULT NULL,
	  "GOOGLESYNCTOKEN" NCLOB DEFAULT NULL,
	  "GOOGLESYNCSTART" DATE DEFAULT NULL,
	  "GOOGLECREATEDATE" DATE DEFAULT NULL,
	  "GOOGLEUPDATEDATE" DATE DEFAULT NULL,
	  "OFFICETENANTID" NCLOB DEFAULT NULL,
	  "OFFICEACCESSTOKEN" NCLOB DEFAULT NULL,
	  "OFFICEREFRESHTOKEN" NCLOB DEFAULT NULL,
	  "OFFICECREATEDATE" DATE DEFAULT NULL,
	  "OFFICEUPDATEDATE" DATE DEFAULT NULL,
	  "COMPANYID" VARCHAR2(40) NOT NULL,
	  "TENANT_ID" NUMBER(5,0) NOT NULL,
	  PRIMARY KEY ("USERID","COMPANYID","TENANT_ID")
	) ;
--------------------------------------------------------
--  DDL for Table TBL_SCHISTORY_CAB
--------------------------------------------------------

  CREATE TABLE "TBL_SCHISTORY_CAB" 
   (	"VERSION" NUMBER(10,0), 
	"CABINETCLASSNO" CHAR(25 CHAR), 
	"SERIALNO" CHAR(3 CHAR), 
	"SC1" NVARCHAR2(100), 
	"SC2" NVARCHAR2(100), 
	"SC3" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_SCHISTORY_REC
--------------------------------------------------------

  CREATE TABLE "TBL_SCHISTORY_REC" 
   (	"RECORDID" CHAR(17 CHAR), 
	"SEPERATEATTACHNO" CHAR(2 CHAR), 
	"VERSION" NUMBER(10,0), 
	"SERIALNO" CHAR(3 CHAR), 
	"SC1" NVARCHAR2(100), 
	"SC2" NVARCHAR2(100), 
	"SC3" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
   
 --------------------------------------------------------
--  DDL for Table TBL_CAR
--------------------------------------------------------  
   
   CREATE TABLE "TBL_CAR" (
  "CAR_ID" NUMBER(11,0),
  "CAR_NAME" NVARCHAR2(510),
  "CAR_NAME2" NVARCHAR2(510),
  "CAR_NM" NVARCHAR2(40),
  "CAR_GB" NVARCHAR2(2),
  "CAR_LEVEL" NUMBER(11,0),
  "CAR_STEP" NUMBER(11,0),
  "CAR_ACCESS" NVARCHAR2(510),
  "CAR_UPPER" NUMBER(10,0),
  "OWNDEPTID" NVARCHAR2(100),
  "OWNDEPTNM" NVARCHAR2(100),
  "OWNDEPTNM2" NVARCHAR2(100),
  "OWNERID" NVARCHAR2(200),
  "OWNERNM" NVARCHAR2(40),
  "OWNERNM2" NVARCHAR2(40),
  "OWNERPOSITION" NVARCHAR2(20),
  "OWNERPOSITION2" NVARCHAR2(100),
  "OWNERCALL" NVARCHAR2(200),
  "CAR_REGISTER_DATE" NVARCHAR2(20),
  "DELFLAG" NVARCHAR2(2),
  "COMPANYID" NVARCHAR2(40),
  "TENANT_ID" NUMBER DEFAULT 0,
  "CAR_URL" NVARCHAR2(40),
  "CAR_EXPLAIN" NVARCHAR2(40)
);
 --------------------------------------------------------
--  DDL for Table TBL_CAR_ACL
--------------------------------------------------------  
CREATE TABLE "TBL_CAR_ACL" (
  "CAR_ID" NVARCHAR2(40),
  "MEMBER_NAM" NVARCHAR2(20),
  "MEMBER_ID" NVARCHAR2(80),
  "ACCESS_LVL" NVARCHAR2(2),
  "DEPT_YN" NVARCHAR2(2),
  "SDA_YN" NVARCHAR2(2),
  "COMPANYID" NVARCHAR2(40),
  "TENANT_ID" NUMBER DEFAULT 0
);
 --------------------------------------------------------
--  DDL for Table TBL_CAR_ATTACH
--------------------------------------------------------  
CREATE TABLE "TBL_CAR_ATTACH" (
  "ATTACHID" NUMBER(10,0),
  "CAR_ID" NVARCHAR2(40),
  "FILESIZE" NUMBER(11,0),
  "FILENAME" NVARCHAR2(500),
  "FILEPATH" NVARCHAR2(500),
  "COMPANYID" NVARCHAR2(40),
  "TENANT_ID" NUMBER DEFAULT 0
);
 --------------------------------------------------------
--  DDL for Table TBL_CAR_FORM
--------------------------------------------------------  
CREATE TABLE "TBL_CAR_FORM" (
  "CAR_FORM_ID" NUMBER(38,0),
  "CAR_ID" NVARCHAR2(40),
  "REGISTER_ID" NVARCHAR2(80),
  "REGISTER_DATE" DATE,
  "REV_DATE" DATE,
  "REV_TIME" NVARCHAR2(45),
  "REV_TIME2" NVARCHAR2(45),
  "DRIVER_DEPTNAME" NVARCHAR2(80),
  "DRIVER_NAME" NVARCHAR2(80),
  "B_DEPT_ID" NVARCHAR2(100),
  "B_DEPART_TIME" NVARCHAR2(16),
  "B_DISTANCE" NVARCHAR2(40),
  "DRIVE_PURPOSE" NVARCHAR2(200),
  "DRIVE_POINT" NVARCHAR2(100),
  "A_ARRIVE_TIME" NVARCHAR2(16),
  "A_DISTANCE"  NVARCHAR2(40),
  "A_DISTANCE_AUTO" NVARCHAR2(40),
  "A_DISTANCE_COMMUTE" NVARCHAR2(40),
  "A_DISTANCE_WORK" NVARCHAR2(40),
  "A_DISTANCE_ETC" NVARCHAR2(40),
  "A_SUBMIT_FLAG" NVARCHAR2(2),
  "COMPANYID" NVARCHAR2(40),
  "TENANT_ID" NUMBER DEFAULT 0,
  "CAR_REGISTER_NO" NUMBER(20,0),
  "DELFLAG" NVARCHAR2(2)
  );
--------------------------------------------------------
--  DDL for Table TBL_SEALDEPTINFO
--------------------------------------------------------

  CREATE TABLE "TBL_SEALDEPTINFO" 
   (	"SEALNUM" NUMBER(10,0), 
	"DEPTID" VARCHAR2(100 CHAR), 
	"SEALNAME" NVARCHAR2(100), 
	"SEALPATH" VARCHAR2(255 CHAR), 
	"SEALWIDTH" FLOAT(126), 
	"SEALHEIGHT" FLOAT(126), 
	"REGDATE" DATE, 
	"DELDATE" DATE, 
	"REGUSERID" VARCHAR2(100 CHAR), 
	"REGUSERNAME" NVARCHAR2(100), 
	"REGUSERNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_SEALINFO
--------------------------------------------------------

  CREATE TABLE "TBL_SEALINFO" 
   (	"SEALNUM" NUMBER(10,0), 
	"SEALNAME" NVARCHAR2(100), 
	"SEALPATH" VARCHAR2(255 CHAR), 
	"SEALWIDTH" FLOAT(126), 
	"SEALHEIGHT" FLOAT(126), 
	"REGDATE" DATE, 
	"DELDATE" DATE, 
	"REGUSERID" VARCHAR2(100 CHAR), 
	"REGUSERNAME" NVARCHAR2(100), 
	"REGUSERNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_SECRETARY
--------------------------------------------------------

  CREATE TABLE "TBL_SECRETARY" 
   (	"USERID" NVARCHAR2(50), 
	"USERNAME" NVARCHAR2(50), 
	"USERNAME2" NVARCHAR2(50), 
	"SECRETARYID" NVARCHAR2(50), 
	"SECRETARYNAME" NVARCHAR2(50), 
	"SECRETARYNAME2" NVARCHAR2(50), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(40 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_SEPERATEATTACH
--------------------------------------------------------

  CREATE TABLE "TBL_SEPERATEATTACH" 
   (	"RECORDID" VARCHAR2(200 BYTE), 
	"SEPERATEATTACHNO" CHAR(2 CHAR), 
	"TITLE" NVARCHAR2(1020), 
	"REGISTERTYPE" CHAR(1 CHAR), 
	"NUMOFPAGE" CHAR(3 CHAR), 
	"DELFLAG" CHAR(18 CHAR), 
	"MODIFYFLAG" CHAR(1 CHAR), 
	"DELETEDATE" DATE, 
	"CABINETID" VARCHAR2(112 BYTE), 
	"CREATEDATE" DATE, 
	"CATALOGTRANSFERYEAR" NUMBER(10,0), 
	"DOCTRANSFERYEAR" NUMBER(10,0), 
	"CONFIRMFLAG" CHAR(1 CHAR), 
	"CATALOGTRANSFERFLAG" CHAR(1 CHAR), 
	"DOCTRANSFERFLAG" CHAR(1 CHAR), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_SEPERATEATTACH_TEMP
--------------------------------------------------------

  CREATE TABLE "TBL_SEPERATEATTACH_TEMP" 
   (	"DOCID" CHAR(20 BYTE), 
	"RECORDID" VARCHAR2(200 BYTE), 
	"SEPERATEATTACHNO" CHAR(2 BYTE), 
	"TITLE" NVARCHAR2(1020), 
	"REGISTERTYPE" CHAR(1 BYTE), 
	"NUMOFPAGE" CHAR(3 BYTE), 
	"DELFLAG" CHAR(18 BYTE), 
	"MODIFYFLAG" CHAR(1 BYTE), 
	"DELETEDATE" DATE, 
	"CABINETID" VARCHAR2(112 BYTE), 
	"CREATEDATE" DATE, 
	"CATALOGTRANSFERYEAR" NUMBER(10,0), 
	"DOCTRANSFERYEAR" NUMBER(10,0), 
	"CONFIRMFLAG" CHAR(1 BYTE), 
	"CATALOGTRANSFERFLAG" CHAR(1 BYTE), 
	"DOCTRANSFERFLAG" CHAR(1 BYTE), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_SERIALNUMGEN
--------------------------------------------------------

  CREATE TABLE "TBL_SERIALNUMGEN" 
   (	"TYPE1" VARCHAR2(50 CHAR), 
	"TYPE3" VARCHAR2(50 CHAR), 
	"ROLLBACKFLAG" NUMBER(5,0), 
	"TYPE2" VARCHAR2(50 CHAR), 
	"TIMESEP" NUMBER(10,0), 
	"REGSERIALNO" NUMBER(19,0), 
	"TENANT_ID" NUMBER(*,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(20 BYTE), 
	"IDX" NUMBER(11,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_SIGNINFO
--------------------------------------------------------

  CREATE TABLE "TBL_SIGNINFO" 
   (	"DOCID" CHAR(20 CHAR), 
	"APRSN" NUMBER(10,0), 
	"SIGNTYPE" VARCHAR2(10 CHAR), 
	"SIGNNAME" VARCHAR2(100 CHAR), 
	"CONTENT" NVARCHAR2(510), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_SPECIALCATALOGINFO_CAB
--------------------------------------------------------

  CREATE TABLE "TBL_SPECIALCATALOGINFO_CAB" 
   (	"CABINETCLASSNO" VARCHAR2(100 CHAR), 
	"SERIALNO" CHAR(3 CHAR), 
	"SC2" NVARCHAR2(100), 
	"SC3" NVARCHAR2(100), 
	"SC1" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_SPECIALCATALOGINFO_REC
--------------------------------------------------------

  CREATE TABLE "TBL_SPECIALCATALOGINFO_REC" 
   (	"RECORDID" VARCHAR2(68 BYTE), 
	"SERIALNO" CHAR(3 CHAR), 
	"SC2" NVARCHAR2(100), 
	"SC3" NVARCHAR2(100), 
	"SC1" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_SPECIALCATALOGINFO_TMP
--------------------------------------------------------

  CREATE TABLE "TBL_SPECIALCATALOGINFO_TMP" 
   (	"DOCID" CHAR(20 BYTE), 
	"RECORDID" VARCHAR2(200 BYTE), 
	"SERIALNO" CHAR(3 BYTE), 
	"SC1" NVARCHAR2(200), 
	"SC2" NVARCHAR2(200), 
	"SC3" NVARCHAR2(200), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_SPECIALCONTAINERINFO
--------------------------------------------------------

  CREATE TABLE "TBL_SPECIALCONTAINERINFO" 
   (	"DEPTID" VARCHAR2(100 BYTE), 
	"CONTTYPE" VARCHAR2(12 BYTE), 
	"SN" NUMBER(10,0), 
	"CONTNAME" VARCHAR2(510 BYTE), 
	"SUBQUERY" VARCHAR2(1000 BYTE), 
	"COMPANYID" VARCHAR2(20 BYTE), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_SURVEY
--------------------------------------------------------

  CREATE TABLE "TBL_SURVEY" 
   (	"SURVEY_ID" NUMBER(20,0), 
	"TITLE" NCLOB, 
	"PURPOSE" NCLOB, 
	"USER_ID" VARCHAR2(50 BYTE), 
	"CREATE_DATE" VARCHAR2(40 BYTE), 
	"START_DATE" VARCHAR2(40 BYTE), 
	"END_DATE" VARCHAR2(40 BYTE), 
	"USER_NAME1" VARCHAR2(150 BYTE), 
	"USER_NAME2" VARCHAR2(150 BYTE), 
	"USE_STATUS" NUMBER(11,0) DEFAULT 0, 
	"OPEN_DAYS" NUMBER(11,0), 
	"RESULT_PUBLIC_FLAG" NUMBER(4,0) DEFAULT 0, 
	"ANONYMOUS_FLAG" NUMBER(4,0) DEFAULT 0, 
	"MULTI_ANSWER_FLAG" NUMBER(4,0) DEFAULT 0, 
	"PARTICIPATE_FLAG" NUMBER(4,0) DEFAULT 0, 
	"ATTACH_FLAG" NUMBER(4,0) DEFAULT 0, 
	"MODIFY_FLAG" NUMBER(4,0) DEFAULT 0, 
	"DRAFT_FLAG" NUMBER(4,0) DEFAULT 0, 
	"RESPONSE_FLAG" NUMBER(4,0) DEFAULT 0, 
	"DELETE_USER" VARCHAR2(50 BYTE) DEFAULT NULL, 
	"UPDATE_USER" VARCHAR2(50 BYTE) DEFAULT NULL, 
	"UPDATE_DATE" VARCHAR2(40 BYTE) DEFAULT NULL, 
	"TOTAL_USER" NUMBER(11,0) DEFAULT 0, 
	"COMPANY_ID" VARCHAR2(80 BYTE), 
	"TENANT_ID" NUMBER(5,0),
	"MAIL_FLAG" NUMBER(4,0), 
	"POPUP_FLAG" NUMBER(4,0), 
	"MAIL_SENT_FLAG" NUMBER(4,0) DEFAULT 0,
    "CLOSING_TEXT" NCLOB DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_SURVEY_ATTACHFILE
--------------------------------------------------------

  CREATE TABLE "TBL_SURVEY_ATTACHFILE" 
   (	"ATT_FILE_ID" NUMBER(20,0), 
	"SURVEY_ID" NUMBER(20,0), 
	"TARGET_ID" NUMBER(20,0), 
	"TARGET_TYPE" VARCHAR2(50 BYTE), 
	"FILE_NM" VARCHAR2(256 BYTE), 
	"FILE_SIZE" NUMBER(20,0) DEFAULT 0, 
	"FILE_PATH" VARCHAR2(256 BYTE) DEFAULT NULL, 
	"FILE_URL" VARCHAR2(256 BYTE) DEFAULT NULL, 
	"COMPANY_ID" VARCHAR2(80 BYTE), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_SURVEY_CONFIG
--------------------------------------------------------

  CREATE TABLE "TBL_SURVEY_CONFIG" 
   (	"USER_ID" VARCHAR2(50 BYTE), 
	"LIST_COUNT" NUMBER(11,0) DEFAULT -1, 
	"PREVIEW_FLAG" VARCHAR2(10 BYTE) DEFAULT -1, 
	"LIST_H_PERCENT" NUMBER(11,0) DEFAULT -1, 
	"LIST_W_PERCENT" NUMBER(11,0) DEFAULT -1, 
	"COMPANY_ID" VARCHAR2(80 BYTE), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_SURVEY_OPTION
--------------------------------------------------------

  CREATE TABLE "TBL_SURVEY_OPTION" 
   (	"OPTION_ID" NUMBER(20,0), 
	"SURVEY_ID" NUMBER(20,0), 
	"QUESTION_ID" NUMBER(20,0), 
	"QUESTION_TYPE" NUMBER(4,0), 
	"QUESTION_LEVEL" NUMBER(20,0), 
	"CONTENT" VARCHAR2(250 BYTE), 
	"LEVELS" NUMBER(11,0), 
	"OTHER_FLAG" NUMBER(4,0) DEFAULT 0, 
	"LOGIC_NUM" NUMBER(11,0) DEFAULT -1, 
	"ROW_LEVEL" NUMBER(11,0) DEFAULT NULL, 
	"COLUMN_LEVEL" NUMBER(11,0) DEFAULT NULL, 
	"COMPANY_ID" VARCHAR2(80 BYTE), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_SURVEY_PARTICIPANT
--------------------------------------------------------

  CREATE TABLE "TBL_SURVEY_PARTICIPANT" 
   (	"PARTICIPANT_ID" NUMBER(20,0), 
	"SURVEY_ID" NUMBER(20,0), 
	"USER_TYPE" VARCHAR2(50 BYTE), 
	"USER_ID" VARCHAR2(50 BYTE), 
	"USER_NAME1" VARCHAR2(80 BYTE) DEFAULT NULL, 
	"USER_NAME2" VARCHAR2(80 BYTE) DEFAULT NULL, 
	"EMAIL" VARCHAR2(150 BYTE) DEFAULT NULL, 
	"DEPT_ID" VARCHAR2(80 BYTE) DEFAULT NULL, 
	"DEPT_NAME1" VARCHAR2(80 BYTE) DEFAULT NULL, 
	"DEPT_NAME2" VARCHAR2(80 BYTE) DEFAULT NULL, 
	"COMPANY_ID" VARCHAR2(80 BYTE), 
	"TENANT_ID" NUMBER(5,0),
    "SUBDEPTYN" CHAR(1 CHAR) DEFAULT 'N'
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_SURVEY_QUESTION
--------------------------------------------------------

  CREATE TABLE "TBL_SURVEY_QUESTION" 
   (	"QUESTION_ID" NUMBER(20,0), 
	"SURVEY_ID" NUMBER(20,0), 
	"QUESTION_TYPE" NUMBER(4,0), 
	"TITLE" VARCHAR2(750 BYTE),
	"LEVELS" NUMBER(11,0), 
	"USE_STATUS" NUMBER(4,0) DEFAULT 0, 
	"REQUIRED_FLAG" NUMBER(4,0) DEFAULT 0, 
	"LOGIC_FLAG" NUMBER(4,0) DEFAULT 0, 
	"SLIDER_LOGIC_POINT" NUMBER(20,0) DEFAULT -1, 
	"SKIP_FLAG" NUMBER(4,0) DEFAULT 0, 
	"SKIP_NUM" NUMBER(11,0) DEFAULT -1, 
	"UNIT" NUMBER(20,0) DEFAULT -1, 
	"COMPANY_ID" VARCHAR2(80 BYTE), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_SURVEY_RESPONDENT
--------------------------------------------------------

  CREATE TABLE "TBL_SURVEY_RESPONDENT" 
   (	"RESPONSE_ID" NUMBER(20,0), 
	"SURVEY_ID" NUMBER(20,0), 
	"USER_ID" VARCHAR2(50 BYTE), 
	"USER_NAME1" VARCHAR2(80 BYTE), 
	"USER_NAME2" VARCHAR2(80 BYTE), 
	"EMAIL" VARCHAR2(150 BYTE), 
	"IMAGE" VARCHAR2(150 BYTE) DEFAULT NULL, 
	"DEPT_ID" VARCHAR2(80 BYTE), 
	"DEPT_NAME1" VARCHAR2(80 BYTE), 
	"DEPT_NAME2" VARCHAR2(80 BYTE), 
	"RESPONSE_DATE" VARCHAR2(40 BYTE), 
	"COMPANY_ID" VARCHAR2(80 BYTE), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_SURVEY_RESPONSE
--------------------------------------------------------

  CREATE TABLE "TBL_SURVEY_RESPONSE" 
   (	"RESPONSE_ID" NUMBER(20,0), 
	"SURVEY_ID" NUMBER(20,0), 
	"QUESTION_LEVEL" NUMBER(20,0), 
	"QUESTION_TYPE" NUMBER(4,0), 
	"USER_ID" VARCHAR2(50 BYTE), 
	"OPTION_ID" NUMBER(20,0) DEFAULT -1, 
	"TEXTS" NCLOB DEFAULT NULL, 
	"ROW_ID" NUMBER(11,0) DEFAULT -1, 
	"COLUMN_ID" NUMBER(11,0) DEFAULT -1, 
	"RANKING_LEVEL" NUMBER(11,0) DEFAULT -1, 
	"SLIDER_VALUE" NUMBER(11,0) DEFAULT -1, 
	"COMPANY_ID" VARCHAR2(80 BYTE), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_TASK
--------------------------------------------------------

  CREATE TABLE "TBL_TASK" 
   (	"TASKID" NUMBER(10,0), 
	"CREATORID" NVARCHAR2(50), 
	"CREATORNAME" NVARCHAR2(50), 
	"CREATORNAME2" NVARCHAR2(50), 
	"CREATEDATE" NVARCHAR2(20), 
	"TASKSTATUS" NUMBER(5,0), 
	"COMPLETERATE" NUMBER(5,0), 
	"IMPORTANCE" NUMBER(5,0), 
	"HASSHARE" NVARCHAR2(2), 
	"HASATTACH" NVARCHAR2(2), 
	"HASCOMMENT" NVARCHAR2(2), 
	"STARTDATE" NVARCHAR2(20), 
	"ENDDATE" NVARCHAR2(20), 
	"REPETITION" NVARCHAR2(50), 
	"TITLE" NVARCHAR2(250), 
	"CONTENTPATH" NVARCHAR2(250), 
	"TASKTYPE" NUMBER(5,0), 
	"UPDATETIME" NVARCHAR2(20), 
	"PERSONID" NVARCHAR2(50), 
	"PERSONNAME" NVARCHAR2(50), 
	"PERSONNAME2" NVARCHAR2(50), 
	"PERSONDEPTNAME" NVARCHAR2(50), 
	"PERSONDEPTNAME2" NVARCHAR2(50), 
	"PERSONATTACH" NVARCHAR2(10), 
	"PERSONCONTENTPATH" NVARCHAR2(250), 
	"CREATORDEPTNAME" NVARCHAR2(50), 
	"CREATORDEPTNAME2" NVARCHAR2(50), 
	"CREATOREMAIL" NVARCHAR2(50), 
	"PERSONEMAIL" NVARCHAR2(50), 
	"MEMO" NVARCHAR2(250), 
	"TOTALREP" NUMBER(9,0) DEFAULT 0, 
	"TENANTID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(40 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_TASKATTACH
--------------------------------------------------------

  CREATE TABLE "TBL_TASKATTACH" 
   (	"ATTACHID" NUMBER(10,0), 
	"TASKID" NUMBER(10,0), 
	"FILESIZE" NUMBER(10,0), 
	"FILENAME" NVARCHAR2(250), 
	"FILEPATH" NVARCHAR2(50), 
	"TYPE" NVARCHAR2(2), 
	"TENANTID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_TASKCATEGORY
--------------------------------------------------------

  CREATE TABLE "TBL_TASKCATEGORY" 
   (	"CATEGORYCODE" NVARCHAR2(16), 
	"NAME" NVARCHAR2(100), 
	"DESCRIPTION" NVARCHAR2(510), 
	"OLDFLAG" NVARCHAR2(2), 
	"NAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_TASKCODE
--------------------------------------------------------

  CREATE TABLE "TBL_TASKCODE" 
   (	"TASKCODE" NVARCHAR2(16), 
	"TASKNAME" NVARCHAR2(100), 
	"KEEPINGPERIOD" NVARCHAR2(4), 
	"CREATIONDATE" DATE, 
	"KPREASON" NVARCHAR2(500), 
	"KEEPINGMETHOD" NVARCHAR2(2), 
	"KEEPINGPLACE" NVARCHAR2(2), 
	"DISPLAYRECFLAG" NVARCHAR2(2), 
	"DISPLAYRECTRASTIME" NVARCHAR2(200), 
	"EXDISPLAYFREQUENCY" NVARCHAR2(2), 
	"SPECIALCATALOGFLAG" NVARCHAR2(2), 
	"SC1" NVARCHAR2(100), 
	"SC2" NVARCHAR2(100), 
	"SC3" NVARCHAR2(100), 
	"DISPLAYUSAGE" NVARCHAR2(2), 
	"DESCRIPTION" NVARCHAR2(500), 
	"TEMPFLAG" NVARCHAR2(2), 
	"SUBCATEGORYCODE" NVARCHAR2(16), 
	"DELFLAG" NVARCHAR2(2) DEFAULT 0, 
	"TASKNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT NULL, 
	"ITEMSECURITY" VARCHAR2(4 BYTE), 
	"ISPUBLIC" VARCHAR2(2 BYTE), 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_TASKCODEHISTORY
--------------------------------------------------------

  CREATE TABLE "TBL_TASKCODEHISTORY" 
   (	"SN" NUMBER(10,0), 
	"APPLYDATE" DATE, 
	"TASKCODE" NVARCHAR2(16), 
	"TASKNAME" NVARCHAR2(100), 
	"CHANGEFACTOR" NVARCHAR2(100), 
	"BEFOREVALUE" NVARCHAR2(500), 
	"AFTERVALUE" NVARCHAR2(600), 
	"CHANGEFACTOR2" NVARCHAR2(100), 
	"TASKNAME2" NVARCHAR2(100), 
	"AFTERVALUE2" NVARCHAR2(600), 
	"TENANT_ID" NUMBER(22,0) DEFAULT NULL, 
	"COMPANYID" NVARCHAR2(20)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_TASKCOMMENT
--------------------------------------------------------

  CREATE TABLE "TBL_TASKCOMMENT" 
   (	"COMMENTID" NUMBER(10,0), 
	"TASKID" NUMBER(10,0), 
	"COMMENTORID" NVARCHAR2(50), 
	"COMMENTORNAME" NVARCHAR2(50), 
	"COMMENTORNAME2" NVARCHAR2(50), 
	"COMMENTDATE" DATE, 
	"T_COMMENT" NCLOB, 
	"TENANTID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_TASKCONFIG
--------------------------------------------------------

  CREATE TABLE "TBL_TASKCONFIG" 
   (	"USERID" NVARCHAR2(50), 
	"DELAYCOLOR" NVARCHAR2(12), 
	"COMPLETECOLOR" NVARCHAR2(12), 
	"ORIGINCOLOR" NVARCHAR2(12), 
	"ORIGINCOLOR2" NVARCHAR2(12), 
	"TENANTID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_TASKGENERAL
--------------------------------------------------------

  CREATE TABLE "TBL_TASKGENERAL" 
   (	"USERID" NVARCHAR2(50), 
	"LISTCOUNT" NUMBER(10,0), 
	"SELECTTASKSTATUS" NVARCHAR2(12), 
	"TENANTID" NUMBER(8,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_TASKINSTANCESTATUS
--------------------------------------------------------

  CREATE TABLE "TBL_TASKINSTANCESTATUS" 
   (	"TASKID" NUMBER(10,0), 
	"REPEATCOUNT" NUMBER(10,0), 
	"TASKSTATUS" NUMBER(5,0), 
	"COMPLETERATE" NUMBER(5,0), 
	"STARTDATE" NVARCHAR2(20), 
	"ENDDATE" NVARCHAR2(20), 
	"TENANTID" NUMBER(5,0), 
	"DELETESTATUS" NUMBER(11,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_TASKMIDDLECATEGORY
--------------------------------------------------------

  CREATE TABLE "TBL_TASKMIDDLECATEGORY" 
   (	"MCATEGORYCODE" NVARCHAR2(16), 
	"NAME" NVARCHAR2(100), 
	"DESCRIPTION" NVARCHAR2(510), 
	"CATEGORYCODE" NVARCHAR2(16), 
	"OLDFLAG" NVARCHAR2(2), 
	"NAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_TASKREQUEST
--------------------------------------------------------

  CREATE TABLE "TBL_TASKREQUEST" 
   (	"REQUESTID" NUMBER(10,0), 
	"REQUESTDATE" DATE DEFAULT NULL, 
	"APPLYDATE" NVARCHAR2(16), 
	"REQUESTFLAG" NVARCHAR2(2), 
	"PROCESSFLAG" NUMBER(10,0), 
	"ORGANCODE" NVARCHAR2(14), 
	"DEPTCODE" NVARCHAR2(14), 
	"TASKCODE" NVARCHAR2(16), 
	"TASKNAME" NVARCHAR2(100), 
	"FILENAME" NVARCHAR2(510), 
	"ERRMSG" NCLOB
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_TASKSHARE
--------------------------------------------------------

  CREATE TABLE "TBL_TASKSHARE" 
   (	"TASKID" NUMBER(10,0), 
	"SHARERID" NVARCHAR2(50), 
	"SHARERNAME" NVARCHAR2(50), 
	"SHARERNAME2" NVARCHAR2(50), 
	"SHARERDEPTNAME" NVARCHAR2(50), 
	"SHARERDEPTNAME2" NVARCHAR2(50), 
	"SHAREREMAIL" NVARCHAR2(50), 
	"UPDATETIME" DATE, 
	"TENANTID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_TASKSUBCATEGORY
--------------------------------------------------------

  CREATE TABLE "TBL_TASKSUBCATEGORY" 
   (	"SUBCATEGORYCODE" NVARCHAR2(16), 
	"NAME" NVARCHAR2(100), 
	"DESCRIPTION" NVARCHAR2(510), 
	"MCATEGORYCODE" NVARCHAR2(16), 
	"OLDFLAG" NVARCHAR2(2), 
	"NAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_TASK_DEPTINFO
--------------------------------------------------------

  CREATE TABLE "TBL_TASK_DEPTINFO" 
   (	"CREATEDATE" DATE DEFAULT NULL, 
	"DESCRIPTION" NVARCHAR2(300), 
	"PROCESSDEPTNAME" NVARCHAR2(100), 
	"TASKTRANSFERFLAG" NVARCHAR2(2), 
	"TDEPTCODE" NVARCHAR2(14), 
	"PROCESSDEPTCODE" NVARCHAR2(20), 
	"PROCESSDATE" NVARCHAR2(24), 
	"APPLYDATE" NVARCHAR2(16), 
	"TASKCODE" NVARCHAR2(16), 
	"DELFLAG" NVARCHAR2(2) DEFAULT (0), 
	"DELETEDATE" DATE, 
	"ORGANCODE" NVARCHAR2(14), 
	"PROCESSDEPTNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" NVARCHAR2(20)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_TENANT
--------------------------------------------------------

  CREATE TABLE "TBL_TENANT" 
   (	"TENANT_ID" NUMBER(5,0), 
	"TENANT_NAME" NVARCHAR2(100), 
	"TENANT_NAME2" VARCHAR2(100 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_TENANT_CONFIG
--------------------------------------------------------

  CREATE TABLE "TBL_TENANT_CONFIG" 
   (	"TENANT_ID" NUMBER(5,0), 
	"PROPERTY_NAME" VARCHAR2(100 CHAR), 
	"PROPERTY_VALUE" NVARCHAR2(1000), 
	"DESCRIPTION" VARCHAR2(1000 BYTE) DEFAULT NULL, 
	"CONFIG_NAME" VARCHAR2(400 CHAR),
	"REGDATE" DATE, 
	"CONFIG_TYPE" VARCHAR2(100 CHAR) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_TENANT_SERVERNAME
--------------------------------------------------------

  CREATE TABLE "TBL_TENANT_SERVERNAME" 
   (	"SERVER_NAME" VARCHAR2(100 CHAR), 
	"TENANT_ID" NUMBER(5,0),
	"MAINYN" VARCHAR2(10) DEFAULT "N"
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_TMPAPRDOCATTACHINFO
--------------------------------------------------------

  CREATE TABLE "TBL_TMPAPRDOCATTACHINFO" 
   (	"OWNERID" VARCHAR2(100 CHAR), 
	"SN" NUMBER(10,0), 
	"ATTACHSN" NUMBER(10,0), 
	"ATTACHDOCNAME" NVARCHAR2(510), 
	"ATTACHDOCURL" NVARCHAR2(510), 
	"SUBATTACHYN" CHAR(1 CHAR), 
	"ATTACHUSERID" VARCHAR2(100 CHAR), 
	"ATTACHUSERNAME" NVARCHAR2(200), 
	"ATTACHUSERDEPTID" VARCHAR2(100 CHAR), 
	"ATTACHUSERDEPTNAME" NVARCHAR2(200), 
	"ATTACHUSERJOBTITLE" NVARCHAR2(100), 
	"ATTACHUSERNAME2" NVARCHAR2(100), 
	"ATTACHUSERJOBTITLE2" NVARCHAR2(100), 
	"ATTACHUSERDEPTNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_TMPAPRDOCINFO
--------------------------------------------------------

  CREATE TABLE "TBL_TMPAPRDOCINFO" 
   (	"OWNERID" VARCHAR2(100 CHAR), 
	"SN" NUMBER(10,0), 
	"FORMID" CHAR(10 CHAR), 
	"ORGDOCID" CHAR(20 CHAR), 
	"DOCTYPE" CHAR(3 CHAR), 
	"DOCSTATE" CHAR(3 CHAR), 
	"FUNCTIONTYPE" CHAR(3 CHAR), 
	"HREF" NVARCHAR2(510), 
	"DOCTITLE" NVARCHAR2(510), 
	"DOCNO" NVARCHAR2(100), 
	"HASATTACHYN" CHAR(1 CHAR), 
	"HASOPINIONYN" CHAR(1 CHAR), 
	"STARTDATE" DATE, 
	"ENDDATE" DATE, 
	"WRITERID" VARCHAR2(100 CHAR), 
	"WRITERNAME" NVARCHAR2(100), 
	"WRITERJOBTITLE" NVARCHAR2(100), 
	"WRITERDEPTID" VARCHAR2(100 CHAR), 
	"WRITERDEPTNAME" NVARCHAR2(100), 
	"ISPUBLIC" CHAR(1 CHAR), 
	"WRITERNAME2" NVARCHAR2(100), 
	"WRITERJOBTITLE2" NVARCHAR2(100), 
	"WRITERDEPTNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_TMPAPRLINEINFO
--------------------------------------------------------

  CREATE TABLE "TBL_TMPAPRLINEINFO" 
   (	"OWNERID" VARCHAR2(100 CHAR), 
	"SN" NUMBER(10,0), 
	"APRMEMBERSN" NUMBER(10,0), 
	"APRTYPE" CHAR(3 CHAR), 
	"APRSTATE" CHAR(3 CHAR), 
	"APRMEMBERID" VARCHAR2(100 CHAR), 
	"APRMEMBERISDEPTYN" CHAR(1 CHAR), 
	"APRMEMBERNAME" NVARCHAR2(100), 
	"APRMEMBERJOBTITLE" NVARCHAR2(100), 
	"APRMEMBERDEPTID" VARCHAR2(100 CHAR), 
	"APRMEMBERDEPTNAME" NVARCHAR2(100), 
	"APRMEMBERLDAPPATH" VARCHAR2(100 CHAR), 
	"RECEIVEDDATE" DATE, 
	"PROCESSDATE" DATE, 
	"REASONDONOTAPPROV" VARCHAR2(255 CHAR), 
	"ISPROPOSERYN" CHAR(1 CHAR), 
	"ISBRIEFUSERYN" CHAR(1 CHAR), 
	"APRMEMBERNAME2" NVARCHAR2(100), 
	"APRMEMBERJOBTITLE2" NVARCHAR2(100), 
	"APRMEMBERDEPTNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_TMPAPROPINIONINFO
--------------------------------------------------------

  CREATE TABLE "TBL_TMPAPROPINIONINFO" 
   (	"OWNERID" VARCHAR2(100 CHAR), 
	"SN" NUMBER(10,0), 
	"USERID" VARCHAR2(100 CHAR), 
	"OPINIONGB" CHAR(3 CHAR), 
	"CONTENT" NCLOB, 
	"USERNAME" NVARCHAR2(100), 
	"USERJOBTITLE" NVARCHAR2(100), 
	"USERDEPTID" VARCHAR2(100 CHAR), 
	"USERDEPTNAME" NVARCHAR2(100), 
	"OPINIONSN" NUMBER(10,0), 
	"USERNAME2" NVARCHAR2(100), 
	"USERJOBTITLE2" NVARCHAR2(100), 
	"USERDEPTNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_TMPATTACHINFO
--------------------------------------------------------

  CREATE TABLE "TBL_TMPATTACHINFO" 
   (	"OWNERID" VARCHAR2(100 CHAR), 
	"SN" NUMBER(10,0), 
	"ATTACHFILESN" NUMBER(10,0), 
	"VIEWORDER" NUMBER(10,0), 
	"ATTACHFILENAME" NVARCHAR2(510), 
	"ATTACHFILEHREF" NVARCHAR2(510), 
	"ATTACHFILESIZE" FLOAT(126), 
	"ATTACHUSERID" VARCHAR2(100 CHAR), 
	"ATTACHUSERNAME" NVARCHAR2(100), 
	"ATTACHUSERJOBTITLE" NVARCHAR2(100), 
	"ATTACHUSERDEPTID" VARCHAR2(100 CHAR), 
	"ATTACHUSERDEPTNAME" NVARCHAR2(100), 
	"PAGENUM" NUMBER(10,0), 
	"DISPLAYNAME" NVARCHAR2(510), 
	"BODYATTACH" CHAR(1 CHAR), 
	"ATTACHUSERNAME2" NVARCHAR2(100), 
	"ATTACHUSERJOBTITLE2" NVARCHAR2(100), 
	"ATTACHUSERDEPTNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(20 BYTE),
	"ISBIGATTACH" CHAR(1 CHAR) DEFAULT 'N',
	"ISBIGATTACHDEL" CHAR(1 CHAR) DEFAULT 'N',
	"SAVEDATE" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_TMPEXPAPRDOCINFO
--------------------------------------------------------

  CREATE TABLE "TBL_TMPEXPAPRDOCINFO" 
   (	"OWNERID" VARCHAR2(100 CHAR), 
	"SN" NUMBER(10,0), 
	"SECURITYCODE" NUMBER(10,0), 
	"STORAGEPERIOD" VARCHAR2(40 CHAR), 
	"KEYWORD" VARCHAR2(25 CHAR), 
	"FORMNAME" NVARCHAR2(510), 
	"COMPANYID" VARCHAR2(255 CHAR), 
	"ITEMCODE" VARCHAR2(40 CHAR), 
	"ITEMNAME" NVARCHAR2(200), 
	"URGENTAPPROVAL" CHAR(1 CHAR), 
	"SECURITYAPPROVAL" CHAR(10 CHAR), 
	"TEMPATTRIBUTE" VARCHAR2(100 CHAR), 
	"STATUS" CHAR(1 CHAR), 
	"SPECIALRECORDCODE" CHAR(5 CHAR), 
	"PUBLICITYCODE" CHAR(9 CHAR), 
	"LIMITRANGE" VARCHAR2(100 CHAR), 
	"PAGENUM" NUMBER(10,0), 
	"CABINETID" VARCHAR2(112 BYTE), 
	"TASKCODE" CHAR(8 CHAR), 
	"DOCNUMCODE" CHAR(13 CHAR), 
	"ORGDOCNUMCODE" CHAR(13 CHAR), 
	"SEPERATEATTACHXML" NCLOB, 
	"SUMMARY" NCLOB, 
	"FORMNAME2" NVARCHAR2(510), 
	"ITEMNAME2" NVARCHAR2(200), 
	"TENANT_ID" NUMBER(5,0), 
	"PUBLICITYYN" CHAR(2 BYTE), 
	"FORMVERSION" NUMBER(10,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_TMPEXPAPRLINE
--------------------------------------------------------

  CREATE TABLE "TBL_TMPEXPAPRLINE" 
   (	"OWNERID" VARCHAR2(100 CHAR), 
	"SN" NUMBER(10,0), 
	"APRMEMBERSN" NUMBER(10,0), 
	"ORGUSERID" VARCHAR2(100 CHAR), 
	"PROXYUSERID" VARCHAR2(100 CHAR), 
	"PROXYUSERNAME" NVARCHAR2(100), 
	"PROXYUSERJOBTITLE" NVARCHAR2(100), 
	"PROXYUSERDEPTID" VARCHAR2(100 CHAR), 
	"PROXYUSERDEPTNAME" NVARCHAR2(100), 
	"PROXYUSERNAME2" NVARCHAR2(100), 
	"PROXYUSERJOBTITLE2" NVARCHAR2(100), 
	"PROXYUSERDEPTNAME2" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_TMPRECEIPTPOINTINFO
--------------------------------------------------------

  CREATE TABLE "TBL_TMPRECEIPTPOINTINFO" 
   (	"OWNERID" VARCHAR2(100 CHAR), 
	"SN" NUMBER(10,0), 
	"RECEIPTPOINTID" VARCHAR2(100 CHAR), 
	"RECEIPTPOINTNAME" VARCHAR2(100 CHAR), 
	"EXTRECEPTYN" CHAR(1 CHAR), 
	"PROCESSYN" CHAR(1 CHAR), 
	"PROCESSSN" NUMBER(10,0), 
	"CANEDITYN" CHAR(1 CHAR), 
	"EXTRECEPTEMAIL" VARCHAR2(100 CHAR), 
	"RECEIPTMEMBERID" VARCHAR2(100 CHAR), 
	"RECEIPTMEMBERNAME" VARCHAR2(40 CHAR), 
	"PROCESSDATE" DATE, 
	"RECEIPTMEMBERJOBTITLE" VARCHAR2(20 CHAR), 
	"DEPTMEMBERSN" NUMBER(10,0), 
	"RECEIPTPOINTNAME2" NVARCHAR2(100), 
	"RECEIPTMEMBERJOBTITLE2" NVARCHAR2(100), 
	"RECEIPTMEMBERNAME2" NVARCHAR2(100), 
	"ROUTEYN" CHAR(1 CHAR), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_USERCONT
--------------------------------------------------------

  CREATE TABLE "TBL_USERCONT" 
   (	"USERCONTID" VARCHAR2(20 BYTE), 
	"USERCONTNAME" VARCHAR2(255 BYTE), 
	"PARENTCONTID" VARCHAR2(20 BYTE), 
	"DESCRIPTION" VARCHAR2(255 BYTE), 
	"OWNUSERID" VARCHAR2(100 BYTE), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_USERCONTLIST
--------------------------------------------------------

  CREATE TABLE "TBL_USERCONTLIST" 
   (	"DOCID" VARCHAR2(20 BYTE), 
	"USERCONTID" VARCHAR2(20 BYTE), 
	"LINKDATE" DATE, 
	"DESCRIPTION" VARCHAR2(255 BYTE), 
	"TENANT_ID" NUMBER, 
	"COMPANYID" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_USERLOCALINFO
--------------------------------------------------------

  CREATE TABLE "TBL_USERLOCALINFO" 
   (	"USERID" VARCHAR2(50 CHAR), 
	"TIMEZONE" CHAR(10 CHAR), 
	"LANG" CHAR(1 CHAR), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_USERMASTER
--------------------------------------------------------

  CREATE TABLE "TBL_USERMASTER" 
   (	"CN" NVARCHAR2(80), 
	"DISPLAYNAME" NVARCHAR2(120), 
	"DISPLAYNAME2" NVARCHAR2(120), 
	"MAIL" NVARCHAR2(100), 
	"MAILNICKNAME" NVARCHAR2(100), 
	"UPNNAME" NVARCHAR2(400), 
	"DEPARTMENT" NVARCHAR2(80), 
	"DESCRIPTION" NVARCHAR2(200), 
	"DESCRIPTION2" NVARCHAR2(200), 
	"DESCRIPTION3" NVARCHAR2(200), 
	"PHYSICALDELIVERYOFFICENAME" NVARCHAR2(160), 
	"COMPANY" NVARCHAR2(200), 
	"COMPANY2" NVARCHAR2(200), 
	"TITLE" NVARCHAR2(200), 
	"TITLE2" NVARCHAR2(200), 
	"TELEPHONENUMBER" NVARCHAR2(100), 
	"HOMEPHONE" NVARCHAR2(100), 
	"FACSIMILETELEPHONENUMBER" NVARCHAR2(100), 
	"MOBILE" NVARCHAR2(100), 
	"POSTALCODE" NVARCHAR2(100), 
	"STREETADDRESS" NVARCHAR2(400), 
	"INFO" NVARCHAR2(2000), 
	"EXTENSIONATTRIBUTE1" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE2" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE3" NVARCHAR2(2000), 
	"EXTENSIONATTRIBUTE4" NVARCHAR2(2000), 
	"EXTENSIONATTRIBUTE5" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE6" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE7" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE8" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE9" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE10" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE102" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE11" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE12" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE13" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE14" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE15" NVARCHAR2(200), 
	"ADSPATH" NVARCHAR2(200), 
	"SIPURI" NVARCHAR2(100), 
	"UPDATEDT" DATE, 
	"CREATEDT" DATE, 
	"MOBILE_ENABLE" NVARCHAR2(4), 
	"MOBILE_NOTUSE" NVARCHAR2(4) DEFAULT 'N', 
	"MOBILE_PIN" NVARCHAR2(4), 
	"POSITIONCD" NVARCHAR2(40), 
	"BIRTH" NVARCHAR2(20), 
	"BIRTHTYPE" NVARCHAR2(4), 
	"PASSWORD" NVARCHAR2(100), 
	"IPADDRESS" NVARCHAR2(15), 
	"LASTLOGIN" DATE, 
	"LOGINCNT" NUMBER(10,0) DEFAULT 0, 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"LISTTYPE" VARCHAR2(3 BYTE) DEFAULT 'TXT', 
	"MANUAL_FLAG" NVARCHAR2(4) DEFAULT NULL, 
	"PASSWORD_UPDATEDT" DATE DEFAULT NULL, 
	"MAILBOXQUOTA" VARCHAR2(50 BYTE) DEFAULT NULL, 
	"MAILBOXUSAGE" VARCHAR2(50 BYTE) DEFAULT NULL, 
	"FURIGANA" VARCHAR2(120 CHAR), 
	"EXTENSIONPHONE" VARCHAR2(100 CHAR), 
	"OFFICEMOBILE" VARCHAR2(100 CHAR),
	"PHOTO_UPDATEDT" DATE DEFAULT NULL,
    "USERTREEFLAG" char(1) DEFAULT 'Y'
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_USERMASTER_DELETE
--------------------------------------------------------

  CREATE TABLE "TBL_USERMASTER_DELETE" 
   (	"CN" NVARCHAR2(80), 
	"DISPLAYNAME" NVARCHAR2(120), 
	"DISPLAYNAME2" NVARCHAR2(120), 
	"MAIL" NVARCHAR2(100), 
	"MAILNICKNAME" NVARCHAR2(100), 
	"UPNNAME" NVARCHAR2(400), 
	"DEPARTMENT" NVARCHAR2(80), 
	"DESCRIPTION" NVARCHAR2(200), 
	"DESCRIPTION2" NVARCHAR2(200), 
	"DESCRIPTION3" NVARCHAR2(200), 
	"PHYSICALDELIVERYOFFICENAME" NVARCHAR2(160), 
	"COMPANY" NVARCHAR2(200), 
	"COMPANY2" NVARCHAR2(200), 
	"TITLE" NVARCHAR2(200), 
	"TITLE2" NVARCHAR2(200), 
	"TELEPHONENUMBER" NVARCHAR2(100), 
	"HOMEPHONE" NVARCHAR2(100), 
	"FACSIMILETELEPHONENUMBER" NVARCHAR2(100), 
	"MOBILE" NVARCHAR2(100), 
	"POSTALCODE" NVARCHAR2(100), 
	"STREETADDRESS" NVARCHAR2(400), 
	"INFO" NVARCHAR2(2000), 
	"EXTENSIONATTRIBUTE1" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE2" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE3" NVARCHAR2(2000), 
	"EXTENSIONATTRIBUTE4" NVARCHAR2(2000), 
	"EXTENSIONATTRIBUTE5" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE6" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE7" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE8" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE9" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE10" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE102" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE11" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE12" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE13" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE14" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE15" NVARCHAR2(200), 
	"ADSPATH" NVARCHAR2(200), 
	"UPDATEDT" DATE, 
	"MOBILE_ENABLE" NVARCHAR2(4), 
	"MOBILE_NOTUSE" NVARCHAR2(4), 
	"MOBILE_PIN" NVARCHAR2(4), 
	"SIPURI" NVARCHAR2(200), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"PASSWORD" NVARCHAR2(100)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_USERMASTER_RETIRE
--------------------------------------------------------

  CREATE TABLE "TBL_USERMASTER_RETIRE" 
   (	"CN" NVARCHAR2(80), 
	"DISPLAYNAME" NVARCHAR2(120), 
	"DISPLAYNAME2" NVARCHAR2(120), 
	"MAIL" NVARCHAR2(100), 
	"MAILNICKNAME" NVARCHAR2(100), 
	"UPNNAME" NVARCHAR2(400), 
	"DEPARTMENT" NVARCHAR2(80), 
	"DESCRIPTION" NVARCHAR2(200), 
	"DESCRIPTION2" NVARCHAR2(200), 
	"DESCRIPTION3" NVARCHAR2(200), 
	"PHYSICALDELIVERYOFFICENAME" NVARCHAR2(160), 
	"COMPANY" NVARCHAR2(200), 
	"COMPANY2" NVARCHAR2(200), 
	"TITLE" NVARCHAR2(200), 
	"TITLE2" NVARCHAR2(200), 
	"TELEPHONENUMBER" NVARCHAR2(100), 
	"HOMEPHONE" NVARCHAR2(100), 
	"FACSIMILETELEPHONENUMBER" NVARCHAR2(100), 
	"MOBILE" NVARCHAR2(100), 
	"POSTALCODE" NVARCHAR2(100), 
	"STREETADDRESS" NVARCHAR2(400), 
	"INFO" NVARCHAR2(2000), 
	"EXTENSIONATTRIBUTE1" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE2" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE3" NVARCHAR2(2000), 
	"EXTENSIONATTRIBUTE4" NVARCHAR2(2000), 
	"EXTENSIONATTRIBUTE5" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE6" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE7" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE8" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE9" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE10" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE102" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE11" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE12" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE13" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE14" NVARCHAR2(200), 
	"EXTENSIONATTRIBUTE15" NVARCHAR2(200), 
	"ADSPATH" NVARCHAR2(200), 
	"SIPURI" NVARCHAR2(100), 
	"UPDATEDT" DATE, 
	"CREATEDT" DATE, 
	"MOBILE_ENABLE" NVARCHAR2(4), 
	"MOBILE_NOTUSE" NVARCHAR2(4) DEFAULT 'N', 
	"MOBILE_PIN" NVARCHAR2(4), 
	"POSITIONCD" NVARCHAR2(40), 
	"BIRTH" NVARCHAR2(20), 
	"BIRTHTYPE" NVARCHAR2(4), 
	"PASSWORD" NVARCHAR2(100), 
	"IPADDRESS" NVARCHAR2(15), 
	"LASTLOGIN" DATE, 
	"LOGINCNT" NUMBER(10,0) DEFAULT 0, 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0, 
	"LISTTYPE" VARCHAR2(3 BYTE) DEFAULT 'TXT', 
	"MANUAL_FLAG" NVARCHAR2(4) DEFAULT NULL, 
	"PASSWORD_UPDATEDT" DATE DEFAULT NULL, 
	"MAILBOXQUOTA" VARCHAR2(50 BYTE) DEFAULT NULL, 
	"MAILBOXUSAGE" VARCHAR2(50 BYTE) DEFAULT NULL, 
	"FURIGANA" VARCHAR2(120 CHAR), 
	"EXTENSIONPHONE" VARCHAR2(100 CHAR), 
	"OFFICEMOBILE" VARCHAR2(100 CHAR),
	"PHOTO_UPDATEDT" DATE DEFAULT NULL,
    "USERTREEFLAG" char(1) DEFAULT 'Y'
   ) ;

--------------------------------------------------------
--  DDL for Table TBL_USERMOBILEINFO
--------------------------------------------------------

  CREATE TABLE "TBL_USERMOBILEINFO" 
   (	"USERID" VARCHAR2(200 BYTE), 
	"TIMEZONE" VARCHAR2(40 BYTE), 
	"LANG" VARCHAR2(4 BYTE), 
	"MAINTYPE" CHAR(1 BYTE), 
	"LISTCNT" NUMBER(7,0), 
	"USESECURITY" CHAR(1 BYTE), 
	"TENANT_ID" NUMBER(7,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_USER_CONFIG
--------------------------------------------------------

  CREATE TABLE "TBL_USER_CONFIG" 
   (	"TENANT_ID" NUMBER(5,0), 
	"USER_ID" NVARCHAR2(40), 
	"PROPERTY_NAME" NVARCHAR2(50), 
	"PROPERTY_VALUE" NVARCHAR2(1000)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_USER_JOBMASTER
--------------------------------------------------------

  CREATE TABLE "TBL_USER_JOBMASTER" 
   (	"JOBID" NUMBER(10,0), 
	"TYPE" NVARCHAR2(50), 
	"CN" NVARCHAR2(100), 
	"DISPLAYNAME" NVARCHAR2(200), 
	"DISPLAYNAME2" NVARCHAR2(200), 
	"USEFLAG" NVARCHAR2(2), 
	"SORT" NUMBER(10,0), 
	"CREATEDATE" DATE, 
	"COMPANYID" VARCHAR2(40 BYTE), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_USER_MULTILOGIN
--------------------------------------------------------

  CREATE TABLE "TBL_USER_MULTILOGIN" 
   (	"TENANT_ID" NUMBER, 
	"USER_ID" NVARCHAR2(40), 
	"LOGIN_TIME" VARCHAR2(15 BYTE),
	"MOBILE_FLAG" NUMBER(1, 0) DEFAULT 0
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_USER_NOTI_DISABLE_ITEM
--------------------------------------------------------

  CREATE TABLE "TBL_USER_NOTI_DISABLE_ITEM"
   (	"USER_ID" NVARCHAR2(80) NOT NULL,
	"MAIN_TYPE" NUMBER(2) NOT NULL,
	"SUB_TYPE" NUMBER(2) NOT NULL,
	"PLATFORM" NUMBER(1) NOT NULL,
	"TENANT_ID" NUMBER(5) NOT NULL,
	CONSTRAINT "TBL_USER_NOTI_DISABLE_ITEM_PK" PRIMARY KEY (user_id, main_type, sub_type, platform, tenant_id)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_VOTE_ANSWER
--------------------------------------------------------

  CREATE TABLE "TBL_VOTE_ANSWER" 
   (	"ID" NUMBER(9,0), 
	"QST_ID" NUMBER(9,0), 
	"TENANT_ID" NUMBER(9,0), 
	"CONTENT" VARCHAR2(500 BYTE), 
	"VOTES_NUM" NUMBER(11,0) DEFAULT 0, 
	"FILE_PATH" CLOB
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_VOTE_COMMENT
--------------------------------------------------------

  CREATE TABLE "TBL_VOTE_COMMENT" 
   (	"ID" NUMBER(11,0), 
	"QST_ID" NUMBER(11,0), 
	"TENANT_ID" NUMBER(11,0), 
	"USER_ID" VARCHAR2(50 BYTE), 
	"USER_NAME1" VARCHAR2(240 BYTE), 
	"USER_NAME2" VARCHAR2(240 BYTE), 
	"TEXT_CONTENT" VARCHAR2(1000 BYTE) DEFAULT NULL, 
	"IMAGE_TYPE" VARCHAR2(100 BYTE), 
	"FILE_TYPE" VARCHAR2(500 BYTE), 
	"FILE_NAME" VARCHAR2(500 BYTE), 
	"FILE_PATH" VARCHAR2(500 BYTE), 
	"CMT_TIME" VARCHAR2(100 BYTE), 
	"DEPT_ID" VARCHAR2(50 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_VOTE_CONFIGURATION
--------------------------------------------------------

  CREATE TABLE "TBL_VOTE_CONFIGURATION" 
   (	"USER_ID" VARCHAR2(100 BYTE), 
	"START_TIME" VARCHAR2(50 BYTE), 
	"END_TIME" VARCHAR2(50 BYTE), 
	"TARGET_DEPTS" VARCHAR2(1000 BYTE), 
	"TARGET_USERS" VARCHAR2(1000 BYTE), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_VOTE_QUESTION
--------------------------------------------------------

  CREATE TABLE "TBL_VOTE_QUESTION" 
   (	"ID" NUMBER(9,0), 
	"TENANT_ID" NUMBER(9,0), 
	"CONTENT" CLOB, 
	"MULTI_SELECT" NUMBER(4,0) DEFAULT 0, 
	"CREATE_DATE" VARCHAR2(38 BYTE), 
	"START_DATE" VARCHAR2(38 BYTE), 
	"END_DATE" VARCHAR2(38 BYTE), 
	"TARGET" NUMBER(4,0) DEFAULT 0, 
	"TITLE" VARCHAR2(500 BYTE), 
	"SECRET_VOTE" NUMBER(4,0) DEFAULT 0, 
	"CREATOR" VARCHAR2(160 BYTE) DEFAULT 0, 
	"CREATOR_NAME1" VARCHAR2(240 BYTE), 
	"CREATOR_NAME2" VARCHAR2(240 BYTE), 
	"FILE_PATH" CLOB, 
	"RESULT_FIRST" NUMBER(4,0) DEFAULT 1, 
	"IS_MODIFYING" NUMBER(4,0) DEFAULT 0, 
	"SET_DATE" NUMBER(4,0) DEFAULT 0, 
	"IS_SORTING" NUMBER(4,0) DEFAULT 0, 
	"IS_SELONLYONCE" NUMBER(4,0) DEFAULT 0, 
	"SENDPOSTNOTICE" NUMBER(4,0) DEFAULT 0, 
	"OPENTOALL" NUMBER(4,0) DEFAULT 0, 
	"VOTEOPTION1" NUMBER(4,0) DEFAULT 0, 
	"VOTEOPTION2" NUMBER(4,0) DEFAULT 0, 
	"VOTEOPTION3" NUMBER(4,0) DEFAULT 0, 
	"VOTEOPTION4" NUMBER(4,0) DEFAULT 0, 
	"CREATOR_DEPT" VARCHAR2(80 BYTE), 
	"COMPANYID" VARCHAR2(80 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_VOTE_QUESTION_RELATED
--------------------------------------------------------

  CREATE TABLE "TBL_VOTE_QUESTION_RELATED" 
   (	"QST_ID" NUMBER(11,0), 
	"USER_ID" VARCHAR2(50 BYTE), 
	"TENANT_ID" NUMBER(11,0), 
	"SEEN" NUMBER(4,0) DEFAULT 0, 
	"COMMENT" NUMBER(4,0) DEFAULT 0, 
	"HIDE" NUMBER(4,0) DEFAULT 0, 
	"MODIFYING" NUMBER(4,0) DEFAULT 0, 
	"COMPANYID" VARCHAR2(80 BYTE), 
	"DEPT_ID" VARCHAR2(50 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_VOTE_USER_AND_ANSWER
--------------------------------------------------------

  CREATE TABLE "TBL_VOTE_USER_AND_ANSWER" 
   (	"ANS_ID" NUMBER(9,0), 
	"QST_ID" NUMBER(9,0), 
	"USER_ID" VARCHAR2(80 BYTE), 
	"TENANT_ID" NUMBER(9,0), 
	"USER_NAME1" VARCHAR2(240 BYTE), 
	"USER_NAME2" VARCHAR2(240 BYTE), 
	"VOTE_DATE" VARCHAR2(70 BYTE), 
	"DEPT_ID" VARCHAR2(50 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_VOTE_USER_AND_QUESTION
--------------------------------------------------------

  CREATE TABLE "TBL_VOTE_USER_AND_QUESTION" 
   (	"QST_ID" NUMBER(11,0), 
	"USER_ID" VARCHAR2(50 BYTE), 
	"TENANT_ID" NUMBER(11,0), 
	"USER_TYPE" VARCHAR2(100 BYTE) DEFAULT 0, 
	"COMPANYID" VARCHAR2(80 BYTE), 
	"DEPT_ID" VARCHAR2(50 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_WEATHER
--------------------------------------------------------

  CREATE TABLE "TBL_WEATHER" 
   (	"SN" VARCHAR2(3 BYTE), 
	"CITYCODE" VARCHAR2(20 BYTE), 
	"CITYNAME" VARCHAR2(50 BYTE) DEFAULT NULL, 
	"DISPLAYCITYNAME" VARCHAR2(50 BYTE), 
	"PRIMARYLANG" VARCHAR2(10 BYTE), 
	"CURRENTWEATHER" VARCHAR2(200 BYTE) DEFAULT NULL, 
	"TODAYWEATHER" VARCHAR2(500 BYTE) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_WEATHER_USER
--------------------------------------------------------

  CREATE TABLE "TBL_WEATHER_USER" 
   (	"USERID" VARCHAR2(80 BYTE), 
	"TENANT_ID" NUMBER(5,0), 
	"CITYCODE" VARCHAR2(45 BYTE) DEFAULT NULL,
    "COUNTRYCODE" VARCHAR(2 BYTE) DEFAULT NULL
   ) ;

--------------------------------------------------------
--  DDL for Table TBL_WEATHER_CITY
--	2024.04.09 박문송
--		- 사용자 언어 설정에 따라 해당 언어로 지역 이름이 보이도록 하기 위한 테이블
--------------------------------------------------------

CREATE TABLE "TBL_WEATHER_CITY" (
    "CITYCODE" VARCHAR2(20 BYTE) NOT NULL,
    "DISPLAYCITYNAME" VARCHAR2(50 BYTE),
    "USERLOCALLANG" VARCHAR(10 BYTE)
);

--------------------------------------------------------
--  DDL for Table TBL_WEBFOLDER_CONFIG
--------------------------------------------------------

  CREATE TABLE "TBL_WEBFOLDER_CONFIG" 
   (	"TENANT_ID" NUMBER(7,0), 
	"COMPANY_ID" VARCHAR2(100 BYTE), 
	"UPLOAD_LIMIT" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"USER_TOTAL_LIMIT" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"COMPANY_TOTAL_LIMIT" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"DEPARTMENT_TOTAL_LIMIT" VARCHAR2(100 BYTE) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_WEBFOLDER_ENCRYPTED_FILE
--------------------------------------------------------

  CREATE TABLE "TBL_WEBFOLDER_ENCRYPTED_FILE" 
   (	"FILE_ID" VARCHAR2(100 BYTE), 
	"VERSION" NUMBER(7,0), 
	"TENANT_ID" NUMBER(7,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_WEBFOLDER_ENC_FOLDER
--------------------------------------------------------

  CREATE TABLE "TBL_WEBFOLDER_ENC_FOLDER" 
   (	"FOLDER_ID" NUMBER(11,0), 
	"TENANT_ID" NUMBER(7,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_WEBFOLDER_ENV
--------------------------------------------------------

  CREATE TABLE "TBL_WEBFOLDER_ENV" 
   (	"CN" VARCHAR2(100 BYTE), 
	"ENV_TYPE" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"ENV_VALUE" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"TENANT_ID" NUMBER(7,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_WEBFOLDER_FAVOR
--------------------------------------------------------

  CREATE TABLE "TBL_WEBFOLDER_FAVOR" 
   (	"TARGET_ID" NUMBER(11,0), 
	"USER_ID" VARCHAR2(80 BYTE), 
	"TARGET_TYPE" VARCHAR2(50 BYTE), 
	"CREATE_DATE" DATE, 
	"TENANT_ID" NUMBER(7,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_WEBFOLDER_FILE
--------------------------------------------------------

  CREATE TABLE "TBL_WEBFOLDER_FILE" 
   (	"FILE_ID" NUMBER(11,0), 
	"FILE_NAME" VARCHAR2(250 BYTE), 
	"FILE_PATH" VARCHAR2(250 BYTE), 
	"FILE_SIZE" NUMBER, 
	"TYPE_ID" VARCHAR2(100 BYTE), 
	"DOWN_COUNT" NUMBER(19,0), 
	"FILE_EXT" VARCHAR2(10 BYTE), 
	"FOLDER_ID" NUMBER(11,0), 
	"USE_STATUS" VARCHAR2(250 BYTE), 
	"CREATE_ID" VARCHAR2(80 BYTE), 
	"CREATE_NAME1" VARCHAR2(120 BYTE), 
	"CREATE_NAME2" VARCHAR2(120 BYTE), 
	"CREATE_DATE" DATE, 
	"UPDATE_ID" VARCHAR2(80 BYTE), 
	"UPDATE_DATE" DATE, 
	"DELETER_ID" VARCHAR2(100 BYTE), 
	"TENANT_ID" NUMBER(7,0), 
	"VERSION" NUMBER(7,0) DEFAULT 1, 
	"DEPTH" NUMBER(7,0) DEFAULT 1, 
	"ROOT_ID" VARCHAR2(100 BYTE), 
	"PARENT_ID" VARCHAR2(100 BYTE), 
	"HIERARCHICAL_PATH" VARCHAR2(300 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_WEBFOLDER_FILETYPE
--------------------------------------------------------

  CREATE TABLE "TBL_WEBFOLDER_FILETYPE" 
   (	"TYPE_ID" VARCHAR2(100 BYTE), 
	"TYPE_NAME" VARCHAR2(80 BYTE), 
	"FILE_EXT" VARCHAR2(80 BYTE), 
	"TYPE_ICON" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"TENANT_ID" NUMBER(7,0), 
	"TYPE_NAME2" VARCHAR2(80 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_WEBFOLDER_FILEUSER
--------------------------------------------------------

  CREATE TABLE "TBL_WEBFOLDER_FILEUSER" 
   (	"SEQ_ID" NUMBER(11,0), 
	"FILE_ID" NUMBER(11,0), 
	"USER_ID" VARCHAR2(100 BYTE), 
	"USER_TYPE" VARCHAR2(50 BYTE), 
	"CREATE_ID" VARCHAR2(100 BYTE), 
	"CREATE_DATE" DATE, 
	"COMPANY_ID" VARCHAR2(50 BYTE), 
	"TENANT_ID" NUMBER(7,0), 
	"SUBDEPT_PERMITTED" NUMBER(11,0) DEFAULT '0'
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_WEBFOLDER_FILE_HISTORY
--------------------------------------------------------

  CREATE TABLE "TBL_WEBFOLDER_FILE_HISTORY" 
   (	"FILE_ID" NUMBER(11,0),
    "FILE_NAME" VARCHAR2(250 BYTE),
	"VERSION" NUMBER(7,0) DEFAULT 1,
	"FILE_PATH" VARCHAR2(250 BYTE), 
	"FILE_SIZE" NUMBER, 
	"USE_STATUS" VARCHAR2(250 BYTE) DEFAULT 'Y', 
	"UPDATE_DATE" DATE, 
	"UPDATE_ID" VARCHAR2(80 BYTE), 
	"UPDATE_NAME" VARCHAR2(120 BYTE), 
	"UPDATE_NAME2" VARCHAR2(120 BYTE), 
	"DELETER_ID" VARCHAR2(100 BYTE), 
	"TENANT_ID" NUMBER(7,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_WEBFOLDER_FOLDER
--------------------------------------------------------

  CREATE TABLE "TBL_WEBFOLDER_FOLDER" 
   (	"FOLDER_ID" NUMBER(11,0), 
	"FOLDER_NAME1" VARCHAR2(200 BYTE), 
	"FOLDER_NAME2" VARCHAR2(200 BYTE) DEFAULT NULL, 
	"FOLDER_TYPE" VARCHAR2(50 BYTE), 
	"FOLDER_PATH" VARCHAR2(200 BYTE) DEFAULT NULL, 
	"FOLDER_STEP" NUMBER(19,0), 
	"FOLDER_LEVEL" NUMBER(19,0), 
	"FOLDER_UPPER" VARCHAR2(50 BYTE) DEFAULT NULL, 
	"USE_STATUS" VARCHAR2(5 BYTE) DEFAULT NULL, 
	"OWNER_ID" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"CREATE_ID" VARCHAR2(100 BYTE), 
	"CREATE_DATE" DATE, 
	"CREATE_NAME1" VARCHAR2(100 BYTE), 
	"CREATE_NAME2" VARCHAR2(100 BYTE), 
	"UPDATE_ID" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"UPDATE_DATE" DATE DEFAULT NULL, 
	"COMPANY_ID" VARCHAR2(100 BYTE), 
	"DELETER_ID" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"TENANT_ID" NUMBER(7,0), 
	"FOLDER_SUBTYPE" VARCHAR2(50 BYTE) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_WEBFOLDER_FOLDERUSER
--------------------------------------------------------

  CREATE TABLE "TBL_WEBFOLDER_FOLDERUSER" 
   (	"SEQ_ID" NUMBER(11,0), 
	"USER_ID" VARCHAR2(100 BYTE), 
	"USER_TYPE" VARCHAR2(50 BYTE), 
	"FOLDER_ID" NUMBER(11,0), 
	"CREATE_ID" VARCHAR2(100 BYTE), 
	"CREATE_DATE" DATE, 
	"COMPANY_ID" VARCHAR2(50 BYTE), 
	"TENANT_ID" NUMBER(7,0), 
	"SUBDEPT_PERMITTED" NUMBER(11,0) DEFAULT '0', 
	"FOLDER_MANAGER" NUMBER(11,0) DEFAULT '0'
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_WEBFOLDER_LOG
--------------------------------------------------------

  CREATE TABLE "TBL_WEBFOLDER_LOG" 
   (	"LOG_ID" VARCHAR2(200 BYTE), 
	"FILE_TYPE" VARCHAR2(200 BYTE), 
	"FILE_NAME" VARCHAR2(200 BYTE), 
	"FILE_SIZE" NUMBER, 
	"FILE_EXT" VARCHAR2(10 BYTE), 
	"LOG_TYPE" VARCHAR2(200 BYTE), 
	"CREATE_ID" VARCHAR2(200 BYTE), 
	"CREATE_NAME1" VARCHAR2(200 BYTE), 
	"CREATE_NAME2" VARCHAR2(200 BYTE), 
	"CREATE_DATE" DATE, 
	"COMPANY_ID" VARCHAR2(200 BYTE), 
	"TENANT_ID" NUMBER(7,0), 
	"FILE_ID" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"VERSION" NUMBER(7,0) DEFAULT NULL, 
	"FOLDER_ID" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"FOLDER_NAME" VARCHAR2(200 BYTE) DEFAULT NULL, 
	"FOLDER_PATH" VARCHAR2(200 BYTE) DEFAULT NULL, 
	"FOLDER_PATH_NAME" VARCHAR2(500 BYTE) DEFAULT NULL, 
	"TOP_FOLDER_ID" VARCHAR2(100 BYTE) DEFAULT NULL, 
	"TOP_FOLDER_NAME" VARCHAR2(200 BYTE) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_WEBFOLDER_SHARE
--------------------------------------------------------

  CREATE TABLE "TBL_WEBFOLDER_SHARE" 
   (	"SHARE_ID" NUMBER(19,0), 
	"SHARER_ID" VARCHAR2(80 CHAR), 
	"SHARER_NAME1" VARCHAR2(120 CHAR), 
	"SHARER_NAME2" VARCHAR2(120 CHAR), 
	"FOLDERFILE_ID" VARCHAR2(100 CHAR), 
	"FOLDERFILE_TYPE" VARCHAR2(5 CHAR), 
	"USER_NAME_LIST" VARCHAR2(300 CHAR), 
	"SHARE_DATE" DATE, 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_WEBFOLDER_SHARE_HIDE
--------------------------------------------------------

  CREATE TABLE "TBL_WEBFOLDER_SHARE_HIDE" 
   (	"SEQ_ID" NUMBER(19,0), 
	"SHARE_ID" NUMBER(19,0), 
	"USER_ID" VARCHAR2(80 CHAR), 
	"USER_NAME1" VARCHAR2(120 CHAR), 
	"USER_NAME2" VARCHAR2(120 CHAR), 
	"HIDE_DATE" DATE, 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_WEBFOLDER_SHARE_SUB
--------------------------------------------------------

  CREATE TABLE "TBL_WEBFOLDER_SHARE_SUB" 
   (	"SEQ_ID" NUMBER(10,0), 
	"SHARE_ID" NUMBER(10,0), 
	"USER_ID" VARCHAR2(80 CHAR), 
	"USER_NAME1" VARCHAR2(120 CHAR), 
	"USER_NAME2" VARCHAR2(120 CHAR), 
	"USER_TYPE" VARCHAR2(5 CHAR), 
	"TENANT_ID" NUMBER(5,0)
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_WEBFOLDER_TOKEN
--------------------------------------------------------

  CREATE TABLE "TBL_WEBFOLDER_TOKEN" 
   (	"USERID" VARCHAR2(32 BYTE), 
	"LTOKEN" VARCHAR2(128 BYTE) DEFAULT NULL, 
	"REGDATA" DATE DEFAULT NULL, 
	"COMPID" VARCHAR2(32 BYTE) DEFAULT NULL, 
	"TENANTID" VARCHAR2(45 BYTE), 
	"DEVICE" VARCHAR2(128 BYTE) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table TBL_WEBFOLDER_USER
--------------------------------------------------------

  CREATE TABLE "TBL_WEBFOLDER_USER" 
   (	"CN" VARCHAR2(80 BYTE), 
	"TOTAL_CAPACITY" VARCHAR2(250 BYTE) DEFAULT NULL, 
	"COMPANY_ID" VARCHAR2(50 BYTE), 
	"TENANT_ID" NUMBER(7,0), 
	"TYPE" VARCHAR2(50 BYTE)
   ) ;
   
   CREATE TABLE "TBL_WEBFOLDER_NO_INHERIT"
   (
			"FOLDER_ID" VARCHAR2(100 BYTE) NOT NULL,
			"TENANT_ID" NUMBER(7, 0) NOT NULL,
			CONSTRAINT WEBFOLDER_NO_INHERIT_PK PRIMARY KEY ("FOLDER_ID", "TENANT_ID")
	);
-----------------------	---------------------------------
--  DDL for Table TBL_WEBFOLDER_APPLY_HISTORY
--------------------------------------------------------

  CREATE TABLE "TBL_WEBFOLDER_APPLY_HISTORY" 
   (	"APPLY_ID" NVARCHAR2(40), 
	"TENANT_ID" NUMBER(5,0), 
	"COMPANY_ID" NVARCHAR2(80), 
	"FOLDER_NAME" NVARCHAR2(200), 
	"CONTENT" NVARCHAR2(1000), 
	"APPLICATION_DATE" DATE, 
	"APPROVAL_STATUS" NVARCHAR2(10), 
	"APPROVAL_STATUS_UPDATEDT" DATE
   ) ;
-----------------------	---------------------------------
--  DDL for Table TBL_WEBFOLDER_APPLY_HIST_MEM
--------------------------------------------------------

  CREATE TABLE "TBL_WEBFOLDER_APPLY_HIST_MEM" 
   (	"APPLY_ID" NVARCHAR2(40), 
	"MEMBER_ID" NVARCHAR2(80), 
	"MEMBER_NAME" NVARCHAR2(200), 
	"MEMBER_TYPE" NVARCHAR2(10), 
	"MEMBER_ITEM" NVARCHAR2(10)
   ) ;
-------------------------------------------------------- 
--  DDL for Table JMOCHA_MAIL_OUTOFOFFICE_TEM
--------------------------------------------------------

  CREATE TABLE "JMOCHA_MAIL_OUTOFOFFICE_TEM" 
   (	
    "USER_ID" NVARCHAR2(100), 
	"DISPLAYNAME" NVARCHAR2(40), 
	"CONTENT" LONG
   );   
-------------------------------------------------------- 
--  DDL for Table JMOCHA_USER_MAIL_TEMPLATE
--------------------------------------------------------

  CREATE TABLE "JMOCHA_USER_MAIL_TEMPLATE" 
   (	"USER_ID" NVARCHAR2(100), 
	"DISPLAYNAME" NVARCHAR2(100), 
	"TEMPLATE_ID" NVARCHAR2(510), 
	"REGDATE" DATE, 
	"EDITORTYPE" NVARCHAR2(5), 
	"CONTENT" LONG
   ) ;
-------------------------------------------------------- 
--  DDL for Table JMOCHA_MAILBOX_PROGRESS
--------------------------------------------------------

  CREATE TABLE "JMOCHA_MAILBOX_PROGRESS" 
   (	"USER_KEY" NVARCHAR2(80) NOT NULL, 
	"TENANT_ID" NUMBER(5,0) NOT NULL, 
	"USER_ID" NVARCHAR2(80) NOT NULL, 
	"ACT" NVARCHAR2(15) NOT NULL, 
	"PERCENT" NUMBER(5,0) NOT NULL,
    "STATE" NVARCHAR2(20),
    "STATE_DESCRIPTION" NVARCHAR2(100),
	"UPDATEDT" DATE DEFAULT SYSDATE
   ) ;
-------------------------------------------------------- 
--  DDL for Table JMOCHA_APPR_ALLOWED_DOMAIN
--------------------------------------------------------

  CREATE TABLE "JMOCHA_APPR_ALLOWED_DOMAIN" 
   (	"TENANT_ID" NUMBER(5,0) NOT NULL, 
	"COMPANY_ID" NVARCHAR2(80) NOT NULL, 
	"DOMAIN_NAME" NVARCHAR2(100) NOT NULL
   ) ;
-------------------------------------------------------- 
--  DDL for Table JMOCHA_APPR_USER
--------------------------------------------------------

  CREATE TABLE "JMOCHA_APPR_USER" 
   (	"TENANT_ID" NUMBER(5,0) NOT NULL, 
	"COMPANY_ID" NVARCHAR2(80) NOT NULL, 
	"USER_ID" NVARCHAR2(100) NOT NULL, 
	"USER_TYPE" NVARCHAR2(10) NOT NULL
   ) ;
-------------------------------------------------------- 
--  DDL for Table JMOCHA_APPR_HISTORY
--------------------------------------------------------
  CREATE TABLE "JMOCHA_APPR_HISTORY" (
  "TENANT_ID" NUMBER(5,0) NOT NULL,
  "COMPANY_ID" NVARCHAR2(80) NOT NULL,
  "MAIL_UID" NUMBER NOT NULL,
  "SUBJECT" CLOB,
  "SENDEREMAIL" NVARCHAR2(100),
  "USER_ID" NVARCHAR2(100) NOT NULL,
  "USER_NAME" NVARCHAR2(100),
  "USER_NAME2" NVARCHAR2(100),
  "USER_DEPTID" NVARCHAR2(100),
  "USER_DEPTNAME" NVARCHAR2(100),
  "USER_DEPTNAME2" NVARCHAR2(100),
  "WRITE_DATE" DATE,
  "APPROVER_ID" NVARCHAR2(100),
  "APPROVER_NAME" NVARCHAR2(100),
  "APPROVER_NAME2" NVARCHAR2(100),
  "updatedt" DATE,
  "STATE" NVARCHAR2(10),
  "MEMO" NVARCHAR2(200),
  "DEL_FLAG" NVARCHAR2(10) DEFAULT 'N'
  );
-------------------------------------------------------- 
--  DDL for Table JMOCHA_APPR_COMP_HISTORY
--------------------------------------------------------
CREATE TABLE "JMOCHA_APPR_COMP_HISTORY" (
  "TENANT_ID" NUMBER(5,0) NOT NULL,
  "COMPANY_ID" NVARCHAR2(80) NOT NULL,
  "MAIL_UID" NUMBER NOT NULL,
  "SUBJECT" CLOB,
  "SENDEREMAIL" NVARCHAR2(100),
  "USER_ID" NVARCHAR2(100) NOT NULL,
  "USER_NAME" NVARCHAR2(100),
  "USER_NAME2" NVARCHAR2(100),
  "USER_DEPTID" NVARCHAR2(100), 
  "USER_DEPTNAME" NVARCHAR2(100),
  "USER_DEPTNAME2" NVARCHAR2(100),
  "WRITE_DATE" DATE,
  "APPROVER_ID" NVARCHAR2(100),
  "APPROVER_NAME" NVARCHAR2(100),
  "APPROVER_NAME2" NVARCHAR2(100),
  "updatedt" DATE,
  "STATE" NVARCHAR2(10),
  "MEMO" NVARCHAR2(200),
  "DEL_FLAG" NVARCHAR2(10) DEFAULT 'N'
);
--------------------------------------------------------
--  DDL for Sequence DBOBJECTID_SEQUENCE
--------------------------------------------------------

   CREATE SEQUENCE  "DBOBJECTID_SEQUENCE"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 50 START WITH 1 CACHE 50 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence LIGHTPOLLOPTIONID_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "LIGHTPOLLOPTIONID_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence POPUPOPTIONID_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "POPUPOPTIONID_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_DBOBJECTID_SEQUENCE
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_DBOBJECTID_SEQUENCE"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 50 START WITH 1 CACHE 50 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_JMOCHA_ADDRESS_FOLDER
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_JMOCHA_ADDRESS_FOLDER"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_JMOCHA_ADDRESS_INFO
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_JMOCHA_ADDRESS_INFO"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_JMOCHA_ADDRESS_SIMPLE
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_JMOCHA_ADDRESS_SIMPLE"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_JMOCHA_CONNECTION_INFO
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_JMOCHA_CONNECTION_INFO"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_JMOCHA_INBOX_RULE
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_JMOCHA_INBOX_RULE"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_JMOCHA_INBOX_RULE_SUB
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_JMOCHA_INBOX_RULE_SUB"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_JMOCHA_LETTER
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_JMOCHA_LETTER"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_JMOCHA_LETTER_BOX
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_JMOCHA_LETTER_BOX"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_JMOCHA_MAIL_POP3
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_JMOCHA_MAIL_POP3"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_JMOCHA_MAIL_RECALL
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_JMOCHA_MAIL_RECALL"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_JMOCHA_MAIL_SECURE
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_JMOCHA_MAIL_SECURE"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_JMOCHA_STAT_MAIL_LOG
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_JMOCHA_STAT_MAIL_LOG"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TALK_TBLNOTIFICATION
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TALK_TBLNOTIFICATION"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_ADMINRECEIPTGROUP_MAIN
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_ADMINRECEIPTGROUP_MAIN"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
-------------------------------------------------------- 
--  DDL for Sequence TBL_ADMIN_ACCESS_IP_SEQ2
--------------------------------------------------------

   CREATE SEQUENCE  "TBL_ADMIN_ACCESS_IP_SEQ2"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_ADMINRECEIPTGROUP_SUB
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_ADMINRECEIPTGROUP_SUB"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_ATTITUDE
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_ATTITUDE"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_ATTITUDE_HISTORY
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_ATTITUDE_HISTORY"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_ATTITUDE_TYPE
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_ATTITUDE_TYPE"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_ATTI_ANNUAL_HISTORY
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_ATTI_ANNUAL_HISTORY"  MINVALUE 1 MAXVALUE 99999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_ATTI_MODAPPL_HISTORY
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_ATTI_MODAPPL_HISTORY"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_COMM_ITEM_ATTACHMENTS
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_COMM_ITEM_ATTACHMENTS"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_COMM_SCHEDULE
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_COMM_SCHEDULE"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_COMM_SCHEDULEATTACH
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_COMM_SCHEDULEATTACH"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_COMM_SCHEDULECOMMENT
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_COMM_SCHEDULECOMMENT"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_CONNECTION_INFO
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_CONNECTION_INFO"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_ADMIN_ACCESS_INFO
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_ADMIN_ACCESS_INFO"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_PERMISSION_CHANGE_INFO
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_PERMISSION_CHANGE_INFO"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_USER_CHANGE_INFO
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_USER_CHANGE_INFO"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_USER_CHANGE_INFO
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_DEPT_CHANGE_INFO"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
   --------------------------------------------------------
--  DDL for Sequence SEQ_TBL_C_BOARD
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_C_BOARD"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_C_CLUBGUEST
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_C_CLUBGUEST"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_C_CLUBNOTICE
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_C_CLUBNOTICE"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_C_CLUBPHOTO
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_C_CLUBPHOTO"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_C_CLUBPHOTO_ATTACH
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_C_CLUBPHOTO_ATTACH"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_C_CLUBPHOTO_REPLY
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_C_CLUBPHOTO_REPLY"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_C_NOTICE
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_C_NOTICE"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_C_POLLANSWER
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_C_POLLANSWER"  MINVALUE 0 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_C_POLLMANAGER
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_C_POLLMANAGER"  MINVALUE 0 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_C_POLLQUESTION
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_C_POLLQUESTION"  MINVALUE 0 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_C_POLLRESPONSE
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_C_POLLRESPONSE"  MINVALUE 0 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_DTPROPERTIES
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_DTPROPERTIES"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_D_C_BOARD1
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_D_C_BOARD1"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_D_C_BOARD2
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_D_C_BOARD2"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_D_C_BOARD3
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_D_C_BOARD3"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_D_C_CLUBBOARD
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_D_C_CLUBBOARD"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_D_C_CLUBBOARD1
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_D_C_CLUBBOARD1"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_D_C_CLUBBOARD2
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_D_C_CLUBBOARD2"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_D_C_CLUBPDS
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_D_C_CLUBPDS"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_D_C_CLUBPDS1
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_D_C_CLUBPDS1"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_D_C_CLUBPDS_BACK
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_D_C_CLUBPDS_BACK"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_FORMCONNINFO
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_FORMCONNINFO"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_HOLIDAYLIST
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_HOLIDAYLIST"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_JOURNAL
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_JOURNAL"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_JOURNAL_FILE
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_JOURNAL_FILE"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_JOURNAL_FORM
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_JOURNAL_FORM"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_JOURNAL_RECV_FAVORITE
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_JOURNAL_RECV_FAVORITE"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_JOURNAL_REPLY
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_JOURNAL_REPLY"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_MEMO
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_MEMO"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_MEMO_FOLDER
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_MEMO_FOLDER"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_NOTIFICATION_ITEMSEQ
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_NOTIFICATION_ITEMSEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_PS_COMPANYLINK_ITEMSEQ
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_PS_COMPANYLINK_ITEMSEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_PS_LIGHTPOLL_ITEMSEQ
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_PS_LIGHTPOLL_ITEMSEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_PS_NOTICE_ITEMSEQ
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_PS_NOTICE_ITEMSEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_PS_POPUP_ITEMSEQ
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_PS_POPUP_ITEMSEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_PS_USERLINK_ITEMSEQ
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_PS_USERLINK_ITEMSEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_RECRELAYINFO
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_RECRELAYINFO"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_RS_ATTACH
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_RS_ATTACH"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;

--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_SCHEDULE
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_SCHEDULE"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_SCHEDULEATTACH
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_SCHEDULEATTACH"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_SCHEDULECOMMENT
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_SCHEDULECOMMENT"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_SCHEDULE_PUBLIC_DEPT
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_SCHEDULE_PUBLIC_DEPT"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_SCHEDULE_REPEDEL
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_SCHEDULE_REPEDEL"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_SERIALNUMGEN
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_SERIALNUMGEN"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_STAT_MAIL_TEMP_IDX
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_STAT_MAIL_TEMP_IDX"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_SURVEY_ATTACHFILE
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_SURVEY_ATTACHFILE"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_SURVEY_PARTICIPANT
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_SURVEY_PARTICIPANT"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_TASK
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_TASK"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_TASKATTACH
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_TASKATTACH"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_TASKCODEHISTORY
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_TASKCODEHISTORY"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_TASKCOMMENT
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_TASKCOMMENT"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_TASKREQUEST
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_TASKREQUEST"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_TT_V_TBLBOARDORDER
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_TT_V_TBLBOARDORDER"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_TT_V_TBLPARENTBOARDS
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_TT_V_TBLPARENTBOARDS"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TBL_USER_JOBMASTER
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TBL_USER_JOBMASTER"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence TBL_ACCESS_IP_SEQ2
--------------------------------------------------------

   CREATE SEQUENCE  "TBL_ACCESS_IP_SEQ2"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence TBL_LADDER_BMUSER_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "TBL_LADDER_BMUSER_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence TBL_LADDER_BM_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "TBL_LADDER_BM_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence TBL_LADDER_COMMENT_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "TBL_LADDER_COMMENT_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence TBL_LADDER_LINE_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "TBL_LADDER_LINE_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence TBL_LADDER_ORDER_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "TBL_LADDER_ORDER_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence TBL_LADDER_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "TBL_LADDER_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence TBL_PORTAL_FRAME_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "TBL_PORTAL_FRAME_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence TBL_PORTAL_MENU_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "TBL_PORTAL_MENU_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence TBL_PORTAL_PORTLET_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "TBL_PORTAL_PORTLET_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence TBL_PORTAL_THEME_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "TBL_PORTAL_THEME_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence TT_SQ_TMPCLASSINFO_SN
--------------------------------------------------------

   CREATE SEQUENCE  "TT_SQ_TMPCLASSINFO_SN"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_JMOCHA_MAIL_SIGN_TEMP
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_JMOCHA_MAIL_SIGN_TEMP"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence TBL_ACCESS_ID_SEQ2
--------------------------------------------------------

	CREATE SEQUENCE  "TBL_ACCESS_ID_SEQ2"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence TBL_DEV_MASTER
--------------------------------------------------------

	CREATE SEQUENCE  "SEQ_TBL_DEV_MASTER"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence TBL_DEV_MASTER
--------------------------------------------------------

    CREATE SEQUENCE  "SEQ_TBL_NOT_ACCESS_FIDO_IP"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Index APPROVCONNKAMCO_PK
--------------------------------------------------------

   CREATE SEQUENCE "SEQ_FILEID" MINVALUE 10000000 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 10000000 CACHE 20 NOORDER  NOCYCLE;
   CREATE SEQUENCE "SEQ_FOLDERID" MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE;
        
   CREATE SEQUENCE "SEQ_FILEUSER" MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE;
   CREATE SEQUENCE "SEQ_FOLDERUSER" MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE;

  CREATE UNIQUE INDEX "APPROVCONNKAMCO_PK" ON "APPROVCONNKAMCO" ("USERID", "DOCID") 
  ;
--------------------------------------------------------
--  DDL for Index APPROVCONNKAMCO_USER_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "APPROVCONNKAMCO_USER_PK" ON "APPROVCONNKAMCO_USER" ("USERID") 
  ;
--------------------------------------------------------
--  DDL for Index FK_TBL_CABINETHISTORY_IDX
--------------------------------------------------------

  CREATE INDEX "FK_TBL_CABINETHISTORY_IDX" ON "TBL_CABINETHISTORY" ("TENANT_ID", "COMPANYID", "CABINETCLASSNO") 
  ;
--------------------------------------------------------
--  DDL for Index IDX1
--------------------------------------------------------

  CREATE INDEX "IDX1" ON "TBL_JOURNAL_ORDER" ("USER_ID", "USER_ORDER") 
  ;
--------------------------------------------------------
--  DDL for Index IDX_JAMES_MAIL_BLOB
--------------------------------------------------------

  CREATE UNIQUE INDEX "IDX_JAMES_MAIL_BLOB" ON "JAMES_MAIL_BLOB" ("MAILBOX_ID", "MAIL_UID") 
  ;
  CREATE INDEX "JAMES_MAIL_BLOB_DISK_ID_IDX" ON "JAMES_MAIL_BLOB" ("DISK_ID")
  ;
--------------------------------------------------------
--  DDL for Index IDX_JAMES_MAIL_USERFLAG
--------------------------------------------------------

  CREATE INDEX "IDX_JAMES_MAIL_USERFLAG" ON "JAMES_MAIL_USERFLAG" ("MAILBOX_ID", "MAIL_UID") 
  ;
  CREATE INDEX "JAMES_MAIL_USERFLAG_NAME_IDX" ON "JAMES_MAIL_USERFLAG" ("USERFLAG_NAME")
  ;
--------------------------------------------------------
--  DDL for Index IDX_JAMES_PROPERTY_LINE_NUMBER
--------------------------------------------------------

  CREATE INDEX "IDX_JAMES_PROPERTY_LINE_NUMBER" ON "JAMES_MAIL_PROPERTY" ("PROPERTY_LINE_NUMBER") 
  ;
--------------------------------------------------------
--  DDL for Index IDX_JAMES_PROPERTY_MAILBOX_ID
--------------------------------------------------------

  CREATE INDEX "IDX_JAMES_PROPERTY_MAILBOX_ID" ON "JAMES_MAIL_PROPERTY" ("MAILBOX_ID", "MAIL_UID") 
  ;
--------------------------------------------------------
--  DDL for Index IDX_JMOCHA_ADDRESS_INFO
--------------------------------------------------------

  CREATE INDEX "IDX_JMOCHA_ADDRESS_INFO" ON "JMOCHA_ADDRESS_INFO" ("OWNER_ID", "S_NAME") 
  ;
--------------------------------------------------------
--  DDL for Index IDX_JMOCHA_ADDRESS_SEARCH
--------------------------------------------------------

  CREATE INDEX "IDX_JMOCHA_ADDRESS_SEARCH" ON "JMOCHA_ADDRESS_SEARCH" ("ADDRESS") 
   INDEXTYPE IS "CTXSYS"."CONTEXT" ;
--------------------------------------------------------
--  DDL for Index IDX_JMOCHA_INBOX_RULE
--------------------------------------------------------

  CREATE INDEX "IDX_JMOCHA_INBOX_RULE" ON "JMOCHA_INBOX_RULE" ("USER_ID") 
  ;
--------------------------------------------------------
--  DDL for Index IDX_JMOCHA_INBOX_RULE_SUB
--------------------------------------------------------

  CREATE INDEX "IDX_JMOCHA_INBOX_RULE_SUB" ON "JMOCHA_INBOX_RULE_SUB" ("RULE_ID") 
  ;
--------------------------------------------------------
--  DDL for Index IDX_JMOCHA_MAIL_POP3
--------------------------------------------------------

  CREATE INDEX "IDX_JMOCHA_MAIL_POP3" ON "JMOCHA_MAIL_POP3" ("USER_ID", "POP3_SERVER", "POP3_USER_ID") 
  ;
--------------------------------------------------------
--  DDL for Index IDX_JMOCHA_MAIL_RECALL
--------------------------------------------------------

  CREATE INDEX "IDX_JMOCHA_MAIL_RECALL" ON "JMOCHA_MAIL_RECALL" ("MESSAGE_ID", "SENDER_EMAIL") 
  ;
--------------------------------------------------------
--  DDL for Index IDX_JMOCHA_MAIL_SECURE
--------------------------------------------------------

  CREATE INDEX "IDX_JMOCHA_MAIL_SECURE" ON "JMOCHA_MAIL_SECURE" ("MAILBOX_ID", "MAIL_UID") 
  ;
--------------------------------------------------------
--  DDL for Index IDX_JMOCHA_RESERVE_SEND_DATE
--------------------------------------------------------

  CREATE INDEX "IDX_JMOCHA_RESERVE_SEND_DATE" ON "JMOCHA_MAIL_RESERVE" ("SEND_DATE") 
  ;
--------------------------------------------------------
--  DDL for Index IDX_JMOCHA_RESERVE_USER_ID
--------------------------------------------------------

  CREATE INDEX "IDX_JMOCHA_RESERVE_USER_ID" ON "JMOCHA_MAIL_RESERVE" ("USER_ID") 
  ;
--------------------------------------------------------
--  DDL for Index IDX_JMOCHA_STAT_LOG_EVENT_TYPE
--------------------------------------------------------

  CREATE INDEX "IDX_JMOCHA_STAT_LOG_EVENT_TYPE" ON "JMOCHA_STAT_MAIL_LOG" ("EVENT_TYPE") 
  ;
--------------------------------------------------------
--  DDL for Index IDX_JMOCHA_STAT_LOG_LOG_DATE
--------------------------------------------------------

  CREATE INDEX "IDX_JMOCHA_STAT_LOG_LOG_DATE" ON "JMOCHA_STAT_MAIL_LOG" ("LOG_DATE") 
  ;
--------------------------------------------------------
--  DDL for Index IDX_JMOCHA_STAT_LOG_TENANT_ID
--------------------------------------------------------

  CREATE INDEX "IDX_JMOCHA_STAT_LOG_TENANT_ID" ON "JMOCHA_STAT_MAIL_LOG" ("TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index IDX_JMOCHA_TENANT_CONFIG
--------------------------------------------------------

  CREATE INDEX "IDX_JMOCHA_TENANT_CONFIG" ON "JMOCHA_TENANT_CONFIG" ("PROPERTY_NAME") 
  ;
--------------------------------------------------------
--  DDL for Index IDX_JMOCHA_TENANT_SERVERNAME
--------------------------------------------------------

  CREATE INDEX "IDX_JMOCHA_TENANT_SERVERNAME" ON "JMOCHA_TENANT_SERVERNAME" ("TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index IDX_JMOHCA_ADDRESS_SIMPLE
--------------------------------------------------------

  CREATE INDEX "IDX_JMOHCA_ADDRESS_SIMPLE" ON "JMOCHA_ADDRESS_SIMPLE" ("USER_ID") 
  ;
--------------------------------------------------------
--  DDL for Index IDX_TBL_TASKCODEHISTORY
--------------------------------------------------------

  CREATE UNIQUE INDEX "IDX_TBL_TASKCODEHISTORY" ON "TBL_TASKCODEHISTORY" ("TENANT_ID", "SN", "COMPANYID") 
  ;
--------------------------------------------------------
--  DDL for Index INDEX_TBL_CIRCULAR
--------------------------------------------------------

  CREATE INDEX "INDEX_TBL_CIRCULAR" ON "TBL_CIRCULAR" ("TENANTID", "MEMBERID") 
  ;
--------------------------------------------------------
--  DDL for Index INDEX_TBL_CIRCULAR_BM
--------------------------------------------------------

  CREATE INDEX "INDEX_TBL_CIRCULAR_BM" ON "TBL_CIRCULAR_BM" ("TENANTID", "MEMBERID") 
  ;
--------------------------------------------------------
--  DDL for Index INDEX_TBL_CIRCULAR_BMUSER
--------------------------------------------------------

  CREATE INDEX "INDEX_TBL_CIRCULAR_BMUSER" ON "TBL_CIRCULAR_BMUSER" ("TENANTID", "MEMBERID", "CIRCULARBMID") 
  ;
--------------------------------------------------------
--  DDL for Index INDEX_TBL_CIRCULAR_CO_
--------------------------------------------------------

  CREATE INDEX "INDEX_TBL_CIRCULAR_CO_" ON "TBL_CIRCULAR_COMMENTSTATE" ("TENANTID", "MEMBERID", "CIRCULARCOMMENTID") 
  ;
--------------------------------------------------------
--  DDL for Index INDEX_TBL_CIRCULAR_FIRE
--------------------------------------------------------

  CREATE INDEX "INDEX_TBL_CIRCULAR_FIRE" ON "TBL_CIRCULAR_FILE" ("TENANTID", "CIRCULARID") 
  ;
--------------------------------------------------------
--  DDL for Index INDEX_TBL_CIRCULAR_FOLDER
--------------------------------------------------------

  CREATE INDEX "INDEX_TBL_CIRCULAR_FOLDER" ON "TBL_CIRCULAR_FOLDER" ("TENANTID", "MEMBERID") 
  ;
--------------------------------------------------------
--  DDL for Index INDEX_TBL_CIRCULAR_LINK
--------------------------------------------------------

  CREATE INDEX "INDEX_TBL_CIRCULAR_LINK" ON "TBL_CIRCULAR_LINK" ("TENANTID", "MEMBERID") 
  ;
--------------------------------------------------------
--  DDL for Index INDEX_TBL_CIRCULAR_OPTION
--------------------------------------------------------

  CREATE INDEX "INDEX_TBL_CIRCULAR_OPTION" ON "TBL_CIRCULAR_OPTION" ("TENANTID", "MEMBERID") 
  ;
--------------------------------------------------------
--  DDL for Index INDEX_TBL_CIRCULAR_USER
--------------------------------------------------------

  CREATE INDEX "INDEX_TBL_CIRCULAR_USER" ON "TBL_CIRCULAR_USER" ("TENANTID", "MEMBERID", "CIRCULARID") 
  ;
--------------------------------------------------------
--  DDL for Index I_JMS_LBX_USER_NAME
--------------------------------------------------------

  CREATE INDEX "I_JMS_LBX_USER_NAME" ON "JAMES_MAILBOX" ("USER_NAME") 
  ;
--------------------------------------------------------
--  DDL for Index I_JMS_MIL_MAIL_IS_DELETED
--------------------------------------------------------

  CREATE INDEX "I_JMS_MIL_MAIL_IS_DELETED" ON "JAMES_MAIL" ("MAIL_IS_DELETED") 
  ;
--------------------------------------------------------
--  DDL for Index I_JMS_MIL_MAIL_IS_RECENT
--------------------------------------------------------

  CREATE INDEX "I_JMS_MIL_MAIL_IS_RECENT" ON "JAMES_MAIL" ("MAIL_IS_RECENT") 
  ;
--------------------------------------------------------
--  DDL for Index I_JMS_MIL_MAIL_IS_SEEN
--------------------------------------------------------

  CREATE INDEX "I_JMS_MIL_MAIL_IS_SEEN" ON "JAMES_MAIL" ("MAIL_IS_SEEN") 
  ;
--------------------------------------------------------
--  DDL for Index I_JMS_MIL_MAIL_MODSEQ
--------------------------------------------------------

  CREATE INDEX "I_JMS_MIL_MAIL_MODSEQ" ON "JAMES_MAIL" ("MAIL_MODSEQ") 
  ;
--------------------------------------------------------
--  DDL for Index JAMES_MAIL_MAIL_DATE_IDX
--------------------------------------------------------

  CREATE INDEX "JAMES_MAIL_MAIL_DATE_IDX" ON "JAMES_MAIL" ("MAIL_DATE")
  ;
--------------------------------------------------------
--  DDL for Index JAMES_MAIL_BLOB_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "JAMES_MAIL_BLOB_PK" ON "JAMES_MAIL_BLOB" ("MAIL_BLOB_ID") 
  ;
--------------------------------------------------------
--  DDL for Index JAMES_MAIL_DELETED_ID_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "JAMES_MAIL_DELETED_ID_PK" ON "JAMES_MAIL_DELETED_ID" ("MAILBOX_ID", "MAIL_UID") 
  ;
--------------------------------------------------------
--  DDL for Index JAMES_MAIL_SEARCH_INDEX
--------------------------------------------------------

  CREATE INDEX "JAMES_MAIL_SEARCH_INDEX" ON "JAMES_MAIL_SEARCH" ("MAILBOX_ID", "MAIL_UID") 
  ;
--------------------------------------------------------
--  DDL for Index JMOCHA_ADDRESS_FOLDER_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "JMOCHA_ADDRESS_FOLDER_PK" ON "JMOCHA_ADDRESS_FOLDER" ("FOLDER_ID") 
  ;
--------------------------------------------------------
--  DDL for Index JMOCHA_ADDRESS_SEARCH_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "JMOCHA_ADDRESS_SEARCH_PK" ON "JMOCHA_ADDRESS_SEARCH" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Index JMOCHA_BIGATTACH_DOWN_LIMIT_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "JMOCHA_BIGATTACH_DOWN_LIMIT_PK" ON "JMOCHA_BIGATTACH_DOWN_LIMIT" ("FILE_ID") 
  ;
--------------------------------------------------------
--  DDL for Index JMOCHA_DISTRIBUTION_SUB_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "JMOCHA_DISTRIBUTION_SUB_PK" ON "JMOCHA_DISTRIBUTION_SUB" ("DOMAIN_NAME", "USER_NAME", "SUB_MAIL") 
  ;
--------------------------------------------------------
--  DDL for Index JMOCHA_LETTERBOX_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "JMOCHA_LETTERBOX_PK" ON "JMOCHA_LETTERBOX" ("LETTERBOX_NO") 
  ;
--------------------------------------------------------
--  DDL for Index JMOCHA_LETTER_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "JMOCHA_LETTER_PK" ON "JMOCHA_LETTER" ("LETTER_NO") 
  ;
--------------------------------------------------------
--  DDL for Index JMOCHA_MAIL_COUNTRYIP_PK1
--------------------------------------------------------

  CREATE UNIQUE INDEX "JMOCHA_MAIL_COUNTRYIP_PK1" ON "JMOCHA_MAIL_COUNTRYIP" ("START_IP_NUMBER", "END_IP_NUMBER") 
  ;
--------------------------------------------------------
--  DDL for Index MESSAGE_ID_INDEX
--------------------------------------------------------

  CREATE INDEX "MESSAGE_ID_INDEX" ON "JAMES_MAIL_SEARCH" ("MESSAGE_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK2_TBL_COMPANY_CONFIG
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK2_TBL_COMPANY_CONFIG" ON "TBL_COMPANY_CONFIG" ("TENANT_ID", "COMPANY_ID", "PROPERTY_NAME") 
  ;
--------------------------------------------------------
--  DDL for Index PK_ATTITUDE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_ATTITUDE" ON "TBL_ATTITUDE" ("ATTITUDE_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_ATTITUDE_AUTH
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_ATTITUDE_AUTH" ON "TBL_ATTITUDE_AUTH" ("USER_ID", "TENANT_ID", "AUTH_DEPT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_ATTITUDE_CONF
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_ATTITUDE_CONF" ON "TBL_ATTITUDE_CONF" ("COMPANY_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_ATTITUDE_FORM
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_ATTITUDE_FORM" ON "TBL_ATTITUDE_FORM" ("FORM_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_ATTITUDE_MODAPPL
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_ATTITUDE_MODAPPL" ON "TBL_ATTITUDE_MODAPPL" ("ATTITUDE_ID", "APPL_CNT", "COMPANY_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_ATTITUDE_MODAPPL_HISTORY
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_ATTITUDE_MODAPPL_HISTORY" ON "TBL_ATTITUDE_MODAPPL_HISTORY" ("MOD_CNT") 
  ;
--------------------------------------------------------
--  DDL for Index PK_ATTITUDE_TYPE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_ATTITUDE_TYPE" ON "TBL_ATTITUDE_TYPE" ("ORDER", "TYPE_ID", "COMPANY_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_ATTITUDE_USER_CONF
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_ATTITUDE_USER_CONF" ON "TBL_ATTITUDE_USER_CONF" ("USER_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_ADDRESS_GENERAL
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_ADDRESS_GENERAL" ON "JMOCHA_ADDRESS_GENERAL" ("USER_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_ADDRESS_INFO
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_ADDRESS_INFO" ON "JMOCHA_ADDRESS_INFO" ("ADDRESS_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_ADDRESS_SIMPLE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_ADDRESS_SIMPLE" ON "JMOCHA_ADDRESS_SIMPLE" ("SIMPLE_IDX") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_ALIAS
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_ALIAS" ON "JMOCHA_ALIAS" ("TARGET_ADDRESS", "ALIAS_ADDRESS") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_ALIAS_RETIRE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_ALIAS_RETIRE" ON "JMOCHA_ALIAS_RETIRE" ("TARGET_ADDRESS", "ALIAS_ADDRESS") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_CONNECTION_INFO
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_CONNECTION_INFO" ON "JMOCHA_CONNECTION_INFO" ("SEQUENCE") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_DEFAULT_QUOTA
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_DEFAULT_QUOTA" ON "JMOCHA_DEFAULT_QUOTA" ("DOMAIN_NAME") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_COMPANY_QUOTA
--------------------------------------------------------
CREATE UNIQUE INDEX "PK_JMOCHA_COMPANY_QUOTA" ON "JMOCHA_COMPANY_QUOTA" ("DOMAIN_NAME", "COMPANY_ID")
;

--------------------------------------------------------
--  DDL for Index PK_JMOCHA_DEPT_MASTER
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_DEPT_MASTER" ON "JMOCHA_DEPT_MASTER" ("TENANT_ID", "CN") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_DISTRIBUTION
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_DISTRIBUTION" ON "JMOCHA_DISTRIBUTION" ("DOMAIN_NAME", "USER_NAME") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_INBOX_RULE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_INBOX_RULE" ON "JMOCHA_INBOX_RULE" ("RULE_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_INBOX_RULE_SUB
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_INBOX_RULE_SUB" ON "JMOCHA_INBOX_RULE_SUB" ("ITEM_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_MAIL_COLOR
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_MAIL_COLOR" ON "JMOCHA_MAIL_COLOR" ("TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_MAIL_DELETE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_MAIL_DELETE" ON "JMOCHA_MAIL_DELETE" ("USER_ID", "FOLDER_PATH") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_MAIL_FORWARD
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_MAIL_FORWARD" ON "JMOCHA_MAIL_FORWARD" ("USERID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_MAIL_GENERAL
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_MAIL_GENERAL" ON "JMOCHA_MAIL_GENERAL" ("USER_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_MAIL_OUTOFOFFICE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_MAIL_OUTOFOFFICE" ON "JMOCHA_MAIL_OUTOFOFFICE" ("USER_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_MAIL_POP3
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_MAIL_POP3" ON "JMOCHA_MAIL_POP3" ("POP3_IDX") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_MAIL_READ
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_MAIL_READ" ON "JMOCHA_MAIL_READ" ("MESSAGE_ID", "USER_ID", "READER_EMAIL") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_MAIL_RECALL
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_MAIL_RECALL" ON "JMOCHA_MAIL_RECALL" ("RECALL_IDX") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_MAIL_RECALL_DETAIL
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_MAIL_RECALL_DETAIL" ON "JMOCHA_MAIL_RECALL_DETAIL" ("RECALL_IDX", "RECEIVER_EMAIL") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_MAIL_SECURE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_MAIL_SECURE" ON "JMOCHA_MAIL_SECURE" ("SECURE_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_MAIL_SECURE_READ
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_MAIL_SECURE_READ" ON "JMOCHA_MAIL_SECURE_READ" ("SECURE_ID", "READER_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_MAIL_SIGNATURE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_MAIL_SIGNATURE" ON "JMOCHA_MAIL_SIGNATURE" ("USER_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_OUTOFOFFICE_SENT
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_OUTOFOFFICE_SENT" ON "JMOCHA_MAIL_OUTOFOFFICE_SENT" ("USER_ID", "RECIPIENT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_RETIRED_USER
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_RETIRED_USER" ON "JMOCHA_RETIRED_USER" ("USER_NAME") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_SCHEDULER_SERVER
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_SCHEDULER_SERVER" ON "JMOCHA_SCHEDULER_SERVER" ("SCHEDULER") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_SHARED_MAILBOX
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_SHARED_MAILBOX" ON "JMOCHA_SHARED_MAILBOX" ("TENANT_ID", "SHARE_ID", "USER_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_STAT_COMP_FLOW_DAY
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_STAT_COMP_FLOW_DAY" ON "JMOCHA_STAT_MAIL_COMP_FLOW_DAY" ("TENANT_ID", "DT_DD", "SORGID", "RORGID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_STAT_COMP_FLOW_MON
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_STAT_COMP_FLOW_MON" ON "JMOCHA_STAT_MAIL_COMP_FLOW_MON" ("TENANT_ID", "DT_MM", "SORGID", "RORGID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_STAT_MAILBOXQTY_INFO
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_STAT_MAILBOXQTY_INFO" ON "JMOCHA_STAT_MAILBOXQTY_INFO" ("TENANT_ID", "USERID", "DT_MM") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_STAT_MAIL_DEPT_DAY
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_STAT_MAIL_DEPT_DAY" ON "JMOCHA_STAT_MAIL_DEPT_DAY" ("TENANT_ID", "DT_DD", "DEPTID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_STAT_MAIL_DEPT_MONTH
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_STAT_MAIL_DEPT_MONTH" ON "JMOCHA_STAT_MAIL_DEPT_MONTH" ("TENANT_ID", "DT_MM", "DEPTID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_STAT_MAIL_LOG
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_STAT_MAIL_LOG" ON "JMOCHA_STAT_MAIL_LOG" ("IDX") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_STAT_MAIL_USER_DAY
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_STAT_MAIL_USER_DAY" ON "JMOCHA_STAT_MAIL_USER_DAY" ("TENANT_ID", "DT_DD", "USERID", "DEPTID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_STAT_MAIL_USER_MONTH
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_STAT_MAIL_USER_MONTH" ON "JMOCHA_STAT_MAIL_USER_MONTH" ("TENANT_ID", "DT_MM", "USERID", "DEPTID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_STORAGE_WARNING_SENT
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_STORAGE_WARNING_SENT" ON "JMOCHA_STORAGE_WARNING_SENT" ("USER_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_TENANT
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_TENANT" ON "JMOCHA_TENANT" ("TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_TENANT_CONFIG
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_TENANT_CONFIG" ON "JMOCHA_TENANT_CONFIG" ("TENANT_ID", "PROPERTY_NAME") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_TENANT_SERVERNAME
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_TENANT_SERVERNAME" ON "JMOCHA_TENANT_SERVERNAME" ("SERVER_NAME") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_USER_DISTRIBUTION
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_USER_DISTRIBUTION" ON "JMOCHA_USER_DISTRIBUTION" ("DOMAIN_NAME", "USER_NAME") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_USER_DIST_MEM
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_USER_DIST_MEM" ON "JMOCHA_USER_DISTRIBUTION_MEM" ("DOMAIN_NAME", "USER_NAME", "MEMBER_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_USER_DIST_APPLY
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_USER_DIST_APPLY" ON "JMOCHA_USER_DIST_APPLY" ("DOMAIN_NAME", "USER_NAME", "APPLICANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_USER_LOCAL_INFO
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_USER_LOCAL_INFO" ON "JMOCHA_USER_LOCAL_INFO" ("TENANT_ID", "USERID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_USER_MASTER
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_USER_MASTER" ON "JMOCHA_USER_MASTER" ("TENANT_ID", "CN") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_USER_MASTER_RETIRE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_USER_MASTER_RETIRE" ON "JMOCHA_USER_MASTER_RETIRE" ("TENANT_ID", "CN") 
  ;
--------------------------------------------------------
--  DDL for Index PK_JMOCHA_USER_QUOTA
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_JMOCHA_USER_QUOTA" ON "JMOCHA_USER_QUOTA" ("USER_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_MEMO
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_MEMO" ON "TBL_MEMO" ("MEMO_ID", "COMPANY_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_MEMO_CONFIG
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_MEMO_CONFIG" ON "TBL_MEMO_CONFIG" ("USER_ID", "COMPANY_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_MEMO_FOLDER
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_MEMO_FOLDER" ON "TBL_MEMO_FOLDER" ("FOLDER_ID", "COMPANY_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_MESSAGE_ID
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_MESSAGE_ID" ON "JMOCHA_MAIL_RESERVE" ("MESSAGE_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_SURVEY
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_SURVEY" ON "TBL_SURVEY" ("SURVEY_ID", "COMPANY_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_SURVEY_ATTACHFILE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_SURVEY_ATTACHFILE" ON "TBL_SURVEY_ATTACHFILE" ("ATT_FILE_ID", "COMPANY_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_SURVEY_CONFIG
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_SURVEY_CONFIG" ON "TBL_SURVEY_CONFIG" ("USER_ID", "COMPANY_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_SURVEY_OPTION
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_SURVEY_OPTION" ON "TBL_SURVEY_OPTION" ("OPTION_ID", "COMPANY_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_SURVEY_PARTICIPANT
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_SURVEY_PARTICIPANT" ON "TBL_SURVEY_PARTICIPANT" ("PARTICIPANT_ID", "COMPANY_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_SURVEY_QUESTION
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_SURVEY_QUESTION" ON "TBL_SURVEY_QUESTION" ("QUESTION_ID", "COMPANY_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_SURVEY_RESPONDENT
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_SURVEY_RESPONDENT" ON "TBL_SURVEY_RESPONDENT" ("RESPONSE_ID", "COMPANY_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_SURVEY_RESPONSE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_SURVEY_RESPONSE" ON "TBL_SURVEY_RESPONSE" ("RESPONSE_ID", "COMPANY_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_ADD_JOBMASTER
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_ADD_JOBMASTER" ON "TBL_ADDJOBMASTER" ("TENANT_ID", "CN", "DEPTID", "JOBID", "ROLEID")
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_ADMINRECEIPTGROUP_SUB
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_ADMINRECEIPTGROUP_SUB" ON "TBL_ADMINRECEIPTGROUP_SUB" ("TENANT_ID", "SUBID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_ADMINRECEIPTGROUP_SUB1
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_ADMINRECEIPTGROUP_SUB1" ON "TBL_ADMINRECEIPTGROUP_SUB" ("TENANT_ID", "SUBID", "COMPANYID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_ATTENDANT
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_ATTENDANT" ON "TBL_ATTENDANT" ("TENANT_ID", "SCHEDULEID", "ATTENDANTID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_BOARD_APPRLIST
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_BOARD_APPRLIST" ON "TBL_BOARD_APPRLIST" ("TENANT_ID", "BOARDID", "APPRUSERID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_BOARD_BOARDINFO
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_BOARD_BOARDINFO" ON "TBL_BOARD_BOARDINFO" ("TENANT_ID", "BOARDID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_BOARD_BOARDINFO_ATTR
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_BOARD_BOARDINFO_ATTR" ON "TBL_BOARD_BOARDINFO_ATTRIBUTE" ("TENANT_ID", "BOARDID", "TABLECOL") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_BOARD_BOARDMANAGE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_BOARD_BOARDMANAGE" ON "TBL_BOARD_BOARDMANAGE" ("TENANT_ID", "BOARDID", "ACCESSID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_BOARD_CONFIGURATION
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_BOARD_CONFIGURATION" ON "TBL_BOARD_CONFIGURATION" ("TENANT_ID", "USERID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_BOARD_DELETERESERVED
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_BOARD_DELETERESERVED" ON "TBL_BOARD_DELETERESERVEDBOARD" ("TENANT_ID", "BOARDID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_BOARD_DELETERESERVEDIT
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_BOARD_DELETERESERVEDIT" ON "TBL_BOARD_DELETERESERVEDITEM" ("TENANT_ID", "BOARDID", "ITEMID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_BOARD_ITEM
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_BOARD_ITEM" ON "TBL_BOARD_ITEM" ("TENANT_ID", "ITEMID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_BOARD_ITEM_ATTACHMENTS
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_BOARD_ITEM_ATTACHMENTS" ON "TBL_BOARD_ITEM_ATTACHMENTS" ("TENANT_ID", "ITEMID", "FILEPATH") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_BOARD_ITEM_LISTOPTION
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_BOARD_ITEM_LISTOPTION" ON "TBL_BOARD_ITEM_LISTOPTION" ("TENANT_ID", "LISTTYPE", "SN") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_BOARD_ITEM_LISTOPTION_2
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_BOARD_ITEM_LISTOPTION_2" ON "TBL_BOARD_ITEM_LISTOPTION_BOAR" ("TENANT_ID", "BOARDID", "SN") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_BOARD_ITEM_READ
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_BOARD_ITEM_READ" ON "TBL_BOARD_ITEM_READ" ("TENANT_ID", "BOARDID", "ITEMID", "USERID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_BOARD_ITEM_TEMP
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_BOARD_ITEM_TEMP" ON "TBL_BOARD_ITEM_TEMP" ("TENANT_ID", "ITEMID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_BOARD_MYBOARDS
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_BOARD_MYBOARDS" ON "TBL_BOARD_MYBOARDS" ("TENANT_ID", "USERID", "BOARDID", "COMPANYID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_BOARD_MYTREE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_BOARD_MYTREE" ON "TBL_BOARD_MYTREE" ("TENANT_ID", "TREEID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_BOARD_ONELINEREPLY
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_BOARD_ONELINEREPLY" ON "TBL_BOARD_ONELINEREPLY" ("TENANT_ID", "ITEMID", "REPLYID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_BOARD_TREECACHE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_BOARD_TREECACHE" ON "TBL_BOARD_TREECACHE" ("TENANT_ID", "QUERY") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_BRDMNG
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_BRDMNG" ON "TBL_QS_BRDMNG" ("BRD_ID", "USER_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_CABINET
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_CABINET" ON "TBL_CABINET" ("TENANT_ID", "CABINETID", "COMPANYID") 
  ;

--------------------------------------------------------
--  DDL for Index TBL_CABINET_CABINETCLASSNO_IDX
--------------------------------------------------------

CREATE INDEX "TBL_CABINET_CABINETCLASSNO_IDX" ON "TBL_CABINET" ("CABINETCLASSNO")
;

--------------------------------------------------------
--  DDL for Index TBL_CABINET_CABINETID_IDX
--------------------------------------------------------

CREATE INDEX "TBL_CABINET_CABINETID_IDX" ON "TBL_CABINET" ("CABINETID")
;

--------------------------------------------------------
--  DDL for Index TBL_CABINET_CABINETTRANSFERFLAG_IDX
--------------------------------------------------------

CREATE INDEX "TBL_CABINET_CABINETTRANSFERFLAG_IDX" ON "TBL_CABINET" ("CABINETTRANSFERFLAG")
;

--------------------------------------------------------
--  DDL for Index TBL_CABINET_DELFLAG_IDX
--------------------------------------------------------

CREATE INDEX "TBL_CABINET_DELFLAG_IDX" ON "TBL_CABINET" ("DELFLAG")
;

--------------------------------------------------------
--  DDL for Index PK_TBL_CABROLEINFO
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_CABROLEINFO" ON "TBL_CABROLEINFO" ("TENANT_ID", "USER_ID", "CABINETCLASSNO") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_CABROLEINFO1
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_CABROLEINFO1" ON "TBL_CABROLEINFO" ("TENANT_ID", "USER_ID", "CABINETCLASSNO", "COMPANYID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_CLUBID
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_CLUBID" ON "TBL_CLUBID" ("TENANT_ID", "CLUBID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_COMM_BOARDINFO
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_COMM_BOARDINFO" ON "TBL_COMM_BOARDINFO" ("TENANT_ID", "C_CLUBNO", "BOARDID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_COMM_BOARDMANAGE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_COMM_BOARDMANAGE" ON "TBL_COMM_BOARDMANAGE" ("TENANT_ID", "BOARDID", "ACCESSID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_COMM_DELETERESERVED
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_COMM_DELETERESERVED" ON "TBL_COMM_DELETERESERVEDITEM" ("TENANT_ID", "BOARDID", "ITEMID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_COMM_DELETERESERVEDBOA
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_COMM_DELETERESERVEDBOA" ON "TBL_COMM_DELETERESERVEDBOARD" ("TENANT_ID", "BOARDID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_COMM_ITEM
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_COMM_ITEM" ON "TBL_COMM_ITEM" ("TENANT_ID", "ITEMID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_COMM_ITEM_ATTACHMENTS
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_COMM_ITEM_ATTACHMENTS" ON "TBL_COMM_ITEM_ATTACHMENTS" ("TENANT_ID", "ITEMID", "GUID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_COMM_ITEM_READ
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_COMM_ITEM_READ" ON "TBL_COMM_ITEM_READ" ("TENANT_ID", "BOARDID", "ITEMID", "USERID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_COMM_MYBOARDS
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_COMM_MYBOARDS" ON "TBL_COMM_MYBOARDS" ("TENANT_ID", "USERID", "BOARDID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_COMM_ONELINEREPLY
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_COMM_ONELINEREPLY" ON "TBL_COMM_ONELINEREPLY" ("TENANT_ID", "ITEMID", "REPLYID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_COMM_SCHEDULE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_COMM_SCHEDULE" ON "TBL_COMM_SCHEDULE" ("TENANT_ID", "SCHEDULEID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_COMM_SCHEDULEATTACH
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_COMM_SCHEDULEATTACH" ON "TBL_COMM_SCHEDULEATTACH" ("TENANT_ID", "ATTACHID", "SCHEDULEID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_COMM_SCHEDULECOMMENT
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_COMM_SCHEDULECOMMENT" ON "TBL_COMM_SCHEDULECOMMENT" ("TENANT_ID", "COMMENTID", "SCHEDULEID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_COMM_SCHEDULECONFIG
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_COMM_SCHEDULECONFIG" ON "TBL_COMM_SCHEDULECONFIG" ("TENANT_ID", "USERID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_COMM_SCHEDULEGROUP
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_COMM_SCHEDULEGROUP" ON "TBL_COMM_SCHEDULEGROUP" ("TENANT_ID", "GROUPID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_COMM_SCHEDULEGROUPMEM
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_COMM_SCHEDULEGROUPMEM" ON "TBL_COMM_SCHEDULEGROUPMEMBER" ("TENANT_ID", "GROUPID", "MEMBERID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_COMM_SCHEDULESHARE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_COMM_SCHEDULESHARE" ON "TBL_COMM_SCHEDULESHARE" ("TENANT_ID", "OWNERID", "SHARERID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_COMM_SECRETARY
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_COMM_SECRETARY" ON "TBL_COMM_SECRETARY" ("TENANT_ID", "USERID", "SECRETARYID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_COMM_TREECACHE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_COMM_TREECACHE" ON "TBL_COMM_TREECACHE" ("TENANT_ID", "QUERY") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_SESSION
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_SESSION" ON "TBL_SESSION" ("SESSION_ID")
  ;
--------------------------------------------------------
--  DDL for Index IDX_SESSION_LAST_TIME
--------------------------------------------------------

  CREATE UNIQUE INDEX "IDX_SESSION_LAST_TIME" ON "TBL_SESSION" ("SESSION_ID", "LAST_ACCESS_TIME")
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_FIDO_SESSION
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_FIDO_SESSION" ON "TBL_FIDO_SESSION" ("FIDO_SESSION_ID")
  ;
--------------------------------------------------------
--  DDL for Index TBL_NOT_ACCESS_FIDO_IP
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_NOT_ACCESS_FIDO_IP" ON "TBL_NOT_ACCESS_FIDO_IP" ("IPNO")
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_CONNECTION_INFO
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_CONNECTION_INFO" ON "TBL_CONNECTION_INFO" ("SEQUENCE") 
  ;

--------------------------------------------------------
--  DDL for Index TCI_TENANT_ID_USERID_IDX
--------------------------------------------------------

  CREATE INDEX TCI_TENANT_ID_USERID_IDX ON TBL_CONNECTION_INFO (TENANT_ID, USERID)
  ;

--------------------------------------------------------
--  DDL for Index PK_TBL_ADMIN_ACCESS_INFO
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_ADMIN_ACCESS_INFO" ON "TBL_ADMIN_ACCESS_INFO" ("SEQUENCE") 
  ;  
--------------------------------------------------------
--  DDL for Index PK_TBL_PERMISSION_CHANGE_INFO
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_PERMISSION_CHANGE_INFO" ON "TBL_PERMISSION_CHANGE_INFO" ("SEQUENCE")
  ;

--------------------------------------------------------
--  DDL for Index PK_TBL_USER_CHANGE_INFO
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_USER_CHANGE_INFO" ON "TBL_USER_CHANGE_INFO" ("SEQ")
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_DEPT_CHANGE_INFO
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_DEPT_CHANGE_INFO" ON "TBL_DEPT_CHANGE_INFO" ("SEQ")
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_C_BOARD
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_C_BOARD" ON "TBL_C_BOARD" ("TENANT_ID", "NO") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_C_CATEGORY
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_C_CATEGORY" ON "TBL_C_CATEGORY" ("TENANT_ID", "C_CODE", "C_CAT") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_C_CLUB
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_C_CLUB" ON "TBL_C_CLUB" ("TENANT_ID", "C_CLUBNO") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_C_CLUBGUEST
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_C_CLUBGUEST" ON "TBL_C_CLUBGUEST" ("TENANT_ID", "NO") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_C_CLUBNOTICE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_C_CLUBNOTICE" ON "TBL_C_CLUBNOTICE" ("TENANT_ID", "NO") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_C_CLUBUSER
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_C_CLUBUSER" ON "TBL_C_CLUBUSER" ("TENANT_ID", "C_CLUBNO", "C_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_C_COMCLOSE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_C_COMCLOSE" ON "TBL_C_COMCLOSE" ("TENANT_ID", "C_CLUBNO") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_C_MEMBERINFO
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_C_MEMBERINFO" ON "TBL_C_MEMBERINFO" ("TENANT_ID", "COMPANYID", "USERID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_C_NOTICE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_C_NOTICE" ON "TBL_C_NOTICE" ("TENANT_ID", "NO") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_C_OUTAPPLICATION
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_C_OUTAPPLICATION" ON "TBL_C_OUTAPPLICATION" ("TENANT_ID", "C_CLUBNO", "USERID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_C_POLLANSWER
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_C_POLLANSWER" ON "TBL_C_POLLANSWER" ("TENANT_ID", "ANSWERID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_C_POLLMANAGER
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_C_POLLMANAGER" ON "TBL_C_POLLMANAGER" ("TENANT_ID", "MANAGERID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_C_POLLQUESTION
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_C_POLLQUESTION" ON "TBL_C_POLLQUESTION" ("TENANT_ID", "QUESTIONID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_C_POLLRESPONSE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_C_POLLRESPONSE" ON "TBL_C_POLLRESPONSE" ("TENANT_ID", "RESPONSEID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_DAILYDOCCOUNTLOG
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_DAILYDOCCOUNTLOG" ON "TBL_DAILYDOCCOUNTLOG" ("TENANT_ID", "REGDATE", "DEPTID", "USERID", "COMPANYID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_DAILYFORMCOUNTLOG
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_DAILYFORMCOUNTLOG" ON "TBL_DAILYFORMCOUNTLOG" ("TENANT_ID", "REGDATE", "FORMID", "FORMCONTID", "COMPANYID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_DEPTCONT
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_DEPTCONT" ON "TBL_DEPTCONT" ("DEPTCONTID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_DEPTCONTLIST
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_DEPTCONTLIST" ON "TBL_DEPTCONTLIST" ("TENANT_ID", "DOCID", "DEPTCONTID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_DEPTMASTER
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_DEPTMASTER" ON "TBL_DEPTMASTER" ("TENANT_ID", "CN") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_DEPTTEMPLET1
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_DEPTTEMPLET1" ON "TBL_DEPTTEMPLET" ("TENANT_ID", "USERID", "FORMID", "APRDEPTSN", "COMPANYID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_DEPTTEMPLETDETAIL1
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_DEPTTEMPLETDETAIL1" ON "TBL_DEPTTEMPLETDETAIL" ("TENANT_ID", "USERID", "FORMID", "APRDEPTSN", "APRDEPTMEMBERSN", "COMPANYID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_DOCDELETEHISTORY
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_DOCDELETEHISTORY" ON "TBL_DOCDELETEHISTORY" ("TENANT_ID", "DOCID", "COMPANYID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_DOCDELIVERY1
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_DOCDELIVERY1" ON "TBL_DOCDELIVERY" ("TENANT_ID", "COMPANYID", "SN", "DOCID", "DEPTID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_HOLIDAYLIST
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_HOLIDAYLIST" ON "TBL_HOLIDAYLIST" ("TENANT_ID", "HOLIDAYID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_ITEMSEQ
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_ITEMSEQ" ON "TBL_QS_ITEMSEQ" ("TENANT_ID", "BRD_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_JOURNAL
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_JOURNAL" ON "TBL_JOURNAL" ("JOURNAL_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_JOURNAL_ENV
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_JOURNAL_ENV" ON "TBL_JOURNAL_ENV" ("USER_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_JOURNAL_FILE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_JOURNAL_FILE" ON "TBL_JOURNAL_FILE" ("FILE_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_JOURNAL_FORM
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_JOURNAL_FORM" ON "TBL_JOURNAL_FORM" ("FORM_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_JOURNAL_FORM_TYPE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_JOURNAL_FORM_TYPE" ON "TBL_JOURNAL_FORM_TYPE" ("TYPE_ID", "TENANT_ID", "COMPANY_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_JOURNAL_RECV_FAVORITE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_JOURNAL_RECV_FAVORITE" ON "TBL_JOURNAL_RECV_FAVORITE" ("TENANT_ID", "FAVORITE_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_JOURNAL_REPLY
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_JOURNAL_REPLY" ON "TBL_JOURNAL_REPLY" ("REPLY_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_JOURNAL_VIEW
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_JOURNAL_VIEW" ON "TBL_JOURNAL_VIEW" ("USER_ID", "TENANT_ID", "JOURNAL_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_LOGO_SIZE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_LOGO_SIZE" ON "TBL_LOGO_SIZE" ("TENANT_ID", "C_CLUBNO") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_LUNARUSE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_LUNARUSE" ON "TBL_LUNARUSE" ("TENANT_ID", "USECOMPANY") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_PHOTO_IMAGEITEM
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_PHOTO_IMAGEITEM" ON "TBL_PHOTO_IMAGEITEM" ("TENANT_ID", "IMAGEID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_POLL_ANSWER
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_POLL_ANSWER" ON "TBL_POLL_ANSWER" ("TENANT_ID", "BRD_ID", "ITEM_NO", "QUESTION_NO", "ANSWERNO") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_POLL_ATTACH
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_POLL_ATTACH" ON "TBL_POLL_ATTACH" ("TENANT_ID", "BRD_ID", "ITEM_NO", "QUESTION_NO", "ANSWERNO", "ATTACHNO") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_POLL_ITEM
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_POLL_ITEM" ON "TBL_POLL_ITEM" ("TENANT_ID", "BRD_ID", "ITEM_NO") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_POLL_ITEMACL
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_POLL_ITEMACL" ON "TBL_POLL_ITEMACL" ("TENANT_ID", "BRD_ID", "ITEM_NO", "GUBUN", "GUBUN_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_POLL_ITEMREAD
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_POLL_ITEMREAD" ON "TBL_POLL_ITEMREAD" ("TENANT_ID", "BRD_ID", "ITEM_NO", "USER_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_POLL_PERMISSION
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_POLL_PERMISSION" ON "TBL_POLL_PERMISSION" ("TENANT_ID", "BRD_ID", "ITEM_NO") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_POLL_QUESTION
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_POLL_QUESTION" ON "TBL_POLL_QUESTION" ("TENANT_ID", "BRD_ID", "ITEM_NO", "QUESTION_NO") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_POLL_RESPONSE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_POLL_RESPONSE" ON "TBL_POLL_RESPONSE" ("TENANT_ID", "BRD_ID", "ITEM_NO", "QUESTION_NO", "RESPONSENO") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_POLL_RESPONSEPERSON
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_POLL_RESPONSEPERSON" ON "TBL_POLL_RESPONSEPERSON" ("TENANT_ID", "BRD_ID", "ITEM_NO", "USER_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_POLL_TABLE_ANSWER
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_POLL_TABLE_ANSWER" ON "TBL_POLL_TABLE_ANSWER" ("TENANT_ID", "BRD_ID", "ITEM_NO", "QUESTION_NO", "ANSWERNO") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_PREVIOSLYREGI
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_PREVIOSLYREGI" ON "TBL_PREVIOSLYREGI" ("TENANT_ID", "USECOMPANY") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_PROXYINFO
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_PROXYINFO" ON "TBL_PROXYINFO" ("TENANT_ID", "USERID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_PS_APPROVNOTIMAILCONF
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_PS_APPROVNOTIMAILCONF" ON "TBL_PS_APPROVNOTIMAILCONF" ("TENANT_ID", "USERID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_PS_LIGHTPOLL
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_PS_LIGHTPOLL" ON "TBL_PS_LIGHTPOLL" ("TENANT_ID", "ITEMSEQ") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_PS_LIGHTPOLLRESULT
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_PS_LIGHTPOLLRESULT" ON "TBL_PS_LIGHTPOLLRESULT" ("TENANT_ID", "ITEMSEQ", "USERID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_PS_NOTICE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_PS_NOTICE" ON "TBL_PS_NOTICE" ("TENANT_ID", "ITEMSEQ") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_PS_POPUP
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_PS_POPUP" ON "TBL_PS_POPUP" ("TENANT_ID", "COMPANYID", "ITEMSEQ") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_PS_QUICKLINK
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_PS_QUICKLINK" ON "TBL_PS_QUICKLINK" ("TENANT_ID", "QUICKLINKID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_PS_QUICKLINK_ACL
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_PS_QUICKLINK_ACL" ON "TBL_PS_QUICKLINK_ACL" ("TENANT_ID", "QUICKLINKID", "ACCESSID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_PS_SLIDERIMAGE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_PS_SLIDERIMAGE" ON "TBL_PS_SLIDERIMAGE" ("TENANT_ID", "SLIDERID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_PS_USERWEBPART
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_PS_USERWEBPART" ON "TBL_PS_USERWEBPART" ("TENANT_ID", "USERID", "ITEMID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_PS_WEBPARTGROUP
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_PS_WEBPARTGROUP" ON "TBL_PS_WEBPARTGROUP" ("TENANT_ID", "ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_PS_WEBPARTITEM
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_PS_WEBPARTITEM" ON "TBL_PS_WEBPARTITEM" ("TENANT_ID", "ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_PS_WEBPARTITEMACL
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_PS_WEBPARTITEMACL" ON "TBL_PS_WEBPARTITEMACL" ("TENANT_ID", "ITEMID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_PWDINFO
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_PWDINFO" ON "TBL_PWDINFO" ("TENANT_ID", "COMPANYID", "USERID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_RS_BRD
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_RS_BRD" ON "TBL_RS_BRD" ("TENANT_ID", "BRD_ID", "BRD_COMPANY") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_RS_FAVORITE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_RS_FAVORITE" ON "TBL_RS_FAVORITE" ("RESID", "USERID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_RS_RESACL
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_RS_RESACL" ON "TBL_RS_RESACL" ("TENANT_ID", "RESID", "MEMBER_ID", "COMPANYID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_RS_SCHEDULE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_RS_SCHEDULE" ON "TBL_RS_SCHEDULE" ("TENANT_ID", "OWNERID", "NUM", "COMPANYID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_RS_SCHEDULEFORM
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_RS_SCHEDULEFORM" ON "TBL_RS_SCHEDULEFORM" ("TENANT_ID", "RESID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_SCHEDULE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_SCHEDULE" ON "TBL_SCHEDULE" ("SCHEDULEID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_SCHEDULEATTACH
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_SCHEDULEATTACH" ON "TBL_SCHEDULEATTACH" ("ATTACHID", "SCHEDULEID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_SCHEDULECONFIG
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_SCHEDULECONFIG" ON "TBL_SCHEDULECONFIG" ("USERID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_SCHEDULEGROUP
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_SCHEDULEGROUP" ON "TBL_SCHEDULEGROUP" ("GROUPID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_SCHEDULEGROUPMEMBER
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_SCHEDULEGROUPMEMBER" ON "TBL_SCHEDULEGROUPMEMBER" ("GROUPID", "MEMBERID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_SCHEDULE_PUBLIC_DEPT
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_SCHEDULE_PUBLIC_DEPT" ON "TBL_SCHEDULE_PUBLIC_DEPT" ("TENANT_ID", "USERCN", "DEPARTMENTCN") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_SCHISTORY_CAB
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_SCHISTORY_CAB" ON "TBL_SCHISTORY_CAB" ("TENANT_ID", "VERSION", "CABINETCLASSNO", "SERIALNO", "COMPANYID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_SCHISTORY_REC1
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_SCHISTORY_REC1" ON "TBL_SCHISTORY_REC" ("TENANT_ID", "RECORDID", "SEPERATEATTACHNO", "VERSION", "SERIALNO", "COMPANYID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_SEALDEPTINFO
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_SEALDEPTINFO" ON "TBL_SEALDEPTINFO" ("TENANT_ID", "SEALNUM", "DEPTID", "COMPANYID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_CAR
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_CAR" ON "TBL_CAR" ("TENANT_ID", "CAR_ID", "COMPANYID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_CAR_ACL
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_CAR_ACL" ON "TBL_CAR_ACL" ("TENANT_ID", "CAR_ID", "MEMBER_ID", "COMPANYID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_CAR_ATTACH
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_CAR_ATTACH" ON "TBL_CAR_ATTACH" ("ATTACHID", "TENANT_ID", "COMPANYID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_CAR_FORM
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_CAR_FORM" ON "TBL_CAR_FORM" ("CAR_FORM_ID", "CAR_ID", "COMPANYID", "TENANT_ID", "CAR_REGISTER_NO")
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_SEALDEPTINFO1
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_SEALDEPTINFO1" ON "TBL_SEALDEPTINFO" ("TENANT_ID", "SEALNUM", "DEPTID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_SEALINFO
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_SEALINFO" ON "TBL_SEALINFO" ("TENANT_ID", "SEALNUM", "COMPANYID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_SECRETARY
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_SECRETARY" ON "TBL_SECRETARY" ("TENANT_ID", "USERID", "SECRETARYID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_SPECIALCATALOGINFO_CAB
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_SPECIALCATALOGINFO_CAB" ON "TBL_SPECIALCATALOGINFO_CAB" ("TENANT_ID", "CABINETCLASSNO", "SERIALNO") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_SPECIALCATALOGINFO_CAB1
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_SPECIALCATALOGINFO_CAB1" ON "TBL_SPECIALCATALOGINFO_CAB" ("TENANT_ID", "CABINETCLASSNO", "SERIALNO", "COMPANYID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_TASK
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_TASK" ON "TBL_TASK" ("TASKID", "TENANTID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_TASKATTACH
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_TASKATTACH" ON "TBL_TASKATTACH" ("ATTACHID", "TASKID", "TENANTID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_TASKCATEGORY
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_TASKCATEGORY" ON "TBL_TASKCATEGORY" ("TENANT_ID", "CATEGORYCODE", "COMPANYID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_TASKCODEHISTORY
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_TASKCODEHISTORY" ON "TBL_TASKCODEHISTORY" ("SN") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_TASKCOMMENT
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_TASKCOMMENT" ON "TBL_TASKCOMMENT" ("COMMENTID", "TASKID", "TENANTID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_TASKCONFIG
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_TASKCONFIG" ON "TBL_TASKCONFIG" ("USERID", "TENANTID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_TASKINSTANCESTATUS
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_TASKINSTANCESTATUS" ON "TBL_TASKINSTANCESTATUS" ("TASKID", "STARTDATE", "TENANTID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_TASKMIDDLECATEGORY
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_TASKMIDDLECATEGORY" ON "TBL_TASKMIDDLECATEGORY" ("TENANT_ID", "MCATEGORYCODE", "COMPANYID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_TASKREQUEST
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_TASKREQUEST" ON "TBL_TASKREQUEST" ("REQUESTID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_TASKSHARE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_TASKSHARE" ON "TBL_TASKSHARE" ("TASKID", "SHARERID", "TENANTID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_TASKSUBCATEGORY
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_TASKSUBCATEGORY" ON "TBL_TASKSUBCATEGORY" ("TENANT_ID", "SUBCATEGORYCODE", "COMPANYID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_TASK_DEPTINFO
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_TASK_DEPTINFO" ON "TBL_TASK_DEPTINFO" ("TENANT_ID", "PROCESSDEPTCODE", "TASKCODE") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_TENANT
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_TENANT" ON "TBL_TENANT" ("TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_TENANT_CONFIG
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_TENANT_CONFIG" ON "TBL_TENANT_CONFIG" ("TENANT_ID", "PROPERTY_NAME") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_TENANT_SERVERNAME
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_TENANT_SERVERNAME" ON "TBL_TENANT_SERVERNAME" ("SERVER_NAME") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_TMPEXPAPRDOCINFO
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_TMPEXPAPRDOCINFO" ON "TBL_TMPEXPAPRDOCINFO" ("COMPANYID", "TENANT_ID", "OWNERID", "SN") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_USERLOCALINFO
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_USERLOCALINFO" ON "TBL_USERLOCALINFO" ("USERID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_USERMASTER
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_USERMASTER" ON "TBL_USERMASTER" ("TENANT_ID", "CN") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_USERMASTER_DELETE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_USERMASTER_DELETE" ON "TBL_USERMASTER_DELETE" ("TENANT_ID", "CN") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_USERMASTER_RETIRE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_USERMASTER_RETIRE" ON "TBL_USERMASTER_RETIRE" ("TENANT_ID", "CN") 
  ;
--------------------------------------------------------
--  DDL for Index PK__TBL_CABINETCLASS__10216508
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK__TBL_CABINETCLASS__10216508" ON "TBL_CABINETCLASS" ("TENANT_ID", "CABINETCLASSNO", "COMPANYID") 
  ;

--------------------------------------------------------
--  DDL for Index TBL_CABINETCLASS_CABINETCLASSNO_IDX
--------------------------------------------------------

CREATE INDEX "TBL_CABINETCLASS_CABINETCLASSNO_IDX" ON "TBL_CABINETCLASS" ("CABINETCLASSNO")
;

--------------------------------------------------------
--  DDL for Index TBL_CABINETCLASS_CONFIRMFLAG_IDX
--------------------------------------------------------

CREATE INDEX "TBL_CABINETCLASS_CONFIRMFLAG_IDX" ON "TBL_CABINETCLASS" ("CONFIRMFLAG")
;

--------------------------------------------------------
--  DDL for Index TBL_CABINETCLASS_OWNERDEPTID_IDX
--------------------------------------------------------

CREATE INDEX "TBL_CABINETCLASS_OWNERDEPTID_IDX" ON "TBL_CABINETCLASS" ("OWNERDEPTID")
;

--------------------------------------------------------
--  DDL for Index TBL_CABINETCLASS_REGSERIALNO_IDX
--------------------------------------------------------

CREATE INDEX "TBL_CABINETCLASS_REGSERIALNO_IDX" ON "TBL_CABINETCLASS" ("REGSERIALNO")
;

--------------------------------------------------------
--  DDL for Index TBL_CABINETCLASS_DELFLAG_IDX
--------------------------------------------------------

CREATE INDEX "TBL_CABINETCLASS_DELFLAG_IDX" ON "TBL_CABINETCLASS" ("DELFLAG")
;

--------------------------------------------------------
--  DDL for Index SIGNATURE_TEMPLATE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "SIGNATURE_TEMPLATE_PK" ON "JMOCHA_MAIL_SIGNATURE_TEMPLATE" ("SIGN_NO") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0013858
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0013858" ON "TALK_TBLGROUP" ("USERID", "GROUPID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0013863
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0013863" ON "TALK_TBLMEMBER" ("OWNERID", "GROUPID", "USERID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0013867
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0013867" ON "TALK_TBLROOMMEMBERCONFIG" ("ROOMID", "MEMBERID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0013872
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0013872" ON "TALK_TBLMEMBERRELATION" ("OWNERID", "USERID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0013887
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0013887" ON "TALK_TBLNOTIFICATION" ("ITEMSEQ") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0013898
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0013898" ON "TALK_TBLROOM" ("ROOMID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0013906
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0013906" ON "TALK_TBLROOMMEMBER" ("ROOMID", "MEMBERID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0013911
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0013911" ON "TALK_TBLROOMSEQ" ("ROOMID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0013919
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0013919" ON "TALK_TBLSERVERINFO" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0013930
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0013930" ON "TALK_TBLUSER" ("USERID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0013934
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0013934" ON "TALK_TBLUSERINFO" ("USERID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0013938
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0013938" ON "TALK_TBLVERSION" ("TYPE", "REGDATE") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0013944
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0013944" ON "TBL_VOTE_ANSWER" ("ID", "QST_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0013957
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0013957" ON "TBL_VOTE_COMMENT" ("ID", "QST_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0013962
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0013962" ON "TBL_VOTE_CONFIGURATION" ("USER_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0013978
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0013978" ON "TBL_VOTE_QUESTION" ("ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0013986
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0013986" ON "TBL_VOTE_QUESTION_RELATED" ("QST_ID", "USER_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0013994
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0013994" ON "TBL_VOTE_USER_AND_ANSWER" ("ANS_ID", "QST_ID", "USER_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0013999
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0013999" ON "TBL_VOTE_USER_AND_QUESTION" ("QST_ID", "USER_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0027162
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0027162" ON "TBL_CIRCULAR" ("CIRCULARID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0027165
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0027165" ON "TBL_CIRCULAR_BM" ("CIRCULARBMID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0027168
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0027168" ON "TBL_CIRCULAR_BMUSER" ("CIRCULARBMUSERID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0027172
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0027172" ON "TBL_CIRCULAR_COMMENT" ("CIRCULARCOMMENTID", "CIRCULARID", "TENANTID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0027175
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0027175" ON "TBL_CIRCULAR_COMMENTSTATE" ("CIRCULARCOMMENTSTATEID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0027178
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0027178" ON "TBL_CIRCULAR_FILE" ("CIRCULARFILEID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0027181
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0027181" ON "TBL_CIRCULAR_FOLDER" ("CIRCULARFOLDERID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0027184
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0027184" ON "TBL_CIRCULAR_LINK" ("CIRCULARLINKID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0027190
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0027190" ON "TBL_CIRCULAR_LISTOPTION" ("TENANTID", "LISTTYPE", "SN") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0027193
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0027193" ON "TBL_CIRCULAR_OPTION" ("CIRCULAROPTIONID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0027196
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0027196" ON "TBL_CIRCULAR_USER" ("CIRCULARUSERID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0027326
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0027326" ON "JAMES_DOMAIN" ("DOMAIN_NAME") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0027337
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0027337" ON "JAMES_MAIL" ("MAILBOX_ID", "MAIL_UID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0027345
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0027345" ON "JAMES_MAILBOX" ("MAILBOX_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0027355
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0027355" ON "JAMES_MAIL_PROPERTY" ("PROPERTY_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0027358
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0027358" ON "JAMES_MAIL_USERFLAG" ("USERFLAG_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0027362
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0027362" ON "JAMES_RECIPIENT_REWRITE" ("DOMAIN_NAME", "USER_NAME") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0027366
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0027366" ON "JAMES_SUBSCRIPTION" ("SUBSCRIPTION_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0027371
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0027371" ON "JAMES_USER" ("USER_NAME") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0027373
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0027373" ON "OPENJPA_SEQUENCE_TABLE" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0028145
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0028145" ON "TBL_FORM_AUTORULE" ("TENANT_ID", "COMPANYID", "FORMID", "AUTORULESN", "AUTORULEGUID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0028151
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0028151" ON "TBL_FORM_AUTORULELINE" ("TENANT_ID", "COMPANYID", "FORMID", "AUTORULEGUID", "APRMEMBERSN") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0029172
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0029172" ON "TBL_WEBFOLDER_CONFIG" ("COMPANY_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0029179
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0029179" ON "TBL_WEBFOLDER_FAVOR" ("TENANT_ID", "USER_ID", "TARGET_ID", "TARGET_TYPE") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0029214
--------------------------------------------------------

  CREATE INDEX "IDX_FILEUSER_FILE_ID" ON "TBL_WEBFOLDER_FILEUSER" ("FILE_ID");
  CREATE INDEX "IDX_FILEUSER_USER_ID" ON "TBL_WEBFOLDER_FILEUSER" ("USER_ID");  
  
  CREATE UNIQUE INDEX "SYS_C0029214" ON "TBL_WEBFOLDER_FOLDER" ("TENANT_ID", "FOLDER_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0029223
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0029223" ON "TBL_WEBFOLDER_FOLDERUSER" ("SEQ_ID", "TENANT_ID") 
  ;
  
  CREATE INDEX "IDX_WF_FOLDERUSER_USER_ID" ON "TBL_WEBFOLDER_FOLDERUSER" ("USER_ID");
  CREATE INDEX "IDX_WF_FOLDERUSER_FOLDER_ID" ON "TBL_WEBFOLDER_FOLDERUSER" ("FOLDER_ID");  
--------------------------------------------------------
--  DDL for Index SYS_C0029249
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0029249" ON "TBL_WEBFOLDER_FILETYPE" ("FILE_EXT", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0029542
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0029542" ON "TBL_LADDER_LINE" ("ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0029549
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0029549" ON "TBL_LADDER_COMMENT" ("ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0029554
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0029554" ON "TBL_LADDER_BM" ("LADDERBMID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0029560
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0029560" ON "TBL_LADDER_BMUSER" ("ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0029564
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0029564" ON "TBL_LADDER_ORDER" ("ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0031291
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0031291" ON "JAMES_MAIL_SEARCH" ("MAIL_SEARCH_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0032127
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0032127" ON "TBL_PS_LIGHTPOLL_OPTION" ("LIGHTPOLLOPTIONID", "TENANTID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0032240
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0032240" ON "TBL_WEBFOLDER_TOKEN" ("USERID", "TENANTID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0032254
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0032254" ON "TBL_PS_POPUP_OPTION" ("POPUPOPTIONID", "TENANTID") 
  ;

--------------------------------------------------------
--  DDL for Index SYS_C0029536
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0029536" ON "TBL_LADDER" ("LADDERID", "TENANT_ID") 
  ;

--------------------------------------------------------
--  DDL for Index SYS_C0032439
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0032439" ON "TBL_PORTAL_PORTLET_NAME" ("PORTLET_ID", "MENU_ID", "PORTLET_LANG", "TENANT_ID", "COMPANY_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0034629
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0034629" ON "JMOCHA_MAIL_COPYRIGHT" ("COMPANY_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0034686
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0034686" ON "TBL_JOURNAL_SYMBOL" ("SYMBOL_STR", "COMPANY_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0034696
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0034696" ON "TBL_JOURNAL_ORDER" ("USER_ID", "RELATED_USER_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0035238
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0035238" ON "TBL_WEBFOLDER_USER" ("CN", "TENANT_ID", "TYPE") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0056132
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0056132" ON "TBL_PERMISSIONGROUPLIST" ("GROUP_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C0056140
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0056140" ON "TBL_PERMISSIONGROUPINFO" ("GROUP_ID", "MEMBER_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TABLE1_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TABLE1_PK" ON "JMOCHA_ADDJOB_MASTER" ("TENANT_ID", "CN", "DEPTID") 
  ;
--------------------------------------------------------
--  DDL for Index TALK_TBLADDJOB_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TALK_TBLADDJOB_PK" ON "TALK_TBLADDJOB" ("DEPTID", "USERID") 
  ;
--------------------------------------------------------
--  DDL for Index TALK_TBLAUTHLOGINTOKEN_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TALK_TBLAUTHLOGINTOKEN_PK" ON "TALK_TBLAUTHLOGINTOKEN" ("USERID", "LTOKEN") 
  ;
--------------------------------------------------------
--  DDL for Index TALK_TBLCOMPANY_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TALK_TBLCOMPANY_PK" ON "TALK_TBLCOMPANY" ("COMPID") 
  ;
--------------------------------------------------------
--  DDL for Index TALK_TBLDATELIMIT_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TALK_TBLDATELIMIT_PK" ON "TALK_TBLDATELIMIT" ("TYPE", "REGDATE") 
  ;
--------------------------------------------------------
--  DDL for Index TALK_TBLDEPT_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TALK_TBLDEPT_PK" ON "TALK_TBLDEPT" ("DEPTID") 
  ;
--------------------------------------------------------
--  DDL for Index TALK_TBLMESSAGE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TALK_TBLMESSAGE_PK" ON "TALK_TBLMESSAGE" ("ROOMID", "MSEQ") 
  ;
--------------------------------------------------------
--  DDL for Index TALK_TBL_ADM_DEFALUTSERVER_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TALK_TBL_ADM_DEFALUTSERVER_PK" ON "TALK_TBL_ADM_DEFALUTSERVER" ("SERVERID") 
  ;
--------------------------------------------------------
--  DDL for Index TALK_TBL_API_ACCESSKEY_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TALK_TBL_API_ACCESSKEY_PK" ON "TALK_TBL_API_ACCESSKEY" ("NAME") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_ACCESS_COUNTRY
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_ACCESS_COUNTRY" ON "TBL_ACCESS_COUNTRY" ("TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_ACCESS_ID_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_ACCESS_ID_PK" ON "TBL_ACCESS_ID" ("ACCESSNO") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_ACCESS_IP_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_ACCESS_IP_PK" ON "TBL_ACCESS_IP" ("IPNO") 
  ;
-------------------------------------------------------- 
--  DDL for Index PK2_TBL_ADMIN_ACCESS_IP
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK2_TBL_ADMIN_ACCESS_IP" ON "TBL_ADMIN_ACCESS_IP" ("IPNO")
  ;
--------------------------------------------------------
--  DDL for Index TBL_ADMINRECEIPTGROUP_MAIN_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_ADMINRECEIPTGROUP_MAIN_PK" ON "TBL_ADMINRECEIPTGROUP_MAIN" ("TENANT_ID", "COMPANYID", "MAINID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_APRATTACHINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_APRATTACHINFO_PK" ON "TBL_APRATTACHINFO" ("TENANT_ID", "COMPANYID", "DOCID", "ATTACHFILESN") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_APRDOCATTACHINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_APRDOCATTACHINFO_PK" ON "TBL_APRDOCATTACHINFO" ("TENANT_ID", "DOCID", "ATTACHSN", "COMPANYID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_APRDOCGROUPINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_APRDOCGROUPINFO_PK" ON "TBL_APRDOCGROUPINFO" ("TENANT_ID", "COMPANYID", "GROUPDOCSN", "TABSN") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_APRDOCINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_APRDOCINFO_PK" ON "TBL_APRDOCINFO" ("TENANT_ID", "COMPANYID", "DOCID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_APRDOCINFO_DOCSTATE_IDX
--------------------------------------------------------

  CREATE INDEX "TBL_APRDOCINFO_DOCSTATE_IDX" ON "TBL_APRDOCINFO" ("DOCSTATE")
  ;
--------------------------------------------------------
--  DDL for Index TBL_APRDOCINFO_FORMID_IDX
--------------------------------------------------------

  CREATE INDEX "TBL_APRDOCINFO_FORMID_IDX" ON "TBL_APRDOCINFO" ("FORMID")
  ;
--------------------------------------------------------
--  DDL for Index TBL_APRDOCINFO_WRITERID_IDX
--------------------------------------------------------

  CREATE INDEX "TBL_APRDOCINFO_WRITERID_IDX" ON "TBL_APRDOCINFO" ("WRITERID")
  ;
--------------------------------------------------------
--  DDL for Index TBL_APRLINEINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_APRLINEINFO_PK" ON "TBL_APRLINEINFO" ("TENANT_ID", "COMPANYID", "DOCID", "APRMEMBERSN") 
  ;

--------------------------------------------------------
--  DDL for Index TBL_APRLINEINFO_APRMEMBERSN_IDX
--------------------------------------------------------

CREATE INDEX "TBL_APRLINEINFO_APRMEMBERSN_IDX" ON "TBL_APRLINEINFO" ("APRMEMBERSN")
;

--------------------------------------------------------
--  DDL for Index LINE_APRMEMBERID_IDX
--------------------------------------------------------

  CREATE INDEX "LINE_APRMEMBERID_IDX" ON "TBL_APRLINEINFO" ("APRMEMBERID")
  ;
--------------------------------------------------------
--  DDL for Index LINE_APRTYPE_IDX
--------------------------------------------------------

  CREATE INDEX "LINE_APRTYPE_IDX" ON "TBL_APRLINEINFO" ("APRTYPE")
  ;
--------------------------------------------------------
--  DDL for Index LINE_APRSTATE_IDX
--------------------------------------------------------

  CREATE INDEX "LINE_APRSTATE_IDX" ON "TBL_APRLINEINFO" ("APRSTATE")
  ;
--------------------------------------------------------
--  DDL for Index TBL_APROPINIONINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_APROPINIONINFO_PK" ON "TBL_APROPINIONINFO" ("TENANT_ID", "COMPANYID", "DOCID", "USERID", "OPINIONSN") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_APRRECEIPTPROCESSINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_APRRECEIPTPROCESSINFO_PK" ON "TBL_APRRECEIPTPROCESSINFO" ("TENANT_ID", "COMPANYID", "RECEIVESN", "DOCID", "RECEIVEDDEPTID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_ARPI_APRSTATE_IDX
--------------------------------------------------------

  CREATE INDEX "TBL_ARPI_APRSTATE_IDX" ON "TBL_APRRECEIPTPROCESSINFO" ("APRSTATE")
  ;
--------------------------------------------------------
--  DDL for Index TBL_ARPI_RECEIVEDDEPTID_IDX
--------------------------------------------------------

  CREATE INDEX "TBL_ARPI_RECEIVEDDEPTID_IDX" ON "TBL_APRRECEIPTPROCESSINFO" ("RECEIVEDDEPTID")
  ;
--------------------------------------------------------
--  DDL for Index TBL_ATTITUDE_ANNUAL_CANAPPL_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_ATTITUDE_ANNUAL_CANAPPL_PK" ON "TBL_ATTITUDE_ANNUAL_CANAPPL" ("ATTITUDE_ID", "APPL_CNT", "COMPANY_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_ATTITUDE_ANNUAL_CONF_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_ATTITUDE_ANNUAL_CONF_PK" ON "TBL_ATTITUDE_ANNUAL_CONF" ("COMPANY_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_ATTITUDE_ANNUAL_HISTORY_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_ATTITUDE_ANNUAL_HISTORY_PK" ON "TBL_ATTITUDE_ANNUAL_HISTORY" ("ANNUAL_HISTORY_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_ATTITUDE_ANNUAL_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_ATTITUDE_ANNUAL_PK" ON "TBL_ATTITUDE_ANNUAL" ("USER_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_ATTITUDE_APR_CONN_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_ATTITUDE_APR_CONN_PK" ON "TBL_ATTITUDE_APR_CONN" ("ATTITUDE_ID", "COMPANY_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_ATTITUDE_INDEX1
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_ATTITUDE_INDEX1" ON "TBL_ATTITUDE" ("TENANT_ID", "ATTITUDE_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_AUDIO_VISUALRECEXINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_AUDIO_VISUALRECEXINFO_PK" ON "TBL_AUDIO_VISUALRECEXINFO" ("TENANT_ID", "COMPANYID", "RECORDID", "SEPERATEATTACHNO") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_AUDIO_VISUALRECEXINFO__PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_AUDIO_VISUALRECEXINFO__PK" ON "TBL_AUDIO_VISUALRECEXINFO_TEMP" ("DOCID", "TENANT_ID", "COMPANYID", "SEPERATEATTACHNO") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_AUTODOCNUM_ITEM_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_AUTODOCNUM_ITEM_PK" ON "TBL_AUTODOCNUM_ITEM" ("FORMID", "COMPANYID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_BOARD_BOARDBACKGROUNDI_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_BOARD_BOARDBACKGROUNDI_PK" ON "TBL_BOARD_BOARDBACKGROUNDINFO" ("TENANT_ID", "BACKGROUNDID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_BOARD_LIKE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_BOARD_LIKE_PK" ON "TBL_BOARD_LIKE" ("ITEMID", "USERID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_BOARD_NEWBOARD_ORDERIN_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_BOARD_NEWBOARD_ORDERIN_PK" ON "TBL_BOARD_NEWBOARD_ORDERINFO" ("TENANT_ID", "USERID", "COMPANYID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_CABINETCODELIST_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_CABINETCODELIST_PK" ON "TBL_CABINETCODELIST" ("TENANT_ID", "COMPANYID", "CODETYPE", "CODE") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_CABINETHISTORY_PK1
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_CABINETHISTORY_PK1" ON "TBL_CABINETHISTORY" ("TENANT_ID", "COMPANYID", "VERSION", "CABINETCLASSNO") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_CABINET_VIEWAUTH_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_CABINET_VIEWAUTH_PK" ON "TBL_CABINET_VIEWAUTH" ("CABINETID", "TENANT_ID", "COMPANYID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_CB_ADMIN_MODULE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_CB_ADMIN_MODULE_PK" ON "TBL_CB_ADMIN_MODULE" ("COMPANY_ID", "MODULE_TYPE", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_CB_ATTACH_FILE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_CB_ATTACH_FILE_PK" ON "TBL_CB_ATTACH_FILE" ("ATTACH_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_CB_CABINET_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_CB_CABINET_PK" ON "TBL_CB_CABINET" ("CABINET_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_CB_COMPANY_CAPACITY_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_CB_COMPANY_CAPACITY_PK" ON "TBL_CB_COMPANY_CAPACITY" ("COMPANY_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_CB_CONFIG_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_CB_CONFIG_PK" ON "TBL_CB_CONFIG" ("USER_ID", "COMPANY_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_CB_ITEM_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_CB_ITEM_PK" ON "TBL_CB_ITEM" ("ITEM_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_CB_RELATION_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_CB_RELATION_PK" ON "TBL_CB_RELATION" ("RELATION_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_CB_REL_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_CB_REL_PK" ON "TBL_CB_REL" ("REL_ID", "TENANT_ID", "ITEM_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_CB_SHARE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_CB_SHARE_PK" ON "TBL_CB_SHARE" ("SHARE_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_CB_USER_CAPACITY_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_CB_USER_CAPACITY_PK" ON "TBL_CB_USER_CAPACITY" ("USER_ID", "COMPANY_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_CB_USER_MODULE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_CB_USER_MODULE_PK" ON "TBL_CB_USER_MODULE" ("USER_ID", "COMPANY_ID", "MODULE_TYPE", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_CODELIST_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_CODELIST_PK" ON "TBL_CODELIST" ("TENANT_ID", "COMPANYID", "CODE1", "CODE2") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_CONNDATA_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_CONNDATA_PK" ON "TBL_CONNDATA" ("KEYID", "FORMID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_CONTAINERTODOCSTATE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_CONTAINERTODOCSTATE_PK" ON "TBL_CONTAINERTODOCSTATE" ("TENANT_ID", "COMPANYID", "DOCUMENTSTATE") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_CONTAINERTYPE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_CONTAINERTYPE_PK" ON "TBL_CONTAINERTYPE" ("TENANT_ID", "COMPANYID", "CONTAINERTYPEID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_CONTAINERUSEDEP_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_CONTAINERUSEDEP_PK" ON "TBL_CONTAINERUSEDEP" ("TENANT_ID", "COMPANYID", "CONTAINERID", "USEDEPID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_CONTAINER_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_CONTAINER_PK" ON "TBL_CONTAINER" ("TENANT_ID", "COMPANYID", "CONTAINERID", "CONTAINEROWNDEPID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_DELETECABINETINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_DELETECABINETINFO_PK" ON "TBL_DELETECABINETINFO" ("COMPANYID", "TENANTID", "CABINETID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_DEV_MASTER_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_DEV_MASTER_PK" ON "TBL_DEV_MASTER" ("DEVSEQ") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_ENDAPRDOCATTACHINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_ENDAPRDOCATTACHINFO_PK" ON "TBL_ENDAPRDOCATTACHINFO" ("TENANT_ID", "COMPANYID", "DOCID", "ATTACHSN") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_ENDAPRDOCINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_ENDAPRDOCINFO_PK" ON "TBL_ENDAPRDOCINFO" ("TENANT_ID", "COMPANYID", "DOCID") 
  ;

--------------------------------------------------------
--  DDL for Index TBL_ENDAPRDOCINFO_DOCTYPE_IDX
--------------------------------------------------------

CREATE INDEX "TBL_ENDAPRDOCINFO_DOCTYPE_IDX" ON "TBL_ENDAPRDOCINFO" ("DOCTYPE")
;


--------------------------------------------------------
--  DDL for Index TBL_ENDAPRDOC_CONTAINERID_IDX
--------------------------------------------------------

  CREATE INDEX "TBL_ENDAPRDOC_CONTAINERID_IDX" ON "TBL_ENDAPRDOCINFO" ("CONTAINERID")
  ;
--------------------------------------------------------
--  DDL for Index TBL_ENDAPRDOC_DOCSTATE_IDX
--------------------------------------------------------

  CREATE INDEX "TBL_ENDAPRDOC_DOCSTATE_IDX" ON "TBL_ENDAPRDOCINFO" ("DOCSTATE")
  ;
--------------------------------------------------------
--  DDL for Index TBL_ENDAPRDOC_FORMID_IDX
--------------------------------------------------------

  CREATE INDEX "TBL_ENDAPRDOC_FORMID_IDX" ON "TBL_ENDAPRDOCINFO" ("FORMID")
  ;
--------------------------------------------------------
--  DDL for Index TBL_ENDAPRDOC_WRITERID_IDX
--------------------------------------------------------

  CREATE INDEX "TBL_ENDAPRDOC_WRITERID_IDX" ON "TBL_ENDAPRDOCINFO" ("WRITERID")
  ;
--------------------------------------------------------
--  DDL for Index TBL_ENDAPRLINEINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_ENDAPRLINEINFO_PK" ON "TBL_ENDAPRLINEINFO" ("TENANT_ID", "COMPANYID", "DOCID", "APRMEMBERSN") 
  ;

--------------------------------------------------------
--  DDL for Index TBL_ENDAPRLINEINFO_APRMEMBERSN_IDX
--------------------------------------------------------

CREATE INDEX "TBL_ENDAPRLINEINFO_APRMEMBERSN_IDX" ON "TBL_ENDAPRLINEINFO" ("APRMEMBERSN")
;

--------------------------------------------------------
--  DDL for Index ENDAPRLINE_APRMEMBERID_IDX
--------------------------------------------------------

  CREATE INDEX "ENDAPRLINE_APRMEMBERID_IDX" ON "TBL_ENDAPRLINEINFO" ("APRMEMBERID")
  ;
--------------------------------------------------------
--  DDL for Index ENDAPRLINE_APRTYPE_IDX
--------------------------------------------------------

  CREATE INDEX "ENDAPRLINE_APRTYPE_IDX" ON "TBL_ENDAPRLINEINFO" ("APRTYPE")
  ;
--------------------------------------------------------
--  DDL for Index ENDAPRLINE_APRSTATE_IDX
--------------------------------------------------------

  CREATE INDEX "ENDAPRLINE_APRSTATE_IDX" ON "TBL_ENDAPRLINEINFO" ("APRSTATE")
  ;
--------------------------------------------------------
--  DDL for Index TBL_ENDAPROPINIONINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_ENDAPROPINIONINFO_PK" ON "TBL_ENDAPROPINIONINFO" ("TENANT_ID", "COMPANYID", "DOCID", "USERID", "OPINIONSN") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_ENDATTACHINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_ENDATTACHINFO_PK" ON "TBL_ENDATTACHINFO" ("TENANT_ID", "COMPANYID", "DOCID", "ATTACHFILESN") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_ENDRECEIPTPOINTINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_ENDRECEIPTPOINTINFO_PK" ON "TBL_ENDRECEIPTPOINTINFO" ("TENANT_ID", "COMPANYID", "DOCID", "RECEIPTPOINTID", "PROCESSSN") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_ENDRECEIPTPROCESSINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_ENDRECEIPTPROCESSINFO_PK" ON "TBL_ENDRECEIPTPROCESSINFO" ("TENANT_ID", "COMPANYID", "RECEIVESN", "DOCID", "RECEIVEDDEPTID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_EXPAPRDOCINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_EXPAPRDOCINFO_PK" ON "TBL_EXPAPRDOCINFO" ("TENANT_ID", "COMPANYID", "DOCID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_EXPAPRLINE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_EXPAPRLINE_PK" ON "TBL_EXPAPRLINE" ("TENANT_ID", "COMPANYID", "DOCID", "APRMEMBERSN", "ORGUSERID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_EXPENDAPRDOCINFO_NONIDX1
--------------------------------------------------------

  CREATE INDEX "TBL_EXPENDAPRDOCINFO_NONIDX1" ON "TBL_EXPENDAPRDOCINFO" ("TENANT_ID", "DOCID", "DELFLAG") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_EXPENDAPRDOCINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_EXPENDAPRDOCINFO_PK" ON "TBL_EXPENDAPRDOCINFO" ("TENANT_ID", "COMPANYID", "DOCID") 
  ;

--------------------------------------------------------
--  DDL for Index TBL_EXPENDAPRDOCINFO_DELFLAG_IDX
--------------------------------------------------------

CREATE INDEX "TBL_EXPENDAPRDOCINFO_DELFLAG_IDX" ON "TBL_EXPENDAPRDOCINFO" ("DELFLAG")
;

--------------------------------------------------------
--  DDL for Index TBL_EXPENDAPRDOCINFO_DOCID_IDX
--------------------------------------------------------

CREATE INDEX "TBL_EXPENDAPRDOCINFO_DOCID_IDX" ON "TBL_EXPENDAPRDOCINFO" ("DOCID")
;

--------------------------------------------------------
--  DDL for Index TBL_EXPENDAPRDOCINFO_SECURITYCODE_IDX
--------------------------------------------------------

CREATE INDEX "TBL_EXPENDAPRDOCINFO_SECURITYCODE_IDX" ON "TBL_EXPENDAPRDOCINFO" ("SECURITYCODE")
;

--------------------------------------------------------
--  DDL for Index TBL_EXPENDAPRLINE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_EXPENDAPRLINE_PK" ON "TBL_EXPENDAPRLINE" ("TENANT_ID", "COMPANYID", "ORGUSERID", "APRMEMBERSN", "DOCID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_EXPENDAPRLINE_LINEJOINIDX
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_EXPENDAPRLINE_LINEJOINIDX" ON "TBL_EXPENDAPRLINE" ("TENANT_ID", "COMPANYID", "APRMEMBERSN", "DOCID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_FORMCONNINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_FORMCONNINFO_PK" ON "TBL_FORMCONNINFO" ("SN") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_FORMCONTAINER_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_FORMCONTAINER_PK" ON "TBL_FORMCONTAINER" ("TENANT_ID", "COMPANYID", "FORMCONTID", "FORMCONTNAME", "FORMCONTOWNDEPID", "FORMCONTPARENTS") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_FORMCONTUSERGROUP_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_FORMCONTUSERGROUP_PK" ON "TBL_FORMCONTUSERGROUP" ("TENANT_ID", "COMPANYID", "FORMCONTID", "FORMCONTUSERDEPID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_FORMGROUP_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_FORMGROUP_PK" ON "TBL_FORMGROUP" ("TENANT_ID", "COMPANYID", "SN") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_FORMINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_FORMINFO_PK" ON "TBL_FORMINFO" ("TENANT_ID", "COMPANYID", "FORMID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_FORMPROPERTY_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_FORMPROPERTY_PK" ON "TBL_FORMPROPERTY" ("TENANT_ID", "COMPANYID", "SN") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_FORMRECV_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_FORMRECV_PK" ON "TBL_FORMRECV" ("TENANT_ID", "COMPANYID", "FORMID", "DEPTID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_FORMUSERINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_FORMUSERINFO_PK" ON "TBL_FORMUSERINFO" ("TENANT_ID", "COMPANYID", "FORMID", "USERID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_FORM_OFFICE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_FORM_OFFICE_PK" ON "TBL_FORM_OFFICE" ("FORMID", "TENANT_ID", "COMPANYID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_HISTORYATTACHINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_HISTORYATTACHINFO_PK" ON "TBL_HISTORYATTACHINFO" ("TENANT_ID", "COMPANYID", "DOCID", "ATTACHFILESN", "MODIFYSN") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_HISTORYDOCINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_HISTORYDOCINFO_PK" ON "TBL_HISTORYDOCINFO" ("TENANT_ID", "COMPANYID", "DOCID", "CHANGESN") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_HISTORYLINEINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_HISTORYLINEINFO_PK" ON "TBL_HISTORYLINEINFO" ("TENANT_ID", "COMPANYID", "DOCID", "APRMEMBERSN", "MODIFYSN") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_LASTAPRLINE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_LASTAPRLINE_PK" ON "TBL_LASTAPRLINE" ("TENANT_ID", "COMPANYID", "USERID", "FORMID", "APRMEMBERSN", "DOCSTATE") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_LASTDEPTLINE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_LASTDEPTLINE_PK" ON "TBL_LASTDEPTLINE" ("TENANT_ID", "COMPANYID", "USERID", "FORMID", "RECEIPTPOINTID", "DOCSTATE") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_LASTDOCID_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_LASTDOCID_PK" ON "TBL_LASTDOCID" ("TENANT_ID", "COMPANYID", "LASTDOCID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_LINTEMPLETDETAIL_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_LINTEMPLETDETAIL_PK" ON "TBL_LINTEMPLETDETAIL" ("TENANT_ID", "COMPANYID", "USERID", "FORMID", "APRLINESN", "APRMEMBERSN") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_LINTEMPLET_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_LINTEMPLET_PK" ON "TBL_LINTEMPLET" ("TENANT_ID", "COMPANYID", "USERID", "FORMID", "APRLINESN") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_LISTINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_LISTINFO_PK" ON "TBL_LISTINFO" ("TENANT_ID", "COMPANYID", "LISTTYPE", "SN") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_LISTOPTION_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_LISTOPTION_PK" ON "TBL_LISTOPTION" ("TENANT_ID", "COMPANYID", "LISTTYPE", "SN") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_MYTASKCODE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_MYTASKCODE_PK" ON "TBL_MYTASKCODE" ("TENANT_ID", "COMPANYID", "CN", "DEPTID", "CABINETID", "TASKCODE") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_NOTIFICATION_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_NOTIFICATION_PK" ON "TBL_NOTIFICATION" ("TENANT_ID", "COMPANYID", "ITEMSEQ") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_OLDCABINETEXTRAINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_OLDCABINETEXTRAINFO_PK" ON "TBL_OLDCABINETEXTRAINFO" ("TENANT_ID", "COMPANYID", "CABINETCLASSNO") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_OLDRECORDEXTRAINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_OLDRECORDEXTRAINFO_PK" ON "TBL_OLDRECORDEXTRAINFO" ("TENANT_ID", "COMPANYID", "RECORDID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_OPENGOVDOCINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_OPENGOVDOCINFO_PK" ON "TBL_OPENGOVDOCINFO" ("DOCID", "TENANT_ID", "COMPANYID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_OPENGOVFILEINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_OPENGOVFILEINFO_PK" ON "TBL_OPENGOVFILEINFO" ("DOCID", "SN", "COMPANYID", "TENANT_ID") 
  ;
  
--------------------------------------------------------
--  DDL for Index TBL_OPENGOVMODIFYHISTORY_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_OPENGOVMODIFYHISTORY_PK" ON "TBL_OPENGOVMODIFYHISTORY" ("DOCID", "SN", "COMPANYID", "TENANTID") 
  ;

-------------------------------------------------------- 
--  DDL for Index PK2_TBL_PASSWORD_POLICY
--------------------------------------------------------
  CREATE UNIQUE INDEX "PK2_TBL_PASSWORD_POLICY" ON "TBL_PASSWORD_POLICY" ("TENANT_ID", "COMPANY_ID") 
  ;

--------------------------------------------------------
--  DDL for Index PK2_TBL_PASSWORD_POLICY_PATTERN

-- 오라클에서는 DB 객체 이름으로 30자까지만 지원하여, ORA-00972: identifier is too long 에러가 남.
-- 테이블을 포함해 DB 객체의 이름을 정할 때 30자가 넘지 않도록 주의해야 함.

-- ezFlow>sqlmap 아래로 찾아봤을때는 PK2_TBL_PASSWORD_POLICY_PATTERN 를 직접적으로 쓰는 곳은 없는것으로 보여서
-- _PATTERN => _PATT 으로 변경, 뒤에 세 글자를 지우게 되었음.
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK2_TBL_PASSWORD_POLICY_PATT" ON "TBL_PASSWORD_POLICY_PATTERN" ("TENANT_ID", "COMPANY_ID", "USE_PATTERN_COUNT")
  ;
  
--------------------------------------------------------
--  DDL for Index TBL_GOVSENDDOCHISTORY_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_GOVSENDDOCHISTORY_PK" ON "TBL_GOVSENDDOCHISTORY" ("SN") 
  ;  
  
--------------------------------------------------------
--  DDL for Index TBL_PORTAL_FRAME_COMP_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_PORTAL_FRAME_COMP_PK" ON "TBL_PORTAL_FRAME_COMP" ("COMPANY_ID", "TENANT_ID", "THEME_ID", "FRAME_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_PORTAL_FRAME_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_PORTAL_FRAME_PK" ON "TBL_PORTAL_FRAME" ("FRAME_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_PORTAL_LOGO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_PORTAL_LOGO_PK" ON "TBL_PORTAL_LOGO" ("COMPANY_ID", "TENANT_ID", "LOGO_TYPE") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_PORTAL_MENU_AUTH_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_PORTAL_MENU_AUTH_PK" ON "TBL_PORTAL_MENU_AUTH" ("MENU_ID", "COMPANY_ID", "TENANT_ID", "USER_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_PORTAL_MENU_COMP_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_PORTAL_MENU_COMP_PK" ON "TBL_PORTAL_MENU_COMP" ("COMPANY_ID", "TENANT_ID", "MENU_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_PORTAL_MENU_NAME_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_PORTAL_MENU_NAME_PK" ON "TBL_PORTAL_MENU_NAME" ("MENU_ID", "MENU_LANG", "COMPANY_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_PORTAL_MENU_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_PORTAL_MENU_PK" ON "TBL_PORTAL_MENU" ("MENU_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_PORTAL_MENU_USER_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_PORTAL_MENU_USER_PK" ON "TBL_PORTAL_MENU_USER" ("USER_ID", "TENANT_ID", "COMPANY_ID", "MENU_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_PORTAL_PORTLET_AUTH_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_PORTAL_PORTLET_AUTH_PK" ON "TBL_PORTAL_PORTLET_AUTH" ("PORTLET_ID", "COMPANY_ID", "TENANT_ID", "USER_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_PORTAL_PORTLET_COMP_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_PORTAL_PORTLET_COMP_PK" ON "TBL_PORTAL_PORTLET_COMP" ("COMPANY_ID", "TENANT_ID", "PORTLET_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_PORTAL_PORTLET_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_PORTAL_PORTLET_PK" ON "TBL_PORTAL_PORTLET" ("PORTLET_ID", "MENU_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_PORTAL_PORTLET_USER_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_PORTAL_PORTLET_USER_PK" ON "TBL_PORTAL_PORTLET_USER" ("USER_ID", "TENANT_ID", "COMPANY_ID", "PORTLET_ID", "THEME_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_PORTAL_STARTPAGE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_PORTAL_STARTPAGE_PK" ON "TBL_PORTAL_STARTPAGE" ("USER_ID", "TENANT_ID", "COMPANY_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_PORTAL_THEME_AUTH_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_PORTAL_THEME_AUTH_PK" ON "TBL_PORTAL_THEME_AUTH" ("THEME_ID", "COMPANY_ID", "TENANT_ID", "USER_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_PORTAL_THEME_COMP_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_PORTAL_THEME_COMP_PK" ON "TBL_PORTAL_THEME_COMP" ("COMPANY_ID", "TENANT_ID", "THEME_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_PORTAL_THEME_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_PORTAL_THEME_PK" ON "TBL_PORTAL_THEME" ("THEME_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_PORTAL_THEME_USER_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_PORTAL_THEME_USER_PK" ON "TBL_PORTAL_THEME_USER" ("USER_ID", "COMPANY_ID", "TENANT_ID", "USED_THEME") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_PS_EMPMONTH_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_PS_EMPMONTH_PK" ON "TBL_PS_EMPMONTH" ("TENANT_ID", "COMPANY", "TERM") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_PS_SHAREAPPROVAL_UK1
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_PS_SHAREAPPROVAL_UK1" ON "TBL_PS_SHAREAPPROVAL" ("OWNERID", "TENANTID", "SHAREUSERID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_RECEIPTPOINTINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_RECEIPTPOINTINFO_PK" ON "TBL_RECEIPTPOINTINFO" ("TENANT_ID", "COMPANYID", "DOCID", "RECEIPTPOINTID", "PROCESSSN") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_RECEXCHINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_RECEXCHINFO_PK" ON "TBL_RECEXCHINFO" ("COMPANYID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_RECORDHISTORY_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_RECORDHISTORY_PK" ON "TBL_RECORDHISTORY" ("TENANT_ID", "COMPANYID", "RECORDID", "SEPERATEATTACHNO", "VERSION") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_RECORD_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_RECORD_PK" ON "TBL_RECORD" ("TENANT_ID", "COMPANYID", "RECORDID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_RECORD_TEMP_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_RECORD_TEMP_PK" ON "TBL_RECORD_TEMP" ("COMPANYID", "TENANT_ID", "DOCID") 
  ;

--------------------------------------------------------
--  DDL for Index TBL_RECORD_DOCID_IDX
--------------------------------------------------------

CREATE INDEX "TBL_RECORD_DOCID_IDX" ON "TBL_RECORD" ("DOCID")
;

--------------------------------------------------------
--  DDL for Index TBL_RECORD_RECORDID_IDX
--------------------------------------------------------

CREATE INDEX "TBL_RECORD_RECORDID_IDX" ON "TBL_RECORD" ("RECORDID")
;

--------------------------------------------------------
--  DDL for Index TBL_RECORD_REGISTERDATE_IDX
--------------------------------------------------------

CREATE INDEX "TBL_RECORD_REGISTERDATE_IDX" ON "TBL_RECORD" ("REGISTERDATE")
;

--------------------------------------------------------
--  DDL for Index TBL_RECORD_CREATEDATE_IDX
--------------------------------------------------------

CREATE INDEX "TBL_RECORD_CREATEDATE_IDX" ON "TBL_RECORD" ("CREATEDATE")
;

--------------------------------------------------------
--  DDL for Index TBL_RECORD_DOCTYPE_IDX
--------------------------------------------------------

CREATE INDEX "TBL_RECORD_DOCTYPE_IDX" ON "TBL_RECORD" ("DOCTYPE")
;

--------------------------------------------------------
--  DDL for Index TBL_RECORD_DELFLAG_IDX
--------------------------------------------------------

CREATE INDEX "TBL_RECORD_DELFLAG_IDX" ON "TBL_RECORD" ("DELFLAG")
;

--------------------------------------------------------
--  DDL for Index TBL_RECREADHISTORY_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_RECREADHISTORY_PK" ON "TBL_RECREADHISTORY" ("TENANT_ID", "COMPANYID", "SERIALNO", "DOCID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_RECREADHISTORY_DOCID_IDX
--------------------------------------------------------

  CREATE INDEX TBL_RECREADHISTORY_DOCID_IDX ON "TBL_RECREADHISTORY" ("DOCID")
  ;
--------------------------------------------------------
--  DDL for Index TBL_RECRELAYINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_RECRELAYINFO_PK" ON "TBL_RECRELAYINFO" ("IDX", "XDOCID", "TENANT_ID", "COMPANYID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_RECROLEINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_RECROLEINFO_PK" ON "TBL_RECROLEINFO" ("TENANT_ID", "COMPANYID", "RECORDID", "SEPERATEATTACHNO", "USERID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_RECROLEINFO_TEMP_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_RECROLEINFO_TEMP_PK" ON "TBL_RECROLEINFO_TEMP" ("DOCID", "TENANT_ID", "COMPANYID", "SEPERATEATTACHNO", "USERID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_RS_ATTACH_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_RS_ATTACH_PK" ON "TBL_RS_ATTACH" ("ATTACHID", "COMPANYID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_RS_PERSPORTLET_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_RS_PERSPORTLET_PK" ON "TBL_RS_PERSPORTLET" ("TENANT_ID", "CN", "BRD_COMPANY", "BRD_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_SCHEDULEREPETITION_DEL_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_SCHEDULEREPETITION_DEL_PK" ON "TBL_SCHEDULEREPETITION_DEL" ("REPETITIONID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_SEPERATEATTACH_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_SEPERATEATTACH_PK" ON "TBL_SEPERATEATTACH" ("TENANT_ID", "COMPANYID", "RECORDID", "SEPERATEATTACHNO") 
  ;

--------------------------------------------------------
--  DDL for Index TBL_SEPERATEATTACH_CABINETID_IDX
--------------------------------------------------------

CREATE INDEX "TBL_SEPERATEATTACH_CABINETID_IDX" ON "TBL_SEPERATEATTACH" ("CABINETID")
;

--------------------------------------------------------
--  DDL for Index TBL_SEPERATEATTACH_CONFIRMFLAG_IDX
--------------------------------------------------------

CREATE INDEX "TBL_SEPERATEATTACH_CONFIRMFLAG_IDX" ON "TBL_SEPERATEATTACH" ("CONFIRMFLAG")
;

--------------------------------------------------------
--  DDL for Index TBL_SEPERATEATTACH_RECORDID_IDX
--------------------------------------------------------

CREATE INDEX "TBL_SEPERATEATTACH_RECORDID_IDX" ON "TBL_SEPERATEATTACH" ("RECORDID")
;

--------------------------------------------------------
--  DDL for Index TBL_SEPERATEATTACH_REGISTERTYPE_IDX
--------------------------------------------------------

CREATE INDEX "TBL_SEPERATEATTACH_REGISTERTYPE_IDX" ON "TBL_SEPERATEATTACH" ("REGISTERTYPE")
;

--------------------------------------------------------
--  DDL for Index TBL_SEPERATEATTACH_SEPERATEATTACHNO_IDX
--------------------------------------------------------

CREATE INDEX "TBL_SEPERATEATTACH_SEPERATEATTACHNO_IDX" ON "TBL_SEPERATEATTACH" ("SEPERATEATTACHNO")
;

--------------------------------------------------------
--  DDL for Index TBL_SEPERATEATTACH_DELFLAG_IDX
--------------------------------------------------------

CREATE INDEX "TBL_SEPERATEATTACH_DELFLAG_IDX" ON "TBL_SEPERATEATTACH" ("DELFLAG")
;

--------------------------------------------------------
--  DDL for Index TBL_SEPERATEATTACH_TEMP_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_SEPERATEATTACH_TEMP_PK" ON "TBL_SEPERATEATTACH_TEMP" ("TENANT_ID", "COMPANYID", "DOCID", "SEPERATEATTACHNO") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_SERIALNUMGEN_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_SERIALNUMGEN_PK" ON "TBL_SERIALNUMGEN" ("IDX") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_SIGNINFO_PK1
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_SIGNINFO_PK1" ON "TBL_SIGNINFO" ("TENANT_ID", "COMPANYID", "DOCID", "APRSN", "SIGNNAME") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_SPECIALCATALOGINFO_REC_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_SPECIALCATALOGINFO_REC_PK" ON "TBL_SPECIALCATALOGINFO_REC" ("TENANT_ID", "COMPANYID", "RECORDID", "SERIALNO") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_SPECIALCATALOGINFO_TMP_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_SPECIALCATALOGINFO_TMP_PK" ON "TBL_SPECIALCATALOGINFO_TMP" ("DOCID", "TENANT_ID", "COMPANYID", "RECORDID", "SERIALNO") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_SPECIALCONTAINERINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_SPECIALCONTAINERINFO_PK" ON "TBL_SPECIALCONTAINERINFO" ("TENANT_ID", "COMPANYID", "DEPTID", "CONTTYPE", "SN") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_TASKCODE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_TASKCODE_PK" ON "TBL_TASKCODE" ("TENANT_ID", "COMPANYID", "TASKCODE") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_TASKGENERAL_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_TASKGENERAL_PK" ON "TBL_TASKGENERAL" ("USERID", "TENANTID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_TASK_DEPTINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_TASK_DEPTINFO_PK" ON "TBL_TASK_DEPTINFO" ("PROCESSDEPTCODE", "TASKCODE", "TENANT_ID", "COMPANYID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_TASK_INDEX
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_TASK_INDEX" ON "TBL_TASK" ("TASKID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_TMPAPRDOCATTACHINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_TMPAPRDOCATTACHINFO_PK" ON "TBL_TMPAPRDOCATTACHINFO" ("TENANT_ID", "COMPANYID", "OWNERID", "SN", "ATTACHSN") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_TMPAPRDOCINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_TMPAPRDOCINFO_PK" ON "TBL_TMPAPRDOCINFO" ("TENANT_ID", "COMPANYID", "OWNERID", "SN") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_TMPAPRLINEINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_TMPAPRLINEINFO_PK" ON "TBL_TMPAPRLINEINFO" ("TENANT_ID", "COMPANYID", "OWNERID", "SN", "APRMEMBERSN") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_TMPAPROPINIONINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_TMPAPROPINIONINFO_PK" ON "TBL_TMPAPROPINIONINFO" ("TENANT_ID", "COMPANYID", "OWNERID", "SN", "OPINIONSN") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_TMPATTACHINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_TMPATTACHINFO_PK" ON "TBL_TMPATTACHINFO" ("TENANT_ID", "COMPANYID", "OWNERID", "SN", "ATTACHFILESN") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_TMPEXPAPRLINE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_TMPEXPAPRLINE_PK" ON "TBL_TMPEXPAPRLINE" ("TENANT_ID", "COMPANYID", "OWNERID", "SN", "APRMEMBERSN") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_TMPRECEIPTPOINTINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_TMPRECEIPTPOINTINFO_PK" ON "TBL_TMPRECEIPTPOINTINFO" ("TENANT_ID", "COMPANYID", "OWNERID", "SN", "RECEIPTPOINTID") 
  ;
--------------------------------------------------------
--  DDL for Index 
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_USERCONTLIST_PK" ON "TBL_USERCONTLIST" ("TENANT_ID", "COMPANYID", "USERCONTID", "DOCID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_USERCONT_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_USERCONT_PK" ON "TBL_USERCONT" ("TENANT_ID", "COMPANYID", "USERCONTID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_USERMOBILEINFO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_USERMOBILEINFO_PK" ON "TBL_USERMOBILEINFO" ("USERID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_USER_CONFIG_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_USER_CONFIG_PK" ON "TBL_USER_CONFIG" ("TENANT_ID", "PROPERTY_NAME", "USER_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_USER_JOBMASTER_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_USER_JOBMASTER_PK" ON "TBL_USER_JOBMASTER" ("JOBID", "TYPE", "COMPANYID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_USER_MULTILOGIN_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_USER_MULTILOGIN_PK" ON "TBL_USER_MULTILOGIN" ("USER_ID", "MOBILE_FLAG", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_WEATHER_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_WEATHER_PK" ON "TBL_WEATHER" ("CITYCODE") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_WEATHER_USER_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_WEATHER_USER_PK" ON "TBL_WEATHER_USER" ("USERID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_WEBFOLDER_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_WEBFOLDER_PK" ON "TBL_WEBFOLDER_SHARE_SUB" ("SEQ_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_WEBFOLDER_SHARE_HIDE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_WEBFOLDER_SHARE_HIDE_PK" ON "TBL_WEBFOLDER_SHARE_HIDE" ("SEQ_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_WEBFOLDER_SHARE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_WEBFOLDER_SHARE_PK" ON "TBL_WEBFOLDER_SHARE" ("SHARE_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_WEBFOLDER_SHARE_UK1
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_WEBFOLDER_SHARE_UK1" ON "TBL_WEBFOLDER_SHARE" ("FOLDERFILE_ID", "FOLDERFILE_TYPE", "SHARER_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index WEBFOLDER_ENCRYPTED_FILE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "WEBFOLDER_ENCRYPTED_FILE_PK" ON "TBL_WEBFOLDER_ENCRYPTED_FILE" ("FILE_ID", "VERSION", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index WEBFOLDER_ENCRYPTION_FOLDER_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "WEBFOLDER_ENCRYPTION_FOLDER_PK" ON "TBL_WEBFOLDER_ENC_FOLDER" ("FOLDER_ID", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_TBL_WEBFOLDER_FILE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_WEBFOLDER_FILE" ON "TBL_WEBFOLDER_FILE" ("TENANT_ID", "FILE_ID") 
  ;
  CREATE INDEX "IDX_WEBFOLDER_FILE_FOLDER_ID" ON "TBL_WEBFOLDER_FILE" ("FOLDER_ID"); 
  
--------------------------------------------------------
--  DDL for Index PK_TBL_WEBFOLDER_LOG
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_TBL_WEBFOLDER_LOG" ON "TBL_WEBFOLDER_LOG" ("TENANT_ID", "LOG_ID") 
  ;
--------------------------------------------------------
--  DDL for Index TBL_WEBFOLDER_FILE_HISTORY
--------------------------------------------------------

  CREATE UNIQUE INDEX "TBL_WEBFOLDER_FILE_HISTORY" ON "TBL_WEBFOLDER_FILE_HISTORY" ("FILE_ID", "VERSION", "TENANT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index U_JMS_PTN_USER_NAME
--------------------------------------------------------

  CREATE INDEX "U_JMS_PTN_USER_NAME" ON "JAMES_SUBSCRIPTION" ("USER_NAME", "MAILBOX_NAME") 
  ;
-------------------------------------------------------- 
--  DDL for Index JMOCHA_MAIL_OOO_TEM_PK
--------------------------------------------------------

  CREATE INDEX "JMOCHA_MAIL_OOO_TEM_PK" ON "JMOCHA_MAIL_OUTOFOFFICE_TEM" ("USER_ID", "DISPLAYNAME")
  ;
-------------------------------------------------------- 
--  DDL for Index JMOCHA_USER_MAIL_TEMPLATE_PK
--------------------------------------------------------

  CREATE INDEX "JMOCHA_USER_MAIL_TEMPLATE_PK" ON "JMOCHA_USER_MAIL_TEMPLATE" ("USER_ID", "DISPLAYNAME") 
  ;
-------------------------------------------------------- 
--  DDL for Index JMOCHA_MAILBOX_PROGRESS_PK
--------------------------------------------------------

  CREATE INDEX "JMOCHA_MAILBOX_PROGRESS_PK" ON "JMOCHA_MAILBOX_PROGRESS" ("USER_KEY", "TENANT_ID") 
  ;
-------------------------------------------------------- 
--  DDL for Index JMOCHA_APPR_ALLOWED_DOMAIN_PK
-------------------------------------------------------- 

  CREATE INDEX "JMOCHA_APPR_ALLOWED_DOMAIN_PK" ON "JMOCHA_APPR_ALLOWED_DOMAIN" ("COMPANY_ID", "TENANT_ID", "DOMAIN_NAME") 
  ;
-------------------------------------------------------- 
--  DDL for Index JMOCHA_APPR_USER_PK
--------------------------------------------------------

  CREATE INDEX "JMOCHA_APPR_USER_PK" ON "JMOCHA_APPR_USER" ("COMPANY_ID", "TENANT_ID", "USER_ID", "USER_TYPE") 
  ;
-------------------------------------------------------- 
--  DDL for Index JMOCHA_APPR_HISTORY_PK
--------------------------------------------------------

  CREATE INDEX "JMOCHA_APPR_HISTORY_PK" ON "JMOCHA_APPR_HISTORY" ("TENANT_ID", "MAIL_UID", "USER_ID") 
  ;
-------------------------------------------------------- 
--  DDL for Index JMOCHA_APPR_COMP_HISTORY_PK
--------------------------------------------------------

  CREATE INDEX "JMOCHA_APPR_COMP_HISTORY_PK" ON "JMOCHA_APPR_COMP_HISTORY" ("TENANT_ID", "MAIL_UID", "USER_ID") 
  ;
--------------------------------------------------------
--  DDL for Trigger TRG_TBL_ADMINRECEIPTGROUP_MAIN
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_TBL_ADMINRECEIPTGROUP_MAIN" BEFORE INSERT ON TBL_ADMINRECEIPTGROUP_MAIN
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.MAINID IS NULL THEN
    SELECT  SEQ_TBL_ADMINRECEIPTGROUP_MAIN.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(MAINID),0) INTO v_newVal FROM TBL_ADMINRECEIPTGROUP_MAIN;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT SEQ_TBL_ADMINRECEIPTGROUP_MAIN.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
  -- save this to emulate @@identity
  --utils.identity_value := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.MAINID := v_newVal;
  END IF;
END;
/
ALTER TRIGGER "TRG_TBL_ADMINRECEIPTGROUP_MAIN" DISABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_TBL_ADMINRECEIPTGROUP_SUB
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_TBL_ADMINRECEIPTGROUP_SUB" BEFORE INSERT ON TBL_ADMINRECEIPTGROUP_SUB
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.SUBID IS NULL THEN
    SELECT  SEQ_TBL_ADMINRECEIPTGROUP_SUB.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(SUBID),0) INTO v_newVal FROM TBL_ADMINRECEIPTGROUP_SUB;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT SEQ_TBL_ADMINRECEIPTGROUP_SUB.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
  -- save this to emulate @@identity
  --utils.identity_value := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.SUBID := v_newVal;
  END IF;
END;
/
ALTER TRIGGER "TRG_TBL_ADMINRECEIPTGROUP_SUB" DISABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_TBL_COMM_SCHEDULE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_TBL_COMM_SCHEDULE" BEFORE INSERT ON TBL_COMM_SCHEDULE
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.ScheduleID IS NULL THEN
    SELECT  SEQ_TBL_COMM_SCHEDULE.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(ScheduleID),0) INTO v_newVal FROM TBL_COMM_SCHEDULE;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT SEQ_TBL_COMM_SCHEDULE.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
  -- save this to emulate @@identity
  --utils.identity_value := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.ScheduleID := v_newVal;
  END IF;
END;
/
ALTER TRIGGER "TRG_TBL_COMM_SCHEDULE" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_TBL_COMM_SCHEDULEATTACH
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_TBL_COMM_SCHEDULEATTACH" BEFORE INSERT ON TBL_COMM_SCHEDULEATTACH
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.AttachID IS NULL THEN
    SELECT  SEQ_TBL_COMM_SCHEDULEATTACH.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(AttachID),0) INTO v_newVal FROM TBL_COMM_SCHEDULEATTACH;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT SEQ_TBL_COMM_SCHEDULE.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
  -- save this to emulate @@identity
  --utils.identity_value := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.AttachID := v_newVal;
  END IF;
END;
/
ALTER TRIGGER "TRG_TBL_COMM_SCHEDULEATTACH" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_TBL_COMM_SCHEDULECOMMENT
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_TBL_COMM_SCHEDULECOMMENT" BEFORE INSERT ON TBL_COMM_SCHEDULECOMMENT
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.CommentID IS NULL THEN
    SELECT  SEQ_TBL_COMM_SCHEDULECOMMENT.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(CommentID),0) INTO v_newVal FROM TBL_COMM_SCHEDULECOMMENT;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT SEQ_TBL_COMM_SCHEDULECOMMENT.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
  -- save this to emulate @@identity
  --utils.identity_value := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.CommentID := v_newVal;
  END IF;
END;
/
ALTER TRIGGER "TRG_TBL_COMM_SCHEDULECOMMENT" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_TBL_C_BOARD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_TBL_C_BOARD" BEFORE INSERT ON TBL_C_BOARD
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.no IS NULL THEN
    SELECT  SEQ_TBL_C_BOARD.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(no),0) INTO v_newVal FROM TBL_C_BOARD;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT SEQ_TBL_C_BOARD.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
  -- save this to emulate @@identity
  --utils.identity_value := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.no := v_newVal;
  END IF;
END;
/
ALTER TRIGGER "TRG_TBL_C_BOARD" DISABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_TBL_C_CLUBGUEST
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_TBL_C_CLUBGUEST" BEFORE INSERT ON TBL_C_CLUBGUEST
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.no IS NULL THEN
    SELECT  SEQ_TBL_C_CLUBGUEST.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(no),0) INTO v_newVal FROM TBL_C_CLUBGUEST;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT SEQ_TBL_C_CLUBGUEST.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
  -- save this to emulate @@identity
  --utils.identity_value := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.no := v_newVal;
  END IF;
END;
/
ALTER TRIGGER "TRG_TBL_C_CLUBGUEST" DISABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_TBL_C_CLUBNOTICE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_TBL_C_CLUBNOTICE" BEFORE INSERT ON TBL_C_CLUBNOTICE
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.no IS NULL THEN
    SELECT  SEQ_TBL_C_CLUBNOTICE.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(no),0) INTO v_newVal FROM TBL_C_CLUBNOTICE;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT SEQ_TBL_C_CLUBNOTICE.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
  -- save this to emulate @@identity
  --utils.identity_value := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.no := v_newVal;
  END IF;
END;
/
ALTER TRIGGER "TRG_TBL_C_CLUBNOTICE" DISABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_TBL_C_NOTICE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_TBL_C_NOTICE" BEFORE INSERT ON TBL_C_NOTICE
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.no IS NULL THEN
    SELECT  SEQ_TBL_C_NOTICE.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(no),0) INTO v_newVal FROM TBL_C_NOTICE;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT SEQ_TBL_C_NOTICE.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
  -- save this to emulate @@identity
  --utils.identity_value := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.no := v_newVal;
  END IF;
END;
/
ALTER TRIGGER "TRG_TBL_C_NOTICE" DISABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_TBL_C_POLLANSWER
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_TBL_C_POLLANSWER" BEFORE INSERT ON TBL_C_POLLANSWER
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.answerID IS NULL THEN
    SELECT  SEQ_TBL_C_POLLANSWER.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(answerID),0) INTO v_newVal FROM TBL_C_POLLANSWER;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT SEQ_TBL_C_POLLANSWER.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
  -- save this to emulate @@identity
  --utils.identity_value := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.answerID := v_newVal;
  END IF;
END;
/
ALTER TRIGGER "TRG_TBL_C_POLLANSWER" DISABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_TBL_C_POLLMANAGER
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_TBL_C_POLLMANAGER" BEFORE INSERT ON TBL_C_POLLMANAGER
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.managerID IS NULL THEN
    SELECT  SEQ_TBL_C_POLLMANAGER.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(managerID),0) INTO v_newVal FROM TBL_C_POLLMANAGER;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT SEQ_TBL_C_POLLMANAGER.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
  -- save this to emulate @@identity
  --utils.identity_value := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.managerID := v_newVal;
  END IF;
END;
/
ALTER TRIGGER "TRG_TBL_C_POLLMANAGER" DISABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_TBL_C_POLLQUESTION
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_TBL_C_POLLQUESTION" BEFORE INSERT ON TBL_C_POLLQUESTION
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.questionID IS NULL THEN
    SELECT  SEQ_TBL_C_POLLQUESTION.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(questionID),0) INTO v_newVal FROM TBL_C_POLLQUESTION;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT SEQ_TBL_C_POLLQUESTION.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
  -- save this to emulate @@identity
  --utils.identity_value := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.questionID := v_newVal;
  END IF;
END;
/
ALTER TRIGGER "TRG_TBL_C_POLLQUESTION" DISABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_TBL_C_POLLRESPONSE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_TBL_C_POLLRESPONSE" BEFORE INSERT ON TBL_C_POLLRESPONSE
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.responseID IS NULL THEN
    SELECT  SEQ_TBL_C_POLLRESPONSE.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(responseID),0) INTO v_newVal FROM TBL_C_POLLRESPONSE;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT SEQ_TBL_C_POLLRESPONSE.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
  -- save this to emulate @@identity
  --utils.identity_value := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.responseID := v_newVal;
  END IF;
END;
/
ALTER TRIGGER "TRG_TBL_C_POLLRESPONSE" DISABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_TBL_HOLIDAYLIST
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_TBL_HOLIDAYLIST" BEFORE INSERT ON TBL_HOLIDAYLIST
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.HolidayID IS NULL THEN
    SELECT  SEQ_TBL_HOLIDAYLIST.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(HolidayID),0) INTO v_newVal FROM TBL_HOLIDAYLIST;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT SEQ_TBL_HOLIDAYLIST.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
  -- save this to emulate @@identity
  --utils.identity_value := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.HolidayID := v_newVal;
  END IF;
END;
/
ALTER TRIGGER "TRG_TBL_HOLIDAYLIST" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_TBL_NOTIFICATION_ITEMSEQ
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_TBL_NOTIFICATION_ITEMSEQ" BEFORE INSERT ON TBL_NOTIFICATION
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.ItemSeq IS NULL THEN
    SELECT  SEQ_TBL_NOTIFICATION_ITEMSEQ.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(ItemSeq),0) INTO v_newVal FROM TBL_NOTIFICATION;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT SEQ_TBL_NOTIFICATION_ITEMSEQ.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
  -- save this to emulate @@identity
  -- utils.identity_value := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.ItemSeq := v_newVal;
  END IF;
END;

/
ALTER TRIGGER "TRG_TBL_NOTIFICATION_ITEMSEQ" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_TBL_PS_LIGHTPOLL_ITEMSEQ
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_TBL_PS_LIGHTPOLL_ITEMSEQ" BEFORE INSERT ON TBL_PS_LIGHTPOLL
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.ItemSeq IS NULL THEN
    SELECT  SEQ_TBL_PS_LIGHTPOLL_ITEMSEQ.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(ItemSeq),0) INTO v_newVal FROM TBL_PS_LIGHTPOLL;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT SEQ_TBL_PS_LIGHTPOLL_ITEMSEQ.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
  -- save this to emulate @@identity
  -- utils.identity_value := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.ItemSeq := v_newVal;
  END IF;
END;
/
ALTER TRIGGER "TRG_TBL_PS_LIGHTPOLL_ITEMSEQ" DISABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_TBL_PS_NOTICE_ITEMSEQ
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_TBL_PS_NOTICE_ITEMSEQ" BEFORE INSERT ON TBL_PS_NOTICE
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.ItemSeq IS NULL THEN
    SELECT  SEQ_TBL_PS_NOTICE_ITEMSEQ.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(ItemSeq),0) INTO v_newVal FROM TBL_PS_NOTICE;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT SEQ_TBL_PS_NOTICE_ITEMSEQ.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
  -- save this to emulate @@identity
  -- utils.identity_value := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.ItemSeq := v_newVal;
  END IF;
END;
/
ALTER TRIGGER "TRG_TBL_PS_NOTICE_ITEMSEQ" DISABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_TBL_PS_POPUP_ITEMSEQ
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_TBL_PS_POPUP_ITEMSEQ" BEFORE INSERT ON TBL_PS_POPUP
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.ItemSeq IS NULL THEN
    SELECT  SEQ_TBL_PS_POPUP_ITEMSEQ.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(ItemSeq),0) INTO v_newVal FROM TBL_PS_POPUP;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT SEQ_TBL_PS_POPUP_ITEMSEQ.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
  -- save this to emulate @@identity
  -- utils.identity_value := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.ItemSeq := v_newVal;
  END IF;
END;
/
ALTER TRIGGER "TRG_TBL_PS_POPUP_ITEMSEQ" DISABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_TBL_SCHEDULE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_TBL_SCHEDULE" BEFORE INSERT ON TBL_SCHEDULE
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.ScheduleID IS NULL THEN
    SELECT  SEQ_TBL_SCHEDULE.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(ScheduleID),0) INTO v_newVal FROM TBL_SCHEDULE;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT SEQ_TBL_SCHEDULE.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
  -- save this to emulate @@identity
  --utils.identity_value := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.ScheduleID := v_newVal;
  END IF;
END;
/
ALTER TRIGGER "TRG_TBL_SCHEDULE" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_TBL_SCHEDULEATTACH
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_TBL_SCHEDULEATTACH" BEFORE INSERT ON TBL_SCHEDULEATTACH
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.AttachID IS NULL THEN
    SELECT  SEQ_TBL_SCHEDULEATTACH.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(AttachID),0) INTO v_newVal FROM TBL_SCHEDULEATTACH;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT SEQ_TBL_SCHEDULEATTACH.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
  -- save this to emulate @@identity
  --utils.identity_value := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.AttachID := v_newVal;
  END IF;
END;
/
ALTER TRIGGER "TRG_TBL_SCHEDULEATTACH" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_TBL_SCHEDULE_PUBLIC_DEPT
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_TBL_SCHEDULE_PUBLIC_DEPT" BEFORE INSERT ON TBL_SCHEDULE_PUBLIC_DEPT
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.Idx IS NULL THEN
    SELECT  SEQ_TBL_SCHEDULE_PUBLIC_DEPT.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(Idx),0) INTO v_newVal FROM TBL_SCHEDULE_PUBLIC_DEPT;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT SEQ_TBL_SCHEDULE_PUBLIC_DEPT.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
  -- save this to emulate @@identity
  --utils.identity_value := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.Idx := v_newVal;
  END IF;
END;
/
ALTER TRIGGER "TRG_TBL_SCHEDULE_PUBLIC_DEPT" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_TBL_TASK
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_TBL_TASK" BEFORE INSERT ON TBL_TASK
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.TaskID IS NULL THEN
    SELECT  SEQ_TBL_TASK.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(TaskID),0) INTO v_newVal FROM TBL_TASK;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT SEQ_TBL_TASK.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
  -- save this to emulate @@identity
  --utils.identity_value := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.TaskID := v_newVal;
  END IF;
END;
/
ALTER TRIGGER "TRG_TBL_TASK" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_TBL_TASKATTACH
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_TBL_TASKATTACH" BEFORE INSERT ON TBL_TASKATTACH
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.AttachID IS NULL THEN
    SELECT  SEQ_TBL_TASKATTACH.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(AttachID),0) INTO v_newVal FROM TBL_TASKATTACH;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT SEQ_TBL_TASKATTACH.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
  -- save this to emulate @@identity
  --utils.identity_value := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.AttachID := v_newVal;
  END IF;
END;
/
ALTER TRIGGER "TRG_TBL_TASKATTACH" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_TBL_TASKCODEHISTORY
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_TBL_TASKCODEHISTORY" BEFORE INSERT ON TBL_TASKCODEHISTORY
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.sn IS NULL THEN
    SELECT  SEQ_TBL_TASKCODEHISTORY.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(sn),0) INTO v_newVal FROM TBL_TASKCODEHISTORY;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT SEQ_TBL_TASKCODEHISTORY.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
  -- save this to emulate @@identity
  --utils.identity_value := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.sn := v_newVal;
  END IF;
END;
/
ALTER TRIGGER "TRG_TBL_TASKCODEHISTORY" DISABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_TBL_TASKCOMMENT
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_TBL_TASKCOMMENT" BEFORE INSERT ON TBL_TASKCOMMENT
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.CommentID IS NULL THEN
    SELECT  SEQ_TBL_TASKCOMMENT.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(CommentID),0) INTO v_newVal FROM TBL_TASKCOMMENT;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT SEQ_TBL_TASKCOMMENT.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
  -- save this to emulate @@identity
  --utils.identity_value := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.CommentID := v_newVal;
  END IF;
END;
/
ALTER TRIGGER "TRG_TBL_TASKCOMMENT" ENABLE;

-- webfolder trigger
CREATE OR REPLACE TRIGGER update_dept_webfolder_name
AFTER UPDATE ON tbl_deptmaster
FOR EACH ROW
WHEN (NEW.displayname != OLD.displayname OR NEW.displayname2 != OLD.displayname2)
BEGIN
    UPDATE tbl_webfolder_folder SET folder_name1 = :NEW.displayname, folder_name2 = :NEW.displayname2
    WHERE owner_id = :NEW.cn AND folder_upper = 'root' AND folder_type IN ('C', 'D') AND TENANT_ID = :NEW.TENANT_ID;
END;
/

CREATE OR REPLACE TRIGGER update_user_webfolder_name
AFTER UPDATE ON tbl_usermaster
FOR EACH ROW
WHEN (NEW.displayname != OLD.displayname OR NEW.displayname2 != OLD.displayname2)
BEGIN
    UPDATE tbl_webfolder_folder SET folder_name1 = :NEW.displayname, folder_name2 = :NEW.displayname2 
    WHERE owner_id = :NEW.cn AND folder_upper = 'root' AND folder_type IN ('U') AND TENANT_ID = :NEW.TENANT_ID;
END;
/

CREATE OR REPLACE TRIGGER tbl_webfolder_file_insert
AFTER INSERT ON TBL_WEBFOLDER_FILE
FOR EACH ROW
BEGIN
	INSERT INTO search_index_webfolder (ID, FILEID, GUBUN, INSERTDATE, STATUS, TENANT_ID) VALUES(SEQ_SEARCH_INDEX_WEBFOLDER.NEXTVAL, :NEW.FILE_ID, 'I', SYSDATE, 'N', :NEW.TENANT_ID );
END;
/

CREATE OR REPLACE TRIGGER tbl_webfolder_file_update
AFTER UPDATE ON TBL_WEBFOLDER_FILE
FOR EACH ROW
WHEN (OLD.USE_STATUS != 'T')
BEGIN
	INSERT INTO search_index_webfolder(ID, FILEID, GUBUN, INSERTDATE, STATUS, tenant_id) VALUES(SEQ_SEARCH_INDEX_WEBFOLDER.NEXTVAL, :NEW.FILE_ID, 'U', SYSDATE, 'N', :NEW.TENANT_ID );
END;
/

CREATE OR REPLACE TRIGGER tbl_webfolder_file_delete
AFTER UPDATE ON TBL_WEBFOLDER_FILE
FOR EACH ROW
WHEN (OLD.USE_STATUS != 'T' AND NEW.USE_STATUS = 'T')
BEGIN
	INSERT INTO search_index_webfolder(ID, FILEID, GUBUN, INSERTDATE, STATUS, TENANT_ID) VALUES(SEQ_SEARCH_INDEX_WEBFOLDER.NEXTVAL, :OLD.FILE_ID, 'D', SYSDATE, 'N', :OLD.TENANT_ID );
END;
/

CREATE OR REPLACE TRIGGER tbl_webfolder_file_restore
AFTER UPDATE ON TBL_WEBFOLDER_FILE
FOR EACH ROW
WHEN (OLD.USE_STATUS = 'T' AND NEW.USE_STATUS != 'T')
BEGIN
	INSERT INTO search_index_webfolder (ID, FILEID, GUBUN, INSERTDATE, STATUS, TENANT_ID) VALUES(SEQ_SEARCH_INDEX_WEBFOLDER.NEXTVAL, :NEW.FILE_ID, 'I', SYSDATE, 'N', :NEW.TENANT_ID );
END;
/

CREATE OR REPLACE TRIGGER trigger_mail_deleted_id
AFTER DELETE ON JAMES_MAIL
FOR EACH ROW
BEGIN
    INSERT INTO james_mail_deleted_id (MAILBOX_ID, MAIL_UID) VALUES (:OLD.MAILBOX_ID, :OLD.MAIL_UID);
END;
/

--------------------------------------------------------
--  Constraints for Table APPROVCONNKAMCO
--------------------------------------------------------

  ALTER TABLE "APPROVCONNKAMCO" MODIFY ("ENDTIME" NOT NULL ENABLE);
  ALTER TABLE "APPROVCONNKAMCO" ADD CONSTRAINT "APPROVCONNKAMCO_PK" PRIMARY KEY ("USERID", "DOCID")
  USING INDEX;
  ALTER TABLE "APPROVCONNKAMCO" MODIFY ("STARTTIME" NOT NULL ENABLE);
  ALTER TABLE "APPROVCONNKAMCO" MODIFY ("OVERTIMEDATE" NOT NULL ENABLE);
  ALTER TABLE "APPROVCONNKAMCO" MODIFY ("DOCID" NOT NULL ENABLE);
  ALTER TABLE "APPROVCONNKAMCO" MODIFY ("USERID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table APPROVCONNKAMCO_USER
--------------------------------------------------------

  ALTER TABLE "APPROVCONNKAMCO_USER" ADD CONSTRAINT "APPROVCONNKAMCO_USER_PK" PRIMARY KEY ("USERID")
  USING INDEX;
  ALTER TABLE "APPROVCONNKAMCO_USER" MODIFY ("WEEKTIME" NOT NULL ENABLE);
  ALTER TABLE "APPROVCONNKAMCO_USER" MODIFY ("USERID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JAMES_DOMAIN
--------------------------------------------------------

  ALTER TABLE "JAMES_DOMAIN" ADD PRIMARY KEY ("DOMAIN_NAME")
  USING INDEX;
  ALTER TABLE "JAMES_DOMAIN" MODIFY ("DOMAIN_NAME" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JAMES_MAIL
--------------------------------------------------------

  ALTER TABLE "JAMES_MAIL" ADD PRIMARY KEY ("MAILBOX_ID", "MAIL_UID")
  USING INDEX;
  ALTER TABLE "JAMES_MAIL" MODIFY ("MAIL_IS_SEEN" NOT NULL ENABLE);
  ALTER TABLE "JAMES_MAIL" MODIFY ("MAIL_IS_RECENT" NOT NULL ENABLE);
  ALTER TABLE "JAMES_MAIL" MODIFY ("MAIL_IS_FLAGGED" NOT NULL ENABLE);
  ALTER TABLE "JAMES_MAIL" MODIFY ("MAIL_IS_DRAFT" NOT NULL ENABLE);
  ALTER TABLE "JAMES_MAIL" MODIFY ("MAIL_IS_DELETED" NOT NULL ENABLE);
  ALTER TABLE "JAMES_MAIL" MODIFY ("MAIL_CONTENT_OCTETS_COUNT" NOT NULL ENABLE);
  ALTER TABLE "JAMES_MAIL" MODIFY ("MAIL_BODY_START_OCTET" NOT NULL ENABLE);
  ALTER TABLE "JAMES_MAIL" MODIFY ("MAIL_IS_ANSWERED" NOT NULL ENABLE);
  ALTER TABLE "JAMES_MAIL" MODIFY ("MAIL_UID" NOT NULL ENABLE);
  ALTER TABLE "JAMES_MAIL" MODIFY ("MAILBOX_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JAMES_MAILBOX
--------------------------------------------------------

  ALTER TABLE "JAMES_MAILBOX" ADD PRIMARY KEY ("MAILBOX_ID")
  USING INDEX;
  ALTER TABLE "JAMES_MAILBOX" MODIFY ("USER_NAME" NOT NULL ENABLE);
  ALTER TABLE "JAMES_MAILBOX" MODIFY ("MAILBOX_UID_VALIDITY" NOT NULL ENABLE);
  ALTER TABLE "JAMES_MAILBOX" MODIFY ("MAILBOX_NAMESPACE" NOT NULL ENABLE);
  ALTER TABLE "JAMES_MAILBOX" MODIFY ("MAILBOX_NAME" NOT NULL ENABLE);
  ALTER TABLE "JAMES_MAILBOX" MODIFY ("MAILBOX_LAST_UID" NOT NULL ENABLE);
  ALTER TABLE "JAMES_MAILBOX" MODIFY ("MAILBOX_HIGHEST_MODSEQ" NOT NULL ENABLE);
  ALTER TABLE "JAMES_MAILBOX" MODIFY ("MAILBOX_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JAMES_MAIL_BLOB
--------------------------------------------------------

  ALTER TABLE "JAMES_MAIL_BLOB" ADD CONSTRAINT "JAMES_MAIL_BLOB_PK" PRIMARY KEY ("MAIL_BLOB_ID")
  USING INDEX;
  ALTER TABLE "JAMES_MAIL_BLOB" MODIFY ("MAIL_BLOB_ID" NOT NULL ENABLE);
  ALTER TABLE "JAMES_MAIL_BLOB" MODIFY ("DISK_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JAMES_MAIL_DELETED_ID
--------------------------------------------------------

  ALTER TABLE "JAMES_MAIL_DELETED_ID" MODIFY ("MAILBOX_ID" NOT NULL ENABLE);
  ALTER TABLE "JAMES_MAIL_DELETED_ID" MODIFY ("MAIL_UID" NOT NULL ENABLE);
  ALTER TABLE "JAMES_MAIL_DELETED_ID" ADD CONSTRAINT "JAMES_MAIL_DELETED_ID_PK" PRIMARY KEY ("MAILBOX_ID", "MAIL_UID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table JAMES_MAIL_PROPERTY
--------------------------------------------------------

  ALTER TABLE "JAMES_MAIL_PROPERTY" ADD PRIMARY KEY ("PROPERTY_ID")
  USING INDEX;
  ALTER TABLE "JAMES_MAIL_PROPERTY" MODIFY ("PROPERTY_VALUE" NOT NULL ENABLE);
  ALTER TABLE "JAMES_MAIL_PROPERTY" MODIFY ("PROPERTY_NAME_SPACE" NOT NULL ENABLE);
  ALTER TABLE "JAMES_MAIL_PROPERTY" MODIFY ("PROPERTY_LOCAL_NAME" NOT NULL ENABLE);
  ALTER TABLE "JAMES_MAIL_PROPERTY" MODIFY ("PROPERTY_LINE_NUMBER" NOT NULL ENABLE);
  ALTER TABLE "JAMES_MAIL_PROPERTY" MODIFY ("PROPERTY_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JAMES_MAIL_SEARCH
--------------------------------------------------------

  ALTER TABLE "JAMES_MAIL_SEARCH" ADD PRIMARY KEY ("MAIL_SEARCH_ID")
  USING INDEX;
  ALTER TABLE "JAMES_MAIL_SEARCH" MODIFY ("MAIL_SEARCH_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JAMES_MAIL_USERFLAG
--------------------------------------------------------

  ALTER TABLE "JAMES_MAIL_USERFLAG" ADD PRIMARY KEY ("USERFLAG_ID")
  USING INDEX;
  ALTER TABLE "JAMES_MAIL_USERFLAG" MODIFY ("USERFLAG_NAME" NOT NULL ENABLE);
  ALTER TABLE "JAMES_MAIL_USERFLAG" MODIFY ("USERFLAG_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JAMES_RECIPIENT_REWRITE
--------------------------------------------------------

  ALTER TABLE "JAMES_RECIPIENT_REWRITE" ADD PRIMARY KEY ("DOMAIN_NAME", "USER_NAME")
  USING INDEX;
  ALTER TABLE "JAMES_RECIPIENT_REWRITE" MODIFY ("USER_NAME" NOT NULL ENABLE);
  ALTER TABLE "JAMES_RECIPIENT_REWRITE" MODIFY ("DOMAIN_NAME" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JAMES_SUBSCRIPTION
--------------------------------------------------------

  ALTER TABLE "JAMES_SUBSCRIPTION" ADD CONSTRAINT "U_JMS_PTN_USER_NAME" UNIQUE ("USER_NAME", "MAILBOX_NAME")
  USING INDEX;
  ALTER TABLE "JAMES_SUBSCRIPTION" ADD PRIMARY KEY ("SUBSCRIPTION_ID")
  USING INDEX;
  ALTER TABLE "JAMES_SUBSCRIPTION" MODIFY ("USER_NAME" NOT NULL ENABLE);
  ALTER TABLE "JAMES_SUBSCRIPTION" MODIFY ("MAILBOX_NAME" NOT NULL ENABLE);
  ALTER TABLE "JAMES_SUBSCRIPTION" MODIFY ("SUBSCRIPTION_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JAMES_USER
--------------------------------------------------------

  ALTER TABLE "JAMES_USER" ADD PRIMARY KEY ("USER_NAME")
  USING INDEX;
  ALTER TABLE "JAMES_USER" MODIFY ("PASSWORD" NOT NULL ENABLE);
  ALTER TABLE "JAMES_USER" MODIFY ("PASSWORD_HASH_ALGORITHM" NOT NULL ENABLE);
  ALTER TABLE "JAMES_USER" MODIFY ("USER_NAME" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_ADDJOB_MASTER
--------------------------------------------------------

  ALTER TABLE "JMOCHA_ADDJOB_MASTER" ADD CONSTRAINT "TABLE1_PK" PRIMARY KEY ("TENANT_ID", "CN", "DEPTID")
  USING INDEX;
  ALTER TABLE "JMOCHA_ADDJOB_MASTER" MODIFY ("DEPTID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_ADDJOB_MASTER" MODIFY ("CN" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_ADDJOB_MASTER" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_ADDRESS_FOLDER
--------------------------------------------------------

  ALTER TABLE "JMOCHA_ADDRESS_FOLDER" ADD CONSTRAINT "JMOCHA_ADDRESS_FOLDER_PK" PRIMARY KEY ("FOLDER_ID")
  USING INDEX;
  ALTER TABLE "JMOCHA_ADDRESS_FOLDER" MODIFY ("FOLDER_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_ADDRESS_GENERAL
--------------------------------------------------------

  ALTER TABLE "JMOCHA_ADDRESS_GENERAL" ADD CONSTRAINT "PK_JMOCHA_ADDRESS_GENERAL" PRIMARY KEY ("USER_ID")
  USING INDEX;
  ALTER TABLE "JMOCHA_ADDRESS_GENERAL" MODIFY ("USER_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_ADDRESS_INFO
--------------------------------------------------------

  ALTER TABLE "JMOCHA_ADDRESS_INFO" ADD CONSTRAINT "PK_JMOCHA_ADDRESS_INFO" PRIMARY KEY ("ADDRESS_ID")
  USING INDEX;
  ALTER TABLE "JMOCHA_ADDRESS_INFO" MODIFY ("ADDRESS_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_ADDRESS_SEARCH
--------------------------------------------------------

  ALTER TABLE "JMOCHA_ADDRESS_SEARCH" ADD CONSTRAINT "JMOCHA_ADDRESS_SEARCH_PK" PRIMARY KEY ("ID")
  USING INDEX;
  ALTER TABLE "JMOCHA_ADDRESS_SEARCH" MODIFY ("ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_ADDRESS_SIMPLE
--------------------------------------------------------

  ALTER TABLE "JMOCHA_ADDRESS_SIMPLE" ADD CONSTRAINT "PK_JMOCHA_ADDRESS_SIMPLE" PRIMARY KEY ("SIMPLE_IDX")
  USING INDEX;
  ALTER TABLE "JMOCHA_ADDRESS_SIMPLE" MODIFY ("SIMPLE_IDX" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_ALIAS
--------------------------------------------------------

  ALTER TABLE "JMOCHA_ALIAS" ADD CONSTRAINT "PK_JMOCHA_ALIAS" PRIMARY KEY ("TARGET_ADDRESS", "ALIAS_ADDRESS")
  USING INDEX;
  ALTER TABLE "JMOCHA_ALIAS" MODIFY ("ALIAS_ADDRESS" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_ALIAS" MODIFY ("TARGET_ADDRESS" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_ALIAS_RETIRE
--------------------------------------------------------

  ALTER TABLE "JMOCHA_ALIAS_RETIRE" ADD CONSTRAINT "PK_JMOCHA_ALIAS_RETIRE" PRIMARY KEY ("TARGET_ADDRESS", "ALIAS_ADDRESS")
  USING INDEX;
  ALTER TABLE "JMOCHA_ALIAS_RETIRE" MODIFY ("ALIAS_ADDRESS" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_ALIAS_RETIRE" MODIFY ("TARGET_ADDRESS" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_BIGATTACH_DOWN_LIMIT
--------------------------------------------------------

  ALTER TABLE "JMOCHA_BIGATTACH_DOWN_LIMIT" MODIFY ("FILE_ID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_BIGATTACH_DOWN_LIMIT" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_BIGATTACH_DOWN_LIMIT" ADD CONSTRAINT "JMOCHA_BIGATTACH_DOWN_LIMIT_PK" PRIMARY KEY ("FILE_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table JMOCHA_CONNECTION_INFO
--------------------------------------------------------

  ALTER TABLE "JMOCHA_CONNECTION_INFO" ADD CONSTRAINT "PK_JMOCHA_CONNECTION_INFO" PRIMARY KEY ("SEQUENCE")
  USING INDEX;
  ALTER TABLE "JMOCHA_CONNECTION_INFO" MODIFY ("SEQUENCE" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_CONNECTION_INFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_CONNECTION_INFO" MODIFY ("USERID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_DEFAULT_QUOTA
--------------------------------------------------------

  ALTER TABLE "JMOCHA_DEFAULT_QUOTA" ADD CONSTRAINT "PK_JMOCHA_DEFAULT_QUOTA" PRIMARY KEY ("DOMAIN_NAME")
  USING INDEX;
  ALTER TABLE "JMOCHA_DEFAULT_QUOTA" MODIFY ("DOMAIN_NAME" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_COMPANY_QUOTA
--------------------------------------------------------

ALTER TABLE "JMOCHA_COMPANY_QUOTA" ADD CONSTRAINT "PK_JMOCHA_COMPANY_QUOTA" PRIMARY KEY ("DOMAIN_NAME", "COMPANY_ID")
    USING INDEX;
ALTER TABLE "JMOCHA_COMPANY_QUOTA" MODIFY ("DOMAIN_NAME" NOT NULL ENABLE);
ALTER TABLE "JMOCHA_COMPANY_QUOTA" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_DEPT_MASTER
--------------------------------------------------------

  ALTER TABLE "JMOCHA_DEPT_MASTER" ADD CONSTRAINT "PK_JMOCHA_DEPT_MASTER" PRIMARY KEY ("TENANT_ID", "CN")
  USING INDEX;
  ALTER TABLE "JMOCHA_DEPT_MASTER" MODIFY ("DISPLAYNAME" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_DEPT_MASTER" MODIFY ("CN" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_DEPT_MASTER" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_DISTRIBUTION
--------------------------------------------------------

  ALTER TABLE "JMOCHA_DISTRIBUTION" ADD CONSTRAINT "PK_JMOCHA_DISTRIBUTION" PRIMARY KEY ("DOMAIN_NAME", "USER_NAME")
  USING INDEX;
  ALTER TABLE "JMOCHA_DISTRIBUTION" MODIFY ("GROUP_NAME" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_DISTRIBUTION" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_DISTRIBUTION" MODIFY ("USER_NAME" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_DISTRIBUTION" MODIFY ("DOMAIN_NAME" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_DISTRIBUTION_SUB
--------------------------------------------------------

  ALTER TABLE "JMOCHA_DISTRIBUTION_SUB" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_DISTRIBUTION_SUB" ADD CONSTRAINT "JMOCHA_DISTRIBUTION_SUB_PK" PRIMARY KEY ("DOMAIN_NAME", "USER_NAME", "SUB_MAIL")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table JMOCHA_INBOX_RULE
--------------------------------------------------------

  ALTER TABLE "JMOCHA_INBOX_RULE" ADD CONSTRAINT "PK_JMOCHA_INBOX_RULE" PRIMARY KEY ("RULE_ID")
  USING INDEX;
  ALTER TABLE "JMOCHA_INBOX_RULE" MODIFY ("PRIORITY" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_INBOX_RULE" MODIFY ("IS_USE" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_INBOX_RULE" MODIFY ("USER_ID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_INBOX_RULE" MODIFY ("RULE_NAME" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_INBOX_RULE" MODIFY ("RULE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_INBOX_RULE_SUB
--------------------------------------------------------

  ALTER TABLE "JMOCHA_INBOX_RULE_SUB" ADD CONSTRAINT "PK_JMOCHA_INBOX_RULE_SUB" PRIMARY KEY ("ITEM_ID")
  USING INDEX;
  ALTER TABLE "JMOCHA_INBOX_RULE_SUB" MODIFY ("KIND" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_INBOX_RULE_SUB" MODIFY ("TYPE" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_INBOX_RULE_SUB" MODIFY ("RULE_ID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_INBOX_RULE_SUB" MODIFY ("ITEM_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_LETTER
--------------------------------------------------------

  ALTER TABLE "JMOCHA_LETTER" ADD CONSTRAINT "JMOCHA_LETTER_PK" PRIMARY KEY ("LETTER_NO")
  USING INDEX;
  ALTER TABLE "JMOCHA_LETTER" MODIFY ("LETTER_NO" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_LETTERBOX
--------------------------------------------------------

  ALTER TABLE "JMOCHA_LETTERBOX" ADD CONSTRAINT "JMOCHA_LETTERBOX_PK" PRIMARY KEY ("LETTERBOX_NO")
  USING INDEX;
  ALTER TABLE "JMOCHA_LETTERBOX" MODIFY ("LETTERBOX_NO" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_MAIL_COLOR
--------------------------------------------------------

  ALTER TABLE "JMOCHA_MAIL_COLOR" ADD CONSTRAINT "PK_JMOCHA_MAIL_COLOR" PRIMARY KEY ("TENANT_ID")
  USING INDEX;
  ALTER TABLE "JMOCHA_MAIL_COLOR" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_MAIL_COPYRIGHT
--------------------------------------------------------

  ALTER TABLE "JMOCHA_MAIL_COPYRIGHT" ADD CONSTRAINT "SYS_C0034629" PRIMARY KEY ("COMPANY_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table JMOCHA_MAIL_COUNTRYIP
--------------------------------------------------------

  ALTER TABLE "JMOCHA_MAIL_COUNTRYIP" ADD CONSTRAINT "JMOCHA_MAIL_COUNTRYIP_PK" PRIMARY KEY ("START_IP_NUMBER", "END_IP_NUMBER")
  USING INDEX;
  ALTER TABLE "JMOCHA_MAIL_COUNTRYIP" MODIFY ("COUNTRY_CODE" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_MAIL_COUNTRYIP" MODIFY ("END_IP_NUMBER" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_MAIL_COUNTRYIP" MODIFY ("START_IP_NUMBER" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_MAIL_COUNTRYIP" MODIFY ("END_IP" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_MAIL_COUNTRYIP" MODIFY ("START_IP" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_MAIL_DELETE
--------------------------------------------------------

  ALTER TABLE "JMOCHA_MAIL_DELETE" ADD CONSTRAINT "PK_JMOCHA_MAIL_DELETE" PRIMARY KEY ("USER_ID", "FOLDER_PATH")
  USING INDEX;
  ALTER TABLE "JMOCHA_MAIL_DELETE" MODIFY ("FOLDER_PATH" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_MAIL_DELETE" MODIFY ("USER_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_MAIL_FORWARD
--------------------------------------------------------

  ALTER TABLE "JMOCHA_MAIL_FORWARD" ADD CONSTRAINT "PK_JMOCHA_MAIL_FORWARD" PRIMARY KEY ("USERID")
  USING INDEX;
  ALTER TABLE "JMOCHA_MAIL_FORWARD" MODIFY ("FORWARD_ADDRESS" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_MAIL_FORWARD" MODIFY ("USERID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_MAIL_GENERAL
--------------------------------------------------------

  ALTER TABLE "JMOCHA_MAIL_GENERAL" ADD CONSTRAINT "PK_JMOCHA_MAIL_GENERAL" PRIMARY KEY ("USER_ID")
  USING INDEX;
  ALTER TABLE "JMOCHA_MAIL_GENERAL" MODIFY ("USER_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_MAIL_OUTOFOFFICE
--------------------------------------------------------

  ALTER TABLE "JMOCHA_MAIL_OUTOFOFFICE" ADD CONSTRAINT "PK_JMOCHA_MAIL_OUTOFOFFICE" PRIMARY KEY ("USER_ID")
  USING INDEX;
  ALTER TABLE "JMOCHA_MAIL_OUTOFOFFICE" MODIFY ("EXTERNAL_AUDIENCE" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_MAIL_OUTOFOFFICE" MODIFY ("EXTERNAL" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_MAIL_OUTOFOFFICE" MODIFY ("INTERNAL" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_MAIL_OUTOFOFFICE" MODIFY ("END_DATE" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_MAIL_OUTOFOFFICE" MODIFY ("START_DATE" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_MAIL_OUTOFOFFICE" MODIFY ("OOF_STATE" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_MAIL_OUTOFOFFICE" MODIFY ("USER_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_MAIL_OUTOFOFFICE_SENT
--------------------------------------------------------

  ALTER TABLE "JMOCHA_MAIL_OUTOFOFFICE_SENT" ADD CONSTRAINT "PK_JMOCHA_OUTOFOFFICE_SENT" PRIMARY KEY ("USER_ID", "RECIPIENT_ID")
  USING INDEX;
  ALTER TABLE "JMOCHA_MAIL_OUTOFOFFICE_SENT" MODIFY ("SENT_TIME" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_MAIL_OUTOFOFFICE_SENT" MODIFY ("RECIPIENT_ID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_MAIL_OUTOFOFFICE_SENT" MODIFY ("USER_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_MAIL_POP3
--------------------------------------------------------

  ALTER TABLE "JMOCHA_MAIL_POP3" ADD CONSTRAINT "PK_JMOCHA_MAIL_POP3" PRIMARY KEY ("POP3_IDX")
  USING INDEX;
  ALTER TABLE "JMOCHA_MAIL_POP3" MODIFY ("POP3_IDX" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_MAIL_POP3_LIST
--------------------------------------------------------

  ALTER TABLE "JMOCHA_MAIL_POP3_LIST" MODIFY ("MESSAGE_ID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_MAIL_POP3_LIST" MODIFY ("POP3_IDX" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_MAIL_READ
--------------------------------------------------------

  ALTER TABLE "JMOCHA_MAIL_READ" MODIFY ("USER_ID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_MAIL_READ" ADD CONSTRAINT "PK_JMOCHA_MAIL_READ" PRIMARY KEY ("MESSAGE_ID", "USER_ID", "READER_EMAIL")
  USING INDEX;
  ALTER TABLE "JMOCHA_MAIL_READ" MODIFY ("READER_EMAIL" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_MAIL_READ" MODIFY ("MESSAGE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_MAIL_RECALL
--------------------------------------------------------

  ALTER TABLE "JMOCHA_MAIL_RECALL" ADD CONSTRAINT "PK_JMOCHA_MAIL_RECALL" PRIMARY KEY ("RECALL_IDX")
  USING INDEX;
  ALTER TABLE "JMOCHA_MAIL_RECALL" MODIFY ("RECALL_IDX" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_MAIL_RECALL_DETAIL
--------------------------------------------------------

  ALTER TABLE "JMOCHA_MAIL_RECALL_DETAIL" ADD CONSTRAINT "PK_JMOCHA_MAIL_RECALL_DETAIL" PRIMARY KEY ("RECALL_IDX", "RECEIVER_EMAIL")
  USING INDEX;
  ALTER TABLE "JMOCHA_MAIL_RECALL_DETAIL" MODIFY ("RECEIVER_EMAIL" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_MAIL_RECALL_DETAIL" MODIFY ("RECALL_IDX" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_MAIL_RESERVE
--------------------------------------------------------

  ALTER TABLE "JMOCHA_MAIL_RESERVE" ADD CONSTRAINT "PK_MESSAGE_ID" PRIMARY KEY ("MESSAGE_ID")
  USING INDEX;
  ALTER TABLE "JMOCHA_MAIL_RESERVE" MODIFY ("MESSAGE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_MAIL_SECURE
--------------------------------------------------------

  ALTER TABLE "JMOCHA_MAIL_SECURE" ADD CONSTRAINT "PK_JMOCHA_MAIL_SECURE" PRIMARY KEY ("SECURE_ID")
  USING INDEX;
  ALTER TABLE "JMOCHA_MAIL_SECURE" MODIFY ("SECURE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_MAIL_SECURE_READ
--------------------------------------------------------

  ALTER TABLE "JMOCHA_MAIL_SECURE_READ" ADD CONSTRAINT "PK_JMOCHA_MAIL_SECURE_READ" PRIMARY KEY ("SECURE_ID", "READER_ID")
  USING INDEX;
  ALTER TABLE "JMOCHA_MAIL_SECURE_READ" MODIFY ("READER_ID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_MAIL_SECURE_READ" MODIFY ("SECURE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_MAIL_SIGNATURE
--------------------------------------------------------

  ALTER TABLE "JMOCHA_MAIL_SIGNATURE" ADD CONSTRAINT "PK_JMOCHA_MAIL_SIGNATURE" PRIMARY KEY ("USER_ID")
  USING INDEX;
  ALTER TABLE "JMOCHA_MAIL_SIGNATURE" MODIFY ("USER_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_MAIL_SIGNATURE_TEMPLATE
--------------------------------------------------------

  ALTER TABLE "JMOCHA_MAIL_SIGNATURE_TEMPLATE" ADD CONSTRAINT "SIGNATURE_TEMPLATE_PK" PRIMARY KEY ("SIGN_NO")
  USING INDEX;
  ALTER TABLE "JMOCHA_MAIL_SIGNATURE_TEMPLATE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_MAIL_SIGNATURE_TEMPLATE" MODIFY ("SIGN_NO" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_RETIRED_USER
--------------------------------------------------------

  ALTER TABLE "JMOCHA_RETIRED_USER" ADD CONSTRAINT "PK_JMOCHA_RETIRED_USER" PRIMARY KEY ("USER_NAME")
  USING INDEX;
  ALTER TABLE "JMOCHA_RETIRED_USER" MODIFY ("PASSWORD" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_RETIRED_USER" MODIFY ("PASSWORD_HASH_ALGORITHM" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_RETIRED_USER" MODIFY ("USER_NAME" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_SCHEDULER_SERVER
--------------------------------------------------------

  ALTER TABLE "JMOCHA_SCHEDULER_SERVER" ADD CONSTRAINT "PK_JMOCHA_SCHEDULER_SERVER" PRIMARY KEY ("SCHEDULER")
  USING INDEX;
  ALTER TABLE "JMOCHA_SCHEDULER_SERVER" MODIFY ("SCHEDULER" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_SHARED_MAILBOX
--------------------------------------------------------

  ALTER TABLE "JMOCHA_SHARED_MAILBOX" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_SHARED_MAILBOX" MODIFY ("SHARE_ID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_SHARED_MAILBOX" MODIFY ("USER_ID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_SHARED_MAILBOX" ADD CONSTRAINT "PK_JMOCHA_SHARED_MAILBOX" PRIMARY KEY ("TENANT_ID", "SHARE_ID", "USER_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table JMOCHA_STAT_MAILBOXQTY_INFO
--------------------------------------------------------

  ALTER TABLE "JMOCHA_STAT_MAILBOXQTY_INFO" ADD CONSTRAINT "PK_JMOCHA_STAT_MAILBOXQTY_INFO" PRIMARY KEY ("TENANT_ID", "USERID", "DT_MM")
  USING INDEX;
  ALTER TABLE "JMOCHA_STAT_MAILBOXQTY_INFO" MODIFY ("DT_MM" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_STAT_MAILBOXQTY_INFO" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_STAT_MAILBOXQTY_INFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_STAT_MAIL_COMP_FLOW_DAY
--------------------------------------------------------

  ALTER TABLE "JMOCHA_STAT_MAIL_COMP_FLOW_DAY" ADD CONSTRAINT "PK_JMOCHA_STAT_COMP_FLOW_DAY" PRIMARY KEY ("TENANT_ID", "DT_DD", "SORGID", "RORGID")
  USING INDEX;
  ALTER TABLE "JMOCHA_STAT_MAIL_COMP_FLOW_DAY" MODIFY ("RORGID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_STAT_MAIL_COMP_FLOW_DAY" MODIFY ("SORGID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_STAT_MAIL_COMP_FLOW_DAY" MODIFY ("DT_DD" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_STAT_MAIL_COMP_FLOW_DAY" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_STAT_MAIL_COMP_FLOW_MON
--------------------------------------------------------

  ALTER TABLE "JMOCHA_STAT_MAIL_COMP_FLOW_MON" ADD CONSTRAINT "PK_JMOCHA_STAT_COMP_FLOW_MON" PRIMARY KEY ("TENANT_ID", "DT_MM", "SORGID", "RORGID")
  USING INDEX;
  ALTER TABLE "JMOCHA_STAT_MAIL_COMP_FLOW_MON" MODIFY ("RORGID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_STAT_MAIL_COMP_FLOW_MON" MODIFY ("SORGID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_STAT_MAIL_COMP_FLOW_MON" MODIFY ("DT_MM" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_STAT_MAIL_COMP_FLOW_MON" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_STAT_MAIL_DEPT_DAY
--------------------------------------------------------

  ALTER TABLE "JMOCHA_STAT_MAIL_DEPT_DAY" ADD CONSTRAINT "PK_JMOCHA_STAT_MAIL_DEPT_DAY" PRIMARY KEY ("TENANT_ID", "DT_DD", "DEPTID")
  USING INDEX;
  ALTER TABLE "JMOCHA_STAT_MAIL_DEPT_DAY" MODIFY ("DEPTID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_STAT_MAIL_DEPT_DAY" MODIFY ("DT_DD" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_STAT_MAIL_DEPT_DAY" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_STAT_MAIL_DEPT_MONTH
--------------------------------------------------------

  ALTER TABLE "JMOCHA_STAT_MAIL_DEPT_MONTH" ADD CONSTRAINT "PK_JMOCHA_STAT_MAIL_DEPT_MONTH" PRIMARY KEY ("TENANT_ID", "DT_MM", "DEPTID")
  USING INDEX;
  ALTER TABLE "JMOCHA_STAT_MAIL_DEPT_MONTH" MODIFY ("DEPTID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_STAT_MAIL_DEPT_MONTH" MODIFY ("DT_MM" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_STAT_MAIL_DEPT_MONTH" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_STAT_MAIL_LOG
--------------------------------------------------------

  ALTER TABLE "JMOCHA_STAT_MAIL_LOG" ADD CONSTRAINT "PK_JMOCHA_STAT_MAIL_LOG" PRIMARY KEY ("IDX")
  USING INDEX;
  ALTER TABLE "JMOCHA_STAT_MAIL_LOG" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_STAT_MAIL_LOG" MODIFY ("IDX" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_STAT_MAIL_USER_DAY
--------------------------------------------------------

  ALTER TABLE "JMOCHA_STAT_MAIL_USER_DAY" ADD CONSTRAINT "PK_JMOCHA_STAT_MAIL_USER_DAY" PRIMARY KEY ("TENANT_ID", "DT_DD", "USERID", "DEPTID")
  USING INDEX;
  ALTER TABLE "JMOCHA_STAT_MAIL_USER_DAY" MODIFY ("DEPTID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_STAT_MAIL_USER_DAY" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_STAT_MAIL_USER_DAY" MODIFY ("DT_DD" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_STAT_MAIL_USER_DAY" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_STAT_MAIL_USER_MONTH
--------------------------------------------------------

  ALTER TABLE "JMOCHA_STAT_MAIL_USER_MONTH" ADD CONSTRAINT "PK_JMOCHA_STAT_MAIL_USER_MONTH" PRIMARY KEY ("TENANT_ID", "DT_MM", "USERID", "DEPTID")
  USING INDEX;
  ALTER TABLE "JMOCHA_STAT_MAIL_USER_MONTH" MODIFY ("DEPTID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_STAT_MAIL_USER_MONTH" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_STAT_MAIL_USER_MONTH" MODIFY ("DT_MM" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_STAT_MAIL_USER_MONTH" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_STORAGE_WARNING_SENT
--------------------------------------------------------

  ALTER TABLE "JMOCHA_STORAGE_WARNING_SENT" ADD CONSTRAINT "PK_JMOCHA_STORAGE_WARNING_SENT" PRIMARY KEY ("USER_ID")
  USING INDEX;
  ALTER TABLE "JMOCHA_STORAGE_WARNING_SENT" MODIFY ("SENT_TIME" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_STORAGE_WARNING_SENT" MODIFY ("USER_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_TENANT
--------------------------------------------------------

  ALTER TABLE "JMOCHA_TENANT" ADD CONSTRAINT "PK_JMOCHA_TENANT" PRIMARY KEY ("TENANT_ID")
  USING INDEX;
  ALTER TABLE "JMOCHA_TENANT" MODIFY ("TENANT_NAME" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_TENANT" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_TENANT_CONFIG
--------------------------------------------------------

  ALTER TABLE "JMOCHA_TENANT_CONFIG" ADD CONSTRAINT "PK_JMOCHA_TENANT_CONFIG" PRIMARY KEY ("TENANT_ID", "PROPERTY_NAME")
  USING INDEX;
  ALTER TABLE "JMOCHA_TENANT_CONFIG" MODIFY ("PROPERTY_VALUE" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_TENANT_CONFIG" MODIFY ("PROPERTY_NAME" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_TENANT_CONFIG" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_TENANT_SERVERNAME
--------------------------------------------------------

  ALTER TABLE "JMOCHA_TENANT_SERVERNAME" ADD CONSTRAINT "PK_JMOCHA_TENANT_SERVERNAME" PRIMARY KEY ("SERVER_NAME")
  USING INDEX;
  ALTER TABLE "JMOCHA_TENANT_SERVERNAME" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_TENANT_SERVERNAME" MODIFY ("SERVER_NAME" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_USER_DISTRIBUTION
--------------------------------------------------------

  ALTER TABLE "JMOCHA_USER_DISTRIBUTION" MODIFY ("DOMAIN_NAME" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_USER_DISTRIBUTION" MODIFY ("USER_NAME" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_USER_DISTRIBUTION" MODIFY ("OWNER_ID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_USER_DISTRIBUTION" MODIFY ("DISCLOSURE_POLICY" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_USER_DISTRIBUTION" ADD CONSTRAINT "PK_JMOCHA_USER_DISTRIBUTION" PRIMARY KEY ("DOMAIN_NAME", "USER_NAME")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table JMOCHA_USER_DISTRIBUTION_MEM
--------------------------------------------------------

  ALTER TABLE "JMOCHA_USER_DISTRIBUTION_MEM" MODIFY ("DOMAIN_NAME" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_USER_DISTRIBUTION_MEM" MODIFY ("USER_NAME" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_USER_DISTRIBUTION_MEM" MODIFY ("MEMBER_ID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_USER_DISTRIBUTION_MEM" ADD CONSTRAINT "PK_JMOCHA_USER_DIST_MEM" PRIMARY KEY ("DOMAIN_NAME", "USER_NAME", "MEMBER_ID")
  USING INDEX; 
--------------------------------------------------------
--  Constraints for Table JMOCHA_USER_DISTRIBUTION_MEM
--------------------------------------------------------
  
  ALTER TABLE "JMOCHA_USER_DIST_APPLY" ADD CONSTRAINT "PK_JMOCHA_USER_DIST_APPLY" PRIMARY KEY ("DOMAIN_NAME", "USER_NAME", "APPLICANT_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table JMOCHA_USER_LOCAL_INFO
--------------------------------------------------------

  ALTER TABLE "JMOCHA_USER_LOCAL_INFO" ADD CONSTRAINT "PK_JMOCHA_USER_LOCAL_INFO" PRIMARY KEY ("TENANT_ID", "USERID")
  USING INDEX;
  ALTER TABLE "JMOCHA_USER_LOCAL_INFO" MODIFY ("LANG" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_USER_LOCAL_INFO" MODIFY ("TIMEZONE" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_USER_LOCAL_INFO" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_USER_LOCAL_INFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_USER_MASTER
--------------------------------------------------------

  ALTER TABLE "JMOCHA_USER_MASTER" ADD CONSTRAINT "PK_JMOCHA_USER_MASTER" PRIMARY KEY ("TENANT_ID", "CN")
  USING INDEX;
  ALTER TABLE "JMOCHA_USER_MASTER" MODIFY ("UPDATEDT" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_USER_MASTER" MODIFY ("DEPARTMENT" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_USER_MASTER" MODIFY ("DISPLAYNAME" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_USER_MASTER" MODIFY ("CN" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_USER_MASTER" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_USER_MASTER_RETIRE
--------------------------------------------------------

  ALTER TABLE "JMOCHA_USER_MASTER_RETIRE" ADD CONSTRAINT "PK_JMOCHA_USER_MASTER_RETIRE" PRIMARY KEY ("TENANT_ID", "CN")
  USING INDEX;
  ALTER TABLE "JMOCHA_USER_MASTER_RETIRE" MODIFY ("UPDATEDT" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_USER_MASTER_RETIRE" MODIFY ("DEPARTMENT" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_USER_MASTER_RETIRE" MODIFY ("DISPLAYNAME" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_USER_MASTER_RETIRE" MODIFY ("CN" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_USER_MASTER_RETIRE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table JMOCHA_USER_QUOTA
--------------------------------------------------------

  ALTER TABLE "JMOCHA_USER_QUOTA" ADD CONSTRAINT "PK_JMOCHA_USER_QUOTA" PRIMARY KEY ("USER_ID")
  USING INDEX;
  ALTER TABLE "JMOCHA_USER_QUOTA" MODIFY ("USER_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table OPENJPA_SEQUENCE_TABLE
--------------------------------------------------------

  ALTER TABLE "OPENJPA_SEQUENCE_TABLE" ADD PRIMARY KEY ("ID")
  USING INDEX;
  ALTER TABLE "OPENJPA_SEQUENCE_TABLE" MODIFY ("ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TALK_TBLADDJOB
--------------------------------------------------------

  ALTER TABLE "TALK_TBLADDJOB" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLADDJOB" MODIFY ("DEPTID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLADDJOB" ADD CONSTRAINT "TALK_TBLADDJOB_PK" PRIMARY KEY ("DEPTID", "USERID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TALK_TBLAUTHLOGINTOKEN
--------------------------------------------------------

  ALTER TABLE "TALK_TBLAUTHLOGINTOKEN" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLAUTHLOGINTOKEN" MODIFY ("LTOKEN" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLAUTHLOGINTOKEN" MODIFY ("REGDATA" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLAUTHLOGINTOKEN" MODIFY ("TYPE" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLAUTHLOGINTOKEN" ADD CONSTRAINT "TALK_TBLAUTHLOGINTOKEN_PK" PRIMARY KEY ("USERID", "LTOKEN")
  USING INDEX;
  ALTER TABLE "TALK_TBLAUTHLOGINTOKEN" MODIFY ("COMPID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TALK_TBLCOMPANY
--------------------------------------------------------

  ALTER TABLE "TALK_TBLCOMPANY" ADD CONSTRAINT "TALK_TBLCOMPANY_PK" PRIMARY KEY ("COMPID")
  USING INDEX;
  ALTER TABLE "TALK_TBLCOMPANY" MODIFY ("UPDATEDATE" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLCOMPANY" MODIFY ("COMPEMAIL" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLCOMPANY" MODIFY ("COMPNAME" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLCOMPANY" MODIFY ("COMPID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TALK_TBLDATELIMIT
--------------------------------------------------------

  ALTER TABLE "TALK_TBLDATELIMIT" MODIFY ("TYPE" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLDATELIMIT" MODIFY ("VALUE" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLDATELIMIT" MODIFY ("REGDATE" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLDATELIMIT" ADD CONSTRAINT "TALK_TBLDATELIMIT_PK" PRIMARY KEY ("TYPE", "REGDATE")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TALK_TBLDEPT
--------------------------------------------------------

  ALTER TABLE "TALK_TBLDEPT" MODIFY ("DEPTID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLDEPT" MODIFY ("DEPTNAME" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLDEPT" MODIFY ("DEPTEMAIL" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLDEPT" MODIFY ("PARENTDEPTID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLDEPT" MODIFY ("COMPID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLDEPT" MODIFY ("UPDATEDATE" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLDEPT" ADD CONSTRAINT "TALK_TBLDEPT_PK" PRIMARY KEY ("DEPTID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TALK_TBLDEVICE
--------------------------------------------------------

  ALTER TABLE "TALK_TBLDEVICE" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLDEVICE" MODIFY ("DEVICEID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLDEVICE" MODIFY ("DEVICETYPE" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLDEVICE" MODIFY ("DEVICESUBTYPE" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLDEVICE" MODIFY ("DEVICETOKEN" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLDEVICE" MODIFY ("PUSHSTATE" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLDEVICE" MODIFY ("REGDATE" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLDEVICE" MODIFY ("COMPID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TALK_TBLGROUP
--------------------------------------------------------

  ALTER TABLE "TALK_TBLGROUP" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLGROUP" MODIFY ("GROUPID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLGROUP" MODIFY ("TITLE" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLGROUP" MODIFY ("COMPID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLGROUP" ADD PRIMARY KEY ("USERID", "GROUPID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TALK_TBLMEMBER
--------------------------------------------------------

  ALTER TABLE "TALK_TBLMEMBER" MODIFY ("OWNERID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLMEMBER" MODIFY ("GROUPID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLMEMBER" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLMEMBER" MODIFY ("COMPID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLMEMBER" ADD PRIMARY KEY ("OWNERID", "GROUPID", "USERID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TALK_TBLMEMBERRELATION
--------------------------------------------------------

  ALTER TABLE "TALK_TBLMEMBERRELATION" MODIFY ("OWNERID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLMEMBERRELATION" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLMEMBERRELATION" MODIFY ("FLAG" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLMEMBERRELATION" MODIFY ("COMPID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLMEMBERRELATION" ADD PRIMARY KEY ("OWNERID", "USERID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TALK_TBLMESSAGE
--------------------------------------------------------

  ALTER TABLE "TALK_TBLMESSAGE" MODIFY ("REGDATE" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLMESSAGE" MODIFY ("MESSAGE" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLMESSAGE" MODIFY ("COMPID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLMESSAGE" ADD CONSTRAINT "TALK_TBLMESSAGE_PK" PRIMARY KEY ("ROOMID", "MSEQ")
  USING INDEX;
  ALTER TABLE "TALK_TBLMESSAGE" MODIFY ("ROOMID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLMESSAGE" MODIFY ("MSEQ" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLMESSAGE" MODIFY ("USERID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TALK_TBLMESSAGE_BACKUP
--------------------------------------------------------

  ALTER TABLE "TALK_TBLMESSAGE_BACKUP" MODIFY ("ROOMID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLMESSAGE_BACKUP" MODIFY ("MSEQ" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLMESSAGE_BACKUP" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLMESSAGE_BACKUP" MODIFY ("REGDATE" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLMESSAGE_BACKUP" MODIFY ("MESSAGE" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLMESSAGE_BACKUP" MODIFY ("COMPID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TALK_TBLNOTIFICATION
--------------------------------------------------------

  ALTER TABLE "TALK_TBLNOTIFICATION" MODIFY ("ITEMSEQ" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLNOTIFICATION" ADD PRIMARY KEY ("ITEMSEQ")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TALK_TBLORGANDELETEINFO
--------------------------------------------------------

  ALTER TABLE "TALK_TBLORGANDELETEINFO" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLORGANDELETEINFO" MODIFY ("TYPE" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLORGANDELETEINFO" MODIFY ("COMPID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLORGANDELETEINFO" MODIFY ("REGDATE" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TALK_TBLROOM
--------------------------------------------------------

  ALTER TABLE "TALK_TBLROOM" MODIFY ("ROOMID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLROOM" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLROOM" MODIFY ("COMPID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLROOM" MODIFY ("SVRID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLROOM" MODIFY ("ROOMTYPE" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLROOM" MODIFY ("REGDATE" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLROOM" ADD PRIMARY KEY ("ROOMID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TALK_TBLROOMMEMBER
--------------------------------------------------------

  ALTER TABLE "TALK_TBLROOMMEMBER" MODIFY ("MSEQ" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLROOMMEMBER" MODIFY ("STARTMSEQ" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLROOMMEMBER" MODIFY ("COMPID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLROOMMEMBER" MODIFY ("REGDATE" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLROOMMEMBER" MODIFY ("DELFLAG" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLROOMMEMBER" ADD PRIMARY KEY ("ROOMID", "MEMBERID")
  USING INDEX;
  ALTER TABLE "TALK_TBLROOMMEMBER" MODIFY ("ROOMID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLROOMMEMBER" MODIFY ("MEMBERID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TALK_TBLROOMMEMBERCONFIG
--------------------------------------------------------

  ALTER TABLE "TALK_TBLROOMMEMBERCONFIG" MODIFY ("ROOMID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLROOMMEMBERCONFIG" MODIFY ("MEMBERID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLROOMMEMBERCONFIG" MODIFY ("COMPID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLROOMMEMBERCONFIG" ADD PRIMARY KEY ("ROOMID", "MEMBERID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TALK_TBLROOMSEQ
--------------------------------------------------------

  ALTER TABLE "TALK_TBLROOMSEQ" MODIFY ("ROOMID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLROOMSEQ" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLROOMSEQ" MODIFY ("MAXSEQ" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLROOMSEQ" MODIFY ("COMPID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLROOMSEQ" ADD PRIMARY KEY ("ROOMID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TALK_TBLSERVERINFO
--------------------------------------------------------

  ALTER TABLE "TALK_TBLSERVERINFO" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLSERVERINFO" MODIFY ("IP" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLSERVERINFO" MODIFY ("PORT" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLSERVERINFO" MODIFY ("TYPE" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLSERVERINFO" MODIFY ("MAXSUPPORT" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLSERVERINFO" MODIFY ("NOWCONNECT" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLSERVERINFO" MODIFY ("STATUS" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLSERVERINFO" ADD PRIMARY KEY ("ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TALK_TBLUSER
--------------------------------------------------------

  ALTER TABLE "TALK_TBLUSER" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLUSER" MODIFY ("PWD" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLUSER" MODIFY ("NAME" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLUSER" MODIFY ("NAME2" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLUSER" MODIFY ("EMAIL" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLUSER" MODIFY ("DEPTID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLUSER" MODIFY ("DEPTNAME" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLUSER" MODIFY ("COMPID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLUSER" MODIFY ("COMPNAME" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLUSER" MODIFY ("UPDATEDATE" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLUSER" ADD PRIMARY KEY ("USERID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TALK_TBLUSERINFO
--------------------------------------------------------

  ALTER TABLE "TALK_TBLUSERINFO" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLUSERINFO" MODIFY ("COMPID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLUSERINFO" MODIFY ("UPDATEDATE" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLUSERINFO" ADD PRIMARY KEY ("USERID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TALK_TBLVERSION
--------------------------------------------------------

  ALTER TABLE "TALK_TBLVERSION" MODIFY ("TYPE" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLVERSION" MODIFY ("VALUE" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLVERSION" MODIFY ("REGDATE" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBLVERSION" ADD PRIMARY KEY ("TYPE", "REGDATE")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TALK_TBL_ADM_DEFALUTSERVER
--------------------------------------------------------

  ALTER TABLE "TALK_TBL_ADM_DEFALUTSERVER" MODIFY ("SERVERID" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBL_ADM_DEFALUTSERVER" ADD CONSTRAINT "TALK_TBL_ADM_DEFALUTSERVER_PK" PRIMARY KEY ("SERVERID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TALK_TBL_API_ACCESSKEY
--------------------------------------------------------

  ALTER TABLE "TALK_TBL_API_ACCESSKEY" MODIFY ("NAME" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBL_API_ACCESSKEY" MODIFY ("API" NOT NULL ENABLE);
  ALTER TABLE "TALK_TBL_API_ACCESSKEY" ADD CONSTRAINT "TALK_TBL_API_ACCESSKEY_PK" PRIMARY KEY ("NAME")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_ACCESS_COUNTRY
--------------------------------------------------------

  ALTER TABLE "TBL_ACCESS_COUNTRY" ADD CONSTRAINT "TBL_ACCESS_COUNTRY" PRIMARY KEY ("TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_ACCESS_COUNTRY" MODIFY ("COUNTRY_CODE" NOT NULL ENABLE);
  ALTER TABLE "TBL_ACCESS_COUNTRY" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_ACCESS_ID
--------------------------------------------------------

  ALTER TABLE "TBL_ACCESS_ID" ADD CONSTRAINT "TBL_ACCESS_ID_PK" PRIMARY KEY ("ACCESSNO")
  USING INDEX;
  ALTER TABLE "TBL_ACCESS_ID" MODIFY ("CN" NOT NULL ENABLE);
  ALTER TABLE "TBL_ACCESS_ID" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ACCESS_ID" MODIFY ("ACCESSNO" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_ACCESS_IP
--------------------------------------------------------

  ALTER TABLE "TBL_ACCESS_IP" ADD CONSTRAINT "TBL_ACCESS_IP_PK" PRIMARY KEY ("IPNO")
  USING INDEX;
  ALTER TABLE "TBL_ACCESS_IP" MODIFY ("ACCESS" NOT NULL ENABLE);
  ALTER TABLE "TBL_ACCESS_IP" MODIFY ("IPADDRESS" NOT NULL ENABLE);
  ALTER TABLE "TBL_ACCESS_IP" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ACCESS_IP" MODIFY ("IPNO" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_ADDJOBMASTER
--------------------------------------------------------

  ALTER TABLE "TBL_ADDJOBMASTER" ADD CONSTRAINT "PK_TBL_ADD_JOBMASTER" PRIMARY KEY ("TENANT_ID", "CN", "DEPTID", "JOBID", "ROLEID")
  USING INDEX;
  ALTER TABLE "TBL_ADDJOBMASTER" MODIFY ("DEPTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ADDJOBMASTER" MODIFY ("CN" NOT NULL ENABLE);
-------------------------------------------------------- 
--  Constraints for Table TBL_ADMIN_ACCESS_IP
--------------------------------------------------------

  ALTER TABLE "TBL_ADMIN_ACCESS_IP" MODIFY ("IPNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_ADMIN_ACCESS_IP" MODIFY ("IPADDRESS" NOT NULL ENABLE);
  ALTER TABLE "TBL_ADMIN_ACCESS_IP" ADD CONSTRAINT "PK2_TBL_ADMIN_ACCESS_IP" PRIMARY KEY ("IPNO")
  USING INDEX;  
--------------------------------------------------------
--  Constraints for Table TBL_ADMINRECEIPTGROUP_MAIN
--------------------------------------------------------

  ALTER TABLE "TBL_ADMINRECEIPTGROUP_MAIN" ADD CONSTRAINT "TBL_ADMINRECEIPTGROUP_MAIN_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "MAINID")
  USING INDEX;
  ALTER TABLE "TBL_ADMINRECEIPTGROUP_MAIN" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ADMINRECEIPTGROUP_MAIN" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ADMINRECEIPTGROUP_MAIN" MODIFY ("MAINID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_ADMINRECEIPTGROUP_SUB
--------------------------------------------------------

  ALTER TABLE "TBL_ADMINRECEIPTGROUP_SUB" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ADMINRECEIPTGROUP_SUB" MODIFY ("SUBID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ADMINRECEIPTGROUP_SUB" MODIFY ("MAINID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ADMINRECEIPTGROUP_SUB" ADD CONSTRAINT "PK_TBL_ADMINRECEIPTGROUP_SUB" PRIMARY KEY ("TENANT_ID", "SUBID", "COMPANYID")
  USING INDEX;
  ALTER TABLE "TBL_ADMINRECEIPTGROUP_SUB" MODIFY ("COMPANYID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_APRATTACHINFO
--------------------------------------------------------

  ALTER TABLE "TBL_APRATTACHINFO" ADD CONSTRAINT "TBL_APRATTACHINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "DOCID", "ATTACHFILESN")
  USING INDEX;
  ALTER TABLE "TBL_APRATTACHINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_APRATTACHINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_APRATTACHINFO" MODIFY ("ATTACHFILESN" NOT NULL ENABLE);
  ALTER TABLE "TBL_APRATTACHINFO" MODIFY ("DOCID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_APRDOCATTACHINFO
--------------------------------------------------------

  ALTER TABLE "TBL_APRDOCATTACHINFO" ADD CONSTRAINT "TBL_APRDOCATTACHINFO_PK" PRIMARY KEY ("TENANT_ID", "DOCID", "ATTACHSN", "COMPANYID")
  USING INDEX;
  ALTER TABLE "TBL_APRDOCATTACHINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_APRDOCATTACHINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_APRDOCATTACHINFO" MODIFY ("ATTACHSN" NOT NULL ENABLE);
  ALTER TABLE "TBL_APRDOCATTACHINFO" MODIFY ("DOCID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_APRDOCGROUPINFO
--------------------------------------------------------

  ALTER TABLE "TBL_APRDOCGROUPINFO" ADD CONSTRAINT "TBL_APRDOCGROUPINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "GROUPDOCSN", "TABSN")
  USING INDEX;
  ALTER TABLE "TBL_APRDOCGROUPINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_APRDOCGROUPINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_APRDOCGROUPINFO" MODIFY ("GROUPDOCSN" NOT NULL ENABLE);
  ALTER TABLE "TBL_APRDOCGROUPINFO" MODIFY ("TABSN" NOT NULL ENABLE);
  ALTER TABLE "TBL_APRDOCGROUPINFO" MODIFY ("DOCID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_APRDOCINFO
--------------------------------------------------------

  ALTER TABLE "TBL_APRDOCINFO" ADD CONSTRAINT "TBL_APRDOCINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "DOCID")
  USING INDEX;
  ALTER TABLE "TBL_APRDOCINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_APRDOCINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_APRDOCINFO" MODIFY ("DOCID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_APRLINEINFO
--------------------------------------------------------

  ALTER TABLE "TBL_APRLINEINFO" ADD CONSTRAINT "TBL_APRLINEINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "DOCID", "APRMEMBERSN")
  USING INDEX;
  ALTER TABLE "TBL_APRLINEINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_APRLINEINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_APRLINEINFO" MODIFY ("APRMEMBERSN" NOT NULL ENABLE);
  ALTER TABLE "TBL_APRLINEINFO" MODIFY ("DOCID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_APROPINIONINFO
--------------------------------------------------------

  ALTER TABLE "TBL_APROPINIONINFO" ADD CONSTRAINT "TBL_APROPINIONINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "DOCID", "USERID", "OPINIONSN")
  USING INDEX;
  ALTER TABLE "TBL_APROPINIONINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_APROPINIONINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_APROPINIONINFO" MODIFY ("OPINIONSN" NOT NULL ENABLE);
  ALTER TABLE "TBL_APROPINIONINFO" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_APROPINIONINFO" MODIFY ("DOCID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_APRRECEIPTPROCESSINFO
--------------------------------------------------------

  ALTER TABLE "TBL_APRRECEIPTPROCESSINFO" ADD CONSTRAINT "TBL_APRRECEIPTPROCESSINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "RECEIVESN", "DOCID", "RECEIVEDDEPTID")
  USING INDEX;
  ALTER TABLE "TBL_APRRECEIPTPROCESSINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_APRRECEIPTPROCESSINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_APRRECEIPTPROCESSINFO" MODIFY ("RECEIVEDDEPTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_APRRECEIPTPROCESSINFO" MODIFY ("DOCID" NOT NULL ENABLE);
  ALTER TABLE "TBL_APRRECEIPTPROCESSINFO" MODIFY ("RECEIVESN" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_ATTENDANT
--------------------------------------------------------

  ALTER TABLE "TBL_ATTENDANT" ADD CONSTRAINT "PK_TBL_ATTENDANT" PRIMARY KEY ("TENANT_ID", "SCHEDULEID", "ATTENDANTID")
  USING INDEX;
  ALTER TABLE "TBL_ATTENDANT" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTENDANT" MODIFY ("RESPONSEDATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTENDANT" MODIFY ("STATUS" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTENDANT" MODIFY ("ATTENDANTDEPTNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTENDANT" MODIFY ("ATTENDANTNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTENDANT" MODIFY ("ATTENDANTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTENDANT" MODIFY ("SCHEDULEID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_ATTITUDE
--------------------------------------------------------

  ALTER TABLE "TBL_ATTITUDE" ADD CONSTRAINT "PK_ATTITUDE" PRIMARY KEY ("ATTITUDE_ID")
  USING INDEX;
  ALTER TABLE "TBL_ATTITUDE" MODIFY ("DATE_TYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE" MODIFY ("START_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE" MODIFY ("DEPT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE" MODIFY ("WRITER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE" MODIFY ("ATTITUDE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_ATTITUDE_ANNUAL
--------------------------------------------------------

  ALTER TABLE "TBL_ATTITUDE_ANNUAL" MODIFY ("MONTHLY_HOLIDAY_CNT" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_ANNUAL" MODIFY ("USER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_ANNUAL" ADD PRIMARY KEY ("USER_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_ATTITUDE_ANNUAL" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_ANNUAL" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_ANNUAL" MODIFY ("ADDITIONAL_HOLIDAY_CNT" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_ANNUAL" MODIFY ("ANNUAL_HOLIDAY_CNT" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_ATTITUDE_ANNUAL_CANAPPL
--------------------------------------------------------

  ALTER TABLE "TBL_ATTITUDE_ANNUAL_CANAPPL" ADD CONSTRAINT "TBL_ATTITUDE_ANNUAL_CANAPPL_PK" PRIMARY KEY ("ATTITUDE_ID", "APPL_CNT", "COMPANY_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_ATTITUDE_ANNUAL_CANAPPL" MODIFY ("WRITER_DEPT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_ANNUAL_CANAPPL" MODIFY ("WRITER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_ANNUAL_CANAPPL" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_ANNUAL_CANAPPL" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_ANNUAL_CANAPPL" MODIFY ("APPL_CNT" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_ANNUAL_CANAPPL" MODIFY ("ATTITUDE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_ATTITUDE_ANNUAL_CONF
--------------------------------------------------------

  ALTER TABLE "TBL_ATTITUDE_ANNUAL_CONF" ADD CONSTRAINT "TBL_ATTITUDE_ANNUAL_CONF_PK" PRIMARY KEY ("COMPANY_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_ATTITUDE_ANNUAL_CONF" MODIFY ("CONF_SET_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_ANNUAL_CONF" MODIFY ("ROUND_OFF_RULE" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_ANNUAL_CONF" MODIFY ("USE_ANNUAL_TMNT" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_ANNUAL_CONF" MODIFY ("USE_MINUS_ANNUAL" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_ANNUAL_CONF" MODIFY ("ANNUAL_GNRT_STD" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_ANNUAL_CONF" MODIFY ("USE_ANNUAL_AUTO_GNRT" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_ANNUAL_CONF" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_ANNUAL_CONF" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_ATTITUDE_ANNUAL_HISTORY
--------------------------------------------------------

  ALTER TABLE "TBL_ATTITUDE_ANNUAL_HISTORY" ADD CONSTRAINT "TBL_ATTITUDE_ANNUAL_HISTORY_PK" PRIMARY KEY ("ANNUAL_HISTORY_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_ATTITUDE_APR_CONN
--------------------------------------------------------

  ALTER TABLE "TBL_ATTITUDE_APR_CONN" ADD CONSTRAINT "TBL_ATTITUDE_APR_CONN_PK" PRIMARY KEY ("ATTITUDE_ID", "COMPANY_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_ATTITUDE_APR_CONN" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_APR_CONN" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_APR_CONN" MODIFY ("ANNUAL_DOC_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_APR_CONN" MODIFY ("ATTITUDE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_ATTITUDE_AUTH
--------------------------------------------------------

  ALTER TABLE "TBL_ATTITUDE_AUTH" ADD CONSTRAINT "PK_ATTITUDE_AUTH" PRIMARY KEY ("USER_ID", "TENANT_ID", "AUTH_DEPT_ID")
  USING INDEX;
  ALTER TABLE "TBL_ATTITUDE_AUTH" MODIFY ("AUTH_TYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_AUTH" MODIFY ("AUTH_DEPT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_AUTH" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_AUTH" MODIFY ("USER_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_ATTITUDE_CONF
--------------------------------------------------------

  ALTER TABLE "TBL_ATTITUDE_CONF" ADD CONSTRAINT "PK_ATTITUDE_CONF" PRIMARY KEY ("COMPANY_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_ATTITUDE_CONF" MODIFY ("CONF_SET_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_CONF" MODIFY ("CLOSED_DATE_ATTITUDE" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_CONF" MODIFY ("ATTITUDE_MOD_APPL" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_CONF" MODIFY ("CLOSED_DAY" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_CONF" MODIFY ("WORK_ENDTIME" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_CONF" MODIFY ("WORK_STARTTIME" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_CONF" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_CONF" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_ATTITUDE_FORM
--------------------------------------------------------

  ALTER TABLE "TBL_ATTITUDE_FORM" ADD CONSTRAINT "PK_ATTITUDE_FORM" PRIMARY KEY ("FORM_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_ATTITUDE_FORM" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_FORM" MODIFY ("FORM_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_ATTITUDE_MODAPPL
--------------------------------------------------------

  ALTER TABLE "TBL_ATTITUDE_MODAPPL" MODIFY ("ATTITUDE_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_MODAPPL" ADD CONSTRAINT "PK_ATTITUDE_MODAPPL" PRIMARY KEY ("ATTITUDE_ID", "APPL_CNT", "COMPANY_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_ATTITUDE_MODAPPL" MODIFY ("CHANGE_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_MODAPPL" MODIFY ("ORIGIN_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_MODAPPL" MODIFY ("WRITER_DEPT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_MODAPPL" MODIFY ("WRITER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_MODAPPL" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_MODAPPL" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_MODAPPL" MODIFY ("APPL_CNT" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_ATTITUDE_MODAPPL_HISTORY
--------------------------------------------------------

  ALTER TABLE "TBL_ATTITUDE_MODAPPL_HISTORY" ADD CONSTRAINT "PK_ATTITUDE_MODAPPL_HISTORY" PRIMARY KEY ("MOD_CNT")
  USING INDEX;
  ALTER TABLE "TBL_ATTITUDE_MODAPPL_HISTORY" MODIFY ("WRITER_DEPT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_MODAPPL_HISTORY" MODIFY ("WRITER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_MODAPPL_HISTORY" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_MODAPPL_HISTORY" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_MODAPPL_HISTORY" MODIFY ("MOD_CNT" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_ATTITUDE_TYPE
--------------------------------------------------------

  ALTER TABLE "TBL_ATTITUDE_TYPE" ADD CONSTRAINT "PK_ATTITUDE_TYPE" PRIMARY KEY ("ORDER", "TYPE_ID", "COMPANY_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_ATTITUDE_TYPE" MODIFY ("ISDEL" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_TYPE" MODIFY ("ISADD" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_TYPE" MODIFY ("FORM_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_TYPE" MODIFY ("ISUSE" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_TYPE" MODIFY ("TYPE_NAME2" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_TYPE" MODIFY ("TYPE_NAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_TYPE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_TYPE" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_TYPE" MODIFY ("TYPE_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_TYPE" MODIFY ("ORDER" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_ATTITUDE_USER_CONF
--------------------------------------------------------

  ALTER TABLE "TBL_ATTITUDE_USER_CONF" ADD CONSTRAINT "PK_ATTITUDE_USER_CONF" PRIMARY KEY ("USER_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_ATTITUDE_USER_CONF" MODIFY ("DEPT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_USER_CONF" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_USER_CONF" MODIFY ("WORK_ENDTIME" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_USER_CONF" MODIFY ("WORK_STARTTIME" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_USER_CONF" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ATTITUDE_USER_CONF" MODIFY ("USER_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_AUDIO_VISUALRECEXINFO
--------------------------------------------------------

  ALTER TABLE "TBL_AUDIO_VISUALRECEXINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_AUDIO_VISUALRECEXINFO" MODIFY ("SEPERATEATTACHNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_AUDIO_VISUALRECEXINFO" MODIFY ("RECORDID" NOT NULL ENABLE);
  ALTER TABLE "TBL_AUDIO_VISUALRECEXINFO" ADD CONSTRAINT "TBL_AUDIO_VISUALRECEXINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "RECORDID", "SEPERATEATTACHNO")
  USING INDEX;
  ALTER TABLE "TBL_AUDIO_VISUALRECEXINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_AUDIO_VISUALRECEXINFO_TEMP
--------------------------------------------------------

  ALTER TABLE "TBL_AUDIO_VISUALRECEXINFO_TEMP" ADD CONSTRAINT "TBL_AUDIO_VISUALRECEXINFO__PK" PRIMARY KEY ("DOCID", "TENANT_ID", "COMPANYID", "SEPERATEATTACHNO")
  USING INDEX;
  ALTER TABLE "TBL_AUDIO_VISUALRECEXINFO_TEMP" MODIFY ("SEPERATEATTACHNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_AUDIO_VISUALRECEXINFO_TEMP" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_AUDIO_VISUALRECEXINFO_TEMP" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_AUDIO_VISUALRECEXINFO_TEMP" MODIFY ("DOCID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_AUTODOCNUM_ITEM
--------------------------------------------------------

  ALTER TABLE "TBL_AUTODOCNUM_ITEM" ADD CONSTRAINT "TBL_AUTODOCNUM_ITEM_PK" PRIMARY KEY ("FORMID", "COMPANYID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_AUTODOCNUM_ITEM" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_AUTODOCNUM_ITEM" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_AUTODOCNUM_ITEM" MODIFY ("FORMID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_BOARD_APPRLIST
--------------------------------------------------------

  ALTER TABLE "TBL_BOARD_APPRLIST" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_APPRLIST" ADD CONSTRAINT "PK_TBL_BOARD_APPRLIST" PRIMARY KEY ("TENANT_ID", "BOARDID", "APPRUSERID")
  USING INDEX;
  ALTER TABLE "TBL_BOARD_APPRLIST" MODIFY ("APPRUSERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_APPRLIST" MODIFY ("BOARDID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_BOARD_BOARDBACKGROUNDINFO
--------------------------------------------------------

  ALTER TABLE "TBL_BOARD_BOARDBACKGROUNDINFO" ADD CONSTRAINT "TBL_BOARD_BOARDBACKGROUNDI_PK" PRIMARY KEY ("TENANT_ID", "BACKGROUNDID")
  USING INDEX;
  ALTER TABLE "TBL_BOARD_BOARDBACKGROUNDINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_BOARDBACKGROUNDINFO" MODIFY ("BACKGROUNDID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_BOARD_BOARDINFO
--------------------------------------------------------

  ALTER TABLE "TBL_BOARD_BOARDINFO" MODIFY ("BOARDID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_BOARDINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_BOARDINFO" ADD CONSTRAINT "PK_TBL_BOARD_BOARDINFO" PRIMARY KEY ("TENANT_ID", "BOARDID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_BOARD_BOARDINFO_ATTRIBUTE
--------------------------------------------------------

  ALTER TABLE "TBL_BOARD_BOARDINFO_ATTRIBUTE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_BOARDINFO_ATTRIBUTE" ADD CONSTRAINT "PK_TBL_BOARD_BOARDINFO_ATTR" PRIMARY KEY ("TENANT_ID", "BOARDID", "TABLECOL")
  USING INDEX;
  ALTER TABLE "TBL_BOARD_BOARDINFO_ATTRIBUTE" MODIFY ("TABLECOL" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_BOARDINFO_ATTRIBUTE" MODIFY ("BOARDID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_BOARD_BOARDMANAGE
--------------------------------------------------------

  ALTER TABLE "TBL_BOARD_BOARDMANAGE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_BOARDMANAGE" ADD CONSTRAINT "PK_TBL_BOARD_BOARDMANAGE" PRIMARY KEY ("TENANT_ID", "BOARDID", "ACCESSID")
  USING INDEX;
  ALTER TABLE "TBL_BOARD_BOARDMANAGE" MODIFY ("ACCESSID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_BOARDMANAGE" MODIFY ("BOARDID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_BOARD_CONFIGURATION
--------------------------------------------------------

  ALTER TABLE "TBL_BOARD_CONFIGURATION" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_CONFIGURATION" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_CONFIGURATION" ADD CONSTRAINT "PK_TBL_BOARD_CONFIGURATION" PRIMARY KEY ("TENANT_ID", "USERID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_BOARD_DELETERESERVEDBOARD
--------------------------------------------------------

  ALTER TABLE "TBL_BOARD_DELETERESERVEDBOARD" ADD CONSTRAINT "PK_TBL_BOARD_DELETERESERVED" PRIMARY KEY ("TENANT_ID", "BOARDID")
  USING INDEX;
  ALTER TABLE "TBL_BOARD_DELETERESERVEDBOARD" MODIFY ("BOARDID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_DELETERESERVEDBOARD" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_BOARD_DELETERESERVEDITEM
--------------------------------------------------------

  ALTER TABLE "TBL_BOARD_DELETERESERVEDITEM" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_DELETERESERVEDITEM" ADD CONSTRAINT "PK_TBL_BOARD_DELETERESERVEDIT" PRIMARY KEY ("TENANT_ID", "BOARDID", "ITEMID")
  USING INDEX;
  ALTER TABLE "TBL_BOARD_DELETERESERVEDITEM" MODIFY ("ITEMID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_DELETERESERVEDITEM" MODIFY ("BOARDID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_BOARD_ITEM
--------------------------------------------------------

  ALTER TABLE "TBL_BOARD_ITEM" ADD CONSTRAINT "PK_TBL_BOARD_ITEM" PRIMARY KEY ("TENANT_ID", "ITEMID")
  USING INDEX;
  ALTER TABLE "TBL_BOARD_ITEM" MODIFY ("BOARDID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_ITEM" MODIFY ("ITEMID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_ITEM" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_BOARD_ITEM_ATTACHMENTS
--------------------------------------------------------

  ALTER TABLE "TBL_BOARD_ITEM_ATTACHMENTS" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_ITEM_ATTACHMENTS" ADD CONSTRAINT "PK_TBL_BOARD_ITEM_ATTACHMENTS" PRIMARY KEY ("TENANT_ID", "ITEMID", "FILEPATH")
  USING INDEX;
  ALTER TABLE "TBL_BOARD_ITEM_ATTACHMENTS" MODIFY ("FILEPATH" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_ITEM_ATTACHMENTS" MODIFY ("ITEMID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_BOARD_ITEM_LISTOPTION
--------------------------------------------------------

  ALTER TABLE "TBL_BOARD_ITEM_LISTOPTION" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_ITEM_LISTOPTION" ADD CONSTRAINT "PK_TBL_BOARD_ITEM_LISTOPTION" PRIMARY KEY ("TENANT_ID", "LISTTYPE", "SN")
  USING INDEX;
  ALTER TABLE "TBL_BOARD_ITEM_LISTOPTION" MODIFY ("VIEW_FG" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_ITEM_LISTOPTION" MODIFY ("WIDTH" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_ITEM_LISTOPTION" MODIFY ("COLNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_ITEM_LISTOPTION" MODIFY ("SN" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_ITEM_LISTOPTION" MODIFY ("LISTTYPE" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_BOARD_ITEM_LISTOPTION_BOAR
--------------------------------------------------------

  ALTER TABLE "TBL_BOARD_ITEM_LISTOPTION_BOAR" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_ITEM_LISTOPTION_BOAR" ADD CONSTRAINT "PK_TBL_BOARD_ITEM_LISTOPTION_1" PRIMARY KEY ("TENANT_ID", "BOARDID", "SN")
  USING INDEX;
  ALTER TABLE "TBL_BOARD_ITEM_LISTOPTION_BOAR" MODIFY ("VIEW_FG" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_ITEM_LISTOPTION_BOAR" MODIFY ("WIDTH" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_ITEM_LISTOPTION_BOAR" MODIFY ("COLNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_ITEM_LISTOPTION_BOAR" MODIFY ("SN" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_ITEM_LISTOPTION_BOAR" MODIFY ("BOARDID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_BOARD_ITEM_READ
--------------------------------------------------------

  ALTER TABLE "TBL_BOARD_ITEM_READ" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_ITEM_READ" ADD CONSTRAINT "PK_TBL_BOARD_ITEM_READ" PRIMARY KEY ("TENANT_ID", "BOARDID", "ITEMID", "USERID")
  USING INDEX;
  ALTER TABLE "TBL_BOARD_ITEM_READ" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_ITEM_READ" MODIFY ("ITEMID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_ITEM_READ" MODIFY ("BOARDID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_BOARD_ITEM_TEMP
--------------------------------------------------------

  ALTER TABLE "TBL_BOARD_ITEM_TEMP" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_ITEM_TEMP" ADD CONSTRAINT "PK_TBL_BOARD_ITEM_TEMP" PRIMARY KEY ("TENANT_ID", "ITEMID")
  USING INDEX;
  ALTER TABLE "TBL_BOARD_ITEM_TEMP" MODIFY ("BOARDID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_ITEM_TEMP" MODIFY ("ITEMID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_BOARD_LIKE
--------------------------------------------------------

  ALTER TABLE "TBL_BOARD_LIKE" ADD CONSTRAINT "TBL_BOARD_LIKE_PK" PRIMARY KEY ("ITEMID", "USERID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_BOARD_LIKE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_LIKE" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_LIKE" MODIFY ("ITEMID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_BOARD_MYBOARDS
--------------------------------------------------------

  ALTER TABLE "TBL_BOARD_MYBOARDS" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_MYBOARDS" MODIFY ("BOARDID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_MYBOARDS" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_MYBOARDS" ADD PRIMARY KEY ("TENANT_ID", "USERID", "BOARDID", "COMPANYID")
  USING INDEX;
  ALTER TABLE "TBL_BOARD_MYBOARDS" MODIFY ("COMPANYID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_BOARD_MYTREE
--------------------------------------------------------

  ALTER TABLE "TBL_BOARD_MYTREE" ADD CONSTRAINT "PK_TBL_BOARD_MYTREE" PRIMARY KEY ("TENANT_ID", "TREEID")
  USING INDEX;
  ALTER TABLE "TBL_BOARD_MYTREE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_MYTREE" MODIFY ("TREESTEP" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_MYTREE" MODIFY ("TREENAME2" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_MYTREE" MODIFY ("TREENAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_MYTREE" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_MYTREE" MODIFY ("TREEID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_BOARD_NEWBOARD_ORDERINFO
--------------------------------------------------------

  ALTER TABLE "TBL_BOARD_NEWBOARD_ORDERINFO" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_NEWBOARD_ORDERINFO" ADD PRIMARY KEY ("TENANT_ID", "USERID", "COMPANYID")
  USING INDEX;
  ALTER TABLE "TBL_BOARD_NEWBOARD_ORDERINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_NEWBOARD_ORDERINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_BOARD_ONELINEREPLY
--------------------------------------------------------

  ALTER TABLE "TBL_BOARD_ONELINEREPLY" ADD CONSTRAINT "PK_TBL_BOARD_ONELINEREPLY" PRIMARY KEY ("TENANT_ID", "ITEMID", "REPLYID")
  USING INDEX;
  ALTER TABLE "TBL_BOARD_ONELINEREPLY" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_ONELINEREPLY" MODIFY ("BOARDID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_ONELINEREPLY" MODIFY ("REPLYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_ONELINEREPLY" MODIFY ("ITEMID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_BOARD_TREECACHE
--------------------------------------------------------

  ALTER TABLE "TBL_BOARD_TREECACHE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOARD_TREECACHE" ADD CONSTRAINT "PK_TBL_BOARD_TREECACHE" PRIMARY KEY ("TENANT_ID", "QUERY")
  USING INDEX;
  ALTER TABLE "TBL_BOARD_TREECACHE" MODIFY ("QUERY" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CABINET
--------------------------------------------------------

  ALTER TABLE "TBL_CABINET" ADD CONSTRAINT "SYS_C0023425" CHECK ("TRANSFERFLAG" IS NOT NULL) DISABLE;
  ALTER TABLE "TBL_CABINET" ADD CONSTRAINT "SYS_C0023424" CHECK ("PRODREPORTFLAG" IS NOT NULL) DISABLE;
  ALTER TABLE "TBL_CABINET" ADD CONSTRAINT "SYS_C0023423" CHECK ("CABINETTRANSFERFLAG" IS NOT NULL) DISABLE;
  ALTER TABLE "TBL_CABINET" ADD CONSTRAINT "SYS_C0023422" CHECK ("DELFLAG" IS NOT NULL) DISABLE;
  ALTER TABLE "TBL_CABINET" ADD CONSTRAINT "SYS_C0023421" CHECK ("VOLUMENO" IS NOT NULL) DISABLE;
  ALTER TABLE "TBL_CABINET" ADD CONSTRAINT "PK_TBL_CABINET" PRIMARY KEY ("TENANT_ID", "CABINETID", "COMPANYID")
  USING INDEX;
  ALTER TABLE "TBL_CABINET" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CABINET" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CABINET" MODIFY ("CABINETCLASSNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_CABINET" MODIFY ("CABINETID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CABINETCLASS
--------------------------------------------------------

  ALTER TABLE "TBL_CABINETCLASS" ADD CONSTRAINT "SYS_C0023436" CHECK ("OWNERDEPTID" IS NOT NULL) DISABLE;
  ALTER TABLE "TBL_CABINETCLASS" ADD CONSTRAINT "SYS_C0023435" CHECK ("DELFLAG" IS NOT NULL) DISABLE;
  ALTER TABLE "TBL_CABINETCLASS" ADD CONSTRAINT "SYS_C0023434" CHECK ("CONFIRMFLAG" IS NOT NULL) DISABLE;
  ALTER TABLE "TBL_CABINETCLASS" ADD CONSTRAINT "SYS_C0023433" CHECK ("TRANSDELAYFLAG" IS NOT NULL) DISABLE;
  ALTER TABLE "TBL_CABINETCLASS" ADD CONSTRAINT "SYS_C0023432" CHECK ("MODIFYFLAG" IS NOT NULL) DISABLE;
  ALTER TABLE "TBL_CABINETCLASS" ADD CONSTRAINT "SYS_C0023431" CHECK ("TERMINATEFLAG" IS NOT NULL) DISABLE;
  ALTER TABLE "TBL_CABINETCLASS" ADD CONSTRAINT "SYS_C0023430" CHECK ("REGSERIALNO" IS NOT NULL) DISABLE;
  ALTER TABLE "TBL_CABINETCLASS" ADD CONSTRAINT "PK__TBL_CABINETCLASS__10216507" PRIMARY KEY ("TENANT_ID", "CABINETCLASSNO", "COMPANYID")
  USING INDEX;
  ALTER TABLE "TBL_CABINETCLASS" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CABINETCLASS" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CABINETCLASS" MODIFY ("PRODUCTIONYEAR" NOT NULL ENABLE);
  ALTER TABLE "TBL_CABINETCLASS" MODIFY ("CABINETCLASSNO" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CABINETCODELIST
--------------------------------------------------------

  ALTER TABLE "TBL_CABINETCODELIST" ADD CONSTRAINT "TBL_CABINETCODELIST_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "CODETYPE", "CODE")
  USING INDEX;
  ALTER TABLE "TBL_CABINETCODELIST" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CABINETCODELIST" MODIFY ("ISUSED" NOT NULL ENABLE);
  ALTER TABLE "TBL_CABINETCODELIST" MODIFY ("CODE" NOT NULL ENABLE);
  ALTER TABLE "TBL_CABINETCODELIST" MODIFY ("CODETYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_CABINETCODELIST" MODIFY ("COMPANYID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CABINETHISTORY
--------------------------------------------------------

  ALTER TABLE "TBL_CABINETHISTORY" ADD CONSTRAINT "TBL_CABINETHISTORY_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "VERSION", "CABINETCLASSNO")
  USING INDEX;
  ALTER TABLE "TBL_CABINETHISTORY" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CABINETHISTORY" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CABINETHISTORY" MODIFY ("CABINETCLASSNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_CABINETHISTORY" MODIFY ("VERSION" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CABINET_VIEWAUTH
--------------------------------------------------------

  ALTER TABLE "TBL_CABINET_VIEWAUTH" ADD CONSTRAINT "TBL_CABINET_VIEWAUTH_PK" PRIMARY KEY ("CABINETID", "TENANT_ID", "COMPANYID")
  USING INDEX;
  ALTER TABLE "TBL_CABINET_VIEWAUTH" MODIFY ("MNG_FG" NOT NULL ENABLE);
  ALTER TABLE "TBL_CABINET_VIEWAUTH" MODIFY ("ACCESS_LV" NOT NULL ENABLE);
  ALTER TABLE "TBL_CABINET_VIEWAUTH" MODIFY ("CN" NOT NULL ENABLE);
  ALTER TABLE "TBL_CABINET_VIEWAUTH" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CABINET_VIEWAUTH" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CABINET_VIEWAUTH" MODIFY ("CABINETID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CABROLEINFO
--------------------------------------------------------

  ALTER TABLE "TBL_CABROLEINFO" ADD CONSTRAINT "PK_TBL_CABROLEINFO" PRIMARY KEY ("TENANT_ID", "USER_ID", "CABINETCLASSNO", "COMPANYID")
  USING INDEX;
  ALTER TABLE "TBL_CABROLEINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CABROLEINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CABROLEINFO" MODIFY ("CABINETCLASSNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_CABROLEINFO" MODIFY ("USER_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CB_ADMIN_MODULE
--------------------------------------------------------

  ALTER TABLE "TBL_CB_ADMIN_MODULE" ADD CONSTRAINT "TBL_CB_ADMIN_MODULE_PK" PRIMARY KEY ("COMPANY_ID", "MODULE_TYPE", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_CB_ADMIN_MODULE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_ADMIN_MODULE" MODIFY ("ACTIVE_STATUS" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_ADMIN_MODULE" MODIFY ("MODULE_TYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_ADMIN_MODULE" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CB_ATTACH_FILE
--------------------------------------------------------

  ALTER TABLE "TBL_CB_ATTACH_FILE" ADD CONSTRAINT "TBL_CB_ATTACH_FILE_PK" PRIMARY KEY ("ATTACH_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_CB_ATTACH_FILE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_ATTACH_FILE" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_ATTACH_FILE" MODIFY ("FILE_SIZE" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_ATTACH_FILE" MODIFY ("FILE_NAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_ATTACH_FILE" MODIFY ("FILE_PATH" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_ATTACH_FILE" MODIFY ("ITEM_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_ATTACH_FILE" MODIFY ("ATTACH_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CB_CABINET
--------------------------------------------------------

  ALTER TABLE "TBL_CB_CABINET" ADD CONSTRAINT "TBL_CB_CABINET_PK" PRIMARY KEY ("CABINET_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_CB_CABINET" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_CABINET" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_CABINET" MODIFY ("USE_STATUS" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_CABINET" MODIFY ("UPDATE_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_CABINET" MODIFY ("UPDATE_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_CABINET" MODIFY ("CREATE_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_CABINET" MODIFY ("CABINET_LEVEL" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_CABINET" MODIFY ("CABINET_ORDER" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_CABINET" MODIFY ("CABINET_PATH" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_CABINET" MODIFY ("PARENT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_CABINET" MODIFY ("CABINET_TYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_CABINET" MODIFY ("DEPARTMENT_NAME1" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_CABINET" MODIFY ("DEPARTMENT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_CABINET" MODIFY ("CREATOR_NAME2" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_CABINET" MODIFY ("CREATOR_NAME1" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_CABINET" MODIFY ("CREATOR_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_CABINET" MODIFY ("CABINET_NAME2" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_CABINET" MODIFY ("CABINET_NAME1" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_CABINET" MODIFY ("CABINET_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CB_COMPANY_CAPACITY
--------------------------------------------------------

  ALTER TABLE "TBL_CB_COMPANY_CAPACITY" ADD CONSTRAINT "TBL_CB_COMPANY_CAPACITY_PK" PRIMARY KEY ("COMPANY_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_CB_COMPANY_CAPACITY" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_COMPANY_CAPACITY" MODIFY ("CAPACITY_TYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_COMPANY_CAPACITY" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CB_CONFIG
--------------------------------------------------------

  ALTER TABLE "TBL_CB_CONFIG" ADD CONSTRAINT "TBL_CB_CONFIG_PK" PRIMARY KEY ("USER_ID", "COMPANY_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_CB_CONFIG" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_CONFIG" MODIFY ("CONTENT_HPERCENT" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_CONFIG" MODIFY ("CONTENT_WPERCENT" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_CONFIG" MODIFY ("PREVIEW_MODE" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_CONFIG" MODIFY ("LIST_COUNT" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_CONFIG" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_CONFIG" MODIFY ("USER_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CB_ITEM
--------------------------------------------------------

  ALTER TABLE "TBL_CB_ITEM" ADD CONSTRAINT "TBL_CB_ITEM_PK" PRIMARY KEY ("ITEM_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_CB_ITEM" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_ITEM" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_ITEM" MODIFY ("UPDATE_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_ITEM" MODIFY ("USE_STATUS" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_ITEM" MODIFY ("UPDATE_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_ITEM" MODIFY ("CREATE_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_ITEM" MODIFY ("DEPARTMENT_NAME1" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_ITEM" MODIFY ("DEPARTMENT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_ITEM" MODIFY ("CREATOR_NAME2" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_ITEM" MODIFY ("CREATOR_NAME1" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_ITEM" MODIFY ("CREATOR_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_ITEM" MODIFY ("TITLE" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_ITEM" MODIFY ("ITEM_TYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_ITEM" MODIFY ("CABINET_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_ITEM" MODIFY ("ITEM_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CB_REL
--------------------------------------------------------

  ALTER TABLE "TBL_CB_REL" ADD CONSTRAINT "TBL_CB_REL_PK" PRIMARY KEY ("REL_ID", "TENANT_ID", "ITEM_ID")
  USING INDEX;
  ALTER TABLE "TBL_CB_REL" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_REL" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_REL" MODIFY ("ITEM_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_REL" MODIFY ("REL_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CB_RELATION
--------------------------------------------------------

  ALTER TABLE "TBL_CB_RELATION" ADD CONSTRAINT "TBL_CB_RELATION_PK" PRIMARY KEY ("RELATION_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_CB_RELATION" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_RELATION" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_RELATION" MODIFY ("RELATE_ITEM_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_RELATION" MODIFY ("ITEM_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_RELATION" MODIFY ("RELATION_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CB_SHARE
--------------------------------------------------------

  ALTER TABLE "TBL_CB_SHARE" MODIFY ("CHILD_PERMISSION" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_SHARE" MODIFY ("SHARE_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_SHARE" MODIFY ("PERMISSION" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_SHARE" MODIFY ("SHARED_TYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_SHARE" MODIFY ("SHARED_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_SHARE" MODIFY ("SHARER_NAME2" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_SHARE" MODIFY ("SHARER_NAME1" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_SHARE" MODIFY ("SHARER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_SHARE" MODIFY ("CABINET_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_SHARE" MODIFY ("SHARE_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_SHARE" ADD CONSTRAINT "TBL_CB_SHARE_PK" PRIMARY KEY ("SHARE_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_CB_SHARE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_SHARE" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_SHARE" MODIFY ("USE_STATUS" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_SHARE" MODIFY ("SAVEFLAG" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CB_USER_CAPACITY
--------------------------------------------------------

  ALTER TABLE "TBL_CB_USER_CAPACITY" ADD CONSTRAINT "TBL_CB_USER_CAPACITY_PK" PRIMARY KEY ("USER_ID", "COMPANY_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_CB_USER_CAPACITY" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_USER_CAPACITY" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_USER_CAPACITY" MODIFY ("CAPACITY_TYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_USER_CAPACITY" MODIFY ("USER_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CB_USER_MODULE
--------------------------------------------------------

  ALTER TABLE "TBL_CB_USER_MODULE" ADD CONSTRAINT "TBL_CB_USER_MODULE_PK" PRIMARY KEY ("USER_ID", "COMPANY_ID", "MODULE_TYPE", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_CB_USER_MODULE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_USER_MODULE" MODIFY ("ACTIVE_STATUS" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_USER_MODULE" MODIFY ("MODULE_TYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_USER_MODULE" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CB_USER_MODULE" MODIFY ("USER_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CIRCULAR
--------------------------------------------------------

  ALTER TABLE "TBL_CIRCULAR" ADD PRIMARY KEY ("CIRCULARID")
  USING INDEX;
  ALTER TABLE "TBL_CIRCULAR" MODIFY ("TENANTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CIRCULAR" MODIFY ("CIRCULARID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CIRCULAR_BM
--------------------------------------------------------

  ALTER TABLE "TBL_CIRCULAR_BM" ADD PRIMARY KEY ("CIRCULARBMID")
  USING INDEX;
  ALTER TABLE "TBL_CIRCULAR_BM" MODIFY ("TENANTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CIRCULAR_BM" MODIFY ("CIRCULARBMID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CIRCULAR_BMUSER
--------------------------------------------------------

  ALTER TABLE "TBL_CIRCULAR_BMUSER" ADD PRIMARY KEY ("CIRCULARBMUSERID")
  USING INDEX;
  ALTER TABLE "TBL_CIRCULAR_BMUSER" MODIFY ("TENANTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CIRCULAR_BMUSER" MODIFY ("CIRCULARBMUSERID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CIRCULAR_COMMENT
--------------------------------------------------------

  ALTER TABLE "TBL_CIRCULAR_COMMENT" ADD PRIMARY KEY ("CIRCULARCOMMENTID", "CIRCULARID", "TENANTID")
  USING INDEX;
  ALTER TABLE "TBL_CIRCULAR_COMMENT" MODIFY ("TENANTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CIRCULAR_COMMENT" MODIFY ("CIRCULARCOMMENTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CIRCULAR_COMMENT" MODIFY ("CIRCULARID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CIRCULAR_COMMENTSTATE
--------------------------------------------------------

  ALTER TABLE "TBL_CIRCULAR_COMMENTSTATE" ADD PRIMARY KEY ("CIRCULARCOMMENTSTATEID")
  USING INDEX;
  ALTER TABLE "TBL_CIRCULAR_COMMENTSTATE" MODIFY ("TENANTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CIRCULAR_COMMENTSTATE" MODIFY ("CIRCULARCOMMENTSTATEID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CIRCULAR_FILE
--------------------------------------------------------

  ALTER TABLE "TBL_CIRCULAR_FILE" ADD PRIMARY KEY ("CIRCULARFILEID")
  USING INDEX;
  ALTER TABLE "TBL_CIRCULAR_FILE" MODIFY ("TENANTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CIRCULAR_FILE" MODIFY ("CIRCULARFILEID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CIRCULAR_FOLDER
--------------------------------------------------------

  ALTER TABLE "TBL_CIRCULAR_FOLDER" ADD PRIMARY KEY ("CIRCULARFOLDERID")
  USING INDEX;
  ALTER TABLE "TBL_CIRCULAR_FOLDER" MODIFY ("TENANTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CIRCULAR_FOLDER" MODIFY ("CIRCULARFOLDERID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CIRCULAR_LINK
--------------------------------------------------------

  ALTER TABLE "TBL_CIRCULAR_LINK" ADD PRIMARY KEY ("CIRCULARLINKID")
  USING INDEX;
  ALTER TABLE "TBL_CIRCULAR_LINK" MODIFY ("TENANTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CIRCULAR_LINK" MODIFY ("CIRCULARLINKID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CIRCULAR_LISTOPTION
--------------------------------------------------------

  ALTER TABLE "TBL_CIRCULAR_LISTOPTION" ADD PRIMARY KEY ("TENANTID", "LISTTYPE", "SN")
  USING INDEX;
  ALTER TABLE "TBL_CIRCULAR_LISTOPTION" MODIFY ("TENANTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CIRCULAR_LISTOPTION" MODIFY ("WIDTH" NOT NULL ENABLE);
  ALTER TABLE "TBL_CIRCULAR_LISTOPTION" MODIFY ("COLNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_CIRCULAR_LISTOPTION" MODIFY ("SN" NOT NULL ENABLE);
  ALTER TABLE "TBL_CIRCULAR_LISTOPTION" MODIFY ("LISTTYPE" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CIRCULAR_OPTION
--------------------------------------------------------

  ALTER TABLE "TBL_CIRCULAR_OPTION" ADD PRIMARY KEY ("CIRCULAROPTIONID")
  USING INDEX;
  ALTER TABLE "TBL_CIRCULAR_OPTION" MODIFY ("TENANTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CIRCULAR_OPTION" MODIFY ("CIRCULAROPTIONID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CIRCULAR_USER
--------------------------------------------------------

  ALTER TABLE "TBL_CIRCULAR_USER" ADD PRIMARY KEY ("CIRCULARUSERID")
  USING INDEX;
  ALTER TABLE "TBL_CIRCULAR_USER" MODIFY ("TENANTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CIRCULAR_USER" MODIFY ("CIRCULARUSERID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CLUBID
--------------------------------------------------------

  ALTER TABLE "TBL_CLUBID" ADD CONSTRAINT "PK_TBL_CLUBID" PRIMARY KEY ("TENANT_ID", "CLUBID")
  USING INDEX;
  ALTER TABLE "TBL_CLUBID" MODIFY ("CLUBID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CLUBID" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CODELIST
--------------------------------------------------------

  ALTER TABLE "TBL_CODELIST" ADD CONSTRAINT "TBL_CODELIST_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "CODE1", "CODE2")
  USING INDEX;
  ALTER TABLE "TBL_CODELIST" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CODELIST" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CODELIST" MODIFY ("CODE2" NOT NULL ENABLE);
  ALTER TABLE "TBL_CODELIST" MODIFY ("CODE1" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_COMM_BOARDINFO
--------------------------------------------------------

  ALTER TABLE "TBL_COMM_BOARDINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_BOARDINFO" MODIFY ("PARENTBOARDID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_BOARDINFO" MODIFY ("BOARDNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_BOARDINFO" MODIFY ("BOARDID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_BOARDINFO" MODIFY ("C_CLUBNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_BOARDINFO" ADD CONSTRAINT "PK_TBL_COMM_BOARDINFO" PRIMARY KEY ("TENANT_ID", "C_CLUBNO", "BOARDID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_COMM_BOARDMANAGE
--------------------------------------------------------

  ALTER TABLE "TBL_COMM_BOARDMANAGE" MODIFY ("ACCESSID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_BOARDMANAGE" MODIFY ("BOARDID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_BOARDMANAGE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_BOARDMANAGE" ADD CONSTRAINT "PK_TBL_COMM_BOARDMANAGE" PRIMARY KEY ("TENANT_ID", "BOARDID", "ACCESSID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_COMM_DELETERESERVEDBOARD
--------------------------------------------------------

  ALTER TABLE "TBL_COMM_DELETERESERVEDBOARD" ADD CONSTRAINT "PK_TBL_COMM_DELETERESERVEDBOA" PRIMARY KEY ("TENANT_ID", "BOARDID")
  USING INDEX;
  ALTER TABLE "TBL_COMM_DELETERESERVEDBOARD" MODIFY ("BOARDID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_DELETERESERVEDBOARD" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_COMM_DELETERESERVEDITEM
--------------------------------------------------------

  ALTER TABLE "TBL_COMM_DELETERESERVEDITEM" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_DELETERESERVEDITEM" MODIFY ("ITEMID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_DELETERESERVEDITEM" MODIFY ("BOARDID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_DELETERESERVEDITEM" ADD CONSTRAINT "PK_TBL_COMM_DELETERESERVED" PRIMARY KEY ("TENANT_ID", "BOARDID", "ITEMID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_COMM_ITEM
--------------------------------------------------------

  ALTER TABLE "TBL_COMM_ITEM" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_ITEM" MODIFY ("BOARDID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_ITEM" MODIFY ("ITEMID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_ITEM" ADD CONSTRAINT "PK_TBL_COMM_ITEM" PRIMARY KEY ("TENANT_ID", "ITEMID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_COMM_ITEM_ATTACHMENTS
--------------------------------------------------------

  ALTER TABLE "TBL_COMM_ITEM_ATTACHMENTS" MODIFY ("GUID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_ITEM_ATTACHMENTS" ADD CONSTRAINT "PK_TBL_COMM_ITEM_ATTACHMENTS" PRIMARY KEY ("TENANT_ID", "ITEMID", "GUID")
  USING INDEX;
  ALTER TABLE "TBL_COMM_ITEM_ATTACHMENTS" MODIFY ("FILEPATH" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_ITEM_ATTACHMENTS" MODIFY ("ITEMID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_ITEM_ATTACHMENTS" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_COMM_ITEM_READ
--------------------------------------------------------

  ALTER TABLE "TBL_COMM_ITEM_READ" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_ITEM_READ" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_ITEM_READ" MODIFY ("ITEMID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_ITEM_READ" MODIFY ("BOARDID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_ITEM_READ" ADD CONSTRAINT "PK_TBL_COMM_ITEM_READ" PRIMARY KEY ("TENANT_ID", "BOARDID", "ITEMID", "USERID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_COMM_MYBOARDS
--------------------------------------------------------

  ALTER TABLE "TBL_COMM_MYBOARDS" MODIFY ("BOARDID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_MYBOARDS" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_MYBOARDS" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_MYBOARDS" ADD CONSTRAINT "PK_TBL_COMM_MYBOARDS" PRIMARY KEY ("TENANT_ID", "USERID", "BOARDID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_COMM_ONELINEREPLY
--------------------------------------------------------

  ALTER TABLE "TBL_COMM_ONELINEREPLY" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_ONELINEREPLY" MODIFY ("BOARDID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_ONELINEREPLY" MODIFY ("REPLYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_ONELINEREPLY" MODIFY ("ITEMID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_ONELINEREPLY" ADD CONSTRAINT "PK_TBL_COMM_ONELINEREPLY" PRIMARY KEY ("TENANT_ID", "ITEMID", "REPLYID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_COMM_SCHEDULE
--------------------------------------------------------

  ALTER TABLE "TBL_COMM_SCHEDULE" MODIFY ("CONTENTPATH" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULE" MODIFY ("LOCATION" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULE" MODIFY ("TITLE" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULE" MODIFY ("REPETITIONDELETE" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULE" MODIFY ("REPETITION" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULE" MODIFY ("ENDDATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULE" MODIFY ("STARTDATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULE" MODIFY ("DATETYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULE" MODIFY ("ISPUBLIC" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULE" MODIFY ("ISREADONLY" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULE" MODIFY ("HASCOMMENT" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULE" MODIFY ("HASATTACH" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULE" MODIFY ("HASATTENDANT" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULE" MODIFY ("IMPORTANCE" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULE" MODIFY ("SCHEDULETYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULE" MODIFY ("MODIFYDATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULE" MODIFY ("MODIFIERNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULE" MODIFY ("MODIFIERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULE" MODIFY ("CREATEDATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULE" MODIFY ("CREATORNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULE" MODIFY ("CREATORID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULE" MODIFY ("OWNERNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULE" MODIFY ("OWNERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULE" MODIFY ("PARENTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULE" MODIFY ("SCHEDULEID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULE" ADD CONSTRAINT "PK_TBL_COMM_SCHEDULE" PRIMARY KEY ("TENANT_ID", "SCHEDULEID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_COMM_SCHEDULEATTACH
--------------------------------------------------------

  ALTER TABLE "TBL_COMM_SCHEDULEATTACH" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULEATTACH" MODIFY ("FILEPATH" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULEATTACH" MODIFY ("FILENAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULEATTACH" MODIFY ("FILESIZE" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULEATTACH" MODIFY ("SCHEDULEID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULEATTACH" MODIFY ("ATTACHID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULEATTACH" ADD CONSTRAINT "PK_TBL_COMM_SCHEDULEATTACH" PRIMARY KEY ("TENANT_ID", "ATTACHID", "SCHEDULEID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_COMM_SCHEDULECOMMENT
--------------------------------------------------------

  ALTER TABLE "TBL_COMM_SCHEDULECOMMENT" MODIFY ("COMMENT_" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULECOMMENT" MODIFY ("COMMENTDATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULECOMMENT" MODIFY ("COMMENTORNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULECOMMENT" MODIFY ("COMMENTORID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULECOMMENT" MODIFY ("SCHEDULEID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULECOMMENT" MODIFY ("COMMENTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULECOMMENT" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULECOMMENT" ADD CONSTRAINT "PK_TBL_COMM_SCHEDULECOMMENT" PRIMARY KEY ("TENANT_ID", "COMMENTID", "SCHEDULEID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_COMM_SCHEDULECONFIG
--------------------------------------------------------

  ALTER TABLE "TBL_COMM_SCHEDULECONFIG" MODIFY ("STARTDAY" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULECONFIG" MODIFY ("DEFAULTVIEW" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULECONFIG" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULECONFIG" ADD CONSTRAINT "PK_TBL_COMM_SCHEDULECONFIG" PRIMARY KEY ("TENANT_ID", "USERID")
  USING INDEX;
  ALTER TABLE "TBL_COMM_SCHEDULECONFIG" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULECONFIG" MODIFY ("AUTODELETE" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULECONFIG" MODIFY ("ENDTIME" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULECONFIG" MODIFY ("STARTTIME" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_COMM_SCHEDULEGROUP
--------------------------------------------------------

  ALTER TABLE "TBL_COMM_SCHEDULEGROUP" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULEGROUP" MODIFY ("DESCRIPTION" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULEGROUP" MODIFY ("CREATORNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULEGROUP" MODIFY ("GROUPNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULEGROUP" MODIFY ("GROUPID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULEGROUP" ADD CONSTRAINT "PK_TBL_COMM_SCHEDULEGROUP" PRIMARY KEY ("TENANT_ID", "GROUPID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_COMM_SCHEDULEGROUPMEMBER
--------------------------------------------------------

  ALTER TABLE "TBL_COMM_SCHEDULEGROUPMEMBER" MODIFY ("RESPONSEDATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULEGROUPMEMBER" MODIFY ("STATUS" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULEGROUPMEMBER" MODIFY ("MEMBERNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULEGROUPMEMBER" MODIFY ("MEMBERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULEGROUPMEMBER" MODIFY ("GROUPID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULEGROUPMEMBER" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULEGROUPMEMBER" ADD CONSTRAINT "PK_TBL_COMM_SCHEDULEGROUPMEM" PRIMARY KEY ("TENANT_ID", "GROUPID", "MEMBERID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_COMM_SCHEDULESHARE
--------------------------------------------------------

  ALTER TABLE "TBL_COMM_SCHEDULESHARE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULESHARE" MODIFY ("SHAREPERMISSION" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULESHARE" MODIFY ("SHARETYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULESHARE" MODIFY ("SHARERNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULESHARE" MODIFY ("SHARERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULESHARE" MODIFY ("OWNERNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULESHARE" MODIFY ("OWNERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SCHEDULESHARE" ADD CONSTRAINT "PK_TBL_COMM_SCHEDULESHARE" PRIMARY KEY ("TENANT_ID", "OWNERID", "SHARERID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_COMM_SECRETARY
--------------------------------------------------------

  ALTER TABLE "TBL_COMM_SECRETARY" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SECRETARY" MODIFY ("SECRETARYNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SECRETARY" MODIFY ("SECRETARYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SECRETARY" MODIFY ("USERNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SECRETARY" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_SECRETARY" ADD CONSTRAINT "PK_TBL_COMM_SECRETARY" PRIMARY KEY ("TENANT_ID", "USERID", "SECRETARYID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_COMM_TREECACHE
--------------------------------------------------------

  ALTER TABLE "TBL_COMM_TREECACHE" MODIFY ("QUERY" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_TREECACHE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMM_TREECACHE" ADD CONSTRAINT "PK_TBL_COMM_TREECACHE" PRIMARY KEY ("TENANT_ID", "QUERY")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_COMPANY_CONFIG
--------------------------------------------------------

  ALTER TABLE "TBL_COMPANY_CONFIG" ADD CONSTRAINT "PK2_TBL_COMPANY_CONFIG" PRIMARY KEY ("TENANT_ID", "COMPANY_ID", "PROPERTY_NAME")
  USING INDEX;
  ALTER TABLE "TBL_COMPANY_CONFIG" MODIFY ("PROPERTY_VALUE" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMPANY_CONFIG" MODIFY ("PROPERTY_NAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_COMPANY_CONFIG" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CONNDATA
--------------------------------------------------------

  ALTER TABLE "TBL_CONNDATA" ADD CONSTRAINT "TBL_CONNDATA_PK" PRIMARY KEY ("KEYID", "FORMID")
  USING INDEX;
  ALTER TABLE "TBL_CONNDATA" MODIFY ("UPDATEDATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_CONNDATA" MODIFY ("STATUS" NOT NULL ENABLE);
  ALTER TABLE "TBL_CONNDATA" MODIFY ("BODYHTML" NOT NULL ENABLE);
  ALTER TABLE "TBL_CONNDATA" MODIFY ("FORMID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CONNDATA" MODIFY ("KEYID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CONNECTION_INFO
--------------------------------------------------------

  ALTER TABLE "TBL_CONNECTION_INFO" ADD CONSTRAINT "PK_TBL_CONNECTION_INFO" PRIMARY KEY ("SEQUENCE")
  USING INDEX;
  ALTER TABLE "TBL_CONNECTION_INFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CONNECTION_INFO" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CONNECTION_INFO" MODIFY ("SEQUENCE" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_ADMIN_ACCESS_INFO
--------------------------------------------------------

  ALTER TABLE "TBL_ADMIN_ACCESS_INFO" ADD CONSTRAINT "PK_TBL_ADMIN_ACCESS_INFO" PRIMARY KEY ("SEQUENCE")
  USING INDEX;
  ALTER TABLE "TBL_ADMIN_ACCESS_INFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ADMIN_ACCESS_INFO" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ADMIN_ACCESS_INFO" MODIFY ("SEQUENCE" NOT NULL ENABLE);  
--------------------------------------------------------
--  Constraints for Table TBL_PERMISSION_CHANGE_INFO
--------------------------------------------------------

  ALTER TABLE "TBL_PERMISSION_CHANGE_INFO" ADD CONSTRAINT "PK_TBL_PERMISSION_CHANGE_INFO" PRIMARY KEY ("SEQUENCE")
  USING INDEX;
  ALTER TABLE "TBL_PERMISSION_CHANGE_INFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PERMISSION_CHANGE_INFO" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PERMISSION_CHANGE_INFO" MODIFY ("AUTHORIZERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PERMISSION_CHANGE_INFO" MODIFY ("SEQUENCE" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_USER_CHANGE_INFO
--------------------------------------------------------

  ALTER TABLE "TBL_USER_CHANGE_INFO" ADD CONSTRAINT "PK_TBL_USER_CHANGE_INFO" PRIMARY KEY ("SEQ")
  USING INDEX;
  ALTER TABLE "TBL_USER_CHANGE_INFO" MODIFY ("TENANTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_USER_CHANGE_INFO" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_USER_CHANGE_INFO" MODIFY ("SEQ" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_DEPT_CHANGE_INFO
--------------------------------------------------------

  ALTER TABLE "TBL_DEPT_CHANGE_INFO" ADD CONSTRAINT "PK_TBL_DEPT_CHANGE_INFO" PRIMARY KEY ("SEQ")
  USING INDEX;
  ALTER TABLE "TBL_DEPT_CHANGE_INFO" MODIFY ("TENANTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_DEPT_CHANGE_INFO" MODIFY ("DEPTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_DEPT_CHANGE_INFO" MODIFY ("SEQ" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CONTAINER
--------------------------------------------------------

  ALTER TABLE "TBL_CONTAINER" ADD CONSTRAINT "TBL_CONTAINER_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "CONTAINERID", "CONTAINEROWNDEPID")
  USING INDEX;
  ALTER TABLE "TBL_CONTAINER" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CONTAINER" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CONTAINER" MODIFY ("CONTAINEROWNDEPID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CONTAINER" MODIFY ("CONTAINERID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CONTAINERTODOCSTATE
--------------------------------------------------------

  ALTER TABLE "TBL_CONTAINERTODOCSTATE" ADD CONSTRAINT "TBL_CONTAINERTODOCSTATE_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "DOCUMENTSTATE")
  USING INDEX;
  ALTER TABLE "TBL_CONTAINERTODOCSTATE" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CONTAINERTODOCSTATE" MODIFY ("DOCUMENTSTATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_CONTAINERTODOCSTATE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CONTAINERTYPE
--------------------------------------------------------

  ALTER TABLE "TBL_CONTAINERTYPE" ADD CONSTRAINT "TBL_CONTAINERTYPE_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "CONTAINERTYPEID")
  USING INDEX;
  ALTER TABLE "TBL_CONTAINERTYPE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CONTAINERTYPE" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CONTAINERTYPE" MODIFY ("CONTAINERTYPEID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CONTAINERUSEDEP
--------------------------------------------------------

  ALTER TABLE "TBL_CONTAINERUSEDEP" ADD CONSTRAINT "TBL_CONTAINERUSEDEP_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "CONTAINERID", "USEDEPID")
  USING INDEX;
  ALTER TABLE "TBL_CONTAINERUSEDEP" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CONTAINERUSEDEP" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CONTAINERUSEDEP" MODIFY ("USEDEPID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CONTAINERUSEDEP" MODIFY ("CONTAINERID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_C_BOARD
--------------------------------------------------------

  ALTER TABLE "TBL_C_BOARD" MODIFY ("REF" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_BOARD" MODIFY ("WRITEDAY" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_BOARD" MODIFY ("TITLE" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_BOARD" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_BOARD" MODIFY ("NO" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_BOARD" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_BOARD" ADD CONSTRAINT "PK_TBL_C_BOARD" PRIMARY KEY ("TENANT_ID", "NO")
  USING INDEX;
  ALTER TABLE "TBL_C_BOARD" MODIFY ("READNUM" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_BOARD" MODIFY ("RE_LEVEL" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_BOARD" MODIFY ("STEP" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_C_CATEGORY
--------------------------------------------------------

  ALTER TABLE "TBL_C_CATEGORY" ADD CONSTRAINT "PK_TBL_C_CATEGORY" PRIMARY KEY ("TENANT_ID", "C_CODE", "C_CAT")
  USING INDEX;
  ALTER TABLE "TBL_C_CATEGORY" MODIFY ("C_CAT" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CATEGORY" MODIFY ("C_CODE" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CATEGORY" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_C_CLUB
--------------------------------------------------------

  ALTER TABLE "TBL_C_CLUB" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUB" MODIFY ("ASSIGNDISKSIZE" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUB" MODIFY ("C_CLUBPDS1_ORDERBY" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUB" MODIFY ("C_CLUBPDS1_EXIST" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUB" MODIFY ("C_CLUBBOARD2_ORDERBY" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUB" MODIFY ("C_CLUBBOARD2_EXIST" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUB" MODIFY ("C_CLUBBOARD1_ORDERBY" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUB" MODIFY ("C_CLUBBOARD1_EXIST" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUB" MODIFY ("C_CLUBPDS_EXIST" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUB" MODIFY ("C_CLUBPDS_ORDERBY" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUB" MODIFY ("C_CLUBBOARD_EXIST" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUB" MODIFY ("C_CLUBBOARD_ORDERBY" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUB" MODIFY ("C_CLUBNOTICE_EXIST" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUB" MODIFY ("C_CLUBNOTICE_ORDERBY" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUB" MODIFY ("C_CLUBBANNER" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUB" MODIFY ("C_MEMBERCNT" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUB" MODIFY ("C_CATE_A" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUB" MODIFY ("C_CLUBNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUB" MODIFY ("C_CLUBNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUB" ADD CONSTRAINT "PK_TBL_C_CLUB" PRIMARY KEY ("TENANT_ID", "C_CLUBNO")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_C_CLUBGUEST
--------------------------------------------------------

  ALTER TABLE "TBL_C_CLUBGUEST" ADD CONSTRAINT "PK_TBL_C_CLUBGUEST" PRIMARY KEY ("TENANT_ID", "NO")
  USING INDEX;
  ALTER TABLE "TBL_C_CLUBGUEST" MODIFY ("NO" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUBGUEST" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUBGUEST" MODIFY ("C_NO" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUBGUEST" MODIFY ("C_CLUBNO" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_C_CLUBNOTICE
--------------------------------------------------------

  ALTER TABLE "TBL_C_CLUBNOTICE" ADD CONSTRAINT "PK_TBL_C_CLUBNOTICE" PRIMARY KEY ("TENANT_ID", "NO")
  USING INDEX;
  ALTER TABLE "TBL_C_CLUBNOTICE" MODIFY ("NO" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUBNOTICE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_C_CLUBUSER
--------------------------------------------------------

  ALTER TABLE "TBL_C_CLUBUSER" MODIFY ("C_VISITED" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUBUSER" MODIFY ("C_SEX" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUBUSER" MODIFY ("C_BIRTH" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUBUSER" MODIFY ("C_JOB" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUBUSER" MODIFY ("C_HOUSE" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUBUSER" MODIFY ("C_COMPANY" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUBUSER" MODIFY ("C_HPHONE" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUBUSER" MODIFY ("C_EMAIL" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUBUSER" MODIFY ("C_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUBUSER" MODIFY ("C_CLUBNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUBUSER" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_CLUBUSER" ADD CONSTRAINT "PK_TBL_C_CLUBUSER" PRIMARY KEY ("TENANT_ID", "C_CLUBNO", "C_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_C_COMCLOSE
--------------------------------------------------------

  ALTER TABLE "TBL_C_COMCLOSE" ADD CONSTRAINT "PK_TBL_C_COMCLOSE" PRIMARY KEY ("TENANT_ID", "C_CLUBNO")
  USING INDEX;
  ALTER TABLE "TBL_C_COMCLOSE" MODIFY ("C_CLUBNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_COMCLOSE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_C_MEMBERINFO
--------------------------------------------------------

  ALTER TABLE "TBL_C_MEMBERINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_MEMBERINFO" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_MEMBERINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_MEMBERINFO" ADD CONSTRAINT "PK_TBL_C_MEMBERINFO" PRIMARY KEY ("TENANT_ID", "COMPANYID", "USERID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_C_NOTICE
--------------------------------------------------------

  ALTER TABLE "TBL_C_NOTICE" ADD CONSTRAINT "PK_TBL_C_NOTICE" PRIMARY KEY ("TENANT_ID", "NO")
  USING INDEX;
  ALTER TABLE "TBL_C_NOTICE" MODIFY ("WRITEDAY" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_NOTICE" MODIFY ("READNUM" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_NOTICE" MODIFY ("CONTENT" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_NOTICE" MODIFY ("TITLE" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_NOTICE" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_NOTICE" MODIFY ("NO" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_NOTICE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_C_OUTAPPLICATION
--------------------------------------------------------

  ALTER TABLE "TBL_C_OUTAPPLICATION" ADD CONSTRAINT "PK_TBL_C_OUTAPPLICATION" PRIMARY KEY ("TENANT_ID", "C_CLUBNO", "USERID")
  USING INDEX;
  ALTER TABLE "TBL_C_OUTAPPLICATION" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_OUTAPPLICATION" MODIFY ("C_CLUBNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_OUTAPPLICATION" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_C_POLLANSWER
--------------------------------------------------------

  ALTER TABLE "TBL_C_POLLANSWER" MODIFY ("ANSWERCONTENT" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_POLLANSWER" MODIFY ("ANSWERNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_POLLANSWER" MODIFY ("POLLQUESTIONID" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_POLLANSWER" MODIFY ("ANSWERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_POLLANSWER" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_POLLANSWER" ADD CONSTRAINT "PK_TBL_C_POLLANSWER" PRIMARY KEY ("TENANT_ID", "ANSWERID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_C_POLLMANAGER
--------------------------------------------------------

  ALTER TABLE "TBL_C_POLLMANAGER" MODIFY ("QUESTIONCOUNT" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_POLLMANAGER" MODIFY ("POLLGROUPNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_POLLMANAGER" MODIFY ("C_CLUBNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_POLLMANAGER" MODIFY ("MANAGERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_POLLMANAGER" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_POLLMANAGER" ADD CONSTRAINT "PK_TBL_C_POLLMANAGER" PRIMARY KEY ("TENANT_ID", "MANAGERID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_C_POLLQUESTION
--------------------------------------------------------

  ALTER TABLE "TBL_C_POLLQUESTION" ADD CONSTRAINT "PK_TBL_C_POLLQUESTION" PRIMARY KEY ("TENANT_ID", "QUESTIONID")
  USING INDEX;
  ALTER TABLE "TBL_C_POLLQUESTION" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_POLLQUESTION" MODIFY ("ANSWERTYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_POLLQUESTION" MODIFY ("ANSWERCOUNT" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_POLLQUESTION" MODIFY ("QUESTIONCONTENT" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_POLLQUESTION" MODIFY ("QUESTIONNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_POLLQUESTION" MODIFY ("POLLMANAGERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_POLLQUESTION" MODIFY ("QUESTIONID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_C_POLLRESPONSE
--------------------------------------------------------

  ALTER TABLE "TBL_C_POLLRESPONSE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_POLLRESPONSE" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_POLLRESPONSE" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_POLLRESPONSE" MODIFY ("ANSWERNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_POLLRESPONSE" MODIFY ("ANSWERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_POLLRESPONSE" MODIFY ("QUESTIONID" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_POLLRESPONSE" MODIFY ("RESPONSEID" NOT NULL ENABLE);
  ALTER TABLE "TBL_C_POLLRESPONSE" ADD CONSTRAINT "PK_TBL_C_POLLRESPONSE" PRIMARY KEY ("TENANT_ID", "RESPONSEID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_DAILYDOCCOUNTLOG
--------------------------------------------------------

  ALTER TABLE "TBL_DAILYDOCCOUNTLOG" MODIFY ("RETURNCNT" NOT NULL ENABLE);
  ALTER TABLE "TBL_DAILYDOCCOUNTLOG" MODIFY ("SUSINTIME" NOT NULL ENABLE);
  ALTER TABLE "TBL_DAILYDOCCOUNTLOG" MODIFY ("SUSINENDCNT" NOT NULL ENABLE);
  ALTER TABLE "TBL_DAILYDOCCOUNTLOG" MODIFY ("SUSININGCNT" NOT NULL ENABLE);
  ALTER TABLE "TBL_DAILYDOCCOUNTLOG" MODIFY ("DRAFTTIME" NOT NULL ENABLE);
  ALTER TABLE "TBL_DAILYDOCCOUNTLOG" MODIFY ("DRAFTENDCNT" NOT NULL ENABLE);
  ALTER TABLE "TBL_DAILYDOCCOUNTLOG" MODIFY ("DRAFTINGCNT" NOT NULL ENABLE);
  ALTER TABLE "TBL_DAILYDOCCOUNTLOG" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_DAILYDOCCOUNTLOG" MODIFY ("DEPTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_DAILYDOCCOUNTLOG" MODIFY ("REGDATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_DAILYDOCCOUNTLOG" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_DAILYDOCCOUNTLOG" ADD CONSTRAINT "PK_TBL_DAILYDOCCOUNTLOG" PRIMARY KEY ("TENANT_ID", "REGDATE", "DEPTID", "USERID", "COMPANYID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_DAILYFORMCOUNTLOG
--------------------------------------------------------

  ALTER TABLE "TBL_DAILYFORMCOUNTLOG" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_DAILYFORMCOUNTLOG" ADD CONSTRAINT "PK_TBL_DAILYFORMCOUNTLOG" PRIMARY KEY ("TENANT_ID", "REGDATE", "FORMID", "FORMCONTID", "COMPANYID")
  USING INDEX;
  ALTER TABLE "TBL_DAILYFORMCOUNTLOG" MODIFY ("RETURNCNT" NOT NULL ENABLE);
  ALTER TABLE "TBL_DAILYFORMCOUNTLOG" MODIFY ("SUSINTIME" NOT NULL ENABLE);
  ALTER TABLE "TBL_DAILYFORMCOUNTLOG" MODIFY ("SUSINENDCNT" NOT NULL ENABLE);
  ALTER TABLE "TBL_DAILYFORMCOUNTLOG" MODIFY ("SUSININGCNT" NOT NULL ENABLE);
  ALTER TABLE "TBL_DAILYFORMCOUNTLOG" MODIFY ("DRAFTTIME" NOT NULL ENABLE);
  ALTER TABLE "TBL_DAILYFORMCOUNTLOG" MODIFY ("DRAFTENDCNT" NOT NULL ENABLE);
  ALTER TABLE "TBL_DAILYFORMCOUNTLOG" MODIFY ("DRAFTINGCNT" NOT NULL ENABLE);
  ALTER TABLE "TBL_DAILYFORMCOUNTLOG" MODIFY ("FORMCONTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_DAILYFORMCOUNTLOG" MODIFY ("FORMID" NOT NULL ENABLE);
  ALTER TABLE "TBL_DAILYFORMCOUNTLOG" MODIFY ("REGDATE" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_DELETECABINETINFO
--------------------------------------------------------

  ALTER TABLE "TBL_DELETECABINETINFO" ADD CONSTRAINT "TBL_DELETECABINETINFO_PK" PRIMARY KEY ("COMPANYID", "TENANTID", "CABINETID")
  USING INDEX;
  ALTER TABLE "TBL_DELETECABINETINFO" MODIFY ("TENANTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_DELETECABINETINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_DELETECABINETINFO" MODIFY ("CABINETID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_DEPTCONT
--------------------------------------------------------

  ALTER TABLE "TBL_DEPTCONT" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_DEPTCONT" ADD CONSTRAINT "TBL_DEPTCONT_PK" PRIMARY KEY ("TENANT_ID", "DEPTCONTID")
  USING INDEX;
  ALTER TABLE "TBL_DEPTCONT" MODIFY ("DEPTCONTID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_DEPTCONTLIST
--------------------------------------------------------

  ALTER TABLE "TBL_DEPTCONTLIST" MODIFY ("DEPTCONTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_DEPTCONTLIST" MODIFY ("DOCID" NOT NULL ENABLE);
  ALTER TABLE "TBL_DEPTCONTLIST" ADD CONSTRAINT "PK_TBL_DEPTCONTLIST" PRIMARY KEY ("TENANT_ID", "DOCID", "DEPTCONTID")
  USING INDEX;
  ALTER TABLE "TBL_DEPTCONTLIST" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_DEPTMASTER
--------------------------------------------------------

  ALTER TABLE "TBL_DEPTMASTER" ADD CONSTRAINT "PK_TBL_DEPTMASTER" PRIMARY KEY ("TENANT_ID", "CN")
  USING INDEX;
  ALTER TABLE "TBL_DEPTMASTER" MODIFY ("DISPLAYNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_DEPTMASTER" MODIFY ("CN" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_DEPTTEMPLET
--------------------------------------------------------

  ALTER TABLE "TBL_DEPTTEMPLET" ADD CONSTRAINT "PK_TBL_DEPTTEMPLET" PRIMARY KEY ("TENANT_ID", "USERID", "FORMID", "APRDEPTSN", "COMPANYID")
  USING INDEX;
  ALTER TABLE "TBL_DEPTTEMPLET" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_DEPTTEMPLET" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_DEPTTEMPLET" MODIFY ("APRDEPTSN" NOT NULL ENABLE);
  ALTER TABLE "TBL_DEPTTEMPLET" MODIFY ("FORMID" NOT NULL ENABLE);
  ALTER TABLE "TBL_DEPTTEMPLET" MODIFY ("USERID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_DEPTTEMPLETDETAIL
--------------------------------------------------------

  ALTER TABLE "TBL_DEPTTEMPLETDETAIL" ADD CONSTRAINT "PK_TBL_DEPTTEMPLETDETAIL" PRIMARY KEY ("TENANT_ID", "USERID", "FORMID", "APRDEPTSN", "APRDEPTMEMBERSN", "COMPANYID")
  USING INDEX;
  ALTER TABLE "TBL_DEPTTEMPLETDETAIL" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_DEPTTEMPLETDETAIL" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_DEPTTEMPLETDETAIL" MODIFY ("APRDEPTMEMBERSN" NOT NULL ENABLE);
  ALTER TABLE "TBL_DEPTTEMPLETDETAIL" MODIFY ("APRDEPTSN" NOT NULL ENABLE);
  ALTER TABLE "TBL_DEPTTEMPLETDETAIL" MODIFY ("FORMID" NOT NULL ENABLE);
  ALTER TABLE "TBL_DEPTTEMPLETDETAIL" MODIFY ("USERID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_DEV_MASTER
--------------------------------------------------------

  ALTER TABLE "TBL_DEV_MASTER" ADD CONSTRAINT "TBL_DEV_MASTER_PK" PRIMARY KEY ("DEVSEQ")
  USING INDEX;
  ALTER TABLE "TBL_DEV_MASTER" MODIFY ("TENANTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_DEV_MASTER" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_DEV_MASTER" MODIFY ("DEVID" NOT NULL ENABLE);
  ALTER TABLE "TBL_DEV_MASTER" MODIFY ("DEVSEQ" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_DOCDELETEHISTORY
--------------------------------------------------------

  ALTER TABLE "TBL_DOCDELETEHISTORY" ADD CONSTRAINT "PK_TBL_DOCDELETEHISTORY" PRIMARY KEY ("TENANT_ID", "DOCID", "COMPANYID")
  USING INDEX;
  ALTER TABLE "TBL_DOCDELETEHISTORY" MODIFY ("COMPANYID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_DOCDELIVERY
--------------------------------------------------------

  ALTER TABLE "TBL_DOCDELIVERY" ADD CONSTRAINT "PK_TBL_DOCDELIVERY" PRIMARY KEY ("TENANT_ID", "COMPANYID", "SN", "DOCID", "DEPTID")
  USING INDEX;
  ALTER TABLE "TBL_DOCDELIVERY" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_DOCDELIVERY" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_DOCDELIVERY" MODIFY ("DEPTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_DOCDELIVERY" MODIFY ("DOCID" NOT NULL ENABLE);
  ALTER TABLE "TBL_DOCDELIVERY" MODIFY ("SN" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_ENDAPRDOCATTACHINFO
--------------------------------------------------------

  ALTER TABLE "TBL_ENDAPRDOCATTACHINFO" ADD CONSTRAINT "TBL_ENDAPRDOCATTACHINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "DOCID", "ATTACHSN")
  USING INDEX;
  ALTER TABLE "TBL_ENDAPRDOCATTACHINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ENDAPRDOCATTACHINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ENDAPRDOCATTACHINFO" MODIFY ("ATTACHSN" NOT NULL ENABLE);
  ALTER TABLE "TBL_ENDAPRDOCATTACHINFO" MODIFY ("DOCID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_ENDAPRDOCINFO
--------------------------------------------------------

  ALTER TABLE "TBL_ENDAPRDOCINFO" ADD CONSTRAINT "TBL_ENDAPRDOCINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "DOCID")
  USING INDEX;
  ALTER TABLE "TBL_ENDAPRDOCINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ENDAPRDOCINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ENDAPRDOCINFO" MODIFY ("DOCID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_ENDAPRLINEINFO
--------------------------------------------------------

  ALTER TABLE "TBL_ENDAPRLINEINFO" ADD CONSTRAINT "TBL_ENDAPRLINEINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "DOCID", "APRMEMBERSN")
  USING INDEX;
  ALTER TABLE "TBL_ENDAPRLINEINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ENDAPRLINEINFO" MODIFY ("APRMEMBERSN" NOT NULL ENABLE);
  ALTER TABLE "TBL_ENDAPRLINEINFO" MODIFY ("DOCID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ENDAPRLINEINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_ENDAPROPINIONINFO
--------------------------------------------------------

  ALTER TABLE "TBL_ENDAPROPINIONINFO" ADD CONSTRAINT "TBL_ENDAPROPINIONINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "DOCID", "USERID", "OPINIONSN")
  USING INDEX;
  ALTER TABLE "TBL_ENDAPROPINIONINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ENDAPROPINIONINFO" MODIFY ("OPINIONSN" NOT NULL ENABLE);
  ALTER TABLE "TBL_ENDAPROPINIONINFO" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ENDAPROPINIONINFO" MODIFY ("DOCID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ENDAPROPINIONINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_ENDATTACHINFO
--------------------------------------------------------

  ALTER TABLE "TBL_ENDATTACHINFO" ADD CONSTRAINT "TBL_ENDATTACHINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "DOCID", "ATTACHFILESN")
  USING INDEX;
  ALTER TABLE "TBL_ENDATTACHINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ENDATTACHINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ENDATTACHINFO" MODIFY ("ATTACHFILESN" NOT NULL ENABLE);
  ALTER TABLE "TBL_ENDATTACHINFO" MODIFY ("DOCID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_ENDRECEIPTPOINTINFO
--------------------------------------------------------

  ALTER TABLE "TBL_ENDRECEIPTPOINTINFO" ADD CONSTRAINT "TBL_ENDRECEIPTPOINTINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "DOCID", "RECEIPTPOINTID", "PROCESSSN")
  USING INDEX;
  ALTER TABLE "TBL_ENDRECEIPTPOINTINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ENDRECEIPTPOINTINFO" MODIFY ("PROCESSSN" NOT NULL ENABLE);
  ALTER TABLE "TBL_ENDRECEIPTPOINTINFO" MODIFY ("RECEIPTPOINTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ENDRECEIPTPOINTINFO" MODIFY ("DOCID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ENDRECEIPTPOINTINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_ENDRECEIPTPROCESSINFO
--------------------------------------------------------

  ALTER TABLE "TBL_ENDRECEIPTPROCESSINFO" ADD CONSTRAINT "TBL_ENDRECEIPTPROCESSINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "RECEIVESN", "DOCID", "RECEIVEDDEPTID")
  USING INDEX;
  ALTER TABLE "TBL_ENDRECEIPTPROCESSINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ENDRECEIPTPROCESSINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ENDRECEIPTPROCESSINFO" MODIFY ("RECEIVEDDEPTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ENDRECEIPTPROCESSINFO" MODIFY ("DOCID" NOT NULL ENABLE);
  ALTER TABLE "TBL_ENDRECEIPTPROCESSINFO" MODIFY ("RECEIVESN" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_EXPAPRDOCINFO
--------------------------------------------------------

  ALTER TABLE "TBL_EXPAPRDOCINFO" ADD CONSTRAINT "TBL_EXPAPRDOCINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "DOCID")
  USING INDEX;
  ALTER TABLE "TBL_EXPAPRDOCINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_EXPAPRDOCINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_EXPAPRDOCINFO" MODIFY ("DOCID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_EXPAPRLINE
--------------------------------------------------------

  ALTER TABLE "TBL_EXPAPRLINE" ADD CONSTRAINT "TBL_EXPAPRLINE_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "DOCID", "APRMEMBERSN", "ORGUSERID")
  USING INDEX;
  ALTER TABLE "TBL_EXPAPRLINE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_EXPAPRLINE" MODIFY ("ORGUSERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_EXPAPRLINE" MODIFY ("APRMEMBERSN" NOT NULL ENABLE);
  ALTER TABLE "TBL_EXPAPRLINE" MODIFY ("DOCID" NOT NULL ENABLE);
  ALTER TABLE "TBL_EXPAPRLINE" MODIFY ("COMPANYID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_EXPENDAPRDOCINFO
--------------------------------------------------------

  ALTER TABLE "TBL_EXPENDAPRDOCINFO" ADD CONSTRAINT "TBL_EXPENDAPRDOCINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "DOCID")
  USING INDEX;
  ALTER TABLE "TBL_EXPENDAPRDOCINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_EXPENDAPRDOCINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_EXPENDAPRDOCINFO" MODIFY ("SIGNCHECK" NOT NULL ENABLE);
  ALTER TABLE "TBL_EXPENDAPRDOCINFO" MODIFY ("DOCID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_EXPENDAPRLINE
--------------------------------------------------------

  ALTER TABLE "TBL_EXPENDAPRLINE" ADD CONSTRAINT "TBL_EXPENDAPRLINE_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "ORGUSERID", "APRMEMBERSN", "DOCID")
  USING INDEX;
  ALTER TABLE "TBL_EXPENDAPRLINE" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_EXPENDAPRLINE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_EXPENDAPRLINE" MODIFY ("ORGUSERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_EXPENDAPRLINE" MODIFY ("APRMEMBERSN" NOT NULL ENABLE);
  ALTER TABLE "TBL_EXPENDAPRLINE" MODIFY ("DOCID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_FORMCONNINFO
--------------------------------------------------------

  ALTER TABLE "TBL_FORMCONNINFO" ADD CONSTRAINT "TBL_FORMCONNINFO_PK" PRIMARY KEY ("SN")
  USING INDEX;
  ALTER TABLE "TBL_FORMCONNINFO" MODIFY ("UPPERNODE" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORMCONNINFO" MODIFY ("CONNINFO" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORMCONNINFO" MODIFY ("CONNNODE" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORMCONNINFO" MODIFY ("SN" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_FORMCONTAINER
--------------------------------------------------------

  ALTER TABLE "TBL_FORMCONTAINER" MODIFY ("FORMCONTPARENTS" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORMCONTAINER" MODIFY ("FORMCONTOWNDEPID" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORMCONTAINER" MODIFY ("FORMCONTNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORMCONTAINER" MODIFY ("FORMCONTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORMCONTAINER" ADD CONSTRAINT "TBL_FORMCONTAINER_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "FORMCONTID", "FORMCONTNAME", "FORMCONTOWNDEPID", "FORMCONTPARENTS")
  USING INDEX;
  ALTER TABLE "TBL_FORMCONTAINER" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORMCONTAINER" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_FORMCONTUSERGROUP
--------------------------------------------------------

  ALTER TABLE "TBL_FORMCONTUSERGROUP" ADD CONSTRAINT "TBL_FORMCONTUSERGROUP_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "FORMCONTID", "FORMCONTUSERDEPID")
  USING INDEX;
  ALTER TABLE "TBL_FORMCONTUSERGROUP" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORMCONTUSERGROUP" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORMCONTUSERGROUP" MODIFY ("FORMCONTUSERDEPID" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORMCONTUSERGROUP" MODIFY ("FORMCONTID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_FORMGROUP
--------------------------------------------------------

  ALTER TABLE "TBL_FORMGROUP" ADD CONSTRAINT "TBL_FORMGROUP_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "SN")
  USING INDEX;
  ALTER TABLE "TBL_FORMGROUP" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORMGROUP" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORMGROUP" MODIFY ("SN" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_FORMINFO
--------------------------------------------------------

  ALTER TABLE "TBL_FORMINFO" ADD CONSTRAINT "TBL_FORMINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "FORMID")
  USING INDEX;
  ALTER TABLE "TBL_FORMINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORMINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORMINFO" MODIFY ("FORMFILELOCATION" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORMINFO" MODIFY ("FORMDOCTYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORMINFO" MODIFY ("FORMID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_FORMPROPERTY
--------------------------------------------------------

  ALTER TABLE "TBL_FORMPROPERTY" ADD CONSTRAINT "TBL_FORMPROPERTY_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "SN")
  USING INDEX;
  ALTER TABLE "TBL_FORMPROPERTY" MODIFY ("SN" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORMPROPERTY" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORMPROPERTY" MODIFY ("CODE" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORMPROPERTY" MODIFY ("COMPANYID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_FORMRECV
--------------------------------------------------------

  ALTER TABLE "TBL_FORMRECV" ADD CONSTRAINT "TBL_FORMRECV_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "FORMID", "DEPTID")
  USING INDEX;
  ALTER TABLE "TBL_FORMRECV" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORMRECV" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORMRECV" MODIFY ("DEPTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORMRECV" MODIFY ("FORMID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_FORMUSERINFO
--------------------------------------------------------

  ALTER TABLE "TBL_FORMUSERINFO" ADD CONSTRAINT "TBL_FORMUSERINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "FORMID", "USERID")
  USING INDEX;
  ALTER TABLE "TBL_FORMUSERINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORMUSERINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORMUSERINFO" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORMUSERINFO" MODIFY ("FORMID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_FORM_AUTORULE
--------------------------------------------------------

  ALTER TABLE "TBL_FORM_AUTORULE" ADD PRIMARY KEY ("TENANT_ID", "COMPANYID", "FORMID", "AUTORULESN", "AUTORULEGUID")
  USING INDEX;
  ALTER TABLE "TBL_FORM_AUTORULE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORM_AUTORULE" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORM_AUTORULE" MODIFY ("AUTORULEGUID" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORM_AUTORULE" MODIFY ("AUTORULESN" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORM_AUTORULE" MODIFY ("FORMID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_FORM_AUTORULELINE
--------------------------------------------------------

  ALTER TABLE "TBL_FORM_AUTORULELINE" ADD PRIMARY KEY ("TENANT_ID", "COMPANYID", "FORMID", "AUTORULEGUID", "APRMEMBERSN")
  USING INDEX;
  ALTER TABLE "TBL_FORM_AUTORULELINE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORM_AUTORULELINE" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORM_AUTORULELINE" MODIFY ("APRMEMBERSN" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORM_AUTORULELINE" MODIFY ("AUTORULEGUID" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORM_AUTORULELINE" MODIFY ("FORMID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_FORM_OFFICE
--------------------------------------------------------

  ALTER TABLE "TBL_FORM_OFFICE" ADD CONSTRAINT "TBL_FORM_OFFICE_PK" PRIMARY KEY ("FORMID", "TENANT_ID", "COMPANYID")
  USING INDEX;
  ALTER TABLE "TBL_FORM_OFFICE" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORM_OFFICE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_FORM_OFFICE" MODIFY ("FORMID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_HISTORYATTACHINFO
--------------------------------------------------------

  ALTER TABLE "TBL_HISTORYATTACHINFO" ADD CONSTRAINT "TBL_HISTORYATTACHINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "DOCID", "ATTACHFILESN", "MODIFYSN")
  USING INDEX;
  ALTER TABLE "TBL_HISTORYATTACHINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_HISTORYATTACHINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_HISTORYATTACHINFO" MODIFY ("MODIFYSN" NOT NULL ENABLE);
  ALTER TABLE "TBL_HISTORYATTACHINFO" MODIFY ("ATTACHFILESN" NOT NULL ENABLE);
  ALTER TABLE "TBL_HISTORYATTACHINFO" MODIFY ("DOCID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_HISTORYDOCINFO
--------------------------------------------------------

  ALTER TABLE "TBL_HISTORYDOCINFO" ADD CONSTRAINT "TBL_HISTORYDOCINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "DOCID", "CHANGESN")
  USING INDEX;
  ALTER TABLE "TBL_HISTORYDOCINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_HISTORYDOCINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_HISTORYDOCINFO" MODIFY ("CHANGESN" NOT NULL ENABLE);
  ALTER TABLE "TBL_HISTORYDOCINFO" MODIFY ("DOCID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_HISTORYLINEINFO
--------------------------------------------------------

  ALTER TABLE "TBL_HISTORYLINEINFO" ADD CONSTRAINT "TBL_HISTORYLINEINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "DOCID", "APRMEMBERSN", "MODIFYSN")
  USING INDEX;
  ALTER TABLE "TBL_HISTORYLINEINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_HISTORYLINEINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_HISTORYLINEINFO" MODIFY ("MODIFYSN" NOT NULL ENABLE);
  ALTER TABLE "TBL_HISTORYLINEINFO" MODIFY ("APRMEMBERSN" NOT NULL ENABLE);
  ALTER TABLE "TBL_HISTORYLINEINFO" MODIFY ("DOCID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_HISTORYRECEIPTINFO
--------------------------------------------------------

  ALTER TABLE "TBL_HISTORYRECEIPTINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_HISTORYRECEIPTINFO" MODIFY ("RECEIPTDEPTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_HISTORYRECEIPTINFO" MODIFY ("DOCID" NOT NULL ENABLE);
  ALTER TABLE "TBL_HISTORYRECEIPTINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_HOLIDAYLIST
--------------------------------------------------------

  ALTER TABLE "TBL_HOLIDAYLIST" MODIFY ("HOLIDAYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_HOLIDAYLIST" ADD CONSTRAINT "PK_TBL_HOLIDAYLIST" PRIMARY KEY ("TENANT_ID", "HOLIDAYID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_JOURNAL
--------------------------------------------------------

  ALTER TABLE "TBL_JOURNAL" ADD CONSTRAINT "PK_TBL_JOURNAL" PRIMARY KEY ("JOURNAL_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_JOURNAL" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_JOURNAL" MODIFY ("JOURNAL_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_JOURNAL_ENV
--------------------------------------------------------

  ALTER TABLE "TBL_JOURNAL_ENV" ADD CONSTRAINT "PK_TBL_JOURNAL_ENV" PRIMARY KEY ("USER_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_JOURNAL_ENV" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_JOURNAL_ENV" MODIFY ("USER_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_JOURNAL_FILE
--------------------------------------------------------

  ALTER TABLE "TBL_JOURNAL_FILE" ADD CONSTRAINT "PK_TBL_JOURNAL_FILE" PRIMARY KEY ("FILE_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_JOURNAL_FILE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_JOURNAL_FILE" MODIFY ("FILE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_JOURNAL_FORM
--------------------------------------------------------

  ALTER TABLE "TBL_JOURNAL_FORM" ADD CONSTRAINT "PK_TBL_JOURNAL_FORM" PRIMARY KEY ("FORM_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_JOURNAL_FORM" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_JOURNAL_FORM" MODIFY ("FORM_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_JOURNAL_FORM" MODIFY ("TYPE_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_JOURNAL_FORM" MODIFY ("FORM_NAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_JOURNAL_FORM" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_JOURNAL_FORM" MODIFY ("FORM_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_JOURNAL_FORM_TYPE
--------------------------------------------------------

  ALTER TABLE "TBL_JOURNAL_FORM_TYPE" ADD CONSTRAINT "PK_TBL_JOURNAL_FORM_TYPE" PRIMARY KEY ("TYPE_ID", "TENANT_ID", "COMPANY_ID") DISABLE;
  ALTER TABLE "TBL_JOURNAL_FORM_TYPE" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_JOURNAL_FORM_TYPE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_JOURNAL_FORM_TYPE" MODIFY ("TYPE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_JOURNAL_ORDER
--------------------------------------------------------

  ALTER TABLE "TBL_JOURNAL_ORDER" ADD PRIMARY KEY ("USER_ID", "RELATED_USER_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_JOURNAL_ORDER" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_JOURNAL_ORDER" MODIFY ("USER_ORDER" NOT NULL ENABLE);
  ALTER TABLE "TBL_JOURNAL_ORDER" MODIFY ("RELATED_USER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_JOURNAL_ORDER" MODIFY ("USER_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_JOURNAL_RECV
--------------------------------------------------------

  ALTER TABLE "TBL_JOURNAL_RECV" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_JOURNAL_RECV" MODIFY ("USER_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_JOURNAL_RECV_FAVORITE
--------------------------------------------------------

  ALTER TABLE "TBL_JOURNAL_RECV_FAVORITE" ADD CONSTRAINT "PK_TBL_JOURNAL_RECV_FAVORITE" PRIMARY KEY ("TENANT_ID", "FAVORITE_ID")
  USING INDEX;
  ALTER TABLE "TBL_JOURNAL_RECV_FAVORITE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_JOURNAL_RECV_FAVORITE" MODIFY ("FAVORITE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_JOURNAL_RECV_FAVORITE_LIST
--------------------------------------------------------

  ALTER TABLE "TBL_JOURNAL_RECV_FAVORITE_LIST" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_JOURNAL_RECV_FAVORITE_LIST" MODIFY ("FAVORITE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_JOURNAL_REPLY
--------------------------------------------------------

  ALTER TABLE "TBL_JOURNAL_REPLY" ADD CONSTRAINT "PK_TBL_JOURNAL_REPLY" PRIMARY KEY ("REPLY_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_JOURNAL_REPLY" MODIFY ("JOURNAL_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_JOURNAL_REPLY" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_JOURNAL_REPLY" MODIFY ("REPLY_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_JOURNAL_SYMBOL
--------------------------------------------------------

  ALTER TABLE "TBL_JOURNAL_SYMBOL" ADD PRIMARY KEY ("SYMBOL_STR", "COMPANY_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_JOURNAL_SYMBOL" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_JOURNAL_SYMBOL" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_JOURNAL_SYMBOL" MODIFY ("SYMBOL_STR" NOT NULL ENABLE);
  ALTER TABLE "TBL_JOURNAL_SYMBOL" MODIFY ("SYMBOL_LEVEL" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_JOURNAL_VIEW
--------------------------------------------------------

  ALTER TABLE "TBL_JOURNAL_VIEW" ADD CONSTRAINT "PK_TBL_JOURNAL_VIEW" PRIMARY KEY ("USER_ID", "TENANT_ID", "JOURNAL_ID")
  USING INDEX;
  ALTER TABLE "TBL_JOURNAL_VIEW" MODIFY ("JOURNAL_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_JOURNAL_VIEW" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_JOURNAL_VIEW" MODIFY ("USER_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_LADDER
--------------------------------------------------------

  ALTER TABLE "TBL_LADDER" MODIFY ("WRITERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LADDER" MODIFY ("TYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_LADDER" MODIFY ("LADDERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LADDER" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LADDER" ADD PRIMARY KEY ("LADDERID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_LADDER" MODIFY ("LINECNT" NOT NULL ENABLE);
  ALTER TABLE "TBL_LADDER" MODIFY ("DEPTNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_LADDER" MODIFY ("WRITERNAME" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_LADDER_BM
--------------------------------------------------------

  ALTER TABLE "TBL_LADDER_BM" ADD PRIMARY KEY ("LADDERBMID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_LADDER_BM" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LADDER_BM" MODIFY ("LADDERBMID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LADDER_BM" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_LADDER_BMUSER
--------------------------------------------------------

  ALTER TABLE "TBL_LADDER_BMUSER" ADD PRIMARY KEY ("ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_LADDER_BMUSER" MODIFY ("USERNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_LADDER_BMUSER" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LADDER_BMUSER" MODIFY ("LADDERBMID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LADDER_BMUSER" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LADDER_BMUSER" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_LADDER_COMMENT
--------------------------------------------------------

  ALTER TABLE "TBL_LADDER_COMMENT" ADD PRIMARY KEY ("ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_LADDER_COMMENT" MODIFY ("USERNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_LADDER_COMMENT" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LADDER_COMMENT" MODIFY ("LADDERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LADDER_COMMENT" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LADDER_COMMENT" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_LADDER_LINE
--------------------------------------------------------

  ALTER TABLE "TBL_LADDER_LINE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LADDER_LINE" ADD PRIMARY KEY ("ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_LADDER_LINE" MODIFY ("LADDERORDER" NOT NULL ENABLE);
  ALTER TABLE "TBL_LADDER_LINE" MODIFY ("USERNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_LADDER_LINE" MODIFY ("LADDERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LADDER_LINE" MODIFY ("ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_LADDER_ORDER
--------------------------------------------------------

  ALTER TABLE "TBL_LADDER_ORDER" ADD PRIMARY KEY ("ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_LADDER_ORDER" MODIFY ("LADDERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LADDER_ORDER" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LADDER_ORDER" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_LASTAPRLINE
--------------------------------------------------------

  ALTER TABLE "TBL_LASTAPRLINE" ADD CONSTRAINT "TBL_LASTAPRLINE_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "USERID", "FORMID", "APRMEMBERSN", "DOCSTATE")
  USING INDEX;
  ALTER TABLE "TBL_LASTAPRLINE" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LASTAPRLINE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LASTAPRLINE" MODIFY ("APRMEMBERSN" NOT NULL ENABLE);
  ALTER TABLE "TBL_LASTAPRLINE" MODIFY ("FORMID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LASTAPRLINE" MODIFY ("USERID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_LASTDEPTLINE
--------------------------------------------------------

  ALTER TABLE "TBL_LASTDEPTLINE" ADD CONSTRAINT "TBL_LASTDEPTLINE_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "USERID", "FORMID", "RECEIPTPOINTID", "DOCSTATE")
  USING INDEX;
  ALTER TABLE "TBL_LASTDEPTLINE" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LASTDEPTLINE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LASTDEPTLINE" MODIFY ("RECEIPTPOINTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LASTDEPTLINE" MODIFY ("FORMID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LASTDEPTLINE" MODIFY ("USERID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_LASTDOCID
--------------------------------------------------------

  ALTER TABLE "TBL_LASTDOCID" ADD CONSTRAINT "TBL_LASTDOCID_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "LASTDOCID")
  USING INDEX;
  ALTER TABLE "TBL_LASTDOCID" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LASTDOCID" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LASTDOCID" MODIFY ("LASTDOCID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_LINTEMPLET
--------------------------------------------------------

  ALTER TABLE "TBL_LINTEMPLET" ADD CONSTRAINT "TBL_LINTEMPLET_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "USERID", "FORMID", "APRLINESN")
  USING INDEX;
  ALTER TABLE "TBL_LINTEMPLET" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LINTEMPLET" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LINTEMPLET" MODIFY ("APRLINESN" NOT NULL ENABLE);
  ALTER TABLE "TBL_LINTEMPLET" MODIFY ("FORMID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LINTEMPLET" MODIFY ("USERID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_LINTEMPLETDETAIL
--------------------------------------------------------

  ALTER TABLE "TBL_LINTEMPLETDETAIL" ADD CONSTRAINT "TBL_LINTEMPLETDETAIL_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "USERID", "FORMID", "APRLINESN", "APRMEMBERSN")
  USING INDEX;
  ALTER TABLE "TBL_LINTEMPLETDETAIL" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LINTEMPLETDETAIL" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LINTEMPLETDETAIL" MODIFY ("APRMEMBERSN" NOT NULL ENABLE);
  ALTER TABLE "TBL_LINTEMPLETDETAIL" MODIFY ("APRLINESN" NOT NULL ENABLE);
  ALTER TABLE "TBL_LINTEMPLETDETAIL" MODIFY ("FORMID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LINTEMPLETDETAIL" MODIFY ("USERID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_LISTINFO
--------------------------------------------------------

  ALTER TABLE "TBL_LISTINFO" ADD CONSTRAINT "TBL_LISTINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "LISTTYPE", "SN")
  USING INDEX;
  ALTER TABLE "TBL_LISTINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LISTINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LISTINFO" MODIFY ("DTYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_LISTINFO" MODIFY ("COLALIAS" NOT NULL ENABLE);
  ALTER TABLE "TBL_LISTINFO" MODIFY ("WIDTH" NOT NULL ENABLE);
  ALTER TABLE "TBL_LISTINFO" MODIFY ("SN" NOT NULL ENABLE);
  ALTER TABLE "TBL_LISTINFO" MODIFY ("LISTTYPE" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_LISTOPTION
--------------------------------------------------------

  ALTER TABLE "TBL_LISTOPTION" ADD CONSTRAINT "TBL_LISTOPTION_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "LISTTYPE", "SN")
  USING INDEX;
  ALTER TABLE "TBL_LISTOPTION" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LISTOPTION" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LISTOPTION" MODIFY ("SN" NOT NULL ENABLE);
  ALTER TABLE "TBL_LISTOPTION" MODIFY ("LISTTYPE" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_LOGO_SIZE
--------------------------------------------------------

  ALTER TABLE "TBL_LOGO_SIZE" ADD CONSTRAINT "PK_TBL_LOGO_SIZE" PRIMARY KEY ("TENANT_ID", "C_CLUBNO")
  USING INDEX;
  ALTER TABLE "TBL_LOGO_SIZE" MODIFY ("C_CLUBNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_LOGO_SIZE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_LUNARUSE
--------------------------------------------------------

  ALTER TABLE "TBL_LUNARUSE" ADD CONSTRAINT "PK_TBL_LUNARUSE" PRIMARY KEY ("TENANT_ID", "USECOMPANY")
  USING INDEX;
  ALTER TABLE "TBL_LUNARUSE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_LUNARUSE" MODIFY ("USECOMPANY" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_MEMO
--------------------------------------------------------

  ALTER TABLE "TBL_MEMO" MODIFY ("FOLDER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_MEMO" ADD CONSTRAINT "PK_MEMO" PRIMARY KEY ("MEMO_ID", "COMPANY_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_MEMO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_MEMO" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_MEMO" MODIFY ("ORDERS" NOT NULL ENABLE);
  ALTER TABLE "TBL_MEMO" MODIFY ("USER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_MEMO" MODIFY ("MEMO_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_MEMO_CONFIG
--------------------------------------------------------

  ALTER TABLE "TBL_MEMO_CONFIG" ADD CONSTRAINT "PK_MEMO_CONFIG" PRIMARY KEY ("USER_ID", "COMPANY_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_MEMO_CONFIG" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_MEMO_CONFIG" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_MEMO_CONFIG" MODIFY ("FONT_SIZE" NOT NULL ENABLE);
  ALTER TABLE "TBL_MEMO_CONFIG" MODIFY ("USER_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_MEMO_FOLDER
--------------------------------------------------------

  ALTER TABLE "TBL_MEMO_FOLDER" ADD CONSTRAINT "PK_MEMO_FOLDER" PRIMARY KEY ("FOLDER_ID", "COMPANY_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_MEMO_FOLDER" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_MEMO_FOLDER" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_MEMO_FOLDER" MODIFY ("USER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_MEMO_FOLDER" MODIFY ("FOLDER_NAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_MEMO_FOLDER" MODIFY ("FOLDER_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_MYTASKCODE
--------------------------------------------------------

  ALTER TABLE "TBL_MYTASKCODE" ADD CONSTRAINT "TBL_MYTASKCODE_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "CN", "DEPTID", "CABINETID", "TASKCODE")
  USING INDEX;
  ALTER TABLE "TBL_MYTASKCODE" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_MYTASKCODE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_MYTASKCODE" MODIFY ("TASKCODE" NOT NULL ENABLE);
  ALTER TABLE "TBL_MYTASKCODE" MODIFY ("CABINETID" NOT NULL ENABLE);
  ALTER TABLE "TBL_MYTASKCODE" MODIFY ("DEPTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_MYTASKCODE" MODIFY ("CN" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_NOTIFICATION
--------------------------------------------------------

  ALTER TABLE "TBL_NOTIFICATION" ADD CONSTRAINT "TBL_NOTIFICATION_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "ITEMSEQ")
  USING INDEX;
  ALTER TABLE "TBL_NOTIFICATION" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_NOTIFICATION" MODIFY ("TYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_NOTIFICATION" MODIFY ("SUBJECT" NOT NULL ENABLE);
  ALTER TABLE "TBL_NOTIFICATION" MODIFY ("SENDER" NOT NULL ENABLE);
  ALTER TABLE "TBL_NOTIFICATION" MODIFY ("POSTDATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_NOTIFICATION" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_NOTIFICATION" MODIFY ("ITEMSEQ" NOT NULL ENABLE);
  ALTER TABLE "TBL_NOTIFICATION" MODIFY ("COMPANYID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_OLDCABINETEXTRAINFO
--------------------------------------------------------

  ALTER TABLE "TBL_OLDCABINETEXTRAINFO" ADD CONSTRAINT "TBL_OLDCABINETEXTRAINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "CABINETCLASSNO")
  USING INDEX;
  ALTER TABLE "TBL_OLDCABINETEXTRAINFO" MODIFY ("CABINETCLASSNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_OLDCABINETEXTRAINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_OLDCABINETEXTRAINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_OLDRECORDEXTRAINFO
--------------------------------------------------------

  ALTER TABLE "TBL_OLDRECORDEXTRAINFO" ADD CONSTRAINT "TBL_OLDRECORDEXTRAINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "RECORDID")
  USING INDEX;
  ALTER TABLE "TBL_OLDRECORDEXTRAINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_OLDRECORDEXTRAINFO" MODIFY ("RECORDID" NOT NULL ENABLE);
  ALTER TABLE "TBL_OLDRECORDEXTRAINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_OPENGOVDOCINFO
--------------------------------------------------------

  ALTER TABLE "TBL_OPENGOVDOCINFO" ADD CONSTRAINT "TBL_OPENGOVDOCINFO_PK" PRIMARY KEY ("DOCID", "TENANT_ID", "COMPANYID")
  USING INDEX;
  ALTER TABLE "TBL_OPENGOVDOCINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_OPENGOVDOCINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_OPENGOVDOCINFO" MODIFY ("DOCID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_OPENGOVFILEINFO
--------------------------------------------------------

  ALTER TABLE "TBL_OPENGOVFILEINFO" ADD CONSTRAINT "TBL_OPENGOVFILEINFO_PK" PRIMARY KEY ("DOCID", "SN", "COMPANYID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_OPENGOVFILEINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_OPENGOVFILEINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_OPENGOVFILEINFO" MODIFY ("SN" NOT NULL ENABLE);
  ALTER TABLE "TBL_OPENGOVFILEINFO" MODIFY ("DOCID" NOT NULL ENABLE);
  
--------------------------------------------------------
--  Constraints for Table TBL_OPENGOVMODIFYHISTORY
--------------------------------------------------------

  ALTER TABLE "TBL_OPENGOVMODIFYHISTORY" ADD CONSTRAINT "TBL_OPENGOVMODIFYHISTORY_PK" PRIMARY KEY ("DOCID", "SN", "COMPANYID", "TENANTID")
  USING INDEX;
  ALTER TABLE "TBL_OPENGOVMODIFYHISTORY" MODIFY ("DOCID" NOT NULL ENABLE);
  ALTER TABLE "TBL_OPENGOVMODIFYHISTORY" MODIFY ("SN" NOT NULL ENABLE);
  ALTER TABLE "TBL_OPENGOVMODIFYHISTORY" MODIFY ("TENANTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_OPENGOVMODIFYHISTORY" MODIFY ("COMPANYID" NOT NULL ENABLE);

-------------------------------------------------------- 
--  Constraints for Table TBL_PASSWORD_POLICY
-------------------------------------------------------- 

  ALTER TABLE "TBL_PASSWORD_POLICY" ADD CONSTRAINT "PK2_TBL_PASSWORD_POLICY" PRIMARY KEY ("TENANT_ID", "COMPANY_ID")
  USING INDEX;
  
--------------------------------------------------------
--  Constraints for Table TBL_PASSWORD_POLICY_PATTERN
--------------------------------------------------------

  ALTER TABLE "TBL_PASSWORD_POLICY_PATTERN" ADD CONSTRAINT "PK2_TBL_PASSWORD_POLICY_PATT" PRIMARY KEY ("TENANT_ID", "COMPANY_ID", "USE_PATTERN_COUNT")
  USING INDEX;
  
--------------------------------------------------------
--  Constraints for Table TBL_GOVSENDDOCHISTORY
--------------------------------------------------------

  ALTER TABLE "TBL_GOVSENDDOCHISTORY" ADD CONSTRAINT "TBL_GOVSENDDOCHISTORY_PK" PRIMARY KEY ("SN")
  USING INDEX;
  ALTER TABLE "TBL_GOVSENDDOCHISTORY" MODIFY ("SN" NOT NULL ENABLE);
 
  
--------------------------------------------------------
--  Constraints for Table TBL_PERMISSIONGROUPINFO
--------------------------------------------------------

  ALTER TABLE "TBL_PERMISSIONGROUPINFO" MODIFY ("GROUP_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PERMISSIONGROUPINFO" MODIFY ("MEMBER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PERMISSIONGROUPINFO" MODIFY ("MEMBER_TYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_PERMISSIONGROUPINFO" MODIFY ("ADDED_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_PERMISSIONGROUPINFO" MODIFY ("SUB_DEPT_YN" NOT NULL ENABLE);
  ALTER TABLE "TBL_PERMISSIONGROUPINFO" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PERMISSIONGROUPINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PERMISSIONGROUPINFO" ADD PRIMARY KEY ("GROUP_ID", "MEMBER_ID", "TENANT_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_PERMISSIONGROUPLIST
--------------------------------------------------------

  ALTER TABLE "TBL_PERMISSIONGROUPLIST" MODIFY ("GROUP_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PERMISSIONGROUPLIST" MODIFY ("GROUP_NAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_PERMISSIONGROUPLIST" MODIFY ("CREATE_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PERMISSIONGROUPLIST" MODIFY ("CREATE_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_PERMISSIONGROUPLIST" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PERMISSIONGROUPLIST" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PERMISSIONGROUPLIST" ADD PRIMARY KEY ("GROUP_ID", "TENANT_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_PHOTO_IMAGEITEM
--------------------------------------------------------

  ALTER TABLE "TBL_PHOTO_IMAGEITEM" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PHOTO_IMAGEITEM" ADD CONSTRAINT "PK_TBL_PHOTO_IMAGEITEM" PRIMARY KEY ("TENANT_ID", "IMAGEID")
  USING INDEX;
  ALTER TABLE "TBL_PHOTO_IMAGEITEM" MODIFY ("WRITEDATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_PHOTO_IMAGEITEM" MODIFY ("FILEPATH" NOT NULL ENABLE);
  ALTER TABLE "TBL_PHOTO_IMAGEITEM" MODIFY ("WRITERDEPTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PHOTO_IMAGEITEM" MODIFY ("WRITERNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_PHOTO_IMAGEITEM" MODIFY ("WRITERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PHOTO_IMAGEITEM" MODIFY ("BOARDID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PHOTO_IMAGEITEM" MODIFY ("ITEMID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PHOTO_IMAGEITEM" MODIFY ("IMAGEID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_POLL_ANSWER
--------------------------------------------------------

  ALTER TABLE "TBL_POLL_ANSWER" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ANSWER" MODIFY ("ANSWERNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ANSWER" MODIFY ("QUESTION_NO" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ANSWER" MODIFY ("ITEM_NO" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ANSWER" MODIFY ("BRD_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ANSWER" ADD CONSTRAINT "PK_TBL_POLL_ANSWER" PRIMARY KEY ("TENANT_ID", "BRD_ID", "ITEM_NO", "QUESTION_NO", "ANSWERNO")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_POLL_ATTACH
--------------------------------------------------------

  ALTER TABLE "TBL_POLL_ATTACH" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ATTACH" ADD CONSTRAINT "PK_TBL_POLL_ATTACH" PRIMARY KEY ("TENANT_ID", "BRD_ID", "ITEM_NO", "QUESTION_NO", "ANSWERNO", "ATTACHNO")
  USING INDEX;
  ALTER TABLE "TBL_POLL_ATTACH" MODIFY ("ATTACHNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ATTACH" MODIFY ("ANSWERNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ATTACH" MODIFY ("QUESTION_NO" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ATTACH" MODIFY ("ITEM_NO" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ATTACH" MODIFY ("BRD_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_POLL_ITEM
--------------------------------------------------------

  ALTER TABLE "TBL_POLL_ITEM" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ITEM" MODIFY ("COMPLETE_FLAG" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ITEM" MODIFY ("RES_CNT" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ITEM" MODIFY ("READ_CNT" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ITEM" MODIFY ("ITEM_GB" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ITEM" MODIFY ("HASATTACH" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ITEM" MODIFY ("ITEM_IMP" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ITEM" MODIFY ("POST_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ITEM" MODIFY ("CONTENT" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ITEM" MODIFY ("TITLE" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ITEM" MODIFY ("USER_EMAIL" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ITEM" MODIFY ("USER_NM" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ITEM" MODIFY ("USER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ITEM" MODIFY ("ITEM_NO" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ITEM" MODIFY ("BRD_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ITEM" ADD CONSTRAINT "PK_TBL_POLL_ITEM" PRIMARY KEY ("TENANT_ID", "BRD_ID", "ITEM_NO")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_POLL_ITEMACL
--------------------------------------------------------

  ALTER TABLE "TBL_POLL_ITEMACL" MODIFY ("GUBUN_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ITEMACL" MODIFY ("GUBUN" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ITEMACL" MODIFY ("ITEM_NO" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ITEMACL" MODIFY ("BRD_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ITEMACL" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ITEMACL" ADD CONSTRAINT "PK_TBL_POLL_ITEMACL" PRIMARY KEY ("TENANT_ID", "BRD_ID", "ITEM_NO", "GUBUN", "GUBUN_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_POLL_ITEMREAD
--------------------------------------------------------

  ALTER TABLE "TBL_POLL_ITEMREAD" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ITEMREAD" MODIFY ("USER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ITEMREAD" MODIFY ("ITEM_NO" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ITEMREAD" MODIFY ("BRD_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_ITEMREAD" ADD CONSTRAINT "PK_TBL_POLL_ITEMREAD" PRIMARY KEY ("TENANT_ID", "BRD_ID", "ITEM_NO", "USER_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_POLL_PERMISSION
--------------------------------------------------------

  ALTER TABLE "TBL_POLL_PERMISSION" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_PERMISSION" MODIFY ("RESPONSE_RANGE" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_PERMISSION" MODIFY ("END_FLG" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_PERMISSION" MODIFY ("MULTI_RESPONSE_FLG" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_PERMISSION" MODIFY ("PUBLIC_RESULT_FLG" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_PERMISSION" MODIFY ("PUBLIC_FLG" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_PERMISSION" MODIFY ("ITEM_NO" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_PERMISSION" MODIFY ("BRD_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_PERMISSION" ADD CONSTRAINT "PK_TBL_POLL_PERMISSION" PRIMARY KEY ("TENANT_ID", "BRD_ID", "ITEM_NO")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_POLL_QUESTION
--------------------------------------------------------

  ALTER TABLE "TBL_POLL_QUESTION" ADD CONSTRAINT "PK_TBL_POLL_QUESTION" PRIMARY KEY ("TENANT_ID", "BRD_ID", "ITEM_NO", "QUESTION_NO")
  USING INDEX;
  ALTER TABLE "TBL_POLL_QUESTION" MODIFY ("ITEM_NO" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_QUESTION" MODIFY ("BRD_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_QUESTION" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_QUESTION" MODIFY ("MULTISELECT" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_QUESTION" MODIFY ("ANSWERTYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_QUESTION" MODIFY ("QUESCONTENT" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_QUESTION" MODIFY ("QUESTION_NO" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_POLL_RESPONSE
--------------------------------------------------------

  ALTER TABLE "TBL_POLL_RESPONSE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_RESPONSE" MODIFY ("RESPONSE_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_RESPONSE" MODIFY ("RESPONSENO" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_RESPONSE" MODIFY ("ITEM_NO" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_RESPONSE" MODIFY ("BRD_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_RESPONSE" ADD CONSTRAINT "PK_TBL_POLL_RESPONSE" PRIMARY KEY ("TENANT_ID", "BRD_ID", "ITEM_NO", "QUESTION_NO", "RESPONSENO")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_POLL_RESPONSEPERSON
--------------------------------------------------------

  ALTER TABLE "TBL_POLL_RESPONSEPERSON" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_RESPONSEPERSON" MODIFY ("USER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_RESPONSEPERSON" MODIFY ("ITEM_NO" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_RESPONSEPERSON" MODIFY ("BRD_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_RESPONSEPERSON" ADD CONSTRAINT "PK_TBL_POLL_RESPONSEPERSON" PRIMARY KEY ("TENANT_ID", "BRD_ID", "ITEM_NO", "USER_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_POLL_TABLE_ANSWER
--------------------------------------------------------

  ALTER TABLE "TBL_POLL_TABLE_ANSWER" MODIFY ("ANSWERNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_TABLE_ANSWER" MODIFY ("QUESTION_NO" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_TABLE_ANSWER" MODIFY ("ITEM_NO" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_TABLE_ANSWER" MODIFY ("BRD_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_TABLE_ANSWER" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_POLL_TABLE_ANSWER" ADD CONSTRAINT "PK_TBL_POLL_TABLE_ANSWER" PRIMARY KEY ("TENANT_ID", "BRD_ID", "ITEM_NO", "QUESTION_NO", "ANSWERNO")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_PORTAL_FRAME
--------------------------------------------------------

  ALTER TABLE "TBL_PORTAL_FRAME" ADD CONSTRAINT "TBL_PORTAL_FRAME_PK" PRIMARY KEY ("FRAME_ID")
  USING INDEX;
  ALTER TABLE "TBL_PORTAL_FRAME" MODIFY ("FRAME_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_PORTAL_FRAME_COMP
--------------------------------------------------------

  ALTER TABLE "TBL_PORTAL_FRAME_COMP" ADD CONSTRAINT "TBL_PORTAL_FRAME_COMP_PK" PRIMARY KEY ("COMPANY_ID", "TENANT_ID", "THEME_ID", "FRAME_ID")
  USING INDEX;
  ALTER TABLE "TBL_PORTAL_FRAME_COMP" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_PORTAL_LOGO
--------------------------------------------------------

  ALTER TABLE "TBL_PORTAL_LOGO" ADD CONSTRAINT "TBL_PORTAL_LOGO_PK" PRIMARY KEY ("COMPANY_ID", "TENANT_ID", "LOGO_TYPE")
  USING INDEX;
  ALTER TABLE "TBL_PORTAL_LOGO" MODIFY ("LOGO_TYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_PORTAL_LOGO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PORTAL_LOGO" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_PORTAL_MENU
--------------------------------------------------------

  ALTER TABLE "TBL_PORTAL_MENU" ADD CONSTRAINT "TBL_PORTAL_MENU_PK" PRIMARY KEY ("MENU_ID")
  USING INDEX;
  ALTER TABLE "TBL_PORTAL_MENU" MODIFY ("MENU_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_PORTAL_MENU_AUTH
--------------------------------------------------------

  ALTER TABLE "TBL_PORTAL_MENU_AUTH" ADD CONSTRAINT "TBL_PORTAL_MENU_AUTH_PK" PRIMARY KEY ("MENU_ID", "COMPANY_ID", "TENANT_ID", "USER_ID")
  USING INDEX;
  ALTER TABLE "TBL_PORTAL_MENU_AUTH" MODIFY ("USER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PORTAL_MENU_AUTH" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PORTAL_MENU_AUTH" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PORTAL_MENU_AUTH" MODIFY ("MENU_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_PORTAL_MENU_COMP
--------------------------------------------------------

  ALTER TABLE "TBL_PORTAL_MENU_COMP" ADD CONSTRAINT "TBL_PORTAL_MENU_COMP_PK" PRIMARY KEY ("COMPANY_ID", "TENANT_ID", "MENU_ID")
  USING INDEX;
  ALTER TABLE "TBL_PORTAL_MENU_COMP" MODIFY ("MENU_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PORTAL_MENU_COMP" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PORTAL_MENU_COMP" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_PORTAL_MENU_NAME
--------------------------------------------------------

  ALTER TABLE "TBL_PORTAL_MENU_NAME" ADD CONSTRAINT "TBL_PORTAL_MENU_NAME_PK" PRIMARY KEY ("MENU_ID", "MENU_LANG", "COMPANY_ID", "TENANT_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_PORTAL_MENU_USER
--------------------------------------------------------

  ALTER TABLE "TBL_PORTAL_MENU_USER" ADD CONSTRAINT "TBL_PORTAL_MENU_USER_PK" PRIMARY KEY ("USER_ID", "TENANT_ID", "COMPANY_ID", "MENU_ID")
  USING INDEX;
  ALTER TABLE "TBL_PORTAL_MENU_USER" MODIFY ("MENU_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PORTAL_MENU_USER" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PORTAL_MENU_USER" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PORTAL_MENU_USER" MODIFY ("USER_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_PORTAL_PORTLET
--------------------------------------------------------

  ALTER TABLE "TBL_PORTAL_PORTLET" ADD CONSTRAINT "TBL_PORTAL_PORTLET_PK" PRIMARY KEY ("PORTLET_ID", "MENU_ID")
  USING INDEX;
  ALTER TABLE "TBL_PORTAL_PORTLET" MODIFY ("PORTLET_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_PORTAL_PORTLET_AUTH
--------------------------------------------------------

  ALTER TABLE "TBL_PORTAL_PORTLET_AUTH" ADD CONSTRAINT "TBL_PORTAL_PORTLET_AUTH_PK" PRIMARY KEY ("PORTLET_ID", "COMPANY_ID", "TENANT_ID", "USER_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_PORTAL_PORTLET_COMP
--------------------------------------------------------

  ALTER TABLE "TBL_PORTAL_PORTLET_COMP" ADD CONSTRAINT "TBL_PORTAL_PORTLET_COMP_PK" PRIMARY KEY ("COMPANY_ID", "TENANT_ID", "PORTLET_ID")
  USING INDEX;
  ALTER TABLE "TBL_PORTAL_PORTLET_COMP" MODIFY ("PORTLET_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PORTAL_PORTLET_COMP" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PORTAL_PORTLET_COMP" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_PORTAL_PORTLET_NAME
--------------------------------------------------------

  ALTER TABLE "TBL_PORTAL_PORTLET_NAME" ADD PRIMARY KEY ("PORTLET_ID", "MENU_ID", "PORTLET_LANG", "TENANT_ID", "COMPANY_ID")
  USING INDEX;
  ALTER TABLE "TBL_PORTAL_PORTLET_NAME" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PORTAL_PORTLET_NAME" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PORTAL_PORTLET_NAME" MODIFY ("PORTLET_LANG" NOT NULL ENABLE);
  ALTER TABLE "TBL_PORTAL_PORTLET_NAME" MODIFY ("MENU_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PORTAL_PORTLET_NAME" MODIFY ("PORTLET_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_PORTAL_PORTLET_USER
--------------------------------------------------------

  ALTER TABLE "TBL_PORTAL_PORTLET_USER" ADD CONSTRAINT "TBL_PORTAL_PORTLET_USER_PK" PRIMARY KEY ("USER_ID", "TENANT_ID", "COMPANY_ID", "PORTLET_ID", "THEME_ID")
  USING INDEX;
  ALTER TABLE "TBL_PORTAL_PORTLET_USER" MODIFY ("THEME_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PORTAL_PORTLET_USER" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PORTAL_PORTLET_USER" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PORTAL_PORTLET_USER" MODIFY ("USER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PORTAL_PORTLET_USER" MODIFY ("PORTLET_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_PORTAL_STARTPAGE
--------------------------------------------------------

  ALTER TABLE "TBL_PORTAL_STARTPAGE" ADD CONSTRAINT "TBL_PORTAL_STARTPAGE_PK" PRIMARY KEY ("USER_ID", "TENANT_ID", "COMPANY_ID")
  USING INDEX;
  ALTER TABLE "TBL_PORTAL_STARTPAGE" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PORTAL_STARTPAGE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PORTAL_STARTPAGE" MODIFY ("USER_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_PORTAL_THEME
--------------------------------------------------------

  ALTER TABLE "TBL_PORTAL_THEME" ADD CONSTRAINT "TBL_PORTAL_THEME_PK" PRIMARY KEY ("THEME_ID")
  USING INDEX;
  ALTER TABLE "TBL_PORTAL_THEME" MODIFY ("THEME_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_PORTAL_THEME_AUTH
--------------------------------------------------------

  ALTER TABLE "TBL_PORTAL_THEME_AUTH" ADD CONSTRAINT "TBL_PORTAL_THEME_AUTH_PK" PRIMARY KEY ("THEME_ID", "COMPANY_ID", "TENANT_ID", "USER_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_PORTAL_THEME_COMP
--------------------------------------------------------

  ALTER TABLE "TBL_PORTAL_THEME_COMP" ADD CONSTRAINT "TBL_PORTAL_THEME_COMP_PK" PRIMARY KEY ("COMPANY_ID", "TENANT_ID", "THEME_ID")
  USING INDEX;
  ALTER TABLE "TBL_PORTAL_THEME_COMP" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_PORTAL_THEME_PORTLET
--------------------------------------------------------

  ALTER TABLE "TBL_PORTAL_THEME_PORTLET" ADD CONSTRAINT PK_TBL_PORTAL_THEME_PORTLET PRIMARY KEY ("THEME_ID", "TENANT_ID", "COMPANY_ID", "PORTLET_ID");
  ALTER TABLE "TBL_PORTAL_THEME_PORTLET" MODIFY ("PORTLET_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PORTAL_THEME_PORTLET" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PORTAL_THEME_PORTLET" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PORTAL_THEME_PORTLET" MODIFY ("THEME_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_PORTAL_THEME_USER
--------------------------------------------------------

  ALTER TABLE "TBL_PORTAL_THEME_USER" ADD CONSTRAINT "TBL_PORTAL_THEME_USER_PK" PRIMARY KEY ("USER_ID", "COMPANY_ID", "TENANT_ID", "USED_THEME")
  USING INDEX;
  ALTER TABLE "TBL_PORTAL_THEME_USER" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PORTAL_THEME_USER" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PORTAL_THEME_USER" MODIFY ("USER_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_PREVIOSLYREGI
--------------------------------------------------------

  ALTER TABLE "TBL_PREVIOSLYREGI" ADD CONSTRAINT "PK_TBL_PREVIOSLYREGI" PRIMARY KEY ("TENANT_ID", "USECOMPANY")
  USING INDEX;
  ALTER TABLE "TBL_PREVIOSLYREGI" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PREVIOSLYREGI" MODIFY ("USECOMPANY" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_PROXYINFO
--------------------------------------------------------

  ALTER TABLE "TBL_PROXYINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PROXYINFO" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PROXYINFO" ADD CONSTRAINT "PK_TBL_PROXYINFO" PRIMARY KEY ("TENANT_ID", "USERID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_PS_APPROVNOTIMAILCONF
--------------------------------------------------------

  ALTER TABLE "TBL_PS_APPROVNOTIMAILCONF" MODIFY ("HESONG" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_APPROVNOTIMAILCONF" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_APPROVNOTIMAILCONF" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_APPROVNOTIMAILCONF" ADD CONSTRAINT "PK_TBL_PS_APPROVNOTIMAILCONF" PRIMARY KEY ("TENANT_ID", "USERID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_PS_EMPMONTH
--------------------------------------------------------

  ALTER TABLE "TBL_PS_EMPMONTH" ADD CONSTRAINT "TBL_PS_EMPMONTH_PK" PRIMARY KEY ("TENANT_ID", "COMPANY", "TERM")
  USING INDEX;
  ALTER TABLE "TBL_PS_EMPMONTH" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_EMPMONTH" MODIFY ("TERM" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_EMPMONTH" MODIFY ("DEPARTMENT" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_EMPMONTH" MODIFY ("DISPLAYNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_EMPMONTH" MODIFY ("CN" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_EMPMONTH" MODIFY ("COMPANY" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_PS_LIGHTPOLL
--------------------------------------------------------

  ALTER TABLE "TBL_PS_LIGHTPOLL" MODIFY ("ANSWER10" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_LIGHTPOLL" MODIFY ("ANSWER9" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_LIGHTPOLL" MODIFY ("ANSWER8" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_LIGHTPOLL" MODIFY ("ANSWER7" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_LIGHTPOLL" MODIFY ("ANSWER6" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_LIGHTPOLL" MODIFY ("ANSWER5" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_LIGHTPOLL" MODIFY ("ANSWER4" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_LIGHTPOLL" MODIFY ("ANSWER3" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_LIGHTPOLL" MODIFY ("ANSWER2" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_LIGHTPOLL" MODIFY ("ANSWER1" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_LIGHTPOLL" MODIFY ("POLLTITLE" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_LIGHTPOLL" MODIFY ("POLLSELECTIONCOUNT" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_LIGHTPOLL" MODIFY ("STARTDATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_LIGHTPOLL" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_LIGHTPOLL" MODIFY ("ITEMSEQ" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_LIGHTPOLL" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_LIGHTPOLL" ADD CONSTRAINT "PK_TBL_PS_LIGHTPOLL" PRIMARY KEY ("TENANT_ID", "ITEMSEQ")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_PS_LIGHTPOLLRESULT
--------------------------------------------------------

  ALTER TABLE "TBL_PS_LIGHTPOLLRESULT" ADD CONSTRAINT "PK_TBL_PS_LIGHTPOLLRESULT" PRIMARY KEY ("TENANT_ID", "ITEMSEQ", "USERID")
  USING INDEX;
  ALTER TABLE "TBL_PS_LIGHTPOLLRESULT" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_LIGHTPOLLRESULT" MODIFY ("RESULT" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_LIGHTPOLLRESULT" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_LIGHTPOLLRESULT" MODIFY ("ITEMSEQ" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_PS_LIGHTPOLL_OPTION
--------------------------------------------------------

  ALTER TABLE "TBL_PS_LIGHTPOLL_OPTION" ADD PRIMARY KEY ("LIGHTPOLLOPTIONID", "TENANTID")
  USING INDEX;
  ALTER TABLE "TBL_PS_LIGHTPOLL_OPTION" MODIFY ("TENANTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_LIGHTPOLL_OPTION" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_LIGHTPOLL_OPTION" MODIFY ("LIGHTPOLLOPTIONID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_PS_NOTICE
--------------------------------------------------------

  ALTER TABLE "TBL_PS_NOTICE" MODIFY ("TITLE" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_NOTICE" MODIFY ("POSTDATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_NOTICE" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_NOTICE" MODIFY ("ITEMSEQ" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_NOTICE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_NOTICE" ADD CONSTRAINT "PK_TBL_PS_NOTICE" PRIMARY KEY ("TENANT_ID", "ITEMSEQ")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_PS_POPUP
--------------------------------------------------------

  ALTER TABLE "TBL_PS_POPUP" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_POPUP" MODIFY ("TITLE" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_POPUP" MODIFY ("ENDDATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_POPUP" MODIFY ("STARTDATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_POPUP" MODIFY ("ITEMSEQ" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_POPUP" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_POPUP" ADD CONSTRAINT "PK_TBL_PS_POPUP" PRIMARY KEY ("TENANT_ID", "COMPANYID", "ITEMSEQ")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_PS_POPUP_OPTION
--------------------------------------------------------

  ALTER TABLE "TBL_PS_POPUP_OPTION" ADD PRIMARY KEY ("POPUPOPTIONID", "TENANTID")
  USING INDEX;
  ALTER TABLE "TBL_PS_POPUP_OPTION" MODIFY ("TENANTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_POPUP_OPTION" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_POPUP_OPTION" MODIFY ("POPUPOPTIONID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_PS_QUICKLINK
--------------------------------------------------------

  ALTER TABLE "TBL_PS_QUICKLINK" MODIFY ("LINKTYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_QUICKLINK" MODIFY ("QUICKLINKNAME6" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_QUICKLINK" MODIFY ("QUICKLINKNAME5" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_QUICKLINK" MODIFY ("QUICKLINKNAME4" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_QUICKLINK" MODIFY ("QUICKLINKNAME3" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_QUICKLINK" MODIFY ("QUICKLINKNAME2" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_QUICKLINK" MODIFY ("QUICKLINKNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_QUICKLINK" MODIFY ("QUICKLINKID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_QUICKLINK" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_QUICKLINK" ADD CONSTRAINT "PK_TBL_PS_QUICKLINK" PRIMARY KEY ("TENANT_ID", "QUICKLINKID")
  USING INDEX;
  ALTER TABLE "TBL_PS_QUICKLINK" MODIFY ("REGUSERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_QUICKLINK" MODIFY ("REGDATE" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_PS_QUICKLINK_ACL
--------------------------------------------------------

  ALTER TABLE "TBL_PS_QUICKLINK_ACL" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_QUICKLINK_ACL" MODIFY ("VIEW_FLAG" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_QUICKLINK_ACL" MODIFY ("ACCESSNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_QUICKLINK_ACL" MODIFY ("ACCESSID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_QUICKLINK_ACL" MODIFY ("QUICKLINKID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_QUICKLINK_ACL" ADD CONSTRAINT "PK_TBL_PS_QUICKLINK_ACL" PRIMARY KEY ("TENANT_ID", "QUICKLINKID", "ACCESSID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_PS_SHAREAPPROVAL
--------------------------------------------------------

  ALTER TABLE "TBL_PS_SHAREAPPROVAL" ADD CONSTRAINT "TBL_PS_SHAREAPPROVAL_UK1" UNIQUE ("OWNERID", "TENANTID", "SHAREUSERID")
  USING INDEX;
  ALTER TABLE "TBL_PS_SHAREAPPROVAL" ADD CONSTRAINT "TBL_PS_SHAREAPPROVAL_PK" PRIMARY KEY ("OWNERID", "SHAREUSERID", "TENANTID") DISABLE;
  ALTER TABLE "TBL_PS_SHAREAPPROVAL" MODIFY ("TENANTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_SHAREAPPROVAL" MODIFY ("SHAREUSERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_SHAREAPPROVAL" MODIFY ("OWNERID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_PS_SLIDERIMAGE
--------------------------------------------------------

  ALTER TABLE "TBL_PS_SLIDERIMAGE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_SLIDERIMAGE" MODIFY ("SN" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_SLIDERIMAGE" MODIFY ("ISUSE" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_SLIDERIMAGE" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_SLIDERIMAGE" MODIFY ("REGDATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_SLIDERIMAGE" MODIFY ("REGUSERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_SLIDERIMAGE" MODIFY ("IMAGEPATH" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_SLIDERIMAGE" MODIFY ("FILENAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_SLIDERIMAGE" ADD CONSTRAINT "PK_TBL_PS_SLIDERIMAGE" PRIMARY KEY ("TENANT_ID", "SLIDERID")
  USING INDEX;
  ALTER TABLE "TBL_PS_SLIDERIMAGE" MODIFY ("SLIDERID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_PS_USERWEBPART
--------------------------------------------------------

  ALTER TABLE "TBL_PS_USERWEBPART" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_USERWEBPART" MODIFY ("ITEMPOSITION" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_USERWEBPART" MODIFY ("ITEMSEQ" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_USERWEBPART" MODIFY ("ITEMID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_USERWEBPART" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_USERWEBPART" ADD CONSTRAINT "PK_TBL_PS_USERWEBPART" PRIMARY KEY ("TENANT_ID", "USERID", "ITEMID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_PS_WEBPARTGROUP
--------------------------------------------------------

  ALTER TABLE "TBL_PS_WEBPARTGROUP" ADD CONSTRAINT "TBL_PS_WEBPARTGROUP_PK" PRIMARY KEY ("TENANT_ID", "ID")
  USING INDEX;
  ALTER TABLE "TBL_PS_WEBPARTGROUP" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_WEBPARTGROUP" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_PS_WEBPARTITEM
--------------------------------------------------------

  ALTER TABLE "TBL_PS_WEBPARTITEM" ADD CONSTRAINT "TBL_PS_WEBPARTITEM_PK" PRIMARY KEY ("TENANT_ID", "ID")
  USING INDEX;
  ALTER TABLE "TBL_PS_WEBPARTITEM" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_WEBPARTITEM" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_PS_WEBPARTITEMACL
--------------------------------------------------------

  ALTER TABLE "TBL_PS_WEBPARTITEMACL" ADD CONSTRAINT "TBL_PS_WEBPARTITEMACL_PK" PRIMARY KEY ("TENANT_ID", "ITEMID")
  USING INDEX;
  ALTER TABLE "TBL_PS_WEBPARTITEMACL" MODIFY ("ITEMID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PS_WEBPARTITEMACL" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_PWDINFO
--------------------------------------------------------

  ALTER TABLE "TBL_PWDINFO" ADD CONSTRAINT "TBL_PWDINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "USERID")
  USING INDEX;
  ALTER TABLE "TBL_PWDINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PWDINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_PWDINFO" MODIFY ("PWDTYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_PWDINFO" MODIFY ("FLAG" NOT NULL ENABLE);
  ALTER TABLE "TBL_PWDINFO" MODIFY ("USERID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_QS_BRDMNG
--------------------------------------------------------

  ALTER TABLE "TBL_QS_BRDMNG" ADD CONSTRAINT "PK_TBL_BRDMNG" PRIMARY KEY ("BRD_ID", "USER_ID")
  USING INDEX;
  ALTER TABLE "TBL_QS_BRDMNG" MODIFY ("MNG_GB" NOT NULL ENABLE);
  ALTER TABLE "TBL_QS_BRDMNG" MODIFY ("USER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_QS_BRDMNG" MODIFY ("BRD_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_QS_ITEMSEQ
--------------------------------------------------------

  ALTER TABLE "TBL_QS_ITEMSEQ" MODIFY ("BRD_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_QS_ITEMSEQ" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_QS_ITEMSEQ" ADD CONSTRAINT "PK_TBL_ITEMSEQ" PRIMARY KEY ("TENANT_ID", "BRD_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_RECEIPTPOINTINFO
--------------------------------------------------------

  ALTER TABLE "TBL_RECEIPTPOINTINFO" ADD CONSTRAINT "TBL_RECEIPTPOINTINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "DOCID", "RECEIPTPOINTID", "PROCESSSN")
  USING INDEX;
  ALTER TABLE "TBL_RECEIPTPOINTINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RECEIPTPOINTINFO" MODIFY ("PROCESSSN" NOT NULL ENABLE);
  ALTER TABLE "TBL_RECEIPTPOINTINFO" MODIFY ("RECEIPTPOINTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RECEIPTPOINTINFO" MODIFY ("DOCID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RECEIPTPOINTINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_RECEXCHINFO
--------------------------------------------------------

  ALTER TABLE "TBL_RECEXCHINFO" ADD CONSTRAINT "TBL_RECEXCHINFO_PK" PRIMARY KEY ("COMPANYID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_RECEXCHINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RECEXCHINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_RECORD
--------------------------------------------------------

  ALTER TABLE "TBL_RECORD" ADD CONSTRAINT "TBL_RECORD_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "RECORDID")
  USING INDEX;
  ALTER TABLE "TBL_RECORD" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RECORD" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RECORD" MODIFY ("RECORDID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_RECORDHISTORY
--------------------------------------------------------

  ALTER TABLE "TBL_RECORDHISTORY" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RECORDHISTORY" MODIFY ("VERSION" NOT NULL ENABLE);
  ALTER TABLE "TBL_RECORDHISTORY" MODIFY ("SEPERATEATTACHNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_RECORDHISTORY" MODIFY ("RECORDID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RECORDHISTORY" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RECORDHISTORY" ADD CONSTRAINT "TBL_RECORDHISTORY_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "RECORDID", "SEPERATEATTACHNO", "VERSION")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_RECORD_TEMP
--------------------------------------------------------

  ALTER TABLE "TBL_RECORD_TEMP" ADD CONSTRAINT "TBL_RECORD_TEMP_PK" PRIMARY KEY ("COMPANYID", "TENANT_ID", "DOCID")
  USING INDEX;
  ALTER TABLE "TBL_RECORD_TEMP" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RECORD_TEMP" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RECORD_TEMP" MODIFY ("DOCID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_RECREADHISTORY
--------------------------------------------------------

  ALTER TABLE "TBL_RECREADHISTORY" ADD CONSTRAINT "TBL_RECREADHISTORY_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "SERIALNO", "DOCID")
  USING INDEX;
  ALTER TABLE "TBL_RECREADHISTORY" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RECREADHISTORY" MODIFY ("DOCID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RECREADHISTORY" MODIFY ("SERIALNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_RECREADHISTORY" MODIFY ("COMPANYID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_RECRELAYINFO
--------------------------------------------------------

  ALTER TABLE "TBL_RECRELAYINFO" ADD CONSTRAINT "TBL_RECRELAYINFO_PK" PRIMARY KEY ("IDX", "XDOCID", "TENANT_ID", "COMPANYID")
  USING INDEX;
  ALTER TABLE "TBL_RECRELAYINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RECRELAYINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RECRELAYINFO" MODIFY ("IDX" NOT NULL ENABLE);
  ALTER TABLE "TBL_RECRELAYINFO" MODIFY ("XDOCID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_RECROLEINFO
--------------------------------------------------------

  ALTER TABLE "TBL_RECROLEINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RECROLEINFO" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RECROLEINFO" MODIFY ("SEPERATEATTACHNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_RECROLEINFO" MODIFY ("RECORDID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RECROLEINFO" ADD CONSTRAINT "TBL_RECROLEINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "RECORDID", "SEPERATEATTACHNO", "USERID")
  USING INDEX;
  ALTER TABLE "TBL_RECROLEINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_RECROLEINFO_TEMP
--------------------------------------------------------

  ALTER TABLE "TBL_RECROLEINFO_TEMP" ADD CONSTRAINT "TBL_RECROLEINFO_TEMP_PK" PRIMARY KEY ("DOCID", "TENANT_ID", "COMPANYID", "SEPERATEATTACHNO", "USERID")
  USING INDEX;
  ALTER TABLE "TBL_RECROLEINFO_TEMP" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RECROLEINFO_TEMP" MODIFY ("SEPERATEATTACHNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_RECROLEINFO_TEMP" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RECROLEINFO_TEMP" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RECROLEINFO_TEMP" MODIFY ("DOCID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_RS_ATTACH
--------------------------------------------------------

  ALTER TABLE "TBL_RS_ATTACH" ADD CONSTRAINT "TBL_RS_ATTACH_PK" PRIMARY KEY ("ATTACHID", "COMPANYID", "TENANT_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_RS_BRD
--------------------------------------------------------

  ALTER TABLE "TBL_RS_BRD" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RS_BRD" MODIFY ("BRD_COMPANY" NOT NULL ENABLE);
  ALTER TABLE "TBL_RS_BRD" MODIFY ("BRD_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RS_BRD" ADD CONSTRAINT "PK_TBL_RS_BRD" PRIMARY KEY ("TENANT_ID", "BRD_ID", "BRD_COMPANY")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_RS_FAVORITE
--------------------------------------------------------

  ALTER TABLE "TBL_RS_FAVORITE" ADD CONSTRAINT "PK_TBL_RS_FAVORITE" PRIMARY KEY ("RESID", "USERID", "TENANT_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_RS_PERSPORTLET
--------------------------------------------------------

  ALTER TABLE "TBL_RS_PERSPORTLET" ADD CONSTRAINT "TBL_RS_PERSPORTLET_PK" PRIMARY KEY ("TENANT_ID", "CN", "BRD_COMPANY", "BRD_ID")
  USING INDEX;
  ALTER TABLE "TBL_RS_PERSPORTLET" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RS_PERSPORTLET" MODIFY ("BRD_COMPANY" NOT NULL ENABLE);
  ALTER TABLE "TBL_RS_PERSPORTLET" MODIFY ("BRD_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RS_PERSPORTLET" MODIFY ("CN" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_RS_RESACL
--------------------------------------------------------

  ALTER TABLE "TBL_RS_RESACL" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RS_RESACL" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RS_RESACL" MODIFY ("MEMBER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RS_RESACL" MODIFY ("RESID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RS_RESACL" ADD CONSTRAINT "PK_TBL_RS_RESACL" PRIMARY KEY ("TENANT_ID", "RESID", "MEMBER_ID", "COMPANYID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_RS_SCHEDULE
--------------------------------------------------------

  ALTER TABLE "TBL_RS_SCHEDULE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RS_SCHEDULE" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RS_SCHEDULE" MODIFY ("NUM" NOT NULL ENABLE);
  ALTER TABLE "TBL_RS_SCHEDULE" MODIFY ("OWNERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RS_SCHEDULE" ADD CONSTRAINT "PK_TBL_RS_SCHEDULE" PRIMARY KEY ("TENANT_ID", "OWNERID", "NUM", "COMPANYID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_RS_SCHEDULEFORM
--------------------------------------------------------

  ALTER TABLE "TBL_RS_SCHEDULEFORM" ADD CONSTRAINT "TBL_RS_SCHEDULEFORM_PK" PRIMARY KEY ("TENANT_ID", "RESID")
  USING INDEX;
  ALTER TABLE "TBL_RS_SCHEDULEFORM" MODIFY ("RESID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RS_SCHEDULEFORM" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_RS_SCHEDULEREPETITION
--------------------------------------------------------

  ALTER TABLE "TBL_RS_SCHEDULEREPETITION" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RS_SCHEDULEREPETITION" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RS_SCHEDULEREPETITION" MODIFY ("NUM" NOT NULL ENABLE);
  ALTER TABLE "TBL_RS_SCHEDULEREPETITION" MODIFY ("OWNERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_RS_SCHEDULEREPETITION" ADD CONSTRAINT "PK_TBL_RS_SCHEDULEREPETITION" PRIMARY KEY ("TENANT_ID", "OWNERID", "NUM", "COMPANYID") DISABLE;
--------------------------------------------------------
--  Constraints for Table TBL_SCHEDULE
--------------------------------------------------------

  ALTER TABLE "TBL_SCHEDULE" ADD CONSTRAINT "PK_TBL_SCHEDULE" PRIMARY KEY ("SCHEDULEID")
  USING INDEX;
  ALTER TABLE "TBL_SCHEDULE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULE" MODIFY ("CONTENTPATH" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULE" MODIFY ("LOCATION" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULE" MODIFY ("TITLE" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULE" MODIFY ("REPETITIONDELETE" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULE" MODIFY ("REPETITION" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULE" MODIFY ("ENDDATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULE" MODIFY ("STARTDATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULE" MODIFY ("DATETYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULE" MODIFY ("ISPUBLIC" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULE" MODIFY ("ISREADONLY" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULE" MODIFY ("HASCOMMENT" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULE" MODIFY ("HASATTACH" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULE" MODIFY ("HASATTENDANT" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULE" MODIFY ("IMPORTANCE" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULE" MODIFY ("SCHEDULETYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULE" MODIFY ("MODIFYDATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULE" MODIFY ("MODIFIERNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULE" MODIFY ("MODIFIERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULE" MODIFY ("CREATEDATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULE" MODIFY ("CREATORNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULE" MODIFY ("CREATORID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULE" MODIFY ("OWNERNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULE" MODIFY ("OWNERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULE" MODIFY ("PARENTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULE" MODIFY ("SCHEDULEID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_SCHEDULEATTACH
--------------------------------------------------------

  ALTER TABLE "TBL_SCHEDULEATTACH" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULEATTACH" ADD CONSTRAINT "PK_TBL_SCHEDULEATTACH" PRIMARY KEY ("ATTACHID", "SCHEDULEID")
  USING INDEX;
  ALTER TABLE "TBL_SCHEDULEATTACH" MODIFY ("FILEPATH" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULEATTACH" MODIFY ("FILENAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULEATTACH" MODIFY ("FILESIZE" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULEATTACH" MODIFY ("SCHEDULEID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULEATTACH" MODIFY ("ATTACHID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_SCHEDULECONFIG
--------------------------------------------------------

  ALTER TABLE "TBL_SCHEDULECONFIG" ADD CONSTRAINT "PK_TBL_SCHEDULECONFIG" PRIMARY KEY ("USERID")
  USING INDEX;
  ALTER TABLE "TBL_SCHEDULECONFIG" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULECONFIG" MODIFY ("AUTODELETE" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULECONFIG" MODIFY ("ENDTIME" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULECONFIG" MODIFY ("STARTTIME" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULECONFIG" MODIFY ("STARTDAY" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULECONFIG" MODIFY ("DEFAULTVIEW" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULECONFIG" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULECONFIG" MODIFY ("REMINDERTIME" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_SCHEDULEGROUP
--------------------------------------------------------

  ALTER TABLE "TBL_SCHEDULEGROUP" ADD CONSTRAINT "PK_TBL_SCHEDULEGROUP" PRIMARY KEY ("GROUPID")
  USING INDEX;
  ALTER TABLE "TBL_SCHEDULEGROUP" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULEGROUP" MODIFY ("DESCRIPTION" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULEGROUP" MODIFY ("CREATORNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULEGROUP" MODIFY ("GROUPNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULEGROUP" MODIFY ("GROUPID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_SCHEDULEGROUPMEMBER
--------------------------------------------------------

  ALTER TABLE "TBL_SCHEDULEGROUPMEMBER" ADD CONSTRAINT "PK_TBL_SCHEDULEGROUPMEMBER" PRIMARY KEY ("GROUPID", "MEMBERID")
  USING INDEX;
  ALTER TABLE "TBL_SCHEDULEGROUPMEMBER" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULEGROUPMEMBER" MODIFY ("RESPONSEDATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULEGROUPMEMBER" MODIFY ("STATUS" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULEGROUPMEMBER" MODIFY ("MEMBERNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULEGROUPMEMBER" MODIFY ("MEMBERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULEGROUPMEMBER" MODIFY ("GROUPID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_SCHEDULEREPETITION_DEL
--------------------------------------------------------

  ALTER TABLE "TBL_SCHEDULEREPETITION_DEL" ADD CONSTRAINT "TBL_SCHEDULEREPETITION_DEL_PK" PRIMARY KEY ("REPETITIONID")
  USING INDEX;
  ALTER TABLE "TBL_SCHEDULEREPETITION_DEL" MODIFY ("REPETITIONID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_SCHEDULE_PUBLIC_DEPT
--------------------------------------------------------

  ALTER TABLE "TBL_SCHEDULE_PUBLIC_DEPT" ADD CONSTRAINT "PK_TBL_SCHEDULE_PUBLIC_DEPT" PRIMARY KEY ("TENANT_ID", "USERCN", "DEPARTMENTCN")
  USING INDEX;
  ALTER TABLE "TBL_SCHEDULE_PUBLIC_DEPT" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULE_PUBLIC_DEPT" MODIFY ("DEPARTMENTNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULE_PUBLIC_DEPT" MODIFY ("DEPARTMENTCN" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULE_PUBLIC_DEPT" MODIFY ("USERNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULE_PUBLIC_DEPT" MODIFY ("USERCN" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHEDULE_PUBLIC_DEPT" MODIFY ("IDX" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_SCHISTORY_CAB
--------------------------------------------------------

  ALTER TABLE "TBL_SCHISTORY_CAB" MODIFY ("VERSION" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHISTORY_CAB" ADD CONSTRAINT "PK_TBL_SCHISTORY_CAB" PRIMARY KEY ("TENANT_ID", "VERSION", "CABINETCLASSNO", "SERIALNO", "COMPANYID")
  USING INDEX;
  ALTER TABLE "TBL_SCHISTORY_CAB" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHISTORY_CAB" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHISTORY_CAB" MODIFY ("SERIALNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHISTORY_CAB" MODIFY ("CABINETCLASSNO" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_SCHISTORY_REC
--------------------------------------------------------

  ALTER TABLE "TBL_SCHISTORY_REC" ADD CONSTRAINT "PK_TBL_SCHISTORY_REC" PRIMARY KEY ("TENANT_ID", "RECORDID", "SEPERATEATTACHNO", "VERSION", "SERIALNO", "COMPANYID")
  USING INDEX;
  ALTER TABLE "TBL_SCHISTORY_REC" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHISTORY_REC" MODIFY ("SERIALNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHISTORY_REC" MODIFY ("VERSION" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHISTORY_REC" MODIFY ("SEPERATEATTACHNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHISTORY_REC" MODIFY ("RECORDID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SCHISTORY_REC" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  
  --------------------------------------------------------
--  Constraints for Table TBL_CAR
--------------------------------------------------------

  ALTER TABLE "TBL_CAR" ADD CONSTRAINT "PK_TBL_CAR" PRIMARY KEY ("TENANT_ID", "CAR_ID", "COMPANYID")
  USING INDEX;
  ALTER TABLE "TBL_CAR" MODIFY ("CAR_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CAR" MODIFY ("DELFLAG" NOT NULL ENABLE);
  ALTER TABLE "TBL_CAR" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CAR" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CAR_ACL
--------------------------------------------------------

  ALTER TABLE "TBL_CAR_ACL" ADD CONSTRAINT "PK_TBL_CAR_ACL" PRIMARY KEY ("TENANT_ID", "CAR_ID", "MEMBER_ID", "COMPANYID")
  USING INDEX;
  ALTER TABLE "TBL_CAR_ACL" MODIFY ("CAR_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CAR_ACL" MODIFY ("MEMBER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CAR_ACL" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CAR_ACL" MODIFY ("TENANT_ID" NOT NULL ENABLE);

--------------------------------------------------------
--  Constraints for Table TBL_CAR_ATTACH
--------------------------------------------------------

  ALTER TABLE "TBL_CAR_ATTACH" ADD CONSTRAINT "PK_TBL_CAR_ATTACH" PRIMARY KEY ("ATTACHID", "TENANT_ID", "COMPANYID") 
  USING INDEX;
  ALTER TABLE "TBL_CAR_ATTACH" MODIFY ("ATTACHID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CAR_ATTACH" MODIFY ("CAR_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CAR_ATTACH" MODIFY ("FILESIZE" NOT NULL ENABLE);
  ALTER TABLE "TBL_CAR_ATTACH" MODIFY ("FILENAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_CAR_ATTACH" MODIFY ("FILEPATH" NOT NULL ENABLE);
  ALTER TABLE "TBL_CAR_ATTACH" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CAR_ATTACH" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_CAR_FORM
--------------------------------------------------------

  ALTER TABLE "TBL_CAR_FORM" ADD CONSTRAINT "PK_TBL_CAR_FORM" PRIMARY KEY ("CAR_FORM_ID", "CAR_ID", "COMPANYID", "TENANT_ID", "CAR_REGISTER_NO")
  USING INDEX;
  ALTER TABLE "TBL_CAR_FORM" MODIFY ("CAR_FORM_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CAR_FORM" MODIFY ("CAR_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CAR_FORM" MODIFY ("REGISTER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CAR_FORM" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CAR_FORM" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_CAR_FORM" MODIFY ("CAR_REGISTER_NO" NOT NULL ENABLE);
  ALTER TABLE "TBL_CAR_FORM" MODIFY ("DELFLAG" NOT NULL ENABLE);
  
--------------------------------------------------------
--  Constraints for Table TBL_SEALDEPTINFO
--------------------------------------------------------

  ALTER TABLE "TBL_SEALDEPTINFO" ADD CONSTRAINT "PK_TBL_SEALDEPTINFO" PRIMARY KEY ("TENANT_ID", "SEALNUM", "DEPTID", "COMPANYID")
  USING INDEX;
  ALTER TABLE "TBL_SEALDEPTINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SEALDEPTINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SEALDEPTINFO" MODIFY ("DEPTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SEALDEPTINFO" MODIFY ("SEALNUM" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_SEALINFO
--------------------------------------------------------

  ALTER TABLE "TBL_SEALINFO" ADD CONSTRAINT "PK_TBL_SEALINFO" PRIMARY KEY ("TENANT_ID", "SEALNUM", "COMPANYID")
  USING INDEX;
  ALTER TABLE "TBL_SEALINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SEALINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SEALINFO" MODIFY ("SEALNUM" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_SECRETARY
--------------------------------------------------------

  ALTER TABLE "TBL_SECRETARY" ADD CONSTRAINT "PK_TBL_SECRETARY" PRIMARY KEY ("TENANT_ID", "USERID", "SECRETARYID")
  USING INDEX;
  ALTER TABLE "TBL_SECRETARY" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SECRETARY" MODIFY ("SECRETARYNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_SECRETARY" MODIFY ("SECRETARYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SECRETARY" MODIFY ("USERNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_SECRETARY" MODIFY ("USERID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_SEPERATEATTACH
--------------------------------------------------------

  ALTER TABLE "TBL_SEPERATEATTACH" MODIFY ("CABINETID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SEPERATEATTACH" MODIFY ("SEPERATEATTACHNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_SEPERATEATTACH" MODIFY ("RECORDID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SEPERATEATTACH" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SEPERATEATTACH" ADD CONSTRAINT "TBL_SEPERATEATTACH_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "RECORDID", "SEPERATEATTACHNO")
  USING INDEX;
  ALTER TABLE "TBL_SEPERATEATTACH" MODIFY ("COMPANYID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_SEPERATEATTACH_TEMP
--------------------------------------------------------

  ALTER TABLE "TBL_SEPERATEATTACH_TEMP" ADD CONSTRAINT "TBL_SEPERATEATTACH_TEMP_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "DOCID", "SEPERATEATTACHNO")
  USING INDEX;
  ALTER TABLE "TBL_SEPERATEATTACH_TEMP" MODIFY ("SEPERATEATTACHNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_SEPERATEATTACH_TEMP" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SEPERATEATTACH_TEMP" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SEPERATEATTACH_TEMP" MODIFY ("DOCID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_SERIALNUMGEN
--------------------------------------------------------

  ALTER TABLE "TBL_SERIALNUMGEN" ADD CONSTRAINT "TBL_SERIALNUMGEN_PK" PRIMARY KEY ("IDX")
  USING INDEX;
  ALTER TABLE "TBL_SERIALNUMGEN" MODIFY ("IDX" NOT NULL ENABLE);
  ALTER TABLE "TBL_SERIALNUMGEN" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SERIALNUMGEN" MODIFY ("REGSERIALNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_SERIALNUMGEN" MODIFY ("ROLLBACKFLAG" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_SIGNINFO
--------------------------------------------------------

  ALTER TABLE "TBL_SIGNINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SIGNINFO" MODIFY ("SIGNNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_SIGNINFO" MODIFY ("APRSN" NOT NULL ENABLE);
  ALTER TABLE "TBL_SIGNINFO" MODIFY ("DOCID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SIGNINFO" ADD CONSTRAINT "TBL_SIGNINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "DOCID", "APRSN", "SIGNNAME")
  USING INDEX;
  ALTER TABLE "TBL_SIGNINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_SPECIALCATALOGINFO_CAB
--------------------------------------------------------

  ALTER TABLE "TBL_SPECIALCATALOGINFO_CAB" ADD CONSTRAINT "PK_TBL_SPECIALCATALOGINFO_CAB" PRIMARY KEY ("TENANT_ID", "CABINETCLASSNO", "SERIALNO", "COMPANYID")
  USING INDEX;
  ALTER TABLE "TBL_SPECIALCATALOGINFO_CAB" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SPECIALCATALOGINFO_CAB" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SPECIALCATALOGINFO_CAB" MODIFY ("SERIALNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_SPECIALCATALOGINFO_CAB" MODIFY ("CABINETCLASSNO" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_SPECIALCATALOGINFO_REC
--------------------------------------------------------

  ALTER TABLE "TBL_SPECIALCATALOGINFO_REC" ADD CONSTRAINT "TBL_SPECIALCATALOGINFO_REC_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "RECORDID", "SERIALNO")
  USING INDEX;
  ALTER TABLE "TBL_SPECIALCATALOGINFO_REC" MODIFY ("SERIALNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_SPECIALCATALOGINFO_REC" MODIFY ("RECORDID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SPECIALCATALOGINFO_REC" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SPECIALCATALOGINFO_REC" MODIFY ("COMPANYID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_SPECIALCATALOGINFO_TMP
--------------------------------------------------------

  ALTER TABLE "TBL_SPECIALCATALOGINFO_TMP" ADD CONSTRAINT "TBL_SPECIALCATALOGINFO_TMP_PK" PRIMARY KEY ("DOCID", "TENANT_ID", "COMPANYID", "RECORDID", "SERIALNO")
  USING INDEX;
  ALTER TABLE "TBL_SPECIALCATALOGINFO_TMP" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SPECIALCATALOGINFO_TMP" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SPECIALCATALOGINFO_TMP" MODIFY ("SERIALNO" NOT NULL ENABLE);
  ALTER TABLE "TBL_SPECIALCATALOGINFO_TMP" MODIFY ("RECORDID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SPECIALCATALOGINFO_TMP" MODIFY ("DOCID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_SPECIALCONTAINERINFO
--------------------------------------------------------

  ALTER TABLE "TBL_SPECIALCONTAINERINFO" MODIFY ("CONTTYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_SPECIALCONTAINERINFO" MODIFY ("DEPTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SPECIALCONTAINERINFO" ADD CONSTRAINT "TBL_SPECIALCONTAINERINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "DEPTID", "CONTTYPE", "SN")
  USING INDEX;
  ALTER TABLE "TBL_SPECIALCONTAINERINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SPECIALCONTAINERINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SPECIALCONTAINERINFO" MODIFY ("SN" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_SURVEY
--------------------------------------------------------

  ALTER TABLE "TBL_SURVEY" ADD CONSTRAINT "PK_SURVEY" PRIMARY KEY ("SURVEY_ID", "COMPANY_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_SURVEY" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY" MODIFY ("TOTAL_USER" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY" MODIFY ("OPEN_DAYS" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY" MODIFY ("USER_NAME2" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY" MODIFY ("USER_NAME1" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY" MODIFY ("END_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY" MODIFY ("START_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY" MODIFY ("CREATE_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY" MODIFY ("USER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY" MODIFY ("PURPOSE" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY" MODIFY ("TITLE" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_SURVEY_ATTACHFILE
--------------------------------------------------------

  ALTER TABLE "TBL_SURVEY_ATTACHFILE" ADD CONSTRAINT "PK_SURVEY_ATTACHFILE" PRIMARY KEY ("ATT_FILE_ID", "COMPANY_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_SURVEY_ATTACHFILE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY_ATTACHFILE" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY_ATTACHFILE" MODIFY ("FILE_NM" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY_ATTACHFILE" MODIFY ("TARGET_TYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY_ATTACHFILE" MODIFY ("TARGET_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY_ATTACHFILE" MODIFY ("SURVEY_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_SURVEY_CONFIG
--------------------------------------------------------

  ALTER TABLE "TBL_SURVEY_CONFIG" ADD CONSTRAINT "PK_SURVEY_CONFIG" PRIMARY KEY ("USER_ID", "COMPANY_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_SURVEY_CONFIG" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY_CONFIG" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_SURVEY_OPTION
--------------------------------------------------------

  ALTER TABLE "TBL_SURVEY_OPTION" ADD CONSTRAINT "PK_SURVEY_OPTION" PRIMARY KEY ("OPTION_ID", "COMPANY_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_SURVEY_OPTION" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY_OPTION" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY_OPTION" MODIFY ("LEVELS" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY_OPTION" MODIFY ("QUESTION_LEVEL" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY_OPTION" MODIFY ("QUESTION_TYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY_OPTION" MODIFY ("QUESTION_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY_OPTION" MODIFY ("SURVEY_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_SURVEY_PARTICIPANT
--------------------------------------------------------

  ALTER TABLE "TBL_SURVEY_PARTICIPANT" ADD CONSTRAINT "PK_SURVEY_PARTICIPANT" PRIMARY KEY ("PARTICIPANT_ID", "COMPANY_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_SURVEY_PARTICIPANT" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY_PARTICIPANT" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY_PARTICIPANT" MODIFY ("USER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY_PARTICIPANT" MODIFY ("USER_TYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY_PARTICIPANT" MODIFY ("SURVEY_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_SURVEY_QUESTION
--------------------------------------------------------

  ALTER TABLE "TBL_SURVEY_QUESTION" ADD CONSTRAINT "PK_SURVEY_QUESTION" PRIMARY KEY ("QUESTION_ID", "COMPANY_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_SURVEY_QUESTION" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY_QUESTION" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY_QUESTION" MODIFY ("LEVELS" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY_QUESTION" MODIFY ("TITLE" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY_QUESTION" MODIFY ("QUESTION_TYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY_QUESTION" MODIFY ("SURVEY_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_SURVEY_RESPONDENT
--------------------------------------------------------

  ALTER TABLE "TBL_SURVEY_RESPONDENT" ADD CONSTRAINT "PK_SURVEY_RESPONDENT" PRIMARY KEY ("RESPONSE_ID", "COMPANY_ID", "TENANT_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_SURVEY_RESPONSE
--------------------------------------------------------

  ALTER TABLE "TBL_SURVEY_RESPONSE" ADD CONSTRAINT "PK_SURVEY_RESPONSE" PRIMARY KEY ("RESPONSE_ID", "COMPANY_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_SURVEY_RESPONSE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY_RESPONSE" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY_RESPONSE" MODIFY ("OPTION_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY_RESPONSE" MODIFY ("USER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY_RESPONSE" MODIFY ("QUESTION_TYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY_RESPONSE" MODIFY ("QUESTION_LEVEL" NOT NULL ENABLE);
  ALTER TABLE "TBL_SURVEY_RESPONSE" MODIFY ("SURVEY_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_TASK
--------------------------------------------------------

  ALTER TABLE "TBL_TASK" ADD CONSTRAINT "PK_TBL_TASK" PRIMARY KEY ("TASKID", "TENANTID")
  USING INDEX;
  ALTER TABLE "TBL_TASK" MODIFY ("TENANTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASK" MODIFY ("TASKID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_TASKATTACH
--------------------------------------------------------

  ALTER TABLE "TBL_TASKATTACH" ADD CONSTRAINT "PK_TBL_TASKATTACH" PRIMARY KEY ("ATTACHID", "TASKID", "TENANTID")
  USING INDEX;
  ALTER TABLE "TBL_TASKATTACH" MODIFY ("TENANTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKATTACH" MODIFY ("FILEPATH" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKATTACH" MODIFY ("FILENAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKATTACH" MODIFY ("FILESIZE" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKATTACH" MODIFY ("TASKID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKATTACH" MODIFY ("ATTACHID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_TASKCATEGORY
--------------------------------------------------------

  ALTER TABLE "TBL_TASKCATEGORY" ADD CONSTRAINT "PK_TBL_TASKCATEGORY" PRIMARY KEY ("TENANT_ID", "CATEGORYCODE", "COMPANYID")
  USING INDEX;
  ALTER TABLE "TBL_TASKCATEGORY" MODIFY ("CATEGORYCODE" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKCATEGORY" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKCATEGORY" MODIFY ("COMPANYID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_TASKCODE
--------------------------------------------------------

  ALTER TABLE "TBL_TASKCODE" ADD CONSTRAINT "TBL_TASKCODE_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "TASKCODE")
  USING INDEX;
  ALTER TABLE "TBL_TASKCODE" MODIFY ("TASKCODE" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKCODE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKCODE" MODIFY ("COMPANYID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_TASKCODEHISTORY
--------------------------------------------------------

  ALTER TABLE "TBL_TASKCODEHISTORY" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKCODEHISTORY" MODIFY ("SN" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKCODEHISTORY" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKCODEHISTORY" ADD CONSTRAINT "PK_TBL_TASKCODEHISTORY" PRIMARY KEY ("SN")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_TASKCOMMENT
--------------------------------------------------------

  ALTER TABLE "TBL_TASKCOMMENT" ADD CONSTRAINT "PK_TBL_TASKCOMMENT" PRIMARY KEY ("COMMENTID", "TASKID", "TENANTID")
  USING INDEX;
  ALTER TABLE "TBL_TASKCOMMENT" MODIFY ("T_COMMENT" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKCOMMENT" MODIFY ("COMMENTDATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKCOMMENT" MODIFY ("COMMENTORNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKCOMMENT" MODIFY ("COMMENTORID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKCOMMENT" MODIFY ("TASKID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKCOMMENT" MODIFY ("COMMENTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKCOMMENT" MODIFY ("TENANTID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_TASKCONFIG
--------------------------------------------------------

  ALTER TABLE "TBL_TASKCONFIG" MODIFY ("ORIGINCOLOR2" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKCONFIG" ADD CONSTRAINT "PK_TBL_TASKCONFIG" PRIMARY KEY ("USERID", "TENANTID")
  USING INDEX;
  ALTER TABLE "TBL_TASKCONFIG" MODIFY ("TENANTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKCONFIG" MODIFY ("ORIGINCOLOR" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKCONFIG" MODIFY ("COMPLETECOLOR" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKCONFIG" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKCONFIG" MODIFY ("DELAYCOLOR" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_TASKGENERAL
--------------------------------------------------------

  ALTER TABLE "TBL_TASKGENERAL" ADD CONSTRAINT "TBL_TASKGENERAL_PK" PRIMARY KEY ("USERID", "TENANTID")
  USING INDEX;
  ALTER TABLE "TBL_TASKGENERAL" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKGENERAL" MODIFY ("TENANTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKGENERAL" MODIFY ("SELECTTASKSTATUS" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKGENERAL" MODIFY ("LISTCOUNT" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_TASKINSTANCESTATUS
--------------------------------------------------------

  ALTER TABLE "TBL_TASKINSTANCESTATUS" ADD CONSTRAINT "PK_TBL_TASKINSTANCESTATUS" PRIMARY KEY ("TASKID", "STARTDATE", "TENANTID")
  USING INDEX;
  ALTER TABLE "TBL_TASKINSTANCESTATUS" MODIFY ("DELETESTATUS" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKINSTANCESTATUS" MODIFY ("TENANTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKINSTANCESTATUS" MODIFY ("COMPLETERATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKINSTANCESTATUS" MODIFY ("TASKSTATUS" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKINSTANCESTATUS" MODIFY ("REPEATCOUNT" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKINSTANCESTATUS" MODIFY ("TASKID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKINSTANCESTATUS" MODIFY ("ENDDATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKINSTANCESTATUS" MODIFY ("STARTDATE" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_TASKMIDDLECATEGORY
--------------------------------------------------------

  ALTER TABLE "TBL_TASKMIDDLECATEGORY" ADD CONSTRAINT "PK_TBL_TASKMIDDLECATEGORY" PRIMARY KEY ("TENANT_ID", "MCATEGORYCODE", "COMPANYID")
  USING INDEX;
  ALTER TABLE "TBL_TASKMIDDLECATEGORY" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKMIDDLECATEGORY" MODIFY ("MCATEGORYCODE" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKMIDDLECATEGORY" MODIFY ("COMPANYID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_TASKREQUEST
--------------------------------------------------------

  ALTER TABLE "TBL_TASKREQUEST" ADD CONSTRAINT "PK_TBL_TASKREQUEST" PRIMARY KEY ("REQUESTID")
  USING INDEX;
  ALTER TABLE "TBL_TASKREQUEST" MODIFY ("DEPTCODE" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKREQUEST" MODIFY ("ORGANCODE" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKREQUEST" MODIFY ("REQUESTFLAG" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKREQUEST" MODIFY ("REQUESTID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_TASKSHARE
--------------------------------------------------------

  ALTER TABLE "TBL_TASKSHARE" ADD CONSTRAINT "PK_TBL_TASKSHARE" PRIMARY KEY ("TASKID", "SHARERID", "TENANTID")
  USING INDEX;
  ALTER TABLE "TBL_TASKSHARE" MODIFY ("TENANTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKSHARE" MODIFY ("SHARERDEPTNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKSHARE" MODIFY ("SHARERNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKSHARE" MODIFY ("SHARERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKSHARE" MODIFY ("TASKID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKSHARE" MODIFY ("SHAREREMAIL" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_TASKSUBCATEGORY
--------------------------------------------------------

  ALTER TABLE "TBL_TASKSUBCATEGORY" ADD CONSTRAINT "PK_TBL_TASKSUBCATEGORY" PRIMARY KEY ("TENANT_ID", "SUBCATEGORYCODE", "COMPANYID")
  USING INDEX;
  ALTER TABLE "TBL_TASKSUBCATEGORY" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKSUBCATEGORY" MODIFY ("SUBCATEGORYCODE" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASKSUBCATEGORY" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_TASK_DEPTINFO
--------------------------------------------------------

  ALTER TABLE "TBL_TASK_DEPTINFO" ADD CONSTRAINT "TBL_TASK_DEPTINFO_PK" PRIMARY KEY ("PROCESSDEPTCODE", "TASKCODE", "TENANT_ID", "COMPANYID")
  USING INDEX;
  ALTER TABLE "TBL_TASK_DEPTINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASK_DEPTINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASK_DEPTINFO" MODIFY ("TASKCODE" NOT NULL ENABLE);
  ALTER TABLE "TBL_TASK_DEPTINFO" MODIFY ("PROCESSDEPTCODE" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_TENANT
--------------------------------------------------------

  ALTER TABLE "TBL_TENANT" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TENANT" MODIFY ("TENANT_NAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_TENANT" ADD CONSTRAINT "PK_TBL_TENANT" PRIMARY KEY ("TENANT_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_TENANT_CONFIG
--------------------------------------------------------

  ALTER TABLE "TBL_TENANT_CONFIG" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TENANT_CONFIG" MODIFY ("PROPERTY_NAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_TENANT_CONFIG" ADD CONSTRAINT "PK_TBL_TENANT_CONFIG" PRIMARY KEY ("TENANT_ID", "PROPERTY_NAME")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_TENANT_SERVERNAME
--------------------------------------------------------

  ALTER TABLE "TBL_TENANT_SERVERNAME" MODIFY ("SERVER_NAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_TENANT_SERVERNAME" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TENANT_SERVERNAME" ADD CONSTRAINT "PK_TBL_TENANT_SERVERNAME" PRIMARY KEY ("SERVER_NAME")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_TMPAPRDOCATTACHINFO
--------------------------------------------------------

  ALTER TABLE "TBL_TMPAPRDOCATTACHINFO" MODIFY ("ATTACHSN" NOT NULL ENABLE);
  ALTER TABLE "TBL_TMPAPRDOCATTACHINFO" MODIFY ("SN" NOT NULL ENABLE);
  ALTER TABLE "TBL_TMPAPRDOCATTACHINFO" MODIFY ("OWNERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TMPAPRDOCATTACHINFO" ADD CONSTRAINT "TBL_TMPAPRDOCATTACHINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "OWNERID", "SN", "ATTACHSN")
  USING INDEX;
  ALTER TABLE "TBL_TMPAPRDOCATTACHINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TMPAPRDOCATTACHINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TMPAPRDOCATTACHINFO" MODIFY ("ATTACHDOCURL" NOT NULL ENABLE);
  ALTER TABLE "TBL_TMPAPRDOCATTACHINFO" MODIFY ("ATTACHDOCNAME" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_TMPAPRDOCINFO
--------------------------------------------------------

  ALTER TABLE "TBL_TMPAPRDOCINFO" ADD CONSTRAINT "TBL_TMPAPRDOCINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "OWNERID", "SN")
  USING INDEX;
  ALTER TABLE "TBL_TMPAPRDOCINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TMPAPRDOCINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TMPAPRDOCINFO" MODIFY ("SN" NOT NULL ENABLE);
  ALTER TABLE "TBL_TMPAPRDOCINFO" MODIFY ("OWNERID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_TMPAPRLINEINFO
--------------------------------------------------------

  ALTER TABLE "TBL_TMPAPRLINEINFO" ADD CONSTRAINT "TBL_TMPAPRLINEINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "OWNERID", "SN", "APRMEMBERSN")
  USING INDEX;
  ALTER TABLE "TBL_TMPAPRLINEINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TMPAPRLINEINFO" MODIFY ("APRMEMBERSN" NOT NULL ENABLE);
  ALTER TABLE "TBL_TMPAPRLINEINFO" MODIFY ("SN" NOT NULL ENABLE);
  ALTER TABLE "TBL_TMPAPRLINEINFO" MODIFY ("OWNERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TMPAPRLINEINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_TMPAPROPINIONINFO
--------------------------------------------------------

  ALTER TABLE "TBL_TMPAPROPINIONINFO" ADD CONSTRAINT "TBL_TMPAPROPINIONINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "OWNERID", "SN", "OPINIONSN")
  USING INDEX;
  ALTER TABLE "TBL_TMPAPROPINIONINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TMPAPROPINIONINFO" MODIFY ("OPINIONSN" NOT NULL ENABLE);
  ALTER TABLE "TBL_TMPAPROPINIONINFO" MODIFY ("SN" NOT NULL ENABLE);
  ALTER TABLE "TBL_TMPAPROPINIONINFO" MODIFY ("OWNERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TMPAPROPINIONINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_TMPATTACHINFO
--------------------------------------------------------

  ALTER TABLE "TBL_TMPATTACHINFO" ADD CONSTRAINT "TBL_TMPATTACHINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "OWNERID", "SN", "ATTACHFILESN")
  USING INDEX;
  ALTER TABLE "TBL_TMPATTACHINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TMPATTACHINFO" MODIFY ("ATTACHFILESN" NOT NULL ENABLE);
  ALTER TABLE "TBL_TMPATTACHINFO" MODIFY ("SN" NOT NULL ENABLE);
  ALTER TABLE "TBL_TMPATTACHINFO" MODIFY ("OWNERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TMPATTACHINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_TMPEXPAPRDOCINFO
--------------------------------------------------------

  ALTER TABLE "TBL_TMPEXPAPRDOCINFO" ADD CONSTRAINT "PK_TBL_TMPEXPAPRDOCINFO" PRIMARY KEY ("COMPANYID", "TENANT_ID", "OWNERID", "SN")
  USING INDEX;
  ALTER TABLE "TBL_TMPEXPAPRDOCINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TMPEXPAPRDOCINFO" MODIFY ("SN" NOT NULL ENABLE);
  ALTER TABLE "TBL_TMPEXPAPRDOCINFO" MODIFY ("OWNERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TMPEXPAPRDOCINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_TMPEXPAPRLINE
--------------------------------------------------------

  ALTER TABLE "TBL_TMPEXPAPRLINE" ADD CONSTRAINT "TBL_TMPEXPAPRLINE_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "OWNERID", "SN", "APRMEMBERSN")
  USING INDEX;
  ALTER TABLE "TBL_TMPEXPAPRLINE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TMPEXPAPRLINE" MODIFY ("APRMEMBERSN" NOT NULL ENABLE);
  ALTER TABLE "TBL_TMPEXPAPRLINE" MODIFY ("SN" NOT NULL ENABLE);
  ALTER TABLE "TBL_TMPEXPAPRLINE" MODIFY ("OWNERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TMPEXPAPRLINE" MODIFY ("COMPANYID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_TMPRECEIPTPOINTINFO
--------------------------------------------------------

  ALTER TABLE "TBL_TMPRECEIPTPOINTINFO" ADD CONSTRAINT "TBL_TMPRECEIPTPOINTINFO_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "OWNERID", "SN", "RECEIPTPOINTID")
  USING INDEX;
  ALTER TABLE "TBL_TMPRECEIPTPOINTINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TMPRECEIPTPOINTINFO" MODIFY ("RECEIPTPOINTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TMPRECEIPTPOINTINFO" MODIFY ("SN" NOT NULL ENABLE);
  ALTER TABLE "TBL_TMPRECEIPTPOINTINFO" MODIFY ("OWNERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_TMPRECEIPTPOINTINFO" MODIFY ("COMPANYID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_USERCONT
--------------------------------------------------------

  ALTER TABLE "TBL_USERCONT" ADD CONSTRAINT "TBL_USERCONT_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "USERCONTID")
  USING INDEX;
  ALTER TABLE "TBL_USERCONT" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_USERCONT" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_USERCONT" MODIFY ("OWNUSERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_USERCONT" MODIFY ("USERCONTID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_USERCONTLIST
--------------------------------------------------------

  ALTER TABLE "TBL_USERCONTLIST" ADD CONSTRAINT "TBL_USERCONTLIST_PK" PRIMARY KEY ("TENANT_ID", "COMPANYID", "USERCONTID", "DOCID")
  USING INDEX;
  ALTER TABLE "TBL_USERCONTLIST" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_USERCONTLIST" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_USERCONTLIST" MODIFY ("USERCONTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_USERCONTLIST" MODIFY ("DOCID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_USERLOCALINFO
--------------------------------------------------------

  ALTER TABLE "TBL_USERLOCALINFO" MODIFY ("LANG" NOT NULL ENABLE);
  ALTER TABLE "TBL_USERLOCALINFO" MODIFY ("TIMEZONE" NOT NULL ENABLE);
  ALTER TABLE "TBL_USERLOCALINFO" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_USERLOCALINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_USERLOCALINFO" ADD CONSTRAINT "PK_TBL_USERLOCALINFO" PRIMARY KEY ("USERID", "TENANT_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_USERMASTER
--------------------------------------------------------

  ALTER TABLE "TBL_USERMASTER" MODIFY ("DISPLAYNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_USERMASTER" MODIFY ("CN" NOT NULL ENABLE);
  ALTER TABLE "TBL_USERMASTER" ADD CONSTRAINT "PK_TBL_USERMASTER" PRIMARY KEY ("TENANT_ID", "CN")
  USING INDEX;
  ALTER TABLE "TBL_USERMASTER" MODIFY ("UPDATEDT" NOT NULL ENABLE);
  ALTER TABLE "TBL_USERMASTER" MODIFY ("DEPARTMENT" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_USERMASTER_DELETE
--------------------------------------------------------

  ALTER TABLE "TBL_USERMASTER_DELETE" MODIFY ("CN" NOT NULL ENABLE);
  ALTER TABLE "TBL_USERMASTER_DELETE" MODIFY ("DISPLAYNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_USERMASTER_DELETE" MODIFY ("DEPARTMENT" NOT NULL ENABLE);
  ALTER TABLE "TBL_USERMASTER_DELETE" MODIFY ("UPDATEDT" NOT NULL ENABLE);
  ALTER TABLE "TBL_USERMASTER_DELETE" ADD CONSTRAINT "PK_TBL_USERMASTER_DELETE" PRIMARY KEY ("TENANT_ID", "CN")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_USERMASTER_RETIRE
--------------------------------------------------------

  ALTER TABLE "TBL_USERMASTER_RETIRE" ADD CONSTRAINT "PK_TBL_USERMASTER_RETIRE" PRIMARY KEY ("TENANT_ID", "CN")
  USING INDEX;
  ALTER TABLE "TBL_USERMASTER_RETIRE" MODIFY ("UPDATEDT" NOT NULL ENABLE);
  ALTER TABLE "TBL_USERMASTER_RETIRE" MODIFY ("DEPARTMENT" NOT NULL ENABLE);
  ALTER TABLE "TBL_USERMASTER_RETIRE" MODIFY ("DISPLAYNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_USERMASTER_RETIRE" MODIFY ("CN" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_USERMOBILEINFO
--------------------------------------------------------

  ALTER TABLE "TBL_USERMOBILEINFO" MODIFY ("USESECURITY" NOT NULL ENABLE);
  ALTER TABLE "TBL_USERMOBILEINFO" ADD CONSTRAINT "TBL_USERMOBILEINFO_PK" PRIMARY KEY ("USERID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_USERMOBILEINFO" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_USERMOBILEINFO" MODIFY ("LISTCNT" NOT NULL ENABLE);
  ALTER TABLE "TBL_USERMOBILEINFO" MODIFY ("MAINTYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_USERMOBILEINFO" MODIFY ("LANG" NOT NULL ENABLE);
  ALTER TABLE "TBL_USERMOBILEINFO" MODIFY ("TIMEZONE" NOT NULL ENABLE);
  ALTER TABLE "TBL_USERMOBILEINFO" MODIFY ("USERID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_USER_CONFIG
--------------------------------------------------------

  ALTER TABLE "TBL_USER_CONFIG" ADD CONSTRAINT "TBL_USER_CONFIG_PK" PRIMARY KEY ("TENANT_ID", "PROPERTY_NAME", "USER_ID")
  USING INDEX;
  ALTER TABLE "TBL_USER_CONFIG" MODIFY ("PROPERTY_NAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_USER_CONFIG" MODIFY ("USER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_USER_CONFIG" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_USER_JOBMASTER
--------------------------------------------------------

  ALTER TABLE "TBL_USER_JOBMASTER" ADD CONSTRAINT "TBL_USER_JOBMASTER_PK" PRIMARY KEY ("JOBID", "TYPE", "COMPANYID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_USER_JOBMASTER" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_USER_JOBMASTER" MODIFY ("COMPANYID" NOT NULL ENABLE);
  ALTER TABLE "TBL_USER_JOBMASTER" MODIFY ("TYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_USER_JOBMASTER" MODIFY ("JOBID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_USER_MULTILOGIN
--------------------------------------------------------

  ALTER TABLE "TBL_USER_MULTILOGIN" ADD CONSTRAINT "TBL_USER_MULTILOGIN_PK" PRIMARY KEY ("USER_ID", "MOBILE_FLAG", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_USER_MULTILOGIN" MODIFY ("LOGIN_TIME" NOT NULL ENABLE);
  ALTER TABLE "TBL_USER_MULTILOGIN" MODIFY ("MOBILE_FLAG" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_VOTE_ANSWER
--------------------------------------------------------

  ALTER TABLE "TBL_VOTE_ANSWER" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_ANSWER" MODIFY ("QST_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_ANSWER" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_ANSWER" MODIFY ("CONTENT" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_ANSWER" MODIFY ("VOTES_NUM" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_ANSWER" ADD PRIMARY KEY ("ID", "QST_ID", "TENANT_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_VOTE_COMMENT
--------------------------------------------------------

  ALTER TABLE "TBL_VOTE_COMMENT" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_COMMENT" MODIFY ("CMT_TIME" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_COMMENT" MODIFY ("QST_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_COMMENT" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_COMMENT" MODIFY ("USER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_COMMENT" MODIFY ("USER_NAME1" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_COMMENT" MODIFY ("USER_NAME2" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_VOTE_CONFIGURATION
--------------------------------------------------------

  ALTER TABLE "TBL_VOTE_CONFIGURATION" MODIFY ("USER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_CONFIGURATION" MODIFY ("START_TIME" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_CONFIGURATION" MODIFY ("END_TIME" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_CONFIGURATION" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_CONFIGURATION" ADD PRIMARY KEY ("USER_ID", "TENANT_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_VOTE_QUESTION
--------------------------------------------------------

  ALTER TABLE "TBL_VOTE_QUESTION" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_QUESTION" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_QUESTION" MODIFY ("MULTI_SELECT" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_QUESTION" MODIFY ("CREATE_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_QUESTION" MODIFY ("START_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_QUESTION" MODIFY ("END_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_QUESTION" MODIFY ("TARGET" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_QUESTION" MODIFY ("TITLE" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_QUESTION" MODIFY ("SECRET_VOTE" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_QUESTION" MODIFY ("CREATOR" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_QUESTION" MODIFY ("CREATOR_NAME1" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_QUESTION" MODIFY ("CREATOR_NAME2" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_QUESTION" MODIFY ("RESULT_FIRST" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_QUESTION" MODIFY ("IS_MODIFYING" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_QUESTION" MODIFY ("SET_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_QUESTION" MODIFY ("IS_SORTING" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_QUESTION" MODIFY ("IS_SELONLYONCE" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_QUESTION" MODIFY ("SENDPOSTNOTICE" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_QUESTION" MODIFY ("OPENTOALL" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_QUESTION" ADD PRIMARY KEY ("ID", "TENANT_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_VOTE_QUESTION_RELATED
--------------------------------------------------------

  ALTER TABLE "TBL_VOTE_QUESTION_RELATED" MODIFY ("USER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_QUESTION_RELATED" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_QUESTION_RELATED" MODIFY ("SEEN" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_QUESTION_RELATED" MODIFY ("COMMENT" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_QUESTION_RELATED" MODIFY ("HIDE" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_QUESTION_RELATED" MODIFY ("MODIFYING" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_QUESTION_RELATED" ADD PRIMARY KEY ("QST_ID", "USER_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_VOTE_QUESTION_RELATED" MODIFY ("QST_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_VOTE_USER_AND_ANSWER
--------------------------------------------------------

  ALTER TABLE "TBL_VOTE_USER_AND_ANSWER" MODIFY ("ANS_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_USER_AND_ANSWER" MODIFY ("QST_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_USER_AND_ANSWER" MODIFY ("USER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_USER_AND_ANSWER" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_USER_AND_ANSWER" MODIFY ("USER_NAME1" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_USER_AND_ANSWER" MODIFY ("USER_NAME2" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_USER_AND_ANSWER" MODIFY ("VOTE_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_USER_AND_ANSWER" ADD PRIMARY KEY ("ANS_ID", "QST_ID", "USER_ID", "TENANT_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_VOTE_USER_AND_QUESTION
--------------------------------------------------------

  ALTER TABLE "TBL_VOTE_USER_AND_QUESTION" MODIFY ("QST_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_USER_AND_QUESTION" MODIFY ("USER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_USER_AND_QUESTION" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_USER_AND_QUESTION" MODIFY ("USER_TYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_VOTE_USER_AND_QUESTION" ADD PRIMARY KEY ("QST_ID", "USER_ID", "TENANT_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_WEATHER
--------------------------------------------------------

  ALTER TABLE "TBL_WEATHER" ADD CONSTRAINT "TBL_WEATHER_PK" PRIMARY KEY ("CITYCODE")
  USING INDEX;
  ALTER TABLE "TBL_WEATHER" MODIFY ("PRIMARYLANG" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEATHER" MODIFY ("DISPLAYCITYNAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEATHER" MODIFY ("CITYCODE" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEATHER" MODIFY ("SN" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_WEATHER_USER
--------------------------------------------------------

  ALTER TABLE "TBL_WEATHER_USER" ADD CONSTRAINT "TBL_WEATHER_USER_PK" PRIMARY KEY ("USERID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_WEATHER_USER" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEATHER_USER" MODIFY ("USERID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_WEBFOLDER_APPLY_HISTORY
--------------------------------------------------------

  ALTER TABLE "TBL_WEBFOLDER_APPLY_HISTORY" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_APPLY_HISTORY" MODIFY ("FOLDER_NAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_APPLY_HISTORY" MODIFY ("APPLICATION_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_APPLY_HISTORY" ADD CONSTRAINT "PK2_TBL_WF_APPLY_HISTORY" PRIMARY KEY ("APPLY_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_WEBFOLDER_APPLY_HIST_MEM
--------------------------------------------------------

  ALTER TABLE "TBL_WEBFOLDER_APPLY_HIST_MEM" MODIFY ("MEMBER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_APPLY_HIST_MEM" MODIFY ("MEMBER_NAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_APPLY_HIST_MEM" MODIFY ("MEMBER_TYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_APPLY_HIST_MEM" MODIFY ("MEMBER_ITEM" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_APPLY_HIST_MEM" ADD CONSTRAINT "PK2_TBL_WF_APPLY_HIST_MEM" PRIMARY KEY ("APPLY_ID", "MEMBER_ID", "MEMBER_TYPE", "MEMBER_ITEM")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_WEBFOLDER_CONFIG
--------------------------------------------------------

  ALTER TABLE "TBL_WEBFOLDER_CONFIG" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_CONFIG" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_CONFIG" ADD PRIMARY KEY ("COMPANY_ID", "TENANT_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_WEBFOLDER_ENCRYPTED_FILE
--------------------------------------------------------

  ALTER TABLE "TBL_WEBFOLDER_ENCRYPTED_FILE" MODIFY ("FILE_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_ENCRYPTED_FILE" MODIFY ("VERSION" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_ENCRYPTED_FILE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_ENCRYPTED_FILE" ADD CONSTRAINT "WEBFOLDER_ENCRYPTED_FILE_PK" PRIMARY KEY ("FILE_ID", "VERSION", "TENANT_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_WEBFOLDER_ENC_FOLDER
--------------------------------------------------------

  ALTER TABLE "TBL_WEBFOLDER_ENC_FOLDER" MODIFY ("FOLDER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_ENC_FOLDER" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_ENC_FOLDER" ADD CONSTRAINT "WEBFOLDER_ENCRYPTION_FOLDER_PK" PRIMARY KEY ("FOLDER_ID", "TENANT_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_WEBFOLDER_ENV
--------------------------------------------------------

  ALTER TABLE "TBL_WEBFOLDER_ENV" MODIFY ("CN" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_ENV" MODIFY ("TENANT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TBL_WEBFOLDER_FAVOR
--------------------------------------------------------

  ALTER TABLE "TBL_WEBFOLDER_FAVOR" MODIFY ("TARGET_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FAVOR" MODIFY ("USER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FAVOR" MODIFY ("TARGET_TYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FAVOR" MODIFY ("CREATE_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FAVOR" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FAVOR" ADD CONSTRAINT "SYS_C0029179" PRIMARY KEY ("TENANT_ID", "USER_ID", "TARGET_ID", "TARGET_TYPE")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_WEBFOLDER_FILE
--------------------------------------------------------

  ALTER TABLE "TBL_WEBFOLDER_FILE" MODIFY ("FILE_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILE" MODIFY ("FILE_NAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILE" MODIFY ("FILE_PATH" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILE" MODIFY ("FILE_SIZE" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILE" MODIFY ("TYPE_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILE" MODIFY ("DOWN_COUNT" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILE" MODIFY ("FILE_EXT" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILE" MODIFY ("FOLDER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILE" MODIFY ("USE_STATUS" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILE" MODIFY ("CREATE_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILE" MODIFY ("CREATE_NAME1" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILE" MODIFY ("CREATE_NAME2" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILE" MODIFY ("CREATE_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILE" MODIFY ("UPDATE_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILE" MODIFY ("UPDATE_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILE" MODIFY ("VERSION" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILE" MODIFY ("DEPTH" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILE" ADD CONSTRAINT "PK_TBL_WEBFOLDER_FILE" PRIMARY KEY ("TENANT_ID", "FILE_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_WEBFOLDER_FILETYPE
--------------------------------------------------------

  ALTER TABLE "TBL_WEBFOLDER_FILETYPE" MODIFY ("TYPE_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILETYPE" MODIFY ("TYPE_NAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILETYPE" MODIFY ("FILE_EXT" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILETYPE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILETYPE" ADD PRIMARY KEY ("FILE_EXT", "TENANT_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_WEBFOLDER_FILEUSER
--------------------------------------------------------

  ALTER TABLE "TBL_WEBFOLDER_FILEUSER" MODIFY ("SEQ_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILEUSER" MODIFY ("FILE_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILEUSER" MODIFY ("USER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILEUSER" MODIFY ("USER_TYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILEUSER" MODIFY ("CREATE_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILEUSER" MODIFY ("CREATE_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILEUSER" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILEUSER" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILEUSER" ADD PRIMARY KEY ("SEQ_ID", "TENANT_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_WEBFOLDER_FILE_HISTORY
--------------------------------------------------------

  ALTER TABLE "TBL_WEBFOLDER_FILE_HISTORY" MODIFY ("FILE_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILE_HISTORY" MODIFY ("VERSION" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILE_HISTORY" MODIFY ("FILE_PATH" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILE_HISTORY" MODIFY ("FILE_SIZE" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILE_HISTORY" MODIFY ("USE_STATUS" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILE_HISTORY" MODIFY ("UPDATE_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILE_HISTORY" MODIFY ("UPDATE_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILE_HISTORY" MODIFY ("UPDATE_NAME" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILE_HISTORY" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FILE_HISTORY" ADD CONSTRAINT "TBL_WEBFOLDER_FILE_HISTORY" PRIMARY KEY ("FILE_ID", "VERSION", "TENANT_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_WEBFOLDER_FOLDER
--------------------------------------------------------

  ALTER TABLE "TBL_WEBFOLDER_FOLDER" MODIFY ("FOLDER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FOLDER" MODIFY ("FOLDER_NAME1" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FOLDER" MODIFY ("FOLDER_TYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FOLDER" MODIFY ("FOLDER_STEP" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FOLDER" MODIFY ("FOLDER_LEVEL" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FOLDER" MODIFY ("CREATE_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FOLDER" MODIFY ("CREATE_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FOLDER" MODIFY ("CREATE_NAME1" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FOLDER" MODIFY ("CREATE_NAME2" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FOLDER" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FOLDER" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FOLDER" ADD PRIMARY KEY ("TENANT_ID", "FOLDER_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_WEBFOLDER_FOLDERUSER
--------------------------------------------------------

  ALTER TABLE "TBL_WEBFOLDER_FOLDERUSER" MODIFY ("SEQ_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FOLDERUSER" MODIFY ("USER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FOLDERUSER" MODIFY ("USER_TYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FOLDERUSER" MODIFY ("FOLDER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FOLDERUSER" MODIFY ("CREATE_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FOLDERUSER" MODIFY ("CREATE_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FOLDERUSER" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FOLDERUSER" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_FOLDERUSER" ADD PRIMARY KEY ("SEQ_ID", "TENANT_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_WEBFOLDER_LOG
--------------------------------------------------------

  ALTER TABLE "TBL_WEBFOLDER_LOG" MODIFY ("LOG_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_LOG" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_LOG" ADD CONSTRAINT "PK_TBL_WEBFOLDER_LOG" PRIMARY KEY ("TENANT_ID", "LOG_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_WEBFOLDER_SHARE
--------------------------------------------------------

  ALTER TABLE "TBL_WEBFOLDER_SHARE" MODIFY ("SHARE_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_SHARE" MODIFY ("SHARER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_SHARE" MODIFY ("SHARER_NAME1" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_SHARE" MODIFY ("SHARER_NAME2" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_SHARE" MODIFY ("FOLDERFILE_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_SHARE" MODIFY ("FOLDERFILE_TYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_SHARE" MODIFY ("SHARE_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_SHARE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_SHARE" ADD CONSTRAINT "TBL_WEBFOLDER_SHARE_UK1" UNIQUE ("FOLDERFILE_ID", "FOLDERFILE_TYPE", "SHARER_ID", "TENANT_ID")
  USING INDEX;
  ALTER TABLE "TBL_WEBFOLDER_SHARE" ADD CONSTRAINT "TBL_WEBFOLDER_SHARE_PK" PRIMARY KEY ("SHARE_ID", "TENANT_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_WEBFOLDER_SHARE_HIDE
--------------------------------------------------------

  ALTER TABLE "TBL_WEBFOLDER_SHARE_HIDE" MODIFY ("SEQ_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_SHARE_HIDE" MODIFY ("SHARE_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_SHARE_HIDE" MODIFY ("USER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_SHARE_HIDE" MODIFY ("USER_NAME1" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_SHARE_HIDE" MODIFY ("USER_NAME2" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_SHARE_HIDE" MODIFY ("HIDE_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_SHARE_HIDE" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_SHARE_HIDE" ADD CONSTRAINT "TBL_WEBFOLDER_SHARE_HIDE_PK" PRIMARY KEY ("SEQ_ID", "TENANT_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_WEBFOLDER_SHARE_SUB
--------------------------------------------------------

  ALTER TABLE "TBL_WEBFOLDER_SHARE_SUB" MODIFY ("SEQ_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_SHARE_SUB" MODIFY ("SHARE_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_SHARE_SUB" MODIFY ("USER_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_SHARE_SUB" MODIFY ("USER_NAME1" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_SHARE_SUB" MODIFY ("USER_NAME2" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_SHARE_SUB" MODIFY ("USER_TYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_SHARE_SUB" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_SHARE_SUB" ADD CONSTRAINT "TBL_WEBFOLDER_PK" PRIMARY KEY ("SEQ_ID", "TENANT_ID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_WEBFOLDER_TOKEN
--------------------------------------------------------

  ALTER TABLE "TBL_WEBFOLDER_TOKEN" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_TOKEN" MODIFY ("TENANTID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_TOKEN" ADD PRIMARY KEY ("USERID", "TENANTID")
  USING INDEX;
--------------------------------------------------------
--  Constraints for Table TBL_WEBFOLDER_USER
--------------------------------------------------------

  ALTER TABLE "TBL_WEBFOLDER_USER" MODIFY ("CN" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_USER" MODIFY ("COMPANY_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_USER" MODIFY ("TENANT_ID" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_USER" MODIFY ("TYPE" NOT NULL ENABLE);
  ALTER TABLE "TBL_WEBFOLDER_USER" ADD PRIMARY KEY ("CN", "TENANT_ID", "TYPE")
  USING INDEX;
-------------------------------------------------------- 
--  Constraints for Table JMOCHA_USER_MAIL_TEMPLATE
--------------------------------------------------------

  ALTER TABLE "JMOCHA_USER_MAIL_TEMPLATE" MODIFY ("USER_ID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_USER_MAIL_TEMPLATE" MODIFY ("DISPLAYNAME" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_USER_MAIL_TEMPLATE" MODIFY ("TEMPLATE_ID" NOT NULL ENABLE);
  ALTER TABLE "JMOCHA_USER_MAIL_TEMPLATE" ADD CONSTRAINT "JMOCHA_USER_MAIL_TEMPLATE_PK" PRIMARY KEY ("USER_ID", "DISPLAYNAME")
  USING INDEX;  
-------------------------------------------------------- 
--  Constraints for Table JMOCHA_USER_MAIL_TEMPLATE
--------------------------------------------------------

  ALTER TABLE "JMOCHA_MAILBOX_PROGRESS" ADD CONSTRAINT "JMOCHA_MAILBOX_PROGRESS_PK" PRIMARY KEY ("USER_KEY", "TENANT_ID")
  USING INDEX; 
-------------------------------------------------------- 
--  Constraints for Table JMOCHA_APPR_ALLOWED_DOMAIN
--------------------------------------------------------

  ALTER TABLE "JMOCHA_APPR_ALLOWED_DOMAIN" ADD CONSTRAINT "JMOCHA_APPR_ALLOWED_DOMAIN_PK" PRIMARY KEY ("COMPANY_ID", "TENANT_ID", "DOMAIN_NAME")
  USING INDEX; 
-------------------------------------------------------- 
--  Constraints for Table JMOCHA_APPR_USER
--------------------------------------------------------

  ALTER TABLE "JMOCHA_APPR_USER" ADD CONSTRAINT "JMOCHA_APPR_USER_PK" PRIMARY KEY ("COMPANY_ID", "TENANT_ID", "USER_ID", "USER_TYPE")
  USING INDEX; 
--------------------------------------------------------
--  Ref Constraints for Table TBL_WEBFOLDER_SHARE_HIDE
--------------------------------------------------------

  ALTER TABLE "TBL_WEBFOLDER_SHARE_HIDE" ADD CONSTRAINT "TBL_WEBFOLDER_SHARE_HIDE_FK1" FOREIGN KEY ("SHARE_ID", "TENANT_ID")
	  REFERENCES "TBL_WEBFOLDER_SHARE" ("SHARE_ID", "TENANT_ID") ON DELETE CASCADE ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_WEBFOLDER_SHARE_SUB
--------------------------------------------------------

  ALTER TABLE "TBL_WEBFOLDER_SHARE_SUB" ADD CONSTRAINT "TBL_WEBFOLDER_SHARE_SUB_FK1" FOREIGN KEY ("SHARE_ID", "TENANT_ID")
	  REFERENCES "TBL_WEBFOLDER_SHARE" ("SHARE_ID", "TENANT_ID") ON DELETE CASCADE ENABLE;

--------------------------------------------------------
--  Ref Constraints for Table JAMES_MAIL
--------------------------------------------------------

  ALTER TABLE "JAMES_MAIL" ADD FOREIGN KEY ("MAILBOX_ID")
	  REFERENCES "JAMES_MAILBOX" ("MAILBOX_ID") ON DELETE CASCADE DEFERRABLE;
--------------------------------------------------------
--  Ref Constraints for Table JAMES_MAIL_PROPERTY
--------------------------------------------------------

--------------------------------------------------------
--  Ref Constraints for Table JAMES_MAIL_SEARCH
--------------------------------------------------------

--------------------------------------------------------
--  Ref Constraints for Table JAMES_MAIL_USERFLAG
--------------------------------------------------------

--------------------------------------------------------
--  Ref Constraints for Table JMOCHA_DISTRIBUTION
--------------------------------------------------------

  ALTER TABLE "JMOCHA_DISTRIBUTION" ADD CONSTRAINT "FK_JMOCHA_DISTRIBUTION" FOREIGN KEY ("DOMAIN_NAME", "USER_NAME")
	  REFERENCES "JAMES_RECIPIENT_REWRITE" ("DOMAIN_NAME", "USER_NAME") ON DELETE CASCADE ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table JMOCHA_DISTRIBUTION_SUB
--------------------------------------------------------

  ALTER TABLE "JMOCHA_DISTRIBUTION_SUB" ADD CONSTRAINT "FK_DISTRIBUTION_SUB" FOREIGN KEY ("DOMAIN_NAME", "USER_NAME")
	  REFERENCES "JMOCHA_DISTRIBUTION" ("DOMAIN_NAME", "USER_NAME") ON DELETE CASCADE ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table JMOCHA_INBOX_RULE_SUB
--------------------------------------------------------

  ALTER TABLE "JMOCHA_INBOX_RULE_SUB" ADD CONSTRAINT "RULE_ID" FOREIGN KEY ("RULE_ID")
	  REFERENCES "JMOCHA_INBOX_RULE" ("RULE_ID") ON DELETE CASCADE ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table JMOCHA_MAIL_OUTOFOFFICE_SENT
--------------------------------------------------------

  ALTER TABLE "JMOCHA_MAIL_OUTOFOFFICE_SENT" ADD CONSTRAINT "FK_JMOCHA_OUTOFOFFICE_SENT" FOREIGN KEY ("USER_ID")
	  REFERENCES "JMOCHA_MAIL_OUTOFOFFICE" ("USER_ID") ON DELETE CASCADE ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table JMOCHA_MAIL_POP3_LIST
--------------------------------------------------------

  ALTER TABLE "JMOCHA_MAIL_POP3_LIST" ADD CONSTRAINT "POP3_LIST_FOREIGN_KEY" FOREIGN KEY ("POP3_IDX")
	  REFERENCES "JMOCHA_MAIL_POP3" ("POP3_IDX") ON DELETE CASCADE ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table JMOCHA_MAIL_RECALL_DETAIL
--------------------------------------------------------

  ALTER TABLE "JMOCHA_MAIL_RECALL_DETAIL" ADD CONSTRAINT "RECALL_FOREIGN_KEY" FOREIGN KEY ("RECALL_IDX")
	  REFERENCES "JMOCHA_MAIL_RECALL" ("RECALL_IDX") ON DELETE CASCADE ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table JMOCHA_MAIL_SECURE
--------------------------------------------------------

--------------------------------------------------------
--  Ref Constraints for Table JMOCHA_MAIL_SECURE_READ
--------------------------------------------------------

  ALTER TABLE "JMOCHA_MAIL_SECURE_READ" ADD CONSTRAINT "FK_JMOCHA_MAIL_SECURE_READ" FOREIGN KEY ("SECURE_ID")
	  REFERENCES "JMOCHA_MAIL_SECURE" ("SECURE_ID") ON DELETE CASCADE ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table JMOCHA_TENANT_CONFIG
--------------------------------------------------------

  ALTER TABLE "JMOCHA_TENANT_CONFIG" ADD CONSTRAINT "FK_TENANT_ID" FOREIGN KEY ("TENANT_ID")
	  REFERENCES "JMOCHA_TENANT" ("TENANT_ID") ON DELETE CASCADE ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table JMOCHA_TENANT_SERVERNAME
--------------------------------------------------------

  ALTER TABLE "JMOCHA_TENANT_SERVERNAME" ADD CONSTRAINT "TENANT_ID" FOREIGN KEY ("TENANT_ID")
	  REFERENCES "JMOCHA_TENANT" ("TENANT_ID") ON DELETE CASCADE ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_AUDIO_VISUALRECEXINFO
--------------------------------------------------------

  ALTER TABLE "TBL_AUDIO_VISUALRECEXINFO" ADD CONSTRAINT "TBL_AUDIO_VISUALRECEXINFO_FK1" FOREIGN KEY ("TENANT_ID", "COMPANYID", "RECORDID", "SEPERATEATTACHNO")
	  REFERENCES "TBL_SEPERATEATTACH" ("TENANT_ID", "COMPANYID", "RECORDID", "SEPERATEATTACHNO") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_CABINET
--------------------------------------------------------

  ALTER TABLE "TBL_CABINET" ADD CONSTRAINT "TBL_CABINET_FK1" FOREIGN KEY ("TENANT_ID", "CABINETCLASSNO", "COMPANYID")
	  REFERENCES "TBL_CABINETCLASS" ("TENANT_ID", "CABINETCLASSNO", "COMPANYID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_CABINETHISTORY
--------------------------------------------------------

  ALTER TABLE "TBL_CABINETHISTORY" ADD CONSTRAINT "TBL_CABINETHISTORY_FK1" FOREIGN KEY ("TENANT_ID", "CABINETCLASSNO", "COMPANYID")
	  REFERENCES "TBL_CABINETCLASS" ("TENANT_ID", "CABINETCLASSNO", "COMPANYID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_CABINET_VIEWAUTH
--------------------------------------------------------

  ALTER TABLE "TBL_CABINET_VIEWAUTH" ADD CONSTRAINT "TBL_CABINET_VIEWAUTH_FK1" FOREIGN KEY ("TENANT_ID", "CABINETID", "COMPANYID")
	  REFERENCES "TBL_CABINET" ("TENANT_ID", "CABINETID", "COMPANYID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_CABROLEINFO
--------------------------------------------------------

  ALTER TABLE "TBL_CABROLEINFO" ADD CONSTRAINT "TBL_CABROLEINFO_FK1" FOREIGN KEY ("TENANT_ID", "CABINETCLASSNO", "COMPANYID")
	  REFERENCES "TBL_CABINETCLASS" ("TENANT_ID", "CABINETCLASSNO", "COMPANYID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_C_POLLRESPONSE
--------------------------------------------------------

  ALTER TABLE "TBL_C_POLLRESPONSE" ADD CONSTRAINT "FK_TBL_C_POLLRESPONSE1" FOREIGN KEY ("TENANT_ID", "QUESTIONID")
	  REFERENCES "TBL_C_POLLQUESTION" ("TENANT_ID", "QUESTIONID") ENABLE;
  ALTER TABLE "TBL_C_POLLRESPONSE" ADD CONSTRAINT "FK_TBL_C_POLLRESPONSE2" FOREIGN KEY ("TENANT_ID", "ANSWERID")
	  REFERENCES "TBL_C_POLLANSWER" ("TENANT_ID", "ANSWERID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_DEPTCONTLIST
--------------------------------------------------------

  ALTER TABLE "TBL_DEPTCONTLIST" ADD CONSTRAINT "FK_TBL_DEPTCONTLIST" FOREIGN KEY ("TENANT_ID", "DEPTCONTID")
	  REFERENCES "TBL_DEPTCONT" ("TENANT_ID", "DEPTCONTID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_FORM_OFFICE
--------------------------------------------------------

  ALTER TABLE "TBL_FORM_OFFICE" ADD CONSTRAINT "TBL_FORM_OFFICE_FK1" FOREIGN KEY ("TENANT_ID", "COMPANYID", "FORMID")
	  REFERENCES "TBL_FORMINFO" ("TENANT_ID", "COMPANYID", "FORMID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_JOURNAL_FILE
--------------------------------------------------------

  ALTER TABLE "TBL_JOURNAL_FILE" ADD CONSTRAINT "FK_TBL_JOURNAL_FILE" FOREIGN KEY ("JOURNAL_ID", "TENANT_ID")
	  REFERENCES "TBL_JOURNAL" ("JOURNAL_ID", "TENANT_ID") ON DELETE CASCADE ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_JOURNAL_FORM
--------------------------------------------------------

  ALTER TABLE "TBL_JOURNAL_FORM" ADD CONSTRAINT "FK_TBL_JOURNAL_FORM" FOREIGN KEY ("TYPE_ID", "TENANT_ID", "COMPANY_ID")
	  REFERENCES "TBL_JOURNAL_FORM_TYPE" ("TYPE_ID", "TENANT_ID", "COMPANY_ID") ON DELETE CASCADE DISABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_JOURNAL_FORM_USE_DEPT
--------------------------------------------------------

  ALTER TABLE "TBL_JOURNAL_FORM_USE_DEPT" ADD CONSTRAINT "FK_TBL_JOURNAL_FORM_USE_DEPT" FOREIGN KEY ("FORM_ID", "TENANT_ID")
	  REFERENCES "TBL_JOURNAL_FORM" ("FORM_ID", "TENANT_ID") ON DELETE CASCADE ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_JOURNAL_RECV
--------------------------------------------------------

  ALTER TABLE "TBL_JOURNAL_RECV" ADD CONSTRAINT "FK_TBL_JOURNAL_RECV" FOREIGN KEY ("JOURNAL_ID", "TENANT_ID")
	  REFERENCES "TBL_JOURNAL" ("JOURNAL_ID", "TENANT_ID") ON DELETE CASCADE ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_JOURNAL_RECV_FAVORITE_LIST
--------------------------------------------------------

  ALTER TABLE "TBL_JOURNAL_RECV_FAVORITE_LIST" ADD CONSTRAINT "FK_TBL_JOURNAL_RECV_FAVOR_LIST" FOREIGN KEY ("TENANT_ID", "FAVORITE_ID")
	  REFERENCES "TBL_JOURNAL_RECV_FAVORITE" ("TENANT_ID", "FAVORITE_ID") ON DELETE CASCADE ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_JOURNAL_REPLY
--------------------------------------------------------

  ALTER TABLE "TBL_JOURNAL_REPLY" ADD CONSTRAINT "FK_TBL_JOURNAL_REPLY" FOREIGN KEY ("JOURNAL_ID", "TENANT_ID")
	  REFERENCES "TBL_JOURNAL" ("JOURNAL_ID", "TENANT_ID") ON DELETE CASCADE ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_JOURNAL_VIEW
--------------------------------------------------------

  ALTER TABLE "TBL_JOURNAL_VIEW" ADD CONSTRAINT "FK_TBL_JOURNAL_VIEW" FOREIGN KEY ("JOURNAL_ID", "TENANT_ID")
	  REFERENCES "TBL_JOURNAL" ("JOURNAL_ID", "TENANT_ID") ON DELETE CASCADE ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_LADDER_COMMENT
--------------------------------------------------------

  ALTER TABLE "TBL_LADDER_COMMENT" ADD FOREIGN KEY ("LADDERID", "TENANT_ID")
	  REFERENCES "TBL_LADDER" ("LADDERID", "TENANT_ID") ON DELETE CASCADE DEFERRABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_LADDER_LINE
--------------------------------------------------------

  ALTER TABLE "TBL_LADDER_LINE" ADD FOREIGN KEY ("LADDERID", "TENANT_ID")
	  REFERENCES "TBL_LADDER" ("LADDERID", "TENANT_ID") ON DELETE CASCADE DEFERRABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_LADDER_ORDER
--------------------------------------------------------

  ALTER TABLE "TBL_LADDER_ORDER" ADD FOREIGN KEY ("LADDERID", "TENANT_ID")
	  REFERENCES "TBL_LADDER" ("LADDERID", "TENANT_ID") ON DELETE CASCADE DEFERRABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_MEMO
--------------------------------------------------------

  ALTER TABLE "TBL_MEMO" ADD CONSTRAINT "FK_MEMO" FOREIGN KEY ("FOLDER_ID", "COMPANY_ID", "TENANT_ID")
	  REFERENCES "TBL_MEMO_FOLDER" ("FOLDER_ID", "COMPANY_ID", "TENANT_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_OLDCABINETEXTRAINFO
--------------------------------------------------------

  ALTER TABLE "TBL_OLDCABINETEXTRAINFO" ADD CONSTRAINT "TBL_OLDCABINETEXTRAINFO_FK1" FOREIGN KEY ("TENANT_ID", "CABINETCLASSNO", "COMPANYID")
	  REFERENCES "TBL_CABINETCLASS" ("TENANT_ID", "CABINETCLASSNO", "COMPANYID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_OLDRECORDEXTRAINFO
--------------------------------------------------------

  ALTER TABLE "TBL_OLDRECORDEXTRAINFO" ADD CONSTRAINT "TBL_OLDRECORDEXTRAINFO_FK1" FOREIGN KEY ("TENANT_ID", "COMPANYID", "RECORDID")
	  REFERENCES "TBL_RECORD" ("TENANT_ID", "COMPANYID", "RECORDID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_PORTAL_FRAME
--------------------------------------------------------

  ALTER TABLE "TBL_PORTAL_FRAME" ADD CONSTRAINT "FK_TBL_PORTAL_FRAME_THEME_ID_T" FOREIGN KEY ("THEME_ID")
	  REFERENCES "TBL_PORTAL_THEME" ("THEME_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_PORTAL_FRAME_COMP
--------------------------------------------------------

  ALTER TABLE "TBL_PORTAL_FRAME_COMP" ADD CONSTRAINT "FK_TBL_PORTAL_FRAME_COMP_FRAME" FOREIGN KEY ("FRAME_ID")
	  REFERENCES "TBL_PORTAL_FRAME" ("FRAME_ID") ENABLE;
  ALTER TABLE "TBL_PORTAL_FRAME_COMP" ADD CONSTRAINT "FK_TBL_PORTAL_FRAME_COMP_THEME" FOREIGN KEY ("THEME_ID")
	  REFERENCES "TBL_PORTAL_THEME" ("THEME_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_PORTAL_MENU_COMP
--------------------------------------------------------

  ALTER TABLE "TBL_PORTAL_MENU_COMP" ADD CONSTRAINT "FK_TBL_PORTAL_MENU_COMP_MENU_I" FOREIGN KEY ("MENU_ID")
	  REFERENCES "TBL_PORTAL_MENU" ("MENU_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_PORTAL_MENU_NAME
--------------------------------------------------------

  ALTER TABLE "TBL_PORTAL_MENU_NAME" ADD CONSTRAINT "FK_TBL_PORTAL_MENU_NAME_MENU_I" FOREIGN KEY ("MENU_ID")
	  REFERENCES "TBL_PORTAL_MENU" ("MENU_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_PORTAL_MENU_USER
--------------------------------------------------------

  ALTER TABLE "TBL_PORTAL_MENU_USER" ADD CONSTRAINT "FK_TBL_PORTAL_MENU_USER_MENU_I" FOREIGN KEY ("MENU_ID")
	  REFERENCES "TBL_PORTAL_MENU" ("MENU_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_PORTAL_PORTLET
--------------------------------------------------------

  ALTER TABLE "TBL_PORTAL_PORTLET" ADD CONSTRAINT "FK_TBL_PORTAL_PORTLET_MENU_ID_" FOREIGN KEY ("MENU_ID")
	  REFERENCES "TBL_PORTAL_MENU" ("MENU_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_PORTAL_STARTPAGE
--------------------------------------------------------

  ALTER TABLE "TBL_PORTAL_STARTPAGE" ADD CONSTRAINT "FK_TBL_PORTAL_STARTPAGE_MENU_I" FOREIGN KEY ("MENU_ID")
	  REFERENCES "TBL_PORTAL_MENU" ("MENU_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_PORTAL_THEME_COMP
--------------------------------------------------------

  ALTER TABLE "TBL_PORTAL_THEME_COMP" ADD CONSTRAINT "FK_TBL_PORTAL_THEME_COMP_THEME" FOREIGN KEY ("THEME_ID")
	  REFERENCES "TBL_PORTAL_THEME" ("THEME_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_PORTAL_THEME_USER
--------------------------------------------------------

  ALTER TABLE "TBL_PORTAL_THEME_USER" ADD CONSTRAINT "FK_TBL_PORTAL_THEME_USER_USED_" FOREIGN KEY ("USED_THEME")
	  REFERENCES "TBL_PORTAL_THEME" ("THEME_ID") ENABLE;
  ALTER TABLE "TBL_PORTAL_THEME_USER" ADD CONSTRAINT "FK_TBL_THEME_USER_USED_FRAME" FOREIGN KEY ("USED_FRAME")
	  REFERENCES "TBL_PORTAL_FRAME" ("FRAME_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_RECORDHISTORY
--------------------------------------------------------

  ALTER TABLE "TBL_RECORDHISTORY" ADD CONSTRAINT "TBL_RECORDHISTORY_FK1" FOREIGN KEY ("TENANT_ID", "COMPANYID", "RECORDID", "SEPERATEATTACHNO")
	  REFERENCES "TBL_SEPERATEATTACH" ("TENANT_ID", "COMPANYID", "RECORDID", "SEPERATEATTACHNO") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_SEPERATEATTACH
--------------------------------------------------------

  ALTER TABLE "TBL_SEPERATEATTACH" ADD CONSTRAINT "TBL_SEPERATEATTACH_FK1" FOREIGN KEY ("TENANT_ID", "CABINETID", "COMPANYID")
	  REFERENCES "TBL_CABINET" ("TENANT_ID", "CABINETID", "COMPANYID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_SPECIALCATALOGINFO_CAB
--------------------------------------------------------

  ALTER TABLE "TBL_SPECIALCATALOGINFO_CAB" ADD CONSTRAINT "TBL_SPECIALCATALOGINFO_CA_FK1" FOREIGN KEY ("TENANT_ID", "CABINETCLASSNO", "COMPANYID")
	  REFERENCES "TBL_CABINETCLASS" ("TENANT_ID", "CABINETCLASSNO", "COMPANYID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_SPECIALCATALOGINFO_REC
--------------------------------------------------------

  ALTER TABLE "TBL_SPECIALCATALOGINFO_REC" ADD CONSTRAINT "TBL_SPECIALCATALOGINFO_RE_FK1" FOREIGN KEY ("TENANT_ID", "COMPANYID", "RECORDID")
	  REFERENCES "TBL_RECORD" ("TENANT_ID", "COMPANYID", "RECORDID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_SURVEY_ATTACHFILE
--------------------------------------------------------

  ALTER TABLE "TBL_SURVEY_ATTACHFILE" ADD CONSTRAINT "FK_SURVEY_ATTACHFILE" FOREIGN KEY ("SURVEY_ID", "COMPANY_ID", "TENANT_ID")
	  REFERENCES "TBL_SURVEY" ("SURVEY_ID", "COMPANY_ID", "TENANT_ID") ON DELETE CASCADE ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_SURVEY_OPTION
--------------------------------------------------------

  ALTER TABLE "TBL_SURVEY_OPTION" ADD CONSTRAINT "FK_SURVEY_OPTION_QUEESTION" FOREIGN KEY ("QUESTION_ID", "COMPANY_ID", "TENANT_ID")
	  REFERENCES "TBL_SURVEY_QUESTION" ("QUESTION_ID", "COMPANY_ID", "TENANT_ID") ON DELETE CASCADE ENABLE;
  ALTER TABLE "TBL_SURVEY_OPTION" ADD CONSTRAINT "FK_SURVEY_OPTION_SURVEY" FOREIGN KEY ("SURVEY_ID", "COMPANY_ID", "TENANT_ID")
	  REFERENCES "TBL_SURVEY" ("SURVEY_ID", "COMPANY_ID", "TENANT_ID") ON DELETE CASCADE ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_SURVEY_PARTICIPANT
--------------------------------------------------------

  ALTER TABLE "TBL_SURVEY_PARTICIPANT" ADD CONSTRAINT "FK_SURVEY_PARTICIPANT" FOREIGN KEY ("SURVEY_ID", "COMPANY_ID", "TENANT_ID")
	  REFERENCES "TBL_SURVEY" ("SURVEY_ID", "COMPANY_ID", "TENANT_ID") ON DELETE CASCADE ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_SURVEY_QUESTION
--------------------------------------------------------

  ALTER TABLE "TBL_SURVEY_QUESTION" ADD CONSTRAINT "FK_SURVEY_QUESTION" FOREIGN KEY ("SURVEY_ID", "COMPANY_ID", "TENANT_ID")
	  REFERENCES "TBL_SURVEY" ("SURVEY_ID", "COMPANY_ID", "TENANT_ID") ON DELETE CASCADE ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_SURVEY_RESPONDENT
--------------------------------------------------------

  ALTER TABLE "TBL_SURVEY_RESPONDENT" ADD CONSTRAINT "FK_SURVEY_RESPONDENT_RESPONSE" FOREIGN KEY ("RESPONSE_ID", "COMPANY_ID", "TENANT_ID")
	  REFERENCES "TBL_SURVEY_RESPONSE" ("RESPONSE_ID", "COMPANY_ID", "TENANT_ID") ON DELETE CASCADE ENABLE;
  ALTER TABLE "TBL_SURVEY_RESPONDENT" ADD CONSTRAINT "FK_SURVEY_RESPONDENT_SURVEY" FOREIGN KEY ("SURVEY_ID", "COMPANY_ID", "TENANT_ID")
	  REFERENCES "TBL_SURVEY" ("SURVEY_ID", "COMPANY_ID", "TENANT_ID") ON DELETE CASCADE ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_SURVEY_RESPONSE
--------------------------------------------------------

  ALTER TABLE "TBL_SURVEY_RESPONSE" ADD CONSTRAINT "FK_SURVEY_RESPONSE" FOREIGN KEY ("SURVEY_ID", "COMPANY_ID", "TENANT_ID")
	  REFERENCES "TBL_SURVEY" ("SURVEY_ID", "COMPANY_ID", "TENANT_ID") ON DELETE CASCADE ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_TASKCODE
--------------------------------------------------------

  ALTER TABLE "TBL_TASKCODE" ADD CONSTRAINT "TBL_TASKCODE_FK1" FOREIGN KEY ("TENANT_ID", "SUBCATEGORYCODE", "COMPANYID")
	  REFERENCES "TBL_TASKSUBCATEGORY" ("TENANT_ID", "SUBCATEGORYCODE", "COMPANYID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_TASKMIDDLECATEGORY
--------------------------------------------------------

  ALTER TABLE "TBL_TASKMIDDLECATEGORY" ADD CONSTRAINT "TBL_TASKMIDDLECATEGORY_FK1" FOREIGN KEY ("TENANT_ID", "CATEGORYCODE", "COMPANYID")
	  REFERENCES "TBL_TASKCATEGORY" ("TENANT_ID", "CATEGORYCODE", "COMPANYID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_TASKSUBCATEGORY
--------------------------------------------------------

  ALTER TABLE "TBL_TASKSUBCATEGORY" ADD CONSTRAINT "TBL_TASKSUBCATEGORY_FK1" FOREIGN KEY ("TENANT_ID", "MCATEGORYCODE", "COMPANYID")
	  REFERENCES "TBL_TASKMIDDLECATEGORY" ("TENANT_ID", "MCATEGORYCODE", "COMPANYID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_TENANT_CONFIG
--------------------------------------------------------

  ALTER TABLE "TBL_TENANT_CONFIG" ADD CONSTRAINT "FK_TBLTENANT_CONFIG_TENANT_ID" FOREIGN KEY ("TENANT_ID")
	  REFERENCES "TBL_TENANT" ("TENANT_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_TENANT_SERVERNAME
--------------------------------------------------------

  ALTER TABLE "TBL_TENANT_SERVERNAME" ADD CONSTRAINT "FK_TBLTENANT_SN_TENANT_ID" FOREIGN KEY ("TENANT_ID")
	  REFERENCES "TBL_TENANT" ("TENANT_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TBL_USER_NOTI_DISABLE_ITEM
--------------------------------------------------------

  ALTER TABLE "TBL_USER_NOTI_DISABLE_ITEM" ADD CONSTRAINT "FK_TBL_USER_NOTI_DISABLE_ITEM" FOREIGN KEY ("TENANT_ID", "USER_ID")
	  REFERENCES "TBL_USERMASTER" ("TENANT_ID", "CN") ON DELETE CASCADE ENABLE;
	  
--------------------------------------------------------
--  VIEW_EZAPPROVALG
--------------------------------------------------------

CREATE OR REPLACE VIEW "VIEW_EZAPPROVALG"
(DOCID,DOCNO,DOCTITLE,WRITERDEPTNAME,WRITERDEPTNAME2,WRITERNAME,WRITERNAME2,STARTDATE,ENDDATE,HASATTACHYN,CONTENTSPATH,HREF,FORMID,FORMNAME,FORMNAME2,CONTAINERID,KEYWORD,WRITERDEPTID,TENANT_ID,COMPANYID)
AS
SELECT  
        a.DOCID AS docid, 
        a.DOCNO AS docno, 
        a.DOCTITLE AS doctitle, 
        a.WRITERDEPTNAME AS writerdeptname, 
        a.WRITERDEPTNAME2 AS writerdeptname2, 
        a.WRITERNAME AS writername, 
        a.WRITERNAME2 AS writername2, 
        a.STARTDATE AS StartDate, 
        a.ENDDATE AS EndDate, 
        a.HASATTACHYN AS hasattachyn, 
        CONCAT('/volumes/shared/ezFlow', a.HREF) AS ContentsPath, 
        a.HREF AS href, 
        a.FORMID AS formid, 
        d.FORMNAME AS formname, 
        d.FORMNAME2 AS formname2, 
        a.CONTAINERID AS containerid, 
        NVL(x.KEYWORD, '') AS KeyWord, 
        e.APRMEMBERDEPTID AS WriterDeptID, 
        a.TENANT_ID AS TENANT_ID, 
        a.COMPANYID AS COMPANYID 
    FROM 
        ((((tbl_endaprdocinfo a 
        JOIN tbl_container c ON (a.CONTAINERID = c.CONTAINERID 
            AND a.TENANT_ID = c.TENANT_ID 
            AND a.COMPANYID = c.COMPANYID)) 
        JOIN tbl_expendaprdocinfo x ON (a.DOCID = x.DOCID 
            AND a.TENANT_ID = x.TENANT_ID 
            AND a.COMPANYID = x.COMPANYID)) 
        LEFT JOIN tbl_forminfo d ON (d.FORMID = a.FORMID 
            AND d.TENANT_ID = a.TENANT_ID 
            AND d.COMPANYID = a.COMPANYID)) 
        JOIN tbl_endaprlineinfo e ON (a.DOCID = e.DOCID 
            AND a.TENANT_ID = e.TENANT_ID 
            AND a.COMPANYID = e.COMPANYID)) 
    WHERE 
        e.APRMEMBERSN = 1 
            AND a.CONTAINERID <> '9999999999'  
    UNION ALL SELECT  
        a.DOCID AS docid, 
        a.DOCNO AS docno, 
        a.DOCTITLE AS doctitle, 
        a.WRITERDEPTNAME AS writerdeptname, 
        a.WRITERDEPTNAME2 AS writerdeptname2, 
        a.WRITERNAME AS writername, 
        a.WRITERNAME2 AS writername2, 
        a.STARTDATE AS StartDate, 
        a.ENDDATE AS EndDate, 
        a.HASATTACHYN AS hasattachyn, 
        CONCAT('/volumes/shared/ezFlow', a.HREF) AS ContentsPath, 
        a.HREF AS href, 
        a.FORMID AS formid, 
        d.FORMNAME AS formname, 
        d.FORMNAME2 AS formname2, 
        '' AS containerid, 
        NVL(x.KEYWORD, '') AS KeyWord, 
        '' AS WriterDeptID, 
        a.TENANT_ID AS TENANT_ID, 
        a.COMPANYID AS COMPANYID 
    FROM 
        (((tbl_aprdocinfo a 
        JOIN tbl_aprlineinfo b ON (a.DOCID = b.DOCID 
            AND a.TENANT_ID = b.TENANT_ID 
            AND a.COMPANYID = b.COMPANYID)) 
        JOIN tbl_expaprdocinfo x ON (a.DOCID = x.DOCID 
            AND a.TENANT_ID = x.TENANT_ID 
            AND a.COMPANYID = x.COMPANYID)) 
        LEFT JOIN tbl_forminfo d ON (d.FORMID = a.FORMID 
            AND d.TENANT_ID = a.TENANT_ID 
            AND d.COMPANYID = a.COMPANYID)) 
    WHERE 
        b.APRSTATE = '010' 
            AND b.APRTYPE = '015';

--------------------------------------------------------
--  VIEW_EZBOARDSTD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "VIEW_EZBOARDSTD" ("ITEMID", "BOARDNAME", "BOARDNAME2", "GUBUN", "TITLE", "WRITERDEPTNAME", "WRITERNAME", "WRITEDATE", "ATTACHMENTS", "BOARDID", "WRITERID", "HERF", "CONTENTLOCATION", "WRITERDEPTID", "TENANT_ID", "COMPANYID") AS 
  SELECT  
        b.ITEMID AS ITEMID, 
        a.BOARDNAME AS BOARDNAME, 
        a.BOARDNAME2 AS BOARDNAME2, 
        a.GUBUN AS GUBUN, 
        b.TITLE AS title, 
        b.WRITERDEPTNAME AS WRITERDEPTNAME, 
        b.WRITERNAME AS WRITERNAME, 
        b.WRITEDATE AS WRITEDATE, 
        b.ATTACHMENTS AS ATTACHMENTS, 
        b.BOARDID AS BOARDID, 
        b.WRITERID AS WRITERID, 
        b.CONTENTLOCATION AS Herf, 
        CONCAT('/volumes/shared/ezFlow', 
                b.CONTENTLOCATION) AS CONTENTLOCATION, 
        b.WRITERDEPTID AS WRITERDEPTID, 
        a.TENANT_ID AS TENANT_ID, 
        a.COMPANYID AS COMPANYID 
    FROM 
        (tbl_board_boardinfo a 
        JOIN tbl_board_item b ON (a.BOARDID = b.BOARDID 
            AND a.TENANT_ID = b.TENANT_ID))
    WHERE 
        b.APPRFLAG <> 'C' 
            AND b.APPRFLAG <> 'N' 
            OR b.APPRFLAG IS NULL;

--------------------------------------------------------
--  TBL_SENDOUTINFO
--------------------------------------------------------   
   
CREATE TABLE "TBL_SENDOUTINFO"
   ("IDEX"  NUMBER(30) NOT NULL ENABLE,
    "DOCID" CHAR(20 CHAR) NOT NULL ENABLE, 
	"FILENAME" VARCHAR2(100 CHAR),
	"FOLDERNAME" VARCHAR2(100 CHAR),
	"FILESTATE" VARCHAR2(100 CHAR),
	"SENDSTATE" VARCHAR2(100 CHAR),
	"WRITERID" VARCHAR2(100 CHAR), 
	"WRITERNAME" NVARCHAR2(100), 
	"WRITERDEPTID" VARCHAR2(100 CHAR),
	"CREATEDATE" DATE,
	"UPDATEDATE" DATE,
	"WRITERDEPTNAME" NVARCHAR2(100), 
	"TENANT_ID" NUMBER(5,0) DEFAULT 0 NOT NULL ENABLE, 
	"COMPANYID" VARCHAR2(20) NOT NULL ENABLE
   ) ;
   
--------------------------------------------------------
--  TBL_AUDITAPPRLINE
--------------------------------------------------------   
   
CREATE TABLE "TBL_AUDITAPPRLINE"
   ("AUDITAPPRLINEID"  VARCHAR2(100 CHAR),
    "USERID" NVARCHAR2(40),
    "DEPTID" NVARCHAR2(80), 
    "ORDERBY" NUMBER,
    "INSERTDATE" DATE NOT NULL ENABLE,
    "TENANT_ID" NUMBER(5,0) DEFAULT 0 NOT NULL ENABLE, 
	"COMPANYID" VARCHAR2(20) NOT NULL ENABLE,
	CONSTRAINT AUDITAPPRLINE_PK PRIMARY KEY ("AUDITAPPRLINEID", "USERID")
   ) ;

--------------------------------------------------------
--  TBL_YEARLYDOCCOUNT
--------------------------------------------------------

CREATE TABLE "TBL_YEARLYDOCCOUNT"
(
    "DOC_COUNT" NUMBER,
    "DOC_TYPE" NVARCHAR2(100) ,
    "MONTH_TYPE" NVARCHAR2(100) ,
    "CREATE_ID" NVARCHAR2(100) ,
    "CREATE_DATE" DATE DEFAULT SYSDATE,
    "TENANT_ID" NUMBER(5,0),
    "COMPANYID" VARCHAR2(160)
) ;

COMMENT ON COLUMN "TBL_YEARLYDOCCOUNT"."DOC_TYPE" IS 'INSEND: 내부발송, OUTSEND: 외부발송, OUTRECIEVE: 외부수신';
COMMENT ON COLUMN "TBL_YEARLYDOCCOUNT"."MONTH_TYPE" IS '1 ~ 12월, 작년-10(2) ~ 0(12) 월';

--------------------------------------------------------
--  TBL_SUSINSCHEDULE
--------------------------------------------------------

CREATE TABLE "TBL_SUSINSCHEDULE" (
  "DOCID" NVARCHAR2(80) NOT NULL,
  "DEPTID" NVARCHAR2(80) DEFAULT NULL,
  "DIRPATH" NVARCHAR2(1020) DEFAULT NULL,
  "DOCSTATE" NVARCHAR2(12) DEFAULT NULL,
  "COMPANYID" VARCHAR2(20) DEFAULT NULL,
  "LANG" NVARCHAR2(10) DEFAULT NULL,
  "TENANTID" NUMBER DEFAULT NULL,
  "OFFSET" CHAR(10 CHAR) DEFAULT '',
  CONSTRAINT SUSINSCHEDULE_PK PRIMARY KEY ("DOCID", "COMPANYID", "TENANTID")
) ;


--------------------------------------------------------
--  TBL_SCHEDULE_REMINDER_SCHEDULER
--------------------------------------------------------

CREATE TABLE "TBL_SCHEDULE_REMINDER_SCHEDULER" (
	"SCHEDULEID" NUMBER(10,0) NOT NULL ENABLE,
	"PARENTID" NUMBER(10,0) DEFAULT 0 NOT NULL ENABLE,
	"OWNERID" NVARCHAR2(50) NOT NULL ENABLE,
	"OWNERNAME" NVARCHAR2(80) NOT NULL ENABLE,
	"OWNERNAME2" NVARCHAR2(50),
	"CREATORID" NVARCHAR2(50) NOT NULL ENABLE,
	"CREATORNAME" NVARCHAR2(50) NOT NULL ENABLE,
	"CREATORNAME2" NVARCHAR2(50),
	"SCHEDULETYPE" NUMBER(5,0) NOT NULL ENABLE,
	"DATETYPE" NUMBER(5,0) NOT NULL ENABLE,
	"STARTDATE" DATE NOT NULL ENABLE,
	"ENDDATE" DATE NOT NULL ENABLE,
	"REPETITION" NVARCHAR2(50),
	"TITLE" NVARCHAR2(250) NOT NULL ENABLE,
	"TENANT_ID" NUMBER(5,0) NOT NULL ENABLE,
	"COMPANYID" VARCHAR2(40),
	"REMINDERSTATUS" NCHAR(1) DEFAULT '0',
	"OFFSETINFO" CHAR(10),
	"LANG" NVARCHAR2(10),
	"OFFSETMIN" NVARCHAR2(10),	
	CONSTRAINT TBL_SCHEDULE_REMINDER_SCHEDULER_PK PRIMARY KEY ("SCHEDULEID")
);

--------------------------------------------------------
--  VIEW_EZWEBFOLDER
--------------------------------------------------------

CREATE OR REPLACE VIEW VIEW_EZWEBFOLDER AS
	SELECT
	F.FILE_ID 										AS FILEID,
	F.FILE_NAME 									AS FILENAME,
	CONCAT('/volumes/shared/ezFlow',F.FILE_PATH) 	AS FILEPATH,
	F.FILE_SIZE 									AS FILESIZE,
	F.CREATE_ID 									AS WRITERID,
	F.CREATE_NAME1 									AS WRITERNAME,
	F.CREATE_NAME2 									AS WRITERNAME2,
	fld.COMPANY_ID 									AS COMPANYID,
	DEPT.CN											AS WRITERDEPTID,
	DEPT.DISPLAYNAME								AS WRITERDEPTNAME,
	DEPT.DISPLAYNAME2								AS WRITERDEPTNAME2,
	F.CREATE_DATE 									AS WRITERDATE,
	F.FOLDER_ID 									AS FOLDERID,
	F.TENANT_ID 									AS TENANTID,
	FLD.FOLDER_TYPE									AS FOLDERTYPE,
	FLD.FOLDER_NAME1								AS FOLDERNAME1,
	FLD.FOLDER_NAME2								AS FOLDERNAME2
	FROM TBL_WEBFOLDER_FILE F
	INNER JOIN TBL_WEBFOLDER_FOLDER FLD ON FLD.FOLDER_ID = F.FOLDER_ID AND FLD.TENANT_ID = F.TENANT_ID
	INNER JOIN TBL_USERMASTER USR ON USR.CN = F.CREATE_ID AND USR.TENANT_ID = F.TENANT_ID
	INNER JOIN TBL_DEPTMASTER DEPT ON DEPT.CN = USR.DEPARTMENT AND USR.TENANT_ID = DEPT.TENANT_ID
	WHERE FLD.USE_STATUS = 'Y' AND F.USE_STATUS = 'Y';

--------------------------------------------------------
--  SEARCH_INDEX_WEBFOLDER
--------------------------------------------------------
/*웹폴더 통합검색  증분색인쿼리*/
CREATE TABLE "SEARCH_INDEX_WEBFOLDER"
   ("ID" NUMBER(*,0) NOT NULL PRIMARY KEY,
	"FILEID" NUMBER(11,0) NOT NULL,
	"GUBUN" NVARCHAR2(4) NOT NULL,
	"INSERTDATE" DATE NOT NULL,
	"STATUS" NVARCHAR2(4) NOT NULL,
	"TENANT_ID" NUMBER(5,0) NOT NULL
   ) ;

--------------------------------------------------------
--  DDL for Sequence SEQ_SEARCH_INDEX_WEBFOLDER
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_SEARCH_INDEX_WEBFOLDER"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE ;

--------------------------------------------------------
--  VIEW_WEBFOLDERPERMISSIONS
--------------------------------------------------------
/*웹폴더 통합검색  권한쿼리*/
CREATE OR REPLACE VIEW VIEW_WEBFOLDERPERMISSIONS AS
select  fi.file_id as file_id, NVL(user_id, owner_id) as cn
from tbl_webfolder_file fi inner join tbl_webfolder_folder folder on fi.folder_id = folder.folder_id
left outer join tbl_webfolder_fileuser usr on fi.file_id = usr.file_id where (folder.folder_type = 'U' or (folder.folder_type ='C' and user_type = 'user'))
UNION
select  usr.file_id as file_id, TO_CHAR(u.cn) as cn
from tbl_webfolder_file fi inner join tbl_webfolder_fileuser usr on fi.file_id = usr.file_id
inner join tbl_usermaster u on u.department = usr.user_id
where user_type = 'dept'
UNION
select  usr.file_id as file_id, TO_CHAR(addjob.cn) as cn from tbl_webfolder_file fi inner join tbl_webfolder_fileuser usr
on fi.file_id = usr.file_id
inner join tbl_addjobmaster addjob on addjob.deptid = usr.user_id
where user_type = 'dept'
UNION
select  usr.file_id as file_id, TO_CHAR(u.cn) as cn from tbl_webfolder_file fi inner join tbl_webfolder_fileuser usr
on fi.file_id = usr.file_id
inner join tbl_usermaster u on u.PHYSICALDELIVERYOFFICENAME = usr.user_id
where user_type = 'dept'
UNION
select f.file_id as file_id, TO_CHAR(addjob.cn) as cn
from tbl_addjobmaster addjob inner join tbl_webfolder_fileuser fu on fu.user_id = addjob.jobid 
and fu.user_type = 'JIKWI'
inner join tbl_webfolder_file f on fu.file_id = f.file_id
UNION
select f.file_id as file_id, TO_CHAR(u.cn) as cn
from tbl_usermaster u inner join tbl_webfolder_fileuser fu on fu.user_id = u.extensionattribute7
and fu.user_type = 'JIKWI'
inner join tbl_webfolder_file f on fu.file_id = f.file_id
UNION
select f.file_id as file_id, TO_CHAR(u.cn) as cn
from tbl_usermaster u inner join tbl_webfolder_fileuser fu on fu.user_id = u.extensionattribute8
and fu.user_type = 'JIKCHEK'
inner join tbl_webfolder_file f on fu.file_id = f.file_id
UNION
select file_id as file_id, member_id as cn  FROM tbl_permissiongroupinfo p inner join tbl_webfolder_fileuser fu 
on fu.user_id = p.group_id where fu.user_type = 'group'
and p.member_type = 'user' 
UNION
select file_id, TO_CHAR(u.cn) as cn FROM tbl_permissiongroupinfo p inner join tbl_webfolder_fileuser fu 
on fu.user_id = p.group_id inner join tbl_usermaster u on u.extensionattribute8 = member_id 
where fu.user_type = 'group' and p.member_type = 'JIKCHEK'  
UNION
select file_id, TO_CHAR(u.cn) as cn FROM tbl_permissiongroupinfo p inner join tbl_webfolder_fileuser fu 
on fu.user_id = p.group_id inner join tbl_usermaster u on u.extensionattribute7 = member_id 
where fu.user_type = 'group' and p.member_type = 'JIKWI'  
UNION
select file_id, TO_CHAR(u.cn) as cn FROM tbl_permissiongroupinfo p inner join tbl_webfolder_fileuser fu 
on fu.user_id = p.group_id inner join tbl_addjobmaster u on u.jobid = member_id 
where fu.user_type = 'group' and p.member_type = 'JIKWI'  
UNION
select file_id, TO_CHAR(u.cn) as cn from tbl_webfolder_fileuser fu inner join tbl_permissiongroupinfo p
on p.group_id = fu.user_id inner join tbl_usermaster u
on u.department = p.member_id
where p.member_type = 'dept' and user_type = 'group' and sub_dept_yn = 'N'  
UNION
select file_id, TO_CHAR(u.cn) as cn from tbl_webfolder_fileuser fu inner join tbl_permissiongroupinfo p
on p.group_id = fu.user_id inner join tbl_addjobmaster u
on u.deptid = p.member_id
where p.member_type = 'dept' and user_type = 'group' and sub_dept_yn = 'N'  
UNION
select deptlist.file_id as file_id, TO_CHAR(u.cn) as cn from tbl_usermaster u inner join (
	select cn, dept_cd_path, tenant_id , deptInfo.file_id as file_id 
    from 
	(
		select group_id, file_id, LISTAGG(dept_cd_path, '|') WITHIN GROUP(ORDER BY dept_cd_path) as deptpath from tbl_deptmaster dept 
        inner join(
			select member_id, group_id, file_id, user_id from 
			(select member_id, group_id from tbl_permissiongroupinfo where member_type = 'dept' and SUB_DEPT_YN = 'Y') p 
			inner join tbl_webfolder_fileuser fu on fu.user_id = p.group_id and fu.user_type = 'group'
		) pandd
		on dept.cn = pandd.member_id group by group_id, file_id
	) deptInfo
	inner join tbl_deptmaster on REGEXP_LIKE (UPPER(dept_cd_path), UPPER(deptInfo.deptpath))
) deptlist
on deptlist.cn = u.department 
union
select deptlist.file_id as file_id, TO_CHAR(u.cn) as cn from tbl_addjobmaster u inner join (
	select cn, dept_cd_path, tenant_id , deptInfo.file_id as file_id 
    from 
	(
		select group_id, file_id, LISTAGG(dept_cd_path, '|') WITHIN GROUP(ORDER BY dept_cd_path) as deptpath from tbl_deptmaster dept 
        inner join(
			select member_id, group_id, file_id, user_id from 
			(select member_id, group_id from tbl_permissiongroupinfo where member_type = 'dept' and SUB_DEPT_YN = 'Y') p 
			inner join tbl_webfolder_fileuser fu on fu.user_id = p.group_id and fu.user_type = 'group'
		) pandd
		on dept.cn = pandd.member_id group by group_id, file_id
	) deptInfo
	inner join tbl_deptmaster on REGEXP_LIKE (UPPER(dept_cd_path), UPPER(deptInfo.deptpath))
) deptlist
on deptlist.cn = u.deptid
union
select distinct f.file_id as file_id ,folderInfo.user_id as cn
 from tbl_webfolder_file f 
inner join (
 select fld.folder_id as folder_id, folder.folder_path as folder_path3, folder.user_id as user_id
 from (
  select fldu.folder_id as folder_id, fldu.user_id  as user_id,  replace(folder_path ,'|','\\|') as folder_path 
  from tbl_webfolder_folder fld inner join tbl_webfolder_folderuser fldu 
  on fld.folder_id = fldu.folder_id and fldu.FOLDER_MANAGER = 1 AND FOLDER_TYPE = 'C'
  and fldu.tenant_id = fld.tenant_id 
 ) folder
inner join tbl_webfolder_folder fld 
on REGEXP_LIKE (UPPER(fld.folder_path), UPPER(folder.folder_path)) ) folderInfo 
on f.folder_id = folderInfo.folder_id;

-- webfolder trigger
-- 13070: update_dept_webfolder_name
-- 13079: update_user_webfolder_name
-- 13088: tbl_webfolder_file_insert
-- 13096: tbl_webfolder_file_update
-- 13105: tbl_webfolder_file_delete
-- 13114: tbl_webfolder_file_restore

-- ezEKP <-> ezTalk 간 인사연동 뷰 테이블(V_USERMASTER, V_DEPTMASTER, V_ADDJOBMASTER)
-- V_USERMASTER
CREATE OR REPLACE FORCE VIEW "V_USERMASTER" ("USER_ID", "EMP_NO", "NAME", "NAME2", "EMAIL", "DEPT_ID", "DEPT_NAME", "DEPT_NAME2", "TITLE", "TITLE2", "ROLE", "ROLE2", "POSITION", "POSITION2", "TEL", "MOBILE", "PROFILE_IMAGE", "JOB", "COMP_NAME", "COMP_NAME2", "ORDER_BY", "UPDATE_DATE", "PHOTO_UPDATEDT", "TENANT_ID", "TYPE", "SORT_NUM") AS 
  SELECT
	USER_ID AS USER_ID,
    EMP_NO AS EMP_NO,
	NAME AS NAME,
	NAME2 AS NAME2,
	EMAIL AS EMAIL,
	DEPT_ID AS DEPT_ID,
	DEPT_NAME AS DEPT_NAME,
	DEPT_NAME2 AS DEPT_NAME2,
	TITLE AS TITLE,
	TITLE2 AS TITLE2,
	ROLE AS ROLE,
    ROLE2 AS ROLE2,
	POSITION AS POSITION,
	POSITION2 AS POSITION2,
	TEL AS TEL,
	MOBILE AS MOBILE,
	PROFILE_IMAGE AS PROFILE_IMAGE,
	JOB AS JOB,
	COMP_NAME AS COMP_NAME,
	COMP_NAME2 AS COMP_NAME2,
	ORDER_BY AS ORDER_BY,
	UPDATE_DATE AS UPDATE_DATE,
	PHOTO_UPDATEDT AS PHOTO_UPDATEDT,
	TENANT_ID AS TENANT_ID,
	TYPE AS TYPE,
	SORT_NUM AS SORT_NUM
FROM
	(
	SELECT
		USER_ID AS USER_ID,
        EMP_NO AS EMP_NO,
		NAME AS NAME,
		NAME2 AS NAME2,
		EMAIL AS EMAIL,
		DEPT_ID AS DEPT_ID,
		DEPT_NAME AS DEPT_NAME,
		DEPT_NAME2 AS DEPT_NAME2,
		TITLE AS TITLE,
		TITLE2 AS TITLE2,
		ROLE AS ROLE,
        ROLE2 AS ROLE2,
		POSITION AS POSITION,
		POSITION2 AS POSITION2,
		TEL AS TEL,
		MOBILE AS MOBILE,
		PROFILE_IMAGE AS PROFILE_IMAGE,
		JOB AS JOB,
		COMP_NAME AS COMP_NAME,
		COMP_NAME2 AS COMP_NAME2,
		ORDER_BY AS ORDER_BY,
		UPDATE_DATE AS UPDATE_DATE,
		PHOTO_UPDATEDT AS PHOTO_UPDATEDT,
		TENANT_ID AS TENANT_ID,
		TYPE AS TYPE,
		ROW_NUMBER() OVER ( PARTITION BY DEPT_ID
	ORDER BY
		ORDER_BY,
		NAME) - 1 AS SORT_NUM
	FROM
		(
		SELECT
			a.CN AS USER_ID,
            a.EXTENSIONATTRIBUTE14 AS EMP_NO,
			a.DISPLAYNAME AS NAME,
			a.DISPLAYNAME2 AS NAME2,
			a.MAIL AS EMAIL,
			a.DEPARTMENT AS DEPT_ID,
			a.DESCRIPTION AS DEPT_NAME,
			a.DESCRIPTION2 AS DEPT_NAME2,
			a.EXTENSIONATTRIBUTE10 AS TITLE,
			a.EXTENSIONATTRIBUTE102 AS TITLE2,
			a.EXTENSIONATTRIBUTE10 AS ROLE,
            a.EXTENSIONATTRIBUTE102 AS ROLE2,
			a.TITLE AS POSITION,
			a.TITLE2 AS POSITION2,
			a.TELEPHONENUMBER AS TEL,
			a.MOBILE AS MOBILE,
			a.EXTENSIONATTRIBUTE2 AS PROFILE_IMAGE,
			a.INFO AS JOB,
			a.COMPANY AS COMP_NAME,
			a.COMPANY2 AS COMP_NAME2,
			CASE WHEN a.EXTENSIONATTRIBUTE15 IS NOT NULL THEN cast(a.EXTENSIONATTRIBUTE15 as INTEGER) ELSE 0 END	AS ORDER_BY,
			a.UPDATEDT AS UPDATE_DATE,
			a.PHOTO_UPDATEDT AS PHOTO_UPDATEDT,
			a.TENANT_ID AS TENANT_ID,
			'USER' AS TYPE
		FROM
			(tbl_usermaster a
		LEFT JOIN tbl_usermaster_retire b ON
			(a.CN = b.CN))
		WHERE
			b.CN IS NULL
			AND a.DEPARTMENT NOT LIKE '%shared_mailbox_%'
			AND a.CN <> 'masteradmin'
	UNION ALL
		SELECT
			a.CN AS USER_ID,
            b.EXTENSIONATTRIBUTE14 AS EMP_NO,
			b.DISPLAYNAME AS NAME,
			b.DISPLAYNAME2 AS NAME2,
			b.MAIL AS EMAIL,
			a.DEPTID AS DEPT_ID,
			b.DESCRIPTION AS DEPT_NAME,
			b.DESCRIPTION2 AS DEPT_NAME2,
			a.POSITIONCD AS TITLE,
			a.POSITIONCD AS TITLE2,
            b.EXTENSIONATTRIBUTE10 AS ROLE,
            b.EXTENSIONATTRIBUTE102 AS ROLE2,
			a.TITLE AS POSITION,
			a.TITLE2 AS POSITION2,
			b.TELEPHONENUMBER AS TEL,
			b.MOBILE AS MOBILE,
			b.EXTENSIONATTRIBUTE2 AS PROFILE_IMAGE,
			b.INFO AS JOB,
			b.COMPANY AS COMP_NAME,
			b.COMPANY2 AS COMP_NAME2,
			CASE WHEN a.ORDERBY IS NOT NULL THEN cast(a.ORDERBY as INTEGER) ELSE 0 END	AS ORDER_BY,
			b.UPDATEDT AS UPDATE_DATE,
			b.PHOTO_UPDATEDT AS PHOTO_UPDATEDT,
			b.TENANT_ID AS TENANT_ID,
			'ADDJOB' AS TYPE
		FROM
			tbl_addjobmaster a
		JOIN tbl_usermaster b ON
			a.CN = b.CN
        )) v
WHERE
	TYPE = 'USER';

-- V_DEPTMASTER
CREATE OR REPLACE FORCE VIEW "V_DEPTMASTER" ("DEPT_ID", "NAME", "NAME2", "EMAIL", "PARENT_ID", "DEPT_CD_PATH", "COMP_ID", "COMP_NAME", "COMP_NAME2", "ORDER_BY", "USEFLAG", "UPDATEDT", "TENANT_ID") AS 
  SELECT 
        tbl_deptmaster.CN AS DEPT_ID,
        tbl_deptmaster.DISPLAYNAME AS NAME,
        tbl_deptmaster.DISPLAYNAME2 AS NAME2,
        tbl_deptmaster.MAIL AS EMAIL,
        tbl_deptmaster.EXTENSIONATTRIBUTE1 AS PARENT_ID,
        tbl_deptmaster.DEPT_CD_PATH AS DEPT_CD_PATH,
        tbl_deptmaster.EXTENSIONATTRIBUTE2 AS COMP_ID,
        tbl_deptmaster.EXTENSIONATTRIBUTE3 AS COMP_NAME,
        tbl_deptmaster.COMPNM2 AS COMP_NAME2,
        CASE WHEN tbl_deptmaster.EXTENSIONATTRIBUTE15 IS NOT NULL THEN cast(tbl_deptmaster.EXTENSIONATTRIBUTE15 as INTEGER) ELSE 0 END	AS ORDER_BY,
        tbl_deptmaster.USEFLAG AS USEFLAG,
        tbl_deptmaster.UPDATEDT AS UPDATEDT,
        tbl_deptmaster.TENANT_ID AS TENANT_ID
    FROM
        tbl_deptmaster
    WHERE
        tbl_deptmaster.CN NOT LIKE '%shared_mailbox_%'
            AND tbl_deptmaster.CN NOT LIKE '%trash_dept_%'
            AND tbl_deptmaster.CN <> 'Top'
            AND tbl_deptmaster.DEPT_CD_PATH NOT LIKE '%trash_dept_%';

-- V_ADDJOBMASTER
CREATE OR REPLACE FORCE VIEW "V_ADDJOBMASTER" ("USER_ID", "EMP_NO", "NAME", "DEPT_ID", "POSITION", "POSITION2", "ROLE", "ROLE2", "ORDER_BY", "UPDATEDT", "TENANT_ID", "TYPE", "SORT_NUM") AS 
  SELECT
	USER_ID AS USER_ID,
    EMP_NO AS EMP_NO,
	NAME AS NAME,
	DEPT_ID AS DEPT_ID,
	POSITION AS POSITION,
	POSITION2 AS POSITION2,
	ROLE AS ROLE,
    ROLE2 AS ROLE2,
	ORDER_BY AS ORDER_BY,
	UPDATEDT AS UPDATEDT,
	TENANT_ID AS TENANT_ID,
	TYPE AS TYPE,
	SORT_NUM AS SORT_NUM
FROM
	(
	SELECT
		USER_ID AS USER_ID,
        EMP_NO AS EMP_NO,
		NAME AS NAME,
		DEPT_ID AS DEPT_ID,
		POSITION AS POSITION,
		POSITION2 AS POSITION2,
		ROLE AS ROLE,
        ROLE2 AS ROLE2,
		ORDER_BY AS ORDER_BY,
		UPDATEDT AS UPDATEDT,
		TENANT_ID AS TENANT_ID,
		TYPE AS TYPE,
		ROW_NUMBER() OVER ( PARTITION BY DEPT_ID
	ORDER BY
		ORDER_BY,
		NAME) - 1 AS SORT_NUM
	FROM
		(
		SELECT
			a.CN AS USER_ID,
            a.EXTENSIONATTRIBUTE14 AS EMP_NO,
			a.DISPLAYNAME AS NAME,
			a.DEPARTMENT AS DEPT_ID,
			a.TITLE AS POSITION,
			a.TITLE2 AS POSITION2,
            a.EXTENSIONATTRIBUTE10 AS ROLE,
            a.EXTENSIONATTRIBUTE102 AS ROLE2,
			CASE WHEN a.EXTENSIONATTRIBUTE15 IS NOT NULL THEN cast(a.EXTENSIONATTRIBUTE15 as INTEGER) ELSE 0 END	AS ORDER_BY,
			a.UPDATEDT AS UPDATEDT,
			a.TENANT_ID AS TENANT_ID,
			'USER' AS TYPE
		FROM
			(tbl_usermaster a
		LEFT JOIN tbl_usermaster_retire b ON
			(a.CN = b.CN))
		WHERE
			b.CN IS NULL
			AND a.DEPARTMENT NOT LIKE '%shared_mailbox_%'
			AND a.CN <> 'masteradmin'
	UNION ALL
		SELECT
			a.CN AS USER_ID,
            b.EXTENSIONATTRIBUTE14 AS EMP_NO,
			b.DISPLAYNAME AS NAME,
			a.DEPTID AS DEPT_ID,
			a.TITLE AS POSITION,
			a.TITLE2 AS POSITION2,
			a.ROLE AS ROLE,
            a.ROLE2 AS ROLE2,
			CASE WHEN a.ORDERBY IS NOT NULL THEN cast(a.ORDERBY as INTEGER) ELSE 0 END	AS ORDER_BY,
			SYSDATE AS UPDATEDT,
			a.TENANT_ID AS TENANT_ID,
			'ADDJOB' AS TYPE
		FROM
            ((SELECT
                CN,
                DEPTID,
                TITLE,
                TITLE2,
                ROLE,
                ROLE2,
                MIN(ORDERBY) AS ORDERBY,
                TENANT_ID
            FROM
                TBL_ADDJOBMASTER
            GROUP BY
                (CN, DEPTID, TITLE, TITLE2, ROLE, ROLE2, TENANT_ID)) a
		JOIN tbl_usermaster b ON
			(a.CN = b.CN))) ) v
WHERE
	v.TYPE = 'ADDJOB';

-- -- V_USERMASTER
-- CREATE OR REPLACE FORCE VIEW "V_USERMASTER" ("USER_ID", "EMP_NO", "NAME", "NAME2", "EMAIL", "DEPT_ID", "DEPT_NAME", "DEPT_NAME2", "TITLE", "TITLE2", "ROLE", "ROLE2", "POSITION", "POSITION2", "TEL", "MOBILE", "PROFILE_IMAGE", "JOB", "COMP_NAME", "COMP_NAME2", "ORDER_BY", "UPDATE_DATE", "PHOTO_UPDATEDT", "TENANT_ID", "TYPE", "SORT_NUM") AS
--  SELECT
--	USER_ID AS USER_ID,
--    EMP_NO AS EMP_NO,
--	NAME AS NAME,
--	NAME2 AS NAME2,
--	EMAIL AS EMAIL,
--	DEPT_ID AS DEPT_ID,
--	DEPT_NAME AS DEPT_NAME,
--	DEPT_NAME2 AS DEPT_NAME2,
--	TITLE AS TITLE,
--	TITLE2 AS TITLE2,
--	ROLE AS ROLE,
--    ROLE2 AS ROLE2,
--	POSITION AS POSITION,
--	POSITION2 AS POSITION2,
--	TEL AS TEL,
--	MOBILE AS MOBILE,
--	PROFILE_IMAGE AS PROFILE_IMAGE,
--	JOB AS JOB,
--	COMP_NAME AS COMP_NAME,
--	COMP_NAME2 AS COMP_NAME2,
--	ORDER_BY AS ORDER_BY,
--	UPDATE_DATE AS UPDATE_DATE,
--	PHOTO_UPDATEDT AS PHOTO_UPDATEDT,
--	TENANT_ID AS TENANT_ID,
--	TYPE AS TYPE,
--	SORT_NUM AS SORT_NUM
-- FROM
--	(
--	SELECT
--		USER_ID AS USER_ID,
--        EMP_NO AS EMP_NO,
--		NAME AS NAME,
--		NAME2 AS NAME2,
--		EMAIL AS EMAIL,
--		DEPT_ID AS DEPT_ID,
--		DEPT_NAME AS DEPT_NAME,
--		DEPT_NAME2 AS DEPT_NAME2,
--		TITLE AS TITLE,
--		TITLE2 AS TITLE2,
--		ROLE AS ROLE,
--        ROLE2 AS ROLE2,
--		POSITION AS POSITION,
--		POSITION2 AS POSITION2,
--		TEL AS TEL,
--		MOBILE AS MOBILE,
--		PROFILE_IMAGE AS PROFILE_IMAGE,
--		JOB AS JOB,
--		COMP_NAME AS COMP_NAME,
--		COMP_NAME2 AS COMP_NAME2,
--		ORDER_BY AS ORDER_BY,
--		UPDATE_DATE AS UPDATE_DATE,
--		PHOTO_UPDATEDT AS PHOTO_UPDATEDT,
--		TENANT_ID AS TENANT_ID,
--		TYPE AS TYPE,
--		ROW_NUMBER() OVER ( PARTITION BY DEPT_ID
--	ORDER BY
--		ORDER_BY,
--		NAME) - 1 AS SORT_NUM
--	FROM
--		(
--		SELECT
--			a.CN AS USER_ID,
--            a.EXTENSIONATTRIBUTE14 AS EMP_NO,
--			a.DISPLAYNAME AS NAME,
--			a.DISPLAYNAME2 AS NAME2,
--			a.MAIL AS EMAIL,
--			a.DEPARTMENT AS DEPT_ID,
--			a.DESCRIPTION AS DEPT_NAME,
--			a.DESCRIPTION2 AS DEPT_NAME2,
--			a.EXTENSIONATTRIBUTE10 AS TITLE,
--			a.EXTENSIONATTRIBUTE102 AS TITLE2,
--			a.EXTENSIONATTRIBUTE10 AS ROLE,
--            a.EXTENSIONATTRIBUTE102 AS ROLE2,
--			a.TITLE AS POSITION,
--			a.TITLE2 AS POSITION2,
--			a.TELEPHONENUMBER AS TEL,
--			a.MOBILE AS MOBILE,
--			a.EXTENSIONATTRIBUTE2 AS PROFILE_IMAGE,
--			a.INFO AS JOB,
--			a.COMPANY AS COMP_NAME,
--			a.COMPANY2 AS COMP_NAME2,
--			CASE WHEN a.EXTENSIONATTRIBUTE15 IS NOT NULL THEN cast(a.EXTENSIONATTRIBUTE15 as INTEGER) ELSE 0 END	AS ORDER_BY,
--			a.UPDATEDT AS UPDATE_DATE,
--			a.PHOTO_UPDATEDT AS PHOTO_UPDATEDT,
--			a.TENANT_ID AS TENANT_ID,
--			'USER' AS TYPE
--		FROM
--			(tbl_usermaster a
--		LEFT JOIN tbl_usermaster_retire b ON
--			(a.CN = b.CN))
--		WHERE
--			b.CN IS NULL
--			AND a.DEPARTMENT NOT LIKE '%shared_mailbox_%'
--			AND a.CN <> 'masteradmin'
--	UNION ALL
--		SELECT
--			a.CN AS USER_ID,
--            b.EXTENSIONATTRIBUTE14 AS EMP_NO,
--			b.DISPLAYNAME AS NAME,
--			b.DISPLAYNAME2 AS NAME2,
--			b.MAIL AS EMAIL,
--			a.DEPTID AS DEPT_ID,
--			b.DESCRIPTION AS DEPT_NAME,
--			b.DESCRIPTION2 AS DEPT_NAME2,
--			a.POSITIONCD AS TITLE,
--			a.POSITIONCD AS TITLE2,
--            b.EXTENSIONATTRIBUTE10 AS ROLE,
--            b.EXTENSIONATTRIBUTE102 AS ROLE2,
--			a.TITLE AS POSITION,
--			a.TITLE2 AS POSITION2,
--			b.TELEPHONENUMBER AS TEL,
--			b.MOBILE AS MOBILE,
--			b.EXTENSIONATTRIBUTE2 AS PROFILE_IMAGE,
--			b.INFO AS JOB,
--			b.COMPANY AS COMP_NAME,
--			b.COMPANY2 AS COMP_NAME2,
--			CASE WHEN a.ORDERBY IS NOT NULL THEN cast(a.ORDERBY as INTEGER) ELSE 0 END	AS ORDER_BY,
--			b.UPDATEDT AS UPDATE_DATE,
--			b.PHOTO_UPDATEDT AS PHOTO_UPDATEDT,
--			b.TENANT_ID AS TENANT_ID,
--			'ADDJOB' AS TYPE
--		FROM
--			tbl_addjobmaster a
--		JOIN tbl_usermaster b ON
--			a.CN = b.CN
--        )) v
-- WHERE
--	TYPE = 'USER';
--
-- -- V_DEPTMASTER
-- CREATE OR REPLACE FORCE VIEW "V_DEPTMASTER" ("DEPT_ID", "NAME", "NAME2", "EMAIL", "PARENT_ID", "DEPT_CD_PATH", "COMP_ID", "COMP_NAME", "COMP_NAME2", "ORDER_BY", "USEFLAG", "UPDATEDT", "TENANT_ID") AS
--  SELECT
--        tbl_deptmaster.CN AS DEPT_ID,
--        tbl_deptmaster.DISPLAYNAME AS NAME,
--        tbl_deptmaster.DISPLAYNAME2 AS NAME2,
--        tbl_deptmaster.MAIL AS EMAIL,
--        tbl_deptmaster.EXTENSIONATTRIBUTE1 AS PARENT_ID,
--        tbl_deptmaster.DEPT_CD_PATH AS DEPT_CD_PATH,
--        tbl_deptmaster.EXTENSIONATTRIBUTE2 AS COMP_ID,
--        tbl_deptmaster.EXTENSIONATTRIBUTE3 AS COMP_NAME,
--        tbl_deptmaster.COMPNM2 AS COMP_NAME2,
--        CASE WHEN tbl_deptmaster.EXTENSIONATTRIBUTE15 IS NOT NULL THEN cast(tbl_deptmaster.EXTENSIONATTRIBUTE15 as INTEGER) ELSE 0 END	AS ORDER_BY,
--        tbl_deptmaster.USEFLAG AS USEFLAG,
--        tbl_deptmaster.UPDATEDT AS UPDATEDT,
--        tbl_deptmaster.TENANT_ID AS TENANT_ID
--    FROM
--        tbl_deptmaster
--    WHERE
--        tbl_deptmaster.CN NOT LIKE '%shared_mailbox_%'
--            AND tbl_deptmaster.CN NOT LIKE '%trash_dept_%'
--            AND tbl_deptmaster.CN <> 'Top'
--            AND tbl_deptmaster.DEPT_CD_PATH NOT LIKE '%trash_dept_%';
--
-- -- V_ADDJOBMASTER
-- CREATE OR REPLACE FORCE VIEW "V_ADDJOBMASTER" ("USER_ID", "EMP_NO", "NAME", "DEPT_ID", "POSITION", "POSITION2", "ROLE", "ROLE2", "ORDER_BY", "UPDATEDT", "TENANT_ID", "TYPE", "SORT_NUM") AS
--  SELECT
--	USER_ID AS USER_ID,
--    EMP_NO AS EMP_NO,
--	NAME AS NAME,
--	DEPT_ID AS DEPT_ID,
--	POSITION AS POSITION,
--	POSITION2 AS POSITION2,
--	ROLE AS ROLE,
--    ROLE2 AS ROLE2,
--	ORDER_BY AS ORDER_BY,
--	UPDATEDT AS UPDATEDT,
--	TENANT_ID AS TENANT_ID,
--	TYPE AS TYPE,
--	SORT_NUM AS SORT_NUM
-- FROM
--	(
--	SELECT
--		USER_ID AS USER_ID,
--        EMP_NO AS EMP_NO,
--		NAME AS NAME,
--		DEPT_ID AS DEPT_ID,
--		POSITION AS POSITION,
--		POSITION2 AS POSITION2,
--		ROLE AS ROLE,
--        ROLE2 AS ROLE2,
--		ORDER_BY AS ORDER_BY,
--		UPDATEDT AS UPDATEDT,
--		TENANT_ID AS TENANT_ID,
--		TYPE AS TYPE,
--		ROW_NUMBER() OVER ( PARTITION BY DEPT_ID
--	ORDER BY
--		ORDER_BY,
--		NAME) - 1 AS SORT_NUM
--	FROM
--		(
--		SELECT
--			a.CN AS USER_ID,
--            a.EXTENSIONATTRIBUTE14 AS EMP_NO,
--			a.DISPLAYNAME AS NAME,
--			a.DEPARTMENT AS DEPT_ID,
--			a.TITLE AS POSITION,
--			a.TITLE2 AS POSITION2,
--            a.EXTENSIONATTRIBUTE10 AS ROLE,
--            a.EXTENSIONATTRIBUTE102 AS ROLE2,
--			CASE WHEN a.EXTENSIONATTRIBUTE15 IS NOT NULL THEN cast(a.EXTENSIONATTRIBUTE15 as INTEGER) ELSE 0 END	AS ORDER_BY,
--			a.UPDATEDT AS UPDATEDT,
--			a.TENANT_ID AS TENANT_ID,
--			'USER' AS TYPE
--		FROM
--			(tbl_usermaster a
--		LEFT JOIN tbl_usermaster_retire b ON
--			(a.CN = b.CN))
--		WHERE
--			b.CN IS NULL
--			AND a.DEPARTMENT NOT LIKE '%shared_mailbox_%'
--			AND a.CN <> 'masteradmin'
--	UNION ALL
--		SELECT
--			a.CN AS USER_ID,
--            b.EXTENSIONATTRIBUTE14 AS EMP_NO,
--			b.DISPLAYNAME AS NAME,
--			a.DEPTID AS DEPT_ID,
--			a.TITLE AS POSITION,
--			a.TITLE2 AS POSITION2,
--			a.ROLE AS ROLE,
--            a.ROLE2 AS ROLE2,
--			CASE WHEN a.ORDERBY IS NOT NULL THEN cast(a.ORDERBY as INTEGER) ELSE 0 END	AS ORDER_BY,
--			SYSDATE AS UPDATEDT,
--			a.TENANT_ID AS TENANT_ID,
--			'ADDJOB' AS TYPE
--		FROM
--            ((SELECT
--                CN,
--                DEPTID,
--                TITLE,
--                TITLE2,
--                ROLE,
--                ROLE2,
--                MIN(ORDERBY) AS ORDERBY,
--                TENANT_ID
--            FROM
--                TBL_ADDJOBMASTER
--            GROUP BY
--                (CN, DEPTID, TITLE, TITLE2, ROLE, ROLE2, TENANT_ID)) a
--		JOIN tbl_usermaster b ON
--			(a.CN = b.CN))) ) v
-- WHERE
--	v.TYPE = 'ADDJOB';

-- G_USERMASTER
CREATE OR REPLACE VIEW G_USERMASTER AS
SELECT
    a.CN AS CN,
    a.PASSWORD AS PASSWORD,
    a.DEPARTMENT AS DEPARTMENT,
    a.DISPLAYNAME AS DISPLAYNAME,
    a.DISPLAYNAME2 AS DISPLAYNAME2,
    a.mail AS EMAIL_ADDRESS,
    a.TITLE AS TITLE,
    a.TITLE2 AS TITLE2,
    a.EXTENSIONATTRIBUTE10 AS EXTENSIONATTRIBUTE10,
    a.EXTENSIONATTRIBUTE102 AS EXTENSIONATTRIBUTE102,
    a.HOMEPHONE AS HOMEPHONE,
    a.MOBILE AS MOBILE,
    a.TELEPHONENUMBER AS TELEPHONENUMBER,
    a.FACSIMILETELEPHONENUMBER AS FACSIMILETELEPHONENUMBER,
    a.EXTENSIONATTRIBUTE2 AS EXTENSIONATTRIBUTE2,
    CASE
        WHEN a.EXTENSIONATTRIBUTE15 <> '' THEN TO_NUMBER(a.EXTENSIONATTRIBUTE15)
        ELSE 0
        END AS EXTENSIONATTRIBUTE15,
    a.BIRTH AS BIRTH,
    a.BIRTHTYPE AS BIRTHTYPE,
    a.UPDATEDT AS UPDATEDT,
    a.EXTENSIONATTRIBUTE14 AS EXTENSIONATTRIBUTE14,
    a.EXTENSIONATTRIBUTE2 AS PROFILE_IMAGE,
    CASE
        WHEN a.extensionattribute2 IS NOT NULL THEN 'https://jrelo.kaoni.com/fileroot/0/files/upload_personal/photo/' || TO_CHAR(a.extensionattribute2)
        ELSE TO_CHAR(a.extensionattribute2)
        END AS PROFILE_IMAGE_URL,
    'Y' AS USE_YN
FROM
    (tbl_usermaster a
        LEFT JOIN tbl_usermaster_retire b ON
        (a.CN = b.CN))
WHERE
    b.CN IS NULL
  AND a.DEPARTMENT NOT LIKE '%shared_mailbox_%'
  AND a.CN <> 'masteradmin';

-- G_ADDJOBMASTER
CREATE OR REPLACE FORCE VIEW "G_ADDJOBMASTER" ("CN", "DEPTID", "TITLE", "TITLE2", "ROLE", "ROLE2", "SORT_ORDER") AS
SELECT
    CN,
    DEPTID,
    TITLE,
    TITLE2,
    ROLE,
    ROLE2,
    ORDERBY AS SORT_ORDER
FROM
    TBL_ADDJOBMASTER;

-- G_DEPTMASTER
CREATE OR REPLACE FORCE VIEW "G_DEPTMASTER" ("CN", "DISPLAYNAME", "DISPLAYNAME2", "EXTENSIONATTRIBUTE1", "EXTENSIONATTRIBUTE15", "USE_YN") AS
SELECT
    CN,
    DISPLAYNAME,
    DISPLAYNAME2,
    EXTENSIONATTRIBUTE1,
    EXTENSIONATTRIBUTE15,
    'Y' AS USE_YN
FROM
    tbl_deptmaster
WHERE
    CN NOT LIKE '%shared_mailbox_%'
  AND
    CN NOT LIKE '%trash_dept_%'
  AND
    CN <> 'Top'
  AND
    DEPT_CD_PATH NOT LIKE '%trash_dept_%';

CREATE TABLE TBL_SERIALNUMGEN_GRANT (
    "IDX" NUMBER(10,0) NOT NULL ENABLE,
    "DEPTID" NVARCHAR2(100) NOT NULL ENABLE,
    "DEPTNAME" NVARCHAR2(100) NOT NULL ENABLE,
    "GRANTDEPTID" NVARCHAR2(100) NOT NULL ENABLE,
    "GRANTDEPTNAME" NVARCHAR2(100) NOT NULL ENABLE,
    "TENANT_ID" NUMBER(5,0) NOT NULL ENABLE,
    "COMPANYID" NVARCHAR2(20) NOT NULL ENABLE,
    CONSTRAINT "SERIALNUMGEN_GRANT_PK" PRIMARY KEY ("IDX", "DEPTID", "TENANT_ID", "COMPANYID")
);

CREATE TABLE "TBL_APRATTACHLIMIT" (
    "ATTACHLIMITCNT" NUMBER(10,0),
    "TENANT_ID" NUMBER(5,0) NOT NULL ENABLE,
    "COMPANYID" NVARCHAR2(80) NOT NULL ENABLE,
    CONSTRAINT "PK_TBL_APRATTACHLIMIT" PRIMARY KEY ("TENANT_ID", "COMPANYID")
);

CREATE TABLE TBL_SCHEDULE_COMPLETE (
    SCHEDULEID NUMBER(10) NOT NULL,
    REPEATCOUNT NUMBER(10) NOT NULL,
    ISALLREP NCHAR(1) DEFAULT 'N',
    STARTDATE DATE NOT NULL,
    TENANT_ID NUMBER(5),
    COMPANYID VARCHAR2(40),
    CONSTRAINT TBL_SCHEDULE_COMPLETE_PK PRIMARY KEY (SCHEDULEID, REPEATCOUNT, ISALLREP, STARTDATE)
);

CREATE TABLE TBL_SERIAL_NOROLLBACK (
   TYPE1 VARCHAR2(50 CHAR) NOT NULL,
   TYPE3 VARCHAR2(50 CHAR) NOT NULL,
   TYPE2 VARCHAR2(50 CHAR) NOT NULL,
   TIMESEP NUMBER(10,0) NOT NULL,
   REGSERIALNO NUMBER(19,0) NOT NULL,
   TENANT_ID NUMBER(38,0) DEFAULT 0,
   COMPANYID VARCHAR2(20 BYTE) NOT NULL,
   CONSTRAINT "TBL_SR_NOROLLBACK_PK" PRIMARY KEY (TYPE1, TYPE3, TYPE2, TIMESEP, REGSERIALNO, TENANT_ID, COMPANYID)
);

CREATE TABLE TBL_BOARD_TABBOARD (
    TABID 		NUMBER(2,0) 	NOT NULL,
    BOARDID 	NVARCHAR2(40) 	NOT NULL,
    TENANT_ID 	NUMBER(5,0) 	NOT NULL,
    COMPANYID 	NVARCHAR2(80) 	NOT NULL,
    BOARDNAME 	NVARCHAR2(255),
    BOARDNAME2 	NVARCHAR2(255),
    CONSTRAINT "TBL_BOARD_TABBOARD_PK" PRIMARY KEY (TABID, TENANT_ID, COMPANYID)
);

CREATE TABLE "TBL_APRBIGATTACH_DOWNLOADINFO" (
    "DOCID" CHAR(20 BYTE) NOT NULL ENABLE,
    "ATTACHFILESN" NUMBER(10,0) NOT NULL ENABLE,
    "DOWNLOAD_COUNT" NUMBER,
    "TENANT_ID" NUMBER(5,0) DEFAULT 0 NOT NULL ENABLE,
    "COMPANYID" VARCHAR2(20 BYTE) NOT NULL ENABLE,
     CONSTRAINT "TBL_APRBIGATTACH_DLINFO_PK" PRIMARY KEY ("DOCID", "ATTACHFILESN", "TENANT_ID", "COMPANYID")
);

CREATE TABLE TBL_APRPREVIEW (
    USERID NVARCHAR2(80) NOT NULL,
    PREVIEW NVARCHAR2(50),
    TENANT_ID NUMBER NOT NULL,
    CONSTRAINT "TBL_APRPREVIEW_PK" PRIMARY KEY (USERID , TENANT_ID)
);

CREATE TABLE TBL_PS_POPUP_USER (
   "ITEMSEQ" NUMBER(10,0) NOT NULL ENABLE,
   "USER_ID" NVARCHAR2(50) NOT NULL ENABLE,
   "USER_TYPE" NVARCHAR2(10) NOT NULL ENABLE,
   "TENANT_ID" NUMBER(5,0) NOT NULL ENABLE,
   "COMPANYID" NVARCHAR2(20) NOT NULL ENABLE,
   "SUBDEPT_PERMITTED" NUMBER(11),
   "SN" NUMBER(11) DEFAULT 0,
   CONSTRAINT "PK_PS_POPUP_USER" PRIMARY KEY ("ITEMSEQ", "USER_ID", "USER_TYPE", "TENANT_ID", "COMPANYID")
);

CREATE TABLE TBL_SHARE_DOC_DIR (
   "OWNER_ID" NVARCHAR2(45) NOT NULL ENABLE,
   "SHARE_ID" NVARCHAR2(45) NOT NULL ENABLE,
   "SHARE_TYPE" NVARCHAR2(45),
   "TENANT_ID" NUMBER(5, 0) NOT NULL ENABLE,
   "OWNER_TYPE" NVARCHAR2(45),
   CONSTRAINT "PK_SHARE_DOC_DIR" PRIMARY KEY ("OWNER_ID", "SHARE_ID", "TENANT_ID")
);

CREATE TABLE TBL_BOARD_NOTICEBOARD (
   BOARDID NVARCHAR2(40) NOT NULL,
   TENANT_ID NUMBER(5,0) NOT NULL,
   COMPANYID VARCHAR2(80) NOT NULL,
   CONSTRAINT "TBL_BOARD_NOTICEBOARD_PK" PRIMARY KEY (BOARDID, TENANT_ID, COMPANYID)
);

CREATE TABLE TBL_DB_LOG
(
    MESSAGE    VARCHAR2(1000),
    CATEGORY   VARCHAR2(200),
    EVENT_DATE DATE NOT NULL,
    THREAD     VARCHAR2(100),
    STACK      CLOB
);

CREATE TABLE TBL_PORTAL_PORTLET_SIZE
(
    SIZE_ID    NUMBER NOT NULL
        CONSTRAINT PK_TBL_PORTAL_PORTLET_SIZE
            PRIMARY KEY,
    CLASS_SIZE VARCHAR2(100)
);

CREATE TABLE TBL_PORTAL_PORTLET_COMPANY_SIZE
(
    TENANT_ID    NUMBER        NOT NULL,
    COMPANY_ID   NVARCHAR2(100) NOT NULL,
    PORTLET_ID   NUMBER        NOT NULL,
    THEME_ID     NUMBER        NOT NULL,
    SIZE_ID      NUMBER        NOT NULL
        CONSTRAINT FK_TBL_PORTAL_PORTLET_COMPANY_SIZE
            REFERENCES TBL_PORTAL_PORTLET_SIZE,
    DEFAULT_FLAG NUMBER,
    CONSTRAINT PK_TBL_PORTAL_PORTLET_COMPANY_SIZE
        PRIMARY KEY (TENANT_ID, COMPANY_ID, THEME_ID, PORTLET_ID, SIZE_ID)
);

CREATE INDEX IDX_TBL_PORTAL_PORTLET_COMPANY_SIZE_ID
    ON TBL_PORTAL_PORTLET_COMPANY_SIZE (SIZE_ID);

CREATE INDEX TBL_PORTAL_PORTLET_COMPANY_SIZE_COMPANY_ID_INDEX
    ON TBL_PORTAL_PORTLET_COMPANY_SIZE (COMPANY_ID);

CREATE INDEX TBL_PORTAL_PORTLET_COMPANY_SIZE_TENANT_ID_INDEX
    ON TBL_PORTAL_PORTLET_COMPANY_SIZE (TENANT_ID);

CREATE INDEX TBL_PORTAL_PORTLET_COMPANY_SIZE_THEME_ID_INDEX
    ON TBL_PORTAL_PORTLET_COMPANY_SIZE (THEME_ID);

CREATE TABLE TBL_PORTAL_PORTLET_USER_SIZE
(
    USER_ID    NVARCHAR2(100) NOT NULL,
    TENANT_ID  NUMBER        NOT NULL,
    COMPANY_ID NVARCHAR2(100) NOT NULL,
    PORTLET_ID NUMBER        NOT NULL,
    THEME_ID   NUMBER        NOT NULL,
    SIZE_ID    NUMBER
        CONSTRAINT FK_TBL_PORTAL_PORTLET_USER_SIZE_TBL_PORTAL_PORTLET_SIZE_SIZE_ID
            REFERENCES TBL_PORTAL_PORTLET_SIZE,
    CONSTRAINT PK_TBL_PORTAL_PORTLET_USER_SIZE
        PRIMARY KEY (TENANT_ID, COMPANY_ID, THEME_ID, PORTLET_ID, USER_ID)
);

CREATE INDEX TBL_PORTAL_PORTLET_USER_SIZE_COMPANY_ID_INDEX
    ON TBL_PORTAL_PORTLET_USER_SIZE (COMPANY_ID);

CREATE INDEX TBL_PORTAL_PORTLET_USER_SIZE_PORTLET_ID_INDEX
    ON TBL_PORTAL_PORTLET_USER_SIZE (PORTLET_ID);

CREATE INDEX TBL_PORTAL_PORTLET_USER_SIZE_TENANT_ID_INDEX
    ON TBL_PORTAL_PORTLET_USER_SIZE (TENANT_ID);

CREATE INDEX TBL_PORTAL_PORTLET_USER_SIZE_USER_ID_INDEX
    ON TBL_PORTAL_PORTLET_USER_SIZE (USER_ID);

CREATE TABLE TBL_PORTAL_TOP_USER
(
    USER_ID    VARCHAR2(100)       NOT NULL,
    TENANT_ID  NUMBER(5, 0) DEFAULT 0 NOT NULL,
    COMPANY_ID VARCHAR2(100)       NOT NULL,
    TYPE       NUMBER(5, 0) DEFAULT 0 NOT NULL,
    CONSTRAINT TBL_PORTAL_TOP_USER
        PRIMARY KEY (USER_ID, TENANT_ID, COMPANY_ID)
);

COMMENT ON TABLE TBL_PORTAL_TOP_USER IS '개인별 탑 메뉴 프레임 타입';
COMMENT ON COLUMN TBL_PORTAL_TOP_USER.USER_ID IS '사용자 아이디';
COMMENT ON COLUMN TBL_PORTAL_TOP_USER.TENANT_ID IS '테넌트 아이디';
COMMENT ON COLUMN TBL_PORTAL_TOP_USER.COMPANY_ID IS '회사 아이디';
COMMENT ON COLUMN TBL_PORTAL_TOP_USER.TYPE IS '타입';

CREATE TABLE TBL_PORTAL_TOP_COMPANY
		(
			COMPANY_ID VARCHAR2(20)       NOT NULL,
			TYPE       NUMBER(5) DEFAULT 0 NOT NULL,
			TENANT_ID  NUMBER(5) DEFAULT 0 NOT NULL,
			CONSTRAINT PK_TBL_PORTAL_TOP_COMPANY
			PRIMARY KEY (COMPANY_ID, TENANT_ID)
		);

CREATE TABLE TBL_REALTIME_NOTIFICATION (
		    NOTISEQ NUMBER(20) NOT NULL,
		    USERID VARCHAR2(80) NOT NULL,
		    MAINTYPE VARCHAR2(20) NOT NULL,
		    SUBTYPE VARCHAR2(20),
		    NOTICONTENT VARCHAR2(2000),
		    SENDERID VARCHAR2(80),
		    SENDERNAME VARCHAR2(100),
		    REGDATE DATE,
		    ISREAD CHAR(1) DEFAULT 'N',
		    READDATE DATE,
		    ETCDATA VARCHAR2(400),
		    ISDELETE CHAR(1) DEFAULT 'N',
		    DELETEDATE DATE,
		    LINKURL VARCHAR2(2000),
		    LINKURL_MOBILE VARCHAR2(2000),
		    VIEWTYPE VARCHAR2(10),
		    VIEWWIDTH NUMBER(11),
		    VIEWHEIGHT NUMBER(11),
		    TENANT_ID NUMBER(5) NOT NULL,
		    COMPANYID VARCHAR2(200),
		    CONSTRAINT PK_TBL_REALTIME_NOTIFICATION
		    PRIMARY KEY (NOTISEQ,TENANT_ID)
		);

--------------------------------------------------------
--  DDL for Table TBL_DISTRIBUTEINFO
--------------------------------------------------------
CREATE TABLE "TBL_DISTRIBUTEINFO"
(
    "SN" NUMBER(10,0) NOT NULL,
    "DOCID" CHAR(20) NOT NULL,
    "RECEIPTDATE" DATE,
    "ORGANID" VARCHAR2(100) NOT NULL,
    "ORGAN" NVARCHAR2(100),
    "ORGANUSERNAME" NVARCHAR2(100),
    "DOCNUMBER" NVARCHAR2(100),
    "MANAGEDEPTID" VARCHAR2(100),
    "MANAGEDEPT" NVARCHAR2(100),
    "ORGDOCNUMCODE" NVARCHAR2(100),
    "DOCTITLE" NVARCHAR2(510),
    "MANAGEDEPT2" NVARCHAR2(100),
    "ORGAN2" NVARCHAR2(100),
    "ORGANUSERNAME2" NVARCHAR2(100),
    "TENANT_ID" NUMBER(5,0) DEFAULT 0 NOT NULL,
    "COMPANYID" VARCHAR2(20) NOT NULL,
    "PARENTDOCID" NVARCHAR2(100),
    "ORGDOCID" NVARCHAR2(100) NOT NULL,
    "DELIVERYSN" NUMBER(10,0),
    "TYPE" NVARCHAR2(100),
    CONSTRAINT "PK_TBL_DISTRIBUTEINFO" PRIMARY KEY ("SN", "DOCID", "ORGANID", "TENANT_ID", "COMPANYID")
);
COMMENT ON TABLE TBL_DISTRIBUTEINFO IS '배부이력 정보';
    
--------------------------------------------------------
--  DDL for Table TBL_EXECUTIVE
--------------------------------------------------------
CREATE TABLE TBL_EXECUTIVE (
        CN NVARCHAR2(50) NOT NULL,
        PRIORITY NVARCHAR2(50) NOT NULL,
        USAGE NVARCHAR2(1) NOT NULL,
        CREATEUSER NVARCHAR2(50) NOT NULL,
        LASTUPDATE DATE NOT NULL,
        COMPANYID VARCHAR2(50) NOT NULL,
        TENANT_ID NUMBER(5) DEFAULT 0 NOT NULL,
        CONSTRAINT TBL_EXECUTIVE PRIMARY KEY (CN, COMPANYID, TENANT_ID)
);
COMMENT ON TABLE TBL_EXECUTIVE IS '임원 테이블';
		

CREATE TABLE TBL_SURVEY_RESULTVIEWPERMISSION (
    SURVEY_ID			NUMBER(11) 		NOT NULL,
    COMPANY_ID			VARCHAR2(100) 	NOT NULL,
    TENANT_ID			NUMBER(9) 			NOT NULL,
    CN					VARCHAR2(100) 	NOT NULL,
    USER_TYPE 			VARCHAR2(30),
    SUBDEPT_PERMITTED 	VARCHAR2(30) 	DEFAULT 'N',
    CNNAME 				VARCHAR2(120),
    CNNAME2 			VARCHAR2(120),
    CONSTRAINT TBL_SURVEY_RESULTVIEWPERMISSION_PK PRIMARY KEY (SURVEY_ID, COMPANY_ID, TENANT_ID, CN)
);

COMMENT ON COLUMN TBL_SURVEY_RESULTVIEWPERMISSION.CN IS '권한자 아이디';
COMMENT ON COLUMN TBL_SURVEY_RESULTVIEWPERMISSION.USER_TYPE IS '권한자 타입';
COMMENT ON COLUMN TBL_SURVEY_RESULTVIEWPERMISSION.SUBDEPT_PERMITTED IS '권한자 하위부서 포함여부';
COMMENT ON COLUMN TBL_SURVEY_RESULTVIEWPERMISSION.CNNAME IS '권한자 이름';
COMMENT ON COLUMN TBL_SURVEY_RESULTVIEWPERMISSION.CNNAME2 IS '권한자 이름';
COMMENT ON TABLE TBL_SURVEY_RESULTVIEWPERMISSION IS '설문 지정공개대상자 리스트 테이블';

CREATE TABLE TBL_SYSTEMCONFIG (
    CODE VARCHAR2(50) NOT NULL,
    CODEVALUE VARCHAR2(2000) NOT NULL,
    DESCRIPTION VARCHAR2(1000),
    WRITERID VARCHAR2(50),
    WRITERNAME VARCHAR2(100),
    WRITEDATE DATE,
    TENANT_ID NUMBER(5) NOT NULL,
    COMPANY_ID VARCHAR2(80) NOT NULL,
    TYPECODE VARCHAR2(80),
    ISDELETEBLOCK CHAR(1) DEFAULT 'N',
    CONSTRAINT PK_TBL_SYSTEMCONFIG PRIMARY KEY (CODE, TENANT_ID, COMPANY_ID)
);

CREATE TABLE TBL_SYSTEMCONFIG_TYPE (
    TYPECODE VARCHAR2(50) NOT NULL,
    TENANT_ID NUMBER(5) NOT NULL,
    COMPANY_ID VARCHAR2(80) NOT NULL,
    TYPENAME VARCHAR2(1000),
    TYPENAME2 VARCHAR2(1000),
    DESCRIPTION CLOB,
    WRITERID VARCHAR2(50),
    WRITERNAME VARCHAR2(100),
    WRITERNAME2 VARCHAR2(100),
    WRITEDATE DATE,
    CONSTRAINT PK_TBL_SYSTEMCONFIG_TYPE PRIMARY KEY (TYPECODE, TENANT_ID, COMPANY_ID)
);

CREATE TABLE TBL_NOTI_EMERGENCY_COMPANY (
    COMPANY_ID VARCHAR2(20) NOT NULL,
    TENANT_ID NUMBER(5) NOT NULL,
    EMERGENCY_CONTENT VARCHAR2(200),
    WRITERID VARCHAR2(100) NOT NULL,
    WRITEDATE DATE,
    CONSTRAINT PK_TBL_NOTI_EMERGENCY_COMPANY PRIMARY KEY (COMPANY_ID, TENANT_ID)
);
CREATE TABLE TBL_BOARD_KEYWORD (
    KEYWORDID   NUMBER(20) NOT NULL,
    KEYWORDNAME NVARCHAR2(100) NOT NULL,
    TENANT_ID   NUMBER(5)    NOT NULL,
    CONSTRAINT PK_TBL_BOARD_KEYWORD PRIMARY KEY (KEYWORDID,  TENANT_ID)
);

CREATE TABLE TBL_BOARD_BOARDITEM_KEYWORD (
    KEYWORDID NUMBER(20) NOT NULL,
    BOARDID NVARCHAR2(40) NOT NULL,
    ITEMID NVARCHAR2(40) NOT NULL,
    TENANT_ID NUMBER(5) NOT NULL,
    SN NUMBER(3) NOT NULL,
    CONSTRAINT PK_TBL_BOARD_BOARDITEM_KEYWORD PRIMARY KEY (KEYWORDID, ITEMID, SN, TENANT_ID)
);

CREATE SEQUENCE "TBL_BOARD_KEYWORD_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE;
 CREATE TABLE tbl_noti_emergency_item (
    NOTIID NUMBER(20) NOT NULL,
    WRITERID VARCHAR2(100) NOT NULL,
    COMPANY_ID VARCHAR2(20) NOT NULL,
    TENANT_ID NUMBER(5) NOT NULL,
    NOTITITLE NVARCHAR2(2000),
    NOTIBODY NVARCHAR2(2000),
    WRITEDATE DATE,
    CONSTRAINT PK_TBL_NOTI_EMERGENCY_ITEM PRIMARY KEY (NOTIID, TENANT_ID)
);

CREATE TABLE TBL_NOTI_EMERGENCY_PERMISSION (
    PERMISSION_CODE NUMBER(20) NOT NULL,
    CN VARCHAR2(100) NOT NULL,
    DEPTID VARCHAR2(100),
    JOBID VARCHAR2(80),
    ROLEID VARCHAR2(80),
    USER_TYPE VARCHAR2(50),
    COMPANY_ID VARCHAR2(200) NOT NULL,
    TENANT_ID NUMBER(5) NOT NULL,
    REGDATE DATE,
    SUBDEPTYN CHAR(1),
    CONSTRAINT PK_TBL_NOTI_EMERGENCY_PERMISSION PRIMARY KEY (PERMISSION_CODE, TENANT_ID)
);

CREATE TABLE TBL_RS_FAV_CAT (
		    CAT_ID VARCHAR2(80) NOT NULL, TOP_ID VARCHAR2(80),
		    USER_ID VARCHAR2(100) NOT NULL, CAT_NAME VARCHAR2(200) NOT NULL,
		    UPDATEDATE TIMESTAMP NOT NULL, COMPANYID VARCHAR2(20) NOT NULL,
		    BRDYN VARCHAR2(10), TENANT_ID NUMBER(5) DEFAULT 0 NOT NULL,
		    CONSTRAINT pk_tbl_rs_fav_cat PRIMARY KEY (CAT_ID, TENANT_ID)
		);
		
CREATE TABLE TBL_RS_CAT_BRD (
		    CAT_ID VARCHAR2(100) NOT NULL, BRD_ID VARCHAR2(80) NOT NULL,
		    USER_ID VARCHAR2(80) NOT NULL,
		    COMPANYID VARCHAR2(80) NOT NULL,
		    UPDATEDATE TIMESTAMP NOT NULL,
		    TENANT_ID NUMBER(5) DEFAULT 0 NOT NULL,
		    CONSTRAINT pk_tbl_rs_cat_brd PRIMARY KEY (CAT_ID, BRD_ID, USER_ID, TENANT_ID)
		);

CREATE TABLE JMOCHA_MAIL_TAG (
 IDX NUMBER,
 USER_NAME NVARCHAR2(200) NOT NULL,
 NAME NVARCHAR2(100) NOT NULL,
 CONSTRAINT JMOCHA_MAIL_TAG_PK PRIMARY KEY (IDX),
 CONSTRAINT JMOCHA_MAIL_TAG_FK FOREIGN KEY (USER_NAME) REFERENCES JAMES_USER (USER_NAME) ON DELETE CASCADE,
 CONSTRAINT JMOCHA_MAIL_TAG_UQ UNIQUE (USER_NAME, NAME)
);
			
CREATE SEQUENCE SEQ_JMOCHA_MAIL_TAG INCREMENT BY 1 MINVALUE 0 MAXVALUE 9999999999999999999999999999;

CREATE TABLE JMOCHA_MAIL_TAG_CONFIG (
 USER_NAME NVARCHAR2(200),
 ENABLE CHAR(1) NOT NULL,
 ORDERBY CHAR(1) NOT NULL,
 CONSTRAINT JMOCHA_MAIL_TAG_CONFIG_PK PRIMARY KEY (USER_NAME),
 CONSTRAINT JMOCHA_MAIL_TAG_CONFIG_FK FOREIGN KEY (USER_NAME) REFERENCES JAMES_USER (USER_NAME) ON DELETE CASCADE,
 CONSTRAINT JMOCHA_MAIL_TAG_CONFIG_CHECK CHECK (ENABLE IN ('0', '1')),
 CONSTRAINT JMOCHA_MAIL_TAG_CONFIG_CHECK2 CHECK (ORDERBY IN ('0', '1', '2'))
);	

--------------------------------------------------------
--  DDL for Table JMOCHA_MAIL_BLOCKED
--------------------------------------------------------

CREATE TABLE JMOCHA_MAIL_BLOCKED
(   MESSAGE_ID VARCHAR(500) NOT NULL,
    CONSTRAINT PK_JMOCHA_MAIL_BLOCKED PRIMARY KEY (MESSAGE_ID)
);
CREATE TABLE "TBL_BOARD_COMMENT_ATTACHMENTS" 
(   "ITEMID" NVARCHAR2(38) NOT NULL,
    "REPLYID" NVARCHAR2(38) NOT NULL,
    "SN" NUMBER(5,0) NOT NULL,
    "FILEPATH" NVARCHAR2(400) DEFAULT NULL, 
    "FILESIZE" NVARCHAR2(50) DEFAULT NULL, 
    "FILENAME" NVARCHAR2(400) DEFAULT NULL, 
    "TENANT_ID" NUMBER(5,0) NOT NULL,
	CONSTRAINT PK_TBL_BOARD_COMMENT_ATTACHMENTS PRIMARY KEY (ITEMID, REPLYID, SN, TENANT_ID)
);

COMMENT ON COLUMN TBL_BOARD_COMMENT_ATTACHMENTS.ITEMID IS '게시글 아이디';
COMMENT ON COLUMN TBL_BOARD_COMMENT_ATTACHMENTS.REPLYID IS '댓글 아이디';
COMMENT ON COLUMN TBL_BOARD_COMMENT_ATTACHMENTS.SN IS '첨부파일 순서';
COMMENT ON COLUMN TBL_BOARD_COMMENT_ATTACHMENTS.FILEPATH IS '첨부파일 저장경로';
COMMENT ON COLUMN TBL_BOARD_COMMENT_ATTACHMENTS.FILESIZE IS '첨부파일 크기';
COMMENT ON COLUMN TBL_BOARD_COMMENT_ATTACHMENTS.FILENAME IS '첨부파일 이름';
COMMENT ON COLUMN TBL_BOARD_COMMENT_ATTACHMENTS.TENANT_ID IS '테넌트 아이디';

CREATE TABLE TBL_C_CLUBGUEST_ONELINEREPLY (
    ITEMID NUMBER NOT NULL,
    REPLYID VARCHAR(38) NOT NULL,
    C_CLUBNO VARCHAR(38) NOT NULL,
    USERID NVARCHAR2(50),
    USERNAME NVARCHAR2(50),
    USERNAME2 NVARCHAR2(50),
    WRITEDATE DATE,
    CONTENT NVARCHAR2(300),
    TENANT_ID NUMBER DEFAULT 0,
    COMPANYID VARCHAR2(80),
    CONSTRAINT "TBL_C_CLUBGUEST_ONELINEREPLY_PK" PRIMARY KEY (ITEMID, REPLYID, TENANT_ID)
);

COMMENT ON COLUMN TBL_C_CLUBGUEST_ONELINEREPLY.ITEMID IS '방명록 아이디';
COMMENT ON COLUMN TBL_C_CLUBGUEST_ONELINEREPLY.REPLYID IS '방명록 댓글 아이디';
COMMENT ON COLUMN TBL_C_CLUBGUEST_ONELINEREPLY.C_CLUBNO IS '커뮤니티 아이디';
COMMENT ON COLUMN TBL_C_CLUBGUEST_ONELINEREPLY.USERID IS '방명록 작성자 아이디';
COMMENT ON COLUMN TBL_C_CLUBGUEST_ONELINEREPLY.USERNAME IS '방명록 작성자 이름';
COMMENT ON COLUMN TBL_C_CLUBGUEST_ONELINEREPLY.USERNAME2 IS '방명록 작성자 이름 다국어';
COMMENT ON COLUMN TBL_C_CLUBGUEST_ONELINEREPLY.WRITEDATE IS '방명록 댓글 작성날짜';
COMMENT ON COLUMN TBL_C_CLUBGUEST_ONELINEREPLY.CONTENT IS '방명록 댓글 내용';
COMMENT ON COLUMN TBL_C_CLUBGUEST_ONELINEREPLY.TENANT_ID IS '테넌트 아이디';
COMMENT ON COLUMN TBL_C_CLUBGUEST_ONELINEREPLY.COMPANYID IS '회사 아이디';

COMMENT ON TABLE TBL_C_CLUBGUEST_ONELINEREPLY IS '커뮤니티 방명록 댓글 정보 테이블';

CREATE TABLE TBL_GONGRAMDELETEHISTORY (
	DOCID CHAR(20 CHAR), 
	APRMEMBERSN NUMBER(10,0), 
	APRTYPE CHAR(3 CHAR), 
	APRSTATE CHAR(3 CHAR), 
	APRMEMBERID VARCHAR2(100 CHAR), 
	APRMEMBERISDEPTYN CHAR(1 CHAR), 
	APRMEMBERNAME NVARCHAR2(100), 
	APRMEMBERJOBTITLE NVARCHAR2(100), 
	APRMEMBERDEPTID VARCHAR2(100 CHAR), 
	APRMEMBERDEPTNAME NVARCHAR2(100), 
	APRMEMBERLDAPPATH VARCHAR2(100 CHAR), 
	RECEIVEDDATE DATE, 
	PROCESSDATE DATE,
	DELETEDATE DATE,
	REASONDONOTAPPROV NVARCHAR2(510), 
	ISPROPOSERYN CHAR(1 CHAR), 
	ISBRIEFUSERYN CHAR(1 CHAR), 
	APRMEMBERNAME2 NVARCHAR2(100), 
	APRMEMBERJOBTITLE2 NVARCHAR2(100), 
	APRMEMBERDEPTNAME2 NVARCHAR2(100), 
	TENANT_ID NUMBER(5,0) DEFAULT 0, 
	COMPANYID VARCHAR2(20 BYTE),
	CONSTRAINT PK_TBL_GONGRAMDELETEHISTORY PRIMARY KEY (DOCID, APRMEMBERID, TENANT_ID, COMPANYID)
);

CREATE TABLE "TBL_SCHEDULEGATHER" (
    "GROUPID"      NVARCHAR2(50) NOT NULL ENABLE,
    "GROUPNAME"    NVARCHAR2(50) NOT NULL ENABLE,
    "CREATORID"    NVARCHAR2(50),
    "CREATORNAME"  NVARCHAR2(50) NOT NULL ENABLE,
    "CREATORNAME2" NVARCHAR2(50),
    "DESCRIPTION"  NVARCHAR2(250) NOT NULL ENABLE,
    "CREATEDATE"   DATE,
    "TENANT_ID"    NUMBER(5,0) NOT NULL ENABLE,
    "COMPANYID"    VARCHAR2(40),
    PRIMARY KEY ("GROUPID")
);

CREATE TABLE "TBL_SCHEDULEGATHERMEMBER" (
    "GROUPID"     NVARCHAR2(50) NOT NULL ENABLE,
    "MEMBERID"    NVARCHAR2(50) NOT NULL ENABLE,
    "MEMBERNAME"  NVARCHAR2(50) NOT NULL ENABLE,
    "MEMBERNAME2" NVARCHAR2(50),
    "MEMBERDEPTID" NVARCHAR2(50),
    "TENANT_ID"   NUMBER(5,0) NOT NULL ENABLE,
    PRIMARY KEY ("GROUPID", "MEMBERID")
);

CREATE TABLE TBL_BOARD_ITEM_RATING (
    ITEMID NVARCHAR2(76) NOT NULL,
    USERID NVARCHAR2(80) NOT NULL,
    RATING NVARCHAR2(2) NOT NULL,
    RATINGDATE NVARCHAR2(40) NOT NULL,
    TENANT_ID NUMBER(5) NOT NULL,
    COMPANYID NVARCHAR2(80) DEFAULT NULL,
    CONSTRAINT PK_TBL_BOARD_ITEM_RATING PRIMARY KEY (ITEMID, USERID, TENANT_ID)
);

CREATE TABLE TBL_BOARD_ITEM_RATING_SUMMARY (
    ITEMID NVARCHAR2(76) NOT NULL,
    TOTALRATERS NVARCHAR2(10) NOT NULL,
    TOTALSCORE NVARCHAR2(6) NOT NULL,
    AVERAGESCORE NVARCHAR2(5) NOT NULL,
    TENANT_ID NUMBER(5) NOT NULL,
    COMPANYID NVARCHAR2(80) DEFAULT NULL,
    CONSTRAINT PK_TBL_BOARD_ITEM_RATING_SUMMARY PRIMARY KEY (ITEMID, TENANT_ID)
);

CREATE TABLE TBL_CONNATTACHINFODATA (
  KEYID VARCHAR2(50) NOT NULL,
  ATTACHSN NUMBER(10, 0) NOT NULL,
  ATTACHFILENAME NVARCHAR2(510) DEFAULT NULL,
  ATTACHFILEHREF NVARCHAR2(510) DEFAULT NULL,
  ATTACHFILESIZE NUMBER DEFAULT NULL,
  ATTACHUSERID VARCHAR2(400) DEFAULT NULL,
  CONSTRAINT PK_TBL_CONNATTACHINFODATA PRIMARY KEY (KEYID, ATTACHSN)
);

CREATE TABLE TBL_MEAL_PLAN (
		    MEALDATE DATE,
		    ACOURSE VARCHAR2(300) DEFAULT '',
		    BCOURSE VARCHAR2(300) DEFAULT '',
		    SALADBAR VARCHAR2(300) DEFAULT '',
		    DESSERT VARCHAR2(300) DEFAULT '',
		    TOTALCAL NUMBER DEFAULT 0,
			COMPANYID VARCHAR2(160),
			TENANT_ID NUMBER(5,0) DEFAULT 0,
		    CONSTRAINT TBL_MEAL_PLAN_PK PRIMARY KEY (MEALDATE, COMPANYID, TENANT_ID)
);

COMMENT ON TABLE TBL_MEAL_PLAN IS '식단 정보 테이블';


CREATE TABLE TBL_STAT_MENU_USER
(
    USER_ID    NVARCHAR2(80)  NOT NULL,
    TENANT_ID  NUMBER(5, 0),
    COMPANY_ID NVARCHAR2(100) NOT NULL,
    IPADDRESS  NVARCHAR2(15),
    YEAR       NUMBER(4, 0)   NOT NULL,
    MONTH      NUMBER(2, 0)   NOT NULL,
    DAY        NUMBER(2, 0)   NOT NULL,
    HOUR       NUMBER(2, 0)   NOT NULL,
    TIME_CODE  NUMBER(10, 0)  NOT NULL,

    MENU_ID    NUMBER(10, 0),
    CODE       NVARCHAR2(10),
    STAT_COUNT NUMBER(20, 0)  NOT NULL,

    CONSTRAINT PK_TBL_STAT_MENU_USER PRIMARY KEY (TENANT_ID, COMPANY_ID, USER_ID, MENU_ID, TIME_CODE)
);
CREATE INDEX IDX_STAT_MENU_USER_TIME ON TBL_STAT_MENU_USER (YEAR, MONTH, DAY, HOUR);
CREATE INDEX IDX_STAT_MENU_USER_TIME_CODE ON TBL_STAT_MENU_USER (TIME_CODE);
CREATE INDEX IDX_STAT_MENU_USER_MENU ON TBL_STAT_MENU_USER (MENU_ID);

COMMENT ON TABLE TBL_STAT_MENU_USER IS '유저별 메뉴 통계 시간별 집계 테이블';
COMMENT ON COLUMN TBL_STAT_MENU_USER.USER_ID IS '유저 id(비회원은 ip)';
COMMENT ON COLUMN TBL_STAT_MENU_USER.COMPANY_ID IS '회사 id';
COMMENT ON COLUMN TBL_STAT_MENU_USER.YEAR IS '집계 년도(YYYY)';
COMMENT ON COLUMN TBL_STAT_MENU_USER.MONTH IS '집계 월(01 ~ 12)';
COMMENT ON COLUMN TBL_STAT_MENU_USER.DAY IS '집계 일(01 ~ 31)';
COMMENT ON COLUMN TBL_STAT_MENU_USER.HOUR IS '집계 시간(00 ~ 23)';
COMMENT ON COLUMN TBL_STAT_MENU_USER.TIME_CODE IS '빠른 범위 검색/정렬용 (형식: YYYYMMDDHH)';

CREATE TABLE TBL_STAT_MENU_USER_MONTH
(
    USER_ID    NVARCHAR2(80)  NOT NULL,
    TENANT_ID  NUMBER(5, 0)   NOT NULL,
    COMPANY_ID NVARCHAR2(100) NOT NULL,
    IPADDRESS  NVARCHAR2(15),
    YEAR       NUMBER(4, 0)   NOT NULL,
    MONTH      NUMBER(2, 0)   NOT NULL,
    TIME_CODE  NUMBER(10, 0)  NOT NULL,

    MENU_ID    NUMBER(10, 0),
    CODE       NVARCHAR2(6),
    STAT_COUNT NUMBER(20, 0)  NOT NULL,

    CONSTRAINT PK_TBL_STAT_MENU_USER_MONTH PRIMARY KEY (TENANT_ID, COMPANY_ID, USER_ID, MENU_ID, TIME_CODE)
);

CREATE INDEX IDX_STAT_MENU_USER_MONTH_TIME ON TBL_STAT_MENU_USER_MONTH (YEAR, MONTH);
CREATE INDEX IDX_STAT_MENU_USER_MONTH_TIME_CODE ON TBL_STAT_MENU_USER_MONTH (TIME_CODE);
CREATE INDEX IDX_STAT_MENU_USER_MONTH_MENU ON TBL_STAT_MENU_USER_MONTH (MENU_ID);

COMMENT ON TABLE TBL_STAT_MENU_USER_MONTH IS '유저별 메뉴 통계 시간별 집계 테이블';
COMMENT ON COLUMN TBL_STAT_MENU_USER_MONTH.USER_ID IS '유저 id(비회원은 ip)';
COMMENT ON COLUMN TBL_STAT_MENU_USER_MONTH.COMPANY_ID IS '회사 id';
COMMENT ON COLUMN TBL_STAT_MENU_USER_MONTH.YEAR IS '집계 년도(YYYY)';
COMMENT ON COLUMN TBL_STAT_MENU_USER_MONTH.MONTH IS '집계 월(01 ~ 12)';
COMMENT ON COLUMN TBL_STAT_MENU_USER_MONTH.TIME_CODE IS '빠른 범위 검색/정렬용 (형식: YYYYMM)';

CREATE TABLE TBL_STAT_MENU_DEPT
(
    DEPT_ID    NVARCHAR2(80)  NOT NULL,
    TENANT_ID  NUMBER(5, 0)   NOT NULL,
    COMPANY_ID NVARCHAR2(100) NOT NULL,
    YEAR       NUMBER(4, 0)   NOT NULL,
    MONTH      NUMBER(2, 0)   NOT NULL,
    DAY        NUMBER(2, 0)   NOT NULL,
    HOUR       NUMBER(2, 0)   NOT NULL,
    TIME_CODE  NUMBER(10, 0)  NOT NULL,

    MENU_ID    NUMBER(10, 0),
    CODE       NVARCHAR2(10),
    STAT_COUNT NUMBER(20, 0)  NOT NULL,

    CONSTRAINT PK_TBL_STAT_MENU_DEPT PRIMARY KEY (TENANT_ID, COMPANY_ID, DEPT_ID, MENU_ID, TIME_CODE)
);
CREATE INDEX IDX_STAT_MENU_DEPT_TIME ON TBL_STAT_MENU_DEPT (YEAR, MONTH, DAY, HOUR);
CREATE INDEX IDX_STAT_MENU_DEPT_TIME_CODE ON TBL_STAT_MENU_DEPT (TIME_CODE);
CREATE INDEX IDX_STAT_MENU_DEPT_MENU ON TBL_STAT_MENU_DEPT (MENU_ID);

COMMENT ON TABLE TBL_STAT_MENU_DEPT IS '부서별 메뉴 통계 시간별 집계 테이블';
COMMENT ON COLUMN TBL_STAT_MENU_DEPT.DEPT_ID IS '부서 id';
COMMENT ON COLUMN TBL_STAT_MENU_DEPT.COMPANY_ID IS '회사 id';
COMMENT ON COLUMN TBL_STAT_MENU_DEPT.YEAR IS '집계 년도(YYYY)';
COMMENT ON COLUMN TBL_STAT_MENU_DEPT.MONTH IS '집계 월(01 ~ 12)';
COMMENT ON COLUMN TBL_STAT_MENU_DEPT.DAY IS '집계 일(01 ~ 31)';
COMMENT ON COLUMN TBL_STAT_MENU_DEPT.HOUR IS '집계 시간(00 ~ 23)';
COMMENT ON COLUMN TBL_STAT_MENU_DEPT.TIME_CODE IS '빠른 범위 검색/정렬용 (형식: YYYYMMDDHH)';

CREATE TABLE TBL_STAT_MENU_DEPT_MONTH
(
    DEPT_ID    NVARCHAR2(80)  NOT NULL,
    TENANT_ID  NUMBER(5, 0)   NOT NULL,
    COMPANY_ID NVARCHAR2(100) NOT NULL,
    YEAR       NUMBER(4, 0)   NOT NULL,
    MONTH      NUMBER(2, 0)   NOT NULL,
    TIME_CODE  NUMBER(10, 0)  NOT NULL,

    MENU_ID    NUMBER(10, 0),
    CODE       NVARCHAR2(6),
    STAT_COUNT NUMBER(20, 0)  NOT NULL,

    CONSTRAINT PK_TBL_STAT_MENU_DEPT_MONTH PRIMARY KEY (TENANT_ID, COMPANY_ID, DEPT_ID, MENU_ID, TIME_CODE)
);
CREATE INDEX IDX_STAT_MENU_DEPT_MONTH_TIME ON TBL_STAT_MENU_DEPT_MONTH (YEAR, MONTH);
CREATE INDEX IDX_STAT_MENU_DEPT_MONTH_TIME_CODE ON TBL_STAT_MENU_DEPT_MONTH (TIME_CODE);
CREATE INDEX IDX_STAT_MENU_DEPT_MONTH_MENU ON TBL_STAT_MENU_DEPT_MONTH (MENU_ID);

COMMENT ON TABLE TBL_STAT_MENU_DEPT_MONTH IS '부서별 메뉴 통계 시간별 집계 테이블';
COMMENT ON COLUMN TBL_STAT_MENU_DEPT_MONTH.DEPT_ID IS '부서 id';
COMMENT ON COLUMN TBL_STAT_MENU_DEPT_MONTH.COMPANY_ID IS '회사 id';
COMMENT ON COLUMN TBL_STAT_MENU_DEPT_MONTH.YEAR IS '집계 년도(YYYY)';
COMMENT ON COLUMN TBL_STAT_MENU_DEPT_MONTH.MONTH IS '집계 월(01 ~ 12)';
COMMENT ON COLUMN TBL_STAT_MENU_DEPT_MONTH.TIME_CODE IS '빠른 범위 검색/정렬용 (형식: YYYYMM)';

CREATE TABLE TBL_BOARD_MODIFYHISTORY (
    ITEMID NVARCHAR2(40),
    PARENTITEMID NVARCHAR2(40),
    VERSION NVARCHAR2(5),
    MODIFYUSERID NVARCHAR2(80),
    MODIFYUSERNAME NVARCHAR2(120),
    MODIFIEDDATE DATE,
    TENANT_ID NUMBER(5, 0),
    CONSTRAINT PK_TBL_BOARD_MODIFYHISTORY PRIMARY KEY (ITEMID, TENANT_ID)
);