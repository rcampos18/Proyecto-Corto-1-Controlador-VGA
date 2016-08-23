
module vga_sync
   (
	//=======================================================
   // declaracion de entradas
   //=======================================================
    input wire clk, rst, 					//entradas reloj y reseteo
	//=======================================================
   // declaracion de salidas
   //=======================================================
    output wire hsync, vsync, video_on, p_tick,	//salidas de sincronizacion horizontal, vertical, video y tick
    output wire [9:0] pixel_x, pixel_y				//coordenadas pixeles
   );
	reg clk_out;											//registro reloj
	//=======================================================
   // declaracion de divisor para obtener 50MHz
   //=======================================================	
	always @ (posedge clk) 
				if (rst) 
						clk_out <= 1'b0;
				else	
						clk_out <= ~clk_out ; 
	//=======================================================
   // Fin declaracion de divisor para obtener 50MHz
   //=======================================================						
	
   // declaracion de constantes
   // parametros de sincronizacion VGA 640-by-480 
   localparam HD = 640; // area horizontal
   localparam HF = 48 ; // borde horizontal izquierdo
   localparam HB = 16 ; // borde horizontal derecho
   localparam HR = 96 ; // retraso horizontal
   localparam VD = 480; // area vertical
   localparam VF = 10;  // borde vertical superior
   localparam VB = 33;  // borde vertical inferior
   localparam VR = 2;   // retraso vertical
	
	//=======================================================
   // declaracion de parametros para obtener 25MHz ->  640x480,@60Hz
   //=======================================================	
   reg mod2_reg;
   wire mod2_next;
	
   // contador de sincronizacion
   reg [9:0] h_count_reg, h_count_next;
   reg [9:0] v_count_reg, v_count_next;
   //registros de estado v_sync y hsync  
   reg v_sync_reg, h_sync_reg;
   wire v_sync_next, h_sync_next;
   // senal final
   wire h_end, v_end, pixel_tick;
	

   always @(posedge clk_out, posedge rst)
      if (rst)
         begin
            mod2_reg <= 1'b0;
            v_count_reg <= 0;
            h_count_reg <= 0;
            v_sync_reg <= 1'b0;
            h_sync_reg <= 1'b0;
         end
      else
         begin
            mod2_reg <= mod2_next; //registro guarda valor siguiente
            v_count_reg <= v_count_next;
            h_count_reg <= h_count_next;
            v_sync_reg <= v_sync_next;
            h_sync_reg <= h_sync_next;
         end
		

   // modulo contador flanco 
	//genera 25 MHz activar tick
   assign mod2_next = ~mod2_reg; //registro siguiente es inverso al guardado en registro
   assign pixel_tick = mod2_reg;

   // contador horizontal final (799)
   assign h_end = (h_count_reg==(HD+HF+HB+HR-1));
   // contador vertical final (524)
   assign v_end = (v_count_reg==(VD+VF+VB+VR-1));

   // logica de siguiente estado horizontal
   always @*
      if (pixel_tick) 
         if (h_end)
            h_count_next = 0;
         else
            h_count_next = h_count_reg + 1'b1;
      else
         h_count_next = h_count_reg;
			
   // logica de siguiente estado vertical
   always @*
      if (pixel_tick & h_end)
         if (v_end)
            v_count_next = 0;
         else
            v_count_next = v_count_reg + 1'b1;
      else
         v_count_next = v_count_reg;

   // sincronizacion horizontal y vertical, evitar glitch
//entre 656 and 751
   assign h_sync_next = (h_count_reg>=(HD+HB) &&
                         h_count_reg<=(HD+HB+HR-1));
//entre 490 and 491
   assign v_sync_next = (v_count_reg>=(VD+VB) &&
                         v_count_reg<=(VD+VB+VR-1));

   // video on/off
   assign video_on = (h_count_reg<HD) && (v_count_reg<VD);

   // salidas
   assign hsync = h_sync_reg;
   assign vsync = v_sync_reg;
   assign pixel_x = h_count_reg;
   assign pixel_y = v_count_reg;
   assign p_tick = pixel_tick;

endmodule
