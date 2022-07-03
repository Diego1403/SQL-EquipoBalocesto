
# SQL-EquipoBalocesto
autores:
  - Vasquez, Diego
  - Dueñas Romero, Sara
  - Martínez Muñoz, Alejandro
  - Vargas Camacho , Juan Carlos

## Descripción detallada del problema a resolver

Para poder lograr una solución ante el análisis manual de comparación , organización y mantenimiento  entre equipos de basket y todas sus relaciones , hemos optado por una base de datos que tome en cuenta diversos aspectos desde la altura del jugador hasta año de fundación de los clubes participantes . Los datos que hemos utilizado no son verídicos y sirven únicamente de ejemplo para mostrar el potencial de nuestra base de datos. Para evitar complicaciones en cuanto al almacenamiento de datos como sobrecarga de información necesaria, supondremos que un entrenador no puede entrenar para 2 equipos , existen solamente 3 tipos de partidos , el partido completo se juega en un estadio , los jugadores solo pueden jugar en una posición a la vez , 2 partidos amistosos distintos no pueden tener la misma causa y 2 equipos no pueden jugar mas que 1 partido en la misma fecha. 

## [Esquema Conceptual Modificado](https://drawsql.app/alanturin/diagrams/equipobaloncesto)


## Tablas:
  #### codigo_postal 
   * Contiene el código postal y su correspondiente localidad
  #### entrenador
   * Indica información sobre cada entrenador: dni, nombre y apellidos del entrenador, fecha de nacimiento y el código postal 
    al que pertenece
  #### club
   * Engloba información sobre los datos básicos de un club: cif,nombre del club, el año en que se fundó, en cuántos euros está valorado y el dni del entrenador
  #### jugador
   * Abarca toda la información relativa a un jugador:dni,nombre y apellidos, fecha de nacimiento, altura, si se encuentra lesionado o no, posición dentro de la cancha y el cif del club al que pertenece dicho jugador
  #### estadio
   * Indica el nombre,capacidad máxima y el código postal al que pertenece
  #### torneo
   * Contiene información sobre un identificador propio de cada torneo,nombre y el premio al que aspira el ganador
  #### tipo_partido
  *  El tipo partido sirve de vínculo entre las tablas de club partido con amistoso, clasificatorio, de_torneo y amistoso. El atributo de descripción nos brindará con un breve resumen del partido 
  #### amistoso
  *  Es un tipo específico de partido, el cuál cuenta con su propio código, una descripción y la causa de por qué se jugó
  #### de_torneo
  *  Es un tipo específica de partido, quién gane pasará directo al torneo y cuenta con un código propio, una descripción, su estado(FINAL o SEMIFINAL) y un identificador correspondiente al torneo al que pertenece
  #### clasificatorio
  *  Es un tipo específica de partido, quién gane pasará directo al torneo y cuenta con un código propio, una descripción y     un identificador correspondiente al torneo al que pertenece.
  #### club_partido
   * La tabla de club_partido sirve de enlace  central a gran parte de las tablas creadas. Sabemos que se juega en un estadio, por esta razón está relacionada a la tabla estadio. También observamos que en él juegan 2 clubes, aquí observamos 2 relaciones más donde claramente el cif servirá de clave foránea . Finalmente se debe saber que tipo de partido es y por esta razón tiene una relación enfocada a especificar que tipo de partido es, que se llama tabla
    tipo_partido.
  #### contrato
   * Para poder almacenar información relacionada con los clubes que han pertenecido anteriormente y actualmente  los
    jugadores, hemos creado esta tabla denominada contrato donde se almacena la fecha de inicio, la fecha de fin,  precio
    de compra, el precio de venta, el dni del jugador y el cif del club. La clave de esta tabla serán las fecha de inicio,
    el dni y el cif. No almacenamos la duración del contrato porque la podemos calcular con información ya obtenida.

## Vistas :
  #### ganados_por_club
  *  Muestra los partidos que haya ganado cada club
  #### jugadores_1.90
  *  Muestra los jugadores cuya estatura supera los 1.90
  #### estados_por_localidad
  * Muestra los estadios que se encuentran en cada localidad
  #### clubes_1987
  * Muestra los clubs que fueron fundados en 1970
  #### amistosos_beneficos
  * Muestra los tipos de partidos que han sido amistosos por una causa benéfica


