/* BORRADOS */
/* 1 - Borrar a los entrenadores que hayan nacido antes de 1976 y cuyos clubes hayan ganado en 2 o más partidos*/
ALTER TABLE entrenador DISABLE CONSTRAINT pk_entrenador CASCADE;
DELETE FROM entrenador
  WHERE entrenador.dni IN (SELECT dni FROM entrenador 
                           WHERE dni IN (SELECT club.dni FROM club, club_partido 
                                         WHERE (club_partido.ganador = club.cif) GROUP BY club.dni HAVING COUNT(*)>2) 
                           AND f_nacimiento < '01/01/1976');
ALTER TABLE entrenador ENABLE CONSTRAINT pk_entrenador;
/* 2 - Borrar los partidos clasificatorios del torneo 1000 donde haya ganado un club con mas 3 jugadores lesionados*/
DELETE FROM club_partido
  WHERE club_partido.ganador IN ((SELECT cif FROM jugador WHERE lesionado = 1 GROUP BY cif HAVING COUNT(*)>3)
                                  INTERSECT
                                 (SELECT ganador FROM club_partido WHERE codigo = 'B1000C'))
  AND codigo = 'B1000C';
/* 3 - Borrar los jugadores valorados (precio de venta) entre 80 y 100M (incluidos) y que estén lesionados */
ALTER TABLE jugador DISABLE CONSTRAINT pk_jugador CASCADE;
DELETE FROM jugador
  WHERE jugador.dni IN (SELECT dni FROM jugador 
                        WHERE dni IN (SELECT dni FROM contrato 
                                      WHERE precio_venta >= 80000000 AND precio_venta <= 100000000)
                        AND lesionado = 1);
ALTER TABLE jugador ENABLE CONSTRAINT pk_jugador;