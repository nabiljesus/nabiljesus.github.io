    (*
     * parchisusb.pas
     *
     * Descripción: PLay Ludo!
     *
     * Autor: Emilio Blanco
     *        Nabil J. Márquez V.
     *
     * Última modificación: 07/01/2014
     *)
    PROGRAM parchisusb;
     
    USES
       crt;
    CONST
        ficharoja     = 12;  //color de fichas rojas
        fichaazul     = 9;   //color de fichas azules
        fichaverde    = 10;  //color de fichas verdes
        fichaamarilla = 14;  //color de fichas amarillas
        blanco        = 15;  //color blanco
    
    TYPE
       tColores = (rojo, verde, amarillo, azul);
     
        simbolocampo = record  //utilizado para las casillas que no son casa,meta o
            pri : String;//recta final que pueden tener una o dos fichas
            sec : String //y almacena los simbolos de estas
       
        end;
     
        tiposimbolocolor = record //almacena los simbolos en las casillas casas
            rojo     : String;    //y meta
            azul     : String;
            verde    : String;
            amarillo : String
        end;
     
       simbolocolormeta = record  //almacena los simbolos en las casillas de la
            rojo       : simbolocampo; //recta final de cada color
            azul       : simbolocampo;
            verde      : simbolocampo;
            amarillo   : simbolocampo
       end;
     
        tiposimbolo = record  //hace un registro de arreglos con los tipos anteriores.
            casa      : array[1..4]  of tiposimbolocolor; //posiciones casa
            meta      : array[1..4]  of tiposimbolocolor; //posiciones meta
            cfinal    : array[1..7]  of simbolocolormeta; //posociones recta final
            campo     : array[1..68] of simbolocampo  //posiciones neutras
        end;
     
       tipocampocolor = record  //utilizado para las casillas que no son casa,meta o
           pri : Byte;           //recta final que pueden tener una o dos fichas
           sec : Byte            //y almacena los colores de estas
       end;
     
       tipoposcolor = record   //almacena los colores en las casillas casa
           rojo     : Byte;     //y meta
           azul     : Byte;
           verde    : Byte;
           amarillo : Byte
       end;
     
       tipoposicionmeta = record       //almacena los colores en las casillas de la
            rojo     : tipocampocolor;   //recta final de cada color
            azul     : tipocampocolor;
            verde    : tipocampocolor;
            amarillo : tipocampocolor
       end;
     
       tipoposiciones = record //hace un registro de arreglos con los tipos anteriores.
            casa      : array[1..4]  of tipoposcolor; //posiciones casa
            meta      : array[1..4]  of tipoposcolor; //posiciones meta
            cfinal    : array[1..7]  of tipoposicionmeta; //posociones recta final
            campo     : array[1..68] of tipocampocolor//posiciones neutras
         
       end;

       informativo = record
                primera   : String;
                segunda   : String;
                tercera   : String;
                cuarta    : String;
                quinta    : String
       end;

    procedure tableroajedrez(x,y,m,n : Integer);
     //dibuja un tablero de ajedrez mxn en x,y monocolor.
     Var i,j : Integer;
     begin
         for i:=1 to m do
             for j:=1 to n do begin 
                 gotoxy((x+j),(y+i));
                 if ((x+j) mod 2=0) and ((y+i) mod 2=0) then begin                                 //2 blancos o 2 negros dependiendo
                     TextBackground(white);
                     Write(' ');    
                     TextBackground(black);
                     Write(' ');
                 end   
                 else if ((x+j) mod 2=0) and ((y+i) mod 2<>0) then begin
                     TextBackground(black);
                     Write(' ');    
                     TextBackground(black);  
                     Write(' ');
                 end  
                 else if ((x+j) mod 2<>0) and ((y+i) mod 2=0) then begin
                     TextBackground(black);
                     Write(' ');    
                     TextBackground(black);  
                     Write(' '); 
                 end 
                 else if ((x+j) mod 2<>0) and ((y+i) mod 2<>0) then begin
                     TextBackground(white);
                     Write(' ');    
                     TextBackground(black); 
                     Write(' ');  
                 end;
                 end; 

     end; 

    procedure cuadro(x,y,m,n : Integer);
     //dibuja 3 cuadrados en x,y monocolor.
     Var 
        i,j       : Integer;
     begin
         for i:=1 to m do
             for j:=1 to n do begin 
                 textbackground(black);
                 gotoxy((x+j),(y+i));
                 if  (i=1) and (j=1) then                                
                     writeln('┌')
                 else if  (i=m) and (j=1) then                                
                     writeln('└')
                 else if  (i=m) and (j=n) then                                
                     write('┘')
                 else if  (i=1) and (j=n) then                               
                     writeln('┐')
                 else if  (i<>m) and ((j=1) or (j=n)) then                
                     writeln('│')
                 else if  ((i=m) or (i=1)) and (j<>n) then                                
                     writeln('─')
                 else                                  
                     writeln(' ');
             end; 
     end; 

    procedure cuadrosb(x,y,m,n,c : Integer); //crea un cuadro de color c
     Var 
        i,j       : Integer;
     begin
         for i:=1 to m do
             for j:=1 to n do begin 
                 textbackground(c);
                 gotoxy((x+j),(y+i));
                     writeln(' ');
             end; 
     end; 

    procedure title(x,y,sat : Integer);
     //dibuja un ParchisUsb 
     var
         color : tipoposcolor;
     begin
     if sat=1 then begin
         color.rojo:=4;
         color.azul:=1;
         color.verde:=2;
         color.amarillo:=14;
     end
     else begin
         color.rojo:=14;
         color.azul:=4;
         color.verde:=1;
         color.amarillo:=2; 
     end;
         //letra P
         cuadrosb(x,y,7,4,color.rojo);
         cuadrosb(x+4,y,2,3,color.rojo);
         cuadrosb(x+4,y+3,2,3,color.rojo);
         cuadrosb(x+7,y+1,3,3,color.rojo);
         //letra A
         cuadrosb(x+12,y,7,4,color.azul);
         cuadrosb(x+16,y,2,6,color.azul);
         cuadrosb(x+16,y+3,2,3,color.azul);
         cuadrosb(x+19,y+1,6,3,color.azul);
         //letra R
         cuadrosb(x+24,y,7,4,color.verde);
         cuadrosb(x+28,y,2,3,color.verde);
         cuadrosb(x+28,y+3,2,3,color.verde);
         cuadrosb(x+31,y+1,3,3,color.verde);
         cuadrosb(x+29,y+5,1,3,color.verde);
         cuadrosb(x+30,y+6,1,3,color.verde);
         //letra C
         cuadrosb(x+36,y,7,4,color.amarillo);
         cuadrosb(x+40,y,2,6,color.amarillo);
         cuadrosb(x+40,y+5,2,6,color.amarillo);
         //letra H
         cuadrosb(x+48,y,7,4,color.rojo);
         cuadrosb(x+52,y+2,2,3,color.rojo);
         cuadrosb(x+55,y,7,3,color.rojo);
         //letra I
         cuadrosb(x+60,y,2,7,color.azul);
         cuadrosb(x+62,y,7,3,color.azul);
         cuadrosb(x+60,y+5,2,7,color.azul);
         //letra S
         cuadrosb(x+69,y,2,10,color.verde);
         cuadrosb(x+69,y+2,2,4,color.verde);
         cuadrosb(x+69,y+3,1,10,color.verde);
         cuadrosb(x+76,y+3,4,3,color.verde);
         cuadrosb(x+69,y+5,2,10,color.verde);
         //letra U
         cuadrosb(x+58,y+6,5,2,color.verde);
         cuadrosb(x+58,y+10,1,7,color.verde);
         cuadrosb(x+63,y+6,5,2,color.verde);
         //letra S
         cuadrosb(x+66,y+6,1,7,color.rojo);
         cuadrosb(x+66,y+6,3,2,color.rojo);
         cuadrosb(x+66,y+8,1,7,color.rojo);
         cuadrosb(x+71,y+8,3,2,color.rojo);
         cuadrosb(x+66,y+10,1,7,color.rojo);
         //letra B
         cuadrosb(x+75,y+6,1,6,color.azul);
         cuadrosb(x+80,y+7,1,2,color.azul);
         cuadrosb(x+75,y+6,5,2,color.azul);
         cuadrosb(x+75,y+6,3,2,color.azul);
         cuadrosb(x+75,y+8,1,6,color.azul);
         cuadrosb(x+80,y+9,1,2,color.azul);
         cuadrosb(x+75,y+10,1,6,color.azul);
     end;

    procedure titleanim(x,y,del,long : Integer); //anima el titulo
     var i : integer;
     begin
       for i:=1 to long do begin
           title(x,y,0);
           delay(del);
           title(x,y,1);
           delay(del);
           textbackground(black);
       end;
     end;
    
    procedure layoutmain(); //crea la plantilla para la pantalla de juego
         begin
             tableroajedrez(1,1,47,140);
             cuadro(50,15,12,85);
             cuadro(50,32,12,40);
             cuadro(95,32,12,20);
             cuadro(70,28,3,40);
         end;

    procedure layoutcfg(); //crea la plantilla para la pantalla de config
         begin
             tableroajedrez(1,1,47,140);
             titleanim(30,3,150,3);
             cuadro(16,15,25,110);
         end;

    function IntToStr (n : Longint) : String; // convierte un integer en un string
     
       Var S : String;
     
       begin
             Str (n,S);
             IntToStr:=S;
       end;
     
    function ColorToStr (color : tColores) : String; //convierte un color en string
     begin
        if color=rojo then
            ColorToStr:='rojo';
        if color=azul then
            ColorToStr:='azul';
        if color=verde then
            ColorToStr:='verde';
        if color=Amarillo then
            ColorToStr:='amarillo';
     end;
     
    procedure asignamaquinas(
      Colorjug     : tColores;
      jugadores    : integer;
      var maquinas : array of tColores
      ); //Le asigna los colores restantes a las maquinas.
      Var i : tColores;
      var j : integer;
     begin
     if jugadores=4 then begin
         j:=0;
         for i:=rojo to azul do begin
             if Colorjug<>i then begin
                 maquinas[j]:=i;
                 j:=j+1;
             end;
         end;
       end
     else begin //Para hacer justo el juego, la maquina es siempre del color opuesto al jugador.
         if Colorjug=rojo then
             maquinas[0]:=amarillo;
         if Colorjug=verde then
             maquinas[0]:=azul;
         if Colorjug=amarillo then
             maquinas[0]:=rojo;
         if Colorjug=azul then
             maquinas[0]:=verde;
      end;
     end;
     
    procedure imprimirtexto(
        historico  : informativo //texto que informa de lo que sucede en la partida
       ); //Informa lo que sucede en la partida
       BEGIN
       {Pre: TRUE}
       with (historico) do
       begin
           gotoxy(55,18);
           Writeln('1: ',primera);
           gotoxy(55,20);
           Writeln('2: ',segunda);
           gotoxy(55,22);
           Writeln('3: ',tercera);
           gotoxy(55,24);
           Writeln('4: ',cuarta);
           gotoxy(55,26);
           Writeln('5: ',quinta);
       end;
     
       {Post: (%Exists i:1<=i<=6:LanzarDado=i)}
        end;
     
    procedure cambiartexto(
        var historico  : informativo; //texto que informa de lo que sucede en la partida
            nuevalinea : String // Nueva linea a agregar
        ); //Hace un "scroll" del historico de la partida.
       BEGIN
       {Pre: TRUE}
           historico.primera:=historico.segunda;
           historico.segunda:=historico.tercera;
           historico.tercera:=historico.cuarta;
           historico.cuarta:=historico.quinta;
           historico.quinta:=nuevalinea;
       {Post: (%Exists i:1<=i<=6:LanzarDado=i)}
        end;
     
    procedure LanzarDados(
      var Dado  :  array of byte
      ); //Lanza dos dados
        var x,y : integer;
        begin
       {Pre: TRUE}
          for y:= 0 to 1 do BEGIN
              for x:= 1 to 15 do begin;
                  Dado[y]:=random(6)+1;
              end;
              delay(120);
          end;
       {Post: (%Exists i:1<=i<=6:(%Forall j:0<=j<=1:Dado[j]=i))}
        end;
     
    procedure dadosmoviles(
        dados : array of byte
        ); //Muestra dos dados
         var 
             dadoslocales : array[0..1] of byte;
             linea        : array[0..1] of string;
             dadoactual   : integer;
             i            : integer;
         begin
         for i:=0 to 5 do begin
             LanzarDados(dadoslocales);
             if i<4 then
                 if i mod 2 = 0 then
                     dadoactual:=dadoslocales[0]
                 else
                     dadoactual:=dadoslocales[1]
             else
                 if i mod 2 = 0 then
                     dadoactual:=dados[0]
                 else
                     dadoactual:=dados[1];
             if dadoactual=1 then begin
                 linea[0]:='|  ●  |';
                 linea[1]:='|     |';
             end
             else if dadoactual=2 then begin
                 linea[0]:='|    ●|';
                 linea[1]:='|●    |';
             end
             else if dadoactual=3 then begin
                 linea[0]:='|  ● ●|';
                 linea[1]:='|  ●  |';
             end
             else if dadoactual=4 then begin
                 linea[0]:='|●   ●|';
                 linea[1]:='|●   ●|';
             end
             else if dadoactual=5 then begin
                 linea[0]:='|● ● ●|';
                 linea[1]:='|●   ●|';
             end
             else if dadoactual=6 then begin
                 linea[0]:='|● ● ●|';
                 linea[1]:='|● ● ●|';
             end;
             if (i mod 2 = 0) then begin
                 gotoxy(97,35);
                 write('┌─────┐');
                 gotoxy(97,36);
                 write(linea[0]);
                 gotoxy(97,37);
                 write(linea[1]);
                 gotoxy(97,38);
                 write('└─────┘');
             end
             else begin
                 gotoxy(106,40);
                 write('┌─────┐');
                 gotoxy(106,41);
                 write(linea[0]);
                 gotoxy(106,42);
                 write(linea[1]);
                 gotoxy(106,43);
                 write('└─────┘');
             end;
             writeln(dadoactual);
             delay(130);
         end;
       end;

    function SumaDados(
      var Dado  :  array of byte
      ) : integer; //La suma de los dos dados
        begin
          SumaDados:=Dado[0]+Dado[1];
        end;
     
    function DadosDobles(
      var Dado : array of byte;
      ) : boolean;
        begin
          if (Dado[0]=Dado[1]) then
             DadosDobles:=true;
          else
             DadosDobles:=false;
        end;
    
    procedure pantallafinal(
      salir : integer; //0 menu principal. 1 salir.
      var  jugadores  : Integer;
      var  posiciones : tipoposiciones; // Almacena las posiciones de cada  casilla
      var  historico  : informativo; //Informa al usuario lo sucedido en la partida.
      var  Colorjug   : tColores; //Almacena el color que el jugador usará.
      var  primero    : tColores;
      var  orden      : array of tColores;
      var  turnoactual: tColores); //cierra el juego o regresa al menu principal
         begin
             tableroajedrez(1,1,47,140);
             titleanim(30,3,150,6);
             cuadro(16,15,25,110);
             gotoxy(20,18);
             Writeln('    »   Gracia por jugar Parchis-USB');
            // start(jugadores,posiciones,historico,Colorjug,primero,
            //   orden,turnoactual);
             halt;
         end;

    function Completaconespacios(
      n : integer;
      S : string
      ):String; //concatena espacios hasta que S sea de tamaño n;
     var i : integer;
     begin
       if Length(S)<n then
           for i:=Length(S) to n do
               S:=S+' '; 
       Completaconespacios:=S;
     end; 

    function Menu(
      cant    : integer;
      mensaje : string;
      opcion1 : string;
      opcion2 : string;
      opcion3 : string;
      opcion4 : string
      ) : integer;
        var
            x  : Integer;
            y  : integer;
            ch : char;
            k  : integer;
        begin
           opcion1:=Completaconespacios(15,opcion1);
           opcion2:=Completaconespacios(15,opcion2);
           opcion3:=Completaconespacios(15,opcion3);
           opcion4:=Completaconespacios(15,opcion4);
           k:=1;
           x:=55;
           y:=35;
           repeat
                Textcolor(White);
                gotoxy(x,y);
                Write(Completaconespacios(15,mensaje));
               if (k=1) then begin
                   gotoxy(x,y+1);
                   Textcolor(white);
                   TextBackground(White);
                   Write('» ');write(opcion1);
                   gotoxy(x,y+2);
                   Textcolor(white);
                   TextBackground(black);
                   Write('» ');write(opcion2);
                   gotoxy(x,y+3);
                   Textcolor(white);
                   TextBackground(black);
                   Write('» ');write(opcion3);
                   gotoxy(x,y+4);
                   Textcolor(white);
                   TextBackground(black);
                   Write('» ');write(opcion4);
                   menu:=1;
               end;
               if (k=2) then begin
                   gotoxy(x,y+1);
                   Textcolor(white);
                   TextBackground(black);
                   Write('» ');write(opcion1);
                   gotoxy(x,y+2);
                   Textcolor(white);
                   TextBackground(white);
                   Write('» ');write(opcion2);
                   gotoxy(x,y+3);
                   Textcolor(white);
                   TextBackground(black);
                   Write('» ');write(opcion3);
                   gotoxy(x,y+4);
                   Textcolor(white);
                   TextBackground(black);
                   Write('» ');write(opcion4);
                   menu:=2;
               end;
               if (k=3) then begin
                   gotoxy(x,y+1);
                   Textcolor(white);
                   TextBackground(black);
                   Write('» ');write(opcion1);
                   gotoxy(x,y+2);
                   Textcolor(white);
                   TextBackground(black);
                   Write('» ');write(opcion2);
                   gotoxy(x,y+3);
                   Textcolor(white);
                   TextBackground(White);
                   Write('» ');write(opcion3);
                   gotoxy(x,y+4);
                   Textcolor(white);
                   TextBackground(black);
                   Write('» ');write(opcion4);
                   menu:=3;
               end;
               if (k=3) then begin
                   gotoxy(x,y+1);
                   Textcolor(white);
                   TextBackground(black);
                   Write('» ');write(opcion1);
                   gotoxy(x,y+2);
                   Textcolor(white);
                   TextBackground(black);
                   Write('» ');write(opcion2);
                   gotoxy(x,y+3);
                   Textcolor(white);
                   TextBackground(white);
                   Write('» ');write(opcion3);
                   gotoxy(x,y+4);
                   Textcolor(white);
                   TextBackground(White);
                   Write('» ');write(opcion4);
                   menu:=4;
               end;
               ch:=ReadKey;
               if (ch=#72) then
                   if k<>1 then
                       k:=k-1;
               if ch=#80 then
                   if k<>cant then
                       k:=k+1;
           until ch=#13; //enter
     end;

    procedure mturnoactual(
      color : tColores
      );
      var nColor : byte; //Color en byte
      begin
        if color=rojo then
            ncolor:=4;
        if color=azul then
            ncolor:=1;
        if color=verde then
            ncolor:=2;
        if color=amarillo then
            ncolor:=14;
        gotoxy(74,30);
        textColor(white);
        write('> Turno de: ');
        textcolor(ncolor);
        write(Completaconespacios(15,ColorToStr(color)));
        textcolor(white);
     end;
     
    procedure menuinicial(
      var historico  : informativo;
      var jug            : array of integer;
      Colorjug   : tColores
      ) ; //Menu utilizado al inicio del juego.
        var
            dado      : array[0..1] of byte;
            opcion    : integer;
       BEGIN
       {Pre: TRUE}
           opcion:=menu(2,'¿Que desea hacer? :','Lanzar Dados.','Salir.','','');
               if opcion=2 then BEGIN;
                   opcion:=menu(2,'¿Esta seguro? :','Sí','No','','');
                   if opcion=1 then begin
                       pantallafinal(0,jugadores,posiciones,historico,Colorjug,
                        primero,orden,turnoactual);
                       opcion:=1;
                   end;
               end;
               if opcion=1 then begin
       {Post CantidadJugadores=2 \/ CantidadJugadores=4}
       end;
          LanzarDados(dado);
          mturnoactual(Colorjug);
          dadosmoviles(dado);
          imprimirtexto(historico);
          cambiartexto(historico,Completaconespacios(40,ColorToStr(Colorjug)
             +' obtuvo:'+IntToStr(dado[0])+' y '+IntToStr(dado[1])));
          jug[3]:=SumaDados(dado);
          imprimirtexto(historico);
        end;

    function Defineprimero(
      var historico  : informativo;
      jugadores  : integer;
      maquinas   : array of tColores;
      Colorjug   : tColores
      )  :  tColores; //define quien es el primer jugador;
        var
            jug       : array[0..3] of integer;
            dado      : array[0..1] of byte;
            i         : byte;
            j         : byte;
            tryagain  : boolean;
            max       : integer;
     
        begin
          menuinicial(historico,jug,Colorjug);
          imprimirtexto(historico);gotoxy(1,48);
          if jugadores=2 then begin
              mturnoactual(maquinas[0]);
              LanzarDados(dado);
              dadosmoviles(dado);
              cambiartexto(historico,Completaconespacios(40,ColorToStr(maquinas[0])
                +' obtuvo:'+IntToStr(dado[0])+' y '+IntToStr(dado[1])));
              jug[0]:=SumaDados(dado);
              imprimirtexto(historico);
              jug[1]:=0;
              jug[2]:=0;
              delay(1500)
          end
          else begin
              for i:=0 to 2 do begin
                  mturnoactual(maquinas[i]);
                  LanzarDados(dado);
                  dadosmoviles(dado);
                  cambiartexto(historico,Completaconespacios(40,ColorToStr(maquinas[i])
                    +' obtuvo:'+IntToStr(dado[0])+' y '+IntToStr(dado[1])));
                  jug[i]:=SumaDados(dado);
                  imprimirtexto(historico);
                  delay(1500);
              end;
          end;
          Defineprimero:=maquinas[0];
          max:=jug[0];
          tryagain:=false;
          for i:=0 to 2 do begin
              if max<=jug[i] then begin
                Defineprimero:=maquinas[i];
                max:=jug[i];
              end;
          end;
          if max<=jug[3] then begin
              Defineprimero:=Colorjug;
              max:=jug[3];
          end;
          j:=0;
          for i:=0 to 3 do begin
              if max=jug[i] then begin
                  j:=j+1;
                  tryagain:=(j>1);
              end;
          end;
          if tryagain then begin
              cambiartexto(historico,Completaconespacios(40,
                'Empate primer lugar. Nuevo intento.'));
              imprimirtexto(historico);
              Defineprimero:=Defineprimero(historico,jugadores,maquinas,Colorjug);    
          end
          else begin
              cambiartexto(historico,Completaconespacios(40,
                'El primer jugador es: '+ColorToStr(Defineprimero)));
              imprimirtexto(historico);
          end;
        end;
     
    procedure DefineOrden(
      var orden : array of tColores;
      primero   : tColores
      ); //establece el orden de los turnos
     begin
         if primero=rojo then begin
            orden[0]:=rojo;
            orden[1]:=azul;
            orden[2]:=amarillo;
            orden[3]:=verde;
         end;
         if primero=azul then begin
            orden[0]:=azul;
            orden[1]:=amarillo;
            orden[2]:=verde;
            orden[3]:=rojo;
         end;
         if primero=amarillo then begin
            orden[0]:=amarillo;
            orden[1]:=verde;
            orden[2]:=rojo;
            orden[3]:=azul;
         end;
         if primero=verde then begin
            orden[0]:=verde;
            orden[1]:=rojo;
            orden[2]:=azul;
            orden[3]:=amarillo;
         end;
     end;
    
    function CantidadJugadores(
      var historico  : informativo //texto que informa de lo que sucede en la partida
      ): Integer; //Pregunta al usuario cuantos jugadores.
       VAR
              ch : char;
              k  : integer;
       BEGIN
       {Pre: TRUE}
           k:=75;
           repeat
                Textcolor(White);
                gotoxy(20,18);
                Writeln('¿Con cuantos jugadores desea Jugar?      ');
                gotoxy(20,19);
                Write('Utilice las flechas derecha e izquierda para moverse',
                ' y ENTER');
                Writeln(' para seleccionar una opción:     ');
               if (k=75) then begin
                   gotoxy(20,22);
                   Textcolor(White);
                   TextBackground(red);
                   Write('2');
                   Textcolor(White);
                   TextBackground(black);
                   Writeln('   ───   4      ');
                   CantidadJugadores:=2;
                end;
               if (k=77) then begin
                   gotoxy(20,22);
                   Textcolor(White);
                   TextBackground(black);
                   Write('2   ───   ');
                   Textcolor(White);
                   TextBackground(Red);
                   Write('4');
                   TextBackground(black);
                   CantidadJugadores:=4;
               end;
                ch:=ReadKey;
                if (ch=#75) then
                    k:=75;
                if ch=#77 then
                    k:=77;
           until ch=#13; //enter
           cambiartexto(historico,Completaconespacios(40,
            'Cantidad de jugadores: '+IntToStr(CantidadJugadores)));
       {Post CantidadJugadores=2 \/ CantidadJugadores=4}
       end;
     
    function Colorjugador(
      var historico  : informativo //texto que informa de lo que sucede en la partida
      ): tColores; //Pregunta al usuario con que color desea jugar
       VAR
          ch : char;      //tecla del teclado
          k  : integer;   //auxiliar
       BEGIN
       {Pre: TRUE}
           k:=1;
           repeat
                Textcolor(White);
                gotoxy(20,18);
                Writeln('¿Con que color desea Jugar?');
                gotoxy(20,19);
                Write('Utilice las flechas derecha e izquierda para moverse',
                ' y ENTER');
                Writeln(' para seleccionar una opción:      ');
               if (k=1) then begin
                   gotoxy(20,22);
                   Textcolor(White);
                   TextBackground(red);
                   Write('Rojo');
                   Textcolor(White);
                   TextBackground(black);
                   Writeln(' ─── Azul ─── Verde ─── Amarillo        ');
                   Colorjugador:=rojo;
               end;
               if (k=2) then begin
                   gotoxy(20,22);
                   Textcolor(White);
                   Write('Rojo ─── ');
                   TextBackground(blue);
                   Write('Azul');
                   textcolor(White);
                   TextBackground(black);
                   Writeln(' ─── Verde ─── Amarillo      ');
                   Colorjugador:=azul;
               end;
               if (k=3) then begin
                   gotoxy(20,22);
                   Textcolor(White);
                   Write('Rojo ─── Azul ─── ');
                   TextBackground(Green);
                   Write('Verde');
                   textcolor(White);
                   TextBackground(black);
                   Writeln(' ─── Amarillo      ');
                   Colorjugador:=verde;
               end;
               if (k=4) then begin
                   gotoxy(20,22);
                   Textcolor(White);
                   Write('Rojo ─── Azul ─── Verde ─── ');
                   TextBackground(yellow);
                   Write('Amarillo');
                   textcolor(White);
                   TextBackground(black);
                   Writeln();
                   Colorjugador:=amarillo;
               end;
                ch:=ReadKey;
                if (ch=#75) then
                    if k<>1 then
                        k:=k-1;
                if ch=#77 then
                    if k<>4 then
                        k:=k+1;
                if k=0 then
                    k:=1;
           until ch=#13; //enter
           Clrscr;
           cambiartexto(historico,Completaconespacios(40,
            'Color del jugador: '+ColorToStr(Colorjugador)));
       {Post Colorjugador=rojo \/ Colorjugador=azul \/ Colorjugador=verde
        \/ Colorjugador=amarillo}
       end;
     
    procedure posinicial(
        var posiciones    : tipoposiciones // Almacena las posiciones de cada casilla
       ); //Inicializa las posiciones
       VAR
           X  : Integer;
       begin
           randomize;
           for x:=1 to 68 do begin  //inicializando las casillas neutras
               posiciones.campo[x].pri:=0;
               posiciones.campo[x].sec:=0;
           end;
           for x:=1 to 7 do begin  //inicializando las rectas finales
               posiciones.cfinal[x].rojo.pri:=0;
               posiciones.cfinal[x].rojo.sec:=0;
               posiciones.cfinal[x].azul.pri:=0;
               posiciones.cfinal[x].azul.sec:=0;
               posiciones.cfinal[x].verde.pri:=0;
               posiciones.cfinal[x].verde.sec:=0;
               posiciones.cfinal[x].amarillo.pri:=0;
               posiciones.cfinal[x].amarillo.sec:=0;
           end;
           for x:=1 to 4 do begin  //inicializando las casillas de casas y metas
               posiciones.casa[x].rojo:=1;
               posiciones.casa[x].azul:=2;
               posiciones.casa[x].verde:=4;
               posiciones.casa[x].amarillo:=3;
               posiciones.meta[x].rojo:=0;
               posiciones.meta[x].azul:=0;
               posiciones.meta[x].verde:=0;
               posiciones.meta[x].amarillo:=0;
            end;
       end;    
     
    procedure formatoimprimible(
        posiciones    : tipoposiciones;// Almacena las posiciones de cada casilla
        var casilla    : tiposimbolo;// Almacena los simbolos de cada casilla
        var colores    : tipoposiciones// Almacena los colores de cada  casilla
       ); //De las posiciones crea dos registros de arreglos con los simbolos
          //y los colores correspondientes a cada posición.
        VAR
           X  : Integer;
           S  : array[0..4] of integer;
     
       begin
           S[1]:=ficharoja;
           S[0]:=blanco;
           S[2]:=fichaazul;
           S[4]:=fichaverde;
           S[3]:=fichaamarilla;
           for x:=1 to 68 do begin  //convirtiendo las casillas neutras
               if posiciones.campo[x].pri<>0 then begin
                   casilla.campo[x].pri:='●';
                   colores.campo[x].pri:=S[posiciones.campo[x].pri];
               end
               else begin
                   casilla.campo[x].pri:=' ';
                   colores.campo[x].pri:=S[posiciones.campo[x].pri];
               end;
               if posiciones.campo[x].sec<>0 then begin
                   casilla.campo[x].sec:='●';
                   colores.campo[x].sec:=S[posiciones.campo[x].sec];
               end
               else begin
                   casilla.campo[x].sec:=' ';
                   colores.campo[x].sec:=S[posiciones.campo[x].sec];
               end;
           end;
           for x:=1 to 7 do begin  //convirtiendo las rectas finales
     
               if posiciones.cfinal[x].rojo.pri<>0 then begin //recta roja
                   casilla.cfinal[x].rojo.pri:='●';
                   colores.cfinal[x].rojo.pri:=S[posiciones.cfinal[x].rojo.pri];
               end
               else begin
                   casilla.cfinal[x].rojo.pri:=' ';
                   colores.cfinal[x].rojo.pri:=S[posiciones.cfinal[x].rojo.pri];
               end;
               if posiciones.cfinal[x].rojo.sec<>0 then begin
                   casilla.cfinal[x].rojo.sec:='●';
                   colores.cfinal[x].rojo.sec:=S[posiciones.cfinal[x].rojo.sec];
               end
               else begin
                   casilla.cfinal[x].rojo.sec:=' ';
                   colores.cfinal[x].rojo.sec:=S[posiciones.cfinal[x].rojo.sec];
               end;
     
               if posiciones.cfinal[x].azul.pri<>0 then begin //recta azul
                   casilla.cfinal[x].azul.pri:='●';
                   colores.cfinal[x].azul.pri:=S[posiciones.cfinal[x].azul.pri];
               end
               else begin
                   casilla.cfinal[x].azul.pri:=' ';
                   colores.cfinal[x].azul.pri:=S[posiciones.cfinal[x].azul.pri];
               end;
               if posiciones.cfinal[x].azul.sec<>0 then begin
                   casilla.cfinal[x].azul.sec:='●';
                   colores.cfinal[x].azul.sec:=S[posiciones.cfinal[x].azul.sec];
               end
               else begin
                   casilla.cfinal[x].azul.sec:=' ';
                   colores.cfinal[x].azul.sec:=S[posiciones.cfinal[x].azul.sec];
               end;
     
               if posiciones.cfinal[x].verde.pri<>0 then begin //recta verde
                   casilla.cfinal[x].verde.pri:='●';
                   colores.cfinal[x].verde.pri:=S[posiciones.cfinal[x].verde.pri];
               end
               else begin
                   casilla.cfinal[x].verde.pri:=' ';
                   colores.cfinal[x].verde.pri:=S[posiciones.cfinal[x].verde.pri];
               end;
               if posiciones.cfinal[x].verde.sec<>0 then begin
                   casilla.cfinal[x].verde.sec:='●';
                   colores.cfinal[x].verde.sec:=S[posiciones.cfinal[x].verde.sec];
               end
               else begin
                   casilla.cfinal[x].verde.sec:=' ';
                   colores.cfinal[x].verde.sec:=S[posiciones.cfinal[x].verde.sec];
               end;
     
               if posiciones.cfinal[x].amarillo.pri<>0 then begin //recta amarilla
                   casilla.cfinal[x].amarillo.pri:='●';
                   colores.cfinal[x].amarillo.pri:=S[posiciones.cfinal[x].amarillo.pri];
               end
               else begin
                   casilla.cfinal[x].amarillo.pri:=' ';
                   colores.cfinal[x].amarillo.pri:=S[posiciones.cfinal[x].amarillo.pri];
               end;
               if posiciones.cfinal[x].amarillo.sec<>0 then begin
                   casilla.cfinal[x].amarillo.sec:='●';
                   colores.cfinal[x].amarillo.sec:=S[posiciones.cfinal[x].amarillo.sec];
               end
               else begin
                   casilla.cfinal[x].amarillo.sec:=' ';
                   colores.cfinal[x].amarillo.sec:=S[posiciones.cfinal[x].amarillo.sec];
               end;
            end;
            for x:=1 to 4 do begin  //convirtiendo las casillas de casas
               if posiciones.casa[x].rojo<>0 then begin //casas rojas
                    casilla.casa[x].rojo:='●';
                    colores.casa[x].rojo:=S[posiciones.casa[x].rojo];
               end
               else begin
                    casilla.casa[x].rojo:=' ';
                    colores.casa[x].rojo:=S[posiciones.casa[x].rojo];
               end;
     
               if posiciones.casa[x].azul<>0 then begin //casas azules
                    casilla.casa[x].azul:='●';
                    colores.casa[x].azul:=S[posiciones.casa[x].azul];
               end
               else begin
                    casilla.casa[x].azul:=' ';
                    colores.casa[x].azul:=S[posiciones.casa[x].azul];
               end;
     
               if posiciones.casa[x].verde<>0 then begin  //casas verdes
                    casilla.casa[x].verde:='●';
                    colores.casa[x].verde:=S[posiciones.casa[x].verde];
               end
               else begin
                    casilla.casa[x].verde:=' ';
                    colores.casa[x].verde:=S[posiciones.casa[x].verde];
               end;
     
               if posiciones.casa[x].amarillo<>0 then begin  //casas amaril
                    casilla.casa[x].amarillo:='●';
                    colores.casa[x].amarillo:=S[posiciones.casa[x].amarillo];
               end
               else begin
                    casilla.casa[x].amarillo:=' ';
                    colores.casa[x].amarillo:=S[posiciones.casa[x].amarillo];
               end;
            end;
            for x:=1 to 4 do begin  //convirtiendo las casillas de metas
               if posiciones.meta[x].rojo<>0 then begin //meta rojas
                    casilla.meta[x].rojo:='●';
                    colores.meta[x].rojo:=S[posiciones.meta[x].rojo];
               end
               else begin
                    casilla.meta[x].rojo:=' ';
                    colores.meta[x].rojo:=S[posiciones.meta[x].rojo];
               end;
     
               if posiciones.meta[x].azul<>0 then begin //meta azules
                    casilla.meta[x].azul:='●';
                    colores.meta[x].azul:=S[posiciones.meta[x].azul];
               end
               else begin
                    casilla.meta[x].azul:=' ';
                    colores.meta[x].azul:=S[posiciones.meta[x].azul];
               end;
     
               if posiciones.meta[x].verde<>0 then begin  //meta verdes
                    casilla.meta[x].verde:='●';
                    colores.meta[x].verde:=S[posiciones.meta[x].verde];
               end
               else begin
                    casilla.meta[x].verde:=' ';
                    colores.meta[x].verde:=S[posiciones.meta[x].verde];
               end;
     
               if posiciones.meta[x].amarillo<>0 then begin  //meta amarillas
                    casilla.meta[x].amarillo:='●';
                    colores.meta[x].amarillo:=S[posiciones.meta[x].amarillo];
               end
               else begin
                    casilla.meta[x].amarillo:=' ';
                    colores.meta[x].amarillo:=S[posiciones.meta[x].amarillo];
               end;
            end;
       end;    
    
    procedure entablero(
      posiciones    : tipoposiciones // Almacena las posiciones de cada  casilla
      ); // Dibuja un tablero con las fichas
        VAR
            casilla    : tiposimbolo; // Almacena los simbolos de cada casilla
            colores    : tipoposiciones;  // Almacena los colores de cada  casilla
            y          : integer; //pos y
        BEGIN
            formatoimprimible(posiciones,casilla,colores); //Transforma las posicion-
            TextBackground(0);   //nes en simbolos y colores para cada casilla   
            TextColor (15);   //del tablero
            y:=3;
            y:=y+1;;
            gotoxy(7,y);
            y:=y+1;
            Write('┌─────────────┬──┬───┬──┬─────────────┐');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            textColor (15);
            Write('│             │');
            TextColor(colores.campo[33].sec);
            Write(casilla.campo[33].sec);
            TextColor(colores.campo[33].pri);
            Write(casilla.campo[33].pri);
            Write('│');
            TextBackground(white);  
            TextColor(colores.campo[34].sec);
            Write(casilla.campo[34].sec);
            Write(' ');
            TextColor(colores.campo[34].pri);
            Write(casilla.campo[34].pri);
            TextBackground(black);  
            Write('│');
            TextColor(colores.campo[36].sec);
            Write(casilla.campo[36].sec);
            TextColor(colores.campo[36].pri);
            Write(casilla.campo[36].pri);
            Write('│             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             ├──┼───┼──┤             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             │');
            TextColor(colores.campo[32].sec);
            Write(casilla.campo[32].sec);
            TextColor(colores.campo[32].pri);
            Write(casilla.campo[32].pri);
            Write('│');
            TextBackground(blue);
            TextColor(colores.cfinal[01].azul.sec);
            Write(casilla.cfinal[01].azul.sec);
            TextColor(white);
            Write(' ');
            TextColor(colores.cfinal[01].azul.pri);
            Write(casilla.cfinal[01].azul.pri);
            TextColor(white);
            TextBackground(black);
            Write('│');
            TextColor(colores.campo[36].sec);
            Write(casilla.campo[36].sec);
            TextColor(colores.campo[36].pri);
            Write(casilla.campo[36].pri);
            Write('│             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             ├──┼');
            TextBackground(blue);
            Write('───');
            TextBackground(black);
            Write('┼──┤             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             │');
            TextColor(colores.campo[31].sec);
            Write(casilla.campo[31].sec);
            TextColor(colores.campo[31].pri);
            Write(casilla.campo[31].pri);
            Write('│');
            TextBackground(blue);
            TextColor(colores.cfinal[02].azul.sec);
            Write(casilla.cfinal[02].azul.sec);
            TextColor(white);
            Write(' ');
            TextColor(colores.cfinal[02].azul.pri);
            Write(casilla.cfinal[02].azul.pri);
            TextColor(white);
            TextBackground(black);
            Write('│');
            TextColor(colores.campo[37].sec);
            Write(casilla.campo[37].sec);
            TextColor(colores.campo[37].pri);
            Write(casilla.campo[37].pri);
            Write('│             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             ├──┼');
            TextBackground(blue);
            Write('───');
            TextBackground(black);
            Write('┼──┤             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│  ');
            TextBackground(blue);
            Write('/   ');
            TextColor(colores.casa[01].azul);
            Write(casilla.casa[01].azul);
            TextColor(white);
            Write('   \');
            TextBackground(black);
            Write('  │');
            TextColor(colores.campo[30].sec);
            Write(casilla.campo[30].sec);
            TextColor(colores.campo[30].pri);
            Write(casilla.campo[30].pri);
            Write('│');
            TextBackground(blue);
            TextColor(colores.cfinal[03].azul.sec);
            Write(casilla.cfinal[03].azul.sec);
            TextColor(white);
            Write(' ');
            TextColor(colores.cfinal[03].azul.pri);
            Write(casilla.cfinal[03].azul.pri);
            TextColor(white);
            TextBackground(black);
            Write('│');
            TextColor(colores.campo[38].sec);
            Write(casilla.campo[38].sec);
            TextColor(colores.campo[38].pri);
            Write(casilla.campo[38].pri);
            Write('│  ');
            TextBackground(yellow);
            Write('/   ');
            TextColor(colores.casa[01].amarillo);
            Write(casilla.casa[01].amarillo);
            TextColor(white);
            Write('   \');
            TextBackground(black);
            Write('  │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│ ');
            TextBackground(blue);
            Write('/    ↑    \');
            TextBackground(black);
            Write(' ├──┼');
            TextBackground(blue);
            Write('───');
            TextBackground(black);
            Write('┼──┤ ');
            TextBackground(yellow);
            Write('/    ↑    \');
            TextBackground(black);
            Write(' │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│');
            TextBackground(blue);
            Write('│   ');
            TextColor(colores.casa[04].azul);
            Write(casilla.casa[04].azul);
            TextColor(white);
            Write('←●→');
            TextColor(colores.casa[02].azul);
            Write(casilla.casa[02].azul);
            TextColor(white);
            Write('   │');
            TextBackground(black);
            Write('│');
            textbackground(blue);
            TextColor(colores.campo[29].sec);
            Write(casilla.campo[29].sec);
            TextColor(colores.campo[29].pri);
            Write(casilla.campo[29].pri);
            textbackground(black);
            Write('│');
            TextBackground(blue);
            TextColor(colores.cfinal[04].azul.sec);
            Write(casilla.cfinal[04].azul.sec);
            TextColor(white);
            Write(' ');
            TextColor(colores.cfinal[04].azul.pri);
            Write(casilla.cfinal[04].azul.pri);
            TextColor(white);
            TextBackground(black);
            Write('│');
            textbackground(lightgray);
            TextColor(colores.campo[39].sec);
            Write(casilla.campo[39].sec);
            TextColor(colores.campo[39].pri);
            Write(casilla.campo[39].pri);
            textbackground(black);
            Write('│');
            TextBackground(yellow);
            Write('│   ');
            TextColor(colores.casa[04].amarillo);
            Write(casilla.casa[04].amarillo);
            TextColor(white);
            Write('←●→');
            TextColor(colores.casa[02].amarillo);
            Write(casilla.casa[02].amarillo);
            TextColor(white);
            Write('   │');
            TextBackground(black);
            Write('│');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│ ');
            TextBackground(blue);
            Write('\    ↓    /');
            TextBackground(black);
            Write(' ├──┼');
            TextBackground(blue);
            Write('───');
            TextBackground(black);
            Write('┼──┤ ');
            TextBackground(yellow);
            Write('\    ↓    /');
            TextBackground(black);
            Write(' │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│  ');
            TextBackground(blue);
            Write('\   ');
            TextColor(colores.casa[03].azul);
            Write(casilla.casa[03].azul);
            TextColor(white);
            Write('   /');
            TextBackground(black);
            Write('  │');
            TextColor(colores.campo[28].sec);
            Write(casilla.campo[28].sec);
            TextColor(colores.campo[28].pri);
            Write(casilla.campo[28].pri);
            Write('│');
            TextBackground(blue);
            TextColor(colores.cfinal[05].azul.sec);
            Write(casilla.cfinal[05].azul.sec);
            TextColor(white);
            Write(' ');
            TextColor(colores.cfinal[05].azul.pri);
            Write(casilla.cfinal[05].azul.pri);
            TextColor(white);
            TextBackground(black);
            Write('│');
            TextColor(colores.campo[40].sec);
            Write(casilla.campo[40].sec);
            TextColor(colores.campo[40].pri);
            Write(casilla.campo[40].pri);
            Write('│  ');
            TextBackground(yellow);
            Write('\   ');
            TextColor(colores.casa[03].amarillo);
            Write(casilla.casa[03].amarillo);
            TextColor(white);
            Write('   /');
            TextBackground(black);
            Write('  │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             ├──┼');
            TextBackground(blue);
            Write('───');
            TextBackground(black);
            Write('┼──┤             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             │');
            TextColor(colores.campo[27].sec);
            Write(casilla.campo[27].sec);
            TextColor(colores.campo[27].pri);
            Write(casilla.campo[27].pri);
            Write('│');
            TextBackground(blue);
            TextColor(colores.cfinal[06].azul.sec);
            Write(casilla.cfinal[06].azul.sec);
            TextColor(white);
            Write(' ');
            TextColor(colores.cfinal[06].azul.pri);
            Write(casilla.cfinal[06].azul.pri);
            TextColor(white);
            TextBackground(black);
            Write('│');                                  
            TextColor(colores.campo[41].sec);
            Write(casilla.campo[41].sec);
            TextColor(colores.campo[41].pri);
            Write(casilla.campo[41].pri);
            Write('│             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             ├──┼');
            TextBackground(blue);
            Write('───');
            TextBackground(black);
            Write('┼──┤             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             │');  
            TextColor(colores.campo[26].sec);
            Write(casilla.campo[26].sec);
            TextColor(colores.campo[26].pri);
            Write(casilla.campo[26].pri);
            Write('│');
            TextBackground(blue);
            TextColor(colores.cfinal[07].azul.sec);
            Write(casilla.cfinal[07].azul.sec);
            TextColor(white);
            Write(' ');
            TextColor(colores.cfinal[07].azul.pri);
            Write(casilla.cfinal[07].azul.pri);
            TextColor(white);
            TextBackground(black);
            Write('│');
     
            TextColor(colores.campo[42].sec);
            Write(casilla.campo[42].sec);
            TextColor(colores.campo[42].pri);
            Write(casilla.campo[42].pri);
            Write('│             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('├─┬─┬─┬─┬─┬─┬─┼──┼');
            TextBackground(blue);
            Write('───');
            TextBackground(black);
            Write('┼──┼─┬─┬─┬─┬─┬─┬─┤');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│');
            TextColor(colores.campo[18].pri);
            Write(casilla.campo[18].pri);
            Write('│');
            TextColor(colores.campo[19].pri);
            Write(casilla.campo[19].pri);
            Write('│');
            TextColor(colores.campo[20].pri);
            Write(casilla.campo[20].pri);
            Write('│');
            TextColor(colores.campo[21].pri);
            Write(casilla.campo[21].pri);
            Write('│');
            TextBackground(lightgray);
            TextColor(colores.campo[22].pri);
            Write(casilla.campo[22].pri);
            TextBackground(black);
            Write('│');
            TextColor(colores.campo[23].pri);
            Write(casilla.campo[23].pri);
            Write('│');
            TextColor(colores.campo[24].pri);
            Write(casilla.campo[24].pri);
            Write('│');
            TextColor(colores.campo[25].pri);
            Write(casilla.campo[25].pri);
            Write('┌┤');
            TextBackground(blue);
            TextColor(colores.meta[04].azul);
            Write(casilla.meta[04].azul);
            TextColor(white);
            Write(' ');
            TextColor(colores.meta[03].azul);
            Write(casilla.meta[03].azul);
            TextColor(white);
            TextBackground(black);
            Write('├┐');
            TextColor(colores.campo[43].sec);
            Write(casilla.campo[43].sec);
            Write('│');
            TextColor(colores.campo[44].sec);
            Write(casilla.campo[44].sec);
            Write('│');
            TextColor(colores.campo[45].sec);
            Write(casilla.campo[45].sec);
            Write('│');
            TextBackground(yellow);
            TextColor(colores.campo[46].sec);
            Write(casilla.campo[46].sec);
            TextBackground(black);
            Write('│');
            TextColor(colores.campo[47].sec);
            Write(casilla.campo[47].sec);
            Write('│');
            TextColor(colores.campo[48].sec);
            Write(casilla.campo[48].sec);
            Write('│');
            TextColor(colores.campo[49].sec);
            Write(casilla.campo[49].sec);
            Write('│');
            TextColor(colores.campo[50].sec);
            Write(casilla.campo[50].sec);
            Write('│');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│');
            TextColor(colores.campo[18].sec);
            Write(casilla.campo[18].sec);
            Write('│');
            TextColor(colores.campo[19].sec);
            Write(casilla.campo[19].sec);
            Write('│');
            TextColor(colores.campo[20].sec);
            Write(casilla.campo[20].sec);
            Write('│');
            TextColor(colores.campo[21].sec);
            Write(casilla.campo[21].sec);
            Write('│');
            TextBackground(lightgray);
            TextColor(colores.campo[22].sec);
            Write(casilla.campo[22].sec);
            TextBackground(black);
            Write('│');
            TextColor(colores.campo[23].sec);
            Write(casilla.campo[23].sec);
            Write('│');
            TextColor(colores.campo[24].sec);
            Write(casilla.campo[24].sec);
            Write('│');
            TextColor(colores.campo[25].sec);
            Write(casilla.campo[25].sec);
            Write('│└┐');
            TextBackground(blue);
            TextColor(colores.meta[02].verde);
            Write(casilla.meta[02].verde);
            TextColor(white);
            TextBackground(black);
            Write('┌┘│');
            TextColor(colores.campo[43].pri);
            Write(casilla.campo[43].pri);
            Write('│');
            TextColor(colores.campo[44].pri);
            Write(casilla.campo[44].pri);
            Write('│');
            TextColor(colores.campo[45].pri);
            Write(casilla.campo[45].pri);
            Write('│');
            TextBackground(yellow);
            TextColor(colores.campo[46].pri);
            Write(casilla.campo[46].pri);
            TextBackground(black);
            Write('│');
            TextColor(colores.campo[47].pri);
            Write(casilla.campo[47].pri);
            Write('│');
            TextColor(colores.campo[48].pri);
            Write(casilla.campo[48].pri);
            Write('│');
            TextColor(colores.campo[49].pri);
            Write(casilla.campo[49].pri);
            Write('│');
            TextColor(colores.campo[50].pri);
            Write(casilla.campo[50].pri);
            Write('│');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('├─┼─┼─┼─┼─┼─┼─┼─┤');
            TextBackground(red);
            TextColor(colores.meta[04].rojo);
            Write(casilla.meta[04].rojo);
            TextBackground(black);
            TextColor(white);
            Write('│');
            TextBackground(blue);
            TextColor(colores.meta[01].azul);
            Write(casilla.meta[01].azul);
            TextColor(white);
            TextBackground(black);
            Write('│');
            TextBackground(yellow);
            TextColor(colores.meta[04].amarillo);
            Write(casilla.meta[04].amarillo);
            TextBackground(black);
            TextColor(white);
            Write('├─┼─┼─┼─┼─┼─┼─┼─┤');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│');
            TextBackground(lightgray);
            TextColor(colores.campo[17].pri);
            Write(casilla.campo[17].pri);
            TextBackground(black);
            Write('│');
            TextBackground(red);
            TextColor(colores.cfinal[01].rojo.pri);
            Write(casilla.cfinal[01].rojo.pri);
            TextColor(white);
            Write('│');
            TextColor(colores.cfinal[02].rojo.pri);
            Write(casilla.cfinal[02].rojo.pri);
            TextColor(white);
            Write('│');
            TextColor(colores.cfinal[03].rojo.pri);
            Write(casilla.cfinal[03].rojo.pri);
            TextColor(white);
            Write('│');
            TextColor(colores.cfinal[04].rojo.pri);
            Write(casilla.cfinal[04].rojo.pri);
            TextColor(white);
            Write('│');
            TextColor(colores.cfinal[05].rojo.pri);
            Write(casilla.cfinal[05].rojo.pri);
            TextColor(white);
            Write('│');
            TextColor(colores.cfinal[06].rojo.pri);
            Write(casilla.cfinal[06].rojo.pri);
            TextColor(white);
            Write('│');
            TextColor(colores.cfinal[07].rojo.pri);
            Write(casilla.cfinal[07].rojo.pri);
            TextColor(white);
            Write('│');
            TextColor(colores.meta[03].rojo);
            Write(casilla.meta[03].rojo);
            TextBackground(black);
            TextColor(white);
            Write('└┬┘');
            TextBackground(yellow);
            TextColor(colores.meta[02].amarillo);
            Write(casilla.meta[02].amarillo);
            TextColor(white);
            Write('│');
            TextColor(colores.cfinal[07].amarillo.sec);
            Write(casilla.cfinal[07].amarillo.sec);
            TextColor(white);
            Write('│');
            TextColor(colores.cfinal[06].amarillo.sec);
            Write(casilla.cfinal[06].amarillo.sec);
            TextColor(white);
            Write('│');
            TextColor(colores.cfinal[05].amarillo.sec);
            Write(casilla.cfinal[05].amarillo.sec);
            TextColor(white);
            Write('│');
            TextColor(colores.cfinal[04].amarillo.sec);
            Write(casilla.cfinal[04].amarillo.sec);
            TextColor(white);
            Write('│');
            TextColor(colores.cfinal[03].amarillo.sec);
            Write(casilla.cfinal[03].amarillo.sec);
            TextColor(white);
            Write('│');
            TextColor(colores.cfinal[02].amarillo.sec);
            Write(casilla.cfinal[02].amarillo.sec);
            TextColor(white);
            Write('│');
            TextColor(colores.cfinal[01].amarillo.sec);
            Write(casilla.cfinal[01].amarillo.sec);
            TextBackground(black);
            TextColor(white);
            Write('│');
            TextBackground(lightgray);
            TextColor(colores.campo[51].sec);
            Write(casilla.campo[51].sec);
            TextBackground(black);
            Write('│');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│');
            TextBackground(white);
            TextColor(colores.campo[17].sec);
            Write(casilla.campo[17].sec);
            TextBackground(black);
            Write('│');
            TextBackground(red);
            TextColor(colores.cfinal[01].rojo.sec);
            Write(casilla.cfinal[01].rojo.sec);
            TextColor(white);
            Write('│');
            TextColor(colores.cfinal[02].rojo.sec);
            Write(casilla.cfinal[02].rojo.sec);
            TextColor(white);
            Write('│');
            TextColor(colores.cfinal[03].rojo.sec);
            Write(casilla.cfinal[03].rojo.sec);
            TextColor(white);
            Write('│');
            TextColor(colores.cfinal[04].rojo.sec);
            Write(casilla.cfinal[04].rojo.sec);
            TextColor(white);
            Write('│');
            TextColor(colores.cfinal[05].rojo.sec);
            Write(casilla.cfinal[05].rojo.sec);
            TextColor(white);
            Write('│');
            TextColor(colores.cfinal[06].rojo.sec);
            Write(casilla.cfinal[06].rojo.sec);
            TextColor(white);
            Write('│');
            TextColor(colores.cfinal[07].rojo.sec);
            Write(casilla.cfinal[07].rojo.sec);
            TextColor(white);
            Write('│');
            TextColor(colores.meta[02].rojo);
            Write(casilla.meta[02].rojo);
            TextBackground(black);
            TextColor(white);
            Write('┌┴┐');
            TextBackground(yellow);
            TextColor(colores.meta[02].amarillo);
            Write(casilla.meta[02].amarillo);
            TextColor(white);
            Write('│');
            TextColor(colores.cfinal[07].amarillo.pri);
            Write(casilla.cfinal[07].amarillo.pri);
            TextColor(white);
            Write('│');
            TextColor(colores.cfinal[06].amarillo.pri);
            Write(casilla.cfinal[06].amarillo.pri);
            TextColor(white);
            Write('│');
            TextColor(colores.cfinal[05].amarillo.pri);
            Write(casilla.cfinal[05].amarillo.pri);
            TextColor(white);
            Write('│');
            TextColor(colores.cfinal[04].amarillo.pri);
            Write(casilla.cfinal[04].amarillo.pri);
            TextColor(white);
            Write('│');
            TextColor(colores.cfinal[03].amarillo.pri);
            Write(casilla.cfinal[03].amarillo.pri);
            TextColor(white);
            Write('│');
            TextColor(colores.cfinal[02].amarillo.pri);
            Write(casilla.cfinal[02].amarillo.pri);
            TextColor(white);
            Write('│');
            TextColor(colores.cfinal[01].amarillo.pri);
            Write(casilla.cfinal[01].amarillo.pri);
            TextBackground(black);
            TextColor(white);
            Write('│');
            TextBackground(lightgray);
            TextColor(colores.campo[51].pri);
            Write(casilla.campo[51].pri);
            TextBackground(black);
            Write('│');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('├─┼─┼─┼─┼─┼─┼─┼─┤');
            TextBackground(red);
            TextColor(colores.meta[04].rojo);
            Write(casilla.meta[04].rojo);
            TextBackground(black);
            TextColor(white);
            Write('│');
            TextBackground(green);
            TextColor(colores.meta[01].verde);
            Write(casilla.meta[01].verde);
            TextColor(white);
            TextBackground(black);
            Write('│');
            TextBackground(yellow);
            TextColor(colores.meta[01].amarillo);
            Write(casilla.meta[01].amarillo);
            TextBackground(black);
            TextColor(white);
            Write('├─┼─┼─┼─┼─┼─┼─┼─┤');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│');
            TextColor(colores.campo[16].pri);
            Write(casilla.campo[16].pri);
            Write('│');
            TextColor(colores.campo[15].pri);
            Write(casilla.campo[15].pri);
            Write('│');
            TextColor(colores.campo[14].pri);
            Write(casilla.campo[14].pri);
            Write('│');
            TextColor(colores.campo[13].pri);
            Write(casilla.campo[13].pri);
            Write('│');
            TextBackground(red);
            TextColor(colores.campo[12].pri);
            Write(casilla.campo[12].pri);
            TextBackground(black);
            Write('│');
            TextColor(colores.campo[11].pri);
            Write(casilla.campo[11].pri);
            Write('│');
            TextColor(colores.campo[10].pri);
            Write(casilla.campo[10].pri);
            Write('│');
            TextColor(colores.campo[09].pri);
            Write(casilla.campo[09].pri);
            Write('│┌┘');
            TextBackground(green);
            TextColor(colores.meta[02].verde);
            Write(casilla.meta[02].verde);
            TextColor(white);
            TextBackground(black);
            Write('└┐│');
            TextColor(colores.campo[59].sec);
            Write(casilla.campo[59].sec);
            Write('│');
            TextColor(colores.campo[58].sec);
            Write(casilla.campo[58].sec);
            Write('│');
            TextColor(colores.campo[57].sec);
            Write(casilla.campo[57].sec);
            Write('│');
            TextBackground(lightgray);
            TextColor(colores.campo[56].sec);
            Write(casilla.campo[56].sec);
            TextBackground(black);
            Write('│');
            TextColor(colores.campo[55].sec);
            Write(casilla.campo[55].sec);
            Write('│');
            TextColor(colores.campo[54].sec);
            Write(casilla.campo[54].sec);
            Write('│');
            TextColor(colores.campo[53].sec);
            Write(casilla.campo[53].sec);
            Write('│');
            TextColor(colores.campo[52].sec);
            Write(casilla.campo[52].sec);
            Write('│');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│');
            TextColor(colores.campo[16].sec);
            Write(casilla.campo[16].sec);
            Write('│');
            TextColor(colores.campo[15].sec);
            Write(casilla.campo[15].sec);
            Write('│');
            TextColor(colores.campo[14].sec);
            Write(casilla.campo[14].sec);
            Write('│');
            TextColor(colores.campo[13].sec);
            Write(casilla.campo[13].sec);
            Write('│');
            TextBackground(red);
            TextColor(colores.campo[12].sec);
            Write(casilla.campo[12].sec);
            TextBackground(black);
            Write('│');
            TextColor(colores.campo[11].sec);
            Write(casilla.campo[11].sec);
            Write('│');
            TextColor(colores.campo[10].sec);
            Write(casilla.campo[10].sec);
            Write('│');
            TextColor(colores.campo[09].sec);
            Write(casilla.campo[09].sec);
            Write('└┤');
            TextBackground(green);
            TextColor(colores.meta[03].verde);
            Write(casilla.meta[03].verde);
            TextColor(white);
            Write(' ');
            TextColor(colores.meta[04].verde);
            Write(casilla.meta[04].verde);
            TextColor(white);
            TextBackground(black);
            Write('├┘');
            TextColor(colores.campo[59].pri);
            Write(casilla.campo[59].pri);
            Write('│');
            TextColor(colores.campo[58].pri);
            Write(casilla.campo[58].pri);
            Write('│');
            TextColor(colores.campo[57].pri);
            Write(casilla.campo[57].pri);
            Write('│'); TextBackground(lightgray);
            TextColor(colores.campo[56].pri);
            Write(casilla.campo[56].pri);
            TextBackground(black);
            Write('│');
            TextColor(colores.campo[55].pri);
            Write(casilla.campo[55].pri);
            Write('│');
            TextColor(colores.campo[54].pri);
            Write(casilla.campo[54].pri);
            Write('│');
            TextColor(colores.campo[53].pri);
            Write(casilla.campo[53].pri);
            Write('│');
            TextColor(colores.campo[52].pri);
            Write(casilla.campo[52].pri);
            Write('│');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('├─┴─┴─┴─┴─┴─┴─┼──┼');
            TextBackground(green);
            Write('───');
            TextBackground(black);
            Write('┼──┼─┴─┴─┴─┴─┴─┴─┤');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             │');
            TextColor(colores.campo[08].pri);
            Write(casilla.campo[08].pri);
            TextColor(colores.campo[08].sec);
            Write(casilla.campo[08].sec);
            Write('│');
            TextBackground(Green);
            TextColor(colores.cfinal[07].verde.pri);
            Write(casilla.cfinal[07].verde.pri);
            TextColor(white);
            Write(' ');
            TextColor(colores.cfinal[07].verde.sec);
            Write(casilla.cfinal[07].verde.sec);
            TextColor(white);
            TextBackground(black);
            Write('│');
            TextColor(colores.campo[60].pri);
            Write(casilla.campo[60].pri);
            TextColor(colores.campo[60].sec);
            Write(casilla.campo[60].sec);
            Write('│             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             ├──┼');
            TextBackground(green);
            Write('───');
            TextBackground(black);
            Write('┼──┤             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             │');
            TextColor(colores.campo[07].pri);
            Write(casilla.campo[07].pri);
            TextColor(colores.campo[07].sec);
            Write(casilla.campo[07].sec);
            Write('│');
            TextBackground(Green);
            TextColor(colores.cfinal[06].verde.pri);
            Write(casilla.cfinal[06].verde.pri);
            TextColor(white);
            Write(' ');
            TextColor(colores.cfinal[06].verde.sec);
            Write(casilla.cfinal[06].verde.sec);
            TextColor(white);
            TextBackground(black);
            Write('│');
            TextColor(colores.campo[61].pri);
            Write(casilla.campo[61].pri);
            TextColor(colores.campo[61].sec);
            Write(casilla.campo[61].sec);
            Write('│             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             ├──┼');
            TextBackground(green);
            Write('───');
            TextBackground(black);
            Write('┼──┤             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             │');
            TextColor(colores.campo[06].pri);
            Write(casilla.campo[06].pri);
            TextColor(colores.campo[06].sec);
            Write(casilla.campo[06].sec);
            Write('│');
            TextBackground(Green);
            TextColor(colores.cfinal[05].verde.pri);
            Write(casilla.cfinal[05].verde.pri);
            TextColor(white);
            Write(' ');
            TextColor(colores.cfinal[05].verde.sec);
            Write(casilla.cfinal[05].verde.sec);
            TextColor(white);
            TextBackground(black);
            Write('│');
            TextColor(colores.campo[62].pri);
            Write(casilla.campo[62].pri);
            TextColor(colores.campo[62].sec);
            Write(casilla.campo[62].sec);
            Write('│             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             ├──┼');
            TextBackground(green);
            Write('───');
            TextBackground(black);
            Write('┼──┤             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│  ');
            TextBackground(red);
            Write('/   ');
            TextColor(colores.casa[03].rojo);
            Write(casilla.casa[03].rojo);
            TextColor(white);
            Write('   \');
            TextBackground(black);
            Write('  │');
            TextBackground(lightgray);
            TextColor(colores.campo[05].pri);
            Write(casilla.campo[05].pri);
            TextColor(colores.campo[05].sec);
            Write(casilla.campo[05].sec);
            textbackground(black);
            Write('│');
            TextBackground(Green);
            TextColor(colores.cfinal[04].verde.pri);
            Write(casilla.cfinal[04].verde.pri);
            TextColor(white);
            Write(' ');
            TextColor(colores.cfinal[04].verde.sec);
            Write(casilla.cfinal[04].verde.sec);
            TextColor(white);
            TextBackground(black);
            Write('│');
            TextBackground(green);
            TextColor(colores.campo[63].pri);
            Write(casilla.campo[63].pri);
            TextColor(colores.campo[63].sec);
            Write(casilla.campo[63].sec);
            textbackground(black);
            Write('│  ');
            TextBackground(green);
            Write('/   ');
            TextColor(colores.casa[03].verde);
            Write(casilla.casa[03].verde);
            TextColor(white);
            Write('   \');
            TextBackground(black);
            Write('  │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│ ');
            TextBackground(red);
            Write('');
            TextBackground(red);
            Write('/    ↑    \');
            TextBackground(black);
            Write(' ├──┼');
            TextBackground(green);
            Write('───');
            TextBackground(black);
            Write('┼──┤ ');
            TextBackground(green);
            Write('/    ↑    \');
            TextBackground(black);
            Write(' │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│');
            TextBackground(red);
            Write('│   ');
            TextColor(colores.casa[02].rojo);
            Write(casilla.casa[02].rojo);
            TextColor(white);
            Write('←●→');
            TextColor(colores.casa[04].rojo);
            Write(casilla.casa[04].rojo);
            TextColor(white);
            Write('   │');
            TextBackground(black);
            Write('│');
            TextColor(colores.campo[04].pri);
            Write(casilla.campo[04].pri);
            TextColor(colores.campo[04].sec);
            Write(casilla.campo[04].sec);
            Write('│');
            TextBackground(Green);
            TextColor(colores.cfinal[03].verde.pri);
            Write(casilla.cfinal[03].verde.pri);
            TextColor(white);
            Write(' ');
            TextColor(colores.cfinal[03].verde.sec);
            Write(casilla.cfinal[03].verde.sec);
            TextColor(white);
            TextBackground(black);
            Write('│');
            TextColor(colores.campo[64].pri);
            Write(casilla.campo[64].pri);
            TextColor(colores.campo[64].sec);
            Write(casilla.campo[64].sec);
            Write('│');
            TextBackground(green);
            Write('│   ');
            TextColor(colores.casa[02].verde);
            Write(casilla.casa[02].verde);
            TextColor(white);
            Write('←●→');
            TextColor(colores.casa[04].verde);
            Write(casilla.casa[04].verde);
            TextColor(white);
            Write('   │');
            TextBackground(black);
            Write('│');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│ ');
            TextBackground(red);
            Write('\    ↓    /');
            TextBackground(black);
            Write(' ├──┼');
            TextBackground(green);
            Write('───');
            TextBackground(black);
            Write('┼──┤ ');
            TextBackground(green);
            Write('\    ↓    /');
            TextBackground(black);
            Write(' │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│  ');
            TextBackground(red);
            Write('\   ');
            TextColor(colores.casa[01].rojo);
            Write(casilla.casa[01].rojo);
            TextColor(white);
            Write('   /');
            TextBackground(black);
            Write('  │');
            TextColor(colores.campo[03].pri);
            Write(casilla.campo[03].pri);
            TextColor(colores.campo[03].sec);
            Write(casilla.campo[03].sec);
            Write('│');
            TextBackground(Green);
            TextColor(colores.cfinal[02].verde.pri);
            Write(casilla.cfinal[02].verde.pri);
            TextColor(white);
            Write(' ');
            TextColor(colores.cfinal[02].verde.sec);
            Write(casilla.cfinal[02].verde.sec);
            TextColor(white);
            TextBackground(black);
            Write('│');
            TextColor(colores.campo[65].pri);
            Write(casilla.campo[65].pri);
            TextColor(colores.campo[65].sec);
            Write(casilla.campo[65].sec);
            Write('│  ');
            TextBackground(green);
            Write('\   ');
            TextColor(colores.casa[01].verde);
            Write(casilla.casa[01].verde);
            TextColor(white);
            Write('   /');
            TextBackground(black);
            Write('  │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             ├──┼');
            TextBackground(green);
            Write('───');
            TextBackground(black);
            Write('┼──┤             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             │');
            TextColor(colores.campo[02].pri);
            Write(casilla.campo[02].pri);
            TextColor(colores.campo[02].sec);
            Write(casilla.campo[02].sec);
            Write('│');
            TextBackground(Green);
            TextColor(colores.cfinal[01].verde.pri);
            Write(casilla.cfinal[01].verde.pri);
            TextColor(white);
            Write(' ');
            TextColor(colores.cfinal[01].verde.sec);
            Write(casilla.cfinal[01].verde.sec);
            TextColor(white);
            TextBackground(black);
            Write('│');
            TextColor(colores.campo[66].pri);
            Write(casilla.campo[66].pri);
            TextColor(colores.campo[66].sec);
            Write(casilla.campo[66].sec);
            Write('│             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             ├──┼───┼──┤             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             │');
            TextColor(colores.campo[01].pri);
            Write(casilla.campo[01].pri);
            TextColor(colores.campo[01].sec);
            Write(casilla.campo[01].sec);
            Write('│');
            TextBackground(black);  
            TextBackground(lightgray);  
            TextColor(colores.campo[68].pri);
            Write(casilla.campo[68].pri);
            Write(' ');
            TextColor(colores.campo[68].sec);
            Write(casilla.campo[68].sec);
            TextBackground(black);  
            Write('│');
            TextColor(colores.campo[67].pri);
            Write(casilla.campo[67].pri);
            TextColor(colores.campo[67].sec);
            Write(casilla.campo[67].sec);
            Write('│             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('└─────────────┴──┴───┴──┴─────────────┘');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
     END;

    procedure configinicial(
      VAR jugadores  : Integer;
      VAR posiciones : tipoposiciones; // Almacena las posiciones de cada  casilla
      VAR historico  : informativo; //Informa al usuario lo sucedido en la partida.
      VAR Colorjug   : tColores; //Almacena el color que el jugador usará.
      VAR orden      : array of tColores;
      var turnoactual: tColores
            ); //Realiza las primeras configuraciones del juego
      VAR 
          maquinas   : array[0..2] of tColores; //npcs
          primero    : tColores;
      begin
           layoutcfg;
           jugadores:=CantidadJugadores(historico);
           Colorjug:=Colorjugador(historico);
           posinicial(posiciones);
           layoutmain;
           entablero(posiciones);
           titleanim(50,4,150,10);
           asignamaquinas(Colorjug,jugadores,maquinas);
           primero:=Defineprimero(historico,jugadores,maquinas,Colorjug);
           DefineOrden(orden,primero);
           imprimirtexto(historico);
           turnoactual:=primero;
           mturnoactual(turnoactual);
           cambiartexto(historico,Completaconespacios(40,'Iniciando partida...'));
           imprimirtexto(historico);
       end;

    procedure nexturn(
      var turnoactual : tColores; //establece el turno acutal
                orden : array of tColores //orden de jugadores
      ); //cambia el turno al siguiente de la derecha
     var k : byte;
     begin
        if ord(turnoactual)=3 then
            k:=0
        else
            k:=ord(turnoactual)+1;
        turnoactual:=orden[k];
     end;

    procedure sacarficha(
      var posiciones : tipoposiciones;
      );
    begin
      
    end;

    procedure turno(
      var historico  : informativo;
      var posiciones : tipoposiciones;
          Colorjug   : tColores;
          orden      : array of tColores;
      var turnoactual: tColores 
      ); //turno de juego
     var 
        dado   : array[0..1] of byte;
        opcion : byte; //opción a menú.
        disp   : array[0..3] of Shortint;
        doble  : boolean;
     begin
        mturnoactual(turnoactual);
        if turnoactual=Colorjug then
            repeat
                opcion:=menu(3,'¿Que desea hacer? :','Lanzar Dados','Guardar Partida',
                'Salir','');
                if opcion=3 then BEGIN;
                       opcion:=menu(2,'¿Esta seguro? :','Sí','No','','');
                       if opcion=1 then begin
                           pantallafinal(0,jugadores,posiciones,historico,
                            Colorjug,primero,orden,turnoactual);
                       end;
                end;
                if opcion=2 then BEGIN;
                       opcion:=menu(2,'¿Esta seguro? :','Sí','No','','');
                       if opcion=1 then begin
                           //guardarpartida
                           opcion:=2;
                   end;
                end;
            until opcion=1;
        repeat
        LanzarDados(dado);
        doble:=DadosDobles(dado);
        dadosmoviles(dado);
        cambiartexto(historico,Completaconespacios(40,ColorToStr(turnoactual)+
          'obtuvo '+IntToStr(dado[0])+' y '+IntToStr(dado[1])));
        imprimirtexto(historico);
        //sacarficha
        //comprobarmovimientos
        //moverficha
        until 

     end;
    
    procedure Start(
      var  jugadores  : Integer;
      var  posiciones : tipoposiciones; // Almacena las posiciones de cada  casilla
      var  historico  : informativo; //Informa al usuario lo sucedido en la partida.
      var  Colorjug   : tColores; //Almacena el color que el jugador usará.
      var  primero    : tColores;
      var  orden      : array of tColores;
      var  turnoactual: tColores
      );
     begin
       //intro
       configinicial(jugadores,posiciones,historico,Colorjug,orden,turnoactual);
       turno(historico,posiciones,Colorjug,orden,turnoactual);
     end;
 
    VAR
            jugadores  : Integer;
            posiciones : tipoposiciones; // Almacena las posiciones de cada  casilla
            historico  : informativo; //Informa al usuario lo sucedido en la partida.
            Colorjug   : tColores; //Almacena el color que el jugador usará.
            primero    : tColores;
            orden      : array[0..3] of tColores;
            turnoactual: tColores;
            x,y:integer;
     
              // Clrscr;
    BEGIN
     // start(jugadores,posiciones,historico,Colorjug,primero,orden,turnoactual);
      pantallafina(0,jugadores,posiciones,historico,Colorjug,primero,orden,turnoactual);
    END.