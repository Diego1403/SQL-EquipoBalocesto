/* comprobación */
/*
SELECT * FROM partidosganados ORDER BY 2;
SELECT * FROM jugadores190 ORDER BY 1;
SELECT * FROM localidadestadios ORDER BY 2;
SELECT * FROM clubes1978 ORDER BY 1;
SELECT * FROM amistosos_beneficos;
*/


                                      
/* CONSULTAS */
/* PIVOTES DE 18 A 22 AÑOS MAS ALTOS DE SU EQUIPO*/
SELECT ju.*
FROM jugador ju
WHERE ju.posicion = 'PIVOT' AND 
      SYSDATE - ju.F_NACIMIENTO >= 360 * 18 AND 
      SYSDATE - ju.F_NACIMIENTO < 23 * 360 AND 
      ju.altura = (SELECT MAX(ju2.altura)
                   FROM jugador ju2
                   WHERE ju.cif = ju2.cif);
                   
  
/* JUGADORES QUE HAN FIRMADO MAS CONTRATOS*/   
SELECT ju.nombre,COUNT(con.dni)"Numero de Contratos"
FROM jugador ju,contrato con
WHERE ju.dni = con.dni 
GROUP BY con.dni,ju.nombre
HAVING COUNT(con.dni) = (SELECT MAX(COUNT(con2.dni))
                         FROM contrato con2
                         GROUP BY con2.dni);
                         
/* JUGADORES DE LOS CLUBES QUE MAS TORNEOS HAN GANADO, ORDENADOS DE MENOR A MAYOR ALTURA*/
SELECT jugador.*
FROM jugador
WHERE jugador.cif IN(SELECT club.cif
                     FROM club_partido , club
                     WHERE club_partido.ganador = club.cif AND club_partido.codigo IN (SELECT codigo
                                                                                       FROM de_torneo
                                                                                       WHERE estado = 'FINAL')
                                                                                       GROUP BY club_partido.ganador,club.cif,club.nombre
                                                                                       HAVING COUNT(club_partido.ganador) = (SELECT MAX(COUNT(club_partido.ganador))
                                                                                                                             FROM club_partido 
                                                                                                                             WHERE club_partido.codigo IN (SELECT codigo
                                                                                                                                                           FROM de_torneo
                                                                                                                                                           WHERE estado = 'FINAL')
                                                                                                                                                           GROUP BY club_partido.ganador))
ORDER BY jugador.altura ASC;



/* JUGADORES QUE NUNCA HAN ESTADO EN UN CLUB QUE HAYA GANADO TORNEOS*/
SELECT ju.* 
FROM jugador ju
WHERE NOT EXISTS((SELECT contrato.cif
                  FROM contrato
                  WHERE contrato.DNI = ju.dni) INTERSECT (SELECT club_partido.ganador
                                                          FROM club_partido
                                                          WHERE club_partido.codigo IN (SELECT de_torneo.codigo
                                                                                        FROM de_torneo
                                                                                        WHERE de_torneo.estado = 'FINAL')));
  


/* CLUB QUE MÁS PARTIDOS HA GANADO EN CADA UNO DE LOS ESTADIOS*/
SELECT clu1.nombre"Nombre Estadio",clu1.ganador,clubb.nombre"Nombre del Club",COUNT(clu1.nombre)"Nº Victorias"   
FROM club_partido clu1,club clubb
WHERE clu1.ganador = clubb.cif
GROUP BY clu1.ganador,clu1.nombre,clubb.nombre
HAVING COUNT(clu1.ganador) = (SELECT MAX(COUNT(clu2.ganador))   
                              FROM club_partido clu2
                              WHERE clu2.nombre = clu1.nombre 
                              GROUP BY clu2.ganador,clu2.nombre)
ORDER BY clu1.nombre ASC;



/* PORCENTAJE DE PARTIDOS GANADOS DE CADA UNO DE LOS EQUIPOS*/
SELECT clu1.nombre,TO_CHAR((((SELECT COUNT(club_partido.ganador)
                             FROM club_partido
                             WHERE club_partido.ganador = clu1.cif)/(SELECT COUNT(club_partido.ganador)
                                                                     FROM club_partido
                                                                     WHERE club_partido.cif_1 = clu1.cif OR club_partido.cif_2 = clu1.cif))*100),'00.00')||'%'"Porcentaje de Partidos Ganados" 
FROM club clu1;

/* PARA CADA UNO DE LOS EQUIPOS CALCULAR CON QUE EQUIPO TIENE MAS DERROTAS (Rival), Y EL NUMERO DE DERROTAS*/
SELECT clu1.nombre"Club",clu2.nombre"Rival",COUNT(club_partido.ganador)"Nº Derrotas"
FROM club clu1,club clu2,club_partido
WHERE  (club_partido.cif_1 = clu1.cif OR club_partido.cif_2 = clu1.cif) AND club_partido.ganador = clu2.cif AND clu2.cif IN (SELECT club_partido.ganador
                                                                                                                             FROM club_partido
                                                                                                                             WHERE (club_partido.cif_1 = clu1.cif OR club_partido.cif_2 = clu1.cif) AND club_partido.ganador != clu1.cif
                                                                                                                             GROUP BY club_partido.ganador
                                                                                                                             HAVING COUNT(club_partido.ganador) = (SELECT MAX(COUNT(club_partido.ganador))
                                                                                                                                                                   FROM club_partido
                                                                                                                                                                   WHERE (club_partido.cif_1 = clu1.cif OR club_partido.cif_2 = clu1.cif) AND club_partido.ganador != clu1.cif
                                                                                                                                                                   GROUP BY club_partido.ganador))
GROUP BY clu1.nombre,clu2.nombre,club_partido.ganador
ORDER BY clu1.nombre ASC;

/* CLUB CON LOS JUGADORES MAS BAJITOS EN PROPORCION*/
SELECT club.*
FROM club
WHERE club.cif = (SELECT jugador.cif
                  FROM jugador
                  GROUP BY jugador.cif
                  HAVING AVG(jugador.altura) = (SELECT MIN(AVG(jugador.altura))
                                                FROM jugador
                                                GROUP BY jugador.cif));
                                                
/* CLUBES QUE NO HAYAN GANADO NINGUN PARTIDO*/
SELECT club.*
FROM club
WHERE NOT club.cif IN (SELECT club_partido.ganador
                       FROM club_partido);
                       
                       
/* JUGADORES CON MAYOR PRECIO DE COMPRA EN CADA UNA DE LAS POSICIONES*/
SELECT DISTINCT ju.posicion,ju.dni,ju.nombre,con.PRECIO_COMPRA
FROM jugador ju,contrato con
WHERE con.DNI = ju.dni AND con.precio_compra = (SELECT MAX(con2.precio_compra)
                                                FROM jugador ju2,contrato con2
                                                WHERE con2.dni = ju2.dni AND ju2.posicion = ju.posicion)
ORDER BY ju.posicion ASC;

/* ¿Cuántos partidos se han realizado en cada estadio en el año 2022?*/
SELECT e.nombre "estadio", COUNT(*) "Nº DE partidos"
FROM club_partido p, estadio e
  WHERE p.nombre=e.nombre 
    AND p.fecha LIKE '%22'
  GROUP BY e.nombre;

/* Ver que contratos de un jugador se acaban 2024*/
SELECT j.nombre , j.apellido 
FROM contrato co, jugador j
  WHERE f_fin LIKE '%24'   
    AND j.dni = co.dni ORDER BY 1;

/* Mostrar todos los jugadores que tengan asignado un contrato , si estan lesionados  y cuando acaba dicho contrato*/
SELECT jugador.nombre ,jugador.apellido,jugador.lesionado, contrato.f_fin
FROM jugador
  INNER JOIN contrato ON jugador.dni=contrato.dni;

/* Mostrar club con mas vistorias*/
SELECT  clu.nombre , COUNT(cp.ganador) "Partidos ganados"
FROM club clu, club_partido cp
WHERE clu.cif = cp.ganador
GROUP BY clu.nombre  
HAVING COUNT(cp.ganador ) = (SELECT MAX(COUNT(ganador)) 
                             FROM club_partido
                              GROUP BY ganador);
/* Localidad con mas paritdos ganados*/
SELECT cp.localidad , COUNT(club.ganador) "N Partidos ganados"
FROM codigo_postal cp, club_partido club
  WHERE cp.cod_postal = club.cod_postal 
  GROUP BY cp.localidad 
  HAVING COUNT(club.cod_postal ) = ( SELECT MAX(COUNT(cod_postal)) 
                                     FROM club_partido
                                      GROUP by cod_postal);


/*Seleccionar los estadios donde se han jugado más de 2 partidos*/
SELECT est.nombre "NOMBRE ESTADIO",COUNT (est.nombre)"PARTIDOS JUGADOS"
FROM estadio est,club_partido cpart
WHERE est.nombre=cpart.nombre
GROUP BY est.nombre
HAVING COUNT(est.nombre) > 2;

/*Visualizar los clubs que han ganado menos de 4 partidos en 2021*/
SELECT cl.nombre "NOMBRE CLUB",COUNT (cl.cif) "PARTIDOS GANADOS EN 2021"
FROM club_partido cpart, club cl
WHERE cl.cif=cpart.ganador AND cpart.fecha LIKE '__/__/21'
GROUP BY cl.nombre
HAVING COUNT(cl.cif) < 4;

/*Qué entrenador de Andujar es el más viejo*/
SELECT en.nombres "NOMBRE ENTRENADOR",en.f_nacimiento
FROM entrenador en
WHERE en.f_nacimiento IN (SELECT MIN(en.f_nacimiento)
                          FROM entrenador en,codigo_postal cd
                          WHERE en.cod_postal=cd.cod_postal AND cd.localidad='Andujar' );

/*Cual es la media de altura de los jugadores del club Leones*/
SELECT cl.nombre "NOMBRE CLUB",AVG(j.altura) "MEDIA ALTURA EN CM"
FROM jugador j,club cl
WHERE j.cif=cl.cif AND cl.nombre='Leones'
GROUP BY cl.nombre;

/*Mostrar la posicion que ocupan los jugadores con un contrato de precio_venta mayor a 50000000 y que no se llame Diego*/
(SELECT j.nombre "JUGADOR",j.posicion, con.precio_venta "PRECIO VENTA"
FROM jugador j,contrato con
WHERE j.dni=con.dni AND con.precio_venta > 210000000)
MINUS
(SELECT j.nombre "JUGADOR",j.posicion, con.precio_venta "PRECIO VENTA"
FROM jugador j,contrato con
WHERE j.dni=con.dni AND j.nombre='Diego')
ORDER BY 2;


/* Información del torneo con el mayor premio */
SELECT club_1.nombre "CLUB 1", club_partido.puntos_club_1 "PUNTUACION CLUB 1", club_2.nombre "CLUB 2", club_partido.puntos_club_2 "PUNTUACION CLUB 2", club_partido.fecha "FECHA", de_torneo.estado "PARTIDO", club_ganador.nombre "CLUB GANADOR" 
FROM club_partido, de_torneo, club club_1, club club_2, club club_ganador 
  WHERE club_partido.ganador = club_ganador.cif 
    AND club_partido.cif_1 = club_1.cif 
    AND club_partido.cif_2 = club_2.cif 
    AND club_partido.codigo = de_torneo.codigo 
    AND club_partido.codigo IN ( SELECT codigo FROM de_torneo 
                                   WHERE identificador = ( SELECT identificador FROM torneo 
                                                             WHERE premio = ( SELECT MAX(premio) FROM torneo ) ) );
/* Club(es) que más dinero ha(n) gastado en jugadores*/
SELECT club.nombre "CLUBES CON MAYOR GASTO", club.anio_fundacion "AÑO DE FUNDACIÓN", club.valoracion_euros "VALORACIÓN (€)", entrenador.nombres||' '||entrenador.apellido "ENTRENADOR"
FROM club, entrenador
 WHERE club.cif IN (SELECT club.cif 
                    FROM club, contrato 
                      WHERE contrato.cif = club.cif
                      GROUP BY (club.cif)
                      HAVING SUM(contrato.precio_compra) = (SELECT MAX(SUM(contrato.precio_compra)) 
                                                            FROM club, contrato 
                                                              WHERE contrato.cif = club.cif 
                                                              GROUP BY (club.cif)))
 AND club.dni = entrenador.dni
 ORDER BY 1;
/* Estadios donde se han celebrado finales*/
SELECT estadio.nombre "ESTADIO QUE CELEBRÓ LA FINAL", estadio.capacidad "CAPACIDAD", codigo_postal.localidad "CUIDAD", torneo.premio "PREMIO" 
FROM club_partido, estadio, torneo, codigo_postal, de_torneo 
  WHERE club_partido.codigo = de_torneo.codigo 
    AND de_torneo.identificador = torneo.identificador 
    AND club_partido.nombre = estadio.nombre 
    AND club_partido.cod_postal = estadio.cod_postal 
    AND club_partido.cod_postal = codigo_postal.cod_postal 
    AND club_partido.codigo LIKE '%F';
/* Jugadores más bajos de 200cm y que jueguen como BASE*/
SELECT jugador.nombre||' '||jugador.apellido "JUGADOR", jugador.f_nacimiento "FECHA DE NACIMIENTO", jugador.altura "ALTURA < 200CM", jugador.lesionado "LESION (1=SI, 0=NO)"
FROM jugador
  WHERE jugador.dni IN ( (SELECT dni FROM jugador WHERE altura < 200)
                         INTERSECT
                         (SELECT dni FROM jugador WHERE jugador.posicion = 'BASE') )
  ORDER BY 3;
/* Partidos clasificatorios de 2022, ordenados por fecha, con el club que pasa al torneo y el premio al que opta*/
SELECT club_partido.fecha "FECHA DEL ENCUENTRO (2022)", club_ganador.nombre "CLUB GANADOR", torneo.nombre "TORNEO AL QUE OPTA", TO_CHAR(torneo.premio,'999999.99')||'€' "PREMIO"
FROM club_partido, clasificatorio, club club_ganador, torneo
WHERE club_partido.ganador = club_ganador.cif
  AND club_partido.codigo = clasificatorio.codigo
  AND clasificatorio.identificador = torneo.identificador
  AND club_partido.codigo LIKE '%C' AND club_partido.fecha LIKE '%/22';