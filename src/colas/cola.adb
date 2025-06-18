with text_IO, unchecked_Deallocation;
use text_IO;

package body cola is

   procedure free is new Unchecked_Deallocation (tipoNodo, tipoPunt);

   procedure crear (q:out tipoCola) is
   begin
      q.frente:=null;
      q.final:=null;
   end crear;


   procedure encolar (q: in out tipoCola; i: in tipoInfo) is
      aux: tipoPunt;
   begin
      aux:= new tipoNodo;
      aux.info:= i;
      aux.sig:= null;
      if (q.frente /= null) then
         q.final.sig:= aux;
      else
         q.frente:= aux;
      end if;
      q.final:=aux;
   exception
      when STORAGE_ERROR => raise colaLlena;
   end encolar;


   procedure desencolar (q: in out tipoCola) is
      aux: tipoPunt;
   begin
      if (q.frente = null) then
         raise colaVacia;
      else
         aux:= q.frente;
         q.frente:= q.frente.sig;
         free(aux);
         if (q.frente = null) then
            q.final:= null;
         end if;
      end if;
   end desencolar;


   procedure frente(q: in tipoCola; i: out tipoInfo) is
   begin
      if (q.frente = null) then
         raise colaVacia;
      else
         i:= q.frente.info;
      end if;
   end frente;


   procedure vaciar(q:in out tipoCola) is
      aux: tipoPunt;
   begin
      while (q.frente /= null) loop
         aux:= q.frente;
         q.frente:= q.frente.sig;
         free(aux);
      end loop;
      q.final:= null;
   end vaciar;

   function esVacia(q:in tipoCola) return boolean is
   begin
      return (q.frente=null);
   end esVacia;

end cola;
