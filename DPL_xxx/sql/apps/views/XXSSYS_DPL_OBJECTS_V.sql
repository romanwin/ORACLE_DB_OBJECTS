CREATE OR REPLACE VIEW XXSSYS_DPL_OBJECTS_V AS
SELECT 'BINARY_FILE' CATEGORY_CODE
       , 'REPORT' OBJECT_TYPE
       , fav.APPLICATION_SHORT_NAME
       , null SCHEMA
       , EXECUTION_FILE_NAME OBJECT_NAME
   FROM FND_EXECUTABLES_FORM_V fefv
      , fnd_application_vl fav
  WHERE fefv.executable_id > 4
    and (fefv.EXECUTION_METHOD_CODE = 'P')
    and fav.APPLICATION_ID = fefv.APPLICATION_ID
union
select 'BINARY_FILE' CATEGORY_CODE
     , 'FORM' OBJECT_TYPE
     , fav.APPLICATION_SHORT_NAME
     , null SCHEMA
     , ff.FORM_NAME OBJECT_NAME
  from FND_FORM_VL ff
     , fnd_application_vl fav
 where 1=1
   and fav.APPLICATION_ID = ff.APPLICATION_ID
union
SELECT 'BINARY_FILE' CATEGORY_CODE
     , 'HOST' OBJECT_TYPE
     , fav.APPLICATION_SHORT_NAME
     , null SCHEMA
     , fefv.EXECUTION_FILE_NAME OBJECT_NAME
  FROM FND_EXECUTABLES_FORM_V fefv
      , fnd_application_vl fav
 WHERE executable_id > 4
   and EXECUTION_METHOD_CODE = 'H'
   and fav.APPLICATION_ID = fefv.APPLICATION_ID
union
SELECT 'BINARY_FILE' CATEGORY_CODE
     , 'WORKFLOW' OBJECT_TYPE
     , null APPLICATION_SHORT_NAME
     , null SCHEMA
     , witv.NAME OBJECT_NAME
  from WF_ITEM_TYPES_VL witv
----------------------------------- SETUP ---------------------
union
-- MESSAGE
select 'SETUP' CATEGORY_CODE
     , 'MESSAGE' OBJECT_TYPE
     , fav.APPLICATION_SHORT_NAME
     , null SCHEMA
     , FNM.MESSAGE_NAME
  from FND_NEW_MESSAGES FNM
     , fnd_application_vl fav
 where FNM.Message_Name like('XX%')
   and fav.APPLICATION_ID = FNM.APPLICATION_ID
union
--'PROFILE'
SELECT 'SETUP' CATEGORY_CODE
     , 'PROFILE' OBJECT_TYPE
     , fav.APPLICATION_SHORT_NAME
     , null SCHEMA
     , fpov.PROFILE_OPTION_NAME OBJECT_NAME
  FROM FND_PROFILE_OPTIONS_VL fpov
     , fnd_application_vl fav
 WHERE PROFILE_OPTION_NAME LIKE 'XX%'
   AND fav.APPLICATION_ID = fpov.APPLICATION_ID
--'VALUESET'
union
SELECT 'SETUP' CATEGORY_CODE
     , 'VALUESET' OBJECT_TYPE
     , null APPLICATION_ID
     , null SCHEMA
     , ffvs.flex_value_set_name
  FROM FND_FLEX_VALUE_SETS ffvs
 WHERE ffvs.flex_value_set_name like('XX%')
union
-- 'ALERT' ---
select 'SETUP' CATEGORY_CODE
     , 'ALERT' OBJECT_TYPE
     , fav.APPLICATION_SHORT_NAME
     , null SCHEMA
     , aa.alert_name OBJECT_NAME
  from ALR_ALERTS aa
     , fnd_application_vl fav
  where aa.alert_name like('XX%')
    and fav.APPLICATION_ID = aa.application_id
--'PROGRAM'
union
select 'SETUP' CATEGORY_CODE
     , 'PROGRAM' OBJECT_TYPE
     , fav.APPLICATION_SHORT_NAME
     , null SCHEMA
     , fcpv.CONCURRENT_PROGRAM_NAME OBJECT_NAME
  from FND_CONCURRENT_PROGRAMS_VL fcpv
     , fnd_application_vl fav
 where fcpv.CONCURRENT_PROGRAM_NAME like('XX%')
   and fav.APPLICATION_ID = fcpv.APPLICATION_ID
union
--'LOOKUP'
select 'SETUP' CATEGORY_CODE
     , 'LOOKUP' OBJECT_TYPE
     , fav.APPLICATION_SHORT_NAME
     , null SCHEMA
     , flt.lookup_type OBJECT_NAME
from FND_LOOKUP_TYPES flt
   , fnd_application_vl fav
where fav.APPLICATION_ID = flt.application_id
union
--'LOOKUP'
select 'SETUP' CATEGORY_CODE
     , 'XMLPDATASOURCE' OBJECT_TYPE
     , DsDefinitionsVlEO.APPLICATION_SHORT_NAME
     , null SCHEMA
     , DsDefinitionsVlEO.DATA_SOURCE_CODE OBJECT_NAME
  FROM XDO_DS_DEFINITIONS_VL DsDefinitionsVlEO
 Where DsDefinitionsVlEO.DATA_SOURCE_CODE like 'XX%'
union
-------------------------------------------------- SQL --
select 'SQL' CATEGORY_CODE
     , xxcust.OBJECT_TYPE
     , null  APPLICATION_SHORT_NAME
     , aos.OWNER SCHEMA
     , aos.OBJECT_NAME
from all_objects aos
   , (select xds.schema , xds.object_type
        from xxssys_dpl_setup xds
       where xds.category_code = 'SQL' ) xxcust
where upper(xxcust.schema) =  upper(aos.OWNER)
  and decode(aos.object_type ,
             'PACKAGE', 'PACKAGE_SPEC',
             'PACKAGE BODY', 'PACKAGE_BODY',
             aos.object_type
            ) = xxcust.OBJECT_TYPE
  and aos.OBJECT_NAME like('XX%')
;
