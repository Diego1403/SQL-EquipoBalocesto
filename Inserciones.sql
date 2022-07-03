/* INSERCIONES */
/* 1 - Insertar jugador en club spursito con duracion de contrato de 5 años */
INSERT INTO CONTRATO VALUES ('16/05/2022', '16/05/2027', 500000, 600000,
                             (SELECT cif FROM club WHERE nombre ='Spursito'),
                             (SELECT dni FROM jugador WHERE (nombre ='Anibal' AND apellido = 'Vasquez'))
                            );

/* 2 - Crear partido donde juegan Arsenal y Sevillanos*/
INSERT INTO club_partido VALUES (
                                 (SELECT cif FROM club WHERE nombre = 'Arsenal'),
                                 (SELECT cif FROM club WHERE nombre = 'Sevillanos'),
                                 'A1', '14/03/2022', 'Bernabeu', 23740, 93, 92, 
                                 (SELECT cif FROM club WHERE nombre = 'Arsenal')
                                );
                                
/* 3 - Crear un nuevo club que tenga el entreador actual de sevillanos (entrena a ambos equipos )*/
INSERT INTO club VALUES ('D66666666', 'Rinconada', 2000, 53767342,
                         (SELECT dni FROM entrenador WHERE (nombres = 'Ricardo' AND apellido = 'Gareca'))
                        );
