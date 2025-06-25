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
   package ioCategoria is new Enumeration_IO(tCategoria);
   use ioCategoria;

   type tEdad is (ATP, e12, e15, e18);
   package ioEdad is new Enumeration_IO(tEdad);
   use ioEdad;

   type tPremiado is (oro, plata, bronce, nada);
   package ioPremiado is new Enumeration_IO(tPremiado);
   use ioPremiado;

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
      ultimoAlquiler: tUltimo;	                  --Registro del último alquiler
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

   ----------------------------------------------------------------------------NIVEL 6--------------------------------------------------------------------------------------------
   --QH: convierte un enumerado de edad sugerida en una cadena.
   --PRE: edad=E
   --POS: edadATexto=C y C es E convertido a cadena.
   --EXC: -
   function edadATexto (edad: in tEdad) return string is
   begin
      case edad is
         when ATP => return "ATP";
         when e12 => return "+12";
         when e15 => return "+15";
         when e18 => return "+18";
      end case;
   end edadATexto;

   ----------------------------------------------------------------------------NIVEL 5--------------------------------------------------------------------------------------------
   --QH: Muestra las categorías de juegos y devuelve la categoría elegida por el usuario.
   --PRE: -
   --POS: categorias = N y N es el valor de la categoria seleccionada
   --EXC:-
   function categorias return integer is
   begin
      Put_Line ("CATEGORÍAS");
      Put_Line ("1. Rol");
      Put_Line ("2. Estrategia");
      Put_Line ("3. Acción");
      Put_Line ("4. Aventura");
      Put_Line ("5. Arcade");
      Put_Line ("6. Puzzle");
      Put_Line ("7. Deporte");
      Put_Line ("8. Supervivencia");
      Put_Line ("9. Sandbox");
      return enteroEnRango ("Seleccione una categoria", 1, 9);	--ÚTILES
   end categorias;

   --QH: Muestra las opciones de edad sugerida y devuelve la opción elegida por el usuario.
   --PRE:-
   --POS:edades = D y D es el valor de la opción elegida por el usuario.
   --EXC:-
   function edades return integer is
   begin
      Put_Line ("Clasificación por nivel de violencia");
      Put_Line ("1. ATP");
      Put_Line ("2. +12");
      Put_Line ("3. +15");
      Put_Line ("4. +18");
      return enteroEnRango ("Seleccione la edad sugerida:",1,4);	--ÚTILES
   end edades;

   --QH: Muestra todos los datos de un juego
   --PRE: k = K, i = I
   --POS: -
   --EXC: -
   procedure mostrarJuego (kJuego: in tClaveJuego; i: in tInfoJuego) is
   begin
      Put_Line ("Titulo: " & kJuego);
      Put_Line ("Desarrollador: " & i.desarrollador);
      Put_Line ("Descripcion: " & i.descripcion);
      Put ("Categoria: ");
      ioCategoria.Put (i.Categoria);
      New_Line;
      Put("precio: ");
      put(i.precio,Fore => 10, Aft => 2,Exp =>0);
      New_Line;
      Put_Line ("Juegos Vendidos:" & integer'Image(i.vendidos));
      Put_Line ("Total alquilados:" & integer'Image(i.alquilados));
      Put_Line ("Stock:" & integer'Image(i.stock));
      Put_Line ("Edad sugerida: " & edadATexto(i.edad));  --NIVEL 6
   end mostrarJuego;

   --QH: Determina si la cantidad de créditos es suficiente para obtener un descuento en compras (mínimo 1000 créditos).
   --PRE: creditos=C y C >= 0
   --POS: creditosSuficientes=verdadero si creditos >= 1000,sino creditosSuficientes=falso.
   --EXC: –
   function creditosSuficientes (creditos: in integer) return boolean is
   begin
      return creditos >= 1000;
   end creditosSuficientes;

   --QH: Registra los datos de la compra en la lista de compras de un cliente.
   --PRE: compras = C, kJuego = K, cant = CANT y precio = P
   --POS: compras = C1 y C1 es C pero con la nueva compra guardada
   --EXC: listaLlena, claveExiste
   procedure registroCompra (compras: in out listaCompras.tipoLista; kJuego: in tClaveJuego; cant: in integer; precio: in float) is
      compra: tInfoCompra;
   begin
      compra.importe := precio;
      compra.cantidad := cant;
      compra.fecha := fechaHoy;
      insertar(compras, kJuego, compra);			--ADT ABB
   end registroCompra;

   --QH: Calcula la cantidad de créditos que corresponden según el total gastado.
   --PRE: totalGastado >= 0
   --POS: modificarCreditos=M y M es la cantidad de créditos que le corresponden al total gastado.
   --EXC: --
   function modificarCreditos (totalGastado: in float) return integer is
      valorCred: constant := 1000.0;
      creditos: integer;
      total: float;
   begin
      creditos := 0;
      total := totalGastado;
      while total >= valorCred loop
         total := total - valorCred;
         creditos := creditos + 1;
      end loop;
      return creditos;
   end modificarCreditos;

   --QH: Asigna los datos de la última compra
   --PRE: kJuego = K y precio = P y P > 0.
   --POS: ultimaCompra = U y U contiene los datos de la última compra
   --EXC: -
   procedure registrarUltimaCompra (ultimaCompra: out tUltimo;  kJuego: in tClaveJuego; precio: in float) is
   begin
      ultimaCompra.titulo := kJuego;
      ultimaCompra.fecha := fechaHoy;                  --FECHAS
      ultimaCompra.importe := precio;
      ultimaCompra.cantDias := 0;
   end registrarUltimaCompra;

   ----------------------------------------------------------------------------NIVEL 4--------------------------------------------------------------------------------------------
   --QH: Devuelve una categoría pedida al usuario
   --PRE: -
   --POS:cat = C y C es la categoría elegida
   --EXC: -
   procedure pedirCategoria(cat: out tCategoria) is
      aux: integer;
   begin
      aux := categorias;                  --NIVEL 5
      case aux is
         when 1 => cat := rol;
         when 2 => cat := estrategia;
         when 3 => cat := accion;
         when 4 => cat := aventura;
         when 5 => cat := arcade;
         when 6 => cat := puzzle;
         when 7 => cat := deporte;
         when 8 => cat := supervivencia;
         when 9 => cat := sandbox;
         when others => null;
      end case;
   end pedirCategoria;

   --QH: Devuelve la edad sugerida de un juego, elegida por el usuario.
   --PRE: --
   --POS: edad=E y E es la edad elegida por el usuario.
   --EXC: --
   procedure ingresoEdad(edad: out tEdad) is
      aux: integer;
   begin
      aux := edades;              --NIVEL 5
      case aux is
         when 1 => edad := ATP;
         when 2 => edad := e12;
         when 3 => edad := e15;
         when 4 => edad := e18;
         when others => null;
      end case;
   end ingresoEdad;

   --QH: Devuelve el precio de un juego pedido al usuario.
   --PRE: –
   --POS: cargarPrecio=P y P>0.
   --EXC: --
   function cargarPrecio return float is
      precio: float;
   begin
      loop
         precio := numeroReal ("Ingrese el precio del juego");  --ÚTILES
         exit when precio > 0.0;
      end loop;
      return precio;
   end cargarPrecio;

   --QH: Muestra las opciones de modificación de un juego y devuelve la opción elegida por el usuario.
   --PRE:-
   --POS: menuModificarJuego = N y N es el valor entero de la opción seleccionada a modificar.
   --EXC: -
   function menuModificarJuego return integer is
   begin
      Put_Line ("Menu de modificacion");
      Put_Line ("1. Modificar el desarrollador");
      Put_Line ("2. Modificar la descripcion");
      Put_Line ("3. Modificar categoría");
      Put_Line ("4. Modificar la clasificación por nivel de violencia");
      Put_Line ("5. Modificar precio del juego");
      return enteroEnRango ("Seleccione la opción a modificar", 1, 5);    --ÚTILES
   end menuModificarJuego;

   --QH: Agrega de forma ordenada el juego al top 10 de los más vendidos.
   --PRE: top = T, dim = N, iJuego = I, kJuego = K
   --POS: top = T1 y T1 es T con un nuevo juego en el top 10.
   --EXC: -
   procedure insertarJuego (top: in out tTopVendidos; dim: in integer; iJuego: in tInfoJuego; kJuego: in tClaveJuego) is
      i: integer;
   begin
      i := dim;
      while i >= 1 loop
         if iJuego.vendidos > top(i).vendidos then
            top(i + 1) := top(i);
            i := i - 1;
         else
            exit;
         end if;
      end loop;
      top(i+1).titulo := kJuego;
      top(i+1).vendidos := iJuego.vendidos;
   end insertarJuego;

   --QH: Muestra los juegos cuyas claves vienen en la cola que coinciden con la categoría recibida por parámetro.
   --PRE: cat = C, juegos = J y q = Q
   --POS: q = Q1 y Q1 está vacía
   --EXC: -
   procedure mostrarCategoria (cat: in tCategoria; juegos: in abbJuegos.tipoArbol; q: in out abbJuegos.ColaRecorridos.tipoCola) is
      iJuego:tInfoJuego;
      kJuego:tClaveJuego;
   begin
      while not esVacia(q) loop                --ADT COLA
         frente (q, kJuego);				      --ADT COLA
         desencolar (q);					      --ADT COLA
         buscar (juegos, kJuego, iJuego);	      --ADT ABB
         if iJuego.categoria = cat then
            mostrarJuego (kJuego, iJuego);	  --NIVEL 5
         end if;
      end loop;
   end mostrarCategoria;

   --QH: Calcula el importe total a pagar por una cantidad de juegos, aplicando un 10% de descuento si el cliente tiene suficientes créditos.
   --PRE: precioJuego=P y P > 0, cant=C y C > 0, creditos=K y K >= 0
   --POS: calculoImporte=I y I > 0
   --EXC: –
   function calculoImporte (precioJuego: in float; cant: in integer; creditos: in integer) return float is
      descuento: constant := 0.9;
      precio: float;
   begin
      precio := precioJuego * float(cant);
      if creditosSuficientes(creditos) then      --NIVEL 5
         return precio * descuento;
      else
         return precio;
      end if;
   end calculoImporte;

   --QH: Actualiza los registros de compras del cliente recibido por parámetro y el stock y cantidad de vendidos del juego recibido por parámetro.
   --PRE: clientes=C, kCliente=KC y KC existe en C, juegos=J, kJuego=KJ y KJ existe en J, cant=I y I > 0, precio=P y P > 0.
   --POS: clientes=C1 y C1 es C con los registros del cliente KC modificados, juegos=J1 y J1 es J con el stock y cantidad de vendidos de KJ actualizados.
   --EXC: -
   procedure AnadirCompra (clientes: in out abbClientes.tipoArbol; kCliente: in tClaveCliente; juegos: in out abbJuegos.tipoArbol; kJuego: in tClaveJuego; cant: in integer; precio: in float) is
      iCliente:tInfoCliente;
      iJuego:tInfoJuego;
   begin
      buscar(clientes, kCliente, iCliente);			                      --ADT ABB
      registroCompra (iCliente.compras, kJuego, cant, precio);           --NIVEL 5
      iCliente.importeTotal := iCliente.importeTotal + precio;
      iCliente.cantJuegos := iCliente.cantJuegos + cant;
      iCliente.creditos := modificarCreditos(iCliente.importeTotal);     --NIVEL 5
      registrarUltimaCompra (iCliente.ultimaCompra, kJuego, precio);     --NIVEL 5
      modificar(clientes, kCliente, iCliente);		                      --ADT ABB
      buscar(juegos, kJuego, iJuego);					                      --ADT ABB
      iJuego.vendidos := iJuego.vendidos + cant;
      iJuego.stock := iJuego.stock - cant;
      modificar(juegos, kJuego, iJuego);				                      --ADT ABB
   Exception
	  when listaCompras.listaLlena => Put_Line ("Se produjo un error al cargar la compra. Intentelo mas tarde");
	  when listaCompras.claveExiste => Put_Line ("Ya ha adquirido este juego");
   end AnadirCompra;

   --QH: Carga el nombre y apellido de un cliente.
   --PRE: -
   --POS: cad1=C1 y tiene cargado un nombre , cad2=C2 y tiene cargado un apellido.
   --EXC: –
   procedure cargarNombre (nombre: out Unbounded_String; apellido: out Unbounded_String) is
   begin
      nombre := To_Unbounded_String( textoNoVacio ("Ingrese el nombre"));		--ÚTILES
      apellido := To_Unbounded_String( textoNoVacio ("Ingrese el apellido")	);	--ÚTILES
      Put_Line ("Nombre: " & nombre & " " & apellido);
   end cargarNombre;

   --QH: Carga la fecha de nacimiento de un cliente.
   --PRE:-
   --POS: f=F y tiene cargada una fecha válida.
   --EXC: –
   procedure cargarFecha (f: out tFecha) is
      dMes: integer;
   begin
      f.anio := enteroEnRango ("Ingrese el año", 1950, 2010); 		--ÚTILES
      f.mes := enteroEnRango ("Ingrese el mes", 1, 12);     		--ÚTILES
      dMes := diasMes (f.mes, f.anio);					   		--FECHAS
      f.dia := enteroEnRango ("Ingrese el dia", 1, dMes); 	     --ÚTILES
      Put_Line (fechaTexto(f));								--FECHAS
   end cargarFecha;

   --QH: carga la dirección de un cliente y la muestra al usuario
   --PRE: -
   --POS: dir=D
   --EXC: --
   procedure cargarDireccion (dir: out Unbounded_String) is
   begin
      dir := To_Unbounded_String( textoNoVacio ("Ingrese la direccion"));	--ÚTILES
      Put_Line ("Direccion: " & dir);
   end cargarDireccion;

   --QH: Inicializa las listas de compras y alquileres de un cliente.
   --PRE: -
   --POS: alquiler = A y A esta creado y vacío, compras = C y C está creado y vacío
   --EXC: --
   procedure cargarListas (alquiler: out listaAlquiler.tipoLista; compras: out listaCompras.tipoLista) is
   begin
      crear (alquiler);		--ADT ABB
      crear (compras);		--ADT ABB
   end cargarListas;

   --QH: Inicializa los datos reales o enteros de la información de un cliente nuevo.
   --PRE: i = I
   --POS: i = I1 y I1 es I con los campos numéricos en 0.
   --EXC: -
   procedure iniDatosCero (i: in out tInfoCliente) is
   begin
      i.cantDeuda := 0.0;
      i.cantJuegos := 0;
      i.creditos := 0;
      i.importeTotal := 0.0;
      i.cantTorneos := 0;
   end iniDatosCero;

   --QH: Inicializa las medallas de un cliente.
   --PRE: -
   --POS: m = M y Tiene sus campos en 0.
   --EXC: -
   procedure iniMedalla (med: out tMedallas) is
   begin
      med.oro := 0;
      med.plata := 0;
      med.bronce := 0;
      med.premioGanado := 0.0;
   end iniMedalla;

   --QH: Inicializa la última compra y alquiler de un cliente.
   --PRE: -
   --POS: último = U y U está vacío
   --EXC: -
   procedure iniUltimo (ultimo: out tUltimo) is
   begin
      ultimo.titulo := To_Unbounded_String("");
      ultimo.fecha := fechaHoy;		--FECHAS
      ultimo.importe := 0.0;
      ultimo.cantDias := 0;
   end iniUltimo;

   --QH: Muestra en pantalla la cantidad de medallas y el total de dinero ganado.
   --PRE: m=M
   --POS: -
   --EXC: -
   procedure mostrarMedallas (m: in tMedallas) is
   begin
      Put_Line ("Medallas de oro:" & integer'Image(m.oro));
      Put_Line ("Medallas de plata:" & integer'Image(m.plata));
      Put_Line ("Medallas de bronce:" & integer'Image(m.bronce));
      Put("total de dinero ganado: ");
      put(m.premioGanado,Fore => 10, Aft => 2,Exp =>0);
      New_Line;
   end mostrarMedallas;

   --QH: Muestra los datos de la última compra de un cliente.
   --PRE: u=U
   --POS: -
   --EXC: -
   procedure mostrarUltimaCompra (u: in tUltimo) is
   begin
      Put_Line ("Su ultimo juego comprado es: " & u.titulo);
      Put_Line ("Lo adquirio el dia: " & fechaTexto(u.fecha));
      Put("le costo: $");
      put(u.importe,Fore => 10, Aft => 2,Exp =>0);
      New_Line;
   end mostrarUltimaCompra;

   --QH: Muestra los datos del último alquiler de un cliente.
   --PRE: u=U.
   --POS: -
   --EXC: -
   procedure mostrarUltimoAlquiler(u: in tUltimo) is
   begin
      Put_Line ("Ultimo alquiler: " & u.titulo);
      Put_Line ("Alquilado el dia " & fechaTexto(u.fecha));
      Put_Line ("Por" & integer'Image(u.cantDias) & " dias");
      Put("total de alquiler: $");
      put(u.importe,Fore => 10, Aft => 2,Exp =>0);
      New_Line;
   end mostrarUltimoAlquiler;

   --QH: Muestra las opciones de campos modificables de un cliente y devuelve la opción seleccionada.
   --PRE: -
   --POS: opcionesCliente= C y C es la opción elegida por el usuario.
   --EXC: -
   function opcionesCliente return integer is
   begin
      Put_Line ("¿Que campo desea modificar?");
      Put_Line ("1. Nombre y Apellido");
      Put_Line ("2. Fecha De Nacimiento");
      Put_Line ("3. Dirección");
      return enteroEnRango("Elija una opción",1,3); --ÚTILES
   end opcionesCliente;

   --QH: Agrega de forma ordenada el cliente al top 10 de los más compradores.
   --PRE: top = T, dim = N, dni = N, total= T
   --POS: top = T1 y T1 es T con un nuevo cliente en el top 10.
   --EXC: -
   procedure insertarCliente (top: in out tCompradores; dim: in integer; dni: in tClaveCliente; totalGastado: in float) is
      i: integer;
   begin
      i:= dim;
      while (i >= 1) loop
         if (totalGastado > top(i).totalGastado) then
            top(i+1) := top(i);
            i := i-1;
         end if;
	   end loop;
      top(i+1).dni := dni;
      top(i+1).totalGastado := totalGastado;
   end insertarCliente;

   ----------------------------------------------------------------------------NIVEL 3--------------------------------------------------------------------------------------------
   --QH: Determina si existe un juego.
   --PRE: a=A y kJuegos=K
   --POS: existeJuego=verdadero si existe K en A, sino existeJuego=falso.
   --EXC:--
   function existeJuego (juegos: in abbJuegos.tipoArbol; kJuego: in tClaveJuego) return boolean is
      iJuego: tInfoJuego;
   begin
      buscar(juegos, kJuego, iJuego);              --ADT ABB
      return true;
   Exception
      when abbJuegos.claveNoExiste => return false;
   end existeJuego;

   --QH: Devuelve la información de un juego para dar de alta en el sistema.
   --PRE:--
   --POS: iJuego= I y I tiene la información del juego.
   --EXC: --
   procedure ingresoDatosJuego (iJuego: out tInfoJuego) is
   begin
      iJuego.desarrollador := To_Unbounded_String( textoNoVacio ("Ingrese el desarrollador"));      --ÚTILES
      iJuego.descripcion := To_Unbounded_String (textoNoVacio ("Ingrese la reseña descriptiva"));   --ÚTILES
      pedirCategoria (iJuego.categoria);                                                            --NIVEL 4
      ingresoEdad (iJuego.edad);			                                                           --NIVEL 4
      iJuego.precio := cargarPrecio;                                                                --NIVEL 4
      loop
         iJuego.stock  := numeroEnt ("Ingrese la cantidad de stock");                               --ÚTILES
         exit when iJuego.stock >= 0;
      end loop;
      iJuego.alquilados := 0;
      iJuego.vendidos := 0;
   end ingresoDatosJuego;

   --QH: Inserta un juego en el ABB de juegos.
   --PRE: juegos = J
   --POS: juegos=J1 y J1 es J con un juego nuevo.
   --EXC:--
   procedure guardarJuego (juegos: in out abbJuegos.tipoArbol; kJuego: in tClaveJuego; iJuego: in tInfoJuego) is
   begin
      insertar (juegos,kJuego,iJuego);                                            --ADT ABB
   Exception
      when abbJuegos.arbolLleno=> Put_Line ("No se pudo guardar el juego. Inténtelo más tarde");
   end guardarJuego;

   --QH:Elimina un juego si el usuario lo desea.
   --PRE: juegos = J, kJuego = K y K existe en J.
   --POS:	juegos = J1 y J1 es J sin el juego de clave K.
   --EXC: --
   procedure eliminarJuego (juegos: in out abbJuegos.tipoArbol; kJuego: in tClaveJuego) is
   begin
      if confirma("¿Desea eliminar el juego?") then			--ÚTILES
         suprimir(juegos,kJuego);		                    --ADT ABB
         Put_Line ("Juego eliminado");
      else
         Put_Line ("Eliminación cancelada");
      end if;
   end eliminarJuego;

   --QH: Modifica los datos de un juego hasta que el usuario no desee seguir modificando.
   --PRE: iJuego = I y I contiene la información de un juego.
   --POS: iJuegos = I1 y I1 es I con los datos modificados.
   --EXC: --
   procedure modificarDatosJuegos (iJuego: in out tInfoJuego) is
      m: integer;
   begin
      loop
         m := menuModificarJuego;											   --NIVEL 4
         case m is
            when 1 =>	iJuego.desarrollador := To_Unbounded_String( textoNoVacio("Desarollador: "));			        --ÚTILES
            when 2 => 	iJuego.descripcion := To_Unbounded_String ( textoNoVacio ("Ingrese la reseña descriptiva"));  --ÚTILES
            when 3 =>	pedirCategoria (iJuego.categoria);								   --NIVEL 4
            when 4 =>	ingresoEdad (iJuego.edad);									      --NIVEL 4
            when 5 =>	iJuego.precio := cargarPrecio;								      --NIVEL 4
            when others => null;
         end case;
         exit when not confirma ("¿Quiere modificar algo mas?");
      end loop;
   end modificarDatosJuegos;

   --QH:Inicializa el arreglo del top 10
   --PRE: MAX = M y M > 0.
   --POS: top = T y T[i].titulo=”” y T[i].vendidos=-1 para todo T[i] que pertenece a T.
   --EXC: --
   procedure inicializarTop10 (top: out tTopVendidos; MAX: in integer) is
   begin
      for i in 1 .. MAX loop
         top(i).titulo := To_Unbounded_String("");
         top(i).vendidos := -1;
      end loop;
   end inicializarTop10;

   --QH: Busca y agrega los 10 juegos más vendidos al arreglo del top 10
   --PRE: juegos = J, top = T
   --POS:top = T1 y T1 es T con el top 10 juegos más vendidos del mes, dim = N y N es la dimensión lógica del arreglo.
   --EXC: --
   procedure buscarTop10 (juegos: in abbJuegos.tipoArbol; top: in out tTopVendidos; dim: out integer) is
      q: abbJuegos.ColaRecorridos.tipoCola;
      kJuego: tClaveJuego;
      iJuego: tInfoJuego;
   begin
      crear(q);								                   --ADT COLA
      inOrder (juegos, q);					                   --ADT ABB
      dim := 0;
      while not esVacia(q) loop			                   --ADT COLA
         frente(q, kJuego);					                   --ADT COLA
         desencolar(q);					                       --ADT COLA
         buscar(juegos, kJuego, iJuego);		                --ADT ABB
         if dim < 10 then
            insertarJuego(top, dim, iJuego, kJuego);        --NIVEL 4
            dim := dim + 1;
         else
            if iJuego.vendidos > top(dim).vendidos then
               insertarJuego(top, dim-1, iJuego, kJuego);    --NIVEL 4
            end if;
         end if;
      end loop;
   Exception
      when abbJuegos.errorEnCola => Put_Line ("Se produjo un error al listar juegos. Inténtelo más tarde.");
   end buscarTop10;

   --QH: Muestra el top 10 de los juegos más vendidos
   --PRE: juegos=J,top = T y T[i].titulo existe en J para todo T[i]∈T, dim=D y D > 0
   --POS: --
   --EXC: --
   procedure mostrarTop10 (juegos: in abbJuegos.tipoArbol; top: in tTopVendidos; dim: in integer) is
      iJuego: tInfoJuego;
   begin
      for i in 1..dim loop
         buscar(juegos,top(i).titulo, iJuego);		                 --ADT ABB
         Put_Line ("Posición del top:" & integer'Image (i));
         Put_Line ("Título: " & top(i).titulo);
         Put_Line ("Desarrollador: " & iJuego.desarrollador);
         Put ("Categoría: ");
         ioCategoria.Put (iJuego.categoria);
         New_Line;
         Put_Line ("Nivel de violencia: " & edadATexto(iJuego.edad));  --NIVEL 6
         Put_Line ("La cantidad de vendidos es: " & integer'Image(iJuego.vendidos));
         continua ("¿continua con el top?");
      end loop;
   end mostrarTop10;

   --QH: Genera un listado de juegos filtrados por categoría recibida por parámetro.
   --PRE: juegos=J, cat=C, q=Q y Q está vacía.
   --POS: q=Q1 y Q1 está vacía.
   --EXC: --
   procedure crearListadoCat (juegos: in abbJuegos.tipoArbol; cat: in tCategoria; q: in out abbJuegos.ColaRecorridos.tipoCola) is
   begin
      inOrder (juegos, q);					--ADT ABB
      mostrarCategoria(cat,juegos,q);    --NIVEL 4
   Exception
      when abbJuegos.errorEnCola => Put_Line ("Se ha producido un error al mostrar los juegos. Inténtelo más tarde.");
   end crearListadoCat;

   --QH: Pide al usuario el DNI de un cliente y retorna su información.
   --PRE: cliente=C
   --POS: k=K y K es el DNI del cliente, i=I y I es la información del cliente K.
   --EXC: --
   procedure PedirDatosCliente (clientes: in abbClientes.tipoArbol; kCliente: out tClaveCliente; iCliente: out tInfoCliente; c: out Boolean) is
      Esta: boolean;
   begin
      Esta := true;
      loop
         kCliente := enteroEnRango("Ingrese el DNI del cliente", 10000000, 99999999);   --ÚTILES
         begin
            buscar (clientes, kCliente, iCliente);		                        --ADT ABB
            c:=True;
         exception
            when abbClientes.claveNoExiste => Esta := false;
               Put_Line ("El cliente no se encuentra registrado");
               if not confirma("desea ingresar otro cliente?") then
                  c:=false;
               end if;
         end;
         exit when Esta or not c;
      end loop;
   end PedirDatosCliente;

   --QH: Pide al usuario el título de un juego y retorna su información.
   --PRE: juegos=J
   --POS: k=K y K es el título del juego, i=I y I es la información del juego K.
   --EXC: –-
   procedure obtenerJuegoDisponible (juegos: in abbJuegos.tipoArbol; kJuego: out tClaveJuego; iJuego: out tInfoJuego) is
      Esta: boolean;
   begin
      loop
         kJuego := To_Unbounded_String( textoNoVacio("Ingrese el título del juego"));        --ÚTILES
         begin
            buscar(juegos,kJuego,iJuego);							--ADT ABB
            Esta := true;
            if iJuego.stock = 0 then
               Put_Line("Juego no Disponible");
            else
               Put_Line("Juego Disponible");
            end if;
         exception
            when abbJuegos.claveNoExiste => Esta := false;
               Put_Line ("Juego no existe");
         end;
         exit when Esta;
      end loop;
   end obtenerJuegoDisponible;

   --QH: se pide al usuario los datos de la compra y se actualizan los registros de compra.
   --PRE: juegos = J, kJuego = KJ y KJ existe en J, clientes = C, kCliente = KC y KC existe en C.
   --POS: juegos=J1 y J1 es J con el stock y cantidad de vendidos del juego KJ actualizados, clientes=C1 y C1 es C con los registros de compras del cliente KC actualizados.
   --EXC: - */
   procedure realizarCompra (juegos: in out abbJuegos.tipoArbol; kJuego: in tClaveJuego; clientes: in out abbClientes.tipoArbol; kCliente: in tClaveCliente) is
      iJuego: tInfoJuego;
      iCliente: tInfoCliente;
      cant: integer;
      precioFinal: float;
   begin
      buscar(clientes,kCliente,iCliente);				                                   --ADT ABB
      buscar(juegos, kJuego, iJuego);         		                                   --ADT ABB
      cant := enteroEnRango("Ingrese cuantos ejemplares desea comprar", 0, iJuego.stock);
      if cant > 0 then
         precioFinal := calculoImporte(iJuego.precio, cant, iCliente.creditos);            --NIVEL 4
         Put("El total a pagar es: $");
         put(precioFinal,Fore => 10, Aft => 2,Exp =>0);
         New_Line;
         AnadirCompra(clientes, kCliente, juegos, kJuego, cant, precioFinal);            -- NIVEL 4
      end if;
   end realizarCompra;

   --QH: Determina si existe un cliente en el árbol.
   --PRE: clientes=C y k=K
   --POS: existeCliente=verdadero si existe K en C, sino existeCliente=falso.
   --EXC: --
   function existeCliente (clientes: in abbClientes.tipoArbol; kCliente: in tClaveCliente) return boolean is
      i:tInfoCliente;
   begin
      buscar(clientes,kCliente,i);		                  --ADT ABB
      return true;
   Exception
      when abbClientes.claveNoExiste => return false;
   end existeCliente;

   --QH: Carga todos los campos necesarios para inicializar un nuevo cliente.
   --PRE:-
   --POS: i=I y I tiene la información de un nuevo cliente.
   --EXC: --
   procedure cargarInfoCliente (i: out tInfoCliente) is
   begin
      cargarNombre(i.nombre, i.apellido);       --NIVEL 4
      cargarFecha(i.fechaNacimiento);           --NIVEL 4
      cargarDireccion(i.direccion);             --NIVEL 4
      cargarListas (i.alquileres, i.compras);   --NIVEL 4
      i.sancionado := false;
      iniDatosCero (i);				              --NIVEL 4
      iniMedalla (i.medallas);		              --NIVEL 4
      iniUltimo (i.ultimoAlquiler)	;             --NIVEL 4
      iniUltimo (i.ultimaCompra); 	              --NIVEL 4
   end cargarInfoCliente;

   --QH: Inserta un nuevo cliente en el arbol de clientes.
   --PRE: clientes=C, kCliente=K, iCliente=I.
   --POS: clientes=C1 y C1 es C con un nuevo cliente.
   --EXC: --
   procedure cargarCliente (clientes: in out abbClientes.tipoArbol; kCliente: in tClaveCliente; iCliente: in tInfoCliente) is     --Agregar en pseudocodigo
   begin
      insertar (clientes, kCliente, iCliente);
   exception
      when abbClientes.arbolLleno => Put_Line ("Ocurrio un error al cargar el cliente. Intentelo mas tarde");
   end cargarCliente;

   --QH: Muestra en pantalla los datos del cliente.
   --PRE: cliente=C, k=K y K existe en C.
   --POS: -
   --EXC: --
   procedure mostrarCliente (k: in tClaveCliente; clientes: in abbClientes.tipoArbol) is
      i:tInfoCliente;
   begin
      buscar(clientes,k,i);				                       --ADT ABB
      Put_Line (i.nombre & " " & i.apellido);
      Put_Line ("DNI:" & integer'Image(k));
      Put_Line ("Direccion: " & i.direccion);
      Put("Deuda: ");
      put(i.cantDeuda,Fore => 10, Aft => 2,Exp =>0);
      New_Line;
      Put_Line ("Cantidad de juegos: " & integer'Image(i.cantJuegos));
      New_Line;
      Put_Line ("Creditos: " & integer'Image(i.creditos));
      New_Line;
      Put("Total gastado: ");
      put(i.importeTotal,Fore => 10, Aft => 2,Exp =>0);
      New_Line;
      --Put_Line ("Torneos participados:" & integer'Image(i.cantTorneos));
      mostrarMedallas(i.medallas);		                       --NIVEL 4
      mostrarUltimaCompra(i.ultimaCompra)	;	                --NIVEL 4
      mostrarUltimoAlquiler(i.ultimoAlquiler);				   --NIVEL 4
      Put_Line ("Nacimiento: " & fechaTexto(i.fechaNacimiento));    --FECHAS
      if (i.sancionado) then
         Put_Line ("Usuario sancionado");
      else
         Put_Line ("Cliente ejemplar");
      end if;
   end mostrarCliente;

   --QH: Permite modificar uno o más datos de un cliente mientras el usuario lo desee.
   --PRE: i=I y tiene cargado un cliente válido.
   --POS: i=I1 y I1 es I el cual actualiza los campos válidos.
   --EXC: –-
   procedure modificarDatosCliente (info: in out tInfoCliente) is
      opcion: integer;
   begin
      loop
         opcion := opcionesCliente; 				--NIVEL 4
         case opcion is
            when 1 => cargarNombre(info.nombre,info.apellido);	--NIVEL 4
            when 2 => cargarFecha(info.fechaNacimiento);		--NIVEL 4
            when 3 => cargarDireccion(info.direccion);	       --NIVEL 4
            when others => null;
         end case;
         exit when not confirma("¿Desea cambiar otro dato?");	--ÚTILES
      end loop;
   end modificarDatosCliente;

   --QH:Inicializa el arreglo del top 10 compradores
   --PRE: MAX = M y M > 0.
   --POS: top = T y T[i].dni=0 y T[i].totalGastado=-1 para todo T[i]∈T.
   --EXC: --
   procedure inicializarTop10Compradores (top: out tCompradores; MAX: in integer) is
   begin
      for i in 1..MAX loop
         top(i).dni := 0;
         top(i).totalGastado := -1.0;
      end loop;
   end inicializarTop10Compradores;

   --QH: Busca y agrega los 10 clientes más compradores del arreglo del top 10
   --PRE: clientes=C , top = T
   --POS: top = T1 y T1 es T con el top 10 clientes más compradores del mes, dim = N y N es la dimensión lógica del arreglo y N>=0.
   --EXC: --
   procedure buscarTop10Compradores (clientes: in abbClientes.tipoArbol; top: in out tCompradores; dim: out integer) is
      q: abbClientes.ColaRecorridos.tipoCola;
      dni: tClaveCliente;
      info: tInfoCliente;
   begin
      crear (q); 					--ADT COLA
      inOrder(clientes,q); 		--ADT ABB
      dim := 0;
      while not esVacia(q) loop	     --ADT COLA
         frente (q,dni); 			     --ADT COLA
         desencolar (q); 			     --ADT COLA
         buscar(clientes,dni,info);     --ADT ABB
         if dim < 10 then
            insertarCliente(top,dim,dni,info.importeTotal);              --NIVEL 4
            dim := dim + 1;
         else
            if info.importeTotal > top(dim).totalGastado then
               insertarCliente(top,dim-1,dni,info.importeTotal);         --NIVEL 4
            end if;
         end if;
      end loop;
   Exception
      when abbClientes.errorEnCola => Put_Line ("Error al listar clientes, intente nuevamente");
   end buscarTop10Compradores;

   --QH: Muestra el top 10 de los clientes más compradores.
   --PRE: clientes=C,top = T y T[i].dni existe en C para todo T[i]∈T, dim=D y D >= 0
   --POS: -
   --EXC: -
   procedure mostrarTop10Compradores (clientes: in abbClientes.tipoArbol; top: in tCompradores; dim: in integer) is
      info:tInfoCliente;
   begin
      for i in 1..dim loop
         buscar(clientes,top(i).dni, info); 		--ADT ABB
         Put_Line ("Posicion" & integer'Image(i));
         Put_Line ("DNI:" & integer'Image(top(i).dni));
         Put_Line ("Nombre: " & info.nombre & " " & info.apellido);
         Put_Line ("Juegos comprados:" & integer'Image(info.cantJuegos));
         Put("El total a gastado es: $");
         put(top(i).totalGastado,Fore => 10, Aft => 2,Exp =>0);
         New_Line;
      end loop;
   end mostrarTop10Compradores;

   --QH: Actualiza el campo de créditos y total gastado de un cliente.
   --PRE: cliente=C,k=K y K existe en C, importe=I y n=N.
   --POS:cliente=C1 y C1 es C con los campos de créditos y total gastado de un cliente actualizado.
   --EXC: --
   procedure acreditacion (clientes: in out abbClientes.tipoArbol; k: in tClaveCliente; importe: in float; n: in integer) is
      i:tInfoCliente;
   begin
      buscar(clientes, k, i);						--ADT ABB
      i.importeTotal := i.importeTotal + importe;
      i.creditos := i.creditos + n;
      modificar(clientes,k,i);					     --ADT ABB
   end acreditacion;

   ----------------------------------------------------------------------------NIVEL 2--------------------------------------------------------------------------------------------
   --QH:Muestra las opciones del menú de juegos y devuelve la opción elegida por el usuario.
   --PRE:-
   --POS: menuJuego = N y N es la opción elegida del menú
   --EXC: --
   function menuJuego return integer is
   begin
      Put_Line ("MENÚ JUEGOS");
      Put_Line ("1. Alta de juego");
      Put_Line ("2. Baja de juego");
      Put_Line ("3. Modificar juego");
      Put_Line ("4. Top 10 juegos más vendidos");
      Put_Line ("5. Lista de Juegos según categoría");
      Put_Line ("6. Compras");
      Put_Line ("7. Alquileres");
      Put_Line ("0. Volver");
      return enteroEnRango ("Ingrese una opción", 0, 7);	    --ÚTILES
   end menuJuego;

   --QH: Carga un nuevo juego de la empresa.
   --PRE: juegos=A
   --POS: juegos = A1 y A1 es A con un nuevo juego.
   --EXC: -
   procedure AltaJuego (juegos: in out abbJuegos.tipoArbol) is
      iJuego: tInfoJuego;
      kJuego: tClaveJuego;
   begin
      loop
         kJuego := To_Unbounded_String( textoNoVacio ("Ingrese el título del juego"));     --ÚTILES
         if existeJuego (juegos, kJuego) then	                                           --NIVEL 3
            Put_Line ("El juego ingresado ya existe");
         else
            Put_Line ("Ingrese los datos del juego");
            ingresoDatosJuego (iJuego);				                                       --NIVEL 3
            guardarJuego (juegos,kJuego,iJuego);				                             --NIVEL 3
		  end if;
         exit when not confirma ("¿Desea ingresar otro juego?");                           --ÚTILES
      end loop;
   end AltaJuego;

   --QH: Se dan de baja uno o más juegos mientras el usuario lo desee.
   --PRE: juegos = J
   --POS: juegos = J1 y J1 es J sin los juegos eliminados.
   --EXC: --
   procedure BajarJuego (juegos: in out abbJuegos.tipoArbol) is
      kJuego:tClaveJuego;
      iJuego:tInfoJuego;
   begin
      loop
         kJuego := To_Unbounded_String( textoNoVacio("Ingrese el título del juego"));          --ÚTILES
         if not existeJuego(juegos, kJuego) then				                                 --NIVEL 3
            Put_Line ("No existe juego para borrar");
         else
            buscar(juegos,kJuego,iJuego);                                                      --ADT ABB
            mostrarJuego(kJuego,iJuego);                                                       --NIVEL 5
            if iJuego.alquilados = 0 then
               eliminarJuego(juegos, kJuego);                                                  --NIVEL 3
            else
               Put_Line("No puede darse de baja el juego mientras esté alquilado");
            end if;
         end if;
         exit when not confirma("¿Desea borrar otro juego?");                                  --ÚTILES
      end loop;
   end BajarJuego;

   --QH: Modifica la información de juegos mientras el usuario desee.
   --PRE: juegos = J y J tiene juegos cargados.
   --POS: juegos = J1 y J1 es J pero con uno o más juegos modificados.
   --EXC: --
   procedure ModificarJuego (juegos: in out abbJuegos.tipoArbol) is
      kJuego:tClaveJuego;
      iJuego:tInfoJuego;
   begin
      loop
         kjuego := To_Unbounded_String( textoNoVacio("Ingrese el juego que desea modificar"));    --ÚTILES
         if existeJuego(juegos,kJuego) then                                                       --NIVEL 3
            buscar(juegos,kJuego,iJuego);                                                         --ADT ABB
            mostrarJuego(kJuego,iJuego);                                                          --NIVEL 5
            if confirma("¿Quiere modificar este juego?") then                                     --ÚTILES
               modificarDatosJuegos(iJuego);                                                      --NIVEL 3
               modificar(juegos, kJuego, iJuego);                                                 --ADT ABB
			  end if;
		  else
            Put_Line("El juego ingresado no se encuentra");
         end if;
         exit when not confirma("¿Desea modificar los datos de otro juego?");                     --ÚTILES
      end loop;
   end ModificarJuego;

   --QH: Genera y muestra el top 10 de juegos más vendidos del mes
   --PRE: juego = J
   --POS: –
   --EXC: --
   procedure Top10Juegos (juegos: in abbJuegos.tipoArbol) is
      MAX: constant := 10;
      top: tTopVendidos;
      dim: integer;
   begin
      inicializarTop10 (top, MAX);      --NIVEL 3
      buscarTop10 (juegos,top,dim);     --NIVEL 3
      if dim > 0 then
         mostrarTop10 (juegos,top,dim); 	  --NIVEL 3
      else
         Put_Line ("No hay juegos para mostrar");
      end if;
   end Top10Juegos;

   --QH: Crea un listado según una categoría
   --PRE: juegos = J
   --POS: --
   --EXC: --
   procedure ListarCategoria (juegos: in abbJuegos.tipoArbol) is
      cat: tCategoria;
      q: abbJuegos.ColaRecorridos.tipoCola;
   begin
      crear(q);                                     --ADT COLA
      pedirCategoria(cat);                          --NIVEL 4
      crearListadoCat(juegos,cat,q);                --NIVEL 3
   end ListarCategoria;

   --QH: Realiza la compra de uno o más juegos mientras el usuario lo desee.
   --PRE: juegos = J, cliente = C
   --POS: juegos = J1 y J1 es J con el stock y cantidad de ejemplares vendidos de los juegos vendidos modificados, cliente = C1 y C1 es C con la lista de compras del cliente indicado por el usuario modificada.
   --EXC: --
   procedure CompraJuegos (juegos: in out abbJuegos.tipoArbol; clientes: in out abbClientes.tipoArbol) is
      iJuego:tInfoJuego;
      kJuego:tClaveJuego;
      iCliente: tInfoCliente;
      kCliente: tClaveCliente;
      hayCliente: Boolean;
   begin
      	loop
         PedirDatosCliente(clientes,kCliente,iCliente,hayCliente);                               --NIVEL 3
         if hayCliente then
            if iCliente.sancionado then
            Put_Line ("Cliente sancionado,no puede realizar compras");
            else
               obtenerJuegoDisponible(juegos,kJuego,iJuego);                             --NIVEL 3
               mostrarJuego(kJuego,iJuego);                                              --NIVEL 5
               if iJuego.stock > 0 and confirma("¿Desea comprar el juego?") then
                  realizarCompra(juegos,kJuego,clientes,kCliente);                        --NIVEL 3
               end if;
            end if;
         end if;
         exit when not confirma("¿Desea comprar otro juego?");
      end loop;
   end CompraJuegos;

   --QH: Realiza el alquiler de un juego y actualiza la información de alquileres.
   --PRE: juegos=J, clientes=C
   --POS: juegos=J1 y J1 es J con el stock y cantidad de alquilados del juego pedido al usuario actualizados, clientes=C1 y C1 es C con el listado de alquileres de un cliente pedido al usuario actualizado.
   --EXC: --*/
   procedure AlquilerJuegos (juegos: in out abbJuegos.tipoArbol; clientes: in out abbClientes.tipoArbol) is
   begin
      Put_Line ("Módulo no implementado");
      continua("Presione una tecla para volver");
   end AlquilerJuegos;

   --QH:Muestra las opciones de torneos retornar la opción ingresada por el usuario
   --PRE:--
   --POS:menuTorneo = N y N es la opción elegida por el usuario
   --EXC:--
   function menuTorneo return integer is
   begin
      Put_Line ("MENÚ TORNEOS");
      Put_Line ("1. Alta torneo");
      Put_Line ("2. Baja torneo");
      Put_Line ("3. Alta inscripción");
      Put_Line ("4. Baja inscripción");
      Put_Line ("5. Entrega de premios");
      Put_Line ("0. Volver");
      return enteroEnRango ("Ingrese una opción", 0, 5);          --ÚTILES
   end menuTorneo;

   --QH: Da de alta un torneo, registrando sus datos.
   --PRE: torneos=T
   --POS: torneos=T1 y T1 es T con un nuevo torneo.
   --EXC: --
   procedure AltaTorneo (torneos: in out abbTorneos.tipoArbol) is
   begin
      Put_Line ("Módulo no implementado");
      continua("Presione una tecla para volver");
   end AltaTorneo;

   --QH: Da de baja un torneo.
   --PRE: torneos=T
   --POS: torneos=T1 y T1 es T sin el torneo eliminado.
   --EXC: --
   procedure BajaTorneo (torneos: in out abbTorneos.tipoArbol) is
   begin
      Put_Line ("Módulo no implementado");
      continua("Presione una tecla para volver");
   end BajaTorneo;

   --QH: Registra una inscripción a un torneo.
   --PRE: torneos=T, clientes=C
   --POS: torneos=T1 y T1 es T con una inscripción más a un torneo, clientes=C1 y C1 es C con la participación a torneos de un cliente actualizada.
   --EXC: --
   procedure AltaInscripcion (torneos: in out abbTorneos.tipoArbol; clientes: in out abbClientes.tipoArbol) is
   begin
      Put_Line ("Módulo no implementado");
      continua("Presione una tecla para volver");
   end AltaInscripcion;

   --QH: da de baja la inscripción de un cliente a un torneo.
   --PRE: torneos=T, clientes=C
   --POS: torneos=T1 y T1 es T sin la inscripción de un torneo eliminada, clientes=C1 y C1 es C con la participación a torneos de un cliente actualizada.
   --EXC: --
   procedure BajaInscripcion (torneos: in out abbTorneos.tipoArbol; clientes: in out abbClientes.tipoArbol) is
   begin
      Put_Line ("Módulo no implementado");
      continua("Presione una tecla para volver");
   end BajaInscripcion;

   --QH: Registra la entrega de premios de un torneo.
   --PRE: torneos=T, clientes=C
   --POS: clientes=C1 y C1 es C con los registros de medallas de clientes correspondientes actualizadas.
   --EXC: --
   procedure EntregaPremios (torneos: in out abbTorneos.tipoArbol; clientes: in out abbClientes.tipoArbol) is
   begin
      Put_Line ("Módulo no implementado");
      continua("Presione una tecla para volver");
   end EntregaPremios;

   --QH: Muestra las opciones de cliente y devuelve la opción ingresada por el usuario.
   --PRE: -
   --POS: menuCliente = N y N es la opción elegida por el usuario.
   --EXC: --
   function menuCliente return integer is
   begin
      Put_Line ("1. Alta cliente");
      Put_Line ("2. Baja cliente");
      Put_Line ("3. Modificar cliente");
      Put_Line ("4. Top 10 clientes más compradores");
      Put_Line ("5. Compras de créditos");
      Put_Line ("6. Detalle del cliente");
      Put_Line ("0. Volver");
      return enteroEnRango ("Ingrese una opción", 0, 6);
   end menuCliente;

   --QH: Da de alta a un nuevo cliente solicitando y registrando sus datos.
   --PRE: cliente= C
   --POS: cliente=C1 y C1 es C con un nuevo cliente.
   --EXC: --
   procedure AltaCliente (clientes: in out abbClientes.tipoArbol) is
      kCliente:tClaveCliente;
      iCliente:tInfoCliente;
   begin
      loop
         kCliente := enteroEnRango ("Ingrese el DNI de cliente", 10000000, 99999999);   --ÚTILES
         if existeCliente(clientes,kCliente) then  	                                     --NIVEL 3
            Put_Line ("Cliente ya registrado");
         else
            cargarInfoCliente(iCliente);  				                                 --NIVEL 3
            cargarCliente(clientes,kCliente,iCliente); 		                          --NIVEL 3
         end if;
         exit when not confirma("¿Desea añadir otro cliente?"); 		                   --ÚTILES
      end loop;
   end AltaCliente;

   --QH: Elimina uno o más clientes según el DNI ingresado por el usuario.
   --PRE: cliente=C
   --POS: clientes=C1 y C1 es C sin los clientes eliminados.
   --EXC:--
   procedure BajarCliente (clientes: in out abbClientes.tipoArbol) is
      k:tClaveCliente;
   begin
      loop
         k := enteroEnRango ("Ingrese el DNI de cliente", 10000000, 99999999);        --ÚTILES
         if existeCliente(clientes,k) then  							                     --NIVEL 3
            mostrarCliente (k,clientes); 								                     --NIVEL 3
            if confirma("esta seguro de eliminar al cliente:") then                   --UTILES
               suprimir (clientes,k);									                     --ADT ABB
            else
               Put_Line ("Eliminación cancelada");
            end if;
         else
            Put_Line ("Cliente no registrado");
         end if;
         exit when not confirma("desea eliminar otro cliente?"); 						    --ÚTILES
      end loop;
   end BajarCliente;

   --QH: Modifica los datos de un cliente mientras el usuario lo desee.
   --PRE: cliente=C
   --POS: cliente=C1 y C1 es C con los datos de clientes modificados.
   --EXC: --
   procedure ModificarCliente (clientes: in out abbClientes.tipoArbol) is
      k:tClaveCliente;
      i:tInfoCliente;
   begin
      loop
         k := enteroEnRango ("Ingrese el DNI de cliente", 10000000, 99999999);        --ÚTILES
         if existeCliente(clientes,k) then  							                     --NIVEL 3
            buscar(clientes,k,i);  										                 --ADT ABB
            mostrarCliente(k,clientes); 								                     --NIVEL 3
            if confirma("esta seguro de modificar al cliente?") then
               modificarDatosCliente(i); 							                        --NIVEL 3
               modificar(clientes,k,i); 								                     --ADT ABB
            end if;
         else
            Put_Line ("cliente no registrado");
         end if;
         exit when not confirma("desea modificar otro cliente?"); 						--ÚTILES
      end loop;
   end ModificarCliente;

   --QH: Genera y muestra el top 10 de clientes con mayor gasto.
   --PRE: clientes=C.
   --POS:-
   --EXC: --
   procedure Top10Clientes (clientes: in abbClientes.tipoArbol) is
      MAX: constant := 10;
      top: tCompradores;
      dim: integer;
   begin
      inicializarTop10Compradores(top,MAX);                   --NIVEL 3
      buscarTop10Compradores(clientes,top,dim);               --NIVEL 3
      if dim > 0 then
         mostrarTop10Compradores(clientes,top,dim);              --NIVEL 3
      else
         Put_Line ("No hay clientes para mostrar");
      end if;
   end Top10Clientes;

   --QH: Realiza la compra de créditos y actualiza los registros de creditos del cliente.
   --PRE: a=A
   --POS:a=A1 y A1 es A con el saldo de créditos de un cliente actualizado.
   --EXC: --
   procedure CompraCredito (clientes: in out abbClientes.tipoArbol) is
      valor: constant := 1000;
      recargo: constant := 1.1;
      n: integer;
      importe: float;
      k: tClaveCliente;
   begin
      loop
         k := enteroEnRango ("Ingrese el DNI de cliente", 10000000, 99999999);                     --ÚTILES
         if existeCliente(clientes,k) then                                                         --NIVEL 3
            n := enteroEnRango ("Ingrese la cantidad de creditos que desea comprar",1,9999999);    --ÚTILES
            importe := Float(n * valor) * recargo;
            Put("importe total de: $");
            put(importe,Fore => 10, Aft => 2,Exp =>0);
            New_Line;
            if confirma("desea acreditarlos?") then                                                --ÚTILES
               acreditacion(clientes,k,importe,n);                                                 --NIVEL 3
            else
               Put_Line("acreditacion cancelada");
            end if;
         else
            Put_Line("Cliente no registrado");
         end if;
         exit when not confirma("desea cargar mass créditos?");                                     --ÚTILES
      end loop;
   end CompraCredito;

   --QH: Muestra los datos de un cliente a partir de su DNI.
   --PRE: cliente=C.
   --POS: -
   --EXC: --
   procedure DetalleCliente (clientes: in abbClientes.tipoArbol) is
      k:tClaveCliente;
   begin
      loop
         k := enteroEnRango ("Ingrese el DNI de cliente", 10000000, 99999999);        --ÚTILES
         if existeCliente(clientes,k) then  							--NIVEL 3
				mostrarCliente(k,clientes); 								--NIVEL 3
         else
            Put_Line ("cliente no registrado");
         end if;
         exit when not confirma("¿Desea ver el detalle de otro cliente?"); 				--ÚTILES
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
