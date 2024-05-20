/**Proyecto TertulianoBG
   Estudiantes: Daniel Alejandro Rodriguez Baracaldo - Juan Pablo Vélez Muñoz.
   Profesor: Rodrigo Humberto Gualtero Martinez
   MBDA - G1.
   Componentes.**/

/**consumidores**/

CREATE OR REPLACE PACKAGE consumidor AS
    PROCEDURE insertar_cliente(
        p_codigo VARCHAR2,
        p_direccion VARCHAR2,
        p_codigo_postal VARCHAR2,
        p_duns VARCHAR2,
        p_empresa VARCHAR2,
        p_contacto VARCHAR2,
        p_telefono_contacto VARCHAR2,
        p_idC VARCHAR2,
        p_tidC VARCHAR2,
        p_nombre VARCHAR2,
        p_telefono VARCHAR2
    );
    
    FUNCTION consultar_cliente(p_codigo VARCHAR2) RETURN VARCHAR2;
END consumidor;

CREATE OR REPLACE PACKAGE BODY consumidor AS
    PROCEDURE insertar_cliente(
        p_codigo VARCHAR2,
        p_direccion VARCHAR2,
        p_codigo_postal VARCHAR2,
        p_duns VARCHAR2,
        p_empresa VARCHAR2,
        p_contacto VARCHAR2,
        p_telefono_contacto VARCHAR2,
        p_idC VARCHAR2,
        p_tidC VARCHAR2,
        p_nombre VARCHAR2,
        p_telefono VARCHAR2
    ) IS
    BEGIN
        INSERT INTO clientes (codigo, direccion, codigo_postal)
        VALUES (p_codigo, p_direccion, p_codigo_postal);
        
        IF p_duns IS NOT NULL AND p_empresa IS NOT NULL AND p_contacto IS NOT NULL AND p_telefono_contacto IS NOT NULL THEN
            INSERT INTO tiendas (codigo, duns, empresa, contacto, telefono_contacto)
            VALUES (p_codigo, p_duns, p_empresa, p_contacto, p_telefono_contacto);
        ELSIF p_idC IS NOT NULL AND p_tidC IS NOT NULL AND p_nombre IS NOT NULL AND p_telefono IS NOT NULL THEN
            INSERT INTO particulares (codigo, idC, tidC, nombre, telefono)
            VALUES (p_codigo, p_idC, p_tidC, p_nombre, p_telefono);
        END IF;
    END insertar_cliente;
    
    FUNCTION consultar_cliente(p_codigo VARCHAR2) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
        SELECT *
        FROM clientes
        WHERE codigo = p_codigo;
        
        RETURN v_cursor;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
    END consultar_cliente;
END consumidor;

/**Produccion**/

CREATE OR REPLACE PACKAGE produccion AS
    -- Procedimientos para Proveedores
    PROCEDURE insertar_proveedor_material(
        p_empresa VARCHAR2, 
        p_telefono VARCHAR2, 
        p_representante VARCHAR2, 
        p_pais VARCHAR2, 
        p_codigo VARCHAR2, 
        p_nombre VARCHAR2, 
        p_descripcion VARCHAR2, 
        p_cantidad NUMBER, 
        p_precio NUMBER);

    PROCEDURE insertar_proveedor_componente(
        p_empresa VARCHAR2, 
        p_telefono VARCHAR2, 
        p_representante VARCHAR2, 
        p_pais VARCHAR2, 
        p_codigo VARCHAR2, 
        p_descripcion VARCHAR2, 
        p_unidades NUMBER, 
        p_precio NUMBER, 
        p_cantidadMinima NUMBER, 
        p_juego VARCHAR2);

    PROCEDURE modificar_proveedor(
        p_empresa VARCHAR2, 
        p_telefono VARCHAR2, 
        p_representante VARCHAR2, 
        p_pais VARCHAR2);

    PROCEDURE consultar_proveedor_material(
        p_empresa VARCHAR2);

    PROCEDURE consultar_proveedor_componente(
        p_empresa VARCHAR2);

    -- Procedimientos para Materiales
    PROCEDURE insertar_material(
        p_codigo VARCHAR2, 
        p_nombre VARCHAR2, 
        p_descripcion VARCHAR2, 
        p_cantidad NUMBER, 
        p_precio NUMBER, 
        p_proveedor VARCHAR2);

    PROCEDURE modificar_material(
        p_codigo VARCHAR2, 
        p_nombre VARCHAR2, 
        p_descripcion VARCHAR2, 
        p_cantidad NUMBER, 
        p_precio NUMBER);

    -- Procedimientos para Operarios
    PROCEDURE insertar_operario(
        p_idO VARCHAR2, 
        p_tidO VARCHAR2, 
        p_nombre VARCHAR2);

    PROCEDURE modificar_operario(
        p_idO VARCHAR2, 
        p_tidO VARCHAR2, 
        p_nombre VARCHAR2);

    PROCEDURE eliminar_operario(
        p_idO VARCHAR2, 
        p_tidO VARCHAR2);

    -- Procedimientos para Componentes
    PROCEDURE insertar_componente(
        p_codigo VARCHAR2, 
        p_descripcion VARCHAR2, 
        p_unidades NUMBER, 
        p_precio NUMBER, 
        p_cantidadMinima NUMBER, 
        p_juego VARCHAR2, 
        p_proveedor VARCHAR2, 
        p_operarioId VARCHAR2, 
        p_operarioTid VARCHAR2, 
        p_operarioNombre VARCHAR2);

    PROCEDURE modificar_componente(
        p_codigo VARCHAR2, 
        p_descripcion VARCHAR2, 
        p_unidades NUMBER, 
        p_precio NUMBER, 
        p_cantidadMinima NUMBER, 
        p_juego VARCHAR2);

    PROCEDURE consultar_componente(
        p_codigo VARCHAR2);
END produccion;
/

CREATE OR REPLACE PACKAGE BODY produccion AS
    -- Procedimientos para Proveedores
    PROCEDURE insertar_proveedor_material(
        p_empresa VARCHAR2, 
        p_telefono VARCHAR2, 
        p_representante VARCHAR2, 
        p_pais VARCHAR2, 
        p_codigo VARCHAR2, 
        p_nombre VARCHAR2, 
        p_descripcion VARCHAR2, 
        p_cantidad NUMBER, 
        p_precio NUMBER) IS
    BEGIN
        INSERT INTO proveedores(empresa, telefono, representante, pais)
        VALUES (p_empresa, p_telefono, p_representante, p_pais);

        INSERT INTO materiales (codigo, nombre, descripcion, cantidad, precio, proveedor)
        VALUES (p_codigo, p_nombre, p_descripcion, p_cantidad, p_precio, p_empresa);
    END insertar_proveedor_material;

    PROCEDURE insertar_proveedor_componente(
        p_empresa VARCHAR2, 
        p_telefono VARCHAR2, 
        p_representante VARCHAR2, 
        p_pais VARCHAR2, 
        p_codigo VARCHAR2, 
        p_descripcion VARCHAR2, 
        p_unidades NUMBER, 
        p_precio NUMBER, 
        p_cantidadMinima NUMBER, 
        p_juego VARCHAR2) IS
    BEGIN
        INSERT INTO proveedores (empresa, telefono, representante, pais)
        VALUES (p_empresa, p_telefono, p_representante, p_pais);

        INSERT INTO componentes (codigo, descripcion, unidades, precio, cantidadMinima, juego, proveedor)
        VALUES (p_codigo, p_descripcion, p_unidades, p_precio, p_cantidadMinima, p_juego, p_empresa);
    END insertar_proveedor_componente;

    PROCEDURE modificar_proveedor(
        p_empresa VARCHAR2, 
        p_telefono VARCHAR2, 
        p_representante VARCHAR2, 
        p_pais VARCHAR2) IS
    BEGIN
        UPDATE Proveedor
        SET telefono = p_telefono, representante = p_representante, pais = p_pais
        WHERE empresa = p_empresa;
    END modificar_proveedor;

    PROCEDURE consultar_proveedor_material(
        p_empresa VARCHAR2) IS
        CURSOR c_material IS
            SELECT m.codigo, m.nombre, m.descripcion, m.cantidad, m.precio
            FROM Materiales m
            WHERE m.proveedor = p_empresa;

        v_material c_material%ROWTYPE;
    BEGIN
        OPEN c_material;
        LOOP
            FETCH c_material INTO v_material;
            EXIT WHEN c_material%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('Codigo: ' || v_material.codigo || ', Nombre: ' || v_material.nombre ||
                                 ', Descripcion: ' || v_material.descripcion || ', Cantidad: ' || v_material.cantidad ||
                                 ', Precio: ' || v_material.precio);
        END LOOP;
        CLOSE c_material;
    END consultar_proveedor_material;

    PROCEDURE consultar_proveedor_componente(
        p_empresa VARCHAR2) IS
        CURSOR c_componente IS
            SELECT c.codigo, c.descripcion, c.unidades, c.precio, c.cantidadMinima, c.juego
            FROM componentes c
            WHERE c.proveedor = p_empresa;

        v_componente c_componente%ROWTYPE;
    BEGIN
        OPEN c_componente;
        LOOP
            FETCH c_componente INTO v_componente;
            EXIT WHEN c_componente%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('Codigo: ' || v_componente.codigo || ', Descripcion: ' || v_componente.descripcion ||
                                 ', Unidades: ' || v_componente.unidades || ', Precio: ' || v_componente.precio ||
                                 ', Cantidad Minima: ' || v_componente.cantidadMinima || ', Juego: ' || v_componente.juego);
        END LOOP;
        CLOSE c_componente;
    END consultar_proveedor_componente;

    -- Procedimientos para Materiales
    PROCEDURE insertar_material(
        p_codigo VARCHAR2, 
        p_nombre VARCHAR2, 
        p_descripcion VARCHAR2, 
        p_cantidad NUMBER, 
        p_precio NUMBER, 
        p_proveedor VARCHAR2) IS
    BEGIN
        INSERT INTO materiales (codigo, nombre, descripcion, cantidad, precio, proveedor)
        VALUES (p_codigo, p_nombre, p_descripcion, p_cantidad, p_precio, p_proveedor);
    END insertar_material;

    PROCEDURE modificar_material(
        p_codigo VARCHAR2, 
        p_nombre VARCHAR2, 
        p_descripcion VARCHAR2, 
        p_cantidad NUMBER, 
        p_precio NUMBER) IS
    BEGIN
        UPDATE materiales
        SET nombre = p_nombre, descripcion = p_descripcion, cantidad = p_cantidad, precio = p_precio
        WHERE codigo = p_codigo;
    END modificar_material;

    -- Procedimientos para Operarios
    PROCEDURE insertar_operario(
        p_idO VARCHAR2, 
        p_tidO VARCHAR2, 
        p_nombre VARCHAR2) IS
    BEGIN
        INSERT INTO Operario (idO, tidO, nombre)
        VALUES (p_idO, p_tidO, p_nombre);
    END insertar_operario;

    PROCEDURE modificar_operario(
        p_idO VARCHAR2, 
        p_tidO VARCHAR2, 
        p_nombre VARCHAR2) IS
    BEGIN
        UPDATE Operario
        SET nombre = p_nombre
        WHERE idO = p_idO AND tidO = p_tidO;
    END modificar_operario;

    PROCEDURE eliminar_operario(
        p_idO VARCHAR2, 
        p_tidO VARCHAR2) IS
    BEGIN
        DELETE FROM Operario
        WHERE idO = p_idO AND tidO = p_tidO;
    END eliminar_operario;

    -- Procedimientos para Componentes
    PROCEDURE insertar_componente(
        p_codigo VARCHAR2, 
        p_descripcion VARCHAR2, 
        p_unidades NUMBER, 
        p_precio NUMBER, 
        p_cantidadMinima NUMBER, 
        p_juego VARCHAR2, 
        p_proveedor VARCHAR2, 
        p_operarioId VARCHAR2, 
        p_operarioTid VARCHAR2, 
        p_operarioNombre VARCHAR2) IS
    BEGIN
        INSERT INTO componentes (codigo, descripcion, unidades, precio, cantidadMinima, juego, proveedor, operarioId, operarioTid, operarioNombre)
        VALUES (p_codigo, p_descripcion, p_unidades, p_precio, p_cantidadMinima, p_juego, p_proveedor, p_operarioId, p_operarioTid, p_operarioNombre);
    END insertar_componente;

    PROCEDURE modificar_componente(
        p_codigo VARCHAR2, 
        p_descripcion VARCHAR2, 
        p_unidades NUMBER, 
        p_precio NUMBER, 
        p_cantidadMinima NUMBER, 
        p_juego VARCHAR2) IS
    BEGIN
        UPDATE Componentes
        SET descripcion = p_descripcion, unidades = p_unidades, precio = p_precio, cantidadMinima = p_cantidadMinima, juego = p_juego
        WHERE codigo = p_codigo;
    END modificar_componente;

    PROCEDURE consultar_componente(
        p_codigo VARCHAR2) IS
        CURSOR c_componente IS
            SELECT codigo, descripcion, unidades, precio, cantidadMinima, juego
            FROM componentes
            WHERE codigo = p_codigo;

        v_componente c_componente%ROWTYPE;
    BEGIN
        OPEN c_componente;
        LOOP
            FETCH c_componente INTO v_componente;
            EXIT WHEN c_componente%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('Codigo: ' || v_componente.codigo || ', Descripcion: ' || v_componente.descripcion ||
                                 ', Unidades: ' || v_componente.unidades || ', Precio: ' || v_componente.precio ||
                                 ', Cantidad Minima: ' || v_componente.cantidadMinima || ', Juego: ' || v_componente.juego);
        END LOOP;
        CLOSE c_componente;
    END consultar_componente;
END produccion;