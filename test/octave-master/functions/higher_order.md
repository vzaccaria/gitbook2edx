Funzioni di ordine superiore
============================

[Da
wikipedia](http://it.wikipedia.org/wiki/Funzione_di_ordine_superiore):
Una funzione di **ordine superiore** è una funzione che può prendere
altre funzioni come parametri e/o restituire funzioni come risultato.
L'operatore differenziale in matematica è un esempio di funzione di
ordine superiore.

Le funzioni di ordine superiore sono quindi funzioni che manipolano
altre funzioni.

Prologo: variabili che sono sinonimi di funzioni
------------------------------------------------

Prima di introdurre le funzioni di ordine superiore, diamo un'occhiata a
cosa significa assegnare una funzione ad una variabile.

Ricordiamo innanzitutto che una variabile è un contenitore. Possiamo
inserire al suo interno valori di vario tipo (numeri, vettori, matrici e
così via). Octave permette di fare una cosa in più; possiamo anche
inserire una **funzione** in una variabile. Ecco il codice che assegna
la funzione `incrementa` alla variabile `a`:

``` matlab
% `incrementa`:
function [y] = incrementa(x)
  y = x+1;
end

a = @incrementa
```

Attenzione: non è una invocazione! Stiamo semplicemente **creando un
sinonimo** per funzione `incrementa` che si chiama `a`.

Possiamo invocare `a` proprio come `incrementa`:

``` matlab
a = @incrementa
octave:5> a(1)
ans =  2
```

Esempio di funzione superiore
-----------------------------

Il seguente codice mostra come creare una funzione di ordine superiore
che applica una funzione passata come parametro ad un vettore in
ingresso:

``` matlab
% `applica`: applica la funzione `a` a tutti gli elementi
% del vettore `v` e ritorna v1
function [v1] = applica(v, a)
  v1 = [];
  for i = 1:length(v)
    v1 = [v1 a(v(i))];
  end
end
```

Possiamo invocare la funzione applica con il sinonimo di `incrementa`
per aggiungere 1 a tutti gli elementi di un vettore:

``` matlab
octave:7> v = [3 4 8]
v =

   3   4   8

octave:8>
octave:8> v1 = applica(v, @incrementa)
v1 =

   4   5   9
```

Funzioni anonime
----------------

Possiamo definire in maniera molto veloce dei sinonimi di funzioni,
addirittura senza che queste abbiano un nome predefinito (funzioni
anonime). Qui di seguito, ad esempio, `b` diventa il sinonimo di una
funzione che riceve il valore `x` e ritorna `x-1`:

``` matlab
b = @(x) x - 1
```

Utilizzare `applica` per effettuare manipolazioni di vettore diventa
ancora più semplice; ad esempio, in questa sessione usiamo `applica` per
decrementare gli elementi del vettore:

``` matlab
octave:9> v2 = applica(v, @(x)x-1)
v2 =

   2   3   7
```

------------------------------------------------------------------------

Completare la funzione di ordine superiore `filtra` che riceve un
vettore `v` ed una funzione `p(x)` che ritorna 0 oppure 1. `filtra`
ritorna un vettore i cui elementi `e` sono gli elementi di `v` per cui
`p(e)` ha ritornato 1.

``` matlab

function v1 = filtra(v, p)
  v1 = []
  for x=1:size(v,2)




  end
end

ris = filtra([1,2,3], @(x) x>1)
```

``` matlab
function v1 = filtra(v, p)
  v1 = []
  for x=1:size(v,2)
    x
    if(p(v(x)))
      v1 = [v1 v(x)]
    end
  end
end

ris = filtra([1,2,3], @(x) x>1)
```

``` matlab
assert(ris == [2, 3])
```
