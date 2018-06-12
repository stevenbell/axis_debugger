
module streamcounter #
  (
    parameter integer C_AXIS_BYTEWIDTH = 4
  )
  (
    // Clock
    input clk,
    input resetn,
  
    // Input stream
    input wire  input_s_axis_tvalid,
    input wire [(C_AXIS_BYTEWIDTH*8)-1: 0] input_s_axis_tdata,
    input wire [C_AXIS_BYTEWIDTH-1: 0] input_s_axis_tstrb,
    input wire  input_s_axis_tlast,
    output wire  input_s_axis_tready,
  
    // Output stream
    output wire  output_m_axis_tvalid,
    output wire [(C_AXIS_BYTEWIDTH*8)-1: 0] output_m_axis_tdata,
    output wire [C_AXIS_BYTEWIDTH-1: 0] output_m_axis_tstrb,
    output wire  output_m_axis_tlast,
    input wire  output_m_axis_tready,
  
    // Report registers
    output reg [31:0] byte_count,
    output reg [31:0] tlast_count
  );

  always @(posedge clk) begin
    if (~resetn) begin
      byte_count <= 0;
      tlast_count <= 0;
    end

    // Byte counter
    if(input_s_axis_tvalid & output_m_axis_tready) begin
      byte_count <= byte_count + C_AXIS_BYTEWIDTH;
    end

    // TLAST counter
    if(input_s_axis_tlast & output_m_axis_tready) begin
      tlast_count <= tlast_count + C_AXIS_BYTEWIDTH;
    end
  end


  // No data injection for now, just passthrough and monitor
  assign output_m_axis_tvalid = input_s_axis_tvalid;
  assign input_s_axis_tready = output_m_axis_tready;
  assign output_m_axis_tdata = input_s_axis_tdata;
  assign output_m_axis_tstrb = input_s_axis_tstrb;
  assign output_m_axis_tlast = input_s_axis_tlast;

endmodule

