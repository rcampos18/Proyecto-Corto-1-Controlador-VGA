module text_font
   (
    input wire clk, 
	 input wire [2:0] sw,
    input wire [9:0] pix_x, pix_y,
    output wire text_on,
    output reg [7:0] text_rgb
   );
   //  declaracion de señales
	reg[7:0] color_word;
   wire [10:0] rom_addr;
   reg [6:0] char_addr, char_addr_l;
   reg [3:0] row_addr;
   wire [3:0] row_addr_l;
   reg [2:0] bit_addr;
   wire [2:0] bit_addr_l;
   wire [7:0] font_word;
   wire font_bit;

   // instancia de font ROM
   font_rom font_unit
      (.clk(clk), .addr(rom_addr), .data(font_word));

   // region letras:
   //   - desplega palabra "RCMV" centrada
   //-------------------------------------------
   assign text_on = (pix_y[9:7]==2) &&
                    (3<=pix_x[9:6]) && (pix_x[9:6]<=6);
   assign row_addr_l = pix_y[6:3];//tamaño del cuadro
   assign bit_addr_l = pix_x[5:3];
   always @*
      case (pix_x[8:6])
         3'o3: char_addr_l = 7'h52; // R
         3'o4: char_addr_l = 7'h43; // C
         3'o5: char_addr_l = 7'h4d; // M
         default: char_addr_l = 7'h56; // V
      endcase

   //-------------------------------------------
   // mux para accesar a ROM y rgb
   //-------------------------------------------
   always @*
   begin
      text_rgb =8'b11111111; // fondo blanco
		case (sw)
					3'b000:color_word = 8'b11011101; //Morado
					3'b001:color_word = 8'b10010000; //azul oscuro
					3'b010:color_word = 8'b11000000; //azul
					3'b011:color_word = 8'b10000001; //morado oscuro
					3'b100:color_word = 8'b00010001; //verde oscuro
					3'b101:color_word = 8'b00011000; //verde claro
					3'b110:color_word = 8'b00000100; //rojo
					3'b111:color_word = 8'b11000111; //rosado
					default: color_word = 8'b11111111;  //nregro
		endcase
		if (text_on)
         begin
            char_addr = char_addr_l;
            row_addr = row_addr_l;
            bit_addr = bit_addr_l;
            if (font_bit)
         		text_rgb=color_word;
         end
//      
   end

   //-------------------------------------------
   //interface memoria fuente ROM
   //-------------------------------------------
   assign rom_addr = {char_addr, row_addr};
   assign font_bit = font_word[~bit_addr];

endmodule
