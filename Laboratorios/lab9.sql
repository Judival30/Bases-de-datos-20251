SET SERVEROUTPUT ON;

--1
CREATE OR REPLACE PROCEDURE lstProd IS

    CURSOR c_productos IS
        SELECT c.cc, c.nombre, p.descripcion, co.fecha, co.cantidad
        FROM Cliente c 
        JOIN Compra co ON c.cc = co.cc
        JOIN Producto p ON co.prod = p.cod
        WHERE EXTRACT(YEAR FROM co.fecha) IN (2024, 2025);

BEGIN
   

    FOR it IN c_productos LOOP
        DBMS_OUTPUT.PUT_LINE(
            it.cc || ' | ' ||
            RPAD(it.nombre, 20) || ' | ' ||
            RPAD(it.descripcion, 20) || ' | ' ||
            TO_CHAR(it.fecha, 'DD-MM-YYYY') || ' | ' ||
            it.cantidad
        );
    END LOOP;

END;
/

BEGIN
    lstProd;
END;


-- 2
CREATE OR REPLACE PROCEDURE lstClientesCiudad(codc CHAR) IS

    CURSOR c_clientes IS
        SELECT c.cc, c.nombre, c.descuento, ci.nombre AS nombre_ciudad
        FROM Cliente c
        JOIN Ciudad ci ON c.codCiud = ci.codCiud
        WHERE ci.codCiud = codc;

BEGIN
 
    FOR it IN c_clientes LOOP
        DBMS_OUTPUT.PUT_LINE(
            it.cc || ' | ' ||
            RPAD(it.nombre, 20) || ' | ' ||
            LPAD(it.descuento, 9) || ' | ' ||
            it.nombre_ciudad
        );
    END LOOP;

END;
/

BEGIN
    lstClientesCiudad('05001');
END;

-- 3
CREATE OR REPLACE PROCEDURE resumen_compras_producto IS
    CURSOR c_resumen IS
        SELECT p.cod, p.descripcion, SUM(co.cantidad) AS total_vendido
        FROM Producto p
        JOIN Compra co ON p.cod = co.prod
        GROUP BY p.cod, p.descripcion
        ORDER BY p.cod;

 
    v_resumen c_resumen%ROWTYPE;

BEGIN
   
    OPEN c_resumen;

    LOOP
        FETCH c_resumen INTO v_resumen;

        EXIT WHEN c_resumen%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            LPAD(v_resumen.cod, 8) || ' | ' ||
            RPAD(v_resumen.descripcion, 25) || ' | ' ||
            v_resumen.total_vendido
        );
    END LOOP;

    CLOSE c_resumen;

END;
/

BEGIN
    resumen_compras_producto;
END;
-- 4 

CREATE OR REPLACE FUNCTION simular_compra_masiva(pcod IN NUMBER, pdes  IN NUMBER) RETURN NUMBER IS

    v_precio_producto   Producto.precio%TYPE;
    v_descuento_total   NUMBER := 0;

    CURSOR c_clientes IS
        SELECT cc, codCiud 
        FROM Cliente;

    v_cliente c_clientes%ROWTYPE;
    v_descuento_cliente NUMBER;

BEGIN
    SELECT precio INTO v_precio_producto
    FROM Producto
    WHERE cod = pcod;

    OPEN c_clientes;

    LOOP
        FETCH c_clientes INTO v_cliente;
        EXIT WHEN c_clientes%NOTFOUND;

        IF v_cliente.codCiud = '76001' THEN
            v_descuento_cliente := v_precio_producto * (pdes / 100);
        ELSE
            v_descuento_cliente := v_precio_producto * 0.01;
        END IF;

        v_descuento_total := v_descuento_total + v_descuento_cliente;
    END LOOP;

    CLOSE c_clientes;

    RETURN v_descuento_total;

END;

DECLARE
    v_total_descuento NUMBER;
BEGIN
    v_total_descuento := simular_compra_masiva(101, 15);
    DBMS_OUTPUT.PUT_LINE('Total de descuentos aplicados: ' || v_total_descuento);
END;
/
-- 5
CREATE OR REPLACE PROCEDURE listar_clientes_por_ciudad IS

    CURSOR c_ciudades IS
        SELECT codCiud, nombre FROM Ciudad ORDER BY nombre;

    CURSOR c_clientes(p_cod_ciud CHAR) IS
        SELECT cc, nombre FROM Cliente
        WHERE codCiud = p_cod_ciud
        ORDER BY nombre;

    v_ciudad c_ciudades%ROWTYPE;
    v_cliente c_clientes%ROWTYPE;
    v_total_ciudad NUMBER;
    v_total_general NUMBER := 0;

BEGIN
    OPEN c_ciudades;

    LOOP
        FETCH c_ciudades INTO v_ciudad;
        EXIT WHEN c_ciudades%NOTFOUND;

        v_total_ciudad := 0;

        OPEN c_clientes(v_ciudad.codCiud);

        LOOP
            FETCH c_clientes INTO v_cliente;
            EXIT WHEN c_clientes%NOTFOUND;

            DBMS_OUTPUT.PUT_LINE('  ' || v_cliente.cc || ' - ' || v_cliente.nombre);
            v_total_ciudad := v_total_ciudad + 1;
            v_total_general := v_total_general + 1;
        END LOOP;

        CLOSE c_clientes;

    END LOOP;

    CLOSE c_ciudades;

   

END;
/

BEGIN
    listar_clientes_por_ciudad;
END;

CREATE OR REPLACE TRIGGER trg_cliente_log_cambios
AFTER INSERT OR DELETE ON Cliente
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        DBMS_OUTPUT.PUT_LINE('Se ha agregado un nuevo cliente: ' || :NEW.cc || ' - ' || :NEW.nombre);
    ELSIF DELETING THEN
        DBMS_OUTPUT.PUT_LINE('Se ha eliminado un cliente: ' || :OLD.cc || ' - ' || :OLD.nombre);
    END IF;
END;
/

INSERT INTO Cliente (cc, nombre, direccion, descuento, codCiud)
VALUES (1234567890, 'Fedemending', 'Calle 100 #50-20', 5.5, '11001');

DELETE FROM Cliente
WHERE cc = 1234567890;
--7

CREATE OR REPLACE TRIGGER trg_advertencia_ciudad
BEFORE INSERT ON Ciudad
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('Advertencia: Asegúrese de que la ciudad "' || :NEW.nombre || '" pertenece a COLOMBIA.');
END;
/

INSERT INTO Ciudad (codCiud, nombre)
VALUES ('99999', 'Ciudad Ficticia');
