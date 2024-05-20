/**Proyecto TertulianoBG
   Estudiantes: Daniel Alejandro Rodriguez Baracaldo - Juan Pablo Vélez Muñoz.
   Profesor: Rodrigo Humberto Gualtero Martinez
   MBDA - G1.
   Estructura y restricciones declarativas.**/
   
/**Tablas.**/

CREATE TABLE materiales(
    codigo VARCHAR2(10) NOT NULL,
    nombre VARCHAR2(25) NOT NULL,
    descripcion VARCHAR2(100),
    cantidad NUMBER(9,2) NOT NULL,
    precio NUMBER(7,2) NOT NULL,
    proveedor VARCHAR2(60));
    
CREATE TABLE proveedores(
    empresa VARCHAR2(60) NOT NULL,
    telefono VARCHAR2(10),
    representante VARCHAR2(50) NOT NULL,
    pais VARCHAR2(50) NOT NULL);
    
CREATE TABLE emailsprov(
    empresa VARCHAR2(60) NOT NULL,
    correo VARCHAR2(50) NOT NULL);

CREATE TABLE direccionesprov(
    empresa VARCHAR2(60) NOT NULL,
    direccion VARCHAR2(60) NOT NULL);

CREATE TABLE componentes(
    codigo VARCHAR2(15) NOT NULL,
    descripcion VARCHAR2(50) NOT NULL,
    unidades NUMBER(7) NOT NULL,
    precio NUMBER(5,2),
    cantidadMinima NUMBER(7),
    juego VARCHAR2(50) NOT NULL,
    proveedor VARCHAR2(60));

CREATE TABLE operariocomponentes(
    operarioId VARCHAR2(10) NOT NULL,
    operarioTid VARCHAR2(2) NOT NULL,
    componente VARCHAR2(15) NOT NULL,
    unidades NUMBER(6) NOT NULL);
    
CREATE TABLE OCmateriales(
    idO VARCHAR2(10) NOT NULL,
    tidO VARCHAR2(2) NOT NULL,
    componente VARCHAR2(15) NOT NULL,
    material VARCHAR2(10) NOT NULL);
    
CREATE TABLE operarios(
    idO VARCHAR2(10) NOT NULL,
    tidO VARCHAR2(2) NOT NULL,
    nombre VARCHAR2(50) NOT NULL);

CREATE TABLE categorias(
    nombre VARCHAR2(50) NOT NULL,
    descripcion VARCHAR2(200));

CREATE TABLE categoriajuego(
    juego VARCHAR2(50) NOT NULL,
    categoria VARCHAR2(50) NOT NULL);

CREATE TABLE juegos(
    nombre VARCHAR2(50) NOT NULL,
    instrucciones VARCHAR2(100) NOT NULL,
    lanzamiento DATE NOT NULL,
    unidades NUMBER(6) NOT NULL,
    previstas NUMBER(6) NOT NULL,
    edicion NUMBER(2) NOT NULL,
    estado VARCHAR2(1) NOT NULL,
    precio NUMBER(7,2) NOT NULL,
    fecha_licencia DATE,
    contrato_licencia VARCHAR2(100));

CREATE TABLE propuestajuego(
    juego VARCHAR2(50) NOT NULL,
    codigo VARCHAR2(50) NOT NULL);

CREATE TABLE propuestas(
    codigo VARCHAR2(50) NOT NULL,
    descripcion VARCHAR2(200),
    fecha DATE NOT NULL);

CREATE TABLE ideacomponente(
    propuesta VARCHAR2(50) NOT NULL,
    descripcion VARCHAR2(100) NOT NULL);

CREATE TABLE disenadorpropuesta(
    disenador VARCHAR2(10) NOT NULL,
    codigo VARCHAR2(50) NOT NULL);

CREATE TABLE disenadores(
    idD VARCHAR2(10) NOT NULL,
    nombre VARCHAR2(50) NOT NULL);

CREATE TABLE emailsdis(
    idD VARCHAR2(10) NOT NULL,
    correo VARCHAR2(50) NOT NULL);

CREATE TABLE licencias(
    fecha DATE NOT NULL,
    contrato VARCHAR2(100) NOT NULL,
    descripcion VARCHAR2(60),
    editorial VARCHAR2(11) NOT NULL);

CREATE TABLE editoriales(
    duns VARCHAR2(11) NOT NULL,
    nombre VARCHAR2(50) NOT NULL,
    cede_principal VARCHAR2(50) NOT NULL,
    email_representante VARCHAR2(50) NOT NULL);

CREATE TABLE vendedores(
    idV VARCHAR2(10) NOT NULL,
    tidV VARCHAR2(2) NOT NULL,
    nombre VARCHAR2(50) NOT NULL,
    correo VARCHAR2(50) NOT NULL);

CREATE TABLE lineaventas(
    juego VARCHAR2(50) NOT NULl,
    venta VARCHAR2(25) NOT NULL,
    unidades NUMBER(6) NOT NULL);

CREATE TABLE ventas(
    codigo VARCHAR2(25) NOT NULL,
    fecha DATE NOT NULL,
    tipo_pago VARCHAR2(2) NOT NULL,
    monto NUMBER(7,2) NOT NULL,
    estado VARCHAR2(2) NOT NULL,
    idV VARCHAR2(10),
    tidV VARCHAR2(2),
    cliente VARCHAR2(10) NOT NULL);

CREATE TABLE envios(
    codigo VARCHAR2(25) NOT NULL,
    empresa VARCHAR2(50) NOT NULL,
    direccion VARCHAR2(60) NOT NULL,
    barrio VARCHAR2(50) NOT NULL,
    departamento VARCHAR2(50) NOT NULL,
    descripcion VARCHAR2(100),
    costo NUMBER(7,2) NOT NULL,
    venta VARCHAR2(25) NOT NULL);

CREATE TABLE clientes(
    codigo VARCHAR2(10) NOT NULL,
    direccion VARCHAR2(60) NOT NULL,
    codigo_postal VARCHAR2(6) NOT NULL);

CREATE TABLE emailsClie(
    codigo VARCHAR2(10) NOT NULL,
    correo VARCHAR2(50) NOT NULL);

CREATE TABLE tiendas(
    codigo VARCHAR2(10) NOT NULL,
    duns VARCHAR2(11) NOT NULL,
    empresa VARCHAR2(60) NOT NULL,
    contacto VARCHAR2(50) NOT NULL,
    telefono_contacto VARCHAR2(10) NOT NULL);

CREATE TABLE particulares(
    codigo VARCHAR2(10) NOT NULL,
    idC VARCHAR2(10) NOT NULL,
    tidC VARCHAR2(2) NOT NULL,
    nombre VARCHAR2(50) NOT NULL,
    telefono VARCHAR2(10));

CREATE TABLE tarjetasP(
    codigo VARCHAR2(10) NOT NULL,
    tarjeta VARCHAR2(7) NOT NULL);

CREATE TABLE tarjetasV(
    codigo VARCHAR2(25) NOT NULL,
    tarjeta VARCHAR2(7) NOT NULL);


/**Restricciones de atributos**/

/**Materiales**/

ALTER TABLE materiales ADD CONSTRAINT CH_cantidad
CHECK(cantidad > 0);

ALTER TABLE materiales ADD CONSTRAINT CH_precio
CHECK(precio > 0);

/**proveedores**/

ALTER TABLE proveedores ADD CONSTRAINT CH_telefono
CHECK(REGEXP_LIKE(telefono, '^[0-9]+$'));

/**emailsProv**/

ALTER TABLE emailsprov ADD CONSTRAINT CH_correo
CHECK(correo LIKE '%@%.com');

/**direccionesProv**/

ALTER TABLE direccionesprov ADD CONSTRAINT CH_direccion
CHECK(direccion LIKE 'cr.%#%-%');

/**componentes**/

ALTER TABLE componentes ADD CONSTRAINT CH_codigo
CHECK(LENGTH(codigo) = 15 AND REGEXP_LIKE(codigo, '^[0-9]+$'));

ALTER TABLE componentes ADD CONSTRAINT CH_unidades
CHECK(unidades >= 0);

ALTER TABLE componentes ADD CONSTRAINT CH_Com_preci
CHECK(precio > 0);

ALTER TABLE componentes ADD CONSTRAINT CH_cantidadMinima
CHECK(cantidadMinima > 0);

/**operarioscomponentes**/

ALTER TABLE operariocomponentes ADD CONSTRAINT CH_operarioId
CHECK(LENGTH(operarioId) = 10 AND REGEXP_LIKE(operarioId, '^[0-9]+$'));

ALTER TABLE operariocomponentes ADD CONSTRAINT CH_operarioTid
CHECK(operarioTid IN ('cc','ce'));

ALTER TABLE operariocomponentes ADD CONSTRAINT CH_componente
CHECK(LENGTH(componente) = 15 AND REGEXP_LIKE(componente, '^[0-9]+$'));

ALTER TABLE operariocomponentes ADD CONSTRAINT CH_OpeCom_unidades
CHECK(unidades > 0);

/**OCmateriales**/

ALTER TABLE OCmateriales ADD CONSTRAINT CH_idO
CHECK(LENGTH(idO) = 10 AND REGEXP_LIKE(idO, '^[0-9]+$'));

ALTER TABLE OCmateriales ADD CONSTRAINT CH_tidO
CHECK(tidO IN ('cc','ce'));

ALTER TABLE OCmateriales ADD CONSTRAINT CH_OCm_componente
CHECK(LENGTH(componente) = 15 AND REGEXP_LIKE(componente, '^[0-9]+$'));

/**operarios**/

ALTER TABLE operarios ADD CONSTRAINT CH_op_idO
CHECK(LENGTH(idO) = 10 AND REGEXP_LIKE(idO, '^[0-9]+$'));

ALTER TABLE operarios ADD CONSTRAINT CH_op_tidO
CHECK(tidO IN ('cc','ce'));

/**juegos**/

ALTER TABLE juegos ADD CONSTRAINT CH_instrucciones
CHECK(instrucciones LIKE 'https://%.pdf');

ALTER TABLE juegos ADD CONSTRAINT CH_jue_unidades
CHECK(unidades > 0);

ALTER TABLE juegos ADD CONSTRAINT CH_previstas
CHECK(previstas > 0);

ALTER TABLE juegos ADD CONSTRAINT CH_edicion
CHECK(edicion > 0);

ALTER TABLE juegos ADD CONSTRAINT CH_estado
CHECK(estado IN ('a', 'n'));

ALTER TABLE juegos ADD CONSTRAINT CH_jue_precio
CHECK(precio > 0);

ALTER TABLE juegos ADD CONSTRAINT CH_contrato_licencia
CHECK(contrato_licencia LIKE 'https://%.pdf');

/**disenadorPropuesta**/

ALTER TABLE disenadorpropuesta ADD CONSTRAINT CH_disenador
CHECK(LENGTH(disenador) = 10 AND REGEXP_LIKE(disenador, '^[0-9]+$'));

/**disenador**/

ALTER TABLE disenadores ADD CONSTRAINT CH_idD
CHECK(LENGTH(idD) = 10 AND REGEXP_LIKE(idD, '^[0-9]+$'));

/**emailsdis**/

ALTER TABLE emailsdis ADD CONSTRAINT CH_emails_idD
CHECK(LENGTH(idD) = 10 AND REGEXP_LIKE(idD, '^[0-9]+$'));

ALTER TABLE emailsdis ADD CONSTRAINT CH_emails_correo
CHECK(correo LIKE '%@%.com');

/**licencias**/

ALTER TABLE licencias ADD CONSTRAINT CH_contrato
CHECK(contrato LIKE 'https://%.pdf');

ALTER TABLE licencias ADD CONSTRAINT CH_editorial
CHECK(editorial LIKE '%-%-%' AND (REGEXP_LIKE(SUBSTR(editorial, 1, 2), '^[0-9]+$') AND REGEXP_LIKE(SUBSTR(editorial, 4, 3), '^[0-9]+$')) AND REGEXP_LIKE(SUBSTR(editorial, 8, 4), '^[0-9]+$'));

/**editoriales**/

ALTER TABLE editoriales ADD CONSTRAINT CH_duns
CHECK(duns LIKE '%-%-%' AND (REGEXP_LIKE(SUBSTR(duns, 1, 2), '^[0-9]+$') AND REGEXP_LIKE(SUBSTR(duns, 4, 3), '^[0-9]+$')) AND REGEXP_LIKE(SUBSTR(duns, 8, 4), '^[0-9]+$'));

ALTER TABLE editoriales ADD CONSTRAINT CH_email_representante
CHECK(email_representante LIKE '%@%.com');

/**vendedores**/

ALTER TABLE vendedores ADD CONSTRAINT CH_idV
CHECK(LENGTH(idV) = 10 AND REGEXP_LIKE(idV, '^[0-9]+$'));

ALTER TABLE vendedores ADD CONSTRAINT CH_tidV
CHECK(tidV IN ('cc', 'ce'));

ALTER TABLE vendedores ADD CONSTRAINT CH_email
CHECK(correo LIKE '%@%.com');

/**lineaventas**/

ALTER TABLE lineaventas ADD CONSTRAINT CH_venta
CHECK(venta LIKE 'SELL-%');

ALTER TABLE lineaventas ADD CONSTRAINT CH_linven_unidades
CHECK(unidades > 0);

/**ventas**/

ALTER TABLE ventas ADD CONSTRAINT CH_ven_codigo
CHECK(codigo LIKE 'SELL-%');

ALTER TABLE ventas ADD CONSTRAINT CH_tipo_pago
CHECK(tipo_pago IN ('ef', 'tr'));

ALTER TABLE ventas ADD CONSTRAINT CH_monto
CHECK(monto > 0);

ALTER TABLE ventas ADD CONSTRAINT CH_ven_estado
CHECK(estado IN ('re', 'ap'));

ALTER TABLE ventas ADD CONSTRAINT CH_ven_idV
CHECK(LENGTH(idV) = 10 AND REGEXP_LIKE(idV, '^[0-9]+$'));

ALTER TABLE ventas ADD CONSTRAINT CH_ven_tidV
CHECK(tidV IN ('cc', 'ce'));

ALTER TABLE ventas ADD CONSTRAINT CH_cliente
CHECK(LENGTH(cliente) = 10 AND (cliente LIKE 't-%' OR cliente LIKE 'p-%') AND REGEXP_LIKE(SUBSTR(cliente, 3, 8), '^[0-9]+$'));

/**envios**/

ALTER TABLE envios ADD CONSTRAINT CH_env_codigo
CHECK(codigo LIKE 'SEND-%');

ALTER TABLE envios ADD CONSTRAINT CH_env_direccion
CHECK(direccion LIKE 'cr.%#%-%');

ALTER TABLE envios ADD CONSTRAINT CH_costo
CHECK(costo > 0);

ALTER TABLE envios ADD CONSTRAINT CH_env_venta
CHECK(venta LIKE 'SELL-%');

/**clientes**/

ALTER TABLE clientes ADD CONSTRAINT CH_cli_codigo
CHECK(LENGTH(codigo) = 10 AND (codigo LIKE 't-%' OR codigo LIKE 'p-%') AND REGEXP_LIKE(SUBSTR(codigo, 3, 8), '^[0-9]+$'));

ALTER TABLE clientes ADD CONSTRAINT CH_cli_direccion
CHECK(direccion LIKE 'cr.%#%-%');

ALTER TABLE clientes ADD CONSTRAINT CH_codigo_postal
CHECK(LENGTH(codigo_postal) = 6 AND REGEXP_LIKE(codigo_postal, '^[0-9]+$'));

/**emailsClie**/

ALTER TABLE emailsClie ADD CONSTRAINT CH_emCli_codigo
CHECK(LENGTH(codigo) = 10 AND (codigo LIKE 't-%' OR codigo LIKE 'p-%') AND REGEXP_LIKE(SUBSTR(codigo, 3, 8), '^[0-9]+$'));

ALTER TABLE emailsClie ADD CONSTRAINT CH_emClicorreo
CHECK(correo LIKE '%@%.com');

/**tiendas**/

ALTER TABLE tiendas ADD CONSTRAINT CH_tie_codigo
CHECK(LENGTH(codigo) = 10 AND codigo LIKE 't-%' AND REGEXP_LIKE(SUBSTR(codigo, 3, 8), '^[0-9]+$'));

ALTER TABLE tiendas ADD CONSTRAINT CH_tie_duns
CHECK(duns LIKE '%-%-%' AND (REGEXP_LIKE(SUBSTR(duns, 1, 2), '^[0-9]+$') AND REGEXP_LIKE(SUBSTR(duns, 4, 3), '^[0-9]+$')) AND REGEXP_LIKE(SUBSTR(duns, 8, 4), '^[0-9]+$'));

ALTER TABLE tiendas ADD CONSTRAINT CH_telefono_contacto
CHECK(REGEXP_LIKE(telefono_contacto, '^[0-9]+$'));

/**particulares**/

ALTER TABLE particulares ADD CONSTRAINT CH_par_codigo
CHECK(LENGTH(codigo) = 10 AND codigo LIKE 'p-%' AND REGEXP_LIKE(SUBSTR(codigo, 3, 8), '^[0-9]+$'));

ALTER TABLE particulares ADD CONSTRAINT CH_par_idC
CHECK(LENGTH(idC) = 10 AND REGEXP_LIKE(idC, '^[0-9]+$'));

ALTER TABLE particulares ADD CONSTRAINT CH_par_tidC
CHECK(tidC IN ('cc','ce'));

ALTER TABLE particulares ADD CONSTRAINT CH_par_telefono
CHECK(REGEXP_LIKE(telefono, '^[0-9]+$'));

/**tarjetasP**/

ALTER TABLE tarjetasP ADD CONSTRAINT CH_tarP_codigo
CHECK(LENGTH(codigo) = 10 AND codigo LIKE 'p-%' AND REGEXP_LIKE(SUBSTR(codigo, 3, 8), '^[0-9]+$'));

ALTER TABLE tarjetasP ADD CONSTRAINT CH_tarP_tarjeta
CHECK(LENGTH(tarjeta) = 7 AND REGEXP_LIKE(tarjeta, '^[0-9]+$'));

/**tarjetasV**/

ALTER TABLE tarjetasV ADD CONSTRAINT CH_tarV_codigo
CHECK(codigo LIKE 'SELL-%');

ALTER TABLE tarjetasV ADD CONSTRAINT CH_tarV_tarjeta
CHECK(LENGTH(tarjeta) = 7 AND REGEXP_LIKE(tarjeta, '^[0-9]+$'));


/**Definicion de llave primarias, foraneas y únicas**/

/**materiales**/

ALTER TABLE materiales ADD CONSTRAINT PK_materiales
PRIMARY KEY(codigo);

ALTER TABLE materiales ADD CONSTRAINT AK_materiales
UNIQUE(descripcion);

ALTER TABLE materiales ADD CONSTRAINT FK_materiales
FOREIGN KEY(proveedor) REFERENCES proveedores(empresa);

/**proveedores**/

ALTER TABLE proveedores ADD CONSTRAINT PK_proveedores
PRIMARY KEY(empresa);

/**emailsProv**/

ALTER TABLE emailsprov ADD CONSTRAINT PK_emailsprov
PRIMARY KEY(correo);

ALTER TABLE emailsprov ADD CONSTRAINT FK_emailsprov
FOREIGN KEY(empresa) REFERENCES proveedores(empresa);

/**direccionesProv**/

ALTER TABLE direccionesprov ADD CONSTRAINT PK_direccionesprov
PRIMARY KEY(empresa, direccion);

ALTER TABLE direccionesprov ADD CONSTRAINT FK_direccionesprov
FOREIGN KEY(empresa) REFERENCES proveedores(empresa);

/**componentes**/

ALTER TABLE componentes ADD CONSTRAINT PK_componentes
PRIMARY KEY(codigo);

ALTER TABLE componentes ADD CONSTRAINT AK_componentes
UNIQUE(descripcion);

ALTER TABLE componentes ADD CONSTRAINT FK_componentes_juego
FOREIGN KEY(juego) REFERENCES juegos(nombre);

ALTER TABLE componentes ADD CONSTRAINT FK_componentes_proveedor
FOREIGN KEY(proveedor) REFERENCES proveedores(empresa);

/**operariocomponentes**/

ALTER TABLE operariocomponentes ADD CONSTRAINT PK_operarioscomponentes
PRIMARY KEY(operarioId, operarioTid, componente);

ALTER TABLE operariocomponentes ADD CONSTRAINT FK_opecomp_operario1
FOREIGN KEY(operarioId, operarioTid) REFERENCES operarios(idO, tidO);

ALTER TABLE operariocomponentes ADD CONSTRAINT FK_opecomp_componente
FOREIGN KEY(componente) REFERENCES componentes(codigo);

/**OCmateriales**/

ALTER TABLE OCmateriales ADD CONSTRAINT PK_OCmateriales
PRIMARY KEY(idO, tidO, componente, material);

ALTER TABLE OCmateriales ADD CONSTRAINT FK_OCmateriales1
FOREIGN KEY(idO, tidO, componente) REFERENCES operariocomponentes(operarioId, operarioTid, componente);

/**operarios**/

ALTER TABLE operarios ADD CONSTRAINT PK_operarios
PRIMARY KEY(idO, tidO);

/**categorias**/

ALTER TABLE categorias ADD CONSTRAINT PK_categorias
PRIMARY KEY(nombre);

ALTER TABLE categorias ADD CONSTRAINT AK_categorias
UNIQUE(descripcion);

/**categoriajuego**/

ALTER TABLE categoriajuego ADD CONSTRAINT PK_categoriajuego
PRIMARY KEY(juego, categoria);

ALTER TABLE categoriajuego ADD CONSTRAINT FK_categoriajuego_categoria
FOREIGN KEY(categoria) REFERENCES categorias(nombre);

ALTER TABLE categoriajuego ADD CONSTRAINT FK_categoriajuego_juegos
FOREIGN KEY(juego) REFERENCES juegos(nombre);

/**juegos**/

ALTER TABLE juegos ADD CONSTRAINT PK_juegos
PRIMARY KEY(nombre);

ALTER TABLE juegos ADD CONSTRAINT AK_juegos
UNIQUE(instrucciones);

ALTER TABLE juegos ADD CONSTRAINT FK_juegos_licencia1
FOREIGN KEY(fecha_licencia, contrato_licencia) REFERENCES licencias(fecha, contrato);

/**propuestajuego**/

ALTER TABLE propuestajuego ADD CONSTRAINT PK_propuestajuego
PRIMARY KEY(juego, codigo);

ALTER TABLE propuestajuego ADD CONSTRAINT FK_propuestajuego_juegos
FOREIGN KEY(juego) REFERENCES juegos(nombre);

ALTER TABLE propuestajuego ADD CONSTRAINT FK_propuestajuego_propuesta
FOREIGN KEY(codigo) REFERENCES propuestas(codigo);

/**propuestas**/

ALTER TABLE propuestas ADD CONSTRAINT PK_propuestas
PRIMARY KEY(codigo);

ALTER TABLE propuestas ADD CONSTRAINT AK_propuestas
UNIQUE(descripcion);

/**ideacomponente**/

ALTER TABLE ideacomponente ADD CONSTRAINT PK_ideacomponente
PRIMARY KEY(propuesta, descripcion);

ALTER TABLE ideacomponente ADD CONSTRAINT FK_ideacomponente
FOREIGN KEY(propuesta) REFERENCES propuestas(codigo);

/**disenadorpropuesta**/

ALTER TABLE disenadorpropuesta ADD CONSTRAINT PK_disenadorpropuesta
PRIMARY KEY(disenador, codigo);

ALTER TABLE disenadorpropuesta ADD CONSTRAINT FK_disprop_propuesta
FOREIGN KEY(codigo) REFERENCES propuestas(codigo);

ALTER TABLE disenadorpropuesta ADD CONSTRAINT FK_disprop_disenador
FOREIGN KEY(disenador) REFERENCES disenadores(idD);

/**disenadores**/

ALTER TABLE disenadores ADD CONSTRAINT PK_disenadores
PRIMARY KEY(idD);

/**emailsDis**/

ALTER TABLE emailsdis ADD CONSTRAINT PK_emailsdis
PRIMARY KEY(correo);

ALTER TABLE emailsdis ADD CONSTRAINT FK_emailsdis
FOREIGN KEY(idD) REFERENCES disenadores(idD);

/**licencias**/

ALTER TABLE licencias ADD CONSTRAINT PK_licencias
PRIMARY KEY(fecha, contrato);

ALTER TABLE licencias ADD CONSTRAINT AK_licencias
UNIQUE(descripcion);

ALTER TABLE licencias ADD CONSTRAINT FK_licencias
FOREIGN KEY(editorial) REFERENCES editoriales(duns);

/**editoriales**/

ALTER TABLE editoriales ADD CONSTRAINT PK_editoriales
PRIMARY KEY(duns);

ALTER TABLE editoriales ADD CONSTRAINT AK_editoriales
UNIQUE(nombre);

/**vendedores**/

ALTER TABLE vendedores ADD CONSTRAINT PK_vendedores
PRIMARY KEY(idV, tidV);

/**lineaventas**/

ALTER TABLE lineaventas ADD CONSTRAINT PK_lineaventas
PRIMARY KEY(juego, venta);

ALTER TABLE lineaventas ADD CONSTRAINT FK_lineaventas_juegos
FOREIGN KEY(juego) REFERENCES juegos(nombre);

ALTER TABLE lineaventas ADD CONSTRAINT FK_lineaventas_ventas
FOREIGN KEY(venta) REFERENCES ventas(codigo);

/**ventas**/

ALTER TABLE ventas ADD CONSTRAINT PK_ventas
PRIMARY KEY(codigo);

ALTER TABLE ventas ADD CONSTRAINT FK_ventas_vendedor
FOREIGN KEY(idV, tidV) REFERENCES vendedores(idV, tidV);

ALTER TABLE ventas ADD CONSTRAINT FK_ventas_cliente
FOREIGN KEY(cliente) REFERENCES clientes(codigo);

/**envios**/

ALTER TABLE envios ADD CONSTRAINT PK_envios
PRIMARY KEY(codigo);

ALTER TABLE envios ADD CONSTRAINT FK_envios
FOREIGN KEY(venta) REFERENCES ventas(codigo);

/**clientes**/

ALTER TABLE clientes ADD CONSTRAINT PK_clientes
PRIMARY KEY(codigo);

/**emailsClie**/

ALTER TABLE emailsclie ADD CONSTRAINT PK_emailsclie
PRIMARY KEY(correo);

ALTER TABLE emailsclie ADD CONSTRAINT FK_emailsclie
FOREIGN KEY(codigo) REFERENCES clientes(codigo);

/**tiendas**/

ALTER TABLE tiendas ADD CONSTRAINT PK_tiendas
PRIMARY KEY(codigo);

ALTER TABLE tiendas ADD CONSTRAINT AK_tiendas
UNIQUE(duns);

ALTER TABLE tiendas ADD CONSTRAINT FK_tiendas
FOREIGN KEY(codigo) REFERENCES clientes(codigo);

/**particulares**/

ALTER TABLE particulares ADD CONSTRAINT PK_particulares
PRIMARY KEY(codigo);

ALTER TABLE particulares ADD CONSTRAINT AK_particulares
UNIQUE(idC, tidC);

ALTER TABLE particulares ADD CONSTRAINT FK_particuales
FOREIGN KEY(codigo) REFERENCES clientes(codigo);

/**tarjetasP**/

ALTER TABLE tarjetasP ADD CONSTRAINT PK_tarjetasP
PRIMARY KEY(codigo, tarjeta);

ALTER TABLE tarjetasP ADD CONSTRAINT FK_tarjetasP
FOREIGN KEY(codigo) REFERENCES particulares(codigo);

/**tarjetasV**/

ALTER TABLE tarjetasV ADD CONSTRAINT PK_tarjetasV
PRIMARY KEY(codigo, tarjeta);

ALTER TABLE tarjetasV ADD CONSTRAINT FK_tarjetasV
FOREIGN KEY(codigo) REFERENCES ventas(codigo);


/**PruebasOK**/

INSERT INTO categorias(nombre, descripcion)
VALUES ('Dungeon Crawler', 'explorar y matar');

INSERT INTO editoriales(duns, nombre, cede_principal, email_representante)
VALUES('01-001-0001', 'fantasy flight', 'USA', 'ff666@hotmail.com');

INSERT INTO licencias(fecha, contrato, editorial)
VALUES(TO_DATE('2010-02-12', 'YYYY-MM-DD'), 'https://contrat.pdf', '01-001-0001');

INSERT INTO juegos(nombre, instrucciones, lanzamiento, unidades, previstas, edicion, estado, precio, fecha_licencia, contrato_licencia) 
VALUES('Mansions of madness', 'https://mansmadns.pdf', TO_DATE('2012-02-12', 'YYYY-MM-DD'), 100, 75, 2, 'n', 150, TO_DATE('2010-02-12', 'YYYY-MM-DD'), 'https://contrat.pdf');

INSERT INTO juegos(nombre, instrucciones, lanzamiento, unidades, previstas, edicion, estado, precio) 
VALUES('Ticket to ride', 'https://tickride.pdf', TO_DATE('2009-02-12', 'YYYY-MM-DD'), 174, 7250, 15, 'n', 85);

INSERT INTO propuestas(codigo, descripcion, fecha)
VALUES('Trenes construir', 'construir vias de tren', TO_DATE('2009-01-10', 'YYYY-MM-DD'));

INSERT INTO propuestajuego(juego, codigo)
VALUES('Ticket to ride', 'Trenes construir');

INSERT INTO ideacomponente(propuesta, descripcion)
VALUES('Trenes construir', 'tablero europa');

INSERT INTO disenadores(idD, nombre)
VALUES('1234567891', 'Felipe chicunguna');

INSERT INTO disenadorpropuesta(disenador, codigo)
VALUES('1234567891', 'Trenes construir');

INSERT INTO emailsdis(idD, correo)
VALUES('1234567891', 'cangrejo@gmail.com');

INSERT INTO proveedores(empresa, representante, pais)
VALUES('cartonesDonJose', 'Don Jose', 'Venezuela');

INSERT INTO componentes(codigo, descripcion, unidades, precio, cantidadMinima, juego, proveedor)
VALUES('000000000000001', 'tablero europa', 174, 25, 1, 'Ticket to ride', 'cartonesDonJose');

INSERT INTO emailsprov(empresa, correo)
VALUES('cartonesDonJose', 'donjose@hotmail.com');

INSERT INTO direccionesprov(empresa, direccion)
VALUES('cartonesDonJose', 'cr.57 #66-60');

INSERT INTO proveedores(empresa, representante, pais)
VALUES('plasticosDonmartin', 'Don Martin', 'guinea francesa');

INSERT INTO materiales(codigo, nombre, descripcion, cantidad, precio, proveedor)
VALUES('1', 'plasticoverde', 'plastico maleable verde', 1000, 150,  'plasticosDonmartin');

INSERT INTO operarios(idO, tidO, nombre)
VALUES('0000000002', 'cc', 'Jefferson cossio');

INSERT INTO componentes(codigo, descripcion, unidades, cantidadMinima, juego)
VALUES('000000000000002', 'Cthulu verde feo 25mm2', 100, 1, 'Mansions of madness');

INSERT INTO operariocomponentes(operarioId, operarioTid, componente, unidades)
VALUES('0000000002', 'cc', '000000000000002', 100);

INSERT INTO OCmateriales(idO, tidO, componente, material)
VALUES('0000000002', 'cc', '000000000000002', '1');

INSERT INTO vendedores(idV, tidV, nombre, correo)
VALUES('0000000003', 'ce', 'El diego', 'manodeDios@hotmail.com');

INSERT INTO clientes(codigo, direccion, codigo_postal)
VALUES('p-00000001', 'cr.57 #66-60', '110110');

INSERT INTO clientes(codigo, direccion, codigo_postal)
VALUES('t-00000001', 'cr.63 #10-18', '001001');

INSERT INTO tiendas(codigo, duns, empresa, contacto, telefono_contacto)
VALUES('t-00000001', '01-001-0002', 'Justo y Bueno', 'DonJusto', '7772133217');

INSERT INTO particulares(codigo, idC, tidC, nombre)
VALUES('p-00000001', '0000000004', 'ce', 'Michael Schumagger');

INSERT INTO tarjetasP(codigo, tarjeta)
VALUES('p-00000001', '7777777');

INSERT INTO emailsclie(codigo, correo)
VALUES('t-00000001', 'justico@hotmail.com');

INSERT INTO ventas(codigo, fecha, tipo_pago, monto, estado, idV, tidV, cliente)
VALUES('SELL-1', TO_DATE('2015-02-12', 'YYYY-MM-DD'), 'tr', 150, 'ap', '0000000003', 'ce', 'p-00000001');

INSERT INTO lineaventas(juego, venta, unidades)
VALUES('Mansions of madness', 'SELL-1', 1);

INSERT INTO tarjetasV(codigo, tarjeta)
VALUES('SELL-1', '7777777');

INSERT INTO envios(codigo, empresa, direccion, barrio, departamento, descripcion, costo, venta)
VALUES('SEND-1', 'rappi almuerzos', 'cr.76 #16-58', 'LosAbandonados', 'El choco', 'casa sin techo', 25, 'SELL-1');

INSERT INTO categoriajuego(juego, categoria)
VALUES('Mansions of madness', 'Dungeon Crawler');


/**EliminacionPruebas
NOTA: dejaremos comentada toda esta parte del código, para evitar problemas.
**/

/**
DELETE FROM emailsclie;

DELETE FROM emailsdis;

DELETE FROM emailsprov;

DELETE FROM direccionesprov;

DELETE FROM envios;

DELETE FROM tarjetasV;

DELETE FROM tarjetasP;

DELETE FROM particulares;

DELETE FROM tiendas;

DELETE FROM lineaventas;

DELETE FROM disenadorpropuesta;

DELETE FROM propuestajuego;

DELETE FROM disenadores;

DELETE FROM ideacomponente;

DELETE FROM propuestas;

DELETE FROM ventas;

DELETE FROM clientes;

DELETE FROM vendedores;

DELETE FROM categoriajuego;

DELETE FROM categorias;

DELETE FROM materiales;

DELETE FROM OCmateriales;

DELETE FROM operariocomponentes;

DELETE FROM operarios;

DELETE FROM proveedores;

DELETE FROM componentes;

DELETE FROM juegos;

DELETE FROM licencias;

DELETE FROM editoriales;

**/

/**Eliminacion de tablas
NOTA: para ejecutar estas sentencias, primero ha de elimiar todas las claves primarias y foraneas de la base.**/

DROP TABLE categoriajuego;
DROP TABLE categorias;
DROP TABLE clientes;
DROP TABLE componentes;
DROP TABLE direccionesprov;
DROP TABLE disenador;
DROP TABLE disenadorpropuesta;
DROP TABLE editoriales;
DROP TABLE emailsdis;
DROP TABLE emailsclie;
DROP TABLE emailsprov;
DROP TABLE envios;
DROP TABLE ideacomponente;
DROP TABLE juegos;
DROP TABLE licencias;
DROP TABLE lineaventas;
DROP TABLE materiales;
DROP TABLE ocmateriales;
DROP TABLE operariocomponentes;
DROP TABLE operarios;
DROP TABLE particulares;
DROP TABLE propuestajuego;
DROP TABLE propuestas;
DROP TABLE tarjetasP;
DROP TABLE tarjetasV;
DROP TABLE tiendas;
DROP TABLE vendedores;
DROP TABLE ventas;



/****/
ALTER TABLE ocmateriales
ADD cantidad NUMBER(9,2);

ALTER TABLE ocmateriales ADD CONSTRAINT CH_cantidadOCmat
CHECK(cantidad > 0);