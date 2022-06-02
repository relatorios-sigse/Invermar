SELECT
 /** 
            Creación: 02-06-2022. Andrés Del Río. Reporte de auditorías con base en consulta estándar (AU014)
            El reporte trae las columnas "LISTADO_REQUISITOS" (requisito de referencia asociado en el alcance
            de la auditoría), "AUDIT_OCCURRENCE" (cantidad de hallazgos asociados en la auditoría) y "PORC_CUMPLE" (%
            de requisitos que fueron evaluados como "CUMPLE")
            Ambiente: https://invermar.softexpert.com/
            Versión SE Suite: 2.1.8.59 
            Panel de análisis:  REPAUD - Reporte de Auditorías
            
            Modificaciones: 
            DD-MM-AAAA. Autor. Descripción
**/
        ( SELECT
            ROUND(100.0 * TMP.TOTAL_PARTITION / TMP.TOTAL,
            2 )       
        FROM
            (SELECT
                DISTINCT    AUAUDIT.IDAUDIT,
                AUAUDIT.NMAUDIT,
                AUCONFORMITYLEVEL.IDCONFORMITYLEVEL,
                COUNT(AUCONFORMITYLEVEL.IDCONFORMITYLEVEL) OVER(                            
            ORDER BY
                AUCONFORMITYLEVEL.IDCONFORMITYLEVEL) TOTAL_PARTITION,
                COUNT(AUCONFORMITYLEVEL.IDCONFORMITYLEVEL) OVER()  TOTAL                     
            FROM
                AUAUDIT                      
            JOIN
                AUSCOPESTRUCT                                   
                    ON AUSCOPESTRUCT.CDSCOPEDEFINITION=AUAUDIT.CDSCOPEDEFINITION                                                                                         
            JOIN
                AUCONFORMITYLEVEL                                                                                                                                      
                    ON (
                        AUSCOPESTRUCT.CDAUDITEVALCRIT=AUCONFORMITYLEVEL.CDAUDITEVALCRIT                                                                                                                                                          
                        AND AUSCOPESTRUCT.CDAUDITEVALCRITREV=AUCONFORMITYLEVEL.CDAUDITEVALCRITREV                                                                                                                                                          
                        AND AUSCOPESTRUCT.CDCONFORMITYLEVEL=AUCONFORMITYLEVEL.CDCONFORMITYLEVEL                                                                                                                                     
                    )                                                                                           
            WHERE
                AUAUDIT.CDAUDIT = AU.CDAUDIT )  TMP         
        WHERE
            TMP.IDCONFORMITYLEVEL = 'CUMPLE'  
        ) PORC_CUMPLE,  (
            SELECT
                RQREQUIREMENT.IDREQUIREMENT || ' - ' || RQREQUIREMENT.NMREQUIREMENT     
            FROM
                AUAUDIT                                                                                               
            INNER JOIN
                AUSCOPESTRUCT                                                                                                               
                    ON (
                        AUSCOPESTRUCT.CDSCOPEDEFINITION=AUAUDIT.CDSCOPEDEFINITION                                                                                                              
                    )                                                                                               
            INNER JOIN
                AUSTRUCTASSOC                                                                                                               
                    ON (
                        AUSTRUCTASSOC.CDSTRUCT=AUSCOPESTRUCT.CDSTRUCT                                                                                                              
                    )                                                                                              
            INNER JOIN
                RQREQUIREMENT                                                                                                              
                    ON (
                        RQREQUIREMENT.CDREQUIREMENT = AUSTRUCTASSOC.CDREQUIREMENT                 
                        AND RQREQUIREMENT.CDREVISION =  AUSTRUCTASSOC.CDREQUIREMENTREVISION             
                    )                                                                                               
            WHERE
                AUSCOPESTRUCT.CDSTRUCT=AUSCOPESTRUCT.CDSTRUCTROOT    
                AND AUAUDIT.CDAUDIT = AU.CDAUDIT
        ) LISTADO_REQUISITOS,          AU.CDPLANEXECMODEL,         AUCFG.FGREQUIREMENT AS ISREQUIREMENTSCOPE,         APEM.CDINSTANCE,         AUP.IDPLAN,         AUP.NMPLAN,         AUTP.IDAUDITTYPE,         AUTP.NMAUDITTYPE,         AU.IDAUDIT,         AU.NMAUDIT,         AU.FGAUDITSTATUS,         AU.CDAUDIT,         AUTP.CDAUDITTYPE,         AU.FGAUDITSTATUS AS FGTEMPLATESTATUS,         AU.CDFAVORITE,         1 AS FGOBJECT,         CAST(NULL AS INTEGER) AS CDTASK,         CAST(NULL AS INTEGER) AS CDBASETASK,         CAST(NULL AS INTEGER) AS CDTASKTYPE,         CAST(NULL AS INTEGER) AS FGPHASE,         CAST(NULL AS DATE) AS DTPLANST,         CAST(NULL AS DATE) AS DTPLANEND,         CAST(NULL AS DATE) AS DTREPLST,         CAST(NULL AS DATE) AS DTREPLEND,         CAST(NULL AS DATE) AS DTACTST,         CAST(NULL AS DATE) AS DTACTEND,         CAST(NULL AS DATE) AS DTSCHEDULEDST,         CAST(NULL AS DATE) AS DTSCHEDULEDEND,         CAST(NULL AS INTEGER) AS FGOUTDATED,         CAST(NULL AS INTEGER) AS FGLOCK,         AU.FGLASTAUDITSTATUS,         AU.CDSCOPEDEFINITION,         ASSOC_DOC.COUNT_DOC AS FGHASDOCUMENT,         ASSOC_ATTACH.COUNT_ATTACH AS FGHASATTACHMENT,         AUDIT_OCCURRENCES.QTD_OCCUR AS AUDIT_OCCURRENCE,         CASE              
            WHEN AUSCOPECONFIG.FGREQUIREMENT=1 THEN AURC.FGSYMBOL              
            ELSE SCOPESTRUCTVALUES.FGSYMBOL          
        END AS FGSYMBOL,         CASE              
            WHEN AUSCOPECONFIG.FGREQUIREMENT=1 THEN AURS.VLRESULTVALUE              
            ELSE SCOPESTRUCTVALUES.VLVALUE          
        END AS VLVALUERESULT,         CASE              
            WHEN AUSCOPECONFIG.FGREQUIREMENT=1 THEN (CASE                  
                WHEN AURS.VLRESULTPERCENT < 0 THEN 0                  
                ELSE AURS.VLRESULTPERCENT              
            END)              
            ELSE (
                CASE                  
                    WHEN SCOPESTRUCTVALUES.VLCONFORMITYPERCENT < 0 THEN 0                  
                    ELSE SCOPESTRUCTVALUES.VLCONFORMITYPERCENT              
                END
            )          
        END AS VLRESULTPERCENT,         CASE              
            WHEN AUSCOPECONFIG.FGREQUIREMENT=1 THEN AURC.IDCOLOR              
            ELSE SCOPESTRUCTVALUES.IDCOLOR          
        END AS IDCOLOR,         AU.CDASSOC,         AU.FGAUDITTYPE,         CASE              
            WHEN ADCY1.CDCOMPANY IS NULL THEN NULL              
            ELSE (
                ADCY1.IDCOMMERCIAL||' - '||ADCY1.NMCOMPANY
            )          
        END AS IDCUSTOMER,         CASE              
            WHEN ADCO1.CDDEPARTMENT IS NULL THEN NULL              
            ELSE (
                ADCO1.IDDEPARTMENT ||' - '|| ADCO1.NMDEPARTMENT
            )          
        END AS IDAUDITEECOMPANIES,         CASE              
            WHEN ADCY2.CDCOMPANY IS NULL THEN NULL              
            ELSE (
                ADCY2.IDCOMMERCIAL||' - '||ADCY2.NMCOMPANY
            )          
        END AS IDAUDITEESUPPLIER,         CASE              
            WHEN ADCO2.CDDEPARTMENT IS NULL THEN NULL              
            ELSE (
                ADCO2.IDDEPARTMENT||' - '||ADCO2.NMDEPARTMENT
            )          
        END AS IDAUDORGCOMPANIES,         CASE              
            WHEN ADCY3.CDCOMPANY IS NULL THEN NULL              
            ELSE (
                ADCY3.IDCOMMERCIAL||' - '||ADCY3.NMCOMPANY
            )          
        END AS IDAUDITORG,         AUINT.CDINTAUDITORUSER,         CASE AUT2.FGAUDITORTYPE              
            WHEN 10 THEN ADU2.NMUSER              
            WHEN 20 THEN AUEXT.NMEXTERNALAUDITOR          
        END AS IDLEADER,         CAST (CASE AUT2.FGAUDITORTYPE              
            WHEN 10 THEN ADU2.NMUSER              
            WHEN 20 THEN AUEXT.NMEXTERNALAUDITOR          
        END AS VARCHAR(255)) AS NMLEADER,         AUST04.DTPLANNEDSTARTDT,         AUST04.DTPLANNEDENDDATE,         AUST04.DTACTUALSTARTDT,         AUST04.DTACTUALENDDATE,         AUPU.IDAUDITPURPOSE,         CASE              
            WHEN ADTE.CDTEAM IS NULL THEN NULL              
            ELSE (
                ADTE.IDTEAM||' - '||ADTE.NMTEAM
            )          
        END AS IDTEAM,         CASE              
            WHEN AUSCOPECONFIG.FGREQUIREMENT=1 THEN AURC.IDAUDRESULTCLASSIF              
            ELSE SCOPESTRUCTVALUES.IDCONFORMITYLEVEL          
        END AS IDAUDRESULTCLASSIF,         CASE              
            WHEN AUSCOPECONFIG.FGREQUIREMENT=1 THEN AURC.NMAUDRESULTCLASSIF              
            ELSE SCOPESTRUCTVALUES.NMCONFORMITYLEVEL          
        END AS NMAUDRESULTCLASSIF,         CASE              
            WHEN AUSCOPECONFIG.FGREQUIREMENT=1 THEN IDAUDRESULTCLASSIF||' - '||AURC.NMAUDRESULTCLASSIF              
            ELSE SCOPESTRUCTVALUES.CONFORMITYLEVEL          
        END AS RESULT,         CASE              
            WHEN (
                AU.FGAUDITRESULT=1              
                OR AU.FGAUDITCRITRESULT=1              
                OR AU.FGPROCESSRESULT=1              
                OR AU.FGDEPARTMENTRESULT=1              
                OR AU.FGITEMRESULT=1              
                OR AU.FGPROJECTRESULT=1              
                OR AU.FGASSETRESULT=0              
                OR AU.FGRISKCTRLRESULT=1              
                OR AU.FGSUPPLYRESULT=1
            ) THEN 1              
            ELSE 2          
        END AS FGAUDITALLRESULT,         CAST (CASE              
            WHEN AU.FGAUDITSTATUS=25              
            OR AU.FGAUDITSTATUS=36              
            OR AU.FGAUDITSTATUS=46              
            OR AU.FGAUDITSTATUS=53 THEN '#{100263}'              
            WHEN (SELECT
                GNAPPROV.NRLASTCYCLE              
            FROM
                GNAPPROV              
            WHERE
                AUST.CDPROD=GNAPPROV.CDPROD                  
                AND AUST.CDAPPROV=GNAPPROV.CDAPPROV) > 1 THEN '#{100761}'              
            WHEN AU.FGAUDITSTATUS=18              
            OR AU.FGAUDITSTATUS=30              
            OR AU.FGAUDITSTATUS=40              
            OR AU.FGAUDITSTATUS=48 THEN '#{104919}'              
            WHEN AU.FGAUDITSTATUS=20              
            OR AU.FGAUDITSTATUS=33              
            OR AU.FGAUDITSTATUS=43              
            OR AU.FGAUDITSTATUS=50 THEN '#{103131}'              
            WHEN AU.FGAUDITSTATUS=60 THEN '#{104230}'              
            WHEN AU.FGAUDITSTATUS=56 THEN '#{100667}'          
        END AS VARCHAR(255)) AS IDSITUATION,         CAST(CASE              
            WHEN AURC.IDAUDRESULTCLASSIF IS NOT NULL THEN AURC.IDAUDRESULTCLASSIF||' ('||AURCR.IDAUDITRESULTCRIT||':'|| CAST(AURCV.NRREVISION AS VARCHAR(8))||')'          
        END AS VARCHAR(255)) AS IDCLASSRESULT,         CAST (CASE AU.FGAUDITTYPE              
            WHEN 10 THEN '#{112681}'              
            WHEN 20 THEN '#{112683}'              
            WHEN 30 THEN '#{112682}'              
            WHEN 40 THEN '#{112684}'          
        END AS VARCHAR(255)) AS IDTAUDITYPE,         AUST04.NRPLANNEDENDYEAR,         AUST04.NRPLANNEDENDMONTH,         AUST04.NRPLANNEDENDYEAR AS NMPLANNEDENDYEAR,         AUST04.NRPLANNEDENDMONTH AS NMPLANNEDENDMONTH,         AUST02.FGAUDITSTEP AS FGAUDITSTEP02,         AUST02.DTPLANNEDSTARTDT AS DTPLANNEDSTARTDT02,         AUST02.DTPLANNEDENDDATE AS DTPLANNEDENDDATE02,         AUST02.DTACTUALSTARTDT AS DTACTUALSTARTDT02,         AUST02.DTACTUALENDDATE AS DTACTUALENDDATE02,         AUST03.FGAUDITSTEP AS FGAUDITSTEP03,         AUST03.DTPLANNEDSTARTDT AS DTPLANNEDSTARTDT03,         AUST03.DTPLANNEDENDDATE AS DTPLANNEDENDDATE03,         AUST03.DTACTUALSTARTDT AS DTACTUALSTARTDT03,         AUST03.DTACTUALENDDATE AS DTACTUALENDDATE03,         AUST04.FGAUDITSTEP AS FGAUDITSTEP04,         AUST04.FGRESPONSIBLETYPE AS FGRESPONSIBLETYPE04,         AUST04.DTPLANNEDSTARTDT AS DTPLANNEDSTARTDT04,         AUST04.DTPLANNEDENDDATE AS DTPLANNEDENDDATE04,         AUST04.DTACTUALSTARTDT AS DTACTUALSTARTDT04,         AUST04.DTACTUALENDDATE AS DTACTUALENDDATE04,         AUST05.FGAUDITSTEP AS FGAUDITSTEP05,         AUST05.DTPLANNEDSTARTDT AS DTPLANNEDSTARTDT05,         AUST05.DTPLANNEDENDDATE AS DTPLANNEDENDDATE05,         AUST05.DTACTUALSTARTDT AS DTACTUALSTARTDT05,         AUST05.DTACTUALENDDATE AS DTACTUALENDDATE05,         1 AS QT,         CASE              
            WHEN (
                CASE                  
                    WHEN AU.FGAUDITSTATUS IN (
                        18,                 20,                 30,                 33,                 40,                 43,                 48,                 50
                    ) THEN AUST.DTPLANNEDENDDATE                  
                    WHEN AU.FGAUDITSTATUS IN (
                        25,                 36,                 46,                 53
                    ) THEN (SELECT
                        MAX(GNAR.DTDEADLINE)                  
                    FROM
                        GNAPPROVRESP GNAR                  
                    WHERE
                        GNAR.CDPROD=AUST.CDPROD                      
                        AND GNAR.CDAPPROV=AUST.CDAPPROV                      
                        AND GNAR.FGPEND=1                      
                        AND GNAR.CDCYCLE IN (SELECT
                            GNAP.NRLASTCYCLE                      
                        FROM
                            GNAPPROV GNAP                      
                        WHERE
                            GNAR.CDPROD=GNAP.CDPROD                          
                            AND GNAR.CDAPPROV=GNAP.CDAPPROV))                  
                    END > (
                        SELECT
                            SEF_DTEND_WK_DAYS_PERIOD(<!%TODAY%>,
                            CAST(3.000000000000AS INTEGER) + 1,
                            (SELECT
                                CDCALENDAR                          
                            FROM
                                GNCALENDAR                          
                            WHERE
                                FGDEFAULT=1)))                          
                            OR CASE                              
                                WHEN AU.FGAUDITSTATUS IN (18,
                                20,
                                30,
                                33,
                                40,
                                43,
                                48,
                                50) THEN AUST.DTPLANNEDENDDATE                              
                                WHEN AU.FGAUDITSTATUS IN (25,
                                36,
                                46,
                                53) THEN (SELECT
                                    MAX(GNAR.DTDEADLINE)                              
                                FROM
                                    GNAPPROVRESP GNAR                              
                                WHERE
                                    GNAR.CDPROD=AUST.CDPROD                                  
                                    AND GNAR.CDAPPROV=AUST.CDAPPROV                                  
                                    AND GNAR.FGPEND=1                                  
                                    AND GNAR.CDCYCLE IN (SELECT
                                        GNAP.NRLASTCYCLE                                  
                                    FROM
                                        GNAPPROV GNAP                                  
                                    WHERE
                                        GNAR.CDPROD=GNAP.CDPROD                                      
                                        AND GNAR.CDAPPROV=GNAP.CDAPPROV))                              
                                END IS NULL) THEN 1                          
                            WHEN CASE                              
                                WHEN AU.FGAUDITSTATUS IN (18,
                                20,
                                30,
                                33,
                                40,
                                43,
                                48,
                                50) THEN AUST.DTPLANNEDENDDATE                              
                                WHEN AU.FGAUDITSTATUS IN (25,
                                36,
                                46,
                                53) THEN (SELECT
                                    MAX(GNAR.DTDEADLINE)                              
                                FROM
                                    GNAPPROVRESP GNAR                              
                                WHERE
                                    GNAR.CDPROD=AUST.CDPROD                                  
                                    AND GNAR.CDAPPROV=AUST.CDAPPROV                                  
                                    AND GNAR.FGPEND=1                                  
                                    AND GNAR.CDCYCLE IN (SELECT
                                        GNAP.NRLASTCYCLE                                  
                                    FROM
                                        GNAPPROV GNAP                                  
                                    WHERE
                                        GNAR.CDPROD=GNAP.CDPROD                                      
                                        AND GNAR.CDAPPROV=GNAP.CDAPPROV))                              
                                END >= CAST(<!%TODAY%> AS DATE) THEN 2                              
                                ELSE 3                          
                            END AS FGDEADLINE ,CAST (CASE                              
                                WHEN (CASE                                  
                                    WHEN AU.FGAUDITSTATUS IN (18,20,30,33,40,43,48,50) THEN AUST.DTPLANNEDENDDATE                                  
                                    WHEN AU.FGAUDITSTATUS IN (25,36,46,53) THEN (SELECT
                                        MAX(GNAR.DTDEADLINE)                                  
                                    FROM
                                        GNAPPROVRESP GNAR                                  
                                    WHERE
                                        GNAR.CDPROD=AUST.CDPROD                                      
                                        AND GNAR.CDAPPROV=AUST.CDAPPROV                                      
                                        AND GNAR.FGPEND=1                                      
                                        AND GNAR.CDCYCLE IN (SELECT
                                            GNAP.NRLASTCYCLE                                      
                                        FROM
                                            GNAPPROV GNAP                                      
                                        WHERE
                                            GNAR.CDPROD=GNAP.CDPROD                                          
                                            AND GNAR.CDAPPROV=GNAP.CDAPPROV))                                  
                                    END > (SELECT
                                        SEF_DTEND_WK_DAYS_PERIOD(<!%TODAY%>,
                                        CAST(3.000000000000AS INTEGER) + 1,
                                        (SELECT
                                            CDCALENDAR                                      
                                        FROM
                                            GNCALENDAR                                      
                                        WHERE
                                            FGDEFAULT=1)))                                      
                                        OR CASE                                          
                                            WHEN AU.FGAUDITSTATUS IN (18,
                                            20,
                                            30,
                                            33,
                                            40,
                                            43,
                                            48,
                                            50) THEN AUST.DTPLANNEDENDDATE                                          
                                            WHEN AU.FGAUDITSTATUS IN (25,
                                            36,
                                            46,
                                            53) THEN (SELECT
                                                MAX(GNAR.DTDEADLINE)                                          
                                            FROM
                                                GNAPPROVRESP GNAR                                          
                                            WHERE
                                                GNAR.CDPROD=AUST.CDPROD                                              
                                                AND GNAR.CDAPPROV=AUST.CDAPPROV                                              
                                                AND GNAR.FGPEND=1                                              
                                                AND GNAR.CDCYCLE IN (SELECT
                                                    GNAP.NRLASTCYCLE                                              
                                                FROM
                                                    GNAPPROV GNAP                                              
                                                WHERE
                                                    GNAR.CDPROD=GNAP.CDPROD                                                  
                                                    AND GNAR.CDAPPROV=GNAP.CDAPPROV))                                          
                                            END IS NULL) THEN 3                                      
                                        WHEN CASE                                          
                                            WHEN AU.FGAUDITSTATUS IN (18,
                                            20,
                                            30,
                                            33,
                                            40,
                                            43,
                                            48,
                                            50) THEN AUST.DTPLANNEDENDDATE                                          
                                            WHEN AU.FGAUDITSTATUS IN (25,
                                            36,
                                            46,
                                            53) THEN (SELECT
                                                MAX(GNAR.DTDEADLINE)                                          
                                            FROM
                                                GNAPPROVRESP GNAR                                          
                                            WHERE
                                                GNAR.CDPROD=AUST.CDPROD                                              
                                                AND GNAR.CDAPPROV=AUST.CDAPPROV                                              
                                                AND GNAR.FGPEND=1                                              
                                                AND GNAR.CDCYCLE IN (SELECT
                                                    GNAP.NRLASTCYCLE                                              
                                                FROM
                                                    GNAPPROV GNAP                                              
                                                WHERE
                                                    GNAR.CDPROD=GNAP.CDPROD                                                  
                                                    AND GNAR.CDAPPROV=GNAP.CDAPPROV))                                          
                                            END >= CAST(<!%TODAY%> AS DATE) THEN 2                                          
                                            ELSE 1                                      
                                        END AS VARCHAR(50))|| '' || (CAST( CASE                                      
                                        WHEN CASE                                          
                                            WHEN AU.FGAUDITSTATUS IN (18,
                                            20,
                                            30,
                                            33,
                                            40,
                                            43,
                                            48,
                                            50) THEN AUST.DTPLANNEDENDDATE                                          
                                            WHEN AU.FGAUDITSTATUS IN (25,
                                            36,
                                            46,
                                            53) THEN (SELECT
                                                MAX(GNAR.DTDEADLINE)                                          
                                            FROM
                                                GNAPPROVRESP GNAR                                          
                                            WHERE
                                                GNAR.CDPROD=AUST.CDPROD                                              
                                                AND GNAR.CDAPPROV=AUST.CDAPPROV                                              
                                                AND GNAR.FGPEND=1                                              
                                                AND GNAR.CDCYCLE IN (SELECT
                                                    GNAP.NRLASTCYCLE                                              
                                                FROM
                                                    GNAPPROV GNAP                                              
                                                WHERE
                                                    GNAR.CDPROD=GNAP.CDPROD                                                  
                                                    AND GNAR.CDAPPROV=GNAP.CDAPPROV))                                          
                                            END IS NULL THEN 99999999                                          
                                            ELSE CAST(to_char( CASE                                              
                                                WHEN AU.FGAUDITSTATUS IN (18,20,30,33,40,43,48,50) THEN AUST.DTPLANNEDENDDATE                                              
                                                WHEN AU.FGAUDITSTATUS IN (25,36,46,53) THEN (SELECT
                                                    MAX(GNAR.DTDEADLINE)                                              
                                                FROM
                                                    GNAPPROVRESP GNAR                                              
                                                WHERE
                                                    GNAR.CDPROD=AUST.CDPROD                                                  
                                                    AND GNAR.CDAPPROV=AUST.CDAPPROV                                                  
                                                    AND GNAR.FGPEND=1                                                  
                                                    AND GNAR.CDCYCLE IN (SELECT
                                                        GNAP.NRLASTCYCLE                                                  
                                                    FROM
                                                        GNAPPROV GNAP                                                  
                                                    WHERE
                                                        GNAR.CDPROD=GNAP.CDPROD                                                      
                                                        AND GNAR.CDAPPROV=GNAP.CDAPPROV))                                              
                                                END, 'YYYYMMDD') AS INTEGER)                                      
                                        END AS VARCHAR(50))                                 
                                    ) AS FGDEADLINEAU, CASE                                      
                                        WHEN AU.FGAUDITSTATUS IN (
                                            56,60                                     
                                        ) THEN ''                                      
                                        WHEN (
                                            CASE                                              
                                                WHEN AU.FGAUDITSTATUS IN (
                                                    18,20,30,33,40,43,48,50                                             
                                                ) THEN AUST.DTPLANNEDENDDATE                                              
                                                WHEN AU.FGAUDITSTATUS IN (
                                                    25,36,46,53                                             
                                                ) THEN (SELECT
                                                    MAX(GNAR.DTDEADLINE)                                              
                                                FROM
                                                    GNAPPROVRESP GNAR                                              
                                                WHERE
                                                    GNAR.CDPROD=AUST.CDPROD                                                  
                                                    AND GNAR.CDAPPROV=AUST.CDAPPROV                                                  
                                                    AND GNAR.FGPEND=1                                                  
                                                    AND GNAR.CDCYCLE IN (SELECT
                                                        GNAP.NRLASTCYCLE                                                  
                                                    FROM
                                                        GNAPPROV GNAP                                                  
                                                    WHERE
                                                        GNAR.CDPROD=GNAP.CDPROD                                                      
                                                        AND GNAR.CDAPPROV=GNAP.CDAPPROV))                                              
                                                END > (
                                                    SELECT
                                                        SEF_DTEND_WK_DAYS_PERIOD(<!%TODAY%>,
                                                        CAST(3.000000000000AS INTEGER) + 1,
                                                        (SELECT
                                                            CDCALENDAR                                                      
                                                        FROM
                                                            GNCALENDAR                                                      
                                                        WHERE
                                                            FGDEFAULT=1)))                                                      
                                                        OR CASE                                                          
                                                            WHEN AU.FGAUDITSTATUS IN (18,
                                                            20,
                                                            30,
                                                            33,
                                                            40,
                                                            43,
                                                            48,
                                                            50) THEN AUST.DTPLANNEDENDDATE                                                          
                                                            WHEN AU.FGAUDITSTATUS IN (25,
                                                            36,
                                                            46,
                                                            53) THEN (SELECT
                                                                MAX(GNAR.DTDEADLINE)                                                          
                                                            FROM
                                                                GNAPPROVRESP GNAR                                                          
                                                            WHERE
                                                                GNAR.CDPROD=AUST.CDPROD                                                              
                                                                AND GNAR.CDAPPROV=AUST.CDAPPROV                                                              
                                                                AND GNAR.FGPEND=1                                                              
                                                                AND GNAR.CDCYCLE IN (SELECT
                                                                    GNAP.NRLASTCYCLE                                                              
                                                                FROM
                                                                    GNAPPROV GNAP                                                              
                                                                WHERE
                                                                    GNAR.CDPROD=GNAP.CDPROD                                                                  
                                                                    AND GNAR.CDAPPROV=GNAP.CDAPPROV))                                                          
                                                            END IS NULL) THEN '#{100900}'                                                      
                                                        WHEN CASE                                                          
                                                            WHEN AU.FGAUDITSTATUS IN (18,
                                                            20,
                                                            30,
                                                            33,
                                                            40,
                                                            43,
                                                            48,
                                                            50) THEN AUST.DTPLANNEDENDDATE                                                          
                                                            WHEN AU.FGAUDITSTATUS IN (25,
                                                            36,
                                                            46,
                                                            53) THEN (SELECT
                                                                MAX(GNAR.DTDEADLINE)                                                          
                                                            FROM
                                                                GNAPPROVRESP GNAR                                                          
                                                            WHERE
                                                                GNAR.CDPROD=AUST.CDPROD                                                              
                                                                AND GNAR.CDAPPROV=AUST.CDAPPROV                                                              
                                                                AND GNAR.FGPEND=1                                                              
                                                                AND GNAR.CDCYCLE IN (SELECT
                                                                    GNAP.NRLASTCYCLE                                                              
                                                                FROM
                                                                    GNAPPROV GNAP                                                              
                                                                WHERE
                                                                    GNAR.CDPROD=GNAP.CDPROD                                                                  
                                                                    AND GNAR.CDAPPROV=GNAP.CDAPPROV))                                                          
                                                            END >= CAST(<!%TODAY%> AS DATE) THEN '#{201639}'                                                          
                                                            ELSE '#{100899}'                                                      
                                                        END AS NMDEADLINE,(
                                                            SELECT
                                                                COALESCE(GNTRANSLATIONLANGUAGE.NMTRANSLATION,
                                                                ADATTRIBVALUE.NMATTRIBUTE) AS NMATTRIBUTE                                                          
                                                            FROM
                                                                ADATTRIBVALUE                                                          
                                                            INNER JOIN
                                                                AUAUDITATTRIBUTE                                                                  
                                                                    ON ADATTRIBVALUE.CDATTRIBUTE=AUAUDITATTRIBUTE.CDATTRIBUTE                                                          
                                                            LEFT JOIN
                                                                GNTRANSLATIONLANGUAGE                                                                  
                                                                    ON ADATTRIBVALUE.CDTRANSLATION=GNTRANSLATIONLANGUAGE.CDTRANSLATION                                                                  
                                                                    AND GNTRANSLATIONLANGUAGE.FGLANGUAGE=3                                                          
                                                            WHERE
                                                                ADATTRIBVALUE.CDVALUE=AUAUDITATTRIBUTE.CDVALUE                                                              
                                                                AND AUAUDITATTRIBUTE.CDAUDIT=AU.CDAUDIT                                                              
                                                                AND ADATTRIBVALUE.CDATTRIBUTE=1                                                     
                                                        ) AS NMATTRIB1,(
                                                            SELECT
                                                                COALESCE(GNTRANSLATIONLANGUAGE.NMTRANSLATION,
                                                                ADATTRIBVALUE.NMATTRIBUTE) AS NMATTRIBUTE                                                          
                                                            FROM
                                                                ADATTRIBVALUE                                                          
                                                            INNER JOIN
                                                                AUAUDITATTRIBUTE                                                                  
                                                                    ON ADATTRIBVALUE.CDATTRIBUTE=AUAUDITATTRIBUTE.CDATTRIBUTE                                                          
                                                            LEFT JOIN
                                                                GNTRANSLATIONLANGUAGE                                                                  
                                                                    ON ADATTRIBVALUE.CDTRANSLATION=GNTRANSLATIONLANGUAGE.CDTRANSLATION                                                                  
                                                                    AND GNTRANSLATIONLANGUAGE.FGLANGUAGE=3                                                          
                                                            WHERE
                                                                ADATTRIBVALUE.CDVALUE=AUAUDITATTRIBUTE.CDVALUE                                                              
                                                                AND AUAUDITATTRIBUTE.CDAUDIT=AU.CDAUDIT                                                              
                                                                AND ADATTRIBVALUE.CDATTRIBUTE=3                                                     
                                                        ) AS NMATTRIB3,NULL AS FGMEETING, NULL AS QTACTPERC, NULL AS IDTASKTYPE, NULL AS MAXREVISION, NULL AS IDUSEREXECRESP                                                  
                                                    FROM
                                                        AUAUDIT AU                                                  
                                                    INNER JOIN
                                                        AUSCOPECONFIG AUCFG                                                          
                                                            ON (
                                                                AUCFG.CDSCOPECONFIG=AU.CDSCOPECONFIG                                                         
                                                            )                                                  
                                                    INNER JOIN
                                                        AUAUDITTYPE AUTP                                                          
                                                            ON AU.CDAUDITTYPE=AUTP.CDAUDITTYPE                                                  
                                                    LEFT OUTER JOIN
                                                        AUPLANEXECMODEL APEM                                                          
                                                            ON APEM.CDPLANEXECMODEL=AU.CDPLANEXECMODEL                                                  
                                                    LEFT OUTER JOIN
                                                        AUPLAN AUP                                                          
                                                            ON AUP.CDPLAN=APEM.CDPLAN                                                  
                                                    LEFT OUTER JOIN
                                                        AUAUDITSTEP AUST                                                          
                                                            ON (
                                                                AU.CDAUDIT=AUST.CDAUDIT                                                              
                                                                AND (
                                                                    (
                                                                        AUST.FGAUDITSTEP=2                                                                      
                                                                        AND AU.FGAUDITSTATUS IN(
                                                                            18,
                                                                        20,
                                                                        25))                                                                      
                                                                        OR (AUST.FGAUDITSTEP=3                                                                      
                                                                        AND AU.FGAUDITSTATUS IN(30,
                                                                        33,
                                                                        36))                                                                      
                                                                        OR (AUST.FGAUDITSTEP=4                                                                      
                                                                        AND AU.FGAUDITSTATUS IN(40,
                                                                        43,
                                                                        46))                                                                      
                                                                        OR (AUST.FGAUDITSTEP=5                                                                      
                                                                        AND AU.FGAUDITSTATUS IN(48,
                                                                        50,
                                                                        53))))                                                                  
                                                                    LEFT OUTER JOIN
                                                                        AUSCOPECONFIG                                                                          
                                                                            ON (
                                                                                AUSCOPECONFIG.CDSCOPECONFIG=AU.CDSCOPECONFIG                                                                         
                                                                            )                                                                  
                                                                    LEFT OUTER JOIN
                                                                        (
                                                                            SELECT
                                                                                AUCONFORMITYLEVEL.FGSYMBOL,
                                                                                AUSCOPESTRUCT.VLCONFORMITYPERCENT,
                                                                                AUCONFORMITYLEVEL.IDCOLOR,
                                                                                AUSCOPESTRUCT.VLVALUE,
                                                                                AUCONFORMITYLEVEL.IDCONFORMITYLEVEL,
                                                                                AUCONFORMITYLEVEL.NMCONFORMITYLEVEL,
                                                                                AUCONFORMITYLEVEL.IDCONFORMITYLEVEL||' - '||AUCONFORMITYLEVEL.NMCONFORMITYLEVEL AS CONFORMITYLEVEL,
                                                                                AUSCOPESTRUCT.CDSCOPEDEFINITION                                                                          
                                                                            FROM
                                                                                AUSCOPESTRUCT                                                                          
                                                                            LEFT OUTER JOIN
                                                                                AUCONFORMITYLEVEL                                                                                  
                                                                                    ON (
                                                                                        AUSCOPESTRUCT.CDAUDITEVALCRIT=AUCONFORMITYLEVEL.CDAUDITEVALCRIT                                                                                      
                                                                                        AND AUSCOPESTRUCT.CDAUDITEVALCRITREV=AUCONFORMITYLEVEL.CDAUDITEVALCRITREV                                                                                      
                                                                                        AND AUSCOPESTRUCT.CDCONFORMITYLEVEL=AUCONFORMITYLEVEL.CDCONFORMITYLEVEL                                                                                 
                                                                                    )                                                                          
                                                                            WHERE
                                                                                AUSCOPESTRUCT.CDSTRUCTOWNER IS NULL                                                                              
                                                                                AND AUSCOPESTRUCT.CDSTRUCT=AUSCOPESTRUCT.CDSTRUCTROOT                                                                              
                                                                                AND AUSCOPESTRUCT.FGREQUIREMENT <> 1                                                                     
                                                                        ) SCOPESTRUCTVALUES                                                                          
                                                                            ON (
                                                                                SCOPESTRUCTVALUES.CDSCOPEDEFINITION=AU.CDSCOPEDEFINITION                                                                         
                                                                            )                                                                  
                                                                    LEFT OUTER JOIN
                                                                        AUAUDITSTEP AUST02                                                                          
                                                                            ON (
                                                                                AUST02.CDAUDIT=AU.CDAUDIT                                                                              
                                                                                AND AUST02.FGAUDITSTEP=2                                                                         
                                                                            )                                                                  
                                                                    LEFT OUTER JOIN
                                                                        AUAUDITSTEP AUST03                                                                          
                                                                            ON (
                                                                                AUST03.CDAUDIT=AU.CDAUDIT                                                                              
                                                                                AND AUST03.FGAUDITSTEP=3                                                                         
                                                                            )                                                                  
                                                                    LEFT OUTER JOIN
                                                                        AUAUDITSTEP AUST04                                                                          
                                                                            ON (
                                                                                AUST04.CDAUDIT=AU.CDAUDIT                                                                              
                                                                                AND AUST04.FGAUDITSTEP=4                                                                         
                                                                            )                                                                  
                                                                    LEFT OUTER JOIN
                                                                        AUAUDITSTEP AUST05                                                                          
                                                                            ON (
                                                                                AUST05.CDAUDIT=AU.CDAUDIT                                                                              
                                                                                AND AUST05.FGAUDITSTEP=5                                                                         
                                                                            )                                                                  
                                                                    LEFT OUTER JOIN
                                                                        ADCOMPANY ADCY1                                                                          
                                                                            ON (
                                                                                AU.CDCUSTOMER=ADCY1.CDCOMPANY                                                                         
                                                                            )                                                                  
                                                                    LEFT OUTER JOIN
                                                                        ADCOMPANY ADCY2                                                                          
                                                                            ON (
                                                                                AU.CDAUDITEESUPPLIER=ADCY2.CDCOMPANY                                                                         
                                                                            )                                                                  
                                                                    LEFT OUTER JOIN
                                                                        ADCOMPANY ADCY3                                                                          
                                                                            ON (
                                                                                AU.CDAUDITORG=ADCY3.CDCOMPANY                                                                         
                                                                            )                                                                  
                                                                    LEFT OUTER JOIN
                                                                        ADDEPARTMENT ADCO1                                                                          
                                                                            ON (
                                                                                AU.CDAUDITEECOMPANIES=ADCO1.CDDEPARTMENT                                                                         
                                                                            )                                                                  
                                                                    LEFT OUTER JOIN
                                                                        ADDEPARTMENT ADCO2                                                                          
                                                                            ON (
                                                                                AU.CDAUDORGCOMPANIES=ADCO2.CDDEPARTMENT                                                                         
                                                                            )                                                                  
                                                                    LEFT OUTER JOIN
                                                                        AUAUDITPURPOSE AUPU                                                                          
                                                                            ON (
                                                                                AU.CDAUDITPURPOSE=AUPU.CDAUDITPURPOSE                                                                         
                                                                            )                                                                  
                                                                    LEFT OUTER JOIN
                                                                        AUAUDITRESULT AURS                                                                          
                                                                            ON (
                                                                                AU.CDAUDITRESULT=AURS.CDAUDITRESULT                                                                         
                                                                            )                                                                  
                                                                    LEFT OUTER JOIN
                                                                        AUAUDRESULTCLASSIF AURC                                                                          
                                                                            ON (
                                                                                AURS.CDAUDITRESULTCRIT=AURC.CDAUDITRESULTCRIT                                                                              
                                                                                AND AURS.CDAUDRESULTCRITREV=AURC.CDAUDRESULTCRITREV                                                                              
                                                                                AND AURS.CDAUDRESULTCLASSIF=AURC.CDAUDRESULTCLASSIF                                                                         
                                                                            )                                                                  
                                                                    INNER JOIN
                                                                        ADTEAM ADTE                                                                          
                                                                            ON(
                                                                                AU.CDCONTROLTEAM=ADTE.CDTEAM                                                                         
                                                                            )                                                                  
                                                                    LEFT OUTER JOIN
                                                                        AUAUDITAUDITOR AUT2                                                                          
                                                                            ON (
                                                                                AU.CDAUDIT=AUT2.CDAUDIT                                                                              
                                                                                AND AUT2.FGTEAMLEADER=1                                                                         
                                                                            )                                                                  
                                                                    LEFT OUTER JOIN
                                                                        AUINTERNALAUDITOR AUINT                                                                          
                                                                            ON (
                                                                                AUT2.CDINTERNALAUDITOR=AUINT.CDINTERNALAUDITOR                                                                         
                                                                            )                                                                  
                                                                    LEFT OUTER JOIN
                                                                        ADUSER ADU2                                                                          
                                                                            ON (
                                                                                AUINT.CDINTAUDITORUSER=ADU2.CDUSER                                                                         
                                                                            )                                                                  
                                                                    LEFT OUTER JOIN
                                                                        AUEXTERNALAUDITOR AUEXT                                                                          
                                                                            ON (
                                                                                AUT2.CDAUDITORG=AUEXT.CDAUDITORG                                                                              
                                                                                AND AUT2.CDEXTERNALAUDITOR=AUEXT.CDEXTERNALAUDITOR                                                                         
                                                                            )                                                                  
                                                                    LEFT OUTER JOIN
                                                                        AUAUDRESULTCRITREV AURCV                                                                          
                                                                            ON(
                                                                                AURC.CDAUDRESULTCRITREV=AURCV.CDAUDRESULTCRITREV                                                                              
                                                                                AND AURC.CDAUDITRESULTCRIT=AURCV.CDAUDITRESULTCRIT                                                                         
                                                                            )                                                                  
                                                                    LEFT OUTER JOIN
                                                                        AUAUDITRESULTCRIT AURCR                                                                          
                                                                            ON(
                                                                                AURCV.CDAUDITRESULTCRIT=AURCR.CDAUDITRESULTCRIT                                                                         
                                                                            )                                                                  
                                                                    LEFT JOIN
                                                                        (
                                                                            SELECT
                                                                                AUSCOPESTRUCT.CDSCOPEDEFINITION,
                                                                                (COUNT(GNASSOCACTIONPLAN.CDASSOCACTIONPLAN) + COUNT(GNASSOCWORKFLOW.CDASSOCWORKFLOW) + COUNT(GNASSOCACTION.CDASSOCACTION)) AS QTD_OCCUR                                                                          
                                                                            FROM
                                                                                AUSCOPESTRUCT                                                                          
                                                                            LEFT JOIN
                                                                                GNASSOCACTIONPLAN                                                                                  
                                                                                    ON (
                                                                                        AUSCOPESTRUCT.CDASSOC=GNASSOCACTIONPLAN.CDASSOC                                                                                 
                                                                                    )                                                                          
                                                                            LEFT JOIN
                                                                                GNASSOCWORKFLOW                                                                                  
                                                                                    ON (
                                                                                        AUSCOPESTRUCT.CDASSOC=GNASSOCWORKFLOW.CDASSOC                                                                                 
                                                                                    )                                                                          
                                                                            LEFT JOIN
                                                                                GNASSOCACTION                                                                                  
                                                                                    ON (
                                                                                        GNASSOCACTION.CDASSOC=AUSCOPESTRUCT.CDASSOC                                                                                 
                                                                                    )                                                                          
                                                                            WHERE
                                                                                AUSCOPESTRUCT.FGSELECTED=1                                                                          
                                                                            GROUP BY
                                                                                AUSCOPESTRUCT.CDSCOPEDEFINITION                                                                     
                                                                        ) AUDIT_OCCURRENCES                                                                          
                                                                            ON AU.CDSCOPEDEFINITION=AUDIT_OCCURRENCES.CDSCOPEDEFINITION                                                                  
                                                                    LEFT JOIN
                                                                        (
                                                                            SELECT
                                                                                COUNT(1) AS COUNT_DOC,
                                                                                CDASSOC                                                                          
                                                                            FROM
                                                                                GNASSOCDOCUMENT                                                                          
                                                                            GROUP BY
                                                                                CDASSOC                                                                     
                                                                        ) ASSOC_DOC                                                                          
                                                                            ON AU.CDASSOC=ASSOC_DOC.CDASSOC                                                                  
                                                                    LEFT JOIN
                                                                        (
                                                                            SELECT
                                                                                COUNT(1) AS COUNT_ATTACH,
                                                                                CDASSOC                                                                          
                                                                            FROM
                                                                                GNASSOCATTACH                                                                          
                                                                            GROUP BY
                                                                                CDASSOC                                                                     
                                                                        ) ASSOC_ATTACH                                                                          
                                                                            ON AU.CDASSOC=ASSOC_ATTACH.CDASSOC                                                                  
                                                                    WHERE
                                                                        1=1                                                                      
                                                                        AND AU.FGMODEL IN (
                                                                            2                                                                     
                                                                        )                                                                  
                                                                    UNION
                                                                    ALL SELECT
                                                                        NULL AS PORC_CUMPLE,
                                                                        NULL AS LISTADO_REQUISITOS,
                                                                        NULL AS CDPLANEXECMODEL,
                                                                        AUCFG.FGREQUIREMENT AS ISREQUIREMENTSCOPE,
                                                                        NULL AS CDINSTANCE,
                                                                        NULL AS IDPLAN,
                                                                        NULL AS NMPLAN,
                                                                        AUTP.IDAUDITTYPE,
                                                                        AUTP.NMAUDITTYPE,
                                                                        PROJ.NRPROJ AS IDAUDIT,
                                                                        PROJ.NMPROJ AS NMAUDIT,
                                                                        AU.FGAUDITSTATUS,
                                                                        AU.CDAUDIT,
                                                                        AUTP.CDAUDITTYPE,
                                                                        NULL AS FGTEMPLATESTATUS,
                                                                        AU.CDFAVORITE,
                                                                        2 AS FGOBJECT,
                                                                        PROJ.CDTASK,
                                                                        PROJ.CDBASETASK,
                                                                        PROJ.CDTASKTYPE,
                                                                        PROJ.FGPHASE,
                                                                        PROJ.DTPLANST,
                                                                        PROJ.DTPLANEND,
                                                                        PROJ.DTREPLST,
                                                                        PROJ.DTREPLEND,
                                                                        PROJ.DTACTST,
                                                                        PROJ.DTACTEND,
                                                                        PROJ.DTSCHEDULEDST,
                                                                        PROJ.DTSCHEDULEDEND,
                                                                        PROJ.FGOUTDATED,
                                                                        PROJ.FGLOCK,
                                                                        NULL AS FGLASTAUDITSTATUS,
                                                                        AU.CDSCOPEDEFINITION,
                                                                        PROJ.FGDOCUMENT AS FGHASDOCUMENT,
                                                                        PROJ.FGATTACH AS FGHASATTACHMENT,
                                                                        AUDIT_OCCURRENCES.QTD_OCCUR AS AUDIT_OCCURRENCE,
                                                                        CASE                                                                          
                                                                            WHEN AUSCOPECONFIG.FGREQUIREMENT=1 THEN AURC.FGSYMBOL                                                                          
                                                                            ELSE SCOPESTRUCTVALUES.FGSYMBOL                                                                      
                                                                        END AS FGSYMBOL,
                                                                        CASE                                                                          
                                                                            WHEN AUSCOPECONFIG.FGREQUIREMENT=1 THEN AURS.VLRESULTVALUE                                                                          
                                                                            ELSE SCOPESTRUCTVALUES.VLVALUE                                                                      
                                                                        END AS VLVALUERESULT,
                                                                        CASE                                                                          
                                                                            WHEN AUSCOPECONFIG.FGREQUIREMENT=1 THEN (CASE                                                                              
                                                                                WHEN AURS.VLRESULTPERCENT < 0 THEN 0                                                                              
                                                                                ELSE AURS.VLRESULTPERCENT                                                                          
                                                                            END)                                                                          
                                                                            ELSE (CASE                                                                              
                                                                                WHEN SCOPESTRUCTVALUES.VLCONFORMITYPERCENT < 0 THEN 0                                                                              
                                                                                ELSE SCOPESTRUCTVALUES.VLCONFORMITYPERCENT                                                                          
                                                                            END)                                                                      
                                                                        END AS VLRESULTPERCENT,
                                                                        CASE                                                                          
                                                                            WHEN AUSCOPECONFIG.FGREQUIREMENT=1 THEN AURC.IDCOLOR                                                                          
                                                                            ELSE SCOPESTRUCTVALUES.IDCOLOR                                                                      
                                                                        END AS IDCOLOR,
                                                                        AU.CDASSOC,
                                                                        AU.FGAUDITTYPE,
                                                                        CASE                                                                          
                                                                            WHEN ADCY1.CDCOMPANY IS NULL THEN NULL                                                                          
                                                                            ELSE (ADCY1.IDCOMMERCIAL||' - '||ADCY1.NMCOMPANY)                                                                      
                                                                        END AS IDCUSTOMER,
                                                                        CASE                                                                          
                                                                            WHEN ADCO1.CDDEPARTMENT IS NULL THEN NULL                                                                          
                                                                            ELSE (ADCO1.IDDEPARTMENT ||' - '|| ADCO1.NMDEPARTMENT)                                                                      
                                                                        END AS IDAUDITEECOMPANIES,
                                                                        CASE                                                                          
                                                                            WHEN ADCY2.CDCOMPANY IS NULL THEN NULL                                                                          
                                                                            ELSE (ADCY2.IDCOMMERCIAL||' - '||ADCY2.NMCOMPANY)                                                                      
                                                                        END AS IDAUDITEESUPPLIER,
                                                                        CASE                                                                          
                                                                            WHEN ADCO2.CDDEPARTMENT IS NULL THEN NULL                                                                          
                                                                            ELSE (ADCO2.IDDEPARTMENT||' - '||ADCO2.NMDEPARTMENT)                                                                      
                                                                        END AS IDAUDORGCOMPANIES,
                                                                        CASE                                                                          
                                                                            WHEN ADCY3.CDCOMPANY IS NULL THEN NULL                                                                          
                                                                            ELSE (ADCY3.IDCOMMERCIAL||' - '||ADCY3.NMCOMPANY)                                                                      
                                                                        END AS IDAUDITORG,
                                                                        AUINT.CDINTAUDITORUSER,
                                                                        CASE AUT2.FGAUDITORTYPE                                                                          
                                                                            WHEN 10 THEN ADU2.NMUSER                                                                          
                                                                            WHEN 20 THEN AUEXT.NMEXTERNALAUDITOR                                                                      
                                                                        END AS IDLEADER,
                                                                        CAST (CASE AUT2.FGAUDITORTYPE                                                                          
                                                                            WHEN 10 THEN ADU2.NMUSER                                                                          
                                                                            WHEN 20 THEN AUEXT.NMEXTERNALAUDITOR                                                                      
                                                                        END AS VARCHAR(255)) AS NMLEADER,
                                                                        PROJ.DTPLANST AS DTPLANNEDSTARTDT,
                                                                        PROJ.DTPLANEND AS DTPLANNEDENDDATE,
                                                                        PROJ.DTACTST AS DTACTUALSTARTDT,
                                                                        PROJ.DTACTEND AS DTACTUALENDDATE,
                                                                        AUPU.IDAUDITPURPOSE,
                                                                        CASE                                                                          
                                                                            WHEN ADTE.CDTEAM IS NULL THEN NULL                                                                          
                                                                            ELSE (ADTE.IDTEAM||' - '||ADTE.NMTEAM)                                                                      
                                                                        END AS IDTEAM,
                                                                        CASE                                                                          
                                                                            WHEN AUSCOPECONFIG.FGREQUIREMENT=1 THEN AURC.IDAUDRESULTCLASSIF                                                                          
                                                                            ELSE SCOPESTRUCTVALUES.IDCONFORMITYLEVEL                                                                      
                                                                        END AS IDAUDRESULTCLASSIF,
                                                                        CASE                                                                          
                                                                            WHEN AUSCOPECONFIG.FGREQUIREMENT=1 THEN AURC.NMAUDRESULTCLASSIF                                                                          
                                                                            ELSE SCOPESTRUCTVALUES.NMCONFORMITYLEVEL                                                                      
                                                                        END AS NMAUDRESULTCLASSIF,
                                                                        CASE                                                                          
                                                                            WHEN AUSCOPECONFIG.FGREQUIREMENT=1 THEN IDAUDRESULTCLASSIF||' - '||AURC.NMAUDRESULTCLASSIF                                                                          
                                                                            ELSE SCOPESTRUCTVALUES.CONFORMITYLEVEL                                                                      
                                                                        END AS RESULT,
                                                                        CASE                                                                          
                                                                            WHEN (AU.FGAUDITRESULT=1                                                                          
                                                                            OR AU.FGAUDITCRITRESULT=1                                                                          
                                                                            OR AU.FGPROCESSRESULT=1                                                                          
                                                                            OR AU.FGDEPARTMENTRESULT=1                                                                          
                                                                            OR AU.FGITEMRESULT=1                                                                          
                                                                            OR AU.FGPROJECTRESULT=1                                                                          
                                                                            OR AU.FGASSETRESULT=0                                                                          
                                                                            OR AU.FGRISKCTRLRESULT=1                                                                          
                                                                            OR AU.FGSUPPLYRESULT=1) THEN 1                                                                          
                                                                            ELSE 2                                                                      
                                                                        END AS FGAUDITALLRESULT,
                                                                        (SELECT
                                                                            CAST (CASE                                                                              
                                                                                WHEN PRSITUATIONCHANGE.FGPROJECTSITUATION=9 THEN '#{104919}'                                                                              
                                                                                WHEN PRSITUATIONCHANGE.FGPROJECTSITUATION=2                                                                              
                                                                                AND PRSITUATIONCHANGE.FGTASKSITUATION=3 THEN '#{100303}'                                                                              
                                                                                WHEN PRSITUATIONCHANGE.FGPROJECTSITUATION=2 THEN '#{103131}'                                                                              
                                                                                WHEN PRSITUATIONCHANGE.FGPROJECTSITUATION=3 THEN '#{100263}'                                                                              
                                                                                WHEN PRSITUATIONCHANGE.FGPROJECTSITUATION=10 THEN '#{100761}'                                                                              
                                                                                WHEN PRSITUATIONCHANGE.FGPROJECTSITUATION=4 THEN '#{100667}'                                                                              
                                                                                WHEN PROJ.FGPHASE=7 THEN '#{104230}'                                                                              
                                                                                WHEN PROJ.FGPHASE=6 THEN '#{107788}'                                                                              
                                                                                WHEN PROJ.FGPHASE=8 THEN '#{100667}'                                                                          
                                                                            END AS VARCHAR(255)) AS IDSITUATION                                                                      
                                                                        FROM
                                                                            PRSITUATIONCHANGE                                                                      
                                                                        INNER JOIN
                                                                            PRTASK                                                                              
                                                                                ON (
                                                                                    PRTASK.CDTASK=PRSITUATIONCHANGE.CDTASK                                                                             
                                                                                )                                                                      
                                                                        WHERE
                                                                            PRSITUATIONCHANGE.CDTASK=PROJ.CDTASK                                                                          
                                                                            AND PRSITUATIONCHANGE.CDSITUATIONCHANGE=(
                                                                                SELECT
                                                                                    MAX(SUB.CDSITUATIONCHANGE)                                                                              
                                                                                FROM
                                                                                    PRSITUATIONCHANGE SUB                                                                              
                                                                                WHERE
                                                                                    SUB.CDTASK=PROJ.CDTASK                                                                         
                                                                            )                                                                     
                                                                        ) AS IDSITUATION, NULL AS IDCLASSRESULT, CAST (CASE AU.FGAUDITTYPE                                                                          
                                                                            WHEN 10 THEN '#{112681}'                                                                          
                                                                            WHEN 20 THEN '#{112683}'                                                                          
                                                                            WHEN 30 THEN '#{112682}'                                                                          
                                                                            WHEN 40 THEN '#{112684}'                                                                      
                                                                        END AS VARCHAR(255)) AS IDTAUDITYPE, NULL AS NRPLANNEDENDYEAR, NULL AS NRPLANNEDENDMONTH, NULL AS NMPLANNEDENDYEAR, NULL AS NMPLANNEDENDMONTH, NULL AS FGAUDITSTEP02, NULL AS DTPLANNEDSTARTDT02, NULL AS DTPLANNEDENDDATE02, NULL AS DTACTUALSTARTDT02, NULL AS DTACTUALENDDATE02, NULL AS FGAUDITSTEP03, NULL AS DTPLANNEDSTARTDT03, NULL AS DTPLANNEDENDDATE03, NULL AS DTACTUALSTARTDT03, NULL AS DTACTUALENDDATE03, NULL AS FGAUDITSTEP04, NULL AS FGRESPONSIBLETYPE04, NULL AS DTPLANNEDSTARTDT04, NULL AS DTPLANNEDENDDATE04, NULL AS DTACTUALSTARTDT04, NULL AS DTACTUALENDDATE04, NULL AS FGAUDITSTEP05, NULL AS DTPLANNEDSTARTDT05, NULL AS DTPLANNEDENDDATE05, NULL AS DTACTUALSTARTDT05, NULL AS DTACTUALENDDATE05, NULL AS QT, PROJ.FGDEADLINE, NULL AS FGDEADLINEAU, NULL AS NMDEADLINE,NULL AS NMATTRIB1,NULL AS NMATTRIB3 ,PROJ.FGMEETING, PROJ.QTACTPERC, PROJ.IDTASKTYPE, PROJ.MAXREVISION, PROJ.NMUSER AS IDUSEREXECRESP                                                                  
                                                                    FROM
                                                                        (SELECT
                                                                            0 AS FGDEADLINE,
                                                                            AB.FGMEETING,
                                                                            AB.FGDOCUMENT,
                                                                            AB.FGATTACH,
                                                                            AB.FGPHASE,
                                                                            AB.QTACTPERC,
                                                                            TA.IDTASKTYPE,
                                                                            AB.NMIDTASK AS NRPROJ,
                                                                            AB.NMTASK AS NMPROJ,
                                                                            (SELECT
                                                                                IDREVISION                                                                          
                                                                            FROM
                                                                                PRTASKREVISION REV                                                                          
                                                                            WHERE
                                                                                REV.CDTASK=AB.CDTASK                                                                              
                                                                                AND REV.FGCURRENT=1) AS MAXREVISION,
                                                                            AB.DTPLANST,
                                                                            AB.DTREPLST,
                                                                            AB.DTACTST,
                                                                            AB.DTPLANEND,
                                                                            AB.DTREPLEND,
                                                                            AB.DTACTEND,
                                                                            US.NMUSER,
                                                                            AB.CDTASK,
                                                                            AB.CDBASETASK,
                                                                            AB.FGOUTDATED,
                                                                            AB.CDTASKTYPE,
                                                                            AB.DTSCHEDULEDST,
                                                                            AB.DTSCHEDULEDEND,
                                                                            AB.CDTEAMRESP,
                                                                            AB.FGLOCK                                                                      
                                                                        FROM
                                                                            PRTASKFINANCES ATV,
                                                                            PRTASKBROADCAST PRTB,
                                                                            PRTASK AB                                                                      
                                                                        LEFT JOIN
                                                                            (
                                                                                SELECT
                                                                                    DISTINCT PVIEW.PR_CDTASK                                                                              
                                                                                FROM
                                                                                    (SELECT
                                                                                        ACCVIEW.CDTASK AS PR_CDTASK,
                                                                                        ACCVIEW.FGACCESSCOST,
                                                                                        UDP.CDUSER                                                                                   
                                                                                    FROM
                                                                                        PRTASKACCESS ACCVIEW                                                                                  
                                                                                    INNER JOIN
                                                                                        ADUSERDEPTPOS UDP                                                                                          
                                                                                            ON UDP.CDDEPARTMENT=ACCVIEW.CDDEPARTMENT                                                                                  
                                                                                    WHERE
                                                                                        ACCVIEW.FGACCESS=1                                                                                      
                                                                                        AND ACCVIEW.FGTEAMMEMBER=1                                                                                      
                                                                                        AND UDP.CDUSER=38 /*DONTREMOVE*/                                                                                 
                                                                                    UNION
                                                                                    ALL/*DONTREMOVE*/ SELECT
                                                                                        ACCVIEW.CDTASK AS PR_CDTASK,
                                                                                        ACCVIEW.FGACCESSCOST,
                                                                                        UDP.CDUSER                                                                                   
                                                                                    FROM
                                                                                        PRTASKACCESS ACCVIEW                                                                                  
                                                                                    INNER JOIN
                                                                                        ADUSERDEPTPOS UDP                                                                                          
                                                                                            ON UDP.CDPOSITION=ACCVIEW.CDPOSITION                                                                                  
                                                                                    WHERE
                                                                                        ACCVIEW.FGACCESS=1                                                                                      
                                                                                        AND ACCVIEW.FGTEAMMEMBER=2                                                                                      
                                                                                        AND UDP.CDUSER=38 /*DONTREMOVE*/                                                                                 
                                                                                    UNION
                                                                                    ALL/*DONTREMOVE*/ SELECT
                                                                                        ACCVIEW.CDTASK AS PR_CDTASK,
                                                                                        ACCVIEW.FGACCESSCOST,
                                                                                        UDP.CDUSER                                                                                   
                                                                                    FROM
                                                                                        PRTASKACCESS ACCVIEW                                                                                  
                                                                                    INNER JOIN
                                                                                        ADUSERDEPTPOS UDP                                                                                          
                                                                                            ON UDP.CDDEPARTMENT=ACCVIEW.CDDEPARTMENT                                                                                           
                                                                                            AND UDP.CDPOSITION=ACCVIEW.CDPOSITION                                                                                  
                                                                                    WHERE
                                                                                        ACCVIEW.FGACCESS=1                                                                                      
                                                                                        AND ACCVIEW.FGTEAMMEMBER=3                                                                                      
                                                                                        AND UDP.CDUSER=38 /*DONTREMOVE*/                                                                                 
                                                                                    UNION
                                                                                    ALL/*DONTREMOVE*/ SELECT
                                                                                        ACCVIEW.CDTASK AS PR_CDTASK,
                                                                                        ACCVIEW.FGACCESSCOST,
                                                                                        ACCVIEW.CDUSER                                                                                   
                                                                                    FROM
                                                                                        PRTASKACCESS ACCVIEW                                                                                  
                                                                                    WHERE
                                                                                        ACCVIEW.FGACCESS=1                                                                                      
                                                                                        AND ACCVIEW.FGTEAMMEMBER=4                                                                                      
                                                                                        AND ACCVIEW.CDUSER=38 /*DONTREMOVE*/                                                                                 
                                                                                    UNION
                                                                                    ALL/*DONTREMOVE*/ SELECT
                                                                                        ACCVIEW.CDTASK AS PR_CDTASK,
                                                                                        ACCVIEW.FGACCESSCOST,
                                                                                        TMM.CDUSER                                                                                   
                                                                                    FROM
                                                                                        PRTASKACCESS ACCVIEW                                                                                  
                                                                                    INNER JOIN
                                                                                        ADTEAMUSER TMM                                                                                          
                                                                                            ON TMM.CDTEAM=ACCVIEW.CDTEAM                                                                                  
                                                                                    WHERE
                                                                                        ACCVIEW.FGACCESS=1                                                                                      
                                                                                        AND ACCVIEW.FGTEAMMEMBER=5                                                                                      
                                                                                        AND TMM.CDUSER=38                                                                             
                                                                                ) PVIEW                                                                          
                                                                            WHERE
                                                                                1=1                                                                     
                                                                        ) PRTASKSECURITY                                                                          
                                                                            ON PRTASKSECURITY.PR_CDTASK=AB.CDBASETASK                                                                          
                                                                            AND AB.FGRESTRICT=1,
                                                                        ADDEPARTMENT AR,
                                                                        ADUSER US,
                                                                        PRTASKTYPE TA,
                                                                        PRPRIORITY PRI                                                                  
                                                                    WHERE
                                                                        AB.CDTASK=AB.CDBASETASK                                                                      
                                                                        AND ATV.CDTASK=AB.CDTASK                                                                      
                                                                        AND PRTB.CDTASK=AB.CDTASK                                                                      
                                                                        AND AB.FGTASKTYPE=1                                                                      
                                                                        AND (
                                                                            (
                                                                                AB.FGRESTRICT=2                                                                              
                                                                                OR AB.FGRESTRICT IS NULL                                                                              
                                                                                OR AB.FGRESTRICT=0                                                                         
                                                                            )                                                                          
                                                                            OR (
                                                                                PRTASKSECURITY.PR_CDTASK IS NOT NULL                                                                         
                                                                            )                                                                     
                                                                        )                                                                      
                                                                        AND AR.CDDEPARTMENT=AB.CDTASKDEPT                                                                      
                                                                        AND US.CDUSER=AB.CDTASKRESP                                                                      
                                                                        AND TA.CDTASKTYPE=AB.CDTASKTYPE                                                                      
                                                                        AND PRI.CDPRIORITY=AB.CDPRIORITY                                                                      
                                                                        AND AB.FGPHASE <> 99                                                             
                                                                ) PROJ                                                          
                                                            INNER JOIN
                                                                AUAUDIT AU                                                                  
                                                                    ON PROJ.CDBASETASK=AU.CDTASK                                                          
                                                            INNER JOIN
                                                                AUSCOPECONFIG AUCFG                                                                  
                                                                    ON (
                                                                        AUCFG.CDSCOPECONFIG=AU.CDSCOPECONFIG                                                                 
                                                                    )                                                          
                                                            LEFT OUTER JOIN
                                                                AUAUDITTYPE AUTP                                                                  
                                                                    ON AU.CDAUDITTYPE=AUTP.CDAUDITTYPE                                                          
                                                            LEFT OUTER JOIN
                                                                AUAUDITRESULT AURS                                                                  
                                                                    ON (
                                                                        AU.CDAUDITRESULT=AURS.CDAUDITRESULT                                                                 
                                                                    )                                                          
                                                            LEFT OUTER JOIN
                                                                AUAUDRESULTCLASSIF AURC                                                                  
                                                                    ON (
                                                                        AURS.CDAUDITRESULTCRIT=AURC.CDAUDITRESULTCRIT                                                                      
                                                                        AND AURS.CDAUDRESULTCRITREV=AURC.CDAUDRESULTCRITREV                                                                      
                                                                        AND AURS.CDAUDRESULTCLASSIF=AURC.CDAUDRESULTCLASSIF                                                                 
                                                                    )                                                          
                                                            LEFT OUTER JOIN
                                                                AUSCOPECONFIG                                                                  
                                                                    ON (
                                                                        AUSCOPECONFIG.CDSCOPECONFIG=AU.CDSCOPECONFIG                                                                 
                                                                    )                                                          
                                                            LEFT OUTER JOIN
                                                                (
                                                                    SELECT
                                                                        AUCONFORMITYLEVEL.FGSYMBOL,
                                                                        AUSCOPESTRUCT.VLCONFORMITYPERCENT,
                                                                        AUCONFORMITYLEVEL.IDCOLOR,
                                                                        AUSCOPESTRUCT.VLVALUE,
                                                                        AUCONFORMITYLEVEL.IDCONFORMITYLEVEL,
                                                                        AUCONFORMITYLEVEL.NMCONFORMITYLEVEL,
                                                                        AUCONFORMITYLEVEL.IDCONFORMITYLEVEL||' - '||AUCONFORMITYLEVEL.NMCONFORMITYLEVEL AS CONFORMITYLEVEL,
                                                                        AUSCOPESTRUCT.CDSCOPEDEFINITION                                                                  
                                                                    FROM
                                                                        AUSCOPESTRUCT                                                                  
                                                                    LEFT OUTER JOIN
                                                                        AUCONFORMITYLEVEL                                                                          
                                                                            ON (
                                                                                AUSCOPESTRUCT.CDAUDITEVALCRIT=AUCONFORMITYLEVEL.CDAUDITEVALCRIT                                                                              
                                                                                AND AUSCOPESTRUCT.CDAUDITEVALCRITREV=AUCONFORMITYLEVEL.CDAUDITEVALCRITREV                                                                              
                                                                                AND AUSCOPESTRUCT.CDCONFORMITYLEVEL=AUCONFORMITYLEVEL.CDCONFORMITYLEVEL                                                                         
                                                                            )                                                                  
                                                                    WHERE
                                                                        AUSCOPESTRUCT.CDSTRUCTOWNER IS NULL                                                                      
                                                                        AND AUSCOPESTRUCT.CDSTRUCT=AUSCOPESTRUCT.CDSTRUCTROOT                                                                      
                                                                        AND AUSCOPESTRUCT.FGREQUIREMENT <> 1                                                             
                                                                ) SCOPESTRUCTVALUES                                                                  
                                                                    ON (
                                                                        SCOPESTRUCTVALUES.CDSCOPEDEFINITION=AU.CDSCOPEDEFINITION                                                                 
                                                                    )                                                          
                                                            LEFT OUTER JOIN
                                                                ADCOMPANY ADCY1                                                                  
                                                                    ON (
                                                                        AU.CDCUSTOMER=ADCY1.CDCOMPANY                                                                 
                                                                    )                                                          
                                                            LEFT OUTER JOIN
                                                                ADCOMPANY ADCY2                                                                  
                                                                    ON (
                                                                        AU.CDAUDITEESUPPLIER=ADCY2.CDCOMPANY                                                                 
                                                                    )                                                          
                                                            LEFT OUTER JOIN
                                                                ADCOMPANY ADCY3                                                                  
                                                                    ON (
                                                                        AU.CDAUDITORG=ADCY3.CDCOMPANY                                                                 
                                                                    )                                                          
                                                            LEFT OUTER JOIN
                                                                ADDEPARTMENT ADCO1                                                                  
                                                                    ON (
                                                                        AU.CDAUDITEECOMPANIES=ADCO1.CDDEPARTMENT                                                                 
                                                                    )                                                          
                                                            LEFT OUTER JOIN
                                                                ADDEPARTMENT ADCO2                                                                  
                                                                    ON (
                                                                        AU.CDAUDORGCOMPANIES=ADCO2.CDDEPARTMENT                                                                 
                                                                    )                                                          
                                                            LEFT OUTER JOIN
                                                                AUAUDITAUDITOR AUT2                                                                  
                                                                    ON (
                                                                        AU.CDAUDIT=AUT2.CDAUDIT                                                                      
                                                                        AND AUT2.FGTEAMLEADER=1                                                                 
                                                                    )                                                          
                                                            LEFT OUTER JOIN
                                                                AUINTERNALAUDITOR AUINT                                                                  
                                                                    ON (
                                                                        AUT2.CDINTERNALAUDITOR=AUINT.CDINTERNALAUDITOR                                                                 
                                                                    )                                                          
                                                            LEFT OUTER JOIN
                                                                ADUSER ADU2                                                                  
                                                                    ON (
                                                                        AUINT.CDINTAUDITORUSER=ADU2.CDUSER                                                                 
                                                                    )                                                          
                                                            LEFT OUTER JOIN
                                                                AUEXTERNALAUDITOR AUEXT                                                                  
                                                                    ON (
                                                                        AUT2.CDAUDITORG=AUEXT.CDAUDITORG                                                                      
                                                                        AND AUT2.CDEXTERNALAUDITOR=AUEXT.CDEXTERNALAUDITOR                                                                 
                                                                    )                                                          
                                                            LEFT OUTER JOIN
                                                                AUAUDITPURPOSE AUPU                                                                  
                                                                    ON (
                                                                        AU.CDAUDITPURPOSE=AUPU.CDAUDITPURPOSE                                                                 
                                                                    )                                                          
                                                            LEFT OUTER JOIN
                                                                ADTEAM ADTE                                                                  
                                                                    ON(
                                                                        PROJ.CDTEAMRESP=ADTE.CDTEAM                                                                 
                                                                    )                                                          
                                                            LEFT JOIN
                                                                (
                                                                    SELECT
                                                                        AUSCOPESTRUCT.CDSCOPEDEFINITION,
                                                                        (COUNT(GNASSOCACTIONPLAN.CDASSOCACTIONPLAN) + COUNT(GNASSOCWORKFLOW.CDASSOCWORKFLOW) + COUNT(GNASSOCACTION.CDASSOCACTION)) AS QTD_OCCUR                                                                  
                                                                    FROM
                                                                        AUSCOPESTRUCT                                                                  
                                                                    LEFT JOIN
                                                                        GNASSOCACTIONPLAN                                                                          
                                                                            ON (
                                                                                AUSCOPESTRUCT.CDASSOC=GNASSOCACTIONPLAN.CDASSOC                                                                         
                                                                            )                                                                  
                                                                    LEFT JOIN
                                                                        GNASSOCWORKFLOW                                                                          
                                                                            ON (
                                                                                AUSCOPESTRUCT.CDASSOC=GNASSOCWORKFLOW.CDASSOC                                                                         
                                                                            )                                                                  
                                                                    LEFT JOIN
                                                                        GNASSOCACTION                                                                          
                                                                            ON (
                                                                                GNASSOCACTION.CDASSOC=AUSCOPESTRUCT.CDASSOC                                                                         
                                                                            )                                                                  
                                                                    WHERE
                                                                        AUSCOPESTRUCT.FGSELECTED=1                                                                  
                                                                    GROUP BY
                                                                        AUSCOPESTRUCT.CDSCOPEDEFINITION                                                             
                                                                ) AUDIT_OCCURRENCES                                                                  
                                                                    ON AU.CDSCOPEDEFINITION=AUDIT_OCCURRENCES.CDSCOPEDEFINITION                                                          
                                                            INNER JOIN
                                                                PRSITUATIONCHANGE PRSC                                                                  
                                                                    ON (
                                                                        PRSC.CDTASK=PROJ.CDBASETASK                                                                 
                                                                    )                                                          
                                                            WHERE
                                                                PRSC.CDSITUATIONCHANGE=(
                                                                    SELECT
                                                                        MAX(SUB.CDSITUATIONCHANGE)                                                                  
                                                                    FROM
                                                                        PRSITUATIONCHANGE SUB                                                                  
                                                                    WHERE
                                                                        PRSC.CDTASK=SUB.CDTASK                                                             
                                                                )                                                              
                                                                AND (
                                                                    EXISTS (
                                                                        SELECT
                                                                            1                                                                      
                                                                        FROM
                                                                            AUAUDIT AUATTRIB                                                                      
                                                                        WHERE
                                                                            AUATTRIB.CDAUDIT=AU.CDAUDIT                                                                 
                                                                    )                                                                  
                                                                    OR EXISTS(
                                                                        SELECT
                                                                            1                                                                      
                                                                        FROM
                                                                            PRTASK PROJETO                                                                      
                                                                        WHERE
                                                                            PROJETO.CDTASK=PROJ.CDTASK                                                                 
                                                                    )                                                             
                                                                )