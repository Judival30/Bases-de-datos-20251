-- 1
SET SERVEROUTPUT ON;

DECLARE
    ans NUMBER;
BEGIN
    SELECT COUNT(DISTINCT prod)
    INTO ans
    FROM compra
    WHERE cc = 1107000001;

    DBMS_OUTPUT.PUT_LINE('Total de productos diferentes: ' || ans);
END;


--2
CREATE OR REPLACE FUNCTION diffProdClient(ced NUMBER)
RETURN NUMBER
IS
    ans NUMBER;
BEGIN
    SELECT COUNT(DISTINCT prod)
    INTO ans
    FROM compra
    WHERE cc = ced;

    RETURN ans;
END;

DECLARE
    ans NUMBER;
BEGIN
    ans := diffProdClient(1107000001);
    DBMS_OUTPUT.PUT_LINE('Resultado de la funcion: ' || ans);
END;

-- 3
CREATE OR REPLACE PROCEDURE actDescuento(ced NUMBER)
AS
    ans NUMBER;
BEGIN
    SELECT COUNT(*) INTO ans
    FROM compra
    WHERE cc = ced;

    IF ans > 5 THEN
        UPDATE cliente
        SET descuento = 2 
        WHERE cc = ced;

        DBMS_OUTPUT.PUT_LINE('Se actualizó el descuento.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('El cliente tiene menos de 5 productos, no cumple con el requisito.');
    END IF;
END;
    

BEGIN
    actDescuento(1107000001);
END;

-- 4
CREATE OR REPLACE FUNCTION totComprasClienteCC(ced NUMBER)
RETURN NUMBER
AS
    ans NUMBER := 0;
BEGIN
    SELECT SUM(precio * cantidad)
    INTO ans
    FROM compra
    WHERE cc = ced;
    RETURN ans;
END;

DECLARE
    ans NUMBER;
BEGIN
    ans := totComprasClienteCC(1107000001);
    DBMS_OUTPUT.PUT_LINE('Resultado de la funcion: ' || ans);
END;

--5
CREATE OR REPLACE FUNCTION contProdClientes(cod NUMBER)
RETURN NUMBER
AS
    ans NUMBER;
BEGIN
    SELECT COUNT(DISTINCT cc)
    INTO ans
    FROM compra
    WHERE prod = cod;

    RETURN ans;
END;


DECLARE
    ans NUMBER;
BEGIN
    ans := contProdClientes(101);
    DBMS_OUTPUT.PUT_LINE('Producto 101 lo compraron: ' || ans);
END;

-- 6
CREATE OR REPLACE PROCEDURE actPreciosRangos
IS
    CURSOR lst IS
        SELECT cod, precio FROM producto FOR UPDATE;

    vprecio producto.precio%TYPE;
    vcod producto.cod%TYPE;
    r1 NUMBER := 0;
    r2 NUMBER := 0;
    r3 NUMBER := 0;
BEGIN
    FOR i IN lst LOOP
        vcod := i.cod;
        vprecio := i.precio;

        IF vprecio < 1000000 THEN
            UPDATE producto SET precio = precio * 1.05 WHERE cod = vcod;
            r1 := r1 + 1;

        ELSIF vprecio BETWEEN 1000001 AND 2000000 THEN
            UPDATE producto SET precio = precio * 1.03 WHERE cod = vcod;
            r2 := r2 + 1;

        ELSIF vprecio > 2000000 THEN
            UPDATE producto SET precio = precio * 1.015 WHERE cod = vcod;
            r3 := r3 + 1;
        END IF;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Productos actualizados por rango: menor a 1M: ' || r1 || ', entre 1M-2M: ' || r2 || ', mayor a 2M: ' || r3);
END;



BEGIN
    actPreciosRangos();
END;


-- 7
CREATE OR REPLACE FUNCTION tiene_desc(ced NUMBER) 
RETURN VARCHAR2 
IS
  cantidad NUMBER;
BEGIN
  SELECT COUNT(*) 
    INTO cantidad
    FROM compra
   WHERE cc = ced;
    
  IF cantidad > 3 THEN
    RETURN 'SI';
  ELSE
    RETURN 'NO';
  END IF;
END;

DECLARE
    ans VARCHAR2;
BEGIN
    ans := tieneDescuento(1107000001);
    DBMS_OUTPUT.PUT_LINE('Resultado de la funcion: ' || ans);
END;
--8
CREATE OR REPLACE PROCEDURE lstProd(ced NUMBER) IS
    CURSOR c_productos IS
        SELECT p.descripcion
        FROM Compra 
        NATURAL JOIN Producto
        WHERE c.cc = ced;
    
    v_producto Producto.descripcion%TYPE;
BEGIN
    OPEN c_productos;
    LOOP
        FETCH c_productos INTO v_producto;
        EXIT WHEN c_productos%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Producto comprado: ' || v_producto);
    END LOOP;
    CLOSE c_productos;
END listar_productos_cliente;


