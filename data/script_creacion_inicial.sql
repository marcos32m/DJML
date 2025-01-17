--============================================================	
--			GESTION DE DATOS 2C 2015 - TP AEROLINEA FRBA						
-- ===========================================================

USE [GD2C2015]
GO

--============================================================	
--		CREACION DEL ESQUEMA CON EL NOMBRE DEL GRUPO--
-- ===========================================================

CREATE SCHEMA [DJML] AUTHORIZATION [GD]
GO

--============================================================
--                EMPEZAMOS A CREAR LAS TABLAS
-- =========================================================== 
PRINT 'CREANDO SPs...'
GO

CREATE PROCEDURE DJML.CREAR_ROLES
AS
BEGIN

--============================================================
						--TABLA ROLES
--============================================================

	CREATE TABLE DJML.ROLES(
		ROL_ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		ROL_DESCRIPCION VARCHAR(40) NOT NULL,
		ROL_ACTIVO BIT NOT NULL
	)
	
	PRINT 'SE CREO LA TABLA ROLES CORRECTAMENTE'
	
	---MIGRACION DATOS TABLA ROLES---
	
	INSERT INTO DJML.ROLES VALUES ('ADMINISTRADOR',1);
	INSERT INTO DJML.ROLES VALUES ('CLIENTE',1);
	
	PRINT 'SE MIGRO LA TABLA ROLES CORRECTAMENTE'
	
END
GO

CREATE PROCEDURE DJML.CREAR_FUNCIONALIDADES
AS 
BEGIN

--============================================================
				--TABLA FUNCIONALIDADES
--============================================================

	CREATE TABLE DJML.FUNCIONALIDAD(
		FUNC_ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		DESCRIPCION VARCHAR(60) UNIQUE NOT NULL	
	)
	
	PRINT 'SE CREO LA TABLA FUNCIONALIDAD CORRECTAMENTE'
	
	---MIGRACION DATOS TABLA FUNIONALIDAD---


	INSERT INTO DJML.FUNCIONALIDAD VALUES ('ABM ROL')
	INSERT INTO DJML.FUNCIONALIDAD VALUES ('ABM CIUDAD')
	INSERT INTO DJML.FUNCIONALIDAD VALUES ('ABM RUTA AEREA')
	INSERT INTO DJML.FUNCIONALIDAD VALUES ('ABM AERONAVE')
	INSERT INTO DJML.FUNCIONALIDAD VALUES ('LOGIN Y SEGURIDAD')
	INSERT INTO DJML.FUNCIONALIDAD VALUES ('REGISTRO USUARIO')
	INSERT INTO DJML.FUNCIONALIDAD VALUES ('GENERAR VIAJE')
	INSERT INTO DJML.FUNCIONALIDAD VALUES ('REGISTRO DE LLEGADA A DESTINO')
	INSERT INTO DJML.FUNCIONALIDAD VALUES ('COMPRA PASAJE/ENCOMIENDA')
	INSERT INTO DJML.FUNCIONALIDAD VALUES ('DEVOLUCION/CANCELACION PASAJE/ENCOMIENDA')
	INSERT INTO DJML.FUNCIONALIDAD VALUES ('CONSULTA MILLAS PASAJERO')
	INSERT INTO DJML.FUNCIONALIDAD VALUES ('CANJE MILLAS')
	INSERT INTO DJML.FUNCIONALIDAD VALUES ('LISTADO ESTADISTICO')
	
	PRINT 'SE MIGRO LA TABLA FUNCIONALIDAD CORRECTAMENTE'
	
	
--============================================================
					--TABLA ROL_FUNCIONALIDAD
--============================================================

	CREATE TABLE DJML.ROL_FUNCIONALIDAD(
		RXF_ROL_ID INT NOT NULL FOREIGN KEY REFERENCES DJML.ROLES(ROL_ID),
		RXF_FUNC_ID INT NOT NULL FOREIGN KEY REFERENCES DJML.FUNCIONALIDAD(FUNC_ID),
		RXF_HABILITADO BIT
		)		
		PRINT 'SE CREO LA TABLA ROL_FUNCIONALIDAD CORRECTAMENTE'
		
		
		
		---MIGRACION DATOS TABLA ROL_FUNCIONALIDAD---

		---ADMIN
		insert into DJML.ROL_FUNCIONALIDAD (RXF_ROL_ID, RXF_FUNC_ID,RXF_HABILITADO)
		select distinct r.ROL_ID , f.FUNC_ID, 1
		from DJML.ROLES r
		cross join DJML.FUNCIONALIDAD f
		where r.ROL_DESCRIPCION = 'ADMINISTRADOR'

		--CLIENTE
		
		insert into DJML.ROL_FUNCIONALIDAD (RXF_ROL_ID, RXF_FUNC_ID,RXF_HABILITADO)
		select distinct r.ROL_ID , f.FUNC_ID, 1
		from DJML.ROLES r
		cross join DJML.FUNCIONALIDAD f
		where r.ROL_DESCRIPCION = 'CLIENTE'
		and f.DESCRIPCION in ('COMPRA PASAJE/ENCOMIENDA','CONSULTA MILLAS PASAJERO','CANJE MILLAS')
		
		PRINT 'SE MIGRO LA TABLA ROL_FUNCIONALIDAD CORRECTAMENTE'
		
		
END
GO	

CREATE PROCEDURE DJML.CREAR_USUARIOS
AS 
BEGIN

--============================================================
						--TABLA USUARIOS
--============================================================


	CREATE TABLE DJML.USUARIOS (
		USUA_ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		USUA_USERNAME INT NOT NULL UNIQUE,
		USUA_PASSWORD NVARCHAR(256),
		USUA_HABILITADO BIT NOT NULL,
		USUA_LOGIN_FALLIDOS INT NOT NULL,
		USUA_ROL_ID INT NOT NULL FOREIGN KEY REFERENCES DJML.ROLES(ROL_ID)
		)

	PRINT 'SE CREO LA TABLA USUARIOS CORRECTAMENTE'
	
	---MIGRACION DATOS TABLA USUARIOS---

	INSERT INTO DJML.USUARIOS VALUES (10000000,'E6-B8-70-50-BF-CB-81-43-FC-B8-DB-01-70-A4-DC-9E-D0-0D-90-4D-DD-3E-2A-4A-D1-B1-E8-DC-0F-DC-9B-E7',1,0,1)
	INSERT INTO DJML.USUARIOS VALUES (20000000,'E6-B8-70-50-BF-CB-81-43-FC-B8-DB-01-70-A4-DC-9E-D0-0D-90-4D-DD-3E-2A-4A-D1-B1-E8-DC-0F-DC-9B-E7',1,0,1)
	INSERT INTO DJML.USUARIOS VALUES (30000000,'E6-B8-70-50-BF-CB-81-43-FC-B8-DB-01-70-A4-DC-9E-D0-0D-90-4D-DD-3E-2A-4A-D1-B1-E8-DC-0F-DC-9B-E7',1,0,1)
	INSERT INTO DJML.USUARIOS VALUES (40000000,'E6-B8-70-50-BF-CB-81-43-FC-B8-DB-01-70-A4-DC-9E-D0-0D-90-4D-DD-3E-2A-4A-D1-B1-E8-DC-0F-DC-9B-E7',1,0,1)
	
	PRINT 'SE MIGRO LA TABLA USUARIOS CORRECTAMENTE'
	
END
GO


CREATE PROCEDURE DJML.CREAR_CIUDADES
AS
BEGIN

--============================================================
						--TABLA CIUDAD
--============================================================

	CREATE TABLE DJML.CIUDADES(
	CIUD_ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	CIUD_DETALLE NVARCHAR(255)
	)
	
	PRINT 'SE CREO LA TABLA CIUDAD CORRECTAMENTE'
	
	---MIGRACION DATOS TABLA CIUDADES---
	
	insert into djml.CIUDADES(CIUD_DETALLE)
	select distinct Ruta_Ciudad_Destino from gd_esquema.Maestra
	union
	select distinct ruta_ciudad_origen from gd_esquema.Maestra
	
	PRINT 'SE MIGRO LA TABLA CIUDAD CORRECTAMENTE'
		
END 
GO




CREATE PROCEDURE DJML.CREAR_SERVICIOS
AS
BEGIN

--============================================================
						--TABLA SERVICIO
--============================================================

	CREATE TABLE DJML.SERVICIOS(
	SERV_ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	SERV_DESCRIPCION NVARCHAR(255) NOT NULL,
	SERV_PORCENTAJE NUMERIC(18,2) NOT NULL
	)
	PRINT 'SE CREO LA TABLA SERVICIO CORRECTAMENTE'
	
	---MIGRACION DATOS TABLA SERVICIOS---
	
	insert into djml.SERVICIOS(SERV_DESCRIPCION, SERV_PORCENTAJE)
	select Tipo_Servicio,convert(numeric(18,2),MAX(((Pasaje_Precio * 100 / Ruta_Precio_BasePasaje) - 100)/100))
	from gd_esquema.Maestra m
	where Pasaje_Precio <> 0
	group by Tipo_Servicio
	order by 2
	
	PRINT 'SE MIGRO LA TABLA SERVICIO CORRECTAMENTE'
	
END
GO

CREATE PROCEDURE DJML.CREAR_RUTAS
AS
BEGIN

--============================================================
						--TABLAS
--============================================================

	CREATE TABLE DJML.TRAMOS(
	TRAMO_ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	TRAMO_CIUDAD_ORIGEN INT NOT NULL FOREIGN KEY REFERENCES DJML.CIUDADES(CIUD_ID),
	TRAMO_CIUDAD_DESTINO INT NOT NULL FOREIGN KEY REFERENCES DJML.CIUDADES(CIUD_ID)
	)
	
	PRINT 'SE CREO LA TABLA TRAMOS CORRECTAMENTE'
	
	CREATE TABLE DJML.RUTAS(
	RUTA_CODIGO INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	RUTA_TRAMO INT NOT NULL FOREIGN KEY REFERENCES DJML.TRAMOS(TRAMO_ID),
	RUTA_SERVICIO INT NOT NULL FOREIGN KEY REFERENCES DJML.SERVICIOS(SERV_ID),
	RUTA_PRECIO_BASE_PASAJE NUMERIC(18,2) NOT NULL,
	RUTA_PRECIO_BASE_KILO NUMERIC(18,2)NOT NULL,
	RUTA_IS_ACTIVE BIT NOT NULL
	)
	
	PRINT 'SE CREO LA TABLA RUTAS CORRECTAMENTE'
	
	CREATE TABLE DJML.RUTAS_LEGACY(
	RL_RUTA INT NOT NULL FOREIGN KEY REFERENCES DJML.RUTAS(RUTA_CODIGO),
	RL_CODIGO NUMERIC(18,0) NOT NULL
	)
	
	PRINT 'SE CREO LA TABLA RUTAS_LEGACY CORRECTAMENTE'
	
--============================================================
						--MIGRACIONES
--============================================================
	
	INSERT INTO DJML.TRAMOS(TRAMO_CIUDAD_ORIGEN, TRAMO_CIUDAD_DESTINO)
	SELECT DISTINCT c1.CIUD_ID, c2.CIUD_ID
	FROM gd_esquema.Maestra
	JOIN DJML.CIUDADES c1 ON Ruta_Ciudad_Origen = c1.CIUD_DETALLE
	JOIN DJML.CIUDADES c2 ON Ruta_Ciudad_Destino = c2.CIUD_DETALLE
	ORDER BY 1
	
	PRINT 'SE MIGRO LA TABLA TRAMOS CORRECTAMENTE'
	
	INSERT INTO DJML.RUTAS(RUTA_TRAMO, RUTA_SERVICIO, RUTA_PRECIO_BASE_PASAJE, RUTA_PRECIO_BASE_KILO, RUTA_IS_ACTIVE)
	SELECT DISTINCT TRAMO_ID
				,SERV_ID
				,(select TOP 1 m3.Ruta_Precio_BasePasaje from gd_esquema.Maestra m3 where m3.Ruta_Codigo = m1.Ruta_Codigo and m3.Ruta_Precio_BaseKG = 0.00)
				,(select TOP 1 m2.Ruta_Precio_BaseKG from gd_esquema.Maestra m2 where m2.Ruta_Codigo = m1.Ruta_Codigo and m2.Ruta_Precio_BasePasaje = 0.00)
				, 1
	FROM gd_esquema.Maestra m1
	JOIN DJML.TRAMOS t ON (SELECT c1.CIUD_ID FROM DJML.CIUDADES c1 WHERE Ruta_Ciudad_Origen = c1.CIUD_DETALLE) = t.TRAMO_CIUDAD_ORIGEN
					 AND (SELECT c2.CIUD_ID FROM DJML.CIUDADES c2 WHERE Ruta_Ciudad_Destino = c2.CIUD_DETALLE) = t.TRAMO_CIUDAD_DESTINO
	JOIN DJML.SERVICIOS S ON s.SERV_DESCRIPCION = m1.Tipo_Servicio
	ORDER BY 1
	
	PRINT 'SE MIGRO LA TABLA RUTAS CORRECTAMENTE'
	
	INSERT INTO DJML.RUTAS_LEGACY(RL_RUTA, RL_CODIGO)
	SELECT DISTINCT r.RUTA_CODIGO, m.Ruta_Codigo
	FROM gd_esquema.Maestra m
	JOIN DJML.TRAMOS t ON (SELECT c1.CIUD_ID FROM DJML.CIUDADES c1 WHERE Ruta_Ciudad_Origen = c1.CIUD_DETALLE) = t.TRAMO_CIUDAD_ORIGEN
					 AND (SELECT c2.CIUD_ID FROM DJML.CIUDADES c2 WHERE Ruta_Ciudad_Destino = c2.CIUD_DETALLE) = t.TRAMO_CIUDAD_DESTINO
	JOIN DJML.SERVICIOS s ON s.SERV_DESCRIPCION = Tipo_Servicio
	JOIN DJML.RUTAS r ON r.RUTA_TRAMO = t.TRAMO_ID AND r.RUTA_SERVICIO = s.SERV_ID
	ORDER BY 1
	
	PRINT 'SE MIGRO LA TABLA RUTAS_LEGACY CORRECTAMENTE'

END
GO		


CREATE PROCEDURE DJML.CREAR_AERONAVES
AS
BEGIN
	
	
--============================================================
					--TABLA TIPO_BUTACA
--============================================================

	CREATE TABLE DJML.TIPO_BUTACA(
	TIPO_BUTACA_ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	DESCRIPCION NVARCHAR(15) NOT NULL,
	) 
	
	PRINT 'SE CREO LA TABLA TIPO_BUTACA CORRECTAMENTE'
	
	---MIGRACION DATOS TABLA TIPO_BUTACA---
	
	INSERT INTO DJML.TIPO_BUTACA(DESCRIPCION)
	SELECT DISTINCT BUTACA_TIPO FROM gd_esquema.Maestra 
	WHERE Butaca_Nro <> 0
	
	
	
--============================================================
							--TABLA FABRICANTES
--============================================================

	CREATE TABLE DJML.FABRICANTES(
	ID_FABRICANTE INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	DESCRIPCION NVARCHAR(50) NOT NULL
	)
	
	PRINT 'SE CREO LA TABLA FABRICANTES CORRECTAMENTE'
	
	---MIGRACION DATOS TABLA FABRICANTES---
	
	
	insert into djml.FABRICANTES(DESCRIPCION)
	SELECT distinct Aeronave_Fabricante from gd_esquema.Maestra
	where (Paquete_Codigo = 0 and Pasaje_Codigo <> 0) or (Pasaje_Codigo = 0 and Paquete_Codigo <> 0) 
	


--============================================================
						--TABLA AERONAVE
--============================================================

	CREATE TABLE DJML.AERONAVES(
	AERO_MATRICULA NVARCHAR(7) NOT NULL PRIMARY KEY,
	AERO_MODELO NVARCHAR(50) NOT NULL,
	AERO_FABRICANTE INT NOT NULL FOREIGN KEY REFERENCES DJML.FABRICANTES(ID_FABRICANTE), -- agregue la fk de fabricantes (nueva tabla maestra)
	AERO_KILOS_DISPONIBLES INT NOT NULL,
	AERO_SERVICIO_ID INT NOT NULL FOREIGN KEY REFERENCES DJML.SERVICIOS(SERV_ID),
	AERO_BAJA_FUERA_SERVICIO BIT NOT NULL,
	AERO_BAJA_VIDA_UTIL BIT NOT NULL,
	AERO_FECHA_BAJA_DEF DATETIME,
	AERO_FECHA_ALTA DATETIME
	)
	
	PRINT 'SE CREO LA TABLA AERONAVE CORRECTAMENTE'
	
	---MIGRACION DATOS TABLA AERONAVES---
	

	insert into djml.AERONAVES(AERO_MATRICULA, AERO_MODELO, AERO_FABRICANTE, AERO_KILOS_DISPONIBLES, AERO_SERVICIO_ID, AERO_BAJA_FUERA_SERVICIO, AERO_BAJA_VIDA_UTIL, AERO_FECHA_BAJA_DEF, AERO_FECHA_ALTA)
	SELECT distinct AERONAVE_matricula, M.Aeronave_Modelo,F.ID_FABRICANTE ,Aeronave_KG_Disponibles, s.SERV_ID, 0,0, NULL,NULL
	FROM gd_esquema.Maestra m 
	join djml.SERVICIOS s on  m.Tipo_Servicio = s.SERV_DESCRIPCION
	join djml.FABRICANTES f on f.DESCRIPCION = m.Aeronave_Fabricante
	ORDER BY 1 
	
--==========================================================================
						--TABLA PERIODOS DE FUERA DE SERVICIO AERONAVES
--==========================================================================

	CREATE TABLE DJML.PERIODOS_DE_INACTIVIDAD (
    PERI_ID INT IDENTITY(1,1) PRIMARY KEY,
    PERI_FECHA_INICIO DATETIME NOT NULL,
    PERI_FECHA_FIN DATETIME NOT NULL
)

--========================================================================
						--TABLA AERONAVES X PERIODOS
--========================================================================

CREATE TABLE DJML.AERONAVES_POR_PERIODOS (
    AXP_MATRI_AERONAVE NVARCHAR(7) NOT NULL FOREIGN KEY REFERENCES DJML.AERONAVES(AERO_MATRICULA),
    AXP_ID_PERIODO  INT NOT NULL FOREIGN KEY REFERENCES DJML.PERIODOS_DE_INACTIVIDAD(PERI_ID),
    PRIMARY KEY(AXP_MATRI_AERONAVE,AXP_ID_PERIODO)
)
	
--============================================================
							--TABLA BUTACA
--============================================================

	CREATE TABLE DJML.BUTACAS(
	BUTA_ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	BUTA_NRO NUMERIC(4,0) NOT NULL,
	BUTA_TIPO_ID INT NOT NULL FOREIGN KEY REFERENCES DJML.TIPO_BUTACA(TIPO_BUTACA_ID),
	BUTA_PISO NUMERIC(1,0) NOT NULL
	)
	
	PRINT 'SE CREO LA TABLA BUTACA CORRECTAMENTE'
	
	---MIGRACION DATOS TABLA BUTACAS---
	
	insert into djml.BUTACAS(BUTA_NRO, BUTA_TIPO_ID, BUTA_PISO)
	SELECT distinct Butaca_Nro, n.TIPO_BUTACA_ID, Butaca_Piso
	FROM gd_esquema.Maestra m
	JOIN djml.TIPO_BUTACA n on  m.Butaca_Tipo = n.DESCRIPCION
	order by 1
	
	
--============================================================
							--TABLA BUTACA_AERO
--============================================================

	CREATE TABLE DJML.BUTACA_AERO(
	BXA_ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	BXA_BUTA_ID INT NOT NULL FOREIGN KEY REFERENCES DJML.BUTACAS(BUTA_ID),
	BXA_AERO_MATRICULA NVARCHAR(7) NOT NULL FOREIGN KEY REFERENCES DJML.AERONAVES(AERO_MATRICULA),
	BXA_ESTADO BIT NOT NULL
	)
	
	PRINT 'SE CREO LA TABLA BUTACA_AERO CORRECTAMENTE'
	
	---MIGRACION DATOS TABLA BUTACA_AERO---
	
	insert into djml.BUTACA_AERO(BXA_BUTA_ID,BXA_AERO_MATRICULA,BXA_ESTADO)
	select distinct b.BUTA_ID, a.aero_matricula, 1 from gd_esquema.Maestra m
	join djml.AERONAVES a on m.Aeronave_Matricula = a.AERO_MATRICULA
	join djml.TIPO_BUTACA tb on m.Butaca_Tipo = tb.DESCRIPCION 
	join djml.BUTACAS b on tb.TIPO_BUTACA_ID = b.BUTA_TIPO_ID 
	and b.BUTA_NRO = m.Butaca_Nro 
	and b.BUTA_PISO = m.Butaca_Piso 
	where m.Pasaje_Codigo <> 0
	or m.Paquete_Codigo <> 0
	

	
END
GO

CREATE PROCEDURE DJML.CREAR_VIAJES
AS
BEGIN

--============================================================
						--TABLA VIAJE
--============================================================


	CREATE TABLE DJML.VIAJES(
	VIAJE_ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	VIAJE_FECHA_SALIDA smalldatetime  NOT NULL,
	VIAJE_FECHA_LLEGADA smalldatetime  NULL,
	VIAJE_FECHA_LLEGADA_ESTIMADA  smalldatetime  NOT NULL,
	VIAJE_AERO_ID NVARCHAR(7) NOT NULL FOREIGN KEY REFERENCES DJML.AERONAVES(AERO_MATRICULA),
	VIAJE_RUTA_ID INT NOT NULL FOREIGN KEY REFERENCES DJML.RUTAS(RUTA_CODIGO)
	)
	PRINT 'SE CREO LA TABLA VIAJES CORRECTAMENTE'

	---MIGRACION DATOS TABLA VIAJES---
	
	insert into djml.VIAJES(VIAJE_FECHA_SALIDA, VIAJE_FECHA_LLEGADA, VIAJE_FECHA_LLEGADA_ESTIMADA, VIAJE_AERO_ID, VIAJE_RUTA_ID)
	select distinct m.FechaSalida, m.FechaLLegada, m.Fecha_LLegada_Estimada, a.aero_matricula, r.RUTA_CODIGO
	from gd_esquema.Maestra m
	join DJML.AERONAVES a on a.AERO_MATRICULA = m.aeronave_matricula
	JOIN DJML.SERVICIOS S ON s.SERV_DESCRIPCION = m.Tipo_Servicio
	JOIN DJML.TRAMOS t ON (SELECT c1.CIUD_ID FROM DJML.CIUDADES c1 WHERE Ruta_Ciudad_Origen = c1.CIUD_DETALLE) = t.TRAMO_CIUDAD_ORIGEN
						 AND (SELECT c2.CIUD_ID FROM DJML.CIUDADES c2 WHERE Ruta_Ciudad_Destino = c2.CIUD_DETALLE) = t.TRAMO_CIUDAD_DESTINO
	JOIN DJML.RUTAS r ON r.RUTA_TRAMO = t.TRAMO_ID AND r.RUTA_SERVICIO = s.SERV_ID
	where (m.Paquete_Codigo <> 0 or m.Pasaje_Codigo <> 0)
	and m.FechaSalida is not null
	and m.FechaLLegada is not null
	
	
	
--============================================================
					--TABLA REGISTRO_DESTINO
--============================================================

	CREATE TABLE DJML.REGISTRO_DESTINO(
	RD_ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	RD_VIAJE_ID INT NOT NULL FOREIGN KEY REFERENCES DJML.VIAJES(VIAJE_ID),
	RD_AERO_ID NVARCHAR(7) NOT NULL FOREIGN KEY REFERENCES DJML.AERONAVES(AERO_MATRICULA),
	RD_FECHA_LLEGADA smalldatetime  NOT NULL ,
	RD_CIUDAD_ORIGEN_ID INT NOT NULL FOREIGN KEY REFERENCES DJML.CIUDADES(CIUD_ID),     
	RD_CIUDAD_DESTINO_ID INT NOT NULL FOREIGN KEY REFERENCES DJML.CIUDADES(CIUD_ID)
	)		
	--LAS CIUDADES ORIGEN/DESTINO REPRESENTAN A LOS AEROPUERTOS PORQUE NO HAY INFORMACION DE ELLOS.
	PRINT 'SE CREO LA TABLA REGISTRO_DESTINO CORRECTAMENTE'

	---MIRAGRACION DATOS TABLA REGISTRO_DESTINO---
	--HACER: NO SE MIGRA!!
	
	
	
	CREATE TABLE djml.BUTACA_AERO_VIAJE(
	BAV_ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	BAV_BUTA_ID INT NOT NULL FOREIGN KEY REFERENCES DJML.BUTACAS(BUTA_ID),
	BAV_VIAJE_ID INT NOT NULL FOREIGN KEY REFERENCES DJML.VIAJES(VIAJE_ID),
	BAV_ESTADO BIT NOT NULL
	)
	-- BAV_ESTADO: 1 => Ocupado; 0 => Libre
	
	PRINT 'SE CREO LA TABLA BUTACA_AERO_VIAJE CORRECTAMENTE'	
	
	insert into djml.BUTACA_AERO_VIAJE(BAV_BUTA_ID,BAV_VIAJE_ID,BAV_ESTADO)
	select 
		(
			select BXA_ID
			from DJML.BUTACA_AERO
			join DJML.BUTACAS on BXA_BUTA_ID = BUTA_ID
			join DJML.TIPO_BUTACA on BUTA_TIPO_ID = TIPO_BUTACA_ID
			where BXA_AERO_MATRICULA = Aeronave_Matricula 
			and BUTA_NRO = Butaca_Nro
			and BUTA_PISO = Butaca_Piso
			and TIPO_BUTACA.DESCRIPCION = Butaca_Tipo
		),
		(
			select VIAJE_ID
			from DJML.VIAJES
			join DJML.RUTAS on VIAJE_RUTA_ID = RUTA_CODIGO
			join DJML.TRAMOS on RUTA_TRAMO = TRAMO_ID
			where VIAJE_AERO_ID = Aeronave_Matricula
			and VIAJE_FECHA_SALIDA = FechaSalida
			and VIAJE_FECHA_LLEGADA = FechaLLegada
			and TRAMO_CIUDAD_ORIGEN = (select CIUD_ID from DJML.CIUDADES where CIUD_DETALLE = Ruta_Ciudad_Origen)
			and TRAMO_CIUDAD_DESTINO = (select CIUD_ID from DJML.CIUDADES where CIUD_DETALLE = Ruta_Ciudad_Destino)
			
		), 1
	from gd_esquema.Maestra
	where Pasaje_Codigo <> 0
	
END 
GO


CREATE PROCEDURE DJML.CREAR_CLIENTES
AS
BEGIN

--============================================================
						--TABLA CLIENTE
--============================================================
	CREATE TABLE DJML.TIPO_DOCUMENTO(
	ID_TIPO_DOC INT IDENTITY(1,1) PRIMARY KEY,
	DESCRIPCION varchar(15) not null
	)
	
	PRINT 'SE CREO LA TABLA REGISTRO_DESTINO CORRECTAMENTE'
	
	--MIGRACION TABLA TIPO_DOCUMENTO

	INSERT INTO DJML.TIPO_DOCUMENTO (DESCRIPCION) VALUES ('DNI')
	INSERT INTO DJML.TIPO_DOCUMENTO (DESCRIPCION) VALUES ('LC')
	INSERT INTO DJML.TIPO_DOCUMENTO (DESCRIPCION) VALUES ('LE')

	
	CREATE TABLE DJML.CLIENTES(
	CLIE_ID INT NOT NULL IDENTITY (1,1) PRIMARY KEY,
	CLIE_DNI INT NOT NULL,
	CLIE_TIPO_DOC INT NOT NULL FOREIGN KEY REFERENCES DJML.TIPO_DOCUMENTO(ID_TIPO_DOC),
	CLIE_NOMBRE NVARCHAR(255) NOT NULL,
	CLIE_APELLIDO NVARCHAR(255)NOT NULL,
	CLIE_DIRECCION NVARCHAR(255)NOT NULL,
	CLIE_EMAIL NVARCHAR(255),
	CLIE_TELEFONO NUMERIC(18,0) NOT NULL,
	CLIE_FECHA_NACIMIENTO DATETIME NOT NULL
	)

	PRINT 'SE CREO LA TABLA CLIENTE CORRECTAMENTE'

	---MIGRACION DATOS TABLA CLIENTES---
	
	insert into djml.CLIENTES(CLIE_DNI,CLIE_TIPO_DOC,CLIE_NOMBRE,CLIE_APELLIDO,CLIE_DIRECCION,CLIE_EMAIL, CLIE_TELEFONO, CLIE_FECHA_NACIMIENTO)
	select distinct Cli_Dni,t.ID_TIPO_DOC, Cli_Nombre,Cli_Apellido,Cli_Dir, Cli_Mail,Cli_Telefono,Cli_Fecha_Nac from gd_esquema.Maestra
	join djml.TIPO_DOCUMENTO t on t.DESCRIPCION = 'DNI' 
	where ((Pasaje_Codigo <> 0) or (Paquete_Codigo <> 0))
	AND Cli_Mail <> 'orencia@gmail.com'
	union
	select distinct Cli_Dni,t.ID_TIPO_DOC, Cli_Nombre,Cli_Apellido,Cli_Dir, Cli_Mail,Cli_Telefono,Cli_Fecha_Nac from gd_esquema.Maestra
	join djml.TIPO_DOCUMENTO t on t.DESCRIPCION = 'LE' 
	where ((Pasaje_Codigo <> 0) or (Paquete_Codigo <> 0))
	AND Cli_Mail = 'orencia@gmail.com'

END
GO


CREATE PROCEDURE DJML.CREAR_PASAJENCOMIENDA
AS
BEGIN
--============================================================
						--TABLA PASAJE
--============================================================
	CREATE TABLE DJML.PASAJES (
	PASA_ID INT NOT NULL PRIMARY KEY,
	PASA_VIAJE_ID INT NOT NULL FOREIGN KEY REFERENCES DJML.VIAJES(VIAJE_ID),
	PASA_CLIE_ID INT NOT NULL FOREIGN KEY REFERENCES DJML.CLIENTES(CLIE_ID),
	PASA_COMPRA_ID INT FOREIGN KEY REFERENCES DJML.COMPRAS(COMPRA_ID),
	PASA_BUTA_ID INT FOREIGN KEY REFERENCES DJML.BUTACA_AERO(BXA_ID) NOT NULL,
	PASA_PRECIO MONEY NOT NULL,
	CANCELACION_ID INT DEFAULT NULL
	)


	PRINT 'SE CREO LA TABLA PASAJE CORRECTAMENTE'

	---MIGRACION DATOS TABLA PASAJES---

	insert into djml.PASAJES(PASA_ID, PASA_VIAJE_ID,PASA_CLIE_ID,PASA_COMPRA_ID,PASA_BUTA_ID,PASA_PRECIO)
	SELECT distinct 
		Pasaje_Codigo, 
		v.VIAJE_ID, 
		(
			select c.CLIE_ID
			from DJML.CLIENTES c
			where m.Cli_Dni = c.CLIE_DNI
			and m.Cli_Telefono = c.CLIE_TELEFONO
		), 
		NULL, 
		B.BUTA_ID, 
		Pasaje_Precio
	FROM [GD2C2015].[gd_esquema].[Maestra] m
	JOIN DJML.VIAJES v on m.FechaSalida = v.VIAJE_FECHA_SALIDA
		AND m.FechaLLegada = v.VIAJE_FECHA_LLEGADA
		AND m.Fecha_LLegada_Estimada = v.VIAJE_FECHA_LLEGADA_ESTIMADA
		AND m.Aeronave_Matricula = v.VIAJE_AERO_ID
	JOIN DJML.RUTAS R ON V.VIAJE_RUTA_ID = R.RUTA_CODIGO
	JOIN DJML.TRAMOS T ON R.RUTA_TRAMO = T.TRAMO_ID
	JOIN DJML.BUTACAS B ON M.Butaca_Nro = B.BUTA_NRO
		AND M.Butaca_Piso = B.BUTA_PISO
	JOIN DJML.TIPO_BUTACA TP ON B.BUTA_TIPO_ID = TP.TIPO_BUTACA_ID
		AND M.Butaca_Tipo = TP.DESCRIPCION
	JOIN DJML.BUTACA_AERO BA ON B.BUTA_ID = BA.BXA_BUTA_ID
		AND M.Aeronave_Matricula = BA.BXA_AERO_MATRICULA
	WHERE Paquete_Codigo = 0
	AND (SELECT c1.CIUD_ID FROM DJML.CIUDADES c1 WHERE Ruta_Ciudad_Origen = c1.CIUD_DETALLE) = t.TRAMO_CIUDAD_ORIGEN
	AND (SELECT c2.CIUD_ID FROM DJML.CIUDADES c2 WHERE Ruta_Ciudad_Destino = c2.CIUD_DETALLE) = t.TRAMO_CIUDAD_DESTINO
	ORDER BY 1
	
	PRINT 'SE MIGRO LA TABLA PASAJE CORRECTAMENTE'


--============================================================
						--TABLA ENCOMIENDAS
--============================================================
	CREATE TABLE DJML.ENCOMIENDAS (
	ENCO_ID INT NOT NULL PRIMARY KEY,
	ENCO_VIAJE_ID INT NOT NULL FOREIGN KEY REFERENCES DJML.VIAJES(VIAJE_ID),
	ENCO_CLIE_ID INT NOT NULL FOREIGN KEY REFERENCES DJML.CLIENTES(CLIE_ID),
	ENCO_COMPRA_ID INT FOREIGN KEY REFERENCES DJML.COMPRAS(COMPRA_ID), 
	ENCO_KG INT NOT NULL,
	ENCO_PRECIO MONEY NOT NULL,
	CANCELACION_ID INT DEFAULT NULL
	)
	
	PRINT 'SE CREO LA TABLA ENCOMIENDA CORRECTAMENTE'

	---MIGRACION DATOS TABLA ENCOMIENDAS---

	insert into djml.ENCOMIENDAS(ENCO_ID,ENCO_VIAJE_ID,ENCO_CLIE_ID,ENCO_COMPRA_ID,ENCO_KG,ENCO_PRECIO)
	select distinct m.Paquete_Codigo, V.VIAJE_ID,C.CLIE_ID, null, m.Paquete_KG, m.Paquete_Precio 
	from gd_esquema.Maestra m
	JOIN DJML.VIAJES V on M.FechaSalida = V.VIAJE_FECHA_SALIDA
		AND M.FechaLLegada = V.VIAJE_FECHA_LLEGADA
		AND M.Fecha_LLegada_Estimada = V.VIAJE_FECHA_LLEGADA_ESTIMADA
		AND M.Aeronave_Matricula = V.VIAJE_AERO_ID
	JOIN DJML.RUTAS R ON V.VIAJE_RUTA_ID = R.RUTA_CODIGO
	JOIN DJML.TRAMOS T ON R.RUTA_TRAMO = T.TRAMO_ID
	JOIN DJML.CLIENTES C ON M.Cli_Dni = C.CLIE_DNI
		AND M.Cli_Telefono = C.CLIE_TELEFONO
	where m.Paquete_Codigo <> 0 
	AND m.Pasaje_Codigo = 0
	AND (SELECT c1.CIUD_ID FROM DJML.CIUDADES c1 WHERE Ruta_Ciudad_Origen = c1.CIUD_DETALLE) = t.TRAMO_CIUDAD_ORIGEN
	AND (SELECT c2.CIUD_ID FROM DJML.CIUDADES c2 WHERE Ruta_Ciudad_Destino = c2.CIUD_DETALLE) = t.TRAMO_CIUDAD_DESTINO
	ORDER BY 1
	
	PRINT 'SE MIGRO LA TABLA ENCOMIENDA CORRECTAMENTE'
	
	--============================================================
						--TABLA CLAVES
	--============================================================
	CREATE TABLE DJML.CLAVES (
	CLAVE_ID INT NOT NULL IDENTITY (1,1) PRIMARY KEY,
	CLAVE_DESCRIPCION VARCHAR(30) NOT NULL,
	CLAVE_ULTIMO_ID INT NOT NULL
	)
	
	PRINT 'SE CREO LA TABLA CLAVES CORRECTAMENTE'
	
	INSERT INTO DJML.CLAVES VALUES ('Pasajes', (select top 1 PASA_ID from DJML.PASAJES order by PASA_ID desc));
	INSERT INTO DJML.CLAVES VALUES ('Encomiendas',(select top 1 ENCO_ID from DJML.ENCOMIENDAS order by ENCO_ID desc));
	
	PRINT 'SE MIGRO LA TABLA CLAVES CORRECTAMENTE'
	
END
GO


CREATE PROCEDURE DJML.CREAR_COMPRAS
AS 
BEGIN
--=======================================================================
                            -- TABLA MEDIO DE PAGO
--=======================================================================
	CREATE TABLE DJML.MEDIOS_DE_PAGO(
	MEDI_ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	MEDI_DESCRIPCION VARCHAR(15) NOT NULL
	)

	--MIGRACION TABLA MEDIOS_DE_PAGO

	INSERT INTO DJML.MEDIOS_DE_PAGO(MEDI_DESCRIPCION) VALUES ('EFECTIVO')
	INSERT INTO DJML.MEDIOS_DE_PAGO(MEDI_DESCRIPCION) VALUES ('TC')


--=======================================================================
                            -- TABLA TIPOS DE TARJETA
--=======================================================================


	CREATE TABLE DJML.TIPOS_DE_TARJETA (
    	ID INT IDENTITY(1,1) PRIMARY KEY,
	NOMBRE NVARCHAR(255) NOT NULL,
	CUOTAS INT DEFAULT 0   
	)

	--MIGRACION TABLA TIPOS_DE_TARJETA

	INSERT INTO DJML.TIPOS_DE_TARJETA (NOMBRE, CUOTAS)
	VALUES ('VISA', 6),
	('MASTERCARD', 12),
	('AMEX', 3),
	('DINERS', 0);

--=======================================================================
                            -- TABLA TARJETA DE CREDITO
--=======================================================================
	CREATE TABLE DJML.TARJETAS_DE_CREDITO(
	TARJ_NUMERO BIGINT NOT NULL PRIMARY KEY,
	TARJ_TIPO_ID INT FOREIGN KEY REFERENCES DJML.TIPOS_DE_TARJETA(ID),
	TARJ_CODIGO INT NOT NULL
	)
	
	--HACER: NO SE MIGRA

--=======================================================================
                            -- TABLA COMPRA
--=======================================================================

	CREATE TABLE DJML.COMPRAS(
	COMPRA_ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	COMPRA_CODIGO as 'COM' + right('00000000' +cast(compra_id as varchar(8)),8) persisted,
	COMPRA_VIAJE_ID INT NOT NULL FOREIGN KEY REFERENCES DJML.VIAJES(VIAJE_ID),
	COMPRA_CLIE_ID INT NOT NULL FOREIGN KEY REFERENCES DJML.CLIENTES(CLIE_ID),
	COMPRA_VEND_ID INT NULL FOREIGN KEY REFERENCES DJML.USUARIOS(USUA_ID), 
	COMPRA_MEDIO_DE_PAGO INT FOREIGN KEY REFERENCES DJML.MEDIOS_DE_PAGO(MEDI_ID),
	COMPRA_TARJETA_DE_CREDITO BIGINT FOREIGN KEY REFERENCES DJML.TARJETAS_DE_CREDITO(TARJ_NUMERO),
	COMPRA_MONTO MONEY NOT NULL,
	COMPRA_FECHA DATETIME NOT NULL
	)
	
	-- MIGRACION DATOS TABLA COMPRAS
	-- MIGRAR CON: MEDIO DE PAGO, TARJETA DE CREDITO EN NULL !!!!


--=======================================================================
                            -- TABLA CANCELACION
--=======================================================================

	CREATE TABLE DJML.CANCELACIONES (
    CANC_ID INT IDENTITY(1,1)PRIMARY KEY,
	CANC_CODIGO as 'CAN' + right('00000000' +cast(CANC_ID as varchar(8)),8) persisted,
    CANC_FECHA_DEVOLUCION DATETIME NOT NULL,
    CANC_COMPRA_ID INT NOT NULL FOREIGN KEY REFERENCES DJML.COMPRAS(COMPRA_ID),
    CANC_MOTIVO NVARCHAR(255)NOT NULL
	)

	--MIGRACION TABLA CANCELACIONES	
	--HACER: NO SE MIGRA

END 
GO

CREATE PROCEDURE DJML.CREAR_CANJES
AS
BEGIN

--============================================================
						--CREAR TABLA MILLAS
--============================================================


CREATE TABLE DJML.MILLAS(
	MILLAS_ID INT IDENTITY(1,1) PRIMARY KEY,
	MILLAS_CLIE_ID INT NOT NULL FOREIGN KEY REFERENCES DJML.CLIENTES(CLIE_ID),
    MILLAS_INFORMACION NVARCHAR(100),
   -- MILLAS_COMPRA_ID INT NOT NULL FOREIGN KEY REFERENCES DJML.COMPRAS(COMPRA_ID),
     MILLAS_PASA_ID INT  FOREIGN KEY REFERENCES DJML.PASAJES(PASA_ID),
    MILLAS_ENCO_ID INT  FOREIGN KEY REFERENCES DJML.ENCOMIENDAS(ENCO_ID),
   	MILLAS_CANTIDAD INT NOT NULL,
	MILLAS_CANTIDAD_HISTORICA INT NOT NULL,
    MILLAS_FECHA SMALLDATETIME NOT NULL)

	PRINT 'SE CREO CORRECTAMENTE LA TABLA MILLAS'
	--HACER:: NO SE MIGRA

	

--============================================================
						--TABLA PRODUCTOS
--============================================================
CREATE TABLE DJML.PRODUCTO (
    PROD_ID  INT  IDENTITY(1,1)PRIMARY KEY,
    PROD_NOMBRE NVARCHAR(255)UNIQUE,
    PROD_MILLAS_REQUERIDAS INT NOT NULL,
    PROD_STOCK INT  NOT NULL    
	) 

	--MIGRACION TABLA PRODUCTO
	
	INSERT INTO DJML.PRODUCTO VALUES ('ADAMS X 20u. MENTOL', 20, 100);
	INSERT INTO DJML.PRODUCTO VALUES ('BUBBALOO X 60u. TUTTIF.', 50, 10);
	INSERT INTO DJML.PRODUCTO VALUES ('HALLS EXTREME X15 CHERRY', 200, 200);
	INSERT INTO DJML.PRODUCTO VALUES ('LENGUETAZO HIGH SCHOOL', 100, 200);
	INSERT INTO DJML.PRODUCTO VALUES ('MEDIA HORA X 200u.', 2000, 15);
	INSERT INTO DJML.PRODUCTO VALUES ('LA YAPA X 36u.', 500, 45);
	INSERT INTO DJML.PRODUCTO VALUES ('MINI PUNCH X 36u.', 222, 22);
	INSERT INTO DJML.PRODUCTO VALUES ('PASTILLAS BARBIE X 12u.', 1000, 100);
	INSERT INTO DJML.PRODUCTO VALUES ('ENCENDEDOR MINI BIC u.', 375, 150);
	INSERT INTO DJML.PRODUCTO VALUES ('CHOC. RAMA LECHE X 40g.', 500, 450);
	INSERT INTO DJML.PRODUCTO VALUES ('CHOC. RAMA BLANCO X 40g.', 500, 450);

--============================================================
						--TABLA CANJES
--============================================================

	CREATE TABLE DJML.CANJES (
    CANJ_ID INT IDENTITY(1,1)     PRIMARY KEY,
	CANJ_CLIE_ID INT NOT NULL FOREIGN KEY REFERENCES DJML.CLIENTES(CLIE_ID),
    CANJ_PRODUCTO_ID INT NOT NULL FOREIGN KEY REFERENCES DJML.PRODUCTO(PROD_ID),
    CANJ_CANTIDAD INT DEFAULT 1,
    CANJ_FECHA_CANJE DATETIME NOT NULL,
    CANJ_MILLAS_USADAS INT NOT NULL
	)
	
	--MIGRACION TABLA CANJES
	--HACER: NO SE MIGRA
	
END
GO

PRINT 'SPs CREADOS...'
GO

--============================================================
						--EJECUTAR PROCEDURES
--============================================================

PRINT 'EJECUTAR SP DE CREACION...'
GO

EXEC DJML.CREAR_ROLES
EXEC DJML.CREAR_FUNCIONALIDADES
EXEC DJML.CREAR_USUARIOS
EXEC DJML.CREAR_SERVICIOS
EXEC DJML.CREAR_CIUDADES
EXEC DJML.CREAR_RUTAS
EXEC DJML.CREAR_AERONAVES
EXEC DJML.CREAR_VIAJES
EXEC DJML.CREAR_CLIENTES
EXEC DJML.CREAR_COMPRAS
EXEC DJML.CREAR_PASAJENCOMIENDA
EXEC DJML.CREAR_CANJES

PRINT 'LOS SP DE CREACION SE EJECUTARON CORRECTAMENTE'
GO

--============================================================
			--VIEW
--============================================================
PRINT 'CREAR VISTA v_rutas ...'
GO

CREATE VIEW DJML.v_rutas
	AS SELECT	c1.CIUD_DETALLE as 'Ciudad Origen'
			  , c1.CIUD_ID as 'OrigenID'
			  , c2.CIUD_DETALLE as 'Ciudad Destino'
			  , c2.CIUD_ID as 'DestinoID'
			  , s.SERV_DESCRIPCION as 'Servicio'
			  , s.SERV_ID as 'ServicioID'
			  , '$ ' + cast ([RUTA_PRECIO_BASE_PASAJE] as CHAR(100)) as 'Pasaje'
			  , '$ ' + cast ([RUTA_PRECIO_BASE_KILO] as CHAR(100)) as 'Kilo Encomienda'
		FROM DJML.RUTAS r
		JOIN DJML.SERVICIOS s ON s.SERV_ID = r.RUTA_SERVICIO
		JOIN DJML.TRAMOS t ON t.TRAMO_ID = r.RUTA_TRAMO
		JOIN DJML.CIUDADES c1 ON c1.CIUD_ID = t.TRAMO_CIUDAD_ORIGEN
		JOIN DJML.CIUDADES c2 ON c2.CIUD_ID = t.TRAMO_CIUDAD_DESTINO
		WHERE RUTA_IS_ACTIVE = 1

GO

PRINT 'SE CREO LA VISTA v_rutas CORRECTAMENTE'
GO

--------------------------------------------			
--Funcion para calcular diferencia de fechas
--------------------------------------------
PRINT 'CREAR FUNCION calculoFecha ...'
GO

create function  djml.calculoFecha(@fechaSalida smalldatetime, @fechaLlegadaEstimada smalldatetime)
returns int 
as
begin 
	declare @diferencia int 
	select @diferencia  = datediff(day,@fechaLlegadaEstimada, @fechaSalida)
	
	return @diferencia
end
GO

PRINT 'SE CREO LA FUNCION calculoFecha CORRECTAMENTE'
GO

--------------------------------------------------------------------------
--Procedimiento Buscar Aeronaves para remplazar similar a la dada de baja
--------------------------------------------------------------------------
PRINT 'CREAR PROCEDURE Proc_Aeronaves ...'
GO

create procedure djml.Proc_Aeronaves @idaeronave nvarchar(7), @resultado int output
AS
	BEGIN

		declare @viajeId int 
		declare @aeroModelo nvarchar(50)
		declare @aeroFabricante int
		declare @aeroServicioId int
		declare @idaeronavenueva nvarchar(7)
		declare @habemusaeronave int, @fecha_llegada_nueva as datetime, @fecha_salida_nueva as datetime
		declare @fecha_llegada_vieja as datetime , @fecha_salida_vieja as datetime

		select @aeromodelo = a1.aero_modelo, @aerofabricante = a1.aero_fabricante, 
		@aeroservicioid = a1.aero_servicio_id  from djml.aeronaves a1
		where a1.aero_matricula = @idaeronave

		declare cAeroNaves cursor for 
			select a.aero_matricula from djml.aeronaves a
			where a.aero_modelo = @aeroModelo and a.aero_fabricante = @aeroFabricante 
			and a.aero_servicio_id = @aeroServicioId and a.AERO_BAJA_FUERA_SERVICIO = 0
			and a.AERO_BAJA_VIDA_UTIL = 0
			
		open cAeroNaves
		fetch cAeroNaves into @idaeronavenueva
	
		while(@@FETCH_STATUS = 0)
			begin
				set @habemusaeronave = 1
				
				declare cViajesAeroNaveNueva cursor for
				select viaje_fecha_salida,viaje_fecha_llegada_estimada from djml.viajes where viaje_aero_id = @idaeronavenueva
				
				open cViajesAeroNaveNueva
				fetch cViajesAeroNaveNueva into @fecha_salida_nueva,@fecha_llegada_nueva
		
				while(@@FETCH_STATUS = 0)
					begin
						declare cViajesAeroNaveVieja cursor for
						select viaje_fecha_salida,viaje_fecha_llegada_estimada from djml.viajes where viaje_aero_id = @idaeronave
						
						open cViajesAeroNaveVieja
						fetch cViajesAeroNaveVieja into @fecha_salida_vieja,@fecha_llegada_vieja
			
						while(@@FETCH_STATUS = 0)
							begin
								if not (@fecha_salida_vieja < @fecha_salida_nueva and @fecha_salida_vieja > @fecha_llegada_nueva)
									set @habemusaeronave = 0
								fetch cViajesAeroNaveVieja into @fecha_salida_vieja,@fecha_llegada_vieja
							end
			
						close cViajesAeroNaveVieja
						deallocate cViajesAeroNaveVieja
			
						fetch cViajesAeroNaveNueva into @fecha_salida_nueva,@fecha_llegada_nueva
					end
					
				close cViajesAeroNaveNueva
				deallocate cViajesAeroNaveNueva
				
				if @habemusaeronave = 0
					fetch cAeroNaves into @idAeroNaveNueva
				else
					break
			end
			
		close cAeroNaves
		deallocate cAeroNaves
	
		if @idaeronavenueva is not null and @habemusaeronave = 1
			begin
				update djml.viajes set VIAJE_AERO_ID = @idaeronavenueva where VIAJE_AERO_ID = @idaeronave
				update djml.butaca_aero set BXA_AERO_MATRICULA = @idaeronavenueva where BXA_AERO_MATRICULA = @idaeronave
				set @resultado = 1;
			end 
		else
			set @resultado = 0;
	
		select @resultado

	END
GO

PRINT 'SE CREO EL PROCEDURE Proc_Aeronaves CORRECTAMENTE'
GO

----------------------------------------------------------------------------
--TRIGGER DE INSERCION DE MILLAS UNA VEZ REGISTRADA LA LLEGADA DEL VIAJE
-----------------------------------------------------------------------------

PRINT 'CREAR EL TRIGGER Insertar_Millas ...'
GO

create trigger Insertar_Millas
on djml.Registro_destino 
after insert
as

--if( select p.pasa_compra_id from djml.REGISTRO_DESTINO rd join djml.PASAJES p on rd.RD_VIAJE_ID = p.PASA_VIAJE_ID) != NULL 
begin
	INSERT INTO DJML.MILLAS (millas_clie_id, millas_informacion, millas_enco_id, millas_pasa_id, millas_cantidad,millas_cantidad_historica, millas_fecha)
	SELECT p.pasa_clie_id, null, null, p.pasa_id,(round(p.pasa_precio /10,0)),(round(p.PASA_PRECIO /10,0)),rd.rd_fecha_llegada from djml.registro_destino rd
	join djml.pasajes p on rd.rd_viaje_id = p.pasa_viaje_id
	where p.cancelacion_id is null 
		and p.PASA_CLIE_ID in (select c.compra_clie_id from djml.COMPRAS c where COMPRA_VIAJE_ID = rd.RD_VIAJE_ID)
end

--if((select e.ENCO_COMPRA_ID from djml.REGISTRO_DESTINO rd join djml.ENCOMIENDAS e on rd.RD_VIAJE_ID = e.enco_VIAJE_ID) != NULL )
begin
	INSERT INTO DJML.MILLAS (millas_clie_id, millas_informacion, millas_enco_id, millas_pasa_id, millas_cantidad, millas_cantidad_historica, millas_fecha)
	SELECT e.enco_clie_id, null, e.enco_id, null,(round(e.enco_precio /10,0)),(round(e.enco_precio /10,0)),rd.rd_fecha_llegada from djml.registro_destino rd
	join djml.encomiendas e on rd.rd_viaje_id = e.enco_viaje_id
	where e.cancelacion_id is null
	and e.ENCO_CLIE_ID in (select c.compra_clie_id from djml.COMPRAS c where COMPRA_VIAJE_ID = rd.RD_VIAJE_ID)

end

PRINT 'SE CREO EL TRIGGER Insertar_Millas CORRECTAMENTE'
GO

PRINT 'LA MIGRACION TERMINO SATISFACTORIAMENTE, GRACIAS POR ESPERAR'
GO


-----------------------------------------------------------
---DROPS 
-----------------------------------------------------------
/*
DROP TABLE DJML.CANJES
DROP TABLE DJML.PRODUCTO
DROP TABLE DJML.MILLAS
DROP TABLE DJML.CANCELACIONES
DROP TABLE DJML.COMPRAS
DROP TABLE DJML.TARJETAS_DE_CREDITO
DROP TABLE DJML.TIPOS_DE_TARJETA
DROP TABLE DJML.MEDIOS_DE_PAGO
DROP TABLE DJML.CLAVES
DROP TABLE DJML.ENCOMIENDAS
DROP TABLE DJML.PASAJES
DROP TABLE DJML.CLIENTES
DROP TABLE DJML.TIPO_DOCUMENTO
DROP TABLE DJML.REGISTRO_DESTINO
DROP TABLE DJML.BUTACA_AERO_VIAJE
DROP TABLE DJML.VIAJES
DROP TABLE DJML.BUTACA_AERO
DROP TABLE DJML.BUTACAS
DROP TABLE DJML.AERONAVES_POR_PERIODOS
DROP TABLE DJML.PERIODOS_DE_INACTIVIDAD
DROP TABLE DJML.AERONAVES
DROP TABLE DJML.FABRICANTES
DROP TABLE DJML.TIPO_BUTACA
DROP TABLE DJML.RUTAS_LEGACY
DROP TABLE DJML.RUTAS
DROP TABLE DJML.TRAMOS
DROP TABLE DJML.SERVICIOS
DROP TABLE DJML.CIUDADES
DROP TABLE DJML.USUARIOS
DROP TABLE DJML.ROL_FUNCIONALIDAD
DROP TABLE DJML.FUNCIONALIDAD
DROP TABLE DJML.ROLES

drop view DJML.v_rutas
drop function djml.calculoFecha
drop trigger djml.Insertar_Millas
drop procedure djml.Proc_Aeronaves


DROP PROCEDURE DJML.CREAR_AERONAVES
DROP PROCEDURE DJML.CREAR_CIUDADES
DROP PROCEDURE DJML.CREAR_CLIENTES
DROP PROCEDURE DJML.CREAR_ROLES
DROP PROCEDURE DJML.CREAR_RUTAS
DROP PROCEDURE DJML.CREAR_SERVICIOS
DROP PROCEDURE DJML.CREAR_VIAJES 
DROP PROCEDURE DJML.CREAR_FUNCIONALIDADES 
DROP PROCEDURE DJML.CREAR_USUARIOS
DROP PROCEDURE DJML.CREAR_PASAJENCOMIENDA
DROP PROCEDURE DJML.CREAR_COMPRAS
DROP PROCEDURE DJML.CREAR_CANJES

DROP SCHEMA DJML
*/


