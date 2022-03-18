SELECT
        /** Creación:  
		18-03-2022. Andrés Del Río. Muestra los detalles de configuración de las reglas de seguridad definidas en menú DC055 de Softexpert.  
		
		Modificaciones: 
		DD-MM-AAAA. Autor. Descripción. **/         
		SR.IDSECURITYRULE ID_REGLA,
        SR.NMSECURITYRULE NOMBRE_REGLA,
        SR.DTINSERT REGLA_FECHA_REGISTRO,
        SR.DTUPDATE REGLA_FECHA_ACTUALIZACION,
        SR.NMUSERUPD REGLA_USUARIO_ACTUALIZACION,
        SRC.NMSECRULECONDITION REGLA_CONDICION,
        CASE              
            WHEN SRCI.FGTYPE = 1 THEN 'ATRIBUTO'              
            WHEN SRCI.FGTYPE = 2 THEN 'CATEGORIA'          
        END TIPO_CONDICION,
        (SELECT
            NMATTRIBUTE          
        FROM
            ADATTRIBUTE          
        WHERE
            CDATTRIBUTE = SRCI.CDATTRIBUTE) ID_ATRIBUTO_CONDICION,
        (SELECT
            NMLABEL          
        FROM
            ADATTRIBUTE          
        WHERE
            CDATTRIBUTE = SRCI.CDATTRIBUTE) NOMBRE_ATRIBUTO_CONDICION,
        (SELECT
            NMATTRIBUTE          
        FROM
            ADATTRIBVALUE          
        WHERE
            CDATTRIBUTE = SRCI.CDATTRIBUTE              
            AND CDVALUE = SRCI.CDATTRIBVALUE)  VALOR_ATRIBUTO_CONDICION,
        CASE              
            WHEN SRCP.FGACCESSTYPE = 1 THEN 'GRUPO'                 
            WHEN SRCP.FGACCESSTYPE = 2 THEN 'ÁREA'                 
            WHEN SRCP.FGACCESSTYPE = 3 THEN 'ÁREA/FUNCIÓN'                 
            WHEN SRCP.FGACCESSTYPE = 4 THEN 'FUNCIÓN'                 
            WHEN SRCP.FGACCESSTYPE = 5 THEN 'USUARIO'                 
            WHEN SRCP.FGACCESSTYPE = 6 THEN 'TODOS'                 
            WHEN SRCP.FGACCESSTYPE = 7 THEN 'USUARIO DE INCLUSIÓN'                 
            WHEN SRCP.FGACCESSTYPE = 8 THEN 'ÁREA/FUNCIÓN USUARIO DE INCLUSIÓN'                 
            WHEN SRCP.FGACCESSTYPE = 9 THEN 'FUNCIÓN USUARIO DE INCLUSIÓN'                 
            WHEN SRCP.FGACCESSTYPE = 10 THEN 'ÁREA USUARIO DE INCLUSIÓN'            
        END TIPO_CONTROL_ACCESO_CONDICION,
        CASE              
            WHEN SRCP.FGACCESSTYPE = 1 THEN (SELECT
                IDTEAM || '-' || NMTEAM              
            FROM
                ADTEAM              
            WHERE
                CDTEAM = SRCP.CDTEAM)                 
            WHEN SRCP.FGACCESSTYPE = 2 THEN (SELECT
                IDDEPARTMENT || '-' || NMDEPARTMENT              
            FROM
                ADDEPARTMENT              
            WHERE
                CDDEPARTMENT = SRCP.CDDEPARTMENT)                 
            WHEN SRCP.FGACCESSTYPE = 3 THEN (SELECT
                IDDEPARTMENT || '-' || NMDEPARTMENT              
            FROM
                ADDEPARTMENT              
            WHERE
                CDDEPARTMENT = SRCP.CDDEPARTMENT) || ' / ' || (SELECT
                IDPOSITION || '-' || NMPOSITION              
            FROM
                ADPOSITION              
            WHERE
                CDPOSITION = SRCP.CDPOSITION)                 
            WHEN SRCP.FGACCESSTYPE = 4 THEN (SELECT
                IDPOSITION || '-' || NMPOSITION              
            FROM
                ADPOSITION              
            WHERE
                CDPOSITION = SRCP.CDPOSITION)                 
            WHEN SRCP.FGACCESSTYPE = 5 THEN (SELECT
                IDUSER || '-' || NMUSER              
            FROM
                ADUSER              
            WHERE
                CDUSER = SRCP.CDUSER)                 
            WHEN SRCP.FGACCESSTYPE = 6 THEN 'TODOS'                 
            WHEN SRCP.FGACCESSTYPE = 7 THEN 'USUARIO DE INCLUSIÓN'                 
            WHEN SRCP.FGACCESSTYPE = 8 THEN 'ÁREA/FUNCIÓN USUARIO DE INCLUSIÓN'                 
            WHEN SRCP.FGACCESSTYPE = 9 THEN 'FUNCIÓN USUARIO DE INCLUSIÓN'                 
            WHEN SRCP.FGACCESSTYPE = 10 THEN 'ÁREA USUARIO DE INCLUSIÓN'            
        END INSTANCIA_CONTROL_ACCESO_CONDICION,
        CASE              
            WHEN SRCP.FGPERMISSION = 1 THEN 'PERMITIR'              
            WHEN SRCP.FGPERMISSION = 2 THEN 'DENEGAR'          
        END TIPO_PERMISO_CONDICION,
        CASE              
            WHEN SRCP.FGACCESSADD = 1 THEN 'SI'              
            ELSE 'NO'          
        END PERMISO_INCLUSION,
        CASE              
            WHEN SRCP.FGACCESSEDIT = 1 THEN 'SI'              
            ELSE 'NO'          
        END PERMISO_MODIFICACION,
        CASE              
            WHEN SRCP.FGACCESSDELETE = 1 THEN 'SI'              
            ELSE 'NO'          
        END PERMISO_EXCLUSION,
        CASE              
            WHEN SRCP.FGACCESSKNOW = 1 THEN 'SI'              
            ELSE 'NO'          
        END PERMISO_CONOCIMIENTO,
        CASE              
            WHEN SRCP.FGACCESSTRAIN = 1 THEN 'SI'              
            ELSE 'NO'          
        END PERMISO_CAPACITACION,
        CASE              
            WHEN SRCP.FGACCESSVIEW = 1 THEN 'SI'              
            ELSE 'NO'          
        END PERMISO_VISUALIZACION,
        CASE              
            WHEN SRCP.FGACCESSPRINT = 1 THEN 'SI'              
            ELSE 'NO'          
        END PERMISO_IMPRESION,
        CASE              
            WHEN SRCP.FGACCESSPHYSFILE = 1 THEN 'SI'              
            ELSE 'NO'          
        END PERMISO_ARCHIVO,
        CASE              
            WHEN SRCP.FGACCESSREVISION = 1 THEN 'SI'              
            ELSE 'NO'          
        END PERMISO_REVISION,
        CASE              
            WHEN SRCP.FGACCESSCOPY = 1 THEN 'SI'              
            ELSE 'NO'          
        END PERMISO_DIST_COPIAS,
        CASE              
            WHEN SRCP.FGACCESSREGTRAIN = 1 THEN 'SI'              
            ELSE 'NO'          
        END PERMISO_REGISTRO_CAPACITACION,
        CASE              
            WHEN SRCP.FGACCESSCANCEL = 1 THEN 'SI'              
            ELSE 'NO'          
        END PERMISO_CANCELACION,
        CASE              
            WHEN SRCP.FGACCESSSAVE = 1 THEN 'SI'              
            ELSE 'NO'          
        END PERMISO_GUARDAR_LOCALMENTE,
        CASE              
            WHEN SRCP.FGACCESSSIGN = 1 THEN 'SI'              
            ELSE 'NO'          
        END PERMISO_FIRMAR,
        CASE              
            WHEN SRCP.FGACCESSNOTIFY = 1 THEN 'SI'              
            ELSE 'NO'          
        END PERMISO_NOTIFICACION,
        CASE              
            WHEN SRCP.FGACCESSEDITKNOW = 1 THEN 'SI'              
            ELSE 'NO'          
        END PERMISO_EVALUAR_APLICABILIDAD,
        CASE              
            WHEN SRCP.FGACCESSADDCOMMENT = 1 THEN 'SI'              
            ELSE 'NO'          
        END PERMISO_INSERTAR_COMENTARIO,
        CASE              
            WHEN SRCP.FGADDLOWERLEVEL = 1 THEN 'SI'              
            ELSE 'NO'          
        END INCLUIR_NIVELES_INFERIORES,
        1 AS CANTIDAD            
    FROM
        DCSECURITYRULE SR           
    LEFT JOIN
        DCSECRULECONDITION SRC                           
            ON SRC.CDSECURITYRULE = SR.CDSECURITYRULE           
    LEFT JOIN
        DCSECRULECONDITEM SRCI                           
            ON SRCI.CDCONDITION = SRC.CDCONDITION           
    LEFT JOIN
        DCSECRULECONDPERM SRCP                           
            ON SRCP.CDCONDITION = SRCI.CDCONDITION       