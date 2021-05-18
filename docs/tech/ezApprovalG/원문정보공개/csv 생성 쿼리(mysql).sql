select 
	tbl_opengovdocinfo.docid,
    '' as 'n2',
    '' as 'n3',
    '' as 'n4',
    '' as 'n5',
    '' as 'n6',
    '' as 'n7',
    tbl_endaprdocinfo.doctitle,
    '' as 'n9',
    date_format(tbl_opengovdocinfo.createdate, "%Y%m%d%H%i%s") as createdate,
    'B551904' as companycode,
    '한국고용정보원' as companyname,
    tbl_endaprdocinfo.writerdeptid,
    tbl_endaprdocinfo.writerdeptname,
    tbl_endaprdocinfo.writername,
    '' as 'n16',
    tbl_endaprdocinfo.docno,
    tbl_cabinetclass.keepingperiod,
    tbl_expendaprdocinfo.publicitycode,
    tbl_opengovdocinfo.basis,
    tbl_opengovdocinfo.reason,
    '' as 'n22',
    '' as 'n23',
    '' as 'n24',
    '' as 'n25',
    tbl_opengovdocinfo.listopenflag,
    '' as 'n27',
    '' as 'n28',
    tbl_record.aprmembertitle,
    (select aprmemberjobtitle from tbl_endaprlineinfo where docid = tbl_opengovdocinfo.docid and aprtype in ('001' or '016' or '004') order by aprmembersn desc limit 1) as aprmemberjobtitle,
    ifnull(tbl_opengovdocinfo.openlimitdate, curdate()-1) as openlimitdate,
    '' as 'n32',
    '' as 'n33',
    '01' as 'n34',
    (select 
		concat('본문:', tbl_opengovdocinfo.docid,
        ':결재본문.hwp:',
        ifnull(tbl_opengovdocinfo.docsize,'60112'),
        ':0:',
        case when openflag = '3' then 'N' ELSE 'Y' end,
        case when attach is null then '' else attach end
        )
	) as filelist
    from tbl_opengovdocinfo
    inner join tbl_endaprdocinfo 
    on tbl_opengovdocinfo.docid = tbl_endaprdocinfo.docid
    and tbl_opengovdocinfo.tenant_id = tbl_endaprdocinfo.tenant_id
    and tbl_endaprdocinfo.companyid = tbl_endaprdocinfo.companyid
    inner join tbl_expendaprdocinfo
    on tbl_opengovdocinfo.docid = tbl_expendaprdocinfo.docid
    and tbl_opengovdocinfo.tenant_id = tbl_expendaprdocinfo.tenant_id
    and tbl_opengovdocinfo.companyid = tbl_expendaprdocinfo.companyid
    inner join tbl_record
    on tbl_opengovdocinfo.docid = tbl_record.docid
    and tbl_opengovdocinfo.tenant_id = tbl_record.tenant_id
    and tbl_opengovdocinfo.companyid = tbl_record.companyid
    inner join tbl_cabinet
    on tbl_expendaprdocinfo.cabinetid = tbl_cabinet.cabinetid
    inner join tbl_cabinetclass
    on tbl_cabinet.cabinetclassno = tbl_cabinetclass.cabinetclassno
    left outer join 
    (
		select docid, group_concat(attach SEPARATOR '') as attach 
		from
		(
			select tbl_opengovfileinfo.docid, concat(':첨부:',tbl_opengovfileinfo.docid, sn,':',attachfilename, ':',ifnull(attachfilesize, '1024'), ':',sn-1,':', fileopenflag) as attach 
			from tbl_opengovfileinfo
			inner join tbl_endattachinfo
			on tbl_opengovfileinfo.docid = tbl_endattachinfo.docid
			and tbl_opengovfileinfo.sn = tbl_endattachinfo.attachfilesn
			and tbl_opengovfileinfo.tenant_id = tbl_endattachinfo.tenant_id
			and tbl_opengovfileinfo.companyid = tbl_endattachinfo.companyid
		) attachlist
        group by docid
    ) fileattachlist
    on tbl_opengovdocinfo.docid = fileattachlist.docid
    where (tbl_endaprdocinfo.docstate <> '011' or tbl_endaprdocinfo.docstate is null)
    and date(tbl_opengovdocinfo.createdate) = date_sub(curdate(), INTERVAL 1 DAY)