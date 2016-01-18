Ricorsione
==========

Supponiamo di voler scrivere il metodo per calcolare [il fattoriale di
un numero](http://it.wikipedia.org/wiki/Fattoriale).

``` matlab
function f = fattoriale(n)
...
end
```

Prima di accingerci a farlo, vediamo alcuni esempi per qualche numero:

-   fattoriale di 1 = 1
-   fattoriale di 2 = 2 \* 1
-   fattoriale di 3 = 3 \* 2 \* 1
-   fattoriale di 4 = 4 \* 3 \* 2 \* 1
-   e così via..

Ci accorgiamo subito di una **regolarità del metodo**, ovvero che, a
parte il fattoriale di 1:

-   fattoriale di 2 = 2 \* fattoriale di 1
-   fattoriale di 3 = 3 \* fattoriale di 2
-   fattoriale di 4 = 4 \* fattoriale di 3
-   e così via..

Possiamo dire che il metodo generale per calcolare il fattoriale di `n`
è, per `n` diverso da 1:

-   fattoriale di n = n \* fattoriale di (n-1)

Il caso particolare di `n=1` è detto **caso base**, ovvero l'unico
valore di `n` per cui non vale la definizione appena data.

Siccome la definizione della funzione `fattoriale` ricorre a se stessa
per risolvere il problema, viene detta
[**ricorsiva**](http://it.wikipedia.org/wiki/Funzione_ricorsiva).

Ricorsione in Octave
--------------------

Octave ci permette di descrivere soluzioni ricorsive in maniera
abbastanza intuitiva. Dobbiamo stare solo attenti a capire quando
bisogna applicare la regola ricorsiva e quando, invece, dobbiamo
applicare il caso base. La definizione ricorsiva del fattoriale in
Octave è la seguente:

``` matlab
function f = fattoriale(n)
  if n == 1
    f = 1
  else
    f = n * fattoriale(n-1)
end
```

------------------------------------------------------------------------

Scrivere una funzione ricorsiva `somma(n)` che effettua la somma di
tutti i numeri da `1` ad `n`:

``` matlab
function r = somma(a)

end
```

``` matlab
function r = somma(n)
  if n == 1
    r = 1
  else
    r = n + somma(n-1)
end
```

``` matlab
assert(somma(5) == 15)
```
