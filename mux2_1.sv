module mux2_1(out, feedback, in, en);   
	output logic out;    
	input  logic feedback, in, en; 
	logic out1, out2;
	
	and(out1, in, en);
	and (out2, feedback, ~en);
	or (out, out1, out2);
	
endmodule    

