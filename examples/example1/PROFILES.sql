declare @id int, @profile_id numeric(10,0), @signed_ips varchar(255)

--create temp table
SELECT SYNCHRONIZE_ID, PROFILE_ID into #temp
FROM IPWORKFLOW..cgi_SYNCHRONIZE
WHERE PROFILE_STATUS = 'ACTIVE'
AND VENDOR_ID IS NULL

--loop one by one in this temp table
while exists (select 1 from #temp)
begin
  set rowcount 1
  select @id = SYNCHRONIZE_ID, @profile_id= PROFILE_ID from #temp --set up @profile_id from #temp table
  set rowcount 0
  delete from #temp where SYNCHRONIZE_ID = @id
  
--prepare column separately
  select @signed_ips = 
    CASE WHEN COUNT(1)>0 THEN 'NO' ELSE 'OTHER' END --CASE clause
    FROM dbo.sig
    WHERE obj_id = @profile_id
    AND sig_type_code =  'IDENTIC'
    AND (marked_by is null and marked_dt is null)
    AND (deleted_by is null and deleted_dt is null)

--prepare column separately
  if @signed_ips = 'OTHER' 
    select @signed_ips = 
    CASE WHEN COUNT(1)>0 THEN 'YES' ELSE 'N/A' END 
    FROM dbo.sig
    WHERE obj_id = @profile_id
    AND sig_type_code =  'DECISION_MARKER'
    AND (deleted_by is null and deleted_dt is null)

--create table and fill the data by SELECT clause.
INSERT INTO cgi_PROFILES(IPWF_PROFILE_ID, PROFILE_NAME, IP_ID, LINE_OF_BUSINESS, SIGNED_IPS)
SELECT
p.id IPWF_PROFILE_ID,
p.name PROFILE_NAME,
ips.code IP_ID,
(CASE WHEN tp.code='SPC' THEN 'Stonegate' WHEN tp.code='UFC' THEN 'Assante' END) LINE_OF_BUSINESS,
SIGNED_IPS = @signed_ips
FROM
IPWORKFLOW..profile p,
IPWORKFLOW..ips ips,
TA_MAIN..portfolio po,
TA_MAIN..ud_manager um,
TA_MAIN..third_party tp
WHERE ips.id = p.ips_id
AND po.code = ips.code
AND um.ud_id = po.admin_mgr_id
AND tp.id = um.ud_dealer_third_id
AND p.id = @profile_id

end
