Dichiarare una funzione
=======================

Cosa significa effettivamente la prima parte del programma precedente?

``` matlab
function r = cubo(a)
  r = a*a*a
end
```

E' la descrizione di come elevare al cubo qualsiasi numero: possiamo
leggerla in questo modo:

> Per elevare al **`cubo`** il numero **`a`**, il risultato **`r`** deve
> essere calcolato come **`a × a × a`**

La descrizione del metodo è chiamata **dichiarazione di funzione**. Le
linee di codice tra `function` ed `end` sono chiamate **corpo della
funzione** e possono essere anche una sequenza complessa (contenente
condizioni, cicli e quant'altro).

Due nozioni da sapere:

-   la variabile `a` è chiamata **parametro formale in ingresso**, o
    anche semplicemente **parametro in ingresso**.

-   La variabile `r` è chiamata **valore di ritorno** della funzione.

------------------------------------------------------------------------

Modificare la funzione `cubo` in modo tale che ritorni `1` **se e solo
se** il valore di `a` è maggiore di `4`, altrimenti si comporta come
quella già definita. Nota: Ricordare che le linee di codice tra
`function` ed `end` possono essere anche una sequenza complessa
(contenente condizioni, cicli e quant'altro).

``` matlab
function r = cubo(a)
  r = a*a*a
end
```

``` matlab
function r = cubo(a)
  if a > 4
    r = 1
  else
    r = a*a*a
  end
end
```

``` matlab
assert(cubo(3) == 9)
assert(cubo(4) == 1)
```
