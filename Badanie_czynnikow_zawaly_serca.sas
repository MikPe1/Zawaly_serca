
/*      Analiza czynnikow wplywajacych na wystepowanie zawalu serca przy uzyciu regresji logistycznej       */


/* ustalenie katalogu roboczego */

x 'cd C:\Users\123\Desktop\EAD';
libname dane 'C:\Users\123\Desktop\EAD\dane';
proc import datafile='zawaly.csv' out=pacjenci dbms=csv replace;
run;


proc logistic data= pacjenci;
model target(event='1') = mezczyzna tetno bol_typ3 bol_typ1 spadek_ST
ST_nach2 szer_zyly thal1 /rsquare;
output out = pred_logit p=p;
run;
data pred_logit;
set pred_logit;
if p<=0.5
then y=0;
if p>0.5
then y=1;
run;
proc freq data=pred_logit;
tables target*y / out=cross_results;
run;
data cross_results;
set cross_results;
if target = 1 and y = 1 then result_type = 'TP';
if target = 1 and y = 0 then result_type = 'FN';
if target = 0 and y = 1 then result_type = 'FP';
if target = 0 and y = 0 then result_type = 'TN';
run;
data pred_logit;
set pred_logit;
if target=y then dobra_klasyfikacja=1;

else dobra_klasyfikacja=0;

run;
proc freq data=pred_logit;
tables dobra_klasyfikacja;


run;
proc univariate data=Pacjenci;
var wiek;
histogram wiek/weibull;
run;

/* W N I O S K I */

/* W badaniu zastosowano model Logit do predykcji prawdopodobie�stwa zawa�u serca
u pacjent�w, u kt�rych taki stan by� podejrzewany przez lekarzy ze szpitala w Cleveland.
Wyszczeg�lniono 7 czynnik�w. Na podstawie informacji z tabeli klasyfikacyjnej dla punktu odci�cia
p =0.5 Count R2 dla modelu wyni�s� 84.49%, i z tak� dok�adno�ci� pozwala okre�li� kto przejdzie zawa�
serca a kto nie. Lepiej oszacowana zosta�a specyficzno��, kt�ra wynios�a 86.4%, niewiele gorzej
wra�liwo��, 83.15%. Zbi�r danych nie pozwoli� na prawdziwe oszacowanie wp�ywu dw�ch cz�sto
szacowanych zmiennych w tego typu badaniach: wieku badanych, gdy� 95% badanych by�o w grupie
ryzyka przej�cia zawa�u oraz p�ci, gdy� ze wzgl�du na specyfik� doboru pr�by wyniki mimo istotno�ci
statystycznej by�y sprzeczne z wiedz� naukow�. Przez odrzucenie zmiennej zwi�zanej z p�ci� model sta�
si� bardziej og�lny, trac�c przy tym 1.3% miary adjusted R2. Z badania wynika, �e b�le w klatce
piersiowej, niezwi�zane z dusznic� maj� wi�kszy wp�yw na szans� przej�cia zawa�u serca ni� b�le
zwi�zane z dusznic�, jednak wzgl�dem poziomu bazowego jest to kolejno ponad 5-krotnie i 4-krotnie
wi�ksza szansa. Wniosek ten potwierdza hipotez� badawcz� o b�lu w klatce piersiowej jako jednym
z kluczowych czynnik�w pozwalaj�cych stwierdzi� zawa� mi�nia sercowego. Talasemia z widocznymi
objawami niedoboru krwi w mi�niu sercowym tak�e jest istotnym czynnikiem, zwi�ksza szans�
na zawa� ponad 6-krotnie wzgl�dem os�b zdrowych. Nachylenie odcinka ST w g�r� w badaniu EKG
w stanie w spoczynku zwi�ksza szans� na zawa� dwukrotnie. Istotne okaza�y si� tak�e wyniki
Fluoroskopii, ka�da widoczna w badaniu �y�a zmniejsza szans� na zawa� do 42.5%. Spadek nachylenia
odcinka ST w badaniu wysi�kowym wzgl�dem badania w stanie spoczynku zmniejsza szans� o ponad
po�ow�. Istotnym ograniczeniem w stwierdzeniu wp�ywu p�ci i wieku w badaniu by�a wielko�� bazy
danych i dob�r pr�by, dlatego dalsze badania powinny opiera� si� na wi�kszych zbiorach danych, gdzie
nie wyst�puje problem selekcji pr�by. Badanie mo�na rozwin�� tak�e poprzez zwi�kszenie zestawu
zmiennych niezale�nych, kt�re mog� mie� wp�yw na choroby serca, np. Cechy fizyczne pacjent�w
jak wzrost, wska�nik BMI oraz historia leczenia. /*
