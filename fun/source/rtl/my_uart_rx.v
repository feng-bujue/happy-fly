module my_uart_rx
(
	input			clk,		//25MHz��ʱ��
	input			rst_n,		//�͵�ƽ��λ�ź�
	input			uart_rx,	//���������ź�
	output	    	rx_data,	//�������ݼĴ���������ֱ����һ����������
	output			rx_int,		//���������ж��ź�,���յ������ڼ�ʼ��Ϊ�ߵ�ƽ
	input			clk_bps,	//clk_bps�ĸߵ�ƽΪ���ջ��߷�������λ���м������
	output			bps_start,	//���յ����ݺ󣬲�����ʱ�������ź���λ
	output          rx_data3
	//input			uart_rx_2,	//���������ź�2
	//input			clk_bps_2,	//clk_bps�ĸߵ�ƽΪ���ջ��߷�������λ���м������
	//output			bps_start_2	//���յ����ݺ󣬲�����ʱ�������ź���λ
	
	
	);
	


//----------------------------------------------------------------
reg		uart_rx0,uart_rx1,uart_rx2,uart_rx3;	//�������ݼĴ���

wire	neg_uart_rx;						
reg    [7:0] rx_data_11 [11:0];
reg    [7:0] rx_data_0,rx_data_1,rx_data_2,rx_data_3,rx_data_4,rx_data_5,rx_data_6,rx_data_7,rx_data_8,rx_data_9,rx_data_10;
reg    [7:0] count;
reg          T;
reg          G;
reg    [15:0] a_x,a_y,a_z,w_x,w_y,w_z,roll_x,pitch_y,yaw_z;
reg    [15:0] w_y1,w_y2,w_y3,w_y4,w_y5,w_y6,w_y7,w_y8,w_y9,w_y10;
reg    [15:0] w_z1,w_z2,w_z3,w_z4,w_z5,w_z6,w_z7,w_z8,w_z9,w_z10;
always @ (posedge clk or negedge rst_n)
begin 
	if(!rst_n) 
    begin
		uart_rx0 <= 1'b0;
		uart_rx1 <= 1'b0;
		uart_rx2 <= 1'b0;
		uart_rx3 <= 1'b0;
	end
	else 
    begin
		uart_rx0 <= uart_rx;
		uart_rx1 <= uart_rx0;
		uart_rx2 <= uart_rx1;
		uart_rx3 <= uart_rx2;
		
		//uart_rx0 <= uart_rx;//2
		//uart_rx_1 <= uart_rx_0;
		//uart_rx_2 <= uart_rx_1;
		//uart_rx_3 <= uart_rx_2;
	end
end

assign neg_uart_rx = uart_rx3 & uart_rx2 & ~uart_rx1 & ~uart_rx0;	//���յ��½��غ�neg_uart_rx�ø�һ��ʱ������
//assign neg_uart_rx_2 = uart_rx_3 & uart_rx_2 & ~uart_rx_1 & ~uart_rx_0;	//���յ��½��غ�neg_uart_rx_2�ø�һ��ʱ������
//----------------------------------------------------------------
reg 		bps_start_r;
reg	[3:0] 	num;	
reg 		rx_int;		//���������ж��ź�,���յ������ڼ�ʼ��Ϊ�ߵ�ƽ

always @ (posedge clk or negedge rst_n)
begin
	if(!rst_n)  
    begin
		bps_start_r <= 1'bz;
		rx_int 		<= 1'b0;
	end
	else if(neg_uart_rx) 
    begin	                    //���յ����ڽ�����uart_rx���½��ر�־�ź�  
		bps_start_r <= 1'b1;	//��������׼�����ݽ���   
		rx_int 		<= 1'b1;	//���������ж��ź�ʹ��
	end
	else if(num == 4'd9) 
    begin	                    //����������������Ϣ
		bps_start_r <= 1'b0;	//���ݽ�����ϣ��ͷŲ����������ź�
		rx_int 		<= 1'b0;	//���������ж��źŹر�
	end
end

assign bps_start = bps_start_r;

//----------------------------------------------------------------
reg	[7:0]	rx_data_r;		//���ڽ������ݼĴ���
reg	[7:0]	rx_temp_data;	//��ǰ�������ݼĴ���

always @ (posedge clk or negedge rst_n)
begin
	if(!rst_n) 
    begin
		rx_temp_data 	<= 8'd0;
		num 			<= 4'd0;
		rx_data_r 		<= 8'd0;
	end
	else if(rx_int) 
    begin	                //�������ݴ���
		if(clk_bps) 
        begin	            	
			num <= num+1'b1;
			case (num)
				4'd1: rx_temp_data[0] <= uart_rx;	//�����0bit
				4'd2: rx_temp_data[1] <= uart_rx;	//�����1bit
				4'd3: rx_temp_data[2] <= uart_rx;	//�����2bit
				4'd4: rx_temp_data[3] <= uart_rx;	//�����3bit
				4'd5: rx_temp_data[4] <= uart_rx;	//�����4bit
				4'd6: rx_temp_data[5] <= uart_rx;	//�����5bit
				4'd7: rx_temp_data[6] <= uart_rx;	//�����6bit
				4'd8: rx_temp_data[7] <= uart_rx;	//�����7bit
				default: ;
			endcase
		end
		else if(num == 4'd9) 
        begin		
			num			<= 4'd0;			//���յ�STOPλ�����,num����
			//rx_data_r	<= rx_temp_data;	
			rx_data_0   <=rx_temp_data;        //���������浽���ݼĴ���rx_data_x��
			rx_data_1   <=rx_data_0;
		    rx_data_2   <=rx_data_1;
			rx_data_3   <=rx_data_2;
			rx_data_4   <=rx_data_3;
			rx_data_5   <=rx_data_4;
			rx_data_6   <=rx_data_5;
			rx_data_7   <=rx_data_6;
			rx_data_8   <=rx_data_7;
			rx_data_9   <=rx_data_8;
			rx_data_10  <=rx_data_9;
			
			
		end
	end
end

//assign rx_data = rx_data_r;	



always @(posedge clk or negedge rst_n)
begin
 if(!rst_n)
      begin
  
      end
       
      else if(num == 4'd0)	
      begin
           if(rx_data_10==8'h55)
			  begin
		    
		  
		      case (rx_data_9)
		      8'h51:
		             begin
		            // a_x <= ((rx_data_7<<8)| rx_data_8);      //X����ٶ�
                    // a_y <= ((rx_data_5<<8)| rx_data_6);     //Y����ٶ�
                    // a_z <= ((rx_data_3<<8)| rx_data_4);      //Z����ٶ�
                    // T   <= rx_data_1;      //�¶�
                     end
		      8'h52:
		             begin
		           //  w_x <= ((rx_data_7<<8)| rx_data_8);      //X����ٶ�
		          ///////////////////////////////////////////////////////////////
                     //w_y <= ((rx_data_5)<<8|rx_data_6);      //Y����ٶ�
                  if(((rx_data_5)<<8|rx_data_6)>16'h6000)w_y<=16'h0000;
                  else w_y<=((rx_data_5)<<8|rx_data_6);
                     w_y1 <=  w_y;
                     w_y2 <=  w_y1;
                     w_y3 <=  w_y2;
                     w_y4 <=  w_y3;
                     w_y5 <=  w_y4;
                     w_y6 <=  w_y5;  
                     w_y7 <=  w_y6;
                     w_y8 <=  w_y7;
                     w_y9 <=  w_y8;
                     w_y10<=  w_y9+w_y8+w_y7+w_y6+w_y5+w_y4+w_y3+w_y2+w_y1+w_y;
                     
                   if(w_y10>=16'h6000)T<=1'b1;
                    else T<=1'b0;
                    
                    ///////////////////////////////////////////////////
                  if(((rx_data_7)<<8|rx_data_8)>16'h8000)w_z<=16'h0000;//FFFF-((rx_data_7)<<8|rx_data_8);
                  else w_z<=((rx_data_7)<<8|rx_data_8);
                
                  
                  
                  w_z1<=w_z1+w_z;
                  
                if(w_z<=16'h0600) 
                    G<=1'b1;
                else G<=1'b0;
                  // begin                    
                    //   count<=count+8'h01  ;
                  
                    // if(count>=8'h20)
                     //   begin 
                     //   G<=8'h11;
                     ///   count<=8'h00;
                     //   end
                    // else G<=8'h00;                                        
                   
                    
                   // else count<=count;
                    // w_z <= ((rx_data_3<<8)| rx_data_4);      //Z����ٶ�
                    // T   <= ((rx_data_1<<8)| rx_data_2);      //�¶�
                    end
          
              
		      8'h53:
		             begin
		             // roll_x <= ((rx_data_7<<8)| rx_data_8);      //X���
                    // pitch_y <= ((rx_data_5<<8)| rx_data_6);      //Y��Ƕ�
                    // yaw_z <= ((rx_data_3<<8)| rx_data_4);      //Z��Ƕ�
                    // T   <= ((rx_data_1<<8)| rx_data_2);      //�¶�
		
                      end
                      endcase
			  end
			   
	  end  
        
end
assign rx_data = T;//����
assign rx_data3 = G;//ʯͷ
  
endmodule



