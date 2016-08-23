# Proyecto-Corto-1-Controlador-VGA
Diseño Sistemas Digitales, Nexys 3 VGA

Controlador posee la posibilidad de imprimir las letras de las iniciales de los integrantes del grupo ademas de la posibilidad de usar switches para el cambio de colores

////////////////////////////////////////////////////////////////// ////
//// ////
//// This file is part of the 'Proyecto Corto 1. Controlador VGA' project ////
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

