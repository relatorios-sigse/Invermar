SELECT
/** 
Creación:  
17-06-2022. Jonathan Cofré/Andrés Del Río. Lista los registros de combustible de Diesel, Gasolina y Gas, informados a través del
proceso PRO-APO1 - Inicio mensual de registro

Versión: 2.1.8.59
Ambiente: https://invermar.softexpert.com/
Panel de análisis: REPOCOMB - Reporte Combustibles
        
Modificaciones: 
dd-mm-aaaa. Autor. Descripción.    
**/
        1 CANTIDAD,
        WFP.IDPROCESS IDENTIFICADOR,
        WFP.NMPROCESS TITULO,
        WFP.NMUSERSTART INICIADOR,
        WFP.DTSTART FECHA_INICIOWORFLOW,
        CASE WFP.FGSTATUS 
            WHEN 1 THEN '#{103131}' 
            WHEN 2 THEN '#{107788}' 
            WHEN 3 THEN '#{104230}' 
            WHEN 4 THEN '#{100667}' 
            WHEN 5 THEN '#{200712}' 
        END AS IDSITUATION,
        COMB.NMCENTRO COMB_CENTRO,
        COMB.FECHAREG COMB_FECHA,
        COMB.PRODUCTO COMB_PRODUCTO,
        COMB.STOCINIC COMB_STOCKINICIAL,
        COMB.CONSTOTA COMB_CONSUMOTOTAL,
        COMB.INGRCOMB COMB_INGRESO,
        COMB.EGRECOMB COMB_EGRESO,
        COMB.STOCFINA COMB_STOCKFINAL,
        GRIDACTI.TIPOACTI COMB_TIPOACTIVO,
        GRIDACTI.MARCACTI COMB_MARCA,
        GRIDACTI.POTEACTI COMB_POTENCIA,
        GRIDACTI.CONSPROM COMB_CONSUMOPROMEDIO,
        GRIDACTI.HORACONS COMB_HORASCONSUMO,
        GRIDACTI.CONSTOTA COMB_SUBTOTAL    
    FROM
        WFPROCESS WFP                                                                     
    JOIN
        GNASSOCFORMREG REG                                                                                                                                     
            ON WFP.CDASSOCREG = REG.CDASSOC                                                                     
    JOIN
        DYNABA FORMCOMB                                                                                                                                     
            ON REG.OIDENTITYREG=FORMCOMB.OID     
    LEFT JOIN
        DYNregiconscomb COMB   
            ON (COMB.OIDABCS7EXBRNPLQD5=FORMCOMB.OID  OR
                COMB.OIDABCJ1EC9BSPERVY=FORMCOMB.OID  OR
                COMB.OIDABC3UOA5TUVFE6N=FORMCOMB.OID)
    LEFT JOIN
        DYNgridregicomb GRIDACTI   
            ON GRIDACTI.OIDABCUX63XSHMJ9M1=COMB.OID      
    WHERE
        WFP.CDPROCESSMODEL=1          
        AND WFP.FGSTATUS<=5