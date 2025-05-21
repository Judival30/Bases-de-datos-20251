-- Juan Diego Valencia Alomia
-- 1
SELECT ced_empleado, nombres, apellidos, salario, fecha_ing
FROM empleado E
WHERE E.fecha_ing BETWEEN '01/01/2023' AND '31/12/2024';
--2
SELECT ced_empleado, nombres, apellidos, nom_cargo
FROM empleado E 
NATURAL JOIN cargo C
WHERE salario > 2800000;
-- 3
SELECT direccion, nom_pais, nom_region
FROM localizacion L 
NATURAL JOIN pais P 
NATURAL JOIN region R
ORDER BY nom_pais DESC;
--4
SELECT nombres, apellidos, email, celular
FROM empleado
WHERE nombres like 'J%' AND apellidos like '%e%';
-- 5
SELECT nombres, apellidos, email, celular
FROM empleado
WHERE nombres like 'J%' OR nombres like 'C%';
-- 6
SELECT E.nombres, E.apellidos, H.fecha_inicio, H.fecha_fin, C.nom_cargo
FROM empleado E
INNER JOIN historia_cargos H ON E.ced_empleado = H.ced_empleado
INNER JOIN cargo C ON H.cod_cargo = C.cod_cargo
INNER JOIN area_empresa A ON A.cod_area = H.cod_area
INNER JOIN localizacion L ON A.localizacion = L.cod_localizacion
WHERE L.cod_pais = 169;
--7
SELECT E.nombres, E.apellidos,
       EXTRACT(MONTH FROM H.fecha_inicio) AS "mes inicio",
       EXTRACT(YEAR FROM H.fecha_inicio) AS "ano inicio",
       EXTRACT(MONTH FROM H.fecha_fin) AS "mes fin",
       EXTRACT(YEAR FROM H.fecha_fin) AS "ano fin"
FROM empleado E
INNER JOIN historia_cargos H ON E.ced_empleado = H.ced_empleado
WHERE E.ced_empleado = 1557235452;
-- 8
SELECT DISTINCT nom_cargo, nom_area
FROM empleado E
NATURAL JOIN area_empresa A
NATURAL JOIN cargo C;
--9

SELECT nombres, apellidos, fecha_inicio, fecha_fin, H.cod_cargo, H.cod_area
FROM empleado E
FULL OUTER JOIN historia_cargos H ON (E.ced_empleado = H.ced_empleado);

SELECT E.ced_empleado AS "Cédula del Empleado",
       E.nombres AS "Nombre del Empleado",
       E.apellidos AS "Apellido del Empleado",
       C.nom_cargo AS "Cargo del Empleado",
       J.nombres AS "Nombre del Jefe",
       J.apellidos AS "Apellido del Jefe",
       P.nom_pais AS "Nombre del País"
FROM empleado E
INNER JOIN cargo C ON (E.cod_cargo = C.cod_cargo)
FULL OUTER JOIN empleado J ON (E.cod_jefe = J.ced_empleado)
INNER JOIN area_empresa A ON (E.cod_area = A.cod_area)
INNER JOIN localizacion L ON (L.cod_localizacion = A.localizacion)
INNER JOIN pais P ON (P.cod_pais = L.cod_pais);
