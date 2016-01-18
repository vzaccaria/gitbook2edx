Invocazione innestata di funzioni
=================================

Ricapitolando ciò che abbiamo visto fin'ora:

-   Scrivere una funzione significa scrivere il metodo per risolvere un
    problema a partire da un insieme di dati iniziali generici.

-   Invocare una funzione significa risolvere il problema per dati
    specifici.

Benché sia possibile risolvere un problema grosso all'interno di una
singola funzione, in informatica si cerca il più possibile di
riutilizzare funzioni già esistenti.

Supponiamo di voler descrivere il metodo per calcolare la distanza di un
punto di coordinate `(x,y)` dal centro del piano cartesiano con una
funzione Octave:

``` matlab
function d = calcolaDistanza(x,y)
  ...
end
```

Un approccio per completare la funzione è quello di descrivere nei
minimi dettagli la soluzione del problema utilizzando solo gli operatori
base dell'aritmetica (`*`, `+`, `-`, `/`) e qualche ciclo iterativo.

L'approccio è legittimo ma ci porterebbe a descrivere una funzione molto
lunga e, con molta probabilità, contenente errori.

Un secondo approccio è quello di sfruttare una funzione già scritta
dagli sviluppatori di Octave per elevare a potenza dei numeri: `power`
[(manuale)](https://www.gnu.org/software/octave/doc/interpreter/Arithmetic-Ops.html#XREFpower).

Seguendo questo approccio, possiamo scrivere la funzione
`calcolaDistanza` utilizzando il [teorema di
Pitagora](http://it.wikipedia.org/wiki/Teorema_di_Pitagora):

``` matlab
function d = calcolaDistanza(x,y)
  d = pow(pow(x,2)+pow(y,2), 1/2)
end
```

Octave ha un insieme enorme di [funzioni già
scritte](http://octave.sourceforge.net/octave/overview.html). Prima di
iniziare a scrivere una vostra funzione, cercate di capire se può essere
scritta sfruttando funzioni già esistenti.

------------------------------------------------------------------------

Scrivere una funzione che calcola la distanza di un punto
tridimensionale dal centro degli assi:

``` matlab
function d = calcolaDistanza(x,y,z)

end
```

``` matlab
function d = calcolaDistanza(x,y,z)
  d = pow(pow(x,2)+pow(y,2)+pow(z,2), 1/2)
end
```

``` matlab
assert(calcolaDistanza(1,0,1) - 1 < epsilon)
```
