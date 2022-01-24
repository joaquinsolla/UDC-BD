/*CONSULTAS TEST*/

/*a*/
SELECT r.nhcp, r.coda, a.nombre, r.fecha
FROM regalerg r JOIN alergia a ON r.coda=a.codigo;

/*b*/
SELECT p.resultado, r.fechapr
FROM pruebacovid p JOIN regprueba r ON p.fecha=r.fechapr
WHERE r.nhcp = 0000001 AND p.fecha IN '05/01/2020 16:05:00';

/*c*/
SELECT nhcp, fecha, dosis, centro
FROM cita
WHERE nhcp = 0000001;

/*d*/
SELECT asistencia, idsanit
FROM cita 
WHERE nhcp = 0000001 AND fecha IN '01/06/2020 10:30:00';

/*e*/
/*¿Que pacientes han recibido mas de una vez una primera dosis?*/
SELECT nhcp, dosis, count(*) AS VECES_RECIBIDA
FROM cita 
WHERE dosis = 1
GROUP BY nhcp, dosis
HAVING count(*)>1;

/*Que pacientes han recibido una segunda dosis?*/
SELECT nhcp, fecha
FROM cita 
WHERE dosis = 2;

/*f*/
SELECT ht.codeq, hi.idsanit
FROM hturnos ht JOIN hintegr hi ON ht.codeq=hi.codeq 
WHERE ht.fecha IN '01/06/2020 08:00:00' AND ht.centro IN 'Montecelo'
	AND hi.tvi<=ht.fecha AND COALESCE(hi.tvf, ht.fecha+1)>ht.fecha;

/*g*/
SELECT idsanit
FROM hintegr
WHERE codeq=01 AND tvf IS NULL;

/*h*/
SELECT recomend
FROM hrecom
WHERE codvac=01 AND agencia IN 'EMA'
	AND tvi<='01/08/2020' AND COALESCE(TO_CHAR(tvf),'02/08/2020')>'01/08/2020';



