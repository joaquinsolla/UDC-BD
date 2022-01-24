/*CREACION DE TABLAS*/

CREATE TABLE paciente (
nhc NUMERIC(7),
nombre VARCHAR(15) NOT NULL,
apellidos VARCHAR(31) NOT NULL,
fecnac DATE NOT NULL,
edad NUMERIC(3),
telefono NUMERIC(9) UNIQUE NOT NULL,
inmunizado NUMERIC(1) NOT NULL,
CONSTRAINT PK_paciente PRIMARY KEY(nhc),
CONSTRAINT CH_inmunizado0 CHECK(inmunizado>=0),
CONSTRAINT CH_inmunizado1 CHECK(inmunizado<=1)
);

CREATE TABLE alergia (
codigo NUMERIC(5),
nombre VARCHAR(30) UNIQUE NOT NULL,
CONSTRAINT PK_alergia PRIMARY KEY (codigo)
);

CREATE TABLE pruebacovid (
fecha DATE,
tipo VARCHAR(15),
resultado VARCHAR(13) NOT NULL,
CONSTRAINT PK_pruebacovid PRIMARY KEY (fecha, tipo)
);

CREATE TABLE vacuna (
codigo NUMERIC(3),
nombre VARCHAR(15) UNIQUE NOT NULL,
fabricante VARCHAR(15) NOT NULL,
CONSTRAINT PK_vacuna PRIMARY KEY (codigo)
);

CREATE TABLE centro (
nombre VARCHAR(30),
localidad VARCHAR(15) NOT NULL,
CONSTRAINT PK_centro PRIMARY KEY (nombre)
);

CREATE TABLE equipo (
codigo NUMERIC(2),
nombre VARCHAR(15) UNIQUE NOT NULL,
centro VARCHAR(30) NOT NULL REFERENCES centro (nombre),
CONSTRAINT PK_equipo PRIMARY KEY (codigo)
);

CREATE TABLE sanitario (
id NUMERIC(5),
nombre VARCHAR(15) NOT NULL,
apellidos VARCHAR(31) NOT NULL,
codeq NUMERIC(2) NOT NULL REFERENCES equipo (codigo),
salario NUMERIC(5) DEFAULT 1500,
CONSTRAINT PK_sanitario PRIMARY KEY (id)
);

CREATE TABLE cita (
codigo NUMERIC(8),
nhcp NUMERIC(7) NOT NULL REFERENCES paciente (nhc),
fecha DATE NOT NULL,
codvac NUMERIC(3) NOT NULL REFERENCES vacuna (codigo),
dosis NUMERIC(2) NOT NULL,
centro VARCHAR(30) NOT NULL REFERENCES centro (nombre),
idsanit NUMERIC(5) NOT NULL REFERENCES sanitario (id),
fecsms DATE,
asistencia NUMERIC(1),
CONSTRAINT PK_cita PRIMARY KEY (codigo),
CONSTRAINT CH_asistencia0 CHECK(asistencia>=0),
CONSTRAINT CH_asistencia1 CHECK(asistencia<=1)
);

CREATE TABLE informe (
codigo NUMERIC(3),
codvac NUMERIC(3) NOT NULL REFERENCES vacuna (codigo),
agencia VARCHAR(15) NOT NULL,
estado VARCHAR(20) NOT NULL,
fecha DATE NOT NULL,
CONSTRAINT PK_informe PRIMARY KEY (codigo)
);

CREATE TABLE hpaciente (
nhcp NUMERIC(7),
codigo NUMERIC(8),
CONSTRAINT FK_hpaciente FOREIGN KEY (nhcp) REFERENCES paciente (nhc),
CONSTRAINT PK_hpaciente PRIMARY KEY (nhcp, codigo)
);

CREATE TABLE hrecom (
codvac NUMERIC(3),
tvi DATE,
tvf DATE,
agencia VARCHAR(15) NOT NULL,
recomend VARCHAR(200) NOT NULL,
CONSTRAINT FK_hrecom FOREIGN KEY (codvac) REFERENCES vacuna (codigo),
CONSTRAINT PK_hrecom PRIMARY KEY (codvac, tvi)
);

CREATE TABLE hturnos (
centro VARCHAR(30),
fecha DATE,
codeq REFERENCES equipo (codigo) NOT NULL,
CONSTRAINT FK_hturnos FOREIGN KEY (centro) REFERENCES centro (nombre),
CONSTRAINT PK_hturnos PRIMARY KEY (centro, fecha)
);

CREATE TABLE hintegr (
codeq NUMERIC(2),
tvi DATE,
tvf DATE,
idsanit NUMERIC(5) NOT NULL REFERENCES sanitario (id),
CONSTRAINT FK_hintegr FOREIGN KEY (codeq) REFERENCES equipo (codigo),
CONSTRAINT PK_hintegr PRIMARY KEY (codeq, tvi)
);

CREATE TABLE regprueba (
fechapr DATE,
tipopr VARCHAR(15),
nhcp NUMERIC(7),
codh NUMERIC(8),
CONSTRAINT PK_regprueba PRIMARY KEY (fechapr, tipopr),
CONSTRAINT FK_regprueba_fechapr_tipopr FOREIGN KEY (fechapr, tipopr) REFERENCES pruebacovid (fecha, tipo),
CONSTRAINT FK_regprueba_nhcp_codh FOREIGN KEY (nhcp, codh) REFERENCES hpaciente (nhcp, codigo)
);

CREATE TABLE regalerg (
coda NUMERIC(5),
nhcp NUMERIC(7),
codh NUMERIC(8),
fecha DATE NOT NULL,
CONSTRAINT PK_ragalerg PRIMARY KEY (coda),
CONSTRAINT FK_regalerg_coda FOREIGN KEY (coda) REFERENCES alergia (codigo),
CONSTRAINT FK_regalerg_nhcp_codh FOREIGN KEY (nhcp, codh) REFERENCES hpaciente (nhcp, codigo)
);


/*INSERCION DE DATOS*/

alter session set nls_date_format ='DD-MM-RR HH24:MI:SS'; /*Formato de fecha europeo*/

INSERT INTO paciente VALUES (0000001, 'Joaquin', 'Solla Vazquez', '5/8/2001', 19, 555111111, 1);
INSERT INTO paciente VALUES (0000002, 'Manuel', 'Estevez Murado', '26/01/2001', 20, 555222222, 0);
INSERT INTO paciente VALUES (0000008, 'Jorge', 'Gonzalez Fernandez', '01/01/2014', 7, 555333333, 0);
INSERT INTO paciente VALUES (0000014, 'Clara', 'Otero Otero', '12/10/2002', 18, 555444444, 0);
INSERT INTO paciente VALUES (0000143, 'Fernando', 'Alonso Diaz', '29/07/1981', 39, 555555555, 1);
INSERT INTO paciente VALUES (1851341, 'Lucas', 'Alonso de san Segundo', '13/01/1999', 22, 555666666, 0);
INSERT INTO paciente VALUES (0000455, 'Alex', 'Porto Vidal', '05/02/2000', 21, 555777777, 1);
INSERT INTO paciente VALUES (0007340, 'Roberto', 'Blanco Fernandez', '11/03/2000', 21, 555888888, 0);
INSERT INTO paciente VALUES (0926483, 'Pablo', 'Rivas Vazquez', '30/04/2001', 20, 555999999, 0);


INSERT INTO alergia VALUES (00001, 'Acaros');
INSERT INTO alergia VALUES (00002, 'Marisco');
INSERT INTO alergia VALUES (00003, 'Latex');
INSERT INTO alergia VALUES (00043, 'Picadura de abeja');
INSERT INTO alergia VALUES (08430, 'Polen');
INSERT INTO alergia VALUES (00033, 'Farmaco X');
INSERT INTO alergia VALUES (00009, 'Farmaco Y');


INSERT INTO pruebacovid VALUES ('03/06/2020 16:05:00', 'PCR', 'POSITIVO');
INSERT INTO pruebacovid VALUES ('05/01/2020 16:05:00', 'PCR', 'NEGATIVO');
INSERT INTO pruebacovid VALUES ('05/01/2020 16:10:00', 'PCR', 'NEGATIVO');
INSERT INTO pruebacovid VALUES ('05/01/2020 16:15:00', 'Antigenos', 'NEGATIVO');
INSERT INTO pruebacovid VALUES ('05/01/2020 16:20:00', 'PCR', 'NEGATIVO');
INSERT INTO pruebacovid VALUES ('05/01/2020 16:30:00', 'Serologica', 'NEGATIVO');
INSERT INTO pruebacovid VALUES ('05/01/2020 16:35:00', 'PCR', 'NEGATIVO');
INSERT INTO pruebacovid VALUES ('06/01/2020 18:40:00', 'Serologica', 'NEGATIVO');
INSERT INTO pruebacovid VALUES ('06/01/2020 18:50:00', 'PCR', 'NEGATIVO');
INSERT INTO pruebacovid VALUES ('06/01/2020 18:55:00', 'Antigenos', 'NEGATIVO');
INSERT INTO pruebacovid VALUES ('06/01/2020 19:00:00', 'PCR', 'NEGATIVO');
INSERT INTO pruebacovid VALUES ('07/01/2020 20:30:00', 'Serologica', 'NEGATIVO');
INSERT INTO pruebacovid VALUES ('07/01/2020 20:35:00', 'Antigenos', 'NEGATIVO');


INSERT INTO vacuna VALUES (001, 'pzif1', 'Pzifer');
INSERT INTO vacuna VALUES (002, 'astravax', 'AstraZeneca');
INSERT INTO vacuna VALUES (003, 'jonsV', 'Jonson&Jonson');
INSERT INTO vacuna VALUES (004, 'janssetest3', 'Jansse');
INSERT INTO vacuna VALUES (005, 'mv7', 'Moderna');


INSERT INTO centro VALUES ('Montecelo', 'Pontevedra');
INSERT INTO centro VALUES ('Meixoeiro', 'Vigo');
INSERT INTO centro VALUES ('Provincial Pontevedra', 'Pontevedra');
INSERT INTO centro VALUES ('Abente y Lago', 'A Coruña');
INSERT INTO centro VALUES ('Lucus Augusti', 'Lugo');
INSERT INTO centro VALUES ('Santa Maria Nai', 'Orense');


INSERT INTO equipo VALUES (01, 'vacunacionMon1', 'Montecelo');
INSERT INTO equipo VALUES (02, 'vacunacionMon2', 'Montecelo');
INSERT INTO equipo VALUES (03, 'asistenciaMon', 'Montecelo');
INSERT INTO equipo VALUES (04, 'vacunacionMei', 'Meixoeiro');
INSERT INTO equipo VALUES (05, 'asistenciaMei', 'Meixoeiro');
INSERT INTO equipo VALUES (06, 'vacunacionAL', 'Abente y Lago');


INSERT INTO sanitario VALUES (00001, 'Alex', 'Fernandez Fernandez', 01, 3000);
INSERT INTO sanitario VALUES (00002, 'Sofia', 'Solla Solla', 01, 1550);
INSERT INTO sanitario VALUES (00003, 'Claudia', 'Vidal Solla', 01, 3000);
INSERT INTO sanitario VALUES (00004, 'Mario', 'Gonzalez Vazquez', 01, 4200);
INSERT INTO sanitario VALUES (00005, 'Jose', 'Seara Vazquez', 02, 2500);
INSERT INTO sanitario VALUES (00006, 'Esther', 'Gonzalez Perez', 03, 2000);
INSERT INTO sanitario VALUES (00007, 'Laura', 'Perez Perez', 03, 3300);
INSERT INTO sanitario VALUES (00008, 'Lua', 'Otero do Pazo', 04, 2000);
INSERT INTO sanitario VALUES (00009, 'Maria', 'Rodriguez Salvador', 04, 1550);
INSERT INTO sanitario VALUES (00010, 'Argimiro', 'Perez de Garcia', 05, 10000);
INSERT INTO sanitario VALUES (00055, 'Torcuato', 'Dopazo Gonzalez', 05, 4200);
INSERT INTO sanitario VALUES (00094, 'Alberto', 'Fraguela Casado', 05, 1800);


INSERT INTO cita VALUES (00000001, 0000001, '01/06/2020 10:30:00', 001, 1, 'Montecelo', 00001, '25/05/2020', 1);
INSERT INTO cita VALUES (00000002, 0000001, '01/12/2020 10:30:00', 001, 1, 'Montecelo', 00001, '25/11/2020', 1);
INSERT INTO cita VALUES (00000003, 0000002, '01/06/2020 10:40:00', 002, 1, 'Meixoeiro', 00004, '25/05/2020', 1);
INSERT INTO cita VALUES (00000004, 0000008, '01/06/2020 10:50:00', 002, 1, 'Meixoeiro', 00004, '25/05/2020', 1);
INSERT INTO cita VALUES (00000005, 0000014, '01/06/2020 11:00:00', 001, 1, 'Meixoeiro', 00005, '25/05/2020', 1);
INSERT INTO cita VALUES (00000006, 0000143, '01/06/2020 10:00:00', 003, 1, 'Meixoeiro', 00005, '25/05/2020', 1);
INSERT INTO cita VALUES (00000007, 0000143, '21/06/2020 10:00:00', 003, 2, 'Meixoeiro', 00005, '14/06/2020', 1);
INSERT INTO cita VALUES (00000008, 1851341, '01/06/2020 16:00:00', 001, 1, 'Montecelo', 00005, '25/05/2020', 1);
INSERT INTO cita VALUES (00000009, 0000455, '03/07/2020 17:00:00', 004, 1, 'Meixoeiro', 00005, '27/05/2020', 1);
INSERT INTO cita VALUES (00000010, 0000455, '23/07/2020 17:00:30', 004, 2, 'Meixoeiro', 00005, '16/07/2020', 1);
INSERT INTO cita VALUES (00000011, 0007340, '01/06/2020 18:00:00', 001, 1, 'Montecelo', 00005, '25/05/2020', 0);
INSERT INTO cita VALUES (00000012, 0926483, '01/06/2020 18:00:10', 001, 1, 'Abente y Lago', 00007, '25/05/2020', 1);
INSERT INTO cita VALUES (00000013, 0926483, '05/08/2020 09:00:30', 001, 2, 'Abente y Lago', 00007, '28/07/2020', 1);
INSERT INTO cita VALUES (00000014, 0000001, '21/12/2020 10:30:00', 001, 2, 'Montecelo', 00001, '14/12/2020', 1);


INSERT INTO informe VALUES (001, 001, 'EMA', 'APROBADA', '01/05/2020');
INSERT INTO informe VALUES (002, 001, 'EMA', 'APROBADA', '03/05/2020');
INSERT INTO informe VALUES (032, 002, 'NANDA', 'EN ESTUDIO', '20/05/2020');
INSERT INTO informe VALUES (033, 002, 'OMS', 'APROBADA', '22/05/2020');
INSERT INTO informe VALUES (128, 003, 'NIC', 'APROBADA', '15/05/2020');
INSERT INTO informe VALUES (140, 003, 'OMS', 'APROBADA', '15/05/2020');
INSERT INTO informe VALUES (200, 005, 'OMS', 'CANCELADA', '17/05/2020');


INSERT INTO hpaciente VALUES (00000001, 0000001);
INSERT INTO hpaciente VALUES (00000001, 0000002);
INSERT INTO hpaciente VALUES (00000002, 0000003);
INSERT INTO hpaciente VALUES (00000002, 0000004);
INSERT INTO hpaciente VALUES (00000002, 0000005);
INSERT INTO hpaciente VALUES (00000008, 0000006);
INSERT INTO hpaciente VALUES (00000143, 0000007);
INSERT INTO hpaciente VALUES (00000143, 0000008);
INSERT INTO hpaciente VALUES (00000455, 0000009);
INSERT INTO hpaciente VALUES (00000455, 0000010);
INSERT INTO hpaciente VALUES (00000455, 0000011);
INSERT INTO hpaciente VALUES (00000455, 0000012);
INSERT INTO hpaciente VALUES (00007340, 0000013);
INSERT INTO hpaciente VALUES (00000001, 0000014);
INSERT INTO hpaciente VALUES (00000002, 0000015);


INSERT INTO hrecom VALUES (001, '01/05/2020', null, 'EMA', 'No suministrar a mayores de 65 anios');
INSERT INTO hrecom VALUES (001, '03/07/2020', null, 'EMA', 'No suministrar a menores de 21 anios');
INSERT INTO hrecom VALUES (002, '20/05/2020', '19/12/2020', 'NANDA', 'Suministrar a personas de entre 30 y 50 anios');
INSERT INTO hrecom VALUES (002, '19/12/2020', null, 'OMS', 'No suministrar a mayores de 65 anios');
INSERT INTO hrecom VALUES (003, '15/05/2021', '03/10/2020', 'NIC', 'No suministrar a quienes padezcan alergia al farmaco Y');
INSERT INTO hrecom VALUES (003, '03/10/2020', null, 'OMS', 'No suministrar a quienes padezcan alergia al farmaco X');
INSERT INTO hrecom VALUES (005, '17/05/2020', null, 'OMS', 'No suministrar. Alto riesgo de trombos');


INSERT INTO hturnos VALUES ('Montecelo', '01/06/2020 08:00:00', 01);
INSERT INTO hturnos VALUES ('Montecelo', '01/12/2020 08:00:00', 01);
INSERT INTO hturnos VALUES ('Montecelo', '11/12/2020 08:00:00', 01);
INSERT INTO hturnos VALUES ('Montecelo', '01/06/2020 13:00:00', 02);
INSERT INTO hturnos VALUES ('Meixoeiro', '01/06/2020 08:00:00', 04);
INSERT INTO hturnos VALUES ('Meixoeiro', '21/06/2020 08:00:00', 04);
INSERT INTO hturnos VALUES ('Meixoeiro', '03/07/2020 13:00:00', 04);
INSERT INTO hturnos VALUES ('Meixoeiro', '23/07/2020 08:00:00', 04);
INSERT INTO hturnos VALUES ('Abente y Lago', '01/06/2020 13:00:00', 06);
INSERT INTO hturnos VALUES ('Abente y Lago', '21/06/2020 08:00:00', 06);
INSERT INTO hturnos VALUES ('Montecelo', '05/01/2020 13:00:00', 03);
INSERT INTO hturnos VALUES ('Montecelo', '06/01/2020 13:00:00', 03);
INSERT INTO hturnos VALUES ('Montecelo', '07/01/2020 13:00:00', 03);
INSERT INTO hturnos VALUES ('Montecelo', '03/06/2020 13:00:00', 03);


INSERT INTO hintegr VALUES (01, '01/01/2020 00:00:00', null, 00001);
INSERT INTO hintegr VALUES (01, '01/01/2020 00:00:01', null, 00002);
INSERT INTO hintegr VALUES (01, '01/01/2020 00:00:02', null, 00003);
INSERT INTO hintegr VALUES (02, '01/01/2020 00:00:00', null, 00005);
INSERT INTO hintegr VALUES (02, '01/01/2020 00:00:01', '15/03/2020 00:00:00', 00004);
INSERT INTO hintegr VALUES (01, '15/03/2020 00:00:00', null, 00004);
INSERT INTO hintegr VALUES (03, '01/01/2020 00:00:00', null, 00006);
INSERT INTO hintegr VALUES (03, '01/01/2020 00:00:01', null, 00007);
INSERT INTO hintegr VALUES (04, '01/01/2020 00:00:00', null, 00008);
INSERT INTO hintegr VALUES (04, '01/01/2020 00:00:01', null, 00009);
INSERT INTO hintegr VALUES (05, '01/01/2020 00:00:00', null, 00010);
INSERT INTO hintegr VALUES (05, '01/01/2020 00:00:01', null, 00055);
INSERT INTO hintegr VALUES (05, '01/01/2020 00:00:02', null, 00094);


INSERT INTO regprueba VALUES ('03/06/2020 16:05:00', 'PCR', 0000001, 0000001);
INSERT INTO regprueba VALUES ('05/01/2020 16:05:00', 'PCR', 0000001, 0000002);
INSERT INTO regprueba VALUES ('05/01/2020 16:10:00', 'PCR', 00000002, 0000003);
INSERT INTO regprueba VALUES ('05/01/2020 16:15:00', 'Antigenos', 00000002, 0000004);
INSERT INTO regprueba VALUES ('05/01/2020 16:20:00', 'PCR', 0000002, 0000005);
INSERT INTO regprueba VALUES ('05/01/2020 16:30:00', 'Serologica', 0000008, 0000006);
INSERT INTO regprueba VALUES ('05/01/2020 16:35:00', 'PCR', 000143, 0000007);
INSERT INTO regprueba VALUES ('06/01/2020 18:40:00', 'Serologica', 0000143, 0000008);
INSERT INTO regprueba VALUES ('06/01/2020 18:50:00', 'PCR', 0000455, 0000009);
INSERT INTO regprueba VALUES ('06/01/2020 18:55:00', 'Antigenos', 0000455, 0000010);
INSERT INTO regprueba VALUES ('06/01/2020 19:00:00', 'PCR', 0000455, 0000011);
INSERT INTO regprueba VALUES ('07/01/2020 20:30:00', 'Serologica', 0000455, 0000012);
INSERT INTO regprueba VALUES ('07/01/2020 20:35:00', 'Antigenos', 0007340, 0000013);


INSERT INTO regalerg VALUES (00033, 0000001, 0000014, '04/07/2015');
INSERT INTO regalerg VALUES (00001, 0000002, 0000015, '22/02/2012');