    (*
     * parchisusb.pas
     *
     * Descripción: Proyecto final del curso CI-2611 para el periodo Oct-Ene 
     * 13-14. Una adaptación del juego clásico Parchís.
     *
     * Autores: Emilio Blanco
     *        Nabil J. Márquez V.
     *
     * Última modificación: 28/01/2014
     *)
    PROGRAM parchisusb;
     
    USES
       crt;
    CONST
        ficharoja       = 12; // Color de fichas rojas
        fichaazul       = 9;  // Color de fichas azules
        fichaverde      = 10; // Color de fichas verdes
        fichaamarilla   = 14; // Color de fichas amarillas
        blanco          = 15; // Color blanco
        salidarojo      = 57; // Posicion de la casa roja 
        salidaverde     = 6;  // Posicion de la casa roja 
        salidaamarillo  = 23; // Posicion de la casa roja 
        salidaazul      = 40; // Posicion de la casa roja 
        pasillorojo     = 52; // Ultima casilla neutral antes del pasillo rojo
        pasilloverde    = 1;  // Ultima casilla neutral antes del pasillo azul
        pasilloamarillo = 18; // Ultima casilla neutral antes del pasillo amarillo
        pasilloazul     = 35; // Ultima casilla neutral antes del pasillo verde
        seguro1         = 13; // Casilla del primer seguro
        seguro2         = 48; // Casilla del segundo seguro
        seguro3         = 64; // Casilla del termer seguro
        seguro4         = 30; // Casilla del cuarto seguro
   
    TYPE
       tColores = (rojo, verde, amarillo, azul);
     
        simbolocampo = record // Utilizado para las casillas que no son casa,meta
            pri : String;     // o recta final que pueden tener una o dos fichas
            sec : String      // y almacena los simbolos de estas
       
        end;
     
        tiposimbolocolor = record // Almacena los simbolos en las casillas casas
            rojo     : String;    // y meta
            azul     : String;
            verde    : String;
            amarillo : String
        end;
     
       simbolocolormeta = record // Almacena los simbolos en las casillas de la
            rojo       : simbolocampo; // recta final de cada color
            azul       : simbolocampo;
            verde      : simbolocampo;
            amarillo   : simbolocampo
       end;
     
        tiposimbolo = record // Hace un registro de arreglos con los tipos anteriores.
            casa      : array[1..4]  of tiposimbolocolor; // Posiciones casa
            meta      : array[1..4]  of tiposimbolocolor; // Posiciones meta
            cfinal    : array[1..7]  of simbolocolormeta; // Posiciones recta final
            campo     : array[1..68] of simbolocampo      // Posiciones neutras
        end;
     
       tipocampocolor = record // Utilizado para las casillas que no son casa,meta
           pri : Byte;         // o recta final que pueden tener una o dos fichas
           sec : Byte          // y almacena los colores de estas
       end;
     
       tipoposcolor = record   // Almacena los colores en las casillas casa
           rojo     : Byte;    // y meta
           azul     : Byte;
           verde    : Byte;
           amarillo : Byte
       end;
     
       tipoposicionmeta = record // Almacena los colores en las casillas de la
            rojo     : tipocampocolor; // recta final de cada color
            azul     : tipocampocolor;
            verde    : tipocampocolor;
            amarillo : tipocampocolor
       end;
     
       tipoposiciones = record // Hace un registro de arreglos con los tipos anteriores.
            casa      : array[1..4]  of tipoposcolor;     // Posiciones casa
            meta      : array[1..4]  of tipoposcolor;     // Posiciones meta
            cfinal    : array[1..7]  of tipoposicionmeta; // Posiciones recta final
            campo     : array[1..68] of tipocampocolor    // Posiciones neutras
         
       end;

       informativo = record // Arreglo para almacenar lo que pasa en cada turno.
                primera   : String;
                segunda   : String;
                tercera   : String;
                cuarta    : String;
                quinta    : String
       end;

    procedure tableroajedrez(x,y,m,n : Integer); // Dibuja un tablero de ajedrez
     Var i,j : Integer; // Coordenadas variantes // de tamaño mxn empezando en
                        // para crear el tablero // las coordenadas x,y
     begin
         { Pre: x>0 /\ y>0 /\ m>0 /\ n>0 }
         for i:=1 to m do
             for j:=1 to n do begin
                 gotoxy((x+j),(y+i));
                 if ((x+j) mod 2=0) and ((y+i) mod 2=0) then begin
                     TextBackground(white);
                     Write(' ');
                     TextBackground(black);
                 end
                 else if ((x+j) mod 2=0) and ((y+i) mod 2<>0) then begin
                     TextBackground(black);
                     Write(' ');
                     TextBackground(black);
                 end
                 else if ((x+j) mod 2<>0) and ((y+i) mod 2=0) then begin
                     TextBackground(black);
                     Write(' ');
                     TextBackground(black);
                 end
                 else if ((x+j) mod 2<>0) and ((y+i) mod 2<>0) then begin
                     TextBackground(white);
                     Write(' ');
                     TextBackground(black);
                 end;
             end;
     { Post: Se dibuja un cuadro con patrón de ajedrez en las coordenadas x,y
             de tamaño mxn }
     end;

    procedure cuadro(x,y,m,n : Integer); // Dibuja 3 cuadros con bordes en x,y
     Var
        i,j : Integer; // Coordenadas variantes para crear el cuadro
     begin
         { Pre: x>0 /\ y>0 /\ m>0 /\ n>0 }
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
     { Post: Se dibuja un cuadro con bordes en las coordenadas x,y de tamaño mxn }
     end; 

    procedure cuadrosb(x,y,m,n,c : Integer); // Crea un cuadro de color c
     Var 
        i,j : Integer; // Coordenadas variantes para crear los cuadros sin bordes.
     begin
         { Pre: x>0 /\ y>0 /\ m>0 /\ n>0 /\ c=>0 /\ c<=15 }
         for i:=1 to m do
             for j:=1 to n do begin
                 textbackground(c);
                 gotoxy((x+j),(y+i));
                     writeln(' ');
             end;
     { Post: Se crea un cuadro de color c en las coordenadas x,y de tamano mxn }
     end;

    procedure titulo(x,y,sat : Integer); // Dibuja el titulo ParchisUsb
     var
         color : tipoposcolor; // Colores a usar
     begin
     { Pre: x>0 /\ y>0 }
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
         // letra P
         cuadrosb(x,y,7,4,color.rojo);
         cuadrosb(x+4,y,2,3,color.rojo);
         cuadrosb(x+4,y+3,2,3,color.rojo);
         cuadrosb(x+7,y+1,3,3,color.rojo);
         // letra A
         cuadrosb(x+12,y,7,4,color.azul);
         cuadrosb(x+16,y,2,6,color.azul);
         cuadrosb(x+16,y+3,2,3,color.azul);
         cuadrosb(x+19,y+1,6,3,color.azul);
         // letra R
         cuadrosb(x+24,y,7,4,color.verde);
         cuadrosb(x+28,y,2,3,color.verde);
         cuadrosb(x+28,y+3,2,3,color.verde);
         cuadrosb(x+31,y+1,3,3,color.verde);
         cuadrosb(x+29,y+5,1,3,color.verde);
         cuadrosb(x+30,y+6,1,3,color.verde);
         // letra C
         cuadrosb(x+36,y,7,4,color.amarillo);
         cuadrosb(x+40,y,2,6,color.amarillo);
         cuadrosb(x+40,y+5,2,6,color.amarillo);
         // letra H
         cuadrosb(x+48,y,7,4,color.rojo);
         cuadrosb(x+52,y+2,2,3,color.rojo);
         cuadrosb(x+55,y,7,3,color.rojo);
         // letra I
         cuadrosb(x+60,y,2,7,color.azul);
         cuadrosb(x+62,y,7,3,color.azul);
         cuadrosb(x+60,y+5,2,7,color.azul);
         // letra S
         cuadrosb(x+69,y,2,10,color.verde);
         cuadrosb(x+69,y+2,2,4,color.verde);
         cuadrosb(x+69,y+3,1,10,color.verde);
         cuadrosb(x+76,y+3,4,3,color.verde);
         cuadrosb(x+69,y+5,2,10,color.verde);
         // letra U
         cuadrosb(x+58,y+6,5,2,color.verde);
         cuadrosb(x+58,y+10,1,7,color.verde);
         cuadrosb(x+63,y+6,5,2,color.verde);
         // letra S
         cuadrosb(x+66,y+6,1,7,color.rojo);
         cuadrosb(x+66,y+6,3,2,color.rojo);
         cuadrosb(x+66,y+8,1,7,color.rojo);
         cuadrosb(x+71,y+8,3,2,color.rojo);
         cuadrosb(x+66,y+10,1,7,color.rojo);
         // letra B
         cuadrosb(x+75,y+6,1,6,color.azul);
         cuadrosb(x+80,y+7,1,2,color.azul);
         cuadrosb(x+75,y+6,5,2,color.azul);
         cuadrosb(x+75,y+6,3,2,color.azul);
         cuadrosb(x+75,y+8,1,6,color.azul);
         cuadrosb(x+80,y+9,1,2,color.azul);
         cuadrosb(x+75,y+10,1,6,color.azul);
     { Post: Se imprime en pantalla el título ParchisUsb }
     end;

    procedure tituloanim(x,y,del,long : Integer); // Anima el titulo
     var i : integer; // Variable de iteración
     begin
     { Pre: x>0 /\ y>0 /\ del>0 /\ long>0 }
       for i:=1 to long do begin
           titulo(x,y,0);
           delay(del);
           titulo(x,y,1);
           delay(del);
           textbackground(black);
       end;
     { Post: Se cambian los colores del titulo dados el tiempo de delay y la longitud }
     end;

    procedure intro(); // Introducción al juego
        Var
            linea       : array[0..32] of string; // Linea para "dibujar"
            x,y,j,i     : Integer; // Variables de coordenadas x,y para los dibujos
        Begin                      // y de iteración para ir dibujando en i,j
         { Pre: true }
            linea[00]
            :='                          *******                          ';
            linea[01]
            :='                      *****     *****                      ';
            linea[02]
            :='                   ****    *****    ****                   ';
            linea[03]
            :='               ***     ****** ******    ****               ';
            linea[04]
            :='           ****     *****    *    *****     ****           ';
            linea[05]
            :='        ***     ****     *********     ***      ***        ';
            linea[06]
            :='      **     ***      ****      *****      ***     **      ';
            linea[07]
            :='    ***   ***     ****     *****     ****     ***   **     ';
            linea[08]
            :='   **   **    ****      ****  *****      ****    **   **   ';
            linea[09]
            :='  **  **   ***      ****     *     ****      **    *   **  ';
            linea[10]
            :=' **  **   **    ****     *********     ****    **   **  ** ';
            linea[11]
            :=' *  **   *   ***     ****         ***      ***   *   **  * ';
            linea[12]
            :='**  **  *   **    ***     ******      ***    **   *   *  **';
            linea[13]
            :='*  **  **  *   ***     *****   *****     ***  **  **  **  *';
            linea[14]
            :='*  **  *  **  **   ****     ***     ****   **  **  *  **  *';
            linea[15]
            :='*  *   *  **  *  **      *********      **  *   *  *   *  *';
            linea[16]
            :='*  *   *  **  *  **  ****         ****  **  *   *  *   *  *';
            linea[17]
            :='*  *   *  **  *  **  *     *****     *  **  *   *  *   *  *';
            linea[18]
            :='   **  *  **  *  **  *  ***     **   *  **  *   *  *  **   ';
            linea[19]
            :='   ** **  **  *  **  *  **   *   *   *  **  *   *  ** **   ';
            linea[20]
            :='   ** **  **  *  **  *  **  ***  *   *  **  *  **  ** **   ';
            linea[21]
            :='    * **  **  *  **  *  **  ***  *   *  **  *  **  ** *    ';
            linea[22]
            :='      **  ** **  **  *  **  ***  *   *  **  ** **  **      ';
            linea[23]
            :='          ** **  **  *  **  ***  *   *  **  ** **          ';
            linea[24]
            :='             **  **  ** **  ***  *  **  **  **             ';
            linea[25]
            :='                                                           ';
            linea[26]
            :='                                                           ';
            linea[27]
            :='              **    **   ********   *******                ';
            linea[28]
            :='              **    **   **         **     **              ';
            linea[29]
            :='              **    **   ********   *******                ';
            linea[30]
            :='              **    **         **   **     **              ';
            linea[31]
            :='              **    **   **    **   **     **              ';
            linea[32]
            :='              ********   ********   *******                ';
            x:=20;
            y:=5;
            // Logo
            for i:=1 to 97 do begin
              for j:=0 to 26 do begin
                gotoxy(x+i,y+j);
                if linea[j][i]='*' then Begin
                    textbackground(white);
                    writeln(' ');
                    textbackground(black);
                end;
                delay(5);
              end;
            end;
            // USB
            for i:=1 to 97 do begin
              for j:=26 to 32 do begin
                gotoxy(x+i,y+j);
                if linea[j][i]='*' then Begin
                    textbackground(white);
                    writeln(' ');
                    textbackground(black);
                end;
                delay(2);
              end;
              delay(1);
            end;
            delay(30);                                        
            linea[00]
            :='                                                             ';
            linea[01]
            :='                                                             ';
            linea[02]
            :='                                                             ';
            linea[03]
            :='                                                             ';
            linea[04]
            :='                                                             ';
            linea[05]
            :='                                                             ';
            linea[06]
            :='                                                             ';
            linea[07]
            :='    ***** ***** ***** ***** ****  *****                      ';
            linea[08]
            :='    *     *   * *     *   * *   * *   *                      ';
            linea[09]
            :='    *     ***** ***   ***** *   * *   *                      ';
            linea[10]
            :='    *     * *   *     *   * *   * *   *                      ';
            linea[11]
            :='    ***** *  *  ***** *   * ****  *****                      ';
            linea[12]
            :='                                                             ';
            linea[13]
            :='           ***** ***** *****  **                             ';
            linea[14]
            :='           *   * *   * *   *  **                             ';
            linea[15]
            :='           ***** *   * *****                                 ';
            linea[16]
            :='           *     *   * * *    **                             ';
            linea[17]
            :='           *     ***** *   *  **                             ';
            linea[18]
            :='                                                             ';
            linea[19]
            :='                                                             ';
            linea[20]
            :='                                                             ';
            linea[21]
            :='       Emilio Blanco                                         ';
            linea[22]
            :='                                                             ';
            linea[23]
            :='                                                             ';
            linea[24]
            :='                                                             ';
            linea[25]
            :='                                                             ';
            linea[26]
            :='                                                             ';
            linea[27]
            :='                               Nabil J. Marquez              ';
            linea[28]
            :='                                                             ';
            linea[29]
            :='                                                             ';
            linea[30]
            :='                                                             ';
            linea[31]
            :='                                                             ';
            linea[32]:='                                                             ';
            x:=20;       
            y:=5;
            clrscr;
            // Creado
            for i:=1 to 97 do begin
              for j:=0 to 11 do begin
                gotoxy(x+i,y+j);
                if linea[j][i]='*' then Begin
                    textbackground(white);
                    writeln(' ');
                    textbackground(black);
                end;
                delay(5);
              end;
            end;
            // Por:
            for i:=1 to 97 do begin
              for j:=12 to 17 do begin
                gotoxy(x+i,y+j);
                if linea[j][i]='*' then Begin
                    textbackground(white);
                    writeln(' ');
                    textbackground(black);
                end;
                delay(5);
              end;
              delay(1);
            end;
            textcolor(White);
            // Nabil J. Márquez
            for i:=1 to 97 do begin
              for j:=18 to 22 do begin
                gotoxy(x+i,y+j);
                write(linea[j][i]);
                delay(1);
              end;
              delay(1);
            end;
            // Emilio Blanco
            for i:=1 to 97 do begin
              for j:=23 to 28 do begin
                gotoxy(x+i,y+j);
                write(linea[j][i]);
                delay(1);
              end;
              delay(1);
            end;
        { Post: Se imprime la pantalla de introducción al juego }
        End;

    procedure plantillaprincipal(); // Crea la plantilla para la pantalla de juego
         begin
         { Pre: true }
             tableroajedrez(1,1,45,140);
             cuadro(50,15,12,85);
             cuadro(50,32,12,40);
             cuadro(95,32,12,20);
             cuadro(70,28,3,40);
         { Post: Se imprime en pantalla el "fondo" del juego }
         end;

    procedure plantillaconfig(); // Crea la plantilla para la pantalla de configuración
         begin
         { Pre: true }
             tableroajedrez(1,1,45,140);
             tituloanim(30,3,150,1);
             cuadro(16,15,25,110);
         { Post: Se crea el "fondo" para la pantalla de configuración }
         end;

    function IntAStr (n : Longint) : String; // Convierte un entero en string 
       Var S : String; // String de salida
       begin
         { Pre: n>0 }
             Str (n,S);
             IntAStr:=S;
         { Post: IntAStr=S }
       end;

    function ColorAStr (color : tColores) : String; // Convierte un color en string
     begin
     { Pre: ( %exists i | i %in tColores : i ) }
        if color=rojo then
            ColorAStr:='rojo';
        if color=azul then
            ColorAStr:='azul';
        if color=verde then
            ColorAStr:='verde';
        if color=Amarillo then
            ColorAStr:='amarillo';
     { Post: (color=rojo => ColorAStr='rojo') /\ (color=azul => ColorAStr='azul')
             /\ (color=verde => ColorAStr='verde')
             /\ (color=Amarillo => ColorAStr='amarillo') }
     end;

    function Completaconespacios(
      n : integer; // Tamaño de salida
      S : string   // String de entrada
      ):String; // Concatena espacios hasta que S sea de tamaño n;
     var i : integer; // Variable de iteración
     begin
     { Pre: |S|>0 /\ n>=|S| }
       if Length(S)<n then
           for i:=Length(S) to n do
               S:=S+' '; 
       Completaconespacios:=S;
     { Post: |Completaconespacios|=n }
     end; 

    procedure asignamaquinas(
      Colorjug     : tColores;         // Color que eligió el jugador
      jugadores    : integer;          // Cantidad de jugadores
      var maquinas : array of tColores // Colores de las maquinas
      ); // Le asigna los colores restantes a las maquinas
      Var i : tColores; // Variable de iteración entre los colores
      var j : integer;  // Variable de iteración para las maquinas
     begin
     { Pre: ( %exists i | i %in tColores : i )=Colorjug /\ (jugadores=2 \/ jugadores=4)
            /\ ( %exists i | i %in tColores : i)=( %forall i | 0<=i<=2 : maquinas[i] ) }
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
     { Post: ( %exists i | i %in tColores /\ i<>Colorjug : i)=( %forall i | 0<=i<=2 : maquinas[i] ) }
     end;

    procedure imprimirtexto(
        historico  : informativo // Texto que informa lo que ha sucedido en la partida
       ); // Imprime en pantalla las lineas del historial
       BEGIN
       { Pre: true }
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
       { Post: Imprime en pantalla el historial de la partida }
       end;

    procedure cambiartexto(
        var historico  : informativo; // Texto que informa lo que ha sucedido en la partida
            nuevalinea : String       // Nueva linea a agregar
        ); // Hace un "scroll" del historial de la partida
        BEGIN
         { Pre: true }
           historico.primera:=historico.segunda;
           historico.segunda:=historico.tercera;
           historico.tercera:=historico.cuarta;
           historico.cuarta:=historico.quinta;
           historico.quinta:=nuevalinea;
         { Post: Cambia el orden de las lineas agregando una linea nueva y eliminando
                 la que se ha mostrado por más tiempo }
        end;

    procedure LanzarDados(
      var Dado  :  array of byte // Valor del dado 1 o 2
      ); // Lanza dos dados
        var x,y : integer; // Variables de iteración
        begin
       { Pre: true }
          for y:= 0 to 1 do BEGIN
              for x:= 1 to 15 do begin;
                  Dado[y]:=random(6)+1;
              end;
              delay(120);
          end;
       { Post: ( %exists i | 1<=i<=6 : ( %forall j | 0<=j<=1 : Dado[j] )=i ) }
        end;

    procedure dadosmoviles(
        dados : array of byte // Valor del dado 1 o 2
        ); // Imprime dos dados y hace una animación en la que "ruedan"
         var 
             dadoslocales : array[0..1] of byte;   // Dado a "rodar"
             linea        : array[0..1] of string; // Lineas para dibujar el dado
             dadoactual   : integer;               // Dado que está "rodando" en
                                                   // el momento
             i            : integer;               // Variable de iteración
        begin
         { Pre: true }
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
         delay(300);
         { Post: ( dadoactual=1 => linea[0]='|  ●  |' /\ linea[1]='|     |' )
                 /\ ( dadoactual=2 => linea[0]='|    ●|' /\ linea[1]='|●    |' )
                 /\ ( dadoactual=3 => linea[0]='|  ● ●|' /\ linea[1]='|  ●  |' )
                 /\ ( dadoactual=4 => linea[0]='|●   ●|' /\ linea[1]='|●   ●|' )
                 /\ ( dadoactual=5 => linea[0]='|● ● ●|' /\ linea[1]='|●   ●|' )
                 /\ ( dadoactual=6 => linea[0]='|● ● ●|' /\ linea[1]='|● ● ●|' ) }
        end;

    function SumaDados(
      var Dado  :  array of byte // Valores numéricos de cada dado
      ) : integer; // Suma ambos dados
        begin
        { Pre: true }
          SumaDados:=Dado[0]+Dado[1];
        { Post: SumaDados=Dado[0]+Dado[1] }
        end;

    function DadosDobles(
      var Dado : array of byte // Variables numéricas de cada dado
      ) : boolean; // Indica si el jugador sacó dobles
        begin
         { Pre: true }
          if (Dado[0]=Dado[1]) then
             DadosDobles:=true
          else
             DadosDobles:=false;
         { Post: ( Dado[0]=Dado[1] => DadosDobles==true )
                 /\ ( Dado[0]<>Dado[1] => Dadosdobles==false ) }
        end;

    procedure GuardarPartida(
      jugadores         : integer;           // Cantidad de jugadores
      Colorjug          : tColores;          // Color del jugador
      orden             : Array of tColores; // Orden en que se juega
      posiciones        : tipoposiciones     // Posiciones de las fichas
       ); // Procedimiento para guardar la partida
     VAR
         archivo       : text;    // Archivo para el guardado
         x             : integer; // Variable de iteración
         codigo        : word;    // Codigo de error
     begin
     { Pre: ( jugadores=2 \/ jugadores=4 ) }
         assign(archivo,'parchisusb.sav');
         {$IOCHECKS OFF}
         rewrite(archivo);
         codigo := ioResult;
         if codigo<>0 then begin
             clrscr;
             Writeln('Hubo un error (',codigo:4,') al crear el archivo.' 
                     ,'Intente nuevamente luego de solucionar el problema.'); 
             halt;
         end;
         writeln(archivo,jugadores);
         codigo := ioResult;
         if codigo<>0 then begin
             clrscr;
             Writeln('Hubo un error (',codigo:4,') al escribir en el archivo.' 
                      ,'Intente nuevamente luego de solucionar el problema.'); 
             halt;
         end;
         writeln(archivo,Colorjug);
         codigo := ioResult;
         if codigo<>0 then begin
             clrscr;
             Writeln('Hubo un error (',codigo:4,') al escribir en el archivo.' 
                      ,'Intente nuevamente luego de solucionar el problema.'); 
             halt;
         end;
         for x:=1 to 4 do begin // Escribe los valores de las casas
              writeln(archivo,orden[x]);
              codigo := ioResult; 
              if codigo<>0 then begin
                 clrscr;
                 Writeln('Hubo un error (',codigo:4,') al escribir en el archivo.' 
                         ,'Intente nuevamente luego de solucionar el problema.'); 
                 halt;
              end;
         end;
         for x:=1 to 68 do begin // Escribe los valores de las casillas neutras
              writeln(archivo,posiciones.campo[x].pri); // en la posición primaria
              codigo := ioResult; 
              if codigo<>0 then begin
                 clrscr;
                 Writeln('Hubo un error (',codigo:4,') al escribir en el archivo.' 
                         ,'Intente nuevamente luego de solucionar el problema.'); 
                 halt;
              end;
         end;
         for x:=1 to 68 do begin // Escribe los valores de las casillas neutras
              writeln(archivo,posiciones.campo[x].sec); // en la posición secundaria
              codigo := ioResult; 
              if codigo<>0 then begin
                 clrscr;
                 Writeln('Hubo un error (',codigo:4,') al escribir en el archivo.' 
                         ,'Intente nuevamente luego de solucionar el problema.'); 
                 halt;
              end;
         end;
         for x:=1 to 7 do begin // Escribe los valores de los pasillos
              writeln(archivo,posiciones.cfinal[x].rojo.pri);
              writeln(archivo,posiciones.cfinal[x].rojo.sec);
              writeln(archivo,posiciones.cfinal[x].azul.pri);
              writeln(archivo,posiciones.cfinal[x].azul.sec);
              writeln(archivo,posiciones.cfinal[x].verde.pri);
              writeln(archivo,posiciones.cfinal[x].verde.sec);
              writeln(archivo,posiciones.cfinal[x].amarillo.pri);
              writeln(archivo,posiciones.cfinal[x].amarillo.sec);
              codigo := ioResult; 
              if codigo<>0 then begin
                 clrscr;
                 Writeln('Hubo un error (',codigo:4,') al escribir en el archivo.' 
                         ,'Intente nuevamente luego de solucionar el problema.'); 
                 halt;
              end;
         end;
         for x:=1 to 4 do begin // Escribe los valores de las casas
              writeln(archivo,posiciones.casa[x].rojo);
              writeln(archivo,posiciones.casa[x].azul);
              writeln(archivo,posiciones.casa[x].verde);
              writeln(archivo,posiciones.casa[x].amarillo);
              writeln(archivo,posiciones.meta[x].rojo);
              writeln(archivo,posiciones.meta[x].azul);
              writeln(archivo,posiciones.meta[x].verde);
              writeln(archivo,posiciones.meta[x].amarillo);
              codigo := ioResult; 
              if codigo<>0 then begin
                 clrscr;
                 Writeln('Hubo un error (',codigo:4,') al escribir en el archivo.' 
                        ,'Intente nuevamente luego de solucionar el problema.'); 
                 halt;
              end;
         end;
         close(archivo);
         {$IOCHECKS ON}
         if codigo<>0 then begin
            clrscr;
            Writeln('Hubo un error (',codigo:4,') al guardar el archivo.' 
                    ,'Intente nuevamente luego de solucionar el problema.'); 
            halt;
         end;
     { Post: Se guarda en un archivo de texto, las posiciones de las fichas,
             cantidad de jugadores, color del jugador, color de las máquinas y
             el orden en que se juega }
     end;
 
    procedure CargarPartida(
      var jugadores         : integer;           // Cantidad de jugadores
      var Colorjug          : tColores;          // Color del jugador
      var orden             : Array of tColores; // Orden en que se juega
      var posiciones        : tipoposiciones     // Posiciones de las fichas
       ); // Procedimiento para cargar la partida
     VAR
         archivo       : text;    // Archivo para el guardado
         x             : integer; // Variable de iteración
         codigo        : word;    // Codigo de error
     begin
     { Pre: true }
        assign(archivo,'parchisusb.sav');
        {$IOCHECKS OFF}
        reset(archivo);
        codigo := ioResult; 
         if codigo<>0 then begin
             clrscr;
             Writeln('Hubo un error (',codigo:4,') al abrir el archivo.' 
                     ,'Intente nuevamente luego de solucionar el problema.'); 
             halt;
         end;
         readln(archivo,jugadores);
         codigo := ioResult;
         if codigo<>0 then begin
             clrscr;
             Writeln('Hubo un error (',codigo:4,') al leer en el archivo.' 
                      ,'Intente nuevamente luego de solucionar el problema.'); 
             halt;
         end;
         readln(archivo,Colorjug);
         codigo := ioResult;
         if codigo<>0 then begin
             clrscr;
             Writeln('Hubo un error (',codigo:4,') al leer en el archivo.' 
                      ,'Intente nuevamente luego de solucionar el problema.'); 
             halt;
         end;
         for x:=1 to 4 do begin  //escribiendo los valores de las casas
              readln(archivo,orden[x]);
              codigo := ioResult; 
              if codigo<>0 then begin
                 clrscr;
                 Writeln('Hubo un error (',codigo:4,') al leer en el archivo.' 
                         ,'Intente nuevamente luego de solucionar el problema.'); 
                 halt;
              end;
         end;
         for x:=1 to 68 do begin  //escribiendo los valores de las casillas neutras
              readln(archivo,posiciones.campo[x].pri);
              codigo := ioResult; 
              if codigo<>0 then begin
                 clrscr;
                 Writeln('Hubo un error (',codigo:4,') al leer en el archivo.' 
                         ,'Intente nuevamente luego de solucionar el problema.'); 
                 halt;
              end;
         end;
         for x:=1 to 68 do begin  //escribiendo los valores de las casillas neutras
              readln(archivo,posiciones.campo[x].sec);
              codigo := ioResult; 
              if codigo<>0 then begin
                 clrscr;
                 Writeln('Hubo un error (',codigo:4,') al leer en el archivo.' 
                         ,'Intente nuevamente luego de solucionar el problema.'); 
                 halt;
              end;
         end;
         for x:=1 to 7 do begin         //escribiendo los valores de los pasillos
              readln(archivo,posiciones.cfinal[x].rojo.pri);
              readln(archivo,posiciones.cfinal[x].rojo.sec);
              readln(archivo,posiciones.cfinal[x].azul.pri);
              readln(archivo,posiciones.cfinal[x].azul.sec);
              readln(archivo,posiciones.cfinal[x].verde.pri);
              readln(archivo,posiciones.cfinal[x].verde.sec);
              readln(archivo,posiciones.cfinal[x].amarillo.pri);
              readln(archivo,posiciones.cfinal[x].amarillo.sec);
              codigo := ioResult; 
              if codigo<>0 then begin
                 clrscr;
                 Writeln('Hubo un error (',codigo:4,') al leer en el archivo.' 
                         ,'Intente nuevamente luego de solucionar el problema.'); 
                 halt;
              end;
         end;
         for x:=1 to 4 do begin  //escribiendo los valores de las casas
              readln(archivo,posiciones.casa[x].rojo);
              readln(archivo,posiciones.casa[x].azul);
              readln(archivo,posiciones.casa[x].verde);
              readln(archivo,posiciones.casa[x].amarillo);
              readln(archivo,posiciones.meta[x].rojo);
              readln(archivo,posiciones.meta[x].azul);
              readln(archivo,posiciones.meta[x].verde);
              readln(archivo,posiciones.meta[x].amarillo);
              codigo := ioResult; 
              if codigo<>0 then begin
                 clrscr;
                 Writeln('Hubo un error (',codigo:4,') al leer en el archivo.' 
                         ,'Intente nuevamente luego de solucionar el problema.'); 
                 halt;
              end;
         end;
         close(archivo);
         {$IOCHECKS ON}
         if codigo<>0 then begin
            clrscr;
            Writeln('Hubo un error (',codigo:4,') al guardar el archivo.' 
                    ,'Intente nuevamente luego de solucionar el problema.'); 
            halt;
         end;
     { Post: ( jugadores=2 \/ jugadores=4 ) /\ ( %exists i | i %in tColores : i )=Colorjug
            /\ ( jugadores=4 => orden[0]<>orden[1]<>orden[2]<>orden[3] )
            /\ ( jugadores=2 => orden[0]<>orden[1] )
            /\ ( %forall i | 1<=i<=68 : posiciones.campo[i].pri )=(% exists i | 0<=i<=4 : i )
            /\ ( %forall i | 1<=i<=68 : posiciones.campo[i].sec )=(% exists i | 0<=i<=4 : i )
            /\ ( %forall i | 1<=i<=7 : posiciones.cfinal[i].rojo.pri )=(% exists i | 0<=i<=4 : i )
            /\ ( %forall i | 1<=i<=7 : posiciones.cfinal[i].rojo.sec )=(% exists i | 0<=i<=4 : i )
            /\ ( %forall i | 1<=i<=7 : posiciones.cfinal[i].azul.pri )=(% exists i | 0<=i<=4 : i )
            /\ ( %forall i | 1<=i<=7 : posiciones.cfinal[i].azul.sec )=(% exists i | 0<=i<=4 : i )
            /\ ( %forall i | 1<=i<=7 : posiciones.cfinal[i].verde.pri )=(% exists i | 0<=i<=4 : i )
            /\ ( %forall i | 1<=i<=7 : posiciones.cfinal[i].verde.sec )=(% exists i | 0<=i<=4 : i )
            /\ ( %forall i | 1<=i<=7 : posiciones.cfinal[i].amarillo.pri )=(% exists i | 0<=i<=4 : i )
            /\ ( %forall i | 1<=i<=7 : posiciones.cfinal[i].amarillo.sec )=(% exists i | 0<=i<=4 : i )
            /\ ( %forall i | 1<=i<=4 : posiciones.casa[i].rojo )=(% exists i | 0<=i<=4 : i )
            /\ ( %forall i | 1<=i<=4 : posiciones.casa[i].azul )=(% exists i | 0<=i<=4 : i )
            /\ ( %forall i | 1<=i<=4 : posiciones.casa[i].verde )=(% exists i | 0<=i<=4 : i )
            /\ ( %forall i | 1<=i<=4 : posiciones.casa[i].amarillo )=(% exists i | 0<=i<=4 : i )
            /\ ( %forall i | 1<=i<=4 : posiciones.meta[i].rojo )=(% exists i | 0<=i<=4 : i )
            /\ ( %forall i | 1<=i<=4 : posiciones.meta[i].azul )=(% exists i | 0<=i<=4 : i )
            /\ ( %forall i | 1<=i<=4 : posiciones.meta[i].verde )=(% exists i | 0<=i<=4 : i )
            /\ ( %forall i | 1<=i<=4 : posiciones.meta[i].amarillo )=(% exists i | 0<=i<=4 : i ) }
     end;

    procedure pantallafinal; // Cierra el juego
         begin
             { Pre: true }
             tableroajedrez(1,1,45,140);
             tituloanim(30,3,150,3);
             cuadro(16,15,25,110);
             gotoxy(20,18);
             Writeln('    »   Gracias por jugar Parchis-USB');
             gotoxy(1,49);
             halt;
             { Post: Se imprime en pantalla un diálogo con "fondo" y se sale del juego }
         end;

    procedure pantallavictoria(
      turnoactual : tColores // Color del turno actual
      ); // Animación que muestra quién ganó
         VAR
             ch : char; // Variable para la tecla a presionar
         begin
         { Pre: true }
             tableroajedrez(1,1,45,140);
             tituloanim(30,3,150,1);
             cuadro(16,15,25,110);
             gotoxy(20,18);
             textcolor(white);
             Write('                ¡Ah ganado el jugador: ');
             if turnoactual=rojo then
                 textcolor(4);
             if turnoactual=azul then
                 textcolor(1);  
             if turnoactual=amarillo then
                 textcolor(14);  
             if turnoactual=verde then
                 textcolor(2);  
             write(ColorAStr(turnoactual));
             textcolor(white);
             writeln('!, ¡Felicidades!');
             gotoxy(1,49);
             delay(3500);
             gotoxy(20,30);
             Write('             Presione "Enter" para salir.');
             repeat
                 ch:=ReadKey;
             until ch=#13;
             pantallafinal;
         { Post: Se da un mensaje de felicitación al jugador ganador y permanece
                 ahí hasta que el usuario presiona enter }
         end;

    function Menu(
      x,y     : integer; // Coordenadas en x,y para el menu
      cant    : integer; // Cantidad de opciones posibles
      mensaje : string;  // Mensaje de salida
      opcion1 : string;  // Primera opción del menu
      opcion2 : string;  // Segunda opción del menu
      opcion3 : string;  // Tercera opción del menu
      opcion4 : string   // Cuarta opción del menu
      ) : integer; // Función para los menus
        var
            ch   : char;    // Variable para la tecla a presionar
            k    : integer; // Variable de iteración
            list : string;  // Variable para enlistar las opciones
        begin
         { Pre: x>0 /\ y>0 /\ cant>0 /\ cant<=4}
           if opcion1='' then
               list:=''
           else
               list:='» ';
           opcion1:=list+Completaconespacios(15,opcion1);
           if opcion2='' then
               list:=''
           else
               list:='» ';
           opcion2:=list+Completaconespacios(15,opcion2);
           if opcion3='' then
               list:=''
           else
               list:='» ';
           opcion3:=list+Completaconespacios(15,opcion3);
           if opcion4='' then
               list:=''
           else
               list:='» ';
           opcion4:=list+Completaconespacios(15,opcion4);
           k:=1;
           repeat
                Textcolor(White);
                gotoxy(x,y);
                Write(Completaconespacios(15,Completaconespacios(20,mensaje)));
               if (k=1) then begin
                   gotoxy(x,y+1);
                   Textcolor(white);
                   TextBackground(cyan);
                   write(opcion1);
                   gotoxy(x,y+2);
                   Textcolor(white);
                   TextBackground(black);
                   write(opcion2);
                   gotoxy(x,y+3);
                   Textcolor(white);
                   TextBackground(black);
                   write(opcion3);
                   gotoxy(x,y+4);
                   Textcolor(white);
                   TextBackground(black);
                   write(opcion4);
                   menu:=1;
               end;
               if (k=2) then begin
                   gotoxy(x,y+1);
                   Textcolor(white);
                   TextBackground(black);
                   write(opcion1);
                   gotoxy(x,y+2);
                   Textcolor(white);
                   TextBackground(cyan);
                   write(opcion2);
                   gotoxy(x,y+3);
                   Textcolor(white);
                   TextBackground(black);
                   write(opcion3);
                   gotoxy(x,y+4);
                   Textcolor(white);
                   TextBackground(black);
                   write(opcion4);
                   menu:=2;
               end;
               if (k=3) then begin
                   gotoxy(x,y+1);
                   Textcolor(white);
                   TextBackground(black);
                   write(opcion1);
                   gotoxy(x,y+2);
                   Textcolor(white);
                   TextBackground(black);
                   write(opcion2);
                   gotoxy(x,y+3);
                   Textcolor(white);
                   TextBackground(cyan);
                   write(opcion3);
                   gotoxy(x,y+4);
                   Textcolor(white);
                   TextBackground(black);
                   write(opcion4);
                   menu:=3;
               end;
               if (k=4) then begin
                   gotoxy(x,y+1);
                   Textcolor(white);
                   TextBackground(black);
                   write(opcion1);
                   gotoxy(x,y+2);
                   Textcolor(white);
                   TextBackground(black);
                   write(opcion2);
                   gotoxy(x,y+3);
                   Textcolor(white);
                   TextBackground(white);
                   write(opcion3);
                   gotoxy(x,y+4);
                   Textcolor(white);
                   TextBackground(cyan);
                   write(opcion4);
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
     { Post: Se crea un menú  en las coordenadas x,y con las opciones opcion1,
             opcion2, opcion3, hasta opcion4 dependiendo del número de opciones
             de entrada (cant) }
     end;

    procedure mturnoactual(
      color : tColores // Color del turno actual
      ); // Muestra el de quién es el turno
      var nColor : byte; // Color en byte
      begin
      { Pre: ( %exists i | i %in tColores : i )=color }
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
        write(Completaconespacios(15,ColorAStr(color)));
        textcolor(white);
      { Post: ( color=rojo => ncolor=4 ) /\ ( color=azul => ncolor=1 )
              /\ ( color=verde => ncolor=2 ) /\ ( color=amarillo => ncolor=14 ) }
     end;
     
    procedure menuinicial(
      var historico : informativo; // Texto que informa lo que ha sucedido en la partida
      var jug : array of integer;  // Suma de los dados para los jugadores
      Colorjug : tColores          // Color del jugador
      ) ; // Menu utilizado al inicio del juego
        var
            dado      : array[0..1] of byte; // Dados
            opcion    : integer;             // Opción del menú
       BEGIN
       { Pre: true }
           opcion:=menu(55,35,2,'¿Que desea hacer? :','Lanzar Dados.','Salir.','','');
               if opcion=2 then BEGIN;
                   opcion:=menu(55,35,2,'¿Esta seguro? :','Sí','No','','');
                   if opcion=1 then begin
                       pantallafinal;
                       opcion:=1;
                   end;
               end;
               if opcion=1 then begin
          LanzarDados(dado);
          mturnoactual(Colorjug);
          dadosmoviles(dado);
          imprimirtexto(historico);
          cambiartexto(historico,Completaconespacios(40,ColorAStr(Colorjug)
             +' obtuvo:'+IntAStr(dado[0])+' y '+IntAStr(dado[1])));
          jug[3]:=SumaDados(dado);
          imprimirtexto(historico);
        end;
       { Post: Se crea un menú que se imprime en pantalla para que el jugador escoja
               entre las opciones }
       end;

    function Defineprimero(
      var historico  : informativo;   // Texto que informa lo que ha sucedido en
                                      // la partida
      jugadores  : integer;           // Cantidad de jugadores
      maquinas   : array of tColores; // Colores de las máquinas
      Colorjug   : tColores           // Color del jugador
      )  :  tColores; // Funcion para definir quien es el primer jugador
        var
            jug       : array[0..3] of integer; // Jugador
            dado      : array[0..1] of byte;    // Dado
            i         : byte;    // Variable de iteración
            j         : byte;    // Variable de iteración
            tryagain  : boolean; // Variable para indicar si se debe correr la
                                 // función de nuevo
            max       : integer; // Almacena el valor máximo lanzado
        begin
         { Pre: ( %exists i | i %in tColores : i )=primero /\ ( jugadores=2 \/ jugadores=4 )
            /\ ( jugadores=4 => orden[0]<>orden[1]<>orden[2]<>orden[3] )
            /\ ( jugadores=2 => orden[0]<>orden[1] ) }
          menuinicial(historico,jug,Colorjug);
          imprimirtexto(historico);gotoxy(1,48);
          if jugadores=2 then begin
              mturnoactual(maquinas[0]);
              LanzarDados(dado);
              dadosmoviles(dado);
              cambiartexto(historico,Completaconespacios(40,ColorAStr(maquinas[0])
                +' obtuvo:'+IntAStr(dado[0])+' y '+IntAStr(dado[1])));
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
                  cambiartexto(historico,Completaconespacios(40,ColorAStr(maquinas[i])
                    +' obtuvo:'+IntAStr(dado[0])+' y '+IntAStr(dado[1])));
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
                'El primer jugador es: '+ColorAStr(Defineprimero)));
              imprimirtexto(historico);
          end;
         { Post: Defineprimero=( %exists i | 0<=i<=3 : ( %forall j | 0<=j<=3 /\ j<>i : jug[i]>jug[j] ) ) }
        end;
     
    procedure DefineOrden(
      var orden : array of tColores; // Orden de los colores
      primero   : tColores;          // Color del primer jugador
      jugadores : integer            // Cantidad de jugadores
      ); // Procedimiento para establecer el orden de los turnos
     begin
     { Pre: ( %exists i | i %in tColores : i )=primero /\ ( jugadores=2 \/ jugadores=4 )
            /\ ( jugadores=4 => orden[0]<>orden[1]<>orden[2]<>orden[3] )
            /\ ( jugadores=2 => orden[0]<>orden[1] ) }
     if jugadores=4 then begin
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
            orden[2]:=verde;
            orden[3]:=amarillo;
         end;
     end
     else begin
         if primero=rojo then begin
            orden[0]:=rojo;
            orden[1]:=amarillo;
            orden[2]:=rojo;
            orden[3]:=amarillo;
         end;
         if primero=azul then begin
            orden[0]:=azul;
            orden[1]:=verde;
            orden[2]:=azul;
            orden[3]:=verde;
         end;
         if primero=amarillo then begin
            orden[0]:=amarillo;
            orden[1]:=rojo;
            orden[2]:=amarillo;
            orden[3]:=rojo;
         end;
         if primero=verde then begin
            orden[0]:=verde;
            orden[1]:=azul;
            orden[2]:=verde;
            orden[3]:=azul;  
         end;
     end;
     { Post: jugadores=4 => ( ( primero=rojo => ( orden[0]=rojo /\ orden[1]=azul
             /\ orden[2]=amarillo /\ orden[3]=verde ) ) /\ ( primero=azul => 
             ( orden[0]=azul /\ orden[1]=amarillo /\ orden[2]=verde /\ orden[3]=rojo ) )
             /\ ( primero=amarillo => ( orden[0]=amarillo /\ orden[1]=verde
             /\ orden[2]=rojo /\ orden[3]=azul ) ) /\ ( primero=verde => ( orden[0]=verde
             /\ orden[1]=rojo /\ orden[2]=verde /\ orden[3]=amarillo ) ) )
             /\ jugadores=2 => ( ( primero=rojo => ( orden[0]=rojo /\ orden[1]=amarillo
             /\ orden[2]=rojo /\ orden[3]=amarillo ) ) /\ ( primero=azul =>
             ( orden[0]=azul /\ orden[1]=verde /\ orden[2]=azul /\ orden[3]=verde ) ) 
             /\ ( primero=amarillo => ( orden[0]=amarillo /\ orden[1]=rojo
             /\ orden[2]=amarillo /\ orden[3]=rojo ) ) /\ ( primero=verde => 
             ( orden[0]=verde /\ orden[1]=azul /\ orden[2]=verde /\ orden[3]=azul ) ) ) }
     end;
    
    function CantidadJugadores(
      var historico  : informativo // Texto que informa lo que ha sucedido en la partida
      ): Integer; // Función para preguntar al usuario con cuantos jugadores se
       VAR        // quiere jugar
              ch : char;    // Variable para la tecla a presionar
              k  : integer; // Variable de iteración
       BEGIN
       { Pre: true }
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
           until ch=#13;
           cambiartexto(historico,Completaconespacios(40,
            'Cantidad de jugadores: '+IntAStr(CantidadJugadores)));
       { Post: CantidadJugadores=2 \/ CantidadJugadores=4}
       end;
     
    function Colorjugador(
      var historico  : informativo // Historial de lo que ha pasado hasta el momento
      ): tColores; // Función para preguntar al usuario con qué color desea jugar
       VAR
          ch : char;    // Tecla del teclado
          k  : integer; // Auxiliar
       BEGIN
       { Pre: true }
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
           cambiartexto(historico,Completaconespacios(40,
            'Color del jugador: '+ColorAStr(Colorjugador)));
       { Post: ( %exists i | i %in tColores : i )=Colorjugador }
       end;
     
    procedure posinicial(
        var posiciones  : tipoposiciones;  // Almacena las posiciones de cada casilla
            orden      : array of tColores // Orden de los turnos
       ); // Inicializa las posiciones de las fichas
       VAR
           X,Y  : Integer; // Variables de iteración
       begin
         { Pre: ( jugadores=2 => orden[0]<>orden[1] )
                /\ ( jugadores=4 => orden[0]<>orden[1]<>orden[2]<>orden[3] ) }
           randomize;
           for x:=1 to 68 do begin  // Inicialización de las casillas neutras
               posiciones.campo[x].pri:=0;
               posiciones.campo[x].sec:=0;
           end;
           for x:=1 to 7 do begin  // Inicialización de las rectas finales
               posiciones.cfinal[x].rojo.pri:=0;
               posiciones.cfinal[x].rojo.sec:=0;
               posiciones.cfinal[x].azul.pri:=0;
               posiciones.cfinal[x].azul.sec:=0;
               posiciones.cfinal[x].verde.pri:=0;
               posiciones.cfinal[x].verde.sec:=0;
               posiciones.cfinal[x].amarillo.pri:=0;
               posiciones.cfinal[x].amarillo.sec:=0;
           end;
           for y:=0 to 3 do begin
               if orden[y]=rojo then begin
                   for x:=2 to 4 do begin  // Inicialización de las casillas de
                      posiciones.casa[x].rojo:=1; // casas y metas
                      posiciones.meta[x].rojo:=0;
                   end;
                   posiciones.meta[1].rojo:=0;
                   posiciones.campo[salidarojo].pri:=1;
                   posiciones.casa[1].rojo:=0;
               end
               else if orden[y]=azul then begin
                   for x:=2 to 4 do begin  // Inicialización de las casillas de
                      posiciones.casa[x].azul:=2; // casas y metas
                      posiciones.meta[x].azul:=0;
                   end;
                   posiciones.meta[1].azul:=0;
                   posiciones.campo[salidaazul].pri:=2;
                   posiciones.casa[1].azul:=0;
               end
               else if orden[y]=amarillo then begin
                   for x:=2 to 4 do begin  // Inicialización de las casillas de
                      posiciones.casa[x].amarillo:=3; // casas y metas
                      posiciones.meta[x].amarillo:=0;
                   end;
                   posiciones.meta[1].amarillo:=0;
                   posiciones.campo[salidaamarillo].pri:=3;
                   posiciones.casa[1].amarillo:=0;
               end
               else if orden[y]=verde then begin
                   for x:=2 to 4 do begin  // Inicialización de las casillas de
                      posiciones.casa[x].verde:=4; // casas y metas
                      posiciones.meta[x].verde:=0;
                   end;
                   posiciones.meta[1].verde:=0;
                   posiciones.campo[salidaverde].pri:=4;
                   posiciones.casa[1].verde:=0;
               end;
           end;
         { Post: Se inicializan las posiciones del juego }
       end;    
     
    procedure formatoimprimible(
        posiciones    : tipoposiciones; // Almacena las posiciones de cada casilla
        var casilla    : tiposimbolo;   // Almacena los simbolos de cada casilla
        var colores    : tipoposiciones // Almacena los colores de cada  casilla
       ); // De las posiciones, crea dos registros de arreglos con los simbolos
          // y los colores correspondientes a cada posición
        VAR
           X  : Integer;                // Variable de iteración
           S  : array[0..5] of integer; // Constantes para los colores
       begin
         { Pre: true }
           S[0]:=blanco;
           S[1]:=ficharoja;
           S[2]:=fichaazul;
           S[3]:=fichaamarilla;
           S[4]:=fichaverde;
           S[5]:=13;
           for x:=1 to 68 do begin  // Convierte las casillas neutras
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
           for x:=1 to 7 do begin  // Convierte los pasillos finales
     
               if posiciones.cfinal[x].rojo.pri<>0 then begin // Pasillo roja
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
     
               if posiciones.cfinal[x].azul.pri<>0 then begin // Pasillo azul
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
     
               if posiciones.cfinal[x].verde.pri<>0 then begin // Pasillo verde
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
     
               if posiciones.cfinal[x].amarillo.pri<>0 then begin // Pasillo amarillo
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
            for x:=1 to 4 do begin  // Convierte las casillas de las casas
               if posiciones.casa[x].rojo<>0 then begin // Casa roja
                    casilla.casa[x].rojo:='●';
                    colores.casa[x].rojo:=S[posiciones.casa[x].rojo];
               end
               else begin
                    casilla.casa[x].rojo:=' ';
                    colores.casa[x].rojo:=S[posiciones.casa[x].rojo];
               end;
     
               if posiciones.casa[x].azul<>0 then begin // Casa azule
                    casilla.casa[x].azul:='●';
                    colores.casa[x].azul:=S[posiciones.casa[x].azul];
               end
               else begin
                    casilla.casa[x].azul:=' ';
                    colores.casa[x].azul:=S[posiciones.casa[x].azul];
               end;
     
               if posiciones.casa[x].verde<>0 then begin  // Casa verde
                    casilla.casa[x].verde:='●';
                    colores.casa[x].verde:=S[posiciones.casa[x].verde];
               end
               else begin
                    casilla.casa[x].verde:=' ';
                    colores.casa[x].verde:=S[posiciones.casa[x].verde];
               end;
     
               if posiciones.casa[x].amarillo<>0 then begin  // Casa amarila
                    casilla.casa[x].amarillo:='●';
                    colores.casa[x].amarillo:=S[posiciones.casa[x].amarillo];
               end
               else begin
                    casilla.casa[x].amarillo:=' ';
                    colores.casa[x].amarillo:=S[posiciones.casa[x].amarillo];
               end;
            end;
            for x:=1 to 4 do begin  // Convierte las casillas de metas
               if posiciones.meta[x].rojo<>0 then begin // Meta roja
                    casilla.meta[x].rojo:='●';
                    colores.meta[x].rojo:=S[posiciones.meta[x].rojo];
               end
               else begin
                    casilla.meta[x].rojo:=' ';
                    colores.meta[x].rojo:=S[posiciones.meta[x].rojo];
               end;
     
               if posiciones.meta[x].azul<>0 then begin // Meta azul
                    casilla.meta[x].azul:='●';
                    colores.meta[x].azul:=S[posiciones.meta[x].azul];
               end
               else begin
                    casilla.meta[x].azul:=' ';
                    colores.meta[x].azul:=S[posiciones.meta[x].azul];
               end;
     
               if posiciones.meta[x].verde<>0 then begin  // Meta verde
                    casilla.meta[x].verde:='●';
                    colores.meta[x].verde:=S[posiciones.meta[x].verde];
               end
               else begin
                    casilla.meta[x].verde:=' ';
                    colores.meta[x].verde:=S[posiciones.meta[x].verde];
               end;
     
               if posiciones.meta[x].amarillo<>0 then begin  // Meta amarilla
                    casilla.meta[x].amarillo:='●';
                    colores.meta[x].amarillo:=S[posiciones.meta[x].amarillo];
               end
               else begin
                    casilla.meta[x].amarillo:=' ';
                    colores.meta[x].amarillo:=S[posiciones.meta[x].amarillo];
               end;
            end;
         { Post: Se imprimen las fichas y los colores respectivos sobre el tablero }
       end; 
    
    procedure entablero(
      posiciones    : tipoposiciones // Almacena las posiciones de cada casilla
      ); // Dibuja un tablero con las fichas
        VAR
            casilla    : tiposimbolo;    // Almacena los simbolos de cada casilla
            colores    : tipoposiciones; // Almacena los colores de cada  casilla
            y          : integer;        // Posición y
        BEGIN
         { Pre: true }
            formatoimprimible(posiciones,casilla,colores); // Transforma las 
            TextBackground(0); // posiciones en simbolos y colores para cada
            TextColor (15);    // casilla del tablero
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
            TextColor(colores.campo[69-33].sec);
            Write(casilla.campo[69-33].sec);
            TextCOlor(white);
            TextColor(colores.campo[69-33].pri);
            Write(casilla.campo[69-33].pri);
            TextCOlor(white);
            Write('│');
            TextBackground(white);  
            TextColor(colores.campo[69-34].sec);
            Write(casilla.campo[69-34].sec);
            TextCOlor(white);
            Write(' ');
            TextColor(colores.campo[69-34].pri);
            Write(casilla.campo[69-34].pri);
            TextCOlor(white);
            TextBackground(black);
            TextColor(white);  
            Write('│');
            TextColor(colores.campo[69-35].sec);
            Write(casilla.campo[69-35].sec);
            TextCOlor(white);
            TextColor(colores.campo[69-35].pri);
            Write(casilla.campo[69-35].pri);
            TextCOlor(white);
            Write('│             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             ├──┼───┼──┤             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             │');
            TextColor(colores.campo[69-32].sec);
            Write(casilla.campo[69-32].sec);
            TextCOlor(white);
            TextColor(colores.campo[69-32].pri);
            Write(casilla.campo[69-32].pri);
            TextCOlor(white);
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
            TextColor(white);
            Write('│');
            TextColor(colores.campo[69-36].sec);
            Write(casilla.campo[69-36].sec);
            TextCOlor(white);
            TextColor(colores.campo[69-36].pri);
            Write(casilla.campo[69-36].pri);
            TextCOlor(white);
            Write('│             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             ├──┼');
            TextBackground(blue);
            Write('───');
            TextBackground(black);
            TextColor(white);
            Write('┼──┤             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             │');
            TextColor(colores.campo[69-31].sec);
            Write(casilla.campo[69-31].sec);
            TextCOlor(white);
            TextColor(colores.campo[69-31].pri);
            Write(casilla.campo[69-31].pri);
            TextCOlor(white);
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
            TextColor(white);
            Write('│');
            TextColor(colores.campo[69-37].sec);
            Write(casilla.campo[69-37].sec);
            TextCOlor(white);
            TextColor(colores.campo[69-37].pri);
            Write(casilla.campo[69-37].pri);
            TextCOlor(white);
            Write('│             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             ├──┼');
            TextBackground(blue);
            Write('───');
            TextBackground(black);
            TextColor(white);
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
            TextColor(white);
            Write('  │');
            TextColor(colores.campo[69-30].sec);
            Write(casilla.campo[69-30].sec);
            TextCOlor(white);
            TextColor(colores.campo[69-30].pri);
            Write(casilla.campo[69-30].pri);
            TextCOlor(white);
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
            TextColor(white);
            Write('│');
            TextColor(colores.campo[69-38].sec);
            Write(casilla.campo[69-38].sec);
            TextCOlor(white);
            TextColor(colores.campo[69-38].pri);
            Write(casilla.campo[69-38].pri);
            TextCOlor(white);
            Write('│  ');
            TextBackground(yellow);
            Write('/   ');
            TextColor(colores.casa[01].amarillo);
            Write(casilla.casa[01].amarillo);
            TextColor(white);
            Write('   \');
            TextBackground(black);
            TextColor(white);
            Write('  │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│ ');
            TextBackground(blue);
            Write('/    ↑    \');
            TextBackground(black);
            TextColor(white);
            Write(' ├──┼');
            TextBackground(blue);
            Write('───');
            TextBackground(black);
            TextColor(white);
            Write('┼──┤ ');
            TextBackground(yellow);
            Write('/    ↑    \');
            TextBackground(black);
            TextColor(white);
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
            TextColor(white);
            Write('│');
            textbackground(blue);
            TextColor(colores.campo[69-29].sec);
            Write(casilla.campo[69-29].sec);
            TextCOlor(white);
            TextColor(colores.campo[69-29].pri);
            Write(casilla.campo[69-29].pri);
            TextCOlor(white);
            TextBackground(black);
            TextColor(white);
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
            TextColor(white);
            Write('│');
            textbackground(lightgray);
            TextColor(colores.campo[69-39].sec);
            Write(casilla.campo[69-39].sec);
            TextCOlor(white);
            TextColor(colores.campo[69-39].pri);
            Write(casilla.campo[69-39].pri);
            TextCOlor(white);
            TextBackground(black);
            TextColor(white);
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
            TextColor(white);
            Write('│');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│ ');
            TextBackground(blue);
            Write('\    ↓    /');
            TextBackground(black);
            TextColor(white);
            Write(' ├──┼');
            TextBackground(blue);
            Write('───');
            TextBackground(black);
            TextColor(white);
            Write('┼──┤ ');
            TextBackground(yellow);
            Write('\    ↓    /');
            TextBackground(black);
            TextColor(white);
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
            TextColor(white);
            Write('  │');
            TextColor(colores.campo[69-28].sec);
            Write(casilla.campo[69-28].sec);
            TextCOlor(white);
            TextColor(colores.campo[69-28].pri);
            Write(casilla.campo[69-28].pri);
            TextCOlor(white);
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
            TextColor(white);
            Write('│');
            TextColor(colores.campo[69-40].sec);
            Write(casilla.campo[69-40].sec);
            TextCOlor(white);
            TextColor(colores.campo[69-40].pri);
            Write(casilla.campo[69-40].pri);
            TextCOlor(white);
            Write('│  ');
            TextBackground(yellow);
            Write('\   ');
            TextColor(colores.casa[03].amarillo);
            Write(casilla.casa[03].amarillo);
            TextColor(white);
            Write('   /');
            TextBackground(black);
            TextColor(white);
            Write('  │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             ├──┼');
            TextBackground(blue);
            Write('───');
            TextBackground(black);
            TextColor(white);
            Write('┼──┤             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             │');
            TextColor(colores.campo[69-27].sec);
            Write(casilla.campo[69-27].sec);
            TextCOlor(white);
            TextColor(colores.campo[69-27].pri);
            Write(casilla.campo[69-27].pri);
            TextCOlor(white);
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
            TextColor(white);
            Write('│');                                  
            TextColor(colores.campo[69-41].sec);
            Write(casilla.campo[69-41].sec);
            TextCOlor(white);
            TextColor(colores.campo[69-41].pri);
            Write(casilla.campo[69-41].pri);
            TextCOlor(white);
            Write('│             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             ├──┼');
            TextBackground(blue);
            Write('───');
            TextBackground(black);
            TextColor(white);
            Write('┼──┤             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             │');  
            TextColor(colores.campo[69-26].sec);
            Write(casilla.campo[69-26].sec);
            TextCOlor(white);
            TextColor(colores.campo[69-26].pri);
            Write(casilla.campo[69-26].pri);
            TextCOlor(white);
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
            TextColor(white);
            Write('│');
     
            TextColor(colores.campo[69-42].sec);
            Write(casilla.campo[69-42].sec);
            TextCOlor(white);
            TextColor(colores.campo[69-42].pri);
            Write(casilla.campo[69-42].pri);
            TextCOlor(white);
            Write('│             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('├─┬─┬─┬─┬─┬─┬─┼──┼');
            TextBackground(blue);
            Write('───');
            TextBackground(black);
            TextColor(white);
            Write('┼──┼─┬─┬─┬─┬─┬─┬─┤');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│');
            TextColor(colores.campo[69-18].pri);
            Write(casilla.campo[69-18].pri);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-19].pri);
            Write(casilla.campo[69-19].pri);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-20].pri);
            Write(casilla.campo[69-20].pri);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-21].pri);
            Write(casilla.campo[69-21].pri);
            TextCOlor(white);
            Write('│');
            TextBackground(lightgray);
            TextColor(colores.campo[69-22].pri);
            Write(casilla.campo[69-22].pri);
            TextCOlor(white);
            TextBackground(black);
            TextColor(white);
            Write('│');
            TextColor(colores.campo[69-23].pri);
            Write(casilla.campo[69-23].pri);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-24].pri);
            Write(casilla.campo[69-24].pri);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-25].pri);
            Write(casilla.campo[69-25].pri);
            TextCOlor(white);
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
            TextColor(white);
            Write('├┐');
            TextColor(colores.campo[69-43].sec);
            Write(casilla.campo[69-43].sec);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-44].sec);
            Write(casilla.campo[69-44].sec);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-45].sec);
            Write(casilla.campo[69-45].sec);
            TextCOlor(white);
            Write('│');
            TextBackground(yellow);
            TextColor(colores.campo[69-46].sec);
            Write(casilla.campo[69-46].sec);
            TextCOlor(white);
            TextBackground(black);
            TextColor(white);
            Write('│');
            TextColor(colores.campo[69-47].sec);
            Write(casilla.campo[69-47].sec);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-48].sec);
            Write(casilla.campo[69-48].sec);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-49].sec);
            Write(casilla.campo[69-49].sec);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-50].sec);
            Write(casilla.campo[69-50].sec);
            TextCOlor(white);
            Write('│');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│');
            TextColor(colores.campo[69-18].sec);
            Write(casilla.campo[69-18].sec);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-19].sec);
            Write(casilla.campo[69-19].sec);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-20].sec);
            Write(casilla.campo[69-20].sec);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-21].sec);
            Write(casilla.campo[69-21].sec);
            TextCOlor(white);
            Write('│');
            TextBackground(lightgray);
            TextColor(colores.campo[69-22].sec);
            Write(casilla.campo[69-22].sec);
            TextCOlor(white);
            TextBackground(black);
            TextColor(white);
            Write('│');
            TextColor(colores.campo[69-23].sec);
            Write(casilla.campo[69-23].sec);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-24].sec);
            Write(casilla.campo[69-24].sec);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-25].sec);
            Write(casilla.campo[69-25].sec);
            TextCOlor(white);
            Write('│└┐');
            TextBackground(blue);
            TextColor(colores.meta[02].azul);
            Write(casilla.meta[02].azul);
            TextColor(white);
            TextBackground(black);
            TextColor(white);
            Write('┌┘│');
            TextColor(colores.campo[69-43].pri);
            Write(casilla.campo[69-43].pri);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-44].pri);
            Write(casilla.campo[69-44].pri);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-45].pri);
            Write(casilla.campo[69-45].pri);
            TextCOlor(white);
            Write('│');
            TextBackground(yellow);
            TextColor(colores.campo[69-46].pri);
            Write(casilla.campo[69-46].pri);
            TextCOlor(white);
            TextBackground(black);
            TextColor(white);
            Write('│');
            TextColor(colores.campo[69-47].pri);
            Write(casilla.campo[69-47].pri);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-48].pri);
            Write(casilla.campo[69-48].pri);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-49].pri);
            Write(casilla.campo[69-49].pri);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-50].pri);
            Write(casilla.campo[69-50].pri);
            TextCOlor(white);
            Write('│');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('├─┼─┼─┼─┼─┼─┼─┼─┤');
            TextBackground(red);
            TextColor(colores.meta[01].rojo);
            Write(casilla.meta[01].rojo);
            TextBackground(black);
            TextColor(white);
            TextColor(white);
            Write('│');
            TextBackground(blue);
            TextColor(colores.meta[01].azul);
            Write(casilla.meta[01].azul);
            TextColor(white);
            TextBackground(black);
            TextColor(white);
            Write('│');
            TextBackground(yellow);
            TextColor(colores.meta[04].amarillo);
            Write(casilla.meta[04].amarillo);
            TextBackground(black);
            TextColor(white);
            TextColor(white);
            Write('├─┼─┼─┼─┼─┼─┼─┼─┤');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│');
            TextBackground(lightgray);
            TextColor(colores.campo[69-17].pri);
            Write(casilla.campo[69-17].pri);
            TextCOlor(white);
            TextBackground(black);
            TextColor(white);
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
            TextColor(white);
            Write('│');
            TextBackground(lightgray);
            TextColor(colores.campo[69-51].sec);
            Write(casilla.campo[69-51].sec);
            TextCOlor(white);
            TextBackground(black);
            TextColor(white);
            Write('│');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│');
            TextBackground(white);
            TextColor(colores.campo[69-17].sec);
            Write(casilla.campo[69-17].sec);
            TextCOlor(white);
            TextBackground(black);
            TextColor(white);
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
            TextColor(white);
            Write('│');
            TextBackground(lightgray);
            TextColor(colores.campo[69-51].pri);
            Write(casilla.campo[69-51].pri);
            TextCOlor(white);
            TextBackground(black);
            TextColor(white);
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
            TextColor(white);
            Write('│');
            TextBackground(green);
            TextColor(colores.meta[01].verde);
            Write(casilla.meta[01].verde);
            TextColor(white);
            TextBackground(black);
            TextColor(white);
            Write('│');
            TextBackground(yellow);
            TextColor(colores.meta[01].amarillo);
            Write(casilla.meta[01].amarillo);
            TextBackground(black);
            TextColor(white);
            TextColor(white);
            Write('├─┼─┼─┼─┼─┼─┼─┼─┤');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│');
            TextColor(colores.campo[69-16].pri);
            Write(casilla.campo[69-16].pri);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-15].pri);
            Write(casilla.campo[69-15].pri);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-14].pri);
            Write(casilla.campo[69-14].pri);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-13].pri);
            Write(casilla.campo[69-13].pri);
            TextCOlor(white);
            Write('│');
            TextBackground(red);
            TextColor(colores.campo[69-12].pri);
            Write(casilla.campo[69-12].pri);
            TextCOlor(white);
            TextBackground(black);
            TextColor(white);
            Write('│');
            TextColor(colores.campo[69-11].pri);
            Write(casilla.campo[69-11].pri);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-10].pri);
            Write(casilla.campo[69-10].pri);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-09].pri);
            Write(casilla.campo[69-09].pri);
            TextCOlor(white);
            Write('│┌┘');
            TextBackground(green);
            TextColor(colores.meta[02].verde);
            Write(casilla.meta[02].verde);
            TextColor(white);
            TextBackground(black);
            TextColor(white);
            Write('└┐│');
            TextColor(colores.campo[69-59].sec);
            Write(casilla.campo[69-59].sec);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-58].sec);
            Write(casilla.campo[69-58].sec);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-57].sec);
            Write(casilla.campo[69-57].sec);
            TextCOlor(white);
            Write('│');
            TextBackground(lightgray);
            TextColor(colores.campo[69-56].sec);
            Write(casilla.campo[69-56].sec);
            TextCOlor(white);
            TextBackground(black);
            TextColor(white);
            Write('│');
            TextColor(colores.campo[69-55].sec);
            Write(casilla.campo[69-55].sec);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-54].sec);
            Write(casilla.campo[69-54].sec);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-53].sec);
            Write(casilla.campo[69-53].sec);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-52].sec);
            Write(casilla.campo[69-52].sec);
            TextCOlor(white);
            Write('│');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│');
            TextColor(colores.campo[69-16].sec);
            Write(casilla.campo[69-16].sec);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-15].sec);
            Write(casilla.campo[69-15].sec);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-14].sec);
            Write(casilla.campo[69-14].sec);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-13].sec);
            Write(casilla.campo[69-13].sec);
            TextCOlor(white);
            Write('│');
            TextBackground(red);
            TextColor(colores.campo[69-12].sec);
            Write(casilla.campo[69-12].sec);
            TextCOlor(white);
            TextBackground(black);
            TextColor(white);
            Write('│');
            TextColor(colores.campo[69-11].sec);
            Write(casilla.campo[69-11].sec);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-10].sec);
            Write(casilla.campo[69-10].sec);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-09].sec);
            Write(casilla.campo[69-09].sec);
            TextCOlor(white);
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
            TextColor(white);
            Write('├┘');
            TextColor(colores.campo[69-59].pri);
            Write(casilla.campo[69-59].pri);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-58].pri);
            Write(casilla.campo[69-58].pri);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-57].pri);
            Write(casilla.campo[69-57].pri);
            TextCOlor(white);
            Write('│'); TextBackground(lightgray);
            TextColor(colores.campo[69-56].pri);
            Write(casilla.campo[69-56].pri);
            TextCOlor(white);
            TextBackground(black);
            TextColor(white);
            Write('│');
            TextColor(colores.campo[69-55].pri);
            Write(casilla.campo[69-55].pri);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-54].pri);
            Write(casilla.campo[69-54].pri);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-53].pri);
            Write(casilla.campo[69-53].pri);
            TextCOlor(white);
            Write('│');
            TextColor(colores.campo[69-52].pri);
            Write(casilla.campo[69-52].pri);
            TextCOlor(white);
            Write('│');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('├─┴─┴─┴─┴─┴─┴─┼──┼');
            TextBackground(green);
            Write('───');
            TextBackground(black);
            TextColor(white);
            Write('┼──┼─┴─┴─┴─┴─┴─┴─┤');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             │');
            TextColor(colores.campo[69-08].pri);
            Write(casilla.campo[69-08].pri);
            TextCOlor(white);
            TextColor(colores.campo[69-08].sec);
            Write(casilla.campo[69-08].sec);
            TextCOlor(white);
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
            TextColor(white);
            Write('│');
            TextColor(colores.campo[69-60].pri);
            Write(casilla.campo[69-60].pri);
            TextCOlor(white);
            TextColor(colores.campo[69-60].sec);
            Write(casilla.campo[69-60].sec);
            TextCOlor(white);
            Write('│             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             ├──┼');
            TextBackground(green);
            Write('───');
            TextBackground(black);
            TextColor(white);
            Write('┼──┤             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             │');
            TextColor(colores.campo[69-07].pri);
            Write(casilla.campo[69-07].pri);
            TextCOlor(white);
            TextColor(colores.campo[69-07].sec);
            Write(casilla.campo[69-07].sec);
            TextCOlor(white);
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
            TextColor(white);
            Write('│');
            TextColor(colores.campo[69-61].pri);
            Write(casilla.campo[69-61].pri);
            TextCOlor(white);
            TextColor(colores.campo[69-61].sec);
            Write(casilla.campo[69-61].sec);
            TextCOlor(white);
            Write('│             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             ├──┼');
            TextBackground(green);
            Write('───');
            TextBackground(black);
            TextColor(white);
            Write('┼──┤             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             │');
            TextColor(colores.campo[69-06].pri);
            Write(casilla.campo[69-06].pri);
            TextCOlor(white);
            TextColor(colores.campo[69-06].sec);
            Write(casilla.campo[69-06].sec);
            TextCOlor(white);
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
            TextColor(white);
            Write('│');
            TextColor(colores.campo[69-62].pri);
            Write(casilla.campo[69-62].pri);
            TextCOlor(white);
            TextColor(colores.campo[69-62].sec);
            Write(casilla.campo[69-62].sec);
            TextCOlor(white);
            Write('│             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             ├──┼');
            TextBackground(green);
            Write('───');
            TextBackground(black);
            TextColor(white);
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
            TextColor(white);
            Write('  │');
            TextBackground(lightgray);
            TextColor(colores.campo[69-05].pri);
            Write(casilla.campo[69-05].pri);
            TextCOlor(white);
            TextColor(colores.campo[69-05].sec);
            Write(casilla.campo[69-05].sec);
            TextCOlor(white);
            TextBackground(black);
            TextColor(white);
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
            TextColor(white);
            Write('│');
            TextBackground(green);
            TextColor(colores.campo[69-63].pri);
            Write(casilla.campo[69-63].pri);
            TextCOlor(white);
            TextColor(colores.campo[69-63].sec);
            Write(casilla.campo[69-63].sec);
            TextCOlor(white);
            TextBackground(black);
            TextColor(white);
            Write('│  ');
            TextBackground(green);
            Write('/   ');
            TextColor(colores.casa[03].verde);
            Write(casilla.casa[03].verde);
            TextColor(white);
            Write('   \');
            TextBackground(black);
            TextColor(white);
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
            TextColor(white);
            Write(' ├──┼');
            TextBackground(green);
            Write('───');
            TextBackground(black);
            TextColor(white);
            Write('┼──┤ ');
            TextBackground(green);
            Write('/    ↑    \');
            TextBackground(black);
            TextColor(white);
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
            TextColor(white);
            Write('│');
            TextColor(colores.campo[69-04].pri);
            Write(casilla.campo[69-04].pri);
            TextCOlor(white);
            TextColor(colores.campo[69-04].sec);
            Write(casilla.campo[69-04].sec);
            TextCOlor(white);
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
            TextColor(white);
            Write('│');
            TextColor(colores.campo[69-64].pri);
            Write(casilla.campo[69-64].pri);
            TextCOlor(white);
            TextColor(colores.campo[69-64].sec);
            Write(casilla.campo[69-64].sec);
            TextCOlor(white);
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
            TextColor(white);
            Write('│');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│ ');
            TextBackground(red);
            Write('\    ↓    /');
            TextBackground(black);
            TextColor(white);
            Write(' ├──┼');
            TextBackground(green);
            Write('───');
            TextBackground(black);
            TextColor(white);
            Write('┼──┤ ');
            TextBackground(green);
            Write('\    ↓    /');
            TextBackground(black);
            TextColor(white);
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
            TextColor(white);
            Write('  │');
            TextColor(colores.campo[69-03].pri);
            Write(casilla.campo[69-03].pri);
            TextCOlor(white);
            TextColor(colores.campo[69-03].sec);
            Write(casilla.campo[69-03].sec);
            TextCOlor(white);
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
            TextColor(white);
            Write('│');
            TextColor(colores.campo[69-65].pri);
            Write(casilla.campo[69-65].pri);
            TextCOlor(white);
            TextColor(colores.campo[69-65].sec);
            Write(casilla.campo[69-65].sec);
            TextCOlor(white);
            Write('│  ');
            TextBackground(green);
            Write('\   ');
            TextColor(colores.casa[01].verde);
            Write(casilla.casa[01].verde);
            TextColor(white);
            Write('   /');
            TextBackground(black);
            TextColor(white);
            Write('  │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             ├──┼');
            TextBackground(green);
            Write('───');
            TextBackground(black);
            TextColor(white);
            Write('┼──┤             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             │');
            TextColor(colores.campo[69-02].pri);
            Write(casilla.campo[69-02].pri);
            TextCOlor(white);
            TextColor(colores.campo[69-02].sec);
            Write(casilla.campo[69-02].sec);
            TextCOlor(white);
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
            TextColor(white);
            Write('│');
            TextColor(colores.campo[69-66].pri);
            Write(casilla.campo[69-66].pri);
            TextCOlor(white);
            TextColor(colores.campo[69-66].sec);
            Write(casilla.campo[69-66].sec);
            TextCOlor(white);
            Write('│             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             ├──┼───┼──┤             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('│             │');
            TextColor(colores.campo[69-01].pri);
            Write(casilla.campo[69-01].pri);
            TextCOlor(white);
            TextColor(colores.campo[69-01].sec);
            Write(casilla.campo[69-01].sec);
            TextCOlor(white);
            Write('│');
            TextBackground(black);
            TextColor(white);  
            TextBackground(lightgray);  
            TextColor(colores.campo[69-68].pri);
            Write(casilla.campo[69-68].pri);
            TextCOlor(white);
            Write(' ');
            TextColor(colores.campo[69-68].sec);
            Write(casilla.campo[69-68].sec);
            TextCOlor(white);
            TextBackground(black);
            TextColor(white);  
            Write('│');
            TextColor(colores.campo[69-67].pri);
            Write(casilla.campo[69-67].pri);
            TextCOlor(white);
            TextColor(colores.campo[69-67].sec);
            Write(casilla.campo[69-67].sec);
            TextCOlor(white);
            Write('│             │');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
            Write('└─────────────┴──┴───┴──┴─────────────┘');
            Writeln;
            gotoxy(7,y);
            y:=y+1;
      { Post: Se imprime el tablero del juego }
     END;
    
    procedure configinicial(
      VAR jugadores  : Integer;           // Cantidad de jugadores
      VAR posiciones : tipoposiciones;    // Almacena las posiciones de cada casilla
      VAR historico  : informativo;       // Informa al usuario lo sucedido en la partida
      VAR Colorjug   : tColores;          // Color del jugador
      VAR orden      : array of tColores; // Orden de los jugadores
      var turnoactual: tColores
            ); // Realiza las primeras configuraciones del juego
      VAR 
          maquinas   : array[0..2] of tColores; // Colores de las maquinas
          primero    : tColores;                // Color del primer jugador
      begin
         { Pre: ( jugadores=2 \/ jugadores=4 ) /\ ( %exists i | i %in tColores : i )=Colorjug
                /\ ( jugadores=2 => orden[0]<>orden[1] )
                /\ ( jugadores=4 => orden[0]<>orden[1]<>orden[2]<>orden[3] ) }
           plantillaconfig;
           jugadores:=CantidadJugadores(historico);
           Colorjug:=Colorjugador(historico);
           plantillaprincipal;
           tituloanim(50,4,150,3);
           asignamaquinas(Colorjug,jugadores,maquinas);
           primero:=Defineprimero(historico,jugadores,maquinas,Colorjug);
           DefineOrden(orden,primero,jugadores);
           posinicial(posiciones,orden);
           entablero(posiciones);
           imprimirtexto(historico);
           turnoactual:=primero;
           mturnoactual(turnoactual);
           cambiartexto(historico,Completaconespacios(40,'Iniciando partida...'));
           imprimirtexto(historico);
         { Post: Se inicia el juego con las configuraciones iniciales }
       end;

    procedure enviaracasa(
      var posiciones: tipoposiciones; // Tipo de posiciones de las fichas
              posfi : integer;        // Posición final al mover la ficha
              ordfi : byte            // Parámetro que indica la zona final de
                                      // la ficha
        ); // Procedimiento para enviar una ficha a casa
     var 
        j     : integer; // Variable de iteración
     begin
         { Pre: ordfi=1 \/ ordfi=2 /\ posfi>=1 /\ posfi<=68}
         if ordfi=1 then begin
             if posiciones.campo[posfi].pri=1 then begin
                posiciones.campo[posfi].pri:=0;
                j:=1;
                {Inv: TRUE}
                while (posiciones.casa[j].rojo=0) and (j<=4) do begin
                    j:=j+1;
                end;
                j:=1;
                posiciones.casa[j].rojo:=ficharoja;
             end;
             if posiciones.campo[posfi].pri=2 then begin
                posiciones.campo[posfi].pri:=0;
                j:=1;
                {Inv: TRUE}
                while (posiciones.casa[j].azul=0) and (j<=4) do begin
                    j:=j+1;
                end;
                j:=1;
                posiciones.casa[j].azul:=fichaazul;
             end;
             if posiciones.campo[posfi].pri=3 then begin
                posiciones.campo[posfi].pri:=0;
                j:=1;
                {Inv: TRUE}
                while (posiciones.casa[j].amarillo=0) and (j<=4) do begin
                    j:=j+1;
                end;
                j:=1;
                posiciones.casa[j].amarillo:=fichaamarilla;
             end;
             if posiciones.campo[posfi].pri=4 then begin
                posiciones.campo[posfi].pri:=0;
                j:=1;
                {Inv: TRUE}
                while (posiciones.casa[j].verde=0) and (j<=4) do begin
                    j:=j+1;
                end;
                j:=1;
                posiciones.casa[j].verde:=fichaverde;
             end;
         end
         else if ordfi=2 then begin
             if posiciones.campo[posfi].sec=1 then begin
                posiciones.campo[posfi].sec:=0;
                j:=1;
                {Inv: TRUE}
                while (posiciones.casa[j].rojo=0) and (j<=4) do begin
                    j:=j+1;
                end;
                j:=1;
                posiciones.casa[j].rojo:=ficharoja;
             end;
             if posiciones.campo[posfi].sec=2 then begin
                posiciones.campo[posfi].sec:=0;
                j:=1;
                {Inv: TRUE}
                while (posiciones.casa[j].azul=0) and (j<=4) do begin
                    j:=j+1;
                end;
                j:=1;
                posiciones.casa[j].azul:=fichaazul;
             end;
             if posiciones.campo[posfi].sec=3 then begin
                posiciones.campo[posfi].sec:=0;
                j:=1;
                {Inv: TRUE}
                while (posiciones.casa[j].amarillo=0) and (j<=4) do begin
                    j:=j+1;
                end;
                j:=1;
                posiciones.casa[j].amarillo:=fichaamarilla;
             end;
             if posiciones.campo[posfi].sec=4 then begin
                posiciones.campo[posfi].sec:=0;
                j:=1;
                {Inv: TRUE}
                while (posiciones.casa[j].verde=0) and (j<=4) do begin
                    j:=j+1;
                end;
                j:=1;
                posiciones.casa[j].verde:=fichaverde;
             end;
         end;
         { Post: Se envía una ficha a casa}
     end;

    procedure animacioncomer(
        turnoactual : tColores; // Color del turno actual
        fichacomida : tColores  // Color de la ficha que se comió
        ); // Muestra una animación al comer una ficha
       VAR
       i,j,k,u,v : Integer; // Variables de iteración para la animación
       x : Integer;         // Coordenada en X
       y : Integer;         // Coordenada en Y
       come : Integer;      // Color de la ficha que come
       comido : Integer;    // Color de la ficha comida
       cabeza : array[1..11] of string; // Lineas para la parte superior de la cabeza
       boca : array[1..11] of string;   // Lineas para la boca
       ficha : array[1..11] of string;  // Lineas para la ficha
       begin
         { Pre: turnoactual=( %exists i | i %in tColores : i ) }
          cabeza[1]:=
          ('                                                                        ');
          cabeza[2]:=
          ('                            ******                                      ');
          cabeza[3]:=
          ('                         ************                                   ');
          cabeza[4]:=
          ('                      ******************                                ');
          cabeza[5]:=
          ('                     ***   ********   ***                               ');
          cabeza[6]:=
          ('                     ***   ********   ***                               ');
          cabeza[7]:=
          ('                     ***   ********   ***                               ');
          cabeza[8]:=
          ('                     ********************                               ');
          cabeza[9]:=
          ('                     ********************                               ');
          cabeza[10]:=
          ('                     ********************                               ');
          cabeza[11]:=
          ('                            *   *                                       ');
          ficha[1]:=
          ('                             ***                                        ');
          ficha[2]:=
          ('                            *****                                       ');
          ficha[3]:=
          ('                             ***                                        ');
          boca[1]:=
          ('                              *                                         ');
          boca[2]:=
          ('                     ********************                               ');
          boca[3]:=
          ('                     ********************                               ');
          boca[4]:=
          ('                      ******************                                ');
          boca[5]:=
          ('                      ******************                                ');
          boca[6]:=
          ('                                                                        ');
          boca[7]:=
          ('                                                                        ');
          if turnoactual=Rojo then
              come:=ficharoja
          else if turnoactual=azul then
              come:=fichaazul
          else if turnoactual=amarillo then
              come:=fichaamarilla
          else if turnoactual=verde then
              come:=fichaverde;
          if fichacomida=Rojo then
              comido:=ficharoja
          else if fichacomida=azul then
              comido:=fichaazul
          else if fichacomida=amarillo then
              comido:=fichaamarilla
          else if fichacomida=verde then
              comido:=fichaverde;
          for k:=0 to 6 do begin
             if k<6 then
                 y:=12
             else 
                 y:=11;
             x:=46;
             gotoxy(x,y);
             textbackground(white);
             writeln(' ');
             textbackground(black);
             gotoxy(x+11,y);
             textbackground(white);
             writeln(' ');
             textbackground(black);
             x:=20;
             y:=16;
             for i:=1 to 72 do begin
               for j:=1 to 3 do begin
                 gotoxy(x+i,y+j);
                 if ficha[j][i]='*' then Begin
                     textbackground(comido);
                     writeln(' ');
                     textbackground(black);
                 end;
               end;
             end;
             y:=5;
             for i:=1 to 72 do begin
               for j:=1 to 11 do begin
                 if cabeza[j][i]='*' then Begin
                     gotoxy(x+i,y+j);
                     textbackground(come);
                     writeln(' ');
                     textbackground(black);
                 end;
                 if boca[j][i]='*' then Begin
                     gotoxy(x+i,y+j+15-k);
                     textbackground(come);
                     writeln(' ');
                     textbackground(black);
                 end;
               end;
             end;
             if k<6 then
                 delay(200)
             else
                 delay(600);
             clrscr;
          end;
             clrscr;
             plantillaprincipal;
             tituloanim(50,4,150,1);
         { Post: Se muestra una animación en la que comido viene a ser el color
                 en número de fichacomida y come vendría a ser el color en número
                 de turnoactual, es decir, quien está comiendo. En la animación,
                 la "cara" es del color de quien come y la "ficha" del color de
                 la ficha que se comió }
       end;

    procedure comerficha(
      var historico   : informativo;    // Texto que informa lo que ha sucedido
                                        // en la partida
      var posiciones  : tipoposiciones; // Tipo de posiciones de las fichas
          turnoactual : tColores;       // Color del turno actual
                posin : integer;        // Posición inicial de la ficha
                posfi : integer;        // Posición final de la ficha
                ordin : byte;           // Parámetro que indica la zona inicial
                                        // de la ficha
                ordfi : byte            // Parámetro que indica la zona final de
                                        // la ficha
        ); // Procedimiento para comer una ficha
     var 
        comido : string; // String del color comido
        come   : string; // String del color que come
     begin
     { Pre: turnoactual=( %exists i | i %in tColores : i ) /\ posin>=0 /\ posfi>=0
            /\ posfi>=posin /\ ( ordin=1 \/ ordin=2 ) /\ ( ordfi=1 \/ ordfi=2 ) }
        if (ordin=1) and (ordfi=1) then begin
            if posiciones.campo[posfi].pri=1 then
                comido:='rojo';
            if posiciones.campo[posfi].pri=2 then
                comido:='azul';
            if posiciones.campo[posfi].pri=3 then
                comido:='amarillo';
            if posiciones.campo[posfi].pri=4 then
                comido:='verde';
            if posiciones.campo[posin].pri=1 then
                come:='rojo';
            if posiciones.campo[posin].pri=2 then
                come:='azul';
            if posiciones.campo[posin].pri=3 then
                come:='amarillo';
            if posiciones.campo[posin].pri=4 then
                come:='verde';
            enviaracasa(posiciones,posfi,ordfi);
            posiciones.campo[posfi].pri:=posiciones.campo[posin].pri;
            posiciones.campo[posin].pri:=posiciones.campo[posin].sec;
            posiciones.campo[posin].sec:=0;
        end;
        if (ordin=1) and (ordfi=2) then begin
            if posiciones.campo[posfi].sec=1 then
                comido:='rojo';
            if posiciones.campo[posfi].sec=2 then
                comido:='azul';
            if posiciones.campo[posfi].sec=3 then
                comido:='amarillo';
            if posiciones.campo[posfi].sec=4 then
                comido:='verde';
            if posiciones.campo[posin].pri=1 then
                come:='rojo';
            if posiciones.campo[posin].pri=2 then
                come:='azul';
            if posiciones.campo[posin].pri=3 then
                come:='amarillo';
            if posiciones.campo[posin].pri=4 then
                come:='verde';
            enviaracasa(posiciones,posfi,ordfi);
            posiciones.campo[posfi].sec:=posiciones.campo[posin].pri;
            posiciones.campo[posin].pri:=posiciones.campo[posin].sec;
            posiciones.campo[posin].sec:=0;
        end;
        if (ordin=2) and (ordfi=1) then begin
            if posiciones.campo[posfi].pri=1 then
                comido:='rojo';
            if posiciones.campo[posfi].pri=2 then
                comido:='azul';
            if posiciones.campo[posfi].pri=3 then
                comido:='amarillo';
            if posiciones.campo[posfi].pri=4 then
                comido:='verde';
            if posiciones.campo[posin].sec=1 then
                come:='rojo';
            if posiciones.campo[posin].sec=2 then
                come:='azul';
            if posiciones.campo[posin].sec=3 then
                come:='amarillo';
            if posiciones.campo[posin].sec=4 then
                come:='verde';
            enviaracasa(posiciones,posfi,ordfi);
            posiciones.campo[posfi].pri:=posiciones.campo[posin].sec;
            posiciones.campo[posin].sec:=0;
        end;
        if (ordin=2) and (ordfi=2) then begin
            if posiciones.campo[posfi].sec=1 then
                comido:='rojo';
            if posiciones.campo[posfi].sec=2 then
                comido:='azul';
            if posiciones.campo[posfi].sec=3 then
                comido:='amarillo';
            if posiciones.campo[posfi].sec=4 then
                comido:='verde';
            if posiciones.campo[posin].sec=1 then
                come:='rojo';
            if posiciones.campo[posin].sec=2 then
                come:='azul';
            if posiciones.campo[posin].sec=3 then
                come:='amarillo';
            if posiciones.campo[posin].sec=4 then
                come:='verde';
            enviaracasa(posiciones,posfi,ordfi);
            posiciones.campo[posfi].sec:=posiciones.campo[posin].sec;
            posiciones.campo[posin].sec:=0;
        end;
        delay(300);
        cambiartexto(historico,Completaconespacios(40,'jugador '+come+
            ' comido una ficha a '+comido));
        imprimirtexto(historico);
        if comido='rojo' then
            animacioncomer(turnoactual,rojo)
        else if comido='azul' then
            animacioncomer(turnoactual,azul)
        else if comido='amarillo' then
            animacioncomer(turnoactual,amarillo)
        else if comido='verde' then
            animacioncomer(turnoactual,verde);
        plantillaprincipal;
        entablero(posiciones);
     { Post: Se reemplaza a una ficha "comida" por una ficha que "come" y se
             endía la ficha comida a casa }
     end;

    procedure siguienteturno(  
      var turnoactual : tColores;          // Color del turno acutal
          orden       : array of tColores; // Orden de los jugadores
          jugadores   : integer            // Cantidad de jugadores
      ); // Cambia el turno al siguiente jugador en sentido anti-horario
     var k : byte; // Variable de iteración
     begin
     { Pre: turnoactual=( %exists i | i %in tColores : i ) /\ ( jugadores = 2 
            \/ jugadores=4 ) /\ ( jugadores=2 => orden[0]<>orden[1] )
                /\ ( jugadores=4 => orden[0]<>orden[1]<>orden[2]<>orden[3] ) }
     if jugadores=4 then
          if turnoactual=rojo then
              turnoactual:=verde
          else if turnoactual=verde then
              turnoactual:=amarillo
          else if turnoactual=amarillo then
              turnoactual:=azul
          else if turnoactual=azul then
              turnoactual:=rojo;
     if jugadores=2 then 
          if turnoactual=rojo then Begin
              turnoactual:=amarillo;
              end
          else if turnoactual=verde then
              turnoactual:=azul
          else if turnoactual=amarillo then
              turnoactual:=rojo
          else if turnoactual=azul then
              turnoactual:=verde;
         { Post: Se cambia el turno del jugador actual. Si se juega de 4 jugadores,
                 el orden es rojo, verde, amarillo, azul y se retorna a rojo. Si
                 se juega de 4 jugadores, dependiendo del color del jugador, si
                 es rojo, se cambia a amarillo; si es verde, se cambia a azul y
                 viceversa para ambos casos }
     end;

    procedure SacarFicha(
      var historico  : informativo;    // Texto que informa lo que ha sucedido en
                                       //la partida
      var posiciones : tipoposiciones; // Tipo de posiciones de las fichas
      turnoactual    : tColores;       // Color del turno actual
      comio          : boolean         // Variable booleana que indica si se
                                       // comio al sacar una ficha
      ); // Procedimiento para sacar una ficha
     VAR
         i,j    : integer;  // Variables de iteración
         comido : tColores; // Variable para una ficha comida
     Begin
         { Pre: ( %exists i | i %in tColores : i )=turnoactual }
         comio:=false;
         if turnoactual=rojo then begin
            j:=0;
            for i:=1 to 4 do
                if (j=0) and (posiciones.casa[i].rojo<>0) then
                    j:=i;
            posiciones.casa[j].rojo:=0;
            if posiciones.campo[salidarojo].pri=0 then
                posiciones.campo[salidarojo].pri:=1
            else if posiciones.campo[salidarojo].pri<>0 then
                if posiciones.campo[salidarojo].pri<>1 then begin
                    enviaracasa(posiciones,salidarojo,1);
                    posiciones.campo[salidarojo].pri:=1;
                    if posiciones.campo[salidarojo].pri=1 then
                        comido:=rojo
                    else if posiciones.campo[salidarojo].pri=2 then
                        comido:=azul
                    else if posiciones.campo[salidarojo].pri=3 then
                        comido:=amarillo
                    else if posiciones.campo[salidarojo].pri=4 then
                        comido:=verde;
                    cambiartexto(historico,Completaconespacios(40,'Jugador '+
                    ColorAStr(turnoactual)+' ha comido una ficha a '+
                    ColorAStr(comido)));
                    comio:=true;
                    animacioncomer(turnoactual,comido);
                    mturnoactual(turnoactual);
                    imprimirtexto(historico);
                    entablero(posiciones);
                end
            else if posiciones.campo[salidarojo].pri=1 then
                if posiciones.campo[salidarojo].sec=0 then
                    posiciones.campo[salidarojo].sec:=1
                else if posiciones.campo[salidarojo].sec<>0 then
                    if posiciones.campo[salidarojo].sec<>1 then begin
                        enviaracasa(posiciones,salidarojo,2);
                        posiciones.campo[salidarojo].pri:=1;
                        if posiciones.campo[salidarojo].sec=1 then
                            comido:=rojo
                        else if posiciones.campo[salidarojo].sec=2 then
                            comido:=azul
                        else if posiciones.campo[salidarojo].sec=3 then
                            comido:=amarillo
                        else if posiciones.campo[salidarojo].sec=4 then
                            comido:=verde;
                        cambiartexto(historico,Completaconespacios(40,'Jugador '+
                        ColorAStr(turnoactual)+' ha comido una ficha a '+
                        ColorAStr(comido)));
                        comio:=true;
                        animacioncomer(turnoactual,comido);
                        mturnoactual(turnoactual);
                        imprimirtexto(historico);
                        entablero(posiciones);
                    end;
         end
         else if turnoactual=azul then begin
            j:=0;
            for i:=1 to 4 do
                if (j=0) and (posiciones.casa[i].azul<>0) then
                    j:=i;
            posiciones.casa[j].azul:=0;
            if posiciones.campo[salidaazul].pri=0 then
                posiciones.campo[salidaazul].pri:=2
            else if posiciones.campo[salidaazul].pri<>0 then
                if posiciones.campo[salidaazul].pri<>2 then begin
                    enviaracasa(posiciones,salidaazul,1);
                    posiciones.campo[salidaazul].pri:=2;
                    if posiciones.campo[salidaazul].pri=1 then
                        comido:=rojo
                    else if posiciones.campo[salidaazul].pri=2 then
                        comido:=azul
                    else if posiciones.campo[salidaazul].pri=3 then
                        comido:=amarillo
                    else if posiciones.campo[salidaazul].pri=4 then
                        comido:=verde;
                end
            else if posiciones.campo[salidaazul].pri=1 then
                if posiciones.campo[salidaazul].sec=0 then
                    posiciones.campo[salidaazul].sec:=2
                else if posiciones.campo[salidaazul].sec<>0 then
                    if posiciones.campo[salidaazul].sec<>2 then begin
                        enviaracasa(posiciones,salidaazul,2);
                        posiciones.campo[salidaazul].pri:=2;
                        if posiciones.campo[salidaazul].sec=1 then
                            comido:=rojo
                        else if posiciones.campo[salidaazul].sec=2 then
                            comido:=azul
                        else if posiciones.campo[salidaazul].sec=3 then
                            comido:=amarillo
                        else if posiciones.campo[salidaazul].sec=4 then
                            comido:=verde;
                        cambiartexto(historico,Completaconespacios(40,'Jugador '+
                        ColorAStr(turnoactual)+' ha comido una ficha a '+
                        ColorAStr(comido)));
                        animacioncomer(turnoactual,comido);
                        mturnoactual(turnoactual);
                        imprimirtexto(historico);
                        entablero(posiciones);
                    end;
         end
         else if turnoactual=amarillo then begin
            j:=0;
            for i:=1 to 4 do
                if (j=0) and (posiciones.casa[i].amarillo<>0) then
                    j:=i;
            posiciones.casa[j].amarillo:=0;
            if posiciones.campo[salidaamarillo].pri=0 then
                posiciones.campo[salidaamarillo].pri:=3
            else if posiciones.campo[salidaamarillo].pri<>0 then
                if posiciones.campo[salidaamarillo].pri<>3 then begin
                    enviaracasa(posiciones,salidaamarillo,1);
                    posiciones.campo[salidaamarillo].pri:=3;
                    if posiciones.campo[salidaamarillo].pri=1 then
                        comido:=rojo
                    else if posiciones.campo[salidaamarillo].pri=2 then
                        comido:=azul
                    else if posiciones.campo[salidaamarillo].pri=3 then
                        comido:=amarillo
                    else if posiciones.campo[salidaamarillo].pri=4 then
                        comido:=verde;
                end
            else if posiciones.campo[salidaamarillo].pri=1 then
                if posiciones.campo[salidaamarillo].sec=0 then
                    posiciones.campo[salidaamarillo].sec:=3
                else if posiciones.campo[salidaamarillo].sec<>0 then
                    if posiciones.campo[salidaamarillo].sec<>3 then begin
                        enviaracasa(posiciones,salidaamarillo,2);
                        posiciones.campo[salidaamarillo].pri:=3;
                        if posiciones.campo[salidaamarillo].sec=1 then
                            comido:=rojo
                        else if posiciones.campo[salidaamarillo].sec=2 then
                            comido:=azul
                        else if posiciones.campo[salidaamarillo].sec=3 then
                            comido:=amarillo
                        else if posiciones.campo[salidaamarillo].sec=4 then
                            comido:=verde;
                        cambiartexto(historico,Completaconespacios(40,'Jugador '+
                        ColorAStr(turnoactual)+' ha comido una ficha a '+
                        ColorAStr(comido)));
                        animacioncomer(turnoactual,comido);
                        mturnoactual(turnoactual);
                        imprimirtexto(historico);
                        entablero(posiciones);
                    end;
         end
         else if turnoactual=verde then begin
            j:=0;
            for i:=1 to 4 do
                if (j=0) and (posiciones.casa[i].verde<>0) then
                    j:=i;
            posiciones.casa[j].verde:=0;
            if posiciones.campo[salidaverde].pri=0 then
                posiciones.campo[salidaverde].pri:=4
            else if posiciones.campo[salidaverde].pri<>0 then
                if posiciones.campo[salidaverde].pri<>4 then begin
                    enviaracasa(posiciones,salidaverde,1);
                    posiciones.campo[salidaverde].pri:=4;
                    if posiciones.campo[salidaverde].pri=1 then
                        comido:=rojo
                    else if posiciones.campo[salidaverde].pri=2 then
                        comido:=azul
                    else if posiciones.campo[salidaverde].pri=3 then
                        comido:=amarillo
                    else if posiciones.campo[salidaverde].pri=4 then
                        comido:=verde;
                end
            else if posiciones.campo[salidaverde].pri=1 then
                if posiciones.campo[salidaverde].sec=0 then
                    posiciones.campo[salidaverde].sec:=4
                else if posiciones.campo[salidaverde].sec<>0 then
                    if posiciones.campo[salidaverde].sec<>4 then begin
                        enviaracasa(posiciones,salidaverde,2);
                        posiciones.campo[salidaverde].pri:=4;
                        if posiciones.campo[salidaverde].sec=1 then
                            comido:=rojo
                        else if posiciones.campo[salidaverde].sec=2 then
                            comido:=azul
                        else if posiciones.campo[salidaverde].sec=3 then
                            comido:=amarillo
                        else if posiciones.campo[salidaverde].sec=4 then
                            comido:=verde;
                        cambiartexto(historico,Completaconespacios(40,'Jugador '+
                        ColorAStr(turnoactual)+' ha comido una ficha a '+
                        ColorAStr(comido)));
                        animacioncomer(turnoactual,comido);
                        mturnoactual(turnoactual);
                        imprimirtexto(historico);
                        entablero(posiciones);
                    end;
         end;
     { Post: Se saca una ficha y si hay fichas en la salida, se comen }
     end;

    function NoEsSeguroOcupado(
        posiciones : tipoposiciones; // Tipo de las posiciones de las fichas
        n : integer                  // Variable en la que se almacena el color
                                     // de la ficha en la casilla
        ): boolean; // Establece si una casilla de seguro no está ocupada
        begin
         { Pre: ( %exists i | i %in tColores : i )=n }
            NoEsSeguroOcupado:=
            ((n=pasillorojo) and ((posiciones.campo[n].pri=0) 
            or (posiciones.campo[n].sec=0))) OR 
            ((n=pasilloazul) and ((posiciones.campo[n].pri=0) 
            or (posiciones.campo[n].sec=0))) OR 
            ((n=pasilloamarillo) and ((posiciones.campo[n].pri=0) 
            or (posiciones.campo[n].sec=0))) OR 
            ((n=pasilloverde) and ((posiciones.campo[n].pri=0) 
            or (posiciones.campo[n].sec=0))) OR 
            ((n=seguro1) and ((posiciones.campo[n].pri=0) 
            or (posiciones.campo[n].sec=0))) OR 
            ((n=seguro2) and ((posiciones.campo[n].pri=0) 
            or (posiciones.campo[n].sec=0))) OR 
            ((n=seguro3) and ((posiciones.campo[n].pri=0) 
            or (posiciones.campo[n].sec=0))) OR 
            ((n=seguro4) and ((posiciones.campo[n].pri=0) 
            or (posiciones.campo[n].sec=0))) OR ((n<>pasillorojo)and
            (n<>pasilloazul)and(n<>pasilloverde)and(n<>pasilloamarillo)
            and(n<>seguro4)and(n<>seguro3)and(n<>seguro2)and(n<>seguro1));
         { Post:  TRUE}
        end;

    function NoesSalidaOcupada(
        posiciones : tipoposiciones; // Tipo de las posiciones de las fichas
        n : integer                  // Variable en la que se almacena el color
                                     // de la ficha en la casilla
        ): boolean; // Establece si una casilla de salida no está ocupada
        begin
         { Pre: ( %exists i | i %in tColores : i )=n }
            Noessalidaocupada:=
            ((n=salidarojo) and ((posiciones.campo[n].pri=0) 
            or (posiciones.campo[n].sec=0))) OR 
            ((n=salidaazul) and ((posiciones.campo[n].pri=0) 
            or (posiciones.campo[n].sec=0))) OR 
            ((n=salidaamarillo) and ((posiciones.campo[n].pri=0) 
            or (posiciones.campo[n].sec=0))) OR 
            ((n=salidaverde) and ((posiciones.campo[n].pri=0) 
            or (posiciones.campo[n].sec=0))) OR ((n<>salidarojo)and
            (n<>salidaazul)and(n<>salidaverde)and(n<>salidaamarillo));
         { Post: TRUE}
        end;

    procedure menufichas(
     var  seleccion  : integer;          // ficha seleccionada
     var  parametro  : integer;          // Parámetro que define en qué parte del
                                         // tablero se encuentra la ficha
          paramde    : array of integer; // parametro final luego de calculos
          definit    : array of integer; // posiciones finales luego de calculos
          k          : integer;          // cantidad de opciones.
          posiciones : tipoposiciones;   // posiciones de la partida
          turnoactual: tColores          // Color del turno actual
          ); // Menu para cambiar de ficha
     Var
        ch           : char;    // Tecla a presionar
        cant         : integer; // Cantidad de opciones
        opcion1      : string;  // Primera opción
        opcion2      : string;  // Segunda opción
        opcion3      : string;  // Tercera opción
        opcion4      : string;  // Cuarta opción
        mensaje      : string;  // Mensaje de salida
        x,y          : integer; // Coordenadas x,y
     begin
     {Pre: TRUE}
         opcion1:='» ficha 1';
         opcion2:='» ficha 2';
         opcion3:='» ficha 3';
         opcion4:='» ficha 4';
         mensaje:='» ¿Cual ficha desea mover?';
         opcion1:=Completaconespacios(15,opcion1);
         opcion2:=Completaconespacios(15,opcion2);
         opcion3:=Completaconespacios(15,opcion3);
         opcion4:=Completaconespacios(15,opcion4);
         cant:=k;
         k:=1;
         x:=55;
         y:=35;
         repeat
             Textcolor(White);
             gotoxy(x,y);
             Write(Completaconespacios(15,Completaconespacios(20,mensaje)));
             if (k=1) then begin
                 entablero(posiciones);
                 gotoxy(x,y+1);
                 Textcolor(white);
                 TextBackground(cyan);
                 write(opcion1);
                 gotoxy(x,y+2);
                 Textcolor(white);
                 TextBackground(black);
                 write(opcion2);
                 gotoxy(x,y+3);
                 Textcolor(white);
                 TextBackground(black);
                 write(opcion3);
                 gotoxy(x,y+4);
                 Textcolor(white);
                 TextBackground(black);
                 write(opcion4);
                 if turnoactual=rojo then begin
                     if paramde[0]>10 then
                         if paramde[0]=11 then begin
                             posiciones.cfinal[definit[0]].rojo.pri:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[0]].pri:=1;
                         end
                         else begin
                             posiciones.cfinal[definit[0]].rojo.sec:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[0]].pri:=1;
                         end
                     else
                         if paramde[0]=1 then begin
                             posiciones.campo[definit[0]].pri:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[0]].pri:=1;
                         end
                         else begin
                             posiciones.campo[definit[0]].sec:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[0]].pri:=1;
                         end;
                 end
                 else if turnoactual=azul then begin
                     if paramde[0]>10 then
                         if paramde[0]=11 then begin
                             posiciones.cfinal[definit[0]].azul.pri:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[0]].pri:=2;
                         end
                         else begin
                             posiciones.cfinal[definit[0]].azul.sec:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[0]].pri:=2;
                         end
                     else
                         if paramde[0]=1 then begin
                             posiciones.campo[definit[0]].pri:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[0]].pri:=2;
                         end
                         else begin
                             posiciones.campo[definit[0]].sec:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[0]].pri:=2;
                         end;
                 end
                 else if turnoactual=amarillo then begin
                     if paramde[0]>10 then
                         if paramde[0]=11 then begin
                             posiciones.cfinal[definit[0]].amarillo.pri:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[0]].pri:=3;
                         end
                         else begin
                             posiciones.cfinal[definit[0]].amarillo.sec:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[0]].pri:=3;
                         end
                     else
                         if paramde[0]=1 then begin
                             posiciones.campo[definit[0]].pri:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[0]].pri:=3;
                         end
                         else begin
                             posiciones.campo[definit[0]].sec:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[0]].pri:=3;
                         end;
                 end
                 else if turnoactual=verde then begin
                     if paramde[0]>10 then
                         if paramde[0]=11 then begin
                             posiciones.cfinal[definit[0]].verde.pri:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[0]].pri:=4;
                         end
                         else begin
                             posiciones.cfinal[definit[0]].verde.sec:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[0]].pri:=4;
                         end
                     else
                         if paramde[0]=1 then begin
                             posiciones.campo[definit[0]].pri:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[0]].pri:=4;
                         end
                         else begin
                             posiciones.campo[definit[0]].sec:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[0]].pri:=4;
                         end;
                 end;
                 seleccion:=definit[0];
                 parametro:=paramde[0];
             end;
             if (k=2) then begin
                 entablero(posiciones);
                 gotoxy(x,y+1);
                 Textcolor(white);
                 TextBackground(black);
                 write(opcion1);
                 gotoxy(x,y+2);
                 Textcolor(white);
                 TextBackground(cyan);
                 write(opcion2);
                 gotoxy(x,y+3);
                 Textcolor(white);
                 TextBackground(black);
                 write(opcion3);
                 gotoxy(x,y+4);
                 Textcolor(white);
                 TextBackground(black);
                 write(opcion4);
                 if turnoactual=rojo then begin
                     if paramde[1]>10 then
                         if paramde[1]=11 then begin
                             posiciones.cfinal[definit[1]].rojo.pri:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[1]].pri:=1;
                         end
                         else begin
                             posiciones.cfinal[definit[1]].rojo.sec:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[1]].pri:=1;
                         end
                     else
                         if paramde[1]=1 then begin
                             posiciones.campo[definit[1]].pri:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[1]].pri:=1;
                         end
                         else begin
                             posiciones.campo[definit[1]].sec:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[1]].pri:=1;
                         end;
                 end
                 else if turnoactual=azul then begin
                     if paramde[1]>10 then
                         if paramde[1]=11 then begin
                             posiciones.cfinal[definit[1]].azul.pri:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[1]].pri:=2;
                         end
                         else begin
                             posiciones.cfinal[definit[1]].azul.sec:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[1]].pri:=2;
                         end
                     else
                         if paramde[1]=1 then begin
                             posiciones.campo[definit[1]].pri:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[1]].pri:=2;
                         end
                         else begin
                             posiciones.campo[definit[1]].sec:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[1]].pri:=2;
                         end;
                 end
                 else if turnoactual=amarillo then begin
                     if paramde[1]>10 then
                         if paramde[1]=11 then begin
                             posiciones.cfinal[definit[1]].amarillo.pri:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[1]].pri:=3;
                         end
                         else begin
                             posiciones.cfinal[definit[1]].amarillo.sec:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[1]].pri:=3;
                         end
                     else
                         if paramde[1]=1 then begin
                             posiciones.campo[definit[1]].pri:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[1]].pri:=3;
                         end
                         else begin
                             posiciones.campo[definit[1]].sec:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[1]].pri:=3;
                         end;
                 end
                 else if turnoactual=verde then begin
                     if paramde[1]>10 then
                         if paramde[1]=11 then begin
                             posiciones.cfinal[definit[1]].verde.pri:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[1]].pri:=4;
                         end
                         else begin
                             posiciones.cfinal[definit[1]].verde.sec:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[1]].pri:=4;
                         end
                     else
                         if paramde[1]=1 then begin
                             posiciones.campo[definit[1]].pri:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[1]].pri:=4;
                         end
                         else begin
                             posiciones.campo[definit[1]].sec:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[1]].pri:=4;
                         end;
                 end;
                 seleccion:=definit[1];
                 parametro:=paramde[1];
             end;
             if (k=3) then begin
                 entablero(posiciones);
                 gotoxy(x,y+1);
                 Textcolor(white);
                 TextBackground(black);
                 write(opcion1);
                 gotoxy(x,y+2);
                 Textcolor(white);
                 TextBackground(black);
                 write(opcion2);
                 gotoxy(x,y+3);
                 Textcolor(white);
                 TextBackground(cyan);
                 write(opcion3);
                 gotoxy(x,y+4);
                 Textcolor(white);
                 TextBackground(black);
                 write(opcion4);
                 if turnoactual=rojo then begin
                     if paramde[2]>10 then
                         if paramde[2]=11 then begin
                             posiciones.cfinal[definit[2]].rojo.pri:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[2]].pri:=1;
                         end
                         else begin
                             posiciones.cfinal[definit[2]].rojo.sec:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[2]].pri:=1;
                         end
                     else
                         if paramde[2]=1 then begin
                             posiciones.campo[definit[2]].pri:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[2]].pri:=1;
                         end
                         else begin
                             posiciones.campo[definit[2]].sec:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[2]].pri:=1;
                         end;
                 end
                 else if turnoactual=azul then begin
                     if paramde[2]>10 then
                         if paramde[2]=11 then begin
                             posiciones.cfinal[definit[2]].azul.pri:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[2]].pri:=2;
                         end
                         else begin
                             posiciones.cfinal[definit[2]].azul.sec:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[2]].pri:=2;
                         end
                     else
                         if paramde[2]=1 then begin
                             posiciones.campo[definit[2]].pri:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[2]].pri:=2;
                         end
                         else begin
                             posiciones.campo[definit[2]].sec:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[2]].pri:=2;
                         end;
                 end
                 else if turnoactual=amarillo then begin
                     if paramde[2]>10 then
                         if paramde[2]=11 then begin
                             posiciones.cfinal[definit[2]].amarillo.pri:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[2]].pri:=3;
                         end
                         else begin
                             posiciones.cfinal[definit[2]].amarillo.sec:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[2]].pri:=3;
                         end
                     else
                         if paramde[2]=1 then begin
                             posiciones.campo[definit[2]].pri:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[2]].pri:=3;
                         end
                         else begin
                             posiciones.campo[definit[2]].sec:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[2]].pri:=3;
                         end;
                 end
                 else if turnoactual=verde then begin
                     if paramde[2]>10 then
                         if paramde[2]=11 then begin
                             posiciones.cfinal[definit[2]].verde.pri:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[2]].pri:=4;
                         end
                         else begin
                             posiciones.cfinal[definit[2]].verde.sec:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[2]].pri:=4;
                         end
                     else
                         if paramde[2]=1 then begin
                             posiciones.campo[definit[2]].pri:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[2]].pri:=4;
                         end
                         else begin
                             posiciones.campo[definit[2]].sec:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[2]].pri:=4;
                         end;
                 end;
                 seleccion:=definit[2];
                 parametro:=paramde[2];
             end;
             if (k=4) then begin
                 entablero(posiciones);
                 gotoxy(x,y+1);
                 Textcolor(white);
                 TextBackground(black);
                 write(opcion1);
                 gotoxy(x,y+2);
                 Textcolor(white);
                 TextBackground(black);
                 write(opcion2);
                 gotoxy(x,y+3);
                 Textcolor(white);
                 TextBackground(white);
                 write(opcion3);
                 gotoxy(x,y+4);
                 Textcolor(white);
                 TextBackground(cyan);
                 write(opcion4);
                 if turnoactual=rojo then begin
                     if paramde[3]>10 then
                         if paramde[3]=11 then begin
                             posiciones.cfinal[definit[3]].rojo.pri:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[3]].pri:=1;
                         end
                         else begin
                             posiciones.cfinal[definit[3]].rojo.sec:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[3]].pri:=1;
                         end
                     else
                         if paramde[3]=1 then begin
                             posiciones.campo[definit[3]].pri:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[3]].pri:=1;
                         end
                         else begin
                             posiciones.campo[definit[3]].sec:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[3]].pri:=1;
                         end;
                 end
                 else if turnoactual=azul then begin
                     if paramde[3]>10 then
                         if paramde[3]=11 then begin
                             posiciones.cfinal[definit[3]].azul.pri:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[3]].pri:=2;
                         end
                         else begin
                             posiciones.cfinal[definit[3]].azul.sec:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[3]].pri:=2;
                         end
                     else
                         if paramde[3]=1 then begin
                             posiciones.campo[definit[3]].pri:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[3]].pri:=2;
                         end
                         else begin
                             posiciones.campo[definit[3]].sec:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[3]].pri:=2;
                         end;
                 end
                 else if turnoactual=amarillo then begin
                     if paramde[3]>10 then
                         if paramde[3]=11 then begin
                             posiciones.cfinal[definit[3]].amarillo.pri:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[3]].pri:=3;
                         end
                         else begin
                             posiciones.cfinal[definit[3]].amarillo.sec:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[3]].pri:=3;
                         end
                     else
                         if paramde[3]=1 then begin
                             posiciones.campo[definit[3]].pri:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[3]].pri:=3;
                         end
                         else begin
                             posiciones.campo[definit[3]].sec:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[3]].pri:=3;
                         end;
                 end
                 else if turnoactual=verde then begin
                     if paramde[3]>10 then
                         if paramde[3]=11 then begin
                             posiciones.cfinal[definit[3]].verde.pri:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[3]].pri:=4;
                         end
                         else begin
                             posiciones.cfinal[definit[3]].verde.sec:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[3]].pri:=4;
                         end
                     else
                         if paramde[3]=1 then begin
                             posiciones.campo[definit[3]].pri:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[3]].pri:=4;
                         end
                         else begin
                             posiciones.campo[definit[3]].sec:=5;
                             entablero(posiciones);
                             posiciones.campo[definit[3]].pri:=4;
                         end;
                 end;
                 entablero(posiciones);
                 seleccion:=definit[3];
                 parametro:=paramde[3];
             end;
             ch:=ReadKey;
             if (ch=#72) then
                 if k<>1 then
                     k:=k-1;
             if ch=#80 then
                 if k<>cant then
                     k:=k+1;
         until ch=#13; //enter
         {Post : TRUE}
     end;

    function quedanfichas(
        posiciones   : tipoposiciones; // Tipo de posiciones de las fichas
        turnoactual  : tColores        // Color del turno actual
        ) : boolean; // Función para comprobar si quedan fichas en las casas
      var x : integer; // Variable de iteración
      begin
         { Pre: ( %exists i | i %in tColores : i )=turnoactual }
          if turnoactual=rojo then begin
              quedanfichas:=false;
              for x:=1 to 4 do
                  quedanfichas:=(quedanfichas or (posiciones.casa[x].rojo<>0));
          end;
          if turnoactual=azul then begin
              quedanfichas:=false;
              for x:=1 to 4 do
                  quedanfichas:=(quedanfichas or (posiciones.casa[x].azul<>0));
          end;
          if turnoactual=amarillo then begin
              quedanfichas:=false;
              for x:=1 to 4 do
                  quedanfichas:=(quedanfichas or (posiciones.casa[x].amarillo<>0));
          end;
          if turnoactual=verde then begin
              quedanfichas:=false;
              for x:=1 to 4 do
                  quedanfichas:=(quedanfichas or (posiciones.casa[x].verde<>0));
          end;
         { Post: (turnoactual=rojo => ( %forall i | 1<=i<=4 : posiciones.casa[i].rojo )=0)
                 => quedanfichas==true )
                 /\ (turnoactual=azul => ( %forall i | 1<=i<=4 : posiciones.casa[i].azul )=0)
                 => quedanfichas==true )
                 /\ (turnoactual=amarillo => ( %forall i | 1<=i<=4 : posiciones.casa[i].amarillo )=0)
                 => quedanfichas==true )
                 /\ (turnoactual=verde => ( %forall i | 1<=i<=4 : posiciones.casa[i].verde )=0)
                 => quedanfichas==true ) }
      end;

    procedure CalculaPosicion(
        turnoactual  : tColores; // Color del turno actual
        var amover   : integer;  // Cantidad de espacios que se va a mover la ficha
        var posicion : integer;  // Posición actual de la ficha
        var parametro: integer   // Parámetro que indica en qué parte del tablero
                                 // se encuentra la ficha
        ); // Procedimiento para comprobar si quedan fichas en las casas
      var 
          entrada : boolean; // Indica si una ficha está o no en la entrada del
                             // pasillo
      begin
         { Pre:  TRUE}
          if turnoactual=rojo then
              entrada:=(posicion=pasillorojo);
          if turnoactual=azul then
              entrada:=(posicion=pasilloazul);
          if turnoactual=amarillo then
              entrada:=(posicion=pasilloamarillo);
          if turnoactual=verde then
              entrada:=(posicion=pasilloverde);
          if amover<>0 then
              if entrada then begin
                amover:=amover-1;
                posicion:=1;
                parametro:=12;
                calculaposicion(turnoactual,amover,posicion,parametro);
              end
              else
                  if (parametro>10) then
                    if  (posicion>=7) then begin
                        amover:=amover-1;
                        posicion:=posicion+1;
                        parametro:=50;
                        calculaposicion(turnoactual,amover,posicion,parametro);
                    end
                    else begin
                        amover:=amover-1;
                        posicion:=posicion+1;
                        calculaposicion(turnoactual,amover,posicion,parametro);
                    end
                  else begin
                        amover:=amover-1;
                        posicion:=posicion+1;
                        if posicion>68 then
                            posicion:=posicion-68;
                        calculaposicion(turnoactual,amover,posicion,parametro);
                  end
           else begin
               Posicion:=posicion;
               parametro:=parametro;
           end;
         { Post: TRUE}
      end;

    function HayDos(
      turnoactual      : tColores;       // Color del turno actual
      posiciones       : tipoposiciones; // Posiciones de las fichas
      posicion         : integer;        // posicion actual a evaluar
      parametro        : integer;        // Parámetro que indica en qué parte del
                                         // tablero se encuentra la ficha
      especifica       : boolean         // Variable para determinar si se desea
                                         // buscar algun color de barrera especifico
      ): boolean; // Comprueba si hay una barrera en una casilla
        VAR
            i         : integer; // Variable de iteración 
            contando  : integer; //
            color     : integer; //
        begin
        {Pre: TRUE}
            if not (especifica) then
              begin
               if parametro<10 then
                   HayDos:=
                   ((posiciones.campo[posicion].pri=posiciones.campo[posicion].sec)
                   and (posiciones.campo[posicion].pri<>0))
               else if parametro=50 then
                   HayDos:=false
               else if parametro>10 then
                   if turnoactual=rojo then
                       HayDos:=((posiciones.cfinal[posicion].rojo.pri
                       =posiciones.cfinal[posicion].rojo.sec) and 
                       (posiciones.cfinal[posicion].rojo.pri<>0))
                   else if turnoactual=azul then
                       HayDos:=((posiciones.cfinal[posicion].azul.pri
                       =posiciones.cfinal[posicion].azul.sec) and 
                       (posiciones.cfinal[posicion].azul.pri<>0))
                   else if turnoactual=amarillo then
                       HayDos:=((posiciones.cfinal[posicion].amarillo.pri
                       =posiciones.cfinal[posicion].amarillo.sec) and 
                       (posiciones.cfinal[posicion].amarillo.pri<>0))
                   else if turnoactual=verde then
                       HayDos:=((posiciones.cfinal[posicion].verde.pri
                       =posiciones.cfinal[posicion].verde.sec) and 
                       (posiciones.cfinal[posicion].verde.pri<>0));
              end
            else begin
               if parametro<10 then begin
                   if turnoactual=rojo then
                       color:=1;
                   if turnoactual=azul then
                       color:=2;
                   if turnoactual=amarillo then
                       color:=3;
                   if turnoactual=verde then
                       color:=4;
                   HayDos:=((posiciones.campo[posicion].pri=posiciones.campo[posicion].sec)
                   and (posiciones.campo[posicion].pri=color));
               end
               else if parametro=50 then
                   HayDos:=false
               else if parametro>10 then
                   if turnoactual=rojo then
                       HayDos:=((posiciones.cfinal[posicion].rojo.pri
                       =posiciones.cfinal[posicion].rojo.sec) and 
                       (posiciones.cfinal[posicion].rojo.pri=1))
                   else if turnoactual=azul then
                       HayDos:=((posiciones.cfinal[posicion].azul.pri
                       =posiciones.cfinal[posicion].azul.sec) and 
                       (posiciones.cfinal[posicion].azul.pri=2))
                   else if turnoactual=amarillo then
                       HayDos:=((posiciones.cfinal[posicion].amarillo.pri
                       =posiciones.cfinal[posicion].amarillo.sec) and 
                       (posiciones.cfinal[posicion].amarillo.pri=3))
                   else if turnoactual=verde then
                       HayDos:=((posiciones.cfinal[posicion].verde.pri
                       =posiciones.cfinal[posicion].verde.sec) and 
                       (posiciones.cfinal[posicion].verde.pri=4))
               end;
               {Post: TRUE}
        end;

    procedure BuscarBarrera(
      posiciones       : tipoposiciones;   // Posiciones de las fichas
      turnoactual      : tColores;         // Color del turno actual
      var barrerasjug  : array of integer; // Posiciones de las barreras del jugador
      var parambarre   : array of integer  // Indica si la barrera se encuentra
                                           // en un pasillo o en el campo
      );  // Busca las barreras del color turnoactual
        VAR
            i,j       : integer; // Variables de iteración
            posicion  : integer;
            contando  : integer;
            parametro : integer;
        begin
        {Pre: TRUE}
           j:=0;
           parametro:=1;
           for i:=0 to 70 do begin //desde la salida hasta la casilla antes de meta.
           if turnoactual=rojo then
               posicion:=salidarojo;
           if turnoactual=azul then
               posicion:=salidaazul;
           if turnoactual=amarillo then
               posicion:=salidaamarillo;
           if turnoactual=verde then
               posicion:=salidaverde;
               contando:=i;
               calculaposicion(turnoactual,contando,posicion,parametro);
               if HayDos(turnoactual,posiciones,posicion,parametro,true) then begin
                   barrerasjug[j]:=Posicion;
                   parambarre[j]:=parametro;  //error aqui
                   j:=j+1;
               end;
          end;
          {Post: TRUE}
        end;

    function ComprobarBarrera( 
      posiciones       : tipoposiciones; // Posiciones de las fichas
      turnoactual      : tColores;       // Color del turno actual
      loquecuenta      : integer;        // Cantidad de espacios que se mueve la ficha
      posicioninicial  : integer;        // Posición inicial de la ficha que se mueve
      parametro        : integer         // Indica si la ficha se encuentra en un 
                                         // pasillo o en el campo
      ): boolean; // Indica si hay barreras en el rango de movimiento de la ficha
        VAR
            i         : integer; // Variable de iteración
            posicion  : integer; // Posicion a buscar barrera
            contando  : integer; // Iterado de posiciones
        begin
        {Pre: TRUE}
           ComprobarBarrera:=false;
           for i:=1 to loquecuenta do begin
               posicion:=posicioninicial;
               contando:=i;
               calculaposicion(turnoactual,contando,posicion,parametro);
               ComprobarBarrera:=ComprobarBarrera or HayDos(turnoactual,posiciones,posicion,parametro,false);
           end;
           {Post TRUE}
        end;

    procedure moverficha(
      var historico   : informativo;    // Texto que informa lo que ha sucedido
                                        // en la partida
      var posiciones  : tipoposiciones; // Posiciones de las fichas
          turnoactual : tColores;       // Color del turno actual
                posin : integer;        // Posición inicial de la ficha
            parametro : integer;        // Indica en qué lugar del tablero se
                                        // encuentra la ficha
               amover : integer;        // Cuánto se mueve la ficha
      var      comio  : boolean         // Indica si la ficha comió en el turno
     ); // Mueve una ficha de posin a posfi dentro del campo
     VAR
     posgraficas : tipoposiciones; // para mostrar el movimiento
     posicion    : integer;        // 
     i,j         : integer;        // Variables de iteración
     pinicial    : integer;        // Parámetro inicial
     turnojugador: integer;        //
     BEGIN
     //muestra el movimiento.
     {PRE TRUE}
        pinicial:=parametro;
        posgraficas:=posiciones;
        if turnoactual=rojo then
            turnojugador:=1
        else if turnoactual=azul then
            turnojugador:=2
        else if turnoactual=amarillo then
            turnojugador:=3
        else if turnoactual=verde then
            turnojugador:=4;
        for j:=1 to amover do begin
            posicion:=posin;
            i:=j;
            if turnoactual=rojo then begin
                if parametro<10 then
                    posgraficas.campo[posicion].pri:=5
                    else
                    posgraficas.cfinal[posicion].rojo.pri:=5;
                calculaposicion(turnoactual,i,posicion,parametro);
                if parametro<10 then
                    posgraficas.campo[posicion].pri:=5
                else
                    posgraficas.cfinal[posicion].rojo.pri:=5;
                entablero(posgraficas);
                delay(100);
                end
            else if turnoactual=azul then begin
                if parametro<10 then
                    posgraficas.campo[posicion].pri:=5
                    else
                    posgraficas.cfinal[posicion].azul.pri:=5;
                calculaposicion(turnoactual,i,posicion,parametro);
                if parametro<10 then
                    posgraficas.campo[posicion].pri:=5
                else
                    posgraficas.cfinal[posicion].azul.pri:=5;
                entablero(posgraficas);
                delay(100);
            end
            else if turnoactual=amarillo then begin
                if parametro<10 then
                    posgraficas.campo[posicion].pri:=5
                    else
                    posgraficas.cfinal[posicion].amarillo.pri:=5;
                calculaposicion(turnoactual,i,posicion,parametro);
                if parametro<10 then
                    posgraficas.campo[posicion].pri:=5
                else
                    posgraficas.cfinal[posicion].amarillo.pri:=5;
                entablero(posgraficas);
                delay(100);
            end
            else if turnoactual=verde then begin
                if parametro<10 then
                    posgraficas.campo[posicion].pri:=5
                    else
                    posgraficas.cfinal[posicion].verde.pri:=5;
                calculaposicion(turnoactual,i,posicion,parametro);
                if parametro<10 then
                    posgraficas.campo[posicion].pri:=5
                else
                    posgraficas.cfinal[posicion].verde.pri:=5;
                entablero(posgraficas);
                delay(100);
            end;
        delay(150);
        end;
     (* Inicio del caso rojo*)
        if turnoactual=rojo then begin
                    posicion:=posin;
        calculaposicion(turnoactual,amover,posicion,parametro);
            if parametro<10 then begin
            //caso en casillas neutras
                if posiciones.campo[Posicion].pri=0 then //caso primera casilla vacia
                    if pinicial=1 then begin
                        posiciones.campo[posicion].pri:=posiciones.campo[posin].pri;
                        posiciones.campo[posin].pri:=posiciones.campo[posin].sec;
                        posiciones.campo[posin].sec:=0;
                    end
                    else begin
                        posiciones.campo[posicion].pri:=posiciones.campo[posin].sec;
                        posiciones.campo[posin].sec:=0;
                    end
                else if posiciones.campo[posicion].pri<>0 then begin 
                //casos pri casilla ocupada
                    if (posiciones.campo[posicion].pri<>turnojugador) then begin
                     //diferente al jugador
                     //caso no seguros
                        if (posicion<>salidarojo) and (posicion<>salidaazul) and 
                        (posicion<>salidaamarillo) and (posicion<>salidaverde) and
                        (posicion<>seguro4) and (posicion<>seguro3) and 
                        (posicion<>seguro2) and (posicion<>seguro1) then begin
                        
                             if pinicial=1 then begin
                                 comio:=true;
                                 comerficha(historico,posiciones,
                                 turnoactual,posin,Posicion,pinicial,parametro);
                                 posiciones.campo[posin].pri:=posiciones.campo[posin].sec;
                                 posiciones.campo[posin].sec:=0;
                             end
                             else begin
                                 comio:=true;
                                 comerficha(historico,posiciones,
                                 turnoactual,posin,Posicion,pinicial,parametro);
                                 posiciones.campo[posin].sec:=0;
                             end;
                        end
                    //casos en los seguros
                        else begin
                            if pinicial=1 then begin
                                posiciones.campo[posicion].sec:=posiciones.campo[posin].pri;
                                posiciones.campo[posin].pri:=posiciones.campo[posin].sec;
                                posiciones.campo[posin].sec:=0;
                            end
                            else begin
                                posiciones.campo[posicion].sec:=posiciones.campo[posin].sec;
                                posiciones.campo[posin].sec:=0;
                            end;
                        end;
                    end
                    else if posiciones.campo[posicion].pri=turnojugador then begin
                    //diferente de cero igual al jugador
                      if posiciones.campo[Posicion].sec=0 then //caso segunda casilla vacia
                          if pinicial=1 then begin
                              posiciones.campo[posicion].sec:=posiciones.campo[posin].pri;
                              posiciones.campo[posin].pri:=posiciones.campo[posin].sec;
                              posiciones.campo[posin].sec:=0;
                          end
                          else begin
                            posiciones.campo[posicion].sec:=posiciones.campo[posin].sec;
                            posiciones.campo[posin].sec:=0;
                          end
                      else if posiciones.campo[posicion].sec<>0 then begin 
                      //casos pri casilla ocupada
                      //cuando no es una barrera ni esta en seguro
                        if (posiciones.campo[posicion].sec<>turnojugador) and 
                           (posicion<>salidarojo) and (posicion<>salidaazul) and 
                           (posicion<>salidaamarillo) and (posicion<>salidaverde) and
                           (posicion<>seguro4) and (posicion<>seguro3) and 
                           (posicion<>seguro2) and (posicion<>seguro1) then begin
                              if pinicial=1 then begin
                                  comio:=true;
                                  comerficha(historico,posiciones,
                                  turnoactual,posin,Posicion,pinicial,parametro);
                                  posiciones.campo[posin].pri:=posiciones.campo[posin].sec;
                                  posiciones.campo[posin].sec:=0;
                              end
                              else begin
                                  comio:=true;
                                  comerficha(historico,posiciones,
                                  turnoactual,posin,Posicion,pinicial,parametro);
                                  posiciones.campo[posin].sec:=0;
                                   end;
                              end;
                        end;
                    end;
                end;
            end
           //caso en la meta
            else if parametro=50 then begin
                if posiciones.meta[1].rojo=0 then
                    posiciones.meta[1].rojo:=1
                else if posiciones.meta[2].rojo=0 then
                    posiciones.meta[2].rojo:=1 
                else if posiciones.meta[3].rojo=0 then
                    posiciones.meta[3].rojo:=1 
                else if posiciones.meta[4].rojo=0 then
                    posiciones.meta[4].rojo:=1;
                if pinicial=1 then begin
                    posiciones.campo[posin].pri:=posiciones.campo[posin].sec;
                    posiciones.campo[posin].sec:=0;
                end
                else if pinicial=2 then begin
                    posiciones.campo[posin].sec:=0;
                end
                else if pinicial=11 then begin
                    posiciones.cfinal[posin].rojo.pri:=posiciones.cfinal[posin].rojo.sec;
                    posiciones.cfinal[posin].rojo.sec:=0;
                end
                else if pinicial=12 then
                    posiciones.cfinal[posin].rojo.sec:=0;
            end
            //caso en el pasillo
            else if parametro>10 then begin
                if pinicial>10 then begin
                        if posiciones.cfinal[Posicion].rojo.pri=0 then //caso 
                        //primera casilla vacia
                              if pinicial=11 then begin
                                  posiciones.cfinal[Posicion].rojo.pri:=
                                  posiciones.cfinal[posin].rojo.pri;
                                  posiciones.cfinal[posin].rojo.pri:=
                                  posiciones.cfinal[posin].rojo.sec;
                                  posiciones.cfinal[posin].rojo.sec:=0;
                              end
                              else begin
                                posiciones.cfinal[Posicion].rojo.pri:=
                                posiciones.cfinal[posin].rojo.sec;
                                posiciones.cfinal[posin].rojo.sec:=0;
                              end
                          else if posiciones.cfinal[Posicion].rojo.pri<>0 then begin 
                          //casos pri casilla ocupada
                              if pinicial=11 then begin
                                  posiciones.cfinal[Posicion].rojo.sec:=
                                  posiciones.cfinal[posin].rojo.pri;
                                  posiciones.cfinal[posin].rojo.pri:=
                                  posiciones.cfinal[posin].rojo.sec;
                                  posiciones.cfinal[posin].rojo.sec:=0;
                              end
                              else begin
                                  posiciones.cfinal[Posicion].rojo.sec:=
                                  posiciones.cfinal[posin].rojo.pri;
                                  posiciones.cfinal[posin].rojo.sec:=0;
                                  end;
                             end;
                end
                else if pinicial<10 then begin
                        if posiciones.cfinal[Posicion].rojo.pri=0 then
                         //caso primera casilla vacia
                              if pinicial=1 then begin
                                  posiciones.cfinal[Posicion].rojo.pri:=
                                  posiciones.campo[posin].pri;
                                  posiciones.campo[posin].pri:=
                                  posiciones.campo[posin].sec;
                                  posiciones.campo[posin].sec:=0;
                              end
                              else begin
                                posiciones.cfinal[Posicion].rojo.pri:=
                                posiciones.campo[posin].sec;
                                posiciones.campo[posin].sec:=0;
                              end
                          else if posiciones.cfinal[Posicion].rojo.pri<>0 then 
                          begin 
                          //casos pri casilla ocupada
                              if pinicial=1 then begin
                                  posiciones.cfinal[Posicion].rojo.sec:=
                                  posiciones.campo[posin].pri;
                                  posiciones.campo[posin].pri:=
                                  posiciones.campo[posin].sec;
                                  posiciones.campo[posin].sec:=0;
                              end
                              else begin
                                  posiciones.cfinal[Posicion].rojo.sec:=
                                  posiciones.campo[posin].sec;
                                  posiciones.campo[posin].sec:=0;
                                  end;
                             end;
                end;
            end;
                    end;
     (* Fin del caso rojo e inicio del caso azul*)
        if turnoactual=azul then begin
                posicion:=posin;
        calculaposicion(azul,amover,posicion,parametro);
            if parametro<10 then begin
            //caso en casillas neutras
                if posiciones.campo[Posicion].pri=0 then //caso primera casilla vacia
                    if pinicial=1 then begin
                        posiciones.campo[posicion].pri:=posiciones.campo[posin].pri;
                        posiciones.campo[posin].pri:=posiciones.campo[posin].sec;
                        posiciones.campo[posin].sec:=0;
                    end
                    else begin
                        posiciones.campo[posicion].pri:=posiciones.campo[posin].sec;
                        posiciones.campo[posin].sec:=0;
                    end
                else if posiciones.campo[posicion].pri<>0 then begin 
                //casos pri casilla ocupada
                    if (posiciones.campo[posicion].pri<>turnojugador) then begin
                     //diferente al jugador
                     //caso no seguros
                        if (posicion<>salidarojo) and (posicion<>salidaazul) and 
                        (posicion<>salidaamarillo) and (posicion<>salidaverde) and
                        (posicion<>seguro4) and (posicion<>seguro3) and 
                        (posicion<>seguro2) and (posicion<>seguro1) then begin
                        
                             if pinicial=1 then begin
                                 comio:=true;
                                 comerficha(historico,posiciones,
                                 turnoactual,posin,Posicion,pinicial,parametro);
                                 posiciones.campo[posin].pri:=
                                 posiciones.campo[posin].sec;
                                 posiciones.campo[posin].sec:=0;
                             end
                             else begin
                                 comio:=true;
                                 comerficha(historico,posiciones,
                                 turnoactual,posin,Posicion,pinicial,parametro);
                                 posiciones.campo[posin].sec:=0;
                             end;
                        end
                    //casos en los seguros
                        else begin
                            if pinicial=1 then begin
                                posiciones.campo[posicion].sec:=
                                posiciones.campo[posin].pri;
                                posiciones.campo[posin].pri:=
                                posiciones.campo[posin].sec;
                                posiciones.campo[posin].sec:=0;
                            end
                            else begin
                                posiciones.campo[posicion].sec:=
                                posiciones.campo[posin].sec;
                                posiciones.campo[posin].sec:=0;
                            end;
                        end;
                    end
                    else if posiciones.campo[posicion].pri=turnojugador then begin
                    //diferente de cero igual al jugador
                      if posiciones.campo[Posicion].sec=0 then //caso segunda casilla vacia
                          if pinicial=1 then begin
                              posiciones.campo[posicion].sec:=posiciones.campo[posin].pri;
                              posiciones.campo[posin].pri:=posiciones.campo[posin].sec;
                              posiciones.campo[posin].sec:=0;
                          end
                          else begin
                            posiciones.campo[posicion].sec:=posiciones.campo[posin].sec;
                            posiciones.campo[posin].sec:=0;
                          end
                      else if posiciones.campo[posicion].sec<>0 then begin 
                      //casos pri casilla ocupada
                      //cuando no es una barrera ni esta en seguro
                        if (posiciones.campo[posicion].sec<>turnojugador) and 
                           (posicion<>salidarojo) and (posicion<>salidaazul) and 
                           (posicion<>salidaamarillo) and (posicion<>salidaverde) and
                           (posicion<>seguro4) and (posicion<>seguro3) and 
                           (posicion<>seguro2) and (posicion<>seguro1) then begin
                              if pinicial=1 then begin
                                  comio:=true;
                                  comerficha(historico,posiciones,
                                  turnoactual,posin,Posicion,pinicial,parametro);
                                  posiciones.campo[posin].pri:=posiciones.campo[posin].sec;
                                  posiciones.campo[posin].sec:=0;
                              end
                              else begin
                                  comio:=true;
                                  comerficha(historico,posiciones,
                                  turnoactual,posin,Posicion,pinicial,parametro);
                                  posiciones.campo[posin].sec:=0;
                                   end;
                              end;
                        end;
                    end;
                end;
            end
           //caso en la meta
            else if parametro=50 then begin
                if posiciones.meta[1].azul=0 then
                    posiciones.meta[1].azul:=2
                else if posiciones.meta[2].azul=0 then
                    posiciones.meta[2].azul:=2 
                else if posiciones.meta[3].azul=0 then
                    posiciones.meta[3].azul:=2 
                else if posiciones.meta[4].azul=0 then
                    posiciones.meta[4].azul:=2;
                if pinicial=1 then begin
                    posiciones.campo[posin].pri:=posiciones.campo[posin].sec;
                    posiciones.campo[posin].sec:=0;
                end
                else if pinicial=2 then begin
                    posiciones.campo[posin].sec:=0;
                end
                else if pinicial=11 then begin
                    posiciones.cfinal[posin].azul.pri:=
                    posiciones.cfinal[posin].azul.sec;
                    posiciones.cfinal[posin].azul.sec:=0;
                end
                else if pinicial=12 then
                    posiciones.cfinal[posin].azul.sec:=0;
            end
            //caso en el pasillo
            else if parametro>10 then begin
                if pinicial>10 then begin
                        if posiciones.cfinal[Posicion].azul.pri=0 then 
                        //caso primera casilla vacia
                              if pinicial=11 then begin
                                  posiciones.cfinal[Posicion].azul.pri:=
                                  posiciones.cfinal[posin].azul.pri;
                                  posiciones.cfinal[posin].azul.pri:=
                                  posiciones.cfinal[posin].azul.sec;
                                  posiciones.cfinal[posin].azul.sec:=0;
                              end
                              else begin
                                posiciones.cfinal[Posicion].azul.pri:=
                                posiciones.cfinal[posin].azul.sec;
                                posiciones.cfinal[posin].azul.sec:=0;
                              end
                          else if posiciones.cfinal[Posicion].azul.pri<>0 then begin 
                          //casos pri casilla ocupada
                              if pinicial=11 then begin
                                  posiciones.cfinal[Posicion].azul.sec:=
                                  posiciones.cfinal[posin].azul.pri;
                                  posiciones.cfinal[posin].azul.pri:=
                                  posiciones.cfinal[posin].azul.sec;
                                  posiciones.cfinal[posin].azul.sec:=0;
                              end
                              else begin
                                  posiciones.cfinal[Posicion].azul.sec:=
                                  posiciones.cfinal[posin].azul.pri;
                                  posiciones.cfinal[posin].azul.sec:=0;
                                  end;
                             end;
                end
                else if pinicial<10 then begin
                        if posiciones.cfinal[Posicion].azul.pri=0 then 
                        //caso primera casilla vacia
                              if pinicial=1 then begin
                                  posiciones.cfinal[Posicion].azul.pri:=
                                  posiciones.campo[posin].pri;
                                  posiciones.campo[posin].pri:=
                                  posiciones.campo[posin].sec;
                                  posiciones.campo[posin].sec:=0;
                              end
                              else begin
                                posiciones.cfinal[Posicion].azul.pri:=
                                posiciones.campo[posin].sec;
                                posiciones.campo[posin].sec:=0;
                              end
                          else if posiciones.cfinal[Posicion].azul.pri<>0 then begin 
                          //casos pri casilla ocupada
                              if pinicial=1 then begin
                                  posiciones.cfinal[Posicion].azul.sec:=
                                  posiciones.campo[posin].pri;
                                  posiciones.campo[posin].pri:=
                                  posiciones.campo[posin].sec;
                                  posiciones.campo[posin].sec:=0;
                              end
                              else begin
                                  posiciones.cfinal[Posicion].azul.sec:=
                                  posiciones.campo[posin].sec;
                                  posiciones.campo[posin].sec:=0;
                                  end;
                             end;
                end;
            end;
            end;
     (* Fin del caso azul e inicio del caso amarillo *)
        posicion:=posin;
        calculaposicion(turnoactual,amover,posicion,parametro);
        if turnoactual=amarillo then
            if parametro<10 then begin
            //caso en casillas neutras
                if posiciones.campo[Posicion].pri=0 then //caso primera casilla vacia
                    if pinicial=1 then begin
                        posiciones.campo[posicion].pri:=posiciones.campo[posin].pri;
                        posiciones.campo[posin].pri:=posiciones.campo[posin].sec;
                        posiciones.campo[posin].sec:=0;
                    end
                    else begin
                        posiciones.campo[posicion].pri:=posiciones.campo[posin].sec;
                        posiciones.campo[posin].sec:=0;
                    end
                else if posiciones.campo[posicion].pri<>0 then begin 
                //casos pri casilla ocupada
                    if (posiciones.campo[posicion].pri<>turnojugador) then begin
                     //diferente al jugador
                     //caso no seguros
                        if (posicion<>salidarojo) and (posicion<>salidaazul) and 
                        (posicion<>salidaamarillo) and (posicion<>salidaverde) and
                        (posicion<>seguro4) and (posicion<>seguro3) and 
                        (posicion<>seguro2) and (posicion<>seguro1) then begin
                        
                             if pinicial=1 then begin
                                 comio:=true;
                                 comerficha(historico,posiciones,
                                 turnoactual,posin,Posicion,pinicial,parametro);
                                 posiciones.campo[posin].pri:=
                                 posiciones.campo[posin].sec;
                                 posiciones.campo[posin].sec:=0;
                             end
                             else begin
                                 comio:=true;
                                 comerficha(historico,posiciones,
                                 turnoactual,posin,Posicion,pinicial,parametro);
                                 posiciones.campo[posin].sec:=0;
                             end;
                        end
                    //casos en los seguros
                        else begin
                            if pinicial=1 then begin
                                posiciones.campo[posicion].sec:=
                                posiciones.campo[posin].pri;
                                posiciones.campo[posin].pri:=
                                posiciones.campo[posin].sec;
                                posiciones.campo[posin].sec:=0;
                            end
                            else begin
                                posiciones.campo[posicion].sec:=
                                posiciones.campo[posin].sec;
                                posiciones.campo[posin].sec:=0;
                            end;
                        end;
                    end
                    else if posiciones.campo[posicion].pri=turnojugador then begin
                    //diferente de cero igual al jugador
                      if posiciones.campo[Posicion].sec=0 then //caso segunda casilla vacia
                          if pinicial=1 then begin
                              posiciones.campo[posicion].sec:=
                              posiciones.campo[posin].pri;
                              posiciones.campo[posin].pri:=
                              posiciones.campo[posin].sec;
                              posiciones.campo[posin].sec:=0;
                          end
                          else begin
                            posiciones.campo[posicion].sec:=
                            posiciones.campo[posin].sec;
                            posiciones.campo[posin].sec:=0;
                          end
                      else if posiciones.campo[posicion].sec<>0 then begin 
                      //casos pri casilla ocupada
                      //cuando no es una barrera ni esta en seguro
                        if (posiciones.campo[posicion].sec<>turnojugador) and 
                           (posicion<>salidarojo) and (posicion<>salidaazul) and 
                           (posicion<>salidaamarillo) and (posicion<>salidaverde) and
                           (posicion<>seguro4) and (posicion<>seguro3) and 
                           (posicion<>seguro2) and (posicion<>seguro1) then begin
                              if pinicial=1 then begin
                                  comio:=true;
                                  comerficha(historico,posiciones,
                                  turnoactual,posin,Posicion,pinicial,parametro);
                                  posiciones.campo[posin].pri:=
                                  posiciones.campo[posin].sec;
                                  posiciones.campo[posin].sec:=0;
                              end
                              else begin
                                  comio:=true;
                                  comerficha(historico,posiciones,
                                  turnoactual,posin,Posicion,pinicial,parametro);
                                  posiciones.campo[posin].sec:=0;
                                   end;
                              end;
                        end;
                    end;
                end;
            end
           //caso en la meta
            else if parametro=50 then begin
                if posiciones.meta[1].amarillo=0 then
                    posiciones.meta[1].amarillo:=3
                else if posiciones.meta[2].amarillo=0 then
                    posiciones.meta[2].amarillo:=3 
                else if posiciones.meta[3].amarillo=0 then
                    posiciones.meta[3].amarillo:=3 
                else if posiciones.meta[4].amarillo=0 then
                    posiciones.meta[4].amarillo:=3;
                if pinicial=1 then begin
                    posiciones.campo[posin].pri:=posiciones.campo[posin].sec;
                    posiciones.campo[posin].sec:=0;
                end
                else if pinicial=2 then begin
                    posiciones.campo[posin].sec:=0;
                end
                else if pinicial=11 then begin
                    posiciones.cfinal[posin].amarillo.pri:=
                    posiciones.cfinal[posin].amarillo.sec;
                    posiciones.cfinal[posin].amarillo.sec:=0;
                end
                else if pinicial=12 then
                    posiciones.cfinal[posin].amarillo.sec:=0;
            end
            //caso en el pasillo
            else if parametro>10 then begin
                if pinicial>10 then begin
                        if posiciones.cfinal[Posicion].amarillo.pri=0 then //caso primera casilla vacia
                              if pinicial=11 then begin
                                  posiciones.cfinal[Posicion].amarillo.pri:=
                                  posiciones.cfinal[posin].amarillo.pri;
                                  posiciones.cfinal[posin].amarillo.pri:=
                                  posiciones.cfinal[posin].amarillo.sec;
                                  posiciones.cfinal[posin].amarillo.sec:=0;
                              end
                              else begin
                                posiciones.cfinal[Posicion].amarillo.pri:=
                                posiciones.cfinal[posin].amarillo.sec;
                                posiciones.cfinal[posin].amarillo.sec:=0;
                              end
                          else if posiciones.cfinal[Posicion].amarillo.pri<>0 then begin 
                          //casos pri casilla ocupada
                              if pinicial=11 then begin
                                  posiciones.cfinal[Posicion].amarillo.sec:=
                                  posiciones.cfinal[posin].amarillo.pri;
                                  posiciones.cfinal[posin].amarillo.pri:=
                                  posiciones.cfinal[posin].amarillo.sec;
                                  posiciones.cfinal[posin].amarillo.sec:=0;
                              end
                              else begin
                                  posiciones.cfinal[Posicion].amarillo.sec:=
                                  posiciones.cfinal[posin].amarillo.pri;
                                  posiciones.cfinal[posin].amarillo.sec:=0;
                                  end;
                             end;
                end
                else if pinicial<10 then begin
                        if posiciones.cfinal[Posicion].amarillo.pri=0 then //caso primera casilla vacia
                              if pinicial=1 then begin
                                  posiciones.cfinal[Posicion].amarillo.pri:=
                                  posiciones.campo[posin].pri;
                                  posiciones.campo[posin].pri:=
                                  posiciones.campo[posin].sec;
                                  posiciones.campo[posin].sec:=0;
                              end
                              else begin
                                posiciones.cfinal[Posicion].amarillo.pri:=
                                posiciones.campo[posin].sec;
                                posiciones.campo[posin].sec:=0;
                              end
                          else if posiciones.cfinal[Posicion].amarillo.pri<>0 then begin 
                          //casos pri casilla ocupada
                              if pinicial=1 then begin
                                  posiciones.cfinal[Posicion].amarillo.sec:=
                                  posiciones.campo[posin].pri;
                                  posiciones.campo[posin].pri:=
                                  posiciones.campo[posin].sec;
                                  posiciones.campo[posin].sec:=0;
                              end
                              else begin
                                  posiciones.cfinal[Posicion].amarillo.sec:=
                                  posiciones.campo[posin].sec;
                                  posiciones.campo[posin].sec:=0;
                                  end;
                             end;
                end;
            end;
     (* Fin del caso amarillo e inicio del caso verde *)
        posicion:=posin;
        calculaposicion(turnoactual,amover,posicion,parametro);
        if turnoactual=verde then
            if parametro<10 then begin
            //caso en casillas neutras
                if posiciones.campo[Posicion].pri=0 then //caso primera casilla vacia
                    if pinicial=1 then begin
                        posiciones.campo[posicion].pri:=posiciones.campo[posin].pri;
                        posiciones.campo[posin].pri:=posiciones.campo[posin].sec;
                        posiciones.campo[posin].sec:=0;
                    end
                    else begin
                        posiciones.campo[posicion].pri:=posiciones.campo[posin].sec;
                        posiciones.campo[posin].sec:=0;
                    end
                else if posiciones.campo[posicion].pri<>0 then begin 
                //casos pri casilla ocupada
                    if (posiciones.campo[posicion].pri<>turnojugador) then begin
                     //diferente al jugador
                     //caso no seguros
                        if (posicion<>salidarojo) and (posicion<>salidaazul) and 
                        (posicion<>salidaamarillo) and (posicion<>salidaverde) and
                        (posicion<>seguro4) and (posicion<>seguro3) and 
                        (posicion<>seguro2) and (posicion<>seguro1) then begin
                        
                             if pinicial=1 then begin
                                 comio:=true;
                                 comerficha(historico,posiciones,
                                 turnoactual,posin,Posicion,pinicial,parametro);
                                 posiciones.campo[posin].pri:=
                                 posiciones.campo[posin].sec;
                                 posiciones.campo[posin].sec:=0;
                             end
                             else begin
                                 comio:=true;
                                 comerficha(historico,posiciones,
                                 turnoactual,posin,Posicion,pinicial,parametro);
                                 posiciones.campo[posin].sec:=0;
                             end;
                        end
                    //casos en los seguros
                        else begin
                            if pinicial=1 then begin
                                posiciones.campo[posicion].sec:=
                                posiciones.campo[posin].pri;
                                posiciones.campo[posin].pri:=
                                posiciones.campo[posin].sec;
                                posiciones.campo[posin].sec:=0;
                            end
                            else begin
                                posiciones.campo[posicion].sec:=
                                posiciones.campo[posin].sec;
                                posiciones.campo[posin].sec:=0;
                            end;
                        end;
                    end
                    else if posiciones.campo[posicion].pri=
                    turnojugador then begin
                    //diferente de cero igual al jugador
                      if posiciones.campo[Posicion].sec=0 then //caso segunda casilla vacia
                          if pinicial=1 then begin
                              posiciones.campo[posicion].sec:=
                              posiciones.campo[posin].pri;
                              posiciones.campo[posin].pri:=
                              posiciones.campo[posin].sec;
                              posiciones.campo[posin].sec:=0;
                          end
                          else begin
                            posiciones.campo[posicion].sec:=posiciones.campo[posin].sec;
                            posiciones.campo[posin].sec:=0;
                          end
                      else if posiciones.campo[posicion].sec<>0 then begin 
                      //casos pri casilla ocupada
                      //cuando no es una barrera ni esta en seguro
                        if (posiciones.campo[posicion].sec<>turnojugador) and 
                           (posicion<>salidarojo) and (posicion<>salidaazul) and 
                           (posicion<>salidaamarillo) and (posicion<>salidaverde) and
                           (posicion<>seguro4) and (posicion<>seguro3) and 
                           (posicion<>seguro2) and (posicion<>seguro1) then begin
                              if pinicial=1 then begin
                                  comio:=true;
                                  comerficha(historico,posiciones,
                                  turnoactual,posin,Posicion,pinicial,parametro);
                                  posiciones.campo[posin].pri:=
                                  posiciones.campo[posin].sec;
                                  posiciones.campo[posin].sec:=0;
                              end
                              else begin
                                  comio:=true;
                                  comerficha(historico,posiciones,
                                  turnoactual,posin,Posicion,pinicial,parametro);
                                  posiciones.campo[posin].sec:=0;
                                   end;
                              end;
                        end;
                    end;
                end;
            end
           //caso en la meta
            else if parametro=50 then begin
                if posiciones.meta[1].verde=0 then
                    posiciones.meta[1].verde:=4
                else if posiciones.meta[2].verde=0 then
                    posiciones.meta[2].verde:=4 
                else if posiciones.meta[3].verde=0 then
                    posiciones.meta[3].verde:=4
                else if posiciones.meta[4].verde=0 then
                    posiciones.meta[4].verde:=4;
                if pinicial=1 then begin
                    posiciones.campo[posin].pri:=posiciones.campo[posin].sec;
                    posiciones.campo[posin].sec:=0;
                end
                else if pinicial=2 then begin
                    posiciones.campo[posin].sec:=0;
                end
                else if pinicial=11 then begin
                    posiciones.cfinal[posin].verde.pri:=
                    posiciones.cfinal[posin].verde.sec;
                    posiciones.cfinal[posin].verde.sec:=0;
                end
                else if pinicial=12 then
                    posiciones.cfinal[posin].verde.sec:=0;
            end
            //caso en el pasillo
            else if parametro>10 then begin
                if pinicial>10 then begin
                        if posiciones.cfinal[Posicion].verde.pri=0 then //caso primera casilla vacia
                              if pinicial=11 then begin
                                  posiciones.cfinal[Posicion].verde.pri:=
                                  posiciones.cfinal[posin].verde.pri;
                                  posiciones.cfinal[posin].verde.pri:=
                                  posiciones.cfinal[posin].verde.sec;
                                  posiciones.cfinal[posin].verde.sec:=0;
                              end
                              else begin
                                posiciones.cfinal[Posicion].verde.pri:=
                                posiciones.cfinal[posin].verde.sec;
                                posiciones.cfinal[posin].verde.sec:=0;
                              end
                          else if posiciones.cfinal[Posicion].verde.pri<>0 then begin 
                          //casos pri casilla ocupada
                              if pinicial=11 then begin
                                  posiciones.cfinal[Posicion].verde.sec:=
                                  posiciones.cfinal[posin].verde.pri;
                                  posiciones.cfinal[posin].verde.pri:=
                                  posiciones.cfinal[posin].verde.sec;
                                  posiciones.cfinal[posin].verde.sec:=0;
                              end
                              else begin
                                  posiciones.cfinal[Posicion].verde.sec:=
                                  posiciones.cfinal[posin].verde.pri;
                                  posiciones.cfinal[posin].verde.sec:=0;
                                  end;
                             end;
                end
                else if pinicial<10 then begin
                        if posiciones.cfinal[Posicion].verde.pri=0 then //caso primera casilla vacia
                              if pinicial=1 then begin
                                  posiciones.cfinal[Posicion].verde.pri:=
                                  posiciones.campo[posin].pri;
                                  posiciones.campo[posin].pri:=
                                  posiciones.campo[posin].sec;
                                  posiciones.campo[posin].sec:=0;
                              end
                              else begin
                                posiciones.cfinal[Posicion].verde.pri:=
                                posiciones.campo[posin].sec;
                                posiciones.campo[posin].sec:=0;
                              end
                          else if posiciones.cfinal[Posicion].verde.pri<>0 then begin 
                          //casos pri casilla ocupada
                              if pinicial=1 then begin
                                  posiciones.cfinal[Posicion].verde.sec:=
                                  posiciones.campo[posin].pri;
                                  posiciones.campo[posin].pri:=
                                  posiciones.campo[posin].sec;
                                  posiciones.campo[posin].sec:=0;
                              end
                              else begin
                                  posiciones.cfinal[Posicion].verde.sec:=
                                  posiciones.campo[posin].sec;
                                  posiciones.campo[posin].sec:=0;
                                  end;
                             end;
                end;
            end;
     (* Fin del caso verde*)
        cambiartexto(historico,
        Completaconespacios(40,'El jugador '+ColorAStr(turnoactual)
        +' ha movido una ficha'));
        imprimirtexto(historico);
        delay(200);writeln('hi');
        entablero(posiciones);
        {POST: TRUE}
     END;  

    procedure movimientosposibles(
      var historico  : informativo;      // Texto que informa lo que ha sucedido
                                         // en la partida
      var posiciones : tipoposiciones;   // Tipo de posiciones de las fichas
          loquecuenta: integer;          // Cantidad de espacios que se puede mover
                                         // una ficha
      var seleccion  : integer;          // Seleccion de ficha
      var parametro  : integer;          // Parámetro que indica en qué parte del
                                         // tablero se encuentra la ficha
            erabarr  : integer;          // posicion de la barrera anterior
        turnoactual  : tColores;         // Color del turno actual
          esmaquina  : boolean;          // Variable para identificar si un jugador
                                         // es máquina
        sonbarreras  : boolean;          // si son barreras o no
        barrerasjug  : array of integer; // barreras del jugador 
        parambarre   : array of Integer  // parametros para ubicar las barreras
      ); // Procedimiento para mostrarle al usuario los movimientos posibles
      VAR 
          fichas   :   array[0..3] of integer; // arreglo con las fichas del turno
          param    :   array[0..3] of integer; // parametros
          posibl   :   array[0..3] of boolean; // si es posible o no moverla
          definit  :   array[0..3] of integer; // el definitivo luego de filtrar
          paramdef :   array[0..3] of integer; // definitivo luego de filtrar
          i,j,k    :   integer; // Variables de iteración
          amover   :   integer; // Cantidad de espacios que se mueve la ficha
          posicion :   integer; // posicion actual
          temparam :   integer; // variable temporal (parametro)
          hayopcio :   boolean; // si hay opcion para elegir
      begin
      {Pre: TRUE}
          for j:=0 to 3 do begin
              posibl[j]:=false;
              param[j]:=0;
              fichas[j]:=0;
              definit[j]:=0;
              paramdef[j]:=0;
          end;  
          j:=0;
          if not sonbarreras then begin
            //Detecta las fichas del turnoactual
            if turnoactual=rojo then begin
                for i:=1 to 68 do begin //para las neutrales
                    if posiciones.campo[i].pri=1 then begin
                        param[j]:=1;
                        fichas[j]:=i;
                        j:=j+1;
                    end;
                    if posiciones.campo[i].sec=1 then begin
                        param[j]:=2;
                        fichas[j]:=i;
                        j:=j+1;
                    end;
                end;
                for i:=1 to 7 do begin // para los pasillos
                    if posiciones.cfinal[i].rojo.pri=1 then begin
                        param[j]:=11;
                        fichas[j]:=i;
                        j:=j+1;
                    end;
                    if posiciones.cfinal[i].rojo.sec=1 then begin
                        if posiciones.cfinal[i].rojo.pri=1 then begin
                            param[j]:=12;
                            fichas[j]:=i;
                            j:=j+1;
                        end;
                    end;
                end;
            end
            else if turnoactual=azul then begin
                for i:=1 to 68 do begin //para las neutrales
                    if posiciones.campo[i].pri=2 then begin
                        param[j]:=2;
                        fichas[j]:=i;
                        j:=j+1;
                    end;
                    if posiciones.campo[i].sec=2 then begin
                        param[j]:=2;
                        fichas[j]:=i;
                        j:=j+1;
                    end;
                end;
                for i:=1 to 7 do begin // para los pasillos
                    if posiciones.cfinal[i].azul.pri=2 then begin
                        param[j]:=11;
                        fichas[j]:=i;
                        j:=j+1;
                    end;
                    if posiciones.cfinal[i].azul.sec=2 then begin
                        if posiciones.cfinal[i].azul.pri=2 then begin
                            param[j]:=12;
                            fichas[j]:=i;
                            j:=j+1;
                        end;
                    end;
                end;
            end
            else if turnoactual=amarillo then begin
                for i:=1 to 68 do begin //para las neutrales
                    if posiciones.campo[i].pri=3 then begin
                        param[j]:=1;
                        fichas[j]:=i;
                        j:=j+1;
                    end;
                    if posiciones.campo[i].sec=3 then begin
                        param[j]:=2;
                        fichas[j]:=i;
                        j:=j+1;
                    end;
                end;
                for i:=1 to 7 do begin // para los pasillos
                    if posiciones.cfinal[i].amarillo.pri=3 then begin
                        param[j]:=11;
                        fichas[j]:=i;
                        j:=j+1;
                    end;
                    if posiciones.cfinal[i].amarillo.sec=3 then begin
                        if posiciones.cfinal[i].amarillo.pri=3 then begin
                            param[j]:=12;
                            fichas[j]:=i;
                            j:=j+1;
                        end;
                    end;
                end;
            end
            else if turnoactual=verde then begin
                for i:=1 to 68 do begin //para las neutrales
                    if posiciones.campo[i].pri=4 then begin
                        param[j]:=1;
                        fichas[j]:=i;
                        j:=j+1;
                    end;
                    if posiciones.campo[i].sec=4 then begin
                        param[j]:=2;
                        fichas[j]:=i;
                        j:=j+1;
                    end;
                end;
                for i:=1 to 7 do begin // para los pasillos
                    if posiciones.cfinal[i].verde.pri=4 then begin
                        param[j]:=11;
                        fichas[j]:=i;
                        j:=j+1;
                    end;
                    if posiciones.cfinal[i].verde.sec=4 then begin
                        if posiciones.cfinal[i].verde.pri=4 then begin
                            param[j]:=12;
                            fichas[j]:=i;
                            j:=j+1;
                        end;
                    end;
                end;
            end;
          end
          else begin
            //Detecta las barreras del turnoactual
            for i:=0 to 1 do begin //para las neutrales
                if barrerasjug[i]<>0 then begin
                    param[j]:=parambarre[i];
                    fichas[j]:=barrerasjug[i];
                    j:=j+1;
               end;
            end;
          end;
      //Comprobando que se pueda mover (no hay barreras, ni cae en salida/seguro ocupado)
          k:=0;
          for i:=0 to 3 do begin
              if fichas[i]<>0 then begin
                  amover:=loquecuenta;
                  posicion:=fichas[i];
                  temparam:=param[i];
                  posibl[k]:=not(comprobarbarrera(posiciones,turnoactual,
                  loquecuenta,posicion,temparam) and (posicion<>erabarr));
                  calculaposicion(turnoactual,amover,posicion,temparam);
                  posibl[k]:=posibl[k] and (posicion<>erabarr) and 
                  NoEsSeguroOcupado(posiciones,posicion) and
                  NoesSalidaOcupada(posiciones,posicion);
                  if temparam=50 then
                      posibl[k]:=posibl[k] and (posicion<=8);
                  definit[k]:=fichas[i];
                  paramdef[k]:=param[i];
                  k:=k+1;
                  end;
          end;
              //haciendo la selección
          hayopcio:=posibl[0] or posibl[2] or posibl[3] or posibl[1];
          if hayopcio then
              if not (esmaquina) then Begin
                  cambiartexto(historico,Completaconespacios(40,
                  ColorAStr(turnoactual)+' está seleccionando '));
                  imprimirtexto(historico);
                  menufichas(seleccion,parametro,paramdef,definit,k,posiciones,
                    turnoactual);
              end
              else begin
                  k:=random(k);
                  seleccion:=definit[k];
                  parametro:=paramdef[k];
                  cambiartexto(historico,Completaconespacios(40,
                  ColorAStr(turnoactual)+' está seleccionando '));
                  imprimirtexto(historico);
                  delay(2500);
              end
          else if not hayopcio then begin
            cambiartexto(historico,Completaconespacios(40,
            ColorAStr(turnoactual)+' no pudo mover con '+
            IntAStr(loquecuenta)));
            imprimirtexto(historico);
            seleccion:=0;
            parametro:=0;
          end;
          {POST: TRUE}
    end;

    procedure turno(
      var historico  : informativo;       // Texto que informa lo que ha sucedido
                                          // en la partida
          jugadores  : integer;           // Cantidad de jugadores
      var posiciones : tipoposiciones;    // Tipo de posiciones de las fichas
          Colorjug   : tColores;          // Color del jugador
          orden      : array of tColores; // Orden en que se juega
      var turnoactual: tColores           // Color del turno actual
      ); //turno de juego
     var 
        dado      : array[0..1] of byte;    // Dados
        opcion    : byte;                   // Opción para el menú
        disp      : array[0..2] of integer; //
        posibl    : array[0..2] of integer; //
        esdoble   : boolean;   // Variable que indica si se obtuvieron dados dobles
        i,j       : integer;   // Variables de iteración
        seleccion : integer;   // Seleccion del jugador
        parametro : integer;   // Parametro para ubicacion
        comio     : boolean;   // Variable que indica si una ficha comió
        entroameta: boolean;   // Variable que indica si una ficha entró a meta
        erabarr   : integer;   // Si era barrera o no
        parbarr   : integer;   // Parametro de las barreras anteriores
        esmaquina : boolean;   // Variable que indica si un jugador es máquina
        positempo : integer;   // Posicion temporal (auxiliar)
        paratempo : integer;   // Parametro temporal (auxiliar)
        amover    : integer;   // cuanto va a mover
        loquecuenta :integer;  // Espacios que se puede mover una ficha
        ultimaficha : integer; // ultima ficha movida
        ultimoparam : integer; // ultimo parametro movido
        barrerasjug : array[0..1] of integer; // barreras del jugador
        parambarre  : array[0..1] of integer; // parametros de las barreras
        todosenmeta : boolean; // si todos estan en meta o no
        alguiengano : boolean; // Variable para indicar si alguien ganó el juego
     begin
     {PRE: TRUE}
      repeat
        j:=0;
        for i:=0 to 1 do begin
            parambarre[i]:=0;
            barrerasjug[i]:=0;
            erabarr:=0;
            comio:=false;
            disp[i]:=0;
            posibl[i]:=0;
        end;
        j:=j+1;
        posibl[2]:=0;
        disp[2]:=0;
        mturnoactual(turnoactual);
        if turnoactual=Colorjug then
            repeat
                opcion:=menu(55,35,3,'¿Que desea hacer? : ','Lanzar Dados',
                    'Guardar Partida',
                'Salir','');
                if opcion=3 then BEGIN;
                       opcion:=menu(55,35,2,'¿Esta seguro? : ','Sí','No','','');
                       if opcion=1 then begin
                           pantallafinal;
                       end;
                       if opcion=2 then
                           opcion:=3;
                end;
                if opcion=2 then BEGIN;
                       opcion:=menu(55,35,2,'¿Esta seguro? : ','Sí','No','','');
                       if opcion=1 then begin
                           GuardarPartida(jugadores,Colorjug,orden,posiciones);
                           cambiartexto(historico,
                           Completaconespacios(40,'Se guardo la partida'));
                           imprimirtexto(historico);
                           opcion:=2;
                   end;
                end;
            until opcion=1;
        if turnoactual=Colorjug then
            esmaquina:=false
        else
            esmaquina:=true;
        LanzarDados(dado);
        dadosmoviles(dado);
        cambiartexto(historico,Completaconespacios(40,ColorAStr(turnoactual)+
          ' obtuvo '+IntAStr(dado[0])+' y '+IntAStr(dado[1])));
        imprimirtexto(historico);
        disp[0]:=dado[0];
        disp[1]:=dado[1];
        disp[2]:=SumaDados(dado);
        esdoble:=DadosDobles(dado);
        if (j=3) and esdoble then begin
            j:=0;
            if (ultimoparam<10) then
                enviaracasa(posiciones,ultimaficha,ultimoparam);
            cambiartexto(historico,
            Completaconespacios(40,'3 dobles seguidos. Pierde turno.'));
            imprimirtexto(historico);
            siguienteturno(turnoactual,orden,jugadores);
            turno(historico,jugadores,posiciones,Colorjug,orden,turnoactual);
        end;
        for i:=0 to 2 do //obligatorio sacar ficha si obtiene 5
            if quedanfichas(posiciones,turnoactual) and (disp[i]=5) then begin
                sacarficha(historico,posiciones,turnoactual,comio);
                if i<>2 then begin
                    disp[i]:=0;
                    disp[2]:=disp[2]-disp[i];
                end
                else begin
                    disp[i]:=0;
                    disp[1]:=0;
                    disp[0]:=0;
                end;
                cambiartexto(historico,Completaconespacios(40,
                ColorAStr(turnoactual)+' sacó una ficha'));
                imprimirtexto(historico);
                entablero(posiciones);
                if comio then Begin
                    repeat    
                        comio:=false;
                        cambiartexto(historico,Completaconespacios(40,
                        ColorAStr(turnoactual)+' Puede avanzar 20'));
                        imprimirtexto(historico);
                        movimientosposibles(historico,posiciones,20,
                        seleccion,parametro,erabarr,turnoactual,esmaquina,false,
                        barrerasjug,parambarre);
                        if seleccion<>0 then begin
                            positempo:=seleccion;
                            paratempo:=parametro;
                            amover:=20;
                            calculaposicion(turnoactual,positempo,amover,
                                paratempo);
                            moverficha(historico,posiciones,turnoactual,
                                seleccion,parametro,20,comio);
                            cambiartexto(historico,Completaconespacios(40,
                            ColorAStr(turnoactual)+' ha movido una ficha'));
                            imprimirtexto(historico);
                            if (paratempo=50) and (positempo=8) then
                                entroameta:=true;
                            ultimaficha:=positempo;
                            ultimoparam:=paratempo;
                            if entroameta then begin
                                repeat
                                    entroameta:=false;
                                    cambiartexto(historico,Completaconespacios(40,
                                    ColorAStr(turnoactual)+' Puede avanzar 10'));
                                    imprimirtexto(historico);
                                    movimientosposibles(historico,posiciones,10,
                                    seleccion,parametro,erabarr,turnoactual,
                                    esmaquina,false,barrerasjug,parambarre);
                                    if seleccion<>0 then begin
                                        positempo:=seleccion;
                                        paratempo:=parametro;
                                        amover:=10;
                                        calculaposicion(turnoactual,positempo,
                                            amover,paratempo);
                                        moverficha(historico,posiciones,
                                            turnoactual,seleccion,parametro,10,comio);
                                        cambiartexto(historico,Completaconespacios(40,
                                        ColorAStr(turnoactual)+' ha movido una ficha'));
                                        imprimirtexto(historico);
                                        if (paratempo=50) and (positempo=8) then
                                            entroameta:=true;
                                        ultimaficha:=positempo;
                                        ultimoparam:=paratempo;
                                    end;
                                until not (entroameta);
                            end;
                        end;
                    until not comio;
                end;
            end;
        BuscarBarrera(posiciones,turnoactual,barrerasjug,parambarre);
         //olbigar sacar ficha si dobles
        if esdoble and ((barrerasjug[0]<>0) or (barrerasjug[1]<>0)) then begin
                positempo:=seleccion;
                paratempo:=parametro;
                amover:=disp[0];
                movimientosposibles(historico,posiciones,disp[0],
                seleccion,parametro,erabarr,turnoactual,esmaquina,false,
                barrerasjug,parambarre);
                erabarr:=seleccion;
                parbarr:=parametro;
                if seleccion<>0 then begin
                    cambiartexto(historico,Completaconespacios(40,
                    ColorAStr(turnoactual)+' abriendo barrera...'));
                    imprimirtexto(historico);
                    positempo:=seleccion;
                    paratempo:=parametro;
                    amover:=disp[0];
                    calculaposicion(turnoactual,positempo,disp[0],paratempo);
                    moverficha(historico,posiciones,turnoactual,seleccion,
                        parametro,amover,comio);
                    cambiartexto(historico,Completaconespacios(40,
                    ColorAStr(turnoactual)+' ha movido una ficha'));
                    imprimirtexto(historico);
                    if (paratempo=50) and (positempo=8) then
                        entroameta:=true;
                    ultimaficha:=positempo;
                    ultimoparam:=paratempo;
                    if entroameta then begin
                        repeat
                            entroameta:=false;
                            cambiartexto(historico,Completaconespacios(40,
                            ColorAStr(turnoactual)+' Puede avanzar 10'));
                            imprimirtexto(historico);
                            movimientosposibles(historico,posiciones,10,
                            seleccion,parametro,erabarr,turnoactual,
                            esmaquina,false,barrerasjug,parambarre);
                            if seleccion<>0 then begin
                                positempo:=seleccion;
                                paratempo:=parametro;
                                amover:=10;
                                calculaposicion(turnoactual,positempo,amover,
                                    paratempo);
                                moverficha(historico,posiciones,turnoactual,
                                    seleccion,parametro,10,comio);
                                cambiartexto(historico,Completaconespacios(40,
                                ColorAStr(turnoactual)+' ha movido una ficha'));
                                imprimirtexto(historico);
                                if (paratempo=50) and (positempo=8) then
                                    entroameta:=true;
                                ultimaficha:=positempo;
                                ultimoparam:=paratempo;
                            end;
                        until not (entroameta);
                    end;
                    if comio then Begin
                    repeat    
                        comio:=false;
                        cambiartexto(historico,Completaconespacios(40,
                        ColorAStr(turnoactual)+' Puede avanzar 20'));
                        imprimirtexto(historico);
                        movimientosposibles(historico,posiciones,20,
                        seleccion,parametro,erabarr,turnoactual,esmaquina,false,
                        barrerasjug,parambarre);
                        if seleccion<>0 then begin
                            positempo:=seleccion;
                            paratempo:=parametro;
                            amover:=20;
                            calculaposicion(turnoactual,positempo,amover,paratempo);
                            moverficha(historico,posiciones,turnoactual,
                                seleccion,parametro,20,comio);
                            cambiartexto(historico,Completaconespacios(40,
                            ColorAStr(turnoactual)+' ha movido una ficha'));
                            imprimirtexto(historico);
                            if (paratempo=50) and (positempo=8) then
                                entroameta:=true;
                            ultimaficha:=positempo;
                            ultimoparam:=paratempo;
                            if entroameta then begin
                                repeat
                                    entroameta:=false;
                                    cambiartexto(historico,Completaconespacios(40,
                                    ColorAStr(turnoactual)+' Puede avanzar 10'));
                                    imprimirtexto(historico);
                                    movimientosposibles(historico,posiciones,20,
                                    seleccion,parametro,erabarr,turnoactual,
                                    esmaquina,false,barrerasjug,parambarre);
                                    if seleccion<>0 then begin
                                        positempo:=seleccion;
                                        paratempo:=parametro;
                                        amover:=10;
                                        calculaposicion(turnoactual,positempo,
                                            amover,paratempo);
                                        moverficha(historico,posiciones,
                                            turnoactual,seleccion,parametro,10,comio);
                                        cambiartexto(historico,Completaconespacios(40,
                                        ColorAStr(turnoactual)+' ha movido una ficha'));
                                        imprimirtexto(historico);
                                        if (paratempo=50) and (positempo=8) then
                                            entroameta:=true;
                                        ultimaficha:=positempo;
                                        ultimoparam:=paratempo;
                                    end;
                                until not (entroameta);
                            end;
                        end;
                      until not comio;
                    end;
                end;
        end;
        repeat
        if (disp[0]<>0) or (disp[1]<>0) or (disp[2]<>0) then begin 
        // para movimientos normales
            repeat
                opcion:=menu(55,35,3,'¿Cuanto desea mover? : ',IntAStr(disp[0]),
                IntAStr(disp[1]),IntAStr(disp[2]),'');
                amover:=disp[opcion-1];
                if amover=0 then begin
                    cambiartexto(historico,Completaconespacios(40,
                        '¡No puede mover 0 espacios!'));
                    imprimirtexto(historico);
                end;
            until (amover<>0);
            movimientosposibles(historico,posiciones,amover,
            seleccion,parametro,erabarr,turnoactual,esmaquina,false,
            barrerasjug,parambarre);
            if seleccion<>0 then begin
                for i:=0 to 2 do begin
                    disp[i]:=posibl[i];
                    posibl[i]:=0;
                end;
                if opcion-1=2 then begin
                    disp[1]:=0;
                    disp[0]:=0;
                end
                else
                    disp[2]:=disp[2]-disp[opcion-1];
                disp[opcion-1]:=0;
                posibl[opcion-1]:=0;
                positempo:=seleccion;
                paratempo:=parametro;
                loquecuenta:=amover;
                calculaposicion(turnoactual,positempo,amover,paratempo);
                moverficha(historico,posiciones,turnoactual,seleccion,
                parametro,loquecuenta,comio);
                cambiartexto(historico,Completaconespacios(40,
                ColorAStr(turnoactual)+' ha movido una ficha'));
                imprimirtexto(historico);
                if (paratempo=50) and (positempo=8) then
                    entroameta:=true;
                ultimaficha:=positempo;
                ultimoparam:=paratempo;
                if entroameta then begin
                    repeat
                        entroameta:=false;
                        cambiartexto(historico,Completaconespacios(40,
                        ColorAStr(turnoactual)+' Puede avanzar 10'));
                        imprimirtexto(historico);
                        movimientosposibles(historico,posiciones,10,
                        seleccion,parametro,erabarr,turnoactual,
                        esmaquina,false,barrerasjug,parambarre);
                        if seleccion<>0 then begin
                            positempo:=seleccion;
                            paratempo:=parametro;
                            amover:=10;
                            calculaposicion(turnoactual,positempo,amover,
                                paratempo);
                            moverficha(historico,posiciones,turnoactual,
                                seleccion,parametro,10,comio);
                            cambiartexto(historico,Completaconespacios(40,
                            ColorAStr(turnoactual)+' ha movido una ficha'));
                            imprimirtexto(historico);
                            if (paratempo=50) and (positempo=8) then
                                entroameta:=true;
                            ultimaficha:=positempo;
                            ultimoparam:=paratempo;
                        end;
                    until not (entroameta);
                end;
                if comio then Begin
                    repeat    
                        comio:=false;
                        cambiartexto(historico,Completaconespacios(40,
                        ColorAStr(turnoactual)+' Puede avanzar 20'));
                        imprimirtexto(historico);
                        movimientosposibles(historico,posiciones,20,
                        seleccion,parametro,erabarr,turnoactual,esmaquina,
                        false,barrerasjug,parambarre);
                        if seleccion<>0 then begin
                            positempo:=seleccion;
                            paratempo:=parametro;
                            amover:=20;
                            calculaposicion(turnoactual,positempo,amover,
                            paratempo);
                            moverficha(historico,posiciones,turnoactual,
                            seleccion,parametro,20,comio);
                            cambiartexto(historico,Completaconespacios(40,
                            ColorAStr(turnoactual)+' ha movido una ficha'));
                            imprimirtexto(historico);
                            if (paratempo=50) and (positempo=8) then
                                entroameta:=true;
                            ultimaficha:=positempo;
                            ultimoparam:=paratempo;
                            if entroameta then begin
                                repeat
                                    entroameta:=false;
                                    cambiartexto(historico,Completaconespacios(40,
                                    ColorAStr(turnoactual)+' Puede avanzar 10'));
                                    imprimirtexto(historico);
                                    movimientosposibles(historico,posiciones,10,
                                    seleccion,parametro,erabarr,turnoactual,
                                    esmaquina,false,barrerasjug,parambarre);
                                    if seleccion<>0 then begin
                                        positempo:=seleccion;
                                        paratempo:=parametro;
                                        amover:=10;
                                        calculaposicion(turnoactual,positempo,
                                            amover,paratempo);
                                        moverficha(historico,posiciones,
                                            turnoactual,seleccion,parametro,10,comio);
                                        cambiartexto(historico,Completaconespacios(40,
                                        ColorAStr(turnoactual)+' ha movido una ficha'));
                                        imprimirtexto(historico);
                                        if (paratempo=50) and (positempo=8) then
                                            entroameta:=true;
                                        ultimaficha:=positempo;
                                        ultimoparam:=paratempo;
                                    end;
                                until not (entroameta);
                            end;
                        end;
                    until not comio;
                end;
            end
            else begin
                posibl[opcion-1]:=disp[opcion-1];
                disp[opcion-1]:=0;
            end;
        end
        else  BEGIN
            cambiartexto(historico,Completaconespacios(40,
            'No le quedan movimientos posibles a '+ColorAStr(turnoactual)));
            imprimirtexto(historico);
        end;
        until (disp[0]=0) and (disp[1]=0) and (disp[2]=0);
        alguiengano:=false;
        todosenmeta:=true;
        for i:=1 to 4 do begin
            if turnoactual=rojo then
                todosenmeta:=todosenmeta and (posiciones.meta[i].rojo<>0)
            else if turnoactual=azul then
                todosenmeta:=todosenmeta and (posiciones.meta[i].azul<>0)
            else if turnoactual=amarillo then
                todosenmeta:=todosenmeta and (posiciones.meta[i].amarillo<>0)
            else if turnoactual=verde then
                todosenmeta:=todosenmeta and (posiciones.meta[i].verde<>0);
        end;
        alguiengano:=alguiengano or todosenmeta;
        if not alguiengano then
            if not esdoble then 
                siguienteturno(turnoactual,orden,jugadores)
            else begin
                cambiartexto(historico,Completaconespacios(40,
                'Ha obtenido dobles! '+ColorAStr(turnoactual)+' vuelve a jugar'));
                imprimirtexto(historico);
            end;
      until alguiengano;
      {Post: TRUE}
     end;
   
    function menuprincipal(
      var jugadores         : integer;           // Cantidad de jugadores
      var Colorjug          : tColores;          // Color del jugador
      var orden             : Array of tColores; // Orden en que se juega
      var posiciones        : tipoposiciones     // Tipo de posiciones de las fichas
      ) : Integer; // Menu principal del programa
        begin
         { Pre: true }
             tableroajedrez(1,1,45,140);
             tituloanim(30,3,150,5);
             cuadro(16,15,25,110);
             gotoxy(55,24);
             Writeln('¡Bienvenido/a a Parchís-USB!!');
             menuprincipal:=menu(55,25,3,Completaconespacios(30,''),
                'Nueva Partida','Cargar Partida','Salir','');
             if menuprincipal=3 then begin
                 menuprincipal:=menu(55,25,3,'¿Está seguro?','Sí','No','','');
                 if menuprincipal=1 then
                     pantallafinal
                 else
                     menuprincipal:=menuprincipal(jugadores,Colorjug,
                        orden,posiciones);
             end;
             if menuprincipal=2 then begin
                 CargarPartida(jugadores,Colorjug,orden,posiciones);
                 gotoxy(90,45);
                 textcolor(cyan);
                 gotoxy(90,45);
                 Write('Cargando Partida.  por favor espere      ');
                 delay(1000);
                 gotoxy(90,45);
                 Write('Cargando Partida..  por favor espere      ');
                 delay(1000);
                 gotoxy(90,45);
                 Write('Cargando Partida... por favor espere      ');
                 textcolor(white);
                 delay(1000);
             end;
         { Post: Se muestra una intro animada y el menú principal del juego}
         end;

    procedure instrucciones( ); // Muestra una pantalla con las instrucciones del juego
      VAR 
      y,x,j     : integer; // Variables de iteración
      linea     : array[1..99] of string; // Lineas 1 a 99 para las instrucciones
     begin
         { Pre: true }
         tableroajedrez(1,1,45,140);
         titulo(30,3,150);
         cuadro(16,15,25,110);
         gotoxy(20,12);
         textcolor(white);
         if menu(55,35,2,'¿Desea conocer las instrucciones del juego?','Sí',
            'No','','')=1 then Begin
             cuadro(16,15,25,110);
             x:=20;
             y:=18;
             gotoxy(20,y);
             linea[01]:='» Necesario para jugar';
             linea[02]:='';
             linea[03]:='Pueden jugar 2 ó 4 jugadores. Cada jugador dispone de ';
             linea[04]:='4 fichas del mismo color (amarillas, rojas, verdes y azules) ';
             linea[05]:='y un dos dado de seis caras. ';
             linea[06]:='';
             linea[07]:='» Terminología';
             linea[08]:='';
             linea[09]:='Las casillas circulares coloreadas de las esquinas se ';
             linea[010]:='denominan casas o cárceles.';
             linea[011]:='Las casillas rectangulares, coloreadas que hay junto a';
             linea[012]:=' cada casa se denominan salidas.';
             linea[013]:='Las casillas rectangulares grises o marcadas de otro ';
             linea[014]:='color se denominan seguros.';
             linea[015]:='Las casillas "triangulares" coloreadas del centro del ';
             linea[016]:='tablero se denominan metas.';
             linea[017]:='A las 7 casillas coloreadas justo antes de las metas ';
             linea[018]:='se les suele llamar pasillo.';
             linea[019]:='Dos fichas de igual color en la misma casilla forman ';
             linea[020]:='una barrera o puente y se dice que la barrera se “abre”';
             linea[021]:=' cuando una de esas fichas es movida.';
             linea[022]:='';
             linea[023]:='Contar siete, diez o veinte significa que un jugador ';
             linea[024]:='debe avanzar una de sus fichas siete, diez o veinte ';
             linea[025]:='casillas, respectivamente. Se emplean las palabras ';
             linea[026]:='comer o capturar cuando una ficha ocupa la posición ';
             linea[027]:='de una ficha contraria y ésta última se mueve a su casa.';
             linea[028]:='';
             linea[029]:='» Antes de comenzar la partida';
             linea[030]:='';
             linea[031]:='Cada jugador elegirá un color: amarillo, azul, rojo o ';
             linea[032]:='verde. Los jugadores lanzarán el dado y quien obtenga ';
             linea[033]:='la mayor puntuación será quien comience la partida.';
             linea[034]:='';
             linea[035]:='» Reglas básicas';
             linea[036]:='';
             linea[037]:='Al comenzar el juego todas las fichas están en la casa';
             linea[38]:='de su color con expeción de una que comienza en la salida.';
             linea[39]:='La partida se desarrolla por turnos. Cada jugador lanzará ';
             linea[40]:='el dado una sola vez en cada turno. Una vez jugado su turno, ';
             linea[041]:='si sacó dobles, el jugador repetirá el turno. En caso contrari';
             linea[042]:='o cederá el turno al jugador de su derecha de acuerdo al ';
             linea[043]:='color de las cárceles.';
             linea[044]:='';
             linea[045]:='Sólo cuando la puntuación obtenida con el dado no permita ';
             linea[046]:='hacer ninguna jugada el jugador no hará nada. En el resto ';
             linea[047]:='de los casos el jugador está obligado a hacer lo que pueda hacer.';
             linea[048]:='';
             linea[049]:='Las fichas se mueven en sentido contrario a las agujas';
             linea[050]:='del reloj desde la salida de su color hasta la meta de su color. ';
             linea[051]:='Las fichas que están en la casa y en la meta no se pueden mover.';
             linea[052]:='';
             linea[053]:='Una ficha no puede moverse a una casilla en la que ya ';
             linea[054]:='existan 2 fichas, salvo el caso especial de que al obtener ';
             linea[055]:='un 5 haya fichas contrarias en la salida del jugador que saca ficha.';
             linea[056]:=' Sólo la casa y la meta pueden contener 3 o 4 fichas. Esta ';
             linea[057]:=' regla prevalece sobre otras.';
             linea[058]:='';
             linea[059]:='» Sobre el 5';
             linea[060]:='';
             linea[061]:='El jugador que saca un 5 con algún dado o la suma exacta de ambos, ';
             linea[062]:='debe sacar ficha de su casa a la casilla de salida. Si esto no ';
             linea[063]:='fuera posible porque ya hay dos fichas de su mismo color en la ';
             linea[064]:='salida o porque ya no dispone de más fichas para sacar, deberá ';
             linea[065]:='mover alguna ficha.';
             linea[066]:='';
             linea[067]:='» Sobre dobles';
             linea[068]:='';
             linea[069]:='El jugador que saque dobles podrá repetir turno. Si saca otro ';
             linea[070]:='doble podrá volver a repetir.Si saca un doble en la tercera tirada, ';
             linea[071]:='la última ficha que movió volverá a casa. Tampoco irá a casa si no ';
             linea[072]:='pudo mover el segundo seis. En cualquier caso no podrá utilizar ';
             linea[073]:='la tirada y  terminará su turno» Sobre los puentes o barreras';
             linea[074]:='Ninguna ficha puede pasar sobre una barrera. Esta regla prevalece ';
             linea[075]:='sobre las demás. Si un jugador tiene una barrera y saca un doble ';
             linea[076]:='con el dado deberá abrir la barrera. La única excepción a esta ';
             linea[077]:='regla ocurrirá cuando la ficha de la barrera deba avanzar y esta';
             linea[078]:='no pueda, ya sea por encontrarse con otra barrera en medio ';
             linea[079]:='del trayecto o por caer en una casilla ocupada por otras dos fichas.';
             linea[080]:='';
             linea[081]:='» Sobre comer o capturar';
             linea[082]:='';
             linea[083]:='Si una ficha cae en una casilla blanca y numerada ocupada por ';
             linea[084]:='una ficha de otro color se la comerá. La ficha comida irá a ';
             linea[085]:='su casa original (de su mismo color). El jugador que coma ';
             linea[086]:='contará veinte. En las salidas y en los seguros, no es posible comer ';
             linea[087]:='y pueden estar dos fichas de colores diferentes. En la salidas no ';
             linea[088]:='puede haber más de dos fichas. Si un jugador al sacar una ficha de ';
             linea[089]:='su casa encuentra dos fichas de otros colores comerá la primera ';
             linea[090]:='que hubiese llegado y contará 20.';
             linea[091]:='';
             linea[092]:='» Sobre la meta y el fin del juego';
             linea[093]:='';
             linea[094]:='Una ficha entra a la meta con un número exacto de casillas ';
             linea[095]:='obtenido con el dado. Si el número no es exacto no se puede ';
             linea[096]:='mover la ficha. Además el jugador que mete una ficha en la meta, ';
             linea[097]:='avanza 10 con alguna de sus otras fichas.';
             linea[098]:='El jugador que consigue meter sus 4 fichas en la meta ';
             linea[099]:='finaliza el juego resultando ganador.';             
             j:=0;
             for x:=1 to 99 do Begin
                 j:=j+1;
                 gotoxy(20,y+j);
                 if  (x=92)or(x=81)or(x=67)or(x=59)or(x=35)or(x=29)
                     or(x=7)or(x=1) then Begin
                     textcolor(cyan);
                     write(linea[x]);
                     textcolor(white);
                 end
                 else
                     write(linea[x]);
                 if x mod 21 = 0 then Begin
                     gotoxy(90,45);
                     Write('Presione "Enter" para continuar.');
                     Readln;
                     cuadro(16,15,25,110);
                     j:=0;
                 end;
             end;
         end;
         gotoxy(90,45);
         textcolor(cyan);
         Write('Presione "Enter" para ir al menú principal.');
         textcolor(white);
         Readln;
         { Post: Se muestra una pantalla con las instrucciones }
     end;

    procedure Inicio(
      var  jugadores     : Integer;           // Cantidad de jugadores
      var  posiciones    : tipoposiciones;    // Tipo de posiciones de las fichas
      var  historico     : informativo;       // Texto que informa lo que ha
                                              // sucedido en la partida
      var  Colorjug      : tColores;          // Color del jugador
      var  primero       : tColores;          // Color del primer jugador
      var  orden         : array of tColores; // Orden de los colores
      var  turnoactual   : tColores           // Color del turno actual
      );
      var
          opcion  : integer; // Número de opción del menú
     begin
     { Pre: true }
       clrscr;
       intro;
       instrucciones;
       opcion:=menuprincipal(jugadores,Colorjug,orden,posiciones);
       if opcion=1 then
            configinicial(jugadores,posiciones,historico,Colorjug,orden,turnoactual)
       else begin
            plantillaprincipal;
            tituloanim(30,3,150,3);
            entablero(posiciones);
            turnoactual:=Colorjug;
            mturnoactual(turnoactual);
            cambiartexto(historico,Completaconespacios(40,'Continuando partida...'));
            imprimirtexto(historico);
       end;
       turno(historico,jugadores,posiciones,Colorjug,orden,turnoactual);
     { Post: true }
     end;
 
    VAR
            jugadores  : Integer;        // Cantidad de jugadores
            posiciones : tipoposiciones; // Tipo de posiciones de las fichas 
            historico  : informativo;    // Texto que informa lo que ha sucedido
                                         // en la partida
            Colorjug   : tColores;       // Color del jugador
            primero    : tColores;       // Color del primer jugador
            orden      : array[0..3] of tColores; // Orden de los colores
            turnoactual: tColores;       // Color del turno actual

    BEGIN
     randomize; //Para evitar dados repetitivos
     Inicio(jugadores,posiciones,historico,Colorjug,primero,orden,turnoactual);
    END.