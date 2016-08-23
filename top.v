////////////////////////////////////////////////////////////////// ////
//// ////
//// This file is part of the 'Proyecto Corto 1. Controlador VGA' project ////
//// https://github.com/rcampos18/Proyecto-Corto-1-Controlador-VGA.git
//// ////
//// Diseño de sistemas Digitales////
////  FPGA: Nexys 3 spartan 6
////	Plataforma de desarrollo:
//// Descripción: Xilinx ISE
//// En el programa se utilizaron varios bloques, al que llamamos vga_sync se utilizó 
//// para generar los tiempos y señales de sincronización, 
//// en el caso de las señales hsync y vsync van al conector de salida VGA y son las encargadas,
//// en el caso de hsync, de contar los puntos de cada línea y generar el sincronismo horizontal 
//// y para vsync cuenta las líneas de cada imagen y genera el sincronismo vertical, 
//// y las señales pixelx y pixely muestran donde se debe generar el pixel actual, 
//// la señal video on habilita la visualización, 
//// lo que indica que genera la imagen a mostrar,
//// el bloque vga_sync se utiliza para generar la salida en los pixeles de las letras
//// en la unidad text_font para enviar los bits de salida (Azul, Verde, Rojo)
//// dependiendo de los switches de color.
//// To Do: 
////
//// ////
//// Author(s): ////
//// - Mario Valenciano Rojas 2013099217
///      mariovarojas@gmail.com
///  -Ruth Campos Artavia 2013026084
///      tutirica@gmail.com
////
//// ////
//////////////////////////////////////////////////////////////////////
//// ////
//// Copyright (C) 2009 Authors and OPENCORES.ORG ////
//// ////
//// This source file may be used and distributed without ////
//// restriction provided that this copyright statement is not ////
//// removed from the file and that any derivative work contains ////
//// the original copyright notice and the associated disclaimer. ////
//// ////
//// This source file is free software; you can redistribute it ////
//// and/or modify it under the terms of the GNU Lesser General ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any ////
//// later version. ////
//// ////
//// This source is distributed in the hope that it will be ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR ////
//// PURPOSE. See the GNU Lesser General Public License for more ////
//// details. ////
//// ////
//// //// ///
///////////////////////////////////////////////////////////////////
module top //Unidad Global Graficos
   (
	//=======================================================
   // declaracion de entradas
   //=======================================================
    input wire clk, rst, 					//entradas reloj y reseteo
    input wire [2:0] sw,   					//switches selectores de color
	//=======================================================
   // declaracion de salidas
   //=======================================================
    output wire hsync, vsync, 				//salidas de sincronizacion horizontal y vertical
    output wire [7:0] rgb 						//salidas [7:6]azul,[5:3]verde,[2:0]rojo
   );

   //=======================================================
   // declaracion de señales
   //=======================================================
   wire [9:0] pixel_x, pixel_y;				//coordenadas pixeles
   wire video_on, pixel_tick; 				//habiitador de video, movimiento pixel
   wire text_on; 									//habilitador de texto
   wire [7:0] text_rgb; 						//colores rgb
   reg [7:0] rgb_next; 							//registro colores

   //=======================================================
   // instancias
   //=======================================================
   // instanciamiento unidad de sincronizacion de video
	//=======================================================
   vga_sync vsync_unit
	(.clk(clk), .rst(rst), .hsync(hsync), .vsync(vsync),
       .video_on(video_on), .p_tick(pixel_tick),
       .pixel_x(pixel_x), .pixel_y(pixel_y));
   
   //=======================================================
   // instanciamiento unidad de texto
   //=======================================================
   text_font text_unit
      (.clk(clk),.pix_x(pixel_x), .pix_y(pixel_y),
       .text_on(text_on), .text_rgb(text_rgb),.sw(sw));
   
   //=======================================================
   // Multiplexado rgb 
   //=======================================================
   always @*
      if (~video_on)
         rgb_next = 8'b00000000;				//negro bordes
      else
         if (text_on) 							//color de texto
           rgb_next = text_rgb;
         else
           rgb_next = 8'b11111111; 			//fondo blanco
			  // salida
   assign rgb = rgb_next;
endmodule
