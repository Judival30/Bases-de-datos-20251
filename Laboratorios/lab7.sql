--1
SELECT cedula, nombres, apellidos, salario
FROM empleado
WHERE salario = (
    SELECT MAX(salario)
    FROM empleado
);

--2
SELECT cargos, MAX(CANTIDAD) AS max_empleados
FROM (
    SELECT COUNT(*) AS CANTIDAD, cod_cargo AS cargos
    FROM empleado
    GROUP BY cod_cargo
);

--3
SELECT e.cedula, e.nombres, e.apellidos, e.cod_cargo
FROM empleado e
WHERE e.cod_cargo IN (
    SELECT cod_cargo
    FROM (
        SELECT cod_cargo, COUNT(*) AS cantidad
        FROM empleado
        GROUP BY cod_cargo
    )
    WHERE cantidad = (
        SELECT MAX(cantidad)
        FROM (
            SELECT COUNT(*) AS cantidad, cod_cargo
            FROM empleado
            GROUP BY cod_cargo
        )
    )
);

--4
SELECT *
FROM localizacion
WHERE cod_localizacion NOT IN (
    SELECT cod_localizacion
    FROM empleado
    NATURAL JOIN area_empresa
    NATURAL JOIN localizacion
);

--5
SELECT *
FROM empleado e
WHERE NOT EXISTS (
    SELECT 1
    FROM historia_cargos h
    WHERE h.ced_empleado = e.cedula
);

--6
SELECT nom_cargo, empleados_cargo
FROM (
    SELECT COUNT(*) AS empleados_cargo, e.cod_cargo, c.nom_cargo
    FROM empleado e
    JOIN cargo c ON e.cod_cargo = c.cod_cargo
    WHERE e.porc_comision <= 3.0
    GROUP BY c.nom_cargo, e.cod_cargo
);

--7

SELECT  nom_cargo, cod_cargo, AVG(salario) 
FROM cargo
NATURAL JOIN empleado
GROUP BY nom_cargo, cod_cargo
HAVING AVG(salario) > (
    SELECT AVG(salario)
    FROM empleado
);

--8
UPDATE cargo
SET salario_max = salario_max * 1.15
WHERE cod_cargo IN (
    SELECT cod_cargo
    FROM empleado
    GROUP BY cod_cargo
    HAVING COUNT(*) > 10
);


SELECT nom_cargo, salario_max, empleados_cargo
FROM (
    SELECT c.nom_cargo, c.salario_max, e.cod_cargo, COUNT(*) AS empleados_cargo
    FROM cargo c
    INNER JOIN empleado e ON c.cod_cargo = e.cod_cargo
    GROUP BY c.nom_cargo, c.salario_max, e.cod_cargo
);

--9
INSERT INTO VENTA (cod_venta, ced_empleado, fecha_venta, valor, comision_venta)
VALUES (
    1,
    1560321866,
    CURRENT_DATE,
    2000000,
    (SELECT porc_comision FROM Empleado WHERE cedula = 1560321866) * 2000000
);
-- 10
INSERT INTO VENTA (cod_venta, ced_empleado, fecha_venta, valor, comision_venta)
VALUES (
    2,
    (
        SELECT cedula
        FROM Empleado
        WHERE apellidos = 'Hunt' AND nombres = 'Erica'
    ),
    CURRENT_DATE,
    5000000,
    (SELECT MAX(porc_comision) FROM Empleado) * 5000000
);

COMMIT;
