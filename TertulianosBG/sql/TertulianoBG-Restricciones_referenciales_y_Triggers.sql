/**Proyecto TertulianoBG
   Estudiantes: Daniel Alejandro Rodriguez Baracaldo - Juan Pablo Vélez Muñoz.
   Profesor: Rodrigo Humberto Gualtero Martinez
   MBDA - G1.
   Restricciones declarativas y Triggers.**/
   
/**acciones referenciales**/

/**vendedores-venta**/

ALTER TABLE ventas DROP CONSTRAINT FK_ventas_vendedor;

ALTER TABLE ventas ADD CONSTRAINT FK_ventas_vendedor
FOREIGN KEY(idV, tidV) REFERENCES vendedores(idV, tidV)
ON DELETE SET NULL;

/**ventas-envios**/

ALTER TABLE envios DROP CONSTRAINT FK_envios;

ALTER TABLE envios ADD CONSTRAINT FK_envios
FOREIGN KEY(venta) REFERENCES ventas(codigo)
ON DELETE CASCADE;

/**ventas-lineaventas**/

ALTER TABLE lineaventas DROP CONSTRAINT FK_lineaventas_ventas;

ALTER TABLE lineaventas ADD CONSTRAINT FK_lineaventas_ventas
FOREIGN KEY(venta) REFERENCES ventas(codigo)
ON DELETE CASCADE;

/**proveedores-componente**/

ALTER TABLE componentes DROP CONSTRAINT FK_componentes_proveedores;

ALTER TABLE componentes ADD CONSTRAINT FK_componentes_proveedores
FOREIGN KEY(proveedor) REFERENCES proveedores(empresa)
ON DELETE SET NULL;

/**Aserciones generales**/

/**El juego ya se puede lanzar, ya ha pasado su lanzamiento**/
CREATE OR REPLACE TRIGGER T_juegoVender
BEFORE INSERT ON lineaventas
FOR EACH ROW
DECLARE
    lanz DATE;
    fecha_v DATE;
BEGIN
    SELECT lanzamiento INTO lanz
    FROM juegos
    WHERE :NEW.juego = nombre;
    
    SELECT fecha INTO fecha_v
    FROM ventas
    WHERE codigo = :NEW.venta;
    
    IF lanz > fecha_v 
    THEN RAISE_APPLICATION_ERROR(-20000, 'no se pueden vender juegos antes de su fecha de lanzamiento.');
    END IF;
        
END;

/**Los siguientes dos se encargan de verificar que el juego este en producción antes de que se le agregen más componentes para más unidades**/

CREATE OR REPLACE TRIGGER T_fueradeproduccion
BEFORE UPDATE ON operariocomponentes
FOR EACH ROW
DECLARE
    act VARCHAR2(1);
BEGIN
    SELECT estado INTO act
    FROM componentes JOIN juegos ON componentes.juego = juegos.nombre JOIN operariocomponentes ON componentes.codigo = operariocomponentes.componente
    WHERE :OLD.componente = operariocomponentes.componente;
    
    IF act = 'n'
    THEN RAISE_APPLICATION_ERROR(-20001, 'El juego ya no está en produccion por ello no se producen más componentes de este.');
    END IF;
END;

CREATE OR REPLACE TRIGGER T_fueradeproduccion2
BEFORE INSERT ON operariocomponentes
FOR EACH ROW
DECLARE
    act VARCHAR2(1);
BEGIN
    SELECT estado INTO act
    FROM componentes JOIN juegos ON componentes.juego = juegos.nombre JOIN operariocomponentes ON componentes.codigo = operariocomponentes.componente
    WHERE :NEW.componente = operariocomponentes.componente;
    
    IF act = 'n'
    THEN RAISE_APPLICATION_ERROR(-20002, 'El juego ya no está en produccion por ello no se producen más componentes de este.');
    END IF;
END; 

/**el siguiente trigger sólo permite borrar ventas que han sido rechazadas**/

CREATE OR REPLACE TRIGGER T_eliminarventa
BEFORE DELETE ON ventas
FOR EACH ROW
BEGIN
    IF :OLD.estado = 'ap'
    THEN RAISE_APPLICATION_ERROR(-20003, 'No se pueden borrar ventas que hayan sido aprobadas.');
    END IF;
END;

/**Triggers del XOR**/

CREATE OR REPLACE TRIGGER T_XORcomponentes
BEFORE INSERT ON componentes
FOR EACH ROW
DECLARE
    prov NUMBER(9);    
BEGIN
    SELECT COUNT(componentes.proveedor) INTO prov
    FROM (componentes JOIN proveedores  ON componentes.proveedor = proveedores.empresa) JOIN materiales ON proveedores.empresa = materiales.proveedor;
    
    IF prov != 0
    THEN RAISE_APPLICATION_ERROR(-20004, 'se violo el XOR del modelo.');
    END IF;
END;

CREATE OR REPLACE TRIGGER T_XORmateriales
BEFORE INSERT ON materiales
FOR EACH ROW
DECLARE
    prov NUMBER(9);    
BEGIN
    SELECT COUNT(materiales.proveedor) INTO prov
    FROM (componentes JOIN proveedores  ON componentes.proveedor = proveedores.empresa) JOIN materiales ON proveedores.empresa = materiales.proveedor;
    
    IF prov != 0
    THEN RAISE_APPLICATION_ERROR(-20004, 'se violo el XOR del modelo.');
    END IF;
END;

/**precio envio**/

CREATE OR REPLACE TRIGGER T_precioenvio
BEFORE INSERT ON envios
FOR EACH ROW
DECLARE
    mon NUMBER(7,2);
BEGIN
    SELECT monto INTO mon
    FROM ventas 
    WHERE codigo = :NEW.venta;
    
    INSERT INTO envios(codigo, empresa, direccion, barrio, departamento, descripcion, costo, venta)
    VALUES(:NEW.codigo, :NEW.empresa, :NEW.direccion, :NEW.barrio, :NEW.departamento, :NEW.descripcion, mon, :NEW.venta);
END;

/**montoVenta**/

CREATE OR REPLACE TRIGGER T_montoVenta
AFTER INSERT ON lineaventas
FOR EACH ROW
DECLARE
    total NUMBER(7,2);
    mon NUMBER(7,2);
BEGIN
    SELECT SUM(juegos.precio*lineaventas.unidades) INTO total
    FROM (lineaventas JOIN juegos ON lineaventas.juego = juegos.nombre)
    WHERE lineaventas.venta = :NEW.venta;
    
    SELECT monto INTO mon
    FROM ventas
    WHERE codigo = :NEW.venta;
    
    IF total != mon
    THEN RAISE_APPLICATION_ERROR(-20005, 'El monto de la venta no corresponde a los precios por las unidades de los juegos a comprar.');
    END IF;
END;

/**actualizarjuego**/

CREATE OR REPLACE TRIGGER T_actualizarjuego
BEFORE UPDATE ON juegos
FOR EACH ROW
BEGIN
    IF :NEW.estado != :OLD.estado AND :OLD.unidades > 0
    THEN RAISE_APPLICATION_ERROR(-20006, 'No se pueden reeditar juegos que aún no han sido completamente vendidos.');
    END IF;
END;

//**Triggers reglas de negocio**//

/**al venderse un juego se reduce la cantidad de unidades del juego y de componentes**/
CREATE OR REPLACE TRIGGER T_restarunidades
AFTER INSERT ON lineaventas
FOR EACH ROW
BEGIN
    UPDATE juegos
    SET unidades = unidades - :NEW.unidades
    WHERE nombre = :NEW.juego;
    
    UPDATE componentes
    SET unidades = unidades - (:NEW.unidades*cantidadMinima)
    WHERE juego = :NEW.juego;
END;

/**vender juegos que tienen unidades disponibles**/

CREATE OR REPLACE TRIGGER T_hayunidades
BEFORE INSERT ON lineaventas
FOR EACH ROW
DECLARE
    uni NUMBER(7);
BEGIN
    SELECT unidades INTO uni
    FROM juegos
    WHERE nombre = :NEW.juego;
    
    IF uni < :NEW.unidades
    THEN RAISE_APPLICATION_ERROR(-20007,'No hay suficientes unidades del juego.');
    END IF;
END;