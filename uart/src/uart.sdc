//Copyright (C)2014-2025 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//Tool Version: V1.9.11 (64-bit) 
//Created Time: 2025-02-20 19:16:41
create_clock -name systemClock -period 37.037 -waveform {0 18.518} [get_ports {systemClockIn}]
