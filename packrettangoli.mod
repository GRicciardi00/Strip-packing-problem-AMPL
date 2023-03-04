#GIUSEPPE RICCIARDI, ANTONIO SIGNORELLI.
#LAUREA MAGISTRALE INGEGNGERIA INFORMATICA, UNIVERSITA' DEGLI STUDI DI PARMA 2022/2023.

#DATI
set RETTANGOLI; #insieme dei rettangoli da inserire nel contenitore
param B;  #base del contenitore
param N := card(RETTANGOLI); #numero di rettangoli
param l{RETTANGOLI}; #lunghezza del rettangolo
param h{RETTANGOLI}; #altezza del rettangolo

#VARIABILI
var H; #altezza del contenitore
var x{RETTANGOLI} >= 0; #coordinata sull'asse delle x del rettangolo i-esimo del vertice in basso a sinistra
var y{RETTANGOLI} >= 0; #coordinata sull'asse delle y del rettangolo i-esimo del vertice in basso a sinistra
var lunghezza{RETTANGOLI} >= 0; #assume valore l se rettangolo è posizionato in orizzontale altrimenti valore h.
var altezza{RETTANGOLI} >= 0; #assume valore h se rettangolo è posizionato in orizzontale altrimenti valore w.
var c_o{RETTANGOLI,RETTANGOLI} binary; #variabile binaria per controllo overlapping orizzontale, 1 se presente overlapping 0 altrimenti.
var c_v{RETTANGOLI,RETTANGOLI} binary; #variabile binaria per controllo overlapping verticale, 1 se presente overlapping 0 altrimenti.
var rotazione{RETTANGOLI} binary; #assume 0 se il rettangolo è posizionato in orizzontale, 1 se il rettangolo è posizionato in verticale (w ed h sono invertiti)


#FUNZIONE OBIETTIVO -> minimizzare altezza contenitore
minimize obj: H; 

#VINCOLI
#la lunghezza di un rettangolo posizionato non deve superare il valore B per restare nel contenitore
subject to vincolo_lunghezza{i in RETTANGOLI}: 
		x[i]+lunghezza[i]<= B; #OK

#l'altezza di un rettangolo posizionato non deve superare il valore H per restare nel contenitore	
subject to vincolo_altezza{i in RETTANGOLI}: 
		y[i]+altezza[i]<= H;  #OK
		
#Se ruotato vale 1 allora lunghezza_i vale h_i
subject to assegnazione_lunghezza{i in RETTANGOLI}:
		lunghezza[i]= l[i]*(1-rotazione[i])+h[i]*rotazione[i];#OK
	
#Se ruotato vale 1 allora altezza_i vale l_i	
subject to assegnazione_altezza{i in RETTANGOLI}:
		altezza[i]=  h[i]*(1-rotazione[i])+l[i]*rotazione[i]; #OK

#Rettangolo i si trova a sinistra al rettangolo j
subject to vincolo_no_sovrap_sinistra{i in RETTANGOLI, j in RETTANGOLI: i<j}: 
		x[i]+lunghezza[i] <= x[j]+ B * c_o[i,j]; #OK

#Rettangolo i si trova a destra rispetto al rettangolo j		
subject to vincolo_no_sovrap_destra{i in RETTANGOLI, j in RETTANGOLI: i<j}: 
		x[j]+lunghezza[j] <= x[i]+ B * c_o[j,i]; #OK
		
#Rettangolo i si trova in basso rispetto al rettangolo j	
subject to vincolo_no_sovrap_alto{i in RETTANGOLI, j in RETTANGOLI: i<j}: 
		y[i]+altezza[i] <= y[j]+ H * c_v[i,j]; #OK

#Rettangolo i si trova in alto rispetto al rettangolo j	
subject to vincolo_no_sovrap_basso{i in RETTANGOLI, j in RETTANGOLI: i<j}: 
		y[j]+altezza[j] <= y[i]+ H * c_v[j,i]; #OK
		
#almeno uno dei vincoli delle sovrapposizioni deve essere rispettato
subject to vincolo_controllo_sovrap{i in RETTANGOLI, j in RETTANGOLI: i<j}:
		c_o[i,j]+c_o[j,i]+c_v[i,j]+c_v[j,i] <= 3; #OK
