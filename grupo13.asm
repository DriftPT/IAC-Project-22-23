;**********************************************************************
; * IST-UL
; * Modulo:    grupo13.asm
; * Identificação:    Francisco Nascimento - 106559
;					  Daniel    Rodrigues  - 106772
;					  Pedro     Dias       - 106501
;**********************************************************************

; **********************************************************************
; * COMANDOS
; **********************************************************************

COMANDOS				 EQU	6000H			; endereço de base dos comandos do MediaCenter

DEFINE_LINHA    		 EQU COMANDOS + 0AH		; endereço do comando para definir a linha
DEFINE_COLUNA   		 EQU COMANDOS + 0CH		; endereço do comando para definir a coluna
DEFINE_PIXEL    		 EQU COMANDOS + 12H		; endereço do comando para escrever um pixel
REPRODUZ_SOM        	 EQU COMANDOS + 5AH		; endereço do comando para reproduzir um som
APAGA_AVISO     	 	 EQU COMANDOS + 40H		; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ	 			 EQU COMANDOS + 02H		; endereço do comando para apagar todos os pixeis já desenhados
SELECIONA_CENARIO_FUNDO  EQU COMANDOS + 42H		; endereço do comando para selecionar uma imagem de fundo
SOBREPOR_IMAGEM          EQU COMANDOS + 46H		; endereço do comando para sobrepor uma imagem 
APAGA_IMAGEM_SOBREPOSTA  EQU COMANDOS + 44H		; endereço do comando para apagar imagem sobreposta 

; **********************************************************************
; * CONSTANTES
; **********************************************************************

LINHA_ATUAL_SONDA_MEIO	     EQU 3000H		; endereço que guarda o valor da linha da sonda do meio
LINHA_ATUAL_SONDA_DIREITA    EQU 3002H		; endereço que guarda o valor da linha da sonda da direita
COLUNA_ATUAL_SONDA_DIREITA   EQU 3004H		; endereço que guarda o valor da coluna da sonda da direita
LINHA_ATUAL_SONDA_ESQUERDA   EQU 3006H		; endereço que guarda o valor da linha da sonda da esquerda
COLUNA_ATUAL_SONDA_ESQUERDA  EQU 3008H		; endereço que guarda o valor da coluna da sonda da esquerda
ESTADO_JOGO         	     EQU 300AH		; endereço que guarda o estado de jogo do programa
LINHA_ATUAL_AST_MEIO		 EQU 300EH		; endereço que guarda o valor da linha do asteroide do meio
LINHA_ATUAL_AST_ESQ			 EQU 3010H		; endereço que guarda o valor da linha do asteroide da esquerda
LINHA_ATUAL_AST_DTR			 EQU 3012H		; endereço que guarda o valor da linha do asteroide do direita
VALOR_DISPLAY                EQU 3014H		; endereço que guarda o valor decimal que é colocado no display

ATIVO              			 EQU 1 		; valor do estado de jogo quando está ativo
PAUSA               		 EQU 2      ; valor do estado de jogo quando está em pausa
PARADO              		 EQU 3 		; valor do estado de jogo quando está parado

COR_ROSA		 EQU 0EF08H		; cor rosa
COR_ROSA_2		 EQU 0AE79H		; cor rosa claro
COR_LARANJA      EQU 0FF72H 	; cor lalanja
COR_APAGADO		 EQU 00000H   	; cor para apagar um pixel
COR_VERMELHO     EQU 0CF00H		; cor vermelho
COR_ROXO         EQU 0CF0FH		; cor roxo
COR_VERDE		 EQU 0C0F0H		; cor verde
COR_VERDE_CLARO  EQU 0F9F9H 	; cor verde claro
COR_AMARELO      EQU 0CFF0H		; cor amarelo
COR_AZUL         EQU 0C00FH		; cor azul
COR_PRETO        EQU 0C000H		; cor preto
COR_ROXO_ESCURO  EQU 0F80FH		; cor roxo escuro
COR_AZUL_CLARO   EQU 0F5DFH 	; cor asuzl claro

DISPLAYS   EQU 0A000H		; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN    EQU 0C000H		; endereço das linhas do teclado (periférico POUT-2)
TEC_COL    EQU 0E000H		; endereço das colunas do teclado (periférico PIN)
TEC_LINHA  EQU 8     		; linha a testar (4ª linha, 1000b)
MASCARA    EQU 0FH   		; para isolar os 4 bits de menor peso, ao ler as colunas do teclado

TECLA_8	   EQU 0008H	    ; valor da tecla 8
TECLA_9    EQU 0009H 		; valor da tecla 9
TECLA_C    EQU 000CH        ; valor da tecla C
TECLA_E    EQU 000EH		; valor da tecla E
TECLA_D    EQU 000DH 		; valor da tecla D
TECLA_F    EQU 000FH 		; valor da tecla F
  
TAMANHO_PILHA 		EQU 100H		; endereço para o tamanha das pilhas
TAMANHO_PILHA_AST   EQU 400H        ; endereço para o tamanha das pilha do processo asteroide
FATOR 	   			EQU 1000 		; valor do fator de conversão do display
CONST_100   		EQU 100         ; valor 100
NUN_AST             EQU 4           ; numero de asteroides usados
LINHA_PAINEL_COL    EQU 22			; valor da linha que ocorre a colisão do asteroide com o painel

; **********************************************************************
; * DADOS
; **********************************************************************

PLACE 1000H

	STACK TAMANHO_PILHA			; espaço reservado para a pilha do processo "programa principal"
SP_inicial_prog_princ:		; este é o endereço com que o SP deste processo deve ser inicializado

	STACK TAMANHO_PILHA			; espaço reservado para a pilha do processo "teclado"
SP_inicial_teclado:			; este é o endereço com que o SP deste processo deve ser inicializado

	STACK TAMANHO_PILHA_AST		; espaço reservado para a pilha do processo "asteroide"
SP_inicial_asteroide:		; este é o endereço com que o SP deste processo deve ser inicializado

	STACK TAMANHO_PILHA			; espaço reservado para a pilha do processo "sonda meio"
SP_inicial_sonda_meio:		; este é o endereço com que o SP deste processo deve ser inicializado

	STACK TAMANHO_PILHA			; espaço reservado para a pilha do processo "sonda esquerda"
SP_inicial_sonda_esquerda:	; este é o endereço com que o SP deste processo deve ser inicializado

	STACK TAMANHO_PILHA			; espaço reservado para a pilha do processo "sonda direita"
SP_inicial_sonda_direita:	; este é o endereço com que o SP deste processo deve ser inicializado

	STACK TAMANHO_PILHA			; espaço reservado para a pilha do processo "painel"
SP_inicial_painel:			; este é o endereço com que o SP deste processo deve ser inicializado

	STACK TAMANHO_PILHA			; espaço reservado para a pilha do processo "display"
SP_display:					; este é o endereço com que o SP deste processo deve ser inicializado

tecla_carregada:
	LOCK 0				; LOCK para o teclado comunicar aos restantes processos que tecla detetou,
						; uma vez por cada tecla carregada

pausa:
	LOCK 0 				; LOCK para o programa principal comunicar aos restantes processos que estão
						; no estado de jogo pausa.	

parado:
	LOCK 0 				; LOCK para o programa principal comunicar aos restantes processos que estão
						; no estado de jogo parado.

valor_aleatorio:
	LOCK 0              ; LOCK para o teclado comunicar ao processo dos asteroides que o valor aleatório,
						; foi introduzido

tab:
	WORD rot_int_0 			; rotina de atendimento da interrupção 0
	WORD rot_int_1			; rotina de atendimento da interrupção 1
	WORD rot_int_2			; rotina de atendimento da interrupção 2
	WORD rot_int_3			; rotina de atendimento da interrupção 3


evento_int_bonecos:			; LOCKs para cada rotina de interrupção comunicar ao processo
						; boneco respetivo que a interrupção ocorreu
	LOCK 0				; LOCK para a rotina de interrupção 0
	LOCK 0   			; LOCK para a rotina de interrupção 1
	LOCK 0 				; LOCK para a rotina de interrupção 2
	LOCK 0              ; LOCK para a rotina de interrupção 3


DEF_AST:		   ;tabela que caracteriza o asteroide (altura, largura, cores)
	WORD  5, 5
	WORD  0, COR_LARANJA, COR_LARANJA, COR_LARANJA, 0
	WORD  COR_LARANJA, COR_LARANJA, COR_LARANJA, COR_LARANJA, COR_LARANJA
	WORD  COR_LARANJA, COR_LARANJA, COR_LARANJA, COR_LARANJA, COR_LARANJA
	WORD  COR_LARANJA, COR_LARANJA, COR_LARANJA, COR_LARANJA, COR_LARANJA
	WORD  0, COR_LARANJA, COR_LARANJA, COR_LARANJA, 0

DEF_AST_ESP:        ;tabela que caracteriza o asteroide especial (altura, largura, cores)
	WORD  5, 5
	WORD  COR_VERDE_CLARO, COR_VERDE_CLARO, 0, COR_VERDE_CLARO, COR_VERDE_CLARO
	WORD  0, COR_VERDE_CLARO, COR_VERDE_CLARO, COR_VERDE_CLARO, 0
	WORD  COR_VERDE_CLARO, 0, COR_VERDE_CLARO, 0, COR_VERDE_CLARO
	WORD  0, COR_VERDE_CLARO, COR_VERDE_CLARO, COR_VERDE_CLARO, 0
	WORD  COR_VERDE_CLARO, COR_VERDE_CLARO, 0, COR_VERDE_CLARO, COR_VERDE_CLARO


DEF_AST_DANO:		;tabela que caracteriza o asteroide danificado (altura, largura, cores)
	WORD  5, 5
	WORD  0, COR_AZUL_CLARO, 0, COR_AZUL_CLARO, 0
	WORD  COR_AZUL_CLARO, 0, COR_AZUL_CLARO, 0, COR_AZUL_CLARO
	WORD  0, COR_AZUL_CLARO, 0, COR_AZUL_CLARO, 0
	WORD  COR_AZUL_CLARO, 0, COR_AZUL_CLARO, 0, COR_AZUL_CLARO
	WORD  0, COR_AZUL_CLARO, 0, COR_AZUL_CLARO, 0	

DEF_AST_ESP_DANO:   ;tabela que caracteriza o asteroide especial danificado (altura, largura, cores)
	WORD  5, 5
	WORD  0, COR_VERDE_CLARO, 0, COR_VERDE_CLARO, 0
	WORD  0, 0, COR_VERDE_CLARO, 0, 0
	WORD  COR_VERDE_CLARO, 0, 0, 0, COR_VERDE_CLARO
	WORD  0, 0, COR_VERDE_CLARO, 0, 0
	WORD  0, COR_VERDE_CLARO, 0, COR_VERDE_CLARO, 0

DEF_PAINEL:     	;tabela que caracteriza o painel (altura, largura, cores)
	WORD  5, 9
	WORD  COR_ROSA, 0, 0, 0, COR_ROSA, 0, 0, 0, COR_ROSA
	WORD  COR_ROSA, 0, 0, COR_ROSA, COR_ROSA_2, COR_ROSA, 0, 0, COR_ROSA
	WORD  COR_ROSA, 0, COR_ROSA, COR_ROSA_2, COR_ROSA_2, COR_ROSA_2, COR_ROSA, 0, COR_ROSA
	WORD  COR_ROSA, COR_ROSA, COR_ROSA_2, COR_ROSA_2, COR_ROSA_2, COR_ROSA_2, COR_ROSA_2, COR_ROSA, COR_ROSA
	WORD  COR_ROSA, COR_ROSA_2, COR_ROSA_2, COR_ROSA_2,COR_ROSA_2, COR_ROSA_2, COR_ROSA_2, COR_ROSA_2, COR_ROSA

DEF_PAINEL_1: 		;tabela que caracteriza o quadro do painel 1 (altura, largura, cores)
	WORD  2, 3
	WORD  COR_AMARELO, COR_AZUL, COR_PRETO
	WORD  COR_VERMELHO, COR_ROXO, COR_VERDE

DEF_PAINEL_2:		;tabela que caracteriza o quadro do painel 2 (altura, largura, cores)
	WORD  2, 3
	WORD  COR_AZUL, COR_ROXO, COR_VERMELHO
	WORD  COR_VERDE, COR_PRETO, COR_AMARELO

DEF_PAINEL_3: 		;tabela que caracteriza o o quadro do painel 3 (altura, largura, cores)
	WORD  2, 3
	WORD  COR_ROXO, COR_VERDE, COR_AMARELO
	WORD  COR_AZUL, COR_VERMELHO, COR_PRETO


DEF_SONDA:			;tabela que caracteriza a sonda (altura, largura, cores)
	WORD  1, 1
	WORD  COR_ROXO_ESCURO



; ***********************************************************************************
; * CODIGO *
;
; PROGRAMA PRINCIPAL
; ***********************************************************************************

PLACE 0  

inicio:
	MOV    SP, SP_inicial_prog_princ			; inicializa SP do programa principal

	MOV    BTE, tab								; inicializa BTE (registo de Base da Tabela de Exceções)

    MOV    [APAGA_AVISO], R1					; apaga o aviso de nenhum cenário selecionado
    MOV    [APAGA_ECRÃ], R1						; apaga todos os pixeis já desenhados
	MOV	   R1, 0								; cenário de fundo número 0
    MOV    [SELECIONA_CENARIO_FUNDO], R1		; seleciona o cenário de fundo da tela inicial
    CALL   teclado 								; cria o processo teclado

start:									; neste ciclo espera-se até a tecla C ser premida para começar o jogo
	MOV	   R1, [tecla_carregada]		; bloqueia neste LOCK até uma tecla ser carregada			
	MOV    R2, TECLA_C		
	CMP    R1, R2 		  				; verifica se a tecla carregada é a C
	JNZ    start                    	; se não, continua		


inicio_jogo:
	MOV    R1, ATIVO	
	MOV    [ESTADO_JOGO], R1                    ; define o estado de jogo como ativo

    MOV    [APAGA_ECRÃ], R1					    ; apaga todos os pixeis já desenhados
	MOV	   R1, 1								; cenário de fundo número 1
    MOV    [SELECIONA_CENARIO_FUNDO], R1		; seleciona o cenário de fundo de jogo ativo

 	MOV    R1, 0 					 	; som número 0	
	MOV    [REPRODUZ_SOM], R1			; reproduz o som de início de jogo

	MOV    R1, CONST_100 
	MOV    [VALOR_DISPLAY], R1		    ; coloca o valor 100 no display, que representa a energia inicial 

    EI0  	; permite interrupções 0
    EI1		; permite interrupções 1
    EI2 	; permite interrupções 2
    EI3 	; permite interrupções 3
	EI 		; permite interrupções (geral)
			; a partir daqui, qualquer interrupção que ocorra usa
			; a pilha do processo que estiver a correr nessa altura         

; cria processos. O CALL não invoca a rotina, apenas cria um processo executável

	MOV	   R11, NUN_AST			; número de bonecos a usar (até 4)
loop_asteroide:
	SUB	   R11, 1					; próximo asteroide
	CALL   teclado				    ; cria o processo teclado
	CALL   asteroide_inicial		; cria uma nova instância do processo boneco (o valor de R11 distingue-as)
								    ; Cada processo fica com uma cópia independente dos registos
	CMP    R11, 0					; já criou as instâncias todas?
    JNZ    loop_asteroide			; se não, continua


    CALL   painel  					    ; cria o processo do painel
	CALL   sonda_meio 				    ; cria o processo da sonda do meio
	CALL   sonda_esquerda 			    ; cria o processo da sonda da esquerda
	CALL   sonda_direita 				; cria o processo da sonda da direita
	CALL   display						; cria o processo display

obtem_tecla:	                    	; ciclo que verifica o estado do jogo e que controla a deteção das teclas 8 e 9
	MOV    R1, [tecla_carregada]  	    ; bloqueia neste LOCK até uma tecla ser carregada
	MOV    R3, [ESTADO_JOGO] 			; guarda o estado atual do jogo num registo

	CMP    R3, PARADO                 	; verifica se o jogo está parado
	JZ     verifica_tecla_em_parado		; se estiver, ficará à espera que seja premida a tecla C, para recomeçar o jogo

	CMP    R3, PAUSA 				   	; verifica se o jogo está pausado
	JZ     verifica_tecla_em_pausa		; se estiver, verifica se o utilizador clicou na tecla 8 para acabar o jogo,
								   		; ou na tecla 9 para continuar
	CALL   comando_8 				   	; se o estado d ejogo estiver ativo, chama a rotina que verifica se foi premida 
	CALL   comando_9 				   	; a tecla 8 e a rotina que verifica se foi premida a tecla 9
	JMP    obtem_tecla  			   	; volta ao início do ciclo


verifica_tecla_em_parado: 					    ; verifica se a tecla C foi pressionada quando o jogo está parado
	MOV    R8, TECLA_C
	CMP    R8, R1                               ; verifica se a tecla C foi premida
	JNZ    obtem_tecla                          ; se foi, recomeça o jogo

	MOV	   R1, 1								; cenário de fundo número 1
    MOV    [SELECIONA_CENARIO_FUNDO], R1		; seleciona o cenário de fundo de jogo ativo
	MOV    R11, ATIVO                         
	MOV    [ESTADO_JOGO], R11                   ; define o estado de jogo como ativo
	MOV    R1, 0 								; som número 0
	MOV    [REPRODUZ_SOM], R1					; reproduz o som de começar o jogo
	CALL   reseta_display                       ; coloca o valor 100 no display
	MOV    [parado], R11                        ; informa quem estiver bloqueado neste LOCK que o jogo já não está parado
	JMP    obtem_tecla                          ; espera que uma tecla seja premida


verifica_tecla_em_pausa: 					; verifica se as teclas 8 e 9 foram pressionadas quando o jogo está em pausa
	MOV    R8, TECLA_8
	CMP    R8, R1 							; verifica se a tecla 8 foi premida
	JZ     recomeçar_da_pausa 				; se foi, recomeça o jogo

	MOV    R8, TECLA_9
	CMP    R8, R1 							; verifica se a tecla 9 foi premida
	JNZ    obtem_tecla 						; se não foi, espera que outra tecla seja 

	MOV    [APAGA_IMAGEM_SOBREPOSTA], R8    ; apaga a mensagem de pausa
	MOV    R11, ATIVO
	MOV    [ESTADO_JOGO], R11 				; define o estado do jogo como ativo
	MOV    [pausa], R11 						; informa quem estiver bloqueado neste LOCK que o jogo já não está pausado
	JMP    obtem_tecla 						; espera que uma tecla seja premida

recomeçar_da_pausa:							; coloca o estado do jogo como parado após ser pausado
	MOV    [pausa], R8                    	; informa quem estiver bloqueado neste LOCK que o jogo já não está pausado
	MOV    R0, 6
	MOV    [SOBREPOR_IMAGEM], R0          	; seleciona uma imagem transparente para apagar a mensagem de pausa
	CALL   comando_8                      	; chama a rotina que verifica se foi premida a tecla 8 para colocar o jogo no estado parado
	JMP    obtem_tecla                    	; espera que uma tecla seja premida


; ***********************************************************************************
; COMANDO_8 - Verifica se foi premida a tecla 8, se sim para o jogo. 
; 
; Argumentos:	R1 - tecla pressionada
;
; ***********************************************************************************

comando_8:									    ; comando que verifica se foi premida a tecla 8 e que para o jogo caso tenha sido premida
	PUSH   R0
	PUSH   R2
	PUSH   R3
	MOV    R0, TECLA_8    	 
	CMP    R1, R0 			                    ; verifica se foi premida a tecla 8
	JNZ    fim_comando_8 					    ; se não foi, termina este comando sem quaisquer alterações
 											    ; se foi premida a tecla 8:
	MOV    R2, PARADO 
	MOV    [ESTADO_JOGO], R2 					; define o estado do jogo como parado
	MOV    R2, 1 					            ; som número 0
	MOV    [REPRODUZ_SOM], R2 				    ; reproduz o som de paragem
	MOV    [APAGA_ECRÃ], R3					    ; apaga todos os pixels já desenhados
	MOV    R3, 5 								; cenário de fundo número 5
    MOV    [SELECIONA_CENARIO_FUNDO], R3		; seleciona o cenário de fundo do jogo parado

fim_comando_8:
	POP    R3
	POP    R2
	POP    R0
	RET

; ***********************************************************************************
; COMANDO_9 - Verifica se foi premida a tecla 9, se sim pausa o jogo. 
; 
; Argumentos:	R1 - tecla pressionada
;
; ***********************************************************************************

comando_9: 								; comando que verifica se foi premida a tecla 9 e que pausa o jogo caso tenha sido premida
	PUSH   R0
	MOV    R0, TECLA_9
	CMP    R1, R0 						; verifica se foi premida a tecla 9
	JNZ    fim_comando_9 				; se não foi, termina este comando sem quaisquer alterações
 										; se foi premida a tecla 9:
	MOV    R0, PAUSA 
	MOV    [ESTADO_JOGO], R0 			; define o estado do jogo como pausado
	MOV    R0, 2				        ; cenário de fundo e som número 0
	MOV    [REPRODUZ_SOM], R0 		    ; reproduz o som de pausa
	MOV    [SOBREPOR_IMAGEM], R0		; seleciona uma imagem transparente com uma mensagem a informar que o jogo está em pausa

fim_comando_9:
	POP R0
	RET


; **********************************************************************
; RESETA_DISPLAY - Atualiza o valor do display para 100
; 
; **********************************************************************

reseta_display:
	PUSH   R1
	PUSH   R10

	MOV    R10, CONST_100
	MOV    [VALOR_DISPLAY], R10		; coloca o valor 100 no endereço do valor do display
	CALL   converte_hexa            ; converte o valor 100 decimal em hexadecimal
	MOV    R1, DISPLAYS               
	MOV    [R1], R10                ; coloca o valor convertido no display

fim_reseta_display:
	POP    R10
	POP    R1
	RET

; ***********************************************************************************
; Processo
;
; TECLADO - Processo que deteta quando se carrega numa tecla do teclado 
;           e escreve o valor num LOCK. Também responsável por escrever em outro
;			LOCK um valor aleatório
;
; ***********************************************************************************

PROCESS SP_inicial_teclado		; indicação de que a rotina que se segue é um processo,
								; com indicação do valor para inicializar o SP

teclado:					; processo que implementa o comportamento do teclado
	MOV    R2, TEC_LIN		; endereço do periférico das linhas
	MOV    R3, TEC_COL		; endereço do periférico das colunas
	MOV    R5, MASCARA		; para isolar os 4 bits de menor peso, ao ler as colunas do teclado


linha_inicial:
    MOV    R1, TEC_LINHA     		; começar na linha de baixo 

espera_tecla:          				; neste ciclo espera-se até uma tecla ser premida

	YIELD							; este ciclo é potencialmente bloqueante, pelo que tem de
									; ter um ponto de fuga (aqui pode comutar para outro processo) 
	
	MOVB   R8, [R3]                   	; ler do periférico de entrada (colunas)
    SHR    R8, 4                      	; destes bits, isola os 4 mais à esquerda, que são quatro valores aleatórios
    MOV    [valor_aleatorio], R8		; informa quem estiver bloqueado neste LOCK que o valor aleatório foi inserido

    MOVB   [R2], R1      				; escrever no periférico de saída (linhas)
    MOVB   R0, [R3]      				; ler do periférico de entrada (colunas)
    AND    R0, R5        				; elimina bits para além dos bits 0-3
    CMP    R0, 0         				; verifica se alguma tecla foi premida
    JNZ    converte 					; se alguma tecla foi premida, converte
    SHR    R1, 1         				; trocar a linha a ser vista
    CMP	   R1, 0         				; verifica se a linha é 0
    JZ     linha_inicial 				; se a linha for 0, volta para a linha de baixo
    JMP    espera_tecla  				; se nenhuma tecla foi premida, repete

converte: 								; converte o numero da linha e da coluna na tecla pressionada e executa comandos baseados nesta
	CALL   rotina_converte				; converte o numero da linha e da coluna na tecla pressionada
	MOV    [tecla_carregada], R9		; informa quem estiver bloqueado neste LOCK que uma tecla foi carregada


ha_tecla:              				; neste ciclo espera-se até nenhuma tecla estar premida

	YIELD							; este ciclo é potencialmente bloqueante, pelo que tem de
									; ter um ponto de fuga (aqui pode comutar para outro processo) 

									; (o valor escrito é o número da coluna da tecla no teclado)
    MOVB   [R2], R1      			; escrever no periférico de saída (linhas)
    MOVB   R0, [R3]      			; ler do periférico de entrada (colunas)
    AND    R0, R5        			; elimina bits para além dos bits 0-3
    CMP    R0, 0         			; há tecla premida?
    JZ     linha_inicial    		; se não houver uma tecla premida
    JMP    ha_tecla      			; se ainda houver uma tecla premida, espera até não haver




; ***********************************************************************************
; ROTINA_CONVERTE - Converte as coordenadas (1, 2, 4 e 8) da tecla
;					pressionada num valor de 1 a F. Se nenhuma tecla for
;				    for pressionada, o valor é 0.
; Argumentos:	R1 - Linha da tecla pressionada
;
; Retorna:		R9 - Tecla premida
;
; ***********************************************************************************


rotina_converte:
	PUSH   R1	 	
	PUSH   R6
	PUSH   R7
	MOV    R6, -1        				; contador da coluna do teclado
    MOV    R7, -1        				; contador da linha do teclado

converte_tecla_linha:					; converte os valores binários da linha para um valor de 0 a 3
	SHR    R1, 1         				; percorre o valor binário da linha premida até 0
	INC    R6            				; ver em que linha, em forma decimal, estamos através de um contador
	CMP    R1, 0 						; ver se o valor binário da linha é 0, se for a conversao da linha está feita
	JNZ    converte_tecla_linha			; continua a percorrer até o valor binário da linha for 0

converte_tecla_coluna:					; converte os valores binários da coluna para um valor de 0 a 3
	SHR    R0, 1        				; percorre o valor binário da coluna premida até 0
	INC    R7           				; ver em que coluna, em forma decimal, estamos através de um contador
	CMP    R0, 0                     	; ver se o valor binário da linha é 0, se for a conversao da coluna está feita
	JNZ    converte_tecla_coluna		; continua a percorrer até o valor binário da coluna for 0

converte_tecla:							; calcula o valor da tecla premida
	MOV    R0, 4        				
	MUL    R6, R0	   					; multiplicar o valor da linha em decimal com 4
	ADD    R6, R7       				; somar o valor anterio com a coluna em decimal
	MOV    R9, R6	  					; guardar o valor da tecla que foi premida
    POP    R7
    POP    R6
    POP    R1
    RET

; ***********************************************************************************
; Processo
;
; ASTEROIDE - Processo que desenha um asteroide, este pode mover-se para 3 
;		 direções diferentes e partir de 3 posições diferentes com temporização
;		 marcada pela interrupção 0
;
; ***********************************************************************************

PROCESS SP_inicial_asteroide			; indicação de que a rotina que se segue é um processo,
										; com indicação do valor para inicializar o SP

asteroide_inicial:
	MOV    R1, TAMANHO_PILHA				; tamanho em palavras da pilha de cada processo
	MUL    R1, R11							; TAMANHO_PILHA vezes o nº da instância dos asteroides
	SUB    SP, R1		    			 	; inicializa SP do asteroide
											; A instância 0 fica na mesma, e as seguintes vão andando para trás,
											; até esgotar todo o espaço de pilha reservado para o processo

asteroide:									; processo que implementa o comportamento do asteroide

	MOV    R8, [valor_aleatorio] 			; bloqueia neste LOCK até um valor aleatório ser definido

	MOV    R6, 0
	MOV    [LINHA_ATUAL_AST_MEIO], R6 		; define 0 como a linha inicial do asteroide do meio
	MOV    [LINHA_ATUAL_AST_ESQ], R6 		; define 0 como a linha inicial do asteroide da esquerda
	MOV    [LINHA_ATUAL_AST_DTR], R6 		; define 0 como a linha inicial do asteroide da direita

	MOV    R1, 32
	MOV    R2, 5
	MOV    R0, R8
	MOD    R8, R2 							; calcula o resto da divisão inteira entre o valor aleatório e cinco,
											; que irá definir a posição e direção do asteroide
	MOV    R9, 0
	CMP    R8, R9 							; se o resto for 0
	JZ     asteroide_esquerda 				; é selecionado o asteroide da esquerda

	MOV    R9, 1
	CMP    R8, R9 							; se o resto for 1
	JZ     asteroide_meio_direita 			; é selecionado o asteroide do meio que vai para a direita

	MOV    R9, 2
	CMP    R8, R9 							; se o resto for 2
	JZ     asteroide_meio_centro 			; é selecionado o asteroide do meio que vai diretamente para baixo

	MOV    R9, 3
	CMP    R8, R9 							; se o resto for 3
	JZ     asteroide_meio_esquerda 			; é selecionado o asteroide do meio que vai para a esquerda

	MOV    R9, 4
	CMP    R8, R9 							; se o resto for 4
	JZ     asteroide_direita 				; é selecionado o asteroide da direita

asteroide_esquerda:
	MOV    R7, 0 									; define o valor da coluna inicial do asteroide

	SHR    R0, 2 									; seleciona os dois bits mais à esquerda do valor aleatório

	MOV    R9, 3
	CMP    R9, R0 									; se esse valor for 3
	JZ     define_especial_esquerda 				; define este asteroide como especial
	MOV    R10, DEF_AST 							; se não for, define-o como um asteroide normal
	JMP    redesenhar_asteroide_esquerda 			; inicia o ciclo de redesenhar o asteroide da esquerda a descer

define_especial_esquerda:
	CALL   asteroide_especial                 		; define este asteroide como especial
	JMP    redesenhar_asteroide_esquerda       		; inicia o ciclo de redesenhar o asteroide da esquerda a descer

asteroide_meio_direita:
	MOV    R7, 29                                  	; define o valor da coluna inicial do asteroide

	SHR    R0, 2 									; seleciona os dois bits mais à esquerda do valor aleatório

	MOV    R9, 3
	CMP    R9, R0 									; se esse valor for 3
	JZ     define_especial_centro_direita      		; define este asteroide como especial
	MOV    R10, DEF_AST                        		; se não for, define-o como um asteroide normal
	JMP    redesenhar_asteroide_centro_direita     	; inicia o ciclo de redesenhar o asteroide do centro a descer para a direita

define_especial_centro_direita:
	CALL   asteroide_especial                  		; define este asteroide como especial
	JMP    redesenhar_asteroide_centro_direita     	; inicia o ciclo de redesenhar o asteroide do centro a descer para a direita

asteroide_meio_centro:
	MOV    R7, 29     								; define o valor da coluna inicial do asteroide

	SHR    R0, 2 									; seleciona os dois bits mais à esquerda do valor aleatório

	MOV    R9, 3
	CMP    R9, R0 									; se esse valor for 3
	JZ     define_especial_centro                 	; define este asteroide como especial
	MOV    R10, DEF_AST 							; se não for, define-o como um asteroide normal
	JMP    redesenhar_asteroide_centro 				; inicia o ciclo de redesenhar o asteroide do centro a descer

define_especial_centro:                         
	CALL   asteroide_especial                     	; define este asteroide como especial
	JMP    redesenhar_asteroide_centro             	; inicia o ciclo de redesenhar o asteroide do centro a descer do centro

asteroide_meio_esquerda:
	MOV	   R7, 29                                  	; define o valor da coluna inicial do asteroide

	SHR    R0, 2 									; seleciona os dois bits mais à esquerda do valor aleatório

	MOV    R9, 3
	CMP    R9, R0 									; se esse valor for 3
	JZ     define_especial_centro_esquerda 			; define este asteroide como especial
	MOV    R10, DEF_AST 							; se não for, define-o como um asteroide normal
	JMP    redesenhar_asteroide_centro_esquerda    	; inicia o ciclo de redesenhar o asteroide do centro a descer para a esquerda

define_especial_centro_esquerda:
	CALL   asteroide_especial 						; define este asteroide como especial
	JMP    redesenhar_asteroide_centro_esquerda 	; inicia o ciclo de redesenhar o asteroide do centro a descer para a esquerda

asteroide_direita:
	MOV    R7, 58                                  	; define o valor da coluna inicial do asteroide

	SHR    R0, 2 									; seleciona os dois bits mais à esquerda do valor aleatório

	MOV    R9, 3
	CMP    R9, R0 									; se esse valor for 3
	JZ     define_especial_direita 					; define este asteroide como especial
	MOV    R10, DEF_AST  							; se não for, define-o como um asteroide normal
	JMP    redesenhar_asteroide_direita 			; inicia o ciclo de redesenhar o asteroide da direita a descer

define_especial_direita:
	CALL   asteroide_especial 						; define este asteroide como especial
	JMP    redesenhar_asteroide_direita 			; inicia o ciclo de redesenhar o asteroide da direita a descer


redesenhar_asteroide_esquerda:                  ; ciclo de redesenhar o asteroide da esquerda a descer

	YIELD 									    ; este ciclo é potencialmente bloqueante, pelo que tem de
												; ter um ponto de fuga (aqui pode comutar para outro processo) 
	CALL   desenha_boneco	                    ; desenha o asteroide na posição indicada
	CALL   espera_acabar_pausa	                ; verifica se o jogo está em pausa e só continua se não estiver

	MOV    R9, [evento_int_bonecos]				; lê o LOCK desta instância (bloqueia até a rotina de interrupção
												; respetiva escrever neste LOCK)
	CALL   apaga_boneco							; apaga o boneco na sua posição corrente

	MOV    R9, [ESTADO_JOGO]         
	MOV    R11, PARADO
	CMP    R9, R11                             	; verifica se o jogo está parado
	JZ 	   para_jogo                          	; se sim, para o jogo e volta pra o início do processo

	MOV    R4, [LINHA_ATUAL_SONDA_ESQUERDA]		; guarda o valor da linha atual da sonda da esquerda para um registo
	MOV    R9, R6        
	ADD    R9, 6                               	; adiciona 6 ao valor da linha atual do asteroide para se obter a última linha do asteroide 
	CMP    R9, R4     
	JGT    colisao_asteroide                   	; se esta linha for maior que a linha atual da sonda, existe colisão

	MOV    R9, LINHA_PAINEL_COL                	; guarda o valor da linha do painel
	CMP    R9, R6
	JZ     painel_destroi                      	; se as linhas do asteroide e do painel forem iguais, perde-se o jogo

	INC    R6			 						; incrementa o valor da linha do asteroide
	MOV    [LINHA_ATUAL_AST_ESQ], R6           	; guarda esse valor num endereço
	INC    R7			 						; incrementa o valor da coluna do asteroide
	SUB    R1, 1                               	; retira 1 ao valor máximo que o asteroide pode-se mover
	JNZ    redesenhar_asteroide_esquerda       	; se sair do ecrã, volta para o início do processo se não continua o ciclo
	JMP    asteroide			                ; repete o processo do asteroide
							

redesenhar_asteroide_direita: 					; ciclo de redesenhar o asteroide da direita a descer

	YIELD 									    ; este ciclo é potencialmente bloqueante, pelo que tem de
												; ter um ponto de fuga (aqui pode comutar para outro processo) 
	CALL   desenha_boneco	                    ; desenha o asteroide na posição indicada
	CALL   espera_acabar_pausa	                ; verifica se o jogo está em pausa e só continua se não estiver

	MOV    R9, [evento_int_bonecos]				; lê o LOCK desta instância (bloqueia até a rotina de interrupção
												; respetiva escrever neste LOCK)
	CALL   apaga_boneco							; apaga o boneco na sua posição corrente

	MOV    R9, [ESTADO_JOGO]                  
	MOV    R11, PARADO
	CMP    R9, R11                             ; verifica se o jogo está parado
	JZ 	   para_jogo                           ; se sim, para o jogo e volta pra o início do processo

	MOV    R4, [LINHA_ATUAL_SONDA_DIREITA]     ; guarda o valor da linha atual da sonda da direita para um registo
	MOV    R9, R6        
	ADD    R9, 6                               ; adiciona 6 ao valor da linha atual do asteroide para se saber a linha da parte de baixo do asteroide 
	CMP    R9, R4     
	JGT    colisao_asteroide                   ; se a linha do asteroide for maior que a da sonda pode existir colisão

	MOV    R9, LINHA_PAINEL_COL                ; guarda o valor da linha do painel
	CMP    R9, R6
	JZ     painel_destroi                      ; se a linha do asteroide e a do painel forem iguais perde-se o jogo

	INC    R6			 					   ; incrementa o valor da linha do asteroide
	MOV    [LINHA_ATUAL_AST_DTR], R6           ; guarda esse valor num endereço
	SUB    R7, 1			 				   ; subtrai 1 ao valor da coluna do asteroide
	SUB    R1, 1                               ; subtrai 1 ao valor máximo que o asteroide se pode mover
	JNZ    redesenhar_asteroide_direita        ; se sair do ecrã, volta para o início do processo, se não, continua o ciclo
	JMP    asteroide			               ; repete o processo do asteroide

; ***********************************************************************************
; Funções auxiliares usadas para redesenhar os asteroides
; ***********************************************************************************

colisao_asteroide:                              ; colisão do asteroide
	MOV    R9, DEF_AST_ESP                     
	ADD    R9, 4                               	; vê a cor do primeiro pixel do asteroide especial
	ADD    R10, 4                              	; vê a cor do primeiro pixel do asteroide a ser analisado
	CMP    R10, R9 								; verifica se o asteroide a colidir é especial
	JZ     colisao_especial                    	; se for, salta para a colisão especial,

	MOV    R5, 7
	MOV    [REPRODUZ_SOM], R5 					; se não for, reproduz o som de asteroide a ser destruido
	MOV    R10, DEF_AST_DANO 					; define o asteroide danificado
	CALL   desenha_boneco	                    ; desenha o asteroide danificado
	MOV    R9, [evento_int_bonecos]           	; lê o LOCK desta instância (bloqueia até a rotina de interrupção respetiva escrever neste LOCK)
	CALL   apaga_boneco                        	; apaga o asteroide danificado
	JMP    asteroide                            ; repete o processo do asteroide

colisao_especial: 								; colisão do asteroide especial
	MOV    R10, DEF_AST_ESP_DANO 				; define o asteroide especial danificado
	CALL   desenha_boneco	 					; desenha o asteroide especial danificado
	MOV    R9, [evento_int_bonecos]            	; lê o LOCK desta instância (bloqueia até a rotina de interrupção respetiva escrever neste LOCK)
	CALL   apaga_boneco                        	; apaga o asteroide danificado
	CALL   muda_display_especial               	; retira 5 ao valor do display
	MOV    R5, 6
	MOV    [REPRODUZ_SOM], R5 					; reproduz o som de asteroide especial a ser destruido
	JMP    asteroide                           	; volta para o início do processo

para_jogo:                                      ; para os asteroides e reinicia o processo
	MOV    R11, [parado]                        ; bloqueia neste LOCK até o jogo ser recomeçado 
	JMP    asteroide 							; repete o processo do asteroide

painel_destroi:
	MOV    R4, PARADO                             
	MOV    [ESTADO_JOGO], R4 						; coloca o estado de jogo parado
 	MOV    [APAGA_ECRÃ], R9							; apaga todos os pixeis já desenhados 
	MOV    R9, 4
    MOV    [SELECIONA_CENARIO_FUNDO], R9			; seleciona o cenário de fundo quando o painel é destruido
    MOV    R5, 5
	MOV    [REPRODUZ_SOM], R5 						; reproduz o som quando o painel é destruido
    MOV    R9, [parado]                           	; bloqueia neste LOCK até o jogo ser recomeçado 
    JMP    asteroide 								; repete o processo do asteroide

; ***********************************************************************************
; FIM de funções auxiliares usadas para redesenhar os asteroides
; ***********************************************************************************

redesenhar_asteroide_centro_esquerda:           ; ciclo de redesenhar o asteroide do centro a descer para a esquerda

	YIELD 									    ; este ciclo é potencialmente bloqueante, pelo que tem de
												; ter um ponto de fuga (aqui pode comutar para outro processo) 
	CALL   desenha_boneco	                    ; desenha o asteroide na posição indicada
	CALL   espera_acabar_pausa	                ; verifica se o jogo está em pausa e só continua se não estiver

	MOV    R9, [evento_int_bonecos]				; lê o LOCK desta instância (bloqueia até a rotina de interrupção
												; respetiva escrever neste LOCK)
	CALL 	apaga_boneco						; apaga o boneco na sua posição corrente

	MOV    R9, [ESTADO_JOGO]                  
	MOV    R11, PARADO
	CMP    R9, R11                             	; verifica se o jogo está parado
	JZ 	   para_jogo                           	; se sim, para o jogo e volta pra o início do processo

	MOV    R4, [LINHA_ATUAL_SONDA_ESQUERDA]    	; guarda o valor da linha atual da sonda da esquerda para um registo
	MOV    R9, R6 								
	ADD    R9, 6                               	; adiciona 6 ao valor da linha atual do asteroide para se obter a última linha do asteroide 
	CMP    R9, R4                               
	JGT    colisao_asteroide_esquerda 			; se a linha do asteroide for maior que a da sonda pode existir colisão

movimento_asteroide_centro_esquerda:            	; continua o movimento do asteroide
	INC    R6			 							; incrementa o valor da linha do asteroide
	SUB    R7, 1			 						; retira 1 ao valor da coluna do asteroide
	SUB    R1, 1                                 	; retira 1 ao valor máximo que o asteroide se pode mover
	JNZ    redesenhar_asteroide_centro_esquerda  	; se sair do ecrã, volta para o início do processo, se não, continua o ciclo
	JMP    asteroide			               		; repete o processo do asteroide


colisao_asteroide_esquerda:                     	; verificar se existe colisão
	MOV    R9, [COLUNA_ATUAL_SONDA_ESQUERDA]    	; guarda o valor da coluna atual da sonda da esquerda para um registo
	MOV    R11, R7                
	SUB    R9, R11                              	; retira ao valor da coluna da sonda o valor da coluna do asteroide
	MOV    R11, 5
	CMP    R9, R11                               
	JLT    colisao_asteroide                    	; verificar se esse valor é menor que 5, se for, existe colisão, 
	JMP    movimento_asteroide_centro_esquerda  	; se não, continua o movimento do asteroide


redesenhar_asteroide_centro_direita:            ; ciclo de redesenhar o asteroide do centro a descer para a direita

	YIELD 									    ; este ciclo é potencialmente bloqueante, pelo que tem de
												; ter um ponto de fuga (aqui pode comutar para outro processo) 
	CALL   desenha_boneco	                    ; desenha o asteroide na posição indicada
	CALL   espera_acabar_pausa	                ; verifica se o jogo esta em pausa e só continua se não estiver

	MOV    R9, [evento_int_bonecos]				; lê o LOCK desta instância (bloqueia até a rotina de interrupção
												; respetiva escrever neste LOCK)
	CALL   apaga_boneco							; apaga o boneco na sua posição corrente

	MOV    R9, [ESTADO_JOGO]                  
	MOV    R11, PARADO
	CMP    R9, R11                             	; verifica se o jogo está parado
	JZ 	   para_jogo                           	; se sim, para o jogo e volta pra o início do processo

	MOV    R4, [LINHA_ATUAL_SONDA_DIREITA]     	; guarda o valor da linha atual da sonda da esquerda para um registo
	MOV    R9, R6 								
	ADD    R9, 6                               	; adiciona 6 ao valor da linha atual do asteroide para se obter a última linha do asteroide 
	CMP    R9, R4                               
	JGT    colisao_asteroide_direita 			; se a linha do asteroide for maior que a da sonda pode existir colisão

movimento_asteroide_centro_direita:             ; continua o movimento do asteroide
	INC   R6			 						; incrementa o valor da linha do asteroide
	INC   R7			 						; incrementa o valor da coluna do asteroide
	SUB   R1, 1                                 ; retira 1 ao valor máximo que o asteroide se pode mover
	JNZ   redesenhar_asteroide_centro_direita   ; se sair do ecrã, volta para o início do processo, se não, continua o ciclo
	JMP	  asteroide			               		; repete o processo do asteroide


colisao_asteroide_direita:                      ; verificar se existe colisão
	MOV    R9, [COLUNA_ATUAL_SONDA_DIREITA]     ; guarda o valor da coluna atual da sonda da esquerda para um registo
	MOV    R11, R7
	ADD    R11, 5                               ; adiciona 5 ao valor da coluna do asteroide para se obter a coluna mais à direita do asteroide
	SUB    R11, R9                              ; retira ao valor da coluna do asteroide o valor da coluna da sonda
	MOV    R9, 5
	CMP    R11, R9
	JGE    movimento_asteroide_centro_direita   ; verificar se esse valor é maior ou igual a 5, se for, não existe colisão 
	MOV    R9, 0
	CMP    R11, R9
	JLT    movimento_asteroide_centro_direita   ; verificar também, se esse valor é menor 0, se for, não existe colisão 
	JMP    colisao_asteroide                    ; se não for nenhum dos casos, salta para a função responsável pelas colisões


redesenhar_asteroide_centro:                    ; ciclo de redesenhar o asteroide a descer do centro

	YIELD 									    ; este ciclo é potencialmente bloqueante, pelo que tem de
												; ter um ponto de fuga (aqui pode comutar para outro processo) 
	CALL   desenha_boneco	                    ; desenha o asteroide na posição indicada
	CALL   espera_acabar_pausa	                ; verifica se o jogo esta em pausa e só continua se não estiver

	MOV    R9, [evento_int_bonecos]				; lê o LOCK desta instância (bloqueia até a rotina de interrupção
												; respetiva escrever neste LOCK)
	CALL   apaga_boneco							; apaga o boneco na sua posição corrente

	MOV    R9, [ESTADO_JOGO]                  
	MOV    R11, PARADO
	CMP    R9, R11                             	; verifica se o jogo está parado
	JZ 	   para_jogo                           	; se sim, para o jogo e volta para o início do processo

	MOV    R4, [LINHA_ATUAL_SONDA_MEIO]        	; guarda o valor da linha atual da sonda da direita para um registo
	MOV    R9, R6        
	ADD    R9, 6                               	; adiciona 6 ao valor da linha atual do asteroide para se obter á última linha do asteroide 
	CMP    R9, R4     
	JGT    colisao_asteroide                   	; se a linha do asteroide for maior que a da sonda existe colisão

	MOV    R9, LINHA_PAINEL_COL                	; guarda o valor da linha do painel
	CMP    R9, R6
	JZ     painel_destroi                      	; se a linha do asteroide e a do painel forem iguais perde-se o jogo

	INC    R6			 						; incrementa o valor da linha do asteroide
	MOV    [LINHA_ATUAL_AST_MEIO], R6          	; guarda esse valor num endereço
	SUB    R1, 1                               	; retira 1 ao valor máximo que o asteroide se pode mover
	JNZ    redesenhar_asteroide_centro         	; se sair do ecrã, volta para o início do processo, se não, continua o ciclo
	JMP    asteroide			                ; repete o processo do asteroide


; ***********************************************************************************
; ASTEROIDE_ESPECIAL - Define o asteroide especial
; 
; Retorna:		R10 - valor do endereço da tabela que define o 
;					 asteroide especial
;
; ***********************************************************************************

asteroide_especial:
	MOV    R10, DEF_AST_ESP		; endereço da tabela que define o asteroide especial
	RET


; ***********************************************************************************
; MUDA_DISPLAY_ESPECIAL - Adiciona 25 ao display
;
; ***********************************************************************************

muda_display_especial:
	PUSH   R1
	PUSH   R2
	PUSH   R10
	MOV    R10, [VALOR_DISPLAY]
	MOV    R2, 25
	ADD    R10, R2                  ; adiciona ao valor atual decimal do display 25   
	MOV    [VALOR_DISPLAY], R10		; atualiza o endereço do valor atual do display
	CALL   converte_hexa            ; converte esse valor para hexadecimal	 	
	MOV    R1, DISPLAYS            
	MOV    [R1], R10                ; coloca o valor convertido no display

muda_display_especial_fim:
	POP    R10
	POP    R2
	POP    R1
	RET


; ***********************************************************************************
; Processo
;
; SONDA_MEIO - Processo que controla todas as funcionalidades da sonda do meio
;			   com temporização marcada pela interrupção 1.
;
; ***********************************************************************************

PROCESS SP_inicial_sonda_meio					; indicação de que a rotina que se segue é um processo
												; com indicação do valor para inicializar o SP
sonda_meio:										; processo que implementa o comportamento da sonda do meio
	MOV 	R8, 37
	MOV 	[LINHA_ATUAL_SONDA_MEIO], R8 		; define a linha atual da sonda do meio como 37 (definida fora do ecrã para evitar colisões indesejadas)
    MOV 	R6, 26
	MOV		R7, 31
	MOV		R10, DEF_SONDA
	MOV 	R8, 12

espera_movimento_sonda_meio: 					; ciclo que espera que uma tecla seja pressionada e, se for, verifica se foi a tecla E. Se não, repete
	MOV	 	R0, [tecla_carregada]				; bloqueia neste LOCK até uma tecla ser carregada

	MOV 	R3, [ESTADO_JOGO]
	MOV 	R4, ATIVO
	CMP 	R3, R4 								; verifica se o estado do jogo está ativo
	JNZ  	espera_movimento_sonda_meio 		; se não estiver, volta para o LOCK e espera que outra tecla seja carregada

	MOV  	R5, TECLA_E
	CMP	 	R0, R5		    					; verifica se a tecla carregada é a tecla E
	JNZ	 	espera_movimento_sonda_meio			; se não for, volta para o LOCK e espera que outra tecla seja carregada

	CALL 	muda_display 						; se for, chama a função que subtrai 5 ao valor do display
	MOV 	[LINHA_ATUAL_SONDA_MEIO], R6 		; define a linha atual da sonda do meio como o valor no registo R6 (inicialmente 26)
	MOV  	R5, 3 					
	MOV  	[REPRODUZ_SOM], R5 					; reproduz o som de lançamento de uma sonda

redesenhar_sonda_meio: 							; ciclo que desenha as várias posições da sonda do meio

	YIELD

	CALL   desenha_boneco 						; desenha a sonda do meio na linha definida pelo registo R6 e na coluna definida pelo registo R7
	CALL   espera_acabar_pausa 					; verifica se o jogo está em pausa e, se estiver, permanece num ciclo até não estar
	MOV    R3, [evento_int_bonecos + 2] 		; lê o LOCK desta instância (bloqueia até a rotina de interrupção respetiva escrever neste LOCK)
	CALL   apaga_boneco							; apaga a sonda do meio na mesma linha e coluna em que foi desenhada
	SUB    R6, 1			 					; muda-se a linha onde será desenhada a sonda do meio para a que está diretamente em cima
	MOV    [LINHA_ATUAL_SONDA_MEIO], R6 		; defini-se a linha atual da sonda do meio como a nova linha onde ela será desenhada
	MOV    R2, [LINHA_ATUAL_AST_MEIO]
	ADD    R2, 2 								; aumentar a "hitbox" do asteroide do meio
	CMP    R6, R2 								; verifica se a linha da sonda do meio é menor que a linha do asteroide
	JLT    sonda_meio 							; se for, repete o processo, de modo a que a sonda do meio seja considerada como destruída

	MOV    R9, [ESTADO_JOGO]
	MOV    R11, PARADO
	CMP    R9, R11 								; verifica se o estado do jogo está parado
	JZ     para_jogo_1 							; se estiver, espera até que o jogo seja recomeçado e fique ativo

	SUB    R8, 1 								; reduz o número possível de movimentos da sonda do meio por 1
	JNZ    redesenhar_sonda_meio 				; se o número de movimentos ainda não for 0, recomeça o ciclo
	JMP    sonda_meio							; se for, recomeça o processo da sonda do meio



para_jogo_1:
	MOV    R11, [parado] 						; bloqueia neste LOCK até o jogo ser recomeçado
	JMP    sonda_meio 							; repete o processo da sonda do meio


; ***********************************************************************************
; Processo
;
; SONDA_ESQUERDA - Processo que controla todas as funcionalidades da sonda da esquerda
;				   com temporização marcada pela interrupção 1.
;
; ***********************************************************************************

PROCESS SP_inicial_sonda_esquerda 				; indicação de que a rotina que se segue é um processo
												; com indicação do valor para inicializar o SP
sonda_esquerda: 								; processo que implementa o comportamento da sonda da esquerda
    MOV    R8, 37 
    MOV    [LINHA_ATUAL_SONDA_ESQUERDA], R8		; define a linha atual da sonda da esquerda como 37 (definida fora do ecrã para evitar colisões indesejadas)
    MOV    R6, 26
	MOV    R7, 27
	MOV    R10, DEF_SONDA
	MOV    R8, 12

espera_movimento_sonda_esquerda: 				; ciclo que espera que uma tecla seja pressionada e, se for, verifica se foi a tecla D. Se não, repete
	MOV    R0, [tecla_carregada] 				; bloqueia neste LOCK até uma tecla ser carregada

	MOV    R3, [ESTADO_JOGO]
	MOV    R4, ATIVO
	CMP    R3, R4 								; verifica se o estado do jogo está ativo
	JNZ    espera_movimento_sonda_esquerda 		; se não estiver, volta para o LOCK e espera que outra tecla seja carregada

	MOV    R5, TECLA_D
	CMP    R0, R5 								; verifica se a tecla carregada é a tecla D
	JNZ    espera_movimento_sonda_esquerda		; se não for, volta para o LOCK e espera que outra tecla seja carregada

	CALL   muda_display 						; se for, chama a função que subtrai 5 ao valor do display
	MOV    [LINHA_ATUAL_SONDA_ESQUERDA], R6 	; define a linha atual da sonda da esquerda como o valor no registo R6 (inicialmente 26)
	MOV    R5, 3 					
	MOV    [REPRODUZ_SOM], R5 					; reproduz o som de lançamento de uma sonda


redesenhar_sonda_esquerda: 						; ciclo que desenha as várias posições da sonda da esquerda

	YIELD

	CALL   desenha_boneco 						; desenha a sonda da esquerda na linha definida pelo registo R6 e na coluna definida pelo registo R7
	CALL   espera_acabar_pausa 					; verifica se o jogo está em pausa e, se estiver, permanece num ciclo até não estar
	MOV    R3, [evento_int_bonecos + 2] 		; lê o LOCK desta instância (bloqueia até a rotina de interrupção respetiva escrever neste LOCK)
	CALL   apaga_boneco							; apaga a sonda da esquerda na mesma linha e coluna em que foi desenhada
	SUB    R6, 1			 					; muda-se a linha onde será desenhada a sonda da esquerda para a que está diretamente em cima
	MOV    [LINHA_ATUAL_SONDA_ESQUERDA], R6 	; defini-se a linha atual da sonda da esquerda como a nova linha onde ela será desenhada
	SUB    R7, 1 								; muda-se a coluna onde será desenhada a sonda da esquerda para a que está à sua esquerda
	MOV    [COLUNA_ATUAL_SONDA_ESQUERDA], R7 	; defini-se a coluna atual da sonda da esquerda como a nova coluna onde ela será desenhada
	MOV    R2, [LINHA_ATUAL_AST_ESQ]
	ADD    R2, 2 								; aumentar a "hitbox" do asteroide da esquerda
	CMP    R6, R2 								; verifica se a linha da sonda da esquerda é menor que a linha do asteroide 
	JLE    sonda_esquerda 						; se for, repete o processo, de modo a que a sonda da esquerda seja considerada como destruída

	MOV    R9, [ESTADO_JOGO]
	MOV    R11, PARADO
	CMP    R9, R11 								; verifica se o estado do jogo está parado
	JZ     para_jogo_2 							; se estiver, espera até que o jogo seja recomeçado e fique ativo

	SUB    R8, 1 								; reduz o número possível de movimentos da sonda da esquerda por 1
	JNZ    redesenhar_sonda_esquerda 			; se o número de movimentos ainda não for 0, recomeça o ciclo
	JMP    sonda_esquerda 						; se for, recomeça o processo da sonda da esquerda



para_jogo_2:
	MOV    R11, [parado] 						; bloqueia neste LOCK até o jogo ser recomeçado
	JMP    sonda_esquerda 						; repete o processo da sonda da esquerda


; ***********************************************************************************
; Processo
;
; SONDA_DIREITA - Processo que controla todas as funcionalidades da sonda da direita
;				  com temporização marcada pela interrupção 1.
;
; ***********************************************************************************

PROCESS SP_inicial_sonda_direita 				; indicação de que a rotina que se segue é um processo
												; com indicação do valor para inicializar o SP
sonda_direita: 									; processo que implementa o comportamento da sonda da direita
    MOV    R8, 37
    MOV    [LINHA_ATUAL_SONDA_DIREITA], R8 		; define a linha atual da sonda da direita como 37 (definida fora do ecrã para evitar colisões indesejadas)
    MOV    R6, 26
	MOV    R7, 35
	MOV    R10, DEF_SONDA
	MOV    R8, 12

espera_movimento_sonda_direita: 				; ciclo que espera que uma tecla seja pressionada e, se for, verifica se foi a tecla F. Se não, repete
	MOV    R0, [tecla_carregada] 				; bloqueia neste LOCK até uma tecla ser carregada

	MOV    R3, [ESTADO_JOGO]
	MOV    R4, ATIVO
	CMP    R3, R4 								; verifica se o estado do jogo está ativo
	JNZ    espera_movimento_sonda_direita 		; se não estiver, volta para o LOCK e espera que outra tecla seja carregada

	MOV    R5, TECLA_F
	CMP    R0, R5		    					; verifica se a tecla carregada é a tecla F
	JNZ    espera_movimento_sonda_direita		; se não for, volta para o LOCK e espera que outra tecla seja carregada

	CALL   muda_display 						; se for, chama a função que subtrai 5 ao valor do display
	MOV    [LINHA_ATUAL_SONDA_DIREITA], R6		; define a linha atual da sonda da direita como o valor no registo R6 (inicialmente 26)
	MOV    R5, 3 					
	MOV    [REPRODUZ_SOM], R5 					; reproduz o som de lançamento de uma sonda


redesenhar_sonda_direita: 						; ciclo que desenha as várias posições da sonda da direita

	YIELD

	CALL   desenha_boneco 						; desenha a sonda da direita na linha definida pelo registo R6 e na coluna definida pelo registo R7
	CALL   espera_acabar_pausa 					; verifica se o jogo está em pausa e, se estiver, permanece num ciclo até não estar
	MOV    R3, [evento_int_bonecos + 2] 		; lê o LOCK desta instância (bloqueia até a rotina de interrupção respetiva escrever neste LOCK)
	CALL   apaga_boneco							; apaga a sonda da direita na mesma linha e coluna em que foi desenhada
	SUB    R6, 1			 					; muda-se a linha onde será desenhada a sonda da direita para a que está diretamente em cima
	MOV    [LINHA_ATUAL_SONDA_DIREITA], R6		; defini-se a linha atual da sonda da direita como a nova linha onde ela será desenhada
	ADD    R7, 1 								; muda-se a coluna onde será desenhada a sonda da direita para a que está à sua direita
	MOV    [COLUNA_ATUAL_SONDA_DIREITA], R7 	; defini-se a coluna atual da sonda da direita como a nova coluna onde ela será desenhada
	MOV    R2, [LINHA_ATUAL_AST_DTR]
	ADD    R2, 2 								; aumentar a "hitbox" do asteroide da direita
	CMP    R6, R2 								; verifica se a linha da sonda da direita é menor que a linha do asteroide
	JLE    sonda_direita 						; se for, repete o processo, de modo a que a sonda da direita seja considerada como destruída

	MOV    R9, [ESTADO_JOGO]
	MOV    R11, PARADO
	CMP    R9, R11 								; verifica se o estado do jogo está parado
	JZ 	   para_jogo_3 							; se estiver, espera até que o jogo seja recomeçado e fique ativo

	SUB    R8, 1 								; reduz o número possível de movimentos da sonda da direita por 1
	JNZ    redesenhar_sonda_direita 			; se o número de movimentos ainda não for 0, recomeça o ciclo
	JMP	   sonda_direita						; se for, recomeça o processo da sonda do meio



para_jogo_3:
	MOV    R11, [parado] 						; bloqueia neste LOCK até o jogo ser recomeçado
	JMP    sonda_direita 						; repete o processo da sonda da direita


; ***********************************************************************************
; MUDA_DISPLAY - SUBTRAI 5 ao display
;
; ***********************************************************************************

muda_display: 									; reduz o valor que está no display após ser lançada uma sonda
	PUSH   R1
	PUSH   R10
	MOV    R10, [VALOR_DISPLAY]
	SUB    R10, 5
	MOV    [VALOR_DISPLAY], R10 				; subtrai 5 ao valor que está no display
	CALL   converte_hexa						; converte este número num valor hexadecimal
	MOV    R1, DISPLAYS
	MOV    [R1], R10 							; coloca este número no display
	POP    R10
	POP    R1
	RET


; ***********************************************************************************
; Processo
;
; DISPLAY - Processo que controla as subtrações por 3 do display, com temporizações
;			marcadas pela interrupção 2, e que verifica se a energia da nave é menor
;   		ou igual a 0.
;
; ***********************************************************************************

PROCESS SP_display 								; indicação de que a rotina que se segue é um processo
    
display:		         						; ciclo que faz a subtração por 3 do valor do display de 3 em 3 segundos e que converte o valor do display
												; para um valor decimal
	YIELD 										; este ciclo é potencialmente bloqueante, pelo que tem de
												; ter um ponto de fuga (aqui pode comutar para outro processo)

	CALL   espera_acabar_pausa 					; verifica se o jogo está em pausa e, se estiver, permanece num ciclo até não estar
	MOV    R9, [ESTADO_JOGO]
	MOV    R11, PARADO
	CMP    R9, R11 								; verifica se o jogo está parado
	JZ 	   para_jogo_4 							; se estiver, espera até que o jogo seja recomeçado e fique ativo

	MOV    R10, [VALOR_DISPLAY]
 	CALL   converte_hexa 						; converte o valor que vai estar no display para hexadecimal
    MOV    R1, DISPLAYS
    MOV    [R1], R10 							; coloca este valor no display

    MOV    R3, [evento_int_bonecos + 4] 		; lê o LOCK desta instância (bloqueia até a rotina de interrupção respetiva escrever neste LOCK)
   	MOV    R10, [VALOR_DISPLAY]

    SUB    R10, 3 								; subtrai 3 ao valor que está no display

    MOV    R2, 0
    CMP    R10, R2 								; verifica se o valor é menor ou igual que 0
    JLE    display_0 							; se for, dá-se uma derrota

    MOV    [VALOR_DISPLAY], R10

    JMP    display 			 					; se não, repete-se o ciclo

para_jogo_4:
	MOV    R11, [parado] 						; bloqueia neste LOCK até o jogo ser recomeçado
	JMP    display    		 					; repete o ciclo

converte_hexa: 									; função que converte o valor que vai estar no display para hexadecimal
	PUSH   R6
	PUSH   R7
	PUSH   R8
	PUSH   R9
	MOV    R9, 0
	MOV    R8, FATOR
	MOV    R7, 10

conversao: 										; início do algortimo de conversão de decimal para hexadecimal
	MOD    R10, R8
	DIV    R8, R7
	MOV    R6, R10
	DIV    R6, R8
	SHL    R9, 4
	OR 	   R9, R6
	CMP    R8, R7
	JLT    termina 								; se o fator for menor que 10, termina a conversão
	JMP    conversao 							; se não, continua

termina:
 	MOV    R10, R9
 	POP    R9
 	POP    R8
 	POP    R7
 	POP    R6
 	RET

display_0:                                      ; derrota de ficar sem energia
	MOV    R4, PARADO
	MOV    [ESTADO_JOGO], R4                  	; atualiza o estado de jogo para parado
    MOV    [R1], R2                           	; coloca o valor 0 no display
    MOV    R5, 4
	MOV    [REPRODUZ_SOM], R5 					; reproduz o som de derrota
    MOV    [APAGA_ECRÃ], R1						; apaga todos os pixels já desenhados 
	MOV	   R1, 3								; cenário de fundo número 3
    MOV    [SELECIONA_CENARIO_FUNDO], R1		; seleciona o cenário de fundo de derrota

	JMP    display    		 					; recomeça o ciclo de conversão


; ***********************************************************************************
; Processo
;
; PAINEL - Processo que controla as alternações das cores do painel, com 
;		   temporizações marcadas pela interrupção 4.
;
; ***********************************************************************************

PROCESS SP_inicial_painel

painel:				
	MOV    R10, DEF_PAINEL
	MOV    R6, 27
	MOV    R7, 27
	CALL   desenha_boneco						; desenha o painel na linha definida pelo registo R6 e na coluna definida pelo registo R7

	MOV    R6, 30
	MOV    R7, 30
	MOV    R11, PARADO

ciclo_painel: 									; ciclo que alterna as cores do display

	YIELD 										; este ciclo é potencialmente bloqueante, pelo que tem de
												; ter um ponto de fuga (aqui pode comutar para outro processo) 

	CALL   espera_acabar_pausa 					; verifica se o jogo está em pausa e, se estiver, permanece num ciclo até não estar
	MOV    R9, [ESTADO_JOGO]
	CMP    R9, R11 								; verifica se o jogo está parado
	JZ 	   para_jogo_5 							; se estiver, espera até que o jogo seja recomeçado e fique ativo

	MOV    R10, DEF_PAINEL_1
	CALL   desenha_boneco						; desenha a primeira versão do painel
	MOV    R3, [evento_int_bonecos + 6] 		; lê o LOCK desta instância (bloqueia até a rotina de interrupção respetiva escrever neste LOCK)

	CALL   espera_acabar_pausa
	MOV    R9, [ESTADO_JOGO]
	CMP    R9, R11 								; verifica se o jogo está parado
	JZ 	   para_jogo_5 							; se estiver, espera até que o jogo seja recomeçado e fique ativo

	MOV    R10, DEF_PAINEL_2
	CALL   desenha_boneco						; desenha a segunda versão do painel
	MOV    R3, [evento_int_bonecos + 6] 		; lê o LOCK desta instância (bloqueia até a rotina de interrupção respetiva escrever neste LOCK)

	CALL   espera_acabar_pausa
	MOV    R9, [ESTADO_JOGO]
	CMP    R9, R11 								; verifica se o jogo está parado
	JZ 	   para_jogo_5 							; se estiver, espera até que o jogo seja recomeçado e fique ativo

	MOV    R10, DEF_PAINEL_3
	CALL   desenha_boneco						; desenha a segunda versão do painel
	MOV    R3, [evento_int_bonecos + 6] 		; lê o LOCK desta instância (bloqueia até a rotina de interrupção respetiva escrever neste LOCK)

	JMP    ciclo_painel 						; recomeça este ciclo


para_jogo_5:
	MOV    R11, [parado] 						; bloqueia neste LOCK até o jogo ser recomeçado
	JMP    painel 								; repete o ciclo


; ***********************************************************************************
; ESPERA_ACABAR_PAUSA - Verifica se o jogo está em pausa e, se estiver, fica 
;           	   		bloqueado num LOCK.  
;
; ***********************************************************************************

espera_acabar_pausa:
	PUSH R4
	PUSH R5
	MOV  R5, PAUSA 
	MOV  R4, [ESTADO_JOGO] 		
	CMP  R4, R5                 ; verifica se o jogo está em pausa   
	JNZ  retomar_jogo           ; se estiver retorna para onde estava
	MOV  R4, [pausa]            ; se estiver, em pausa o programa é bloqueado neste LOCK 
								; até o jogo ser recomeçado ou ter terminado a pausa
retomar_jogo:
	POP  R5
	POP  R4
	RET

; ***********************************************************************************
; DESENHA_BONECO - Desenha um boneco na linha e coluna indicadas
;				   com a forma e cor definidas na tabela indicada.
; Argumentos:	R6 - linha inicial
;               R7 - coluna inicial
;               R10 - tabela
;
; ***********************************************************************************


desenha_boneco:
	PUSH    R1
    PUSH    R3
    PUSH    R4
    PUSH    R5
    PUSH    R6
    PUSH    R7
    PUSH    R8
    PUSH    R10
    MOV    R4, [R10]            ; obtém a altura do boneco
    ADD    R10, 2            	; endereço da largura (2 porque a altura é uma word)
    MOV    R5, [R10]			; obtém a largura
    ADD    R10, 2               ; endereço da cor do 1º pixel (2 porque a largura é uma word)
    MOV    R1, R7               ; guarda coluna inicial
    MOV    R8, R5				; guarda largura

desenha_pixeis:                 ; desenha os pixeis do boneco a partir da tabela
    MOV    R3, [R10]            ; obtém a cor do próximo pixel do boneco
    CALL   desenha_pixel		; escreve cada pixel do boneco
    ADD    R10, 2               ; endereço da cor do próximo pixel (2 porque a largura é uma word)
    INC    R7                   ; próxima coluna
    SUB    R5, 1            	; menos uma coluna para desenhar
    JNZ    desenha_pixeis		; continua até percorrer toda a largura do objeto
    MOV    R5, R8				; atualiza o valor da largura ao mudar de linha
    MOV    R7, R1				; atualiza o valor da coluna ao mudar de linha
    INC    R6					; muda de linha
    SUB    R4, 1		    	; menos uma linha para desenhar
    JNZ    desenha_pixeis		; continua até percorrer toda a altura do objeto
    POP    R10
    POP    R8
    POP    R7
    POP    R6
    POP    R5
    POP    R4
    POP    R3
    POP    R1
    RET


; ***********************************************************************************
; DESENHA_PIXEL - Desenha um pixel na linha e coluna indicadas.
; Argumentos:   R6 - linha
;               R7 - coluna
;               R3 - cor do pixel (em formato ARGB de 16 bits)
;
; ***********************************************************************************


desenha_pixel:
	MOV    [DEFINE_LINHA], R6		; seleciona a linha
	MOV    [DEFINE_COLUNA], R7		; seleciona a linha
    MOV    [DEFINE_PIXEL], R3       ; altera a cor do pixel na linha e coluna já selecionadas
    RET


; ***********************************************************************************
; APAGA_BONECO - Pinta o boneco com a cor transparente, começando na
;				 linha onde anteriormente tinha começado para o pintar
; Argumentos:	R6 - linha inicial
;               R7 - coluna inicial
;               R10 - tabela
;
; ***********************************************************************************


apaga_boneco:
	PUSH    R1
    PUSH    R3
    PUSH    R4
    PUSH    R5
    PUSH    R6
    PUSH    R7
    PUSH    R8
    PUSH    R10
    MOV    R4, [R10]            ; obtém a altura do boneco
    ADD    R10, 2            	; endereço da largura (2 porque a altura é uma word)
    MOV    R5, [R10]			; obtém a largura
    MOV    R1, R7               ; guardar a coluna inicial
    MOV    R8, R5				; guardar a largura

apaga_pixeis:                 	; apaga os pixeis do boneco a partir da tabela
    MOV    R3, COR_APAGADO		; cor para apagar o próximo pixel do boneco 
    CALL   desenha_pixel		; escreve cada pixel do boneco
    INC    R7                   ; próxima coluna
    SUB    R5, 1            	; menos uma coluna para desenhar
    JNZ    apaga_pixeis			; continua até percorrer toda a largura do objeto
    MOV    R5, R8				; atualiza o valor da largura ao mudar de linha
    MOV    R7, R1				; atualiza o valor da coluna ao mudar de linha
    INC    R6					; muda de linha
    SUB    R4, 1		    	; menos uma altura para desenhar
    JNZ    apaga_pixeis			; continua até percorrer toda a altura do objeto
    POP    R10
    POP    R8
    POP    R7
    POP    R6
    POP    R5
    POP    R4
    POP    R3
    POP    R1
    RET



; ***********************************************************************************
; ROT_INT_0 - 	Rotina de atendimento da interrupção 0
;			Faz uma escrita no LOCK que o processo dos asteroides lê.
;
; ***********************************************************************************

rot_int_0:
	MOV  [evento_int_bonecos], R0		; desbloqueia o processo asteroide 
										; O valor a somar à base da tabela dos LOCKs é
										; o dobro do número da interrupção, pois a tabela é de WORDs
	RFE

; ***********************************************************************************
; ROT_INT_1 - 	Rotina de atendimento da interrupção 1
;			Faz uma escrita no LOCK que os 3 processos das sondas lêem.
;
; ***********************************************************************************

rot_int_1:
	MOV  [evento_int_bonecos + 2], R0 	; desbloqueia os processos das sondas 
										; O valor a somar à base da tabela dos LOCKs é
										; o dobro do número da interrupção, pois a tabela é de WORDs
	RFE

; ***********************************************************************************
; ROT_INT_2 - 	Rotina de atendimento da interrupção 2
;			Faz uma escrita no LOCK que o processo do display lê.
;
; ***********************************************************************************

rot_int_2:
	MOV  [evento_int_bonecos + 4], R0	; desbloqueia o processo display
										; O valor a somar à base da tabela dos LOCKs é
										; o dobro do número da interrupção, pois a tabela é de WORDs
	RFE


; ***********************************************************************************
; ROT_INT_3 - 	Rotina de atendimento da interrupção 3
;			Faz uma escrita no LOCK que o processo do painel lê.
;
; ***********************************************************************************

rot_int_3:
	MOV  [evento_int_bonecos + 6], R0	; desbloqueia o processo painel 
										; O valor a somar à base da tabela dos LOCKs é
										; o dobro do número da interrupção, pois a tabela é de WORDs
	RFE
