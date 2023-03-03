
#DATI
set RETTANGOLI; #insieme dei rettangoli da inserire nel contenitore
param B;  #base del contenitore
param N := card(RETTANGOLI); #numero di rettangoli
param l{RETTANGOLI}; #lunghezza del rettangolo
param h{RETTANGOLI}; #altezza del rettangolo
param M_h = sum{i in RETTANGOLI} h[i]; #limite superiore esplicito altezza rettangolo
param M_l = sum{i in RETTANGOLI} l[i]; #limite superiore esplicito lunghezza rettangolo

#VARIABILI
var H; #altezza del contenitore
var x{RETTANGOLI} >= 0; #coordinata sull'asse delle x del rettangolo i-esimo del vertice in basso a sinistra
var y{RETTANGOLI} >= 0; #coordinata sull'asse delle y del rettangolo i-esimo del vertice in basso a sinistra
var lunghezza{RETTANGOLI} >= 0; #assume valore l se rettangolo è posizionato in orizzontale altrimenti valore h.
var altezza{RETTANGOLI} >= 0; #assume valore h se rettangolo è posizionato in orizzontale altrimenti valore w.
var rotazione{RETTANGOLI} binary; #assume 0 se il rettangolo è posizionato in orizzontale, 1 se il rettangolo è posizionato in verticale (w ed h sono invertiti)
var controllo_sinistra{RETTANGOLI,RETTANGOLI} binary; #assume 1 se è presente un rettangolo j alla sinistra del rettangolo i altrimenti 0.
var controllo_basso{RETTANGOLI,RETTANGOLI} binary; #assume 1 se è presente un rettangolo j in basso al rettangolo i altrimenti 0.

#FUNZIONE OBIETTIVO -> minimizzare altezza contenitore
minimize obj: H; 

#VINCOLI
subject to obbligo_adiacenza_dei_rettangoli {i in RETTANGOLI, j in RETTANGOLI: i<j}:
		controllo_sinistra[i,j] +  controllo_sinistra[j,i] + controllo_basso[i,j] + controllo_basso[j,i]  >= 1; #OK
subject to assegnazione_lunghezza{i in RETTANGOLI}:
		lunghezza[i]= l[i]*(1-rotazione[i])+h[i]*rotazione[i];#OK
subject to assegnazione_altezza{i in RETTANGOLI}:
		altezza[i]=  h[i]*(1-rotazione[i])+l[i]*rotazione[i]; #OK
subject to vincolo_adiacenza_sinistra{i in RETTANGOLI, j in RETTANGOLI: i!=j}: 
		x[i]-x[j]+M_l*controllo_sinistra[i,j]<= M_l-lunghezza[i]; #OK
subject to vincolo_adiacenza_basso{i in RETTANGOLI, j in RETTANGOLI: i!=j}: 
		y[i]-y[j]+M_h*controllo_basso[i,j] <= M_h-altezza[i]; #OK
subject to vincolo_lunghezza{i in RETTANGOLI}: 
		x[i]+lunghezza[i]<= B; #OK
subject to vincolo_altezza{i in RETTANGOLI}: 
		y[i]+altezza[i]<= H;  #OK
