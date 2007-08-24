@ERASE

0 REM this is the base code for all the AIRcable OS products
0 REM we take the AIRcable SMD/Mini as our base device

0 REM moved from UART command line to SPP as default.

0 REM let's reserve the first 30 lines for internal stuff

0 REM $1 is the version of the command line
1 0.8SPP

0 REM defaults setting for mode
0 REM uncomment the one you want to use as default
0 REM service slave
2 1110
0 REM service master 3110
0 REM cable slave 1010
0 REM cable master 3010
0 REM idle 0010

0 REM $3 stores the mode configuration
0 REM $3[0] = 0 48 means idle
0 REM $3[0] = 1 49 means pairing as slave
0 REM $3[0] = 2 50 means paired as slave           
0 REM $3[0] = 3 51 means pairing as master
0 REM $3[0] = 4 52 means paired as master
0 REM $3[0] = 5 53 means relay pairing
0 REM $3[0] = 6 54 means relay paired
0 REM $3[0] = 7 55 means relay slave connected, master connecting
0 REM $3[0] = 8 56 means relay connected

0 REM $3[1] = 0 48 cable mode
0 REM $3[1] = 1 49 service mode
0 REM $3[1] = 2 50 relay mode

0 REM $3[2] = 0 48 device found / module paired
0 REM $3[2] = 1 49 inquiry needed

0 REM the numbers that are missing had been removed, camed from UART
0 REM $3[3] = 0 48 means automatic
0 REM $3[3] = 1 49 means manual idle.
0 REM $3[3] = 3 51 manual inq
0 REM $3[3] = 4 52 manual master, connecting
0 REM $3[3] = 6 54 manual master, connected
0 REM $3[3] = 7 55 relay pairing

0 REM $3[4] = 1 49 means service relay mode
0 REM $3[4] = 2 50 means cable relay mode

0 REM $3[5] stores previous mode when accessing SPP command line.

0 REM if var K = 1 then we must do a slave-1

0 REM $3[4] is the amount of time we trigger alarms while on manual
0 REM need service-master mode, does not store pairing information starts 
0 REM with pairing
3 Z

0 REM $4 IS RESERVED FOR PAIRED ADDR
4 0

0 REM $5 stores the name of the devices we only want during inquiry
5 AIRcable

0 REM $6 stores the filter address we filter on during inquiry
6 0050C2

0 REM $7 for paired master addresses
7 0

0 REM $8 stores the pio settings
0 REM $8[0] BLUE LED
0 REM $8[1] GREEN LED
0 REM $8[2] BUTTON
0 REM $8[3] RS232 POWER OFF
0 REM $8[4] RS232 POWER ON
0 REM $8[5] DTR
0 REM $8[6] DSR
0 REM $8[7] POWER SWITCH
0 REM $8[8] COMMAND LINE PIN
0 REM $8[9] BATTERY MEASURMENT ENABLED 0 - 1
0 REM LINE $12 STORES THE DEFAULT VALUE
0 REM z means unitializated
8 z

0 REM Debug settings
0 REM first char is for Z enabled/disabled
0 REM second is for dumping states
0 REM third for Obex/ObexFTP
0 REM 0 48 Enabled only on command line
0 REM 1 49 Always enabled
0 REM 2 50 Always Disabled
9 000

0 REM $10 stores our friendly name
10 AIRcableSMD

0 REM $11 stores our PIN
11 1234

0 REM DEFAULT pio settings IN ORDER
0 REM BLUE LED
0 REM GREEN LED
0 REM BUTTON
0 REM RS232 POWER OFF
0 REM RS232 POWER ON
0 REM DTR
0 REM DSR
0 REM POWER SWITCH
0 REM COMMAND LINE PIN
0 REM BATERY MEASURMENT ENABLED
12 K000000000

0 REM PIO_IRQ SETTINGS@
0 REM $13 Button + Power Switch + Command Line. For no connections
0 REM autogenerated in first bootup
13 0
0 REM $14 button + DSR interrupt + Power Switch. While connected
0 REM autogenerated in first bootup
14 0

0 REM 15 is the settings for the uart when a connection is made
0 REM 0 means read from dip swithces
0 REM any other number is converted to an int.
15 1152

0 REM 16 this is the time that the Obex/ObexFTP will be available after
0 REM boot up
16 120

0 REM on variable we store the baud rate setting.
0 REM this variable is initializated by @SENSOR
0 REM and is not set until a connection is stablished


0 REM $20 is used for relay mode, it stores the master address
20 000000000000

0 REM $21 PIO_IRQ for off mode, only Power Switch measurment.
21 0

0 REM 22 Parity Settings
0 REM [0] = "0" = none
0 REM "1" = even
0 REM "2" = odd
0 REM [1] = "0" 1 stop bit
0 REM "1" 2 stop bits
22 000

0 REM 23 unique settings
0 REM [0] = "0" don't add nothing
0 REM [0] = "1" add unique name
0 REM [0] = "2" add unique name, generate pin
23 1

0 REM reserved for manual master and inq.
24 RESERVED

0 REM $39 RESERVED
39 RESERVED

0 REM W = 0 no button press
0 REM W = 1 short button press
0 REM W = 2 long button press

0 REM K = 0 nothing to do
0 REM K = 1 need to do slave-1
0 REM K = 2 slave-1 has been made

0 REM THIS TURNS A CHAR AT $0[E] into
0 REM and integer in F
40 IF $0[E] > 57 THEN 43
41 F = $0[E] - 48;
42 RETURN
0 REM WE NEED TO ADD 10 BECAUSE "A" IS NOT 0
0 REM IS 10
43 F = $0[E] - 55;
44 RETURN


@INIT 45
45 Z = $9[0] - 48;
46 A = baud 1152

49 IF $8[0] <> 122 THEN 73

0 REM first boot.
50 $0[0] = 0
51 PRINTV $12
52 FOR E = 0 TO 9
53 GOSUB 40
54 $8[E] = F + 48
55 NEXT E
56 $8[E+1] = 0
57 $0[0] = 0;
58 PRINTV"P000000000000";
59 $13 = $0;
60 $14 = $0;
61 $21 = $0;

62 IF $8[2] = 48 THEN 65;
63 $13[$8[2]-48] = 49;
64 $14[$8[2]-48] = 49;
65 IF $8[6] = 48 THEN 67;
66 $14[$8[6]-48] = 49;
67 IF $8[7] = 48 THEN 71;
68 $13[$8[7]-48] = 49;
69 $14[$8[7]-48] = 49;
70 $21[$8[7]-48] = 49;
71 IF $8[8] = 48 THEN 73;
72 $13[$8[8]-48] = 49;

73 GOSUB 939

74 H = 1

0 REM button as input
75 A = pioin ($8[2]-48);
0 REM bias pull up to high
76 A = pioset ($8[2]-48);
0 REM green LED output, off
77 A=pioout ($8[1]-48);
78 A=pioclr ($8[1]-48);
0 REM blue LED output, off
79 A=pioout ($8[0]-48)
0 REM RS232_off set, switch on RS232
80 A=pioout ($8[3]-48)
81 A=pioset ($8[3]-48)
0 REM RS232_on power on, switch to automatic later
82 A=pioout ($8[4]-48)
83 A=pioset ($8[4]-48)
0 REM DTR output set -5V
84 A=pioout ($8[5]-48)
85 A=pioset ($8[5]-48)
0 REM DSR input
0 REM this line is changed by serial OS code, so update
86 A=pioin ($8[6]-48)
0 REM Command line Enable switch
87 A = pioin ($8[8]-48)
88 A = pioset ($8[8]-48)

0 REM start baud rate
0 REM 80 A = uartcfg 136
0 REM 81 A = nextsns 6
0 REM reset for pairing timeout
89 A = zerocnt

0 REM state initialize
92 IF $3[0] <> 90 THEN 94
0 REM newly updated BASIC program, goto SLAVE mode
93 $3 = $2;

0 REM init button state
94 W = 0

0 REM blue LED off
95 A = pioclr ($8[0]-48)
96 J = 0

97 $3[3] = 48;

0 REM should go to mode dump
98 IF $9[1] = 48 THEN 100
99 GOSUB 690

0 REM let's start up, green LED on
100 A = pioset ($8[1]-48)

101 K = 1
102 H = 1
103 M = 0
104 A=pioirq $13
105 RETURN

0 REM Obex/ObexFTP timing handler
0 REM this code is also called from the command line on exit
130 B = readcnt
131 C = atoi $16
132 IF B < C THEN 139
133 GOSUB 137
134 H = 0
135 GOTO 339

136 IF $9[2] = 49 THEN 138
137 A = disable 3
138 RETURN

139 ALARM 30
140 GOTO 339

@SENSOR 141
141 IF $22[2] > 48 THEN 154
142 IF $8[9] = 48 THEN 153
143 A = sensor $0
144 V = atoi $0[5]
145 A = nextsns 600
146 IF V < 3000 THEN 148
147 GOTO 151

148 N = 1
149 ALARM 5
150 GOTO 153

151 N = 0
152 ALARM 5
153 RETURN
0 REM baud rate selector switch implementation
0 REM thresholds (medians) for BAUD rate switch
0 REM AIO0 has voltage, use 1000 (3e8) as analog correction factor
0 REM if it is smaller than this, then switch is set
0 REM voltages: 160, 450, 650, 810, 930, 1020, 1090, >
0 REM switch    111, 110, 101, 100, 011,  010,  001, 000
0 REM baud:    1152,  96, 384, 000, 576,   48,  192, 321
154 D = $22[2]
155 $22[2]= D -1
156 IF $15[0] = 48 THEN 161;
0 REM we need to convert from string to integer, because we are on internal
0 REM baud rate, if an error ocurs while converting, then we switch
0 REM to the dip's automatically
157 C = atoi $15;
158 IF C = 0 THEN 161;
159 I = C;
160 GOTO 186
161 C = sensor $0;
162 IF C < 160 THEN 171;
163 IF C < 450 THEN 173;
164 IF C < 650 THEN 175;
165 IF C < 810 THEN 177;
166 IF C < 930 THEN 179;
167 IF C < 1020 THEN 181;
168 IF C < 1090 THEN 183;
169 I = 321;
170 GOTO 199;

171 I = 8;
172 GOTO 226;
173 I = 3;
174 GOTO 226;
175 I = 5;
176 GOTO 226;
177 I = 1152;
178 GOTO 160;
179 I = 6;
180 GOTO 226;
181 I = 2;
182 GOTO 226;
183 I = 4;
184 GOTO 226;

185 RETURN

186 IF I = 12 THEN 201
187 IF I = 24 THEN 203
188 IF I = 48 THEN 205
189 IF I = 96 THEN 207
190 IF I = 209 THEN 209
191 IF I = 384 THEN 211
192 IF I = 576 THEN 213
193 IF I = 769 THEN 215
194 IF I = 1152 THEN 217
195 IF I = 2304 THEN 219
196 IF I = 4608 THEN 221
197 IF I = 9216 THEN 223
198 IF I = 13824 THEN 225
0 REM wrong settings for baud rate, we don't have a fixed value, we can't do
0 REM parity and stop bits
199 A = baud I
200 RETURN

201 I = 0
202 GOTO 226
203 I = 1
204 GOTO 226
205 I = 2
206 GOTO 226
207 I = 3
208 GOTO 226
209 I = 4
210 GOTO 226
211 I = 5
212 GOTO 226
213 I = 6
214 GOTO 226
215 I = 7
216 GOTO 226
217 I = 8
218 GOTO 226
219 I = 9
220 GOTO 226
221 I = 10
222 GOTO 226
223 I = 11
224 GOTO 226
225 I = 12

226 IF $22[0] = 49 THEN 229
227 IF $22[0] = 50 THEN 231
228 GOTO 232
229 I = I + 64
230 GOTO 232
231 I = I + 32
232 IF $22[1] = 49 THEN 235
233 GOTO 235
234 I = I + 16
235 I = I + 128
236 A = uartcfg I
237 RETURN


0 REM handle button press and DSR, status is $0
@PIO_IRQ 241
241 IF L = 1 THEN 252
242 IF $8[7] = 48 THEN 253
243 A = pioget ($8[7]-48)
244 IF A = 1 THEN 253

0 REM turn off, we do a reboot, hardware will do the rest.
245 A = reboot
246 WAIT 10
247 RETURN


252 L = 0

253 A = pioget($8[8]-48);
254 IF A = 1 THEN 256
255 ALARM 1

0 REM press button starts alarm for long press recognition
256 IF $0[$8[2]-48]=48THEN294
0 REM speaciall tratement for Button release on rebooting
257 IF W = 3 THEN 185
0 REM was it a release, now handle it
258 IF W <> 0 THEN 267

0 REM button no pressed, button not released
0 REM when DSR on the RS232 changes
259 IF $0[$8[6]-48]=48THEN262;
260 IF $0[$8[6]-48]=49THEN264;
261 RETURN
0 REM modem control to the other side
262 A = modemctl 0;
263 RETURN
264 A = modemctl 1;
265 RETURN

0 REM released with W == 2, alarm already handled it, exit
266 IF W = 2 THEN 290

0 REM this is a short button press
0 REM if we are on idle mode, then we switch to cable slave
0 REM if we are on service or cable unnconnected then switch master <-> slave
0 REM there is a slight difference between this spec, and the last one
0 REM on the last one any button press while on service did nothing.
267 B = status;
268 IF B < 10000 THEN 270;
269 B = B - 10000;
270 IF B > 0 THEN 299;
271 IF $3[0] = 48 THEN 281;
272 IF $3[0] > 50 THEN 281;

0 REM we were slave, now lets go to master.
273 ALARM 0
276 $3[0] = 51;
277 W = 0;
278 B = zerocnt;
279 A = slave-1
280 RETURN

0 REM switch to pair as slave
281 ALARM 0
284 $3[0] = 49
285 W = 0
286 A = zerocnt;
0 REM cancel inquiries
287 A = cancel
288 ALARM 1
289 RETURN

290 W = 0
291 RETURN


0 REM button press, recognize it and start ALARM for long press
294 W = 1
295 ALARM 3
296 RETURN

299 W = 0
300 RETURN

0 REM idle will be called, when the command line ends working
0 REM when the slave connection is closed, and when slave calls
0 REM timeouts, in any of those cases we will let the @ALARM
0 REM handle the slave mode stuff
0 REM idle used for slave connections, pairing or paired
@IDLE 303
303 L = 0;

304 IF $3[3] <> 48 THEN 977;
305 IF K = 1 THEN 308;
306 IF K = 2 THEN 309;
0 REM start alarm
307 GOTO 330

0 REM slave mode? 
0 REM 314 IF $3[0] > 50 THEN 354

0 REM 315 IF $3[1] = 49 THEN 319;
0 REM 316 IF $3[0] = 50 THEN 321;
0 REM 317 B = readcnt;
0 REM 318 IF B > 120 THEN 419;
0 REM 319 A = slave 5;
0 REM 320 GOTO 979;
0 REM 321 A = slave -5;
0 REM 322 GOTO 979

308 A = slave-1
309 K = 0;
310 GOTO 981



@PIN_CODE 311
311 IF $23[0] = 50 THEN 314
312 $0=$11;
313 RETURN
314 A = getuniq $0
315 RETURN

0 REM ALARM code, handles modes stuff, LEDs and long button press 
@ALARM 330
330 IF N = 0 THEN 333
331 A = pioclr ($8[1]-48)
332 A = pioset ($8[1]-48);

0 REM check if the command line is accesible or not.
333 A = pioget($8[8]-48)
334 IF A = 1 THEN 336

0 REM Command Line is accessible.
335 GOTO 968

0 REM are we on automatic or manual?
336 IF $3[3] <> 48 THEN 816;

0 REM handle button press first of all.
337 IF W = 1 THEN 395

338 IF H = 1 THEN 130

339 IF $3[0] > 52 THEN 874

0 REM now the led stuff, and finally we handle the state.
0 REM firstly see if we are connected, then do what you need
340 B = status
341 IF B < 10000 THEN 343
342 B = B - 10000
343 IF B > 0 THEN 345
344 GOTO 350
0 REM ensure the leds are on
345 A = pioset ($8[0]-48)
346 A = pioset ($8[1]-48)
347 ALARM 5
348 RETURN

0 REM we are on automatic.
0 REM are we on automatic - manual?
349 IF $3[0] = 48 THEN 390

0 REM LED SCHEMA:
0 REM CABLE 	SLAVE 	1 fast blink
0 REM SERVICE 	SLAVE 	2 fast blink
0 REM CABLE	MASTER 	3 fast blink
0 REM SERVICE	MASTER 	4 fast blink
350 A = pioset ($8[1]-48);
351 A = pioset ($8[0]-48)
352 A = pioclr ($8[0]-48);
0 REM are we on master or slave?
353 IF $3[0] > 50 THEN 382
0 REM ok we are on slave
0 REM CABLE 	SLAVE 1 fast BLINK
0 REM SERVICE 	SLAVE 2 fast BLINK

0 REM cable or service?
354 IF $3[1] = 49 THEN 358;
355 IF $3[0] = 50 THEN 360;
356 B = readcnt;
357 IF B > 120 THEN 419;
358 A = slave 30;
359 GOTO 361;
360 A = slave -30;
361 IF H = 0 THEN 363
362 GOSUB 983
363 ALARM 5

0 REM now are we on cable or service?
364 IF $3[1] = 48 THEN 367
0 REM service slave
365 A = pioset ($8[0]-48)
366 A = pioclr ($8[0]-48);
367 RETURN;

0 REM we are on master modes
382 FOR B = 0 TO 1
383 A = pioset ($8[0]-48)
384 A = pioclr ($8[0]-48
385 NEXT B
386 IF $3[1] = 48 THEN 434;
387 A = pioset ($8[0]-48)
388 A = pioclr ($8[0]-48);
389 GOTO 423;


0 REM manual idle code, this is the only mode that ends here.
390 B = pioset ($8[1]-48)
391 B = pioclr ($8[0]-48)
392 A = slave-1
393 K = 2
394 RETURN

0 REM this is a long button press, we have stuff to do
0 REM if we are connected, then we disconnect and reboot to unpaired
0 REM if we aren't then we must reboot and go to idle mode.
395 GOSUB 920;
396 W = 2
397 IF $39[3] = 49 THEN 409
398 IF $39[4] = 49 THEN 409

0 REM reboot 
399 $3[0] = 48
400 $3[1] = 48
401 A = pioclr($8[0]-48);
404 A = pioclr($8[1]-48);
405 W = 3
406 A = reboot
407 WAIT 3;
408 RETURN

0 REM disconnects, disconnect restarts @IDLE
409 ALARM 0
0 REM if we were paired, then we must unpair.
412 IF $3[0] = 50 THEN 415
413 IF $3[0] = 52 THEN 415
414 GOTO 417;
415 A = $3[0]
416 $3[0] = A -1
0 REM 307 A = disconnect 0
0 REM 308 A = disconnect 1
0 REM 309 A = cancel
417 $7 = "0"
418 GOTO 401

0 REM cable mode timeout
419 ALARM 0;
420 GOTO 390;

0 REM service - master
423 A = strlen $7;
424 IF A > 1 THEN 428
425 A = inquiry 8
426 ALARM 15
427 RETURN

428 A = master $7
429 IF $3[1] = 48 THEN 431
430 $7 = "0"
0 REM master returns 0 if the connection was succesfull
0 REM or if we are still trying to connect.
431 IF A = 0 THEN 345
432 ALARM 8
433 RETURN

0 REM cable code, if we are not paired check for timeout.
434 IF $3[0] = 52 THEN 428
435 B = readcnt
436 IF B > 120 THEN 419
0 REM we are pairing as master,
437 GOTO 425;

0 REM this interrupt is launched when there is an incomming
0 REM slave connection
@SLAVE 438
438 A = pioget($8[8]-48);
439 IF A <> 1 THEN 467;
440 IF $3[0] = 54 THEN 911;
0 REM if we are not on slave mode, then we must ignore slave connections :D

443 IF $3[0] > 50 THEN 465;
444 IF $3[0] > 48 THEN 446;
445 GOTO 465

446 A = getconn $7
0 REM if we are on service-slave, and the PIN was a success
0 REM then this is our peer.
447 IF $3[1] = 49 THEN 455
0 REM cable-slave-paired, check address
448 IF $3[0] = 50 THEN 452

0 REM set to paired no matter who cames
449 $3[0] = 50
450 $4 = $7
451 GOTO 455

0 REM check address of the connection and allow
452 $0 = $4
453 B = strcmp $7
454 IF B <> 0 THEN 465

0 REM slave connected
0 REM set interrupts to connected mode.
0 REM green and blue LEDS on
0 REM read sensors
455 A = nextsns 1
456 $22[2] = 50
457 B = pioset ($8[1]-48)
458 B = pioset ($8[0]-48)
0 REM set RS232 power to on
459 A = pioset ($8[4]-48)
0 REM DTR set on, +5V
460 A = pioclr ($8[5]-48)
0 REM set interrupts to connected mode.
461 A = pioirq $14
0 REM connect RS232 to slave
462 ALARM 0
463 C = link 1
464 RETURN

0 REM disconnect and exit
465 A = disconnect 0
466 RETURN

0 REM the user has selected to enabled the command line.
0 REM does he really want to get into?
467 TIMEOUTS 5
468 INPUTS $0
469 A = strlen $0
470 IF A < 3 THEN 440
471 IF $0[A-3] <> 43 THEN 440
472 IF $0[A-1] <> 43 THEN 440
473 GOTO 558

@MASTER 474
0 REM successful master connection
474 IF $3[0] > 52 THEN 886
0 REM if we are on manual master, then we have some requests
477 IF $3[3] <> 52 THEN 485

0 REM manual mode master
478 $3[3] = 54
479 A = pioset ($8[1]-48);
480 A = pioset ($8[0]-48);
481 PRINTS"\n\rCONNECTED\n\r"
482 A = link 3
483 ALARM 5
484 RETURN

0 REM if we are not on master modes, then we must avoid this connection.
485 IF $3[0] > 50 THEN 488;
486 IF $3[0] > 48 THEN 500;
487 IF $3[0] = 48 THEN 500;
488 A = pioset ($8[1]-48);
489 A = pioset ($8[0]-48);
0 REM don't switch state in service mode
490 IF $3[1] = 49 THEN 492
0 REM set state master paired
491 $3[0] = 52

0 REM read sensors
492 A = nextsns 1
493 $22[2] = 50
494 A = pioset ($8[4]-48);
0 REM DTR set on
495 A = pioclr ($8[5]-48);
0 REM link
496 A = link 2
0 REM look for disconnect
497 ALARM 5
0 REM allow DSR interrupts
498 A = pioirq $14
499 RETURN

500 A = disconnect 1
501 RETURN

0 REM $502 RESERVED
502 RESERVED
0 REM inquiry code, only in mode pair_as_master
@INQUIRY 503
503 $502 = $0
504 IF $3[3] <> 51 THEN 511
507 PRINTS"\n\rFound device: "
508 PRINTS $502
509 ALARM 4
510 RETURN

511 $4 = $502;
512 $502 = $0[13];
513 IF $3[0] <> 51 THEN 516;
0 REM inquiry filter active
514 IF $3[2] = 48 THEN 516;
515 GOTO 517
516 RETURN

517 IF $9[1] = 48 THEN 520;
518 PRINTS "found "
519 PRINTS $4
0 REM check name of device
520 $0[0]=0;
521 PRINTV $502;
522 B = strcmp $5;
523 IF B <> 0 THEN 533;
524 $0 = $4
525 B = strcmp $6;
526 IF B <> 0 THEN 533

0 REM found one, try to connect, inquiry canceled automaticall
0 REM 447 GOSUB 485;
527 B = master $4;
0 REM if master busy keep stored address in $4, get next
528 IF B = 0 THEN 534;
0 REM master accepted, store address, restart alarms, give it 8 seconds to connect
0 REM corrected by mn
529 $7 = $4;
530 ALARM 8;
0 REM all on to indicate we have one
531 A = pioset ($8[1]-48);
532 A = pioset ($8[0]-48);
533 RETURN

0 REM get next result, give the inq result at least 2 sec time
534 GOSUB 536;
535 RETURN

0 REM blink sub-routine pair as master mode, blue-on green-off and reverse
536 IF J = 1 THEN 541;
537 J = 1;
538 A = pioset ($8[0]-48);
539 A = pioclr ($8[1]-48);
540 RETURN
541 A = pioclr ($8[0]-48);
542 A = pioset ($8[0]-48);
543 J = 0;
544 RETURN;

@CONTROL 545
0 REM remote request for DTR pin on the RS232
545 IF $0[0] < 128 THEN 548
546 A = uartcfg$0[0]
547 RETURN
548 IF $0[0] = 49 THEN 550;
549 A=pioset ($8[5]-48);
550 RETURN;
551 A=pioclr ($8[5]-48);
552 RETURN

0 REM read from Service slave.
0 REM result is on $551
0 REM 553 RESERVED FOR TEMP
0 REM C = $551[0]
553 RESERVED
554 $553[0] = 0;
555 INPUTS $553
556 C = $553[0]
557 RETURN

0 REM command line interface
558 ALARM 0
559 A = pioirq $14
560 A = pioclr ($8[0]-48);
561 A = pioclr ($8[1]-48);
562 $3[3] = 49
0 REM enable FTP again
563 A = enable 3
564 PRINTS "\r\nAIRcable OS "
565 PRINTS "command line v
566 PRINTS $1
567 PRINTS "\r\nType h to "
568 PRINTS "see the list of "
569 PRINTS "commands";
570 PRINTS "\n\rAIRcable> "
571 GOSUB 554;
572 A = status
573 IF A = 0 THEN 601

0 REM h: help, l: list,
0 REM n: name, p: pin, b: name filter, g: address filter
0 REM c: class of device, u: uart, d: date,
0 REM s: slave, i: inquiry, m: master, a: mode
0 REM o: obex
0 REM e: exit

0 REM help
574 IF C = 104 THEN 711;
0 REM info
575 IF C = 108 THEN 609;
0 REM name
576 IF C = 110 THEN 726;
0 REM pin
577 IF C = 112 THEN 731;
0 REM class
578 IF C = 99 THEN 735;
0 REM uart
579 IF C = 117 THEN 632;
0 REM date
580 IF C = 100 THEN 761;
0 REM inquiry
581 IF C = 105 THEN 831;
0 REM shell
582 IF C = 115 THEN 947;
0 REM master
583 IF C = 109 THEN 841;
0 REM obex
584 IF C = 111 THEN 771;
0 REM modes
585 IF C = 97 THEN 660;
0 REM exit
586 IF C = 101 THEN 600;
0 REM name filter
587 IF C = 98 THEN 751;
0 REM addr filter
588 IF C = 103 THEN 756;
0 REM hidden debug settings
589 IF C = 122 THEN 596;
0 REM reboot
590 IF C = 114 THEN 791;
0 REM name/pin settings
592 IF C = 107 THEN 798;
0 REM PIO settings
593 IF C = 113 THEN 949
594 PRINTS"Command not found
595 GOTO 570;

596 PRINTS"Input settings: "
597 GOSUB 554
598 $9 = $553
599 GOTO 963

0 REM exit code, we end with slave-1 to ensure
0 REM that @SLAVE starts all again, and that
0 REM we start unvisible
600 PRINTS "Bye!!\n\r
601 GOSUB 136;
602 $3[3] = 48;
603 A = slave -1
604 A = disconnect 0
605 A = zerocnt
606 A = pioset($8[1]-48);
607 M = 0
608 RETURN

0 REM ----------------------- Listing Code ------------------------------------
609 PRINTS"Command Line v
610 PRINTS $1
611 PRINTS"\n\rName: ";
612 PRINTS $10;
613 PRINTS"\n\rPin: ";
614 PRINTS$11;
615 A = psget 0;
616 PRINTS"\n\rClass: ";
617 PRINTS $0;
618 PRINTS"\n\rBaud Rate: "
619 GOSUB 654
620 PRINTS"\n\rDate: ";
621 A = date $0;
622 PRINTS $0;
623 A = getaddr;
624 PRINTS"\n\rBT Address: 
625 PRINTS $0
626 PRINTS"\n\rName Filter: 
627 PRINTS $5;
628 PRINTS"\n\rAddr Filter: 
629 PRINTS $6;
630 GOSUB 690
631 GOTO 570;

632 PRINTS"Enter new Baud Ra
633 PRINTS"te divide by 100,
634 PRINTS"or 0 for switches
635 PRINTS": "
636 GOSUB 554
637 $15 = $553
638 PRINTS"\n\r"
639 PRINTS"Parity settings:\n
640 PRINTS"\r0 for none\n\r
641 PRINTS"1 for even\n\r
642 PRINTS"2 for odd: "
643 GOSUB 554
645 $22[0] = C
646 PRINTS"\n\rStop Bits settin"
647 PRINTS"gs:\n\r0 for 1 stop
648 PRINTS" bit\n\r1 for 2 stop
649 PRINTS" bits:
650 GOSUB 554
652 $22[1] = C
653 GOTO 570

654 IF $15[0] = 48 THEN 658
655 PRINTS $15
656 PRINTS "00 bps
657 RETURN
658 PRINTS "External
659 RETURN

0 REM -------------------------- Modes chooser --------------------------------
0 REM the user should select between
0 REM 0: Manual
0 REM 1: Service Slave
0 REM 2: Service Master
0 REM 3: Cable Slave
0 REM 4: Cable Master
0 REM 5: Master Relay Mode
0 REM Mode:
660 PRINTS"Select new mode\n
661 PRINTS"\r0: Manual\n\r1:
662 PRINTS" Service Slave\n
663 PRINTS"\r2: Service Mast
664 PRINTS"er\n\r3: Cable Sl
665 PRINTS"ave\n\r4: Cable M
666 PRINTS"aster\n\rMode: "
667 GOSUB 554;
668 IF C = 48 THEN 676;
669 IF C = 49 THEN 679;
670 IF C = 50 THEN 682;
671 IF C = 51 THEN 685;
672 IF C = 52 THEN 688;
673 PRINTS"\n\rInvalid Option
674 GOTO 570;

0 REM idle
675 0010
676 $3 = $675
677 GOTO 570
0 REM service slave
678 1110
679 $3 = $678
680 GOTO 570
0 REM service master
681 3110
682 $3 = $681
683 GOTO 570
0 REM cable slave
684 1010
685 $3 = $684
686 GOTO 570
0 REM cable master
687 3010
688 $3 = $687
689 GOTO 570

0 REM -------------------------- Listing code ---------------------------------
690 PRINTS "\n\rMode: "
691 IF $3[0] > 52 THEN 709
692 IF $3[0] = 48 THEN 707
693 IF $3[1] = 48 THEN 696
694 PRINTS"Service - "
695 GOTO 697;
696 PRINTS"Cable - "
697 IF $3[0] >= 51 THEN 700;
698 PRINTS"Slave"
699 GOTO 701;
700 PRINTS"Master"
701 IF $3[0] = 50 THEN 705;
702 IF $3[0] = 52 THEN 705;
703 PRINTS"\n\rUnpaired"
704 RETURN
705 PRINTS"\n\rPaired"
706 RETURN
707 PRINTS"Idle"
708 RETURN
709 PRINTS"Relay Mode Master
710 RETURN

0 REM ----------------------- Help code ---------------------------------------
0 REM h: help, l: list,
0 REM n: name, p: pin, k: name/pin settings, 
0 REM b: name filter, g: address filter,
0 REM c: class of device, u: uart, d: date,
0 REM i: inquiry, m: master, a: mode,
0 REM o: obex, f: obexftp,
0 REM e: exit, r: reboot, s: shell,
0 REM q: PIO settings
711 PRINTS"h: help, l: list,\n"
712 PRINTS"\rn: name, p: pin, "
713 PRINTS"k: name/pin setting"
714 PRINTS"s,\n\rb: name filte"
715 PRINTS"r, g: address filte"
716 PRINTS"r,\n\rc: class of d"
717 PRINTS"evice, u: uart, d: "
718 PRINTS"date,\n\ri: inquiry"
719 PRINTS", m: master, a: mode"
720 PRINTS",\n\ro: obex,"
721 PRINTS"\n\re: exit, r:"
722 PRINTS" reboot, s: shell,\n"
723 PRINTS"\rq: PIO settings"
724 GOTO 570;

0 REM Name Function
726 PRINTS"New Name: "
727 GOSUB 554;
728 $10 = $553;
729 GOSUB 939
730 GOTO 570

0 REM Pin Function
731 PRINTS"New PIN: ";
732 GOSUB 554;
733 $11 = $553;
734 GOTO 570

735 PRINTS"Type the class of "
736 PRINTS"device as xxxx xxx"
737 PRINTS"x: "
738 GOSUB 554
739 $0[0] = 0;
740 PRINTV"@0000 =
741 PRINTV$553;
742 $553 = $0;
743 A = psget 0;
744 $39 =$0
745 $0[0]=0;
746 PRINTV $553;
747 $553 = $39[17]
748 PRINTV $553;
749 A = psset 3
750 GOTO 570

0 REM friendly name filter code
751 PRINTS"\r\rEnter the new na"
752 PRINTS"me filter: "
753 GOSUB 554
754 $5 = $553
755 GOTO 570;

0 REM addr filter code
756 PRINTS"Enter the new addr"
757 PRINTS"ess filter: "
758 GOSUB 554
759 $6 = $553
760 GOTO 570

0 REM date changing methods
761 PRINTS"Insert new dat
762 PRINTS"e, check the manua
763 PRINTS"l for formating: "
764 GOSUB 554;
765 A = strlen $553
766 IF A <> 16 THEN 769
767 A = setdate $553
768 GOTO 570
769 PRINTS"\n\rInvalid format
770 GOTO 570

0 REM activate Obex/ObexFTP
0 REM 0 Enabled only on command line
0 REM 1 Always enabled
0 REM 2 Always Disabled
771 PRINTS"Obex/ObexFTP setti"
772 PRINTS"ngs:\n\r0: Enabled "
773 PRINTS"only on command li"
774 PRINTS"ne\n\r1: Always Ena"
775 PRINTS"bled\n\r2: Always D"
776 PRINTS"isabled\n\rChoose "
777 PRINTS"Option: "
778 GOSUB 554
779 $9[2] = C
780 IF C = 50 THEN 786
781 $0[0] = 0
782 A = psget 6
783 $0[11] = 48
784 A = psset 4
785 GOTO 570
786 $0[0] = 0
787 A = psget 6
788 $0[11] = 54
789 A = psset 4
790 GOTO 570

0 REM reboot code
791 PRINTS"Rebooting, please "
792 PRINTS"do not disconnect "
793 PRINTS"electric power\n\r
794 $3[3] = 48
795 A = reboot
796 WAIT 2
797 RETURN

0 REM name/pin settings:
0 REM 0: Don't add anything,
0 REM 1: Add uniq to the name,
0 REM 2: Add uniq to the name, set pin to uniq.
798 PRINTS"Name/Pin settings:\n"
799 PRINTS"\r0: Don't add anyth"
800 PRINTS"ing,\n\r1: Add uniq "
801 PRINTS"to the name,\n\r2: "
802 PRINTS"Add uniq to the nam"
803 PRINTS"e, set pin to uniq: "
804 GOSUB 554
805 IF C < 48 THEN 809
806 IF C > 50 THEN 809
807 $23 = $553
808 GOTO 570

809 PRINTS"Invalid Option\n\r"
810 GOTO 798

0 REM ---------------------- Manual Modes code --------------------------------

811 PRINTS "\n\rThere is BT
812 PRINTS "activity, please
813 PRINTS "wait and try agai
814 PRINTS "n
815 GOTO 570;

0 REM ALARM for Manual modes, simply go to the command line.
0 REM we will not have leds any more.
816 IF $3[3] = 54 THEN 826
817 $3 = $24
819 A = pioclr ($8[0]-48);
820 A = pioclr ($8[1]-48);
821 $3[3] = 49
822 ALARM 0
823 A = cancel
824 A = disconnect 1
825 GOTO 570

826 A = status
827 IF A > 10 THEN 829
828 GOTO 817

829 ALARM 5
830 RETURN

0 REM inquiry code
0 REM by default we inquiry for 10 seconds
831 GOSUB 920;
832 IF $39[0] = 49 THEN 811
833 PRINTS"Inquirying for "
834 PRINTS"16s. Please wait.
835 B = inquiry 10
836 $24 = $3;
837 $3[3] = 51;
838 ALARM 16
839 RETURN

0 REM master code
841 GOSUB 920;
842 IF $39[3] = 49 THEN 811
843 PRINTS"Please input "
844 PRINTS"the addr of your "
845 PRINTS"peer:
846 GOSUB 554
847 B = strlen$553
848 IF B<>12 THEN 855
849 $24 = $3
850 B = master $553
851 ALARM 16
852 $3[3] = 52;
853 $3[0] = 51;
854 RETURN

855 PRINTS"Invalid add
856 PRINTS"r, try again.
857 GOTO 570;

0 REM convert status to a string
0 REM store the result on $44
920 B = status
921 $39[0] = 0;
922 $39 = "00000";
923 IF B < 10000 THEN 926;
924 $39[0] = 49;
925 B = B -10000;
926 IF B < 1000 THEN 929;
927 $39[1] = 49;
928 B = B -1000;
929 IF B < 100 THEN 932;
930 $39[2] = 49;
931 B = B -100;
932 IF B < 10 THEN 935;
933 $39[3] = 49;
934 B = B -10;
935 IF B < 1 THEN 937;
936 $39[4] = 49;
937 $39[5] = 0;
938 RETURN

939 $0[0] = 0;
940 PRINTV $10;
941 IF $23[0] = 48 THEN 944
0 REM this line is used by all the other devices.
0 REM REMEMBER TO UPDATE NUMBER, last was 955
942 GOSUB 965
943 PRINTV $39;
944 A = name $0;
945 RETURN

946 $3[0] = 48
947 A = shell
948 RETURN

949 PRINTS"Please Input PIO set"
950 PRINTS"tings.\n\rPlease che"
951 PRINTS"ck DOCs for More Inf"
952 PRINTS"ormation: "
953 GOSUB 554
954 A = strlen $553
955 IF A <> 10 THEN  959
956 $12 = $553
957 $8[0] = 122
958 GOTO 791
959 PRINTS"Option is invalid, C"
960 PRINTS"heck the DOCs again"
961 PRINTS"\n\r"
962 GOTO 570

963 Z = $9[0]-48
964 GOTO 570

965 PRINTV"_v"
966 $39 = $1
967 RETURN

968 B = status
969 IF B > 0 THEN 975
0 REM to show the user the command line can be accessed, we do a long blink
970 A = pioset($8[1]-48);
971 A = pioset($8[0]-48)
972 A = pioclr($8[0]-48);
973 A = slave 30

975 ALARM 5
976 RETURN

977 $3[3] = 48
978 GOTO 330

0 REM this is part of the @IDLE
979 IF H=1 THEN 130
980 GOTO 349

0 REM idle mode, can we shutdown the FTP
981 IF H=1 THEN 983
982 RETURN

983 B = readcnt
984 C = atoi $16
985 IF B < C THEN 990
986 IF $9[2] = 49 THEN 988
987 A = disable 3
988 H = 0
989 RETURN

990 ALARM 30
991 RETURN

