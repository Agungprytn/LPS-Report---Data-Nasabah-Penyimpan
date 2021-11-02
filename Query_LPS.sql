
INSERT INTO IRPT_RPT_DAT_PTCL 
	(
		RPT_CD
	,   BASC_DT
	,   VER_NO
	,   SEQ_NO
	,   BR_CD  
	,   CHR_COL_01
	,   CHR_COL_02
	,   CHR_COL_03
	,   CHR_COL_04
	,   CHR_COL_05
	,   CHR_COL_06
	,   CHR_COL_07
	,   CHR_COL_08
	,   CHR_COL_09
	,   CHR_COL_10
	,   CHR_COL_11
	,   CHR_COL_12
	,   CHR_COL_13
	,   CHR_COL_14
	,   CHR_COL_15
	,   CHR_COL_16
	,   CHR_COL_17
	,   CHR_COL_18  
	,   CHR_COL_19  
	,   CHR_COL_20  
	)
		SELECT 
			   V_RPT_CD 	                      AS RPT_CD
			,  V_PROC_BASC_DT                     AS BASC_DT
			,  1                                  AS VER_NO
			,  ROWNUM                             AS SEQ_NO  
			,  '0000'                             AS BR_CD  
			,  CUST_NO                            AS CHR_COL_01
			,  CUST_ENM                           AS CHR_COL_02
			,  NPWP                               AS CHR_COL_03
			,  ID_TP                              AS CHR_COL_04
			,  ID_NO                              AS CHR_COL_05
			,  MOTHER_NM                          AS CHR_COL_06
			,  BIRTH_PLACE                        AS CHR_COL_07
			,  BIRTH_DT                           AS CHR_COL_08
			,  SIUP_NO                            AS CHR_COL_09
			,  BOD_NM                             AS CHR_COL_10
			,  ID_PK                              AS CHR_COL_11
			,  BOD_ID_NO                          AS CHR_COL_12
			,  ADDR_ENM_1                         AS CHR_COL_13
			,  CITY_NM                            AS CHR_COL_14
			,  CTRY_CD                            AS CHR_COL_15
			,  TEL_NO                             AS CHR_COL_16
			,  FRAUD_YN                           AS CHR_COL_17
			,  HUB_DGN_BANK                       AS CHR_COL_18             
			,  GOL_NASABAH                        AS CHR_COL_19             
			,  KAT_USAHA                          AS CHR_COL_20             
		FROM ( 
          SELECT 
		    CASE WHEN X.CUST_ENM LIKE '%BPR%' THEN 'BPR'||X.CUST_NO 
		  	   ELSE X.CUST_NO
		     END AS CUST_NO 
		,    X.CUST_ENM
		,    REPLACE(REPLACE(X.NPWP,'-',''),'.','')       							    AS NPWP
		,    X.ID_TP 
		,    REPLACE(REPLACE(REPLACE(REPLACE(X.ID_NO,'-',''),':',''),'.',''),'/','')   	AS ID_NO
		,    X.MOTHER_NM 
		,    CASE WHEN M.CODE IS NULL     THEN UPPER(X.BIRTH_PLACE) 
		  	      WHEN M.CODE IS NOT NULL THEN M.CODE 
		     END AS BIRTH_PLACE
		,    TO_CHAR(X.BIRTH_DT,'YYYYMMDD')              								 AS BIRTH_DT
		,    REPLACE(REPLACE(REPLACE(REPLACE(X.SIUP_NO,'-',''),':',''),'.',''),'/','')   AS SIUP_NO
		,    X.BOD_NM
		,    X.ID_PK
		,    REPLACE(REPLACE(REPLACE(REPLACE(X.BOD_ID_NO,'-',''),':',''),'.',''),'/','') AS BOD_ID_NO
		,    X.ADDR_ENM_1
		,    X.CITY_NM
		,    CASE WHEN X.CTRY_CD LIKE     '%ID%' THEN 'WNI'
		  	      WHEN X.CTRY_CD NOT LIKE '%ID%' THEN 'WNA'
		       ELSE X.CTRY_CD
		     END AS CTRY_CD
		,    X.TEL_NO
		,    X.FRAUD_YN
		,    CASE WHEN X.JOB_CD IN ('99034','99035')         THEN 'T5'
		  	      WHEN X.JOB_CD IN ('99036','99037','99038') THEN 'T6' 
		        ELSE MP.RSLT_CD1   
		       END          AS HUB_DGN_BANK              
		,    MT.RSLT_CD1    AS GOL_NASABAH               
		,    CASE WHEN X.KAT_USAHA = '70' THEN 'UM'
		  	      WHEN X.KAT_USAHA = '80' THEN 'UK'
		  	      WHEN X.KAT_USAHA = '90' THEN 'UT'
		  	      WHEN X.KAT_USAHA = '99' THEN 'NU' 
		      ELSE X.KAT_USAHA
		     END AS KAT_USAHA                       
		  	 FROM ( 
                WITH CIX AS
                    (SELECT 
                        A.CIX_NO
                      , A.ID_NO
                      , B.ID_TP
                      , B.AUTHORIZED_NAME   
                     FROM     
                        (SELECT 
                            CIX_NO
                          , MIN(ID_NO) AS ID_NO  
                        FROM INRT_ACOM_COM_AU
                       WHERE SEQ_NO = 0
                    GROUP BY CIX_NO)A
                      LEFT JOIN INRT_ACOM_COM_AU B 
                      ON (A.CIX_NO = B.CIX_NO 
                      AND A.ID_NO  = B.ID_NO)
                    )
				 	SELECT 
				 		   A.CUST_NO                  
				 		,  B.CUST_ENM                 
				 		,  C.NPWP                     
				 		,  CASE WHEN B.ID_TP = '1' THEN 'KTP'
				 				WHEN B.ID_TP = '3' THEN 'PAS'
				 				WHEN B.ID_TP = '4' THEN 'KTS'
				 			  ELSE 'LN'
				 			END AS ID_TP                
				 		,  B.ID_NO                    
				 		,  C.MOTHER_NM                                            
				 		,  B.BIRTH_PLACE
				 		,  B.BIRTH_DT
				 		,  C.SIUP_NO                              
				 		,  D.AUTHORIZED_NAME         AS BOD_NM    
				 		,  CASE WHEN D.ID_TP = '1' THEN 'KTP'
				 				WHEN D.ID_TP = '3' THEN 'PAS'
				 				WHEN D.ID_TP = '4' THEN 'KTS'
				 			  ELSE ''
				 			END AS ID_PK     
				 		,  D.ID_NO                   AS BOD_ID_NO 
				 		,  B.ADDR_ENM_1                          
				 		,  C.DATI_II                 AS CITY_NM            
				 		,  B.CTRY_CD                  
				 		,  B.TEL_NO                   
				 		,  B.JOB_CD    
				 		,  CASE WHEN C.FRAUD_YN = 'Y' THEN '2.3'   --Req Sien 
				 		      ELSE '1'
				 		   END AS FRAUD_YN  
				 		--,  C.FRAUD_YN                 
				 		,  C.REL_PARTY_CD             
				 		,  C.GRP_OWNER_LBU            
				 		,  A.UMKM_LPS                     AS KAT_USAHA   
				 	FROM   IEDW_LPS_ACCT_BASE  A
				 		,  IDSS_ACOM_CIX_BASE  B
				 		,  IDSS_ACOM_CIX_LRPT  C
				 		,  CIX                 D
				 	WHERE A.BASC_DT = V_PROC_BASC_DT                                      
				 	  AND A.BASC_DT = B.BASC_DT(+)
				 	  AND A.BASC_DT = C.BASC_DT(+)                               
				 	  AND A.CUST_NO = B.CIX_NO(+)
				 	  AND A.CUST_NO = C.CIX_NO(+)
				 	  AND A.CUST_NO = D.CIX_NO(+)
				 	GROUP BY 
					    A.CUST_NO                  
					,   B.CUST_ENM                 
					,   C.NPWP 
					,   B.ID_TP
					,   B.ID_NO                    
					,   C.MOTHER_NM                                            
					,   B.BIRTH_PLACE
					,   B.BIRTH_DT
					,   C.SIUP_NO 
					,   B.ADDR_ENM_1                          
					,   C.DATI_II                           
					,   B.CTRY_CD                  
					,   B.TEL_NO                   
					,   B.JOB_CD 
					,   C.REL_PARTY_CD             
					,   C.GRP_OWNER_LBU            
					,   A.UMKM_LPS
					,   D.ID_TP 
					,   C.FRAUD_YN 
					,   D.AUTHORIZED_NAME
					,   D.ID_NO							
					) X
					,( SELECT DISTINCT 
							  TYPE
							, CODE_NM
							, CODE                                     
						FROM INRT_ACOM_COMH_CODE 
						WHERE TYPE = 'F787'
						)M 
						,( SELECT
							  RSLT_CD1
							, COND_CD1
							FROM IEDW_BI_CODE_MAP
							WHERE MAP_ID = 'LPS_REL_CD'
							  AND STS_CD = '10'
							  AND COND_CD2 IS NULL
							)MP
							,(SELECT   RSLT_CD1
									, COND_CD1
									FROM IEDW_BI_CODE_MAP
								WHERE MAP_ID = 'GRP_OWNER_LPS' 
									AND STS_CD = '10'
									)MT    
							WHERE X.REL_PARTY_CD  = MP.COND_CD1(+)
								AND X.GRP_OWNER_LBU = MT.COND_CD1(+) 
								AND X.BIRTH_PLACE   = M.CODE_NM(+)
								);