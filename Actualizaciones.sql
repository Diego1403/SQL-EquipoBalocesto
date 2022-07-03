/*ACTUALIZACIONES*/
/* 1 - Disminuye un 5% el precio de compra de un jugador si está lesionado*/
UPDATE contrato con
SET con.precio_compra = (con.precio_compra - (con.precio_compra*0.05))
WHERE con.dni IN (SELECT contr.dni
      FROM contrato contr,jugador j
      WHERE j.dni=contr.dni AND j.lesionado=1);

/* 2 - Los jugadores con entrenadores que viven en la localidad de "Andujar" estaran lesionados*/
UPDATE jugador j
SET j.lesionado = 1
WHERE j.cif IN (SELECT ju.cif
                	FROM jugador ju, club cl, entrenador ent, codigo_postal cp
                	WHERE ju.cif = cl.cif 
AND cl.dni= ent.dni 
AND cp.cod_postal=ent.cod_postal 
AND cp.localidad = 'Andujar');

/* 3 - Aumentar un 15% la capacidad del estadio si es en la localidad de Linares*/
UPDATE estadio est
SET est.capacidad= (est.capacidad + (est.capacidad*0.15))
WHERE est.cod_postal IN (SELECT esta.cod_postal
                        FROM estadio esta,codigo_postal cp
                        WHERE esta.cod_postal=cp.cod_postal AND cp.localidad='Linares');
