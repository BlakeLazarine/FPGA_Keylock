// Created by fizzim.pl version 5.20 on 2020:06:04 at 12:21:54 (www.fizzim.com)

module controller (
  output wire CheckPC,
  output wire CheckValidUC,
  output wire Chillin,
  output wire LED2,
  output wire LED3,
  output wire LOCKING,
  output wire ToggleLED1,
  output wire error,
  input wire DoneBlink,
  input wire ValidNewUC,
  input wire clk,
  input wire [3:0] keypress,
  input wire matchPC,
  input wire matchUC,
  input wire rdy,
  input wire resetN
);

  // state bits
  parameter
  START            = 9'b000000000, // extra=0 error=0 ToggleLED1=0 LOCKING=0 LED3=0 LED2=0 Chillin=0 CheckValidUC=0 CheckPC=0
  BadLock          = 9'b010001000, // extra=0 error=1 ToggleLED1=0 LOCKING=0 LED3=0 LED2=1 Chillin=0 CheckValidUC=0 CheckPC=0
  BadRepro         = 9'b010010000, // extra=0 error=1 ToggleLED1=0 LOCKING=0 LED3=1 LED2=0 Chillin=0 CheckValidUC=0 CheckPC=0
  LockingUnlocking = 9'b000101000, // extra=0 error=0 ToggleLED1=0 LOCKING=1 LED3=0 LED2=1 Chillin=0 CheckValidUC=0 CheckPC=0
  ReproPhase1      = 9'b000010001, // extra=0 error=0 ToggleLED1=0 LOCKING=0 LED3=1 LED2=0 Chillin=0 CheckValidUC=0 CheckPC=1
  ReproPhase2      = 9'b000010010, // extra=0 error=0 ToggleLED1=0 LOCKING=0 LED3=1 LED2=0 Chillin=0 CheckValidUC=1 CheckPC=0
  ReproPhase3      = 9'b100010010, // extra=1 error=0 ToggleLED1=0 LOCKING=0 LED3=1 LED2=0 Chillin=0 CheckValidUC=1 CheckPC=0
  SUCCESS          = 9'b000010100, // extra=0 error=0 ToggleLED1=0 LOCKING=0 LED3=1 LED2=0 Chillin=1 CheckValidUC=0 CheckPC=0
  correct UC       = 9'b001000000; // extra=0 error=0 ToggleLED1=1 LOCKING=0 LED3=0 LED2=0 Chillin=0 CheckValidUC=0 CheckPC=0

  reg [8:0] state;
  reg [8:0] nextstate;

  // comb always block
  always @* begin
    // Warning I2: Neither implied_loopback nor default_state_is_x attribute is set on state machine - defaulting to implied_loopback to avoid latches being inferred
    nextstate = state; // default to hold value because implied_loopback is set
    case (state)
      START           : begin
        // Warning P3: State START has multiple exit transitions, and transition trans0 has no defined priority
        // Warning P3: State START has multiple exit transitions, and transition trans8 has no defined priority
        if (rdy&(keypress==9)) begin
          nextstate = LockingUnlocking;
        end
        else if (rdy&(keypress==8)) begin
          nextstate = ReproPhase1;
        end
        else begin
          nextstate = START;
        end
      end
      BadLock         : begin
        if (DoneBlink) begin
          nextstate = START;
        end
        else begin
          nextstate = BadLock;
        end
      end
      BadRepro        : begin
        if (DoneBlink) begin
          nextstate = START;
        end
        else begin
          nextstate = BadRepro;
        end
      end
      LockingUnlocking: begin
        // Warning P3: State LockingUnlocking has multiple exit transitions, and transition trans13 has no defined priority
        // Warning P3: State LockingUnlocking has multiple exit transitions, and transition trans2 has no defined priority
        // Warning P3: State LockingUnlocking has multiple exit transitions, and transition trans3 has no defined priority
        // Warning P3: State LockingUnlocking has multiple exit transitions, and transition trans4 has no defined priority
        if (rdy&(keypress==7)) begin
          nextstate = BadLock;
        end
        else if (!rdy | (keypress !=7 & keypress != 9)) begin
          nextstate = LockingUnlocking;
        end
        else if (rdy & (keypress == 9) & matchUC) begin
          nextstate = correct UC;
        end
        else if (rdy & (keypress == 9) & !matchUC) begin
          nextstate = BadLock;
        end
      end
      ReproPhase1     : begin
        // Warning P3: State ReproPhase1 has multiple exit transitions, and transition trans11 has no defined priority
        // Warning P3: State ReproPhase1 has multiple exit transitions, and transition trans17 has no defined priority
        // Warning P3: State ReproPhase1 has multiple exit transitions, and transition trans27 has no defined priority
        if (!rdy | (keypress !=7 & keypress != 8)) begin
          nextstate = ReproPhase1;
        end
        else if (rdy & (keypress == 8) & matchPC) begin
          nextstate = ReproPhase2;
        end
        else if (rdy & (((keypress == 8) & !matchPC) | (keypress==7))) begin
          nextstate = BadRepro;
        end
      end
      ReproPhase2     : begin
        // Warning P3: State ReproPhase2 has multiple exit transitions, and transition trans18 has no defined priority
        // Warning P3: State ReproPhase2 has multiple exit transitions, and transition trans26 has no defined priority
        if (rdy & (keypress == 8) & validUC) begin
          nextstate = ReproPhase3;
        end
        else if (rdy&((keypress==7) & (keypress == 8) & validUC)) begin
          nextstate = BadRepro;
        end
        else begin
          nextstate = ReproPhase2;
        end
      end
      ReproPhase3     : begin
        // Warning P3: State ReproPhase3 has multiple exit transitions, and transition trans19 has no defined priority
        // Warning P3: State ReproPhase3 has multiple exit transitions, and transition trans25 has no defined priority
        if (rdy & (keypress == 8) & validUC) begin
          nextstate = SUCCESS;
        end
        else if (rdy&((keypress==7) & (keypress == 8) & validUC)) begin
          nextstate = BadRepro;
        end
        else begin
          nextstate = ReproPhase3;
        end
      end
      SUCCESS         : begin
        if (DoneBlink) begin
          nextstate = START;
        end
        else begin
          nextstate = SUCCESS;
        end
      end
      correct UC      : begin
        begin
          nextstate = START;
        end
      end
    endcase
  end

  // Assign reg'd outputs to state bits
  assign CheckPC = state[0];
  assign CheckValidUC = state[1];
  assign Chillin = state[2];
  assign LED2 = state[3];
  assign LED3 = state[4];
  assign LOCKING = state[5];
  assign ToggleLED1 = state[6];
  assign error = state[7];

  // sequential always block
  always @(posedge clk or negedge resetN) begin
    if (!resetN)
      state <= START;
    else
      state <= nextstate;
  end

  // This code allows you to see state names in simulation
  `ifndef SYNTHESIS
  reg [127:0] statename;
  always @* begin
    case (state)
      START           :
        statename = "START";
      BadLock         :
        statename = "BadLock";
      BadRepro        :
        statename = "BadRepro";
      LockingUnlocking:
        statename = "LockingUnlocking";
      ReproPhase1     :
        statename = "ReproPhase1";
      ReproPhase2     :
        statename = "ReproPhase2";
      ReproPhase3     :
        statename = "ReproPhase3";
      SUCCESS         :
        statename = "SUCCESS";
      correct UC      :
        statename = "correct UC";
      default         :
        statename = "XXXXXXXXXXXXXXXX";
    endcase
  end
  `endif

endmodule