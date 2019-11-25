module rgb_tx
(     
      input         clk,
      input         rst_n,   //复位
      input         rx_data_1,//剪刀
      input         rx_data_2,//布
      input         rx_data_3,//石头
      output        led_r,
      output        led_g,
      output        led_b
      );
                   
 reg [2:0] led_rgb;     
 
 reg [3:0] count;
 reg [2:0] wei;
 
 always @ (negedge rx_data_3 or negedge rst_n )
begin 
	if(!rst_n)  
	
	begin 
	wei[0]<=1'b0;
	count<=0;
	end
	else 
	    begin
	
	    count<=count+4'b0001;
	    if(count==2) 
             begin
             
             wei[0]<=1'b1;
	    end
	   
	
	end
	
end 

always @(negedge rx_data_1 or negedge rst_n )
begin

      
       if(!rst_n)wei[2]<=1'b0;
        else  wei[2]<=1'b1;
        
end

always @(negedge rx_data_2 or negedge rst_n )
begin
        
       if(!rst_n)wei[1]<=1'b0;
         else wei[1]<=1'b1;
        

end



 
  always @ (posedge clk )
begin 
    
	casez (wei)	
	3'b10?:
	      begin
              led_rgb<=3'b110;	      //剪刀blue
	      end
	
	3'b?1?:
	       begin
              led_rgb<=3'b101;	       //布green
	      end
	3'b001:
	        begin
              led_rgb<=3'b011;	      //石头red
	      end
	
	3'b000:
	      begin
	         led_rgb<=3'b000;      //清零
	      end
	
	
	endcase
	
	
end 
 
 
 
 
 
 
 
 
 
 
 
 
 

assign led_r = led_rgb[2];
assign led_g =led_rgb[1];
assign led_b = led_rgb[0];


endmodule
