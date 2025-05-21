--1
UPDATE historia_cargos
SET fecha_fin = SYSDATE
WHERE ced_empleado = 1123789255;

SELECT ced_empleado, fecha_fin
FROM historia_cargos
WHERE ced_empleado = 1123789255;

--2

UPDATE cargo
SET salario_max = salario_max * 1.05;

SELECT salario_max as SalarioMaxActual
FROM cargo;

--3
SELECT nom_cargo, salario as SalarioAnterior
FROM empleado  NATURAL JOIN cargo
WHERE nom_cargo = 'Analista' or nom_cargo = 'Asistente';

UPDATE empleado
SET salario = salario * 1.045
WHERE cod_cargo IN (SELECT cod_cargo
                    FROM empleado 
                    NATURAL JOIN cargo
                    WHERE nom_cargo = 'Analista' OR nom_cargo = 'Asistente');
                    
SELECT nom_cargo, salario as SalarioActual
FROM empleado  NATURAL JOIN cargo
WHERE nom_cargo = 'Analista' or nom_cargo = 'Asistente';

-- 4
SELECT * 
FROM empleado 
WHERE nombres = 'Jackson' and apellidos = 'Morgan';

DELETE FROM empleado
WHERE nombres = 'Jackson' and apellidos = 'Morgan';

SELECT * 
FROM empleado 
WHERE nombres = 'Jackson' and apellidos = 'Morgan';

-- 5
SELECT *
FROM historia_cargos
NATURAL JOIN area_empresa
WHERE nom_area = 'Marketing';

DELETE FROM historia_cargos
WHERE cod_area IN (SELECT cod_area
                    FROM historia_cargos 
                    NATURAL JOIN area_empresa
                    WHERE nom_area = 'Marketing');
SELECT *
FROM historia_cargos
NATURAL JOIN area_empresa
WHERE nom_area = 'Marketing';

-- 6

ALTER TABLE localizacion 
ADD CONSTRAINT unique_direccion 
UNIQUE (direccion);

SELECT * 
FROM localizacion;


--7

ALTER TABLE empleado DROP CONSTRAINT SYS_C0011840;
SELECT * FROM all_constraints WHERE table_name='EMPLEADO';
ALTER TABLE empleado ADD CONSTRAINT SYS_C0011840 CHECK (salario >= 1423500);

--8

ALTER TABLE localizacion ADD (direccion2 VARCHAR(25));
SELECT * FROM localizacion;

--9
--a
CREATE TABLE Venta (
  ced_empleado   NUMBER(16) NOT NULL,        
  fecha_venta    DATE,          
  valor          NUMBER(10),  
  comisionVenta  NUMBER(10)   
);

--b

ALTER TABLE Venta ADD (codVenta NUMBER(10));
-- c
ALTER TABLE Venta ADD CONSTRAINT pk_codVenta PRIMARY KEY (codVenta);
--d
ALTER TABLE Venta
ADD CONSTRAINT fk_venta_empleado
FOREIGN KEY (ced_empleado) REFERENCES empleado(ced_empleado);

SELECT * FROM all_constraints WHERE table_name='VENTA';