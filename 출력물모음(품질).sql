 CREATE PROC [dbo].[GNS_QCDevPlanPrintQuery]

   @xmlDocument    NVARCHAR(MAX),  
    @xmlFlags       INT = 0,  
    @ServiceSeq     INT = 0,  
    @WorkingTag     NVARCHAR(10)= '',    
    @CompanySeq     INT = 1,  
    @LanguageSeq    INT = 1,  
    @UserSeq        INT = 0,  
    @PgmSeq         INT = 0,  
 @ItemSeq        INT = 0

AS         
    DECLARE   @docHandle      INT,      
     @AssetSeq       INT,             -- 품목자산분류
     @CreateDate     NCHAR(10),
     @InvoiceDate    NCHAR(10),
    -- @ItemSeq        INT,
     @ItemName       NVARCHAR(20),
     @ItemNo         NVARCHAR(20),
     @Spec           NVARCHAR(20),
     @CustName       NVARCHAR(20),
     @CustSeq        INT,
     @CustItemSeq    INT,
     @CustItemName   NVARCHAR(20),
     @CustItemNo     NVARCHAR(20),
     @CustSpec       NVARCHAR(20),
     @SourceLotNo    NVARCHAR(100),
     @FrDate         NCHAR(8),
              @ToDate         NCHAR(8),
     @PrintGroupCfm  INT,
     @CreateDateFr   NCHAR(10),
     @CreateDateTo   NCHAR(10),
     @PrintGbnSeq       INT
  
    EXEC sp_xml_preparedocument @docHandle OUTPUT, @xmlDocument        
    
    SELECT  @AssetSeq       = ISNULL(AssetSeq,0),
   @CreateDate     = ISNULL(CreateDate,   0),
            @InvoiceDate    = ISNULL(InvoiceDate,  0),
   @ItemSeq        = ISNULL(ItemSeq,     ''),
   @ItemName       = ISNULL(ItemName,    ''),
   @ItemNo       = ISNULL(ItemNo,      ''),
   @Spec         = ISNULL(Spec,        ''),
   @CustName     = ISNULL(CustName,        ''),
   @CustSeq     = ISNULL(CustSeq,        ''),
   @CustItemSeq    = ISNULL(CustItemSeq,  0),
   @CustItemName = ISNULL(CustItemName,''),
   @CustItemNo   = ISNULL(CustItemNo,  ''),
   @CustSpec     = ISNULL(CustSpec,    ''),
   @SourceLotNo  = ISNULL(SourceLotNo, ''),
   @FrDate       = ISNULL(FrDate,      ''),
   @ToDate       = ISNULL(ToDate,      ''),
   @PrintGroupCfm  = ISNULL(PrintGroupCfm,      ''),
   @CreateDateFr = ISNULL(CreateDateFr,      ''),
   @CreateDateTo   = ISNULL(CreateDateTo,      ''),
   @PrintGbnSeq      = ISNULL(PrintGbnSeq, 0)

    FROM OPENXML(@docHandle, N'/ROOT/DataBlock1', @xmlFlags)       
    WITH (  AssetSeq       INT,
   CreateDate     NCHAR(10),
            InvoiceDate    NCHAR(10),
   ItemSeq        INT,
   ItemName       NVARCHAR(20),
   ItemNo         NVARCHAR(20),
   Spec           NVARCHAR(20),
   CustName       NVARCHAR(20),
   CustSeq        INT,
   CustItemName   NVARCHAR(20),
   CustItemNo     NVARCHAR(20),
   CustSpec       NVARCHAR(20),
   CustItemSeq    INT,
   SourceLotNo    NVARCHAR(100),
   FrDate         NCHAR(8),
   ToDate         NCHAR(8),
   PrintGroupCfm  INT,
   CreateDateFr   NCHAR(10), 
   CreateDateTo   NCHAR(10),
   PrintGbnSeq       INT
   )        
  

  
  ---- 컴파일 시간 및 실행 시간
  --SET STATISTICS TIME ON;

  ---- 각 구문의 IO 실행 결과
  --SET STATISTICS IO ON;
   

--   SELECT E.AssetName              AS AssetName      
--          ,A.AssetSeq               AS AssetSeq      
--          ,A.ItemSeq                AS ItemSeq      
--          ,A.ItemNo                 AS ItemNo      
--          ,A.ItemName               AS ItemName      
--          ,A.Spec                   AS Spec
--          ,C.CustSeq
--          ,C.CustItemSeq
--    ,A.CompanySeq
    
--      INTO #Tmp_Info  
--      FROM _TDAItem AS A WITH(NOLOCK)      
--            INNER JOIN _TDAItemAsset AS E WITH(NOLOCK)      
--                    ON A.AssetSeq   = E.AssetSeq      
--                   AND E.SMAssetGrp = 6008002   -- 제품      
--                   AND A.CompanySeq = E.CompanySeq      
--            LEFT  JOIN _TDAUnit AS B WITH(NOLOCK)      
--                    ON A.UnitSeq    = B.UnitSeq      
--                   AND A.CompanySeq = B.CompanySeq      
--            LEFT  JOIN thegns_TSLPLMItem AS C WITH(NOLOCK)    
--                    ON A.CompanySeq = C.CompanySeq    
--                   AND A.ItemSeq = C.ItemSeq    
--     WHERE A.CompanySeq = @CompanySeq      
--       AND (A.AssetSeq = 2)      
--       AND (@ItemName = '' OR A.ItemName LIKE '%' + @ItemName + '%')      
--       AND (@ItemNo = '' OR A.ItemNo LIKE '%' + @ItemNo + '%')      
--       AND (@Spec = '' OR A.Spec LIKE '%' + @Spec + '%')      
--       AND (@CustItemName = '' OR C.CustItemName LIKE '%' + @CustItemName + '%')      
--       AND (@CustItemNo = '' OR C.CustItemNo LIKE '%' + @CustItemNo + '%')      
--       AND (@CustSpec = '' OR C.CustSpec LIKE '%' + @CustSpec + '%')      
----       AND (@IsLastAmd = '0' OR (@IsLastAmd = '1' AND D.SORT = 1))      
--     ORDER BY ItemSeq    
   
--        SELECT MAX(A.AssetName)     AS AssetName  
--              ,MAX(A.AssetSeq)      AS AssetSeq  
--              ,A.ItemSeq
--              ,MAX(A.ItemNo)        AS ItemNo     
--              ,MAX(A.ItemName)      AS ItemName  
--              ,MAX(A.Spec)          AS Spec
--     ,MAX(C.CustItemName)  AS CustItemName
--     ,MAX(C.CustSpec)      AS CustSpec
--     ,MAX(C.CustItemNo)    AS CustItemNo
--     ,MAX(C.CustItemSeq)   AS CustItemSeq
--     ,MAX(A.CompanySeq)    AS CompanySeq
--     ,MAX(C.CustSeq)       AS CustSeq
--     ,MAX(B.AmdSeq)        AS AmdSeq
--     ,MAX(C.CustItemEngName) AS CustItemEngName
--    INTO #RESULT_Query
--          FROM #Tmp_Info AS A
--                INNER JOIN thegns_TPLMAmd AS B WITH(NOLOCK)
--                        ON A.ItemSeq        = B.ItemSeq
--                       AND A.CustSeq        = B.CustSeq
--                       AND A.CustItemSeq    = B.CustItemSeq
--                       AND B.GBNSeq         = 1023278003
--                       AND B.CompanySeq     = @CompanySeq
--    LEFT OUTER JOIN thegns_TSLPLMItem AS C WITH(NOLOCK)
--      ON A.ItemSeq = C.ItemSeq
--      AND A.CustItemSeq = C.CustItemSeq
--         GROUP BY A.ItemSeq

  


 SELECT  A.CompanySeq
   ,A.CustItemNo      
            ,A.CustItemName      
            ,A.CustSpec                
            ,A.ItemSeq      
            ,B.ItemNo      
            ,B.Spec      
            ,B.ItemName      
            ,CASE WHEN ISNULL(LTRIM(C.AmdName), '') = '' THEN C.Amd       
                  ELSE ISNULL(C.Amd, '') END AS Amd      
            ,C.AmdSeq      
            ,CN.CustName      
            ,CN.CustNo      
            ,A.CustSeq      
            ,A.CustItemSeq       
            ,B.AssetSeq      
            ,IA.AssetName      
            ,C.IsEnd     
   ,A.CustItemEngName
   ,CASE WHEN c.IsLastAmd = 1 THEN '최종차수'
   ELSE c.IsLastAmd END AS IsLast
   ,CONVERT(CHAR(10), C.CfmDate, 23) AS CfmDate

   ,c.IsLastAmd
   INTO #RESULT_Query
      FROM thegns_TSLPLMItem AS A WITH(NOLOCK)      
            INNER JOIN _TDAItem AS B WITH(NOLOCK)      
                    ON A.ItemSeq    = B.ItemSeq      
                   AND A.CompanySeq = B.CompanySeq      
            INNER JOIN _TDAItemAsset AS IA WITH(NOLOCK)      
                    ON IA.AssetSeq      = B.AssetSeq      
                   AND IA.CompanySeq    = B.CompanySeq      
            LEFT  JOIN thegns_TPLMAmd AS C WITH(NOLOCK) -- ItemSeq : 거래처품목 사이트화면의 품목 내부코드       
                    ON C.ItemSeq        = A.ItemSeq      
                   AND C.CustSeq        = A.CustSeq      
                   AND C.CustItemSeq    = A.CustItemSeq      
                   AND C.CompanySeq     = A.CompanySeq       
                   --AND C.AmdSeq         = (SELECT MAX(AmdSeq)      
                   --                          FROM thegns_TPLMAmd AS C1 WITH(NOLOCK)      
                   --                         WHERE C1.ItemSeq        = C.ItemSeq      
                   --                           AND C1.CustSeq        = C.CustSeq      
                   --                           AND C1.CustItemSeq    = C.CustItemSeq      
                   --                           AND C1.CompanySeq     = C.CompanySeq      
                   --                         )      
            LEFT  JOIN _TDACust AS CN WITH(NOLOCK)      
                    ON CN.CustSeq       = A.CustSeq      
                   AND CN.CompanySeq    = A.CompanySeq      
     WHERE A.CompanySeq = @CompanySeq      
     AND B.AssetSeq = 2
     AND (@ItemName = '' OR B.ItemName LIKE '%' + @ItemName + '%')      
       AND (@ItemNo = '' OR B.ItemNo LIKE '%' + @ItemNo + '%')      
       AND (@Spec = '' OR B.Spec LIKE '%' + @Spec + '%')      
       AND (@CustItemName = '' OR A.CustItemName LIKE '%' + @CustItemName + '%')      
       AND (@CustItemNo = '' OR A.CustItemNo LIKE '%' + @CustItemNo + '%')      
       AND (@CustSpec = '' OR A.CustSpec LIKE '%' + @CustSpec + '%') 
    AND C.AmdSeq  IS NOT NULL
    ORDER BY A.ItemSeq      



 
 

    SELECT 
    A.*,
   
    CONCAT(A.AmdSeq,(ROW_NUMBER() OVER(PARTITION BY A.AmdSeq ORDER BY A.AmdSeq))) AS InvoceIDX,
    CASE WHEN B.PrintGroupCfm IS NULL OR B.PrintGroupCfm = 0 THEN 0
    ELSE B.PrintGroupCfm END AS PrintGroupCfm,
    ISNULL(C.MinorName,'') AS PrintGbn,
    ISNULL(C.MinorSeq,0) AS PrintGbnSeq
   --C.MinorSeq
  
  
    INTO #DATA_QC
    FROM #RESULT_Query AS A
    LEFT OUTER JOIN THEGNS_TQAgnsCoaCfm AS B ON A.CustItemSeq = B.CustItemSeq AND A.AmdSeq =B.AmdSeq and a.ItemSeq = b.ItemSeq
    LEFT OUTER JOIN  GNS_DevPalnPrintGroupGbn AS C ON A.AmdSeq = C.AmdSeq AND A.CustItemSeq = C.CustItemSeq
    LEFT OUTER JOIN _TDACust G WITH(NOLOCK) ON A.CompanySeq = G.CompanySeq AND A.CustSeq = G.CustSeq 
    GROUP BY A.ItemSeq,a.AssetName,a.AssetSeq,a.ItemNo,a.ItemName  ,a.Spec,a.CustItemName,a.CustSpec,a.CustItemNo,a.CustItemSeq,a.CompanySeq,a.CustSeq,a.AmdSeq,a.CustItemEngName,b.PrintGroupCfm,c.MinorName,c.MinorSeq,G.CustName,A.Amd,A.CustName,A.CustNo,a.IsLastAmd,A.IsLast
    ,A.IsEnd,a.CfmDate
    ORDER BY AmdSeq


    
    SELECT AmdSeq 
    INTO #TPLMDevPlanSpec
    fROM thegns_TPLMDevPlanSpec 
    GROUP BY AmdSeq   ---스펙

    
    SELECT AmdSeq 
    INTO #TPLMProcessCont
    FROM thegns_TPLMProcessCont 
    GROUP BY AmdSeq   ---성분정보
  
    SELECT ItemSeq 
    INTO #MES_QC
    FROM MES.TGONS.DBO.VT_PRO1069
    WHERE 검사일자 > '2021/01/01'
    GROUP BY ITEMSEQ




    SELECT A.*,
    CASE WHEN B.AmdSeq IS NULL AND C.AmdSeq IS NULL AND D.ItemSeq IS NULL THEN 'ERP/MES 스펙 및 성분정보가 없습니다.'
         WHEN B.AmdSeq IS NULL THEN 'ERP 스펙정보가 없습니다.'
      WHEN C.AmdSeq IS NULL THEN 'ERP 성분정보가 없습니다.'
      WHEN D.ItemSeq IS NULL THEN 'MES 검사정보가 없습니다.'
      ELSE '출력가능'
      END AS PrintGBN_1
    INTO  #DATA_QC_TEST
    FROM #DATA_QC AS A
    LEFT OUTER JOIN #TPLMDevPlanSpec AS B ON  A.AmdSeq = B.AmdSeq
    LEFT OUTER JOIN #TPLMProcessCont AS C ON  A.AmdSeq = C.AmdSeq
    LEFT OUTER JOIN #MES_QC AS D ON A.ItemSeq = D.ItemSeq
 


  SELECT MIN(검사일자 )AS 검사일자,ItemSeq,검사항목
  INTO #MES_QC2
  fROM MES.TGONS.DBO.VT_PRO1069
     WHERE 검사일자 > '2021/01/01'
  AND 제조번호 IS NOT NULL
  GROUP BY ITEMSEQ,검사항목
  --ORDER BY ITEMSEQ
 
  --SELECT *fROM #MES_QC2
  --ORDER BY ITEMSEQ

     SELECT A.*, C.MinorName,
   CASE WHEN C.MinorName = D.검사항목 THEN '일치'
   ELSE '불일치' END AS MES_QCGBN
   INTO #MES_ERP_DATA
   FROM #DATA_QC_TEST AS A
      LEFT OUTER JOIN thegns_TPLMDevPlanSpec AS B ON A.AmdSeq = B.AmdSeq AND A.CompanySeq = B.CompanySeq
   LEFT OUTER JOIN _TDAUMinor AS C ON A.CompanySeq = C.CompanySeq AND B.TestItemSeq = C.MinorSeq
   LEFT OUTER JOIN #MES_QC2 AS D ON A.ItemSeq = D.ItemSeq AND C.MinorName = D.검사항목 
  
   ORDER BY A.ItemSeq
   

   SELECT ItemSeq, AmdSeq,CustItemSeq,MES_QCGBN 
   INTO #MES_ERP_DATA_Result
   FROM #MES_ERP_DATA 
   where MES_QCGBN = '불일치'
   GROUP BY ItemSeq, AmdSeq,CustItemSeq,MES_QCGBN 
  

    SELECT a.*,
    CASE WHEN A.PrintGBN_1 = 'ERP 스펙정보가 없습니다.' THEN '출력불가능(ERP 스펙정보가 없습니다.)'
      WHEN A.PrintGBN_1 = 'ERP 성분정보가 없습니다.' THEN '출력불가능(ERP 성분정보가 없습니다.)'
      WHEN A.PrintGBN_1 = 'MES 검사정보가 없습니다.' THEN '출력불가능(MES 검사정보가 없습니다.)'
      WHEN A.PrintGBN_1 = 'ERP/MES 스펙 및 성분정보가 없습니다.' THEN '출력불가능(ERP/MES 스펙 및 성분정보가 없습니다.)'
      WHEN A.ItemSeq = B.ItemSeq AND B.MES_QCGBN = '불일치'  THEN 'MES/ERP데이터 불일치.'
      ELSE '출력가능' END AS PrintResult
  --  into #qc_result
    FROM #DATA_QC_TEST as a
    left outer join #MES_ERP_DATA_Result as b on a.AmdSeq = b.AmdSeq and a.ItemSeq = b.ItemSeq
   WHERE  (@PrintGbnSeq = 0 OR A.PrintGbnSeq = @PrintGbnSeq) 
  --  where a.CustItemSeq = 5214
    order by ItemSeq
    
   -- SELECT @PrintGbnSeq

----    SELECT *FROM #qc_result WHERE ITEMSEQ = 78054

--    SELECT MinorName,B.ItemSeq
--    INTO #TEST1234
--    fROM thegns_TPLMDevPlanSpec AS A
--    LEFT OUTER JOIN _TDAUMinor AS C ON A.CompanySeq = C.CompanySeq AND A.TestItemSeq = C.MinorSeq
--    LEFT OUTER JOIN thegns_TPLMAmd AS B ON A.CompanySeq = B.CompanySeq AND A.AmdSeq = B.AmdSeq
--    WHERE B.AmdSeq = 2334

--    select 검사항목,ITEMSEQ
--    INTO #TEST55
--    from  MES.TGONS.DBO.VT_PRO1069
--    where itemseq in(23615)
--    and 검사일자 > '2021/01/01'
--    AND 제조번호 = 'DNT-PE-CA0G0I-000A'
 
  

   --   select *from  MES.TGONS.DBO.VT_PRO1069 as a
   --left outer join #qc_result as b on a.itemseq = b.ItemSeq
   --where 
   --  검사일자 > '2021/01/01'
   --   and b.PrintResult = '출력불가능(MES 검사정보가 없습니다.)'
   
   --SELECT A.TestItemSeq,B.ItemSeq,
   --case when d.검사항목 = c.MinorName then '일치'
   --else '불일치' end as dd
   --INTO #TEST1234
   --FROM thegns_TPLMDevPlanSpec AS A
   --LEFT OUTER JOIN thegns_TPLMAmd AS B ON A.CompanySeq = B.CompanySeq AND A.AmdSeq = B.AmdSeq
   --LEFT OUTER JOIN _TDAUMinor AS C ON A.CompanySeq = C.CompanySeq AND A.TestItemSeq = C.MinorSeq
   --LEFT OUTER JOIN #MES_QC2 AS D ON B.ItemSeq = D.ItemSeq and d.검사항목 = c.MinorName

   --SELECT *FROM #TEST1234
 



  --SELECT a.ItemSeq,A.AmdSeq,MinorName 
  --FROM #DATA_QC_TEST AS A
  --LEFT OUTER JOIN thegns_TPLMDevPlanSpec AS B ON A.AmdSeq = B.AmdSeq 
  --LEFT OUTER JOIN _TDAUMinor AS C ON A.CompanySeq = B.CompanySeq AND B.TestItemSeq = C.MinorSeq
  --LEFT OUTER JOIN #First_QC AS D ON A.ItemSeq = D.ItemSeq and c.MinorName = d.검사항목
  --where a.ItemSeq = d.itemseq
 

  --SELECT A.* FROM #DATA_TEST AS A
  --LEFT OUTER JOIN #MES_QCTEST AS B ON A.ItemSeq = B.ItemSeq 


  --       SELECT *FROM #DATA_TEST AS A
  --SELECT B.MinorName,C.ItemSeq
  --FROM thegns_TPLMDevPlanSpec AS A 
  --LEFT OUTER JOIN _TDAUMinor AS B ON A.CompanySeq = B.CompanySeq AND A.TestItemSeq = B.MinorSeq
  --LEFT OUTER JOIN thegns_TPLMAmd AS C ON A.CompanySeq = B.CompanySeq AND A.AmdSeq = C.AmdSeq
  --LEFT OUTER JOIN MES.TGONS.DBO.VT_PRO1069 AS D ON C.ItemSeq = D.ItemSeq AND B.MinorName = 검사항목
  --WHERE D.검사일자 > '2021/01/01'
  --GROUP BY C.ItemSeq,MinorName
 
RETURN    

