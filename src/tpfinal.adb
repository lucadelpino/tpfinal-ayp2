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
