//Copyright (C)2014-2025 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//Tool Version: V1.9.10.03 (64-bit) 
//Created Time: 2025-01-08 13:25:28
create_clock -name systemClockIn -period 37.037 -waveform {0 18.518} [get_ports {systemClockIn}]
create_clock -name baudOut -period 10 -waveform {0 5} [get_ports {baudOut}]
