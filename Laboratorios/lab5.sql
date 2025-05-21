-- Juan Diego Valencia Alomia
--1
SELECT cod_area, SUM(salario) as valorTot
FROM empleado
GROUP BY cod_area
ORDER BY cod_area;

--2
SELECT MIN(salario), MAX(salario)
FROM empleado
NATURAL JOIN area_empresa
WHERE (nom_area = 'Marketing');

--3
SELECT nom_cargo, TO_CHAR(AVG(salario), 'L999g999g999mi') AS Prom_Sal_Cargo
FROM cargo
NATURAL JOIN empleado
GROUP BY nom_cargo;


--4
SELECT nom_cargo, TO_CHAR(AVG(salario), 'L999g999g999mi') AS Prom_Sal_Cargo
FROM cargo
NATURAL JOIN empleado
GROUP BY nom_cargo
HAVING  AVG(salario) > 4000000;

--5
SELECT L.ciudad, P.nom_pais, COUNT(E.ced_empleado) AS "cantidad de empleados"
FROM empleado E
NATURAL JOIN area_empresa A
INNER JOIN localizacion L ON A.localizacion = L.cod_localizacion
NATURAL JOIN pais P
GROUP BY L.ciudad,  P.nom_pais
ORDER BY P.nom_pais, L.ciudad;

--6
SELECT cod_cargo, nom_cargo
FROM cargo NATURAL JOIN empleado
GROUP BY cod_cargo, nom_cargo
HAVING AVG(porc_comision) > 2.5;

--7 
SELECT EXTRACT(MONTH FROM fecha_ing) AS mes, nom_cargo,  MAX(salario) AS salario_maximo
FROM empleado
NATURAL JOIN cargo 
GROUP BY nom_cargo, fecha_ing
HAVING EXTRACT(YEAR FROM fecha_ing) = 2024
ORDER BY nom_cargo, fecha_ing;

commit;
