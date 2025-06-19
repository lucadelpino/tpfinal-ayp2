with Ada.Text_IO,
 	Ada.Strings.Unbounded,
 	Ada.Text_IO.Unbounded_IO,
 	Ada.Integer_Text_IO,
 	Ada.Float_Text_IO,
 	fechas,
 	utiles,
 	arbol,
 	cola,
 	lista;

use Ada.Text_IO,
	Ada.Strings.Unbounded,
	Ada.Text_IO.Unbounded_IO,
	Ada.Integer_Text_IO,
	Ada.Float_Text_IO,
	fechas,
	utiles;

procedure tpfinal is

   --ENUMERADOS

   type tCategoria is (rol, estrategia, accion, aventura, arcade, puzzle, deporte, supervivencia, sandbox);

   type tEdad is (ATP, e12, e15, e18);

   type tPremiado is (oro, plata, bronce, nada);

   --REGISTROS

   type tMedallas is record
      oro: integer;         --cantidad de medallas de oro ganadas
      plata: integer;       --cantidad de medallas de plata ganadas
      bronce: integer;      --cantidad de medallas de bronce ganadas
      premioGanado: float;  --acumulador de premios recibidos
   end record;

   type tUltimo is record
      titulo: Unbounded_String;       --Título de juego
      fecha: tFecha;	                 --Fecha de compra o alquiler
      importe: float;                 --precio de la compra o alquiler
      cantDias: integer;	             --cantidad de días alquilados, si tiene 0 días significa que es una compra.
   end record;

   --ABB JUEGOS

   subtype tClaveJuego is Unbounded_String;

   type tInfoJuego is record
       desarrollador: Unbounded_String;	 --desarrollador del juego
		descripcion: Unbounded_String;	    --reseña descriptiva
       categoria: tCategoria;              --Genero del juego
		edad: tEdad;                       --Representa el nivel de violencia/desnudez
		precio: float;                     --importe de un ejemplar
		stock: integer;                    --cantidad de ejemplares disponibles
		alquilados: integer;               --cantidad de juegos alquilados
       vendidos: integer;                 --cantidad de ejemplares del juego vendidos
   end record;

   package abbJuegos is new arbol(tClaveJuego, tInfoJuego, ">", "<", "=");
   use abbJuegos; use abbJuegos.ColaRecorridos;

   --LO COMPRA

   type tInfoCompra is record
		importe: float;            --importe de la compra
		cantidad: integer;         --cantidad de unidades que se compran (del mismo juego)
		fecha: tFecha;             --fecha de la compra
   end record;

   package listaCompras is new lista(tClaveJuego, tInfoCompra, "<", "=");
   use listaCompras;

   --LO ALQUILERES

   type tInfoAlquiler is record
		fInicio: tFecha;				--Fecha de inicio del alquiler
		duracion: integer;			--Duración del alquiler
		devuelto: boolean;			--Estado del alquiler
		totalAlquiler: float;		--Cantidad total a pagar
		fechaDev: tFecha;           --fecha de devolución del juego
		importeMulta: float;        --importe que debe pagar si devuelve con retraso
   end record;

   package listaAlquiler is new lista(tClaveJuego, tInfoAlquiler, "<", "=");
   use listaAlquiler;

   --ABB CLIENTES

   subtype tClaveCliente is integer;

   type tInfoCliente is record
      nombre: Unbounded_String;			           --Nombre del cliente
      apellido: Unbounded_String;		           --Apellido del cliente
      fechaNacimiento: tFecha;     	           --Fecha de nacimiento del cliente
      direccion: Unbounded_String;		           --Dirección del cliente
      sancionado: boolean;         	           --Verificación si tiene deuda
      cantDeuda: float;     			           --Cantidad de deuda
      cantJuegos: integer;      		           --Cantidad de juegos del cliente.
      creditos: integer;    			           --Cantidad de créditos del cliente.
      importeTotal: float;      		           --Cantidad gastado en total
      cantTorneos: integer;     		           --Cantidad de torneos participados
      medallas: tMedallas;      		           --Cantidad de medallas ganadas
      alquileres: listaAlquiler.tipoLista;       --alquileres de cada juego
      ultimoAlquier: tUltimo;	                  --Registro del último alquiler
      compras: listaCompras.tipoLista;		       --compras realizadas
      ultimaCompra: tUltimo;		              --Registro de la última compra
   end record;

   package abbClientes is new arbol(tClaveCliente, tInfoCliente, ">", "<", "=");
   use abbClientes; use abbClientes.ColaRecorridos;

   --LO INSCRIPTOS

   type tInfoInscriptos is record
	   descalificacion: boolean;			--Estado del cliente
	   premiado: tPremiado;			    	--Premios de los clientes
   end record;

   package listaInscriptos is new lista(tClaveCliente, tInfoInscriptos, "<", "=");
   use listaInscriptos;

   --ABB TORNEOS

   subtype tClaveTorneos is Unbounded_String;

   type tInfoTorneos is record
      juego: tClaveJuego;		              --Título del juego
      lema: Unbounded_String;				    --Lema del torneo
      importe: float;			              --Importe de inscripción al torneo
      fecha: tFecha;			                  --Fecha del torneo
      premio: float;			              	--Cantidad total del premio
      inscriptos: listaInscriptos.tipoLista;	--Participantes del torneo
   end record;

   package abbTorneos is new arbol(tClaveTorneos, tInfoTorneos, ">", "<", "=");
   use abbTorneos; use abbTorneos.ColaRecorridos;

   MAX: constant integer:= 10;

   --ARREGLO JUEGOS MAS VENDIDOS

   type tInfoTopVendidos is record
      titulo: tClaveJuego;
      vendidos: integer;
   end record;

   type tTopVendidos is array (1..MAX) of tInfoTopVendidos;

   --ARREGLO CLIENTES MAS COMPRADORES

   type tInfoCompradores is record
      dni: tClaveCliente;
      totalGastado: float;
   end record;

   type tCompradores is array (1..MAX) of tInfoCompradores;

   ----------------------------------------------------------------------------NIVEL 5--------------------------------------------------------------------------------------------
-- QH: Muestra las categorías de juegos y devuelve la categoría elegida por el usuario.
-- PRE: -
-- POS: categorias = N y N es el valor de la categoria seleccionada
-- EXC: -
function categorias return Integer is
   opcion : Integer;
begin
   mostrar("CATEGORÍAS");
   mostrar("1. Rol");
   mostrar("2. Estrategia");
   mostrar("3. Acción");
   mostrar("4. Aventura");
   mostrar("5. Arcade");
   mostrar("6. Puzzle");
   mostrar("7. Deporte");
   mostrar("8. Supervivencia");
   mostrar("9. Sandbox");
   opcion := enteroEnRango("Seleccione una categoria", 1, 9); -- ÚTILES
   return opcion;
end categorias;

-- QH: Muestra las opciones de edad sugerida y devuelve la opción elegida por el usuario.
-- PRE: -
-- POS: edad = D y D es el valor de la opción elegida por el usuario.
-- EXC: -
function edad return Integer is
   opcion : Integer;
begin
   mostrar("Clasificación por nivel de violencia");
   mostrar("1. ATP");
   mostrar("2. +12");
   mostrar("3. +15");
   mostrar("4. +18");
   opcion := enteroEnRango("Seleccione la edad sugerida:", 1, 4); -- ÚTILES
   return opcion;
end edad;

-- QH: Muestra todos los datos de un juego
-- PRE: k = K, i = I
-- POS: -
-- EXC: -
procedure mostrarJuego(k : in tClaveJuego; i : in tInfoJuego) is
begin
   mostrar("Título: ", k);
   mostrar("Desarrollador: ", i.desarollador);
   mostrar("Descripción: ", i.descripcion);
   mostrar("Categoría: ", i.categoria);
   mostrar("Precio: ", i.precio);
   mostrar("Juegos Vendidos: ", i.vendidos);
   mostrar("Total alquilados: ", i.alquilados);
   mostrar("Stock: ", i.stock);
   mostrar("Edad sugerida: ", i.edad);
end mostrarJuego;

-- QH: Determina si la cantidad de créditos es suficiente para obtener un descuento en compras (mínimo 1000 créditos).
-- PRE: creditos = C y C >= 0
-- POS: creditosSuficientes = verdadero si creditos >= 1000, sino creditosSuficientes = falso.
-- EXC: -
function creditosSuficientes(creditos : Integer) return Boolean is
begin
   return creditos >= 1000;
end creditosSuficientes;

-- QH: Registra los datos de la compra en la lista de compras de un cliente.
-- PRE: compras = C, kJuego = K, cant = CANT y precio = P
-- POS: compras = C1 y C1 es C pero con la nueva compra guardada
-- EXC: listaLlena, claveExiste
procedure registroCompra(compras : in out listaCompras; kJuego : in tClaveJuegos; cant : in Integer; precio : in Float) is
   compra : tInfoCompra;
begin
   compra.importe := precio;
   compra.cantidad := cant;
   compra.fecha := fechaHoy();
   insertar(compras, kJuego, compra); -- ADT ABB
end registroCompra;

-- QH: Calcula la cantidad de créditos que corresponden según el total gastado.
-- PRE: totalGastado >= 0
-- POS: modificarCreditos = M y M es la cantidad de créditos que le corresponden al total gastado.
-- EXC: --
function modificarCreditos(totalGastado : Float) return Integer is
   valorCred : constant Integer := 1000;
   creditos : Integer := 0;
   tempGastado : Float := totalGastado;
begin
   while tempGastado >= Float(valorCred) loop
      tempGastado := tempGastado - Float(valorCred);
      creditos := creditos + 1;
   end loop;
   return creditos;
end modificarCreditos;

-- QH: Asigna los datos de la última compra
-- PRE: kJuego = K y precio = P y P > 0.
-- POS: ultimaCompra = U y U contiene los datos de la última compra
-- EXC: -
procedure registrarUltimaCompra(ultimaCompra : in out tUltimo; kJuego : in tClaveJuegos; precio : in Float) is
begin
   ultimaCompra.titulo := kJuego;
   ultimaCompra.fecha := fechaHoy();  -- FECHAS
   ultimaCompra.importe := precio;
   ultimaCompra.cantDias := 0;
end registrarUltimaCompra;

   ----------------------------------------------------------------------------NIVEL 4--------------------------------------------------------------------------------------------


   ----------------------------------------------------------------------------NIVEL 3--------------------------------------------------------------------------------------------

--QH: Determina si existe un juego.
--PRE: a=A y kJuegos=K
--POS: existeJuego=verdadero si existe K en A, sino existeJuego=falso.
--EXC:-
function existeJuego(a : abbJuegos.tipoArbol; kJuegos : tClaveJuegos) return Boolean is
   iJuegos : tInfoJuegos;
begin
   buscar(a, kJuegos, iJuegos);   -- ADT ABB
   return True;
exception
   when claveNoExiste =>
      return False;
end existeJuego;

--QH: Devuelve la información de un juego para dar de alta en el sistema.
--PRE:--
--POS: iJuego= I y I tiene la información del juego.
--EXC: -
procedure ingresoDatosJuego(iJuego : out tInfoJuegos) is
begin
   iJuego.desarrollador := textoNoVacio("Ingrese el desarrollador");       -- ÚTILES
   iJuego.descripcion   := textoNoVacio("Ingrese la reseña descriptiva");  -- ÚTILES
   pedirCategoria(iJuego.categoria);                                       -- NIVEL 4
   ingresoEdad(iJuego.edad);                                               -- NIVEL 4
   iJuego.precio := cargarPrecio();                                        -- NIVEL 4

   loop
      iJuego.stock := numeroEnt("Ingrese la cantidad de stock");           -- ÚTILES
      exit when iJuego.stock >= 0;
   end loop;

   iJuego.alquilados := 0;
   iJuego.vendidos   := 0;
end ingresoDatosJuego;

--QH: Inserta un juego en el ABB de juegos.
--PRE: juegos = J
--POS: juegos=J1 y J1 es J con un juego nuevo.
--EXC:-
procedure guardarJuego(juegos : in out abbJuegos.tipoArbol; k : tClaveJuegos; i : tInfoJuegos) is
begin
   insertar(juegos, k, i);  -- ADT ABB
exception
   when arbolLleno =>
      mostrar("No se pudo guardar el juego. Inténtelo más tarde");
end guardarJuego;

--QH:Elimina un juego si el usuario lo desea.
--PRE: juegos = J, kJuego = K y K existe en J.
--POS:	juegos = J1 y J1 es J sin el juego de clave K.
--EXC: -
procedure eliminarJuego(juegos : in out abbJuegos.tipoArbol; kJuego : tClaveJuegos) is
begin
   if confirma("¿Desea eliminar el juego?") then        -- ÚTILES
      suprimir(juegos, kJuego);                          -- ADT ABB
      mostrar("Juego eliminado");
   else
      mostrar("Eliminación cancelada");
   end if;
end eliminarJuego;

--QH: Modifica los datos de un juego hasta que el usuario no desee seguir modificando.
--PRE: iJuego = I y I contiene la información de un juego.
--POS: iJuegos = I1 y I1 es I con los datos modificados.
--EXC: -
procedure modificarDatosJuegos(iJuego : in out tInfoJuegos) is
   mod : Integer;
begin
   loop
      mod := menuModificarJuego();   -- NIVEL 4
      case mod is
         when 1 => iJuego.desarrollador := textoNoVacio("Desarrollador: ");      -- ÚTILES
         when 2 => iJuego.descripcion   := textoNoVacio("Ingrese la reseña descriptiva");  -- ÚTILES
         when 3 => pedirCategoria(iJuego.categoria);                              -- NIVEL 4
         when 4 => ingresoEdad(iJuego.edad);                                      -- NIVEL 4
         when 5 => iJuego.precio := cargarPrecio();                               -- NIVEL 4
         when others => null;
      end case;
      exit when not confirma("¿Quiere modificar algo más?");
   end loop;
end modificarDatosJuegos;

--QH:Inicializa el arreglo del top 10
--PRE: MAX = M y M > 0.  
--POS: top = T y T[i].titulo=”” y T[i].vendidos=-1 para todo T[i]∈T.
--EXC: -
procedure inicializarTop10(top : out tTopVendidos; MAX : Integer) is
begin
   for i in 1 .. MAX loop
      top(i).titulo  := "";
      top(i).vendidos := -1;
   end loop;
end inicializarTop10;

--QH: Busca y agrega los 10 juegos más vendidos al arreglo del top 10
--PRE: juegos = J, top = T
--POS:top = T1 y T1 es T con el top 10 juegos más vendidos del mes, dim = N y N es la dimensión lógica del arreglo.
--EXC: -
procedure buscarTop10(juego : abbJuegos.tipoArbol; top : in out tTopVendidos; dim : out Integer) is
   q : colaAuxJuegos;
   kJuego : tClaveJuegos;
   iJuego : tInfoJuegos;
begin
   crear(q);										-- ADT COLA
   preOrder(juego, q);								-- ADT ABB
   dim := 0;
   while not esVacia(q) loop							-- ADT COLA
      frente(q, kJuego);								-- ADT COLA
      desencolar(q);									-- ADT COLA
      buscar(juego, kJuego, iJuego);					-- ADT ABB
      if dim < 10 then
         insertarJuego(top, dim, iJuego, kJuego);	-- NIVEL 4
         dim := dim + 1;
      else
         if iJuego.vendidos > top(dim).vendidos then
            insertarJuego(top, dim - 1, iJuego, kJuego);	-- NIVEL 4
         end if;
      end if;
   end loop;
exception
   when errorEnCola =>
      mostrar("Se produjo un error al listar juegos. Inténtelo más tarde.");
end buscarTop10;

--QH: Muestra el top 10 de los juegos más vendidos
--PRE: juegos=J,top = T y T[i].titulo existe en J para todo T[i]∈T, dim=D y D > 0
--POS: -
--EXC: -
procedure mostrarTop10(juegos : abbJuegos.tipoArbol; top : tTopVendidos; dim : Integer) is
   iJuego : tInfoJuegos;
begin
   for i in 1 .. dim loop
      buscar(juegos, top(i).titulo, iJuego);	
      mostrar("Posición del top: ", i);
      mostrar("Título: ", iJuego.titulo);
      mostrar("Desarrollador: ", iJuego.desarrollador);
      mostrar("Categoría: ", iJuego.categoria);
      mostrar("Nivel de violencia: ", iJuego.edad);
      mostrar("La cantidad de vendidos es: ", iJuego.vendidos);
      continua("¿continua con el top?");
   end loop;
end mostrarTop10;

--QH: Genera un listado de juegos filtrados por categoría recibida por parámetro.
--PRE: juegos=J, cat=C, q=Q y Q está vacía.
--POS: q=Q1 y Q1 está vacía.
--EXC: -
procedure crearListadoCat(juegos : abbJuegos.tipoArbol; cat : tCategorias; q : in out colaAuxJuegos) is
begin
   inOrder(juegos, q);							-- ADT ABB
   mostrarCategoria(cat, juegos, q);				-- NIVEL 4
exception
   when errorEnCola =>
      mostrar("Se ha producido un error al mostrar los juegos. Inténtelo más tarde.");
end crearListadoCat;

--QH: Pide al usuario el DNI de un cliente y retorna su información.
--PRE: cliente=C
--POS: k=K y K es el DNI del cliente, i=I y I es la información del cliente K.
--EXC: -
procedure PedirDatosCliente(cliente : abbClientes.tipoArbol; k : out tClaveCliente; i : out tInfoCliente) is
   Esta : Boolean := True;
begin
   loop
      k := enteroEnRango("Ingrese el DNI del cliente", 10000000, 99999999);	-- ÚTILES
      begin
         buscar(cliente, k, i);							-- ADT ABB
         exit;
      exception
         when claveNoExiste =>
            Esta := False;
            mostrar("El cliente no se encuentra registrado");
      end;
   end loop until Esta;
end PedirDatosCliente;

--QH: Pide al usuario el título de un juego y retorna su información.
--PRE: juegos=J
--POS: k=K y K es el título del juego, i=I y I es la información del juego K.
--EXC: –
procedure obtenerJuegoDisponible(juego : abbJuegos.tipoArbol; k : out tClaveJuegos; i : out tInfoJuegos) is
   Esta : Boolean := False;
begin
   loop
      k := textoNoVacio("Ingrese el título del juego");	-- ÚTILES
      begin
         buscar(juego, k, i);							-- ADT ABB
         Esta := True;
         if i.stock = 0 then
            mostrar("Juego no Disponible");
         else
            mostrar("Juego Disponible");
         end if;
      exception
         when claveNoExiste =>
            Esta := False;
            mostrar("Juego no existe");
      end;
      exit when Esta;
   end loop;
end obtenerJuegoDisponible;

--QH: se pide al usuario los datos de la compra y se actualizan los registros de compra. 
--PRE: juegos = J, kJuego = KJ y KJ existe en J, clientes = C, kCliente = KC y KC existe en C.
--POS: juegos=J1 y J1 es J con el stock y cantidad de vendidos del juego KJ actualizados, clientes=C1 y C1 es C con los registros de compras del cliente KC actualizados.
--EXC: - 
procedure realizarCompra(juegos : in out abbJuegos.tipoArbol; kJuego : tClaveJuegos; clientes : in out abbClientes.tipoArbol; kCliente : tClaveCliente) is
   iJuego   : tInfoJuegos;
   iCliente : tInfoCliente;
   cant     : Integer;
   precioFinal : Float;
begin
   buscar(clientes, kCliente, iCliente);	-- ADT ABB
   buscar(juegos, kJuego, iJuego);			-- ADT ABB
   cant := enteroEnRango("Ingrese cuantos ejemplares desea comprar", 0, iJuego.stock);
   if cant > 0 then
      precioFinal := calculoImporte(iJuego.precio, cant, iCliente.creditos);	-- NIVEL 4
      mostrar("El total a pagar es: $", precioFinal);
      AnadirCompra(clientes, kCliente, juegos, kJuego, cant, precioFinal);	-- NIVEL 4
   end if;
end realizarCompra;

--QH: Determina si existe un cliente en el árbol.
--PRE: clientes=C y k=K
--POS: existeCliente=verdadero si existe K en C, sino existeCliente=falso.
--EXC: -
function existeCliente(cliente : abbClientes.tipoArbol; k : tClaveCliente) return Boolean is
   i : tInfoCliente;
begin
   buscar(cliente, k, i);				-- ADT ABB
   return True;
exception
   when claveNoExiste =>
      return False;
end existeCliente;

--QH: Carga todos los campos necesarios para inicializar un nuevo cliente.
--PRE:-
--POS: i=I y I tiene la información de un nuevo cliente.
--EXC: -
procedure cargarInfoCliente(i : out tInfoCliente) is
begin
   cargarNombre(i.nombre, i.apellido);       -- NIVEL 4
   cargarFecha(i.fechaNacimiento);           -- NIVEL 4
   cargarDireccion(i.direccion);             -- NIVEL 4
   cargarListas(i.alquiler, i.compras);      -- NIVEL 4
   i.sancionado := False;
   iniDatosCero(i);							-- NIVEL 4
   iniMedalla(i.medallas);					-- NIVEL 4
   iniUltimo(i.ultimoAlquiler);				-- NIVEL 4
   iniUltimo(i.ultimaCompra);					-- NIVEL 4
end cargarInfoCliente;

--QH: Muestra en pantalla los datos del cliente.
--PRE: cliente=C, k=K y K existe en C.
--POS: -
--EXC: -
procedure mostrarCliente(k : tClaveCliente; cliente : abbClientes.tipoArbol) is
   i : tInfoCliente;
begin
   buscar(cliente, k, i);					-- ADT ABB
   mostrar(i.nombre, " ", i.apellido);
   mostrar("DNI: ", k);
   mostrar("Dirección: ", i.direccion);
   mostrar("Deuda: ", i.cantDeuda);
   mostrar("cantidad de juegos: ", i.cantJuegos);
   mostrar("Creditos: ", i.creditos);
   mostrar("Total gastado: ", i.importeTotal);
   mostrar("Torneos participados: ", i.cantTorneos);
   mostrarMedallas(i.medallas);				-- NIVEL 4
   mostrarUltimaCompra(i.ultimaCompra);		-- NIVEL 4
   mostrarUltimoAlquiler(i.ultimoAlquiler);	-- NIVEL 4
   mostrar("nacimiento: ", fechaTexto(i.fechaNacimiento));	-- FECHAS
   if i.sancionado then
      mostrar("usuario sancionado");
   else
      mostrar("cliente ejemplar");
   end if;
end mostrarCliente;

--QH: Permite modificar uno o más datos de un cliente mientras el usuario lo desee.
--PRE: i=I y tiene cargado un cliente válido.
--POS: i=I1 y I1 es I el cual actualiza los campos válidos.
--EXC: –
procedure modificarDatosCliente(i : in out tInfoCliente) is
   opcion : Integer;
begin
   loop
      opcion := opcionesCliente();			-- NIVEL 4
      case opcion is
         when 1 => cargarNombre(i.nombre, i.apellido);	-- NIVEL 4
         when 2 => cargarFecha(i.fechaNacimiento);		-- NIVEL 4
         when 3 => cargarDireccion(i.direccion);			-- NIVEL 4
         when others => null;
      end case;
      exit when not confirma("¿Desea cambiar otro dato?");
   end loop;
end modificarDatosCliente;

--QH:Inicializa el arreglo del top 10 compradores
--PRE: MAX = M y M > 0.  
--POS: top = T y T[i].dni=0 y T[i].totalGastado=-1 para todo T[i]∈T.
--EXC: -
procedure inicializarTop10Compradores(top : out tCompradores; MAX : Integer) is
begin
   for i in 1 .. MAX loop
      top(i).dni := 0;
      top(i).totalGastado := -1;
   end loop;
end inicializarTop10Compradores;

--QH: Busca y agrega los 10 clientes más compradores del arreglo del top 10
--PRE: clientes=C , top = T
--POS: top = T1 y T1 es T con el top 10 clientes más compradores del mes, dim = N y N es la dimensión lógica del arreglo y N>=0.
--EXC: -
procedure buscarTop10Compradores(clientes : abbClientes.tipoArbol; top : in out tCompradores; dim : out Integer) is
   q : colaAuxCliente;
   dni : tClaveCliente;
   info : tInfoCliente;
begin
   crear(q);					-- ADT COLA
   preOrder(clientes, q);		-- ADT ABB
   dim := 0;
   while not esVacia(q) loop	-- ADT COLA
      frente(q, dni);			-- ADT COLA
      desencolar(q);			-- ADT COLA
      buscar(clientes, dni, info);	-- ADT ABB
      if dim < 10 then
         insertarCliente(top, dim, dni, info.totalGastado);	-- NIVEL 4
         dim := dim + 1;
      else
         if info.totalGastado > top(dim).totalGastado then
            insertarCliente(top, dim - 1, dni, info.totalGastado);	-- NIVEL 4
         end if;
      end if;
   end loop;
exception
   when errorEnCola =>
      mostrar("Error al listar clientes,intente nuevamente");
end buscarTop10Compradores;

--QH: Muestra el top 10 de los clientes más compradores.
--PRE: clientes=C,top = T y T[i].dni existe en C para todo T[i]∈T, dim=D y D >= 0
--POS: -
--EXC: - 
procedure mostrarTop10Compradores(clientes : abbClientes.tipoArbol; top : tCompradores; dim : Integer) is
   info : tInfoCliente;
begin
   for i in 1 .. dim loop
      buscar(clientes, top(i).dni, info);	-- ADT ABB
      mostrar("Posición ", i);
      mostrar("DNI: ", top(i).dni);
      mostrar("Nombre: ", info.nombre, " ", info.apellido);
      mostrar("Juegos comprados: ", info.juegos);
      mostrar("Total gastado $: ", top(i).totalGastado);
   end loop;
end mostrarTop10Compradores;

--QH: Actualiza el campo de créditos y total gastado de un cliente.
--PRE: cliente=C,k=K y K existe en C, importe=I y n=N.
--POS:cliente=C1 y C1 es C con los campos de créditos y total gastado de un cliente actualizado.
--EXC: -
procedure acreditacion(cliente : in out abbClientes.tipoArbol; k : tClaveCliente; importe : Float; n : Integer) is
   i : tInfoCliente;
begin
   buscar(cliente, k, i);				-- ADT ABB
   i.totalGastado := i.totalGastado + importe;
   i.creditos := i.creditos + n;
   modificar(cliente, k, i);				-- ADT ABB
end acreditacion;

   ----------------------------------------------------------------------------NIVEL 2--------------------------------------------------------------------------------------------
--*QH: Muestra las opciones del menú de juegos y devuelve la opción elegida por el usuario.
--PRE: -
--POS: menuJuego = N y N es la opción elegida del menú
--EXC: -
function menuJuego return Integer is
   opcion : Integer;
begin
   put_line("MENÚ JUEGOS");
   put_line("1. Alta de juego");
   put_line("2. Baja de juego");
   put_line("3. Modificar juego");
   put_line("4. Top 10 juegos más vendidos");
   put_line("5. Lista de Juegos según categoría");
   put_line("6. Compras");
   put_line("7. Alquileres");
   put_line("0. Volver");
   opcion := enteroEnRango("Ingrese una opción", 0, 7); -- ÚTILES
   return opcion;
end menuJuego;

--*QH: Carga un nuevo juego de la empresa.
--PRE: juegos = A 
--POS: juegos = A1 y A1 es A con un nuevo juego.
--EXC: -
procedure AltaJuego (juegos: in out abbJuegos.tipoArbol) is
   iJuego : tInfoJuegos;
   kJuego : tClaveJuegos;
begin
   loop
      kJuego := textoNoVacio("Ingrese el título del juego"); -- ÚTILES
      if existeJuego(juegos, kJuego) then                      -- NIVEL 3
         put_line("El juego ingresado ya existe");
      else
         put_line("Ingrese los datos del juego");
         ingreseDatosJuegos(iJuego);                           -- NIVEL 3
         guardarJuego(juegos, kJuego, iJuego);                 -- NIVEL 3
      end if;
      exit when not confirma("¿Desea cargar otro juego?");    -- ÚTILES
   end loop;
end AltaJuego;

--*QH: Se dan de baja uno o más juegos mientras el usuario lo desee.
--PRE: juegos = J
--POS: juegos = J1 y J1 es J sin los juegos eliminados.
--EXC: -
procedure BajarJuego (juegos: in out abbJuegos.tipoArbol) is
   kJuego : tClaveJuegos;
   iJuego : tInfoJuegos;
begin
   loop
      kJuego := textoNoVacio("Ingrese el título del juego"); -- ÚTILES
      if not existeJuego(juegos, kJuego) then                 -- NIVEL 3
         put_line("El juego ingresado no existe");
      else
         buscar(juegos, kJuego, iJuego);                       -- ADT ABB
         mostrarJuego(kJuego, iJuego);                         -- NIVEL 5
         if iJuego.alquilados = 0 then
            eliminarJuego(juegos, kJuego);                     -- NIVEL 3 
         else
            put_line("No puede darse de baja el juego mientras esté alquilado");
         end if;
      end if;
      exit when not confirma("¿Desea borrar otro juego?");    -- ÚTILES
   end loop;
end BajarJuego;

--*QH: Modifica la información de juegos mientras el usuario desee.
--PRE: juegos = J y J tiene juegos cargados.
--POS: juegos = J1 y J1 es J pero con uno o más juegos modificados.
--EXC: -
procedure ModificarJuego (juegos: in out abbJuegos.tipoArbol) is
   kJuego : tClaveJuegos;
   iJuego : tInfoJuegos;
begin
   loop
      kJuego := textoNoVacio("Ingrese el juego que desea modificar");
      if existeJuego(juegos, kJuego) then                             -- NIVEL 3
         buscar(juegos, kJuego, iJuego);                              -- ADT ABB
         mostrarJuego(kJuego, iJuego);                                -- NIVEL 5
         if confirma("¿Quiere modificar este juego?") then            -- ÚTILES
            modificarDatosJuegos(iJuego);                             -- NIVEL 3
            modificar(juegos, kJuego, iJuego);                        -- ADT ABB
         end if;
      else
         put_line("El juego ingresado no se encuentra");
      end if;
      exit when not confirma("¿Desea modificar los datos de otro juego?");  -- ÚTILES
   end loop;
end ModificarJuego;

--*QH: Genera y muestra el top 10 de juegos más vendidos del mes.
--PRE: juego = J
--POS: -
--EXC: -
procedure Top10Juegos (juego: in abbJuegos.tipoArbol) is
   MAX : constant Integer := 10;
   top : tTopVendidos;
   dim : Integer;
begin
   inicializarTop10(top, MAX);        -- NIVEL 3
   buscarTop10(juego, top, dim);     -- NIVEL 3
   mostrarTop10(juego, top, dim);    -- NIVEL 3
end Top10Juegos;

--*QH: Crea un listado según una categoría.
--PRE: juegos = J
--POS: -
--EXC: -
procedure ListarCategoria (juegos: in abbJuegos.tipoArbol) is
   cat : tCategoria;
   q   : colaAuxJuegos;
begin
   crear(q);                    -- ADT COLA
   pedirCategoria(cat);         -- NIVEL 4
   crearListadoCat(juegos, cat, q);  -- NIVEL 3
end ListarCategoria;


--*QH: Realiza la compra de uno o más juegos mientras el usuario lo desee.
--PRE: juego = J, cliente = C
--POS: juego = J1 y J1 es J con el stock y cantidad de ejemplares vendidos de los juegos vendidos modificados;
--      cliente = C1 y C1 es C con la lista de compras del cliente indicado por el usuario modificada.
--EXC: -
procedure CompraJuegos (juego: in out abbJuegos.tipoArbol; cliente: in out abbClientes.tipoArbol) is
   iJuego  : tInfoJuegos;
   kJuego  : tClaveJuegos;
   iCliente: tInfoCliente;
   kCliente: tClaveCliente;
begin
   loop
      PedirDatosCliente(cliente, kCliente, iCliente);                           -- NIVEL 3
      if iCliente.sancionado then
         put_line("Cliente sancionado, no puede realizar compras");
      else
         obtenerJuegoDisponible(juego, kJuego, iJuego);                        -- NIVEL 3
         mostrarJuego(kJuego, iJuego);                                         -- NIVEL 5
         if (iJuego.stock > 0) and then confirma("¿Desea comprar el juego?") then
            realizarCompra(juego, kJuego, cliente, kCliente);                  -- NIVEL 3
         end if;
      end if;
      exit when not confirma("¿Desea comprar otro juego?");                    -- ÚTILES
   end loop;
end CompraJuegos;

--*QH: Realiza el alquiler de un juego y actualiza la información de alquileres.
--PRE: juegos = J, clientes = C
--POS: juegos = J1 y J1 es J con el stock y cantidad de alquilados del juego pedido al usuario actualizados;
--      clientes = C1 y C1 es C con el listado de alquileres de un cliente pedido al usuario actualizado.
--EXC: -
procedure AlquilerJuegos (juegos: in out abbJuegos.tipoArbol; clientes: in out abbClientes.tipoArbol) is
begin
   put_line("Módulo no implementado");
   continua("Presione una tecla para volver"); -- ÚTILES
end AlquilerJuegos;

--*QH: Muestra las opciones de torneos y retorna la opción ingresada por el usuario.
--PRE: -
--POS: menuTorneo = N y N es la opción elegida por el usuario.
--EXC: -
function menuTorneo return Integer is
   opcion : Integer;
begin
   put_line("MENÚ TORNEOS");
   put_line("1. Alta torneo");
   put_line("2. Baja torneo");
   put_line("3. Alta inscripción");
   put_line("4. Baja inscripción");
   put_line("5. Entrega de premios");
   put_line("0. Volver");
   opcion := enteroEnRango("Ingrese una opción", 0, 5);  -- ÚTILES
   return opcion;
end menuTorneo;

--*QH: Da de alta un torneo, registrando sus datos.
--PRE: torneos = T
--POS: torneos = T1 y T1 es T con un nuevo torneo.
--EXC: -
procedure AltaTorneo (torneos: in out abbTorneos.tipoArbol) is
begin
   put_line("Módulo no implementado");
   continua("Presione una tecla para volver"); -- ÚTILES
end AltaTorneo;

--*QH: Da de baja un torneo.
--PRE: torneos = T
--POS: torneos = T1 y T1 es T sin el torneo eliminado.
--EXC: -
procedure BajaTorneo (torneos: in out abbTorneos.tipoArbol) is
begin
   put_line("Módulo no implementado");
   continua("Presione una tecla para volver"); -- ÚTILES
end BajaTorneo;

--*QH: Registra una inscripción a un torneo.
--PRE: torneos = T, clientes = C
--POS: torneos = T1 y T1 es T con una inscripción más a un torneo;
--      clientes = C1 y C1 es C con la participación a torneos de un cliente actualizada.
--EXC: -
procedure AltaInscripcion (torneos: in out abbTorneos.tipoArbol; clientes: in out abbClientes.tipoArbol) is
begin
   put_line("Módulo no implementado");
   continua("Presione una tecla para volver"); -- ÚTILES
end AltaInscripcion;

--*QH: Da de baja la inscripción de un cliente a un torneo.
--PRE: torneos = T, clientes = C
--POS: torneos = T1 y T1 es T sin la inscripción de un torneo eliminada;
--      clientes = C1 y C1 es C con la participación a torneos de un cliente actualizada.
--EXC: -
procedure BajaInscripcion (torneos: in out abbTorneos.tipoArbol; clientes: in out abbClientes.tipoArbol) is
begin
   put_line("Módulo no implementado");
   continua("Presione una tecla para volver"); -- ÚTILES
end BajaInscripcion;

--*QH: Registra la entrega de premios de un torneo.
--PRE: torneos = T, clientes = C
--POS: clientes = C1 y C1 es C con los registros de medallas de clientes correspondientes actualizadas.
--EXC: -
procedure EntregaPremios (torneos: in abbTorneos.tipoArbol; clientes: in out abbClientes.tipoArbol) is
begin
   put_line("Módulo no implementado");
   continua("Presione una tecla para volver"); -- ÚTILES
end EntregaPremios;

--*QH: Muestra las opciones de cliente y devuelve la opción ingresada por el usuario.
--PRE: -
--POS: menuCliente = N y N es la opción elegida por el usuario.
--EXC: -
function menuCliente return Integer is
   opcion : Integer;
begin
   put_line("1. Alta cliente");                       
   put_line("2. Baja cliente");                       
   put_line("3. Modificar cliente");                  
   put_line("4. Top 10 clientes más compradores");    
   put_line("5. Compras de créditos");                
   put_line("6. Detalle del cliente");                
   put_line("0. Volver");                             
   opcion := enteroEnRango("Ingrese una opción", 0, 6); -- ÚTILES
   return opcion;
end menuCliente;

--*QH: Da de alta a un nuevo cliente solicitando y registrando sus datos.
--PRE: cliente = C
--POS: cliente = C1 y C1 es C con un nuevo cliente.
--EXC: Si el árbol está lleno, muestra un mensaje de error.
procedure AltaCliente (cliente: in out abbClientes.tipoArbol) is
   kCliente : tClaveCliente;
   iCliente : tInfoCliente;
begin
   loop
      kCliente := enteroEnRango("Ingrese el DNI de cliente", 10000000, 99999999); -- ÚTILES
      if existeCliente(cliente, kCliente) then                                    -- NIVEL 3
         put_line("Cliente ya registrado");
      else
         cargarInfoCliente(iCliente);                                             -- NIVEL 3
         insertar(cliente, kCliente, iCliente);                                   -- ADT ABB
      end if;
      exit when not confirma("¿Desea añadir otro cliente?");                      -- ÚTILES
   end loop;
exception
   when arbolLleno =>
      put_line("Ocurrió un error al cargar el cliente. Inténtelo más tarde");
end AltaCliente;

--*QH: Elimina uno o más clientes según el DNI ingresado por el usuario.
--PRE: cliente = C
--POS: cliente = C1 y C1 es C sin los clientes eliminados.
--EXC: -
procedure BajarCliente (cliente: in out abbClientes.tipoArbol) is
   k : tClaveCliente;
begin
   loop
      k := enteroEnRango("Ingrese el DNI de cliente", 10000000, 99999999);  -- ÚTILES
      if existeCliente(cliente, k) then                                     -- NIVEL 3
         mostrarCliente(k, cliente);                                        -- NIVEL 3
         if confirma("¿Está seguro de eliminar al cliente?") then
            suprimir(cliente, k);                                           -- ADT ABB
         else
            put_line("Eliminación cancelada");
         end if;
      else
         put_line("Cliente no registrado");
      end if;
      exit when not confirma("¿Desea eliminar otro cliente?");              -- ÚTILES
   end loop;
end BajarCliente;

--*QH: Modifica los datos de un cliente mientras el usuario lo desee.
--PRE: cliente=C 
--POS: cliente=C1 y C1 es C con los datos de clientes modificados.
--EXC: -
procedure ModificarCliente (cliente: in out abbClientes.tipoArbol) is
   opcion : Integer;
   k : tClavecliente;
   i : tInfoCliente; 
begin
   loop
      k := enteroEnRango ("Ingrese el DNI de cliente", 10000000, 99999999); -- ÚTILES
      if existeCliente(cliente, k) then                                     -- NIVEL 3
         buscar(cliente, k, i);                                             -- ADT ABB
         mostrarCliente(k, cliente);                                        -- NIVEL 3
         if confirma("¿Está seguro de modificar al cliente: ", k) then
            modificarDatosCliente(i);                                       -- NIVEL 3
            modificar(cliente, k, i);                                       -- ADT ABB
         end if;
      else
         put_line("Cliente no registrado");
      end if;
      exit when not confirma("¿Desea modificar otro cliente?");            -- ÚTILES
   end loop;
end ModificarCliente;

-- QH: Genera y muestra el top 10 de clientes con mayor gasto.
-- PRE: clientes=C.
-- POS: -
-- EXC: -
procedure Top10Clientes (clientes: in abbClientes.tipoArbol) is
   MAX : constant Integer := 10;
   top : tCompradores;
   dim : Integer;
begin
   inicializarTop10Compradores(top, MAX);                   -- NIVEL 3
   buscarTop10Compradores(clientes, top, dim);              -- NIVEL 3
   mostrarTop10Compradores(clientes, top, dim);             -- NIVEL 3
end Top10Clientes;

-- QH: Realiza la compra de créditos y actualiza los registros de créditos del cliente.
-- PRE: a=A 
-- POS: a=A1 y A1 es A con el saldo de créditos de un cliente actualizado.
-- EXC: -
procedure CompraCredito (a: in out abbClientes.tipoArbol) is
   porcentaje : constant Integer := 10;
   valor : constant Integer := 1000;

   n : Integer;
   importe : Float;
   k : tClavecliente;
begin
   loop
      k := enteroEnRango ("Ingrese el DNI de cliente", 10000000, 99999999); -- ÚTILES
      if existeCliente(a, k) then                                           -- NIVEL 3
         n := enteroEnRango("Ingrese la cantidad de créditos que desea comprar", 1, 9999999); -- ÚTILES
         importe := Float(n * valor) * (1.0 + Float(porcentaje) / 100.0);
         put_line("Importe total de: " & Float'Image(importe));
         if confirma("¿Desea acreditarlos?") then                           -- ÚTILES
            acreditacion(a, k, importe, n);                                 -- NIVEL 3
         else
            put_line("Acreditación cancelada");
         end if;
      else
         put_line("Cliente no registrado");
      end if;
      exit when not confirma("¿Desea cargar más créditos?");                -- ÚTILES
   end loop;
end CompraCredito;

--*QH: Muestra los datos de un cliente a partir de su DNI.
--PRE: cliente=C.
--POS: -
--EXC: -
procedure DetalleCliente (cliente: in abbClientes.tipoArbol) is
   k : tClavecliente;
begin
   loop
      k := enteroEnRango ("Ingrese el DNI de cliente", 10000000, 99999999); -- ÚTILES
      if existeCliente(cliente, k) then                                     -- NIVEL 3
         mostrarCliente(k, cliente);                                        -- NIVEL 3
      else
         put_line("Cliente no registrado");
      end if;
      exit when not confirma("¿Desea ver el detalle de otro cliente?");     -- ÚTILES
   end loop;
end DetalleCliente;

   ----------------------------------------------------------------------------NIVEL 1--------------------------------------------------------------------------------------------
   --QH: Inicializa variables globales.
   --PRE: --
   --POS: clientes = C y C está creado y vacío, juegos = J y J está creado y vacío, torneos = T y T está creado y vacío.
   --EXC: --
   procedure inicializarVar (clientes: out abbClientes.tipoArbol; juegos: out abbJuegos.tipoArbol; torneos: out abbTorneos.tipoArbol) is
   begin
      crear(clientes);
      crear(juegos);
      crear(torneos);
   end inicializarVar;


   --QH: Muestra el Menú Principal y solicita al usuario una opción válida
   --PRE:--
   --POS:menu = M Y M es la opción del usuario
   --EXC:--
   function menu return integer is
   begin
      Put_Line("MENÚ PRINCIPAL");
      Put_Line("1. Juegos");
      Put_Line("2. Torneos");
      Put_Line("3. Clientes");
      Put_Line("0. Salir");
      return enteroEnRango ("Ingrese una opción", 0, 3);              --ÚTILES
   end menu;


   --QH: Muestra un Submenú de opciones relacionadas con juegos y ejecuta la opción elegida.
   --PRE: juegos = J,clientes = C y C tiene clientes cargados.
   --POS: juegos = J1 y J1 contiene juegos de la empresa, clientes=C1 y C1 contiene clientes de la empresa, con las compras/alquileres que hayan realizado.
   --EXC:-*/
   procedure opcionJuegos (juegos: in out abbJuegos.tipoArbol; clientes: in out abbClientes.tipoArbol) is
      resp: integer;
   begin
      loop
         resp := menuJuego;                                     --NIVEL 2
         case resp is
            when 1 => AltaJuego(juegos); 	                       --NIVEL 2
            when 2 => BajarJuego(juegos);	                       --NIVEL 2
            when 3 => ModificarJuego(juegos);					  --NIVEL 2
            when 4 => Top10Juegos(juegos); 	                   --NIVEL 2
            when 5 => ListarCategoria(juegos);                  --NIVEL 2
            when 6 => CompraJuegos(juegos, clientes); 			  --NIVEL 2
            when 7 => AlquilerJuegos(juegos, clientes);         --NIVEL 2
            when others => null;
         end case;
         exit when resp = 0;
      end loop;
   end;

   --QH: Muestra un Submenú de opciones relacionadas con Torneos y ejecuta la opción elegida.
   --PRE: torneos = T y T está vacía, clientes=C y tiene datos cargados
   --POS: torneos=T1 y T1 tiene torneos registrados por la empresa, clientes=C1 y C1 tiene clientes de la empresa, con los torneos en los que participaron.
   --EXC:--
   procedure opcionTorneos (torneos: in out abbTorneos.tipoArbol; clientes: in out abbClientes.tipoArbol) is
      resp: integer;
   begin
      loop
         resp := menuTorneo;                                    --NIVEL 2
         case resp is
            when 1 => AltaTorneo(torneos); 	  	                --NIVEL 2
            when 2 => BajaTorneo(torneos);	         	         --NIVEL 2
            when 3 => AltaInscripcion(torneos, clientes);       --NIVEL 2
            when 4 => BajaInscripcion(torneos, clientes);       --NIVEL 2
            when 5 => EntregaPremios(torneos, clientes);        --NIVEL 2
            when others => null;
         end case;
         exit when resp = 0;
      end loop;
   end opcionTorneos;

   --QH:Muestra un Submenú de opciones relacionada con Clientes y ejecuta la opción elegida
   --PRE:clientes = C
   --POS:clientes= C1 y C1 es C con clientes de la empresa.
   --EXC: - */
   procedure opcionClientes (clientes: in out abbClientes.tipoArbol) is
      resp: integer;
   begin
      loop
         resp:= menuCliente;                              --NIVEL 2
         case resp is
            when 1 => AltaCliente(clientes); 	          --NIVEL 2
            when 2 => BajarCliente(clientes);	          --NIVEL 2
            when 3 => ModificarCliente(clientes);         --NIVEL 2
            when 4 => Top10Clientes(clientes);            --NIVEL 2
            when 5 => CompraCredito(clientes); 	          --NIVEL 2
            when 6 => DetalleCliente(clientes);           --NIVEL 2
            when others => null;
         end case;
         exit when resp = 0;
      end loop;
   end opcionClientes;

   ----------------------------------------------------------------------------NIVEL 0--------------------------------------------------------------------------------------------
   clientes: abbClientes.tipoArbol;
   juegos: abbJuegos.tipoArbol;
   torneos: abbTorneos.tipoArbol;
   resp: integer;

--QH: Controla el flujo principal de la aplicación, gestionando clientes, juegos y torneos.
--PRE: --
--POS: --
--EXC: --
begin
   inicializarVar(clientes, juegos, torneos);                                        --NIVEL 1
   loop
      resp := menu;                                                                  --NIVEL 1
       case resp is
          when 1 => opcionJuegos(juegos, clientes);                                  --NIVEL 1
          when 2 => opcionTorneos(torneos, clientes);                                --NIVEL 1
          when 3 => opcionClientes(clientes);                                        --NIVEL 1
          when others => null;
       end case;
       exit when resp = 0;
   end loop;
end tpfinal;
